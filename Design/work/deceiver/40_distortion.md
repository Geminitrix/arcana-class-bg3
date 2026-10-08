# Task 4 - Distortion's Double and Withdraw's swap (prepared, not applied)

Nothing under the game folder was touched. Base = the LIVE files after apply session 1 (commit 27e3802).

| File (under `Design/work/deceiver/`) | What |
|---|---|
| `40_distortion.patch` | `stats_add.pl` patch: Distortion / Mimic: Distortion summon a Double; Withdraw / Mimic: Withdraw castable only while their Double lives; texts |
| `goals/ARCANA_Spell_Withdraw.txt` | Rewritten from the live goal (CRLF). Binds the Double, opens the window, swaps, ends the window |
| `goals/ARCANA_Spell_MimicWithdraw.txt` | The same for the Mimic ids (own DBs and timers) |
| `goals/ARCANA_Deceiver_Doubles.txt` | The LIVE goal plus a small "Task 4" edit (4 marked places, below). Overwrites the live file |
| delete: `$GOALS/ARCANA_Spell_MirrorWithdraw.txt` | Dead since Task 3 (see "Delete list") |
| this note | |

## What changed for the player

- **Distortion** (and **Mimic: Distortion**) still dashes and blasts where she lands, and now **leaves a Double of the Veil where she stood**. The Double is a normal Double: it counts toward the cap, raises "The Veil (N)", has its own turn and kit, gives Doubt to whoever destroys it.
- **Withdraw** (and **Mimic: Withdraw**) now **swaps places with that Double** instead of teleporting her back to a stored spot. Same cost (bonus action + slot), same 2-turn window.
- **If that Double is gone, Withdraw is lost** (decision 3): the spell disappears from the hotbar the moment the Double goes and Distortion is free again. It is never cast for nothing.

## How it works

```
Distortion cast ----UsingSpell----> Reset window; DB Awaiting(her, origin X Y Z); 6 s "await" timer
   spell functors: GROUND:Summon(Double, TECH status, cause = her) ... TeleportSource ... explosion
   StatusApplied(TECH) ------------> Doubles goal: registers it (cap, layers, 300 ms form, 200 ms kit)  [unchanged]
                          ------------> Withdraw goal: BIND: Link(her, Double); DB DoubleHome(Double, origin);
                                       AddSpell Withdraw; DISTORTION_HELPER 12 s; window timer 12000 (2 turns)
   kit step (500 ms) --GoHome--------> TeleportToPosition(Double, origin) while it is still hidden, then TECH removed
Withdraw cast ----CastSpell---------> read BOTH positions, TeleportToPosition each to the other's spot, close window
Window ends: timer | swap | DB_ARCANA_DoubleGone(Link's Double) ---> Lost = RemoveSpell + RemoveStatus(helper)
```

### Doubles goal: the four marked places (`diff` against the live file shows exactly these)
1. INITSECTION: pins `DB_ARCANA_DoubleHome(Double, X, Y, Z)`.
2. Header comment: documents `DoubleHome` and that `DB_ARCANA_DoubleGone` is also read as an event by the Withdraw goals.
3. Kit rule: one new line `PROC_ARCANA_Doubles_GoHome(_Double);` right before `RemoveStatus(_Double, "DOUBLE_OF_THE_VEIL_TECH", _Owner)`.
4. New `//REGION Task 4`: `PROC_ARCANA_Doubles_GoHome` (reads and deletes the Home row, `TeleportToPosition(..., "ARCANA_Double_Home", 0,0,0,0,1)`) and one more definition of `PROC_ARCANA_Doubles_Gone` that drops a stale Home row. Mirror Image Doubles have no Home row, so for them both are no-ops. Lint: 51 rules (was 49).

### Osiris used (signatures from `story_header.div`, re-read)
```
event UsingSpell((GUIDSTRING)_Caster, (STRING)_Spell, (STRING)_SpellType, (STRING)_SpellElement, (INTEGER)_StoryActionID)
event CastSpell((GUIDSTRING)_Caster, (STRING)_Spell, (STRING)_SpellType, (STRING)_SpellElement, (INTEGER)_StoryActionID)
event StatusApplied((GUIDSTRING)_Object, (STRING)_Status, (GUIDSTRING)_Causee, (INTEGER)_StoryActionID)
event ObjectTimerFinished((GUIDSTRING)_Object, (STRING)_Timer)
query GetPosition([in](GUIDSTRING)_Target, [out](REAL)_X, [out](REAL)_Y, [out](REAL)_Z)
query IsDead([in](CHARACTER)_Character, [out](INTEGER)_Bool)
call  TeleportToPosition((GUIDSTRING)_SourceObject, (REAL)_X, (REAL)_Y, (REAL)_Z, (STRING)_Event, (INTEGER)_TeleportLinkedCharacters,
      (INTEGER)_TeleportPartyFollowers, (INTEGER)_TeleportSummons, (INTEGER)_LeaveCombat, (INTEGER)_SnapToGround)
call  AddSpell((CHARACTER)_Character, (STRING)_Spell, (INTEGER)_ShowNotification, (INTEGER)_AddContainerSpells)
call  RemoveSpell((CHARACTER)_Character, (STRING)_Spell, (INTEGER)_RemoveContainerSpells)
call  ApplyStatus((GUIDSTRING)_Object, (STRING)_Status, (REAL)_Duration, (INTEGER)_Force, (GUIDSTRING)_Source)
call  RemoveStatus((GUIDSTRING)_Target, (STRING)_Status, (GUIDSTRING)_Cause)
call  ObjectTimerLaunch((GUIDSTRING)_Entity, (STRING)_Timer, (INTEGER)_Time, (INTEGER)_ShouldTickOnTurnStart) / ObjectTimerCancel((GUIDSTRING)_Entity, (STRING)_Timer)
call  RealtimeObjectTimerLaunch((GUIDSTRING)_Entity, (STRING)_Timer, (INTEGER)_Time) / RealtimeObjectTimerCancel((GUIDSTRING)_Entity, (STRING)_Timer)
DB-insert event (no header entry): IF DB_ARCANA_DoubleGone(_Double, _Owner) AND DB_ARCANA_Withdraw_Link(_Owner, _Double)
```
`TeleportToPosition` is new to this mod (the old goals used `AppearAtPosition`); vanilla calls it with 3 args and with all 10 (flags `0, 0, 0, 0, 0/1`).

### Lint (`osi_lint.pl`, structural, no compiler)
| Goal | Rules | Unknown functions | DBs |
|---|---|---|---|
| `ARCANA_Spell_Withdraw.txt` | 12 | none | `DB_ARCANA_Withdraw_Awaiting`, `_Link`: pinned and read |
| `ARCANA_Spell_MimicWithdraw.txt` | 12 | none | `DB_ARCANA_MimicWithdraw_Awaiting`, `_Link`: pinned and read |
| `ARCANA_Deceiver_Doubles.txt` | 51 | none | the 9 old DBs pinned and read; `DB_ARCANA_DoubleHome` pinned and read, "never written here" (the Withdraw goals write it; the same cross-goal contract as `DB_ARCANA_MirrorImageOf`) |

The Withdraw goals show `DB_ARCANA_DoubleHome` as "not pinned" because the pin lives in the Doubles goal; the lint cannot see across goals and does not list the DB-insert trigger as an event.

## Decisions

1. **The Double is made by the spell's Summon functor, not by Osiris.** The header has no summon call (only `CreateAt`, which makes an unowned character). The functor is the only path that gives a real summon (summoner link for Task 3's `GetSummoner` targeting and the "cause = her" the registration reads) and it is the exact Mirror Image shape. It stays **first** in `SpellProperties`, where the marker was.
2. **Placing it at her origin is Osiris, not a spell field.** `GROUND:Summon` puts it where she lands; nothing in a spell can say "where the caster stood" (vanilla has no `Summon(SELF, ...)`; the old marker line used one with no precedent, unverified). Osiris already stores the origin at `UsingSpell` (the old goal did), so it writes it to `DB_ARCANA_DoubleHome` and the Doubles kit step moves the Double there while the INVISIBLE technical status still hides it. Cost: one extra DB and 2 PROCs in the Doubles goal. If V-W1 shows `SELF:Summon(...)` lands at her feet, the hook becomes unnecessary (harmless to leave).
3. **Withdraw with no Double: lost at once, not "does nothing at cast".** The goal removes the spell and `DISTORTION_HELPER` the moment `DB_ARCANA_DoubleGone` names the linked Double, and the spell has `RequirementConditions HasStatus('DISTORTION_HELPER')`. So the player never pays a bonus action and a slot for nothing, and Distortion is no longer locked by the dead window. This also covers the PC edition, where Lua conjures Withdraw into the hand on every Distortion cast (`CardDB.lua` `conjures`): that card is simply greyed out when there is no helper.
4. **Bind on the Double's own `StatusApplied`, not on `UsingSpell`.** `UsingSpell` only records the origin and opens a 6 s window (the Summon functor runs after the cast animation, 1-3 s for a teleporting Target spell; the bind consumes the window, so a long one costs nothing). The Withdraw spell, the helper and the 2-turn timer start when a Double really appears, so a failed summon offers nothing and never locks Distortion. (6 s is a margin, not a measurement.)
5. **Swap = `TeleportToPosition` both ways with both positions read first** (spec R6 primary), not `AppearAtPosition`: that call takes `PreventTeleportOnFailure` and the target spot is occupied by the Double. The old Mizora tele-in animation is dropped (the spell keeps its own cast effects).
6. **Mimic: Distortion also summons a Double** (spec: "Distortion... and Mimic: Distortion"). Two windows are independent; each Double counts toward the cap.
7. **The old marker item is no longer summoned.** Templates `c3c514b2` (Distortion), `d88fb323` (Mimic) and `4441890b` (Mirror) stay in `RootTemplates` unused (binary; remove with the Toolkit in Task 10 if wanted).
8. **After the swap the Double stays** as a normal Double (it is not consumed).
9. **Old DBs are dropped** (`DB_Withdraw_Position`, `_Marker`, and the Mimic/Mirror twins). Stale rows in an old save are harmless; a window opened by the OLD goal in an old save is a dud: use a fresh save.
10. **Cap interplay:** the new Double has the highest order, so the cap retires an older one, never it. A later summon can retire the linked Double: Withdraw is then lost (decision 3), as intended.
11. **Same Awaiting/TECH rule exists in both goals.** Only one Awaiting row exists per cast, so a Double is bound once; if both windows were open and one summon failed, one Double could be bound twice (edge case, 6 s window, ignored; the longer window widens it slightly).

## Delete list: `ARCANA_Spell_MirrorWithdraw.txt`

Dead since Task 3 removed `Target_Deceiver_Clone_MirrorDistortion`, `Shout_Deceiver_Clone_MirrorWithdraw` and `MIRROR_DISTORTION_HELPER`. References checked on the live tree (2026-10-06):
- Goals: `DB_MirrorWithdraw_Position`, `DB_MirrorWithdraw_Marker`, `ARCANA_MirrorWithdraw_Timer`, `PROC_ARCANA_MirrorWithdraw_*` are named **only** in that file (grep over `Story/RawFiles/Goals/*.txt`).
- Stats (`Public/.../Stats`, `Editor/.../Stats`) and Lua: no reference.
- Left over, not blocking: orphan loca (`h99c412c1` Mirror Withdraw Timer, `h292adcdc` Mirror: Withdraw, `h1027bccf` Mirror: Distortion, `hc29abaf5` Mirror Distortion Helper, `he4a289bc` its description - Task 6/10 cleanup, already listed by Task 3), the unused template `4441890b`, and the compiled `Story/goals.raw`, `story.div`, `story_ac.dat` (regenerated by the compile).

## Apply steps (a `[fechado]` session, after the backup in `Data\Backup\deceiver_veil_<date>\`)

1. Stats: `perl tools/stats_add.pl deceiver/40_distortion.patch` (read the dry run: 3 loca bumped, 2 new loca, 12 `@set`), then `--apply`.
2. Goals: copy `goals/ARCANA_Spell_Withdraw.txt`, `goals/ARCANA_Spell_MimicWithdraw.txt` and `goals/ARCANA_Deceiver_Doubles.txt` to `$GOALS/` (the last one overwrites the live file; it must still equal the apply-session-1 version outside the four marked places: `diff` first).
3. **Delete** `$GOALS/ARCANA_Spell_MirrorWithdraw.txt`.
4. `perl tools/sort_stats.pl` (read only; it reported entries that would move before - do not `--apply` blindly), `perl tools/check_cards.pl`, `perl tools/stats_add.pl --selftest`. No card level changed, so `gen_upcast_variants.pl` is not needed now.
5. The user compiles in the Story Editor; read `Story/log.txt`: 0 errors; no `DB_ARCANA_*` "never checked" warning; no type error on `DB_ARCANA_DoubleHome` (pinned in the Doubles goal, written from the Withdraw goals).
   **Cross-goal DB dependency (what to read in the log):** the Withdraw goals read `DB_ARCANA_DoubleGone` (as an insert trigger) and `DB_ARCANA_Double`, and write `DB_ARCANA_DoubleHome`; all three are pinned only in `ARCANA_Deceiver_Doubles.txt`. The house pattern pins a DB in the goal that owns it (the Sigil goal reads `DB_ARCANA_MirrorImageOf` the same way), so the Withdraw goals do not pin them. A DB is declared by first use (name + arity + types, OSIRIS.md section 2), so if the log reports a type or "unknown database" error on one of these three in a Withdraw goal, check that the Doubles goal loaded first (it sorts before `ARCANA_Spell_*`) and, only then, add the same declare-then-NOT pin to the Withdraw goals.
6. Fresh save, guide rows W1-W4.

Task 6 note: if the generator adds or drops Distortion / Mimic: Distortion variants, the new ones inherit the root's `SpellProperties` (this patch's Summon and the ROOT explosion): give them their own explosion line as `81_upcast.patch` did, keeping the Summon.

## Guide rows (in-game, fresh save, Tasks 1-3 applied)

| Row | Do | Expect | Risk |
|---|---|---|---|
| W1 | Cast Distortion (also an upcast `_4`..`_6`) at a spot 10-15 m away | She lands there with the Force blast as before. Within about half a second a Double of the Veil (looks like her, shimmer, own turn) stands exactly where she stood, **not** at the landing spot, and never flashes there visibly. "The Veil (N)" rises by 1. Withdraw appears on the hotbar and Distortion is greyed | R2, R6 |
| W2 | Cast Withdraw | She and the Double exchange spots in one go, no extra summon, both stay in combat, no one else moves; Withdraw vanishes, Distortion is castable again; costs one bonus action and one slot | **R6** |
| W3 | Distortion, then make the Double go: an enemy kills it / Dismiss / Shatter / a 4th Mirror Image at the cap / end the turn count (2 turns) / end combat | Withdraw disappears at once (hotbar and hand), Distortion is available again, no resource spent. After an enemy kill the usual 1 Doubt still follows | R4 |
| W4 | Repeat W1-W3 with Mimic: Distortion / Mimic: Withdraw; then Distortion + Mimic: Distortion in one turn | Same behaviour with its own helper and window; both Doubles stand at their own origins, both count toward the cap, each Withdraw swaps with its own Double; losing one does not affect the other | R6 |

## Risks

| # | Status |
|---|---|
| **R6** (swap both ways) | Implemented as spec primary: `TeleportToPosition` both ways, positions read first. It could land her beside, not on, the Double's spot (the engine nudging the first mover off an occupied spot) or leave them overlapping. **Plan B, not built:** stagger - move the Double to a spot a metre aside, then her to its old spot, then the Double to hers (3 calls on a 150 ms timer). **Plan C, not built:** Withdraw becomes a `Target` spell with `SwapPlaces()` (the functor Task 3's Unveil already uses) whose target filter is a marker status that Osiris puts on the linked Double; it costs a click on the Double. |

## Not verified (no compile, no game)

- **Osiris was not compiled.** Read against `story_header.div` and the lint only. In particular: the `IF DB_ARCANA_DoubleGone(...)` insert trigger across goals; `0.0` real literals in the type pins; a `TeleportToPosition` call with 10 arguments (vanilla does, the mod never did).
- `GROUND:Summon(8807d230-...,-1,,,,DOUBLE_OF_THE_VEIL_TECH)` in a Target spell that also runs `TeleportSource`: that the Double appears at the landing spot (assumed), that its status cause is her (as Mirror Image), that the summon is legal at a spot that is also the blast centre (the explosion is `not Ally()`, so it should not hurt it).
- `TeleportToPosition` on a summon that was Transformed 200 ms earlier and is still INVISIBLE (decision 2); and that it does not pop into view at the landing spot before the kit step. Fallback: a `RealtimeObjectTimerLaunch` of ~100 ms inside the Withdraw goal's bind rule that calls the same teleport (earlier, but may hit the engine's "summon not finished" window).
- `RequirementConditions HasStatus('DISTORTION_HELPER')` evaluates on the caster, as the existing `not HasStatus('DISTORTION_HELPER')` on Distortion does.
- PC edition: Lua conjures Withdraw into the hand (`CardDB.lua`, 2 turns) and expires it itself; Osiris' `RemoveSpell` on loss may not update Lua's hand state (the card may stay displayed but uncastable until Lua expires it). Check in W3 on the PC edition.
- The 6 s "awaiting" timer (raised from 2 s in fix round 1) and the 12 s window are margins / carried over; `ObjectTimerLaunch(..., 12000, 1)` behaves as before.
- A Double that goes during its first 500 ms (before the kit step) never gets its Home move; harmless (it is gone), the stale row is dropped.
- Upcast Withdraw variants `_3`..`_6` inherit the new requirement and Extra text through `using`; not inspected in the generated `.stats`.
- A window opened by the old goal in an existing save (decision 9).
