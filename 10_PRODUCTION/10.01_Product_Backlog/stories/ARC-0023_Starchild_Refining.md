---
id: ARC-0023
title: "Starchild refining: rework to the subclass standard v2.1, with paths of light"
type: design
epic: EPIC_Rework_Subclasses
subclass: starchild
status: in_progress
owner: Lead Class Designer
implementation: pending
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/_SUBCLASS_REFINING.md, 05.02/Starchild.md, 21.08, 31.01, 10.06/Open_Questions.md]
outputs: [21.04/Starchild/REFINE_Starchild.md, 21.04/Starchild/DECISIONS.md, 21.04/Starchild/DESIGN.md, 21.03/Starchild.md, 21.08]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0023 · Starchild refining

**Goal:** review the Starchild against the Depth Model of standard v2.1 with the refining method, design the paths of
light the Owner asked for, log the answers as decisions and write the dossier (`DESIGN.md` + `DECISIONS.md`).
**Intent:** a focused, high-output healer (Soraka) who specialises in a path of light — star (Radiant, healing), sun
(Fire), moon (Cold) — with healing and support as the focus on every path, an axis, an ultimate and a 1–12 journey the
player feels.

## Acceptance criteria

- [x] Review started: `21.04/Starchild/REFINE_Starchild.md` (frame, portrait, audit)
- [ ] Owner chose how the paths work and a kit direction
- [ ] Decisions logged in `21.04/Starchild/DECISIONS.md` (prefix `SC`)
- [ ] `DESIGN.md` complete and `21.03/Starchild.md` written from the approved map
- [ ] Propagation (00.08) to every department; `check_propagation.pl Starchild` prints OK
- [ ] Build ticket opened (`implementation: claude`), spec in `55`

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created. Game read with `dump_progression.pl` (matches `05.02/Starchild.md`). Depth audit recorded in
  `REFINE_Starchild.md`. Owner brief: healer first (Soraka), with paths of light — sun (Fire), moon (Cold), star
  (Radiant, healing) — either two paths on a star trunk or three paths. Nothing in the game changed.
