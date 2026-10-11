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

## Verified 2026-10-11
The Toolkit writes the version into `meta.lsx` as one integer, `Version64`: major = v >> 55, minor = (v >> 47) & 0xFF,
revision = (v >> 31) & 0xFFFF, build = v & 0x7FFFFFFF. The published `.pak` decodes to 3.1.0.28; the working copy in
Data is 3.1.0.44 (details in `76.01_Published_Baseline/v3.1.0.28/BASELINE.md`).
