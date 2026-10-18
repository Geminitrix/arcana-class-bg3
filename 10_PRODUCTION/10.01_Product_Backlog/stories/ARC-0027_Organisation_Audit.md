---
id: ARC-0027
title: Organisation audit — one rulebook, real roles, production and tools in order
type: chore
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Producer
implementation: pending
priority: must
value: 5
effort: 4
inputs: [CLAUDE.md, AGENTS.md, every _AGENT.md, .claude/agents, .claude/commands, 00_GOVERNANCE, 10_PRODUCTION, memory]
outputs: [00.01/Operating_Rules.md, 00.04/ADR-0010, 93/2026-10-17_Studio_Constitution_v0.4]
blocked_by: []
sprint: S01
created: 2026-10-17
---

# ARC-0027 · Organisation audit — one rulebook, real roles, production and tools in order

**Goal:** fix what the audit of 2026-10-17 found, in five phases, one per message (Owner-approved).
**Intent:** every role knows the one place where each rule lives and the stage each piece of work is in.

## Audit findings (2026-10-17)
1. ~130 files carry rules; the same rule is copied up to 22 times (commit + push: 15 repo files + 7 memories).
2. Contradictions: who implements (memory vs CLAUDE.md, 00.07, tickets), subagents, handoffs (block vs same session),
   the v0.4 constitution (17 paths that never existed), 10 of 36 memories with old paths.
3. 38 role titles in the `_AGENT.md` files, 9 real agents, a third vocabulary in the tickets' `owner`.
4. Missing files cited as required (`21.01_Vision_and_Pillars.md`, `41.01_Style_Guide.md`, `61.01_QA_Strategy.md`);
   19 empty subfolders.
5. Sprint S00 still active with one ticket; 13 tickets open at once; daily logs stop on 10-15; stale statuses
   (ARC-0026, 05.00 Unbound); 8 done handoffs left in place; playtests filed under 10.01.
6. `check_readme.pl` reports false misses (CRLF); the README lags 05.00; the Lionheart has 11 artifacts to propagate.

## Phases
- [x] **A · One rulebook** — `00.01/Operating_Rules.md` with the work flow; CLAUDE.md imports it; AGENTS.md, 47 `_AGENT.md`,
      9 agents, `/handoff`, templates, `jt-gate` and the Data CLAUDE.md point to it; constitution v0.4 and 00.07
      archived; ADR-0010; 13 memories that duplicated rules retired.
- [x] **C · Real roles** — the 9 active roles are the only owners in `_AGENT.md` and tickets; dormant folders listed once.
- [x] **D · Production** — close S00, open S01 with WIP 3; fix statuses (ARC-0025/0026 → `implementation: owner`);
      archive done handoffs; playtests to 61; daily logs back.
- [ ] **E · Tools** — `check_readme.pl` CRLF; one `/auditoria` command running every check of this audit.
- [x] Missing cited files: 41.01 and 61.01 citations point to what exists; 21.01 stays an open Owner question.

## Log
- 2026-10-17 — Owner: "a empresa está bagunçada, regras espalhadas" → audit; Owner decisions: the Owner implements in the
  Toolkit and Claude verifies and fixes; no subagents; archive the constitution; plan approved, phase A first.
- 2026-10-17 — Phase A done (see the checklist). `jt-gate` now accepts `implementation: owner` for the fixes of stage 5;
  tested 4/4 with simulated payloads (owner/claude allowed with `[fechado]`, pending and no-tag denied).
- 2026-10-17 — Lionheart propagated (ARC-0009 log). Phase C done: `00.05` gains the table "Folder owners" (the source) and the list of dormant folders; every `_AGENT.md` and `_INDEX.md` names one of the 9 active roles (was 38 titles); ticket `owner:` normalised to the 9 roles (15 tickets); RACI hierarchy rewritten; OR-26 covers tickets; citations of the unwritten `41.01` and `61.01` point to what exists; `21.01` stays an open Owner question (`10.06`).
- 2026-10-17 — ARC-0027 (Producer, phase D): phase D: statuses set to the real stage; WIP = ARC-0008, ARC-0026, ARC-0027; the Owner's queue (in_review) = ARC-0009, ARC-0024.
- 2026-10-17 — Phase D done: S00 closed and archived (`91_Closed_Sprints/S00/`: goal, board, 11 daily logs + a catch-up for 10-16/17, the two old plans, 8 done handoffs); review and retro in `10.04/retrospectives/RETRO_S00.md`; S01 opened (WIP: ARC-0008, ARC-0026, ARC-0027; the Owner's queue: ARC-0009, ARC-0024); 14 tickets set to their real stage (5 design tickets closed, their gates moved to the build tickets; the three waiting builds are `implementation: owner`); OR-27 and OR-36 refined; 05.00 and README subclass states refreshed. Playtests stay in `10.01/playtests` (the board's tooling reads them there, ARC-0024).
