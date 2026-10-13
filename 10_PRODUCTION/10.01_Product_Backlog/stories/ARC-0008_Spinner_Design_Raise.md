---
id: ARC-0008
title: Raise the Spinner to the subclass standard (design)
type: design
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Lead Class Designer
implementation: pending
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/Spinner/2026-10-08-spinner-design.md, 05.02/Spinner.md, 21.08_Subclass_Matrix.md]
outputs: [55/_wip/Spinner/decisions.md, 05/HANDOFF_LeadClassDesigner_to_ContextKeeper_ARC-0008.md]
blocked_by: []
sprint:
created: 2026-10-13
---

# ARC-0008 · Raise the Spinner to the subclass standard (design)

**Goal:** audit the Spinner against the evaluation questions of `_SUBCLASS_STANDARD.md` and close every
gap in a raising spec, so it reaches the level the Resonant reached in ARC-0002.
**Intent:** the Spinner plays its timed-fate mechanic — fates that count down, the Cascade, the wheel of
elements — with an ultimate that ties it together and a kit the player can hold in their head.

## Acceptance criteria

- [x] Every evaluative question of §3 answered for the Spinner (✅ / ⚠️ / ❌ with evidence).
- [x] The decisions of the 2026-10-08 design conversation recorded in `55/_wip/Spinner/decisions.md` (SP1–SP43).
- [x] Depth audit handed to the Context Keeper for `05.02/Spinner.md`.
- [ ] Every ❌ and ⚠️ resolved by a decision in `55/_wip/Spinner/decisions.md` or listed as open.
- [ ] Raising spec written in `21.04/Spinner/` (§1.5 sections, Identity Sheet complete, no audit inside).
- [ ] Balance pass: numbers in `25.01`–`25.03`, arithmetic in `22.05`.

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-08 — design conversation (before the project migration): `21.04/Spinner/2026-10-08-spinner-design.md`.
- 2026-10-13 — created; decisions SP1–SP43 recorded from that conversation; audit against the current
  §3 done and handed to the Context Keeper. Gaps to brainstorm, in order: **K3 ultimate** (and A3), the
  **complexity budget** (§15: ~25 combat actions), then I6 names, W1, D1/D2; balance pass after.
- 2026-10-13 — three alternative proposals for the raise (A Measured Thread · B Rise and Fall · C Fortuna's
  Wager) in `55/_wip/Spinner/2026-10-13-spinner-three-proposals.md`; awaiting the Owner's choice (SP47).
- 2026-10-13 — brainstorm with the Owner: direction B *Rise and Fall* chosen, subclass renamed **The Kingmaker**;
  decisions SP47–SP71 (Wheel positions, King/Regent, the Court/Small Council, verbs, Crossing, Cut, Peripeteia,
  The Wheel Stops, chassis, progression). Next: Hubris fix, Awakening, card details, edge cases, raising spec.
