---
id: TOOLKIT_ARC-####
ticket: ARC-####
spec: SPEC_ARC-####
status: draft            # draft | ready | entered | verified
derived_from: []         # every 25 id whose values appear below, e.g. [25.01/SPL_Example.yaml]
generated_at: YYYY-MM-DD # regenerate whenever one of those 25 files changes
author: Mod Engineer
---

# TOOLKIT_ARC-#### · <feature name>

> **What this file is.** A point-by-point guide for the Owner to enter a feature **by hand in the BG3
> Toolkit**: where to click, which entry to create or change, and what to type in every field. It is
> organised by the Toolkit's own layout — **Stories**, **UUID Object Editor**, **Stats Editor** — then
> file, then entry, then field. The SPEC (`SPEC_ARC-####`) stays the technical source; this file is the
> typing view of it.

---

## Rules for whoever writes this file

Keep this section in every guide; it is how the Owner reads the rest.

1. **Derived view (ADR-0005).** Numbers live in `25_Master_Data`. Every number here shows its value **and
   its origin**: `2d6 · SPL_Example#damage`. This file is regenerated when a file in `derived_from`
   changes; never edit a number here by hand.
2. **Order.** Section 0 is a numbered checklist in the order the work has to happen (an entry must exist
   before another one points to it: a list before the progression that uses its UUID; a status before the
   spell that applies it, when the Toolkit validates the reference). The sections below are grouped by
   Toolkit area; the checklist number appears in each entry's title.
3. **New entries: every field.** A new entry lists every field the Owner must fill, in the order the
   Toolkit shows them. Empty fields are not listed.
4. **Changed entries: only what changes**, as `before → after`.
5. **`Using` (parent).** When an entry inherits, name the parent and say what it borrows (animation,
   sounds, effects). Fields that come from the parent unchanged are **not** repeated.
6. **Icons are suggestions.** Every `Icon` field says *suggestion*: the parent's icon or a vanilla one that
   fits. The Owner checks it in the Toolkit and may pick a better one; custom icons (`ICO_…`) come later.
7. **UUIDs.** The Toolkit generates them; this file never invents one. Where a later step needs a UUID
   created earlier, leave the slot `UUID: ________` for the Owner to fill after creating it.
8. **Text.** New player-facing text is given in English inside quotes: create a new localisation handle
   with that text. Existing text says `(existing handle hXXXX)`. Text follows the BG3 style guide (`31.03`).
9. **Generated families — do not type.** Upcast variants (`<card>_2…_6`), one status per spell level and
   any family a generator builds are listed in a *Generated* table with the command that applies them.
   Only the base entry is typed.
10. **Osiris.** Each goal is one copy-paste block, with its name and parent goal.
11. **Exact names.** Every name and value is copied from the SPEC and checked against `55.00_Type_Catalog.md`
    and the glossary (prefixes, ADR-0002). If a field's syntax is uncertain, the SPEC must name a vanilla
    example (`56`) for it; this file never introduces a field the SPEC didn't ground.

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

Fields the Toolkit shows most often, per file, for reference.

| File | Fields |
|---|---|
| SpellData / `Target` · `Shout` · `Zone` · `Projectile` · `Rush` · `Teleportation` | Name, Using, Level, SpellSchool, DisplayName, Description, DescriptionParams, ExtraDescription, Icon, UseCosts, TargetConditions, RequirementConditions, SpellRoll, SpellSuccess, SpellFail, SpellProperties, TooltipDamageList, TooltipAttackSave, TooltipStatusApply, SpellFlags, SpellContainerID, ContainerSpells, RootSpellID, PowerLevel, VerbalIntent, SpellStyleGroup; animation, effect and sound fields usually come from the parent. Zone adds Range, SurfaceType, SurfaceLifetime |
| Stats / `Passive` | Name, Using, DisplayName, Description, DescriptionParams, ExtraDescription, Icon, Properties, Boosts, BoostContext, BoostConditions, StatsFunctorContext, StatsFunctors, Conditions, EnabledContext, EnabledConditions |
| Stats / `Interrupt` | Name, DisplayName, Description, Icon, InterruptContext, InterruptContextScope, Conditions, Properties, Cost, Stack, InterruptDefaultValue, EnableContext, EnableCondition, Container |
| StatusData / `Status_<TYPE>` | Name, Using, DisplayName, Description, DescriptionParams, Icon, StackId, StackType, StackPriority, StatusGroups, StatusPropertyFlags, TickType, Boosts, Passives, OnApplyFunctors, OnRemoveFunctors, TickFunctors, RemoveEvents, RemoveConditions, AuraStatuses, AuraRadius, StatusEffect, ApplyEffect |

### 03 · NEW · SpellData / Target · `Target_Arcana_Card_Spell_Example`

- **Using (parent):** `Target_Example_Vanilla` — borrows the animation, sounds and cast effect.

| Field | Value | Origin |
|---|---|---|
| Level | `1` | SPEC |
| DisplayName | "Example" (new handle) | `32.04` |
| Description | "…" (new handle) | `32.04` |
| Icon | `Spell_Example` — **suggestion**, from the parent | — |
| UseCosts | `ActionPoint:1;SpellSlotsGroup:1:1:1` | SPEC |
| SpellRoll | `not SavingThrow(Ability.Charisma, SourceSpellDC())` | SPEC |
| SpellSuccess | `DealDamage(2d6,Bludgeoning,Magical)` | `2d6 · SPL_Example#damage` |

### 01 · CHANGED · StatusData / Status_BOOST · `EXAMPLE_STATUS`

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
