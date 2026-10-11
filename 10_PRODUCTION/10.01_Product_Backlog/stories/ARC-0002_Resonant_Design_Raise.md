---
id: ARC-0002
title: Raise the Resonant to the subclass standard (design)
type: design
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Lead Class Designer
implementation: pending
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/Resonant/2026-10-06-heartweaver-design.md, 55/_wip/Resonant/decisions.md, 05.02/Resonant.md, 75.02/src/data/resonant.json]
outputs: [55/_wip/Resonant/decisions.md, 21.04/Resonant/2026-10-11-resonant-design.md, 05/HANDOFF_LeadClassDesigner_to_ContextKeeper_ARC-0002.md]
blocked_by: []
sprint:
created: 2026-10-11
---

# ARC-0002 · Raise the Resonant to the subclass standard (design)

**Goal:** audit the Resonant against the evaluation questions of `_SUBCLASS_STANDARD.md` and close every
gap in a raising spec.
**Intent:** the Resonant plays its emotion mechanic with impact from level 1 — behaviour-changing
Surges, an overload meter and its Overflow — without running out of slots.

## Acceptance criteria

- [x] Every evaluative question of §3 answered for the Resonant (✅ / ⚠️ / ❌ with evidence).
- [x] Every ❌ and ⚠️ resolved by a decision in `55/_wip/Resonant/decisions.md` or listed as open.
- [x] Raising spec written in `21.04/Resonant/` (§1.5 sections, Identity Sheet complete, no audit inside).
- [x] Depth audit handed to the Context Keeper for `05.02/Resonant.md`.

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-08 — audit and decisions R1–R14 (before the project migration).
- 2026-10-11 — created; decisions R15–R17 (behaviour peaks, slot refund on reaction), R18–R19 (Shared Heart capstone), R20–R21 (names: Emotional Overload, Tier I Resonance).
- 2026-10-11 — raising spec `21.04/Resonant/2026-10-11-resonant-design.md` written; Depth audit handed to the Context Keeper. R22–R23 (Emotional Overload cost, Rage grudge) confirmed by the Owner. Still open: balance pass, in-game tests (spec §15), Toolkit renames, player guide update (`75.02`).
