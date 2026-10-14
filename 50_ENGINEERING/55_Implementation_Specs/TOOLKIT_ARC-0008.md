---
id: TOOLKIT_ARC-0008
ticket: ARC-0008
spec: SPEC_ARC-0008
status: draft
derived_from: [25.01/SPL_Kingmaker_SpokeOfTheWheel.yaml, 25.01/SPL_Kingmaker_Coronation.yaml, 25.01/SPL_Kingmaker_Dethrone.yaml, 25.01/SPL_Kingmaker_TurnTheSpoke.yaml, 25.02/FEAT_Kingmaker_TheRota.yaml]
generated_at: 2026-10-13
author: Mod Engineer
---

# TOOLKIT_ARC-0008 · The Kingmaker — stage 1: the Wheel core (level 1)

> **What this file is.** The point-by-point guide to enter **stage 1** of `SPEC_ARC-0008` by hand in the BG3
> Toolkit: where to click, which entry to create or change, and what to type in every field. Later stages are added
> to this file when their part of the SPEC is written. Texts are drafts pending the Narrative gate
> (`55/_wip/Kingmaker/texts.md`).

---

## Rules for whoever writes this file

1. **Derived view (ADR-0005, ADR-0008).** Numbers live in `25_Master_Data`. Table cells hold only what is typed; the
   origin of every number is listed **under** its block (`3d6` = `SPL_Kingmaker_Dethrone#damage`). Regenerate this file
   when a file in `derived_from` changes; never edit a number here by hand.
2. **Order.** Section 0 is the checklist in the order the work has to happen.
3. **Stats Editor blocks:** one column per entry, **at most 3 entries per block**, one row per field, in the order the
   mod's existing entries show them. Every row is a real field to fill or to confirm.
4. **New entries: every field**, including the ones the `Using` parent already has — marked *(parent)* with the exact
   value — so the entry stays the same when `Using` is later removed (another mod changing the parent can't change
   ours). Fields to leave empty are listed as *(leave empty)*, with what they clear.
5. **Changed entries** (UUID Object Editor): only what changes, as `before → after`.
6. **Icons are suggestions** — check them in the Toolkit and pick a better one if you like; custom icons come later.
7. **UUIDs:** the Toolkit generates them; write the ones later steps need in the `UUID: ________` slots.
8. **Text:** English in quotes = a new localisation handle with that text. `[n]` in a Description reads
   `DescriptionParams`; in an ExtraDescription it reads `ExtraDescriptionParams` — each list starts at `[1]`.
9. **Generated families — do not type** (upcast variants).
10. **Osiris:** one copy-paste block per goal.
11. Names and syntax come from `SPEC_ARC-0008` (vanilla anchors cited there); parent values are read from the game
    files with the `using` chain resolved (Shared → SharedDev → Gustav → GustavDev → the mod).

---

## 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_RISING` | new | — | ☐ |
| 02 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_REIGNING` | new | — | ☐ |
| 03 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_FALLING` | new | — | ☐ |
| 04 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_FALLEN` | new | — | ☐ |
| 05 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_KING` | new | — | ☐ |
| 06 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_REGENT` | new | — | ☐ |
| 07 | Stats Editor | StatusData / Status_BOOST | `KINGMAKER_BIND_ALLY_TECH`, `KINGMAKER_BIND_ENEMY_TECH`, `KINGMAKER_STEP_TECH` | new (3) | — | ☐ |
| 08 | Stats Editor | Stats / Passive | `Arcana_Passive_TheRota` | new | — | ☐ |
| 09 | Stats Editor | SpellData / Projectile | `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` | new | 03, 04 | ☐ |
| 10 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_Coronation` | new | 07 | ☐ |
| 11 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_Dethrone` | new | 07 | ☐ |
| 12 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_TurnTheSpoke` | new | 01–04, 07 | ☐ |
| 13 | — | Generated | upcast variants of 10, 11 | run script | 10, 11 | ☐ |
| 14 | Stories | Goals | `ARCANA_Kingmaker_Wheel` | new goal | 01–07 | ☐ |
| 15 | UUID Object Editor | Lists / SkillLists | "The Courtier" | new | — | ☐ |
| 16 | UUID Object Editor | Lists / SpellLists | "Kingmaker Level 1" | new | 09–12 | ☐ |
| 17 | UUID Object Editor | ClassDescriptions | the Spinner entry | change | — | ☐ |
| 18 | UUID Object Editor | Progressions / ProgressionDescriptions | the Spinner entry | change | — | ☐ |
| 19 | UUID Object Editor | Progressions / Progressions | table `a688d11f…` level 1 | change | 08, 15, 16 | ☐ |
| 20 | UUID Object Editor | CharacterCreationPresets / AbilityDistributionPresets | the Spinner preset | change | — | ☐ |
| 21 | UUID Object Editor | DefaultValues / Skills | the Spinner defaults | change | 15 | ☐ |

---

## 1 · Stories (Osiris)

### 14 · NEW goal `ARCANA_Kingmaker_Wheel` — parent goal: same as the other `ARCANA_` goals

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION
PROC_ARCANA_Kingmaker_Init();

KBSECTION
// The Kingmaker's Wheel (ARC-0008, SPEC_ARC-0008 stage 1). Ledger: owner, creature, position, side (1 ally / 0 enemy,
// fixed at entry), entry order. The Wheel turns at the owner's turn start; one Kingmaker per Wheel in stage 1.
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
//END_REGION

//REGION Bind - Coronation (ally, Rising) and Dethrone (enemy, Falling)
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ALLY_TECH", _Owner, _)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "RISING", 1);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ENEMY_TECH", _Owner, _)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "FALLING", 0);

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
PROC_ARCANA_Kingmaker_Crown(_Owner);
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
//END_REGION

//REGION The Wheel turns at the owner's turn start
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
//END_REGION

//REGION Turn the Spoke - one step for one creature
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_STEP_TECH", _Owner, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
PROC_ARCANA_Kingmaker_Move(_Owner, _Creature);
PROC_ARCANA_Kingmaker_Crown(_Owner);
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
//END_REGION
EXITSECTION

ENDEXITSECTION
```

After pasting: **compile** in the Story Editor and read `Mods/AspectClass_…/Story/log.txt` — it must end with
`0 error(s)`. A warning such as *Database defined but never checked* is a defect: send me the log.

---

## 2 · UUID Object Editor

### 15 · NEW · Lists / SkillLists · "The Courtier"

| Field | Value |
|---|---|
| Name | `The Courtier` |
| Skills | `Persuasion;Intimidation;Insight;History;Deception;Performance;Arcana;Religion` |

UUID: ________ (used in 19)

### 16 · NEW · Lists / SpellLists · "Kingmaker Level 1"

| Field | Value |
|---|---|
| Name | `Kingmaker Level 1` |
| Spells | `Projectile_Arcana_Card_Spell_SpokeOfTheWheel;Target_Arcana_Card_Spell_Coronation;Target_Arcana_Card_Spell_Dethrone;Target_Arcana_Card_Spell_TurnTheSpoke` |

UUID: ________ (used in 19)

### 17 · CHANGED · ClassDescriptions · `bf046347-57d5-4774-87a6-13a4ebdddb0a` (Name `New_Stat_4`)

| Field | Before | After |
|---|---|---|
| NameFS | `Spinner` | `Kingmaker` |
| DisplayName | (Spinner handle) | "Kingmaker" (new handle) |
| Description | (Spinner handle) | "Mystra wove the Kingmaker from the crowns that rise and fall on Fortune's wheel, a thread that decides who reigns. They bind friend and foe to the turning wheel, crown their allies as their enemies hit the bottom, and turn the whole wheel over when fortune runs against them." (new handle) |
| SoundClassType | `Warlock` | `Sorcerer` |

`ClassEquipment` stays `EQP_CC_Resonant` until you build the Kingmaker's gear (court clothes, rapier, hand crossbow).

### 18 · CHANGED · Progressions / ProgressionDescriptions · `2cafa52b-8389-469d-8566-3f309ee632d6` (Name `New_Stat_11`)

| Field | Before | After |
|---|---|---|
| Type | `Spinner` | `Kingmaker` |
| DisplayName | — | "Kingmaker" (new handle) |
| Description | — | "The Kingmaker turns the Weave into Fortune's wheel, raising allies to reign while their enemies fall." (new handle) |

### 19 · CHANGED · Progressions / Progressions · `76a78614-8bc6-4450-96c4-bb40006bbaa5` (table `a688d11f…`, level 1)

| Field | Before | After |
|---|---|---|
| FSName | `Spinner` | `Kingmaker` |
| PassivesAdded | `Arcana_Passive_EmotionalAlchemy;Arcana_Passive_EmpathicSight` | `Arcana_Passive_TheRota` |
| Boosts | `ProficiencyBonus(SavingThrow,Wisdom);ProficiencyBonus(SavingThrow,Charisma);Proficiency(LightArmor);Proficiency(Daggers);Proficiency(Quarterstaffs);Proficiency(LightCrossbows);Proficiency(Darts)` | `ProficiencyBonus(SavingThrow,Charisma);ProficiencyBonus(SavingThrow,Wisdom);Proficiency(LightArmor);Proficiency(MediumArmor);Proficiency(SimpleWeapons);Proficiency(Rapiers);Proficiency(HandCrossbows)` |
| Selectors | `SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe,AbilityBonus,2,1);SelectSkills(df806fc1-79b4-7328-9e05-8726e513d941,4);SelectSkillsExpertise(f974ebd6-3725-4b90-bb5c-2b647d41615d,2);AddSpells(05269c79-116f-2b07-6dc1-deeefddc7ae4,,,,AlwaysPrepared)` | `SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe,AbilityBonus,2,1);SelectSkills(<UUID 15>,4);SelectSkillsExpertise(<UUID 15>,2);AddSpells(<UUID 16>,,,,AlwaysPrepared)` |

The other rows of the table (`FSName` Spinner, levels 2–12) change their `FSName` to `Kingmaker` as well; their content
comes in later stages.

### 20 · CHANGED · CharacterCreationPresets / AbilityDistributionPresets · `6d9d9bc2-5b07-4909-8001-d19123561a19`

| Field | Before | After |
|---|---|---|
| Strength | 8 | 8 |
| Dexterity | 13 | **12** |
| Constitution | 15 | **13** |
| Intelligence | 10 | **15** |
| Wisdom | 10 | **8** |
| Charisma | 15 | 15 |
| Comment | `Spinner CHA / DEX` | `Kingmaker INT / CHA` |

### 21 · CHANGED · DefaultValues / Skills · `a389eb39-c184-4fc3-b17b-fa5ac1c943f9`

| Field | Before | After |
|---|---|---|
| DefaultValues | `Insight;Persuasion;Medicine;Performance;Perception;Religion;AnimalHandling;Intimidation` | `Persuasion;Intimidation;Insight;History` |
| Comment | `The Spinner` | `The Kingmaker` |

(DefaultValues / Abilities `b12e3a18…` keeps `Intelligence;Charisma`; change only its Comment to `The Kingmaker Default Abilities`.)

---

## 3 · Stats Editor

**How to read the tables below.** Each column is one entry; each row is one field to fill, in the order the mod's
existing entries show them. **Type only what is inside `code` or "quotes"** — the italic tag after it is a note:

| Tag | Meaning |
|---|---|
| *(parent)* | The `Using` parent already has exactly this value. Confirm it is there; when you later remove `Using`, type it in so the entry stays the same |
| *(ours)* | Our value — type it (it replaces the parent's, if the parent has one) |
| *(leave empty)* | Leave the field empty; while `Using` is set, clear the parent's value if the Toolkit shows one |
| "…" | A new localisation handle with this English text |

**Spell names** are typed **without** the type prefix: in `Projectile.stats` the Name is
`Arcana_Card_Spell_SpokeOfTheWheel` and the game id becomes `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` (the mod's
existing cards work the same way). Statuses and passives keep their full name. **`Using`** is chosen in the Toolkit's
picker by the parent's name. The numbers of each block, with their origin in `25` (ADR-0008), are listed under it.

### 01–03 · NEW · StatusData / Status_BOOST · Rising, Reigning, Falling

| Field | `KINGMAKER_RISING` | `KINGMAKER_REIGNING` | `KINGMAKER_FALLING` |
|---|---|---|---|
| Name | `KINGMAKER_RISING` | `KINGMAKER_REIGNING` | `KINGMAKER_FALLING` |
| DisplayName | "Rising" | "Reigning" | "Falling" |
| Description | "Regnabo - 'I shall reign.' Moves faster and can't be knocked <LSTag Type="Status" Tooltip="PRONE">Prone</LSTag>.<br><br>Becomes Reigning when the Wheel next turns." | "Regno - 'I reign.' Lands a <LSTag Tooltip="CriticalHit">Critical Hit</LSTag> on a roll of 19 or 20 and has <LSTag Tooltip="Advantage">Advantage</LSTag> on <LSTag Tooltip="SavingThrow">Saving Throws</LSTag>.<br><br>Becomes Falling when the Wheel next turns." | "Regnavi - 'I have reigned.' Moves slower and subtracts [1] from <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag>.<br><br>Becomes Fallen when the Wheel next turns." |
| DescriptionParams | *(leave empty)* | *(leave empty)* | `1d4` |
| Icon | `Spell_Transmutation_Longstrider` *(suggestion)* | `Spell_Enchantment_Bless` *(suggestion)* | `Spell_Enchantment_Bane` *(suggestion)* |
| StackId | `KINGMAKER_POSITION` | `KINGMAKER_POSITION` | `KINGMAKER_POSITION` |
| StackType | `Overwrite` | `Overwrite` | `Overwrite` |
| Boosts | `ActionResource(Movement,3,0);StatusImmunity(PRONE)` | `ReduceCriticalAttackThreshold(1);Advantage(AllSavingThrows)` | `ActionResource(Movement,-3,0);RollBonus(Attack,-1d4)` |
| StatusPropertyFlags | `ForceOverhead` | `ForceOverhead` | `ForceOverhead` |

Numbers: Rising `3` = `FEAT_Kingmaker_TheRota#rising_movement` · Reigning `1` (threshold 19) =
`…#reigning_crit_threshold` · Falling `-3` = `…#falling_movement`, `1d4` (Boosts and DescriptionParams) =
`…#falling_attack_penalty`. Vanilla anchors: `LONGSTRIDER`, `RAY_OF_FROST`, `BANE`, `ENLARGE` (DescriptionParams `1d4`).

### 04–06 · NEW · StatusData / Status_BOOST · Fallen, King, Regent

| Field | `KINGMAKER_FALLEN` | `KINGMAKER_KING` | `KINGMAKER_REGENT` |
|---|---|---|---|
| Name | `KINGMAKER_FALLEN` | `KINGMAKER_KING` | `KINGMAKER_REGENT` |
| DisplayName | "Fallen" | "King" | "Regent" |
| Description | "Sum sine regno - 'I am without reign.' Attack Rolls against it have Advantage, and it can't take reactions.<br><br>Becomes Rising when the Wheel next turns." | "Wears the crown of Fortune's wheel. The Kingmaker's Court serves the King." | "Reigns beside the King without wearing the crown." |
| DescriptionParams | *(leave empty)* | *(leave empty)* | *(leave empty)* |
| Icon | `Status_Prone` *(suggestion)* | `Spell_Enchantment_CrownOfMadness` *(suggestion)* | `statIcons_AuraOfLeadership` *(suggestion)* |
| StackId | `KINGMAKER_POSITION` | `KINGMAKER_CROWN` | `KINGMAKER_CROWN` |
| StackType | `Overwrite` | `Overwrite` | `Overwrite` |
| Boosts | `Advantage(AttackTarget);ActionResourceBlock(ReactionActionPoint)` | *(leave empty)* | *(leave empty)* |
| StatusPropertyFlags | `ForceOverhead` | `ForceOverhead` | `ForceOverhead` |

No numbers in this block.

### 07 · NEW · StatusData / Status_BOOST · the three technical statuses

| Field | `KINGMAKER_BIND_ALLY_TECH` | `KINGMAKER_BIND_ENEMY_TECH` | `KINGMAKER_STEP_TECH` |
|---|---|---|---|
| Name | `KINGMAKER_BIND_ALLY_TECH` | `KINGMAKER_BIND_ENEMY_TECH` | `KINGMAKER_STEP_TECH` |
| DisplayName | *(leave empty)* | *(leave empty)* | *(leave empty)* |
| Description | *(leave empty)* | *(leave empty)* | *(leave empty)* |
| Icon | *(leave empty)* | *(leave empty)* | *(leave empty)* |
| StackId | `KINGMAKER_BIND_ALLY_TECH` | `KINGMAKER_BIND_ENEMY_TECH` | `KINGMAKER_STEP_TECH` |
| StatusPropertyFlags | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |

No numbers. Pattern: the mod's `DOUBT_ADD_TECH`.

### 08 · NEW · Stats / Passive · The Rota

| Field | `Arcana_Passive_TheRota` |
|---|---|
| Name | `Arcana_Passive_TheRota` |
| DisplayName | "The Rota" |
| Description | "Creatures you set on Fortune's wheel move one position at the start of your turn - Rising, Reigning, Falling, Fallen, and round again. They stay on the Wheel until they die, combat ends or you cut their thread.<br><br>The ally that has Reigned the longest wears the crown as the <LSTag Type="Status" Tooltip="KINGMAKER_KING">King</LSTag>." |
| Icon | `Action_Mag_AuraOfLeadership` *(suggestion)* |
| Properties | `Highlighted` |

No numbers.

### 09 · NEW · SpellData / Projectile · Spoke of the Wheel (cantrip)

| Field | `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` |
|---|---|
| Name | `Arcana_Card_Spell_SpokeOfTheWheel` |
| Using | `Projectile_FireBolt` (picker) |
| Level | `0` *(parent)* |
| SpellSchool | `Evocation` *(parent)* |
| TargetRadius | `18` *(parent)* |
| SpellRoll | `Attack(AttackType.RangedSpellAttack)` *(parent)* |
| SpellSuccess | `DealDamage(LevelMapValue(D6Cantrip),Bludgeoning,Magical);IF(HasStatus('KINGMAKER_FALLING') or HasStatus('KINGMAKER_FALLEN')):DealDamage(1d4,Bludgeoning,Magical)` *(ours)* |
| SpellProperties | *(leave empty — clears the parent's `GROUND:SurfaceChange(Ignite);GROUND:SurfaceChange(Melt)`)* |
| TargetConditions | `not Self() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)` *(ours)* |
| CycleConditions | `Enemy() and not Dead()` *(parent)* |
| DisplayName | "Spoke of the Wheel" *(ours)* |
| Description | "Hurl a spoke of Fortune's wheel at a foe." *(ours)* |
| DescriptionParams | *(leave empty — the Description has no `[n]`)* |
| ExtraDescription | "Deals an additional [1] to a creature that is Falling or Fallen." *(ours)* |
| ExtraDescriptionParams | `DealDamage(1d4,Bludgeoning)` *(ours)* |
| Icon | `Spell_Evocation_FireBolt` *(parent; suggestion)* |
| TooltipDamageList | `DealDamage(LevelMapValue(D6Cantrip),Bludgeoning)` *(ours)* |
| TooltipAttackSave | `RangedSpellAttack` *(parent)* |
| ProjectileCount | `1` *(parent)* |
| Trajectories | `792ba497-a6ea-46bc-81cb-deb78e4dd9d3` *(parent)* |
| TargetFloor | `-1` *(parent)* |
| PrepareSound | `Spell_Prepare_Damage_Fire_Gen_L1to3` *(parent)* |
| PrepareLoopSound | `Spell_Prepare_Damage_Fire_Gen_L1to3_Loop` *(parent)* |
| CastSound | `Spell_Cast_Damage_Fire_FireBolt_L1to3` *(parent)* |
| SpellAnimation | `3ff87abf-1ea1-4c32-aadf-c822d74c7dc0,,;,,;38cdb41c-2eec-4e03-bb31-83cff0346c35,,;85414f5f-b448-4dda-9370-1b6c4b38b561,,;d8925ce4-d6d9-400c-92f5-ad772ef7f178,,;,,;eadedcce-d01b-4fbb-a1ae-d218f13aa5d6,,;,,;,,` *(parent)* |
| PrepareEffect | `c88e9cfa-df92-477a-ae75-cbfb932350b4` *(parent)* |
| CastEffect | `e235ca47-1bf5-4587-9475-cf191b6005f9` *(parent)* |
| PreviewCursor | `Cast` *(parent)* |
| CastTextEvent | `Cast` *(parent)* |
| UseCosts | `ActionPoint:1` *(parent)* |
| VerbalIntent | `Damage` *(parent)* |
| SpellFlags | `HasVerbalComponent;HasSomaticComponent;IsSpell;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful` *(parent)* |
| HitAnimationType | `MagicalDamage_External` *(parent)* |
| DamageType | `Bludgeoning` *(ours; the parent has `Fire`)* |

Numbers: `D6Cantrip` (1d6 / 2d6 at 5 / 3d6 at 10, vanilla level map) = `SPL_Kingmaker_SpokeOfTheWheel#damage` · `1d4`
(SpellSuccess, ExtraDescriptionParams) = `…#bonus_vs_falling_or_fallen` · `18` = `…#range`.
The fire look (sounds, effects) comes from Fire Bolt; swap them later if you find a better match.

### 10–12 · NEW · SpellData / Target · Coronation, Dethrone, Turn the Spoke

| Field | `Target_Arcana_Card_Spell_Coronation` | `Target_Arcana_Card_Spell_Dethrone` | `Target_Arcana_Card_Spell_TurnTheSpoke` |
|---|---|---|---|
| Name | `Arcana_Card_Spell_Coronation` | `Arcana_Card_Spell_Dethrone` | `Arcana_Card_Spell_TurnTheSpoke` |
| Using | `Target_ShieldOfFaith` (picker) | `Target_DissonantWhispers` (picker) | the Temper card (picker; shown as `Arcana_Card_Spell_Temper`) |
| Level | `1` *(parent)* | `1` *(parent)* | `0` *(parent)* |
| SpellSchool | `Enchantment` *(ours; parent `Abjuration`)* | `Enchantment` *(parent)* | `Enchantment` *(parent)* |
| TargetRadius | `18` *(parent)* | `18` *(parent)* | `18` *(parent)* |
| AmountOfTargets | *(leave empty)* | *(leave empty)* | `1` *(parent)* |
| SpellRoll | *(leave empty)* | `not SavingThrow(Ability.Charisma, SourceSpellDC())` *(ours)* | *(leave empty — clears the parent's)* |
| SpellSuccess | *(leave empty)* | `DealDamage(3d6,Bludgeoning,Magical);ApplyStatus(KINGMAKER_BIND_ENEMY_TECH,100,0)` *(ours)* | *(leave empty — clears the parent's)* |
| SpellFail | *(leave empty)* | `DealDamage((3d6)/2,Bludgeoning,Magical);ApplyStatus(KINGMAKER_BIND_ENEMY_TECH,100,0)` *(ours)* | *(leave empty — clears the parent's)* |
| SpellProperties | `ApplyStatus(KINGMAKER_BIND_ALLY_TECH,100,0)` *(ours)* | *(leave empty)* | `ApplyStatus(KINGMAKER_STEP_TECH,100,0)` *(ours)* |
| TargetConditions | `(Ally() or Self()) and not Dead() and not HasStatus('KINGMAKER_RISING') and not HasStatus('KINGMAKER_REIGNING') and not HasStatus('KINGMAKER_FALLING') and not HasStatus('KINGMAKER_FALLEN') and not HasPassive('ARCANA_IS_CARD', context.Source)` *(ours)* | `Enemy() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)` *(ours)* | `not Dead() and (HasStatus('KINGMAKER_RISING') or HasStatus('KINGMAKER_REIGNING') or HasStatus('KINGMAKER_FALLING') or HasStatus('KINGMAKER_FALLEN')) and not HasPassive('ARCANA_IS_CARD', context.Source)` *(ours)* |
| CycleConditions | `Ally() and not Dead()` *(parent)* | `Enemy() and not Dead()` *(parent)* | *(leave empty)* |
| DisplayName | "Coronation" *(ours)* | "Dethrone" *(ours)* | "Turn the Spoke" *(ours)* |
| Description | "Crown an ally or yourself and set them Rising on Fortune's wheel." *(ours)* | "Cast an enemy down and set it Falling on Fortune's wheel." *(ours)* | "Turn a creature on the Wheel one position onward." *(ours)* |
| DescriptionParams | *(leave empty)* | *(leave empty)* | *(leave empty)* |
| ExtraDescription | "The crowned creature stays on the Wheel until it dies, combat ends or its thread is cut." *(ours)* | "On a successful <LSTag Tooltip="SavingThrow">Saving Throw</LSTag> the target takes half damage, but it still joins the Wheel." *(ours)* | "The Wheel only turns forward." *(ours)* |
| Icon | `Spell_Enchantment_CrownOfMadness` *(suggestion)* | `Spell_Enchantment_CommandGrovel` *(suggestion)* | `Spell_Enchantment_CalmEmotions` *(parent; suggestion)* |
| TooltipDamageList | *(leave empty)* | `DealDamage(3d6,Bludgeoning)` *(ours)* | *(leave empty)* |
| TooltipAttackSave | *(leave empty)* | `Charisma` *(ours)* | *(leave empty — clears the parent's `Wisdom`)* |
| TooltipStatusApply | `ApplyStatus(KINGMAKER_RISING,100,-1)` *(ours)* | `ApplyStatus(KINGMAKER_FALLING,100,-1)` *(ours)* | *(leave empty)* |
| TooltipOnSave | *(leave empty)* | `961753f4-c345-4bc4-b408-1d5b87a5ab0c` *(parent)* | *(leave empty)* |
| TooltipUpcastDescription | *(leave empty — clears the parent's)* | `66388a6f-44dd-4c9f-a9e7-910c50e70755` *(parent)* | *(leave empty)* |
| TooltipUpcastDescriptionParams | *(leave empty)* | `DealDamage(1d6,Bludgeoning)` *(ours; parent `Psychic`)* | *(leave empty)* |
| PrepareSound | `Spell_Prepare_Damage_Radiant_Gen_L1to3` *(parent)* | *(leave empty)* | `Spell_Prepare_Control_Gen_L1to3_01` *(parent)* |
| PrepareLoopSound | `Spell_Prepare_Damage_Radiant_Gen_L1to3_Loop` *(parent)* | *(leave empty)* | `Spell_Prepare_Control_Gen_L1to3_01_Loop` *(parent)* |
| CastSound | `Spell_Cast_Buff_ShieldOfFaith_L1to3` *(parent)* | `Spell_Cast_Damage_Psychic_DissonantWhispers_L1to3` *(parent)* | `Spell_Cast_Control_CrownOfMadness_L1to3` *(parent)* |
| TargetSound | `Spell_Impact_Buff_ShieldOfFaith_L1to3` *(parent)* | `Spell_Impact_Damage_Psychic_DissonantWhispers_L1to3` *(parent)* | `Spell_Impact_Control_CrownOfMadness_L1to3` *(parent)* |
| VocalComponentSound | *(leave empty)* | `Vocal_Component_DamagePsychicDiscordantMelody` *(parent)* | `Vocal_Component_Confuse` *(parent)* |
| SpellAnimation | `03496c4a-49e0-4132-b585-3e5ecd1ad8e5,,;,,;7abe77ed-9c77-4eac-872c-5b8caed070b6,,;cb171bda-f065-4520-b470-e447f678ba1f,,;a9682ef9-5d9e-4ac0-8144-2c7fe6eb868c,,;,,;32fb4d91-7fde-4b05-9144-ea87b9a4284a,,;2f5d8e0b-35f3-416f-99e9-1cc9d942204e,,;f2ec369f-4a3b-451e-b954-2ab0a53d51d6,,` *(parent)* | `3ff87abf-1ea1-4c32-aadf-c822d74c7dc0,,;,,;af94aac1-d8eb-4ccb-9520-694ade11b61c,,;f5db4001-b136-4c48-9aa4-026c4a7dd3b7,,;d8925ce4-d6d9-400c-92f5-ad772ef7f178,,;,,;eadedcce-d01b-4fbb-a1ae-d218f13aa5d6,,;,,;,,` *(parent)* | `554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;0149cfd3-d80f-4ce8-8cf7-234e0864ba46,,;1c58959b-8cb1-491d-89b7-2a7d0a593215,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,` *(parent)* |
| PrepareEffect | `60ec0a2d-1b72-4fb2-9eaf-571638aca25d` *(parent)* | `752219e2-351d-46ea-9448-3a714b3d3acc` *(parent)* | `2fa6b127-6f8a-4150-8be6-6f62b7a85911` *(parent)* |
| CastEffect | `1c5d1c5b-d8ff-42b5-8586-99aeaf901192` *(parent)* | `bd2fc245-5645-452f-a2cd-d158b751bbe4` *(parent)* | `4ca6a918-a46b-4269-b11b-d98fb6694677` *(parent)* |
| TargetEffect | `b76f528c-3b42-4283-a10d-d0217baf3c7c` *(parent)* | `a0aee53a-d702-4901-9bb3-7cf08e214346` *(parent)* | `4b5dc428-d623-4203-a7f0-a86c47bf9aa8` *(parent)* |
| PreviewCursor | `Cast` *(parent)* | *(leave empty)* | `Cast` *(parent)* |
| CastTextEvent | `Cast` *(parent)* | `Cast` *(parent)* | `Cast` *(parent)* |
| UseCosts | `BonusActionPoint:1;SpellSlotsGroup:1:1:1` *(parent)* | `ActionPoint:1;SpellSlotsGroup:1:1:1` *(parent)* | `BonusActionPoint:1` *(parent)* |
| VerbalIntent | `Buff` *(parent)* | `Damage` *(parent)* | `Control` *(parent)* |
| SpellStyleGroup | `Class` *(parent)* | *(leave empty)* | `Class` *(parent)* |
| SpellFlags | `HasVerbalComponent;HasSomaticComponent;IsSpell` *(ours; drops the parent's `IsConcentration`)* | `HasVerbalComponent;IsSpell;IsHarmful` *(parent)* | `IsSpell;HasVerbalComponent;HasSomaticComponent` *(parent)* |
| HitAnimationType | `MagicalNonDamage` *(parent)* | `MagicalDamage_Psychic` *(parent)* | `MagicalNonDamage` *(parent)* |
| MemoryCost | *(leave empty — clears the parent's `1`; Arcana cards are always prepared)* | *(leave empty — clears the parent's `1`)* | *(leave empty)* |
| DamageType | *(leave empty)* | `Bludgeoning` *(ours; the parent has `Psychic`)* | *(leave empty)* |

Numbers: Coronation `18` = `SPL_Kingmaker_Coronation#range`, `SpellSlotsGroup:1:1:1` level `1` = `…#card_level` ·
Dethrone `3d6` = `SPL_Kingmaker_Dethrone#damage`, `1d6` per slot level above 1 (TooltipUpcastDescriptionParams) = same
entry, `18` = `…#range` · Turn the Spoke `18` = `SPL_Kingmaker_TurnTheSpoke#range`, level `0` = `…#card_level`.

### 13 · Generated — do not type

| Family | Count | Built by | Command |
|---|---|---|---|
| Upcast variants of Coronation and Dethrone (Dethrone gains 1d6 per slot level: `SPL_Kingmaker_Dethrone#damage`) | 5 each (`_2`…`_6`) | `82_Automation/stats/gen_upcast_variants.pl` | Claude runs it after you save, then `sort_stats.pl --apply` and `check_cards.pl` |

---

## 4 · Localisation summary

| Entry | Field | English text |
|---|---|---|
| ClassDescription | DisplayName / Description | "Kingmaker" / §2 item 17 |
| ProgressionDescription | DisplayName / Description | "Kingmaker" / §2 item 18 |
| `KINGMAKER_RISING`, `_REIGNING`, `_FALLING`, `_FALLEN` | DisplayName, Description | §3 items 01–04 |
| `KINGMAKER_KING`, `_REGENT` | DisplayName, Description | §3 items 05–06 |
| `Arcana_Passive_TheRota` | DisplayName, Description | §3 item 08 |
| Spoke of the Wheel, Coronation, Dethrone, Turn the Spoke | DisplayName, Description, ExtraDescription | §3 items 09–12 |

---

## 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt`.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0008`): I run `sync_data`, the upcast generator,
   `sort_stats.pl --apply`, `check_cards.pl` and `validate.pl`, and commit.
3. Play probes **P1–P8** of `SPEC_ARC-0008` stage 1 and tell me the results.
4. Tick the steps in section 0.
