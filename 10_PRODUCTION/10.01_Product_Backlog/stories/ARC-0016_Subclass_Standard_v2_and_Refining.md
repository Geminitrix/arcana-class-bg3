---
id: ARC-0016
title: "Subclass standard v2 and refining method"
type: design
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Lead Class Designer
implementation: pending
priority: should
value: 4
effort: 3
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/Resonant/BALANCE_SUGGESTIONS.md, 21.04/Resonant/DESIGN.md, 21.04/Resonant/DECISIONS.md, 21.08, 22.06, 27.01, 27.02, 27.03, 27.04, 27.05, 27.06, 27.07, 05.00, 00.08]
outputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/_SUBCLASS_REFINING.md, 27.08_Player_Psychology_and_Progression, 27.07, 93/2026-10-15_SUBCLASS_STANDARD_v1]
blocked_by: []
sprint:
created: 2026-10-15
---

# ARC-0016 · Subclass standard v2 and refining method

**Goal:** rewrite `_SUBCLASS_STANDARD.md` as a grounded, organised standard for creating and judging a design, and
add `_SUBCLASS_REFINING.md`, the method for diagnosing and improving an existing class, subclass, feature, card or
status.
**Intent:** every future design and review asks the same research-backed questions, so subclasses feel their
progression and stay inside the budget.

## Brainstorm decisions (Owner, 2026-10-15)

| # | Decision |
|---|---|
| D1 | Keep §1.2, §2.3, §3 and §15 numbers and every question id; reorganise the rest with a v1 → v2 migration table |
| D2 | Outside the standard, new documents cite questions as `DM-<id>` (e.g. `DM-K3`); refining suggestions are `SG##`; old documents are not edited |
| D3 | Scale ✅ ⚠️ ❌ with one line of evidence, plus ➖ n/a and 🧪 untested |
| D4 | Subclass meters and resources reset at combat end by default; carrying over is an exception logged in DECISIONS with three questions |
| D5 | Pillars (`21.01`) stay an open dependency; the question goes to `10.06/Open_Questions.md`; nothing invented |
| D6 | New research lives in a new card `27.08_Player_Psychology_and_Progression`; `27.07` gets honest statuses (handoff to the 27 owner, run in session) |

## Acceptance criteria

- [ ] Research: every source used verified and logged in `27.07` with its real status; card `27.08` written
- [ ] v1 archived in `90_ARCHIVE/93_Old_Versions/2026-10-15_SUBCLASS_STANDARD_v1/` with date and reason
- [ ] `_SUBCLASS_STANDARD.md` v2 written (Owner approves before the refining method starts)
- [ ] `_SUBCLASS_REFINING.md` written and approved
- [ ] Self-review of both: no dead paths, ids compatible, no copied numbers, no subclass named in the standard
- [ ] Indexes, agents and citing files updated or handed off; pillars question in `10.06`
- [ ] `/propagar` run, `check_propagation.pl` OK, daily log, board updated

## Gates

- [ ] Design gate — n/a (method document, no feature)
- [ ] Narrative gate — n/a
- [ ] DoD (`00.03`)

## Log

- 2026-10-15 — created; Phase 1 diagnosis delivered and the table of contents approved by the Owner (D1–D6).
  Note: the brief named the next id ARC-0015, which was already taken (Kingmaker icons); this is ARC-0016.
