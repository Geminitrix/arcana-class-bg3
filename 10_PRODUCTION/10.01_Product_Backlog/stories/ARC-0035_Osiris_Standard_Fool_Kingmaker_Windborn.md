---
id: ARC-0035
title: "Osiris standard: the 6 errors and 23 warnings of check_osiris in the Fool, Kingmaker and Windborn goals"
type: chore
epic: EPIC_Rework_Subclasses
subclass: none
status: in_qa
owner: Mod Engineer
implementation: claude
priority: should
value: 2
effort: 2
inputs: [game Story/RawFiles/Goals (ARCANA_Aspect_Fool, ARCANA_Kingmaker_*, ARCANA_Aspect_WheelOfFortune, ARCANA_Unbound_AeolusBag), 57.05/OSIRIS.md §13, 82_Automation/check_osiris.pl]
outputs: [game Story/RawFiles/Goals (the same goals, at the apply), 55/_wip/Osiris/ARC-0035/, 61.02/Class/QA_ARC-0035.md]
blocked_by: []
sprint:
created: 2026-11-25
---

# ARC-0035 · Osiris standard: Fool, Kingmaker and Windborn goals

**Goal:** `check_osiris.pl` prints 0 errors and 0 warnings for every goal of the mod.
**Intent:** nothing changes in play — the Story already compiles with 0 errors (log.txt of 2026-11-25); the goals go back to
the house standard (57.05 §13) so the next reader and the checker trust them.

## Findings (check_osiris, 2026-11-25, 34 goals)

The game compiles clean; these are departures from the standard, all from edits made after ARC-0030 applied it.

| # | Goal | Kind | Finding | Cause | Fix |
|---|---|---|---|---|---|
| 1 | `ARCANA_Aspect_Fool` | E | 1 line ends in LF (line 125, the blank line before `ENDEXITSECTION`) | saved by the Story Editor (the Owner's edit synced in `d28ee51`) | CRLF |
| 2 | `ARCANA_Aspect_Fool` | E | KBSECTION has no header block | the same edit deleted the 15-line header (and renamed `PROC_ARCANA_Fool_Init` → `PROC_ARCANA_Fool_Aspect_Init`) | restore the header of `78766b9`, with the new PROC name; keep the Owner's rename |
| 3–4 | `ARCANA_Aspect_Fool` | E | `DB_ARCANA_CalmGust`, `DB_ARCANA_Gusted` not named in the header | the header is gone (2) | fixed by 2 |
| 5 | `ARCANA_Kingmaker_CrownTheKing` | E | 2 lines end in LF (4, 205: the blank lines after `INITSECTION` and before `ENDEXITSECTION`) | Story Editor save (`2e9c816`, the Owner's cast fix) | CRLF |
| 6 | `ARCANA_Unbound_AeolusBag` | E | 2 lines end in LF (6: `PROC_ARCANA_Unbound_AeolusBag_Init();`, 340) | the Windborn split (`bb3934b`) | CRLF; a blank line between the INITSECTION and `KBSECTION`, as in every goal |
| 7–29 | Kingmaker goals | W | 23 DBs shared between Kingmaker goals have no type pin in any INITSECTION (§13.6) | the Kingmaker goals were written without pins | pin each DB once, in the goal that owns it (below) |

**Pins (finding 7–29).** Types read from each DB's header line and its writes. Owner goal = the goal whose header says it
writes the DB.

| Goal | DBs to pin (types) |
|---|---|
| `ARCANA_Kingmaker_Wheel` | `OnWheel(CHARACTER, CHARACTER, STRING, INTEGER, INTEGER)` · `Counter(CHARACTER, INTEGER)` · `Moving(CHARACTER, CHARACTER, STRING, INTEGER, INTEGER)` · `Pending(CHARACTER, CHARACTER)` · `Enemies(CHARACTER, INTEGER)` · `Held(CHARACTER, CHARACTER)` · `ReignTime(CHARACTER, CHARACTER, INTEGER)` · `Stopped(CHARACTER, INTEGER)` · `Next(STRING, STRING)` · `Opposite(STRING, STRING)` · `PositionStatus(STRING, STRING)` · `CrossStatus(INTEGER, STRING)` · `NewFallen(CHARACTER, CHARACTER)` · `NewRuler(CHARACTER, CHARACTER)` · `NewReigning(CHARACTER, CHARACTER)` |
| `ARCANA_Kingmaker_Crossing` | `CrossedBy(CHARACTER, CHARACTER, CHARACTER)` · `CrossSlot(CHARACTER, CHARACTER, INTEGER)` · `CrossPair(CHARACTER, CHARACTER, CHARACTER)` · `HubrisSpent(CHARACTER, CHARACTER)` |
| `ARCANA_Kingmaker_CrownTheKing` | `King(CHARACTER, CHARACTER)` · `Best(CHARACTER, CHARACTER, INTEGER)` |
| `ARCANA_Kingmaker_KingsCourt` | `Court(CHARACTER, CHARACTER, STRING)` · `Condemned(CHARACTER, CHARACTER)` |
| `ARCANA_Kingmaker_Usurp` | `UsurpFirst(CHARACTER, CHARACTER, STRING, INTEGER, INTEGER)` |

(`DB_ARCANA_Kingmaker_` prefix omitted above; `Next` is not in the warnings but is a table of the same kind — pinned with
`Opposite`.) Each pin is a fact and its `NOT` (§13.2), before the goal's `Init` call. Confirm each type against the writes
before the apply; a DB whose columns differ from the table above is fixed in the table first.

## Plan

1. Write the fixed goals in `55/_wip/Osiris/ARC-0035/goals/` from the game's current copies (51 after `sync_data`).
2. `check_osiris.pl --dir` on them: 0 errors, 0 warnings for the 34 goals together; `check_osiris.pl --compare` against the
   game's copies: **same code** for every goal except the INITSECTION pins (no rule changes, no reorder — §13.2).
3. Apply with a `[fechado] ARC-0035` message: backup in `90/94/ARC-0035_<date>/`, copy, `sync_data`.
4. The Owner compiles the Story (OR-15); `log.txt` ends with `0 error(s), 0 warning(s)`.
5. Close: commit, propagate (`57.05` if the standard text changes), board.

**Prevention (proposal, the Owner decides):** the Story Editor writes LF lines and the Owner's edits can drop a header;
`sync_data.sh` could run `check_osiris.pl` on the goals it copies and print the findings, so they are seen the day they
appear instead of tickets later.

## Acceptance criteria

- [x] `check_osiris.pl` on the game's goals: 0 error(s), 0 warning(s)
- [x] `check_osiris.pl --compare` before/after: no code difference outside the INITSECTION pins and the 27 `(CHARACTER)_Owner` casts
- [ ] Story compiled by the Owner with `0 error(s), 0 warning(s)`
- [x] The Fool's restored header names `PROC_ARCANA_Fool_Aspect_Init` (the Owner's rename kept)
- [ ] QA_ARC-0035 passes (each changed event still fires; the 27 casts filter nothing)

## Gates

- [ ] Design gate — not applicable (no design change)
- [ ] Narrative gate — not applicable (no player text)
- [ ] DoD (`00.03`)

## Log

- 2026-11-25 — created at the Owner's request after the ARC-0020 goal split: `check_osiris.pl` on the 34 goals of the game
  showed 6 errors and 23 warnings outside the Deceiver; investigated (findings above). The last compile (log.txt,
  2026-11-25 00:04) has 0 errors, so none of them breaks the game.
- 2026-11-25 — Prepared (the Owner: "Sim, preparar"): `55/_wip/Osiris/ARC-0035/` — `before/` (the game's 11 goals), `goals/` built by `build.pl`, `README.md`. Found while preparing: pinning the Owner columns as CHARACTER needs a cast where an event binds the Kingmaker as an uncast GUIDSTRING (`TurnStarted(_Owner)`, `StatusApplied(_Owner, …)`, the causee `_Owner`), or the Story Editor skips the rule with a type mismatch (57.05 §5) — 27 patterns in 8 goals now read `(CHARACTER)_Owner`. Checks: `check_osiris` on the 34 goals 0 errors / 0 warnings; `--compare`: Fool and Aeolus' Bag same code, the rest only pins and casts. Smoke test `61.02/Class/QA_ARC-0035.md` (12 tests, draft until the apply). Status `spec_ready`: next, a `[fechado] ARC-0035` message to apply, then the Owner compiles.
- 2026-11-25 — Applied (`[fechado] ARC-0035`): the game's 11 goals matched `before/`; backup `90/94/ARC-0035_2026-11-25/goals/` (all 34); 11 copied and checked byte for byte; `check_osiris` on the game: 34 goals, 0 errors, 0 warnings; `sync_data`. QA_ARC-0035 → `ready`. Status `in_qa`: the Owner compiles (log.txt 0 errors, no type mismatch) and plays QA_ARC-0035.
