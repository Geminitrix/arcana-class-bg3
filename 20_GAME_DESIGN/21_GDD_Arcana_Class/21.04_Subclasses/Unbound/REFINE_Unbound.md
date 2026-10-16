---
id: 21.04/Unbound/REFINE_Unbound
owner: Lead Class Designer (with the Balance Designer)
status: proposal — in progress (steps 1–4 and kit directions; direction A + Beaufort ranks chosen, WB3–WB43; SG1–SG16 approved); nothing here is a decision until it is logged in DECISIONS.md
ticket: ARC-0022
created: 2026-10-16
variant: subclass (full)
sources: 21.04/_SUBCLASS_STANDARD.md v2.1, 21.04/_SUBCLASS_REFINING.md, 05.00, 05.02/Unbound.md, game files via dump_progression.pl (2026-10-16), 21.08, 31.01 §3–§6, 10.06/Open_Questions.md, 22.06 §1, ARC-0021
---

# The Windborn (Unbound) — design review

> A **proposal**. It audits the subclass as it is in the game today and offers kit directions; the Owner decides,
> and each answer becomes a `WB#` line in `DECISIONS.md`. Numbers: placeholders `‹…›` only (ADR-0005). There is no
> `21.03`, `22.05`, `26.01` or `25` entry for the Unbound yet.

## 1. Frame

- **Variant:** subclass, full review. Internal name Unbound, display name **Windborn** (WB0).
- **Already decided:** WB0 name · WB1 monk-like Air Nomad, cards that enable passive states by design · WB2 axis
  **Position** · Tier III ability bonus goes away (`10.06`, 2026-10-08) · the subclass needs an ultimate (`10.06`, K3).
- **Open:** the mechanic (state + one rule), ultimate, Awakening tiers, level map, names, numbers.

## 2. The current state (game, 2026-10-16)

- **Core rule today:** *every unarmed attack or Arcane card grants a Zephyr Strike as a bonus action.*
- **Kit:** see `05.02/Unbound.md` §5–§8 (matches the game; only defect found: list name `Unboung Level 7`).
- **Gears:**

| Creates | Changes | Spends | Reads |
|---|---|---|---|
| every unarmed attack, every card, True Strike | Flow State (+bonus action), Restless Wind (one free Zephyr per turn) | Zephyr Strike | — (empty) |

## 3. Audit (Depth Model)

WB1 applies: a monk-like kit and cards that enable passives are not marked as flaws (K2, K4, K5).

| DM | Mark | Evidence |
|---|---|---|
| I1 | 🧪 | No playtest |
| I2 | ⚠️ | "Punches a lot and runs fast" — describable, but says nothing the Monk doesn't |
| I3 | ✅ | Wandering air monk shows in speed, jumps, unarmed kit |
| I4 | ❌ | Aspect is Curiosity; the core rule is action economy. Only the Awakening goal (different enemies) reads as curiosity |
| I5 | ❌ | `21.08` Axis row `❓`; WB2 sets Position, the current mechanic doesn't ask it |
| I6 | ⚠️ | *Feather Fall* is a vanilla spell name; *Twinkle Toes* is off the `31.01` register |
| I7 | ⚠️ | Optimal play is "attack, Zephyr" every turn; moving is a passive bonus, not a decision |
| I8 | ⚠️ | Every tooltip repeats "Afterwards, you can make a Zephyr Strike"; game text still says Unbound |
| S1 | ⚠️ | Card ↔ fantasy is clear (the leap, the road); card ↔ core rule is not |
| S2 | ⚠️ | Used: leap (Leap of Faith), traveller (speed), cliff (falling). Unused: the dog, the bindle, the white rose, number 0, Air |
| S3 | ✅ | Aang and the Air Nomads |
| S4 | ⚠️ | No character → feature table |
| S5 | ❌ | No real model |
| S6 | ❌ | No myth |
| S7 | ❌ | No reading cited to a primary source |
| W1 | ✅ | `31.01` §5 class text ("the first step of every journey") |
| W2 | ⚠️ | One Weave text (Ready: Gale Deflection, "pull a thread of wind") |
| M1 | ⚠️ | `ZEPHYR_STRIKE` is exclusive but is a permission token; nothing builds or reads it |
| M2 | ⚠️ | One sentence, on Flowing Strikes: Zephyr — then repeated on every card |
| M3 | ❌ | Reads column empty (§2) |
| M4 | ⚠️ | Level 9 plays like level 3 with more attacks and bigger numbers |
| M5 | ❌ | Allies take no part; not recorded as a choice |
| M6 | ✅ | Zephyr chains are bounded by bonus actions |
| M7 | ⚠️ | True Strike (vanilla) and Gale Burst's free strike behave outside the rule |
| K1 | ⚠️ | Cards append Zephyr but don't drive it |
| K2 | ✅ | WB1 |
| K3 | ❌ | No ultimate |
| K4 | ✅ | WB1 — mobility and evasion passives carry the identity |
| K5 | ⚠️ | Card-enabled rules (Riposte, Reverberation, Deflection) ✅; level passives are numbers (Twinkle Toes, Feather Fall) |
| K6 | ✅ | Zephyr bonus action and unarmed fallback from level 1 |
| K7 | ❌ | No ultimate |
| P1 · P2 | ✅ | Melee, mobile, specialist striker |
| P3 | ❌ | Nothing acts on allies' turns |
| P4 · P5 | ✅ | Playable at level 1; payoff immediate |
| P6 | ⚠️ | Choice of target matters only for the Awakening |
| P7 | ✅ | Zephyr card in hand; Awakening countdown (ARC-0007) |
| P8 · P9 · P10 · P11 | ✅ | No cooperation needed; armour weakness visible; no SE; armour rule is a chassis choice |
| P12 | ✅ | Zephyr is a created card, not drawn |
| J1 · J2 | ⚠️ | Many level-ups are only numbers (Twinkle Toes, Feather Fall) |
| J3 | ❌ | Zephyr Strike never ranks up |
| J4 | ⚠️ | Level 3 brings ~5 concepts (3 cards, Awakening, Deflection resource) |
| J5 | ✅ | Eye of the Storm / Momentum taught with their cards |
| J6 | 🧪 | Tier III needs 5 different enemies in one round (fallback when fewer stand) |
| J7 | ❌ | No arc |
| J8 | ⚠️ | All content on odd levels; 2, 6, 10 empty |
| A1 | ⚠️ | Counts hits on different enemies — any striker reaches it; not the Zephyr mechanic |
| A2 | ❌ | Tier III +3 DEX (forbidden, §7); Tiers I–II mostly numbers |
| A3 | ⚠️ | Leap of Faith plays the Awakening goal well; no ultimate to differ from |
| B1 · B2 · B4 | 🧪 | No `22.05` report |
| B3 | ✅ | Bounded by bonus actions |
| B5 | ❌ | "Use Zephyr?" is always yes |
| B6 | ⚠️ | Flow State up to 6 turns, Storm Fists and Thunderclap 5, against T = 4 (`22.06` §1) |
| B7 | ➖ | No carried resource |
| X1 | ⚠️ | ~12 subclass buttons by 12; Storm Fists / Thunderclap and Wind Whispers / Evasive Flow overlap |
| X2 | ✅ | Deflection uses and Awakening progress are counters |
| X3 | 🧪 | No playtest |
| T1 · T2 | ✅ | Stats + Osiris (`ARCANA_Aspect_Fool.txt`), built |
| T3 | ⚠️ | Twinkle Toes (12) and Feather Fall (5) hand-made; no generator in `82_Automation/stats/` |
| T4 | ⚠️ | `Unboung Level 7`; id `Weightless_*` shown as Feather Fall |
| D1 · D2 | ❌ | No Identity Sheet; no dossier until ARC-0022 |

## 4. Sources on the table (to cite in S7)

| Source | What it offers | Primary text |
|---|---|---|
| The Fool, Rider–Waite–Smith | Youth at the cliff edge looking up, white rose, bindle, small dog, sun; 0; upright beginnings and the leap, reversed recklessness | Waite, *The Pictorial Key to the Tarot* (1910) |
| The Fool, Thoth | Atu 0 attributed to **Air** (letter Aleph) — the primary-source link for the wind | Crowley, *The Book of Thoth* (1944) |
| Aeolus' bag of winds | The crew opens the bag out of **curiosity** and every wind breaks loose — Curiosity + wind in one image | Homer, *Odyssey* X |
| The Anemoi | Four winds, four directions; Zephyrus already names Zephyr Strike | Hesiod, *Theogony* |
| Hermes | Traveller, roads, winged sandals, guide between places | *Homeric Hymn to Hermes* |
| Beaufort scale | Wind force **0 (Calm) to 12 (Hurricane)** — the Fool is 0, the journey ends at level 12 | Beaufort scale (Met Office) |
| Aang / Air Nomads | Air scooter, glider, deflection, redirecting the enemy's force, circular motion, detachment, Appa and Momo (the Fool's animal companion), the Avatar State | *Avatar: The Last Airbender* |

## 5. Kit directions (for the Owner's choice)

Each keeps WB1 (cards that switch on passive states) and WB2 (Position), and is judged by what it fixes in §3.

### Direction A — The Open Road *(recommended)*

- **Fantasy:** "Never the same foe twice — the wind carries you to the next one."
- **State:** **Windswept**, a mark on each enemy you strike, until your next turn.
- **Core rule:** *Striking an enemy that isn't Windswept marks it, and the wind carries your next strike: Zephyr Strike
  against an unmarked enemy comes with a free dash of ‹…› m.*
- **Gears:** creates — any hit on a new enemy, Leap of Faith (a whole path at once) · changes — cards that move marks or
  enemies (Gale Burst, Wind Blast push a Windswept enemy into another) · spends — the ultimate · reads — Zephyr (new
  target or not), cards that scale with Windswept enemies, the Awakening.
- **Ultimate — "Aeolus' Bag" (placeholder name):** release every wind at once; each Windswept enemy is struck by a gust
  (damage and push ‹…›). Reads how many and where (K7). Leap of Faith builds the marks, the Bag spends them (A3).
- **Allies:** a Windswept enemy can't make opportunity attacks against allies, or allies who start next to one gain
  ‹…› m (the wind clears the way) — P3, M5.
- **Fixes:** I4 (curiosity = always the new), I5/I7 (the path is the decision), M3, K3/K7, B5 (Zephyr on a marked enemy
  is a real "no"), A1 (the Awakening already counts this). **Cost:** weak in a duel (the current fallback rule stays).
  **Feasibility:** the per-round "different enemies" tracking exists (ARC-0007); the free dash is T2.

### Direction B — Beaufort Force

- **Fantasy:** "The wind rises with every step, until it is a hurricane."
- **State:** **Wind Force** on yourself, 0 to a cap equal to your Windborn level (the Fool starts at 0, Calm).
- **Core rule:** *Moving to a new foe, jumping and dodging raise your Force; each card and Zephyr Strike is stronger in
  higher bands (Breeze, Gale, Storm, Hurricane), and Force dies down when you stand still.*
- **Fixes:** S5 (a real model with 13 steps for 12 levels), J2/J3 (the cap *is* the level), K7 (the ultimate needs
  Hurricane). **Cost:** it is an **Accumulation** meter wearing Position clothes — WB2 holds only if the feed is
  positional; "standing still" can't be measured without SE, so the decay is by turn (T2).
- **Best use:** as the **rank ladder** of A's signature button (Zephyr at Breeze / Gale / Storm / Hurricane) rather
  than as the core.

### Direction C — Currents

- **Fantasy:** "Aang's trails of air: you leave paths of wind on the field, and everyone rides them."
- **State:** **Currents**, small wind zones left where you strike or land.
- **Core rule:** *Moving through a Current costs no movement and provokes nothing — for you and your allies; an enemy in a
  Current is Off Balance.*
- **Ultimate:** every Current converges into one vortex that pulls enemies in, stronger for each Current (K7).
- **Fixes:** I5 at its purest (the field itself), P3/M5 strongly (party mobility), §8.4 (plugs into surfaces: a
  Current blows clouds away, fans flames). **Cost:** bodies on the field drift toward the Veilwalker's Presence axis;
  zones are effort **L** (T2: a placeable zone and its rules); more to read on screen.

### Recommendation

**A as the core, B's Beaufort bands as the ranks of the signature button, one piece of C for allies if A's ally rule
is not enough.** A turns what the subclass already rewards (different enemies) into the mechanic, so it is the
cheapest way to fix I4, I5, M3, K3 and B5 together; B gives the journey its spine; C is the strongest but costliest.

## 6. Next steps

Owner picks a direction → mechanic rules (§4.5) → ultimate → Awakening tiers → level map (§6) → suggestions SG# for
the cards and passives that stay, change or go → names → balance pass.

## Appendix — rush animations available (vanilla, read 2026-10-16)

| Rush | Where | Animation set | Notes |
|---|---|---|---|
| `Rush_SpringAttack` | `Shared/.../Spell_Rush.txt` | starts `8b8bb757…`, ends `7bb52cd4…` | Rush to one target and strike. Used by the mod's Leap of Faith (speed `60000`, radius `18`) and by vanilla **`Rush_MAG_ZephyrFlash`** (`GustavDev/.../Spell_Rush.txt`, the same animation, Thunder damage, `Force(2)`, clears clouds; granted by `MAG_TheThorns_Trident`, `Weapon.txt`) |
| `Rush_ForceTunnel` | `Shared/.../Spell_Rush.txt`; a tadpole power (`GLO_Tadpole_PostEA.txt`) | its own set, starts `b94b9184…` | Player-usable; dashes along a line and pushes what is in it (`Force(4)`, `AddFallDamageOnLand`). Psionic VFX — effects are separate fields and can be swapped |
| `Rush_Rush` | `Shared/.../Spell_Rush.txt` | starts `eae21eb0…`, ends `e6a25c4b…` | The generic weapon Rush Attack |
| `Rush_Primal_Stampede` | `Shared/.../Spell_Rush.txt` | own middle (`b282bbfb…`) | Not checked on a humanoid |
| `Rush_Charge_Minotaur` | `Shared/.../Spell_Rush.txt` | creature set | Not for a humanoid |

Wind VFX sources to look at in the Toolkit (effects, not animations): `Shout_Dash_StepOfTheWind`,
`Zone_MAG_WindRider_GustOfWind`, `Zone_MAG_ZephyrBreak`. Not checked: whether a Rush provokes opportunity attacks, and
how it paths around obstacles — a probe (T2).

## Appendix — the four winds (Owner's idea, 2026-10-16; WB11)

Myth: the Anemoi (Hesiod, *Theogony*; Homer). In *Odyssey* X Aeolus binds every wind in the bag but leaves **Zephyrus**
free to carry Odysseus home — the wind of Zephyr Strike. BG3 has no compass: the directions are names, not map
directions. Proposal (values ‹…›; the bane falls on Windswept enemies — WB12):

| Wind | Domain | Allies | Enemies | Myth |
|---|---|---|---|---|
| Boreas · North | Movement | +‹…› m movement | −‹…› m movement | Cold, strong; the winged Boreads |
| Notus · South | Protection | ranged attacks against them have Disadvantage | −‹…› on saving throws | Storm, rain, fog |
| Eurus · East | Attack (melee and ranged) — joins at Gale (WB15) | +‹…› attack rolls | −‹…› attack rolls | The restless, unlucky wind |
| Zephyrus · West | — not in the bag (WB15): it is Zephyr Strike | — | — | The gentle wind left free to carry Odysseus home |

Placements weighed: (A) a prevailing wind drawn at combat start, turnable once per combat; (B) the ultimate opens the
bag and chooses — **chosen (WB11)**; (C) the three bagged winds wake with the Awakening tiers. Feasibility: the mod's
Osiris uses `EnteredCombat` / `CombatEnded`; vanilla Osiris uses `Random(N,_Var)`; vanilla aura `AURA_OF_PROTECTION`.
Bounded accuracy: a flat attack bonus for the whole party is a large lever (standard §8.3) — balance pass.

## Synthesis — the mechanic as decided (WB3–WB18)

**Core rule (one sentence, taught once):** *the wind marks every enemy you touch; Zephyr Strike carries you to the ones
it hasn't touched yet, and Aeolus' Bag releases what it has gathered.*

**Rules**
- **Windswept** (WB8, WB9): any hit of yours, or any failed save against your effects, marks the enemy until the end of
  your next turn. A Windswept enemy can't make opportunity attacks (WB10).
- **Zephyr Strike** (WB4–WB6, WB16–WB18): against an unmarked enemy it is a Rush (`Rush_SpringAttack` animation);
  against a marked one, a plain strike; when everyone is marked, no Rush. Ranks: Breeze 1 · Gale 4 (push; Eurus joins
  the bag) · Storm 8 (one more Rush to another unmarked enemy) · Hurricane 12 (the bag releases two winds).
- **Aeolus' Bag** (WB11–WB15): bonus action, from level 2; needs one mark; choose a wind (Breeze: Boreas, Notus; Gale:
  + Eurus); it blows for X turns, X = marks when opened, capped by the rank; the bag stays shut while it blows; opening
  clears every mark, and while it blows the wind sweeps every mark at the start of your turn (WB23); the boon is for
  allies, the bane falls on Windswept enemies.
- **Awakening** (WB22): counts the marks the wind releases (opening and sweeps), cumulative in the fight.
- **Leap of Faith** (WB7): `Rush_ForceTunnel` animation.

**Gears (standard §4.3)**

| Creates | Changes | Spends | Reads |
|---|---|---|---|
| any hit; failed saves vs your cards; Leap of Faith's path; reactions that hit | Gale push and Wind Blast (move marked enemies); Storm's second Rush | Aeolus' Bag (clears all) | Zephyr (Rush or not); Open Path; the Bag (X, the bane's targets); the Awakening (to decide) |

**Worked example (level 4, Gale; four enemies — two goblins on an ally, an orc mid-field, an archer on a roof)**

| Turn | You | State after |
|---|---|---|
| 1 | Wind Blast — goblins and orc fail → marked. Zephyr (after the card): Rush to the archer, Gale push off the roof → marked | 4 marked |
| Allies | The fighter leaves the goblins with no opportunity attack (Open Path) | 4 marked |
| 2 | Punch goblin 1 (already marked). Bonus action: open the Bag — X = 4, capped by Gale ‹…›; choose Eurus (allies +attack) | 0 marked; Eurus blows |
| 3 | Punch the orc → marked, suffers Eurus's bane. Zephyr: Rush to goblin 2 (unmarked) → marked | 2 marked |

Checked against the rule sentence: every mark comes from a touch, every Rush goes to an untouched enemy, the Bag releases
what was gathered. No exception.

## Suggestions — the existing cards and passives against WB1–WB26 (proposal)

Every piece must touch a gear (create / change / spend / read the mark) or carry the identity (WB1). Values ‹…›.

| SG | Piece (today) | Proposal | Why (DM) |
|---|---|---|---|
| SG1 | Flowing Strikes: Zephyr (L1) | **Rewritten as the core passive**: Windswept + Zephyr's Rush, taught once; cards drop "Afterwards, you can make a Zephyr Strike" from their tooltips | M2, I8 |
| SG2 | Gale Burst (L1) | **Keep**; drop its "free unarmed strike" (the Zephyr already follows it) | M7 |
| SG3 | True Strike (L1, vanilla) | **Retire** from the subclass: the unarmed strike is the fallback (K6), the base class has its cantrips; removes the vanilla exception to the Zephyr rule | M7, X1 |
| SG4 | Wind Blast (L3) | **Keep** — the wide marker (a line of failed saves) and a push | M3 |
| SG5 | Flow State (L3) | **Keep**, moved to L6; THP + one extra bonus action (Rush and the bag in one turn before Tier I); duration ≤ the reference fight | B6, J8 |
| SG6 | Ready: Gale Deflection (L3) | **Keep** (Aang's deflection); the returned missile marks; option: it can protect an ally within ‹…› m | K4, P3 |
| SG7 | Wind Whispers (L5) | **Keep**, absorbs Evasive Flow's Advantage: Disadvantage on attacks against you, Riposte (marks) | X1 |
| SG8 | Storm Fists (L7) + Thunderclap (L11) | **Merge into Storm Fists**: extra Thunder on unarmed hits **against enemies that weren't Windswept** (the reward for the new) | K7-like reading, X1 |
| SG9 | Untethered (L9) + Eye of the Storm | **Keep Untethered** (the glider, verticality); Eye of the Storm's AC folds into it | X1, K4 |
| SG10 | Evasive Flow (L9) | **Retire** — the Rush already carries you; its Advantage goes to Wind Whispers | X1, B5 |
| SG11 | Momentum (L11) | **Retire** with Thunderclap (L11 is the capstone) | X1 |
| SG12 | Leap of Faith (ex-Aspect card) | **Keep as a card** at L10, once per Short Rest: the path rush that marks a line — the Fool's leap stays in the kit | S2, J8 |
| SG13 | Twinkle Toes (L1→20) + Feather Fall (L5→12) | **Merge into one passive** (name ‹…›, not a vanilla name): speed, jump and falling grow **with Zephyr's ranks** (1/4/8/12), announced at each rank; from a generator table | I6, J2, T3 |
| SG14 | Be the Leaf (L1) | **Keep** with AC = 10 + DEX + INT (WB21) | — |
| SG15 | Flowing Strikes: Agility, Precision (L1); Flowing Assault (L5); Magic Strikes (L7) | **Keep** — the monk chassis | K4 |
| SG16 | Empty State (L12) | **Keep**, moved **to L9** with Untethered (L12 already holds Tier III and Hurricane) | J4, J8 |

### Proposed level map (with headlines)

| Lvl | Arrives | Headline |
|---|---|---|
| 1 | Windswept + Zephyr (Breeze), Be the Leaf, Flowing Strikes, the movement passive (rank 1), Gale Burst | "The wind marks what I touch and carries me to the rest" |
| 2 | Aeolus' Bag (Boreas, Notus) | "I can open the bag" |
| 3 | Tier I (free first Rush) + The Calm; Wind Blast | "My Aspect wakes; I can stop the wind" |
| 4 | Gale rank: push, Eurus, longer wind, movement rank 2 | "My Zephyr pushes; a new wind" |
| 5 | Flowing Assault (Extra Attack); Wind Whispers | "Two strikes; the air warns me" |
| 6 | Flow State; Ready: Gale Deflection | "I flow; I turn arrows back" |
| 7 | Tier II (allies mark); Magic Strikes; Storm Fists | "The party carries my wind" |
| 8 | Storm rank: second Rush, longer wind, movement rank 3 | "The wind doesn't stop" |
| 9 | Untethered; Empty State | "I fly; blows barely touch me" |
| 10 | Leap of Faith | "I leap through them all" |
| 11 | Where the Winds Meet (capstone) | "I gather the battlefield" |
| 12 | Tier III (sweeps push) + Hurricane (two winds), movement rank 4 | "The storm" |

## Balance pass — proposal (2026-10-16, awaiting Owner approval; values go to `25` only after it)

Currency `22.06` (1 point = 1 expected damage on one target). Assumptions (`22.06` §1): T = 4 turns, E = 4 fights;
A = 4 / 8 / 11 at T1 / T2 / T3; p(hit) 0.65 / 0.65 / 0.70; allies = the Windborn + 3. Winds are costed per turn of wind
for the whole party; a wind blows ≈ 2.5 turns per fight (opened on turn 2, reopened when it stops).

| Knob | Proposal | Arithmetic | Verdict |
|---|---|---|---|
| Zephyr Rush range | Breeze 9 m · Gale+ 12 m | Built-in dash, no opportunity attack ≈ +0.3A per Rush (`22.06` §4); ~60% of Zephyrs find an unmarked target | In band; 12 m is vanilla Zephyr Flash's radius |
| Gale push | 3 m | 0.1A; +0.2A at an edge | Lean weak |
| Storm second Rush | 9 m, once per Zephyr | One more unarmed hit at T2–T3 ≈ 1d8+4 × 0.70 ≈ 0.55A, × ~0.6 frequency ≈ +0.35A/turn | ⚠️ watch (V-storm) |
| Wind cap X by rank | Breeze 2 · Gale 3 · Storm 4 · Hurricane 5 | Uptime ≈ 2.5–3 of 4 turns at any rank (reopen when it stops); the cap matters in long fights | In band |
| **Boreas** | allies +3 m · Windswept −3 m | 4 × 0.1A + 2.5 × 0.05A ≈ **0.55A**/turn | Balanced with the others |
| **Notus** | ranged attacks vs allies at Disadvantage · Windswept −1 on saves | 4 × 0.3A × 0.4 (ranged share) + ≈ 0.07A ≈ **0.55A** | Balanced |
| **Eurus** | allies +1 attack rolls · Windswept −1 attack rolls | 4 × 0.07A + 2.5 enemies × 2A × 0.05 ≈ **0.55A** | +2/−2 would be 1.1A — dominant (B5); +1 keeps the three equal |
| The bag per day | — | T1: 0.55 × 4 × 2.5 × 4 ≈ 22 gross, −BA ≈ 14 → ≈ 6% of D · T3: ≈ 60 gross ≈ 12% of D | Main subclass feature band (≈ 10%) |
| Hurricane (two winds) | — | +0.55A/turn at 12 ≈ +60/day ≈ 12% of D | ⚠️ watch — the level-12 peak, with Tier III |
| **The Calm** | **Action**; 1d8 Thunder per gust (levels 3–6), 2d6 (7–12); no roll | T1: ~3 gusts × 4.5 + reopen ≈ 17 vs once-per-combat ceiling 19 → 0.9 · T2: 3.75 × 7 + 8 ≈ 34 vs 38 → 0.88 · T3: 7 × 7 + 11 ≈ 58 vs 52 → 1.12 | Balanced → strong at 12 (acceptable: needs a wind and marks). Action so the bag (bonus action) reopens the same turn |
| **Where the Winds Meet** | **Action**; point 18 m; pull 6 m (Windswept 9 m); Off Balance; marked; **+4d8 Thunder, DEX save for half** | Without damage: pull + Off Balance + marks + Fireball set-up + a full bag ≈ 45 vs capstone ceiling 86 → **0.52 (trap)**. With 4d8: 4 targets × 18 × 0.8 × M(4) 2.5 ≈ 36 → ≈ 81 → 0.94 | Needs the damage to be a capstone — a design addition for approval |
| Awakening goals (marks released) | **3 / 5 / 8** | Level 3: opening on turn 2 with ~3 → Tier I turn 2. Level 7: 3 + 2 (sweep) → turn 3. Level 12 (allies mark): 4 + 4 → turn 3, and the waking sweep already pushes | Every tier in a normal fight (J6) |
| Tier III push | 3 m + Off Balance | ≈ 4 swept × (0.1 + 0.2)A ≈ 1.2A per turn of wind | ⚠️ watch (peak) |
| **Weightless** | speed +3 / +4.5 / +6 / +9 m; jump ×1 / ×2 / ×3 / ×4; falling −0% / −50% / −50% / immune (ranks 1/4/8/12) | Today +38 m at 12 is a dead bonus (B6) and the Rush now carries the mobility; +3 m ≈ 0.15A/turn for a melee | Down from today, in band |
| Flow State | THP 2 × level, +1 bonus action, **3 turns** | Was up to 6 turns (> T) | Down, in band (B6) |
| Storm Fists | today's dice (1d4 / 1d6 / 1d8 + DEX by slot), **3 turns**, only vs enemies that weren't Windswept | Frequency ~50% halves it; the 3-turn cap trims the tail | Down; watch it stays a pick (V-fists) |
| Untethered | +2 AC while flying (today's Eye of the Storm) | 0.16A/turn + flight 0.3A | Unchanged |
| Leap of Faith | 18 m, today's damage | Once per Short Rest at 10 | Unchanged |
| Gale Deflection, ally | ally within 3 m | Small | — |
| Preset | STR 8 · DEX 15 · CON 13 · INT 15 · WIS 10 · CHA 10 (27-point buy) | DEX 17 / INT 16 after +2/+1 → AC 16, DC 13 at level 1 | Closes `10.06` #12 |
