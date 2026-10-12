---
id: ARC-0002
title: Raise the Resonant to the subclass standard (design)
type: design
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Lead Class Designer
implementation: claude
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/Resonant/2026-10-06-heartweaver-design.md, 55/_wip/Resonant/decisions.md, 05.02/Resonant.md, 75.02/src/data/resonant.json]
outputs: [55/_wip/Resonant/decisions.md, 21.04/Resonant/2026-10-11-resonant-design.md, 05/HANDOFF_LeadClassDesigner_to_ContextKeeper_ARC-0002.md, 25.01/SPL_Resonant_*, 25.02/FEAT_Resonant_*, 25.03/STA_Resonant_*, 22.05/2026-10-11_ARC-0002_Resonant_Balance.md, 55/SPEC_ARC-0002.md]
blocked_by: []
sprint:
created: 2026-10-11
---

# ARC-0002 · Raise the Resonant to the subclass standard (design)

**Goal:** audit the Resonant against the evaluation questions of `_SUBCLASS_STANDARD.md` and close every
gap in a raising spec.
**Intent:** the Resonant plays its emotion mechanic with impact from level 1 — behaviour-changing
Surges, an overload meter and its Overflow — without running out of slots.

## Acceptance criteria

- [x] Every evaluative question of §3 answered for the Resonant (✅ / ⚠️ / ❌ with evidence).
- [x] Every ❌ and ⚠️ resolved by a decision in `55/_wip/Resonant/decisions.md` or listed as open.
- [x] Raising spec written in `21.04/Resonant/` (§1.5 sections, Identity Sheet complete, no audit inside).
- [x] Depth audit handed to the Context Keeper for `05.02/Resonant.md`.

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-08 — audit and decisions R1–R14 (before the project migration).
- 2026-10-11 — created; decisions R15–R17 (behaviour peaks, slot refund on reaction), R18–R19 (Shared Heart capstone), R20–R21 (names: Emotional Overload, Tier I Resonance).
- 2026-10-11 — raising spec `21.04/Resonant/2026-10-11-resonant-design.md` written; Depth audit handed to the Context Keeper. R22–R23 (Emotional Overload cost, Rage grudge) confirmed by the Owner.
- 2026-10-11 — balance pass approved: numbers in `25.01`–`25.03` (first master-data files, schema `25.00/master_data.schema.yaml`), arithmetic in `22.05/2026-10-11_ARC-0002_Resonant_Balance.md`; R24 (Shared Heart: until combat ends, free Surges on linked allies).
- 2026-10-11 — implementation plan `55/SPEC_ARC-0002.md` (stages 0–7; stage 0 and 1 in full) written, awaiting Owner review.
- 2026-10-11 — stage 0 done (generator, TDD 59/59; patches in `55/_wip/Resonant`; stats_add dry run 7 new / 69 replaced / 0 errors). Next: stage 1 needs `implementation: claude` and `[fechado] ARC-0002`.
- 2026-10-11 — stage 1 applied (`[fechado]`): Catharsis_Damage level map (LSX + tbl), engine patch (7 new, 69 replaced), upcast variants regenerated (inherit via `using`), sort_stats, check_cards OK, stats_add selftest 968/0, goal `ARCANA_Resonant_Grudge` written. Owner: compile the Story, then probes P0–P5 (SPEC_ARC-0002).
- 2026-10-11 — probes: P0 ✅ P1 ✅ P2 ❌ P3 ❌ P4 ❌ (INT gate, grudge vs madness), P5 not run. Decisions R25–R28.
- 2026-10-12 — stage 1b applied (`[fechado]`): constructs gate, grudge + fallback (goal rewritten), Trust shoulder, Joy self, Anticipation duration; tests 68/68, check_cards OK, selftest 970/0. Owner: compile the Story, re-test P2–P5.
- 2026-10-12 — re-test: P3 ✅ P5 ✅; P2 (Trust gone before the enemies' turn) and P4 (angry enemy without opportunity attacks) fixed in stage 1c (`[fechado]`): Trust ticks with the Resonant, Anger/Rage keep their reaction, refund line on every Surge tooltip; tests 71/71, selftest 970/0. Owner: re-test P2 and P4.
- 2026-10-12 — P2 ✅ P4 ✅: stage 1 closed. Stage 2 (Overload + Emotional Overload) written in full in SPEC_ARC-0002. Still open: balance pass, in-game tests (spec §15), Toolkit renames, player guide update (`75.02`).
