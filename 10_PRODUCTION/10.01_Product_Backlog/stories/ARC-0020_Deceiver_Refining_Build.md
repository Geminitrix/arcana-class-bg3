---
id: ARC-0020
title: "Deceiver refining build: the game plays DV18–DV31"
type: rework
epic: EPIC_Rework_Subclasses
subclass: deceiver
status: in_qa
owner: Mod Engineer
implementation: owner
priority: must
value: 5
effort: 4
inputs: [21.04/Deceiver/DESIGN.md, 21.04/Deceiver/DECISIONS.md, 25 (*_Deceiver_*, pending_build), 61.02/Deceiver/QA_ARC-0020.md]
outputs: [55/SPEC_ARC-0020.md, 55/_wip/Deceiver/arc0020/, game files (Stats, LSX, Osiris, loca), 05.02/Deceiver.md]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0020 · Deceiver refining build

**Goal:** apply the ARC-0019 refining (DV18–DV31) to the game, stage by stage, following `55/SPEC_ARC-0020.md`.
**Intent:** the game plays the Deceiver as `21.04/Deceiver/DESIGN.md` describes it, in both editions.

## Acceptance criteria

- [x] Design gate (`_SUBCLASS_STANDARD` §15) and Narrative gate (`32.04`) recorded — carried from the design ticket (Owner approved DESIGN DV1–DV35, 2026-11-25; texts in 32.04)
- [ ] Stage 0: the open sizes of `25` (`‹…›` in `pending_build`) decided with the Owner; patches and scripts ready, dry runs clean
- [ ] Stages 1–4 applied, one `[fechado] ARC-0020` message each; Story compiled with 0 errors after each goal change
- [ ] Probes B1–B4 recorded, plan B applied where one failed
- [ ] `61.02/Deceiver/QA_ARC-0020.md` rows pass in game
- [ ] Stage 5: `25` holds no Deceiver `pending_build` block; `05.02` synced; `check_propagation` OK

## Gates

- [x] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15) — Owner, 2026-11-25 (DV1–DV35)
- [x] Narrative gate (`32.04`) — `32.04/ARC-0020_Deceiver.md` (stages 1–3 texts)
- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created from ARC-0019 at the Owner's go-ahead ("pode dar sequência"); spec written. Nothing in the
  game changed.
- 2026-10-16 — Stage 0 started: Task 0.4 script `55/_wip/Deceiver/arc0020/20_structure.pl` written, dry run matches DESIGN §9.1; Task 0.1 sizes proposed to the Owner (Splinter Tier III 4 m, Grand Deception 1 Doubt per Double within 3 m, Splinter on command 18 m and 1 Thread, Mirrored Self plan B 9 m) — awaiting approval.
- 2026-10-16 — Task 0.1 sizes approved by the Owner and written in `25` (arithmetic in `22.05/Deceiver.md`). Task 0.2–0.3 draft `arc0020/10_names.patch` (43 strings + 2 new, dry run clean) — awaiting the Narrative gate.
- 2026-10-16 — Narrative gate passed for stage 1 texts (Owner): `32.04/ARC-0020_Deceiver.md`. Stage 0 next: Task 0.5.
- 2026-10-16 — Task 0.5 prepared: `arc0020/30_splinter_command.patch`, `32_goal_splinter_command.pl`, `lua/` (CardDB + test, 138 pass). Next: Tasks 0.6–0.7 (Tier III burst, Grand Deception).
- 2026-10-16 — Tasks 0.6–0.7 prepared: `arc0020/40_tier3.patch` (stats + 4 texts, dry run clean), `42_goal_tier3_grand.pl` (+98 lines on a copy, idempotent). New probes B5 (Grand Deception snapshot timing), B6 (Splinter Tier III condition). Stage 3 texts pending in `32.04`. Stage 0 left: nothing but Task 0.8 (after B4) — stage 1 can run with `[fechado] ARC-0020`.
- 2026-10-16 — Stage 1 applied in the game (`[fechado] ARC-0020`): names and the one-rule text (`10_names.patch`). Pre-apply snapshot `3c87edf`; check_cards OK, selftest 1151/1151, no long lines; `sync_data`, `gen_catalog`, `05.02` updated. Stage 3 texts approved by the Owner. Next: stage 2 (`[fechado] ARC-0020`).
- 2026-10-17 — ARC-0027 (Producer, phase D): stage 4 — stage 1 (names) applied before the rulebook; the rest is typed by the Owner (OR-11). Carries the Design and Narrative gates from ARC-0019.
- 2026-11-25 — Back to the design (stage 3, OR-1): the Owner asked to spread the Veilwalker over levels 1–12 like the Windborn and the Kingmaker and to playtest it 1–12. Three level-4/8 options given (A ranks at 4 and 8 · B only 4 · C both empty); the Owner chose A → **DV35** (level map v2: no empty level; Seed of Doubt 2, Splinter on Command 4, Binding Falsehood 5, Veilstep 6, cap 4 at 8, Mirrored Spell 10). Updated: DESIGN.md §4.2/§5/§6/§9, 21.03, 23.02 (9 sheets + index), 25 (`level_next`/`cap_next` in 7 YAML), 22.05, 26.01, QA_ARC-0020 (note); 21.08, 31.02, 32.01, 33.03, 42.04, 05.02 checked, no change. `check_propagation.pl Deceiver` OK (the checker had skipped every dossier since the map got CRLF line ends — fixed). Status `in_review`: the Owner approves DESIGN.md, then stage 4 (SPEC rewritten, TOOLKIT_ARC-0020, QA_ARC-0020 level by level → `ready` → the Veilwalker tab on the Test Guides page). Nothing in the game changed.
- 2026-11-25 — The Owner approved DESIGN.md with DV35 (design gate, stage 3) and chose a **delta** build kit ("só o que muda") over retyping from zero. Stage 4 written: `55/SPEC_ARC-0020.md` rewritten for the Owner to type (the staged plan of 2026-10-16 archived in `93/2026-11-25_ARC-0020_SPEC_staged_plan/`), `55/TOOLKIT_ARC-0020.md` (23 steps, feature by feature: Splinter on Command, Tier III burst, Grand Deception, The Veil's text, the map, the Doubles goal replaced whole — `check_osiris` 0/0), `QA_ARC-0020` level by level (74 tests, L1–L12 + A.1–A.3) → `ready`; the Veilwalker tab is on Arcana Test Guides. Deferred: Mirrored Self from a Double (DV25, probe B4) — stays as today at level 10. Status `spec_ready`: the Owner types the TOOLKIT, then `[fechado] ARC-0020` for the check and step 23.
- 2026-11-25 — `[fechado] ARC-0020` (Owner: typed the Stats; Osiris is Claude's, one goal per feature, *HighPriestess* — DV36). Stage 5 verification: `sync_data`; Stats steps 01–08 compared with TOOLKIT_ARC-0020 — 3 divergences fixed (`_wip/Deceiver/arc0020/verify/10_stats_fix.patch`, backup `90/94/ARC-0020_2026-11-25/`): The Veil's level-8 text had gone into its Description (restored; ExtraDescription now says level 8), Grand Deception's TooltipStatusApply `DOUBT_2` → `DOUBT_1`, Splinter on Command's leftover `DamageType` cleared; the burst kept its own "Splinter" handle (same text). The Owner also typed the lists and progression (a new list for level 6; the level-7 list deleted) — the level-7 row still pointed to the deleted list: its `Selectors` cleared (lsx + tbl). `dump_progression` matches DESIGN §9.1. Osiris: 6 goals retired (archived in `93/2026-11-25_ARC-0020_Deceiver_goals_split/`), 11 written (`_wip/Deceiver/arc0020/goals/`, rule-by-rule diff: every old rule kept, only this build's rules new), `check_osiris` clean for them. Step 23: `gen_upcast_variants --apply` (goal name updated in the generator; 5 new variants from the earlier grant levels), `sort_stats`, `check_cards` OK (a design exception added for `Projectile_Arcana_SplinterBurst`, no Arcana marker on purpose), `stats_add --selftest` 1188/1188, `CardDB.lua` + `CardDBTest.lua` row (Lua tests not run: no Lua interpreter on this machine). `05.02`/`05.00` updated, catalogs regenerated. Status `in_qa`: the Owner compiles the Story and plays QA_ARC-0020.
- 2026-11-25 — Story compiled clean (16:58, after ARC-0035's three rounds): the Deceiver goals of DV36 are live; QA_ARC-0020 can be played.
- 2026-11-25 — Found by ARC-0036's dry run, both fixed in its apply: (1) Osiris still calls `Shout_Deceiver_Double_Shatter`, but the Splinter is now `Shout_Arcana_Double_Splinter` (Splinter on Command, the Splinter cleanup, The Veil Lifts and Tier III miss it); (2) the Double's slot rules lived only in `Rulebook.lsx`, so the Owner's Toolkit save (18:41) kept `_Slot3` alone with Splinter only — no Reflected Seed/Falsehood (L5) or Unveil (L9) until ARC-0036 applies. Hold QA_ARC-0020 L4–L12 Double tests until then.
- 2026-11-25 — ARC-0036 applied: the Shatter call, the lost Double rules and the Tier III burst id (Osiris exploded `Projectile_Arcana_SplinterBurst`; the Stats have the Owner's `Projectile_Arcana_Splinter_Explosion`) are fixed; ids now follow DV37. Still for this ticket's verification: `check_cards` flags the Splinter's `ApplyStatus(SELF,UNSUMMON_ACTIVE,100,-1)` without GROUND, and the Splinter shout explodes the 4 m burst at every tier (design: 3 m, wider from Tier III). QA_ARC-0020 L4–L12 Double tests can be played after the Story compile.
- 2026-11-25 — **QA_ARC-0020 L1.4 FAIL (bug, OR-1: the build differs from DV7):** three Doubles gave +4 AC; after one died, +2. Likely cause (`ARCANA_Deceiver_TheVeil`): a Double past the cap runs, in one frame, Register → count 4 → `ApplyStatus(VEIL_LAYER_4)`, then Enforce → Retire → count 3 → `ApplyStatus(VEIL_LAYER_3)`; the second apply does not replace the first, so +4 stays until the next count change. Fix to prepare (`[fechado] ARC-0020`): refresh the layer once, after Enforce (not inside SetCount), so a moment above the cap never applies a layer. To confirm with the Owner: was a fourth Double summoned (the oldest vanished)?
