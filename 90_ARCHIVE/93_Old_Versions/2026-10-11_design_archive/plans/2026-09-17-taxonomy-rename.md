# Arcana — rename da taxonomia de cartas (prefixos literais)

> **Status (2026-09-19): Tasks 1, 2, 3 e 5 executadas. Falta a Task 4 (ação do autor: Reload Stats no Toolkit e recompilar o Story).** 80 testes passando; backup em `Backup\taxonomy_rename_20260919-190141\`; commit `0d41021` na pasta `ScriptExtender`. As Tasks 1–3 usaram 34 arquivos de texto + 2 templates `.lsf`, e não os 24 do texto original (ver "Levantamento").

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans para executar tarefa a tarefa. Os passos usam checkbox (`- [ ]`).

**Goal:** trocar os prefixos de identificador das magias para os nomes literais da taxonomia nova (`Card_Spell`, `Card_Ability`, `Created`), em todos os arquivos do jogo e no núcleo Lua, sem mudar nenhum efeito de jogo.

**Architecture:** é uma transformação de texto, não uma mudança de lógica. Três substituições literais (`Arcana_Ability_` → `Arcana_Card_Ability_`, `Arcana_Card_` → `Arcana_Card_Spell_`, `Arcana_Token_` → `Arcana_Created_`) aplicadas nos mesmos arquivos onde o nome aparece: stats, listas, Osiris e o `CardDB`/`Const` do Lua. Como o `U.Category` já resolve a categoria por prefixo dinamicamente (lendo de `Const.PREFIX`), a lógica do núcleo não muda — só o conteúdo das strings.

**Tech Stack:** Perl (regex, como nos renames anteriores desta semana), RUN_TESTS (Lua 5.4) para a suíte de 80 testes.

**Spec:** decisões desta conversa (2026-09-17) — taxonomia LoR-inspired confirmada pelo autor. Não há spec de design separado para o rename em si; a taxonomia está descrita no [deck-core-design.md](../specs/2026-09-17-deck-core-design.md) e será atualizada como parte deste plano.

## Global Constraints

- **Escopo é só mecânico.** Este plano faz 1:1 `Card_` → `Card_Spell_`, `Ability_` → `Card_Ability_`, `Token_` → `Created_` em tudo que existe hoje. Ele **não** decide o destino final de nenhuma carta específica (reações, doenças do Hemoplague, EX) — isso é do plano de custos/reações, que roda depois e pode mover cartas para categorias que ainda não existem (`Card_Passive`, `Choose`, `Invoke`).
- **`Arcana_Util_` não muda.** Confirmado pelo autor.
- **Categoria interna do Lua "Token" vira "Created".** Afeta só 3 arquivos de código-fonte (`Const.lua`, `Pool.lua`, `Sync.lua`) e as asserções de 3 testes — listado à parte porque não é coberto pela substituição automática de texto (é a palavra-chave da categoria, não a string do id da magia). As categorias "Card", "Util" e "Ability" **não** mudam de nome internamente.
- **Não escrever em arquivos de stats/LSX/Osiris sem o autor confirmar que o Toolkit e o jogo estão fechados** (Tasks 2–4).
- Backup de cada arquivo tocado em `Backup\taxonomy_rename_<data>\`, no mesmo caminho relativo a `Data\`.
- **RUN_TESTS:** `"C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe" "C:\Projetos\BG3 Modding\Arcana Class\Lua\run_tests.lua" "<ScriptExtender>\Lua"`. Ponto de partida: **80 passed**.
- Commits na pasta `ScriptExtender` com a identidade git do autor (ver `git config user.email`) (idem `GIT_COMMITTER_*`).

## Levantamento (baseline revisto em 2026-09-19)

> A primeira versão deste plano listava 24 arquivos, achados com `grep` em pastas específicas. Uma busca ampla no mod inteiro (texto e binário) encontrou mais: `Interrupt.stats`, os dois helpers Khonsu, os dois templates de clone `.lsf` e os tooltips do `english.xml`. A lista abaixo é a corrigida.

| Prefixo antigo | Ocorrências nos 34 arquivos de texto |
|---|---|
| `Arcana_Card_` (inclui `_EX`, `_DEBUG_`) | 382 |
| `Arcana_Token_` | 97 (inclui 1 tooltip do `english.xml` que ainda estava no nome anterior ao rename de Token) |
| `Arcana_Ability_` | 14 |

**36 arquivos tocados (34 de texto + 2 binários):**

| Onde | Arquivos |
|---|---|
| Stats gerados (Public) | `Spell_Shout.txt`, `Spell_Target.txt`, `Spell_Projectile.txt`, `Spell_Zone.txt`, `Spell_Teleportation.txt`, `Passive.txt`, `Status_BOOST.txt`, `Interrupt.txt` |
| Listas (Public) | `Lists/SpellLists.lsx` |
| Templates de clone (Public, **binário `.lsf`**) | `RootTemplates/4267f207-3e8b-4431-99e0-ba91eb29a836.lsf`, `RootTemplates/8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8.lsf` (guardam `Target_Arcana_Card_MaliciousWhispers` na lista de skills; passam pelo Divine, Task 2) |
| Stats do Editor | `Stats/SpellData/{Shout,Target,Projectile,Zone,Teleportation}.stats`, `Stats/Stats/Passive.stats`, `Stats/Stats/Interrupt.stats`, `Stats/StatusData/Status_BOOST.stats` |
| Listas (Editor) | `Lists/SpellLists.tbl` |
| Khonsu | `Scripts/thoth/helpers/IsArcanaCantrip.khn`, `IsDeceiverOneTargetSpell.khn` (só citam ids completos, sem lógica por prefixo) |
| Osiris (fonte) | `Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt`, `ARCANA_Spell_MimicWithdraw.txt`, `ARCANA_Spell_Mimic_Last_Casted.txt`, `ARCANA_Spell_Withdraw.txt` |
| Loca | `Localization/English/english.xml` (5 tooltips `LSTag`; só o inglês tem nomes `Arcana_`, as outras línguas ainda estão no `IND_`, dívida anterior e fora deste plano) |
| Lua | `Server/Core/Const.lua`, `Server/Cards/CardDB.lua` e os 7 `Tests/*.lua` que citam magia real ou fixture (`CardDBTest`, `FlowTest`, `KeywordsTest`, `ListTest`, `PilesTest`, `SyncTest`, `UtilTest`) |

**Não são editados à mão:** `Story/story.div` e `Story/goals.raw` (Osiris compilado; o Story Editor os regenera na Task 4), `Progressions.lsx/.tbl` (a busca ampla não achou nada neles), `Status_POLYMORPHED` (só cita `Arcana_Util_`), `Pool.lua`/`Hooks/Osiris.lua`/`Keywords/*.lua` (sem string literal de magia) e os scripts de simulação em `Design/Rework/sim/` (usam ids sintéticos).

**Caso especial no `english.xml`:** o tooltip do Final Spark Recreate ainda diz `Arcana_Card_FinalSpark_Recreate`, nome anterior ao rename de Token. O script o manda primeiro pela passada de Token (vira `Arcana_Created_FinalSpark_Recreate`), em vez de `Card_Spell_`, que não existe.

**Amostra do que muda** (a lista completa é o resultado do próprio grep, não uma tabela mantida à mão):

| Categoria | Antes | Depois |
|---|---|---|
| Carta normal | `Target_Arcana_Card_Distortion` | `Target_Arcana_Card_Spell_Distortion` |
| Carta EX | `Target_Arcana_Card_LunarAegis_EX` | `Target_Arcana_Card_Spell_LunarAegis_EX` |
| Carta DEBUG | `Shout_Arcana_Card_DEBUG_Fated` | `Shout_Arcana_Card_Spell_DEBUG_Fated` |
| Flex (ex-Ability) | `Shout_Arcana_Ability_Untethered` | `Shout_Arcana_Card_Ability_Untethered` |
| Gerada (ex-Token) | `Shout_Arcana_Token_Withdraw` | `Shout_Arcana_Created_Withdraw` |
| Constante Lua | `C.REWEAVE_TOKEN = "Shout_Arcana_Token_Reweave"` | `C.REWEAVE_TOKEN = "Shout_Arcana_Created_Reweave"` |

---

### Task 1: Script de transformação e teste a seco

**Files:**
- Create: `Design\Rework\tools\rename_taxonomy.pl` (fica no projeto, para poder ser lido e reexecutado).

- [ ] **Step 1: Escrever o script Perl** — feito, em `Design\Rework\tools\rename_taxonomy.pl`. Ele lê a lista de arquivos, aplica as 3 trocas (Ability; depois Card, sem tocar no que acabou de virar `Card_Ability_`; depois Token), faz o backup só dos arquivos que mudam (`--backup <pasta>`) e só então grava. Usa `bsd_glob` porque o `glob` comum quebra o caminho nos espaços de "Program Files (x86)".

- [ ] **Step 2: Rodar a seco** (`--dry`) e conferir os totais: `ability=14`, `card=382`, `token=97` (`pre=1`, o tooltip do Final Spark Recreate no `english.xml`), em **34 arquivos de 40** examinados.

```bash
perl "C:/Projetos/BG3 Modding/Arcana Class/Design/Rework/tools/rename_taxonomy.pl" "C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data" --dry
```

- [ ] **Step 3: Se as contagens não baterem, parar e investigar** antes de aplicar de verdade — é o sinal de que um arquivo da lista está faltando ou de que apareceu uma colisão de nome não prevista.

- [ ] **Step 4: Testar os dois templates de clone (`.lsf`) só no scratchpad**: converter com o Divine para `.lsx`, aplicar as mesmas 3 trocas, converter de volta e reconverter para conferir que o ciclo fecha (`roundtrip identical: True`; o arquivo cresce 6 bytes, o tamanho de `Spell_`). Feito em 2026-09-19: os dois só têm `Arcana_Card_MaliciousWhispers`.

---

### Task 2: Backup e aplicação

**Pré-condição:** autor confirma no chat, nesta rodada, que o jogo e o Toolkit estão fechados (a confirmação da conversa anterior não vale para uma sessão nova).

- [ ] **Step 1: Aplicar os 34 arquivos de texto com backup**. O script copia para `Backup\taxonomy_rename_<data>\` só os arquivos que vão mudar (caminho relativo a `Data\`) e depois grava.

```bash
perl "C:/Projetos/BG3 Modding/Arcana Class/Design/Rework/tools/rename_taxonomy.pl" "C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data" --backup "C:/Projetos/BG3 Modding/Arcana Class/Backup/taxonomy_rename_<data>"
```

- [ ] **Step 2: Templates de clone.** Copiar os dois `.lsf` para o mesmo backup; converter com o Divine, aplicar as 3 trocas no `.lsx`, converter de volta e copiar o resultado sobre o original em `Public\...\RootTemplates\`.

- [ ] **Step 3: Verificar que não sobrou nome antigo** no mod inteiro (texto e binário), fora de `Story/story.div` e `goals.raw` (compilados; a Task 4 regenera):

```bash
# o padrão tem de EXCLUIR os nomes novos: "Arcana_Card_" também casa dentro de "Arcana_Card_Spell_" e "Arcana_Card_Ability_"
OLD='Arcana_Card_(?!Spell_|Ability_)|Arcana_Token_|Arcana_Ability_'
grep -rlaP "$OLD" "<Public>/AspectClass_..." "<Editor>/Mods/AspectClass_..." "<Mods>/AspectClass_..."
# esperado: só Story/story.div e Story/goals.raw (Osiris compilado, regenerado na Task 4)
```

  E as contagens novas, somadas nos 34 arquivos de texto: `Arcana_Card_Spell_` = 382, `Arcana_Created_` = 97, `Arcana_Card_Ability_` = 14.

- [ ] **Step 4: XML/stats continuam válidos** nos `.lsx`/`.tbl`/`.stats`/`english.xml` (mesmo checador `XmlDocument.Load` usado nos renames anteriores) e o `SpellLists` só mudou nomes (mesma quantidade de linhas).

---

### Task 3: A categoria interna "Token" → "Created" no Lua

Isso **não** é coberto pela Task 2 (é a palavra-chave da categoria, não a string do id da magia).

**Files:**
- Modify: `LUA\Server\Core\Const.lua`, `LUA\Server\Core\Pool.lua`, `LUA\Server\Core\Sync.lua`
- Modify: `LUA\Tests\CardDBTest.lua`, `LUA\Tests\SyncTest.lua`, `LUA\Tests\UtilTest.lua`

- [ ] **Step 1: Ajustar as asserções dos 3 testes** que esperam `"Token"` como resultado de `U.Category` ou como categoria em `Sy.io.relevant`, trocando para `"Created"`.

- [ ] **Step 2: RUN_TESTS.** Esperado: falhas nesses 3 arquivos (o código ainda devolve `"Token"`).

- [ ] **Step 3: Trocar o código**

```lua
-- Const.lua
C.CATEGORY_ORDER = { "Card", "Created", "Util", "Ability" }
C.PREFIX = {
    Card = "Arcana_Card_Spell_",
    Created = "Arcana_Created_",
    Util = "Arcana_Util_",
    Ability = "Arcana_Card_Ability_",
}
```

```lua
-- Pool.lua, dentro de Po.Relevant
if cat == "Card" or cat == "Created" or cat == "Util" then out[#out + 1] = { id = id, cat = cat } end
```

```lua
-- Sync.lua, dentro de Sy.Desired
elseif s.cat == "Card" or s.cat == "Created" then
```

  (Os valores de `C.PREFIX.Card`/`.Ability` já vêm certos da Task 2, aqui só confirmar que batem com o que o script escreveu.)

- [ ] **Step 4: RUN_TESTS.** Esperado: **80 passed, 0 failed**.

- [ ] **Step 5: Commit** — `commit.sh "Rename spell prefixes to the literal taxonomy (Card_Spell, Card_Ability, Created)"`.

---

### Task 4: Toolkit e Story (ação do autor)

- [ ] **Step 1:** Abrir o Toolkit, *Reload Stats*, salvar.
- [ ] **Step 2:** Como 4 goals do Osiris foram tocados (Task 2), recompilar o Story no Story Editor e ler `Story\log.txt` — esperado **0 erros**. Os warnings de "orphan query" não são esperados aqui, porque o rename não mexeu em nome de DB/PROC, só em string literal de nome de magia.
- [ ] **Step 3:** Avisar quando terminar, para eu rodar `!arcanatest` e o roteiro da Task 12 do plano do deck com os nomes novos.

---

### Task 5: Documentação

**Files:**
- Modify: `Design\Rework\specs\2026-09-17-deck-core-design.md` (§4, categorias por prefixo), `Design\Rework\specs\2026-09-17-card-costs.md` (§2, e todas as tabelas que citam nomes de magia), `Design\Rework\plans\2026-09-17-deck-core.md` e `2026-09-17-balance-migration.md` (nomes citados nos exemplos), memória `arcana-naming-convention`.

- [ ] **Step 1:** Atualizar a tabela de prefixos do `deck-core-design.md` §4 para os nomes novos, e marcar `Arcana_Ability_` como retirado (virou `Arcana_Card_Ability_`, e agora **entra** no deck — mudança de comportamento, não só de nome).
- [ ] **Step 2:** No `card-costs.md`, trocar os nomes das tabelas de custo para o prefixo novo — é a referência que a próxima sessão de balanceamento vai ler.
- [ ] **Step 3:** Reescrever a memória `arcana-naming-convention` com a tabela de hoje (3ª versão da convenção em uma semana; vale registrar isso explicitamente, para a próxima sessão não estranhar).

---

## Fora do escopo (fica para o plano de custos/reações)

- Decidir o prefixo final das magias de reação (Gale Deflection, Instinctive Charm) — elas recebem `Card_Spell_` mecanicamente aqui, e o plano de custos decide se ficam assim ou saem do deck de vez.
- Mover as doenças do Hemoplague para `Arcana_Created_` com a keyword `Choose`.
- Criar `Arcana_Card_Passive_` (categoria nova, nada existe para renomear nela ainda).
- Qualquer coisa de `Choose`, `Invoke`, `Attuned`, `Echo`, `Thrash`/`Exile` — são mecânica nova, não rename.
