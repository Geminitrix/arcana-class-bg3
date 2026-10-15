---
id: ARC-0014
title: "Resonant design review: balance, structure and felt progression (proposals S1–S16)"
type: design
epic: EPIC_Rework_Subclasses
status: review
owner: Lead Class Designer
implementation: pending
priority: should
value: 4
effort: 2
inputs: [21.04/Resonant/DESIGN.md, 21.04/Resonant/DECISIONS.md, 21.04/_SUBCLASS_STANDARD.md, 25, 22.05/Resonant.md, 22.06, 26.01/Resonant.md]
outputs: [21.04/Resonant/REFINE_Resonant.md, 21.04/Resonant/REFINE_Resonant_2026-10-15.md]
blocked_by: []
sprint:
created: 2026-10-15
---

# ARC-0014 · Resonant design review: balance, structure and felt progression

**Goal:** an end-to-end review of the Resonant (R1–R48) against the Depth Model and game-design research, with every
suggested change, its reasons, alternatives, impact and verification.
**Intent:** tighten the kit around its core rule and make the 1–12 progression felt, before the 4.0 build.

## Acceptance criteria
- [x] Review written: `21.04/Resonant/REFINE_Resonant.md` (S1–S16, playtest metrics V1–V11)
- [x] v2-format review written: `21.04/Resonant/REFINE_Resonant_2026-10-15.md` (SG1–SG18, V1–V11; brainstorm order in §12)
- [ ] Owner reviews each suggestion (brainstorm order in §10.1 of the review)
- [ ] Approved suggestions logged as R49+ in `DECISIONS.md` and propagated (00.08)
- [ ] Playtest metrics merged into ARC-0010

## Log

- 2026-10-15 — review written at the Owner's request; status `review`. Nothing in the design, master data or game
  files changed.
- 2026-10-15 — At the Owner's request, the proposal was analysed with the refining method and rewritten in the v2 format as `REFINE_Resonant_2026-10-15.md` (the proposal stays as the record). Checked against the generator and `25`: the Intensify loop is wider than S4 says (upcast, R42, Contagion → mass extra actions; enemy stun-lock), Temper renews its own mood (a Bonus-Action lock), S9 contradicts R40. New: SG1 (a used mood is spent), SG2 (excess once per fight), SG8 (kindness rule), SG10 (level map over every level — Owner decision D9, standard v2.1), SG17; S6 and S9 dropped. Nothing in the design, `25` or the game changed.
- 2026-10-15 — Owner approved SG1 → R49 (a used mood is spent; Temper reworked, replaces R36). `DESIGN.md` and the build follow at the end of the brainstorm round.
