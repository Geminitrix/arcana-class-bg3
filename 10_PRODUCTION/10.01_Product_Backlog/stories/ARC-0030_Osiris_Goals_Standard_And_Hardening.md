---
id: ARC-0030
title: "Osiris goals: one standard for comments and regions, and preventive fixes"
type: chore
epic: EPIC_Rework_Subclasses
subclass: none
status: in_progress
owner: Mod Engineer
implementation: owner
priority: should
value: 4
effort: 4
inputs: [game Story/RawFiles/Goals (21 goals), 57.05/OSIRIS.md, 56.01_Osiris_Goals, 82_Automation/stats/gen_awakening_progress.pl, 82_Automation/stats/gen_emotion_alchemy.pl, 82_Automation/stats/gen_upcast_variants.pl]
outputs: [55/_wip/Osiris/ARC-0030/ (the 21 goals, final text), game Story (21 goals), 57.05/OSIRIS.md, 82_Automation/check_osiris.pl, the three generators above, 55/_wip/Osiris/ARC-0030/RISKS.md]
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

- **All 21 goals now**, including the ones under test (ARC-0008 Kingmaker, ARC-0017 Resonant, ARC-0026/ARC-0029 Fool and
  Temperance): the tests in progress run on the new code. Pulled forward past the WIP limit at the Owner's request (OR-3).
- **Fixes split by risk:** a fix that cannot change play (cleanup paths, timer cancels, casts, type pins, dead code) is
  applied; a fix that changes play goes to `RISKS.md` and waits for the Owner's OK, item by item.
- **Delivery:** the final texts are written in `55/_wip/Osiris/ARC-0030/`; the Owner reviews them and sends
  `[fechado] ARC-0030`; Claude then backs up the game goals (`94_Safety_Backups/ARC-0030_<date>/`), writes them and runs
  `sync_data`; the Owner compiles in the Story Editor and Claude reads `Story/log.txt` (OR-11, OR-15).
- **The standard is written and checked:** `57.05/OSIRIS.md` gets the standard (it still describes the old `IND_`
  prefix) and `check_osiris.pl` checks it.
- **Generated goals:** `ARCANA_Aspect_Common`, `ARCANA_Aspect_Empress`, `ARCANA_Aspect_Fool`, `ARCANA_CardFamilies` and
  `ARCANA_Spell_Withdraw` are written in part by the three generators; their templates change with the goals, or the
  next run undoes the work.

## Acceptance criteria

- [ ] `57.05/OSIRIS.md` holds the standard: file header block, `//REGION` / `//END_REGION` layout and order, comment
      rules (English, the why and not the history, no task numbers), DB/PROC/QRY/timer naming (OR-59), type pins
- [ ] `check_osiris.pl` reports, per goal: missing skeleton, unbalanced regions, a DB used without a type pin, a timer
      or DB without the `ARCANA_` prefix, a non-English comment, a task or ticket number in a comment; it prints OK on all 21
- [ ] `RISKS.md` lists every foreseen failure with file, rule, scenario, fix and class (applied / needs the Owner's OK)
- [ ] The rules of every goal are unchanged apart from the applied fixes (a normalised diff of the rule lines, old vs new, shows only them)
- [ ] The generators emit the new layout; running each one on the new goals changes nothing
- [ ] The Story compiles with `0 error(s), 0 warning(s)` in `log.txt`
- [ ] Play: the smoke test of each subclass that has a goal still passes (one Aspect awakening per subclass, one card family, Withdraw)

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-10-20 — created at the Owner's request (`/novo-ticket`). Survey: 21 goals, ~5,500 lines; 20 of them use regions,
  `ARCANA_CardFamilies` none; Portuguese comments in 8 goals; task numbers in 8; every timer already `ARCANA_`;
  last compile 0 errors. Scope answered by the Owner (above).
