---
id: ARC-0001
title: Remove the dead PassivesRemoved at Deceiver level 20
type: chore
epic: EPIC_Rework_Subclasses
status: done
owner: Engineering
implementation: claude
priority: should
value: 2
effort: 1
inputs: [51/Public/…/Progressions/Progressions.lsx, 10.06/Open_Questions.md#7]
outputs: [55/SPEC_ARC-0001.md, 61.02/TC_ARC-0001.md, Data Progressions.lsx + Progressions.tbl, 51 synced, 94/ARC-0001_2026-10-11 (backup)]
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

- [x] The Deceiver level-20 row (UUID `2c4887f9-d4f8-4a95-974c-519643440029`) has no `PassivesRemoved`.
- [x] No other progression row changed (`compare_versions` shows only this row's file).
- [x] `validate.pl` passes with 0 errors; its expansion list no longer shows "Deceiver level 20".
- [x] The Stats entry `Arcana_Passive_UnlockFriends` is untouched (published entries are never deleted).

## Gates

- [x] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15): 1 n/a (no feature) · 2 n/a · 3 n/a · 4 n/a ·
      5 n/a · 6 nothing grants the passive, so removing its removal changes no interaction · 7 the row is
      in the 13–20 module, the core is untouched · 8 intent written above.
- [x] Narrative gate: no player-facing text.
- [x] DoD (`00.03`)

## Log

- 2026-10-11 — created from Open_Questions item 7 as the Sprint 0 pilot; spec written; waiting for the
  Owner to implement in the Toolkit.
- 2026-10-11 — Owner asked "[fechado] implementa o ARC-0001": implementation → claude. Backup of both files in
  `94_Safety_Backups/ARC-0001_2026-10-11/`. Removed the `PassivesRemoved` line from the game copy in both places
  the Toolkit keeps it: `Public/…/Progressions/Progressions.lsx` (what the game reads) and
  `Editor/Mods/…/Progressions/Progressions.tbl` (what the Toolkit edits) — otherwise the next Toolkit save would
  restore it. TC_ARC-0001 passed (5/5), both XML files parse, `dump_progression` shows Deceiver L20 empty. Done.
