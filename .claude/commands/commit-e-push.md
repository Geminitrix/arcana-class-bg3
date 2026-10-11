---
description: Sync, check README, commit and push to main
argument-hint: [ARC-#### and a short message]
---

Commit and push: $ARGUMENTS

1. If anything changed in the game Data folder this session: `bash 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh`.
2. `perl 80_TOOLS_AND_PIPELINE/82_Automation/check_readme.pl` — if it reports a mismatch (published version,
   subclass states, migration status), update `README.md` and show its diff.
3. `git add -A --dry-run`: confirm nothing heavy or third-party is staged (art binaries, `41.02`, `56`,
   `_LEGACY`). Stop and tell the Owner if something looks wrong.
4. Commit with the ticket id first (`ARC-####: …`), English message, the attribution trailer; push to
   `main` (no asking — studio rule). Report the commit hash in Portuguese.
