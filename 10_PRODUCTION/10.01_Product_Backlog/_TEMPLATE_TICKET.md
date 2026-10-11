---
id: ARC-####
title: <short title>
type: feature            # feature | rework | bug | chore | research | design
epic: <EPIC_…>
status: backlog          # backlog | ready | in_progress | blocked | spec_ready | in_qa | done
owner: <role>            # the department that owns the outcome
implementation: pending  # pending | owner | claude  (00.07)
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
