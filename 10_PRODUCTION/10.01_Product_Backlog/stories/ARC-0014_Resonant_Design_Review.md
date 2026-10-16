---
id: ARC-0014
title: "Resonant design review: balance, structure and felt progression (proposals S1–S16)"
type: design
epic: EPIC_Rework_Subclasses
subclass: resonant
status: in_review
owner: Lead Class Designer
implementation: pending
priority: should
value: 4
effort: 2
inputs: [21.04/Resonant/DESIGN.md, 21.04/Resonant/DECISIONS.md, 21.04/_SUBCLASS_STANDARD.md, 25, 22.05/Resonant.md, 22.06, 26.01/Resonant.md]
outputs: [21.04/Resonant/REFINE_Resonant.md, 21.04/Resonant/REFINE_Resonant_2026-10-15.md]
blocked_by: []
sprint:
created: 2026-10-15
---

# ARC-0014 · Resonant design review: balance, structure and felt progression

**Goal:** an end-to-end review of the Resonant (R1–R48) against the Depth Model and game-design research, with every
suggested change, its reasons, alternatives, impact and verification.
**Intent:** tighten the kit around its core rule and make the 1–12 progression felt, before the 4.0 build.

## Acceptance criteria
- [x] Review written: `21.04/Resonant/REFINE_Resonant.md` (S1–S16, playtest metrics V1–V11)
- [x] v2-format review written: `21.04/Resonant/REFINE_Resonant_2026-10-15.md` (SG1–SG18, V1–V11; brainstorm order in §12)
- [x] Owner reviewed each suggestion (2026-10-16): SG1–SG3, SG6–SG17 approved as R49–R65; SG4, SG5 superseded by R51; SG18 by R54–R55; SG13 goes into the DESIGN rewrite
- [x] Approved suggestions logged as R49–R65 in `DECISIONS.md`
- [x] `DESIGN.md` rewritten and the change propagated (00.08), 2026-10-16
- [x] Playtest metrics merged into ARC-0010 (`61.02/Resonant/TC_ARC-0014.md`)

## Log

- 2026-10-15 — review written at the Owner's request; status `review`. Nothing in the design, master data or game
  files changed.
- 2026-10-15 — At the Owner's request, the proposal was analysed with the refining method and rewritten in the v2 format as `REFINE_Resonant_2026-10-15.md` (the proposal stays as the record). Checked against the generator and `25`: the Intensify loop is wider than S4 says (upcast, R42, Contagion → mass extra actions; enemy stun-lock), Temper renews its own mood (a Bonus-Action lock), S9 contradicts R40. New: SG1 (a used mood is spent), SG2 (excess once per fight), SG8 (kindness rule), SG10 (level map over every level — Owner decision D9, standard v2.1), SG17; S6 and S9 dropped. Nothing in the design, `25` or the game changed.
- 2026-10-15 — Owner approved SG1 → R49 (a used mood is spent; Temper reworked, replaces R36). `DESIGN.md` and the build follow at the end of the brainstorm round.
- 2026-10-15 — Owner approved SG2 option A → R50 (a creature feels an intense emotion once per fight).
- 2026-10-16 — Owner approved SG3 (option A) with a redesign of the Overload → R51: *Overloaded* is a Mental Fatigue variant on the Resonant (flat mental-save penalty, Psychic per turn, Surges deal the same to enemies once per turn, no silence); Emotional Overload in ranks 1/5/12 applies vanilla Mental Fatigue, spends feelings (half on a save) and paralyses 1 turn on a failed save. SG4 and SG5 superseded. Vanilla facts checked: `MAG_PSYCHIC_MENTAL_FATIGUE` (Status_BOOST.txt, MultiplyEffectsByDuration, discharge at 5+ turns, cap 7 via the technical status) and bg3.wiki "Mental Fatigue (Condition)".
- 2026-10-16 — R52 (R51 penalty at 5/10, once per turn confirmed), R53 (SG6: the meter settles to half and *Overloaded* ends when a fight ends), R54 (the Surges become one container *Weave Surge*, children named after the emotions; supersedes SG18; the PC copy count is open).
- 2026-10-16 — R55: on PC, *Weave Surge* holds 3 copies per emotion known (an exception to the 3-copies rule, this card only).
- 2026-10-16 — R56 (SG7): waking Tier III fills the meter.
- 2026-10-16 — R57 (SG8): the kindness rule.
- 2026-10-16 — R58 (SG9): Shared Heart casts Joy on every linked creature.
- 2026-10-16 — R59 (SG10): the level map spread over every level (4 and 8 empty).
- 2026-10-16 — R60 (SG11): Catharsis taught at level 3 (passive *Opposites*, working name).
- 2026-10-16 — R61 (SG15): Heartstring reads feelings.
- 2026-10-16 — R62 (SG16): the dice states grow at 5 and 10.
- 2026-10-16 — R63 (SG17): Tier I drops the mood extension.
- 2026-10-16 — R64 (SG12): moods and Surges list their reactions.
- 2026-10-16 — R65 (SG14): Anger said as a taunt. Brainstorm round closed: R49–R65.
- 2026-10-16 — R66 (Emotional Overload ranks by slot variant, one zero-cost passive; Owner-tested engine fact) and R67 (growth rhythm 1/5/9). Open: Tier III bonus at 12.
- 2026-10-16 — R68: Emotional Overload applies vanilla Irresistible Dance (1 turn; 2 at Tier III) instead of Paralysis.
- 2026-10-16 — Propagation (00.08) of R49–R68, each role in session: `DESIGN.md` rewritten (present tense, SG13 fixes); `21.03/Resonant.md` (spread map); `21.08` (Resonant rows); `23.02/Resonant/` (24 sheets updated, 4 reviewed, new `SPL_WeaveSurge`, `FEAT_Opposites`, index); `25` (13 files: `pending_build` blocks — the generator still reads today's values; validate OK, 247 tests pass); `22.05/Resonant.md` and `26.01/Resonant.md` (directions, resources); `31.02` (theme); `32.01` (draft texts for the build); `33.03` (terms); `42.04` (icon briefs); `61.02/Resonant/TC_ARC-0014.md` (probes B1–B5, rows V1–V13) and ARC-0010; `05.02` reviewed (game unchanged). Next: the build spec and an implementation ticket.
- 2026-10-16 — Build ticket ARC-0017 opened (`implementation: claude`) with `SPEC_ARC-0017.md` (stages 0–5).
