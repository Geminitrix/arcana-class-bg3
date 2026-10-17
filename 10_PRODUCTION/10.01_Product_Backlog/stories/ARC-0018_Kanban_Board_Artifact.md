---
id: ARC-0018
title: Kanban board artifact for the whole backlog
type: feature
epic: EPIC_Rework_Subclasses
subclass: none
status: done
owner: Mod Engineer
implementation: claude
priority: should
value: 4
effort: 3
inputs: [10.01/_TEMPLATE_TICKET.md, 10.01/stories, 82_Automation/update_board.pl, 00.03, 31.01 §6, 75.02/src/index.css]
outputs: [10.01/_TEMPLATE_TICKET.md, 10.01/stories (subclass, statuses), 82_Automation/update_board.pl, 82_Automation/kanban/, 82_Automation/_INDEX.md, README.md]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0018 · Kanban board artifact for the whole backlog

**Goal:** one screen shows every ticket by status — what is left, done, waiting for review, blocked and why.
**Intent:** the Owner sees and moves the work without reading `BACKLOG.md`; the ticket `.md` files stay the truth.

## Acceptance criteria

- [x] Seven columns with a count each: Backlog · Ready · In Progress · In Review · Spec Ready · In QA · Done;
      the template gains `in_review`, and every ticket uses only the template statuses.
- [x] Blocked is a tag on the card with its `blocked_by` reason, not a column (`status: blocked` from `/handoff`
      still works: the card shows in In Progress with the tag).
- [x] Tickets gain a `subclass:` field (class | unbound | deceiver | starchild | eternal | resonant | kingmaker |
      lionheart | none); every ticket has it filled.
- [x] Card face: department colour, id, title, subclass emblem in its `31.01` §6 colour (Lionheart: its emblem's red,
      `#db4e50`), type tag. Detail on click: priority, value/effort, implementation, epic, criteria, gates, log, comments.
- [x] Search by text; filters by subclass, department, type and status. Fits one desktop screen; columns scroll.
- [x] Cards can be dragged to any column; a card moved out of In QA can go back. Done refuses a card whose
      DoD gate is not checked in its `.md`. (Logic tested locally against a stand-in store.)
- [x] Moves and comments are stored in the artifact and shown as "pending"; the sync procedure is in
      `82_Automation/_INDEX.md` § Kanban sync.
- [x] `update_board.pl` also writes the board data; `BACKLOG.md` and `SPRINT_BOARD.md` keep working (In Review added).
- [x] In-progress column turns amber above 3 cards (warning only).
- [x] Owner drags a card and adds a comment on the real board (claude.ai), then asks for a first sync.

## Gates

- [x] DoD (`00.03`) — criteria met with evidence (local test, first real sync), outputs in 82, no game numbers, no mod files (05 untouched), README updated, daily log, board, commit

## Log

- 2026-10-16 — created. Owner answered the brainstorming (only the Owner uses it; English UI, Portuguese comments;
  Codex look; desktop only; no burndown, no card age; departments grouped by studio folder).
- 2026-10-16 — built and published: https://claude.ai/artifact/Fwq9XqzgZNt5KmKRC4k15E. Template gains `subclass:` and
  `in_review`; 17 tickets got `subclass:`, ARC-0006 `open` → `backlog`, ARC-0014 / ARC-0016 `review` → `in_review`.
  Tested on a local server (`.claude/launch.json` "kanban"): data, filters, drag rules, DoD refusal, comments, WIP
  amber. Not tested: the real artifact store (the browser pane is not signed in to claude.ai) — Owner check pending.
  The page makes no Claude calls, so it spends no tokens.
- 2026-10-16 — moved to spec_ready on the board (Owner).
- 2026-10-16 — Owner comment: sincroniza o kanban
- 2026-10-16 — first kanban sync: the real artifact store kept the Owner's move and comment; procedure works end to end.
- 2026-10-16 — closed. DoD: criteria 10/10; no mod file changed, so no sync_data and no 05 change; README names the
  board; propagation check has no ARC-0018 dossier (subclass: none), open handoffs 0.
