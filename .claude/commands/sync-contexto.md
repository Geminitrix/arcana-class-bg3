---
description: Full resync of 05_LIVE_CONTEXT with the game files (Context Keeper)
argument-hint: [optional: which 05 files]
---

Resync the live context ($ARGUMENTS — empty means everything). Use the `context-keeper` agent:

1. `bash 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh` — Data → 51 (reads the game only; safe with the
   game open).
2. `perl 80_TOOLS_AND_PIPELINE/82_Automation/gen_catalog.pl` — 05.03, 05.04, 25.05.
3. `perl 80_TOOLS_AND_PIPELINE/82_Automation/verify_context.pl` — classify each miss as a real gap or a
   feature described under another name; fix real gaps in the `05` files.
4. Update headers (`synced_at`, `state`) and `05.00_READ_FIRST.md` if needed.
5. Commit + push (`05: sync context`). Report stale files and suspicious game facts in ≤ 10 lines.
