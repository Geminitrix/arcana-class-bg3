# Arcana Deck — migração para os números de balanceamento

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans (ou subagent-driven-development) para executar tarefa a tarefa. Os passos usam checkbox (`- [ ]`).

**Goal:** trocar os valores da v1 do deck pelos aprovados no balanceamento: mão inicial 4, reserva 2, deck mínimo por nível e Threads por faixa de nível, com o custo das cartas vindo do `CardDB`.

**Architecture:** só muda `Const.lua` (valores e tabelas), `Threads.lua` (rampa por faixa), `List.lua` (mínimo por nível), `CardDB.lua` (custos) e o encanamento do nível do personagem (`Pool` → `Flow` → `Hooks`/`Debug`). O resto do núcleo não muda.

**Tech Stack:** Lua 5.4 no Script Extender; testes fora do jogo com `run_tests.lua`.

**Spec:** `Design/Rework/specs/2026-09-17-resource-economy.md` (§3 e §8) e `Design/Rework/specs/2026-09-17-deck-core-design.md` (§2).

## Global Constraints

- Pasta Lua: `C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\Data\Mods\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\ScriptExtender\Lua\` (abaixo: `LUA\`).
- **RUN_TESTS:** `"C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe" "C:\Projetos\BG3 Modding\Arcana Class\Lua\run_tests.lua" "<LUA>"`. Ponto de partida: **75 passed**.
- Commits na pasta `ScriptExtender` com a identidade git do autor (ver `git config user.email`) (idem `GIT_COMMITTER_*`); nunca alterar a config do git.
- **Não escrever em arquivos de stats/LSX sem o autor confirmar que o Toolkit está fechado** (vale para a Task 6).
- Valores alvo: mão inicial **4**, compra 1, limite da mão **10** (sem mudança), deck mínimo **10** (níveis 1–8) / **15** (9+), reserva **2**, teto **6**.
- Rampa por faixa (início / teto): 1–4 → 0/1 · 5–6 → 0/3 · 7–8 → 1/4 · 9–10 → 2/5 · 11–20 → 3/6.
- **Bind a Thread e ganhos temporários passam do teto da faixa**; o único limite é o teto total 6.
- **Custo em Threads mora no `CardDB`** (edição SE). A edição console usa o `UseCosts` (`ArcanaSpellSlot:1:X`). Os dois têm de contar a mesma coisa.

---

### Task 1: Const — novos valores e tabelas

**Files:**
- Modify: `LUA\Server\Core\Const.lua`

**Interfaces:**
- Produces: `C.OPENING_HAND = 4`, `C.THREAD_RESERVE_MAX = 2`, `C.THREAD_BANDS` (lista `{maxLevel, start, ceiling}`), `C.MIN_DECK_BANDS` (lista `{maxLevel, size}`), `C.DEFAULT_LEVEL = 1`.
- Removidos: `C.THREAD_BASE_MAX`, `C.MIN_DECK` (quem usa muda nas Tasks 2 e 4).

- [ ] **Step 1: Trocar os valores**

```lua
C.HAND_MAX = 10
C.OPENING_HAND = 4
C.DRAW_PER_TURN = 1
C.MAX_COPIES = 3
C.UNIQUE_COPIES = 1

-- Deck mínimo por nível do personagem
C.MIN_DECK_BANDS = {
    { maxLevel = 8, size = 10 },
    { maxLevel = 20, size = 15 },
}

-- Threads: rampa por faixa de nível. energia(turno) = min(ceiling, turno + start)
C.THREAD_BANDS = {
    { maxLevel = 4, start = 0, ceiling = 1 },
    { maxLevel = 6, start = 0, ceiling = 3 },
    { maxLevel = 8, start = 1, ceiling = 4 },
    { maxLevel = 10, start = 2, ceiling = 5 },
    { maxLevel = 20, start = 3, ceiling = 6 },
}
C.THREAD_RESERVE_MAX = 2
C.THREAD_CAP = 6
C.DEFAULT_LEVEL = 1
C.DEFAULT_COST = 1
```

  Apagar as linhas `C.THREAD_BASE_MAX = 5` e `C.MIN_DECK = 15`.

- [ ] **Step 2: RUN_TESTS.** Esperado: falhas em `Threads` e `List` (`THREAD_BASE_MAX`/`MIN_DECK` viraram `nil`) — é o esperado nesta etapa; as Tasks 2 e 4 corrigem.

- [ ] **Step 3: Commit** — `commit.sh "Set balance constants: opening hand 4, reserve 2, level bands"`.

---

### Task 2: Threads por faixa de nível

**Files:**
- Modify: `LUA\Server\Economy\Threads.lua`
- Modify: `LUA\Tests\ThreadsTest.lua`

**Interfaces:**
- Produces: `Th.BandFor(level) -> {maxLevel, start, ceiling}`; `Th.Compute(combat) -> total, base, reserve`, agora lendo `combat.level` (nil = nível 1).
- `combat.binds` e `combat.startBonus` somam **por cima** do teto da faixa, limitados só por `C.THREAD_CAP`.

- [ ] **Step 1: Trocar os testes de rampa**

```lua
        ["Compute follows the level band"] = function()
            T.eq(Th.Compute(combat(1).combat), 1, "level 1 turn 1")
            T.eq(Th.Compute(combat(5).combat), 1, "level 1 turn 5")
            local six = combat(1); six.combat.level = 6
            T.eq(Th.Compute(six.combat), 1, "level 6 turn 1")
            six.combat.turn = 3
            T.eq(Th.Compute(six.combat), 3, "level 6 turn 3")
            six.combat.turn = 9
            T.eq(Th.Compute(six.combat), 3, "level 6 turn 9")
            local thirteen = combat(1); thirteen.combat.level = 13
            T.eq(Th.Compute(thirteen.combat), 4, "level 13 turn 1")
            thirteen.combat.turn = 3
            T.eq(Th.Compute(thirteen.combat), 6, "level 13 turn 3")
        end,
        ["BandFor clamps outside the table"] = function()
            T.eq(Th.BandFor(nil).ceiling, 1)
            T.eq(Th.BandFor(99).ceiling, 6)
        end,
        ["Binds and bonuses go above the band ceiling"] = function()
            local st = combat(1, 0, 2)
            T.eq(Th.Compute(st.combat), 3, "level 1, 2 binds")
            st = combat(1, 0, 0, 2)
            T.eq(Th.Compute(st.combat), 3, "level 1, start bonus 2")
        end,
        ["Compute adds at most two Spare Threads"] = function()
            local st = combat(2, 3); st.combat.level = 7
            T.eq(Th.Compute(st.combat), 5, "level 7 turn 2 + reserve 2")
        end,
        ["Compute never passes 6"] = function()
            local st = combat(3, 2, 2, 2); st.combat.level = 13
            T.eq(Th.Compute(st.combat), 6)
        end,
```

  Apagar os casos antigos `"Compute ramps 1 to 5 with the turn"`, `"Compute adds at most one Spare Thread"` e `"Bind a Thread raises the base up to 5"`. Manter os de `Refill`, `RememberLeftover` e `Gain`.

- [ ] **Step 2: RUN_TESTS.** Esperado: os casos novos falham (`BandFor` não existe).

- [ ] **Step 3: Implementar**

```lua
function Th.BandFor(level)
    level = level or C.DEFAULT_LEVEL
    for _, band in ipairs(C.THREAD_BANDS) do
        if level <= band.maxLevel then return band end
    end
    return C.THREAD_BANDS[#C.THREAD_BANDS]
end

function Th.Compute(combat)
    local band = Th.BandFor(combat.level)
    -- binds and bonuses are added after the band ceiling, so they can go past it
    local base = math.min(band.ceiling, combat.turn + band.start) + (combat.binds or 0)
    local reserve = math.min(C.THREAD_RESERVE_MAX, combat.leftover or 0)
    local total = math.min(C.THREAD_CAP, base + reserve + (combat.startBonus or 0))
    return total, base, reserve
end
```

- [ ] **Step 4: RUN_TESTS.** Esperado: a suíte `Threads` passa; `List`, `Flow` e `Keywords` ainda falham.

- [ ] **Step 5: Commit** — `"Ramp Threads by level band"`.

---

### Task 3: Nível do personagem chegando ao Threads

**Files:**
- Modify: `LUA\Server\Core\Pool.lua`, `LUA\Server\Core\Flow.lua`, `LUA\Server\Hooks\Osiris.lua`
- Modify: `LUA\Tests\FlowTest.lua`

**Interfaces:**
- Produces: `Po.LevelOf(char) -> int`; `F.BeginCombat(char, st, combatId, level)`; `F.StartTurn(char, st, hasSpell, level)` (o `level` atualiza `st.combat.level` quando vem preenchido).

- [ ] **Step 1: Ajustar o FlowTest** — mão inicial 4 e nível na rampa

```lua
local function begin(level)
    local st = S.New()
    st.list = U.DeepCopy(LIST)
    F.BeginCombat("c", st, "combat-1", level)
    return st
end
```

  E trocar os casos de turno:

```lua
        ["Turn 1 draws 4 and gives the band's first value"] = function()
            local st = begin(7)
            F.StartTurn("c", st, yes)
            T.eq(st.combat.level, 7)
            T.eq(drawnCount(st), 4)
            T.eq(value, 2, "level 7 turn 1")
        end,
        ["Later turns draw 1 and carry two Spare Threads"] = function()
            local st = begin(7)
            F.StartTurn("c", st, yes)
            value = 2
            F.EndTurn("c", st)
            F.StartTurn("c", st, yes)
            T.eq(drawnCount(st), 5)
            T.eq(value, 5, "level 7 turn 2 + reserve 2")
        end,
        ["StartTurn refreshes the level"] = function()
            local st = begin(1)
            F.StartTurn("c", st, yes, 9)
            T.eq(st.combat.level, 9)
            T.eq(value, 3)
        end,
```

  No caso `"Cast moves a hand card to Frayed"`, a mão inicial passa a ser 4, então o topo do deck muda: com o embaralhamento desligado o deck é `A,A,A,B,B,B,…,E,E,E` e a compra sai do fim, ou seja, a mão do turno 1 é `E,E,E,D`. A carta usada no teste continua sendo `Shout_Arcana_Card_E`; só o `drawnCount` esperado cai de 4 para 3.

- [ ] **Step 2: RUN_TESTS.** Esperado: falha (`BeginCombat` ignora o nível).

- [ ] **Step 3: Implementar**

  Em `Pool.lua`:

```lua
-- Osiris only exposes the character level; in multiclass this is not the Arcana level
function Po.LevelOf(char)
    local level = Osi.GetLevel(char)
    if type(level) == "number" and level > 0 then return level end
    return C.DEFAULT_LEVEL
end
```

  Em `Flow.lua`:

```lua
function F.BeginCombat(char, st, combatId, level)
    st.combat = { id = combatId, turn = 0, binds = 0, leftover = 0, startBonus = 0,
                  level = level or C.DEFAULT_LEVEL, counters = {} }
    P.ResetForCombat(char, st)
    E.Emit("CombatStarted", { char = char, state = st })
end

function F.StartTurn(char, st, hasSpell, level)
    local c = st.combat
    if level then c.level = level end
    c.turn = c.turn + 1
    ...
```

  Em `Hooks/Osiris.lua`, passar o nível nos dois pontos:

```lua
        withState(char, function(c, st) F.BeginCombat(c, st, U.Guid(combatId), Po.LevelOf(c)) end)
...
            if not st.combat then F.BeginCombat(c, st, nil, Po.LevelOf(c)) end
            F.StartTurn(c, st, hasSpellFor(c), Po.LevelOf(c))
```

- [ ] **Step 4: RUN_TESTS.** Esperado: `Flow` passa; `List` e `Keywords` ainda falham.

- [ ] **Step 5: Commit** — `"Feed the character level into the Threads ramp"`.

---

### Task 4: Deck mínimo por nível

**Files:**
- Modify: `LUA\Server\Deck\List.lua`, `LUA\Server\Debug\Commands.lua`
- Modify: `LUA\Tests\ListTest.lua`

**Interfaces:**
- Produces: `L.MinDeck(level) -> int`; `L.SetCount(st, poolIds, id, n, level)` (o `level` é opcional; sem ele, nível 1).

- [ ] **Step 1: Ajustar o ListTest**

```lua
local function fullDeck()
    local st = S.New()
    st.list = L.Default({ table.unpack(POOL, 1, 4) })   -- 4 títulos x 3 = 12
    st.list[POOL[5]] = 0
    st.list[POOL[6]] = 0
    return st
end
```

  E os casos de mínimo:

```lua
        ["MinDeck is 10 up to level 8 and 15 from 9"] = function()
            T.eq(L.MinDeck(1), 10)
            T.eq(L.MinDeck(8), 10)
            T.eq(L.MinDeck(9), 15)
            T.eq(L.MinDeck(nil), 10)
            T.eq(L.MinDeck(99), 15)
        end,
        ["SetCount refuses to go below the minimum deck"] = function()
            local st = fullDeck()                        -- 12 cards
            T.eq((L.SetCount(st, POOL, POOL[1], 0, 1)), false, "would leave 9 at level 1")
            T.eq(st.list[POOL[1]], 3)
            T.eq((L.SetCount(st, POOL, POOL[1], 1, 1)), true, "10 is allowed at level 1")
        end,
        ["The minimum is stricter from level 9"] = function()
            local st = fullDeck()                        -- 12 cards
            T.eq((L.SetCount(st, POOL, POOL[5], 3, 9)), true, "15 at level 9")
            T.eq((L.SetCount(st, POOL, POOL[5], 2, 9)), false, "14 is refused at level 9")
        end,
```

  O caso `"SetCount clamps to the card maximum"` passa a usar `POOL[5]` e `level` 1.

- [ ] **Step 2: RUN_TESTS.** Esperado: falha (`MinDeck` não existe).

- [ ] **Step 3: Implementar**

```lua
function L.MinDeck(level)
    level = level or C.DEFAULT_LEVEL
    for _, band in ipairs(C.MIN_DECK_BANDS) do
        if level <= band.maxLevel then return band.size end
    end
    return C.MIN_DECK_BANDS[#C.MIN_DECK_BANDS].size
end

function L.SetCount(st, poolIds, id, n, level)
    if st.combat then return false, "in combat" end
    if not U.IndexOf(poolIds, id) then return false, "not in pool" end
    n = math.max(0, math.min(L.MaxCopies(id), math.floor(n)))
    local minimum = L.MinDeck(level)
    local size = L.Size(st.list) - (st.list[id] or 0) + n
    if size < minimum then return false, "deck would drop below " .. minimum end
    st.list[id] = n
    return true, n
end
```

  Em `Commands.lua`, o `!arcanaset` passa o nível:

```lua
        local ok, result = L.SetCount(st, Po.Cards(char), id, tonumber(n) or 0, Po.LevelOf(char))
```

- [ ] **Step 4: RUN_TESTS.** Esperado: `List` passa; só `Keywords` ainda falha.

- [ ] **Step 5: Commit** — `"Scale the minimum deck with the character level"`.

---

### Task 5: Mão inicial 4 nas palavras-chave e custos no CardDB

**Files:**
- Modify: `LUA\Tests\KeywordsTest.lua`, `LUA\Server\Cards\CardDB.lua`, `LUA\Tests\CardDBTest.lua`

**Interfaces:**
- Produces: `cost` preenchido nas cartas reais do `CardDB` (X = nível da carta nos stats, −1 se for 1x/descanso, mínimo 1).

Níveis lidos dos stats: Distortion 3 · Sigil of Malice 1 · Ethereal Chains 2 · Final Spark 6 (com `OncePerShortRest`, então 5) · container Mimic 6. Os tokens herdam o nível da carta de origem; Withdraw, Mimic Withdraw, Final Spark Recreate e Zephyr Strike são continuações e ficam em 1.

- [ ] **Step 1: Ajustar os testes**

  No `KeywordsTest`, os dois casos que contam a mão:

```lua
            T.eq(#st.hand, 6, "fated + 4 drawn + reweave")
...
        ["Reweave swaps the whole hand"] = function()
            local st = begin()
            F.StartTurn("c", st, yes)
            local deckBefore = #st.deck
            F.Cast("c", st, C.REWEAVE_TOKEN)
            T.eq(count(st.hand, C.REWEAVE_TOKEN), 0)
            T.eq(#st.hand, 4)
            T.eq(#st.deck, deckBefore)
        end,
```

  No `CardDBTest`, trocar o caso de custo:

```lua
        ["Cards cost their level, tokens and follow-ups cost 1"] = function()
            T.eq(D.CostOf("Unknown_Spell"), 1)
            T.eq(D.CostOf("Projectile_Arcana_Card_SigilofMalice"), 1)
            T.eq(D.CostOf("Target_Arcana_Card_EtherealChains"), 2)
            T.eq(D.CostOf("Target_Arcana_Card_Distortion"), 3)
            T.eq(D.CostOf("Zone_Arcana_Card_FinalSpark"), 5, "level 6, once per short rest")
            T.eq(D.CostOf("Shout_Arcana_Token_Withdraw"), 1)
        end,
```

- [ ] **Step 2: RUN_TESTS.** Esperado: falhas nos casos novos.

- [ ] **Step 3: Implementar** — acrescentar `cost` às entradas do `CardDB` e criar as que faltam:

```lua
    ["Target_Arcana_Card_Distortion"] = {
        aspect = "Deceiver",
        cost = 3,
        conjures = { ... },
    },
    ["Target_Arcana_Token_MimicDistortion"] = { aspect = "Deceiver", cost = 3, conjures = { ... } },
    ["Projectile_Arcana_Card_SigilofMalice"] = { aspect = "Deceiver", cost = 1, conjures = { ... } },
    ["Target_Arcana_Card_EtherealChains"] = { aspect = "Deceiver", cost = 2, conjures = { ... } },
    ["Zone_Arcana_Card_FinalSpark"] = { aspect = "Starchild", cost = 5, conjures = { ... } },

    ["Target_Arcana_Token_Mimic"] = { aspect = "Deceiver", cost = 1 },
    ["Projectile_Arcana_Token_MimicSigilofMalice"] = { aspect = "Deceiver", cost = 1 },
    ["Target_Arcana_Token_MimicEtherealChains"] = { aspect = "Deceiver", cost = 2 },
    ["Shout_Arcana_Token_Withdraw"] = { aspect = "Deceiver", cost = 1 },
    ["Shout_Arcana_Token_MimicWithdraw"] = { aspect = "Deceiver", cost = 1 },
    ["Zone_Arcana_Token_FinalSpark_Recreate"] = { aspect = "Starchild", cost = 1 },
    ["Target_Arcana_Token_ZephyrStrike"] = { aspect = "Unbound", cost = 1 },
```

  Comentário no topo do arquivo, explicando a regra e a paridade com o console:

```lua
-- cost = Threads spent in combat (SE edition). Rule: X = card level, -1 if once per rest, minimum 1.
-- The console edition pays the same card with ArcanaSpellSlot:1:X from the spell's UseCosts;
-- keep both in step when a card's level changes.
```

- [ ] **Step 4: RUN_TESTS.** Esperado: **75 passed, 0 failed** (a suíte volta inteira).

- [ ] **Step 5: Rodar a simulação de ponta a ponta** (o script descartável da sessão anterior, em `scratchpad\sim_game.lua`, se ainda existir) ou, na falta dele, só confirmar o RUN_TESTS.

- [ ] **Step 6: Commit** — `"Use card levels as Thread costs; opening hand 4"`.

---

### Task 6: Nível 20 dos Woven Spell Slots (arquivos do jogo)

**Files:**
- Modify: `Public\AspectClass_…\Progressions\Progressions.lsx`
- Modify: `Editor\Mods\AspectClass_…\Progressions\Progressions.tbl`

- [ ] **Step 1: Confirmar com o autor que o Toolkit e o jogo estão fechados.** Sem confirmação, parar e entregar os blocos prontos no chat.

- [ ] **Step 2: Localizar a linha do nível 20 da tabela base** (`TableUUID` `99f583de-f62e-43a7-b8f7-4aa29812709f`, `Level` 20) e conferir se ela tem `ActionResource(ArcanaSpellSlot,1,9)` nos `Boosts`.

```bash
grep -n "ArcanaSpellSlot,1,9" "C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data/Public/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Progressions/Progressions.lsx"
```

- [ ] **Step 3: Backup** dos dois arquivos em `Backup\slots_lvl20_<data>\`, mantendo o caminho relativo a `Data\`.

- [ ] **Step 4: Remover esse `ActionResource(ArcanaSpellSlot,1,9)`** do nível 20 (só dele; os outros níveis não mudam), nos dois arquivos, preservando CRLF/LF e sem tocar em mais nada da linha.

- [ ] **Step 5: Conferir** que o XML continua válido e que o `grep` do passo 2 não acha mais nada no nível 20. Somar a tabela de slots e confirmar **4** no nível 20.

- [ ] **Step 6:** Avisar o autor que ele precisa abrir o Toolkit, fazer *Reload Stats* e salvar.

---

### Task 7: Fechar a documentação

**Files:**
- Modify: `Design\Rework\specs\2026-09-17-resource-economy.md` (§8), `Design\Rework\specs\2026-09-17-deck-core-design.md` (§2 e §13), `Design\Rework\plans\2026-09-17-deck-core.md`

- [ ] **Step 1:** Na §8 do `resource-economy.md`, marcar como aplicado o que este plano executou e deixar na lista só o que sobrou: custos das cartas nos stats (`ArcaneEssence` → `ArcanaSpellSlot:1:X`), redesenho de Arcane Recovery/Overflow/Mastery e custo novo das `_EX`.

- [ ] **Step 2:** No `deck-core-design.md`, apagar a coluna "v1 no código" da §2 (os valores passam a ser os do código) e atualizar a §13: mão inicial 4, energia conforme a faixa de nível do personagem de teste.

- [ ] **Step 3:** No plano do deck (`2026-09-17-deck-core.md`), trocar o aviso do topo por "valores migrados em <data>, ver `plans/2026-09-17-balance-migration.md`".

- [ ] **Step 4: Commit** da documentação (o projeto não é repositório git; é só salvar) e avisar o autor.

---

## Fora do escopo

- **Custos nos stats:** trocar `ArcaneEssence:N` por `ArcanaSpellSlot:1:X` em todas as cartas. Mexe em dezenas de magias e precisa da análise de custo própria — plano separado.
- **Recursos antigos:** Arcane Recovery, Overflow e Mastery ainda usam `ArcaneEssence`.
- **Cartas `_EX`:** hoje custam Arcane Shards, que saíram do sistema.
- **Nível de classe em multiclasse:** o Osiris só dá `GetLevel` (nível do personagem). Se o SE expuser o nível de Arcana (`Ext.Entity`), trocar depois em `Po.LevelOf`.
