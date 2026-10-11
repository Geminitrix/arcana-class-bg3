# ADR-0006 · Git LFS for heavy binaries

- **Status:** Proposed · 2026-10-11 · waiting for the quota check

## Context
The spec puts `.pak`, `.dds`, `.psd` and large `.png` in Git LFS. The local art folder alone is ~964 MB, most
of it third-party reference (not authored — Owner, 2026-10-11). GitHub limits LFS storage and bandwidth.

## Proposal
1. Check the account's LFS quota.
2. Put in LFS only authored binaries: final `.dds` (`42.03`), editable sources (`42.01`), release `.pak`
   (`71.01`) and the published baseline (`76.01`).
3. Third-party references stay local (`41.02_References`, gitignored).

## Until accepted
`.gitignore` keeps every heavy binary out; `.gitattributes` already routes them to LFS once un-ignored.
