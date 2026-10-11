# ADR-0004 · Version scheme

- **Status:** Accepted · 2026-10-11 · Owners

## Decision
The Toolkit's four numbers, `Major.Minor.Revision.Build`:

| Number | Goes up when | Example |
|---|---|---|
| Major | Rework or structural change of the class | the rework ships as **4.0.0.x** |
| Minor | New content (subclass, relevant spell, expansion module) | 4.1.0.x |
| Revision | Balance and fixes | 4.1.2.x |
| Build | Counter the Toolkit increments per build | not in patch notes |

Published today: **3.1.0.28** (first patch-notes baseline). Patch notes carry the first three numbers.

## To verify
How the Toolkit writes the version into `meta.lsx` and mod.io — confirm before the first 4.0 build.
