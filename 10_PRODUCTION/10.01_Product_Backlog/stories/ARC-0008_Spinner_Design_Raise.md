---
id: ARC-0008
title: Raise the Kingmaker (was the Spinner) to the subclass standard (design)
type: design
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Lead Class Designer
implementation: pending
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 55/_wip/Kingmaker/2026-10-13-spinner-three-proposals.md, 05.02/Spinner.md, 21.08_Subclass_Matrix.md]
outputs: [55/_wip/Kingmaker/decisions.md, 21.04/Kingmaker/2026-10-13-kingmaker-design.md, 55/_TEMPLATE_TOOLKIT_GUIDE.md, 90/93/2026-10-13_ARC-0008_spinner_audit, 90/93/2026-10-13_ARC-0008_spinner_design]
blocked_by: []
sprint:
created: 2026-10-13
---

# ARC-0008 · Raise the Kingmaker (was the Spinner) to the subclass standard (design)

**Goal:** audit the Spinner against the evaluation questions of `_SUBCLASS_STANDARD.md` and close every
gap in a raising spec, so it reaches the level the Resonant reached in ARC-0002.
**Intent:** the Spinner plays its timed-fate mechanic — fates that count down, the Cascade, the wheel of
elements — with an ultimate that ties it together and a kit the player can hold in their head.

## Acceptance criteria

- [x] Every evaluative question of §3 answered for the Spinner (✅ / ⚠️ / ❌ with evidence).
- [x] The decisions of the 2026-10-08 design conversation recorded in `55/_wip/Spinner/decisions.md` (SP1–SP43).
- [x] Depth audit of the old Spinner handed to the Context Keeper, then archived (design replaced). The Kingmaker audit goes with its 05 handoff.
- [x] Handoffs for the Kingmaker: Context Keeper (`05.02` + Depth audit, `05.00`, `05.06`), Lore Writer (`31.01`), Localization (`33.03`); `21.08` Kingmaker column with Axis = Balance; `10.06` updated.
- [x] Every gap resolved by a decision in `55/_wip/Kingmaker/decisions.md` (SP47–SP103) or listed as open (spec §14).
- [x] Raising spec written: `21.04/Kingmaker/2026-10-13-kingmaker-design.md` (§1.5 sections, Identity Sheet complete, no audit inside).
- [x] Balance pass: numbers in `25.01`–`25.02` (11 SPL, 6 FEAT), arithmetic in `22.05/2026-10-13_ARC-0008_Kingmaker_Balance.md` (approved).

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
- 2026-10-13 — SP72 (Hubris: who reigned falls harder). The old Spinner audit handoff, never applied, archived in
  `90/93/2026-10-13_ARC-0008_spinner_audit` (design replaced by the Kingmaker); the Kingmaker gets its own audit
  with the raising spec. Owner's note: the Kingmaker's role sits close to the Resonant's (support through states)
  and the mod still lacks a magical burst/DPR subclass — a future tarot card will fill that gap (not this ticket).
- 2026-10-13 — brainstorm closed: SP72–SP103 (Hubris, Succession, Awakening Tyche/Nemesis/Aspect of Anticipation,
  Usurp, Foreseen, card details, edge cases, Identity Sheet, names, Osiris drives the Wheel). Before the spec, at the
  Owner's request: the Toolkit entry guide standard `55/_TEMPLATE_TOOLKIT_GUIDE.md` (one `TOOLKIT_ARC-####.md` per
  ticket beside its SPEC; icons as suggestions; generated families not typed) and the ADR-0005 amendment proposal
  `00.04/PROPOSALS/PROPOSAL_Toolkit_Guide_Derived_Numbers.md`. Next: the raising spec in `21.04/Kingmaker/`.
- 2026-10-13 — raising spec `21.04/Kingmaker/2026-10-13-kingmaker-design.md` written; the Spinner spec archived in
  `90/93/2026-10-13_ARC-0008_spinner_design`; `55/_wip/Spinner` renamed `55/_wip/Kingmaker`. Self-review found two
  open rules (Master of Healing "toward Reigning" and Master of Laws "one extra position" conflict with SP62 / can
  help the enemy) — listed in spec §14 for the Owner. Next: handoff to the Context Keeper, balance pass.
- 2026-10-13 — SP104 (Master of Healing forward only), SP105 (Master of Laws never past Fallen, never up to
  Reigning). Kingmaker Depth audit (✅ most; ⚠️ I1, W2, P7, T2, T4, D1, D2; ❌ B — balance pass) in
  `05/HANDOFF_LeadClassDesigner_to_ContextKeeper_ARC-0008.md`; handoffs to the Lore Writer (`31`) and Localization
  (`33`); `21.08` gains the Kingmaker column (Axis = Balance; Deceiver Aspect corrected to Doubt); `10.06` updated.
  Next: balance pass (`25`, `22.05`).
- 2026-10-13 — balance pass written (proposed): `22.05/2026-10-13_ARC-0008_Kingmaker_Balance.md` — Crossing 1d4/1d6/1d8
  Force, Hubris +1 die, Dethrone 3d6 (+1d6/slot), cantrip 1d6 (+1d4 vs Falling/Fallen), Cut 3d8/2d8/1d8 by position,
  Ixion 5d6, The Wheel Stops 2 turns, positions ±3 m (Longstrider / Ray of Frost patterns), goals 3/5/8; ≈ 92 % of the
  budget at T2. Six design changes for the Owner (§7) before the numbers go to `25`.
- 2026-10-13 — balance pass approved with SP106–SP111 (Coronation Bonus Action, Turn the Spoke no slot, Peripeteia
  level-3 card + once per combat, Master of Coin once per Long Rest, Crossing Force, lone enemy counts 2). Numbers in
  `25.01` (11 `SPL_Kingmaker_*`) and `25.02` (6 `FEAT_Kingmaker_*`); spec updated; validate.pl 0 errors. Next: Design
  gate (§15), then `SPEC_ARC-0008` and `TOOLKIT_ARC-0008`.
