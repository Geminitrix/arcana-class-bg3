# Arcana — sistema de economia de recursos (balanceamento)

> Spec de balanceamento · 2026-09-17 · status: **aprovado pelo autor** (valores iniciais, a validar em playtest)
> Escopo: os números de **todos os recursos ao mesmo tempo** — mão, compra, deck, Threads por nível, reserva, custo das cartas e `ArcanaSpellSlot` (Woven Spell Slots).
> Nível e custo de **cada carta que já existe**, mais as categorias `Arcana_Reaction_` e `Arcana_Choose_`: `specs/2026-09-17-card-costs.md`.
> Vale sobre os números da seção 2 de `2026-09-17-deck-core-design.md` e sobre a seção 4 do `REWORK_CONTEXT.md`.
> **O código Lua ainda usa os valores antigos** (ver a seção 8). A implementação precisa de plano próprio.

---

## 1. Resumo

| Recurso | Regra |
|---|---|
| Mão inicial | **4** (escolhida para que as cartas de compra tenham peso) |
| Compra por turno | **1** |
| Limite da mão | **10** |
| Deck mínimo | **10** nos níveis 1–8 · **15** do nível 9 em diante |
| Cópias por título | até 3 (Unique = 1) |
| Threads por turno | **sobe por faixa de nível** (seção 3) |
| Spare Thread (reserva) | **2**, igual em todos os níveis |
| Teto total de Threads | **6** |
| Custo de uma carta | **X = nível da carta (1–6)**; **−1 se for 1x/descanso** (mínimo 1). Truques: custam 1 e devolvem 1. **Ponto de partida:** o custo terá análise própria, com modificadores que aumentam e diminuem o X |
| `ArcanaSpellSlot` | estilo Warlock, recarga no descanso curto; tabela da seção 5 |
| Combates por descanso longo (calibração) | **3** |

## 2. Como as Threads funcionam no turno

- No início de cada turno do personagem, as Threads são **redefinidas** (não somadas): `energia do turno + min(reserva, sobra do turno anterior) + bônus de início`, limitado ao teto total (6).
- A energia do turno é o **máximo que dá para gastar** naquele turno.
- O que sobra **não acumula**, exceto até o tamanho da reserva (2). O resto se perde.
- Quem entra atrasado no combate começa no **turno 1 dele**, com a energia do turno 1 da sua faixa de nível e compra 4.
- **Bind a Thread** (ganho permanente no combate) e os **ganhos temporários** somam por cima da rampa e **podem passar do teto da faixa** (decidido em 2026-09-17). O único limite é o teto total, 6.
- Refil: `min(6, min(tetoDaFaixa, turno + inícioDaFaixa) + binds + min(2, sobra) + bônusDeInício)`.

## 3. Threads por nível

| Nível | Energia nos turnos 1, 2, 3, 4, 5+ | No código: início / teto de base | Poder vs. Wizard (3 combates por dia) |
|---|---|---|---|
| 1–4 | 1, 1, 1, 1, 1 | 0 / 1 | 1,67 → 0,98 (excesso nos níveis 1–2 aceito pelo autor) |
| 5–6 | 1, 2, 3, 3, 3 | 0 / 3 | 1,03 / 0,96 |
| 7–8 | 2, 3, 4, 4, 4 | 1 / 4 | 1,04 / 0,96 |
| 9–10 | 3, 4, 5, 5, 5 | 2 / 5 | 0,90 / 0,84 |
| 11–20 | 4, 5, 6, 6, 6 | 3 / 6 | 0,89 → 0,77 |

Fórmula: `energia(turno) = min(teto de base da faixa, turno + início da faixa)`. Os binds entram **depois** desse mínimo, então passam do teto da faixa e param só no teto total.

**Nível usado:** o Osiris só oferece `GetLevel` (nível do personagem). Em multiclasse, o ideal seria o nível de Arcana — a confirmar no jogo se dá para ler pelo SE (`Ext.Entity`).

**Achado central:** a partir do nível 9, **mais energia não aumenta o poder**. O personagem joga no máximo 1 carta de ação e 1 de ação bônus por turno, então o gargalo passa a ser a economia de ações. Testei teto total 8 e o ganho foi zero.
**O que falta no fim do jogo (10–23%) tem de vir de outras fontes** (decidido: **sem Arcane Shards**):
- cartas **`_EX`**, evoluções das cartas de assinatura de cada subclasse;
- cartas que dão **ação extra**;
- cartas mais fortes por custo (regra da seção 6);
- passivas.

## 4. Mão e deck

| Teste | Resultado |
|---|---|
| Mão inicial 3 / 4 / 5 | turnos sem jogada: 4–6% / 4–9% / 2–4%. A mão 5 é a mais segura, mas **a escolha foi 4**, porque com 5 as cartas de compra quase nunca são usadas (0,0 a 0,2 compras por combate, contra 1,5 a 2,3 com mão 3) |
| Compra 1 vs. 2 | com 2, a mão incha para 5–6 cartas nas lutas longas; com 1, fica em média com 3–4 |
| Limite 5 / 7 / 10 | com 5, a mão encheu em 2–5% dos turnos; com 7 ou 10, nunca (0%). **A escolha foi 10**, que deixa espaço para cartas de compra e tokens |
| Deck de 6–8 cartas | faltam cartas baratas: até 25% de turnos sem jogada |
| Deck de 10 a 25 cartas | o poder é praticamente o mesmo. O tamanho muda a consistência, não o poder |
| Reserva 1 vs. 2 | o poder é igual; o desperdício cai (ex.: 16% → 11% no nível 13) |

**Consistência** — chance de ter uma carta específica, com 3 cópias:

| Deck | Na mão inicial de 4 | Até o turno 4 (7 cartas vistas) |
|---|---|---|
| 10 | 83% | 100% |
| 15 | 63% | 89% |
| 20 | 49% | 76% |
| 30 | 35% | 57% |

Decks grandes se punem sozinhos; não é preciso deck máximo.

**Por que 15 no começo é demais:** no nível 1 há poucas cartas, e um deck de 15 obrigaria a pôr 3 cópias de tudo. Hoje as subclasses têm de 1 a 3 cartas no nível 1, e o Unbound só chega a 5 títulos no nível 7.
**Regra de conteúdo:** pelo menos **4 títulos no nível 1**, para que um deck de 10 seja possível com escolha.

**Curva de custo:** o deck precisa de cerca de **30% de cartas que caibam na energia do turno 1**. Um deck só com as cartas mais caras passa o turno 1 sem jogar nada (achado da simulação).

## 5. `ArcanaSpellSlot` (Woven Spell Slots)

- **Papel:** na edição SE, só fora de combate (em combate o custo vira Threads). Na **edição console**, é o recurso de combate, e por isso a tabela foi calibrada para ela.
- **Funcionamento:** estilo Warlock. Todos os slots têm o mesmo nível, a recarga é no descanso curto e a magia é conjurada no nível do slot. A tabela usa o padrão de `ActionResource` + `ActionResourceOverride`, que já está nos `Progressions.lsx`.

| Nível | Slots × nível do slot | Poder vs. Wizard |
|---|---|---|
| 1 | 1 × 1 | 1,00 |
| 2 | 2 × 1 | 1,20 |
| 3–4 | 2 × 2 | 1,03 / 0,93 |
| 5–6 | 2 × 3 | 0,97 / 0,89 |
| 7–8 | 2 × 4 | 0,88 / 0,81 |
| 9–10 | 3 × 5 | 0,99 / 0,92 |
| 11–12 | 3 × 6 | 0,94 |
| 13–14 | 3 × 7 | 1,01 |
| 15–16 | 3 × 8 | 1,01 |
| 17–18 | 3 × 9 | 0,93 / 0,89 |
| 19–20 | **4** × 9 | 1,05 / 1,05 |

- É a tabela que **já está nos arquivos**, com uma mudança: **o nível 20 passa de 5 para 4 slots** (com 5, o poder chegava a 1,19).
- **Warlock puro (5e)** — no máximo 2 slots até o nível 10 e slot de nível 5 no máximo — ficou em 0,72–0,87 do nível 6 ao 16. É fraco para o Arcana, que não tem Eldritch Blast nem invocações.
- **Conjurar no nível do slot** rende só +0–10%, porque as cartas escalam pelo nível do personagem (`LevelMapValue` / `ClassLevel(Arcana)`), não pelo `SpellPowerLevel`. Para o upcast valer mais, as fórmulas das cartas precisariam usar `SpellPowerLevel`.
- *Conferir no jogo:* uma carta de nível 1 pode ser paga com um slot de nível maior depois que o `ActionResourceOverride` zera os slots de nível 1 (é o comportamento do Warlock vanilla).

**Custo em `UseCosts`:** `ArcanaSpellSlot:1:X`, sendo X o nível da carta. Em combate (SE), o boost GLOW troca por X Threads (`ModifyUseCosts(Replace,ArcanaSpellSlot,X,-1,ArcanaThread)`).
**Decidido (2026-09-17):** o custo em Threads fica no **`CardDB`**, porque é coisa de combate e só existe na edição com SE. A **edição console** lê o custo direto do `UseCosts` (`ArcanaSpellSlot:1:X`), que vale dentro e fora de combate. Os dois precisam ser mantidos coerentes.

## 6. Regras para cartas novas

1. **Custo X** = nível de poder da carta (1–6). **−1 se for 1x/descanso curto ou longo** (dois limitadores ao mesmo tempo).
2. **Benefício alvo** (moeda do `Arcana_Power_Budget.md`, R entre 0,90 e 1,10):
   - carta de ação: `A(tier) + S(X + bônus)`;
   - carta de ação bônus: `0,6 × A(tier) + S(X + bônus)`;
   - `S` = 8 / 12 / 20 / 24 / 28 / 32 / 36 / 40 / 44 para os níveis 1–9;
   - `bônus = max(0, ⌈nível do personagem / 2⌉ − 6)`: a partir do nível 13, a carta ganha +1 nível efetivo a cada 2 níveis, via `LevelMapValue`.
3. **Cerca de 1/3 das cartas de cada subclasse deve ser de ação bônus.** Hoje o Deceiver não tem nenhuma e fica preso a 1 carta por turno.
4. **Cartas de energia (+Threads):** **não gastam ação nem ação bônus** (decidido). Uma "+1 Thread" que gasta a ação bônus quase nunca foi jogada na simulação.
5. **Cartas de compra:** podem ter **efeitos extras** além da compra. A mão inicial 4 já existe para dar espaço a elas.
6. **Cartas de energia e de compra:** 15–20% do deck, sem perda de desempenho.
7. **Cartas `_EX`:** são as evoluções das cartas de assinatura de cada subclasse e **entram no deck**, com custo em Threads como qualquer carta. **Arcane Shards ficam fora deste sistema** (decidido). As `_EX` atuais, que custam Shards, precisam de custo novo.

## 7. Premissas e sensibilidade

- **Referência:** Wizard, com orçamento `4 turnos × A + W/3` por combate (`W` = pontos de slot por dia, Power Budget §2).
- **Duração e frequência:** 3 combates por descanso longo, 2 descansos curtos, lutas de 3 a 5 turnos (30/40/30%).
- **Desconto do deck:** ×0,77 no valor das cartas (×0,9 porque a energia chega aos poucos, ×0,85 porque só se joga o que está na mão).
- **Pool sintético:**
  - 2 truques e 3 cartas de nível 1 no nível 1;
  - depois, +1 carta por nível no maior nível disponível (`⌈nível/2⌉`, até 6);
  - 1/3 de ação bônus e 1/5 com 1x/descanso curto;
  - 20% de cartas de economia;
  - deck montado com curva (30% de cartas baratas).
- **As razões da seção 3 foram medidas com mão inicial 5.** Com mão inicial 4 elas caem de 2 a 4% (ex.: nível 7: 1,04 → 1,00; nível 13: 0,88 → 0,85), e as cartas de compra passam a ser usadas.
- **Sensibilidade a E (combates por descanso longo):** as Threads não se esgotam e os slots do Wizard sim.

  | E | 2 | 3 | 4 | 6 |
  |---|---|---|---|---|
  | Poder da edição SE vs. Wizard | ≈ 0,75 | 1,0 | ≈ 1,2 | ≈ 1,5 |

- **Desconto do deck:** com ×0,69 em vez de ×0,77, todas as razões caem cerca de 6%.
- Os números são **pontos de partida**. Quem confirma é o playtest da Task 12 (e os seguintes).

## 8. Impacto na implementação

**Aplicado em 2026-09-17** (`plans/2026-09-17-balance-migration.md`, 80 testes passando):

| Onde | Como ficou |
|---|---|
| `Const.lua` | `OPENING_HAND` 4, `THREAD_RESERVE_MAX` 2, `HAND_MAX` 10, `THREAD_BANDS` e `MIN_DECK_BANDS` por nível |
| `Threads.Compute` | `min(teto da faixa, turno + início) + binds`, mais reserva e bônus, limitado a 6; `Th.BandFor(level)` escolhe a faixa |
| Nível do personagem | `Po.LevelOf` (`Osi.GetLevel`) → `Flow.BeginCombat/StartTurn` → `st.combat.level` |
| `List` | `L.MinDeck(level)`; `SetCount(st, poolIds, id, n, level)` |
| `CardDB` | custo por carta: Sigil of Malice 1, Ethereal Chains 2, Distortion 3, Final Spark 5, tokens e continuações 1 |
| `Progressions` (`.lsx` e `.tbl`), nível 20 | boost removido; níveis 19–20 ficam com 4 slots de nível 9 |

**Ainda pendente:**

| Onde | Hoje | Novo |
|---|---|---|
| Stats das cartas | `ArcaneEssence:N` | `ArcanaSpellSlot:1:X` (plano próprio; é o que a edição console lê) |
| Recursos antigos | Arcane Recovery, Overflow e Mastery usam `ArcaneEssence` | redesenhar (ex.: Overflow → ganho de Thread no SE e slot no console) |
| Cartas `_EX` | custam Arcane Shards | custo em Threads, já que os Shards saíram do sistema |
| Nível em multiclasse | `Osi.GetLevel` (nível do personagem) | nível de Arcana, se o SE expuser |

## 9. Reproduzir a simulação

Scripts Lua 5.4 em `Design/sim/`. Eles carregam o `Const.lua` e o `Threads.lua` reais do mod, só para leitura.

```
"C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe" ideal2.lua opt 150
"C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe" ideal2.lua prop 400
"C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe" ideal2.lua hand 400
"C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe" ideal2.lua deck 400
"C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe" ideal2.lua slots 300
```

- `sim.lua`: o motor (combate com deck, mão, Threads e cartas de economia; slots fora de combate).
- `ideal2.lua`: o modelo final (3 combates por dia, reserva 2).
- `ideal.lua` e `extra.lua`: a primeira rodada (4 combates por dia, reserva 1).
- `run.lua`: o teste com as cartas atuais do mod.
