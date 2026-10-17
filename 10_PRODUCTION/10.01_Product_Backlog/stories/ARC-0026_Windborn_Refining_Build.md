---
id: ARC-0026
title: "Windborn refining build: the game plays WB0–WB48"
type: rework
epic: EPIC_Rework_Subclasses
subclass: unbound
status: ready
owner: Mod Engineer
implementation: claude
priority: must
value: 5
effort: 5
inputs: [21.04/Unbound/DESIGN.md, 21.04/Unbound/DECISIONS.md, 25 (*_Unbound_*, pending_build), 22.05/Unbound.md, 32.01/Unbound.md, 61.02/Unbound/TC_ARC-0022.md]
outputs: [55/SPEC_ARC-0026.md, 55/_wip/Unbound/arc0026/, game files (Stats, LSX, Osiris, loca), 05.02/Unbound.md, 61.02/Unbound/GUIDE_ARC-0026.json]
blocked_by: []
sprint:
created: 2026-10-17
---

# ARC-0026 · Windborn refining build

**Goal:** apply the ARC-0022 refining (WB0–WB48) to the game, stage by stage, following `55/SPEC_ARC-0026.md`.
**Intent:** the game plays the Windborn as `21.04/Unbound/DESIGN.md` describes it, in both editions.

## Acceptance criteria

- [x] Sizes decided with the Owner (WB45–WB48); arithmetic in `22.05/Unbound.md`; values in `25` (`pending_build`)
- [x] Stage 0: patches, structure script and goal drafts in `55/_wip/Unbound/arc0026/`, dry runs clean; texts through the Narrative gate (`32.04`)
- [ ] Probes P1–P8 recorded, plan B applied where one failed
- [ ] Stages 2–5 applied, one `[fechado] ARC-0026` message each; Story compiled with 0 errors after each goal change
- [ ] `61.02/Unbound/` rows pass in game; guide `GUIDE_ARC-0026.json` on the Arcana Test Guides page
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
