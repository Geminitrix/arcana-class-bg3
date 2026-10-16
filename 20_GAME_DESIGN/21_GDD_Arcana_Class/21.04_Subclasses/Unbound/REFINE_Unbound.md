---
id: 21.04/Unbound/REFINE_Unbound
owner: Lead Class Designer (with the Balance Designer)
status: proposal — in progress (steps 1–4 and kit directions; direction A + Beaufort ranks chosen, WB3–WB10); nothing here is a decision until it is logged in DECISIONS.md
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
