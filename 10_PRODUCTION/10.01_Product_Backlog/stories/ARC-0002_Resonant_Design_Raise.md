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
- 2026-10-12 — P2 ✅ P4 ✅: stage 1 closed. Stage 2 (Overload + Emotional Overload) written in full in SPEC_ARC-0002.
- 2026-10-12 — stage 2 applied (`[fechado]`): Overload statuses + passive, Emotional Overload (`Target_Arcana_Created_EmotionalOverload`, ARCANA_IS_SPELL mark), generated counter goal `ARCANA_Resonant_Overload`, grudge goal internals renamed to `ARCANA_`; DEBUG grants the passive and the spell; tests 91/91, check_cards OK, selftest 975/0. Owner: compile the Story, probes P6–P10.
- 2026-10-12 — the DEBUG list is granted by no progression, so P6–P10 can't run; Owner chose the real progression: Overload passive + Emotional Overload at Resonant level 5 (`_wip/Resonant/50_progression_level5.pl`, LSX + TBL). Refund at level 1 reported missing — evidence asked.
- 2026-10-12 — refund isolation tests A and B both passed (Owner); left as is. Level 5 applied (`[fechado]`): Overload passive + Emotional Overload; dump confirms; check_cards OK. Owner: probes P6–P10. Still open: balance pass, in-game tests (spec §15), Toolkit renames, player guide update (`75.02`).
- 2026-10-12 — R34 (costs: Temper Bonus Action only; Contagion and Compassion level 3 cards). Stage 3 applied (`[fechado]`): P8 fix (RequirementConditions), always-visible meter (R32), Heartstring, Temper (+ goal `ARCANA_Resonant_Temper`), Read the Room, Ready: Compassion, Emotional Contagion; lists via `_wip/Resonant/52_progression_stage3.pl` (Contagion and Compassion on the level 5 list until stage 6); tests 162/162, check_cards OK, selftest 994/0. Owner: compile the Story, probes P8, P10–P15.
- 2026-10-12 — probes P8 ✅ P11 ✅ (both sides) P12 ✅ P15 ✅, P10 accepted as is, P13 ❌, P14 redundant. R35 (Contagion to the target's allies only), R36 (Temper: the mood's root emotion for 1 turn), R37 (Read the Room removed). Stage 3b built project-side (tests 156/156; patch: 6 removals); apply with `[fechado] ARC-0002`.
- 2026-10-12 — stage 3b applied (`[fechado]`): 6 entries removed (Temper sides + techs, Read the Room + status), Temper rewritten, Contagion to allies; level 1 list without Read the Room; goal `ARCANA_Resonant_Temper` and the retired files moved to `90_ARCHIVE/93_Old_Versions/2026-10-12_ARC-0002_stage3b`; check_cards OK, selftest 992/0, no repeated fields. Owner: compile the Story, probes P11b, P13b.
- 2026-10-12 — P11b ✅ P13b ✅: stage 3 closed. R38 (The Two Cups does not fill the Overload), R39 (Harmony's mood follows the side). Stage 4 (Aspect Awakening, Temperance) written in full in SPEC_ARC-0002 (tasks 4.1–4.8, probes P16–P21).
- 2026-10-12 — stage 4 applied (`[fechado]`): Aspect Awakening 14 · Temperance — tier statuses and passives, The Two Cups, Catharsis +1d8 and 7-turn moods at Tier I, goal `ARCANA_Aspect_Temperance` (count, Harmony, Tier III wave), Common rows, progression L3/L7/L12 (`54_stage4_apply.pl`); tests 199/199, check_cards OK, selftest 1003/0. Owner: compile the Story, probes P16–P21.
- 2026-10-12 — probes P16–P19, P21 ✅; P20 ❌. R40 (Tier II: feelings +2 turns, one free Weave Surge per turn via Khonsu `IsWeaveSurge()`), R41 (Surges on any creature). Stage 4b built project-side (tests 204/204; dry run: 1 new status, the rest replaced); apply with `[fechado] ARC-0002`.
- 2026-10-12 — stage 4b applied (`[fechado]`): Tier II feelings +2 and a free Surge per turn (`RESONANT_SURGE_FREE`, Khonsu `Scripts/thoth/helpers/IsWeaveSurge.khn`, marker `ARCANA_IS_SURGE` on the 8 Surges), Surges on any creature, old Harmony removed; Tier III rule now reads the card by `DB_ARCANA_CardFamily` (check_cards rule); tests 205/205, check_cards OK, selftest 1004/0, +1 Status_BOOST both sides. Owner: compile the Story, probes P20b, P22–P24.
- 2026-10-12 — Toolkit warned of a 4833-character line (the Surges' SpellSuccess after 4b). Built (not applied): refund in Osiris, short Tier II marker `RESONANT_TIER2`; longest line 3301; tests 213/213. Owner told not to save in the Toolkit until applied.
- 2026-10-12 — line-length fix applied (`[fechado]`): refund in `ARCANA_Resonant_Overload`, marker `RESONANT_TIER2`; no mod line over 4000 characters; tests 213/213, check_cards OK, selftest 1005/0, +1 Status_BOOST both sides. Owner: compile the Story; probes P20b, P22–P24 and the refund.
- 2026-10-12 — P20b, P22–P24 ✅. Owner's Toolkit edits captured in the generator (not applied): Surges' SpellRoll `SpellAutoResolveOnAlly(Ability.Wisdom,SourceSpellDC(),true)` (vanilla pattern; allies never roll); reaction list one per line (Intense, Primary, Secondary, Tertiary, Catharsis), no refund line; tests 213/213, Fear's text identical to the Owner's. Design gap found: two Surges in one turn can't react (the first leaves a peak, not a mood) — options being discussed.
- 2026-10-12 — R42 (the free Surge leaves its mood at once, so the second Surge of the turn reacts). Stage 4c built project-side with the Owner's Toolkit edits (tests 219/219; longest line 3301); apply with `[fechado] ARC-0002`.
- 2026-10-12 — stage 4c applied (`[fechado]`): the Owner's AutoResolve and one-reaction-per-line texts, Temper on AutoResolve too, R42 (free Surge leaves its mood at once) in `ARCANA_Aspect_Temperance`; tests 219/219, check_cards OK, selftest 1005/0, counts unchanged, no line over 4000. Owner: compile the Story; P25, P26.
- 2026-10-12 — P26 ✅; P25 only on one target of a multi-target Surge. R42 rebuilt in the peaks' OnApplyFunctors (Stats, every target), Osiris mark removed; tests 217/217 (not applied).
- 2026-10-12 — R42 on every target applied (`[fechado]`): the echo in the 8 peaks' OnApplyFunctors, Temperance goal without the Osiris mark; tests 217/217, check_cards OK, selftest 1005/0, counts unchanged. Owner: compile the Story; P25 with several targets.
- 2026-10-12 — R43 (Shared Heart: level 5 card, Unique, once per long rest), R44 (Catharsis heals every linked ally). Stage 5 (Shared Heart) written in full in SPEC_ARC-0002 (tasks 5.1–5.5, probes P27–P31). Found: CardDB.lua (SE edition) has no Resonant card yet — stage 6.
- 2026-10-12 — R45 (PC edition: Temper costs 1 Thread, the level-0 card rule). Stage 6 (lists 9/11, progression, CardDB for the PC edition, Compassion as a PC reaction card, Emotional Overload in the PC edition) written in full in SPEC_ARC-0002 (6.1–6.6, probes P32–P33).
- 2026-10-12 — stages 5 and 6 applied (`[fechado]`): Shared Heart (card, link, copies counted once, Catharsis heal, free Surges on linked allies), lists 9/11 and progression, Compassion as a reaction card with `ArcanaReactCompassion`, CardDB.lua for the PC edition (Lua tests 134/134); generator 244/244, check_cards OK, selftest 1011/0; dump matches spec §10. Owner: compile the Story; probes P27–P33; decide the DEBUG scaffold.
- 2026-10-12 — stage 7 (close): QA handoff with the test cases (61), design §15 / §13.2 updated, 05 handoff §9 (final state), ticket ARC-0006 (player guide) + 75 handoff. DEBUG scaffold retirement built (generator 244/244, `56_retire_debug.pl`, archived), not applied — the message named no ticket. Open: apply the DEBUG retirement; probes P25, P27–P33.
- 2026-10-12 — DEBUG scaffold retired in the game (`[fechado]`): `Shout_Arcana_Util_DEBUG_Resonant` and `RESONANT_DEBUG` removed, the shout off the "Arcana Deck DEBUG" list; selftest 1009/0, check_cards OK, no reference left. Open: probes P25, P27–P33.
- 2026-10-12 — Owner: Shared Heart not working (cause: Story compiled before its goal was applied). R46 (Shared Heart shares feelings only + the Catharsis heal; free Surges dropped), R47 (feelings Additive), R48 (Emotional Overload a bonus action); bug fixed: Compassion triggered on the Resonant's own Surge (now enemy source only). Built, not applied (tests 247/247).
