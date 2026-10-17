# 00 · Governance

Studio rules, decisions, agent registry, licences.

**Owner:** Owner

| Item | What it holds |
|---|---|
| `00.01_Studio_Constitution` | **`Operating_Rules.md` — every studio rule (OR-n) and the work flow** |
| `00.02_Hierarchy_and_RACI` | Who decides what; responsibility matrix |
| `00.03_Definition_of_Ready_Done` | Global and per-department DoR / DoD (DoD includes 05 and README) |
| `00.04_Decisions_ADR` | Approved ADRs (ADR-0001…); PROPOSALS/ holds suggestions awaiting the Owner |
| `00.05_Agent_Registry` | One card per role: scope, folders, status (active / dormant) |
| `00.06_Licenses_and_Platforms` | Mod licence, tool credits, third-party content, asset origin, platform rules |
| `00.07_Implementation_Policy` | Moved to OR-11 (ADR-0010) |
| `00.08_Propagation_Map` | Which artifacts every change must update, and who owns each (ADR-0009) |

## Decisions (00.04)

| ADR | Title | Status |
|---|---|---|
| ADR-0001 | Adopt the studio repository architecture | Accepted |
| ADR-0002 | Keep the mod folder name and the id prefixes | Accepted |
| ADR-0003 | The mod lives in Data; 51 is a synchronized copy | Accepted |
| ADR-0004 | Version scheme (rework = 4.0.0.x) | Accepted |
| ADR-0005 | Scope of the master data (25) | Accepted |
| ADR-0006 | Git LFS for heavy binaries | Proposed (quota check) |
| ADR-0007 | One write gate for mod files | Accepted |
| ADR-0008 | Toolkit guides show numbers as a derived view | Accepted |
| ADR-0009 | Every change propagates to every department, every session | Accepted |
| ADR-0010 | One rulebook, and the Owner implements in the Toolkit | Accepted |
