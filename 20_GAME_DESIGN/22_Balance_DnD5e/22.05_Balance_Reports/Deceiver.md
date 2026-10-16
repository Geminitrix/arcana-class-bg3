---
id: 22.05/Deceiver
owner: Balance Designer
source: 21.04/Deceiver/DECISIONS.md (DV1–DV30), DESIGN.md §12, REFINE_Deceiver.md §5, 25 (*_Deceiver_*)
reviewed: 2026-10-16 ARC-0019 — created (propagation, 00.08); directions only, values in the balance pass; 2026-10-16 ARC-0020 — sizes of the build approved (section ARC-0020); 2026-10-16 ARC-0020 — sizes approved (25), names patch drafted; no change; 2026-10-16 ARC-0021 — display name checked, no change; 2026-10-16 ARC-0020 — Task 0.5 prepared (Splinter on Command), no change
---

# 22.05 · Balance — The Deceiver (current verdict)

No balance arithmetic has been recorded for the Deceiver yet: the Veil build (DV1–DV17, 2026-10-07) shipped without a
balance report and is largely untested in game (`05.02` §8). This file holds the **direction** of each ARC-0019 change
(DV18–DV30) and what would prove it wrong. Values: `25` (`*_Deceiver_*`); new sizes, approved 2026-10-16 (section ARC-0020), are in the
`pending_build` blocks until the balance pass. Currency and parameters: `22.06/Arcana_Power_Budget.md`.

## Today's game (Veil build) — verdict until tested

| Feature | Verdict | Why |
|---|---|---|
| Doubles: cap 3 / 4 / 5, +1 AC each (DV4, DV7, DV16) | ⚠️ **watch** | Up to 5 extra bodies × 1 action each, plus up to +5 AC for her. Paid by cards and lost to any hit or area; DV16 keeps the caps until a playtest says otherwise |
| Splinter (fixed die, 3 m, 1 Doubt per enemy) | ✅ in band (estimate) | A fixed small burst that costs the Double itself |
| Reflected Seed / Falsehood (half her card at her highest slot, DV17) | ⚠️ **watch** | Scales with her slots × the number of Doubles; the action economy is the risk, not the single hit |
| Seed of Doubt + Twice-Told | ⚠️ **watch** | One burst per Seed, but Twice-Told on Seed of Doubt lays a second Seed in the same turn |
| Doubt → Deluded every third stack | ✅ in band (estimate) | Many sources, but stacks expire after a few turns and reset on Deluded |
| Aspect goals 4 / 7 / 10 | ❓ untested | Whether Tier III wakes in a normal fight is V3 |
| Tier III today: +3 Charisma and Charisma to damage | ❌ off-standard | An ability bonus (DM-A2); replaced by DV21 |

## DV18–DV30 — approved design, not built yet (ARC-0019, 2026-10-16)

| Change | Direction | Knob (`25`, `pending_build`) | Verdict until tested |
|---|---|---|---|
| DV21 Tier III *the lie explodes*: a Double destroyed by an enemy splinters by itself; Splinter's area grows | **Up** at 12, the old Charisma bonus **leaves** | `SPL_Deceiver_Splinter` `tier3_radius_next` 4 m | ⚠️ watch bursts per fight at level 12 (V3); every Double struck becomes damage plus Doubt |
| DV22 Grand Deception reads the Doubles near each enemy | **Up or down** with placement (flat 2 Doubt today) | `SPL_Deceiver_GrandDeception` `doubt_per_double_next` 1, `doubles_range_next` 3 m | ⚠️ can Delude a crowd in one cast; the per-enemy count is the knob (V2) |
| DV24 Splinter on command (bonus action) | **Up** from level 2 | `SPL_Deceiver_SplinterOnCommand` | A burst a turn without an action, paid with a body and its AC; dominant if used every turn — braked on PC by the draw: a deck card (DV32) (V1) |
| DV25 Mirrored Self from a Double's position | Flat (same extra target) | `SPL_Deceiver_MirroredSelf` `plan_b_range_next` 9 m | Positional only; engine support is V4 |
| DV28 the spread map (Twice-Told 7 → 6, Mirrored Spell 12 → 6, Mirrored Self 12 → 10, Friends and Faceless 1 → 2) | **Up** mid-game, flat overall | `level_next` keys | Same content, earlier; watch Twice-Told at 6 with Reflected spells at 5 |
| DV26 Telepathy leaves | Flat (utility) | `FEAT_Deceiver_TheVeil` `telepathy_next` | — |
| DV19, DV29 one passive, new names | Flat | `name_next` keys | — |

**Net reading:** power moves from a flat Tier III stat bonus into the Doubles (Tier III burst, Splinter on command) and
into positioning (Grand Deception). The Presence axis (DV18) is the brake: every burst spends a body and its AC.

## ARC-0020 — sizes approved by the Owner (2026-10-16)

Assumptions (`22.06` §1): T = 4 turns per fight; level 12 → A = 11; WIS save at T3: DC 17 vs +3 → p_fail 0.65.
One **Doubt** ≈ 0.3A: Deluded is Confused 1 turn (≈ 65% of a turn negated ≈ 1.3A), a third of it per stack, discounted
for stacks that expire before the third. One enemy caught by a **Splinter** ≈ 3.5 damage + 3.3 Doubt ≈ 6.8.
Enemies caught by radius (Double placed beside them): 3 m → 1.5 · 4 m → 2 · 5 m → 2.5.

| Size (`25`) | Value | Arithmetic | Verdict |
|---|---|---|---|
| `SPL_Deceiver_Splinter.tier3_radius_next` | 4 m | Burst on a destroyed Double: 2 × 6.8 ≈ 13.6; ~2 per fight after waking + wider manual Splinters (+0.5 target × 6.8 × ~2) ≈ 34 per fight ≈ 27% of a fight's budget (504 / 4 = 126). Old Tier III (+3 CHA, CHA to Arcane damage) ≈ 16–20. 5 m would be ≈ 45 | Up at 12, the peak; lean weak: 4 m, not 5 (V3) |
| `SPL_Deceiver_GrandDeception.doubles_range_next` · `doubt_per_double_next` | 3 m · 1 | Old: 3 enemies × 0.65 × 2 Doubt × 3.3 ≈ 12.9. New: Double–enemy pairs within 3 m × 0.65 × 3.3 — placed well (≈ 6 pairs) ≈ 12.9, carelessly (≈ 3.75) ≈ 8. With 2 per Double, two Doubles would Delude every enemy that fails | Flat when placed, down when not — the ultimate reads the state (V2) |
| `SPL_Deceiver_SplinterOnCommand.range_next` · `threads_next` | 18 m · 1 Thread | Level 1–4 (A = 4): a Splinter ≈ 1.5 × (3.5 + 1.2) ≈ 7, which the Double could cast on its own turn anyway; the gain is tempo (bursts before it dies ≈ 0.4 × 7 ≈ 2.8, plus a Seed burst the same turn ≈ 1) ≈ 3.8 vs the Bonus Action (0.6A ≈ 2.4) + 1 Thread | Slightly up, braked by the draw (DV32) (V1, V1b) |
| `SPL_Deceiver_MirroredSelf.plan_b_range_next` | 9 m | Only if probe B4 fails; Eidolon's summon range | — |

## What would prove it wrong (playtest — merge into the playtest ticket)

| V# | Fight | Metric | Right if | Wrong if |
|---|---|---|---|---|
| V1 | Level 2, any | Turns with Splinter on command | Used in most fights, not every turn | Never, or every turn |
| V2 | Level 11 | Doubt from Grand Deception with Doubles placed vs none | Placement changes the result clearly | Same either way |
| V3 | Level 12, Tier III | Turn Tier III wakes; bursts per fight | Wakes in a normal fight; bursts feel like the peak | Wakes after the fight is decided |
| V4 | Level 10 | Mirrored Self's extra target from a Double's position | Works in the engine | Needs plan B |
