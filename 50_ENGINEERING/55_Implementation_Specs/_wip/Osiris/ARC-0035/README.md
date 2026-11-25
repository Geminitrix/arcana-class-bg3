# ARC-0035 · the Osiris standard back on the Fool, Kingmaker and Windborn goals

`before/` = the game's goals on 2026-11-25 (51 after `sync_data`, identical to the game). `goals/` = built by
`perl build.pl` (idempotent, always from `before/`). Apply = copy `goals/*.txt` into the game's
`Mods/AspectClass_…/Story/RawFiles/Goals/` (a `[fechado] ARC-0035` message, backup first), then the Owner compiles.

## What changes

| Part | Goals | Change | Code? |
|---|---|---|---|
| 1 · the 6 errors | `ARCANA_Aspect_Fool`, `ARCANA_Kingmaker_CrownTheKing`, `ARCANA_Unbound_AeolusBag` | CRLF on every line; the Fool's header restored (text of `b071443`, with the Owner's `PROC_ARCANA_Fool_Aspect_Init`); a blank line after the Aeolus' Bag INITSECTION | none (`check_osiris --compare`: same code) |
| 2 · the 23 warnings | `ARCANA_Kingmaker_Wheel`, `_Crossing`, `_CrownTheKing`, `_KingsCourt`, `_Usurp` | 24 shared DBs pinned once in their owner goal (the 23 of the warnings + `Next`) | INITSECTION only |
| 2 · the casts the pins need | `ARCANA_Kingmaker_Wheel`, `_Crossing`, `_Peripeteia`, `_Usurp`, `_AtroposCut`, `_TurnTheSpoke`, `_KingsCourt`, `ARCANA_Aspect_WheelOfFortune` | 27 event patterns bind the Kingmaker as `(CHARACTER)_Owner` instead of an uncast GUIDSTRING (`TurnStarted`, `StatusApplied`'s object or causee) | the binding type only |

Why the casts: a pinned `CHARACTER` column met by a `GUIDSTRING` variable is a type mismatch, and the Story Editor skips the
rule (57.05 §5). The Kingmaker always takes turns and receives these statuses as a character, so the cast filters nothing.

## Checks (2026-11-25)

- `check_osiris.pl --dir` on the 34 goals with these in place: **0 error(s), 0 warning(s)**.
- `check_osiris.pl --compare before goals`: Fool and Aeolus' Bag **same code**; the others differ only by the pins and the
  casts above (no rule added, removed or reordered).
- Not yet: the Owner's compile (`log.txt` must end with `0 error(s), 0 warning(s)` and contain no "type mismatch"), and the
  Kingmaker smoke test `61.02/Class/QA_ARC-0035.md`.

## Round 2 (2026-11-25, after the Owner's compile at 16:47)

The first apply failed the compile: 41 errors, 32 warnings, all `'DB_ARCANA_Kingmaker_X': conflict with function
definition: parameter 1 type mismatch: got (GUIDSTRING), expected (CHARACTER) … Rule skipped`, on 12 DBs (OnWheel, Moving,
Counter, Stopped, NewFallen, NewRuler, NewReigning, CrossSlot, CrossPair, Court, Condemned, UsurpFirst; LawPending's
"type of parameter 2 unknown" followed from a skipped rule). Root cause: 52 Kingmaker PROC heads declare
`(GUIDSTRING)_Owner`; the pins typed the Owner column CHARACTER. Only events had been checked. Fix: those 12 pins take a
`(GUIDSTRING)` Owner (`build.pl`); the 8 DBs that compiled with a CHARACTER Owner keep it; every other column is what the
PROC heads declare (`(CHARACTER)_Creature`, STRING positions, INTEGER sides and orders). The failed compile did not write
`story.div.osi` (still 00:04): the game runs the story of the morning until the next clean compile.
