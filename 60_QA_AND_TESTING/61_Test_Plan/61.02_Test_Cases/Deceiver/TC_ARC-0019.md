---
id: 61.02/Deceiver/TC_ARC-0019
owner: QA Lead
source: 21.04/Deceiver/DECISIONS.md DV1–DV30 · REFINE_Deceiver.md §5 · DESIGN.md §13, §15 · 05.02/Deceiver.md §8
reviewed: 2026-10-16 ARC-0019 — created (propagation, 00.08); 2026-10-16 ARC-0020 — sizes approved (25), names patch drafted; no change; 2026-10-16 ARC-0021 — display name checked, no change; 2026-10-16 ARC-0020 — Task 0.5 prepared (Splinter on Command), no change
status: part A runnable now on the Veil build; parts B and C planned — run after the ARC-0019 build ships
---

# TC_ARC-0019 · The Deceiver — the Veil build and the refining (DV18–DV30)

**Decision it informs:** close the ARC-0019 build, or send a failing rule back to the Lead Class Designer; part A also
decides whether the Veil build (DV1–DV17) is sound enough to build on.
**Scenario:** console edition (no SE), a Deceiver built through the real progression, the standard saves of `83.02`;
the PC (SE) edition where marked. Compile the Story after any apply. Values: `25` (`*_Deceiver_*`).

## A · The Veil build, untested since 2026-10-07 (`05.02` §8) — runnable today

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| A1 | The Doubles' spells follow her tier (the shapeshift rule switch) | Level 1–4: Splinter + Dismiss only · 5: + Mirror: Sigil and Mirror: Chains · 9: + Unveil | The goal re-applies the rule on level-up |
| A2 | Mirror damage is half her card at her highest slot (DV17) | Level 5 (slot 3): Mirror: Sigil deals (3d6)/2 Force and lays her Sigil | Fixed variants per slot band |
| A3 | Veiled Prison saves with Disadvantage at 2+ Doubt | Doubt 2 → the save shows Disadvantage; Doubt 1 → normal | — |
| A4 | Grand Deception fills the cap and gives Doubt on a failed save | Doubles up to the cap; each failing enemy within 9 m gains 2 Doubt (1 → Deluded at 3) | — |
| A5 | Awakening steps count Doubt stacks | Goals 4 / 7 / 10 count down on the progress status; each tier wakes at its goal | — |
| A6 | Two Pillars (Tier II) | Once per turn, a Deluded enemy in her name seeds the nearest unmarked enemy within 6 m | — |
| A7 | Which One? (Tier III): whose Doubt | The attacker gains Doubt **in her name** (counts for her Awakening) | Raise it through the Doubt goal with her as the cause |
| A8 | The Veil Lifts makes every Double cast Shatter off its turn | Every Double bursts; every Sigil of hers detonates; survivors with Doubt become Deluded | Explode at each Double's position from Osiris |

## B · Probes for the ARC-0019 build (one rule each — run first, they decide the spec)

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| B1 | The Tier III burst on death (DV21, vanilla Death Burst pattern) | A Double destroyed by an enemy explodes at its last position with the wider radius; the Doubt is hers | A Splinter cast by Osiris at the Double's position before it is removed |
| B2 | Only the "destroyed by an enemy" path bursts (DESIGN §4.8) | Dismiss, the cap, combat end, an ally's spell, her death: **no** burst, no Doubt | Tag the cleanup paths before the Double dies |
| B3 | Splinter on command (DV24, DV31) picks one Double | The chosen Double splinters now; bonus action spent; no slot; on PC it costs Threads and is drawn from the deck (DV32) | Target the Double with the spell |
| B4 | Grand Deception counts Doubles near each enemy **before** the new ones appear (DV22) | Doubt per enemy = Doubles within 3 m of it before the cast (`25` `doubles_range_next`) | Snapshot the Doubles' positions on cast |
| B5 | The level map (DV28) | `dump_progression.pl`: the rows of DESIGN §9.1, levels 4 and 8 empty, no Telepathy | — |
| B6 | One visible passive (DV19) | The Veil states the core rule; no *Doubt* passive in the list | — |
| B7 | Names (DV29) | Every name in `32.01/Deceiver.md` "after the build"; no Sigil, Shatter, Mirror Image, Distortion, Ethereal Chains or Mimic in a tooltip | — |

## C · Rules (verification rows of the review, `REFINE_Deceiver.md` §5)

| # | Fight | Metric | Right if | Wrong if | Decision |
|---|---|---|---|---|---|
| V1 | Level 2, any | Turns where Splinter on command is used | Used in most fights, not every turn | Never used, or used every turn (dominant) | DV24 |
| V1b | Level 2, PC | Share of turns Splinter on command is in hand when a Double is on the field | Often enough to plan around (DM-P12) | Rarely in hand when it matters | DV32 |
| V2 | Level 11 | Doubt from Grand Deception with Doubles placed vs none | Placement changes the result clearly | Same result either way | DV22 |
| V3 | Level 12, Tier III | Turn Tier III wakes; bursts per fight | Wakes in a normal fight; bursts feel like the peak | Wakes after the fight is decided | DV21 |
| V4 | Level 10 | Mirrored Self's extra target from a Double's position | Works in the engine | Engine can't origin it (plan B: a Double within 9 m (`25` `plan_b_range_next`)) | DV25 |

**Qualitative questions** after each session (`27.06`): *What did you want to do that you couldn't? When did you feel
strongest? When did you keep a Double instead of spending it, and why? What would you call its signature?*
