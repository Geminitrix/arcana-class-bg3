# ADR-0003 · The mod lives in Data; 51 is a synchronized copy

- **Status:** Accepted · 2026-10-11 · Owners

## Context
Spec §7 offered two options: a directory junction (the real mod folder inside the project, Data pointing
to it) or two copies kept in sync.

## Decision
**The mod lives in `…\Baldurs Gate 3\Data\{Mods,Public}\AspectClass_9d734fbd-…\` and is never moved.**
`50_ENGINEERING/51_Mod_Source/` is a copy filled by `82_Automation/sync_data` (Data → 51) before every
commit, which reports any difference. No junction, no symlink.

## Consequences
- The Toolkit and the game work exactly as before.
- Nobody edits `51` by hand; edits happen in the Toolkit (or in Data with `[fechado]`), then sync.
- `jt-gate` protects only the game copy; writing the mirror is safe with the game open.
- Only non-mod clutter leaves Data (`Data\Backup`, `Data\Claude outputs`).
