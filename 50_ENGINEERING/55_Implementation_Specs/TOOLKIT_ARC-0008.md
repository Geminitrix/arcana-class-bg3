---
id: TOOLKIT_ARC-0008
ticket: ARC-0008
spec: SPEC_ARC-0008
status: entered
derived_from: [25.01/SPL_Kingmaker_AtroposCut.yaml, 25.01/SPL_Kingmaker_Coronation.yaml, 25.01/SPL_Kingmaker_Dethrone.yaml, 25.01/SPL_Kingmaker_RotaFortunae.yaml, 25.01/SPL_Kingmaker_SpokeOfTheWheel.yaml, 25.01/SPL_Kingmaker_TurnTheSpoke.yaml, 25.02/FEAT_Kingmaker_AspectAwakening.yaml, 25.02/FEAT_Kingmaker_Crossing.yaml, 25.02/FEAT_Kingmaker_TheRota.yaml]
merged_from: [TOOLKIT_ARC-0008, TOOLKIT_ARC-0008_stage2]
author: Mod Engineer
---

# TOOLKIT_ARC-0008 · The Kingmaker — levels 1 and 3 (stages 1–2; levels 5–12 were applied by scripts)

> **One file for the whole build** (Owner, 2026-10-17): a part per level, in the order you type them. Type a level,
> then play that level's tests in `QA_ARC-0008`. Merged on 2026-10-17 from 2 files (`merged_from`); nothing removed.

## Contents

- The Kingmaker — stage 1: the Wheel core (level 1)
- The Kingmaker — stage 2: the Crossing (level 3)

---

# The Kingmaker — stage 1: the Wheel core (level 1)

> **What this file is.** The point-by-point guide to enter **stage 1** of `SPEC_ARC-0008` by hand in the BG3
> Toolkit: where to click, which entry to create or change, and what to type in every field. Later stages are added
> to this file when their part of the SPEC is written. Texts are drafts pending the Narrative gate
> (`32.01/Kingmaker_texts_with_params.md`).

---

### Rules for whoever writes this file

1. **Derived view (ADR-0005, ADR-0008).** Numbers live in `25_Master_Data`. The origin of every number is listed
   **under** its block (`3d6` = `SPL_Kingmaker_Dethrone#damage`). Regenerate this file
   when a file in `derived_from` changes; never edit a number here by hand.
2. **Order.** Section 0 is the checklist in the order the work has to happen.
3. **Stats Editor blocks:** one column per entry, **at most 3 entries per block**, one row per field. Rows follow
   **the Toolkit's own field order** (`_TEMPLATE_TOOLKIT_GUIDE.md`, *Toolkit field order*), with its labels
   (Spell Animation, Intent, Spell Style Group). Every row is a real field to fill, confirm or clear.
   **A cell holds only what is pasted**, as `code`, with no quotes and no notes (a double-click in the preview
   selects the whole cell; copy it and paste it into the Toolkit). `—` = leave the field empty. Notes go under the block.
4. **New entries: only the fields that matter** — every field with a value (ours, or the parent's, written out so
   the entry stays the same when `Using` is later removed) and every field that must be cleared because the parent
   has a value there. A field that stays empty and isn't set by the parent has no row. The
   **Notes** under each block name, per entry, the fields that come from the parent, the ones that are ours and the
   empty ones that clear a parent's value.
5. **Changed entries** (UUID Object Editor): only what changes, as `before → after`.
6. **Icons are suggestions** — check them in the Toolkit and pick a better one if you like; custom icons come later.
7. **UUIDs:** the Toolkit generates them; write the ones later steps need in the `UUID: ________` slots.
8. **Text:** every `DisplayName`, `Description` and `ExtraDescription` cell is a new localisation handle with that
   English text, tags (`<LSTag …>`, `<br>`) included. `[n]` in a Description reads
   `DescriptionParams`; in an ExtraDescription it reads `ExtraDescriptionParams` — each list starts at `[1]`.
9. **Generated families — do not type** (upcast variants).
10. **Osiris:** one copy-paste block per goal.
11. Names and syntax come from `SPEC_ARC-0008` (vanilla anchors cited there); parent values are read from the game
    files with the `using` chain resolved (Shared → SharedDev → Gustav → GustavDev → the mod).

---

### 0 · Order of work

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

### 1 · Stories (Osiris)

#### 14 · NEW goal `ARCANA_Kingmaker_Wheel` — parent goal: same as the other `ARCANA_` goals

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

### 2 · UUID Object Editor

#### 15 · NEW · Lists / SkillLists · "The Courtier"

| Field | Value |
|---|---|
| Name | `The Courtier` |
| Skills | `Persuasion;Intimidation;Insight;History;Deception;Performance;Arcana;Religion` |

UUID: ________ (used in 19)

#### 16 · NEW · Lists / SpellLists · "Kingmaker Level 1"

| Field | Value |
|---|---|
| Name | `Kingmaker Level 1` |
| Spells | `Projectile_Arcana_Card_Spell_SpokeOfTheWheel;Target_Arcana_Card_Spell_Coronation;Target_Arcana_Card_Spell_Dethrone;Target_Arcana_Card_Spell_TurnTheSpoke` |

UUID: ________ (used in 19)

#### 17 · CHANGED · ClassDescriptions · `bf046347-57d5-4774-87a6-13a4ebdddb0a` (Name `New_Stat_4`)

| Field | Before | After |
|---|---|---|
| NameFS | `Spinner` | `Kingmaker` |
| DisplayName | *the Spinner's handle* | `Kingmaker` |
| Description | *the Spinner's handle* | `Mystra wove the Kingmaker from the crowns that rise and fall on Fortune's wheel, a thread that decides who reigns. They bind friend and foe to the turning wheel, crown their allies as their enemies hit the bottom, and turn the whole wheel over when fortune runs against them.` |
| SoundClassType | `Warlock` | `Sorcerer` |

`ClassEquipment` stays `EQP_CC_Resonant` until you build the Kingmaker's gear (court clothes, rapier, hand crossbow).

#### 18 · CHANGED · Progressions / ProgressionDescriptions · `2cafa52b-8389-469d-8566-3f309ee632d6` (Name `New_Stat_11`)

| Field | Before | After |
|---|---|---|
| Type | `Spinner` | `Kingmaker` |
| DisplayName | — | `Kingmaker` |
| Description | — | `The Kingmaker turns the Weave into Fortune's wheel, raising allies to reign while their enemies fall.` |

#### 19 · CHANGED · Progressions / Progressions · `76a78614-8bc6-4450-96c4-bb40006bbaa5` (table `a688d11f…`, level 1)

| Field | Before | After |
|---|---|---|
| FSName | `Spinner` | `Kingmaker` |
| PassivesAdded | `Arcana_Passive_EmotionalAlchemy;Arcana_Passive_EmpathicSight` | `Arcana_Passive_TheRota` |
| Boosts | `ProficiencyBonus(SavingThrow,Wisdom);ProficiencyBonus(SavingThrow,Charisma);Proficiency(LightArmor);Proficiency(Daggers);Proficiency(Quarterstaffs);Proficiency(LightCrossbows);Proficiency(Darts)` | `ProficiencyBonus(SavingThrow,Charisma);ProficiencyBonus(SavingThrow,Wisdom);Proficiency(LightArmor);Proficiency(MediumArmor);Proficiency(SimpleWeapons);Proficiency(Rapiers);Proficiency(HandCrossbows)` |
| Selectors | `SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe,AbilityBonus,2,1);SelectSkills(df806fc1-79b4-7328-9e05-8726e513d941,4);SelectSkillsExpertise(f974ebd6-3725-4b90-bb5c-2b647d41615d,2);AddSpells(05269c79-116f-2b07-6dc1-deeefddc7ae4,,,,AlwaysPrepared)` | `SelectAbilityBonus(b9149c8e-52c8-46e5-9cb6-fc39301c05fe,AbilityBonus,2,1);SelectSkills(<UUID 15>,4);SelectSkillsExpertise(<UUID 15>,2);AddSpells(<UUID 16>,,,,AlwaysPrepared)` |

The other rows of the table (`FSName` Spinner, levels 2–12) change their `FSName` to `Kingmaker` as well; their content
comes in later stages.

#### 20 · CHANGED · CharacterCreationPresets / AbilityDistributionPresets · `6d9d9bc2-5b07-4909-8001-d19123561a19`

| Field | Before | After |
|---|---|---|
| Strength | `8` | `8` |
| Dexterity | `13` | `12` |
| Constitution | `15` | `13` |
| Intelligence | `10` | `15` |
| Wisdom | `10` | `8` |
| Charisma | `15` | `15` |
| Comment | `Spinner CHA / DEX` | `Kingmaker INT / CHA` |

#### 21 · CHANGED · DefaultValues / Skills · `a389eb39-c184-4fc3-b17b-fa5ac1c943f9`

| Field | Before | After |
|---|---|---|
| DefaultValues | `Insight;Persuasion;Medicine;Performance;Perception;Religion;AnimalHandling;Intimidation` | `Persuasion;Intimidation;Insight;History` |
| Comment | `The Spinner` | `The Kingmaker` |

(DefaultValues / Abilities `b12e3a18…` keeps `Intelligence;Charisma`; change only its Comment to `The Kingmaker Default Abilities`.)

---

### 3 · Stats Editor

**How to read the tables below.** Each column is one entry; each row is one field. **Every cell is exactly what you
paste** — double-click it in the preview, copy, paste into the Toolkit. `—` = leave the field empty. `DisplayName`,
`Description` and `ExtraDescription` cells are new localisation handles with that English text (tags included).

Under each block, **Notes** say, per entry, where each value comes from:

| Note | Meaning |
|---|---|
| **From the parent** | The `Using` parent already has exactly this value. Confirm it is there; when you later remove `Using`, type it in so the entry stays the same |
| **Ours** | Our value — type it (it replaces the parent's, if the parent has one) |
| **Clears the parent** | The cell is `—`, but the parent has a value: while `Using` is set, clear it in the Toolkit |

**Spell names** are typed **without** the type prefix: in `Projectile.stats` the Name is
`Arcana_Card_Spell_SpokeOfTheWheel` and the game id becomes `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` (the mod's
existing cards work the same way). Statuses and passives keep their full name. **`Using`** is given by the parent's name **without** its type prefix (the picker shows `Target_ShieldOfFaith`; search `ShieldOfFaith`).
Rows follow the Toolkit's field order and labels, and only the fields to fill, confirm or clear have a row. The numbers of each block, with their origin in `25` (ADR-0008), are listed under it.

#### 01–03 · NEW · StatusData / Status_BOOST · Rising, Reigning, Falling

| Field | `KINGMAKER_RISING` | `KINGMAKER_REIGNING` | `KINGMAKER_FALLING` |
|---|---|---|---|
| Name | `KINGMAKER_RISING` | `KINGMAKER_REIGNING` | `KINGMAKER_FALLING` |
| DisplayName | `Rising` | `Reigning` | `Falling` |
| Description | `Regnabo - 'I shall reign.' Moves faster and can't be knocked <LSTag Type="Status" Tooltip="PRONE">Prone</LSTag>.<br><br>Becomes Reigning when the Wheel next turns.` | `Regno - 'I reign.' Lands a <LSTag Tooltip="CriticalHit">Critical Hit</LSTag> on a roll of 19 or 20 and has <LSTag Tooltip="Advantage">Advantage</LSTag> on <LSTag Tooltip="SavingThrow">Saving Throws</LSTag>.<br><br>Becomes Falling when the Wheel next turns.` | `Regnavi - 'I have reigned.' Moves slower and subtracts [1] from <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag>.<br><br>Becomes Fallen when the Wheel next turns.` |
| DescriptionParams | — | — | `1d4` |
| Icon | `Spell_Transmutation_Longstrider` | `Spell_Enchantment_Bless` | `Spell_Enchantment_Bane` |
| StackId | `KINGMAKER_POSITION` | `KINGMAKER_POSITION` | `KINGMAKER_POSITION` |
| StackType | `Overwrite` | `Overwrite` | `Overwrite` |
| Boosts | `ActionResource(Movement,3,0);StatusImmunity(PRONE)` | `ReduceCriticalAttackThreshold(1);Advantage(AllSavingThrows)` | `ActionResource(Movement,-3,0);RollBonus(Attack,-1d4)` |
| StatusPropertyFlags | `ForceOverhead` | `ForceOverhead` | `ForceOverhead` |

Notes: Icons are suggestions. Rising and Reigning have no `[n]`, so their DescriptionParams stay empty.

Numbers: Rising `3` = `FEAT_Kingmaker_TheRota#rising_movement` · Reigning `1` (threshold 19) =
`…#reigning_crit_threshold` · Falling `-3` = `…#falling_movement`, `1d4` (Boosts and DescriptionParams) =
`…#falling_attack_penalty`. Vanilla anchors: `LONGSTRIDER`, `RAY_OF_FROST`, `BANE`, `ENLARGE` (DescriptionParams `1d4`).

#### 04–06 · NEW · StatusData / Status_BOOST · Fallen, King, Regent

| Field | `KINGMAKER_FALLEN` | `KINGMAKER_KING` | `KINGMAKER_REGENT` |
|---|---|---|---|
| Name | `KINGMAKER_FALLEN` | `KINGMAKER_KING` | `KINGMAKER_REGENT` |
| DisplayName | `Fallen` | `King` | `Regent` |
| Description | `Sum sine regno - 'I am without reign.' Attack Rolls against it have Advantage, and it can't take reactions.<br><br>Becomes Rising when the Wheel next turns.` | `Wears the crown of Fortune's wheel. The Kingmaker's Court serves the King.` | `Reigns beside the King without wearing the crown.` |
| Icon | `Status_Prone` | `Spell_Enchantment_CrownOfMadness` | `statIcons_AuraOfLeadership` |
| StackId | `KINGMAKER_POSITION` | `KINGMAKER_CROWN` | `KINGMAKER_CROWN` |
| StackType | `Overwrite` | `Overwrite` | `Overwrite` |
| Boosts | `Advantage(AttackTarget);ActionResourceBlock(ReactionActionPoint)` | — | — |
| StatusPropertyFlags | `ForceOverhead` | `ForceOverhead` | `ForceOverhead` |

Notes: Icons are suggestions.

No numbers in this block.

#### 07 · NEW · StatusData / Status_BOOST · the three technical statuses

| Field | `KINGMAKER_BIND_ALLY_TECH` | `KINGMAKER_BIND_ENEMY_TECH` | `KINGMAKER_STEP_TECH` |
|---|---|---|---|
| Name | `KINGMAKER_BIND_ALLY_TECH` | `KINGMAKER_BIND_ENEMY_TECH` | `KINGMAKER_STEP_TECH` |
| StackId | `KINGMAKER_BIND_ALLY_TECH` | `KINGMAKER_BIND_ENEMY_TECH` | `KINGMAKER_STEP_TECH` |
| StatusPropertyFlags | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |

No numbers. Pattern: the mod's `DOUBT_ADD_TECH`.

#### 08 · NEW · Stats / Passive · The Rota

| Field | `Arcana_Passive_TheRota` |
|---|---|
| Name | `Arcana_Passive_TheRota` |
| DisplayName | `The Rota` |
| Description | `Creatures you set on Fortune's wheel move one position at the start of your turn - Rising, Reigning, Falling, Fallen, and round again. They stay on the Wheel until they die, combat ends or you cut their thread.<br><br>The ally that has Reigned the longest wears the crown as the <LSTag Type="Status" Tooltip="KINGMAKER_KING">King</LSTag>.` |
| Icon | `Action_Mag_AuraOfLeadership` |
| Properties | `Highlighted` |

Notes: the Icon is a suggestion. `Highlighted` makes the passive visible on the character sheet.

No numbers.

#### 09 · NEW · SpellData / Projectile · Spoke of the Wheel (cantrip)

| Field | `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` |
|---|---|
| Name | `Arcana_Card_Spell_SpokeOfTheWheel` |
| Using | `FireBolt` |
| Level | `0` |
| SpellSchool | `Evocation` |
| SpellProperties | — |
| TargetFloor | `-1` |
| TargetRadius | `18` |
| SpellRoll | `Attack(AttackType.RangedSpellAttack)` |
| SpellSuccess | `DealDamage(LevelMapValue(D6Cantrip),Bludgeoning,Magical);IF(HasStatus('KINGMAKER_FALLING') or HasStatus('KINGMAKER_FALLEN')):DealDamage(1d4,Bludgeoning,Magical)` |
| TargetConditions | `not Self() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)` |
| ProjectileCount | `1` |
| Trajectories | `792ba497-a6ea-46bc-81cb-deb78e4dd9d3` |
| Icon | `Spell_Evocation_FireBolt` |
| DisplayName | `Spoke of the Wheel` |
| Description | `Hurl a spoke of Fortune's wheel at a foe.` |
| ExtraDescription | `Deals an additional [1] to a creature that is Falling or Fallen.` |
| ExtraDescriptionParams | `DealDamage(1d4,Bludgeoning)` |
| TooltipDamageList | `DealDamage(LevelMapValue(D6Cantrip),Bludgeoning)` |
| TooltipAttackSave | `RangedSpellAttack` |
| PrepareSound | `Spell_Prepare_Damage_Fire_Gen_L1to3` |
| PrepareLoopSound | `Spell_Prepare_Damage_Fire_Gen_L1to3_Loop` |
| CastSound | `Spell_Cast_Damage_Fire_FireBolt_L1to3` |
| PreviewCursor | `Cast` |
| CastTextEvent | `Cast` |
| CycleConditions | `Enemy() and not Dead()` |
| UseCosts | `ActionPoint:1` |
| Spell Animation | `3ff87abf-1ea1-4c32-aadf-c822d74c7dc0,,;,,;38cdb41c-2eec-4e03-bb31-83cff0346c35,,;85414f5f-b448-4dda-9370-1b6c4b38b561,,;d8925ce4-d6d9-400c-92f5-ad772ef7f178,,;,,;eadedcce-d01b-4fbb-a1ae-d218f13aa5d6,,;,,;,,` |
| Intent | `Damage` |
| SpellFlags | `HasVerbalComponent;HasSomaticComponent;IsSpell;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful` |
| HitAnimationType | `MagicalDamage_External` |
| PrepareEffect | `c88e9cfa-df92-477a-ae75-cbfb932350b4` |
| CastEffect | `e235ca47-1bf5-4587-9475-cf191b6005f9` |
| DamageType | `Bludgeoning` |

Notes (`Using` = `FireBolt`; search `FireBolt` in the picker):
- **From the parent:** Level, SpellSchool, TargetFloor, TargetRadius, SpellRoll, ProjectileCount, Trajectories, Icon
  (also a suggestion), TooltipAttackSave, PrepareSound, PrepareLoopSound, CastSound, PreviewCursor, CastTextEvent,
  CycleConditions, UseCosts, Spell Animation (the whole string), Intent, SpellFlags, HitAnimationType, PrepareEffect,
  CastEffect.
- **Ours:** SpellSuccess, TargetConditions, DisplayName, Description, ExtraDescription, ExtraDescriptionParams,
  TooltipDamageList, DamageType (the parent has `Fire`).
- **Clears the parent:** SpellProperties (the parent has `GROUND:SurfaceChange(Ignite);GROUND:SurfaceChange(Melt)`).

Numbers: `D6Cantrip` (1d6 / 2d6 at 5 / 3d6 at 10, vanilla level map) = `SPL_Kingmaker_SpokeOfTheWheel#damage` · `1d4`
(SpellSuccess, ExtraDescriptionParams) = `…#bonus_vs_falling_or_fallen` · `18` = `…#range`.
The fire look (sounds, effects) comes from Fire Bolt; swap them later if you find a better match.

#### 10–12 · NEW · SpellData / Target · Coronation, Dethrone, Turn the Spoke

| Field | `Target_Arcana_Card_Spell_Coronation` | `Target_Arcana_Card_Spell_Dethrone` | `Target_Arcana_Card_Spell_TurnTheSpoke` |
|---|---|---|---|
| Name | `Arcana_Card_Spell_Coronation` | `Arcana_Card_Spell_Dethrone` | `Arcana_Card_Spell_TurnTheSpoke` |
| Using | `ShieldOfFaith` | `DissonantWhispers` | `Arcana_Card_Spell_Temper` |
| Level | `1` | `1` | `0` |
| SpellSchool | `Enchantment` | `Enchantment` | `Enchantment` |
| SpellProperties | `ApplyStatus(KINGMAKER_BIND_ALLY_TECH,100,0)` | — | `ApplyStatus(KINGMAKER_STEP_TECH,100,0)` |
| TargetRadius | `18` | `18` | `18` |
| SpellRoll | — | `not SavingThrow(Ability.Charisma, SourceSpellDC())` | — |
| SpellSuccess | — | `DealDamage(3d6,Bludgeoning,Magical);ApplyStatus(KINGMAKER_BIND_ENEMY_TECH,100,0)` | — |
| SpellFail | — | `DealDamage((3d6)/2,Bludgeoning,Magical);ApplyStatus(KINGMAKER_BIND_ENEMY_TECH,100,0)` | — |
| TargetConditions | `(Ally() or Self()) and not Dead() and not HasStatus('KINGMAKER_RISING') and not HasStatus('KINGMAKER_REIGNING') and not HasStatus('KINGMAKER_FALLING') and not HasStatus('KINGMAKER_FALLEN') and not HasPassive('ARCANA_IS_CARD', context.Source)` | `Enemy() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)` | `not Dead() and (HasStatus('KINGMAKER_RISING') or HasStatus('KINGMAKER_REIGNING') or HasStatus('KINGMAKER_FALLING') or HasStatus('KINGMAKER_FALLEN')) and not HasPassive('ARCANA_IS_CARD', context.Source)` |
| AmountOfTargets | — | — | `1` |
| Icon | `Spell_Enchantment_CrownOfMadness` | `Spell_Enchantment_CommandGrovel` | `Spell_Enchantment_CalmEmotions` |
| DisplayName | `Coronation` | `Dethrone` | `Turn the Spoke` |
| Description | `Crown an ally or yourself and set them Rising on Fortune's wheel.` | `Cast an enemy down and set it Falling on Fortune's wheel.` | `Turn a creature on the Wheel one position onward.` |
| ExtraDescription | `The crowned creature stays on the Wheel until it dies, combat ends or its thread is cut.` | `On a successful <LSTag Tooltip="SavingThrow">Saving Throw</LSTag> the target takes half damage, but it still joins the Wheel.` | `The Wheel only turns forward.` |
| TooltipDamageList | — | `DealDamage(3d6,Bludgeoning)` | — |
| TooltipAttackSave | — | `Charisma` | — |
| TooltipStatusApply | `ApplyStatus(KINGMAKER_RISING,100,-1)` | `ApplyStatus(KINGMAKER_FALLING,100,-1)` | — |
| TooltipOnSave | — | `961753f4-c345-4bc4-b408-1d5b87a5ab0c` | — |
| TooltipUpcastDescription | — | `66388a6f-44dd-4c9f-a9e7-910c50e70755` | — |
| TooltipUpcastDescriptionParams | — | `DealDamage(1d6,Bludgeoning)` | — |
| PrepareSound | `Spell_Prepare_Damage_Radiant_Gen_L1to3` | — | `Spell_Prepare_Control_Gen_L1to3_01` |
| PrepareLoopSound | `Spell_Prepare_Damage_Radiant_Gen_L1to3_Loop` | — | `Spell_Prepare_Control_Gen_L1to3_01_Loop` |
| CastSound | `Spell_Cast_Buff_ShieldOfFaith_L1to3` | `Spell_Cast_Damage_Psychic_DissonantWhispers_L1to3` | `Spell_Cast_Control_CrownOfMadness_L1to3` |
| TargetSound | `Spell_Impact_Buff_ShieldOfFaith_L1to3` | `Spell_Impact_Damage_Psychic_DissonantWhispers_L1to3` | `Spell_Impact_Control_CrownOfMadness_L1to3` |
| VocalComponentSound | — | `Vocal_Component_DamagePsychicDiscordantMelody` | `Vocal_Component_Confuse` |
| PreviewCursor | `Cast` | — | `Cast` |
| CastTextEvent | `Cast` | `Cast` | `Cast` |
| CycleConditions | `Ally() and not Dead()` | `Enemy() and not Dead()` | — |
| UseCosts | `BonusActionPoint:1;SpellSlotsGroup:1:1:1` | `ActionPoint:1;SpellSlotsGroup:1:1:1` | `BonusActionPoint:1` |
| Spell Animation | `03496c4a-49e0-4132-b585-3e5ecd1ad8e5,,;,,;7abe77ed-9c77-4eac-872c-5b8caed070b6,,;cb171bda-f065-4520-b470-e447f678ba1f,,;a9682ef9-5d9e-4ac0-8144-2c7fe6eb868c,,;,,;32fb4d91-7fde-4b05-9144-ea87b9a4284a,,;2f5d8e0b-35f3-416f-99e9-1cc9d942204e,,;f2ec369f-4a3b-451e-b954-2ab0a53d51d6,,` | `3ff87abf-1ea1-4c32-aadf-c822d74c7dc0,,;,,;af94aac1-d8eb-4ccb-9520-694ade11b61c,,;f5db4001-b136-4c48-9aa4-026c4a7dd3b7,,;d8925ce4-d6d9-400c-92f5-ad772ef7f178,,;,,;eadedcce-d01b-4fbb-a1ae-d218f13aa5d6,,;,,;,,` | `554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;0149cfd3-d80f-4ce8-8cf7-234e0864ba46,,;1c58959b-8cb1-491d-89b7-2a7d0a593215,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,` |
| Intent | `Buff` | `Damage` | `Control` |
| Spell Style Group | `Class` | — | `Class` |
| SpellFlags | `HasVerbalComponent;HasSomaticComponent;IsSpell` | `HasVerbalComponent;IsSpell;IsHarmful` | `IsSpell;HasVerbalComponent;HasSomaticComponent` |
| HitAnimationType | `MagicalNonDamage` | `MagicalDamage_Psychic` | `MagicalNonDamage` |
| PrepareEffect | `60ec0a2d-1b72-4fb2-9eaf-571638aca25d` | `752219e2-351d-46ea-9448-3a714b3d3acc` | `2fa6b127-6f8a-4150-8be6-6f62b7a85911` |
| CastEffect | `1c5d1c5b-d8ff-42b5-8586-99aeaf901192` | `bd2fc245-5645-452f-a2cd-d158b751bbe4` | `4ca6a918-a46b-4269-b11b-d98fb6694677` |
| TargetEffect | `b76f528c-3b42-4283-a10d-d0217baf3c7c` | `a0aee53a-d702-4901-9bb3-7cf08e214346` | `4b5dc428-d623-4203-a7f0-a86c47bf9aa8` |
| DamageType | — | `Bludgeoning` | — |

Notes — **Coronation** (`Using` = `ShieldOfFaith`; search `ShieldOfFaith` in the picker):
- **From the parent:** Level, TargetRadius, PrepareSound, PrepareLoopSound, CastSound, TargetSound, PreviewCursor,
  CastTextEvent, CycleConditions, UseCosts, Spell Animation, Intent, Spell Style Group, HitAnimationType,
  PrepareEffect, CastEffect, TargetEffect.
- **Ours:** SpellSchool (the parent has `Abjuration`), SpellProperties, TargetConditions, DisplayName, Description,
  ExtraDescription, TooltipStatusApply, SpellFlags (drops the parent's `IsConcentration`). Icon is a suggestion.
- **Clears the parent:** TooltipUpcastDescription.

Notes — **Dethrone** (`Using` = `DissonantWhispers`; search `DissonantWhispers` in the picker):
- **From the parent:** Level, SpellSchool, TargetRadius, TooltipOnSave, TooltipUpcastDescription, CastSound,
  TargetSound, VocalComponentSound, CastTextEvent, CycleConditions, UseCosts, Spell Animation, Intent, SpellFlags,
  HitAnimationType, PrepareEffect, CastEffect, TargetEffect.
- **Ours:** SpellRoll, SpellSuccess, SpellFail, TargetConditions, DisplayName, Description, ExtraDescription,
  TooltipDamageList, TooltipAttackSave, TooltipStatusApply, TooltipUpcastDescriptionParams (the parent has `Psychic`),
  DamageType (the parent has `Psychic`). Icon is a suggestion.

Notes — **Turn the Spoke** (`Using` = `Arcana_Card_Spell_Temper`; search `Arcana_Card_Spell_Temper` in the picker):
- **From the parent:** Level, SpellSchool, TargetRadius, AmountOfTargets, Icon (also a suggestion), PrepareSound,
  PrepareLoopSound, CastSound, TargetSound, VocalComponentSound, PreviewCursor, CastTextEvent, UseCosts, Spell
  Animation, Intent, Spell Style Group, SpellFlags, HitAnimationType, PrepareEffect, CastEffect, TargetEffect.
- **Ours:** SpellProperties, TargetConditions, DisplayName, Description, ExtraDescription.
- **Clears the parent:** SpellRoll, SpellSuccess, SpellFail, TooltipAttackSave (the parent has `Wisdom`).

Coronation and Dethrone inherit `MemoryCost` `1` from their parents. The Toolkit doesn't show that field for
Target spells, and it does no harm: Arcana cards are always prepared (the Resonant's Emotion cards carry `1` too).

Numbers: Coronation `18` = `SPL_Kingmaker_Coronation#range`, `SpellSlotsGroup:1:1:1` level `1` = `…#card_level` ·
Dethrone `3d6` = `SPL_Kingmaker_Dethrone#damage`, `1d6` per slot level above 1 (TooltipUpcastDescriptionParams) = same
entry, `18` = `…#range` · Turn the Spoke `18` = `SPL_Kingmaker_TurnTheSpoke#range`, level `0` = `…#card_level`.

#### 13 · Generated — do not type

| Family | Count | Built by | Command |
|---|---|---|---|
| Upcast variants of Coronation and Dethrone (Dethrone gains 1d6 per slot level: `SPL_Kingmaker_Dethrone#damage`) | 5 each (`_2`…`_6`) | `82_Automation/stats/gen_upcast_variants.pl` | Claude runs it after you save, then `sort_stats.pl --apply` and `check_cards.pl` |

---

### 4 · Localisation summary

| Entry | Field | English text |
|---|---|---|
| ClassDescription | DisplayName / Description | "Kingmaker" / §2 item 17 |
| ProgressionDescription | DisplayName / Description | "Kingmaker" / §2 item 18 |
| `KINGMAKER_RISING`, `_REIGNING`, `_FALLING`, `_FALLEN` | DisplayName, Description | §3 items 01–04 |
| `KINGMAKER_KING`, `_REGENT` | DisplayName, Description | §3 items 05–06 |
| `Arcana_Passive_TheRota` | DisplayName, Description | §3 item 08 |
| Spoke of the Wheel, Coronation, Dethrone, Turn the Spoke | DisplayName, Description, ExtraDescription | §3 items 09–12 |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt`.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0008`): I run `sync_data`, the upcast generator,
   `sort_stats.pl --apply`, `check_cards.pl` and `validate.pl`, and commit.
3. Play probes **P1–P8** of `SPEC_ARC-0008` stage 1 and tell me the results.
4. Tick the steps in section 0.

---

# The Kingmaker — stage 2: the Crossing (level 3)

> **What this file is.** The point-by-point guide to enter **stage 2** of `SPEC_ARC-0008` by hand in the BG3
> Toolkit: *The Crossing*, *Atropos' Cut*, the Awakening *10 - Wheel of Fortune* with Tier I *Tyche*, and the Aspect
> card *Rota Fortunae*. Stage 1 is `TOOLKIT_ARC-0008.md` (entered 2026-10-14). Texts are drafts pending the Narrative
> gate (`32.01/Kingmaker_texts_with_params.md`).
>
> **Before you start:** stage 1's probes P1–P8 haven't been played yet. Stage 2 builds on the Wheel core; if a probe
> fails, tell me before typing this stage — the goal below replaces stage 1's and carries any fix.

---

### Rules for whoever writes this file

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

### 0 · Order of work

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

### 1 · Stories (Osiris)

#### 10 · CHANGED goal `ARCANA_Kingmaker_Wheel` — select all its text and paste this over it

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

#### 11 · CHANGED goal `ARCANA_Aspect_Common` — add 6 lines

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

### 2 · UUID Object Editor

#### 01 · NEW · Levelmaps / LevelMapValues · `Kingmaker_Crossing`

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

#### 12 · NEW · Lists / SpellLists · "Kingmaker Level 3"

| Field | Value |
|---|---|
| Name | `Kingmaker Level 3` |
| Spells | `Target_Arcana_Card_Spell_AtroposCut` |

UUID: ________ (used in 13)

#### 13 · CHANGED · Progressions / Progressions · `504e7b34-f08d-48d6-a817-4be73d9064c5` (table `a688d11f…`, level 3)

| Field | Before | After |
|---|---|---|
| PassivesAdded | — | `Arcana_Passive_TheCrossing;Arcana_Passive_Aspect_WheelOfFortune_Awakening;Arcana_Passive_Aspect_WheelOfFortune_I` |
| Selectors | — | `AddSpells(<UUID 12>,,,,AlwaysPrepared)` |

Same shape as the Resonant's level 3 (its Tier I passive, its Awakening passive, its level-3 list).

---

### 3 · Stats Editor

**How to read the tables below.** Each column is one entry; each row is one field. **Every cell is exactly what you
paste** — double-click it in the preview, copy, paste into the Toolkit. `—` = leave the field empty. `DisplayName`,
`Description` and `ExtraDescription` cells are new localisation handles with that English text (tags included).
**Spell names** are typed without the type prefix (`Arcana_Card_Spell_AtroposCut` in `Target.stats`; in stage 1 two
cards got the prefix twice — check the Name before saving). Rows follow the Toolkit's field order and labels; the
numbers of each block, with their origin in `25` (ADR-0008), are listed under it.

#### 02–03 · NEW · StatusData / Status_BOOST · the Crossing, the Cut and the turn

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

#### 04 · NEW · StatusData / Status_BOOST · `KINGMAKER_REIGNING_LINGER`

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

#### 05 · NEW · StatusData / Status_BOOST · the Awakening (Tier I)

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

#### 06–07 · NEW · Stats / Passive · The Crossing and the Awakening

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

#### 08 · NEW · SpellData / Target · Atropos' Cut

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

#### 09 · NEW · SpellData / Shout · Rota Fortunae

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

#### 14 · Generated — do not type

| Family | Count | Built by | When |
|---|---|---|---|
| Upcast variants of Atropos' Cut, with their damage (`_3` 4d8/3d8/2d8 … `_6` 7d8/6d8/5d8) | 4 (`_3`…`_6`) | `82_Automation/stats/gen_upcast_variants.pl` (reads `upcast_die` in `25.01`) | after you save |
| Dethrone's variants get their damage (`_2` 4d6 … `_6` 8d6) — stage 1 had only the cost | 5 (existing) | same | after you save |
| Awakening progress statuses `ASPECT_PROGRESS_WHEEL_I` / `_II` / `_III`, the countdown rows in `ARCANA_Aspect_Common`, the Awakening passive's text | 3 + rows | `82_Automation/stats/gen_awakening_progress.pl` (WHEEL added) | after you save |
| `ARCANA_CardFamilies` rows for the new card | — | `gen_upcast_variants.pl` | after you save |

---

### 4 · Localisation summary

| Entry | Field | English text |
|---|---|---|
| `KINGMAKER_CROSSING_TECH`, `KINGMAKER_REIGNING_LINGER` | DisplayName, Description | §3 blocks 02–04 |
| `ASPECT_AWAKENED_WHEEL`, `_I` | DisplayName, Description | §3 block 05 |
| `Arcana_Passive_TheCrossing`, `…_WheelOfFortune_Awakening`, `…_WheelOfFortune_I` | DisplayName, Description | §3 blocks 06–07 |
| Atropos' Cut, Rota Fortunae | DisplayName, Description, ExtraDescription | §3 blocks 08–09 |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt` (`0 error(s)`).
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0008`): I check every block against this guide, then run
   `sync_data`, `gen_upcast_variants.pl --apply`, `gen_awakening_progress.pl` (+ apply), `sort_stats.pl --apply`,
   `check_cards.pl` and `validate.pl`, and commit.
3. Play probes **P9–P16** of `SPEC_ARC-0008` stage 2 and tell me the results (and P1–P8 of stage 1, if not done yet).
4. Tick the steps in section 0.

