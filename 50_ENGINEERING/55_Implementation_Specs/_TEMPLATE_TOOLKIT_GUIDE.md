---
id: TOOLKIT_ARC-####
ticket: ARC-####
spec: SPEC_ARC-####
status: draft            # draft | ready | entered | verified
derived_from: []         # every 25 id whose values appear below, e.g. [25.01/SPL_Example.yaml]
generated_at: YYYY-MM-DD # regenerate whenever one of those 25 files changes
author: Mod Engineer
---

# TOOLKIT_ARC-#### · `<feature name>`

> **What this file is.** A point-by-point guide for the Owner to enter a feature **by hand in the BG3
> Toolkit**: where to click, which entry to create or change, and what to type in every field. It is
> organised by the Toolkit's own layout — **Stories**, **UUID Object Editor**, **Stats Editor** — then
> file, then entry, then field. The SPEC (`SPEC_ARC-####`) stays the technical source; this file is the
> typing view of it. Every subclass **build or rework** gets these guides, one per level (`TOOLKIT_ARC-####_L<n>.md`):
> the Owner types each level and tests it before the next; Claude applies nothing in the game.

---

## Rules for whoever writes this file

Keep this section in every guide; it is how the Owner reads the rest.

1. **Derived view (ADR-0005, ADR-0008).** Numbers live in `25_Master_Data`. Table cells hold **only what is typed**;
   the origin of every number is listed **under** its block (`2d6` = `SPL_Example#damage`). This file is regenerated
   when a file in `derived_from` changes; never edit a number here by hand.
2. **Order.** Section 0 is a numbered checklist in the order the work has to happen (an entry must exist
   before another one points to it: a list before the progression that uses its UUID; a status before the
   spell that applies it, when the Toolkit validates the reference). The sections below are grouped by
   Toolkit area; the checklist number appears in each entry's title.
3. **Stats Editor blocks.** One column per entry, **at most 3 entries per block** (same file only), one row per
   field. **Rows follow the Toolkit's field order** (§3, *Toolkit field order*) and use its labels (Spell
   Animation, Intent, Spell Style Group). Every row is a real field to fill, confirm or clear. After writing the
   blocks and their Notes, run `82_Automation/stats/order_toolkit_guide.pl --apply <guide>`: it sorts rows and Notes
   in this order, renames the labels and drops rows that are `—` in every entry unless the Notes list them under
   *Clears the parent* (so list every clear there). Without `--apply` it only reports.
   **A cell holds only what is pasted** — as `code`, no quotes, no notes, no "(suggestion)": in the preview a
   double-click selects the whole cell and the Owner pastes it straight into the Toolkit. `—` = leave the field empty.
   Where each value comes from goes in the **Notes** under the block (see rule 4). Spell `Name` is typed without the type prefix (`Arcana_Card_Spell_X` in
   `Target.stats` → game id `Target_Arcana_Card_Spell_X`); `Using` is written as the parent's name without its type prefix
   (`ShieldOfFaith`, not `Target_ShieldOfFaith`) — shorter to search in the picker.
4. **New entries: only the fields that matter, parent values included.** A row exists for every field with a
   value (ours or the parent's) and for every field the parent fills that must be cleared; a field that stays empty and
   that the parent doesn't fill has no row. Resolve the parent's effective fields from the game files (`82_Automation/stats/resolve_stats.pl <entry>`)
   (the `using` chain, load order Shared → SharedDev → Gustav → GustavDev → the mod) and list them all with their
   exact values, so the entry is complete when the Owner later removes `Using` (another mod that changes the parent
   can't change ours). Don't copy what doesn't apply (the parent's texts, its status tooltip): its
   cell is `—`. `MemoryCost` is shown only for Rush spells; elsewhere a parent's `1` stays and does no harm (cards are
   always prepared) — say so under the block. Under each block, **Notes** list per entry: `Using` (and the name to search in the picker); **From the
   parent** — every field whose value is the parent's; **Ours** — every field we set (say what the parent had when we
   replace it); **Clears the parent** — every `—` field where the parent has a value (say which). Every filled field
   of an entry with `Using` is in exactly one of the first two lists.
5. **Changed entries** (UUID Object Editor): only what changes, as `before → after`.
6. **Icons are suggestions.** Every `Icon` is the parent's icon or a vanilla one that fits; the Notes say so. The Owner checks it in the Toolkit and may pick a better one; custom icons (`ICO_…`) come later.
7. **UUIDs.** The Toolkit generates them; this file never invents one. Where a later step needs a UUID
   created earlier, leave the slot `UUID: ________` for the Owner to fill after creating it.
8. **Text.** Every `DisplayName`, `Description` and `ExtraDescription` cell is a new localisation handle with
   that English text, in `code` like any other cell, tags included: `…<LSTag Tooltip="Advantage">Advantage</LSTag>…`
   (the Markdown preview hides raw tags, and `code` shows them). Never leave a `<…>` outside `code` anywhere in
   the guide (placeholders included). Existing text says `(existing handle hXXXX)`. Text follows the BG3 style guide (`31.03`).
   A `[n]` in a `Description` reads `DescriptionParams`; in an `ExtraDescription` it reads `ExtraDescriptionParams`
   (vanilla: 115 spells). Each list starts at `[1]`; no parameter is listed that the text doesn't use.
9. **Generated families — do not type.** Upcast variants (`<card>_2…_6`), one status per spell level and
   any family a generator builds are listed in a *Generated* table with the command that applies them.
   Only the base entry is typed.
10. **Osiris.** Each goal is one copy-paste block, with its name and parent goal.
11. **Exact names.** Every name and value is copied from the SPEC and checked against `55.00_Type_Catalog.md`
    and the glossary (prefixes, ADR-0002). If a field's syntax is uncertain, the SPEC must name a vanilla
    example (`56`) for it; this file never introduces a field the SPEC didn't ground.
12. **Nothing the Owner can't type or find.** Never write a GUID or an animation string the Toolkit shows as a
    picker or a copied value:
    - **Look fields** (Spell Animation, Dual Wielding Spell Animation, PrepareEffect, CastEffect, TargetEffect, HitEffect,
      PositionEffect and the other `…Effect` fields, Trajectories): give the spell they come from as `Using`; the Notes
      say **"Copy from the parent in the Toolkit, then remove `Using`"** with the list, and those fields have no row.
      Name the parent's own fields to leave behind (its ground effect, its area) so they go with `Using`.
    - **Tooltip texts picked from a list** (TooltipUpcastDescription, TooltipOnSave, TooltipOnMiss,
      TooltipPermanentWarnings): the cell holds the **name the list shows** (`Additional damage`), read from vanilla
      `Public/Shared/TooltipExtras/*.lsx` (`Name` attribute, or the English text when the entry has no name), never the UUID.
    - Readable parent values (sounds, `Cast`, costs) still get a row, so nothing is lost when `Using` goes.

---

## 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / `Status_BOOST` | `EXAMPLE_STATUS` | new | — | ☐ |
| 02 | Stats Editor | Stats / `Passive` | `Arcana_Passive_Example` | new | 01 | ☐ |
| 03 | Stats Editor | SpellData / `Target` | `Target_Arcana_Card_Spell_Example` | new | 01 | ☐ |
| 04 | UUID Object Editor | Lists / `SpellLists` | "Example Level 1" | new | 03 | ☐ |
| 05 | UUID Object Editor | Progressions / `Progressions` | `<Subclass>` level 1 | change | 04 | ☐ |
| 06 | Stories | Goals | `ARCANA_Example` | new goal | 01 | ☐ |
| 07 | — | Generated | upcast variants | run script | 03 | ☐ |

---

## 1 · Stories (Osiris)

### 06 · Goal `ARCANA_Example` — parent goal `<parent>`

```
<the whole goal, ready to paste>
```

After every goal: **compile** in the Story Editor and read `Mods/AspectClass_…/Story/log.txt` — it must end
with `0 error(s)`; a warning such as *Database defined but never checked* is a defect.

---

## 2 · UUID Object Editor

Fields the Toolkit shows, per file, for reference. Use only the ones the entry needs.

| File | Fields |
|---|---|
| ClassDescriptions / `ClassDescriptions` | Name, DisplayName, Description, ParentUUID, ProgressionTableUUID, PrimaryAbility, SpellCastingAbility, BaseHp, HpPerLevel, CanLearnSpells, MustPrepareSpells, LearningStrategy, SoundClassType, ClassEquipment, Tags, CharacterCreationPose, hotbar columns |
| Lists / `SpellLists` · `PassiveLists` · `SkillLists` | Name, Spells / Passives / Skills |
| Levelmaps / `LevelMapValues` | Name, PreferredClass, Level1 … Level20 |
| Progressions / `Progressions` | Name, TableUUID, Level, ProgressionType, PassivesAdded, PassivesRemoved, Boosts, Selectors, SubClasses, AllowImprovement, IsMulticlass |
| Progressions / `ProgressionDescriptions` | Name, DisplayName, Description, Type, ProgressionId, ProgressionTableId, SelectorId, ParamMatch, ExactMatch |
| DefaultValues / `Abilities` · `Skills` · `Passives` · `Equipments` | Name, ProgressionUUID, Level, SelectorId, DefaultValues |
| CharacterCreationPresets / `AbilityDistributionPresets` | Name, ClassUUID, Strength … Charisma |
| TooltipExtras / `TooltipExtraTexts` | Name, Text |
| ActionResourceDefinitions | Name, DisplayName, Description, MaxValue, MaxLevel, ReplenishType, IsSpellResource, IsHidden, ShowOnActionResourcePanel, UpdatesSpellPowerLevel |

### 04 · NEW · Lists / SpellLists · "Example Level 1"

| Field | Value |
|---|---|
| Name | `Example Level 1` |
| Spells | `Target_Arcana_Card_Spell_Example;…` |

UUID: ________ (used in step 05)

### 05 · CHANGED · Progressions / Progressions · `<Subclass>` level 1

| Field | Before | After |
|---|---|---|
| PassivesAdded | `…` | `…` |
| Selectors | `…` | `AddSpells(<UUID from 04>,,,,AlwaysPrepared)` |

---

## 3 · Stats Editor

Start the section with the reading key (keep it in every guide):

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### Toolkit field order

The Stats Editor shows each entry's fields in this order (Owner's Toolkit, recorded
2026-10-14). `Name` and `Using` sit at the top of the entry, before `Owner`. Write the rows of every block in this
order. Labels are the Toolkit's: **Spell Animation** = `SpellAnimation`, **Intent** = `VerbalIntent`, **Spell Style
Group** = `SpellStyleGroup`, **Memory Cost** = `MemoryCost` (only Rush shows it).

**Projectile:** Owner → Level → SpellSchool → SpellContainerID → ContainerSpells → ConcentrationSpellID → Cooldown → AIFlags → SpellProperties → TargetCeiling → TargetFloor → TargetRadius → AreaRadius → AddRangeFromAbility → DeathType → ExplodeRadius → AmountOfTargets → SpellRoll → SpellSuccess → SpellFail → TargetConditions → ExtraProjectileTargetConditions → ProjectileCount → ProjectileDelay → CastTargetHitDelay → Angle → Trajectories → Icon → DisplayName → Description → DescriptionParams → ExtraDescription → ExtraDescriptionParams → ShortDescription → ShortDescriptionParams → TooltipDamageList → TooltipAttackSave → TooltipStatusApply → TooltipOnMiss → TooltipOnSave → TooltipUpcastDescription → TooltipUpcastDescriptionParams → TooltipPermanentWarnings → PrepareSound → PrepareLoopSound → CastSound → VocalComponentSound → PreviewCursor → CastTextEvent → AlternativeCastTextEvents → InstrumentComponentPrepareSound → InstrumentComponentLoopingSound → InstrumentComponentCastSound → InstrumentComponentImpactSound → ProjectileTerrainOffset → MovingObjectSummonTemplate → ProjectileType → AiCalculationSpellOverride → CycleConditions → UseCosts → DualWieldingUseCosts → HitCosts → Spell Animation → Dual Wielding Spell Animation → Intent → Spell Style Group → Required Weapon Type → SpellFlags → SpellActionType → SpellActionTypePriority → SpellCategory → HitAnimationType → AnimationIntentType → SpellJumpType → MinJumpDistance → RechargeValues → Requirements → Fork Chance → Max Fork Count → Fork Levels → Fork Conditions → Spell Prepare Cost → Root Spell ID → Power Level → Source Limb Index → RequirementConditions → RequirementEvents → PrepareEffect → CastEffect → TargetEffect → HitEffect → TargetHitEffect → TargetGroundEffect → PositionEffect → BeamEffect → SpellEffect → SelectedCharacterEffect → SelectedObjectEffect → SelectedPositionEffect → DisappearEffect → ReappearEffect → ImpactEffect → DamageType → DelayTurnsCount → DelayRollTarget → DelayRollDie → SpellSoundMagnitude → SpellSoundAftermathTrajectory → MaximumTargets → Sheathing → InterruptPrototype → CombatAIOverrideSpell → FollowUpOriginalSpell → TooltipSpellDCAbilities

**Rush:** Owner → Level → SpellSchool → SpellContainerID → Requirement → Cooldown → AIFlags → Damage → Damage Range → SpellProperties → DeathType → TargetCeiling → TargetFloor → TargetRadius → AddRangeFromAbility → HitRadius → Movement Speed → SpellRoll → SpellSuccess → SpellFail → TargetConditions → Icon → DisplayName → Description → DescriptionParams → ExtraDescription → ExtraDescriptionParams → ShortDescription → ShortDescriptionParams → TooltipDamageList → TooltipAttackSave → TooltipStatusApply → TooltipOnMiss → TooltipOnSave → TooltipUpcastDescription → TooltipUpcastDescriptionParams → TooltipPermanentWarnings → FXScale → PrepareSound → PrepareLoopSound → CastSound → VocalComponentSound → PreviewCursor → CastTextEvent → InstrumentComponentPrepareSound → InstrumentComponentLoopingSound → InstrumentComponentCastSound → InstrumentComponentImpactSound → CastEffectTextEvent → WeaponBones → Memory Cost → Magic Cost → Requirements → MemorizationRequirements → Stealth → SurfaceType → SurfaceRadius → CycleConditions → UseCosts → HitCosts → Spell Animation → Required Weapon Type → SpellFlags → SpellActionType → SpellActionTypePriority → SpellCategory → HitAnimationType → AnimationIntentType → RechargeValues → Intent → Spell Style Group → Source Limb Index → RequirementConditions → RequirementEvents → PrepareEffect → CastEffect → TargetEffect → HitEffect → TargetGroundEffect → PositionEffect → BeamEffect → SpellEffect → SelectedCharacterEffect → SelectedObjectEffect → SelectedPositionEffect → DisappearEffect → ReappearEffect → ImpactEffect → PreviewEffect → StopAtFirstContact → HitExtension → OnlyHit1Target → DamageType → DelayTurnsCount → DelayRollTarget → DelayRollDie → SpellSoundMagnitude → SpellSoundAftermathTrajectory → Sheathing → FollowUpOriginalSpell → TooltipSpellDCAbilities

**Shout:** Owner → Level → SpellSchool → SpellContainerID → ContainerSpells → ConcentrationSpellID → Cooldown → AIFlags → SpellProperties → TargetCeiling → TargetFloor → AreaRadius → AddRangeFromAbility → DeathType → SpellRoll → SpellSuccess → SpellFail → TargetConditions → AoEConditions → Autocast → Icon → DisplayName → Description → DescriptionParams → ExtraDescription → ExtraDescriptionParams → ShortDescription → ShortDescriptionParams → TooltipDamageList → TooltipAttackSave → TooltipStatusApply → TooltipOnMiss → TooltipOnSave → TooltipUpcastDescription → TooltipUpcastDescriptionParams → TooltipPermanentWarnings → FXScale → PrepareSound → PrepareLoopSound → CastSound → TargetSound → VocalComponentSound → PreviewCursor → CastTextEvent → AlternativeCastTextEvents → InstrumentComponentPrepareSound → InstrumentComponentLoopingSound → InstrumentComponentCastSound → InstrumentComponentImpactSound → CastEffectTextEvent → WeaponBones → AiCalculationSpellOverride → CycleConditions → UseCosts → HitCosts → Spell Animation → Intent → Spell Style Group → Required Weapon Type → SpellFlags → SpellActionType → SpellActionTypePriority → SpellCategory → HitAnimationType → AnimationIntentType → RechargeValues → Requirements → RequirementConditions → RequirementEvents → Spell Prepare Cost → Root Spell ID → Power Level → Source Limb Index → PrepareEffect → CastEffect → TargetEffect → HitEffect → TargetHitEffect → TargetGroundEffect → PositionEffect → BeamEffect → SpellEffect → SelectedCharacterEffect → SelectedObjectEffect → SelectedPositionEffect → DisappearEffect → ReappearEffect → ImpactEffect → CinematicArenaFlags → DamageType → DelayTurnsCount → DelayRollTarget → DelayRollDie → CinematicArenaTimelineOverride → SpellSoundMagnitude → SpellSoundAftermathTrajectory → Sheathing → InterruptPrototype → RitualCosts → FollowUpOriginalSpell → TooltipSpellDCAbilities

**Target:** Owner → Level → SpellSchool → SpellContainerID → ContainerSpells → ConcentrationSpellID → Cooldown → AIFlags → SpellProperties → TargetCeiling → TargetFloor → TargetRadius → AreaRadius → AddRangeFromAbility → DeathType → Requirements → RequirementConditions → RequirementEvents → SpellRoll → SpellSuccess → SpellFail → TargetConditions → AoEConditions → AmountOfTargets → Icon → DisplayName → Description → DescriptionParams → ExtraDescription → ExtraDescriptionParams → ShortDescription → ShortDescriptionParams → TooltipDamageList → TooltipAttackSave → TooltipStatusApply → TooltipOnMiss → TooltipOnSave → TooltipUpcastDescription → TooltipUpcastDescriptionParams → TooltipPermanentWarnings → FXScale → PrepareSound → PrepareLoopSound → CastSound → TargetSound → VocalComponentSound → PreviewCursor → CastTextEvent → AlternativeCastTextEvents → InstrumentComponentPrepareSound → InstrumentComponentLoopingSound → InstrumentComponentCastSound → InstrumentComponentImpactSound → WeaponBones → Autocast → AiCalculationSpellOverride → CycleConditions → UseCosts → DualWieldingUseCosts → HitCosts → RitualCosts → Spell Animation → Dual Wielding Spell Animation → Intent → Spell Style Group → Required Weapon Type → SpellFlags → SpellActionType → SpellActionTypePriority → SpellCategory → RechargeValues → MaximumTotalTargetHP → SpellAnimationType → HitAnimationType → AnimationIntentType → MaximumTargets → Spell Prepare Cost → Root Spell ID → Power Level → Source Limb Index → Extra LOS Checks → PrepareEffect → CastEffect → TargetEffect → HitEffect → TargetHitEffect → TargetGroundEffect → PositionEffect → BeamEffect → SpellEffect → SelectedCharacterEffect → SelectedObjectEffect → SelectedPositionEffect → DisappearEffect → ReappearEffect → ImpactEffect → CinematicArenaFlags → DamageType → DelayTurnsCount → DelayRollTarget → DelayRollDie → CinematicArenaTimelineOverride → SpellSoundMagnitude → SpellSoundAftermathTrajectory → Sheathing → InterruptPrototype → CombatAIOverrideSpell → HighlightConditions → SteerSpeedMultiplier → FollowUpOriginalSpell → TooltipSpellDCAbilities

**Teleportation:** Owner → Level → SpellSchool → SpellContainerID → Cooldown → AIFlags → TargetCeiling → TargetFloor → TargetRadius → AreaRadius → AddRangeFromAbility → Extra LOS Checks → DeathType → HitRadius → Height → Acceleration → TeleportDelay → SpellProperties → SpellRoll → SpellSuccess → SpellFail → TargetConditions → OriginSpellProperties → OriginSpellRoll → OriginSpellSuccess → OriginSpellFail → OriginTargetConditions → TeleportSelf → TeleportSurface → Icon → DisplayName → Description → DescriptionParams → ExtraDescription → ExtraDescriptionParams → ShortDescription → ShortDescriptionParams → TooltipDamageList → TooltipAttackSave → TooltipStatusApply → TooltipOnMiss → TooltipOnSave → TooltipUpcastDescription → TooltipUpcastDescriptionParams → TooltipPermanentWarnings → FXScale → PrepareSound → PrepareLoopSound → CastSound → TargetSound → VocalComponentSound → PreviewCursor → CastTextEvent → InstrumentComponentPrepareSound → InstrumentComponentLoopingSound → InstrumentComponentCastSound → InstrumentComponentImpactSound → CycleConditions → UseCosts → HitCosts → Root Spell ID → Power Level → Spell Animation → Required Weapon Type → SpellFlags → SpellActionType → SpellActionTypePriority → SpellCategory → HitAnimationType → AnimationIntentType → RechargeValues → Intent → Spell Style Group → Source Limb Index → PrepareEffect → CastEffect → TargetEffect → HitEffect → TargetHitEffect → TargetGroundEffect → PositionEffect → BeamEffect → SpellEffect → SelectedCharacterEffect → SelectedObjectEffect → SelectedPositionEffect → DisappearEffect → ReappearEffect → ImpactEffect → DelayTurnsCount → DelayRollTarget → DelayRollDie → SpellSoundMagnitude → SpellSoundAftermathTrajectory → Sheathing → Ignore Teleport → RequirementConditions → RequirementEvents → FollowUpOriginalSpell

**Zone:** Owner → Level → SpellSchool → SpellContainerID → Cooldown → AIFlags → AddRangeFromAbility → SpellProperties → DeathType → SurfaceType → SurfaceLifetime → SurfaceGrowStep → SurfaceGrowInterval → SpellRoll → SpellSuccess → SpellFail → TargetConditions → Icon → DisplayName → Description → DescriptionParams → ExtraDescription → ExtraDescriptionParams → ShortDescription → ShortDescriptionParams → TooltipDamageList → TooltipAttackSave → TooltipStatusApply → TooltipOnMiss → TooltipOnSave → TooltipUpcastDescription → TooltipUpcastDescriptionParams → TooltipPermanentWarnings → FXScale → PrepareSound → PrepareLoopSound → CastSound → TargetSound → VocalComponentSound → PreviewCursor → CastTextEvent → AlternativeCastTextEvents → InstrumentComponentPrepareSound → InstrumentComponentLoopingSound → InstrumentComponentCastSound → InstrumentComponentImpactSound → CastEffectTextEvent → Shape → Offset → TargetCeiling → TargetFloor → Range → Base → Angle → CycleConditions → UseCosts → HitCosts → Spell Animation → Intent → Spell Style Group → Required Weapon Type → SpellFlags → SpellActionType → SpellActionTypePriority → SpellCategory → RechargeValues → MaximumTotalTargetHP → MaximumTargets → HitAnimationType → AnimationIntentType → Spell Prepare Cost → Root Spell ID → Power Level → Source Limb Index → RequirementConditions → RequirementEvents → PrepareEffect → CastEffect → TargetEffect → HitEffect → TargetHitEffect → TargetGroundEffect → PositionEffect → BeamEffect → SpellEffect → SelectedCharacterEffect → SelectedObjectEffect → SelectedPositionEffect → DisappearEffect → ReappearEffect → ImpactEffect → DamageType → DelayTurnsCount → DelayRollTarget → DelayRollDie → SpellSoundMagnitude → SpellSoundAftermathTrajectory → Sheathing → ContainerSpells → CombatAIOverrideSpell → FollowUpOriginalSpell → TooltipSpellDCAbilities

**Passive:** Owner → DisplayName → Description → DescriptionParams → ExtraDescription → ExtraDescriptionParams → LoreDescription → TooltipUseCosts → TooltipSave → TooltipConditionalDamage → TooltipPermanentWarnings → Icon → PriorityOrder → EnabledConditions → EnabledContext → Properties → BoostContext → BoostConditions → Boosts → StatsFunctorContext → StatsFunctorConditions → StatsFunctors → ToggleOnFunctors → ToggleOffFunctors → ToggleOnEffect → ToggleOffEffect → ToggleOffContext → ToggleGroup → DynamicAnimationLabel

**Status_BOOST:** Owner → DisplayName → Description → DescriptionParams → Icon → FormatColor → StatusEffectOverrideForItems → StatusEffectOverride → MaterialType → Material → MaterialApplyBody → MaterialApplyArmor → MaterialApplyWeapon → MaterialApplyNormalMap → MaterialFadeAmount → MaterialOverlayOffset → MaterialParameters → MeshEffect → StillAnimationType → StillAnimationPriority → HitAnimationType → UseLyingPickingState → SoundVocalStart → SoundVocalLoop → SoundStart → SoundLoop → SoundStop → SoundVocalEnd → StatusSoundState → ImmuneFlag → OnApplyConditions → StackId → StackPriority → StackType → AuraRadius → AuraStatuses → AuraFlags → AuraFX → SurfaceChange → Spells → Items → WeaponOverride → ResetCooldowns → LeaveAction → DieAction → ForceStackOverwrite → Toggle → TickType → Boosts → Passives → RemoveConditions → RemoveEvents → TooltipSave → TooltipDamage → TickFunctors → StatusPropertyFlags → OnApplyFunctors → OnRemoveFunctors → OnApplyRoll → OnApplySuccess → OnApplyFail → OnTickRoll → OnTickSuccess → OnTickFail → OnRemoveRoll → OnRemoveSuccess → OnRemoveFail → LEDEffect → StatusGroups → IsUnique → ApplyEffect → StatusEffect → StatusEffectOnTurn → TargetEffect → BeamEffect → SplatterDirtAmount → SplatterBloodAmount → SplatterSweatAmount → ManagedStatusEffectType → ManagedStatusEffectGroup → EndEffect → TooltipPermanentWarnings → PerformEventName → DynamicAnimationLabel → Sheathing

Other types (Interrupt, other status types): the order is not recorded yet — ask the Owner for it before writing
such a block, then add it here.

### 01–02 · NEW · StatusData / Status_BOOST · Example A, Example B

| Field | `EXAMPLE_A` | `EXAMPLE_B` |
|---|---|---|
| Name | `EXAMPLE_A` | `EXAMPLE_B` |
| DisplayName | `Example A` | `Example B` |
| Description | `Subtracts [1] from <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag>.` | `…` |
| DescriptionParams | `1d4` | — |
| Icon | `Spell_Enchantment_Bane` | `Status_Prone` |
| StackId | `EXAMPLE` | `EXAMPLE` |
| StackType | `Overwrite` | `Overwrite` |
| Boosts | `RollBonus(Attack,-1d4)` | — |
| StatusPropertyFlags | `ForceOverhead` | `ForceOverhead` |

Notes: Icons are suggestions.

Numbers: `1d4` (Boosts, DescriptionParams) = `FEAT_Example#penalty`.

### 03 · NEW · SpellData / Target · Example spell (up to 3 entries per block)

| Field | `Target_Arcana_Card_Spell_Example` |
|---|---|
| Name | `Arcana_Card_Spell_Example` |
| Using | `Example_Vanilla` |
| Level | `1` |
| SpellProperties | — |
| SpellRoll | `not SavingThrow(Ability.Charisma, SourceSpellDC())` |
| SpellSuccess | `DealDamage(2d6,Bludgeoning,Magical)` |
| Icon | `Spell_Example` |
| DisplayName | `Example` |
| CastSound | `Spell_Cast_…` |
| UseCosts | `ActionPoint:1;SpellSlotsGroup:1:1:1` |

Notes (`Using` = `Example_Vanilla`; search `Example_Vanilla` in the picker):
- **Copy from the parent in the Toolkit, then remove `Using`:** Spell Animation, PrepareEffect, CastEffect.
- **From the parent:** Level, Icon (also a suggestion), CastSound, UseCosts.
- **Ours:** SpellRoll, SpellSuccess, DisplayName.
- **Clears the parent:** SpellProperties (the parent has `…`).

Numbers: `2d6` = `SPL_Example#damage`.

### 04 · CHANGED · StatusData / Status_BOOST · `EXAMPLE_C` (only what changes)

| Field | Before | After |
|---|---|---|
| Boosts | `…` | `…` |

### Generated — do not type

| Family | Count | Built by | Command |
|---|---|---|---|
| Upcast variants of `Target_Arcana_Card_Spell_Example` | 5 (`_2`…`_6`) | `82_Automation/stats/gen_upcast_variants.pl` | `perl …/gen_upcast_variants.pl` then `sort_stats.pl --apply` and `check_cards.pl` |

---

## 4 · Localisation summary

Every new handle created above, in one table, so nothing is missed.

| Entry | Field | English text |
|---|---|---|
| `Target_Arcana_Card_Spell_Example` | DisplayName | "Example" |

---

## 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt`.
2. Save in the Toolkit, close it, then `sync_data` and the checks the SPEC lists (`check_cards.pl`,
   `validate.pl`).
3. Tick the steps in section 0 and tell the Mod Engineer which ones are done.
