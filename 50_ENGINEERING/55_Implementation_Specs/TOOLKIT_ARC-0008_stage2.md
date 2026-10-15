---
id: TOOLKIT_ARC-0008_stage2
ticket: ARC-0008
spec: SPEC_ARC-0008
status: entered
derived_from: [25.01/SPL_Kingmaker_AtroposCut.yaml, 25.01/SPL_Kingmaker_RotaFortunae.yaml, 25.01/SPL_Kingmaker_Dethrone.yaml, 25.02/FEAT_Kingmaker_Crossing.yaml, 25.02/FEAT_Kingmaker_AspectAwakening.yaml]
generated_at: 2026-10-14
author: Mod Engineer
---

# TOOLKIT_ARC-0008 · The Kingmaker — stage 2: the Crossing (level 3)

> **What this file is.** The point-by-point guide to enter **stage 2** of `SPEC_ARC-0008` by hand in the BG3
> Toolkit: *The Crossing*, *Atropos' Cut*, the Awakening *10 - Wheel of Fortune* with Tier I *Tyche*, and the Aspect
> card *Rota Fortunae*. Stage 1 is `TOOLKIT_ARC-0008.md` (entered 2026-10-14). Texts are drafts pending the Narrative
> gate (`32.01/Kingmaker_texts_with_params.md`).
>
> **Before you start:** stage 1's probes P1–P8 haven't been played yet. Stage 2 builds on the Wheel core; if a probe
> fails, tell me before typing this stage — the goal below replaces stage 1's and carries any fix.

---

## Rules for whoever writes this file

1. **Derived view (ADR-0005, ADR-0008).** Numbers live in `25_Master_Data`. The origin of every number is listed
   **under** its block. Regenerate this file when a file in `derived_from` changes; never edit a number here by hand.
2. **Order.** Section 0 is the checklist in the order the work has to happen.
3. **Stats Editor blocks:** one column per entry, **at most 3 entries per block**, one row per field, in **the
   Toolkit's own field order** (`_TEMPLATE_TOOLKIT_GUIDE.md`, *Toolkit field order*) with its labels (Spell Animation,
   Intent, Spell Style Group). **A cell holds only what is pasted**, as `code` (double-click, copy, paste). `—` = leave
   the field empty. Notes go under the block.
4. **`Using` only to copy the look.** Spell Animation and the effects are never written here: set `Using` to the
   spell the Notes name, copy those fields from it in the Toolkit, then remove `Using`. Every other field with a value has
   a row, readable parent values included; the parent's unwanted fields go away with `Using`. A tooltip text picked from
   a list (TooltipUpcastDescription) is given by the name the list shows.
5. **Changed entries** (UUID Object Editor, Stories): only what changes.
6. **Icons are suggestions** — custom icons come later.
7. **UUIDs:** the Toolkit generates them; write the ones later steps need in the `UUID: ________` slots.
8. **Text:** every `DisplayName`, `Description` and `ExtraDescription` cell is a new localisation handle with that
   English text, tags included. `[n]` in a Description reads `DescriptionParams`; in an ExtraDescription it reads
   `ExtraDescriptionParams` — each list starts at `[1]`.
9. **Generated — do not type:** the upcast variants (now with their damage), the Awakening progress statuses and the
   Awakening passive's final text. I run the generators after you save (§5).
10. **Osiris:** one copy-paste block per goal.

---

## 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | UUID Object Editor | Levelmaps / LevelMapValues | `Kingmaker_Crossing` | new | — | ☐ |
| 02 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_CROSSING_TECH` | new | 01 | ☐ |
| 03 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_CUT_TECH`, `KINGMAKER_TURN_TECH` | new (2) | — | ☐ |
| 04 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_REIGNING_LINGER` | new | — | ☐ |
| 05 | Stats Editor | StatusData / Status_BOOST | `ASPECT_AWAKENED_WHEEL`, `ASPECT_AWAKENED_WHEEL_I` | new (2) | 09 | ☐ |
| 06 | Stats Editor | Stats / Passive | `Arcana_Passive_TheCrossing` | new | 01 | ☐ |
| 07 | Stats Editor | Stats / Passive | `Arcana_Passive_Aspect_WheelOfFortune_Awakening`, `Arcana_Passive_Aspect_WheelOfFortune_I` | new (2) | — | ☐ |
| 08 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_AtroposCut` | new | 03 | ☐ |
| 09 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_Aspect_RotaFortunae` | new | 03 | ☐ |
| 10 | Stories | Goals | `ARCANA_Kingmaker_Wheel` | **replace the whole text** | 02–04 | ☐ |
| 11 | Stories | Goals | `ARCANA_Aspect_Common` | add 6 lines | 05, 07 | ☐ |
| 12 | UUID Object Editor | Lists / SpellLists | "Kingmaker Level 3" | new | 08 | ☐ |
| 13 | UUID Object Editor | Progressions / Progressions | table `a688d11f…` level 3 | change | 06, 07, 12 | ☐ |
| 14 | — | Generated | upcast variants of 08 (and Dethrone's damage) · Awakening progress statuses | Claude runs scripts | 08, 11 | ☐ |

---

## 1 · Stories (Osiris)

### 10 · CHANGED goal `ARCANA_Kingmaker_Wheel` — select all its text and paste this over it

What changes from stage 1: Tyche's bindings one position ahead; every move notes an enemy that enters Fallen
(`PROC_ARCANA_Kingmaker_Fell`) and every change ends with the Crossing check (`PROC_ARCANA_Kingmaker_Settle`); Rota
Fortunae turns the Wheel (`KINGMAKER_TURN_TECH`); Atropos' Cut takes a creature off (`KINGMAKER_CUT_TECH`); the
Awakening count; the save-load refresh of the tables.

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION
PROC_ARCANA_Kingmaker_Init();
KBSECTION
// The Kingmaker's Wheel (ARC-0008, SPEC_ARC-0008 stages 1-2). Ledger: owner, creature, position, side (1 ally / 0 enemy,
// fixed at entry), entry order. The Wheel turns at the owner's turn start; one Kingmaker per Wheel until stage 6.
// Stage 2: the Crossing (an enemy entering Fallen with a Reigning ally within 9 m takes Force damage, once per enemy per
// round), its count for the Awakening (a lone enemy counts twice), Tyche (bindings one position ahead), Rota Fortunae
// (the Wheel turns once more) and Atropos' Cut (the thread is cut).
//REGION Tables
PROC
PROC_ARCANA_Kingmaker_Init()
AND
DB_ARCANA_Kingmaker_Next(_From, _To)
THEN
NOT DB_ARCANA_Kingmaker_Next(_From, _To);

PROC
PROC_ARCANA_Kingmaker_Init()
AND
DB_ARCANA_Kingmaker_PositionStatus(_Position, _Status)
THEN
NOT DB_ARCANA_Kingmaker_PositionStatus(_Position, _Status);

PROC
PROC_ARCANA_Kingmaker_Init()
THEN
DB_ARCANA_Kingmaker_Next("RISING", "REIGNING");
DB_ARCANA_Kingmaker_Next("REIGNING", "FALLING");
DB_ARCANA_Kingmaker_Next("FALLING", "FALLEN");
DB_ARCANA_Kingmaker_Next("FALLEN", "RISING");
DB_ARCANA_Kingmaker_PositionStatus("RISING", "KINGMAKER_RISING");
DB_ARCANA_Kingmaker_PositionStatus("REIGNING", "KINGMAKER_REIGNING");
DB_ARCANA_Kingmaker_PositionStatus("FALLING", "KINGMAKER_FALLING");
DB_ARCANA_Kingmaker_PositionStatus("FALLEN", "KINGMAKER_FALLEN");

IF
SavegameLoaded()
THEN
PROC_ARCANA_Kingmaker_Init();
//END_REGION

//REGION Bind - Coronation (ally, Rising) and Dethrone (enemy, Falling); with Tyche (Tier I) one position ahead
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ALLY_TECH", (CHARACTER)_Owner, _)
AND
NOT DB_ARCANA_AspectReached(_Owner, 1)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "RISING", 1);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ALLY_TECH", (CHARACTER)_Owner, _)
AND
DB_ARCANA_AspectReached(_Owner, 1)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "REIGNING", 1);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ENEMY_TECH", (CHARACTER)_Owner, _)
AND
NOT DB_ARCANA_AspectReached(_Owner, 1)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "FALLING", 0);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ENEMY_TECH", (CHARACTER)_Owner, _)
AND
DB_ARCANA_AspectReached(_Owner, 1)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "FALLEN", 0);

PROC
PROC_ARCANA_Kingmaker_Bind((GUIDSTRING)_Owner, (CHARACTER)_Creature, (STRING)_Position, (INTEGER)_Side)
AND
NOT DB_ARCANA_Kingmaker_OnWheel(_, _Creature, _, _, _)
AND
NOT DB_ARCANA_Kingmaker_Counter(_Owner, _)
THEN
DB_ARCANA_Kingmaker_Counter(_Owner, 0);

PROC
PROC_ARCANA_Kingmaker_Bind((GUIDSTRING)_Owner, (CHARACTER)_Creature, (STRING)_Position, (INTEGER)_Side)
AND
NOT DB_ARCANA_Kingmaker_OnWheel(_, _Creature, _, _, _)
AND
DB_ARCANA_Kingmaker_Counter(_Owner, _Old)
AND
IntegerSum(_Old, 1, _New)
AND
DB_ARCANA_Kingmaker_PositionStatus(_Position, _Status)
THEN
NOT DB_ARCANA_Kingmaker_Counter(_Owner, _Old);
DB_ARCANA_Kingmaker_Counter(_Owner, _New);
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _New);
ApplyStatus(_Creature, _Status, -1.0, 1, _Owner);
PROC_ARCANA_Kingmaker_Fell(_Owner, _Creature, _Position, _Side);
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

//REGION Move one step (collected first, so the ledger is never changed while it is read)
PROC
PROC_ARCANA_Kingmaker_Move((GUIDSTRING)_Owner, (CHARACTER)_Creature)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order)
THEN
DB_ARCANA_Kingmaker_Moving(_Owner, _Creature, _Position, _Side, _Order);

PROC
PROC_ARCANA_Kingmaker_Move((GUIDSTRING)_Owner, (CHARACTER)_Creature)
AND
DB_ARCANA_Kingmaker_Moving(_Owner, _Creature, _Position, _Side, _Order)
AND
DB_ARCANA_Kingmaker_Next(_Position, _NextPosition)
AND
DB_ARCANA_Kingmaker_PositionStatus(_Position, _OldStatus)
AND
DB_ARCANA_Kingmaker_PositionStatus(_NextPosition, _NewStatus)
THEN
NOT DB_ARCANA_Kingmaker_Moving(_Owner, _Creature, _Position, _Side, _Order);
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order);
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _NextPosition, _Side, _Order);
RemoveStatus(_Creature, _OldStatus, _Owner);
ApplyStatus(_Creature, _NewStatus, -1.0, 1, _Owner);
PROC_ARCANA_Kingmaker_Fell(_Owner, _Creature, _NextPosition, _Side);

// an enemy that enters Fallen waits for the Crossing check, made after every creature has moved
PROC
PROC_ARCANA_Kingmaker_Fell((GUIDSTRING)_Owner, (CHARACTER)_Creature, (STRING)_Position, (INTEGER)_Side)
AND
_Position == "FALLEN"
AND
_Side == 0
THEN
DB_ARCANA_Kingmaker_NewFallen(_Owner, _Creature);
//END_REGION

//REGION The Wheel turns at the owner's turn start (a new round: every enemy may cross again)
IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy);

IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
DB_ARCANA_Kingmaker_Pending(_Owner, _Creature);

IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_Pending(_Owner, _Creature)
THEN
NOT DB_ARCANA_Kingmaker_Pending(_Owner, _Creature);
PROC_ARCANA_Kingmaker_Move(_Owner, _Creature);

IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_Counter(_Owner, _)
THEN
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

//REGION Rota Fortunae (Tier I card) - the Wheel turns once more, now
IF
StatusApplied(_Owner, "KINGMAKER_TURN_TECH", _, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
DB_ARCANA_Kingmaker_Pending(_Owner, _Creature);

IF
StatusApplied(_Owner, "KINGMAKER_TURN_TECH", _, _)
AND
DB_ARCANA_Kingmaker_Pending(_Owner, _Creature)
THEN
NOT DB_ARCANA_Kingmaker_Pending(_Owner, _Creature);
PROC_ARCANA_Kingmaker_Move(_Owner, _Creature);

IF
StatusApplied(_Owner, "KINGMAKER_TURN_TECH", _, _)
AND
DB_ARCANA_Kingmaker_Counter(_Owner, _)
THEN
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

//REGION Turn the Spoke - one step for one creature
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_STEP_TECH", _Owner, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
PROC_ARCANA_Kingmaker_Move(_Owner, _Creature);
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

//REGION Atropos' Cut - the creature leaves the Wheel (the damage is in Stats); an ally cut while Reigning keeps it a turn
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_CUT_TECH", _Owner, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order)
AND
DB_ARCANA_Kingmaker_PositionStatus(_Position, _Status)
THEN
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order);
RemoveStatus(_Creature, _Status, _Owner);
RemoveStatus(_Creature, "KINGMAKER_KING", _Owner);
RemoveStatus(_Creature, "KINGMAKER_REGENT", _Owner);
PROC_ARCANA_Kingmaker_Cut(_Owner, _Creature, _Position, _Side);
PROC_ARCANA_Kingmaker_Crown(_Owner);

PROC
PROC_ARCANA_Kingmaker_Cut((GUIDSTRING)_Owner, (CHARACTER)_Creature, (STRING)_Position, (INTEGER)_Side)
AND
_Position == "REIGNING"
AND
_Side == 1
THEN
ApplyStatus(_Creature, "KINGMAKER_REIGNING_LINGER", 6.0, 1, _Owner);
//END_REGION

//REGION The crown - the ally Reigning longest (lowest order, not a summon) is King; other Reigning allies are Regents
PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
RemoveStatus(_Creature, "KINGMAKER_KING", _Owner);
RemoveStatus(_Creature, "KINGMAKER_REGENT", _Owner);

PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _Order)
THEN
NOT DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _Order);

PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, "REIGNING", 1, _Order)
AND
IsSummon(_Creature, 0)
AND
NOT DB_ARCANA_Kingmaker_Best(_Owner, _, _)
THEN
DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _Order);

PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, "REIGNING", 1, _Order)
AND
IsSummon(_Creature, 0)
AND
DB_ARCANA_Kingmaker_Best(_Owner, _Best, _BestOrder)
AND
_Order < _BestOrder
THEN
NOT DB_ARCANA_Kingmaker_Best(_Owner, _Best, _BestOrder);
DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _Order);

PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_Best(_Owner, _King, _)
THEN
ApplyStatus(_King, "KINGMAKER_KING", -1.0, 1, _Owner);

PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, "REIGNING", 1, _)
AND
NOT DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _)
THEN
ApplyStatus(_Creature, "KINGMAKER_REGENT", -1.0, 1, _Owner);
//END_REGION

//REGION The Crossing (level 3) - after every change; once per enemy per round, however many allies Reign near it
PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy)
AND
HasPassive(_Owner, "Arcana_Passive_TheCrossing", 1)
AND
NOT DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, "FALLEN", 0, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Ally, "REIGNING", 1, _)
AND
GetDistanceTo(_Enemy, _Ally, _Dist)
AND
_Dist <= 9.0
THEN
DB_ARCANA_Kingmaker_CrossPending(_Owner, _Enemy);

PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy);

PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_CrossPending(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_CrossPending(_Owner, _Enemy);
DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy);
ApplyStatus(_Enemy, "KINGMAKER_CROSSING_TECH", 0.0, 1, _Owner);
PROC_ARCANA_Kingmaker_CountCrossing((CHARACTER)_Owner);
//END_REGION

//REGION Awakening 10 - Wheel of Fortune: every Crossing counts 1, or 2 while only one enemy is on the Wheel
PROC
PROC_ARCANA_Kingmaker_CountCrossing((CHARACTER)_Owner)
AND
DB_ARCANA_Kingmaker_Enemies(_Owner, _N)
THEN
NOT DB_ARCANA_Kingmaker_Enemies(_Owner, _N);

PROC
PROC_ARCANA_Kingmaker_CountCrossing((CHARACTER)_Owner)
THEN
DB_ARCANA_Kingmaker_Enemies(_Owner, 0);

PROC
PROC_ARCANA_Kingmaker_CountCrossing((CHARACTER)_Owner)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, _, 0, _)
THEN
PROC_ARCANA_Kingmaker_AddEnemy(_Owner);

PROC
PROC_ARCANA_Kingmaker_AddEnemy((CHARACTER)_Owner)
AND
DB_ARCANA_Kingmaker_Enemies(_Owner, _Old)
AND
IntegerSum(_Old, 1, _New)
THEN
NOT DB_ARCANA_Kingmaker_Enemies(_Owner, _Old);
DB_ARCANA_Kingmaker_Enemies(_Owner, _New);

PROC
PROC_ARCANA_Kingmaker_CountCrossing((CHARACTER)_Owner)
AND
HasPassive(_Owner, "Arcana_Passive_Aspect_WheelOfFortune_Awakening", 1)
THEN
PROC_ARCANA_Aspect_Step(_Owner, "WHEEL");

PROC
PROC_ARCANA_Kingmaker_CountCrossing((CHARACTER)_Owner)
AND
HasPassive(_Owner, "Arcana_Passive_Aspect_WheelOfFortune_Awakening", 1)
AND
DB_ARCANA_Kingmaker_Enemies(_Owner, 1)
THEN
PROC_ARCANA_Aspect_Step(_Owner, "WHEEL");
//END_REGION

//REGION Leaving the Wheel - death and the end of combat
IF
Died(_Creature)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order)
THEN
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order);
PROC_ARCANA_Kingmaker_Crown(_Owner);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order)
AND
DB_ARCANA_Kingmaker_PositionStatus(_Position, _Status)
THEN
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order);
RemoveStatus(_Creature, _Status, _Owner);
RemoveStatus(_Creature, "KINGMAKER_KING", _Owner);
RemoveStatus(_Creature, "KINGMAKER_REGENT", _Owner);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_Counter(_Owner, _N)
THEN
NOT DB_ARCANA_Kingmaker_Counter(_Owner, _N);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _Order)
THEN
NOT DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _Order);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_Enemies(_Owner, _N)
THEN
NOT DB_ARCANA_Kingmaker_Enemies(_Owner, _N);
//END_REGION
EXITSECTION

ENDEXITSECTION
```

### 11 · CHANGED goal `ARCANA_Aspect_Common` — add 6 lines

In `PROC_ARCANA_Aspect_Init()`, the block that fills the tables (the one with the `DB_ARCANA_Aspect("FOOL", …)` lines):
paste these **right after the line `DB_ARCANA_AspectShow("TEMPERANCE", "COUNT");`**. Nothing else in the goal changes.

```
// 10 - Wheel of Fortune (the Kingmaker): Crossings caused in the fight (ARC-0008)
DB_ARCANA_Aspect("WHEEL", "ASPECT_PROGRESS_WHEEL", "ASPECT_AWAKENED_WHEEL", "Arcana_Passive_Aspect_WheelOfFortune_I");
DB_ARCANA_AspectTier("WHEEL", 1, "Arcana_Passive_Aspect_WheelOfFortune_I", "ASPECT_AWAKENED_WHEEL_I", 3);
DB_ARCANA_AspectTier("WHEEL", 2, "Arcana_Passive_Aspect_WheelOfFortune_II", "ASPECT_AWAKENED_WHEEL_II", 5);
DB_ARCANA_AspectTier("WHEEL", 3, "Arcana_Passive_Aspect_WheelOfFortune_III", "ASPECT_AWAKENED_WHEEL_III", 8);
DB_ARCANA_AspectShow("WHEEL", "COUNT");
```

Numbers: goals `3` / `5` / `8` = `FEAT_Kingmaker_AspectAwakening#goal_tier1` / `#goal_tier2` / `#goal_tier3`. Tiers II and III
(passives and statuses) come in stages 4 and 6; until then their rows are never reached.

After pasting both: **compile** in the Story Editor and read `Mods/AspectClass_…/Story/log.txt` — it must end with
`0 error(s)`. A warning such as *Database defined but never checked* is a defect: send me the log.

---

## 2 · UUID Object Editor

### 01 · NEW · Levelmaps / LevelMapValues · `Kingmaker_Crossing`

| Field | Value |
|---|---|
| Name | `Kingmaker_Crossing` |
| Level1 | `1d4` |
| Level2 | `1d4` |
| Level3 | `1d4` |
| Level4 | `1d4` |
| Level5 | `1d6` |
| Level6 | `1d6` |
| Level7 | `1d6` |
| Level8 | `1d6` |
| Level9 | `1d8` |
| Level10 | `1d8` |
| Level11 | `1d8` |
| Level12 | `1d8` |
| Level13 | `1d8` |
| Level14 | `1d8` |
| Level15 | `1d8` |
| Level16 | `1d8` |
| Level17 | `1d8` |
| Level18 | `1d8` |
| Level19 | `1d8` |
| Level20 | `1d8` |

Numbers: `FEAT_Kingmaker_Crossing#damage` `by_level` (3: 1d4, 5: 1d6, 9: 1d8); levels 1–2 repeat level 3 (no Crossing
before level 3). Pattern: the mod's `Sigil_MarkDamage` (same table, read as `Cause.LevelMapValue(…)` by an Osiris-applied
status).

### 12 · NEW · Lists / SpellLists · "Kingmaker Level 3"

| Field | Value |
|---|---|
| Name | `Kingmaker Level 3` |
| Spells | `Target_Arcana_Card_Spell_AtroposCut` |

UUID: ________ (used in 13)

### 13 · CHANGED · Progressions / Progressions · `504e7b34-f08d-48d6-a817-4be73d9064c5` (table `a688d11f…`, level 3)

| Field | Before | After |
|---|---|---|
| PassivesAdded | — | `Arcana_Passive_TheCrossing;Arcana_Passive_Aspect_WheelOfFortune_Awakening;Arcana_Passive_Aspect_WheelOfFortune_I` |
| Selectors | — | `AddSpells(<UUID 12>,,,,AlwaysPrepared)` |

Same shape as the Resonant's level 3 (its Tier I passive, its Awakening passive, its level-3 list).

---

## 3 · Stats Editor

**How to read the tables below.** Each column is one entry; each row is one field. **Every cell is exactly what you
paste** — double-click it in the preview, copy, paste into the Toolkit. `—` = leave the field empty. `DisplayName`,
`Description` and `ExtraDescription` cells are new localisation handles with that English text (tags included).
**Spell names** are typed without the type prefix (`Arcana_Card_Spell_AtroposCut` in `Target.stats`; in stage 1 two
cards got the prefix twice — check the Name before saving). Rows follow the Toolkit's field order and labels; the
numbers of each block, with their origin in `25` (ADR-0008), are listed under it.

### 02–03 · NEW · StatusData / Status_BOOST · the Crossing, the Cut and the turn

| Field | `KINGMAKER_CROSSING_TECH` | `KINGMAKER_CUT_TECH` | `KINGMAKER_TURN_TECH` |
|---|---|---|---|
| Name | `KINGMAKER_CROSSING_TECH` | `KINGMAKER_CUT_TECH` | `KINGMAKER_TURN_TECH` |
| DisplayName | `The Crossing` | — | — |
| Description | `Fell while an ally reigned nearby, and took Force damage.` | — | — |
| Icon | `Spell_Evocation_MagicMissile` | — | — |
| StackId | `KINGMAKER_CROSSING_TECH` | `KINGMAKER_CUT_TECH` | `KINGMAKER_TURN_TECH` |
| StackType | `Overwrite` | `Overwrite` | `Overwrite` |
| StatusPropertyFlags | `ForceOverhead;DisablePortraitIndicator` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |
| OnApplyFunctors | `DealDamage(Cause.LevelMapValue(Kingmaker_Crossing),Force,Magical)` | — | — |

Notes: the Icon is a suggestion. `KINGMAKER_CROSSING_TECH` deals the Crossing: Osiris applies it with the Kingmaker as
the cause, so `Cause.LevelMapValue` reads the Kingmaker's level (the mod's `SIGIL` does the same with `Sigil_MarkDamage`);
`ForceOverhead` shows *The Crossing* over the enemy. The two others are technical, like stage 1's `_TECH`.

Numbers: `Kingmaker_Crossing` = `FEAT_Kingmaker_Crossing#damage` (block 01).

### 04 · NEW · StatusData / Status_BOOST · `KINGMAKER_REIGNING_LINGER`

| Field | `KINGMAKER_REIGNING_LINGER` |
|---|---|
| Name | `KINGMAKER_REIGNING_LINGER` |
| DisplayName | `Reigning` |
| Description | `Cut from the Wheel at its peak. Lands a <LSTag Tooltip="CriticalHit">Critical Hit</LSTag> on a roll of 19 or 20 and has <LSTag Tooltip="Advantage">Advantage</LSTag> on <LSTag Tooltip="SavingThrow">Saving Throws</LSTag> until the end of its next turn.` |
| Icon | `Spell_Enchantment_Bless` |
| StackId | `KINGMAKER_REIGNING_LINGER` |
| StackType | `Overwrite` |
| TickType | `EndTurn` |
| Boosts | `ReduceCriticalAttackThreshold(1);Advantage(AllSavingThrows)` |
| RemoveEvents | `OnCombatEnded` |
| StatusPropertyFlags | `ForceOverhead` |

Notes: the Icon is a suggestion (the same as `KINGMAKER_REIGNING`). Osiris applies it for one turn when Atropos' Cut takes
an ally off the Wheel while it Reigns; `TickType EndTurn` makes it last until the end of that ally's next turn (anchor:
the mod's `ETHEREAL_CHAINS`). It is **not** a position: the ally is off the Wheel, wears no crown and is no source of
Crossings.

Numbers: `1` (threshold 19) = `FEAT_Kingmaker_TheRota#reigning_crit_threshold`.

### 05 · NEW · StatusData / Status_BOOST · the Awakening (Tier I)

| Field | `ASPECT_AWAKENED_WHEEL` | `ASPECT_AWAKENED_WHEEL_I` |
|---|---|---|
| Name | `ASPECT_AWAKENED_WHEEL` | `ASPECT_AWAKENED_WHEEL_I` |
| DisplayName | `10 - Wheel of Fortune` | `10 - Wheel of Fortune: Awakened I` |
| Description | `Awakened as the Aspect of Anticipation until combat ends.` | `Tyche: creatures you set on the Wheel enter one position ahead. Allies you crown begin Reigning, and enemies you cast down begin Fallen.` |
| Icon | `Spell_Divination_DetectThoughts` | `Spell_Divination_DetectThoughts` |
| StackId | `ASPECT_AWAKENED_WHEEL` | `ASPECT_AWAKENED_WHEEL_TIER` |
| StackPriority | — | `1` |
| StackType | `Ignore` | `Overwrite` |
| Boosts | `UnlockSpell(Shout_Arcana_Created_Aspect_RotaFortunae)` | — |
| RemoveEvents | `OnCombatEnded` | `OnCombatEnded` |
| StatusPropertyFlags | `IgnoreResting;DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `ForceOverhead;IgnoreResting` |
| OnRemoveFunctors | `RemoveStatus(ASPECT_AWAKENED_WHEEL_I);RemoveStatus(ASPECT_AWAKENED_WHEEL_II);RemoveStatus(ASPECT_AWAKENED_WHEEL_III)` | — |
| StatusGroups | `SG_RemoveOnRespec` | `SG_RemoveOnRespec` |

Notes: Icons are suggestions. Same shape as the Resonant's `ASPECT_AWAKENED_TEMPERANCE` / `_I` field by field:
`ARCANA_Aspect_Common` applies `ASPECT_AWAKENED_WHEEL` (it unlocks *Rota Fortunae*) and `_I` when the first goal is
reached. Tyche itself is in the goal (block 10): bindings enter one position ahead.

No numbers in this block.

### 06–07 · NEW · Stats / Passive · The Crossing and the Awakening

| Field | `Arcana_Passive_TheCrossing` | `Arcana_Passive_Aspect_WheelOfFortune_Awakening` | `Arcana_Passive_Aspect_WheelOfFortune_I` |
|---|---|---|---|
| Name | `Arcana_Passive_TheCrossing` | `Arcana_Passive_Aspect_WheelOfFortune_Awakening` | `Arcana_Passive_Aspect_WheelOfFortune_I` |
| DisplayName | `The Crossing` | `10 - Wheel of Fortune: Awakening` | `Tyche` |
| Description | `When an enemy on the Wheel becomes Fallen while an ally on the Wheel is Reigning within [1], the enemy takes [2]. Once per enemy per round.` | `Make your enemies fall while your allies reign during a fight to awaken the Aspect of Anticipation until combat ends. Every Crossing counts, and while only one enemy is on the Wheel each Crossing counts twice. Each goal you reach awakens one more tier.<br><br>Level 3: cause 3 Crossings to gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_WheelOfFortune_I">Tyche</LSTag>.<br><br>Level 7: cause 5 Crossings to also gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_WheelOfFortune_II">Nemesis</LSTag>.<br><br>Level 12: cause 8 Crossings to awaken as the <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_WheelOfFortune_III">Aspect of Anticipation</LSTag>.<br><br>The Awakening status shows how much is left to the next tier.` | `Fortune favours those you touch: creatures you set on the Wheel enter one position ahead. Allies you crown begin Reigning, and enemies you cast down begin Fallen.` |
| DescriptionParams | `Distance(9);DealDamage(LevelMapValue(Kingmaker_Crossing),Force)` | — | — |
| Icon | `Spell_Evocation_MagicMissile` | `Spell_Divination_DetectThoughts` | `Spell_Divination_DetectThoughts` |
| Properties | `Highlighted` | `Highlighted` | `IsHidden` |

Notes: Icons are suggestions. `LevelMapValue` in a passive's DescriptionParams shows the die for the owner's level
(vanilla anchor: the Battle Master manoeuvres with `SuperiorityDie`). The Awakening text is the ARC-0007 shape; after you
save, `gen_awakening_progress.pl` rewrites it in place from the goals of block 11, so the numbers there stay in step. The
Awakening and Tier I passives have the Resonant's shape (`Arcana_Passive_Aspect_Temperance_Awakening` / `_I`).

Numbers: `Distance(9)` = `FEAT_Kingmaker_Crossing#range`; the die = `#damage` (block 01); goals `3` / `5` / `8` =
`FEAT_Kingmaker_AspectAwakening#goal_tier1…3`; "counts twice" = `#lone_enemy_count`.

### 08 · NEW · SpellData / Target · Atropos' Cut

| Field | `Target_Arcana_Card_Spell_AtroposCut` |
|---|---|
| Name | `Arcana_Card_Spell_AtroposCut` |
| Using | `CloudOfDaggers` |
| Level | `2` |
| SpellSchool | `Enchantment` |
| SpellProperties | `IF(Enemy() and HasStatus('KINGMAKER_FALLEN')):DealDamage(3d8,Slashing,Magical);IF(Enemy() and HasStatus('KINGMAKER_FALLING')):DealDamage(2d8,Slashing,Magical);IF(Enemy() and (HasStatus('KINGMAKER_RISING') or HasStatus('KINGMAKER_REIGNING'))):DealDamage(1d8,Slashing,Magical);ApplyStatus(KINGMAKER_CUT_TECH,100,0)` |
| TargetRadius | `18` |
| TargetConditions | `not Dead() and (HasStatus('KINGMAKER_RISING') or HasStatus('KINGMAKER_REIGNING') or HasStatus('KINGMAKER_FALLING') or HasStatus('KINGMAKER_FALLEN')) and not HasPassive('ARCANA_IS_CARD', context.Source)` |
| Icon | `Action_Bard_CuttingWords` |
| DisplayName | `Atropos' Cut` |
| Description | `Cut a creature's thread from Fortune's wheel.` |
| ExtraDescription | `An enemy takes damage that grows the lower it sits: [1] if Fallen, [2] if Falling, [3] if Rising or Reigning.<br><br>An ally leaves the Wheel. If it was Reigning, it keeps Reigning until the end of its next turn.` |
| ExtraDescriptionParams | `DealDamage(3d8,Slashing);DealDamage(2d8,Slashing);DealDamage(1d8,Slashing)` |
| TooltipDamageList | `DealDamage(3d8,Slashing)` |
| TooltipUpcastDescription | `Additional damage` |
| TooltipUpcastDescriptionParams | `DealDamage(1d8,Slashing)` |
| CastSound | `Spell_Cast_Damage_Physical_CloudOfDaggers_L1to3` |
| TargetSound | `Spell_Impact_Damage_Physical_CloudOfDaggers_L1to3` |
| PreviewCursor | `Cast` |
| CastTextEvent | `Cast` |
| UseCosts | `ActionPoint:1;SpellSlotsGroup:1:1:2` |
| Intent | `Damage` |
| Spell Style Group | `Class` |
| SpellFlags | `IsSpell;HasVerbalComponent;HasSomaticComponent` |
| HitAnimationType | `MagicalDamage_External` |
| DamageType | `Slashing` |

Notes (`Using` = `CloudOfDaggers`; search `CloudOfDaggers` in the picker — vanilla Cloud of Daggers, a level-2 Slashing spell):
- **Copy from the parent in the Toolkit, then remove `Using`:** Spell Animation, PrepareEffect, CastEffect — the look of
  Cloud of Daggers. Leave its PositionEffect, AreaRadius and TooltipStatusApply behind (they are its ground cloud).
- **From the parent** (typed above too, so nothing is lost when `Using` goes): Level, TargetRadius, TooltipUpcastDescription,
  CastSound, TargetSound, PreviewCursor, CastTextEvent, UseCosts, Intent, DamageType.
- **Ours:** SpellSchool (the parent has `Conjuration`), SpellProperties, TargetConditions, Icon (a suggestion),
  DisplayName, Description, ExtraDescription, ExtraDescriptionParams, TooltipDamageList,
  TooltipUpcastDescriptionParams, Spell Style Group, SpellFlags (drops the parent's `IsConcentration`, `IsHarmful` and
  the rest: the Cut targets allies too), HitAnimationType.
- The damage goes first and the Cut status last: the damage reads the position before Osiris takes the creature off.
  **TooltipUpcastDescription** is picked from the list by its name, *Additional damage* ("+[1] per slot level").

Numbers: `3d8` / `2d8` / `1d8` = `SPL_Kingmaker_AtroposCut#damage_fallen` / `#damage_falling` / `#damage_rising` and
`#damage_reigning`; `1d8` per slot level (TooltipUpcastDescriptionParams, and the variants' damage) = `#upcast_die`;
`18` = `#range`; level `2` = `#card_level`.

### 09 · NEW · SpellData / Shout · Rota Fortunae

| Field | `Shout_Arcana_Created_Aspect_RotaFortunae` |
|---|---|
| Name | `Arcana_Created_Aspect_RotaFortunae` |
| Using | `Arcana_Created_Aspect_TwoCups` |
| Level | `0` |
| SpellSchool | `Enchantment` |
| Cooldown | `OncePerCombat` |
| SpellProperties | `ApplyStatus(KINGMAKER_TURN_TECH,100,0)` |
| Icon | `Spell_Divination_DetectThoughts` |
| DisplayName | `Rota Fortunae` |
| Description | `Turn Fortune's wheel once more. Every creature on it moves one position onward.` |
| ExtraDescription | `Crossings happen as they do when the Wheel turns.<br><br>Once per combat.` |
| PreviewCursor | `Cast` |
| CastTextEvent | `Cast` |
| UseCosts | `ActionPoint:1` |
| Intent | `Control` |
| Spell Style Group | `Class` |
| SpellFlags | `IsSpell;HasVerbalComponent;HasSomaticComponent` |
| HitAnimationType | `MagicalNonDamage` |
| Requirements | `Combat` |

Notes (`Using` = `Arcana_Created_Aspect_TwoCups`; search `Arcana_Created_Aspect_TwoCups` in the picker — the Resonant's
Aspect card *The Two Cups*):
- **Copy from the parent in the Toolkit, then remove `Using`:** Spell Animation. Leave its AreaRadius, TargetConditions,
  DescriptionParams, TooltipDamageList and DamageType behind: without them the Shout lands on the Kingmaker (vanilla
  anchor: `Shout_Dash`) and Osiris turns the whole Wheel.
- **From the parent** (typed above too): Level, SpellSchool, Cooldown, PreviewCursor, CastTextEvent, UseCosts, Spell Style
  Group, SpellFlags, Requirements.
- **Ours:** SpellProperties, Icon (a suggestion), DisplayName, Description, ExtraDescription, Intent (the parent has
  `Damage`), HitAnimationType.
- No card marker: it is created by the Awakening, like The Two Cups.

Numbers: once per combat = `SPL_Kingmaker_RotaFortunae#uses`.

### 14 · Generated — do not type

| Family | Count | Built by | When |
|---|---|---|---|
| Upcast variants of Atropos' Cut, with their damage (`_3` 4d8/3d8/2d8 … `_6` 7d8/6d8/5d8) | 4 (`_3`…`_6`) | `82_Automation/stats/gen_upcast_variants.pl` (reads `upcast_die` in `25.01`) | after you save |
| Dethrone's variants get their damage (`_2` 4d6 … `_6` 8d6) — stage 1 had only the cost | 5 (existing) | same | after you save |
| Awakening progress statuses `ASPECT_PROGRESS_WHEEL_I` / `_II` / `_III`, the countdown rows in `ARCANA_Aspect_Common`, the Awakening passive's text | 3 + rows | `82_Automation/stats/gen_awakening_progress.pl` (WHEEL added) | after you save |
| `ARCANA_CardFamilies` rows for the new card | — | `gen_upcast_variants.pl` | after you save |

---

## 4 · Localisation summary

| Entry | Field | English text |
|---|---|---|
| `KINGMAKER_CROSSING_TECH`, `KINGMAKER_REIGNING_LINGER` | DisplayName, Description | §3 blocks 02–04 |
| `ASPECT_AWAKENED_WHEEL`, `_I` | DisplayName, Description | §3 block 05 |
| `Arcana_Passive_TheCrossing`, `…_WheelOfFortune_Awakening`, `…_WheelOfFortune_I` | DisplayName, Description | §3 blocks 06–07 |
| Atropos' Cut, Rota Fortunae | DisplayName, Description, ExtraDescription | §3 blocks 08–09 |

---

## 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt` (`0 error(s)`).
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0008`): I check every block against this guide, then run
   `sync_data`, `gen_upcast_variants.pl --apply`, `gen_awakening_progress.pl` (+ apply), `sort_stats.pl --apply`,
   `check_cards.pl` and `validate.pl`, and commit.
3. Play probes **P9–P16** of `SPEC_ARC-0008` stage 2 and tell me the results (and P1–P8 of stage 1, if not done yet).
4. Tick the steps in section 0.
