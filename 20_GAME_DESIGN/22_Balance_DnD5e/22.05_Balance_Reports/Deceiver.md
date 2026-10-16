---
id: 22.05/Deceiver
owner: Balance Designer
source: 21.04/Deceiver/DECISIONS.md (DV1–DV30), DESIGN.md §12, REFINE_Deceiver.md §5, 25 (*_Deceiver_*)
reviewed: 2026-10-16 ARC-0019 — created (propagation, 00.08); directions only, values in the balance pass
---

# 22.05 · Balance — The Deceiver (current verdict)

No balance arithmetic has been recorded for the Deceiver yet: the Veil build (DV1–DV17, 2026-10-07) shipped without a
balance report and is largely untested in game (`05.02` §8). This file holds the **direction** of each ARC-0019 change
(DV18–DV30) and what would prove it wrong. Values: `25` (`*_Deceiver_*`); new sizes are ‹placeholders› in the
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
| DV21 Tier III *the lie explodes*: a Double destroyed by an enemy splinters by itself; Splinter's area grows | **Up** at 12, the old Charisma bonus **leaves** | `SPL_Deceiver_Splinter` `tier3_radius_next` ‹wide› | ⚠️ watch bursts per fight at level 12 (V3); every Double struck becomes damage plus Doubt |
| DV22 Grand Deception reads the Doubles near each enemy | **Up or down** with placement (flat 2 Doubt today) | `SPL_Deceiver_GrandDeception` `doubt_per_double_next` ‹1›, `doubles_range_next` ‹x› | ⚠️ can Delude a crowd in one cast; the per-enemy count is the knob (V2) |
| DV24 Shatter on command (bonus action) | **Up** from level 2 | `SPL_Deceiver_ShatterOnCommand` | A burst a turn without an action, paid with a body and its AC; dominant if used every turn (V1) |
| DV25 Mirrored Self from a Double's position | Flat (same extra target) | `SPL_Deceiver_MirroredSelf` `plan_b_range_next` ‹x› | Positional only; engine support is V4 |
| DV28 the spread map (Twice-Told 7 → 6, Mirrored Spell 12 → 6, Mirrored Self 12 → 10, Friends and Faceless 1 → 2) | **Up** mid-game, flat overall | `level_next` keys | Same content, earlier; watch Twice-Told at 6 with Reflected spells at 5 |
| DV26 Telepathy leaves | Flat (utility) | `FEAT_Deceiver_TheVeil` `telepathy_next` | — |
| DV19, DV29 one passive, new names | Flat | `name_next` keys | — |

**Net reading:** power moves from a flat Tier III stat bonus into the Doubles (Tier III burst, Shatter on command) and
into positioning (Grand Deception). The Presence axis (DV18) is the brake: every burst spends a body and its AC.

## What would prove it wrong (playtest — merge into the playtest ticket)

| V# | Fight | Metric | Right if | Wrong if |
|---|---|---|---|---|
| V1 | Level 2, any | Turns with Shatter on command | Used in most fights, not every turn | Never, or every turn |
| V2 | Level 11 | Doubt from Grand Deception with Doubles placed vs none | Placement changes the result clearly | Same either way |
| V3 | Level 12, Tier III | Turn Tier III wakes; bursts per fight | Wakes in a normal fight; bursts feel like the peak | Wakes after the fight is decided |
| V4 | Level 10 | Mirrored Self's extra target from a Double's position | Works in the engine | Needs plan B |
