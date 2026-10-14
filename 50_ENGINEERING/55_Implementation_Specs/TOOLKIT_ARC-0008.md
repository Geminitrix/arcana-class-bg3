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

1. **Derived view (ADR-0005, ADR-0008).** Numbers live in `25_Master_Data`. Every number here shows its value **and its
   origin**: `3d6 · SPL_Kingmaker_Dethrone#damage`. Regenerate this file when a file in `derived_from` changes; never
   edit a number here by hand.
2. **Order.** Section 0 is the checklist in the order the work has to happen.
3. **New entries: every field** the Owner fills, in Toolkit order. Empty fields are not listed.
4. **Changed entries: only what changes**, as `before → after`.
5. **`Using` (parent):** fields from the parent are not repeated; only overrides are listed.
6. **Icons are suggestions** — check them in the Toolkit and pick a better one if you like; custom icons come later.
7. **UUIDs:** the Toolkit generates them; write the ones later steps need in the `UUID: ________` slots.
8. **Text:** English in quotes = a new localisation handle with that text.
9. **Generated families — do not type** (upcast variants).
10. **Osiris:** one copy-paste block per goal.
11. Names and syntax come from `SPEC_ARC-0008` (vanilla anchors cited there).

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

### 01–04 · NEW · StatusData / Status_BOOST · the four positions

Same fields for all four; only the ones in the table change.

| Field | Value (all four) |
|---|---|
| StackId | `KINGMAKER_POSITION` |
| StackType | `Overwrite` |
| StatusPropertyFlags | `ForceOverhead` |

| Name | DisplayName | Description | Boosts | Icon (suggestion) |
|---|---|---|---|---|
| `KINGMAKER_RISING` | "Rising" | "Regnabo - 'I shall reign.' Moves faster and can't be knocked <LSTag Type="Status" Tooltip="PRONE">Prone</LSTag>.<br><br>Becomes Reigning when the Wheel next turns." | `ActionResource(Movement,3,0);StatusImmunity(PRONE)` — `3 · FEAT_Kingmaker_TheRota#rising_movement` | `Spell_Transmutation_Longstrider` |
| `KINGMAKER_REIGNING` | "Reigning" | "Regno - 'I reign.' Lands a <LSTag Tooltip="CriticalHit">Critical Hit</LSTag> on a roll of 19 or 20 and has <LSTag Tooltip="Advantage">Advantage</LSTag> on <LSTag Tooltip="SavingThrow">Saving Throws</LSTag>.<br><br>Becomes Falling when the Wheel next turns." | `ReduceCriticalAttackThreshold(1);Advantage(AllSavingThrows)` — `19 · FEAT_Kingmaker_TheRota#reigning_crit_threshold` | `Spell_Enchantment_Bless` |
| `KINGMAKER_FALLING` | "Falling" | "Regnavi - 'I have reigned.' Moves slower and subtracts [1] from <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag>.<br><br>Becomes Fallen when the Wheel next turns." · DescriptionParams `1d4` | `ActionResource(Movement,-3,0);RollBonus(Attack,-1d4)` — `-3 · …#falling_movement`, `1d4 · …#falling_attack_penalty` | `Spell_Enchantment_Bane` |
| `KINGMAKER_FALLEN` | "Fallen" | "Sum sine regno - 'I am without reign.' Attack Rolls against it have Advantage, and it can't take reactions.<br><br>Becomes Rising when the Wheel next turns." | `Advantage(AttackTarget);ActionResourceBlock(ReactionActionPoint)` | `Status_Prone` |

### 05–06 · NEW · StatusData / Status_BOOST · the crown

| Field | `KINGMAKER_KING` | `KINGMAKER_REGENT` |
|---|---|---|
| DisplayName | "King" | "Regent" |
| Description | "Wears the crown of Fortune's wheel. The Kingmaker's Court serves the King." | "Reigns beside the King without wearing the crown." |
| Icon (suggestion) | `Spell_Enchantment_CrownOfMadness` | `statIcons_AuraOfLeadership` |
| StackId | `KINGMAKER_CROWN` | `KINGMAKER_CROWN` |
| StackType | `Overwrite` | `Overwrite` |
| StatusPropertyFlags | `ForceOverhead` | `ForceOverhead` |

### 07 · NEW · StatusData / Status_BOOST · the three technical statuses

`KINGMAKER_BIND_ALLY_TECH`, `KINGMAKER_BIND_ENEMY_TECH`, `KINGMAKER_STEP_TECH` — each with only:

| Field | Value |
|---|---|
| StackId | its own name |
| StatusPropertyFlags | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |

No DisplayName, no Description, no Icon.

### 08 · NEW · Stats / Passive · `Arcana_Passive_TheRota`

| Field | Value |
|---|---|
| DisplayName | "The Rota" |
| Description | "Creatures you set on Fortune's wheel move one position at the start of your turn - Rising, Reigning, Falling, Fallen, and round again. They stay on the Wheel until they die, combat ends or you cut their thread.<br><br>The ally that has Reigned the longest wears the crown as the <LSTag Type="Status" Tooltip="KINGMAKER_KING">King</LSTag>." |
| Icon (suggestion) | `Action_Mag_AuraOfLeadership` |
| Properties | `Highlighted` |

### 09 · NEW · SpellData / Projectile · `Projectile_Arcana_Card_Spell_SpokeOfTheWheel`

- **Using:** `Projectile_FireBolt` — borrows the projectile, animation, sounds and the ranged spell attack.

| Field | Value | Origin |
|---|---|---|
| Level | `0` | cantrip |
| SpellSchool | `Evocation` | parent |
| DisplayName | "Spoke of the Wheel" | texts §4 |
| Description | "Hurl a spoke of Fortune's wheel at a foe." | texts §4 |
| ExtraDescription | "Deals an additional [2] to a creature that is Falling or Fallen." | texts §4 |
| DescriptionParams | `DealDamage(LevelMapValue(D6Cantrip),Bludgeoning);DealDamage(1d4,Bludgeoning)` | `1d6/2d6/3d6 · SPL_Kingmaker_SpokeOfTheWheel#damage` (vanilla D6Cantrip) · `1d4 · …#bonus_vs_falling_or_fallen` |
| TooltipDamageList | `DealDamage(LevelMapValue(D6Cantrip),Bludgeoning)` | |
| Icon (suggestion) | `Spell_Evocation_FireBolt` (the parent's) | — |
| SpellProperties | *(empty — removes the parent's ignite and melt)* | |
| SpellSuccess | `DealDamage(LevelMapValue(D6Cantrip),Bludgeoning,Magical);IF(HasStatus('KINGMAKER_FALLING') or HasStatus('KINGMAKER_FALLEN')):DealDamage(1d4,Bludgeoning,Magical)` | as above |
| TargetConditions | `not Self() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)` | card marker |

### 10 · NEW · SpellData / Target · `Target_Arcana_Card_Spell_Coronation`

- **Using:** `Target_ShieldOfFaith` — borrows the bonus-action buff animation, effects and sounds.

| Field | Value | Origin |
|---|---|---|
| Level | `1` | `SPL_Kingmaker_Coronation#card_level` |
| SpellSchool | `Enchantment` | |
| DisplayName | "Coronation" | texts §4 |
| Description | "Crown an ally or yourself and set them Rising on Fortune's wheel." | texts §4 |
| ExtraDescription | "The crowned creature stays on the Wheel until it dies, combat ends or its thread is cut." | texts §4 |
| Icon (suggestion) | `Spell_Enchantment_CrownOfMadness` | — |
| UseCosts | `BonusActionPoint:1;SpellSlotsGroup:1:1:1` | SP106 |
| TargetRadius | `18` | `18 · SPL_Kingmaker_Coronation#range` |
| SpellProperties | `ApplyStatus(KINGMAKER_BIND_ALLY_TECH,100,0)` | |
| TargetConditions | `(Ally() or Self()) and not Dead() and not HasStatus('KINGMAKER_RISING') and not HasStatus('KINGMAKER_REIGNING') and not HasStatus('KINGMAKER_FALLING') and not HasStatus('KINGMAKER_FALLEN') and not HasPassive('ARCANA_IS_CARD', context.Source)` | |
| SpellFlags | `IsSpell;HasVerbalComponent;HasSomaticComponent` | **removes the parent's `IsConcentration`** |

### 11 · NEW · SpellData / Target · `Target_Arcana_Card_Spell_Dethrone`

- **Using:** `Target_DissonantWhispers` — borrows the animation, sounds and the "half on a save" shape.

| Field | Value | Origin |
|---|---|---|
| Level | `1` | `SPL_Kingmaker_Dethrone#card_level` |
| DisplayName | "Dethrone" | texts §4 |
| Description | "Cast an enemy down and set it Falling on Fortune's wheel." | texts §4 |
| ExtraDescription | "On a successful <LSTag Tooltip="SavingThrow">Saving Throw</LSTag> the target takes half damage, but it still joins the Wheel." | texts §4 |
| DescriptionParams | `DealDamage(3d6,Bludgeoning)` | `3d6 · SPL_Kingmaker_Dethrone#damage` |
| TooltipDamageList | `DealDamage(3d6,Bludgeoning)` | same |
| TooltipAttackSave | `Charisma` | SP84 |
| Icon (suggestion) | `Spell_Enchantment_CommandGrovel` | — |
| UseCosts | `ActionPoint:1;SpellSlotsGroup:1:1:1` | |
| TargetRadius | `18` | `18 · SPL_Kingmaker_Dethrone#range` |
| SpellRoll | `not SavingThrow(Ability.Charisma, SourceSpellDC())` | |
| SpellSuccess | `DealDamage(3d6,Bludgeoning,Magical);ApplyStatus(KINGMAKER_BIND_ENEMY_TECH,100,0)` | `3d6 · …#damage` |
| SpellFail | `DealDamage((3d6)/2,Bludgeoning,Magical);ApplyStatus(KINGMAKER_BIND_ENEMY_TECH,100,0)` | same |
| TargetConditions | `Enemy() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)` | |

### 12 · NEW · SpellData / Target · `Target_Arcana_Card_Spell_TurnTheSpoke`

- **Using:** `Target_Arcana_Card_Spell_Temper` — borrows the bonus-action control visuals.

| Field | Value | Origin |
|---|---|---|
| Level | `0` | `SPL_Kingmaker_TurnTheSpoke#card_level` (no slot) |
| DisplayName | "Turn the Spoke" | texts §4 |
| Description | "Turn a creature on the Wheel one position onward." | texts §4 |
| ExtraDescription | "The Wheel only turns forward." | texts §4 |
| Icon (suggestion) | `Spell_Enchantment_CalmEmotions` (the parent's) | — |
| UseCosts | `BonusActionPoint:1` | SP107 |
| TargetRadius | `18` | `18 · SPL_Kingmaker_TurnTheSpoke#range` |
| SpellRoll | *(empty)* | |
| SpellSuccess | *(empty)* | |
| SpellFail | *(empty)* | |
| SpellProperties | `ApplyStatus(KINGMAKER_STEP_TECH,100,0)` | |
| TargetConditions | `not Dead() and (HasStatus('KINGMAKER_RISING') or HasStatus('KINGMAKER_REIGNING') or HasStatus('KINGMAKER_FALLING') or HasStatus('KINGMAKER_FALLEN')) and not HasPassive('ARCANA_IS_CARD', context.Source)` | |
| TooltipAttackSave | *(empty)* | |

### 13 · Generated — do not type

| Family | Count | Built by | Command |
|---|---|---|---|
| Upcast variants of `Target_Arcana_Card_Spell_Coronation` and `Target_Arcana_Card_Spell_Dethrone` (Dethrone gains 1d6 per slot level: `SPL_Kingmaker_Dethrone#damage`) | 5 each (`_2`…`_6`) | `82_Automation/stats/gen_upcast_variants.pl` | Claude runs it after you save, then `sort_stats.pl --apply` and `check_cards.pl` |

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
