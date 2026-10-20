---
id: ARC-0029
title: "Osiris fixes from the Windborn review: the Fool goal and Harmony's leak"
type: bug
epic: EPIC_Rework_Subclasses
subclass: unbound
status: in_qa
owner: Mod Engineer
implementation: owner
priority: must
value: 5
effort: 2
inputs: [55/_wip/Unbound/arc0029/ARCANA_Aspect_Fool.txt, 82_Automation/stats/gen_emotion_alchemy.pl, 21.04/Unbound/DECISIONS.md]
outputs: [game Story (ARCANA_Aspect_Fool, ARCANA_Aspect_Temperance), game Stats (WIND_*, HEADWIND_*, BAG_OPEN, INTO_THE_STORM), 21.04/Unbound/DECISIONS.md, 55/SPEC_ARC-0026.md, 61.02/Unbound/QA_ARC-0026.md]
blocked_by: []
sprint: S01
created: 2026-10-20
---

# ARC-0029 · Osiris fixes from the Windborn review: the Fool goal and Harmony's leak

**Goal:** put in the game the Osiris changes worked out with the Owner on 2026-10-19/20 (the goal `ARCANA_Aspect_Fool`
and one rule of `ARCANA_Aspect_Temperance`) and the Stats edits they depend on.
**Intent:** the bag's winds, their headwinds and The Calm play as the Owner described them, and a Windborn at Tier II no
longer receives the Resonant's Harmony.

Found while reviewing the Owner's Windborn typing (ARC-0026). The game was open the whole time, so every change went to
the Owner as copy-paste blocks; this ticket holds them until they are in the game and tested. WIP is full (OR-36:
ARC-0008, ARC-0017, ARC-0026 in QA): this is `ready` and starts when one of them closes, or the Owner pulls it forward.

## The changes

### 1. Goal `ARCANA_Aspect_Fool` — replace the whole text

The final text is `55/_wip/Unbound/arc0029/ARCANA_Aspect_Fool.txt`. Against the goal in the game (2026-10-19):

- `DB_ARCANA_BagSpell` names `Shout_Arcana_Created_AeolusBag_EurusBoreas` (it named `..._BoreasEurus`, so that pair
  opened nothing).
- **Headwinds by the goal, not by the aura** (Owner, 2026-10-20): every enemy Windswept when the bag opens takes the
  headwind of each chosen wind (`PROC_ARCANA_Fool_Headwinds`, before the release), and so does every enemy marked while
  a wind blows (`PROC_ARCANA_Fool_LateHeadwind`). They stay until the wind stops: `PROC_ARCANA_Fool_EndWind` removes
  the ones listed in `DB_ARCANA_Headwinded`. Table `DB_ARCANA_Headwind(wind, headwind)`.
- **The Calm** (Owner, 2026-10-20): its gusts hit every enemy in the fight under any headwind, once even under two
  winds (`PROC_ARCANA_Fool_GustFoe`). Before, they only hit `DB_ARCANA_Windswept`, which the bag and each turn-start
  sweep had already emptied: the reported "removes the headwinds but deals no damage".
- **`BAG_OPEN`** is applied once, when the bag opens (`PROC_ARCANA_Fool_ShowTurns`), and counts its own turns, so the
  player sees the number (Owner: with `FreezeDuration` the turns left don't show). The goal no longer re-applies it
  every turn end (two counts could end it a turn early and reopen the bag while the wind blows).
- **Removed:** the Tier I region (`FOOL_ZEPHYR_FREE` no longer exists; The First Step lives in Stats) and
  `PROC_ARCANA_Fool_Storm` (Into the Storm is the aura of `ASPECT_AWAKENED_FOOL_III` now). The reset removes
  `THE_FIRST_STEP`.

### 2. Goal `ARCANA_Aspect_Temperance` — one rule

The turn-start rule of Tier II (Harmony) read `DB_ARCANA_AspectReached(_, 2)`, which keeps no Aspect: any Arcana at
Tier II got `RESONANT_SURGE_FREE` (seen on a level-7 Windborn). It gains
`AND HasPassive(_Resonant, "Arcana_Passive_Aspect_Temperance_II", 1)`, as the Death goal does at Tier III. The generator
`gen_emotion_alchemy.pl` was fixed on 2026-10-20 (92d4635); the game goal is pasted by the Owner (or regenerated).

### 3. Stats the goals depend on

- `WIND_BOREAS` / `WIND_NOTUS` / `WIND_EURUS`: `AuraStatuses` only for allies — `IF(Ally()):ApplyStatus(TAILWIND_X)`.
- `HEADWIND_BOREAS` / `HEADWIND_NOTUS` / `HEADWIND_EURUS`: `RemoveEvents` = `OnCombatEnded` (a safety; the goal removes them).
- `BAG_OPEN`: `TickType` = `EndTurn`, no `FreezeDuration` (already in the game on 2026-10-20).
- `INTO_THE_STORM`: `Force(3, OrigintoTarget)` → `Force(3, OriginToTarget)` (vanilla spelling).
- `ASPECT_AWAKENED_FOOL_II` / `_III`: the `TickType`, `TickFunctors` and `OnApplyFunctors` that give `THE_FIRST_STEP`,
  as `_I` has them (the higher tier replaces `_I`, so Tier I stopped at Tier II). The Owner said he is doing it.

## Acceptance criteria

- [x] The game's `ARCANA_Aspect_Fool` matches `55/_wip/Unbound/arc0029/ARCANA_Aspect_Fool.txt`; the Story compiles with `0 error(s)`
- [x] The game's `ARCANA_Aspect_Temperance` carries the `HasPassive(... Temperance_II ...)` condition
- [x] The Stats edits of §3 are in the game (checked against this list after `sync_data`)
- [ ] Play: 4 enemies, 3 marked, open the bag with Notus → only those 3 take `HEADWIND_NOTUS`, and keep it until the wind stops
- [ ] Play: an enemy marked while the wind blows takes the headwind; marked with no wind, it doesn't
- [ ] Play: The Calm with 2+ turns left hits every enemy under a headwind (1d8 per turn left to level 6, 2d6 from 7), once each; the headwinds end; the bag can reopen the same turn
- [ ] Play: "the bag is open" shows the turns left and ends with the wind, not a turn early
- [ ] Play: a Windborn at Tier II does not receive Harmony; a Resonant at Tier II still does
- [ ] Play: The First Step (first Zephyr Rush free) still works at Tier II and Tier III
- [ ] The Owner's decisions of 2026-10-20 logged in `21.04/Unbound/DECISIONS.md`; `SPEC_ARC-0026` and `QA_ARC-0026` updated

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-10-20 — created at the Owner's request from the ARC-0026 review. The generator fix is in (92d4635); the rest
  waits for the Owner to paste and compile (game open, OR-11).
- 2026-10-20 — Owner: `[fechado] ARC-0029` ("algumas alterações eu já fiz no jogo, confira e altere"); pulled forward
  past the WIP limit at the Owner's request (OR-3). Checked: the game's `ARCANA_Aspect_Fool` already had the final rules
  (only the header comment differs from `_wip`); every Stats edit of §3 was in the game, and `INTO_THE_STORM` became a
  `StartTurn` tick (`TickFunctors` `Force(3, OriginToTarget)` + Off Balance) — the Owner's choice: a Windswept enemy
  near her at Tier III is pushed at each of its turn starts. Fixed by Claude: the Tier II rule of
  `ARCANA_Aspect_Temperance` (backup in `94_Safety_Backups/ARC-0029_2026-10-20/`). `sync_data` run (it also brought the
  Owner's ARC-0026 typing and the removal of the probe goal). Next: the Owner compiles the Story and plays the tests above.
