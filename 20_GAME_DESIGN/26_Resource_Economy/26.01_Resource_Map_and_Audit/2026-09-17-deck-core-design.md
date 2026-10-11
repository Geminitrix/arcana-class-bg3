# Arcana Deck — núcleo do sistema de cartas (edição SE)

> Spec de design · 2026-09-17 · status: **aguardando revisão do autor**
> Escopo: a arquitetura Lua do baralho de combate da **edição Nexus/PC (Script Extender)**.
> A edição console não usa nada deste documento — ela joga só com `ArcanaSpellSlot` (Woven Spell Slots).
> Contexto geral da reformulação: `93_Old_Versions/2026-10-11_design_archive/REWORK_CONTEXT.md`. Onde este spec diverge daquele, **este vale** (as decisões daqui são mais novas).
> **Números de balanceamento:** vêm de `specs/2026-09-17-resource-economy.md` e já estão no código (migração de 2026-09-17).

---

## 1. Objetivo

Construir o núcleo que transforma as magias da Arcana em cartas durante o combate: baralho, mão, descarte, exílio, a energia **Threads** e as primeiras palavras-chave — organizado em módulos pequenos para que as palavras-chave futuras entrem sem mexer no núcleo.

**Princípio herdado do guia do Cowork:** o script **nunca adiciona nem remove magias**. Elas continuam vindo da progressão. Em combate o script só aplica boosts de **bloqueio** (fora da mão) e **brilho** (na mão). Pior caso de bug: magia acinzentada, nunca magia sumida.

## 2. Regras decididas

| Regra | Valor |
|---|---|
| Mão | persiste entre turnos |
| Mão inicial | **4 cartas** (no 1º turno do personagem no combate) |
| Compra por turno | 1 (a partir do 2º turno do personagem) |
| Limite da mão | **10 para tudo** (compradas, Fated, Conjured) |
| Carta que passaria do limite | vai para **Unravel** (exílio) — punição, nunca para Frayed |
| Carta jogada | Frayed (descarte); Conjured → Unravel |
| Deck vazio | Frayed é embaralhado de volta na hora |
| Início de combate | deck remontado da lista, embaralhado |
| Quem entra atrasado no combate | começa no turno 1 dele (energia do turno 1 da faixa de nível, compra 4) |
| Deck mínimo | **10** nos níveis 1–8 · **15** do nível 9 em diante |
| Cópias por título | 0–3; **Unique** = 0–1 |
| Fora de combate | baralho não se aplica; custo em `ArcanaSpellSlot` (Woven Spell Slots, estilo Warlock) |

### Threads (energia de combate)

Energia disponível em cada turno do personagem, por faixa de nível (detalhes e simulação em `specs/2026-09-17-resource-economy.md`):

| Nível | Turno 1 | 2 | 3 | 4 | 5+ |
|---|---|---|---|---|---|
| 1–4 | 1 | 1 | 1 | 1 | 1 |
| 5–6 | 1 | 2 | 3 | 3 | 3 |
| 7–8 | 2 | 3 | 4 | 4 | 4 |
| 9–10 | 3 | 4 | 5 | 5 |
| 11–20 | 4 | 5 | 6 | 6 | 6 |

- **Spare Thread** (reserva): até **2** de energia não gasta passam para o turno seguinte.
- **Teto absoluto: 6**, valendo para tudo (reserva e ganhos temporários).
- **Ganho temporário:** energia a mais agora, ou no início do próximo turno.
- **Bind a Thread** (ganho permanente no combate) e os ganhos temporários somam **por cima** da rampa e passam do teto da faixa; só o teto total 6 limita.
- Refil no início do turno: `min(6, min(tetoDaFaixa, turno + inícioDaFaixa) + binds + min(2, sobra) + bônusDeInício)`.
- O nível vem do `Osi.GetLevel` (nível do personagem). Em multiclasse ainda não é o nível de Arcana.
- Custo das cartas: **X = nível da carta (1–6)**, −1 se for 1x/descanso. Truques custam 1 e devolvem 1.
- A partir do nível 9, mais energia não aumenta o poder (o gargalo é a ação). O resto do poder no fim do jogo vem das cartas `_EX` (evoluções das cartas de assinatura), de cartas que dão ação extra, de cartas mais fortes por custo e de passivas — **sem Arcane Shards**.

## 3. Recursos (`ActionResourceDefinitions.lsx`)

| Recurso | Estado | Papel |
|---|---|---|
| `ArcanaThread` | **criado** em 2026-09-17 (`d6f4f7d5-b4b2-453c-b1bb-35b67d2d1547`) | energia de combate. `ReplenishType` = `Never` (o Lua controla). Máximo 6, dado pela progressão. Nome no jogo: **Threads** |
| `ArcanaNotInHand` | já existe (`MaxValue 0`) | recurso impagável do bloqueio; tooltip "Not in Hand" |
| `ArcanaSpellSlot` | já existe (`ShortRest`, **`MaxLevel 9`**) | Woven Spell Slots, fora de combate e na edição console |
| `DeceiverDeck` / `StarchildDeck` / `UnboundDeck` / `EternalDeck` | já existem | recursos de subclasse — **fora do escopo** deste spec |

O `ArcanaThread` foi escrito direto no `.tbl` e no `.lsx`, com o texto em `english.xml` (plano, Task 11). Falta o autor fazer *Reload Stats* e salvar no Toolkit.

## 4. Categorias de magia (pelo prefixo)

> **Nomes revistos em 2026-09-19** (rename da taxonomia, `plans/2026-09-17-taxonomy-rename.md`). O prefixo é literal no id da magia. Antes: `Arcana_Card_` → agora `Arcana_Card_Spell_`; `Arcana_Token_` → `Arcana_Created_` ("token" saiu do vocabulário); `Arcana_Ability_` → `Arcana_Card_Ability_`.

| Prefixo | Em combate | Fora de combate | Estado no código |
|---|---|---|---|
| `Arcana_Card_Spell_` | entra no pool do deck. Na mão: brilho + custo em Threads. Fora da mão: bloqueio | livre (custa `ArcanaSpellSlot`) | **implementado** |
| `Arcana_Created_` | nunca entra no deck; sempre tem a keyword `Created`. Na mão: brilho. Fora da mão: bloqueio | livre | **implementado** |
| `Arcana_Util_` | **sempre bloqueada** | livre, Ritual, sem custo de slot | **implementado** |
| `Arcana_Card_Ability_` | **entra no deck** (carta flex). Custa Threads pelo nível da magia; o slot é substituído por 0 | livre; o custo em `ArcanaSpellSlot` existe só para o brilho e ela se comporta como Ritual | ⏳ o Lua ainda a trata como "nunca tocada" (comportamento antigo do `Ability_`); a lógica flex vem no plano de mecânicas |
| `Arcana_Card_Passive_` | entra no deck; ao ser jogada só liga uma passiva exclusiva de combate, removida quando o combate termina. As cartas de ativação de reação são deste tipo (o papel de "reação" fica nos dados do `CardDB`) | — | ⏳ não existe ainda |
| `Arcana_Card_Landmark_` | entra no deck; só cria um landmark no terreno | — | ⏳ futuro |
| qualquer outra (vanilla, `Deceiver_Clone_`, helpers) | ignorada | ignorada | — |

O pool é **derivado do grimório** (`SpellBook`). Uma magia `Arcana_Card_Spell_` concedida temporariamente (por `AddSpell`) não entra na lista persistente: só entram as que o `CardDB` não marca como `conjuredOnly`.

**Keywords** (independentes do prefixo): `Created`, `Create`, `Choose`, `Invoke`, `Fleeting`, `Landmark`, `Fated`+`Unique`, `Attuned` (devolve 1 Thread, limitado pelo teto da faixa e pelo teto total; os truques usam), `Echo`. Nomes de pilha no código: `Thrash` (descarte) e `Exile` (exílio); no jogo continuam **Frayed** e **Unravel**. O código atual ainda usa `frayed`/`unraveled`; a troca entra no plano de mecânicas. O destino da carta deve ser uma keyword explícita no `CardDB`, com a regra automática (Created → Exile, resto → Thrash) como padrão.

## 5. Arquitetura

```
Mods/AspectClass_…/ScriptExtender/
├── Config.json                    (já existe: RequiredVersion 32, ModTable ArcanaDeck)
└── Lua/
    ├── BootstrapServer.lua        ordem de carga
    └── Server/
        ├── Core/
        │   ├── Const.lua          números e nomes (limites, prefixos, tag, recursos)
        │   ├── Util.lua           helpers puros (prefixo, embaralhar, contar)
        │   ├── Events.lua         On(nome, fn) / Emit(nome, ctx)
        │   ├── State.lua          Get(char) / Commit(char) / ModVars
        │   ├── Pool.lua           categoria da magia, pool do grimório, lista padrão
        │   ├── Piles.lua          Draw, AddToHand, Play, ToFrayed, Unravel, ResetForCombat
        │   └── Sync.lua           bloqueio/brilho por diff (único que chama Add/RemoveBoosts)
        ├── Economy/
        │   └── Threads.lua        rampa, Spare Thread, Bind, bônus, teto, refil
        ├── Cards/
        │   └── CardDB.lua         só dados
        ├── Keywords/
        │   ├── Fated.lua
        │   ├── Fleeting.lua
        │   ├── Unique.lua
        │   ├── Conjured.lua
        │   ├── Reweave.lua
        │   └── Tangle.lua
        ├── Deck/
        │   └── List.lua           edição da lista (SetCount, validações) — usada pelo debug agora, pela UI de acampamento depois
        ├── Hooks/
        │   └── Osiris.lua         listeners → núcleo
        └── Debug/
            └── Commands.lua       comandos !arcana…
```

**Adições feitas ao detalhar o plano:**
- **`Core/Flow.lua`:** a sequência de combate e turno (seção 8), separada dos listeners para poder ser testada sem o jogo.
- **`Req`:** carregador com cache definido no `BootstrapServer.lua`. Garante que cada módulo carrega uma vez só, sem depender do cache do `Ext.Require`.
- **`Lua/Tests/`:** testes que rodam fora do jogo (Lua 5.4) e dentro dele (`!arcanatest`). A pasta é removida do pacote de release.
- **Tokens precisam estar no grimório:** os que não são dados pelo Osiris (Reweave, Tangle, container Mimic) entram pela SpellList da progressão. Ficam sempre bloqueados, exceto quando estão na mão.
- **O recurso `ArcanaThread` precisa ser concedido:** `ActionResource(ArcanaThread,6,0)` nos `Boosts` do nível 1 da progressão base (sem passiva, no mesmo padrão do `ArcanaSpellSlot`).
- **Quem tem deck:** `IsPlayer`, tag `ARCANA` e `IsSummon == 0` (exclui os clones).

### Fronteiras (regras de código)

1. **Só o `Piles` altera** `deck`, `hand`, `frayed`, `unraveled`, e toda alteração emite um evento.
2. **Palavras-chave não se chamam entre si.** Escutam eventos e usam `Piles`, `Threads` e `CardDB`.
3. **Só o `Sync` chama** `Osi.AddBoosts` / `Osi.RemoveBoosts`, sempre por diff (`applied` guarda a string exata do boost).
4. **O `CardDB` não tem lógica.**
5. **Só o `State` grava** no ModVars: muta uma cópia local e reatribui a tabela inteira no `Commit`. O `Commit` chama o `Sync` antes de salvar.
6. Cada módulo é uma tabela retornada pelo arquivo e não cria globais. A única global é o carregador `Req`, que vive no ambiente isolado do mod.

## 6. Estado por personagem

```lua
decks[charGuid] = {
  list      = { ["Target_Arcana_Card_X"] = 3 },     -- deck list persistente
  deck      = { "…", "…" },                          -- pilha de compra (topo = último)
  hand      = { {id="…", conjured=false, expiresOnTurn=nil}, … },
  frayed    = { "…" },
  unraveled = { "…" },
  applied   = { ["Target_Arcana_Card_X"] = "UnlockSpellVariant(...)" },
  combat    = nil | { id=guid, turn=0, binds=0, leftover=0, startBonus=0,
                      reweaveUsed=false, counters={} },
}
```

- A mão guarda **entradas**, não strings, porque um Conjured carrega a duração.
- `combat == nil` significa fora de combate.
- `counters` é reservado para o Awaken (objetivos) e o Echo.

## 7. Eventos

| Evento | Quando | ctx |
|---|---|---|
| `CombatStarted` | personagem entra em combate | char, state |
| `TurnStarted` | início do turno do personagem (depois do refil e da compra) | char, state, turn |
| `TurnEnded` | fim do turno do personagem | char, state, turn |
| `CardDrawn` | carta comprada | char, state, entry |
| `CardAdded` | carta entrou na mão por outro meio (Fated, Conjured) | char, state, entry |
| `CardPlayed` | carta da mão conjurada | char, state, entry, spell |
| `CardUnraveled` | carta exilada | char, state, id, reason |
| `SpellCast` | qualquer magia conjurada por um usuário do deck (mesmo fora da mão) | char, state, spell |
| `StatusApplied` | status aplicado num usuário do deck | char, state, status |
| `CombatEnded` | fim do combate | char, state |

## 8. Fluxos

**Entrar em combate:** `state.combat = {turn=0,…}` → `ResetForCombat` (deck da lista, embaralhado; mão, frayed e unraveled vazios) → `CombatStarted`.
A mão inicial **não** é comprada aqui: vem no primeiro `TurnStarted`, para que quem entra atrasado siga a mesma regra.

**Início de turno:**
1. `turn += 1`.
2. `Threads.Refill`.
3. `Piles.ExpireConjured` (sem turno): exila as Conjured cuja magia não está mais no grimório (as que o Osiris deu por `AddSpell` e já removeu).
4. Compra: 5 cartas se `turn == 1`; senão, 1.
5. Emite `TurnStarted`.
6. `Commit`.

**Fim de turno:** `Threads.RememberLeftover` → `Piles.ExpireConjured(turno)`, que exila as Conjured com `expiresOnTurn <= turno` → `TurnEnded` (o Fleeting exila as suas) → `Commit`.

**Duração (`lasts`):** `expiresOnTurn = turno em que surgiu + lasts − 1`.
- `lasts = 1`: vale só no turno em que surgiu e é exilada no fim dele.
- `lasts = 2`: vale até o fim do turno seguinte do personagem.

**Conjurar:**
- Se a magia está na mão (a primeira entrada com esse id): sai da mão; se for Conjured vai para Unravel, senão para Frayed. Emite `CardPlayed`.
- Emite `SpellCast` sempre, porque os gatilhos de Conjured e do Awaken usam esse evento.
- `Commit`.

**Fim do combate** (evento do combate inteiro): para cada personagem com `combat.id` igual ao do combate, `combat = nil`, o que remove todos os bloqueios no `Sync`. `CombatEnded`. `Commit`.

**Save/load e `reset`:** remove todos os boosts de `applied`, zera `applied` e ressincroniza (como no Passo 14 do guia).

## 9. Sync (bloqueio e brilho)

Em combate, para cada magia relevante:

```
LOCK  = UnlockSpellVariant(SpellId('<id>'),ModifyUseCosts(Add,ArcanaNotInHand,1,0),ModifyTooltipDescription())
GLOW  = UnlockSpellVariant(SpellId('<id>'),ModifyUseCosts(Replace,ArcanaSpellSlot,<custo>,-1,ArcanaThread),ModifyIconGlow(),ModifyTooltipDescription())
```

- `<custo>` vem do `CardDB` (padrão 1).
- A sintaxe do `Replace` com troca de recurso **não foi testada**. `Sync.lua` guarda os modelos em `Const.lua` para trocar por `Override`/`Add` sem mexer na lógica.
- **Container Mimic:** recebe brilho se houver qualquer sub-carta Mimic na mão; senão, bloqueio. As sub-cartas seguem a regra normal.

## 10. CardDB

```lua
["Target_Arcana_Card_Distortion"] = {
  aspect   = "Deceiver",          -- Mystra | Deceiver | Starchild | Unbound | Eternal
  cost     = 2,                   -- Threads
  keywords = { Fated=false, Unique=false, Fleeting=false },
  conjures = { { id="Shout_Arcana_Token_Withdraw", lasts=2 },
               { id="Target_Arcana_Token_MimicDistortion", lasts=1 } },
  tangle   = nil,                 -- id da carta Tangle embaralhada ao conjurar
  -- reservados (preparados, sem módulo ainda):
  awaken = nil, refine = nil, echo = nil, attuned = nil,
  invoke = nil, foresee = nil, anchor = nil, mantle = nil,
}
```

- **Gatilhos por status:** `CardDB.statusConjures["ZEPHYR_STRIKE"] = { id="Target_Arcana_Token_ZephyrStrike", lasts=1 }`.
- `lasts` = em quantos turnos do personagem a carta pode ser jogada, contando o turno em que surgiu (ver seção 8).

**Mapa inicial de Conjured** (a partir dos arquivos atuais):

| Gatilho | Gera | Dura |
|---|---|---|
| `Target_Arcana_Card_Distortion` | `Shout_Arcana_Token_Withdraw`, `Target_Arcana_Token_MimicDistortion` | 2 / 1 |
| `Target_Arcana_Token_MimicDistortion` | `Shout_Arcana_Token_MimicWithdraw` | 2 |
| `Projectile_Arcana_Card_SigilofMalice` | `Projectile_Arcana_Token_MimicSigilofMalice` | 1 |
| `Target_Arcana_Card_EtherealChains` | `Target_Arcana_Token_MimicEtherealChains` | 1 |
| `Zone_Arcana_Card_FinalSpark` | `Zone_Arcana_Token_FinalSpark_Recreate` | 2 |
| status `ZEPHYR_STRIKE` | `Target_Arcana_Token_ZephyrStrike` | 1 |

## 11. Palavras-chave

### Implementadas na v1 (testáveis com cartas `DEBUG`)

| Palavra | Comportamento |
|---|---|
| **Fated** | no `CombatStarted`, sai do deck e entra na mão antes da compra inicial (ocupa espaço no limite da mão). Toda carta Fated também é Unique (máx. 1 cópia) |
| **Fleeting** | no `TurnEnded`, se ainda estiver na mão, vai para Unravel |
| **Unique** | `Deck/List` limita a 1 cópia; a lista padrão também usa 1 |
| **Conjured** | no `SpellCast`/`StatusApplied`, adiciona os tokens do `CardDB` com `expiresOnTurn = turn + lasts − 1`. A expiração é feita pelo núcleo, no fim do turno. Ao jogar, vai para Unravel |
| **Reweave** | no `TurnStarted` com `turn == 1`, põe o token `Shout_Arcana_Token_Reweave` na mão como Conjured de `lasts = 1`, então ele é exilado no fim do turno 1. Ao conjurar: devolve as cartas da mão (exceto Fated e Conjured) ao deck, embaralha e compra o mesmo número. Grátis |
| **Tangle** | ao conjurar uma carta com `tangle`, embaralha a carta Tangle no deck. A Tangle é `Arcana_Token_` sem efeito e fica **sempre bloqueada**, mesmo na mão |

As magias `Shout_Arcana_Token_Reweave` e `Shout_Arcana_Token_Tangle_DEBUG` (e as quatro cartas `Shout_Arcana_Card_DEBUG_*`) já existem nos stats. Entram no nível 1 pelas listas "Arcana Deck Core" e "Arcana Deck DEBUG".

### Preparadas (campo no CardDB + evento já emitido; módulo escrito quando existir carta)

| Palavra | Usará |
|---|---|
| **Echo** | `CardPlayed` → Conjured com o mesmo id |
| **Awaken** | `counters` + `SpellCast` → troca Card por `_EX` até o fim do combate |
| **Refine** | `Deck/List` (acampamento): troca Card por `_EX` na lista |
| **Attuned** | `Sync` usa `cost` modificado por status/estado |
| **Invoke** | Conjured múltiplo; jogar um exila os irmãos |
| **Foresee** | escolha por conjuração entre as N cartas do topo |
| **Aspects** | `aspect` no CardDB (dado já preenchido) |
| **Anchor** | Conjured/Mantle ligado a uma zona |
| **Mantle** | Shout que aplica status até `CombatEnded` |
| **Relics (Boons)** | status lidos pelo `Threads` (bônus de início) e pelas palavras-chave |

**Edição de deck (acampamento):** `Deck/List.SetCount(state, poolIds, id, n)` com as validações. Na v1, é acessível só pelos comandos de debug; a UI de acampamento fica para uma fase futura.

## 12. Debug

| Comando | Faz |
|---|---|
| `!arcana` | dump do estado do personagem host |
| `!arcanapool` | lista o pool do grimório com categoria |
| `!arcanadraw [n]` | compra n |
| `!arcanaadd <id>` | põe carta na mão (como Conjured, `lasts` 1) |
| `!arcanaset <id> <n>` | edita a lista (fora de combate) |
| `!arcanathreads` | mostra base, reserva, bônus e o valor atual |
| `!arcanaboost lock\|glow\|clear <id>` | aplica ou remove um boost à mão, para testar a sintaxe |
| `!arcanareset` | limpa boosts e estado do personagem |
| `!arcanatest` | roda os testes automáticos dentro do jogo |

## 13. Testes

A lógica pura tem 80 testes automáticos, que rodam fora do jogo (Lua 5.4) e dentro dele (`!arcanatest`). O comportamento no jogo é verificado pelo console do SE, nesta ordem:

1. O SE carrega o mod (log `[ArcanaDeck] loaded`).
2. `!arcanapool` lista as magias com a categoria certa.
3. **Boosts manuais:** LOCK acinzenta e a tooltip explica; GLOW brilha e o custo vira Threads (testar `Replace`; se falhar, `Override`/`Add`).
4. Energia: conforme a faixa de nível do personagem de teste (§2), com reserva de até 2 e teto 6.
5. Compra: mão 4 no turno 1, +1 depois, limite 10, excedente exilado.
6. Jogar carta → Frayed; deck vazio → reembaralha.
7. Distortion gera Withdraw + Mimic Distortion; expiram no turno certo.
8. Reweave: aparece só no turno 1 e troca a mão.
9. Fated, Fleeting, Unique e Tangle com cartas DEBUG.
10. Fim do combate libera tudo; save/load no meio do combate; `reset` não duplica.
11. Clone do Deceiver **não** recebe deck (checa `IsPlayer`, a tag `ARCANA` e o sufixo de summon).

## 14. Fora do escopo

- UI de cartas e acampamento.
- Recursos por subclasse (`*Deck`).
- Migração dos custos das magias (`ArcaneEssence` → `ArcanaSpellSlot`/Threads).
- Mirrored Spell (boost de custo via Osiris — spec próprio).
- Loca.

## 15. Questões em aberto

1. ~~Níveis do `ArcanaSpellSlot`~~ **Respondido:** o recurso se chama **Woven Spell Slots** e funciona como os espaços do Warlock (com nível, recarga no descanso curto). O GLOW usa nível `-1` (qualquer nível). Tabela de slots por nível: `specs/2026-09-17-resource-economy.md` §5 (a mesma dos arquivos, com 4 slots no nível 20 em vez de 5).
2. ~~Tamanho mínimo do deck~~ **Respondido:** 15. **Revisto em 2026-09-17:** 10 nos níveis 1–8 e 15 do 9 em diante (`specs/2026-09-17-resource-economy.md`).
3. ~~Untethered~~ **Respondido:** vira `Shout_Arcana_Ability_Untethered`. Rename feito em 2026-09-17 (backup em `Backups/rename_Untethered_20260917-103054`).
4. ~~Onde fica o custo em Threads~~ **Respondido:** no `CardDB` (Lua), padrão 1. Ler de um campo dos stats (`RitualCosts`) fica como teste futuro; a leitura do custo fica isolada numa função (`CardDB.CostOf`) para facilitar a troca. **Regra de valor (2026-09-17):** X = nível da carta (1–6), −1 se for 1x/descanso; o ideal é ler o X do `ArcanaSpellSlot:1:X` do `UseCosts`.
5. **Aplicar o balanceamento de 2026-09-17 no código:** faixas de Threads por nível, reserva 2, limite 7 e deck mínimo por nível (`specs/2026-09-17-resource-economy.md` §8). Precisa de plano próprio; os testes da v1 esperam os valores antigos.
