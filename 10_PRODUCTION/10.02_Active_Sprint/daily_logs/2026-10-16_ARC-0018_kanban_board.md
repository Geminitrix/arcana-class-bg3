# 2026-10-16 · ARC-0018 kanban board

- Owner asked for a kanban artifact to see what is left, done, waiting for review and blocked (and why).
  Brainstormed every rule with the Owner; decisions are in the ticket's log.
- Ticket model: template gains `subclass:` and `in_review`; 17 tickets got `subclass:`; non-standard statuses
  normalized (ARC-0006 `open` → `backlog`; ARC-0014, ARC-0016 `review` → `in_review`).
- `update_board.pl` now also writes `82_Automation/kanban/board.json`; SPRINT_BOARD gains an In Review column.
- Board published: https://claude.ai/artifact/Fwq9XqzgZNt5KmKRC4k15E. Moves and comments wait in the artifact's
  store until the Owner asks for a sync (procedure in `82_Automation/_INDEX.md`).
- Open: the Owner tries a drag and a comment on the real board; the first sync closes the ticket.
- First real sync done (Owner moved ARC-0018 and left a comment; both landed in the ticket). ARC-0018 closed.
- ARC-0024: playtest tickets QA-#### (`10.01/playtests`, generated from the test guides by `playtests.pl`), a
  Playtests tab on the board, results from Arcana Test Guides at the kanban sync; QA-0001 Resonant, QA-0002 Kingmaker.
- ARC-0024: test guides by level (Resonant, Kingmaker), `/update-board` syncs the board and the test page.
