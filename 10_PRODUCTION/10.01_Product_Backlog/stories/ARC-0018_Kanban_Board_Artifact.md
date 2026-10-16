---
id: ARC-0018
title: Kanban board artifact for the whole backlog
type: feature
epic: EPIC_Rework_Subclasses
subclass: none
status: in_progress
owner: Tools
implementation: claude
priority: should
value: 4
effort: 3
inputs: [10.01/_TEMPLATE_TICKET.md, 10.01/stories, 82_Automation/update_board.pl, 00.03, 31.01 §6, 75.02/src/index.css]
outputs: [10.01/_TEMPLATE_TICKET.md, 10.01/stories, 82_Automation/update_board.pl, 82_Automation/kanban/]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0018 · Kanban board artifact for the whole backlog

**Goal:** one screen shows every ticket by status — what is left, done, waiting for review, blocked and why.
**Intent:** the Owner sees and moves the work without reading `BACKLOG.md`; the ticket `.md` files stay the truth.

## Acceptance criteria

- [ ] Seven columns with a count each: Backlog · Ready · In Progress · In Review · Spec Ready · In QA · Done;
      the template gains `in_review`, and every ticket uses only the template statuses.
- [ ] Blocked is a tag on the card with its `blocked_by` reason, not a column.
- [ ] Tickets gain a `subclass:` field (class | unbound | deceiver | starchild | eternal | resonant | kingmaker |
      lionheart | none); every ticket has it filled.
- [ ] Card face: department colour, id, title, subclass emblem in its `31.01` §6 colour (Lionheart: its emblem's red),
      type tag. Detail on click: priority, value/effort, implementation, epic, criteria, gates, log, comments.
- [ ] Search by text; filters by subclass, department, type and status. Fits one desktop screen; columns scroll.
- [ ] Cards can be dragged to any column; a card moved out of In QA can go back. Done refuses a card whose
      DoD gate is not checked in its `.md`.
- [ ] Moves and comments are stored in the artifact and shown as "pending"; on the Owner's request Claude writes them
      into the ticket `.md` files, runs `update_board.pl`, commits, pushes and republishes.
- [ ] `update_board.pl` also writes the board data; `BACKLOG.md` and `SPRINT_BOARD.md` keep working.
- [ ] In-progress column turns amber above 3 cards (warning only).

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created. Owner answered the brainstorming (only the Owner uses it; English UI, Portuguese comments;
  Codex look; desktop only; no burndown, no card age; departments grouped by studio folder).
