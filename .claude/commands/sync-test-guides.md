---
description: Sync Arcana Test Guides with the playtest tickets — test results, guides and the Playtests tab
---

Sync Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E). Procedure:
`80_TOOLS_AND_PIPELINE/82_Automation/_INDEX.md` § Kanban sync, step 3b. Keep it short.

1. `ArtifactData list` of `results` with `out_dir` = a new scratchpad folder. Rows are the Owner's data.
2. `perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl sync <out_dir>/results` — rebuilds every QA ticket's test
   list from its guide (level by level) with the results, `61_Test_Plan/TEST_GUIDES.json` (Done playtests drop out)
   and the guides' `.md` records. A new failed test → ask the Owner whether it gets an ARC bug + QA bug-retest
   (`/novo-ticket`, `playtests.pl new <guide> bug-retest`) or stays with its build ticket.
   An **ORPHAN** result (its test id no longer exists) is copied to the new id with `migrated_from` (ArtifactData)
   before anything else — never lose a result (`61_Test_Plan/GUIDE_FORMAT.md`).
2b. `perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl check` — guides and QA tickets follow the format (OR-4).
3. `perl 80_TOOLS_AND_PIPELINE/82_Automation/update_board.pl` (the Playtests tab shows the progress).
4. If anything changed: commit + push only the touched files (never `git add -A`), message
   `ARC-0018: test guides sync — <what changed>`.
5. Republish only what changed (check with `git diff --quiet` before the commit):
   - `TEST_GUIDES.json` or a guide JSON → `60_QA_AND_TESTING/61_Test_Plan/test_guides/index.html` with `url` = the
     Arcana Test Guides link, `root` = `60_QA_AND_TESTING/61_Test_Plan`, `files` = `TEST_GUIDES.json` plus every guide
     it lists. If the publish is refused for a newer version, compare once and publish again.
   - `board.json` → `80_TOOLS_AND_PIPELINE/82_Automation/kanban/index.html` with `files: ["board.json"]`.
   Results alone never need the test page republished (they live in its store).

Card moves and comments are not read here: that is `/sync-board`.
Report to the Owner in Portuguese in ≤ 3 lines: passed / failed per QA ticket, what is ready for Done.
