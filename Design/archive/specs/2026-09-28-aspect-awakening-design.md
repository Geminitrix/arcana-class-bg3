# Arcana — Despertar do Aspecto (a evolução de campeão)

Design aprovado em 2026-09-28. Inspirado no level-up de campeão do Legends of Runeterra: no LoR o
campeão é uma carta; aqui o campeão é a **subclasse**, e cada uma já tem a sua forma evoluída pronta —
o capstone de tarô ("You've become the Aspect of…"). Este documento transforma esse capstone, hoje uma
passiva fixa de nível 20, no clímax de cada combate.

| Subclasse | Arcano | Aspecto de… | Objetivo | Carta do Aspecto |
|---|---|---|---|---|
| Unbound | **0 – The Fool** | Curiosity | *Wanderlust* | Leap of Faith |
| Deceiver | **3 – The Empress** | Love | *Obsession* | Heartbreak |
| Starchild | **17 – The Star** | Hope | *Beacon* | Wish Upon a Star |
| Eternal | **13 – Death** | Sorrow | *Sorrow* | The Final Toll |

---

## 1. Decisões (todas do usuário, 2026-09-28)

| # | Decisão |
|---|---|
| D1 | **Híbrido.** O Despertar acontece dentro do combate e dura até o combate acabar. O nível do personagem decide **quão forte** é a forma desperta. |
| D2 | **Tiers I / II / III nos níveis 3 / 7 / 12, cumulativos** (eram 3 / 9 / 17 até 2026-09-29; mudou para quem joga até o 12). Um personagem nível 17 que desperta recebe I + II + III. Ninguém desperta nos níveis 1–2. |
| D3 | O Despertar entrega **três coisas**: o status do Aspecto (boosts do tier), a **carta do Aspecto** na mão e uma **transformação visual**. **Não** troca as cartas pelas `_EX` — as `_EX` seguem separadas (Refine no acampamento). |
| D4 | **Objetivo temático por subclasse**, contado no Osiris, então funciona nas duas edições. |
| D5 | **Os capstones de tarô viram o Tier III.** As passivas permanentes de nível 20 saem da progressão. |
| D6 | **Os efeitos ficam; a spell redundante é que muda** (§5). |
| D7 | Uma vez por combate. Depois de desperto, o contador para. |
| D8 | Eternal: **perder 30% do HP máximo no total**, num registro que a cura não desfaz (§7.1). |
| D9 | Unbound: marca de **1 turno**, meta **3**. O contador dura o combate inteiro (§4.1). |
| D10 | A Hostile Takeover EX **vai ser reformulada**; não entra nas contas deste documento. |

---

## 2. A estrutura comum

### 2.1 Tiers

| Tier | Nível | Por quê |
|---|---|---|
| I | 3 | A subclasse já tem o kit básico. |
| II | 7 | Meio do jogo, quando a subclasse já tem o kit principal. |
| III | 12 | O teto do jogo sem mod de nível 20; herda o antigo capstone. Os níveis 13–20 ficam para conteúdo futuro. |

A progressão de cada subclasse concede, nos níveis 3, 9 e 17, uma passiva **visível** por tier
(`Arcana_Passive_Aspect_<Arcano>_I/_II/_III`). Ela só descreve o que o tier dá; o efeito mora no status
desperto, que lê `HasPassive(...)` para ligar cada bloco de boosts. Isso resolve o tier pelo **nível de
Arcana** (a passiva vem da progressão da classe), não pelo nível total — importante em multiclasse.

### 2.2 O ciclo

1. **Contador.** Um status visível `ASPECT_PROGRESS_<ARCANO>` com `StackType Additive` +
   `StatusPropertyFlags FreezeDuration` — padrão vanilla (`RAGE_FRENZY_BURNOUT`, `BHAALS_BOON_SLAYER`).
   A duração é o progresso: aparece como "Awakening 1/3", "2/3". Todas as quatro metas são **3 passos**,
   para o jogador ler o progresso do mesmo jeito em qualquer subclasse. Some em `OnCombatEnded`.
2. **Avanço.** Cada subclasse soma passos pelo seu objetivo (§4). Só avança em combate, só com o Tier I
   (`HasPassive(..._I)`) e só se ainda não despertou.
3. **Despertar.** O Osiris lê `GetStatusTurns(_Char, "ASPECT_PROGRESS_<ARCANO>", _N)`; com `_N >= 3`,
   remove o contador e aplica `ASPECT_AWAKENED_<ARCANO>` (duração −1, `RemoveEvents OnCombatEnded`),
   que carrega os boosts dos tiers, o VFX e o `UnlockSpell` da carta.
4. **Carta.** Edição console: o `UnlockSpell` do status é a carta, com `Cooldown OncePerCombat`.
   Edição PC: o Lua vê o status e põe a carta na mão como `Created`, com destino Exile.
5. **Fim.** `CombatEnded` limpa contador, marcas, registros em DB e o status desperto.

Um goal Osiris por subclasse (`ARCANA_Aspect_Fool.txt`, `_Empress`, `_Star`, `_Death`) mais um comum
(`ARCANA_Aspect_Common.txt`) com o PROC de despertar e a limpeza. **Nenhum gatilho compara nome de
carta** (regra do projeto): quando precisar saber a carta, usa `DB_ARCANA_CardFamily` ou um status
técnico aplicado pelo próprio stats da carta.

### 2.3 A carta do Aspecto

- Prefixo `Created` (nunca entra no deck). Unique, destino Exile.
- **0 Threads e 0 Woven Spell Slot, mas gasta a ação normal** — assim é igual nas duas edições.
- O tier melhora os números da carta (via `HasPassive` do tier no próprio stats da carta).

### 2.4 Visual

Um VFX persistente por Aspecto no `StatusEffect` do status desperto, mais som de level-up no
`StatusEffectOnApply`. Escolha dos efeitos vanilla fica para a implementação.

| Aspecto | Direção visual |
|---|---|
| The Fool | redemoinho amarelo e folhas girando nos pés |
| The Empress | pétalas rosa e estilhaços de espelho, leve "eco" da silhueta |
| The Star | halo azul, pontos de luz orbitando ligados por linhas de constelação |
| Death | névoa verde-escura, cinzas caindo, batimento cardíaco |

---

## 3. As quatro evoluções

### 3.1 🍃 Unbound — 0 The Fool, Aspect of Curiosity

| | Efeito |
|---|---|
| **Objetivo — Wanderlust** | Acertar ataques desarmados em inimigos diferentes: 3 passos. Ver §4.1. |
| **Tier I** | +3 m de movimento; mover-se não provoca ataque de oportunidade; golpes desarmados causam +1d4 Trovão. |
| **Tier II** | O Zephyr Strike não gasta a Bonus Action, uma vez por turno; Vantagem em saves de Destreza; +1 Reação. |
| **Tier III** | +3 Destreza; +1 Reação; o primeiro ataque contra você em cada turno erra. *(O +10 de Iniciativa e o voo saem: a Iniciativa não faz nada no meio do combate e o voo já é do Untethered.)* |
| **Carta — Leap of Faith** | Rush no molde do vanilla `Rush_MAG_ZephyrFlash`: dispara até um ponto visível e faz um golpe desarmado no destino. Se o teste S3 permitir, também golpeia quem estiver no caminho; senão, quem estiver no caminho faz save de Destreza contra dano de Trovão, como no ZephyrFlash. |

As restrições de armadura/escudo do Unbound valem para todos os efeitos.

### 3.2 🩷 Deceiver — 3 The Empress, Aspect of Love

| | Efeito |
|---|---|
| **Objetivo — Obsession** | Detonar Sigils: cada detonação é 1 passo. |
| **Tier I** | Inimigos marcados com Sigil têm Desvantagem nos ataques contra você. |
| **Tier II** | Quando um Sigil seu detona, a marca passa para o inimigo **não marcado** mais próximo a até 6 m. **Uma vez por turno**, e nunca a partir de uma detonação do Heartbreak. |
| **Tier III** | +3 Carisma; somar o modificador de Carisma ao dano das magias Arcanas (a antiga `TheEmpress_EX_Tech_II`); **Beloved:** o primeiro inimigo que mira você em cada turno faz save de Sabedoria ou fica Charmed por 1 turno. *(Friends: Faux Amis sai — vira o upcast do Friends.)* |
| **Carta — Heartbreak** | Detona **todos** os seus Sigils ativos de uma vez; cada alvo detonado fica Charmed por 1 turno. |

### 3.3 🌟 Starchild — 17 The Star, Aspect of Hope

| | Efeito |
|---|---|
| **Objetivo — Beacon** | Cura **efetiva** em aliados ≥ nível de Arcana × 5 (cura em excesso não conta). 3 passos, um a cada terço da meta. Ver §4.3. |
| **Tier I** | Aliado que você cura ou em quem lança uma carta ganha +1d4 **Frio** (a lua) no próximo ataque. |
| **Tier II** | Curar um aliado reembolsa 1 Bonus Action dele (`RestoreResource`, no máximo 1 por aliado por rodada), e o próximo ataque dele também causa +1d4 **Fogo** (o sol). |
| **Tier III** | +3 Sabedoria; voo (a atual `Projectile_Arcana_Card_Ability_Fly_TheStarchild`, liberada pelo status); **Undying Hope:** reação, uma vez por combate — quando um aliado cairia a 0 HP, ele fica com 50% do HP máximo e ganha o THP do Lunar Wisp (nível de Arcana + 2× mod. de Sabedoria). |
| **Carta — Wish Upon a Star** | Aliados a até 18 m ganham Vantagem na próxima jogada de ataque ou de magia, dentro de 2 turnos. **Sem cura.** |

### 3.4 💀 Eternal — 13 Death, Aspect of Sorrow

| | Efeito |
|---|---|
| **Objetivo — Sorrow** | Perder, no total do combate, 30% do HP máximo. 3 passos, um a cada 10%. A cura não desfaz. Ver §4.4. |
| **Tier I** | A aura do **Darkness Rise** (`DARKNESS_RISE_AURA`: +50% de movimento, 10% do seu HP máximo em dano necrótico por turno nos inimigos da aura, movimento deles pela metade). |
| **Tier II** | Uma vez por combate, um dano que te levaria a 0 HP te deixa com 1 HP; um inimigo **isolado** a até 3 m — o único inimigo a 3 m de você e sem aliados a 6 m dele — tem Desvantagem nos ataques contra você. |
| **Tier III** | +3 Constituição; **Harvest:** quando uma criatura **hostil** morre a até 9 m, você ganha 1 ação extra (uma vez por turno; dura até o fim do seu próximo turno, para mortes no turno inimigo contarem). *(Howl of the Dead sai — vira carta de progressão.)* |
| **Carta — The Final Toll** | Um alvo sofre dano necrótico igual ao HP que você perdeu no combate, **limitado a 50% do seu HP máximo**. Quem morrer assim levanta como zumbi aliado. |

---

## 4. Como cada objetivo é contado

### 4.1 Wanderlust (Unbound) — desenho do usuário

- Uma passiva técnica oculta, no evento de ataque, filtra golpe desarmado e checa se o alvo **não** tem
  `WANDERLUST_MARK`. Se não tem: marca o alvo (status oculto, **1 turno**) e soma 1 turno ao contador
  `ASPECT_PROGRESS_FOOL` (Additive + FreezeDuration).
- O contador **não expira** durante o combate. A marca só impede contar o mesmo inimigo duas vezes **no
  mesmo turno**. Contra um chefe único, três turnos acertando o chefe despertam.
- Conta (2 golpes desarmados/turno no nível 3, 3 a partir do 5, ~65% de acerto): desperta no turno
  ~2–3 com vários inimigos e ~3 contra um chefe.
- **Teste S4:** a marca aplicada no turno do Unbound precisa sumir antes do turno seguinte dele.

### 4.2 Obsession (Deceiver)

A detonação do Sigil já existe (a `RemoveConditions` do `SIGIL`). A detonação aplica um status técnico
no Deceiver dono da marca (quem o `ARCANA_Status_Sigil.txt` já identifica, inclusive para marcas do
clone), e o Osiris soma 1 passo. 3 detonações ≈ turno 3; Mimic e clone aceleram.

### 4.3 Beacon (Starchild) — ideia do usuário

- As cartas de cura do Starchild aplicam em cada alvo um status técnico `BEACON_HEAL_TECH` (fonte =
  Starchild) antes do functor de cura. Serve para alvo único e para o Wish, que é Shout com vários alvos.
- O Osiris guarda o HP de cada aliado em combate (`DB_ARCANA_LastHP`, inicializado em `EnteredCombat`).
  Em `HitpointsChanged`, lê `GetHitpoints`; se subiu e o aliado tem `BEACON_HEAL_TECH`, soma a diferença
  em `DB_ARCANA_BeaconHealed(_Starchild, _Total)`. Sempre atualiza o `LastHP`.
- A meta (nível × 5) equivale a ~1,5–1,7 Astral Infusions em qualquer nível (L3: 15 vs 2d10 = 11;
  L9: 45 vs 5d10 = 27,5; L17: 85 vs 9d10 = 49,5). Como turno 1 raramente tem aliado ferido: turno 2–3.
- **Teste S1:** se `HitpointsChanged` dispara com cura e se o status técnico já está ativo quando o
  Osiris processa o evento. Se falhar, o plano B é contar cartas de cura lançadas em aliados.

### 4.4 Sorrow (Eternal)

- `AttackedBy(_Eternal, _, _, _, _Amount, _, _)` soma `_Amount` em `DB_ARCANA_SorrowLedger`. Cada 10%
  do HP máximo (`GetMaxHitpoints`) cruzado soma 1 passo.
- O **mesmo registro** é o dano do The Final Toll (limitado a 50% do HP máximo), aplicado com
  `ApplyDamage(..., "Necrotic", _Eternal)` como o `ARCANA_Status_Hemorrhage.txt` já faz.
- **Teste S2:** se o dano absorvido por THP (Indestructible) entra no `_Amount`.

---

## 5. Spells que mudam por redundância

| Subclasse | Spell | Conflito | Mudança |
|---|---|---|---|
| Unbound | **Evasive Flow** (`Shout_Arcana_Card_Spell_EvasiveFlow`) | Tier I já tira o ataque de oportunidade (`IgnoreLeaveAttackRange`) | Perde o sem-AdO. Vira: pular não gasta Bonus Action, e o próximo golpe desarmado neste turno tem Vantagem. O `_EX` segue a mesma troca. |
| Unbound | **Wind Whispers** | Tier II já dá Vantagem em saves de Destreza | Mantém a Desvantagem contra você; troca a Vantagem em Destreza por: quando um ataque erra você, você ganha `ZEPHYR_STRIKE`. |
| Deceiver | **Malicious Whispers** | Tier I já dá Desvantagem aos inimigos com Sigil | Num alvo com Sigil, ele também perde a Reação. |
| Deceiver | **Instinctive Charm** | Beloved já encanta o primeiro atacante | O ataque redirecionado ganha Vantagem. |
| Deceiver | **Friends: Faux Amis** | era do capstone | Vira o upcast do Friends. |
| Eternal | **carta Darkness Rise** | Tier I passa a ser o Darkness Rise | Vira **Blood Offering**: perde 10% do HP máximo (conta para o Sorrow) e a sua próxima magia necrótica causa dano extra. Números no passe de cartas. |
| Eternal | **Death Ward** | Tier II já salva o Eternal de 0 HP | Passa a mirar só aliados. |
| Eternal | **Howl of the Dead** | era do capstone | Vira carta de progressão (nível no passe de cartas). |
| todas | passivas `TheFool_EX`, `TheEmpress_EX`, `TheStar_EX`, `Death_EX` (+ `_Tech`, `_Unlock`) | viram o Tier III | Saem do nível 20 das quatro progressões. O conteúdo vai para o status desperto. |

Sem mudança, conferido: Storm Fists (soma com o +1d4 Trovão, mesmo eixo mas não redundante), Flow State,
Empty State, Star Radiance (tipo de dano diferente do Tier I), Starbreath (revive depois; o Undying
Hope impede antes), Transfusion (o lifesteal saiu do desenho).

---

## 6. Balanceamento

Princípio: na dúvida, errar para o fraco e subir no playtest.

| Risco | Conta | Mitigação |
|---|---|---|
| Corrente do Tier II do Deceiver em cascata | cada marca no nível 17 = 9d10 ≈ 49,5 | Uma vez por turno; nunca a partir do Heartbreak. |
| The Final Toll | com a cura realimentando o registro, passaria de 150 em alvo único no 17 (Disintegrate ≈ 75) | Teto de 50% do HP máximo: ~24 no nível 5, ~78 no 17. |
| Harvest em loop com os próprios mortos-vivos | zumbis e esqueletos do Eternal morrem e dão ação | Só criaturas hostis; 1 por turno. |
| Undying Hope | cura completa = a barra inteira de um aliado | 50% do HP máximo + THP do Lunar Wisp; 1 por combate. |
| Bonus Action do Tier II do Starchild | Astral Infusion é Bonus Action e poderia girar | Reembolso só (`RestoreResource`), 1 por aliado por rodada. |

### 6.1 Por que 30% no Eternal (Monte Carlo, 200 mil combates)

Suposições: 2 ataques por rodada no Eternal (3 no nível 17), AC 17/18/19, inimigos do nível, sem cura.

| Objetivo | L5 | L9 | L17 | Cai na rodada seguinte |
|---|---|---|---|---|
| Perder 20% no total | rodada 2,2 | 2,2 | 1,6 | ~0% |
| **Perder 30% no total** | **2,9** | **3,0** | **2,1** | ~1% |
| Perder 50% no total | 4,3 | 4,4 | 3,1 | 4–13% |
| Estar com ≤30% de vida | 5,6 | 5,9 | 4,0 | 33–56% |
| Estar com ≤20% de vida | 6,3 | 6,5 | 4,4 | 54–78% |

"Estar com X% de vida" ainda faria o Transfusion e o Indestructible **atrasarem** o Despertar. O
registro cumulativo deixa o kit de cura do Eternal livre, e o risco vem de precisar estar na frente.
Script: `scratchpad/eternal_sim.lua` da sessão de 2026-09-28 (Lua 5.4).

---

## 7. Testes antes da implementação completa

Um teste barato por dúvida, no jogo com SE **e** sem (o play mode do Toolkit roda sem SE).

| # | Pergunta | Se falhar |
|---|---|---|
| S1 | `HitpointsChanged` dispara com cura, e o `BEACON_HEAL_TECH` já está ativo quando o Osiris o processa? | Beacon passa a contar cartas de cura em aliados. |
| S2 | O `_Amount` do `AttackedBy` inclui dano absorvido por THP? | Aceitar como está (o Indestructible atrasa o Sorrow) ou somar o THP perdido à parte. |
| S3 | Um Rush aceita rolagem de ataque desarmado por alvo no caminho? | Caminho com save de Destreza, golpe só no destino. |
| S4 | A marca de 1 turno some antes do próximo turno do Unbound? | Remover as marcas no `TurnStarted` do Unbound pelo Osiris. |
| S5 | O Osiris acha o inimigo não marcado mais próximo (`GetDistanceTo` + `IsEnemy` sobre quem está no combate)? | "Um inimigo não marcado a até 6 m", sem garantir o mais próximo. |
| S6 | Existe interrupt para "aliado cairia a 0 HP" (Undying Hope)? | Status preventivo no estilo Death Ward, aplicado ao despertar. |
| S7 | A condição de "inimigo isolado" funciona como boost do Eternal ou precisa de aura no inimigo? | Aura de 3 m que aplica ao inimigo isolado um status de Desvantagem contra o Eternal (`HasAllyWithinRange`/`HasEnemyWithinRange` do vanilla). |

**Critério de sucesso no playtest:** mediana do Despertar **no turno 3** em cada subclasse, e o
Despertar acontecendo em pelo menos 3 de cada 4 combates que passem de 4 turnos.

---

## 8. Fora do escopo, anotado

- **Hostile Takeover EX** vai ser reformulada (D10).
- **Stellar Anchor** repete a Vantagem em concentração do **Arcane Avatar** — redundância que já existe.
- **Darkness Rise, texto do status inimigo:** dizia 5%, o functor é `MaxHP/10`. Corrigido para 10% no
  **inglês**, o idioma base, em 2026-09-28 (backup `Backup/darknessrise_text_20260928`). As outras 15
  línguas ainda dizem 5% e entram na rodada de localização futura. Não verificado no jogo: se o `MaxHP`
  do functor é o do Eternal (a leitura adotada, coerente com o texto da aura) ou o do inimigo.
- Tabela `Starbreath_Heal` vazia do 13 ao 20.
- Números da Blood Offering e nível da carta Howl of the Dead: passe de cartas.

---

## 9. Notas de implementação (2026-09-28)

Implementado pelo plano `Design/Rework/plans/2026-09-28-aspect-awakening.md`. Decisões tomadas durante o
plano, que ajustam as seções acima:

- **Undying Hope é automático** (decisão do usuário): no Despertar com Tier III, os aliados do combate
  recebem `UNDYING_HOPE` (`DownedStatus`, o padrão do Death Ward do vanilla). O primeiro que cairia volta
  com metade do HP e o THP do Lunar Wisp, e a proteção some dos outros.
- **Friends: Faux Amis e Howl of the Dead** entram nas listas de nível 13 do Deceiver e do Eternal
  (decisão do usuário).
- **Blood Offering** (nível 3, Bonus Action): perde 1/10 do HP máximo e as cartas causam
  +`DeathsGrasp_Damage` necrótico até o fim do turno. Números iniciais, para o passe de cartas.
- **Mourning** (Tier II do Eternal) usa status próprio, `ETERNAL_UNDYING`, e não o `DEATH_WARD` do
  vanilla, para a limpeza no fim do combate não tirar um Death Ward de outra fonte.
- **Fool's Luck e Beloved** são interrupts gatados por recursos que recarregam no turno
  (`ArcanaFoolsLuck`, `ArcanaBeloved`). O Beloved reage a ataques, não a magias de save.
- **O progresso é contado numa DB do Osiris** (`DB_ARCANA_Aspect_Steps`); o status com `FreezeDuration`
  só mostra o número. Assim o objetivo não depende de o motor empilhar duração na mesma hora.
- **Moonlit e Sunlit** duram 2 turnos, até o próximo ataque. A marca de zumbi do Final Toll
  (`CRAWLING_GNAW_SWITCH`) dura 1 turno, então quem sobrevive não vira zumbi depois.
- **Leap of Faith** é um Rush filho do `Rush_SpringAttack`, com rolagem de ataque desarmado em cada alvo
  do caminho (o `Rush_Rush` do vanilla prova o `Attack()` por alvo), e dá o Zephyr Strike ao chegar.
- **VFX:** HASTE (Fool), BLUR (Empress), BLESS (Star); Death usa a aura do Darkness Rise. O som de
  level-up ficou para depois.
- **Voo da The Star:** o Tier III libera o `Projectile_Fly_Spell` do vanilla; a antiga
  `Projectile_Arcana_Card_Ability_Fly_TheStarchild` foi apagada.

Guia de teste no jogo: `Design/Rework/plans/2026-09-28-aspect-teste-no-jogo.md`.

### Correções de 2026-09-29 (primeiro teste do Deceiver)

- **Tiers passaram para 3 / 7 / 12** (D2). As linhas de 9 e 17 ficaram sem passivas de tier.
- **Sigil:** a marca só detona (dano + contador do Obsession) quando sai por `RemoveCause(StatusRemoveCause.Condition)`.
  Antes, morte, tempo esgotado e dispel também disparavam o dano, e poderiam contar como detonação.
- **Heartbreak:** aplicar status não detona o Sigil. A condição `IsArcanaSpell()` não enxerga a magia de origem
  num status aplicado, só em dano. O Heartbreak agora causa `D4Cantrip` psíquico em cada marcado (detona) e só
  depois encanta quem sobreviveu.
- **Beloved:** faltava o `Counterspell()`. Agora segue o molde do Instinctive Charm: cancela o ataque, encanta e
  devolve ao atacante um ataque extra para ele mirar outro alvo.
- **Progresso em porcentagem** (Starchild e Eternal, a pedido do usuário): o status de progresso mostra de 1 a 99, a
  porcentagem da meta (cura efetiva ÷ nível × 5; HP perdido ÷ 30% do HP máximo), e com 100 o Aspecto desperta.
  Fool e Deceiver continuam contando 1, 2, 3. `PROC_ARCANA_Aspect_Percent` no goal comum.
- **Starchild reforçado (2026-09-29)**, a pedido do usuário. Moonlit/Sunlit valem para o próximo ataque que acertar,
  dentro de 2 turnos, e o efeito sai pela passiva que o status dá ao aliado (dano + efeito + remove o status num passo).
  Tier I: Moonlit +1d4 Frio e `RAY_OF_FROST`. Tier II: Moonlit 2d4 e Sunlit +1d4 Fogo e `BURNING` 2 turnos.
  Tier III: Sunlit 2d4 e `STAR_ECLIPSE` (resistência a Frio e Fogo, 2 turnos). Saíram o voo do Tier III e a
  recuperação de Bonus Action do Tier II (`STAR_REFRESHED` apagado).
- **Cartas do Aspecto** continuam liberadas desde o Tier I nas quatro subclasses (decisão de balanceamento de
  2026-09-29: o objetivo já é o custo, e é 1 uso por combate). Se alguma ficar forte, reforça-se por tier.
- **Beacon:** o HP sobe antes de o `BEACON_HEAL_TECH` chegar (provado no osirislog); a subida fica pendente
  (`DB_ARCANA_StarPending`) e o status credita o pendente.
- **Undying Hope sem THP** (2026-09-29, a pedido do usuário): o aliado salvo só recupera metade do HP. O THP do
  Lunar Wisp aplicado pelo Osiris sumia logo em seguida, e a própria cura do Starchild já dá o Lunar Wisp.
  Starchild fechado no teste do usuário (Tiers I–III, Beacon em porcentagem, Moonlit/Sunlit/Eclipse).
- **Wanderlust por rodada** (2026-09-30, a pedido do usuário): acertar inimigos diferentes numa mesma rodada (do
  início do turno do Unbound ao início do próximo, então reações contam). Meta 3 / 4 / 5 pelo tier. Com menos
  inimigos vivos que a meta no início do turno, todo acerto conta. Qualquer ataque que acerte conta (desarmado,
  Zephyr, Gale Deflection, ataque de magia). A passiva do Tier I marca o inimigo com `WANDERLUST_HIT_TECH`; o
  Osiris guarda a rodada (`DB_ARCANA_WanderHit/Count/Goal/Foes`). `WANDERLUST_MARK` foi apagado.
- **2026-09-30, a pedido do usuário:** metas do Wanderlust reduzidas para **2 / 3 / 4** (errar um ataque já custava a
  rodada). Nova passiva só de UI por subclasse, `Arcana_Passive_Aspect_<Arcano>_Awakening` ("0 - The Fool:
  Awakening" etc.), dada no nível 3, com o objetivo (no Fool, por faixa de nível); os tiers descrevem só os bônus.
  O Flow State (e o EX) também aplica `ZEPHYR_STRIKE`; a carta do Zephyr passou a se chamar "Zephyr Strike".
- **Unbound, 2026-09-30 (teste do usuário):** o `WIND_WHISPERS` durava só até o fim do próprio turno (`EndTurn`, 1) e nunca
  estava ativo no turno do inimigo; agora `StartTurn`. O revide virou a reação automática `Interrupt_Arcana_WindWhispers_Riposte`
  (molde do Riposte do vanilla) com o golpe auxiliar `Target_Arcana_WindRiposte` (sem custo, não é carta). O Zephyr agora
  vem de golpe desarmado **ou de qualquer carta Arcana ou True Strike** (`Arcana_Passive_FlowingStrikeZephyr`). Durações:
  Storm Fists 3, Thunderclap 5, Flow State 5 (EX sem mudança; vão ser refeitas). Texto do THP do Flow State = nível × 2.
