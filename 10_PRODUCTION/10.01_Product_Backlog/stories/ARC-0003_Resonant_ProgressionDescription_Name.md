---
id: ARC-0003
title: Rename the Resonant's ProgressionDescription Name (last Heartweaver leftover)
type: chore
epic: EPIC_Rework_Subclasses
status: done
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

- [x] `ProgressionDescriptions.tbl` line with UUID `af80da6f-aa3a-58f8-a1c5-a7a9a7687751` has Name `New_Stat_Resonant`.
- [x] No "heartweaver" left in `Data/{Mods,Public,Editor}/AspectClass_…` (grep, case-insensitive).
- [x] `sync_data`, commit + push.
- [x] The Toolkit opens the ProgressionDescriptions table without errors (Owner).

## Gates

- [x] DoD (`00.03`)

## Log

- 2026-10-11 — created. Checked: ClassDescription Name, ProgressionDescription Type, tag `THERESONANT`,
  texts, lists, equipment and Osiris are already renamed; this row name is the only leftover.
- 2026-10-11 — done (`[fechado]`): Name set to `New_Stat_Resonant`; grep finds 0 "heartweaver" in the mod; `sync_data` changed 1 path. Waiting for the Owner to open the table in the Toolkit.
- 2026-10-11 — Owner opened the ProgressionDescriptions table in the Toolkit: no errors. DoD: criteria 4/4; sync_data --check "51 matches Data"; README has no Heartweaver; 05 change sent to the Context Keeper (handoff §4 in `05/HANDOFF_LeadClassDesigner_to_ContextKeeper_ARC-0002.md`). Closed.
