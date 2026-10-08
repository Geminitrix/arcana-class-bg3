# Task 1 - Doubt: statuses and counter (prepared, not applied)

Files: `10_doubt.patch` (stats + English loca), `goals/ARCANA_Deceiver_Doubt.txt` (Osiris draft; copy to
`$GOALS` in the apply session, CRLF already), this note. Nothing under the game folder was touched.

## What each piece does

| Piece | Where | Role |
|---|---|---|
| `DOUBT_ADD_TECH` | Status_BOOST (DECEIVER STATUS) | Hidden (no overhead, log or portrait), duration 0. The **only** thing any source applies: `ApplyStatus(DOUBT_ADD_TECH,100,0)` from Stats, or `ApplyStatus(_Foe,"DOUBT_ADD_TECH",0.0,1,_Deceiver)` from Osiris. |
| `DOUBT_1/2/3` | Status_BOOST | One StackId `DOUBT`, `TickType EndTurn`, 3 turns (the goal applies them with 18.0 s). Stack N: `RollBonus(SavingThrow,-N,Wisdom)` and, only against her / her Doubles, `RollBonus(Attack,-N)`. Same StackPriority on purpose (last applied wins). `ForceOverhead` so each raise reads on the foe. Name "Doubt (N)". |
| `DELUDED` | Status_BOOST, `using CONFUSION` | Vanilla CONFUSION behaviour (a BOOST, parent MADNESS, group `SG_Confused`, Wisdom save at each turn start, random AI, may skip the turn). Own StackId; `OnTickFail` rewritten to test `HasStatus('DELUDED')` (the inherited one tests `'CONFUSION'` and would never skip the turn). |
| `Target_Arcana_Util_DEBUG_AddDoubt` | Spell_Target, under `Target_DEBUG SPELLS` | `using Target_DEBUG_IncreaseHP`; range 18; applies `DOUBT_ADD_TECH`. Shown as "[DEBUG] Add Doubt". |
| `ARCANA_Deceiver_Doubt.txt` | Goals | The counter, below. |

### The goal, step by step

1. `StatusApplied(Foe,"DOUBT_ADD_TECH",Cause)` -> `PROC_ARCANA_Doubt_Add`. The **credited owner** is the owner in
   `DB_ARCANA_MirrorImageOf` if `Cause` is a registered Double; else `CharacterGetOwner` if `Cause` is a summon;
   else `Cause` itself. `_Owner` is cast `(CHARACTER)` where it is first bound (the foreign DB and the query output), because `DB_ARCANA_MirrorImageOf` is typed in another goal.
2. `PROC_ARCANA_Doubt_Raise` reads and clears `DB_ARCANA_DoubtCount(Foe,N)` (row absent = 0) and calls
   `PROC_ARCANA_Doubt_Go(Foe,Owner,Old)`, whose three definitions are exclusive on the *parameter* `Old` (0/1/2),
   so they cannot cascade: 0->1 (apply DOUBT_1), 1->2 (remove DOUBT_1, apply DOUBT_2), 2->3 (remove DOUBT_2, apply
   DOUBT_3, **no count row written = the stacks reset**).
3. Every `Go` inserts one `DB_ARCANA_DoubtStep(Owner,Foe,NewStack)`.
4. `StatusApplied(Foe,"DOUBT_3",Owner)` -> `RemoveStatus(DOUBT_3)` + `ApplyStatus(Foe,"DELUDED",6.0,0,Owner)`
   (1 turn; source = the Deceiver so the inherited save DC is hers; Force 0 so Confusion immunity is respected).
5. Count hygiene: `StatusRemoved` of DOUBT_1/2 deletes the row only if it still holds that same N (a replacement made
   by the goal already wrote the new N); `Died(Foe)` deletes the row.
6. Safety net: `PROC_ARCANA_Aspect_Reset(Owner)` (called when she leaves combat) deletes unconsumed `DB_ARCANA_DoubtStep` rows.

The count lives in a DB, not in the statuses: two applications in the same instant (The Veil Lifts: all Doubles at
once) would both read "no status yet" if the goal looked at statuses.

## DB contract for Task 9 (Awakening)

`DB_ARCANA_DoubtStep((CHARACTER)Owner, (CHARACTER)Foe, (INTEGER)Stack)` is an **event row**: one row per raise
(Stack = the new stack 1..3; the raise that triggers Deluded is a 3 - spec: "a Deluded reset counts its third
stack"). Owner is the Deceiver (a Double's raises are credited to its owner). **The consumer deletes the row.** In
`ARCANA_Aspect_Empress.txt` (Task 9):

```
IF
DB_ARCANA_DoubtStep((CHARACTER)_Deceiver, (CHARACTER)_Foe, _Stack)
THEN
NOT DB_ARCANA_DoubtStep(_Deceiver, _Foe, _Stack);
PROC_ARCANA_Aspect_Step(_Deceiver, "EMPRESS");
```

`PROC_ARCANA_Aspect_Step` (Common, "Contador simples") is today's counter: +1 per call, only while `IsInCombat`,
stored in `DB_ARCANA_Aspect_Steps(Char,N)` and fed to `PROC_ARCANA_Aspect_Progress`. The goals 3/5/7 in Common
become 4/7/10 in Task 9. Another hook for Task 9: `StatusApplied(Foe,"DELUDED",Owner,_)` fires when a foe becomes
Deluded and the Cause is the Deceiver (Tier II, "when an enemy becomes Deluded").

Requirements this puts on other tasks:

- **Sigil detonation / Malicious Whispers (Task 9 / existing Sigil goal):** apply `DOUBT_ADD_TECH` from Osiris with
  the Deceiver as source (`DB_ARCANA_SigilOwner` already gives it). A status applied from `SIGIL.OnRemoveFunctors`
  has no guaranteed source (Empress goal comment), so do not rely on it there.
- **Doubles (Tasks 2/3):** Doubles must stay in `DB_ARCANA_MirrorImageOf` until their `DOUBT_ADD_TECH` events are
  handled. Shatter kills its caster in the same spell: do not delete the row on `Died` at once (use a timer), or rely on
  the `CharacterGetOwner` fallback (unverified for a dead summon).
- **"Destroyed by an enemy" (R4):** the Doubles goal calls `ApplyStatus(_Killer,"DOUBT_ADD_TECH",0.0,1,_Owner)`.
- **Hotbar for the debug spell:** add `Target_Arcana_Util_DEBUG_AddDoubt` to the spell list `Arcana Deck DEBUG`
  (UUID `f2e5e2e9-42c8-4f0e-88de-830ef0224290`, `SpellLists.lsx` + `.tbl`) in the structure step (Task 6), like
  `Shout_Arcana_Util_DEBUG_Resonant`; or `AddSpell` from the SE console on the PC edition.

## Boosts `IF` form: proven or not

- `IF(<cond with context.Target>):RollBonus(Attack,-N)` inside a status `Boosts` is **proven**: vanilla
  `MULTIATTACKDEFENSE` = `IF(HasStatus('MULTIATTACKDEFENSE_TECHNICAL',context.Target)):RollBonus(Attack,-4)`.
- `HasPassive('X', context.Source)` inside a status `Boosts` `IF(...)` is **proven** (MediumArmorMaster), and
  `a or b` inside a Boosts `IF(...)` is proven (`Tagged(...) or Tagged(...)`).
- `HasPassive('X', context.Target)` exists in vanilla only in an Interrupt `Conditions`. **The exact combination**
  (`HasPassive` on `context.Target`, in a Boosts `IF`, joined with `or`) is **not proven as a whole**: each part is.
- Closest proven fallback: a hidden marker **status** on her and on each Double (the MULTIATTACKDEFENSE_TECHNICAL
  shape): `IF(HasStatus('VEIL_MARK_TECH',context.Target)):RollBonus(Attack,-N)`. Osiris would apply the marker to the
  Deceiver and to each Double. Switch to it if D3 below fails.
- Until `Arcana_Passive_TheVeil` / `Arcana_Passive_DoubleOfTheVeil` exist (Tasks 2/4) the attack penalty cannot
  trigger; the Wisdom-save penalty works already. A Double that Transform merges her passives into carries
  `TheVeil` anyway.

## How to test in game (guide rows D1-D4; needs the debug spell on the hotbar and an enemy)

| Row | Do | Expect |
|---|---|---|
| D1 | Cast [DEBUG] Add Doubt on an enemy twice | Overhead "Doubt (1)" then "Doubt (2)"; the portrait shows ONE Doubt icon (never two together); tooltip shows -N Wisdom Saving Throws. |
| D2 | A third cast | "Doubt (3)" flashes, the enemy becomes Deluded (Confused, random turn), no Doubt left; a fourth cast starts again at Doubt (1). |
| D3 | With Doubt (2) on an enemy: let it attack the Deceiver, then an ally (needs the passives from Tasks 2/4; before that test only the save) | The Attack Roll shows -2 against her / her Double and not against the ally; a Wisdom save it makes shows -2. If the attack penalty is missing, use the marker-status fallback. |
| D4 | Let Doubt (1) expire (3 enemy turns) or kill an enemy with Doubt, then cast again | Starts again at (1) (the count followed the status / the death). Use a **fresh save** (stale DB rows survive recompiles). With Task 9 applied: each cast adds one Awakening step (`DB_ARCANA_Aspect_Steps` +1 per raise, the third stack included) and the `DoubtStep` rows are gone once counted. |
| D5 (extra) | Cast it from a Double (once Doubles exist) | Credited to the Deceiver (her Awakening steps rise), not to the Double. |

## Not verified (no compile, no game)

- **Osiris was not compiled** (no Story Editor here): checked by reading only, against `story_header.div`. Read
  `Story\log.txt` for `0 error(s)` and for type warnings.
- That a duration-0 status applied by Osiris (`ApplyStatus(...,0.0,1,...)`; vanilla uses 0.0 in the Nightsong goals,
  the mod's Stats side uses `,100,0`) still fires `StatusApplied`.
- Whether `ApplyStatus` queued right after `RemoveStatus` in the same StackId behaves as intended.
- DELUDED: the inherited Wisdom save uses `SourceSpellDC()`; applied by Osiris the spell context is gone (risk F12). The
  1-turn duration and the save need an in-game look. In the dry run `using "CONFUSION"` was accepted but only the
  entry list is shown, not the generated `.stats` text.
- `HasPassive(...,context.Target)` in a Boosts `IF` (above).
- A very late `StatusRemoved(DOUBT_1)` of a replaced stack landing after a whole new cycle reached 1 again could drop
  the row (needs three raises inside one frame); judged negligible.
- `CharacterGetOwner` for a summon that is already dead.
- Descriptions use `[1]` with `DescriptionParams "N"` (same as the Fool patch); check it renders as the number.
