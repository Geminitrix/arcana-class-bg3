---
id: ARC-0030
title: "Osiris goals: one standard for comments and regions, and preventive fixes"
type: chore
epic: EPIC_Rework_Subclasses
subclass: none
status: in_qa
owner: Mod Engineer
implementation: owner
priority: should
value: 4
effort: 4
inputs: [game Story/RawFiles/Goals (21 goals), 57.05/OSIRIS.md, 82_Automation/stats/gen_awakening_progress.pl, 82_Automation/stats/gen_emotion_alchemy.pl, 82_Automation/stats/gen_upcast_variants.pl]
outputs: [55/_wip/Osiris/ARC-0030/goals/ (20 goals, final text), 55/_wip/Osiris/ARC-0030/RISKS.md, 55/_wip/Osiris/ARC-0030/README.md, 57.05/OSIRIS.md §13, 82_Automation/check_osiris.pl, the three generators above, 61.02/Class/QA_ARC-0030.md, 93/2026-10-20_ARC-0030_mirrorwithdraw_goal/, game Story (at the apply)]
blocked_by: []
sprint: S01
created: 2026-10-20
---

# ARC-0030 · Osiris goals: one standard for comments and regions, and preventive fixes

**Goal:** every Osiris goal of the mod follows one written, checkable standard for its header, regions, comments and the
order of its DBs, PROCs, QRYs and rules, and every failure we can foresee is fixed or listed.
**Intent:** no change in play from the reorganisation; the preventive fixes remove leaks and silent failures (DB rows
never deleted, timers relaunched without a cancel, missing casts, rules that can fire twice) before a player meets them.

## Scope (Owner, 2026-10-20)

- **All the goals now**, including the ones under test (ARC-0008 Kingmaker, ARC-0017 Resonant, ARC-0026/ARC-0029 Fool and
  Temperance): the tests in progress run on the new code. Pulled forward past the WIP limit at the Owner's request (OR-3).
- **Fixes split by risk:** a fix that cannot change play (cleanup paths, timer cancels, casts, type pins, dead code) is
  applied; a fix that changes play waits for the Owner's OK, item by item (`RISKS.md` A / B / C).
- **Delivery:** the final texts are in `55/_wip/Osiris/ARC-0030/goals/`; the Owner reviews them and sends
  `[fechado] ARC-0030`; Claude then follows `55/_wip/Osiris/ARC-0030/README.md` (backup, copy, `sync_data`, checks);
  the Owner compiles in the Story Editor and Claude reads `Story/log.txt` (OR-11, OR-15).
- **The standard is written and checked:** `57.05/OSIRIS.md` §13, checked by `check_osiris.pl`.
- **Generated goals:** the generators emit the standard (`57.05` §13.7).

## Decisions (Owner, 2026-10-20)

- **B1/B2** — the Kingmaker's Wheel and the Resonant's grudges clear only when their owner's own fight ends, not when any
  fight on the map ends (`CombatGetGuidFor`).
- **B3** — fix now: a character still on the Awakening roster when its fight ends is reset then.
- **B4** — Hemorrhage's DB and PROCs take the `ARCANA_` prefix (a save with a Hemorrhage active at the update loses that burst).
- **B5** — `ARCANA_Spell_MirrorWithdraw` (dead: its spells and status no longer exist) is retired to `93`.

## Acceptance criteria

- [x] `57.05/OSIRIS.md` holds the standard (§13): file, layout, header, regions, comments (English, the why and not the
      history), names (OR-59), timers, state, generated goals; the stale `IND_` text is gone
- [x] `check_osiris.pl` reports, per goal: skeleton, line endings, INITSECTION content, header, unbalanced or nested
      regions, rules outside a region, names without `ARCANA_`, timers launched without their cancel or cancelled by the
      wrong family, non-English comments, history in comments, DBs missing from the header (E); shared DBs with no type
      pin (W). It prints OK on the 20 goals of `goals/` (0 errors, 0 warnings)
- [x] `RISKS.md` lists every foreseen failure with goal, scenario, fix and class (A applied, B approved, C open)
- [x] `check_osiris.pl --compare` (old game goals vs `goals/`): 10 goals "same code"; the other 10 differ only by the
      lines of RISKS A and B; the Hemorrhage diff is the rename alone
- [x] The generators emit the new layout: `ARC17_STAGE=4 gen_emotion_alchemy.pl` writes the three Resonant goals of
      `goals/` byte for byte (its Stats patches and level maps unchanged; only the comment line of `43_common_rows.txt`
      lost its ticket id; tests 340/340); `gen_awakening_progress.pl`'s countdown
      block is in the new Common verbatim; `ARCANA_CardFamilies` was built from `gen_upcast_variants.pl`'s template
- [x] Apply: `check_osiris.pl` on `51` prints OK and `--compare 51 goals/` prints "same code" for all 20
- [ ] The Story compiles with `0 error(s), 0 warning(s)` in `log.txt`
- [ ] Play: `61.02/Class/QA_ARC-0030.md` (11 tests)

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-10-20 — created at the Owner's request (`/novo-ticket`). Survey: 21 goals, ~5,500 lines; 20 of them use regions,
  `ARCANA_CardFamilies` none; Portuguese comments in 8 goals; task numbers in 8; every timer already `ARCANA_`;
  last compile 0 errors. Scope answered by the Owner (above).
- 2026-10-20 — audit done: 166 errors of the new standard in the 21 goals; 10 A fixes, 5 B items (approved by the Owner,
  above), 8 C items left open (`RISKS.md`). The 20 goals written in `55/_wip/Osiris/ARC-0030/goals/` (check OK, compare
  as above). Found on the way: `gen_emotion_alchemy.t` had failed since 92d4635 (fixed); `gen_awakening_progress.t` fails
  1/46 on the Fool's old goals (C8, left); the CardFamilies table in the game is older than the Stats (C3). The game was
  open the whole time: nothing written there (OR-11). Next: the Owner reviews `goals/` and sends `[fechado] ARC-0030`.
  `gen_upcast_variants.pl --apply` was not run (it writes the game): its output is checked at the apply.
- 2026-10-20 — Owner: `[fechado] ARC-0030`. The game goals were unchanged since the audit; backup of the 21 in
  `94_Safety_Backups/ARC-0030_2026-10-20/`; the 20 of `goals/` copied into the game (byte for byte, CRLF) and
  `ARCANA_Spell_MirrorWithdraw.txt` taken out (archived in `93`). `sync_data`: only those 21 goal files changed;
  `check_osiris.pl` on `51` OK; `--compare 51 goals/` same code in all 20. `gen_upcast_variants.pl --apply` still not
  run: it also rewrites every upcast variant in the Stats, a build step of its own (RISKS C3); its template was checked
  by building `ARCANA_CardFamilies` with it. Next: the Owner compiles in the Story Editor (remove
  `ARCANA_Spell_MirrorWithdraw` there if it is still listed), Claude reads `log.txt`, then QA_ARC-0030.
