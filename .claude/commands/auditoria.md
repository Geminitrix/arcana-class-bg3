---
description: Health check of the whole studio — rules, owners, tickets, propagation, README, the mod copy (ARC-0027)
---

Run every check, then report to the Owner in Portuguese in ≤ 10 lines: what is clean, each finding with the rule it
breaks (`OR-n`), and the fix you propose. Fix nothing before the Owner's OK, except obvious typos in your own files.

1. `perl 80_TOOLS_AND_PIPELINE/82_Automation/audit.pl` — dead citations, owners (OR-26), tickets and WIP (OR-36),
   open handoffs (OR-27), days without a daily log in the sprint (OR-37).
2. `perl 80_TOOLS_AND_PIPELINE/82_Automation/check_propagation.pl` — artifacts behind their decisions (OR-28).
3. `perl 80_TOOLS_AND_PIPELINE/82_Automation/check_readme.pl` — README vs `05.00` (OR-38).
4. `bash 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh`, then `perl 80_TOOLS_AND_PIPELINE/82_Automation/validate.pl`
   and `perl 80_TOOLS_AND_PIPELINE/82_Automation/verify_context.pl` — the mod copy and `05` against the game.
5. Rules outside the rulebook: grep the private memory index for project rules (they belong in `00.01`, ADR-0010).
