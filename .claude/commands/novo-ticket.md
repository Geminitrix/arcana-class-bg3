---
description: Create a new ARC-#### ticket in the backlog from a short description
argument-hint: <what the ticket is about>
---

Create a ticket for: $ARGUMENTS

1. Use the `producer-scrum` agent (or do it yourself if it is a one-liner).
2. Next id = highest `ARC-####` under `10_PRODUCTION/` + 1. File:
   `10_PRODUCTION/10.01_Product_Backlog/stories/ARC-####_Short_Title.md` from `_TEMPLATE_TICKET.md`.
3. Fill the YAML header (type, epic, owner department, `implementation: pending`, MoSCoW, value, effort,
   inputs / outputs by ID). Write the goal and the intent in one sentence each and checkable acceptance
   criteria. If anything needed for the DoR (`00.03`) is unknown, ask the Owner instead of guessing.
4. Run `perl 80_TOOLS_AND_PIPELINE/82_Automation/update_board.pl`.
5. Commit + push (`ARC-####: create ticket`). Report the id and title to the Owner in Portuguese.
