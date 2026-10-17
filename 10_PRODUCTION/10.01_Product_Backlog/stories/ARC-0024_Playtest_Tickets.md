---
id: ARC-0024
title: Playtest tickets and a Playtests tab on the Arcana Board
type: feature
epic: EPIC_Rework_Subclasses
subclass: none
status: in_review
owner: Tools
implementation: claude
priority: should
value: 4
effort: 3
inputs: [61_Test_Plan/TEST_GUIDES.json, 61.02_Test_Cases/*/GUIDE_*.json, 82_Automation/update_board.pl, 82_Automation/kanban/, 00.03]
outputs: [10.01/playtests/QA-0001, QA-0002, 82_Automation/playtests.pl, 82_Automation/update_board.pl, 82_Automation/kanban/index.html, 82_Automation/_INDEX.md, 00.03, 10/_INDEX.md, 61/_INDEX.md]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0024 · Playtest tickets (QA-nnnn) and a Playtests tab on the Arcana Board

**Goal:** every pending in-game test lives on the board as a QA-#### ticket per subclass, loose feature or bug retest.
**Intent:** the Owner opens the Toolkit, picks one card and tests everything it lists; nothing to test is lost.

## Acceptance criteria

- [x] Playtest tickets `QA-####` (own sequence) in `10.01_Product_Backlog/playtests/`, `type: playtest`,
      `kind: subclass | feature | bug-retest`, with `subclass:`, `build: ARC-####` and `guide:` (the guide JSON).
- [x] A script generates a QA ticket from a guide JSON: one section per session, one checkbox per test (id, title, rule).
- [x] Kanban sync also reads the Arcana Test Guides results (`results/<ARC>_<test>`) and writes pass / fail / skipped
      on each test line of the QA tickets.
- [x] Arcana Board has a Playtests tab (Backlog · Ready · In QA · Done) with search and filters; the Board tab keeps
      the other tickets. Cards show progress (✓ / ✗ / left).
- [x] Done refuses a playtest while any test is left or failed (skipped counts as resolved).
- [x] A failed test opens an ARC bug ticket and a QA bug-retest ticket blocked by it (rule written in `00.03`).
- [x] Company rule in `00.03`: every build (subclass or feature) closes only with its test guide and its QA ticket.
- [x] First tickets: QA-0001 Resonant (GUIDE_ARC-0017, 33 tests) and QA-0002 Kingmaker (GUIDE_ARC-0008, 49 tests),
      both Ready. Old `TC_*.md` and ARC-0010 stay as they are.

- [ ] Owner opens the Playtests tab on the real board, marks a test on Arcana Test Guides and asks for a sync.

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created after the Owner's brainstorming (answers: per subclass, loose feature or bug retest; own folder
  and a separate board area; QA-#### sequence; tests generated from the guides; results marked on Arcana Test Guides;
  Ready → In QA → Done, Done only when all passed; fail → ARC bug + QA retest; old TCs stay).
- 2026-10-16 — built: `playtests.pl` (new / sync), QA-0001 Resonant (33 tests) and QA-0002 Kingmaker (49 tests) in
  Ready, `update_board.pl` reads `playtests/`, Playtests tab (Backlog · Ready · In QA · Done) with progress on the
  cards and Done refused while a test is left or failed (skipped counts as resolved), rules in `00.03`, sync step 3b
  in `82_Automation/_INDEX.md`. Tested: sync round trip with sample results (pass / fail with note / skip, then back
  to pending) and the board tab, filters, progress and Done rules on a local server. Not done: the build tickets
  ARC-0017 / ARC-0008 were not moved to In QA (other sessions are working on them).
