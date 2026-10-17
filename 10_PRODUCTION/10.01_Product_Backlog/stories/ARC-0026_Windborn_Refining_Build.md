---
id: ARC-0026
title: "Windborn refining build: the game plays WB0–WB48"
type: rework
epic: EPIC_Rework_Subclasses
subclass: unbound
status: ready
owner: Mod Engineer
implementation: claude
priority: must
value: 5
effort: 5
inputs: [21.04/Unbound/DESIGN.md, 21.04/Unbound/DECISIONS.md, 25 (*_Unbound_*, pending_build), 22.05/Unbound.md, 32.01/Unbound.md, 61.02/Unbound/TC_ARC-0022.md]
outputs: [55/SPEC_ARC-0026.md, 55/_wip/Unbound/arc0026/, game files (Stats, LSX, Osiris, loca), 05.02/Unbound.md, 61.02/Unbound/GUIDE_ARC-0026.json]
blocked_by: []
sprint:
created: 2026-10-17
---

# ARC-0026 · Windborn refining build

**Goal:** apply the ARC-0022 refining (WB0–WB48) to the game, stage by stage, following `55/SPEC_ARC-0026.md`.
**Intent:** the game plays the Windborn as `21.04/Unbound/DESIGN.md` describes it, in both editions.

## Acceptance criteria

- [x] Sizes decided with the Owner (WB45–WB48); arithmetic in `22.05/Unbound.md`; values in `25` (`pending_build`)
- [ ] Stage 0: patches, structure script and goal drafts in `55/_wip/Unbound/arc0026/`, dry runs clean; texts through the Narrative gate (`32.04`)
- [ ] Probes P1–P8 recorded, plan B applied where one failed
- [ ] Stages 2–5 applied, one `[fechado] ARC-0026` message each; Story compiled with 0 errors after each goal change
- [ ] `61.02/Unbound/` rows pass in game; guide `GUIDE_ARC-0026.json` on the Arcana Test Guides page
- [ ] Stage 6: `25` holds no Windborn `pending_build` block; `05.02` synced; `check_propagation` OK

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`) — names checked against the vanilla corpus first (ARC-0021 collision check)
- [ ] DoD (`00.03`)

## Log

- 2026-10-17 — created from ARC-0022 at the Owner's request; spec skeleton written (stages, probes P1–P8). Sizes
  already approved in ARC-0022 (WB45–WB48), so stage 0 starts with the preparation. Nothing in the game changed.
