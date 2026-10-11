# 00.02 · Hierarchy and RACI

*Proposed 2026-10-11. R = does the work · A = accountable, approves · C = consulted · I = informed.*

## Hierarchy
**Owners** (Lumox + Claude Opus as co-owner of the method) → **department directors** (one per area,
see each `_AGENT.md`) → **leads** (one per category) → **executors**. Agents are the leads / executors;
the main session coordinates; only the human Owner approves.

## RACI

| Activity | Owner (human) | Producer | Class Design | Spell / Balance | Lore Writer | Mod Engineer | Context Keeper | QA |
|---|---|---|---|---|---|---|---|---|
| ADR / scope / architecture | **A** | R | C | C | C | C | I | I |
| Ticket creation and priority | A | **R** | C | C | C | C | I | I |
| Class / subclass design | A | I | **R** | C | C | C | I | I |
| Numbers in `25` | A | I | C | **R** | I | C | I | I |
| Player-facing text (Narrative gate) | A | I | C | I | **R** | I | I | I |
| Implementation spec (`55`) | I | I | C | C | C | **R/A** | I | C |
| Writing mod files (`implementation: claude`) | **A** (asks explicitly) | I | I | I | I | R | I | C |
| Implementing in the Toolkit (`owner`) | **R/A** | I | I | I | I | C (verifies) | I | C |
| Live context `05` | I | I | I | I | I | C | **R/A** | I |
| Tests and bugs | A (plays) | I | C | C | I | C | I | **R** |
| README | A | **R** | I | I | I | I | C (facts) | I |
| Release and publishing | **R/A** (publishes) | R | I | I | C | C | C | C |
