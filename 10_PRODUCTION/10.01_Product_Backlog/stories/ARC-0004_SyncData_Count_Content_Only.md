---
id: ARC-0004
title: sync_data counts content changes only
type: chore
epic: EPIC_Rework_Subclasses
status: done
owner: Tools
implementation: claude
priority: should
value: 2
effort: 1
inputs: [82_Automation/sync_data.sh]
outputs: [82_Automation/sync_data.sh]
blocked_by: []
sprint:
created: 2026-10-12
---

# ARC-0004 · sync_data counts content changes only

**Goal:** the "changed since the last commit" number counts real content changes only.
**Intent:** no more false alarms after the Owner merely opens the Toolkit.

## Acceptance criteria

- [x] A line-ending-only difference is not counted (simulated on `Progressions.tbl`: old count 1, new count 0).
- [x] `meta.lsx` rewritten by the Toolkit (Version64 / MD5) is reported apart, not counted as a mod change.
- [x] New untracked files are still reported.

## Log

- 2026-10-12 — Owner asked why sync_data kept listing Toolkit files. Cause: the Toolkit re-saves
  `Progressions.tbl`, `Status_EFFECT.stats`, `meta.lsx` with other line endings when it opens the project;
  `git status` lists them, but they commit as nothing. Only `Mods/…/meta.lsx` changed for real (Version64 +1,
  MD5) — written by the Toolkit. Count switched to `git diff --ignore-cr-at-eol`. Done.
