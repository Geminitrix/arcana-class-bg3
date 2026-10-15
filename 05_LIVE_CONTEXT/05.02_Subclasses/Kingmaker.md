---
source: 51 (Progressions, ClassDescriptions, Stats, Story goal ARCANA_Kingmaker_Wheel; dump_progression.pl 2026-10-15) · 21.04/Kingmaker/DESIGN.md · HANDOFF ARC-0008
synced_at: 2026-10-15 (ARC-0008 propagation)
state: synced
---

# ⏳ The Kingmaker — X · Wheel of Fortune · Aspect of Anticipation

**Built in the game files (levels 1–12, ARC-0008 stages 1–6); no probe played yet; not in the published 3.1.0.28.**
Was *the Spinner* (renamed and redesigned in ARC-0008). Force multiplier: creatures ride the Wheel of Fortune's four
positions; an enemy that falls while an ally reigns suffers a Crossing. Casts with INT, secondary CHA. Design:
`21.04/Kingmaker/DESIGN.md`; decisions SP47–SP114: `21.04/Kingmaker/DECISIONS.md`. Tag `THEKINGMAKER`
(`f9985485-9df1-43a7-b603-52ac336ebb01`); progression `a688d11f-edff-44c5-95ac-0e4999ebf876` (the former Spinner
placeholder).

## Chassis
Saves CHA, WIS · Light and Medium armour · Simple weapons, Rapiers, Hand Crossbows · skill list *The Courtier* (4 + 2
Expertise) · preset STR 8 DEX 12 CON 13 INT 15 WIS 8 CHA 15 · starting gear `EQP_CC_Kingmaker` · sound set Sorcerer ·
colour teal.

## Progression in the game
| Level | Granted |
|---|---|
| 1 | The Rota · Spoke of the Wheel (cantrip) · Coronation · Dethrone · Turn the Spoke |
| 3 | The Crossing · *10 - Wheel of Fortune: Awakening* · Tier I Tyche · Atropos' Cut |
| 5 | Peripeteia · Convene the Court (King's Hand, Lord Commander, Master of Healing) |
| 7 | Hubris · Tier II Nemesis · Usurp · Court + Master of Laws, Master of Secrets (passive *The Court: second circle*, hidden) |
| 9 | Succession · Wheel of Ixion · Court + Master of Coin, Master of Ships (passive *The Court: third circle*, hidden) |
| 11 | The Wheel Stops |
| 12 | Fortune's Reach · Tier III Aspect of Anticipation |

## How it works in the game
- **The Wheel:** positions Rising → Reigning → Falling → Fallen are permanent statuses (`KINGMAKER_*`) moved by Osiris
  (`ARCANA_Kingmaker_Wheel`) at the Kingmaker's turn start, also while it is downed; a creature leaves on death, combat
  end or Atropos' Cut. Side fixed on entry. The ally Reigning longest is **King**, other Reigning allies **Regent**;
  summons are never King. Two Kingmakers keep separate Wheels (SP113).
- **Binding:** Coronation (Bonus Action) → Rising; Dethrone → Falling whatever the save; Wheel of Ixion binds a whole
  line Falling. Turn the Spoke (Bonus Action, no slot) moves one creature a step on.
- **The Crossing** (3+): an enemy entering Fallen with a Reigning ally within 9 m takes 1d4 / 1d6 / 1d8 Force, once per
  enemy per round; Hubris (7+) adds a die after the enemy reigned; Fortune's Reach (12) removes the range.
- **The Court** (5+): offices up to the CHA modifier, out of combat, until the Long Rest; never the Kingmaker; Master of
  Coin returns one slot once per Long Rest (SP109).
- **Turning points:** Peripeteia (once per combat) flips every position within 18 m; Usurp swaps an ally and an enemy;
  The Wheel Stops (Unique, once per Long Rest) freezes the turn for 2 of the Kingmaker's turns, cards still move
  creatures (SP112).
- **Aspect Awakening 10 - Wheel of Fortune:** goal = Crossings, **counts down** (3 / 5 / 8; a lone enemy counts 2);
  I Tyche (bindings one position ahead; Rota Fortunae) · II Nemesis (a Hubris Crossing drops nearby Falling enemies) ·
  III Aspect of Anticipation (allies never Fallen; Ready: Foreseen, readied with a Bonus Action, SP114).
- Every id: `05.03`, `05.04`.

## Strengths · weaknesses
Makes the party stronger on each one's own turn · one Wheel for both sides · big turning points —
needs the party near (9 m) · weak alone at level 1–4 · allies who reign will fall.

## Depth audit (2026-10-13, updated 2026-10-15 after the build)
Against `21.04/_SUBCLASS_STANDARD.md` §3.

| Question | State | Evidence / what is still due |
|---|---|---|
| I1 fun | ⚠️ | Not played yet — probes P1–P48 and the balance playtest (`61.02/Kingmaker/TC_ARC-0008.md`) |
| I2–I6 | ✅ | "One rises as another falls"; the kingmaker archetype; Anticipation (the next position is known); axis Balance (free); names from the card, myth, history and the Small Council |
| S1–S6 | ✅ | Card read literally; Fortuna, Nemesis, Atropos, Ixion; phase in a cycle; the Small Council, DIO / Faceless Void / Bard |
| W1 | ✅ | SP95's class-description sentence (in game) |
| W2 the Weave in the features | ⚠️ | Threads only in The Rota and Atropos' Cut (`32.01/Kingmaker.md`); the English pass (ARC-0006) can weave more in |
| M1–M6 | ✅ | Exclusive positions; one rule (The Rota); a new rule or verb at 3, 5, 7, 9, 11, 12; Crossings once per enemy per round |
| K1–K6 | ✅ | Ultimate Peripeteia; two Bonus Action plays and the cantrip at level 1 |
| P1–P6, P8–P10 | ✅ | Specialist in party amplification; payoff on turn 2 (turn 1 with Tyche); no SE |
| P7 readable | ⚠️ | Positions and King on the portrait; the 9 m Crossing range is invisible until level 12 |
| A1–A3 | ✅ | Goal = Crossings; the tiers push the Wheel |
| B1–B4 | ⚠️ | Numbers in `25`, verdict ≈ 92 % at T2 (`22.05/Kingmaker.md`); watch the Awakening pace and three Bonus Action users (`26.01/Kingmaker.md`) |
| T1–T3 | ✅ | Osiris + Stats; vanilla patterns; upcasts generated |
| T4 conventions | ✅ | Ids fixed and built (`SPEC_ARC-0008`) |
| D1 Identity Sheet | ⚠️ | Emoji and Aspect VFX open |
| D2 sources agree | ⚠️ | Documents propagated 2026-10-15; the subclass icon files are still `Spinner.DDS` (SPEC stage 7) |

**Complexity budget (§15, a suggestion):** 11 combat actions by level 12 and one utility; one main resource
(positions) and one secondary (the Court).

## Open
Probes P1–P48 (Owner) · SPEC stage 7: PC deck (`CardDB.lua`), renames, icons — the subclass icon doesn't show
(`42.04/Kingmaker.md`) · emoji and Aspect VFX · the role sits close to the Resonant's; a magical burst/DPR subclass is
planned (Owner, 2026-10-13).
