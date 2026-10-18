---
id: ARC-0019
title: "Deceiver refining: raise the Veil design to the subclass standard v2.1 (SG1–SG10)"
type: design
epic: EPIC_Rework_Subclasses
subclass: deceiver
status: done
owner: Lead Class Designer
implementation: pending
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/_SUBCLASS_REFINING.md, 21.04/Deceiver/2026-10-06-deceiver-veil-design.md, 05.02/Deceiver.md, 05.01/Arcana_Base_Class.md, 21.08, 10.06/Open_Questions.md]
outputs: [21.04/Deceiver/REFINE_Deceiver.md, 21.04/Deceiver/DECISIONS.md, 21.04/Deceiver/DESIGN.md, 21.03/Deceiver.md, 21.08]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0019 · Deceiver refining: raise the Veil design to the subclass standard v2.1

**Goal:** review the Deceiver (Veil design, D1–D17) against the Depth Model of standard v2.1 with the refining
method, log the Owner's answers as decisions and rewrite the dossier (`DESIGN.md` + `DECISIONS.md`, ADR-0009).
**Intent:** a Deceiver whose core rule fits in one sentence, whose ultimate and Tier III read the Veil, and whose
1–12 journey is spread and felt — before the 4.0 build.

## Acceptance criteria

- [x] Review written: `21.04/Deceiver/REFINE_Deceiver.md` (audit, SG1–SG10)
- [x] Owner answered every suggestion (2026-10-16): SG1–SG10 approved; SG4 with a wider Shatter; SG9 drops Telepathy
- [x] D1–D17 migrated and the approved suggestions logged in `21.04/Deceiver/DECISIONS.md` (prefix `DV`)
- [x] Level map revised without Telepathy, and SG11–SG12 (names, Nephele), approved → DV28–DV30
- [x] `DESIGN.md` complete and `21.03/Deceiver.md` written from the approved map
- [x] Propagation (00.08) to every department; `check_propagation.pl Deceiver` prints OK
- [x] Build ticket opened: ARC-0020 (`implementation: claude`), spec `55/SPEC_ARC-0020.md`

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15) — moved to ARC-0020 (ARC-0027)
- [ ] Narrative gate (`32.04`) — moved to ARC-0020 (ARC-0027)
- [ ] DoD (`00.03`) — moved to ARC-0020 (ARC-0027)

## Log

- 2026-10-16 — created. Refining review given in session and recorded in `REFINE_Deceiver.md`. Owner approved
  SG1–SG10 → DV18–DV27 (SG4 with a wider Shatter at Tier III; SG9 keeps Faceless and Friends, drops Telepathy and
  asks for a revised map). D1–D17 of the Veil design migrated as DV1–DV17 (the dated spec is archived when `DESIGN.md` replaces it). Proposed after the Owner's follow-ups: the vanilla Death Burst pattern for DV21, a revised level map without Telepathy, SG11 (rename the five LeBlanc names) and SG12 (drop Nephele — Ixion is the Kingmaker's). Matrix `21.08`
  corrected (Axis, Awakening goal). Nothing in the game changed.
- 2026-10-16 — Owner approved the map (DV28), the names (DV29: Eidolon, Seed of Doubt / Seed, Veilstep, Binding
  Falsehood, Twice-Told, Splinter) and SG12 (DV30, Nephele out). Lead Class Designer artifacts written: `DESIGN.md`,
  `21.03/Deceiver.md`, `21.08` (Deceiver rows); the Veil spec archived in `90/93/2026-10-16_ARC-0019_deceiver_veil_design/`;
  `05.02` points to the new dossier (game unchanged). Pending: propagation to 23.02, 25, 22.05, 26.01, 31.02, 32.01,
  33.03, 42.04, 61.02.
- 2026-10-16 — Propagation (00.08) done, each artifact in its owner's role; `check_propagation.pl Deceiver` prints OK.
  Spell Designer: `23.02/Deceiver/` (30 sheets + `_INDEX.md`, gen_spell_sheets.pl). Spell + Balance Designer: `25`
  — 19 `SPL_Deceiver_*`, 2 `FEAT_Deceiver_*`, 3 `STA_Deceiver_*` (values read from today's game files; DV changes in
  `pending_build` with ‹placeholders›). Balance Designer: `22.05/Deceiver.md`, `26.01/Deceiver.md` (directions only).
  Lore Writer: `31.02/Deceiver.md`, `32.01/Deceiver.md` (game texts today + DV29 names), `33.03/MOD_TERMINOLOGY.md`
  (Deceiver section). Icon Artist: `42.04/Deceiver.md` (17 briefs). QA Lead: `61.02/Deceiver/TC_ARC-0019.md` (Veil build
  A1–A8, build probes B1–B7, V1–V4). Context Keeper: `05.02` unchanged (game unchanged). Open for the Owner: `31.01` §4/§5
  still name the LeBlanc abilities and Sigils (base-class change); *Shatter on command* keeps the word DV29 cleared.
- 2026-10-16 — Owner: *Shatter on command* becomes **Splinter on command** → DV31 (amends DV24, follows DV29). Propagated:
  DESIGN.md, 21.03, 23.02 (`SPL_SplinterOnCommand`, renamed), 25 (`SPL_Deceiver_SplinterOnCommand`, renamed), 22.05,
  26.01, 32.01, 33.03, 42.04, 61.02. Lore Writer fixed `31.01` §4 and §5 (no LeBlanc names, no Sigils; the Deceiver's
  in-game description kept as the game text, with a draft for the build). DV24/DV28 and REFINE stay as the record.
- 2026-10-16 — Build ticket ARC-0020 opened with `SPEC_ARC-0020.md` (stages 0–5, probes B1–B4).
- 2026-10-16 — DV32 (Owner): Splinter on command is a deck card (`Target_Arcana_Card_Spell_SplinterOnCommand`, level 0, Threads on PC); propagated to DESIGN, 21.03, 23.02, 25, 22.05, 26.01, 33.03, 61.02 (V1b), SPEC_ARC-0020 Task 0.5; the rest reviewed, no change.
- 2026-10-17 — ARC-0027 (Producer, phase D): closed — the design is delivered (DESIGN.md, DV1–DV33); its Design and Narrative gates move to the build ticket ARC-0020, where later decisions go too (OR-1).
