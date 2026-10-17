---
description: Hand a piece of work from one role to another and execute it in the same session (OR-27)
argument-hint: <ARC-####> <from> <to> <what is needed>
---

Handoff: $ARGUMENTS

1. Create `HANDOFF_<From>_to_<To>.md` **in the destination folder** (the one whose `_AGENT.md` names the owner role):
   ticket id, what is needed, inputs by ID, where to deliver, acceptance.
2. Switch to the destination role (its `.claude/agents/` file and `_AGENT.md`) and do the work **now** — no subagent,
   no waiting (OR-25, OR-27).
3. Mark the handoff `status: done` (or `status: deferred` with reason and ticket when the Owner parks it); log it in the
   ticket.
4. `/sync-board`, commit + push (`ARC-####: handoff <from> → <to>`).
