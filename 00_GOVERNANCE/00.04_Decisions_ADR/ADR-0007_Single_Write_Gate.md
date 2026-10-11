# ADR-0007 · One write gate for mod files

- **Status:** Accepted · 2026-10-11 · Owners (hook extension lands in Stage D)

## Decision
The existing `jt-gate` hook (`~/.claude/hooks/jt-gate.ps1`) is the only guard on mod files:

| Condition | Since |
|---|---|
| The message starts with `[fechado]` (game and Toolkit closed); the tag covers that message only | 2026-10-02 |
| Only the game copy (`…\Baldurs Gate 3\Data\…\AspectClass_9d734fbd-…`) is gated; `51` is not | 2026-10-11 |
| The message names a ticket whose header says `implementation: claude` | Stage D |
| Writes to `56_Vanilla_Code_Reference` are always denied | Stage D |

## Consequences
One hook, no drift between two guards. Never infer the game state from running processes.
