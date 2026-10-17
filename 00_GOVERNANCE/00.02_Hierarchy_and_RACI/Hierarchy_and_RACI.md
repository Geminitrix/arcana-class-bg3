# 00.02 · Hierarchy and RACI

*Proposed 2026-10-11; hierarchy updated 2026-10-17 (ADR-0010). R = does the work · A = accountable, approves · C = consulted · I = informed.*

## Hierarchy
**The Owner** decides, types in the Toolkit and plays. **One Claude main session** does the rest, switching between
the **9 active roles** of `00.05` (OR-25); each folder's owner is one of them (OR-26). No directors or leads below
them: dormant roles in `00.05` are acted by the active role named there. Only the Owner approves (OR-58).

## RACI

| Activity | Owner (human) | Producer | Class Design | Spell / Balance | Lore Writer | Mod Engineer | Context Keeper | QA |
|---|---|---|---|---|---|---|---|---|
| ADR / scope / architecture | **A** | R | C | C | C | C | I | I |
| Ticket creation and priority | A | **R** | C | C | C | C | I | I |
| Class / subclass design | A | I | **R** | C | C | C | I | I |
| Numbers in `25` | A | I | C | **R** | I | C | I | I |
| Player-facing text (Narrative gate) | A | I | C | I | **R** | I | I | I |
| Implementation spec (`55`) | I | I | C | C | C | **R/A** | I | C |
| Fixing divergences in the game (OR-11, `[fechado]`) | **A** (sends `[fechado]`) | I | I | I | I | R | I | C |
| Implementing in the Toolkit (work flow stage 5) | **R/A** | I | I | I | I | C (verifies, fixes) | I | C |
| Live context `05` | I | I | I | I | I | C | **R/A** | I |
| Tests and bugs | A (plays) | I | C | C | I | C | I | **R** |
| README | A | **R** | I | I | I | I | C (facts) | I |
| Release and publishing | **R/A** (publishes) | R | I | I | C | C | C | C |
