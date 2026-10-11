# 05 · Live Context — agent rules

- **Owner:** Context Keeper (active)
- **Writes here:** the owner only. Others ask through `HANDOFF_<from>_to_<to>.md` placed in this folder and mark their ticket `blocked_by`.
- **Read before working:** `/CLAUDE.md`, `/AGENTS.md`, `05_LIVE_CONTEXT/05.00_READ_FIRST.md`, this file, then only the files the ticket lists by ID.

## Conventions

- Entry point: `05.00_READ_FIRST.md`.
- Present tense only — when a value changes, overwrite it.
- Every file starts with a header: `source`, `synced_at` (date + commit), `state` (synced / stale).
- Never a source of truth: on conflict 25 and 51 win and the mirror is corrected.
- Other agents never edit 05; they send a handoff to the Context Keeper.

## Quality checklist

- [ ] Every fact traceable to a source ID.
- [ ] Header updated.
- [ ] Fits a quick read.
