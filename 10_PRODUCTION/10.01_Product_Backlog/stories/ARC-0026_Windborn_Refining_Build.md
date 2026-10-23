---
id: ARC-0026
title: "Windborn refining build: the game plays WB0–WB48"
type: rework
epic: EPIC_Rework_Subclasses
subclass: unbound
status: in_qa
owner: Mod Engineer
implementation: owner
priority: must
value: 5
effort: 5
inputs: [21.04/Unbound/DESIGN.md, 21.04/Unbound/DECISIONS.md, 25 (*_Unbound_*, pending_build), 22.05/Unbound.md, 32.01/Unbound.md, 61.02/Unbound/QA_ARC-0026.md]
outputs: [55/SPEC_ARC-0026.md, 55/_wip/Unbound/arc0026/, game files (Stats, LSX, Osiris, loca), 05.02/Unbound.md, 61.02/Unbound/QA_ARC-0026.md]
blocked_by: []
sprint: S01
created: 2026-10-17
---

# ARC-0026 · Windborn refining build

**Goal:** apply the ARC-0022 refining (WB0–WB48) to the game, stage by stage, following `55/SPEC_ARC-0026.md`.
**Intent:** the game plays the Windborn as `21.04/Unbound/DESIGN.md` describes it, in both editions.

## Acceptance criteria

- [ ] Design gate (`_SUBCLASS_STANDARD` §15) and Narrative gate (`32.04`) recorded — carried from the design ticket
- [x] Sizes decided with the Owner (WB45–WB48); arithmetic in `22.05/Unbound.md`; values in `25` (`pending_build`)
- [x] Stage 0: patches, structure script and goal drafts in `55/_wip/Unbound/arc0026/`, dry runs clean; texts through the Narrative gate (`32.04`)
- [ ] Probes P1–P8 recorded, plan B applied where one failed
- [ ] Stages 2–5 applied, one `[fechado] ARC-0026` message each; Story compiled with 0 errors after each goal change
- [ ] `61.02/Unbound/` rows pass in game; guide `QA_ARC-0026.md` on the Arcana Test Guides page
- [ ] Stage 6: `25` holds no Windborn `pending_build` block; `05.02` synced; `check_propagation` OK

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`) — names checked against the vanilla corpus first (ARC-0021 collision check)
- [ ] DoD (`00.03`)

## Log

- 2026-10-17 — created from ARC-0022 at the Owner's request; spec skeleton written (stages, probes P1–P8). Sizes
  already approved in ARC-0022 (WB45–WB48), so stage 0 starts with the preparation. Nothing in the game changed.
- 2026-10-17 — Stage 0 started: Task 0.1 inventory (106 Stats entries: kept / changed / removed / new / untouched, Osiris, lists) in the spec; Task 0.2 texts drafted in `_wip/Unbound/arc0026/00_texts.md`; Narrative gate opened (`32.04/ARC-0026_Windborn.md`, pending). Nothing in the game changed.
- 2026-10-17 — Narrative gate passed (Owner, "pode seguir"). Task 0.3 done: `10_core.patch` (dry run clean) + `lua/CardDB.patch`; P2 switched to two created cards (Wind Riposte inherits the strike; `stats_add` needs `Rush_` for a Rush). Nothing in the game changed.
- 2026-10-17 — Task 0.4 done: `20_bag_awakening.patch` (dry run with 10 clean), `22_goal_fool.txt` (goal rewrite), CardDB stage-3 lines; probe P9 added (Force from a status functor). Nothing in the game changed.
- 2026-10-17 — Task 0.5 done: `30_ranks_cards.patch` (10+20+30 dry run clean), patch 10 corrected (Gale Burst variants), CardDB stage-4 lines; texts addendum §H for the Owner. Nothing in the game changed.
- 2026-10-17 — Owner approved the texts addendum §H. Task 0.6 done: `40_capstone_names.patch` (10–40 dry run clean). Nothing in the game changed.
- 2026-10-17 — Task 0.7 done: `50_structure.pl` (9 lists, 53 row edits per side, `--stage N`; tested on a copy, idempotent). **Stage 0 complete.** Next: stage 1, the probes P1–P9 (`[fechado] ARC-0026`). Nothing in the game changed.
- 2026-10-17 — Stage 1 prepared: `05_probes.patch` (15 DEBUG entries, dry run clean), `ARCANA_Probe_ARC0026.txt`, guide `GUIDE_ARC-0026.json` (9 probes) and playtest `QA-0004`. Waiting for `[fechado] ARC-0026`. Nothing in the game changed.
- 2026-10-17 — Stage 1 applied ([fechado] ARC-0026): `05_probes.patch` (15 DEBUG entries; the probe Rush got the `ARCANA_IS_SPELL` marker for `check_cards`), goal `ARCANA_Probe_ARC0026.txt` (CRLF). check_cards OK, selftest 1166 equal, max line 3442, no repeated field. Waiting: the Owner compiles the Story and plays `QA-0004` on the console edition.
- 2026-10-17 — Owner, QA-0004 P1: Probe: Rush asked for an equipped weapon and recharged on a Short Rest — it inherited the weapon-action fields of vanilla `Rush_SpringAttack` (`Cooldown OncePerShortRest`, `RechargeValues`, `WeaponTypes Melee`, `CanUseWeaponActions() and IsProficientWithEquippedWeapon()`). Overridden in `05_probes.patch` and in the real `Rush_Arcana_Created_ZephyrRush` (10_core.patch), as Leap of Faith already does; other probes checked (no inherited weapon or cooldown). Reapply of the probe patch needs `[fechado] ARC-0026`.
- 2026-10-17 — Probe patch reapplied ([fechado] ARC-0026): the probe Rush clears Cooldown, RechargeValues and WeaponType(s) on both sides (`clear_inherited_value` in .stats) and keeps the Owner's armour rule from his Toolkit edit (captured first, f76dba0). check_cards OK, selftest 1166 equal, no repeated field. QA-0004 can resume at P1.
- 2026-10-17 — Owner, QA-0004: P1 passed; Probe: Mark not selectable. Root cause: standalone spells without `SpellAnimation` / `CastTextEvent` (the four probes, and in the build Aeolus' Bag + winds, The Calm, the capstone on the grenade parent). Fixed from working templates (Command, Flow State, vanilla Fireball); new guard `check_castable.pl` in the apply chain (8 probes + 12 build spells OK); repeated-field scan clean. Reapply of the probe patch needs `[fechado] ARC-0026`.
- 2026-10-17 — Probe patch reapplied ([fechado] ARC-0026): Probe: Mark / StormPush (Command cast block), OpenPath / Count (Flow State cast block) and Vortex (`using "Projectile_Fireball"`) are now castable. check_castable 8 OK, check_cards OK, selftest 1166 equal, max line 3442, no repeated field. The goal did not change (no Story recompile). QA-0004 resumes at P2.
- 2026-10-17 — QA-0004 results (kanban sync 140f716): P1, P2, P4–P7, P9 pass; P8 fail, P3 waits on it. The Owner's game edits (P4 one area, P6 AoO override, P7 OnDamage, the probe Rush free) captured in 51 by sync_data; `05_probes.patch` is not reapplied any more. P8 root cause: Probe Count had `TickType EndTurn` and no `FreezeDuration` (the working pattern is RESONANT_OVERLOAD). Fix ready: `06_probe_count.patch` + the probe goal shows exactly X, no cap. WB13 cap by rank kept (Owner, asked). WB49 records the outcomes; 10_core / 30 / 40 / 50_structure carry them (check_castable 11 OK, no repeated field, dry runs clean). Apply needs `[fechado] ARC-0026`.
- 2026-10-17 — P8 fix applied ([fechado] ARC-0026): `06_probe_count.patch` (Probe Count frozen, texts) and the probe goal (X exactly, CRLF). First apply wrote `""FreezeDuration;ForceOverhead""`: `@set` kept the quotes, and every ARC-0026 patch quotes its `@set` values (other ARCs don't). Fixed once in `stats_add.pl` (`"x"` = x, `""` clears) and reapplied; no other doubled value in the game. check_cards OK, max line 3442, no repeated field. Selftest 1165/1: Probe: Rush UseCosts is "" in the .txt (the Owner's edit, free in game) but `BonusActionPoint:1` in the .stats, left for the Owner. Next: the Owner recompiles the Story and retests P8, then P3.
- 2026-10-17 — **Stage 1 complete:** every probe passes (P8 and P3 after the fix; results on the test page). Synced the Owner's new probes `Shout_` / `Target_Arcana_Util_PROBE_WhereTheWindsMeet` into 51; the stage 2 cleanup removes them. WB50: Where the Winds Meet becomes `Target_Arcana_Created_WhereTheWindsMeet`, a ground Target on vanilla `Target_Shatter` (renamed in 40, 50_structure, CardDB). check_castable 11 OK, no repeated field, dry run of 10–40 clean. Next: stage 2 (`[fechado] ARC-0026`).
- 2026-10-17 — **Stage 2 applied** ([fechado] ARC-0026). Cleanup: `07_probe_cleanup.patch` removed 14 probe entries, and the probe goal became a cleanup goal (RemoveSpell/RemovePassive on load; the stage 1 goal is kept as `_wip/.../ARCANA_Probe_ARC0026_stage1.txt`). Then `10_core.patch`: Windswept, the Open Path via `@set Interrupt_AttackOfOpportunity EnableCondition`, the Open Road, Zephyr Rush + `ARCANA_ZEPHYR_RUSH`, Windswept Touch on damage, Gale Burst/Wind Blast mark on a failed save. CardDB.lua got 2 stage 2 lines (luac OK). `50_structure.pl --apply --stage 2` wrote 2 rows per side, and a second dry run is empty. check_cards OK, selftest 1157/0, max line 3442, no repeated field, no PROBE left. The Owner needs to compile the Story. Test guide: session S2 (8 tests).
- 2026-10-17 — **Build switched to the Owner typing in the Toolkit** (the Kingmaker way; Owner: "não estou gostando dessa forma"). Claude applies nothing more to the game for this build except `CardDB.lua` and the generated families after each level, with `[fechado]`. `SPEC_ARC-0026.md` was rewritten with one stage per level, and the patch build is kept as history. There are twelve typing guides `TOOLKIT_ARC-0026_L01.md` … `_L12.md`, generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the patches, the game before ARC-0026 (`09f30e0`) and vanilla. The Toolkit field order comes from `StatObjectDefinitions.sod` (the Interrupt order was added to the template). Changes found while writing them: Zephyr Rush's inherited Off Balance tooltip is cleared; `ARCANA_BAG_OPEN` now shows the turns left (frozen status, set by the goal); the texts of the three Awakening progress statuses are corrected; the Unbound preset is moved to WB21. The test guide `GUIDE_ARC-0026.json` is now level by level (13 sessions, 46 tests; the probes are recorded in QA-0004). Next: the Owner types level 1.
- 2026-10-17 — The guides follow the rulebook (ARC-0027, 00.01 Operating_Rules): `implementation: owner` (OR-11). Entries that leave the Windborn are **retired, not deleted** (OR-10: a published entry is never deleted); each guide lists them under RETIRE. Claude writes in the game only to fix a divergence found when checking a level, or for the PC deck and the generated families the guides list.
- 2026-10-17 — ARC-0027 (Producer, phase D): stage 5 — the Owner types levels 1–12 from TOOLKIT_ARC-0026_L01–L12; sprint S01. Carries the Design and Narrative gates from ARC-0022.
- 2026-10-17 — ARC-0027 (test guides sorted): the Owner's stage-2 results were orphaned when the guide became level by level; copied to the new ids. **L1.2 FAIL** (Owner): Zephyr Rush can target the ground and not a Windswept-free enemy as intended, and it carries the same name as Zephyr Strike → a bug to fix in stage 5 (OR-11). **L1.5 note** (Owner): the Open Road marks on any damage, so Gale Burst marks even when the save succeeds → design feedback, needs a decision (OR-1). L1.4 pass. QA-0004 (probes, 9/9) done by the Owner on the board; the level tests are QA-0005 (46 tests).
- 2026-10-18 — **TOOLKIT_ARC-0026 rewritten from zero, feature by feature** (Owner: the file was "extremamente bagunçado" and broke the rules; the Owner deletes the old Unbound and types it again). `63_toolkit_full.pl` writes TOOLKIT_ARC-0026.md (123 steps: 116 Stats entries in 16 features, then the lists, progression and class objects, then the two goals) and SPEC_ARC-0026.md in the same order (OR-5). It reads the game before ARC-0026 (09f30e0 .stats), the patches, the Owner's typing (sync of 2026-10-18) and vanilla. The Toolkit field order and labels come from StatObjectDefinitions.sod. Animations are copied from a named vanilla spell; effects are picked by their MultiEffectInfo name. Found and fixed: `WIND_*` pointed to `ARCANA_TAILWIND_*` (no longer exists); the bag spells checked `BAG_READY` while the status was named `BAG_OPEN_READY`; tail/headwind params were swapped; the shared Zephyr Strike handles had been renamed to "Zephyr Rush"; Leap of Faith and the capstone carried vanilla tooltips (Off Balance, upcast); Leap of Faith's animation comes from Force Tunnel. WB51 records the answers of 2026-10-18.
- 2026-10-23 — **The Owner's Toolkit build propagated** (Producer, 00.08): the Owner changed the build while playing levels 1–8 (commit 60afc0e). Recorded as WB52–WB61 (Rush 9 m and movement, Storm's second Rush, Zephyr: Tempest replaces Storm Fists, Zephyr: Ally Tempest replaces Leap of Faith, Unleashed Winds replaces Where the Winds Meet, the Windswept split, out of combat, Weightless +4/+7/+10/+13 m, winds don't refresh, the West Wind) — Leap of Faith out and the name Unleashed Winds confirmed by the Owner. Brought up to date: DESIGN, 21.03, 21.08, 23.02 (regenerated, 17 sheets), 25 (3 new, 3 updated, 3 archived to 93), 22.05 (V6 added), 26.01, 31.02, 32.01 (regenerated), 33.03, 42.04 (the Owner's icons), 05.02 (rewritten from the game; verify_context 0 missing), QA_ARC-0026 (tested ids kept; L1.12–13, L4.4, L5.3, L6.3, L7.4, L8.3–4, L9.3, A.3 added; L10–L11 rewritten). **WB62 — fixes owed to the game**, exact edits in SPEC_ARC-0026 "Fixes owed" F1–F22 (ZephyrStrike's name handle, Unleashed Winds' TargetConditions missing an `and`, Gale Deflection Level, text slips, the PC deck) plus Q1–Q4 to confirm (Twinkle Toes / Weightless, Agility / Flowing Strikes, Extra Attack / Flowing Assault, Gale Deflection per turn or per cast). check_cards: the The Calm finding was a false positive (no slot, no variant) — the check now skips cards without a slot cost.
