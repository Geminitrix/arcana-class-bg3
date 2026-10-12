---
id: ARC-0003
title: Rename the Resonant's ProgressionDescription Name (last Heartweaver leftover)
type: chore
epic: EPIC_Rework_Subclasses
status: ready
owner: Lead Class Designer
implementation: claude
priority: could
value: 1
effort: 1
inputs: [51/Editor/Progressions/ProgressionDescriptions.tbl]
outputs: [Data/Editor/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Progressions/ProgressionDescriptions.tbl]
blocked_by: []
sprint:
created: 2026-10-11
---

# ARC-0003 · Rename the Resonant's ProgressionDescription Name

**Goal:** replace the internal row name `New_Stat_Heartweaver` with `New_Stat_Resonant`.
**Intent:** no "Heartweaver" left anywhere in the mod; nothing changes in play.

## Acceptance criteria

- [ ] `ProgressionDescriptions.tbl` line with UUID `af80da6f-aa3a-58f8-a1c5-a7a9a7687751` has Name `New_Stat_Resonant`.
- [ ] No "heartweaver" left in `Data/{Mods,Public,Editor}/AspectClass_…` (grep, case-insensitive).
- [ ] `sync_data`, commit + push.
- [ ] The Toolkit opens the ProgressionDescriptions table without errors (Owner).

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-10-11 — created. Checked: ClassDescription Name, ProgressionDescription Type, tag `THERESONANT`,
  texts, lists, equipment and Osiris are already renamed; this row name is the only leftover.
