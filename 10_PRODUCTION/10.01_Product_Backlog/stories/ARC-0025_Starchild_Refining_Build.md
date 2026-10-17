---
id: ARC-0025
title: "Starchild refining build: the game plays SC0–SC32"
type: rework
epic: EPIC_Rework_Subclasses
subclass: starchild
status: in_progress
owner: Mod Engineer
implementation: claude
priority: must
value: 5
effort: 5
inputs: [21.04/Starchild/DESIGN.md, 21.04/Starchild/DECISIONS.md, 25 (*_Starchild_*, pending_build), 22.05/Starchild.md, 61.02/Starchild/]
outputs: [55/SPEC_ARC-0025.md, 55/_wip/Starchild/arc0025/, game files (Stats, LSX, Osiris, loca), 05.02/Starchild.md]
blocked_by: []
sprint:
created: 2026-10-17
---

# ARC-0025 · Starchild refining build

**Goal:** apply the ARC-0023 refining (SC0–SC32) to the game, stage by stage, following `55/SPEC_ARC-0025.md`.
**Intent:** the game plays the Starchild as `21.04/Starchild/DESIGN.md` describes it, in both editions.

## Acceptance criteria

- [x] Stage 0: the sizes of `25` (`‹…›` in `pending_build`) decided with the Owner, round by round; arithmetic in `22.05/Starchild.md`
- [ ] Probes P1–P6 recorded, plan B applied where one failed
- [ ] Stages 1–5 applied, one `[fechado] ARC-0025` message each; Story compiled with 0 errors after each goal change
- [ ] `61.02/Starchild/` rows pass in game
- [ ] Stage 6: `25` holds no Starchild `pending_build` block; `05.02` synced; `check_propagation` OK

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`) — names checked against the vanilla corpus first
- [ ] DoD (`00.03`)

## Log

- 2026-10-17 — created from ARC-0023 at the Owner's go-ahead ("pode prosseguir"); spec skeleton written. Stage 0
  round 1 (the heal core) proposed. Nothing in the game changed.
- 2026-10-17 — R1 (the heal core) approved with the Sun brake amended (SC33); written in `25` and `22.05`. R2 (the Awakening) proposed.
- 2026-10-17 — R2 (the Awakening) approved (SC34); written in `25` and `22.05`. R3 (the cards) proposed.
- 2026-10-17 — R3 (the cards) approved (SC35); written in `25` and `22.05`. R4 (Lantern, Light in the Dark) proposed.
- 2026-10-17 — R4 approved (SC36); every Starchild size is set in `25`. Next: stage 0 preparation — the probe patch for stage 1.
- 2026-10-17 — SC33–SC36 propagated (00.08): DESIGN and the Hymns sheet carry the amended Sun brake, 26.01 the goals and Hesperus charges; other artifacts checked, no change. check_propagation Starchild OK.
- 2026-10-17 — Stage 1 prepared: `_wip/Starchild/arc0025/00_probes.patch` (dry run clean: 27 strings, 18 entries) and the probe goal; guide `61.02/Starchild/GUIDE_ARC-0025.json`, playtest `QA-0003`. Next: `[fechado] ARC-0025` applies stage 1.
