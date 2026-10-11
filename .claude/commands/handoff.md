---
description: Hand a piece of work from one department to another and block the ticket
argument-hint: <ARC-####> <from> <to> <what is needed>
---

Handoff: $ARGUMENTS

1. Create `HANDOFF_<From>_to_<To>.md` **in the destination department's folder** (the one whose
   `_AGENT.md` names the owner): ticket id, what is needed, inputs by ID, where to deliver, acceptance.
2. In the ticket header set `status: blocked` and add the department to `blocked_by`; log it in the ticket.
3. Call the destination agent with the handoff path. When it delivers, it marks the handoff `done`;
   then unblock the ticket (`status: in_progress`) and call the original agent again to continue.
4. `update_board.pl`, commit + push (`ARC-####: handoff <from> → <to>`).
