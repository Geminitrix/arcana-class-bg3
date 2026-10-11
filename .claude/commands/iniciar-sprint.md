---
description: Plan and start a new one-week sprint (goal, tickets, board)
argument-hint: <sprint number, e.g. S01> [goal]
---

Start sprint $ARGUMENTS.

1. With the `producer-scrum` agent: if a sprint is still open, stop and ask the Owner to close it
   (`/retro`) first.
2. Propose a one-sentence sprint goal and the tickets that meet the DoR (`00.03`), ordered by priority and
   sized to one week. **Wait for the Owner's OK** on goal and scope.
3. Write `10_PRODUCTION/10.02_Active_Sprint/SPRINT_GOAL.md` (first line `sprint: S##`, then the goal),
   set `sprint: S##` and `status: ready` on the chosen tickets, save planning notes in
   `10.04_Ceremonies/planning/PLANNING_S##.md`.
4. `perl 80_TOOLS_AND_PIPELINE/82_Automation/update_board.pl`, commit + push (`S##: sprint planning`).
