---
id: QA-0003
title: Playtest — The Starchild — stage 1 probes
type: playtest
kind: subclass
subclass: starchild
build: ARC-0025
guide: 61.02_Test_Cases/Starchild/GUIDE_ARC-0025_probes.json
status: backlog
owner: QA Lead
implementation: owner
blocked_by: []
created: 2026-10-17
---

# QA-0003 · Playtest — The Starchild — stage 1 probes

**Goal:** play every test of `61.02_Test_Cases/Starchild/GUIDE_ARC-0025_probes.json`, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E).
**Intent:** ARC-0025 is proven in the game, or each failure becomes an ARC bug and a QA bug-retest.

Steps, expected results and plan B are on the test page and in the record `61.02_Test_Cases/Starchild/GUIDE_ARC-0025_probes.md`. This list is rebuilt from the guide, with the results, at every test guides sync (`/sync-test-guides`).

## Before you start

- Stage 1 of ARC-0025 is applied (a [fechado] ARC-0025 message), the Story is compiled and log.txt shows 0 error(s), 0 warning(s).
- Load a save with the party; the probe spells ("Probe: …") are added to every player character on load.
- Any class and level. Probes are throwaway: stage 2 removes them.
- Write down what you see for each probe, even when it fails: every probe has a plan B.

## Probes

**Setup:** The party out of combat, then a small fight for P2, P3, P5 and P6.

- [ ] P1 · A container child locked by a status (SPEC_ARC-0025 P1 (containers locked by the Hymn, SC22))
- [ ] P2 · Marks on a downward crossing (SPEC_ARC-0025 P2 (Dusk and Nightfall, SC10, SC11))
- [ ] P3 · A one-turn gate with TickType StartTurn (SPEC_ARC-0025 P3 (the first-heal gate, SC19))
- [ ] P4 · Pull an ally (SPEC_ARC-0025 P4 (Tether, SC20))
- [ ] P5 · A light that switches its bonus off in combat (SPEC_ARC-0025 P5 (Lantern, SC27))
- [ ] P6 · Undying Hope leaves Nightfall (SPEC_ARC-0025 P6 (Undying Hope into Nightfall, SC18))

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail has an ARC bug and a QA bug-retest

## Log

- 2026-10-17 — created from `61.02_Test_Cases/Starchild/GUIDE_ARC-0025_probes.json` (6 tests).
- 2026-10-17 — ARC-0027: back to backlog — these probes were prepared but never applied; ARC-0025 is now typed by the Owner (OR-11), so its build kit (stage 4) writes a level-by-level guide and this ticket is replaced or re-pointed then. Guide renamed `GUIDE_ARC-0025_probes.json`.
