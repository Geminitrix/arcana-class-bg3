---
id: ARC-0022
title: "Windborn (Unbound) refining: rework to the subclass standard v2.1"
type: design
epic: EPIC_Rework_Subclasses
subclass: unbound
status: in_progress
owner: Lead Class Designer
implementation: pending
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/_SUBCLASS_REFINING.md, 05.02/Unbound.md, 05.01/Arcana_Base_Class.md, 21.08, 31.01, 10.06/Open_Questions.md, 22.06/Arcana_Power_Budget.md]
outputs: [21.04/Unbound/REFINE_Unbound.md, 21.04/Unbound/DECISIONS.md, 21.04/Unbound/DESIGN.md, 21.03/Unbound.md, 21.08]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0022 · Windborn (Unbound) refining

**Goal:** review the Windborn (internal name Unbound, ADR-0002) against the Depth Model of standard v2.1 with the
refining method, propose alternative kits that tie the card, the references and the fantasy together, log the Owner's
answers as decisions and write the dossier (`DESIGN.md` + `DECISIONS.md`, ADR-0009).
**Intent:** a monk-like air wanderer whose mechanic asks a Position question, feels like Curiosity, has an ultimate that
reads its state and a 1–12 journey the player feels — before the 4.0 build.

## Acceptance criteria

- [ ] Review written: `21.04/Unbound/REFINE_Unbound.md` (audit, alternative kits, suggestions)
- [ ] Owner chose a kit direction and answered every suggestion
- [ ] Decisions logged in `21.04/Unbound/DECISIONS.md` (prefix `WB`)
- [ ] `DESIGN.md` complete and `21.03/Unbound.md` written from the approved map
- [ ] Propagation (00.08) to every department; `check_propagation.pl Unbound` prints OK
- [ ] Build ticket opened (`implementation: claude`), spec in `55`

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created. Game read with `dump_progression.pl` (matches `05.02/Unbound.md`; list typo
  `Unboung Level 7`). Depth audit given in session and recorded in `REFINE_Unbound.md`. Owner: the subclass is
  monk-like, close to the Air Nomads, and leans on cards that enable passive states — by design (WB1); axis
  **Position** (WB2). Nothing in the game changed.
