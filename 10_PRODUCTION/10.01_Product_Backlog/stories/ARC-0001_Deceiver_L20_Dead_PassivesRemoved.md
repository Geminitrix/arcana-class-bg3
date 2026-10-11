---
id: ARC-0001
title: Remove the dead PassivesRemoved at Deceiver level 20
type: chore
epic: EPIC_Rework_Subclasses
status: spec_ready
owner: Engineering
implementation: owner
priority: should
value: 2
effort: 1
inputs: [51/Public/…/Progressions/Progressions.lsx, 10.06/Open_Questions.md#7]
outputs: [55/SPEC_ARC-0001.md, 61.02/TC_ARC-0001.md]
blocked_by: []
sprint: S00
created: 2026-10-11
---

# ARC-0001 · Remove the dead PassivesRemoved at Deceiver level 20

**Goal:** delete the `PassivesRemoved: Arcana_Passive_UnlockFriends` value from the Deceiver level-20
progression row.
**Intent:** leave no dead instructions in the Deceiver progression (Friends comes from the list
"Deceiver Level 1" since 2026-10-07, so nothing grants the passive any more). No change in play.

Sprint 0 pilot: proves the flow ticket → spec → Toolkit → sync → validate → QA → context → close.

## Acceptance criteria

- [ ] The Deceiver level-20 row (UUID `2c4887f9-d4f8-4a95-974c-519643440029`) has no `PassivesRemoved`.
- [ ] No other progression row changed (`compare_versions` shows only this row's file).
- [ ] `validate.pl` passes with 0 errors; its expansion list no longer shows "Deceiver level 20".
- [ ] The Stats entry `Arcana_Passive_UnlockFriends` is untouched (published entries are never deleted).

## Gates

- [x] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15): 1 n/a (no feature) · 2 n/a · 3 n/a · 4 n/a ·
      5 n/a · 6 nothing grants the passive, so removing its removal changes no interaction · 7 the row is
      in the 13–20 module, the core is untouched · 8 intent written above.
- [x] Narrative gate: no player-facing text.
- [ ] DoD (`00.03`)

## Log

- 2026-10-11 — created from Open_Questions item 7 as the Sprint 0 pilot; spec written; waiting for the
  Owner to implement in the Toolkit.
