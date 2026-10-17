---
id: QA-0004
title: Playtest — The Windborn — stage 1 probes
type: playtest
kind: subclass
subclass: Unbound
build: ARC-0026
guide: 61.02_Test_Cases/Unbound/GUIDE_ARC-0026.json
status: ready
owner: QA
implementation: owner
blocked_by: []
created: 2026-10-17
---

# QA-0004 · Playtest — The Windborn — stage 1 probes

**Goal:** play every test of `61.02_Test_Cases/Unbound/GUIDE_ARC-0026.json`, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E).
**Intent:** ARC-0026 is proven in the game, or each failure becomes an ARC bug and a QA bug-retest.

Steps, expected results and plan B are on the test page and in the record `61.02_Test_Cases/Unbound/GUIDE_ARC-0026.md`. This list is rebuilt from the guide, with the results, at every kanban sync (`/update-board`).

## Before you start

- Stage 1 of ARC-0026 is applied (a [fechado] ARC-0026 message), the Story is compiled and log.txt shows 0 error(s), 0 warning(s).
- Console edition: Script Extender off (the PC deck locks the probe spells in combat).
- Load a save with the party; the probe spells ("Probe: ...") and the passive Probe Touch are added to every player character on load.
- Any class and level. Probes are throwaway: stage 2 removes them.
- Write down what you see for each probe, even when it fails: every probe has a plan B.

## Probes

**Setup:** A fight with at least four enemies, spread out, and one ally in melee with an enemy. One character runs the probes.

- [ ] P1 · A Rush: no opportunity attack, paths around obstacles (SPEC_ARC-0026 P1 (the Rush carries her, WB5))
- [ ] P2 · Marked enemies can't be rushed (SPEC_ARC-0026 P2 (Rush only to an unmarked enemy))
- [ ] P6 · A marked enemy makes no opportunity attack (SPEC_ARC-0026 P6 (the Open Path, WB10: the vanilla Mobile pair))
- [ ] P7 · A hit marks; an ally's hit marks in her name (SPEC_ARC-0026 P7 (marks from hits — hers and an ally's))
- [ ] P8 · The bag's X: marks counted, capped at 2 (SPEC_ARC-0026 P8 (X counted and capped))
- [ ] P3 · Turn start sweeps the marks; turn end is seen (SPEC_ARC-0026 P3 (the sweep at her turn start; her turn end))
- [ ] P4 · The vortex pulls marked enemies from 9 m, the others from 6 m, once each (SPEC_ARC-0026 P4 (Where the Winds Meet, two radii))
- [ ] P5 · Leap of Faith with the Force Tunnel animation (SPEC_ARC-0026 P5 (Leap of Faith on the Force Tunnel animation, WB7))
- [ ] P9 · Into the Storm: the push from a status (SPEC_ARC-0026 P9 (a status pushes away from its source))

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail has an ARC bug and a QA bug-retest

## Log

- 2026-10-17 — created from `61.02_Test_Cases/Unbound/GUIDE_ARC-0026.json` (9 tests).
