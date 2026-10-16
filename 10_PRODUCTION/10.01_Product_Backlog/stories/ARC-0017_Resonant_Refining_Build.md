---
id: ARC-0017
title: "Resonant refining build — R49–R68 in the game"
type: feature
epic: EPIC_Rework_Subclasses
status: ready
owner: Mod Engineer
implementation: claude
priority: should
value: 5
effort: 5
inputs: [21.04/Resonant/DESIGN.md, 21.04/Resonant/DECISIONS.md (R49–R68), 25 (*_Resonant_* pending_build), 55_Implementation_Specs/SPEC_ARC-0017.md, 61.02/Resonant/TC_ARC-0014.md]
outputs: [gen_emotion_alchemy.pl + tests, the Resonant's Stats/LSX/Osiris/Khonsu in Data, CardDB.lua + tests, 25 values moved from pending_build, 32.01 texts, 05.02/Resonant.md]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0017 · Resonant refining build — R49–R68 in the game

**Goal:** the game plays the Resonant as `DESIGN.md` describes it after the ARC-0014 refining (R49–R68).
**Intent:** close the loops, turn the Overload into a trade, spread the progression and make the kit read on screen —
in both editions.

## Acceptance criteria

- [x] Stage 0 — generator and Lua tests written first (RED), then green; the patches generated (SPEC_ARC-0017 §Stage 0)
- [ ] Stage 1 — moods and loops (R49, R50, R57) applied; probe B1 and rows V1, V2 pass
- [ ] Stage 2 — the Overload (R51–R53, R56, R66–R68) applied; probes B2–B5 and rows V4–V7, V11, V13 pass
- [ ] Stage 3 — the *Weave Surge* container and the PC deck copies (R54, R55) applied; row V9 and the Lua tests pass
- [ ] Stage 4 — progression, passives, growth, Heartstring, Shared Heart, texts (R58–R65, R67) applied; rows V3, V8, V10, V12 pass
- [ ] Stage 5 — `25` values moved out of `pending_build`; `05.02` synced; ARC-0010 can run
- [ ] Every stage: one `[fechado] ARC-0017` message, sync before apply, the apply chain, sync + commit + push after

## Log

- 2026-10-16 — created at the Owner's request after the ARC-0014 refining round; spec `SPEC_ARC-0017.md` written.
- 2026-10-16 — Stage 0 done: generator behind ARC17_STAGE (340 tests; stage 0 byte-identical), Lua in _wip (138), progression script (74). Rulings in SPEC_ARC-0017 §Stage 0; new probes B6, B7.
- 2026-10-16 — `[fechado]` stage 1 applied (ARC17_STAGE=1): engine patch (+RESONANT_REPLAY, +RESONANT_EXCESS_SPENT, +Target_Arcana_Created_CompassionTrust; Temper text), upcast variants, sort, check_cards OK, selftest 1129/0, ARCANA_Resonant_SharedHeart goal (helpful feelings only). Counts +2 Status_BOOST, +1 Spell_Target on both twins; no line over 3900; no repeated field. Waiting for the Owner: Story compile, probes B1, V1, V2, V10a.
- 2026-10-16 — `[fechado]` stage 2 applied (ARC17_STAGE=2): engine patch (+7 statuses: MIND_1/5/9, RIDER_TECH_1/5/9, FATIGUE_TECH; Overloaded, Overload, Emotional Overload, Tier III texts), progression (Emotional Overload at level 1), upcast variants (+5 Emotional Overload: 1 / 2 targets, AreaRadius 9 on 5-6), check_cards OK, selftest 1141/0, goals Overload + Temperance. The Owner tests at the end (B2-B5, V4-V7, V11, V13).
- 2026-10-16 — `[fechado]` stage 3 applied (ARC17_STAGE=3): engine patch (+Target_Arcana_Card_Spell_WeaveSurge, children named by emotion), progression (container at 1, Temper alone at 3, no list at 5), `gen_upcast_variants` fixed for children with own variants (ruling 12; +5 container variants listing the children `_L`), check_cards OK, selftest 1147/0, Lua copied into Data (138 pass there). The Owner tests at the end (B6, V9).
- 2026-10-16 — `[fechado]` stage 4 applied (ARC17_STAGE=4): engine patch (+RESONANT_SHARED_JOY, +Opposites, +Deeper Feelings 5/9; growing dice, Heartstring, Tier I, texts), level maps (Catharsis 1/5/9, +Resonant_Die4/Die4Neg/Die6/Die6Neg), progression (dump_progression matches DESIGN §10), check_cards OK, selftest 1151/0. Next: stage 5 (close), then the Owner's test round B1-B7, V1-V13.
- 2026-10-16 — Test guide written (Owner rule, from this ticket on): interactive page https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E (results in its db, collection `results`) + record `61.02_Test_Cases/Resonant/GUIDE_ARC-0017.md` generated from `GUIDE_ARC-0017.json` (33 tests by level; V6/V7 stay in ARC-0010).
