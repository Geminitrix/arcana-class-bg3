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
- 2026-10-16 — Owner chose the kit: **The Open Road** as the core (WB3) and the **Beaufort** bands as the ranks of
  Zephyr Strike (WB4). Feasibility note: Leap of Faith is already a `Rush` spell `using "Rush_SpringAttack"` with an
  unarmed attack roll (`Spell_Rush.txt`), the proven pattern for a strike that carries you to the target.
- 2026-10-16 — Owner asked which rush animation fits. Vanilla rushes listed in `REFINE_Unbound.md` (appendix): vanilla
  `Rush_MAG_ZephyrFlash` already uses the `Rush_SpringAttack` animation (same as Leap of Faith); `Rush_ForceTunnel`
  (tadpole power) has its own player animation that dashes through a line. Animations not seen in game by Claude.
- 2026-10-16 — Owner: Zephyr Strike against an unmarked enemy is a Rush with the `Rush_SpringAttack` animation (WB5);
  the push arrives at the Gale rank (WB6); Leap of Faith moves to the `Rush_ForceTunnel` animation (WB7). Probe for the
  build: opportunity attacks and pathing of a Rush (T2).
- 2026-10-16 — Owner: the Touch of the Wind marks — any hit of yours or any failed save against your effects (WB8);
  chosen over "only unarmed strikes" and "only forced movement".
- 2026-10-16 — Owner: Windswept lasts until the end of your next turn (WB9). Weighed and set aside: one round, and "the
  full circle" with three variants (speed, stored laps, homecoming) — the laps and homecoming hooks stay as ideas for
  Tier III or the Hurricane rank.
- 2026-10-16 — Owner: Windswept enemies can't make opportunity attacks (WB10). Owner's idea under discussion: the four
  winds of Aeolus (N/S/E/W), each with a party boon and an enemy bane — random at combat start, an ultimate, or
  elsewhere. Feasibility read: the mod's Osiris already uses `EnteredCombat` / `CombatEnded`; vanilla Osiris uses
  `Random(N,_Var)`; vanilla aura pattern `AURA_OF_PROTECTION` (`SharedDev/.../Status_BOOST.txt`).
- 2026-10-16 — Owner: the ultimate is Aeolus' Bag of the four winds — bonus action, choose a wind, lasts X turns
  (X = enemies marked when opened), can't reopen until it stops, around level 5, epic (WB11).
- 2026-10-16 — Owner: opening the bag clears the marks; the wind's bane falls on Windswept enemies (WB12).
- 2026-10-16 — Owner: the bag needs at least one mark; X is capped by Zephyr's Beaufort rank (WB13).
- 2026-10-16 — Owner: the bag arrives at level 2 (WB14); the winds join with the ranks — Zephyrus is Zephyr Strike,
  Boreas and Notus at Breeze, Eurus (attack) at Gale, two winds at once at Hurricane (WB15).
- 2026-10-16 — Owner: Zephyr ranks Breeze 1, Gale 4, Storm 8, Hurricane 12 (WB16) — an exception to the standard's
  empty levels 4 and 8 for the Windborn, with the vanilla precedent (Four Elements monk at 4 and 8). The standard is
  unchanged; 21.08 "Level rhythm" to note the exception at propagation.
