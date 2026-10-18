---
id: QA_ARC-0020
title: Playtest — The Veilwalker — refining DV1–DV33 (levels 1–12)
type: playtest
subclass: deceiver
build: ARC-0020
status: draft
owner: QA Lead
sources: [TC_ARC-0019]
created: 2026-10-17
---

# QA_ARC-0020 · The Veilwalker — refining DV1–DV33 (levels 1–12)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0020 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from TC_ARC-0019.

> The level-by-level tests are written at the build kit of ARC-0020 (stage 4), from the draft in the appendix.

## Appendix — TC_ARC-0019 (design-stage draft, verbatim)

Header of the original file:

```
id: 61.02/Deceiver/TC_ARC-0019
owner: QA Lead
source: 21.04/Deceiver/DECISIONS.md DV1–DV30 · REFINE_Deceiver.md §5 · DESIGN.md §13, §15 · 05.02/Deceiver.md §8
reviewed: 2026-10-16 ARC-0019 — created (propagation, 00.08); 2026-10-16 ARC-0020 — sizes approved (25), names patch drafted; no change; 2026-10-16 ARC-0021 — display name checked, no change; 2026-10-16 ARC-0020 — Task 0.5 prepared (Splinter on Command), no change; 2026-10-16 ARC-0020 — Tasks 0.6–0.7 prepared, no change; 2026-10-16 ARC-0020 — stage 1 applied (names in game), no change
status: part A runnable now on the Veil build; parts B and C planned — run after the ARC-0019 build ships
```

### TC_ARC-0019 · The Deceiver — the Veil build and the refining (DV18–DV30)

**Decision it informs:** close the ARC-0019 build, or send a failing rule back to the Lead Class Designer; part A also
decides whether the Veil build (DV1–DV17) is sound enough to build on.
**Scenario:** console edition (no SE), a Deceiver built through the real progression, the standard saves of `83.02`;
the PC (SE) edition where marked. Compile the Story after any apply. Values: `25` (`*_Deceiver_*`).

#### A · The Veil build, untested since 2026-10-07 (`05.02` §8) — runnable today

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

#### B · Probes for the ARC-0019 build (one rule each — run first, they decide the spec)

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| B1 | The Tier III burst on death (DV21, vanilla Death Burst pattern) | A Double destroyed by an enemy explodes at its last position with the wider radius; the Doubt is hers | A Splinter cast by Osiris at the Double's position before it is removed |
| B2 | Only the "destroyed by an enemy" path bursts (DESIGN §4.8) | Dismiss, the cap, combat end, an ally's spell, her death: **no** burst, no Doubt | Tag the cleanup paths before the Double dies |
| B3 | Splinter on Command (DV24, DV31) picks one Double | The chosen Double splinters now; bonus action spent; no slot; on PC it costs Threads and is drawn from the deck (DV32) | Target the Double with the spell |
| B4 | Grand Deception counts Doubles near each enemy **before** the new ones appear (DV22) (SPEC_ARC-0020 probe B5) | Doubt per enemy = Doubles within 3 m of it before the cast (`25` `doubles_range_next`) | Snapshot the Doubles' positions on cast |
| B8 | At Tier III the Splinter shout deals nothing itself; the 4 m burst does (SPEC_ARC-0020 probe B6) | One damage number per enemy per Splinter, 4 m reach | A Tier III shapeshift rule with a damage-free Splinter |
| B5 | The level map (DV28) | `dump_progression.pl`: the rows of DESIGN §9.1, levels 4 and 8 empty, no Telepathy | — |
| B6 | One visible passive (DV19) | The Veil states the core rule; no *Doubt* passive in the list | — |
| B7 | Names (DV29) | Every name in `32.01/Deceiver.md` "after the build"; no Sigil, Shatter, Mirror Image, Distortion, Ethereal Chains or Mimic in a tooltip | — |

#### C · Rules (verification rows of the review, `REFINE_Deceiver.md` §5)

| # | Fight | Metric | Right if | Wrong if | Decision |
|---|---|---|---|---|---|
| V1 | Level 2, any | Turns where Splinter on Command is used | Used in most fights, not every turn | Never used, or used every turn (dominant) | DV24 |
| V1b | Level 2, PC | Share of turns Splinter on Command is in hand when a Double is on the field | Often enough to plan around (DM-P12) | Rarely in hand when it matters | DV32 |
| V2 | Level 11 | Doubt from Grand Deception with Doubles placed vs none | Placement changes the result clearly | Same result either way | DV22 |
| V3 | Level 12, Tier III | Turn Tier III wakes; bursts per fight | Wakes in a normal fight; bursts feel like the peak | Wakes after the fight is decided | DV21 |
| V4 | Level 10 | Mirrored Self's extra target from a Double's position | Works in the engine | Engine can't origin it (plan B: a Double within 9 m (`25` `plan_b_range_next`)) | DV25 |

**Qualitative questions** after each session (`27.06`): *What did you want to do that you couldn't? When did you feel
strongest? When did you keep a Double instead of spending it, and why? What would you call its signature?*

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources TC_ARC-0019 merged; nothing removed.
