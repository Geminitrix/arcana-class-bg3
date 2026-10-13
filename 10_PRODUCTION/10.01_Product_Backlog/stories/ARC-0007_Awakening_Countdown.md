---
id: ARC-0007
title: Aspect Awakening counts down, with one standard text
type: feature
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Mod Engineer
implementation: claude
priority: should
value: 3
effort: 2
inputs: [55_Implementation_Specs/SPEC_ARC-0007.md, ARCANA_Aspect_Common.txt]
outputs: [ARCANA_Aspect_Common.txt, Status_BOOST (ASPECT_PROGRESS_*), the five Awakening passives' texts]
blocked_by: []
sprint:
created: 2026-10-12
---

# ARC-0007 · Aspect Awakening counts down, with one standard text

**Goal:** the Awakening number shows how much is left to the next tier, in every subclass.
**Intent:** the player reads the goal on the status itself, without opening the passive.

## Acceptance criteria

- [ ] Fool, High Priestess, Temperance count down their goal; Star and Death show the hit points left (to heal / to lose).
- [ ] The status is named *Awakening* and says, in one line, what is left and which tier it awakens.
- [ ] The five "<N> - <Arcanum>: Awakening" passives follow one shape.
- [ ] Probes A1–A5 of SPEC_ARC-0007 pass.

## Log

- 2026-10-12 — created from the Owner's request; text standard and passive rewrite chosen by the Owner. Plan: SPEC_ARC-0007.
- 2026-10-12 — applied (`[fechado]`): 15 per-tier progress statuses, the countdown in ARCANA_Aspect_Common (COUNT / HEAL / LOSS), the five Awakening passives in one shape; tests 43 + 247, selftest 1023/0, check_cards OK. Owner: compile the Story; probes A1–A5.
