# Arcana — níveis e custos das cartas

> Spec de balanceamento · 2026-09-17 · status: **proposta, aguardando revisão do autor**
> Escopo: o **nível** e o **custo** de cada magia `Arcana_*` que já existe no mod, mais as categorias novas
> (`Arcana_Reaction_` e `Arcana_Choose_`) e as correções de categoria.
> Depende de: `specs/2026-09-17-resource-economy.md` (economia geral) e `specs/2026-09-17-deck-core-design.md` (deck).
> Moeda e vereditos: `Claude outputs/Arcana_Power_Budget.md`.

---

## 1. As duas regras

**Nível da carta (N).** `N = min(6, ⌈nível de desbloqueio ÷ 2⌉)`, ajustado para baixo quando o efeito é fraco
para esse nível.

Isso não é estética. Com os Woven Spell Slots no estilo Warlock, o nível do slot também é `⌈nível ÷ 2⌉`,
então **uma carta de nível acima disso seria impossível de conjurar fora de combate** (e na edição console)
no nível em que o personagem a recebe.

**Custo (X).** `X = N`, menos 1 se a carta for 1x/descanso curto ou longo (mínimo 1) — recurso e cooldown
juntos são dois limitadores.

**Onde cada número entra:**

| Onde | Valor |
|---|---|
| `UseCosts` da magia (stats) | `ArcanaSpellSlot:1:N` — vale fora de combate e na edição console |
| `CardDB` (Lua, só edição SE) | `cost = X` — vale em combate |

Os dois precisam ser mantidos coerentes. Quando o nível de uma carta mudar, os dois mudam.

## 2. Categorias por prefixo

| Prefixo | O que é | Entra no deck? | Custo |
|---|---|---|---|
| `Arcana_Card_` | carta normal | sim | `ArcanaSpellSlot:1:N` + `cost` em Threads |
| `Arcana_Reaction_` | **novo** — carta de ativação de uma reação | sim | só Threads (ver seção 7) |
| `Arcana_Choose_` | **novo** — carta que gera na mão um token escolhido pelo jogador | sim | `ArcanaSpellSlot:1:N` + Threads |
| `Arcana_Token_` | carta gerada por outra (Conjured) | não | só Threads |
| `Arcana_Util_` | utilitária; **sempre bloqueada em combate** | não | só `ArcanaSpellSlot` |
| `Arcana_Ability_` | o deck nunca toca (inclui a magia que a reação conjura) | não | nenhum |

`Arcana_Reaction_` e `Arcana_Choose_` **são cartas** para o deck: contam no deck mínimo, na mão e no limite,
e recebem bloqueio e brilho como qualquer carta. O prefixo só marca o papel e o que o `CardDB` guarda.

## 3. Cartas por subclasse

Coluna "hoje" = custo atual em `ArcaneEssence`.

### Deceiver

| Carta | Desbl. | N | X | Hoje | Nota |
|---|---|---|---|---|---|
| Malicious Whispers | 1 | 0 | 1, devolve 1 | 0 | truque |
| Sigil of Malice | 1 | 1 | 1 | 1 | já no `CardDB` |
| Ethereal Chains | 3 | 2 | 2 | 2 | já no `CardDB` |
| Hypnotic Gaze | 3 | 2 | 1 | 1 | 1x/DC, e manter gasta a ação de cada turno |
| Mental Prison | 3 | **3** | 2 | 3 | sobe de 2: nega ação, movimento e reação, e dá crítico garantido dentro da área |
| Distortion | 5 | 3 | 3 | 2 | já no `CardDB` |
| Mirror Image | 7 | 4 | 4 | 3 | |
| Terrify | 9 | 4 | 4 | 2 | medo de alvo único não sustenta nível 5 |
| Marionette | 9 | 5 | 4 | 3 | 1x/DL |
| Hostile Takeover | 11 | 5 | 4 | 4 | 1x/DL |

### Starchild

| Carta | Desbl. | N | X | Hoje | Nota |
|---|---|---|---|---|---|
| Starcall | 1 | 1 | 1 | 1 | |
| Astral Infusion | 1 | 1 | 1 | 1 | |
| Solar Purge | 3 | 2 | 1 | 2 | 1x/DC |
| Lunar Aegis | 3 | 2 | 2 | 2 | se o +2 de CA durar o combate inteiro, sobe para N 3 |
| Starbreath | 5 | 3 | 2 | 3 | 1x/DL; Revivify é nível 3 |
| Lucent Singularity | 5 | 3 | 3 | 2 | |
| Star Radiance | 5 | 3 | 3 | 3 | |
| Moon Gravity | 7 | 4 | 4 | 3 | Freedom of Movement é nível 4 |
| Wish | 7 | 4 | 3 | 3 | 1x/combate já é um segundo limitador |
| Equinox | 9 | 5 | 5 | 2 | |
| Astral Fortitude | 9 | 5 | 5 | 3 | vigiar: pode ficar fraca para o nível 5 |
| Final Spark | 11 | 6 | 5 | 3 | 1x/DC; já no `CardDB` |
| Solar Flare | 11 | 6 | 5 | 4 | 1x/DL |
| Stellar Grace | 12 | 6 | 5 | 3 | 1x/DL |

### Unbound

| Carta | Desbl. | N | X | Hoje | Nota |
|---|---|---|---|---|---|
| Gale Burst | 1 | 1 | 1 | 2 | |
| Wind Blast | 3 | 2 | 2 | 2 | |
| Flow State | 3 | **3** | 3 | 2 | sobe de 2: ação bônus extra é economia de ação |
| Wind Whispers | 5 | 3 | 3 | 1 | desvantagem em todo ataque contra você vale muito mais que 1 |
| Storm Fists | 7 | 4 | 4 | 2 | |
| Evasive Flow | 9 | **3** | 3 | 1 | Disengage e pulo livre não são de nível 5. Ou desce o nível, ou a carta precisa ficar mais forte |
| Thunderclap | 11 | **4** | 4 | 3 | Reverberation ao causar dano não sustenta nível 6 |

### Eternal

| Carta | Desbl. | N | X | Hoje | Nota |
|---|---|---|---|---|---|
| Blood Reaper | 1 | 1 | 1 | 1 | |
| Obliterate | 1 | 1 | 1 | 2 | |
| Transfusion | 1 | 1 | 1 | 1 | |
| Death's Grasp | 3 | 2 | 2 | 2 | |
| Indestructible | 3 | 2 | 2 | 2 | |
| Death Ward | 5 | 3 | 2 | 2 | 1x/DC |
| Death's Aspect | 9 | **4** | 4 | 3 | medo em área é nível 3–4 no vanilla |
| Hemoplague | 9 | 5 | 5 | 3 | vira `Arcana_Choose_` (seção 8) |
| Hemorrhage | 11 | 6 | 6 | 4 | |
| Realm of Death | 12 | 6 | 6 | 4 | |

## 4. Tokens

Regra: **o token custa o custo da carta que o gerou, menos 1** (mínimo 1). Ele já foi pago uma vez ao
conjurar a carta de origem; o custo evita valor dobrado de graça.

| Token | X | Nota |
|---|---|---|
| Withdraw · Mimic: Withdraw | 1 | |
| Mimic: Sigil of Malice | 1 | |
| Mimic: Ethereal Chains | 1 | hoje 2 no `CardDB` |
| Mimic: Distortion | 2 | hoje 3 no `CardDB` |
| Mimic (contêiner) | 2 | hoje 1. Reconjurar a última magia de dano por ação bônus vale mais que 1 |
| Zephyr Strike | 1 | |
| Recast Final Spark | 2 | hoje 1. **Sem custo no `UseCosts`** (é de graça sem SE, como o autor quer) |
| Doenças do Hemoplague | 1 | seção 8 |

## 5. Cartas EX

Regra: **N(EX) = min(6, N da base + 2)**, `X = N`. As EX **saem dos Arcane Shards** — os Shards estão fora
deste sistema.

| EX | N | X |
|---|---|---|
| Transfusion · Starcall | 3 | 3 |
| Death's Grasp · Lunar Aegis · Faceless: Rival's Mask | 4 | 4 |
| Evasive Flow · Flow State · Star Radiance | 5 | 5 |
| Storm Fists · Astral Fortitude · Hemoplague · Realm of Death · Mirror Image · Hostile Takeover | 6 | 6 |

Todas as EX são recebidas do nível 13 em diante, quando o slot já é de nível 6 — nenhuma fica impossível de
conjurar fora de combate.

## 6. Utilitárias (`Arcana_Util_`)

Nunca têm custo em Threads: em combate estão sempre bloqueadas.

Com 2 ou 3 slots por descanso curto, cobrar slot por Mage Hand arruinaria a exploração. Por isso:

| Custo 0 | Mage Hand · Comprehend Languages · Detect Supernatural · Dead Whispers · Friends · Faceless e todas as variantes · Arcane Lock · Arcane Unlock · Arcane Familiar (já é 1x/DC) |
|---|---|
| Com custo | Third Eye `ArcanaSpellSlot:1:2` · Third Eye: Projection `:1:3` · Dispel Magic `:1:3` · Arcane Gate `:1:5` |

## 7. Reações — recurso exclusivo e carta de ativação

**Problema:** hoje as magias das reações usam o prefixo `Arcana_Card_`. Se entrarem no deck, o jogador
**perde a reação sempre que a carta não estiver na mão**.

**Solução (decidida pelo autor em 2026-09-17):** cada reação ganha um **recurso exclusivo** e uma **carta de
ativação**.

| Peça | Regra |
|---|---|
| Recurso exclusivo | um por reação, `MaxValue 1`, **não acumula** |
| Fora de combate, e na **edição console** (sem SE) | o personagem tem o recurso normalmente, pela progressão — a reação funciona como hoje |
| Em combate, na **edição SE** | o Lua zera o recurso no início do combate; a reação fica indisponível |
| Carta de ativação (`Arcana_Reaction_`) | ao ser jogada, devolve o recurso a 1 — **uma vez por combate na prática**, porque o teto é 1 e jogar a segunda cópia não faz nada |
| Fim do combate | o Lua devolve o recurso ao máximo |
| Reações com recarga por turno (Hollow Image) | enquanto a ativação não for jogada, o Lua rezera o recurso no início de cada turno |

**Nomes padronizados:**

| Reação | Recurso | Carta de ativação | Magia da reação |
|---|---|---|---|
| Gale Deflection (Unbound 3) | `ArcanaReactGaleDeflection` (hoje `GaleDeflectMissiles_Charge`) | `Shout_Arcana_Reaction_GaleDeflection` | `Projectile_Arcana_Ability_GaleDeflection` (hoje `Card_`) |
| Instinctive Charm (Deceiver 5) | `ArcanaReactInstinctiveCharm` (**não existe hoje**) | `Shout_Arcana_Reaction_InstinctiveCharm` | `Target_Arcana_Ability_InstinctiveCharm` (hoje `Card_`) |
| Hollow Image (Deceiver 11) | `ArcanaReactHollowImage` (hoje `HollowImage_Charge`) | `Shout_Arcana_Reaction_HollowImage` | passiva, sem magia própria |

**Custo das cartas de ativação** (só Threads; não gastam ação nem ação bônus, como as cartas de energia):

| Carta | Desbl. | X | Por quê |
|---|---|---|---|
| Ativar: Gale Deflection | 3 | 2 | devolve uma reação que dura o combate todo |
| Ativar: Instinctive Charm | 5 | 2 | redireciona um ataque; hoje é 1x/reação, sem recurso |
| Ativar: Hollow Image | 11 | 3 | o recurso recarrega por turno, então vale mais |

Todas são **Unique** (1 cópia no deck): a segunda cópia seria carta morta.

**Pendências técnicas das reações:**
- `Interrupt_GaleDeflectMissiles_Return` custa `ArcaneEssence:1` — precisa de custo novo (sugestão: só o recurso da reação, sem custo extra).
- As versões EX das reações custam `ArcaneShards` — os Shards estão fora do sistema.

## 8. Escolhas — `Arcana_Choose_` (Hemoplague)

**Problema:** as 6 doenças (`Card_Hemoplague_FilthFever`, `_Mindfire`, `_Seizure`, `_SlimyDoom`,
`_BlindingSickness`, `_FleshRot`) usam o prefixo `Card_`, então o pool as trata como 6 cartas fantasmas.

**Solução (decidida pelo autor):**

| Peça | Nome | Papel |
|---|---|---|
| Carta principal | `Target_Arcana_Choose_Hemoplague` | N 5, X 5. Ao ser jogada, envenena o alvo e **abre a escolha**: o jogador escolhe uma doença |
| Tokens | `Target_Arcana_Token_Hemoplague_<Doença>` | a doença escolhida entra na mão como Conjured, custo 1 |

A escolha usa o mesmo padrão de contêiner que o Mimic já usa (`CardDB.containers`): a carta principal gera
um contêiner na mão e os filhos brilham junto.

*Em aberto:* a carta principal aplica o efeito **e** gera o token (duas coisas), ou só gera o token (a doença
é o efeito todo)? A segunda opção é mais limpa e deixa a carta principal mais barata (N 4, X 4).

## 9. Correções pendentes

| O quê | Decisão |
|---|---|
| **Arcane Recovery** | vira `Shout_Arcana_Util_ArcaneRecovery`: devolve **1 Woven Spell Slot, 1x por descanso longo**. Sai do deck |
| **Evasive Flow EX** | está sendo concedida no nível 4, antes da carta base. Era um teste do autor; corrigir para o nível 13 |
| **Howl of the Dead EX** | não existe versão base. Remover o sufixo `_EX` e mudar de posição — o autor quer que seja um truque (N 0) |
| **Recast Final Spark** | continua **sem custo no `UseCosts`** (edição sem SE) e custa **2 Threads** no `CardDB` (edição SE). A assimetria é intencional |
| **Magias das reações** | `Card_` → `Ability_` (seção 7) |
| **Doenças do Hemoplague** | `Card_` → `Token_`, com a carta `Choose_` (seção 8) |

## 10. O que muda nos arquivos

1. **Stats (`Spell_*.txt` / `.stats`):** trocar `ArcaneEssence:N` por `ArcanaSpellSlot:1:N` em todas as cartas,
   utilitárias com custo e tokens; zerar o custo das utilitárias de custo 0; ajustar o campo `Level` das
   cartas que mudam de nível (Mental Prison, Flow State, Evasive Flow, Thunderclap, Death's Aspect, Terrify).
2. **Renomear** as magias das reações e as doenças do Hemoplague, com backup e pelo mesmo caminho dos renames
   anteriores (`Backup/rename_*`).
3. **`ActionResourceDefinitions.lsx`:** renomear os dois recursos de reação e criar o do Instinctive Charm,
   todos com `MaxValue 1`.
4. **`Progressions.lsx`:** conceder os recursos de reação junto das passivas; adicionar as cartas de ativação
   nas listas de magia das subclasses.
5. **`CardDB.lua`:** `cost` de cada carta, tokens, contêiner do Hemoplague, marca `Unique` nas cartas de
   ativação.
6. **Lua:** categorias novas (`Reaction`, `Choose`) no `Const.PREFIX` e no `Pool`; zerar e restaurar os
   recursos de reação no `Flow` (início do combate, início do turno, fim do combate).
7. **Loca:** nomes e descrições das cartas de ativação (inglês primeiro).

## 11. Decisões em aberto

1. A carta de ativação da reação gasta alguma ação? A proposta é **não gastar nada**, só Threads.
2. A `Choose_Hemoplague` aplica o efeito e gera o token, ou só gera o token?
3. As reações EX (Gale Deflection EX, Hollow Image EX) precisam de custo novo, sem Shards.
4. Lunar Aegis, Astral Fortitude, Storm Fists e Thunderclap são os pontos onde o nível e o efeito ainda não
   batem. Precisam de conta caso a caso pelo Power Budget, não só da regra geral.
5. Os níveis aqui vêm da regra `⌈desbloqueio ÷ 2⌉` e de um julgamento do efeito. A conta completa
   (benefício ÷ custo) de cada carta ainda não foi feita.
