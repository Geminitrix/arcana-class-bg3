# Arcana — custos, reações e Hemoplague (plano 4)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans para executar tarefa a tarefa. Os passos usam checkbox (`- [ ]`).

**Goal:** dar a cada carta o custo definitivo nos dois recursos (`ArcanaSpellSlot:1:N` nos stats, `cost = X` em Threads no `CardDB`), transformar as reações no modelo de recurso exclusivo + carta de ativação, e transformar o Hemoplague numa carta `Choose`.

**Architecture:** três camadas independentes. (1) **Dados**: `UseCosts` e `Level` das magias — vale para as duas edições e não depende do SE. (2) **Conversão para Threads**: um punhado de boosts genéricos com condição Khonsu, num status técnico que só a edição SE aplica (decisão D1) — o custo por carta deixa de ser problema do Lua. (3) **Lua**: só o que depende do estado da mão — bloqueio, brilho, categoria `Reaction`/`Card_Passive` e o ciclo do recurso de reação. A camada 1 pode ser feita sem o jogo aberto; as camadas 2 e 3 dependem da verificação no jogo (Task 1).

**Tech Stack:** stats `.txt`/`.stats`, `.lsx`/`.tbl`, Lua 5.4 no SE, RUN_TESTS (80 testes hoje).

**Specs:** [`card-costs.md`](../specs/2026-09-17-card-costs.md) (níveis e custos, tabelas por subclasse), [`resource-economy.md`](../specs/2026-09-17-resource-economy.md) (economia geral), [`deck-core-design.md`](../specs/2026-09-17-deck-core-design.md) (arquitetura e taxonomia).

## Global Constraints

- **Nomes já renomeados em 2026-09-19.** O `card-costs.md` foi escrito antes e cita nomes antigos (`Arcana_Card_X`); use sempre os atuais (`Arcana_Card_Spell_X`, `Arcana_Created_X`, `Arcana_Card_Ability_X`).
- **Não escrever em stats/LSX/Osiris sem o autor confirmar, nesta rodada, que o jogo e o Toolkit estão fechados.**
- Backup de cada arquivo tocado em `Backup\costs_reactions_<data>\`, caminho relativo a `Data\`.
- **RUN_TESTS:** `"C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe" "C:\Projetos\BG3 Modding\Arcana Class\Lua\run_tests.lua" "<ScriptExtender>\Lua"`. Ponto de partida: **80 passed**.
- Commits na pasta `ScriptExtender` com a identidade git do autor (ver `git config user.email`) (idem `GIT_COMMITTER_*`).
- **Regra dos custos (fechada em Q1):** `N = min(6, ⌈nível de desbloqueio ÷ 2⌉)`, ajustado para baixo quando o efeito é fraco, e **`X = N = o `Level` da magia`** — um número só, sem exceções. É o que torna possível o boost genérico por nível da Task 4. Carta que precisar ser mais barata em combate baixa o nível, não ganha regra própria.
- **Arcane Shards saem do sistema.** Toda carta `_EX` que hoje custa `ArcaneShards` passa a custar slot/Threads.

---

## Decisões tomadas (2026-09-19)

**D1 — a conversão de custo vira um boost genérico com condição Khonsu, não um boost por magia.**
O mod já usa esse padrão: `Passive.txt:183` tem
`UnlockSpellVariant(IsArcanaSpell(context.Source), ModifyUseCosts(Replace,ArcaneEssence,0,0,ArcaneEssence), …)`,
e `Status_BOOST.txt:624` faz o mesmo para os slots vanilla via `UseSpellSlot()`. Consequências:

- **`IsArcanaSpell.khn` passa a testar `HasUseCosts('ArcanaSpellSlot', true, entity)`** (hoje testa `ArcaneEssence`). Com isso, "carta de combate" = "tem custo de slot", e o resto segue de graça.
- **Truques deixam de precisar de `Attuned`.** Sem custo de slot, o truque não casa com `IsArcanaSpell()`, não é convertido e sai de graça em combate. Sem manobra de devolver slot, sem exploit, sem keyword. `cost = 0` no `CardDB`.
- **Nada mais precisa de custo de slot só para poder brilhar.** `Created`, ativações de reação e o Recast Final Spark ficam grátis em combate por construção.
- **O Lua para de gerar boost de custo.** Sobra para ele só o boost por magia do **bloqueio** (carta fora da mão), que é o único que depende do estado da mão. O `ModifyIconGlow()` também fica no boost por magia — se entrasse no genérico, *toda* magia Arcana brilharia.
- **Onde mora o boost genérico:** num `Status_BOOST` técnico que o Lua aplica ao entrar em combate (mesmo padrão do vanilla em `Status_BOOST.txt:624`), **não** numa passiva permanente. Assim o console nunca recebe o status, nunca vê Threads, e a edição sem SE continua só com slots.
- **`Replace` tem quantidade literal** (`ModifyUseCosts(Replace, Recurso, Quantidade, Nível, NovoRecurso)` — o exemplo acima usa `0,0`), então um boost genérico não sabe o X da carta. Solução: **um boost por nível**, já que `N = nível da magia` em todas as linhas da Task 2 → 6 boosts (`ArcanaSpellSlot` nível 1..6 → `ArcanaThread` 1..6). Ver Q1 para as cartas com desconto.

**D2 — as reações ganham prefixo de categoria: `Arcana_Reaction_`.**
`<Tipo>_Arcana_Reaction_GaleDeflection`, `Interrupt_Arcana_Reaction_GaleDeflection`, `Target_Arcana_Reaction_InstinctiveCharm`. Entra no `Const.PREFIX` como categoria `Reaction` e **fica fora** das listas de `Po.Relevant`/`Sy.Desired` (o deck nunca a toca). A **carta de ativação** continua `Arcana_Card_Passive_` — ela é carta de verdade.

**D3 — a carta principal do Hemoplague só gera a doença** (N4/X4). O "envenena o alvo **e** abre a escolha" veio do `card-costs.md` §8 linha 200 (sessão de balanceamento), não de uma decisão sua. **São 6 doenças**, não 4: Blinding Sickness, Filth Fever, Flesh Rot, Mindfire, Seizure, Slimy Doom. Ver Q2 — elas já são um `SpellContainer` nativo.

**D4 — a carta de ativação de reação não gasta ação**, só Threads.

**Q1 — sem desconto: `X = N = nível da carta`, sempre.** O desconto de −1 nas cartas 1x/descanso exigiria uma segunda leva de 6 boosts e um `IsArcanaDiscounted.khn` com as magias listadas à mão — e toda carta nova 1x/descanso teria de ser lembrada nessa lista, que é exatamente o tipo de coisa que apodrece calada. Com a regra simples são 6 boosts e nenhum helper novo.
**Consequência de balanceamento:** 11 cartas ficam 1 Thread mais caras do que o `card-costs.md` pede (Hypnotic Gaze, Mental Prison, Marionette, Hostile Takeover, Solar Purge, Starbreath, Wish, Final Spark, Solar Flare, Stellar Grace, Death Ward). **A válvula de escape continua existindo e não custa nada em código:** como `N` é o `Level` da magia e o boost é por nível, baixar o nível de uma carta específica já baixa os dois custos de uma vez. Se a sessão de balanceamento quiser o desconto de volta, é só baixar o `N` dessas cartas.

**Q2 — manter o `SpellContainer` nativo do Hemoplague.** As 6 doenças viram `Arcana_Created_` e continuam sendo os filhos do container; o jogo segue mostrando as 6 opções sozinho, nas duas edições, e não é preciso mecanismo `Choose` no Lua. O mesmo padrão já vale para o Mimic, que também é container.

---

## Execução — 2026-09-20

**Tasks 2 a 9 executadas.** Backup em `Backup\costs_reactions_20260920\` (55 arquivos). 82 campos de custo/nível trocados (simétricos nos dois lados), 17 arquivos renomeados, 3 cartas novas, 2 recursos novos, 1 status novo. **89 testes offline passam** (eram 80). Commit do Lua: `2737de4`. **Falta a Task 1**, que é no jogo.

**Divergências e achados durante a execução** — cada um mudou alguma coisa em relação ao plano escrito:

1. **`SpellLevelEqualTo(n)` não serve.** A definição vanilla é `context.HitDescription.SpellLevel == value`, contexto de acerto. A condição certa é **`IsSpellLevel(n)`**, built-in do motor, que é o que o próprio vanilla usa em boost de variante (`(IsSpellLevel(1) | IsSpellLevel(2) | IsSpellLevel(3)) & HasUseCosts('SpellSlot') & HasSpellFlag(SpellFlags.Spell)`). É essa a forma que ficou no `ARCANA_WEAVING`.
2. **O `GaleDeflectMissiles_Charge` não era o portão da reação.** Ele é o token que o *desvio* concede para permitir o **ricochete** (`_Return`) — o spec conflacionou as duas coisas. Zerá-lo em combate não desligaria a reação. Resolvido assim: o token virou **`ArcanaGaleDeflectReturn`** (mesma função de antes) e foi criado um **portão novo, `ArcanaReactGaleDeflection`**, exigido no `Conditions` do interrupt e **nunca consumido**. Como não é consumido, no console e fora de combate o recurso fica sempre em 1 e a reação continua funcionando exatamente como hoje — que é o que o spec pede. O mesmo vale para `ArcanaReactInstinctiveCharm`. O Hollow Image é diferente: o `ArcanaReactHollowImage` (ex-`HollowImage_Charge`) **é** cobrado, com recarga por turno, então já era o portão.
3. **As reações EX perderam o custo em Shards por completo** (`ArcaneShards:1` no Gale EX, `:2` no Hollow Image EX, e as condições `HasActionResource('ArcaneShards',…)`). Ficaram idênticas às base em custo, só mais fortes no efeito. Era a pendência §11.3 do spec; **é decisão de balanceamento em aberto**.
4. **O Evasive Flow EX estava sendo concedido duas vezes:** a lista "Unbound Level 13" aparecia nos `Selectors` do nível **4** *e* do 13. Removido o do nível 4.
5. **Arcane Recovery:** `RestoreResource` não aceita "o slot do nível atual", então virou uma cadeia de 9 `IF(CharacterLevelGreaterThan(x) and not CharacterLevelGreaterThan(y))`, espelhando a tabela de slots da progressão. Usa **nível de personagem, não nível de classe** — em multiclasse fica errado, que é a mesma pendência já conhecida do mod. Cooldown passou para `OncePerRest` e a descrição em inglês foi reescrita (versão 8 → 9).
6. **Recast Final Spark ganhou `ArcanaSpellSlot:1:2`.** A assimetria que o spec queria (grátis no `UseCosts`, 2 Threads no `CardDB`) **deixou de ser expressável** com a D1: o custo em Threads *é* o custo de slot. Como carta gerada só existe em combate, dar slot a ela não muda nada fora de combate. Mesma coisa para o `MimicWithdraw`, que estava sem custo nenhum.
7. **Os custos de ação das cartas geradas ficaram como estavam.** A tabela `Created` do plano dizia "sem custo de ação", o que contradiz a regra geral da Task 2 ("manter o custo de ação como está hoje"). Valeu a regra geral — tirar a ação bônus do Withdraw e dos Mimics seria um buff que ninguém pediu.
8. **As utilitárias não ganharam `IsRitual`.** Ficaram sem custo de recurso, que já era o efeito pretendido; marcar Ritual mudaria mais coisa (conjuração fora de combate, UI) sem necessidade.
9. **`IsArcanaCantrip.khn` tinha um termo morto há tempos:** `SpellId('Target_Friends')`, enquanto a magia do mod é `Target_Arcana_Util_Friends` (defeito já anotado no `Docs/KHONSU.md`). Corrigido, e o Howl of the Dead entrou na lista.
10. **Dois tooltips mortos** em `english.xml` ainda apontavam para `Projectile_IND_GaleDeflectMissiles` (sobra do rename de 2026-09-16). Corrigidos.

**Correção de 2026-09-20, depois do primeiro teste no jogo** (backup `Backup\slotsgroup_20260920\`):

11. **`ArcanaSpellSlot:1:N` exigia o slot do nível exato.** Com slots de nível 2, uma carta de nível 1
    não saía — o oposto da regra do Warlock, que é o modelo declarado. A forma certa é
    **`SpellSlotsGroup:1:1:N`**, de quatro partes, que é o que toda magia vanilla usa: o *grupo* é que
    carrega a regra "slot de nível igual ou maior". E o mod **já tinha metade disso pronto**: o
    `ActionResourceGroupDefinitions.lsx` dele sobrescreve o `SpellSlotsGroup` vanilla acrescentando o
    UUID do `ArcanaSpellSlot`. Os 146 custos foram convertidos, nos dois lados.
12. **Grupo próprio, não a sobrescrita do vanilla** (corrigido pelo autor no mesmo dia). A primeira
    tentativa usou o `SpellSlotsGroup` vanilla, que o mod sobrescrevia acrescentando o `ArcanaSpellSlot`
    — mas isso é errado por dois motivos: mexe num registro do jogo base, e o grupo passa a ser
    compartilhado com todo conjurador, de modo que `HasUseCosts('SpellSlotsGroup')` não distingue uma
    magia da Arcana da de um Clérigo multiclasse. Cheguei a resolver isso com uma lista de 74 `SpellId`
    no `IsArcanaSpell.khn` — o autor recusou, com razão: toda carta nova teria de ser cadastrada à mão.

    **A solução é um grupo exclusivo:** `ArcanaSpellSlotsGroup`
    (`9b0b7641-1508-40f1-a4e3-fc8b54f275d9`), contendo **só** o `ArcanaSpellSlot`. A sobrescrita do
    `SpellSlotsGroup` vanilla foi removida. Com isso:
    - as cartas custam `ArcanaSpellSlotsGroup:1:1:N` e ganham a regra "slot de nível igual ou maior";
    - o `IsArcanaSpell.khn` volta a ser uma linha — `HasUseCosts('ArcanaSpellSlotsGroup', …)` — e
      **nenhuma carta nova precisa ser cadastrada em lugar nenhum**;
    - nada de outra classe casa com o helper, nem em multiclasse;
    - o `ARCANA_WEAVING` volta a condicionar em `IsArcanaSpell(context.Source) and IsSpellLevel(n)`.

    **Risco a verificar no jogo:** não sei se a regra de "slot de nível igual ou maior" vale para
    qualquer `ActionResourceGroup` ou se o motor a amarra ao `SpellSlotsGroup` vanilla. É o que o
    passo 2.1 do guia de teste tem de responder. Se não valer, o plano B é voltar a incluir o
    `ArcanaSpellSlot` no grupo vanilla e achar outro discriminador — nunca a lista de SpellId.

13. **O Carisma era alarme falso meu.** Afirmei que o `IsArcanaSpell` alimentava "o bônus de dano por
    Carisma, a identidade da classe". Errado: a classe conjura com **Inteligência**
    (`SpellCastingAbility = 4`) e o `CharismaModifier` aparece em **uma única** passiva,
    `Arcana_Passive_TheEmpress_EX_Tech_II`. Continua estranho — Carisma numa classe de Inteligência,
    provavelmente sobra de um desenho antigo — mas é questão de design do autor, não deste plano.

**Pontos de balanceamento para olhar** (não são bugs, são escolhas que o plano autorizou e que valem revisão):
- **Howl of the Dead virou truque de verdade:** nível 0, sem custo de recurso, ação bônus, 3m de raio, salvaguarda de Sabedoria CD 14 para atordoar. Como truque ele é ilimitado e, pela D1, de graça em combate. É a carta mais forte por custo do mod agora.
- As 11 cartas que perderam o desconto de 1 Thread (ver Q1).
- As reações EX sem custo extra (item 3).

**O que continua pendente:**
- **Task 1** (no jogo) — e dentro dela, três coisas que só o jogo responde: se `ModifyUseCosts(Replace, ArcanaSpellSlot, n, -1, ArcanaThread)` aceita `-1` como nível (se não, tentar `n` e depois `0`); se `IsSpellLevel(n)` resolve dentro de `UnlockSpellVariant`; e se a cadeia de `CharacterLevelGreaterThan` do Arcane Recovery devolve o slot certo.
- Task 9 Step 2 (simulação de ponta a ponta no scratchpad) — não feita; os 89 testes cobrem a lógica nova.
- Loca das outras 15 línguas.

---

### Task 1: Verificação no jogo (bloqueante para as Tasks 5–8)

Tudo que envolve Threads depende de uma sintaxe que **nunca rodou no jogo**. Fazer isto antes evita reescrever custo de 50 cartas duas vezes.

- [ ] **Step 1:** Rodar o roteiro da Task 12 do `plans/2026-09-17-deck-core.md` (precisa de um Arcana **novo**, porque personagem antigo não recebe as listas criadas em 2026-09-17).
- [ ] **Step 2:** Confirmar, em especial: o `Replace` troca mesmo um custo de slot **de nível n** por Threads, na tooltip e no gasto (é o que a Task 4 inteira assume); o bloqueio por magia continua funcionando junto com o genérico; `Ext.Require` devolve o módulo; o `CastedSpell` vem com ou sem sufixo.
- [ ] **Step 3:** Anotar os resultados na §15 do `deck-core-design.md`. **Se o `Replace` por nível não pegar**, o plano B é um boost por magia gerado pelo Lua, como estava antes — mas aí o custo volta a ser problema do Lua e a Task 4 muda inteira.

---

### Task 2: Custos e níveis das cartas nos stats

**Files:** `Public\…\Stats\Generated\Data\Spell_{Shout,Target,Projectile,Zone,Teleportation}.txt` e os `.stats` correspondentes em `Editor\Mods\…\Stats\SpellData\`.

Regra da troca: manter o custo de ação como está hoje e trocar só a parte do recurso — `ArcaneEssence:n` / `ArcaneShards:n` → `ArcanaSpellSlot:1:N`.

Depois da Q1 há **um número só** por carta: `N = X = Level`. As marcas `(1x/DC)`/`(1x/DL)` ficam só como informação — não descontam mais nada.

**Deceiver**

| Magia | Level hoje → novo | N = X | `UseCosts` novo |
|---|---|---|---|
| `Target_…_MaliciousWhispers` | 0 | 0 | truque: **sem** custo de recurso (Task 4) |
| `Projectile_…_SigilofMalice` | 1 | 1 | `ActionPoint:1;ArcanaSpellSlot:1:1` |
| `Target_…_EtherealChains` | 2 | 2 | `ActionPoint:1;ArcanaSpellSlot:1:2` |
| `Target_…_HypnoticGaze` | 2 | 2 | `ActionPoint:1;ArcanaSpellSlot:1:2` (1x/DC) |
| `Target_…_MentalPrison` | **2 → 3** | 3 | `ActionPoint:1;ArcanaSpellSlot:1:3` (1x/DC) |
| `Target_…_Distortion` | 3 | 3 | `ActionPoint:1;ArcanaSpellSlot:1:3` |
| `Target_…_MirrorImage` | 4 | 4 | `ActionPoint:1;ArcanaSpellSlot:1:4` |
| `Target_…_Terrify` | 4 | 4 | `ActionPoint:1;ArcanaSpellSlot:1:4` |
| `Target_…_Marionette` | 5 | 5 | `ActionPoint:1;ArcanaSpellSlot:1:5` (1x/DL) |
| `Target_…_HostileTakeover` | 5 | 5 | `ActionPoint:1;ArcanaSpellSlot:1:5` (1x/DL) |

**Starchild**

| Magia | Level hoje → novo | N = X | `UseCosts` novo |
|---|---|---|---|
| `Projectile_…_Starcall` | 1 | 1 | `ActionPoint:1;ArcanaSpellSlot:1:1` |
| `Target_…_AstralInfusion` | 1 | 1 | `BonusActionPoint:1;ArcanaSpellSlot:1:1` |
| `Target_…_SolarPurge` | 2 | 2 | `ActionPoint:1;ArcanaSpellSlot:1:2` (1x/DC) |
| `Target_…_LunarAegis` | 2 | 2 | `BonusActionPoint:1;ArcanaSpellSlot:1:2` |
| `Teleportation_…_Starbreath` | 3 | 3 | `ActionPoint:1;ArcanaSpellSlot:1:3` (1x/DL) |
| `Target_…_LucentSingularity` | 3 | 3 | `ActionPoint:1;ArcanaSpellSlot:1:3` |
| `Shout_…_StarRadiance` | 3 | 3 | `ActionPoint:1;ArcanaSpellSlot:1:3` |
| `Target_…_MoonGravity` | 4 | 4 | `ActionPoint:1;ArcanaSpellSlot:1:4` |
| `Shout_…_Wish` | 4 | 4 | `BonusActionPoint:1;ArcanaSpellSlot:1:4` (1x/combate) |
| `Target_…_Equinox` | 5 | 5 | `ActionPoint:1;ArcanaSpellSlot:1:5` |
| `Shout_…_AstralFortitude` | 5 | 5 | `ActionPoint:1;ArcanaSpellSlot:1:5` |
| `Zone_…_FinalSpark` | 6 | 6 | `ActionPoint:1;ArcanaSpellSlot:1:6` (1x/DC) |
| `Target_…_SolarFlare` | 6 | 6 | `ActionPoint:1;ArcanaSpellSlot:1:6` (1x/DL) |
| `Shout_…_StellarGrace` | 6 | 6 | `ActionPoint:1;ArcanaSpellSlot:1:6` (1x/DL) |

**Unbound**

| Magia | Level hoje → novo | N = X | `UseCosts` novo |
|---|---|---|---|
| `Target_…_GaleBurst` | 1 | 1 | `ActionPoint:1;ArcanaSpellSlot:1:1` |
| `Zone_…_WindBlast` | 2 | 2 | `ActionPoint:1;ArcanaSpellSlot:1:2` |
| `Shout_…_FlowState` | **2 → 3** | 3 | `ActionPoint:1;ArcanaSpellSlot:1:3` |
| `Shout_…_WindWhispers` | 3 | 3 | `BonusActionPoint:1;ArcanaSpellSlot:1:3` |
| `Shout_…_StormFists` | 4 | 4 | `BonusActionPoint:1;ArcanaSpellSlot:1:4` |
| `Shout_…_EvasiveFlow` | **5 → 3** | 3 | `BonusActionPoint:1;ArcanaSpellSlot:1:3` |
| `Shout_…_Thunderclap` | **6 → 4** | 4 | `BonusActionPoint:1;ArcanaSpellSlot:1:4` |

**Eternal**

| Magia | Level hoje → novo | N = X | `UseCosts` novo |
|---|---|---|---|
| `Target_…_BloodReaper` | 1 | 1 | `BonusActionPoint:1;ArcanaSpellSlot:1:1` |
| `Target_…_Obliterate` | 1 | 1 | `ActionPoint:1;ArcanaSpellSlot:1:1` |
| `Target_…_Transfusion` | 1 | 1 | `ActionPoint:1;ArcanaSpellSlot:1:1` |
| `Target_…_DeathsGrasp` | 2 | 2 | `ActionPoint:1;ArcanaSpellSlot:1:2` |
| `Shout_…_Indestructible` | 2 | 2 | `BonusActionPoint:1;ArcanaSpellSlot:1:2` |
| `Target_…_DeathWard` | 3 | 3 | `ActionPoint:1;ArcanaSpellSlot:1:3` (1x/DC) |
| `Shout_…_DeathsAspect` | **5 → 4** | 4 | `ActionPoint:1;ArcanaSpellSlot:1:4` |
| `Target_…_Hemoplague` | **5 → 4** | 4 | container: o custo vai nos 6 filhos (Task 8) |
| `Target_…_Hemorrhage` | 6 | 6 | `ActionPoint:1;ArcanaSpellSlot:1:6` |
| `Target_…_RealmOfDeath` | 6 | 6 | `ActionPoint:1;ArcanaSpellSlot:1:6` |

**`Created`** — como o custo em combate agora vem do custo de slot (D1), as cartas geradas que devem custar Threads precisam de slot no `UseCosts`; as de graça ficam sem.

| Carta | N = X | Nota |
|---|---|---|
| `Shout_…_Withdraw`, `…_MimicWithdraw`, `…_MimicSigilofMalice`, `…_MimicEtherealChains`, `…_ZephyrStrike` | 1 | `ArcanaSpellSlot:1:1`, sem custo de ação |
| `…_MimicDistortion`, contêiner `…_Mimic` | 2 | idem, nível 2 |
| `…_FinalSpark_Recreate`, `…_Reweave` | — | continuam **sem** custo de recurso (assimetria intencional) |
| `…_Tangle_DEBUG` | — | injogável, não recebe custo |

**EX** (`N = min(6, N da base + 2)`, `X = N`; todas perdem o `ArcaneShards`)

| N | Magias |
|---|---|
| 3 | `Transfusion_EX`, `Starcall_EX` |
| 4 | `DeathsGrasp_EX`, `LunarAegis_EX`, `Faceless_Copy_EX` |
| 5 | `EvasiveFlow_EX`, `FlowState_EX`, `StarRadiance_EX` |
| 6 | `StormFists_EX`, `AstralFortitude_EX`, `Hemoplague_EX`, `RealmOfDeath_EX`, `MirrorImage_EX`, `HostileTakeover_EX` |

`HowlOfTheDead_EX` sai desta tabela (Task 5) e `GaleDeflectMissiles_EX` é reação (Task 6).

- [x] **Step 1:** Backup dos arquivos de stats.
- [x] **Step 2:** Aplicar `UseCosts` e `Level` das quatro tabelas + EX, nos `.txt` **e** nos `.stats`. Cartas que herdam (`using`) e não declaram `UseCosts` próprio não precisam de linha nova.
- [x] **Step 3:** Verificar que **nenhuma** carta `Arcana_Card_Spell_` ainda cita `ArcaneEssence`/`ArcaneShards` no `UseCosts`, e que todo `ArcanaSpellSlot:1:N` tem `N` entre 1 e 6.
- [x] **Step 4:** XML dos `.stats` continua válido.

---

### Task 3: Utilitárias

**Files:** os mesmos arquivos de stats.

| Custo | Magias |
|---|---|
| **0 (Ritual, sem slot)** | Mage Hand · Comprehend Languages · Detect Supernatural · Dead Whispers · Friends · Faceless e todas as variantes · Arcane Lock · Arcane Unlock · Arcane Familiar (já é 1x/DC) |
| **Com custo** | Third Eye `ArcanaSpellSlot:1:2` · Third Eye: Projection `:1:3` · Dispel Magic `:1:3` · Arcane Gate `:1:5` |

Hoje todas custam `ArcaneEssence` (de 1 a 4) — ver o levantamento: 16 magias `Arcana_Util_` com custo.

- [x] **Step 1:** Zerar a parte de recurso do `UseCosts` das utilitárias da primeira linha (mantendo o custo de ação) e marcar como Ritual onde fizer sentido.
- [x] **Step 2:** Aplicar os 4 custos da segunda linha.
- [x] **Step 3:** Verificar que nenhuma `Arcana_Util_` cita `ArcaneEssence`.

---

### Task 4: Conversão de custo em combate (boosts genéricos) — o coração da D1

**Files:** `Scripts\thoth\helpers\IsArcanaSpell.khn`, `IsArcanaCantrip.khn`, `Status_BOOST.txt`/`.stats`, `Const.lua`, `Boosts.lua`, `CardDB.lua`.

- [x] **Step 1:** `IsArcanaSpell.khn`: trocar `HasUseCosts('ArcaneEssence', true, entity)` por `HasUseCosts('ArcanaSpellSlot', true, entity)`. Conferir os **6 usos** do helper (`Passive.txt` linhas 152, 172, 183, 185, 317-364 e os `.stats` espelhos) — os bônus de dano/vantagem continuam querendo dizer "magia da Arcana", e continuam certos, porque o conjunto de magias é o mesmo.
- [x] **Step 2:** Como os truques e as utilitárias grátis perdem o custo de slot, elas saem do `IsArcanaSpell()`. As passivas que as incluíam já usam `IsArcanaSpell() or IsArcanaCantrip()` — **acrescentar ao `IsArcanaCantrip.khn`** o Howl of the Dead (Task 5) e conferir se alguma utilitária zerada na Task 3 precisa entrar.
- [x] **Step 3:** Status técnico novo (`ARCANA_WEAVING`, `IsHidden`, sem duração — o Lua aplica no `CombatStarted` e remove no `CombatEnded`), carregando **6 boosts**:
  `UnlockSpellVariant(IsArcanaSpell(context.Source) and <nível n>, ModifyUseCosts(Replace, ArcanaSpellSlot, n, n, ArcanaThread), ModifyTooltipDescription())` para n = 1..6.
  **Sem `ModifyIconGlow()`** — o brilho continua vindo do boost por magia do Lua, senão tudo brilha.
- [x] **Step 4:** São **6 boosts e nenhum helper novo** (Q1). Se em algum momento uma carta precisar de custo fora da regra, a saída é mudar o `Level` dela, nunca acrescentar um boost de exceção.
- [x] **Step 5:** `Const.lua`: apagar o `GLOW_BOOST` de custo; sobra o bloqueio e um boost de brilho puro (`UnlockSpellVariant(SpellId('%s'), ModifyIconGlow())`). Apagar do `CardDB` o que virou redundante — o `cost` continua, mas agora só para a **conta de Threads do Lua** (previsão, testes, `!arcanahand`), não para gerar boost.
- [x] **Step 6:** Truques: `cost = 0` no `CardDB`, **sem** keyword `Attuned` (a keyword deixa de existir neste plano). Conferir na Task 9 se o `deck-core-design.md` ainda a menciona.
- [x] **Step 7:** Testes: o `BoostsTest` não pode mais esperar custo no boost de brilho; um teste novo garante que carta sem custo de slot tem `cost = 0`.

---

### Task 5: Correções de categoria e posição

| O quê | Hoje | Vira |
|---|---|---|
| Arcane Recovery | `Shout_Arcana_Card_Spell_ArcaneRecovery`, na lista "Arcana Level 2" | `Shout_Arcana_Util_ArcaneRecovery`; devolve 1 Woven Spell Slot, 1x/DL; sai do deck |
| Howl of the Dead | `Shout_Arcana_Card_Spell_HowlOfTheDead_EX` (Level 10, `ArcaneShards:1`) | perde o `_EX` (não existe base), vira truque `N0` com `Attuned` |
| Evasive Flow EX | está na lista "Unbound Level 13", mas o spec diz que a progressão a concede no nível 4 | confirmar qual nível da progressão usa essa lista e corrigir para 13 |
| Interrupt do Instinctive Charm | `Arcana_Card_Spell_Interrupt_InstinctiveCharm` — o rename da taxonomia pegou este nome por engano | `Interrupt_Arcana_Reaction_InstinctiveCharm` (Task 6, D2) |

- [x] **Step 1:** Renomear as três magias/interrupt com o mesmo método dos renames anteriores (backup, troca, `grep` de verificação), incluindo referências em listas, passivas e `.stats`.
- [x] **Step 2:** Conferir a progressão do Evasive Flow EX (`grep` pelo UUID da lista "Unbound Level 13" nos `Selectors`) e corrigir se estiver no nível 4.
- [x] **Step 3:** Ajustar a loca em inglês dos nomes alterados (as outras 15 línguas continuam em dívida, fora do escopo).

---

### Task 6: Reações — recursos, passivas e interrupts

**Estado de hoje (levantado em 2026-09-19):**
- `GaleDeflectMissiles_Charge`: existe, `ShortRest`, `IsHidden`; concedido na **progressão** (`Progressions.lsx`), gasto por `StatsFunctors` de uma passiva.
- `HollowImage_Charge`: existe, `ReplenishType Turn`; concedido por **duas passivas** (base e EX).
- Instinctive Charm: **não tem recurso**; o interrupt custa só `ReactionActionPoint:1`.
- `Interrupt_GaleDeflectMissiles_Return` custa `ArcaneEssence:1`; os dois interrupts EX custam `ArcaneShards`.

| Reação | Recurso novo (`MaxValue 1`) | Carta de ativação (`Arcana_Card_Passive_`) | X | Lista |
|---|---|---|---|---|
| Gale Deflection | `ArcanaReactGaleDeflection` (renomeia `GaleDeflectMissiles_Charge`) | `Shout_Arcana_Card_Passive_GaleDeflection` | 2 | Unbound Level 3 |
| Instinctive Charm | `ArcanaReactInstinctiveCharm` (**criar**) | `Shout_Arcana_Card_Passive_InstinctiveCharm` | 2 | Deceiver Level 5 |
| Hollow Image | `ArcanaReactHollowImage` (renomeia `HollowImage_Charge`) | `Shout_Arcana_Card_Passive_HollowImage` | 3 | Deceiver Level 11 |

- [x] **Step 1:** `ActionResourceDefinitions` (`.lsx` + `.tbl`): renomear os dois e criar o do Instinctive Charm, os três com `MaxValue 1`, `IsHidden true`. Atualizar todas as referências (progressão, passivas, interrupts, `EnableCondition`).
- [x] **Step 2:** Passivas: garantir que cada reação concede 1 do seu recurso (o Instinctive Charm passa a ter um), e que o interrupt correspondente o gasta e o exige no `EnableCondition`.
- [x] **Step 3:** Custos dos interrupts sem Shards/Essence: `Interrupt_GaleDeflectMissiles_Return` passa a custar só o recurso da reação; os dois `_EX` idem. *(Decisão em aberto no spec §11.3 — confirmar com o autor se a versão EX cobra algo a mais.)*
- [x] **Step 4:** Renomear para o prefixo `Arcana_Reaction_` (**D2**): a magia da reação (`Projectile_Arcana_Reaction_GaleDeflection`, `Target_Arcana_Reaction_InstinctiveCharm`, `…_HollowImage`), as entradas de interrupt (`Interrupt_Arcana_Reaction_X`) e as variantes `_EX`. Mesmo método dos renames anteriores.
- [x] **Step 5:** Criar as 3 cartas de ativação: Shout sem alvo, sem custo de ação (**D4**), `SpellProperties` com `RestoreResource(<recurso>,1,0)`, `Requirements "Combat"` (só fazem sentido em combate), e loca em inglês.
- [x] **Step 6:** Adicionar as 3 às listas de magia das subclasses.

---

### Task 7: Lua — `Card_Passive` e o ciclo do recurso de reação

**Files:** `Const.lua`, `Pool.lua`, `Sync.lua`, `Server/Economy/Reactions.lua` (novo), `Flow.lua`, `CardDB.lua`, testes.

- [x] **Step 1: Duas categorias novas.** `C.PREFIX.Passive = "Arcana_Card_Passive_"` (entra nas listas de `Po.Relevant` e `Sy.Desired`, hoje `Card`/`Created`/`Util`) e `C.PREFIX.Reaction = "Arcana_Reaction_"` (**fica fora** das duas listas — o deck nunca a toca). Ordem no `C.CATEGORY_ORDER` importa: prefixo mais específico primeiro. Testes no `UtilTest` (resolução de categoria) e no `SyncTest`.
- [x] **Step 2: `Reactions.lua`.** Dados no `CardDB` (`reaction = { resource = "ArcanaReactGaleDeflection", perTurn = false }`). Funções: `Zero(char)` no `CombatStarted`, `Restore(char)` no `CombatEnded`, e no `TurnStarted` rezerar as que têm `perTurn` (Hollow Image) **enquanto a ativação não tiver sido jogada** — guardar isso em `st.combat.counters`.
- [x] **Step 3:** Acesso genérico a recurso por nome. O `Threads.io` hoje resolve só o `ArcanaThread` com UUID em cache; extrair um helper que receba o nome do recurso, para o `Reactions` reusar.
- [x] **Step 4:** Ao jogar a carta de ativação (`CardPlayed`), marcar o contador para o `perTurn` parar de rezerar. O efeito de devolver o recurso vem do `SpellProperties` da própria magia (Task 6), não do Lua — assim o console não precisa de nada.
- [x] **Step 5:** Testes: recurso zerado ao entrar em combate, rezerado por turno no caso `perTurn`, parado depois da ativação, restaurado no fim do combate.

---

### Task 8: Hemoplague — `Choose`

**Files (levantamento completo, 8 arquivos):** `Stats\Generated\Data\Spell_Target.txt` + `Passive.txt`, `Lists\SpellLists.lsx`, `Progressions\Progressions.lsx` e os quatro espelhos em `Editor\Mods\…` (`Target.stats`, `Passive.stats`, `SpellLists.tbl`, `Progressions.tbl`). A loca **não** cita o nome (só handles), então não entra.

**Estado de hoje:** já é um `SpellContainer` nativo. `Target_Arcana_Card_Spell_Hemoplague` tem `ContainerSpells` com as **6** doenças (Blinding Sickness, Filth Fever, Flesh Rot, Mindfire, Seizure, Slimy Doom) e cada uma tem `SpellContainerID` apontando de volta. Todas herdam do `_FilthFever`, que herda da carta principal; o `_EX` também herda do `_FilthFever`. O jogo já mostra as 6 opções sem Lua nenhum.

`Choose` é **keyword**, não prefixo (decisão de 2026-09-19) — corrigir o `card-costs.md` §8, que ainda fala em `Arcana_Choose_`.

- [x] **Step 1:** Renomear as 6 doenças para `Target_Arcana_Created_Hemoplague_<Doença>` (saem do pool do deck automaticamente, porque `Created` nunca entra na lista). Cuidado com o `using` do `_EX`.
- [x] **Step 2:** Carta principal continua `Target_Arcana_Card_Spell_Hemoplague`, Level 5 → **4**, N = X = 4 (**D3**: só gera a doença), e ganha `choose = { as 6 }` no `CardDB`.
- [x] **Step 3 (Q2):** **manter o container.** O custo (`ArcanaSpellSlot:1:4`) vai nos **6 filhos**, que é o que o jogo cobra de fato; a mãe não cobra nada. O `CardDB` mapeia filho → carta-mãe, e o `CastedSpell` de um filho conta como ter jogado a mãe (para bloqueio, pilha e contagem de cópias). Nenhum mecanismo `Choose` no Lua; o console continua funcionando sozinho.
- [x] **Step 4:** Aplicar o mesmo mapeamento ao **Mimic**, que também é container (`…_Mimic` com `MimicWithdraw`/`MimicSigilofMalice`/`MimicEtherealChains`/`MimicDistortion`) — hoje o Lua não sabe disso.
- [x] **Step 5:** Testes: jogar um filho debita o custo certo, marca a mãe como jogada e manda a **mãe** para a pilha (não o filho).

---

### Task 9: Fechamento

- [x] **Step 1:** RUN_TESTS — todos verdes, incluindo os testes novos das Tasks 4, 7 e 8.
- [x] **Step 2:** Rodar a simulação de ponta a ponta do scratchpad, com uma carta de cada tipo novo.
- [x] **Step 3:** Commit do Lua.
- [x] **Step 4:** Atualizar: `card-costs.md` (nomes novos, `Choose` como keyword, decisões D1–D4), `deck-core-design.md` §4 e §10 (categoria `Reaction`, campos `choose`/`reaction`, **remoção da keyword `Attuned`** e do boost de custo por magia), `resource-economy.md` §8 e a memória `arcana-rework-2026`.
- [x] **Step 5:** Avisar o autor do que precisa de Toolkit (Reload Stats) e de Story Editor (se algum goal mudar).

---

## Fora do escopo

- **Mecânicas que não são pré-requisito do Hemoplague:** `Invoke`, `Echo`, `Fleeting` generalizado, `Landmark`, destino explícito por carta (`Thrash`/`Exile` como keyword no `CardDB`). Ficam no plano 5.
- **Renomear as pilhas** `frayed`/`unraveled` para `thrash`/`exile` no código — plano 5.
- **Comportamento flex do `Card_Ability`** (entrar no deck, custar Threads em combate): as magias já têm o nome, mas o Lua ainda as ignora. Plano 5.
- **Loca das outras 15 línguas** e os tooltips `LSTag` que ainda citam `IND_`.
- **Arcane Recovery, Overflow e Mastery** como sistema (o Arcane Recovery só muda de categoria aqui; o redesenho de Overflow/Mastery continua pendente).
