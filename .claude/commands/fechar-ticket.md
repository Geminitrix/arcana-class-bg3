---
description: Close a ticket against the Definition of Done
argument-hint: <ARC-####>
---

Close $ARGUMENTS.

0. `perl 80_TOOLS_AND_PIPELINE/82_Automation/check_propagation.pl` must print OK for the ticket's dossier(s) —
   otherwise run `/propagar` first (00.08). An open handoff also blocks the close.
1. Check the DoD in `00_GOVERNANCE/00.03_Definition_of_Ready_Done/DoR_DoD.md` (global + department) item by
   item; for each, cite the evidence. If anything fails, list it and stop — don't close.
2. If mod files changed: `bash 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh`, then `/sync-contexto`
   for the affected `05` files (Context Keeper).
3. README: if structure, subclass state, version or scope changed, update it (Producer).
4. Ticket header `status: done`, outputs filled; daily log entry; `update_board.pl`.
5. Commit + push (`ARC-####: done`). Report to the Owner in Portuguese in ≤ 10 lines.
