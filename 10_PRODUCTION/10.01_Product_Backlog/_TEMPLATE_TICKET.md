---
id: ARC-####
title: <short title>
type: feature            # feature | rework | bug | chore | research | design
epic: <EPIC_…>
subclass: none           # class | unbound | deceiver | starchild | eternal | resonant | kingmaker | lionheart | none
status: backlog          # backlog | ready | in_progress | blocked | in_review | spec_ready | in_qa | done  (blocked shows in In Progress with a tag)
owner: <role>            # one of the 9 active roles of 00.05 (OR-26)
implementation: pending  # pending (design only) | owner (the Owner types it; Claude verifies and fixes)  (OR-11)
priority: should         # must | should | could | wont  (MoSCoW)
value: 3                 # 1-5
effort: 3                # 1-5
inputs: []               # IDs read, e.g. [25.01/SPL_Example.yaml, 23.02]
outputs: []              # IDs written, e.g. [55/SPEC_ARC-####.md]
blocked_by: []           # departments or tickets
sprint:                  # S## when planned
created: YYYY-MM-DD
---

# ARC-#### · <title>

**Goal:** one sentence.
**Intent:** what this should change in play, in one sentence.

## Acceptance criteria

- [ ] …

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- YYYY-MM-DD — created.
