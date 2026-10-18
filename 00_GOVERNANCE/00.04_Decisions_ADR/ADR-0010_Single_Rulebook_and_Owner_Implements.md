# ADR-0010 · One rulebook, and the Owner implements in the Toolkit

- **Status:** Accepted · 2026-10-17 · Owner

## Context
The organisation audit of 2026-10-17 found about 130 files carrying rules — three CLAUDE.md, AGENTS.md, 47 `_AGENT.md`,
9 agents, 11 commands, the v0.4 constitution, 00.03, 00.07, 00.08, and 36 private Claude memories — with the same rule
copied up to 22 times. The copies drifted into contradictions: the newest rule (the Owner types builds in the Toolkit,
2026-10-17) existed only in Claude's private memory while the repository still said Claude implements with `[fechado]`;
subagents were both recommended and forbidden; handoffs both "block and wait" and "execute in the same session"; the
constitution named 38 roles and Portuguese paths that never existed.

## Decision (Owner answers, 2026-10-17)
1. **One rulebook:** `00.01_Studio_Constitution/Operating_Rules.md` holds every rule, numbered `OR-n`. Every other file
   points to a number and never restates it. Claude's private memory keeps no project rules.
2. **The work flow** (OR §1): intake → ideation (decisions logged) → design doc (Design + Narrative gates, Owner approval)
   → build kit (SPEC, Toolkit typing guide per level, test guide written before the build) → build & test one level at a
   time → close (propagation, `05`, patch notes).
3. **The Owner implements everything in the Toolkit**; Claude verifies each level and fixes divergences with `[fechado]`
   and the ticket named (OR-11). `jt-gate` accepts `implementation: owner` for those fixes.
4. **No subagents** unless the Owner asks.
5. The v0.4 constitution and the 00.07 policy are archived (`93/2026-10-17_Studio_Constitution_v0.4/`).

**Amended 2026-10-17 (Owner):** the build kit is **one** `TOOLKIT_ARC-####.md` and **one** `QA_ARC-####.md` per ARC;
"level by level" means the sections of the QA_ARC, not separate files (OR-4).
**Amended 2026-10-18 (Owner):** the TOOLKIT_ARC (and the SPEC) follow the best implementation order, feature by feature,
each feature complete in one place — never level by level, which scatters a growing feature (OR-5). Every id follows
the mod's patterns (OR-59).

## Consequences
A rule changes in one place. The next phases of the audit fix the roles (C), production (D) and the tools (E).
