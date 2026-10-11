# ADR-0001 · Adopt the studio repository architecture

- **Status:** Accepted · 2026-10-11 · Owners
- **Spec:** `00.01/Studio_Architecture_and_Agile_Flow_v0.4_PT.md`

## Context
The project had been reorganised several times (2026-10-08 and by hand afterwards); files were duplicated,
docs drifted, and agents had no fixed place to read or write.

## Decision
Adopt the spec's Johnny.Decimal tree, **full** (every category with `_INDEX.md` and `_AGENT.md`), with
these changes approved by the Owners:

| # | Change |
|---|---|
| M1 | English folder and file names; the master spec stays in Portuguese in `00.01` |
| M2 | Mod folder name and id prefixes unchanged → ADR-0002 |
| M3 | One write gate (`jt-gate`): `[fechado]` + ticket `implementation: claude` → ADR-0007 |
| M4 | Mod lives in Data, `51` is a synchronized copy → ADR-0003 |
| M5 | Master data scope → ADR-0005 |
| M6 | `56` and `31.04` point at the existing local extraction (`C:\Projetos\BG3\…`); never copied, never in git |
| M7 | Extra items: `75.02_Player_Guide_Codex`, `94_Safety_Backups` |
| M8 | Git LFS only after a quota check → ADR-0006 |
| M9 | Pre-migration folders moved as-is to `_LEGACY/2026-10-11/` (gitignored), new tree filled by copy |
| M10 | Knowledge cards (`27`, `57`) from the spec text + game data; web sources read on demand |
| M11 | Version scheme → ADR-0004 |

Git stays **commit + push to `main` without asking**; ticket id first in the message (Owner, 2026-10-11).

## Consequences
Every path in old docs, memory and hooks changes; Stage A rewrote them. `Wiki/` stays only in git history.
