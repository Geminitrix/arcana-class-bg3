---
description: Bring every department's artifacts up to date with the latest decisions (00.08)
argument-hint: [Subclass | ARC-####]  (empty = everything pending)
---

Propagate $ARGUMENTS following `00_GOVERNANCE/00.08_Propagation_Map/Propagation_Map.md`.

1. `perl 80_TOOLS_AND_PIPELINE/82_Automation/check_propagation.pl $ARGUMENTS` — the list of MISSING / STALE
   artifacts and open handoffs.
2. Read the sources once (the dossier's `DECISIONS.md`, dated specs, `55/_wip/<S>/`), then go **department by
   department, in this order**, each time switching to that role and following its `_AGENT.md`:
   Lead Class Designer (DESIGN.md, 21.03, 21.08) → Spell Designer (23.02 sheets, 25 YAML) → Balance Designer
   (22.05, 26.01) → Lore Writer (31.02, 32.01, 33.03) → Icon Artist (42.04) → QA Lead (61.02) →
   Context Keeper (05.02, 05.00 — only what is in the game) → Producer (ticket log, epic, board).
3. Each artifact is rewritten in present tense from the sources — never copy numbers outside `25`. When the
   change does not affect an artifact, refresh its `reviewed: YYYY-MM-DD ARC-#### — no change` line.
4. Open handoffs: do the work in the destination role, then set `status: done` in the handoff.
5. Re-run the check until it prints `OK`. Log the list of updated artifacts in the ticket, regenerate the
   board, commit (ticket id first) and push. Report to the Owner in Portuguese, ≤ 10 lines.
