# 00.05 · Agent registry

*Every studio role has a card here; only **active** roles have a file in `.claude/agents/` (dormant roles
cost no context or tokens). Updated 2026-10-11 (Stage D). Activation of a dormant role = ADR or Owner
request, then its `.claude/agents/<name>.md`.*

| Role | Department | Status | Agent file | Owns | Reads first | Model |
|---|---|---|---|---|---|---|
| Producer / Scrum Master / Product Owner | 10, README | **Active** | `producer-scrum` | 10, 91, README | 00.03 | sonnet |
| Lead Class Designer | 20 | **Active** | `lead-class-designer` | 21 | 27.01, 27.02, `_SUBCLASS_STANDARD` | session |
| Spell Designer | 20 | **Active** | `spell-designer` | 23, 25 (with Balance) | 27.01, 27.03, 27.04 | session |
| Balance Designer (+ economy) | 20 | **Active** | `balance-designer` | 22, 26, 25 (with Spell) | 27.03, 27.04, 27.06 | session |
| Lore Writer (+ Narrative Integrator, Localization) | 30 | **Active** | `lore-writer` | 31, 32, 33 | 27.05, 31.01, 31.03 | session |
| Mod Engineer (+ Build, Pipeline, Stats/LSX, Khonsu, Lua, Osiris) | 50, 80 | **Active — spec mode** | `mod-engineer` | 51–57, 80 | 57.01, 57.06 + layer card | session |
| Icon Artist (+ Art Lead) | 40 | **Active** | `icon-artist` | 41, 42 (43–45 dormant) | 41.01, 31.01 | sonnet |
| Context Keeper | 05 | **Active** | `context-keeper` | 05 | 05.07, 33.03 | sonnet |
| QA Lead (+ Bug Triage, Playtester, Compat Tester) | 60, 83 | **Active** | `qa-lead` | 60, 83 | 27.06, 57.06 | sonnet |
| Stats & LSX Engineer | 50 | Dormant — Mod Engineer acts | — | 51 (Stats, Lists, Progressions) | 57.02, 56.02 | — |
| Khonsu Engineer | 50 | Dormant — first `.khn` ticket | — | 51 (`Scripts/thoth`) | 57.03, 56.03 | — |
| Lua & SE Engineer | 50 | Dormant — first Lua ticket | — | 51 (`ScriptExtender`) | 57.04, 56.04 | — |
| Osiris Engineer | 50 | Dormant — after the goals extraction **and** its 10-task evaluation (57.05) | — | 51 (`Story`) | 57.05, 56.01 | — |
| Code Reviewer | 50 | Dormant — active when a ticket writes code | — | reports only | 57.06 code gate | — |
| Patch Notes Lead | 76 | Dormant — first release after migration | — | 76 | 27.03 (intent) | — |
| Release Engineer, Publisher, Community, Release Notes Writer | 70 | Dormant — before the first public release of the rework | — | 71–75 | 00.06 | — |
| UI Artist, VFX Artist, 3D Artist | 43–45 | Dormant — first spell with its own effect | — | 43–45 | 41.01 | — |
| Item Designer | 24 | Dormant — Spell Designer acts | — | 24 | 27.03 | — |
| Build Engineer, Tech Writer, Pipeline Tech Lead | 53, 54, 80 | Dormant — Mod Engineer acts | — | 53, 54, 80 | 57.06 | — |
| Game Design Facilitator | 10.03 | Dormant — Producer runs the intake | — | 10.03 | 27.01 | — |

**How agents run:** the main session (the Claude you talk to) is the coordinator. It reads the ticket,
calls the right agent, and chains departments through handoffs (`/handoff`). Subagents never call each
other. Agents and commands load when a session starts **in the project folder**
(`C:\Lumox Studios\Arcana Class`).
