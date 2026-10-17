---
id: ARC-0024
title: Playtest tickets (QA-####) and a Playtests tab on the Arcana Board
type: feature
epic: EPIC_Rework_Subclasses
subclass: none
status: in_progress
owner: Tools
implementation: claude
priority: should
value: 4
effort: 3
inputs: [61_Test_Plan/TEST_GUIDES.json, 61.02_Test_Cases/*/GUIDE_*.json, 82_Automation/update_board.pl, 82_Automation/kanban/, 00.03]
outputs: []
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0024 · Playtest tickets (QA-####) and a Playtests tab on the Arcana Board

**Goal:** every pending in-game test lives on the board as a QA-#### ticket per subclass, loose feature or bug retest.
**Intent:** the Owner opens the Toolkit, picks one card and tests everything it lists; nothing to test is lost.

## Acceptance criteria

- [ ] Playtest tickets `QA-####` (own sequence) in `10.01_Product_Backlog/playtests/`, `type: playtest`,
      `kind: subclass | feature | bug-retest`, with `subclass:`, `build: ARC-####` and `guide:` (the guide JSON).
- [ ] A script generates a QA ticket from a guide JSON: one section per session, one checkbox per test (id, title, rule).
- [ ] Kanban sync also reads the Arcana Test Guides results (`results/<ARC>_<test>`) and writes pass / fail / skipped
      on each test line of the QA tickets.
- [ ] Arcana Board has a Playtests tab (Backlog · Ready · In QA · Done) with search and filters; the Board tab keeps
      the other tickets. Cards show progress (✓ / ✗ / left).
- [ ] Done refuses a playtest while any test is left or failed (skipped counts as resolved).
- [ ] A failed test opens an ARC bug ticket and a QA bug-retest ticket blocked by it (rule written in `00.03`).
- [ ] Company rule in `00.03`: every build (subclass or feature) closes only with its test guide and its QA ticket.
- [ ] First tickets: QA-0001 Resonant (GUIDE_ARC-0017, 33 tests) and QA-0002 Kingmaker (GUIDE_ARC-0008, 49 tests),
      both Ready. Old `TC_*.md` and ARC-0010 stay as they are.

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created after the Owner's brainstorming (answers: per subclass, loose feature or bug retest; own folder
  and a separate board area; QA-#### sequence; tests generated from the guides; results marked on Arcana Test Guides;
  Ready → In QA → Done, Done only when all passed; fail → ARC bug + QA retest; old TCs stay).
