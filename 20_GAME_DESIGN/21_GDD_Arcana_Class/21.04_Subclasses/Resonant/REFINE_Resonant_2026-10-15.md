---
id: 21.04/Resonant/REFINE_Resonant_2026-10-15
owner: Lead Class Designer (with the Balance Designer)
status: proposal — awaiting Owner review; nothing here is a decision until it is logged as R49+ in DECISIONS.md
ticket: ARC-0014
created: 2026-10-15
variant: subclass (full)
method: 21.04/_SUBCLASS_REFINING.md v1 · Depth Model of 21.04/_SUBCLASS_STANDARD.md v2.1 (cited DM-<id>)
supersedes: nothing — REFINE_Resonant.md (the Owner's proposal, S1–S16) stays as the record it is; this review builds on it
sources: DESIGN.md · DECISIONS.md (R1–R48) · REFINE_Resonant.md (S1–S16) · _SUBCLASS_STANDARD.md v2.1 · _SUBCLASS_REFINING.md ·
  25_Master_Data (FEAT_Resonant_Overload, STA_Resonant_States, SPL_Resonant_Compassion, SPL_Resonant_EmotionalOverload) ·
  22.06/Arcana_Power_Budget.md §1, §2, §4, §8, §17 · 21.03_Progression_Table/Resonant.md · 21.08_Subclass_Matrix.md ·
  26.01/2026-09-17-deck-core-design.md · 27.08 · the generator gen_emotion_alchemy.pl (statuses, Temper, upcast) ·
  dump_progression.pl (the game's progression, 2026-10-15)
---

# The Resonant — refining review (v2 format)

> **What this is.** A proposal. It reviews the Resonant as built after ARC-0002 (R1–R48) with the refining method, takes
> the Owner's proposal `REFINE_Resonant.md` (S1–S16) as its main input, checks every claim against the real files, and
> adds what the files show and the proposal does not. **What it is not:** the design (`DESIGN.md`) or a decision
> (`DECISIONS.md`). Nothing changes in the design, the master data or the game until the Owner approves a suggestion.
>
> **Numbers.** ADR-0005: no final value here. Current values are quoted as evidence; proposed sizes are placeholders
> `‹…›`; estimates use the currency of `22.06` (A = 4 / 8 / 11 by tier, extra action = +1A, Stunned = 3A, "loses its
> action" = 1.5A, Paralysed = 3.5A; per-turn sustained ceiling 8 / 19 / 31; E = 4 fights, T = 4 turns).

## Contents

1. Executive summary · 2. Frame · 3. The current state · 4. Criteria · 5. Audit · 6. Diagnostic data ·
7. Suggestions SG1–SG18 · 8. Felt progression · 9. Balance impact · 10. Feasibility · 11. Verification ·
12. Rollout and propagation · 13. References · Appendix A — what happened to S1–S16 · Appendix B — the loops, turn by turn

---

## 1. Executive summary

The core is the best in the class: a real model (Plutchik) gives the content its shape, the rule fits in one sentence,
the same spell lifts an ally or breaks an enemy, and the refund gives a rhythm. The axis — **Combination** — is free.

What is loose sits around the core. Six themes, in the order they should be decided:

1. **Three loops have no brake** (the proposal saw one, and smaller than it is). An intense emotion gives its mood back,
   so it repeats every turn; Tier II's free Surge, the upcast (one target per slot level) and Emotional Contagion turn it
   into **mass extra actions or a stun-lock for no slot and no action**. Temper renews a mood every time it replays it,
   so a Bonus Action can deny an enemy's action every round. **One sentence fixes the first two: a mood that is used is
   spent.** A per-creature cap fixes the mass case.
2. **The Overload is a punishment before level 5 and a solved button after it.** The fix is one button in three ranks
   from level 1 and an *Overloaded* state that pressures without silencing; the hold-or-release choice comes back
   because the ultimate reads what was braided.
3. **Allies can be harmed by rule** (Compassion braids Submission; Shared Heart copies it to the party). One "kindness
   rule" covers both.
4. **The level map is dense on odd levels and empty on even ones.** With the standard v2.1 (Owner decision D9) the kit
   can spread over every level: the level-5 cliff disappears without swapping rings, and every level-up brings a little.
5. **Teaching and reading:** Catharsis is taught before it is usable; the wheel lives only in the player's head.
6. **Growth:** dead bonuses (mood extensions) and flat dice; the cantrip barely touches the mechanic.

| SG | Suggestion | Origin | Priority | Effort | DM ids |
|---|---|---|---|---|---|
| **SG1** | **A used mood is spent** — Intensify and Temper leave nothing when their emotion fades (Temper rework) | new (absorbs S4) | **must** | S | M2, M7, B3, M6 |
| **SG2** | **Excess once per fight** — a creature feels an intense emotion at most once per fight | new | **must** | S | B3, B2 |
| **SG3** | **Emotional Overload from level 1, in three ranks** (one button: 1 · 5 · 12) | rework of S1 | **must** | M | J3, P4, P11 |
| **SG4** | ***Overloaded* is pressure, not a silence** — Psychic each turn while full; no silence, no duration | rework of S1 / R29 | **must** | S | P11, B5, P6, I7 |
| **SG5** | **The ultimate reads the feelings it spends** — Paralysis per feeling | S2 | **must** | S | K7, K3, B2 |
| **SG6** | **After a fight the meter settles to half** | S3 | **must** | S | B7, B1, X2 |
| **SG7** | **Waking Tier III fills the meter** | S11 | **must** | S | J6, A2 |
| **SG8** | **The kindness rule** — an automatic effect never braids a hindering feeling on an ally | new (merges S12.2 + S13.2) | **must** | S | M5, M7 |
| **SG9** | **Shared Heart acts on cast** — Joy on every linked creature | S12.1 | should | S | standard §6.3, J6 |
| **SG10** | **The level map spread over every level** (standard v2.1) | new (replaces S6, S13.1) | should | M | J8, J4, J1 |
| **SG11** | **Catharsis taught at level 3** | S5 | should | S | J5 |
| **SG12** | **Each mood and Surge lists its reactions** | S7 | should | S | P7, X3 |
| **SG13** | **Documentation fixes** | S16 | **must** | XS | D2 |
| **SG14** | **Anger said as a taunt** | S15 | could | XS | I8, P8 |
| **SG15** | **Heartstring reads feelings** (cantrip rework) | S10 | should | S | K6, M3, B6 |
| **SG16** | **The dice states grow at 5 and 10** | S8, narrowed | should | M | J2, B6 |
| **SG17** | **Tier I drops its dead bonus** | new (replaces S9) | should | XS | B6, A2 |
| **SG18** | **PC: the Surges as one card with a choice** — measure first | S14 | could | L | P12, X1 |

Effort: XS text only · S one generator table, one Osiris rule or one spell · M several files and a test round · L base
class or PC deck (impact matrix required).

---

## 2. Frame

- **Variant:** subclass, full review (method §1.2). **Scope:** the Resonant, levels 1–12, both editions.
- **Already decided** (not reopened unless an SG names it): the wheel and its distances (R15, §4.3), only Surges react
  (R7), the refund once per turn (R16), any Surge on any creature (R41), constructs feel nothing (R25), the peaks as
  behaviour (R17, R26–R28), Tier II Harmony (R40, R42), Shared Heart shares feelings (R46, R44), feelings stack
  additively (R47), Emotional Overload is a Bonus Action (R48), Read the Room removed (R37), The Two Cups doesn't fill
  the Overload (R38).
- **Reopened by name:** R29 and R30 (SG3, SG4), R31 (SG6), R36 (SG1), R9/R10's "2 turns, no save" (SG5), R18/R46 and
  the Compassion of R34 (SG8), the level map of `21.03/Resonant.md` (SG10), R21's Tier I bonus (SG17).
- **Owner decision taken during this review:** D9 of ARC-0016 — a subclass may grant content at any level (standard
  v2.1, Appendix A.4). SG10 applies it.

---

## 3. The current state

**Identity.** XIV · Temperance · Aspect of Empathy. The Arcana who tunes in to what others feel and changes it. Back
line, 18 m; control and support; low damage of their own, spikes through Catharsis and Emotional Overload.

**Core rule** (`DESIGN.md` §4.3): *a Weave Surge cast on a creature that carries a mood reacts with it instead of landing
alone, by the distance between the two emotions on the wheel, and the mood is spent.*

**States:** peak (1 turn, behaviour) → fades into a mood (5 turns, a number) · feeling (2 turns, two emotions braided,
own StackId, additive) · intense (1 turn, **then the mood returns**) · Catharsis (instant). Values: `STA_Resonant_States`.

**Kit by level** (game and design agree — `21.03/Resonant.md`, `dump_progression.pl`):

| Level | Passives | Cards and features |
|---|---|---|
| 1 | Emotional Alchemy (+ refund) · Empathic Sight · Overload | Surges Joy, Trust, Fear · Heartstring |
| 3 | Tier I Resonance | Surges Anticipation, Surprise, Sadness · Temper · The Two Cups |
| 5 | Complex Feelings | Surges Disgust, Anger · Emotional Overload |
| 7 | Overwhelm · Tier II Harmony | — |
| 9 | Mixed Feelings | Emotional Contagion |
| 11 | — | Shared Heart · Ready: Compassion |
| 12 | Tier III Aspect of Empathy | — |
| 2, 4, 6, 8, 10 | — | — (the Resonant's progression nodes exist at every level, empty) |

**Resources:** Woven Spell Slots (PC: Threads), refunded by a reaction once per turn; the **Overload** meter (`OVERLOAD`,
fills +1 per peak and +2 per reaction, size 3 × slot level + 2, carries over, R31); the Awakening count (reactions;
countdown shown since ARC-0007).

**Gears** (standard §4.3):

| Creates the state | Changes the state | Spends the state | Reads the state |
|---|---|---|---|
| Weave Surges (peaks → moods) · Emotional Contagion (copies moods) · Harmony (mood at once, R42) | Temper (mood → peak) · Heartstring (mood +2 turns) · Shared Heart (copies feelings) · Resonance / Harmony (durations) | Every reaction (feeling, Catharsis, Intensify) · Emotional Overload (feelings) · The Two Cups (moods) | Emotional Overload: damage per feeling only; **its paralysis ignores the state** (K7) · Tier III (feelings in 6 m) · Awakening (counts reactions) |

---

## 4. Criteria

Every family applies (subclass, full). The research cards that sharpen them: `27.08` (motivation, flow and learning,
decisions, framing, peaks and endings, pull toward a goal, systems, the shape of a journey, clarity, mechanics that
tell the story), `27.03` (warning signs, lean weak), `27.04` (source and sink), `27.06` (one rule per test).

---

## 5. Audit

✅ yes · ⚠️ partly · ❌ no · ➖ n/a · 🧪 untested. One line of evidence each.

| DM | Mark | Evidence | SG |
|---|---|---|---|
| I1 | 🧪 | The Owner reports the reaction turn feels good (ARC-0002 probes); silenced turns at 1–4 not yet played as a fight | SG4 |
| I2 | ✅ | "Pour a second emotion into a mood and it reacts" | — |
| I3, I4 | ✅ | Reading a mood and choosing the second emotion *is* empathy (DESIGN §2) | — |
| I5 | ✅ | Combination; `21.08` axis row | SG18 protects it on PC |
| I6 | ✅ | Plutchik, Temperance, Iris, Harmonia (R1–R3, R20, R21) | — |
| I7 | ⚠️ | The empath who feels everything is silenced by it — the fantasy says "strikes with raw feeling", the rule takes the spells | SG4 |
| I8 | 🧪 | Texts deferred to ARC-0006 | SG14 |
| S1–S7, W1–W2 | ✅ | DESIGN §2 (card, myth, science, fiction, Weave) | — |
| M1 | ✅ | Peaks, moods, feelings, Catharsis — created and read only here | — |
| M2 | ⚠️ | One sentence, but Catharsis is taught at 1 and usable at 3 | SG11 |
| M3 | ⚠️ | Every column filled, but the ultimate's main effect and the cantrip barely read the state | SG5, SG15 |
| M4 | ⚠️ | Grows at every odd level; levels 7 and 9 are mostly "more table" | SG10 |
| M5 | ❌ | Compassion braids Submission (Prone) on an ally by rule; Shared Heart copies it to every linked ally | SG8 |
| M6 | ❌ | Intensify and Temper renew their own mood → repeating chains (Appendix B) | SG1, SG2 |
| M7 | ❌ | "The mood is spent" is false for Intensify (`then back to the mood`, DESIGN §4.3) and Temper (`returns at full length`, §7.2) | SG1 |
| K1, K2, K4 | ✅ | The Surges are the mechanic; nothing vanilla buffs-or-debuffs by combination | — |
| K3 | ⚠️ | Emotional Overload ties the kit only through its damage per feeling | SG5 |
| K5 | ✅ | Complex / Mixed Feelings and Overwhelm unlock rules | — |
| K6 | ⚠️ | Bonus action at 3 (Temper) ✅; Heartstring 1d4-scale cantrip that barely touches the state | SG15, SG10 |
| K7 | ❌ | Paralysed 2 turns, no save, whatever the target carries: the best target is the biggest enemy | SG5 |
| P1–P3, P8–P10 | ✅ | DESIGN §1, §3; behaviour peaks on vanilla types; all effects in Stats/Osiris/Khonsu | — |
| P4 | ⚠️ | Playable at 1, but 2 outcomes and a meter that only punishes | SG3, SG4 |
| P5 | ✅ | A reaction on turn 2, refunded | — |
| P6 | ⚠️ | Real choice on Surges; the release is solved from 5 | SG4, SG5 |
| P7 | ⚠️ | Statuses and the meter show; the wheel doesn't | SG12 |
| P11 | ❌ | *Overloaded* removes spells for turns = character level, without a choice (R29) | SG4 |
| P12 | 🧪 | Depends on the Resonant's deck size (§6.11); not measured | SG18 |
| J1 | ⚠️ | Level 7 and 9 headlines are "a new ring"; even levels bring nothing | SG10 |
| J2 | ❌ | Moods and feeling dice are flat 1 → 12; only Catharsis and targets grow | SG16 |
| J3 | ⚠️ | The signature button exists from 5 and changes once (12) | SG3 |
| J4 | ❌ | Level 5 adds 13 outcomes, two Surges and the ultimate (§6.8) | SG10 |
| J5 | ❌ | Catharsis taught at 1, first possible at 3 | SG11 |
| J6 | ❌ | The level-12 area needs ≈ 8 turns or a held, silenced meter (§6.9) | SG7 |
| J7 | ⚠️ | "Why this order" lists unlocks; no arc | §8 |
| J8 | ❌ | Six empty levels out of twelve (2, 4, 6, 8, 10 — and 7 has no action) | SG10 |
| A1, A3 | ✅ | Goal counts reactions; The Two Cups (field) vs Emotional Overload (one target) | — |
| A2 | ⚠️ | Tier I is a die, a dead duration and a card; Tier III rarely shows | SG17, SG7 |
| B1 | ⚠️ | Emotional Overload ≈ 30–40 % of D per day (`22.05/Resonant.md` as quoted in the proposal) | SG5, SG6 |
| B2 | ❌ | The ultimate needs no setup on its target | SG5 |
| B3 | ❌ | Mass Ecstasy ≥ the per-turn ceiling with 0 slots and 0 actions (§6.1) | SG1, SG2 |
| B4 | ⚠️ | Harmony and the Overload flagged "watch", shipped strong | SG2, SG6 |
| B5 | ❌ | Release at once is always right from 5 | SG4, SG5 |
| B6 | ❌ | Mood +2 turns (Tier I, Heartstring) outlast a 4-turn fight | SG15, SG17 |
| B7 | ❌ | The meter carries over (R31) without the three answers | SG6 |
| X1 | ⚠️ | 8 Surges + 7 other buttons by 12 on console; PC adds the deck | SG18 |
| X2 | ✅ | Meter %, Awakening countdown (ARC-0007) | — |
| X3 | 🧪 | Ask after the first fight | V-questions |
| T1–T4 | ✅ | Generator, proven patterns, glossary ids | — |
| D1 | ✅ | Identity Sheet in DESIGN §2.7 | — |
| D2 | ❌ | DESIGN §4.8 "the meter resets" vs R31; §7.4 "takes damage" without "from an enemy" | SG13 |

---

## 6. Diagnostic data

### 6.1 Loop hunt (method §4.4)

Every refund, self-renewing state and payoff that creates its own trigger, played until it stops or repeats. Facts
from the generator: an intense status's `OnRemoveFunctors` re-apply the mood on `TimeOut` (`gen_emotion_alchemy.pl`
`build_statuses`); Temper applies the peak and removes the mood, and the peak's own fade puts the mood back
(`build_temper`); an upcast Surge has one target per slot level (upcast variants, `AmountOfTargets`).

| # | Loop | Repeats | Cost per turn | Value per turn (`22.06`) | Verdict |
|---|---|---|---|---|---|
| L1 | Joy on a Serene ally → Ecstasy (+1 action) → Serene returns → again | every turn | 1 action, slot refunded | +1A per target | ❌ alone it trades an action for an action; with L2/L3 it is free and multiplied |
| L2 | Tier II free Surge (no action) + R42 (the mood at once) + upcast: N allies Ecstasy each turn | every turn | 0 actions; net 0–1 slot | +N·A — at tier 3, 3 allies = 33 vs a per-turn ceiling of 31 | ❌ broken (> 1.25 × ceiling) |
| L3 | Emotional Contagion renews Serene on the anchor's allies each turn → L2 even after a fix that spends moods | every turn while concentrating | 0 actions, 0 slots | as L2 | ❌ survives SG1 — needs SG2 |
| L4 | Surprise on a Distracted enemy → Amazement (Stunned) → Distracted returns → again | every turn | 1 action, slot refunded, 1 save | 3A × p(fail) ≈ 1.8A at tier 3 | ❌ a stun-lock for the price of a cantrip turn; Terror, Grief, Loathing alike |
| L5 | Temper on a Bored enemy → Disgust peak (can't act) → Bored returns → Temper again | every turn | Bonus Action (console: no slot; PC: 1 Thread, R45) | 1.5A × 0.55 ≈ 0.8A at tier 2, for −0.6A | ❌ self-renewing control; on Apprehensive the mood itself lowers the save |
| L6 | The refund | once per turn | — | — | ✅ capped (R16) |
| L7 | Shared Heart reactions | once per Surge | — | — | ✅ counted once (R19) |

### 6.2 Exception hunt (method §4.5)

Rule sentence: *"…reacts…, and the mood is spent."*

| Feature | Behaves differently? |
|---|---|
| Intensify | Yes — the mood comes back when the intense emotion ends (DESIGN §4.2, §4.3) |
| Temper | Yes — replays the emotion and the mood "returns at full length" (§7.2, R36) |
| Heartstring | No exception — extends a mood (a change, not a reaction) |
| Compassion, Shared Heart | Not an exception to the sentence, but an unwritten exception to M5: harm to allies without a choice |

### 6.3 Both sides of the field (method §4.10)

| State | On an ally | On an enemy | Harm to an ally without a choice? |
|---|---|---|---|
| Submission (Trust + Fear) | Prone, can't harm the Resonant | same | **Yes** — Compassion casts Trust automatically on a hit ally; an Apprehensive ally gets it |
| Any hindering feeling under Shared Heart | copied to every linked ally (R46) | — | **Yes** — once one ally carries it |
| Emotional Contagion | bright moods stay on their side (R35) | — | No |
| Joy on an enemy | — | its allies gain Advantage | No — the player's choice (R41) |

### 6.4 Overload timeline (method §4.2)

Reference fight (T = 4) at level 3, meter size 8, two-target Surges — the proposal's Appendix D holds: full on turn 3,
*Overloaded* (silenced) for 3 turns; the next fight starts silenced (R31). Day (E = 4) at level 5–7: up to 3–4
releases per day (`22.05`, as quoted). With SG4 + SG6 the same turns become a choice (pay HP and braid more, or release)
and a day holds about ‹2› releases.

### 6.5 Cost framed as punishment (method §4.9)

| Cost | "You give X to get Y"? |
|---|---|
| Overloaded at 1–4 | No — the spells are taken for turns = character level; nothing is given in return but a weapon rider on a dagger chassis (≈ 0.75 A per weapon turn) |
| Overloaded at 5+ | Yes, but solved: release at once (B5) |
| Full meter under SG4 | Yes — "you give ‹Psychic each turn› to keep braiding before the release" |

### 6.6 Dead bonuses (method §4.7)

| Bonus | Against the reference fight | Verdict |
|---|---|---|
| Tier I: moods +2 turns (5 → 7) | A mood is spent by a reaction or outlasts a 4-turn fight | dead |
| Heartstring: a mood +2 turns | same | dead |
| Tier II: feelings +2 turns (2 → 4) | a feeling ends inside the fight | alive |
| Feeling and mood dice (Hope / Despair 1d4, Remorse 1d6, Aggressiveness 1d4, Apprehensive −1d4…) | flat from 1 to 12 while vanilla cantrips scale at 5 and 10 | flat |
| Conditions (Stunned, Prone, Incapacitated, Paralysed) | scale with the enemies by themselves | alive |

### 6.7 Taught before usable (method §4.6)

| Rule | Taught | First usable |
|---|---|---|
| Catharsis | 1 (Emotional Alchemy) | 3 (Joy ↔ Sadness) |
| Distance 1, refund | 1 | 1 |
| Overload release | 1 (the Overload passive names it) | 5 |

### 6.8 Complexity curve (method §4.1) — outcomes the player can make

Wheel: Joy 0, Trust 1, Fear 2, Surprise 3, Sadness 4, Disgust 5, Anger 6, Anticipation 7.

| Level | Today: total (new) | Proposed map, SG10: total (new) |
|---|---|---|
| 1 | 2 (2) | 2 (2) |
| 2 | — | 3 (1: Optimism) + Temper |
| 3 | 7 (5) | 7 (4 + the Catharsis rule) |
| 5 | **20 (13)** | 12 (5) |
| 6 | — | 20 (8: distance 2) |
| 7 | 28 (8, predictable) | 28 (8, predictable) |
| 9 | 36 (8) | 36 (8) |

### 6.9 Tier and peak timeline (method §4.3)

Tier III wakes ≈ turn 5 (15 reactions, `22.05`); the meter fills ≈ turn 4; released on turn 4, it refills ≈ turn 8.
The area release needs ≈ 8 turns, or a silenced hold from turn 4 to 5. With SG7 it happens on the turn Tier III wakes.

### 6.10 UI reading (method §4.11)

| Question on a typical turn | Answered on screen? |
|---|---|
| "What mood does this creature carry?" | ✅ status icon |
| "What would Trust do to it?" | ❌ only in the player's head — SG12 |
| "How close is the Overload / the next tier?" | ✅ meter % (R31, not at 0 %), Awakening countdown (ARC-0007) |

### 6.11 The right card in hand (method §4.12)

Deck rules (`26.01/2026-09-17-deck-core-design.md`): 0–3 copies per title, hand persists, 1 draw per turn from turn 2.
The same document says the opening hand is **4 cards** (rules table) and **5 cards on turn 1** (the turn-start step) — a
contradiction to settle in a deck review (note, outside this scope). With *N* cards in the Resonant's deck and 3 copies
of a Surge, the chance of holding it after seeing *n* cards is `1 − C(N−3, n) / C(N, n)`; the proposal's assumption
(N = 30) gives ≈ 0.43–0.50 by turn 2–3. *N* depends on the deck the player builds; SG18 measures before changing.

### 6.12 Value by level band (method §4.13)

Not re-derived here. The band table of `22.05/Resonant.md` is the starting point; the loops of §6.1 are not priced in
it and push tier 2–3 above the band.

---

## 7. Suggestions

### SG1 · A used mood is spent (the core rule without exceptions; Temper rework)

- **Problem.** Two features renew the mood they use, so the core sentence is false for them and both loop.
- **Evidence.** §6.1 L1, L4, L5; §6.2; `STA_Resonant_States` `intense_duration` note "then the mood returns"; DESIGN
  §7.2 and R36 "the mood returns at full length".
- **Why it matters.** `DM-M7`, `DM-M2` (one rule, true everywhere — lenticular design, `27.08` clarity); `DM-B3`,
  `DM-M6` (loops without brakes — `27.08` systems).
- **Proposal.** Write the rule once, in Emotional Alchemy: ***Using a mood spends it. Only an emotion that fades on its
  own leaves a mood.*** Two consequences:
  1. **Intensify:** the intense emotion leaves nothing when it ends.
  2. **Temper (rework):** *"Spend a creature's mood to make it relive the emotion it came from, for 1 turn."* The
     replayed emotion leaves nothing when it fades. Temper becomes a **cash-out**: a Bonus Action that turns a mood back
     into its behaviour now (Fear freezes again, Joy spreads again, Disgust takes the action) at the price of the mood.
     It stays the early two-plays-a-turn option (`DM-K6`).
- **Alternatives.** *Intensify gives no refund* (S4's alternative): keeps the exception and still loops for a slot.
  *Temper only on allies*: kills its enemy side, which is its best use. *Temper once per creature per fight*: a second
  special rule where one sentence suffices.
- **Impact.** DESIGN §4.2, §4.3, §7.2 · `STA_Resonant_States` (note), `SPL_Resonant_Temper` · generator: the intense
  statuses lose the mood on fade; Temper's peaks are applied without the fade (a separate replay status, or the peak with
  a marker that blocks the fade — T2) · texts of Emotional Alchemy, Overwhelm, the intense statuses, Temper · tests.
  Both editions.
- **Risks.** Temper feels weaker on allies (no more free mood refresh). That was the loop; Heartstring (SG15) and
  Harmony keep moods alive in other ways.
- **How to verify.** V1, V2.
- **Decisions touched.** R36 (replaced), R7 (unchanged), DESIGN §4.3 table "then back to the mood".

### SG2 · Excess once per fight

- **Problem.** Even with SG1, a mood can be renewed by other sources in the same turn: Tier II's free Surge brings the
  mood at once (R42) and Emotional Contagion renews it every turn (R33). With the upcast, one Surge intensifies several
  creatures at once.
- **Evidence.** §6.1 L2, L3: at tier 3, three allies with an extra action each = 3A = 33 against a per-turn ceiling of
  31, for 0 actions and 0–1 slot; on enemies, Amazement on several targets per turn.
- **Why it matters.** `DM-B3`, `DM-B2`; `27.03` warning signs (an effect that dominates every fight).
- **Proposal** (A recommended).
  - **A — once per fight per creature:** *"A creature can feel an intense emotion once per fight."* An intense emotion
    leaves a hidden marker on the creature, removed when combat ends; Overwhelm doesn't react on a creature that
    carries it (the Surge lands as a plain peak). The mass turn still exists — once — as a moment.
  - **B — only the main target intensifies:** other targets with the same mood get the plain peak. Cheaper in power,
    but needs a way to tell the main target in a multi-target spell (T2, no proven pattern).
- **Alternatives.** *Intensify gives no refund:* still repeats under Contagion for one slot a turn. *Ecstasy becomes a
  Bonus Action:* fixes one state; Admiration, Vigilance and the enemy ring still repeat.
- **Impact.** Generator (one marker status, `RemoveEvents OnCombatEnded` — the pattern of `ASPECT_PROGRESS_*`, ARC-0007;
  the reaction condition of the intense ring) · DESIGN §4.3, §5.3 · `STA_Resonant_States` · texts of Overwhelm · tests.
- **Risks.** Overwhelm feels "spent" in long fights; that is the point of excess.
- **How to verify.** V3.
- **Decisions touched.** R42 and R33 (unchanged; they stop feeding a loop).

### SG3 · Emotional Overload from level 1, in three ranks

- **Problem.** The signature button exists only from level 5; levels 1–4 have the meter and only its cost.
- **Evidence.** R29 (meter from 1, release from 5); §6.5.
- **Why it matters.** `DM-J3` (one button upgraded in ranks — `27.08` felt progression), `DM-P4`, `DM-P11`.
- **Proposal.** One button, the same name, three ranks (replaces the proposal's separate *Outburst*: a new name to
  learn at level 1, where the curve is already full):

  | Level | Rank | What it does |
  |---|---|---|
  | 1 | I | Bonus Action, full meter, not a spell. One enemy within 18 m: its feelings are spent, Psychic damage per feeling, and a short saveable control ‹Frightened 1 turn, Wisdom save› |
  | 5 | II | As I, and Paralysed by the feelings spent (SG5) |
  | 12 | III | As II, and every enemy within 6 m carrying your feelings (Tier III, as today) |

- **Alternatives.** *S1's Outburst + Emotional Overload:* two names for one idea. *Meter and release both at 5 (R13):*
  removes the punishment but also the identity at 1–4 that R29 wanted; the fallback if V4 fails.
- **Impact.** DESIGN §6, §6.1, §8, §10 · `SPL_Resonant_EmotionalOverload` (`by_level` ranks) · the spell (rank II and
  III gated like Tier III's area — find the gate the area uses today before the spec) · `Progressions.lsx` (the spell at
  1) · texts · tests · player guide.
- **Risks.** A level-1 release on a dagger chassis could be the best level-1 turn; the control is short and saveable,
  and the meter takes ≈ 3–4 turns to fill.
- **How to verify.** V4.
- **Decisions touched.** R29 (the release moves to 1), R13 (stays replaced).

### SG4 · *Overloaded* is pressure, not a silence

- **Problem.** At 1–4 the full meter takes the player's spells for turns equal to their level; from 5 the release is
  pressed at once, so "release now or hold" (R11) is gone.
- **Evidence.** R29, R30; §6.5; DESIGN §1 promises "striking with raw feeling", the rule delivers a silence (`DM-I7`).
- **Why it matters.** `DM-P11` (loss aversion, framing — `27.08`), `DM-B5` and `DM-P6` (interesting decisions).
- **Proposal** (A recommended).
  - **A — pressure only.** While the meter is full the Resonant takes Psychic damage at the start of each turn (as
    today) and **nothing else**: no silence, no duration. It ends when they release (SG3) or when the fight ends (SG6).
    The decision comes back through SG5: hold — pay HP and braid one more feeling into the target — or release now.
    The weapon rider (R30) retires: without a silence it has no job.
  - **B — the proposal's power state.** Not silenced; Surges harder to resist while full; if it runs out unreleased, a
    short breakdown ‹silenced 1 turn›. More flavour, three new concepts at level 1.
- **Alternatives.** *Keep the silence, 1 turn:* still a pure loss.
- **Impact.** Osiris `ARCANA_Resonant_Overload` (no silence; no duration), `FEAT_Resonant_Overload`
  (`overloaded_duration`, `weapon_psychic` retire) · DESIGN §6 · texts · tests.
- **Risks.** A player could sit full forever. The HP each turn is the brake; V5 checks it.
- **How to verify.** V5.
- **Decisions touched.** R29 (silence and duration removed), R30 (retired), R11 (its choice returns).

### SG5 · The ultimate reads the feelings it spends

- **Problem / evidence.** Paralysed 2 turns, no save, on any enemy; feelings add only damage
  (`SPL_Resonant_EmotionalOverload`, R9/R10). Paralysed ≈ 3.5A a turn: the paralysis is ≈ 7A, the feelings a few points.
- **Why it matters.** `DM-K7` (wrong if the best target is the biggest enemy, whatever it carries), `DM-K3`, `DM-B2`.
- **Proposal** (A recommended). **A:** Paralysed ‹1 turn per feeling spent, at least 1, at most 3›; damage per feeling
  stays. **B:** no save only if the target carries a feeling; otherwise a Wisdom save, 2 turns.
- **Alternatives.** More damage per feeling: still a number beside the paralysis.
- **Impact.** DESIGN §6.1, §9 · `SPL_Resonant_EmotionalOverload` · Osiris (the count of feelings removed, applied as a
  duration) · texts · tests.
- **Risks.** Burst at 7+: Tier II's free Surge + a Surge + the release (Bonus Action, R48) can braid two feelings and
  release in one turn — that is the intended combo; the cap ‹3› and SG2 keep it in band.
- **How to verify.** V6.
- **Decisions touched.** R9, R10 (duration), R14 (Tier III keeps "others 1 turn").

### SG6 · After a fight the meter settles to half

- **Problem / evidence.** R31 carries the meter over; D4 of ARC-0016 makes reset the default and carry-over an exception
  with three answers (`DM-B7`); DESIGN §4.8 still says "resets".
- **Proposal** (A recommended). **A — settle to half:** the carry-over stays as an exception, with its three answers:
  uses per day ‹1–2› against `22.06` (V7); the counter shows out of combat (R32 ✅); the first and fourth fights differ by
  at most half a meter. **B — reset (D4 default):** simplest; the release shows only in fights of 4+ turns.
- **Impact.** Osiris (halve on combat end; a full meter ends *Overloaded*) · `FEAT_Resonant_Overload` · DESIGN §4.8, §6 ·
  `26.01/Resonant.md` · DECISIONS (the three answers) · texts.
- **Decisions touched.** R31.

### SG7 · Waking Tier III fills the meter

- **Problem / evidence.** §6.9: the level-12 peak needs ≈ 8 turns.
- **Why.** `DM-J6` (peak-end — `27.08`), `DM-A2`.
- **Proposal.** When *Aspect of Empathy* wakes, the meter fills at once ("the dam breaks"); the area release is
  available that turn.
- **Impact.** Osiris `ARCANA_Aspect_Temperance` (the existing path that makes the meter full) · DESIGN §9 · texts · test.
- **Decisions touched.** R14 (extended).

### SG8 · The kindness rule

- **Problem.** Two features harm allies by rule (§6.3).
- **Why.** `DM-M5` (harm to allies listed and chosen or blocked), `DM-M7` (one written rule, not two exceptions).
- **Proposal.** In Emotional Alchemy: ***"Your automatic effects never braid a hindering feeling on an ally."***
  - Ready: Compassion's Trust: if it would braid a hindering feeling, it lands as a plain peak.
  - Shared Heart copies only helpful feelings (the generator already marks each feeling A / I).
  - The player can still braid a hindering feeling on an ally by hand (R41).
- **Impact.** The interrupt's condition · Osiris `ARCANA_Resonant_SharedHeart` (filter by kind) · DESIGN §4.6, §7.4, §7.6 ·
  texts · tests.
- **Decisions touched.** R46 (filtered), R34's Compassion (condition).

### SG9 · Shared Heart acts on cast

- **Problem / evidence.** An Action and a level-5 card that does nothing the turn it is cast; standard §6.3 asks the
  capstone to act on cast.
- **Proposal.** On cast, every linked creature feels **Joy** (a peak — no reaction, no refund, no Overload, no Awakening,
  R7/R19); it fades into Serene, the setup for the first shared reaction.
- **Alternatives.** Love on all at once: a reaction for free, against R7.
- **Impact.** The spell · DESIGN §7.6 · texts · test.
- **Decisions touched.** R18, R46 (extended).

### SG10 · The level map spread over every level (standard v2.1)

- **Problem.** Six empty levels (2, 4, 6, 8, 10 and an action-less 7); level 5 carries a cliff; level 11 holds two cards.
- **Evidence.** §3 kit table; §6.8; `dump_progression.pl`: the Resonant's progression nodes exist at levels 1–20, so
  moving content needs no new structure. Feats: 4, 8, 12 (`[ASI]` in the dump).
- **Why.** `DM-J8`, `DM-J4`, `DM-J1`; `27.08` flow and learning, pull toward a goal; Owner decision D9.
- **Proposal.**

  | Level | Gains | Headline |
  |---|---|---|
  | 1 | Surges Joy, Trust, Fear · Heartstring · Emotional Alchemy (distance 1, refund, SG1 and SG8 rules) · Empathic Sight · Overload with Emotional Overload I (SG3) | *Pour, braid, let it out* |
  | 2 | Surge **Anticipation** · **Temper** (from 3) | *A second play each turn* |
  | 3 | Surges Surprise, Sadness · **Catharsis taught** (SG11) · Tier I + The Two Cups | *Opposites snap* |
  | 4 | — (feat) | |
  | 5 | Surges Disgust, Anger · **Emotional Overload II** · first growth step (SG16) | *The whole wheel; the release paralyses* |
  | 6 | **Complex Feelings** (distance 2, from 5) | *Emotions further apart still blend* |
  | 7 | Overwhelm · Tier II Harmony | *Excess* |
  | 8 | — (feat) | |
  | 9 | Mixed Feelings · Emotional Contagion | *A mood runs through a crowd* |
  | 10 | **Ready: Compassion** (from 11) · second growth step (SG16) | *I answer an ally's pain* |
  | 11 | **Shared Heart alone** (SG9) | *One heart for the party* |
  | 12 | Tier III · Emotional Overload III (SG7: waking it fills the meter) | *The dam breaks* |

  Concepts per level-up: 1: 5 · 2: 2 · 3: 3 · 5: 3 · 6: 1 rule (8 names) · 7: 2 · 9: 2 · 10: 2 · 11: 1 · 12: 1. No
  level-up carries most of its stretch; no two empty levels in a row; feat levels stay empty.
- **Alternatives.** *S6 — swap the rings (Overwhelm 5, Complex 7):* also eases level 5, but moves a known passive two
  levels and needs SG1/SG2 first; the spread solves the cliff without it. *Compassion at 7 (S13):* level 7 already
  carries two rules; level 10 needs a verb (otherwise it would be only a growth step). *Compassion at 8:* a new button
  on a feat level (standard §6.3 keeps those light).
- **Impact.** `Progressions.lsx` (move entries between existing nodes) · DESIGN §8, §10 · `21.03/Resonant.md` · `21.08`
  (rhythm, already noted) · PC deck (the cards join the pool at their new levels) · tests (`dump_progression.pl` rows) ·
  player guide.
- **Risks.** Temper at 2 arrives before any Catharsis; with SG1 it is a cash-out of the level-1 moods, which works.
- **How to verify.** V8, and the X3 question.
- **Decisions touched.** R6 (Temper at 3 → 2), R13 lineage (Complex Feelings 5 → 6), R18/R43 (Compassion and Shared
  Heart no longer share 11).

### SG11 · Catharsis taught at level 3

- **Problem / evidence.** §6.7.
- **Why.** `DM-J5`.
- **Proposal.** Emotional Alchemy (1) teaches peaks, moods, distance 1, the refund and the two rules of SG1/SG8; a short
  passive at 3 *(working name: Opposites)* teaches Catharsis, the turn the first opposite pair exists.
- **Impact.** Generator (passive text and id, `33.03`) · `Progressions.lsx` (3) · DESIGN §4.3, §8 · texts. No balance.

### SG12 · Each mood and Surge lists its reactions

- **Problem / evidence.** §6.10.
- **Why.** `DM-P7`, `DM-X3` (clarity — `27.08`).
- **Proposal.** Each mood's text lists the outcome names by the emotion poured, with the level that unlocks them (no
  effects); each Surge lists the moods it reacts with. Generated from the same table.
- **Impact.** Generator (description builder; loca strings, not stats lines) · `32.01` · no gameplay change.

### SG13 · Documentation fixes

| Where | Says | Should say |
|---|---|---|
| DESIGN §4.8 "Combat ends" | the meter resets | the rule chosen in SG6 (today: carries over, R31) |
| DESIGN §7.4 | "when an ally within 9 m takes damage" | "…takes damage from an enemy" (2026-10-12 fix) |
| DESIGN §8 | Overload (1) after Complex Feelings (5) | ordered by level |
| `26.01/2026-09-17-deck-core-design.md` | opening hand 4 (table) and 5 (turn step) | one value — note for a deck review |

`DM-D2`. The standard and the matrix rhythm were updated with D9 (ARC-0016).

### SG14 · Anger said as a taunt

Keep the rule (R26); say the intent: the tank hits first, then Anger locks the enemy onto it. Text and DESIGN §5.1,
§11.2. `DM-I8`, `DM-P8`. No mechanic change.

### SG15 · Heartstring reads feelings (cantrip rework)

- **Problem / evidence.** A 1d4-scale cantrip (`D4Cantrip`) whose rider (a mood +2 turns) is dead (§6.6).
- **Why.** `DM-K6`, `DM-M3`, `DM-B6`.
- **Proposal.** Heartstring deals ‹+1d4 Psychic per feeling› the target carries; the mood extension leaves. The fallback
  turn advances the same plan as the ultimate (SG5): keep feelings on the enemy.
- **Impact.** `SPL_Resonant_Heartstring` · the spell: conditional damage per feeling, the pattern Emotional Overload
  already uses for its per-feeling damage (proven in the mod); keep the line ≤ 3900 characters · texts · tests.
- **Decisions touched.** None recorded (the extension came with the spell, §7.1).

### SG16 · The dice states grow at 5 and 10

- **Problem / evidence.** §6.6: dice states are flat 1 → 12.
- **Why.** `DM-J2` (competence, goal gradient — `27.08`), `DM-B6`.
- **Proposal.** Only the dice grow, one step at **5** and one at **10** (the cantrip breakpoints the player already
  knows): ‹1d4 → 1d6 → 1d8› for Hope, Despair, Aggressiveness, Apprehensive; ‹1d6 → 1d8 → 1d10› for Remorse and the
  other d6 feelings. Conditions and flat bonuses (AC, movement) stay. The level-up text says it: *"Your moods and
  feelings grow stronger."*
- **Alternatives.** The proposal's S8 (AC and every value): AC stacks with Love and Accepting; conditions don't need it.
  By slot level (upcast pattern): smooth but unannounced.
- **Impact.** Generator (statuses by level for the dice states only) · `STA_Resonant_Feelings`, moods (`by_level`) ·
  balance pass · texts.

### SG17 · Tier I drops its dead bonus

- **Problem.** "Moods +2 turns" (§6.6) is dead. The proposal's S9 (the nearest same-side creature catches the mood)
  **brings back what R40 removed** — "the nearest creature gaining a mood failed P20 and read as complex".
- **Proposal.** Tier I *Resonance* = Catharsis +1d8 and **The Two Cups** — the card is the tier's new verb (`DM-A2`).
  The mood extension leaves (the generator's Tier I fade branch goes).
- **Impact.** Generator · `FEAT_Resonant_AspectAwakening` (`tier1_mood_extend` retires) · DESIGN §9 · texts.
- **Decisions touched.** R21 (bonus list), R40 (respected).

### SG18 · PC: the Surges as one card with a choice — measure first

As S14: measure the share of turns where the needed Surge was not in hand (V9); only if it is ≥ ‹25 %›, a single
*Weave Surge* card opening the wheel (a container — the pattern of the base class's Command). It touches the deck: a
base-class change with the impact matrix of the standard §9.3, effort L. `DM-P12`, `DM-X1`.

---

## 8. Felt progression

**Level table:** SG10's table above (current in §3).

**The arc** (`DM-J7`, from the card's two faces):

| Part | Levels | Name | What the player feels |
|---|---|---|---|
| Introduce | 1–3 | **Feeling** | "I read what they feel and change it — and let mine out" |
| Develop | 5–7 | **Blending and excess** | "The whole wheel; emotions further apart still blend; one pushed to its extreme" |
| Turn | 9–10 | **Contagion** | "Feelings spread through a crowd; I answer an ally's pain" |
| Conclude | 11–12 | **Union** | "One heart for the party; the dam breaks over the field" |

**Complexity curve:** §6.8 — before 2 → 5 → 13 → 8 → 8 on five level-ups; after 2 → 1 → 4 → 5 → 8 → 8 → 8 on seven,
with one rule per level.

**Vertical growth** (`DM-J2`): Catharsis (5, 10), the dice states (SG16: 5, 10), Surge targets (slot level), Emotional
Overload's ranks (1, 5, 12).

**The signature button** (`DM-J3`): SG3's rank table.

**The peak** (`DM-J6`): today ≈ turn 8; after SG7 the turn Tier III wakes (≈ turn 5).

---

## 9. Balance impact

Direction only; the balance pass chooses the values and writes them in `25`.

| SG | Direction | Estimate (`22.06`) | Band check |
|---|---|---|---|
| SG1 | Down | Removes the repeat of L1, L4, L5: up to ≈ 1–1.8A a turn on one target | Fixes `DM-B3` for single targets |
| SG2 | Down | Mass Ecstasy capped to one turn per creature: from ≈ 3A every turn to ≈ 3A once | Back under the per-turn ceiling |
| SG3 | Up at 1–4 | A small release ≈ ‹1A› every ≈ 4 turns; levels 5+ unchanged | Tier 1 is the weakest band |
| SG4 | Up at 1–4 | Removes silenced turns (each ≈ −0.25A against a cantrip turn) | — |
| SG5 | Down | Unbraided target 1 turn (≈ 3.5A) instead of 2 (≈ 7A); braided twice: unchanged | Toward 10–20 % of D |
| SG6 | Down | ≈ 3–4 releases a day → ≈ 2 | With SG5, into band |
| SG7 | Up at 12 | +1 area release per fight that wakes Tier III | Inside the Tier III peak |
| SG8 | Flat | Removes self-harm | — |
| SG9 | Up (slight) | Joy ≈ Advantage on one attack per ally | Capstone budget |
| SG10 | Flat in total | Content earlier (Temper 2, Compassion 10 instead of 11) and Complex Feelings one level later | Smoother bands |
| SG15 | Up late | ≈ +2.5 per feeling on the target | Fallback toward A at tier 3 |
| SG16 | Up at 5 and 10 | Dice states ≈ +20–40 % at each step | Offsets the tier-3 plateau |
| SG17 | Flat | Removes a bonus worth ≈ 0 | — |

**Net reading.** Power leaves the loops (SG1, SG2) and the ultimate's frequency and free paralysis (SG5, SG6) — the
places the balance report and §6.1 flag — and goes to levels 1–4 (SG3, SG4), the end of the journey (SG7, SG9) and
tier 3 (SG15, SG16). The total should land near today's *intended* power, spread more evenly; today's *real* power at
tiers 2–3 is above it because of the loops.

**Assumptions:** reference fight T = 4, day E = 4 (`22.06` §1); the loops valued at their sustained repeat; the
`22.05` figures quoted, not re-derived.

---

## 10. Feasibility

| SG | Where it lives | Proven pattern in the mod | New piece — T2 |
|---|---|---|---|
| SG1 | Generator (intense statuses; Temper) | Peaks' fade on `TimeOut` (`OnRemoveFunctors`) | A replayed peak that fades into nothing: a separate replay status per emotion, or a marker read by the fade — choose by test |
| SG2 | Generator; reaction condition | Marker status removed on combat end (`ASPECT_PROGRESS_*`, ARC-0007); reaction conditions on `HasStatus` | None if A; B needs a "main target" test |
| SG3 | Spell, `Progressions.lsx` | Tier III's area version of the same spell; non-spell Bonus Action (R48) | The level-5 gate for rank II — find the vanilla condition first |
| SG4 | Osiris `ARCANA_Resonant_Overload` | The full-meter handling and Psychic tick | None (removals) |
| SG5 | Spell, Osiris | Per-feeling removal and damage | A paralysis duration from the count |
| SG6 | Osiris | Combat-end handling of the meter (it reset before R31) | Halving |
| SG7 | Osiris `ARCANA_Aspect_Temperance` | The path that makes the meter full | None |
| SG8 | Interrupt condition; Osiris Shared Heart | The kind A / I column of the feeling table | A mood condition on Compassion's Trust |
| SG9 | Spell | Applying a peak to linked creatures | None |
| SG10 | `Progressions.lsx` | Subclass nodes already exist at every level | None |
| SG11 | Generator, progression | Passives per level | A new passive id (`33.03`) |
| SG12 | Generator | Every string from one table | None |
| SG15 | Spell | Per-feeling conditional damage (Emotional Overload) | Line length ≤ 3900 |
| SG16 | Generator | One version per level (standard §13) | None |
| SG17 | Generator | — | None (removal) |
| SG18 | Deck (Lua), container | Command's container | Base-class change |

Every gameplay effect stays in Stats, Osiris and Khonsu (`DM-T1`, `DM-P10`); only SG18 touches the PC deck.

---

## 11. Verification

One rule per test (`27.06`); to merge into ARC-0010 and `61.02/Resonant`.

| V# | Fight | Metric | Right if | Wrong if | SG |
|---|---|---|---|---|---|
| V1 | Level 7–9, any | Ecstasy / Admiration / Amazement on the same creature on consecutive turns | never | ever | SG1 |
| V2 | Level 5, an enemy with Bored | Temper on it on consecutive turns with a lost action each time | impossible without a new Disgust Surge | possible | SG1 |
| V3 | Level 9, Contagion + Tier II | Extra actions granted per fight | ≤ one per creature | more | SG2 |
| V4 | Level 1–3, normal fights | Turns where the Resonant had nothing useful to do | 0 | ≥ 1 per fight | SG3, SG4 |
| V5 | Level 3 and 7 | Turns spent full; hold vs release | sometimes held, sometimes released | always at once, or never released | SG4 |
| V6 | Level 7–9, boss | Feelings on the ultimate's target at release | average ≥ 1.5 | under 1.5 | SG5 |
| V7 | Level 5–7, a full day | Releases per day | 1–2 | ≥ 3 | SG6 |
| V8 | Level-ups 1 → 12 | The player names what changed at each level (ask) | every level with content | a level they can't name | SG10, SG11 |
| V9 | PC, levels 3–9 | Turns where the needed Surge was not in hand | < ‹25 %› | ≥ ‹25 %› → SG18 | SG18 |
| V10 | Level 11 | Hindering feelings on allies without the player's choice | 0 | > 0 | SG8 |
| V11 | Level 12, long fight | Area release in fights that wake Tier III | every one | any missed | SG7 |

**Qualitative questions** after each session (`27.06`): *What did you want to do that you couldn't? When did you feel
strongest? When did you feel the Resonant level up? What would you call its signature?*

---

## 12. Rollout and propagation

**Order of decisions** (one question per message; grouped where they form one design):

1. **Loops:** SG1 → SG2 (SG2's need depends on SG1's answer).
2. **The Overload as one design:** SG3 → SG4 → SG5 → SG6 → SG7.
3. **Allies and the capstone:** SG8 → SG9.
4. **The map:** SG10 → SG11.
5. **Growth (one balance pass):** SG15, SG16, SG17.
6. **Texts:** SG12, SG13, SG14.
7. **Measure first:** SG18.

Each approved SG becomes R49+ in `DECISIONS.md` ("Owner, from SG#"); `DESIGN.md` is rewritten in the present tense; the
build goes through a spec in `55` and the usual apply chain.

| Artifact | Owner role | Touched by |
|---|---|---|
| `21.04/Resonant/DECISIONS.md`, `DESIGN.md` | Lead Class Designer | every approved SG |
| `21.03/Resonant.md`, `21.08` | Lead Class Designer | SG3, SG10, SG11 |
| `25_Master_Data` (`FEAT_Resonant_*`, `SPL_Resonant_*`, `STA_Resonant_*`) | Spell + Balance Designers | SG1–SG7, SG15–SG17 |
| `22.05/Resonant.md`, `26.01/Resonant.md` | Balance Designer | SG1–SG7, SG10, SG15, SG16 |
| `23.02/Resonant/` | Spell Designer | SG1, SG3, SG5, SG8, SG9, SG11, SG15 |
| `31.02`, `32.01/Resonant.md`, `33.03` | Lore Writer | SG1, SG3, SG4, SG8, SG11, SG12, SG14–SG17 |
| `42.04/Resonant.md` | Icon Artist | SG11 (new passive) |
| `55` (spec) | Mod Engineer | every SG that reaches the game |
| `61.02/Resonant/` | QA Lead | V1–V11 |
| `05.02/Resonant.md` | Context Keeper | after the build |
| Player guide (ARC-0006) | Community | after the build |

---

## 13. References

Studio: `_SUBCLASS_STANDARD.md` v2.1, `_SUBCLASS_REFINING.md`, `22.06/Arcana_Power_Budget.md`, `22.05/Resonant.md`,
`26.01/2026-09-17-deck-core-design.md`, `27.03`, `27.04`, `27.06`, `27.08`. Research and the subclass's own sources:
as listed in `REFINE_Resonant.md` §11 (MDA, SDT, prospect theory, cognitive load, peak-end, goal gradient,
kishōtenketsu, lenticular design, feedback loops; Plutchik, Hatfield et al.) — with their status in `27.07`.

---

## Appendix A — what happened to S1–S16

| S | Here | Why |
|---|---|---|
| S1 | **SG3 + SG4** (reworked) | One button with ranks instead of a new name; pressure without a power state (the state is option B) |
| S2 | SG5 | Kept |
| S3 | SG6 | Kept, with the three answers of D4 |
| S4 | **SG1** (widened) | The same fix as a rule, which also covers Temper |
| S5 | SG11 | Kept |
| S6 | **dropped → SG10** | The spread removes the level-5 cliff without moving the rings |
| S7 | SG12 | Kept |
| S8 | SG16 (narrowed) | Only the dice grow; AC and conditions don't need it |
| S9 | **dropped → SG17** | It brings back the mechanic R40 removed after P20 |
| S10 | SG15 | Kept |
| S11 | SG7 | Kept |
| S12 | SG9 + SG8 | The filter became a general rule |
| S13 | SG8 + SG10 | The kindness part became a rule; Compassion goes to 10, not 7 |
| S14 | SG18 | Kept, measure first; the deck numbers need the real deck |
| S15 | SG14 | Kept |
| S16 | SG13 | Kept, plus the deck-document note |
| — | **SG2** (new) | The mass loop through R42, the upcast and Contagion |

## Appendix B — the loops, turn by turn

**L2 + L3 (level 9, Tier II awake, Contagion on a Serene ally; three allies near it).**

| Turn | Resonant | Allies | Slots | Actions spent | Gain |
|---|---|---|---|---|---|
| 1 | Contagion (Action, Concentration) on the Serene ally | 3 allies catch Serene | −1 (level-3 card) | Action | setup |
| 2 | Free Surge: Joy upcast on the 3 → Ecstasy ×3; refund | Ecstasy ×3 | ±0 | none | +3A |
| (allies' turns) | — | Ecstasy fades → Serene (today) / nothing (SG1) — Contagion renews Serene either way | | | |
| 3 | Free Surge again → Ecstasy ×3; refund | | ±0 | none | +3A |
| … | the Resonant's own Action is still free every turn | | | | +3A a turn |

With SG2 (A): turn 3 lands plain Joy peaks — each ally has felt its excess this fight.

**L5 (level 5, an enemy carrying Bored).** Turn 1: Temper (Bonus Action, save) → Disgust peak: the enemy can't act;
it fades → Bored again (today). Turn 2: Temper again. With SG1 the replayed Disgust leaves nothing: a second lock needs a
new Disgust Surge (a slot and a save) and a new fade.
