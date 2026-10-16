---
id: ARC-0020
title: "Deceiver refining build: the game plays DV18–DV31"
type: rework
epic: EPIC_Rework_Subclasses
subclass: deceiver
status: ready
owner: Mod Engineer
implementation: claude
priority: must
value: 5
effort: 4
inputs: [21.04/Deceiver/DESIGN.md, 21.04/Deceiver/DECISIONS.md, 25 (*_Deceiver_*, pending_build), 61.02/Deceiver/TC_ARC-0019.md]
outputs: [55/SPEC_ARC-0020.md, 55/_wip/Deceiver/arc0020/, game files (Stats, LSX, Osiris, loca), 05.02/Deceiver.md]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0020 · Deceiver refining build

**Goal:** apply the ARC-0019 refining (DV18–DV31) to the game, stage by stage, following `55/SPEC_ARC-0020.md`.
**Intent:** the game plays the Deceiver as `21.04/Deceiver/DESIGN.md` describes it, in both editions.

## Acceptance criteria

- [ ] Stage 0: the open sizes of `25` (`‹…›` in `pending_build`) decided with the Owner; patches and scripts ready, dry runs clean
- [ ] Stages 1–4 applied, one `[fechado] ARC-0020` message each; Story compiled with 0 errors after each goal change
- [ ] Probes B1–B4 recorded, plan B applied where one failed
- [ ] `61.02/Deceiver/TC_ARC-0019.md` rows pass in game
- [ ] Stage 5: `25` holds no Deceiver `pending_build` block; `05.02` synced; `check_propagation` OK

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created from ARC-0019 at the Owner's go-ahead ("pode dar sequência"); spec written. Nothing in the
  game changed.
- 2026-10-16 — Stage 0 started: Task 0.4 script `55/_wip/Deceiver/arc0020/20_structure.pl` written, dry run matches DESIGN §9.1; Task 0.1 sizes proposed to the Owner (Splinter Tier III 4 m, Grand Deception 1 Doubt per Double within 3 m, Splinter on command 18 m and 1 Thread, Mirrored Self plan B 9 m) — awaiting approval.
- 2026-10-16 — Task 0.1 sizes approved by the Owner and written in `25` (arithmetic in `22.05/Deceiver.md`). Task 0.2–0.3 draft `arc0020/10_names.patch` (43 strings + 2 new, dry run clean) — awaiting the Narrative gate.
- 2026-10-16 — Narrative gate passed for stage 1 texts (Owner): `32.04/ARC-0020_Deceiver.md`. Stage 0 next: Task 0.5.
- 2026-10-16 — Task 0.5 prepared: `arc0020/30_splinter_command.patch`, `32_goal_splinter_command.pl`, `lua/` (CardDB + test, 138 pass). Next: Tasks 0.6–0.7 (Tier III burst, Grand Deception).
