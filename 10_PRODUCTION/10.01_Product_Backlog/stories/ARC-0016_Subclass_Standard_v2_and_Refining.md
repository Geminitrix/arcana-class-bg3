---
id: ARC-0016
title: "Subclass standard v2 and refining method"
type: design
epic: EPIC_Rework_Subclasses
status: review
owner: Lead Class Designer
implementation: pending
priority: should
value: 4
effort: 3
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/Resonant/REFINE_Resonant.md, 21.04/Resonant/DESIGN.md, 21.04/Resonant/DECISIONS.md, 21.08, 22.06, 27.01, 27.02, 27.03, 27.04, 27.05, 27.06, 27.07, 05.00, 00.08]
outputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/_SUBCLASS_REFINING.md, 27.08_Player_Psychology_and_Progression, 27.07, 93/2026-10-15_SUBCLASS_STANDARD_v1, 27.08, 21.04/Resonant/REFINE_Resonant.md (renamed), 21_INDEX, .claude/agents (4), 10.06, 00.04/PROPOSALS/PROPOSAL_Subclass_Standard_v2_References.md]
blocked_by: [propagation of older Deceiver and Lionheart dossiers (not caused by this ticket)]
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
| D7 | Every BG3 fact cites the bg3.wiki page and the game file; the game file wins (standard §8) |
| D8 | Every refining document is `REFINE_<piece>.md`, the subclass review included (`REFINE_<S>.md`); the existing Resonant review is renamed |
| D9 | A subclass may grant content at **any** level, odd or even (quality of life: things arrive more often, a few at a time); levels 4 and 8 (feats) stay empty, as in every subclass today — standard v2.1 (M4, J1 amended, J8 new, §6.3, Appendix A.4) |

## Acceptance criteria

- [x] Research: every source used verified and logged in `27.07` with its real status; card `27.08` written
- [x] v1 archived in `90_ARCHIVE/93_Old_Versions/2026-10-15_SUBCLASS_STANDARD_v1/` with date and reason
- [x] `_SUBCLASS_STANDARD.md` v2 written (Owner approves before the refining method starts)
- [x] `_SUBCLASS_REFINING.md` written and approved
- [x] Self-review of both: no dead paths, ids compatible, no copied numbers, no subclass named in the standard
- [x] Indexes, agents and citing files updated or handed off; pillars question in `10.06`
- [ ] `/propagar` run, `check_propagation.pl` OK, daily log, board updated

## Gates

- [ ] Design gate — n/a (method document, no feature)
- [ ] Narrative gate — n/a
- [ ] DoD (`00.03`)

## Log

- 2026-10-15 — created; Phase 1 diagnosis delivered and the table of contents approved by the Owner (D1–D6).
  Note: the brief named the next id ARC-0015, which was already taken (Kingmaker icons); this is ARC-0016.
- 2026-10-15 — Phase 2 (research): ~30 sources checked online; card `27.08` written; `27.07` gets a status legend,
  five updated rows and a new ARC-0016 table (honest statuses: mostly skimmed or exists — not read). Handoff
  `27/HANDOFF_LeadClassDesigner_to_GameDesignDirector_ARC-0016.md` executed in session, `done`. Found: the Resonant review
  dates *Lenticular Design* 2011 (it is 2014) — to fix in Phase 6.
- 2026-10-15 — Phase 3: v1 archived (`93/2026-10-15_SUBCLASS_STANDARD_v1/`, README, `_INDEX`); standard v2 written
  (ids and §1.2/§2.3/§3/§15 kept; new I7–I8, S7, M7, K7, P11–P12, J1–J7, B5–B7, X1–X3; BG3 facts grounded in the
  local extraction — high ground corrected to a flat ±2 modifier; formulas left to `22.06`). Pillars question added to
  `10.06` (handoff to the Producer, done). Found: `31.01` §1 holds four identity pillars (content, not experience).
  Status: awaiting Owner approval before Phase 4.
- 2026-10-15 — Owner decision on BG3 sources (option A): every BG3 fact cites the bg3.wiki page **and** the game file;
  the file wins (`CLAUDE.md` rule 6). Standard §8 rewritten with both citations (12 wiki pages checked); new §8.7 for
  divergences (XP totals); initiative corrected (d4 + DEX, shared result, not adjacency); bg3.wiki added to `27.07`.
  High ground confirmed as a flat bonus by both sources.
- 2026-10-15 — Owner approved the standard v2 (status line and `10.06` updated). Phase 4: `_SUBCLASS_REFINING.md` written
  (five variants, full and short; 12-step pipeline; 13 diagnostic tools; `SG##` format; templates). Self-review: no
  subclass named, every `DM-` id and every standard § cited exists. Awaiting Owner approval before Phase 6.
- 2026-10-15 — Owner approved the refining method, with one change (D8): every refining document is `REFINE_<piece>.md`.
  `Resonant/BALANCE_SUGGESTIONS.md` renamed `Resonant/REFINE_Resonant.md` (git mv; header notes the v1 § mapping and the
  D4 meter rule; *Lenticular Design* dated 2014); live references updated (ARC-0014, 27.07, standard Appendix A).
  "See also" line added to the refining method. Phase 6: agents lead-class-designer, spell-designer, balance-designer,
  lore-writer point at the standard v2 / refining / `DM-` ids; 21 `_INDEX` and `_AGENT` updated; proposal for the
  Owners in `00.04/PROPOSALS/PROPOSAL_Subclass_Standard_v2_References.md` (`CLAUDE.md` "Where to look" and rule 6,
  `00.05` registry). `check_propagation.pl`: 21 pending, all from the Deceiver and Lionheart dossiers (older than this
  ticket) — status `review` until they are propagated. Daily log written.
- 2026-10-15 — Owner decision D9 (during the Resonant refining): progression spread over every level. Standard → v2.1 (M4 and J1 lose "odd", new J8, §6.1 and §6.3 rewritten, Appendix A.4); `_SUBCLASS_REFINING.md` step 8 and §6 check the spread; `21.08` level rhythm notes it. Existing subclasses move in their own refining.
- 2026-10-16 — D9 refined by the Owner: levels 4 and 8 carry no subclass content (checked: all six subclasses are empty there in the game). Standard §6.3, J8, A.4, `_SUBCLASS_REFINING.md` §6 and `21.08` updated.
