---
id: TOOLKIT_ARC-0026
ticket: ARC-0026
spec: SPEC_ARC-0026
status: draft
derived_from: [25.01/SPL_Unbound_FlowState.yaml, 25.01/SPL_Unbound_GaleDeflection.yaml, 25.01/SPL_Unbound_LeapOfFaith.yaml, 25.01/SPL_Unbound_StormFists.yaml, 25.01/SPL_Unbound_TheCalm.yaml, 25.01/SPL_Unbound_Untethered.yaml, 25.01/SPL_Unbound_WhereTheWindsMeet.yaml, 25.02/FEAT_Unbound_AeolusBag.yaml, 25.02/FEAT_Unbound_AspectAwakening.yaml, 25.02/FEAT_Unbound_TheOpenRoad.yaml, 25.02/FEAT_Unbound_Weightless.yaml, 25.04/CLS_Unbound.yaml]
merged_from: [TOOLKIT_ARC-0026_L01, TOOLKIT_ARC-0026_L02, TOOLKIT_ARC-0026_L03, TOOLKIT_ARC-0026_L04, TOOLKIT_ARC-0026_L05, TOOLKIT_ARC-0026_L06, TOOLKIT_ARC-0026_L07, TOOLKIT_ARC-0026_L08, TOOLKIT_ARC-0026_L09, TOOLKIT_ARC-0026_L10, TOOLKIT_ARC-0026_L11, TOOLKIT_ARC-0026_L12]
author: Mod Engineer
---

# TOOLKIT_ARC-0026 · The Windborn — levels 1–12

> **One file for the whole build** (Owner, 2026-10-17): a part per level, in the order you type them. Type a level,
> then play that level's tests in `QA_ARC-0026`. Merged on 2026-10-17 from 12 files (`merged_from`); nothing removed.

## Contents

- The Windborn — level 1
- The Windborn — level 2
- The Windborn — level 3
- The Windborn — level 4
- The Windborn — level 5
- The Windborn — level 6
- The Windborn — level 7
- The Windborn — level 8
- The Windborn — level 9
- The Windborn — level 10
- The Windborn — level 11
- The Windborn — level 12

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

---

# The Windborn — level 1

> **What this file is.** The point-by-point guide to enter **level 1** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *The Open Road (Windswept, Open Path, Zephyr's Rush), Be the Leaf, Flowing Strikes, Weightless 1, Gale Burst*. Headline: "The wind marks what I touch and carries me to the rest". Technical source: `SPEC_ARC-0026` (stage 1).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** see step 00 below — the game already holds a first version of part of this level.

---

### 0 · Order of work

**00 · Clear the first version.** On 2026-10-17 a patch (ARC-0026 stage 2, before this guide) put part of level 1 in
the game. To type this level as new: in the Stats Editor delete `ARCANA_WINDSWEPT`, `ARCANA_ZEPHYR_RUSH`,
`Arcana_Passive_Windswept_Touch`, `Rush_Arcana_Created_ZephyrRush` and your copy of `Interrupt_AttackOfOpportunity`;
in the UUID Object Editor take `Arcana_Passive_Windswept_Touch` out of both level-1 progression rows. The fields of
the CHANGED blocks already hold their *After* value: type them over anyway. In the Story Editor, the goal
`ARCANA_Probe_ARC0026` (it removes the old probe spells on load) can be deleted once you have loaded your save.

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `ARCANA_WINDSWEPT` | new | — | ☐ |
| 02 | Stats Editor | StatusData / Status_BOOST | `ARCANA_ZEPHYR_RUSH` | new | — | ☐ |
| 03 | Stats Editor | Stats / Passive | `Arcana_Passive_Weightless_1` | new | — | ☐ |
| 04 | Stats Editor | Stats / Passive | `Arcana_Passive_Windswept_Touch` | new | — | ☐ |
| 05 | Stats Editor | SpellData / Rush | `Rush_Arcana_Created_ZephyrRush` | new | — | ☐ |
| 06 | Stats Editor | Stats / Interrupt | `Interrupt_AttackOfOpportunity` | new | — | ☐ |
| 07 | Stats Editor | Stats / Passive | `Arcana_Passive_BetheLeaf` | change | — | ☐ |
| 08 | Stats Editor | Stats / Passive | `Arcana_Passive_FlowingStrikeZephyr` | change | — | ☐ |
| 09 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_GaleBurst` | change | — | ☐ |
| 10 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_GaleBurst_3` | change | — | ☐ |
| 11 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_GaleBurst_4` | change | — | ☐ |
| 12 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_GaleBurst_5` | change | — | ☐ |
| 13 | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_GaleBurst_6` | change | — | ☐ |
| 14 | Stats Editor | SpellData / Target | `Target_Arcana_Created_ZephyrStrike` | change | — | ☐ |
| 15 | UUID Object Editor | Lists / SpellLists | "Unbound Level 1" | change | — | ☐ |
| 16 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 1 (multiclass row) | change | — | ☐ |
| 17 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 1 | change | — | ☐ |
| 18 | UUID Object Editor | CharacterCreationPresets / AbilityDistributionPresets | the Unbound preset | change | — | ☐ |
| 19 | — | Generated | Gale Burst `_2` (inherits the base) and `ARCANA_CardFamilies` rows for Zephyr Rush | Claude runs scripts | all above | ☐ |
| 20 | — | PC edition | `CardDB.lua` | Claude adds the lines | all above | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level.

---

### 2 · UUID Object Editor

#### 15 · CHANGED · Lists / SpellLists · `43261c49-335c-4231-ae5d-6a828cff974c` ("Unbound Level 1")

| Field | Before | After |
|---|---|---|
| Spells | `Target_Arcana_Card_Spell_GaleBurst;Target_TrueStrike` | `Target_Arcana_Card_Spell_GaleBurst` |

#### 16 · CHANGED · Progressions / Progressions · `71db6872-91ab-4b2f-97e8-bac5da934f48` (table `d75cb44d…`, level 1, the multiclass row)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_1;Arcana_Passive_BetheLeaf;Arcana_Passive_FlowingStrikesAgility;Arcana_Passive_FlowingStrikesPrecision;Arcana_Passive_FlowingStrikeZephyr;Monk_SoundSwitch;UnlockedSpellSlotLevel1` | `Arcana_Passive_BetheLeaf;Arcana_Passive_FlowingStrikesAgility;Arcana_Passive_FlowingStrikesPrecision;Arcana_Passive_FlowingStrikeZephyr;Monk_SoundSwitch;UnlockedSpellSlotLevel1;Arcana_Passive_Weightless_1;Arcana_Passive_Windswept_Touch` |

#### 17 · CHANGED · Progressions / Progressions · `5a26cfd4-4d2c-461e-a939-e74ce87fe3c6` (table `d75cb44d…`, level 1)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_1;Arcana_Passive_BetheLeaf;Arcana_Passive_FlowingStrikesAgility;Arcana_Passive_FlowingStrikesPrecision;Arcana_Passive_FlowingStrikeZephyr;Monk_SoundSwitch;UnlockedSpellSlotLevel1` | `Arcana_Passive_BetheLeaf;Arcana_Passive_FlowingStrikesAgility;Arcana_Passive_FlowingStrikesPrecision;Arcana_Passive_FlowingStrikeZephyr;Monk_SoundSwitch;UnlockedSpellSlotLevel1;Arcana_Passive_Weightless_1;Arcana_Passive_Windswept_Touch` |

#### 18 · CHANGED · CharacterCreationPresets / AbilityDistributionPresets · `e611f20a-75c8-47ac-8323-c9e65898c1ec` (class `dc2e68d3…` Unbound)

| Field | Before | After |
|---|---|---|
| Strength | `10` | `8` |
| Constitution | `10` | `13` |
| Wisdom | `13` | `10` |
| Charisma | `8` | `10` |

Numbers: `CLS_Unbound#preset_next` (STR 8 · DEX 15 · CON 13 · INT 15 · WIS 10 · CHA 10, WB21: DEX and INT for Be the Leaf).

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01–02 · NEW · StatusData / Status_BOOST · Windswept, `ARCANA_ZEPHYR_RUSH`

| Field | `ARCANA_WINDSWEPT` | `ARCANA_ZEPHYR_RUSH` |
|---|---|---|
| Name | `ARCANA_WINDSWEPT` | `ARCANA_ZEPHYR_RUSH` |
| DisplayName | `Windswept` | `Zephyr Strike` |
| Description | `Touched by the wind. Can't make Opportunity Attacks.<br><br>Suffers the bane of any wind the Windborn releases.` | `You can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag> this turn.<br><br>Equipping armour or a shield ends this effect.` |
| Icon | `Spell_Evocation_GustOfWind` | `Action_Monk_StepOfTheWind_Dash` |
| StackId | `ARCANA_WINDSWEPT` | `ARCANA_ZEPHYR_RUSH` |
| StackType | `Overwrite` | — |
| TickType | `EndTurn` | `StartTurn` |
| Boosts | — | `UnlockSpell(Rush_Arcana_Created_ZephyrRush);` |
| RemoveConditions | — | `WearingArmor(context.Source) or HasShieldEquipped(context.Source)` |
| RemoveEvents | `OnCombatEnded` | `OnEquip` |
| StatusPropertyFlags | `TickingWithSource;ForceOverhead` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |

Notes — `ARCANA_WINDSWEPT`:
- The mark (WB8, WB9). `TickType EndTurn` with `TickingWithSource`: the 2 turns of `ApplyStatus(…,100,2)` count down on the Windborn's turns only, so a mark lasts until the end of her next turn. Opportunity Attacks are switched off by the Open Path (block of `Interrupt_AttackOfOpportunity`), not by this status.
- The Icon is a suggestion.

Numbers: `2` (the `ApplyStatus(ARCANA_WINDSWEPT,100,2)` of every mark: 2 of her turn ends) = `FEAT_Unbound_TheOpenRoad#windswept_duration_next`.

Notes — `ARCANA_ZEPHYR_RUSH`:
- Unlocks Zephyr Rush for the turn, the twin of the existing `ZEPHYR_STRIKE` (The Open Road applies both after an unarmed attack or a card).
- The Icon is a suggestion.

#### 03–04 · NEW · Stats / Passive · Weightless, Windswept

| Field | `Arcana_Passive_Weightless_1` | `Arcana_Passive_Windswept_Touch` |
|---|---|---|
| Name | `Arcana_Passive_Weightless_1` | `Arcana_Passive_Windswept_Touch` |
| DisplayName | `Weightless` | `Windswept` |
| Description | `You move as if the air carried you. Your movement speed increases by [1].` | — |
| DescriptionParams | `Distance(3)` | — |
| ExtraDescription | `Only active while not wearing armour or using a shield.` | — |
| Icon | `PassiveFeature_UnarmoredMovement` | — |
| Properties | `Highlighted` | `IsHidden` |
| BoostContext | `OnEquip;OnCreate` | — |
| BoostConditions | `not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` | — |
| Boosts | `ActionResource(Movement,3,0);` | — |
| StatsFunctorContext | — | `OnDamage` |
| StatsFunctorConditions | — | `Enemy() and TotalDamageDoneGreaterThan(0) and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` |
| StatsFunctors | — | `ApplyStatus(ARCANA_WINDSWEPT,100,2)` |

Notes — `Arcana_Passive_Weightless_1`:
- Weightless rank 1 (WB39, WB47) replaces Twinkle Toes. Ranks 4, 8 and 12 inherit from it.
- The Icon is a suggestion.

Numbers: `3` = `FEAT_Unbound_Weightless#speed_next` (level 1).

Notes — `Arcana_Passive_Windswept_Touch`:
- Hidden; The Open Road explains it. P7 (QA-0004): `OnAttack` caught only weapon attacks; `OnDamage` with `TotalDamageDoneGreaterThan(0)` marks on any damage she deals, and a miss marks nothing.

Numbers: `2` = `FEAT_Unbound_TheOpenRoad#windswept_duration_next`.

#### 05 · NEW · SpellData / Rush · `Rush_Arcana_Created_ZephyrRush`

| Field | `Rush_Arcana_Created_ZephyrRush` |
|---|---|
| Name | `Arcana_Created_ZephyrRush` |
| Using | `SpringAttack` |
| Level | `1` |
| Cooldown | — |
| SpellProperties | `IF(not Player(context.Source)):ApplyStatus(SELF,AI_HELPER_EXTRAATTACK,100,1);` |
| TargetRadius | `12` |
| HitRadius | `1.5` |
| Movement Speed | `60000` |
| SpellRoll | `Attack(AttackType.MeleeUnarmedAttack)` |
| SpellSuccess | `DealDamage(UnarmedDamage,Bludgeoning);IF(HasPassive('Arcana_Passive_Zephyr_Gale',context.Source)):Force(3);` |
| TargetConditions | `Character() and Enemy() and not Dead() and not HasStatus('ARCANA_WINDSWEPT') and not HasPassive('ARCANA_IS_CARD', context.Source) and (DistanceToTargetLessThan(9) or HasPassive('Arcana_Passive_Zephyr_Gale', context.Source))` |
| Icon | `Action_Monk_StepOfTheWind_Dash` |
| DisplayName | `Zephyr Strike` |
| Description | `Ride the wind to an enemy it hasn't touched yet and strike it with an open hand.` |
| ExtraDescription | `Only an enemy that isn't <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag>.<br><br>Gale: the strike pushes the target back.<br>Storm: after this strike, the wind can carry you to one more.<br><br>Can only be used while not wearing armour or using a shield.` |
| TooltipDamageList | `DealDamage(UnarmedDamage,Bludgeoning)` |
| TooltipAttackSave | `MeleeUnarmedAttack` |
| TooltipStatusApply | — |
| TooltipPermanentWarnings | `Doesn't provoke Opportunity Attacks.` |
| CastSound | `Action_Cast_SpringAttack` |
| PreviewCursor | `Melee` |
| CastTextEvent | `Cast` |
| Requirements | `!Immobile` |
| CycleConditions | `Enemy() and not Dead()` |
| UseCosts | `BonusActionPoint:1;` |
| Required Weapon Type | — |
| SpellFlags | `IsMelee;IsHarmful;Temporary;DisableBlood` |
| AnimationIntentType | `Aggressive` |
| RechargeValues | — |
| Intent | `Damage` |
| RequirementConditions | `not HasStatus('SG_Polymorph_BeastShape') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);` |
| StopAtFirstContact | `0` |
| HitExtension | `1` |
| OnlyHit1Target | `1` |
| DamageType | `Bludgeoning` |
| Sheathing | `DontChange` |

Notes — `Rush_Arcana_Created_ZephyrRush` (`Using` = `SpringAttack`; search `SpringAttack` in the picker):
- **Copy from the parent in the Toolkit, then remove `Using`:** CastEffect, HitEffect, PrepareEffect, PreviewEffect, Spell Animation.
- **From the parent:** HitRadius, TooltipPermanentWarnings, CastSound, PreviewCursor, CastTextEvent, Requirements,
  CycleConditions, AnimationIntentType, Intent, StopAtFirstContact, HitExtension, OnlyHit1Target.
- **Ours:** Level, SpellProperties, TargetRadius (the parent has `9`), Movement Speed (the parent has `40000`),
  SpellRoll (the parent has `Attack(AttackType.MeleeWeaponAttack)`), SpellSuccess (the parent has `IF(Character() and
  not SavingThrow(Ability.Strength,
  ManeuverSaveDC())):ApplyStatus(OFF_BALANCED,100,2);DealDamage(ImprovisedWeapon+max(DexterityModifier,StrengthModifier),
  Piercing);ExecuteWeaponFunctors(MainHand)`), TargetConditions (the parent has `(Character() and not Ally() and not
  Dead()) or Item()`), Icon (the parent has `Action_Rush_New`), DisplayName, Description, ExtraDescription,
  TooltipDamageList (the parent has `DealDamage(1d4+max(DexterityModifier,StrengthModifier), Piercing)`),
  TooltipAttackSave (the parent has `MeleeWeaponAttack;Strength`), UseCosts (the parent has `ActionPoint:1`),
  SpellFlags (the parent has `IsHarmful;IsDefaultWeaponAction`), RequirementConditions (the parent has
  `CanUseWeaponActions() and IsProficientWithEquippedWeapon()`), DamageType (the parent has `Piercing`), Sheathing
  (the parent has `Melee`).
- **Clears the parent:** Cooldown (the parent has `OncePerShortRest`), TooltipStatusApply (the parent has
  `ApplyStatus(OFF_BALANCED,100,2)`), Required Weapon Type (the parent has `Melee`), RechargeValues (the parent has
  `4-6`).
- Zephyr's Rush (WB5): only to an enemy that isn't Windswept; 9 m at Breeze, 12 m from Gale (the `DistanceToTargetLessThan(9) or HasPassive(Gale)` term). `Rush_SpringAttack` is a weapon action: its Cooldown, RechargeValues, Required Weapon Type and weapon requirement are cleared (the ARC-0026 probe P1). Unlocked for the turn by `ARCANA_ZEPHYR_RUSH`.
- The Icon is a suggestion.

Numbers: `12` (TargetRadius) = `FEAT_Unbound_TheOpenRoad#rush_range_next`; `9` (`DistanceToTargetLessThan`) = `#rush_range_breeze_next`; `3` (`Force`) = `#gale_push_next`.

#### 06 · NEW · Stats / Interrupt · `Interrupt_AttackOfOpportunity`

| Field | `Interrupt_AttackOfOpportunity` |
|---|---|
| Name | `Interrupt_AttackOfOpportunity` |
| DisplayName | `Opportunity Attack` |
| Description | `Attack an enemy moving out of your reach.` |
| Icon | `PassiveFeature_AttackOfOpportunity` |
| InterruptContext | `OnLeaveAttackRange` |
| InterruptContextScope | `Self` |
| Container | `YesNoDecision` |
| Conditions | `IsAbleToReact(context.Observer) and not Self(context.Observer, context.Target) and Enemy() and not HasStatus('SANCTUARY',context.Source) and not WieldingWeapon('Ammunition', false, false, context.Source) and not (not Player(context.Source) and Tagged('AI_IGNORED_TARGET')  and not HasStatus('GNOLL_SUDDENRUSH')) and not HasStatus('SHOCKWAVE') and not (HasStatus('MOBILE_NO_AOO', context.Source) and HasStatus('MOBILE_NO_AOO_SOURCE', context.Target)) and not HasStatus('FLAMING_SPHERE_AURA') and not HasStatus('SNEAKING',context.Target) and not HasStatus('SG_Ignore_AOO',context.Target)  and not AnyEntityIsItem() and not HasSpellFlag(SpellFlags.IgnoreAoO, context.Target)` |
| Properties | `IF(not HasPassive('Sentinel_ZeroSpeed',context.Source)):UseAttack();IF(HasPassive('Sentinel_ZeroSpeed',context.Source)):UseSpell(Target_Sentinel_AttackOfOpportunity,true,true,true);TutorialEvent(SWAP,f658a860-7e3e-44fd-807b-88d3c0c31217)` |
| Cost | `ReactionActionPoint:1` |
| DefaultValue | `Enabled` |
| EnableCondition | `not HasStatus('SG_Blinded') and not HasStatus('ARCANA_WINDSWEPT');` |
| EnableContext | `OnStatusApplied;OnStatusRemoved` |

Notes — `Interrupt_AttackOfOpportunity`:
- The Open Path (WB10, P6 plan B, WB49): a mod copy of the vanilla opportunity attack with the same name, so it replaces it. Every field is vanilla except `EnableCondition`: a Windswept reactor makes no opportunity attack, the way `SG_Blinded` already does. No `Using` (it would point at itself): copy the vanilla entry into the mod the way you did for probe P6 (its texts come along). shortcut: another mod that edits this interrupt wins or loses by load order.
- The Icon is a suggestion.

#### 07 · CHANGED · Stats / Passive · `Arcana_Passive_BetheLeaf`

| Field | Before | After |
|---|---|---|
| Boosts | `ACOverrideFormula(10,true,Dexterity,Wisdom)` | `ACOverrideFormula(10,true,Dexterity,Intelligence)` |

Notes — `Arcana_Passive_BetheLeaf`:
- Be the Leaf (WB21): Intelligence instead of Wisdom in the Armour Class.

#### 08 · CHANGED · Stats / Passive · `Arcana_Passive_FlowingStrikeZephyr`

| Field | Before | After |
|---|---|---|
| DescriptionParams | `DealDamage(LevelMapValue(Precision_UnarmedDamage),Bludgeoning)` | — |
| ExtraDescription | (existing handle `h73613d54g9e1dg231dg03c1gcb8d2ba41166`) | `Windswept lasts until the end of your next turn. Windswept enemies can't make Opportunity Attacks.<br><br>Only active while not wearing armour or using a shield.` |
| StatsFunctorConditions | `((IsMeleeAttack() and IsMonkWeaponAttack() and not SpellId('Target_UnarmedStrike_Monk')) or IsCardSpell() or SpellId('Target_TrueStrike')) and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);` | `((IsMeleeAttack() and IsMonkWeaponAttack() and not SpellId('Target_UnarmedStrike_Monk')) or IsCardSpell()) and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);` |
| StatsFunctors | `ApplyStatus(SELF,ZEPHYR_STRIKE,100,1)` | `ApplyStatus(SELF,ZEPHYR_STRIKE,100,1);ApplyStatus(SELF,ARCANA_ZEPHYR_RUSH,100,1)` |

Notes — `Arcana_Passive_FlowingStrikeZephyr`:
- **ExtraDescription: make a new handle.** The old one (`h73613d54g9e1dg231dg03c1gcb8d2ba41166`) is also used by `Arcana_Passive_Aspect_Fool_II.ExtraDescription`, `Arcana_Passive_Aspect_Fool_III.ExtraDescription`, `Arcana_Passive_Aspect_Fool_I.ExtraDescription`: type the new text into a new handle, don't edit the old text.
- The Open Road (WB3, WB27): the core passive keeps its id (ADR-0002). True Strike leaves its condition (WB29); after an unarmed attack or a card it now grants Zephyr Strike **and** Zephyr Rush for the turn.

#### 09 · CHANGED · SpellData / Target · `Target_Arcana_Card_Spell_GaleBurst`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,MARTIAL_ARTS_BONUS_UNARMED_STRIKE,100,1)` | — |
| SpellSuccess | `DealDamage(1d10,Thunder);Force(6);ApplyStatus(PRONE,100,1);` | `DealDamage(1d10,Thunder);Force(6);ApplyStatus(PRONE,100,1);ApplyStatus(ARCANA_WINDSWEPT,100,2);` |

Notes — `Target_Arcana_Card_Spell_GaleBurst`:
- Gale Burst marks on a failed save (WB8) and loses its free unarmed strike (WB28: its `SpellProperties` go).

#### 10 · CHANGED · SpellData / Target · `Target_Arcana_Card_Spell_GaleBurst_3`

| Field | Before | After |
|---|---|---|
| SpellSuccess | `DealDamage(2d10,Thunder);Force(7);ApplyStatus(PRONE,100,1);` | `DealDamage(2d10,Thunder);Force(7);ApplyStatus(PRONE,100,1);ApplyStatus(ARCANA_WINDSWEPT,100,2);` |

Notes — `Target_Arcana_Card_Spell_GaleBurst_3`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Gale Burst marks on a failed save (WB8) and loses its free unarmed strike (WB28: its `SpellProperties` go).

#### 11 · CHANGED · SpellData / Target · `Target_Arcana_Card_Spell_GaleBurst_4`

| Field | Before | After |
|---|---|---|
| SpellSuccess | `DealDamage(2d10,Thunder);Force(7);ApplyStatus(PRONE,100,1);` | `DealDamage(2d10,Thunder);Force(7);ApplyStatus(PRONE,100,1);ApplyStatus(ARCANA_WINDSWEPT,100,2);` |

Notes — `Target_Arcana_Card_Spell_GaleBurst_4`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Gale Burst marks on a failed save (WB8) and loses its free unarmed strike (WB28: its `SpellProperties` go).

#### 12 · CHANGED · SpellData / Target · `Target_Arcana_Card_Spell_GaleBurst_5`

| Field | Before | After |
|---|---|---|
| SpellSuccess | `DealDamage(3d10,Thunder);Force(8);ApplyStatus(PRONE,100,1);` | `DealDamage(3d10,Thunder);Force(8);ApplyStatus(PRONE,100,1);ApplyStatus(ARCANA_WINDSWEPT,100,2);` |

Notes — `Target_Arcana_Card_Spell_GaleBurst_5`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Gale Burst marks on a failed save (WB8) and loses its free unarmed strike (WB28: its `SpellProperties` go).

#### 13 · CHANGED · SpellData / Target · `Target_Arcana_Card_Spell_GaleBurst_6`

| Field | Before | After |
|---|---|---|
| SpellSuccess | `DealDamage(3d10,Thunder);Force(8);ApplyStatus(PRONE,100,1);` | `DealDamage(3d10,Thunder);Force(8);ApplyStatus(PRONE,100,1);ApplyStatus(ARCANA_WINDSWEPT,100,2);` |

Notes — `Target_Arcana_Card_Spell_GaleBurst_6`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Gale Burst marks on a failed save (WB8) and loses its free unarmed strike (WB28: its `SpellProperties` go).

#### 14 · CHANGED · SpellData / Target · `Target_Arcana_Created_ZephyrStrike`

| Field | Before | After |
|---|---|---|
| SpellSuccess | `DealDamage(UnarmedDamage,Bludgeoning);` | `DealDamage(UnarmedDamage,Bludgeoning);IF(HasPassive('Arcana_Passive_Zephyr_Gale',context.Source)):Force(3);` |

Notes — `Target_Arcana_Created_ZephyrStrike`:
- The plain strike against a Windswept enemy; from Gale (level 4) it also pushes 3 m. The `IF(HasPassive)` reads the rank, so nothing changes here at level 4.

Numbers: `3` (`Force`) = `FEAT_Unbound_TheOpenRoad#gale_push_next`.

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 19 | Gale Burst `_2` (inherits the base) and `ARCANA_CardFamilies` rows for Zephyr Rush | `82_Automation/stats/gen_upcast_variants.pl --apply`, then `sort_stats.pl --apply` and `check_cards.pl` | after you save |
| 20 | Zephyr Rush: a deck card (`cost 1`) and `ARCANA_ZEPHYR_RUSH` in `statusConjures`. | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**New handles** (typed in the blocks above):

| Key | English text |
|---|---|
| `WB_WINDSWEPT_NAME` | `Windswept` |
| `WB_WINDSWEPT_DESC` | `Touched by the wind. Can't make Opportunity Attacks.<br><br>Suffers the bane of any wind the Windborn releases.` |
| `new handle (the text of `h939a9ea3gfbabg50bbgaa8fga3efd4c6de88`)` | `Zephyr Strike` |
| `new handle (the text of `h56efad21g20d8gbfd6g293dg4e2c421af268`)` | `You can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag> this turn.<br><br>Equipping armour or a shield ends this effect.` |
| `WB_WEIGHTLESS` | `Weightless` |
| `new handle (the text of `h73613d54g9e1dg231dg03c1gcb8d2ba41166`)` | `Only active while not wearing armour or using a shield.` |
| `WB_WEIGHTLESS_1_DESC` | `You move as if the air carried you. Your movement speed increases by [1].` |
| `new handle (the text of `h56bc27caga588g2b1agc487ge918b523cedf`)` | `Zephyr Strike` |
| `WB_ZEPHYR_RUSH_DESC` | `Ride the wind to an enemy it hasn't touched yet and strike it with an open hand.` |
| `WB_ZEPHYR_EXTRA` | `Only an enemy that isn't <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag>.<br><br>Gale: the strike pushes the target back.<br>Storm: after this strike, the wind can carry you to one more.<br><br>Can only be used while not wearing armour or using a shield.` |
| `WB_OPENROAD_EXTRA` | `Windswept lasts until the end of your next turn. Windswept enemies can't make Opportunity Attacks.<br><br>Only active while not wearing armour or using a shield.` |

**Existing handles whose text changes** (open the entry, then the text of the field):

| Handle | Used by | Before | After |
|---|---|---|---|
| `h1e5b5d84gf8fag7d7bgc878g960616bd7ae2` | `Arcana_Passive_FlowingStrikeZephyr.Description` | `After making an unarmed attack or casting an Arcane spell, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `Every enemy you hit, or that fails a <LSTag Tooltip="SavingThrow">Saving Throw</LSTag> against you, becomes <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag>. After an unarmed attack or a card, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a bonus action - against an enemy that isn't Windswept, the wind carries you to it.` |
| `h80210a1ag08f6gf70fgdf96g821b0e1e8847` | `Arcana_Passive_BetheLeaf.Description` | `Your reflexes are as effective as armour. You add your Wisdom <LSTag Tooltip="AbilityModifier">Modifier</LSTag> to your <LSTag Tooltip="ArmourClass">Armour Class</LSTag>.` | `Your reflexes are as effective as armour. You add your Intelligence <LSTag Tooltip="AbilityModifier">Modifier</LSTag> to your Armour Class.` |
| `h869a34deg0c99gfa1bg8672g22a4fb8339b4` | `ProgressionDescriptions (the subclass) · DisplayName` | `The Unbound` | `The Windborn` |
| `h8bcf3e57gbc72gd8bbg1503g0762e93077a9` | `ClassDescriptions `Unbound` · DisplayName` | `The Unbound` | `The Windborn` |
| `h99c87996ge8c7g0090gfd52g5145a4e60f30` | `Arcana_Passive_FlowingStrikeZephyr.DisplayName` | `Flowing Strikes: Zephyr` | `The Open Road` |
| `h9a3184f7g73a8g6169g04a6g6dc398547d7f` | `ProgressionDescriptions (the subclass) · Description` | `The Unbound follows the Weave into the unknown, striking with open hands and moving air and never standing where an enemy expects.` | `The Windborn follows the Weave into the unknown, touching every foe once and riding the wind to the next.` |
| `hc3b60f05g2de4ge349g47cdgbfd318148ba4` | `Target_Arcana_Card_Spell_GaleBurst.Description` | `Channel the air into your fist and release it in a focused burst, launching your target backwards [1] and knocking it <LSTag Type="Status" Tooltip="PRONE">Prone</LSTag>.<br><br>Afterwards, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `Channel the air into your fist and release it in a focused burst, launching your target backwards [1] and knocking it <LSTag Type="Status" Tooltip="PRONE">Prone</LSTag>.` |
| `hd9d08b83g0a51g6c77g9187g4e63243b7a82` | `found only in the localisation files (the spell book tab)` | `Arcane Spells: The Unbound` | `Arcane Spells: The Windborn` |
| `he3d63e7ege30bg4ab2gb047ga84261db272b` | `RootTemplate `d586b188…` (the robe) · DisplayName` | `Unbound's Robe` | `Windborn's Robe` |
| `hf4767ceag7e98g7466g81cdg572e1744f0aa` | `Tag `1901f3df…` · DisplayName` | `The Unbound` | `The Windborn` |
| `hf756bce1g79bag5985ga624gb4cc6e843978` | `ClassDescriptions `Unbound` · Description` | `Mystra wove the Unbound from the first step of every journey, a thread that answers only to curiosity and the open road. They wear no armour and strike with open hands and moving air, slipping past every blow until the ground itself stops holding them down.` | `Mystra wove the Windborn from the first step of every journey, a thread that answers only to curiosity and the open road. They wear no armour and strike with open hands and moving air, carried from one foe to the next until the winds they gather break loose.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 1 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-1 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L1) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 2

> **What this file is.** The point-by-point guide to enter **level 2** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Aeolus' Bag (Boreas, Notus)*. Headline: "I can open the bag". Technical source: `SPEC_ARC-0026` (stage 2).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 1 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `ARCANA_BAG_OPEN` | new | — | ☐ |
| 02 | Stats Editor | StatusData / Status_BOOST | `ARCANA_BAG_READY` | new | — | ☐ |
| 03 | Stats Editor | StatusData / Status_BOOST | `ARCANA_HEADWIND_BOREAS` | new | — | ☐ |
| 04 | Stats Editor | StatusData / Status_BOOST | `ARCANA_HEADWIND_NOTUS` | new | — | ☐ |
| 05 | Stats Editor | StatusData / Status_BOOST | `ARCANA_TAILWIND_BOREAS` | new | — | ☐ |
| 06 | Stats Editor | StatusData / Status_BOOST | `ARCANA_TAILWIND_NOTUS` | new | — | ☐ |
| 07 | Stats Editor | StatusData / Status_BOOST | `ARCANA_WIND_BOREAS` | new | — | ☐ |
| 08 | Stats Editor | StatusData / Status_BOOST | `ARCANA_WIND_NOTUS` | new | — | ☐ |
| 09 | Stats Editor | Stats / Passive | `Arcana_Passive_AeolusBag` | new | — | ☐ |
| 10 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag` | new | — | ☐ |
| 11 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag_Boreas` | new | — | ☐ |
| 12 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag_Notus` | new | — | ☐ |
| 13 | UUID Object Editor | Lists / SpellLists | "Unbound Level 2" | new | — | ☐ |
| 14 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 2 | change | — | ☐ |
| 15 | Stories | Goals | `ARCANA_Aspect_Fool` | **replace the whole text** | 02, 01 | ☐ |
| 16 | — | PC edition | `CardDB.lua` | Claude adds the lines | all above | ☐ |

---

### 1 · Stories (Osiris)

#### 15 · CHANGED goal `ARCANA_Aspect_Fool` — select all its text and paste this over it

It replaces the Wanderlust round goal. What it does (all levels; the parts of later levels wait for their passives and statuses):
marks mirrored in `DB_ARCANA_Windswept` (hers, and her allies' at Tier II); the bag counts X (her standing Windswept
enemies, capped 2 / 3 / 4 / 5 by Zephyr's rank), releases every mark and starts the chosen wind(s) for X of her turns,
a sweep at each of her turn starts while it blows, `ARCANA_BAG_OPEN` showing the turns left; The Calm's gusts; Tier I's
free Rush; Tier III's push on each sweep; each released mark is one Awakening step; the reset at combat end.

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION
PROC_ARCANA_Fool_Init();

KBSECTION
// The Fool / the Windborn (internal: Unbound), ARC-0026 (WB8-WB25). Replaces the Wanderlust round goal.
// Marks: ARCANA_WINDSWEPT on an enemy, with her as the source (her hits: Arcana_Passive_Windswept_Touch; her save
// cards: their SpellSuccess; her allies' hits at Tier II: here). DB_ARCANA_Windswept(_Born, _Foe) mirrors them.
// The bag: opening counts X (her Windswept enemies, capped by Zephyr's rank), releases every mark and starts the
// chosen wind(s) for X of her turns; while it blows, each of her turns starts with a sweep. Every released mark is
// one Awakening step (PROC_ARCANA_Aspect_Step, goals 3/5/8 in ARCANA_Aspect_Common.txt).
// Entered by the Owner at level 2 of TOOLKIT_ARC-0026 (it replaces the whole goal); level 3 sets the three FOOL rows
// of DB_ARCANA_AspectTier in ARCANA_Aspect_Common to 3 / 5 / 8. Compile in the Story Editor.

//REGION Tables
PROC
PROC_ARCANA_Fool_Init()
AND
DB_ARCANA_BagWind(_Spell, _Wind)
THEN
NOT DB_ARCANA_BagWind(_Spell, _Wind);

PROC
PROC_ARCANA_Fool_Init()
AND
DB_ARCANA_BagSpell(_Spell)
THEN
NOT DB_ARCANA_BagSpell(_Spell);

PROC
PROC_ARCANA_Fool_Init()
AND
DB_ARCANA_CalmGust(_R, _Gust)
THEN
NOT DB_ARCANA_CalmGust(_R, _Gust);

PROC
PROC_ARCANA_Fool_Init()
THEN
DB_ARCANA_BagSpell("Shout_Arcana_Created_AeolusBag_Boreas");
DB_ARCANA_BagSpell("Shout_Arcana_Created_AeolusBag_Notus");
DB_ARCANA_BagSpell("Shout_Arcana_Created_AeolusBag_Eurus");
DB_ARCANA_BagSpell("Shout_Arcana_Created_AeolusBag_BoreasNotus");
DB_ARCANA_BagSpell("Shout_Arcana_Created_AeolusBag_BoreasEurus");
DB_ARCANA_BagSpell("Shout_Arcana_Created_AeolusBag_NotusEurus");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_Boreas", "ARCANA_WIND_BOREAS");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_Notus", "ARCANA_WIND_NOTUS");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_Eurus", "ARCANA_WIND_EURUS");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_BoreasNotus", "ARCANA_WIND_BOREAS");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_BoreasNotus", "ARCANA_WIND_NOTUS");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_BoreasEurus", "ARCANA_WIND_BOREAS");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_BoreasEurus", "ARCANA_WIND_EURUS");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_NotusEurus", "ARCANA_WIND_NOTUS");
DB_ARCANA_BagWind("Shout_Arcana_Created_AeolusBag_NotusEurus", "ARCANA_WIND_EURUS");
DB_ARCANA_CalmGust(1, "ARCANA_CALM_GUST_1");
DB_ARCANA_CalmGust(2, "ARCANA_CALM_GUST_2");
DB_ARCANA_CalmGust(3, "ARCANA_CALM_GUST_3");
DB_ARCANA_CalmGust(4, "ARCANA_CALM_GUST_4");
DB_ARCANA_CalmGust(5, "ARCANA_CALM_GUST_5");

IF
SavegameLoaded()
THEN
PROC_ARCANA_Fool_Init();
//END_REGION

//REGION Marks
IF
StatusApplied((CHARACTER)_Foe, "ARCANA_WINDSWEPT", (CHARACTER)_Born, _)
AND
HasPassive(_Born, "Arcana_Passive_Windswept_Touch", 1)
THEN
DB_ARCANA_Windswept(_Born, _Foe);
PROC_ARCANA_Fool_Ready(_Born);

PROC
PROC_ARCANA_Fool_Ready((CHARACTER)_Born)
AND
HasPassive(_Born, "Arcana_Passive_AeolusBag", 1)
THEN
ApplyStatus(_Born, "ARCANA_BAG_READY", -1.0, 1, _Born);

IF
StatusRemoved((CHARACTER)_Foe, "ARCANA_WINDSWEPT", _, _)
AND
DB_ARCANA_Windswept(_Born, _Foe)
THEN
NOT DB_ARCANA_Windswept(_Born, _Foe);
PROC_ARCANA_Fool_ReadyCheck(_Born);

PROC
PROC_ARCANA_Fool_ReadyCheck((CHARACTER)_Born)
AND
NOT DB_ARCANA_Windswept(_Born, _)
THEN
RemoveStatus(_Born, "ARCANA_BAG_READY", _Born);

// Tier II Fellow Travellers: an ally's hit marks the enemy in her name (2 of her turns, as her own marks)
IF
AttackedBy((CHARACTER)_Foe, (CHARACTER)_Ally, _, _, _, _, _)
AND
DB_ARCANA_AspectReached(_Born, 2)
AND
HasPassive(_Born, "Arcana_Passive_Aspect_Fool_II", 1)
AND
_Ally != _Born
AND
DB_ARCANA_Aspect_InCombat(_Born, _Combat)
AND
DB_ARCANA_Aspect_InCombat(_Ally, _Combat)
AND
IsEnemy(_Born, _Foe, 1)
AND
IsEnemy(_Born, _Ally, 0)
THEN
ApplyStatus(_Foe, "ARCANA_WINDSWEPT", 12.0, 1, _Born);
//END_REGION

//REGION Release: every released mark is one Awakening step; Tier III pushes each swept enemy
PROC
PROC_ARCANA_Fool_Release((CHARACTER)_Born)
THEN
PROC_ARCANA_Fool_ReleaseCount(_Born);
PROC_ARCANA_Fool_ReleaseClear(_Born);

// counted first, so the sweep that wakes Tier III already pushes
PROC
PROC_ARCANA_Fool_ReleaseCount((CHARACTER)_Born)
AND
DB_ARCANA_Windswept(_Born, _Foe)
THEN
PROC_ARCANA_Aspect_Step(_Born, "FOOL");

PROC
PROC_ARCANA_Fool_ReleaseClear((CHARACTER)_Born)
AND
DB_ARCANA_Windswept(_Born, _Foe)
THEN
PROC_ARCANA_Fool_Storm(_Born, _Foe);
RemoveStatus(_Foe, "ARCANA_WINDSWEPT", _Born);

PROC
PROC_ARCANA_Fool_Storm((CHARACTER)_Born, (CHARACTER)_Foe)
AND
DB_ARCANA_AspectReached(_Born, 3)
AND
HasPassive(_Born, "Arcana_Passive_Aspect_Fool_III", 1)
THEN
ApplyStatus(_Foe, "ARCANA_INTO_THE_STORM", 0.0, 1, _Born);
//END_REGION

//REGION The bag
IF
CastedSpell((CHARACTER)_Born, _Spell, _, _, _)
AND
DB_ARCANA_BagSpell(_Spell)
THEN
PROC_ARCANA_Fool_OpenBag(_Born, _Spell);

PROC
PROC_ARCANA_Fool_OpenBag((CHARACTER)_Born, (STRING)_Spell)
THEN
PROC_ARCANA_Fool_CountX(_Born);
PROC_ARCANA_Fool_CapX(_Born);
PROC_ARCANA_Fool_Release(_Born);
PROC_ARCANA_Fool_StartWind(_Born, _Spell);

// X = her standing Windswept enemies
PROC
PROC_ARCANA_Fool_CountX((CHARACTER)_Born)
AND
DB_ARCANA_BagX(_Born, _Old)
THEN
NOT DB_ARCANA_BagX(_Born, _Old);

PROC
PROC_ARCANA_Fool_CountX((CHARACTER)_Born)
THEN
DB_ARCANA_BagX(_Born, 0);

PROC
PROC_ARCANA_Fool_CountX((CHARACTER)_Born)
AND
DB_ARCANA_Windswept(_Born, _Foe)
AND
IsDead(_Foe, 0)
AND
DB_ARCANA_BagX(_Born, _N)
AND
IntegerSum(_N, 1, _M)
THEN
NOT DB_ARCANA_BagX(_Born, _N);
DB_ARCANA_BagX(_Born, _M);

// the cap by Zephyr's rank (25 FEAT_Unbound_AeolusBag wind_cap_next): Breeze 2, Gale 3, Storm 4, Hurricane 5
PROC
PROC_ARCANA_Fool_CapX((CHARACTER)_Born)
AND
DB_ARCANA_BagCap(_Born, _Old)
THEN
NOT DB_ARCANA_BagCap(_Born, _Old);

PROC
PROC_ARCANA_Fool_CapX((CHARACTER)_Born)
THEN
DB_ARCANA_BagCap(_Born, 2);

PROC
PROC_ARCANA_Fool_CapX((CHARACTER)_Born)
AND
HasPassive(_Born, "Arcana_Passive_Zephyr_Gale", 1)
THEN
NOT DB_ARCANA_BagCap(_Born, 2);
DB_ARCANA_BagCap(_Born, 3);

PROC
PROC_ARCANA_Fool_CapX((CHARACTER)_Born)
AND
HasPassive(_Born, "Arcana_Passive_Zephyr_Storm", 1)
AND
DB_ARCANA_BagCap(_Born, _Cap)
THEN
NOT DB_ARCANA_BagCap(_Born, _Cap);
DB_ARCANA_BagCap(_Born, 4);

PROC
PROC_ARCANA_Fool_CapX((CHARACTER)_Born)
AND
HasPassive(_Born, "Arcana_Passive_Zephyr_Hurricane", 1)
AND
DB_ARCANA_BagCap(_Born, _Cap)
THEN
NOT DB_ARCANA_BagCap(_Born, _Cap);
DB_ARCANA_BagCap(_Born, 5);

PROC
PROC_ARCANA_Fool_StartWind((CHARACTER)_Born, (STRING)_Spell)
AND
DB_ARCANA_BagX(_Born, _X)
AND
_X > 0
AND
DB_ARCANA_BagCap(_Born, _Cap)
AND
IntegerMin(_X, _Cap, _Turns)
THEN
PROC_ARCANA_Fool_SetTurns(_Born, _Turns);
PROC_ARCANA_Fool_Winds(_Born, _Spell);

PROC
PROC_ARCANA_Fool_Winds((CHARACTER)_Born, (STRING)_Spell)
AND
DB_ARCANA_BagWind(_Spell, _Wind)
THEN
ApplyStatus(_Born, _Wind, -1.0, 1, _Born);

PROC
PROC_ARCANA_Fool_SetTurns((CHARACTER)_Born, (INTEGER)_Turns)
AND
DB_ARCANA_BagTurns(_Born, _Old)
THEN
NOT DB_ARCANA_BagTurns(_Born, _Old);

PROC
PROC_ARCANA_Fool_SetTurns((CHARACTER)_Born, (INTEGER)_Turns)
THEN
DB_ARCANA_BagTurns(_Born, _Turns);

// "the bag is open" shows the turns left: the status is frozen, so the number is the one set here (RESONANT_OVERLOAD
// pattern, proved by probe P8)
PROC
PROC_ARCANA_Fool_SetTurns((CHARACTER)_Born, (INTEGER)_Turns)
AND
_Turns > 0
AND
IntegerProduct(_Turns, 6, _Secs)
AND
IntegerToReal(_Secs, _Dur)
THEN
ApplyStatus(_Born, "ARCANA_BAG_OPEN", _Dur, 1, _Born);

// X turns of wind, the opening turn included: each of her turns starts with a sweep while turns are left,
// each of her turns ends one turn shorter; at 0 the wind stops and the bag can open again
IF
TurnStarted((CHARACTER)_Born)
AND
DB_ARCANA_BagTurns(_Born, _T)
AND
_T > 0
THEN
PROC_ARCANA_Fool_Release(_Born);

IF
TurnEnded((CHARACTER)_Born)
AND
DB_ARCANA_BagTurns(_Born, _T)
AND
IntegerSubtract(_T, 1, _Left)
THEN
PROC_ARCANA_Fool_SetTurns(_Born, _Left);
PROC_ARCANA_Fool_WindCheck(_Born);

PROC
PROC_ARCANA_Fool_WindCheck((CHARACTER)_Born)
AND
DB_ARCANA_BagTurns(_Born, _T)
AND
_T <= 0
THEN
PROC_ARCANA_Fool_EndWind(_Born);

PROC
PROC_ARCANA_Fool_EndWind((CHARACTER)_Born)
AND
DB_ARCANA_BagTurns(_Born, _T)
THEN
NOT DB_ARCANA_BagTurns(_Born, _T);

PROC
PROC_ARCANA_Fool_EndWind((CHARACTER)_Born)
THEN
RemoveStatus(_Born, "ARCANA_BAG_OPEN", _Born);
RemoveStatus(_Born, "ARCANA_WIND_BOREAS", _Born);
RemoveStatus(_Born, "ARCANA_WIND_NOTUS", _Born);
RemoveStatus(_Born, "ARCANA_WIND_EURUS", _Born);
//END_REGION

//REGION The Calm: the remaining turns become gusts on every Windswept enemy, then release and the bag reopens
IF
CastedSpell((CHARACTER)_Born, "Shout_Arcana_Created_TheCalm", _, _, _)
AND
DB_ARCANA_BagTurns(_Born, _R)
AND
_R > 0
THEN
PROC_ARCANA_Fool_Gusts(_Born, _R);
PROC_ARCANA_Fool_Release(_Born);
PROC_ARCANA_Fool_EndWind(_Born);

PROC
PROC_ARCANA_Fool_Gusts((CHARACTER)_Born, (INTEGER)_R)
AND
DB_ARCANA_CalmGust(_R, _Gust)
AND
DB_ARCANA_Windswept(_Born, _Foe)
AND
IsDead(_Foe, 0)
THEN
ApplyStatus(_Foe, _Gust, 0.0, 1, _Born);
//END_REGION

//REGION Tier I The First Step: the first Rush each turn is free (FOOL_ZEPHYR_FREE unlocks the free Rush variant)
PROC
PROC_ARCANA_Aspect_OnTier((CHARACTER)_Born, (STRING)_Aspect, (INTEGER)_Tier)
AND
_Aspect == "FOOL"
AND
_Tier == 1
THEN
ApplyStatus(_Born, "FOOL_ZEPHYR_FREE", 6.0, 1, _Born);

IF
TurnStarted((CHARACTER)_Born)
AND
DB_ARCANA_AspectReached(_Born, 1)
AND
HasPassive(_Born, "Arcana_Passive_Aspect_Fool_I", 1)
THEN
ApplyStatus(_Born, "FOOL_ZEPHYR_FREE", 6.0, 1, _Born);

IF
CastedSpell((CHARACTER)_Born, _Spell, _, _, _)
AND
DB_ARCANA_CardFamily(_Spell, "Rush_Arcana_Created_ZephyrRush")
AND
HasActiveStatus(_Born, "FOOL_ZEPHYR_FREE", 1)
THEN
RemoveStatus(_Born, "FOOL_ZEPHYR_FREE", _Born);
//END_REGION

//REGION Cleanup (combat end: ARCANA_Aspect_Common.txt calls the reset)
PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Born)
AND
DB_ARCANA_Windswept(_Born, _Foe)
THEN
NOT DB_ARCANA_Windswept(_Born, _Foe);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Born)
AND
DB_ARCANA_BagX(_Born, _X)
THEN
NOT DB_ARCANA_BagX(_Born, _X);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Born)
AND
DB_ARCANA_BagCap(_Born, _Cap)
THEN
NOT DB_ARCANA_BagCap(_Born, _Cap);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Born)
THEN
PROC_ARCANA_Fool_EndWind(_Born);
RemoveStatus(_Born, "ARCANA_BAG_READY", _Born);
RemoveStatus(_Born, "FOOL_ZEPHYR_FREE", _Born);
//END_REGION
EXITSECTION

ENDEXITSECTION
```

Numbers: the cap `2` / `3` / `4` / `5` = `FEAT_Unbound_AeolusBag#wind_cap_next` `by_level`.

After pasting: **compile** in the Story Editor and read `Mods/AspectClass_…/Story/log.txt` — it must end with `0 error(s)`. A warning such as *Database defined but never checked* is a defect: send me the log.

---

### 2 · UUID Object Editor

#### 13 · NEW · Lists / SpellLists · "Unbound Level 2"

| Field | Value |
|---|---|
| Name | `Unbound Level 2` |
| Spells | `Shout_Arcana_Created_AeolusBag` |

UUID: ________ (used in step 14)

#### 14 · CHANGED · Progressions / Progressions · `8cf47f3b-3c5a-4736-ad7b-a6342fe06f1e` (table `d75cb44d…`, level 2)

| Field | Before | After |
|---|---|---|
| PassivesAdded | — | `Arcana_Passive_AeolusBag` |
| Selectors | — | `AddSpells(<UUID from step 13>,,,,AlwaysPrepared)` |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01–03 · NEW · StatusData / Status_BOOST · Aeolus' Bag: Untied, Aeolus' Bag, Headwind: Boreas

| Field | `ARCANA_BAG_OPEN` | `ARCANA_BAG_READY` | `ARCANA_HEADWIND_BOREAS` |
|---|---|---|---|
| Name | `ARCANA_BAG_OPEN` | `ARCANA_BAG_READY` | `ARCANA_HEADWIND_BOREAS` |
| DisplayName | `Aeolus' Bag: Untied` | `Aeolus' Bag` | `Headwind: Boreas` |
| Description | `A wind blows over the battle. The bag can't be opened again until it stops.` | — | `Chilled by the North Wind. Movement speed reduced by [1].` |
| DescriptionParams | — | — | `Distance(3)` |
| Icon | `Spell_Evocation_GustOfWind` | — | `Spell_Evocation_GustOfWind` |
| StackId | `ARCANA_BAG_OPEN` | `ARCANA_BAG_READY` | `ARCANA_HEADWIND_BOREAS` |
| Boosts | — | — | `ActionResource(Movement,-3,0)` |
| RemoveEvents | `OnCombatEnded` | `OnCombatEnded` | — |
| StatusPropertyFlags | `FreezeDuration;ForceOverhead` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `ForceOverhead` |

Notes — `ARCANA_BAG_OPEN`:
- "The bag is open": shows the turns of wind left. `FreezeDuration`: the number never ticks by itself; the goal sets it each time the count changes (the P8 pattern).
- The Icon is a suggestion.

Notes — `ARCANA_BAG_READY`:
- Technical: Osiris keeps it on her while she has a Windswept enemy; the bag needs it.

Notes — `ARCANA_HEADWIND_BOREAS`:
- The Icon is a suggestion.

Numbers: `3` = `FEAT_Unbound_AeolusBag#boreas_enemy_next`.

#### 04–06 · NEW · StatusData / Status_BOOST · Headwind: Notus, Tailwind: Boreas, Tailwind: Notus

| Field | `ARCANA_HEADWIND_NOTUS` | `ARCANA_TAILWIND_BOREAS` | `ARCANA_TAILWIND_NOTUS` |
|---|---|---|---|
| Name | `ARCANA_HEADWIND_NOTUS` | `ARCANA_TAILWIND_BOREAS` | `ARCANA_TAILWIND_NOTUS` |
| Using | `ARCANA_HEADWIND_BOREAS` | — | `ARCANA_TAILWIND_BOREAS` |
| DisplayName | `Headwind: Notus` | `Tailwind: Boreas` | `Tailwind: Notus` |
| Description | `Battered by the South Wind. [1] penalty to Saving Throws.` | `Carried by the North Wind. Movement speed increased by [1].` | `Cloaked by rain and fog. Ranged attacks against this creature have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag>.` |
| DescriptionParams | `1` | `Distance(3)` | — |
| Icon | `Spell_Evocation_GustOfWind` | `Action_Monk_StepOfTheWind_Dash` | `Action_Monk_StepOfTheWind_Dash` |
| StackId | `ARCANA_HEADWIND_NOTUS` | `ARCANA_TAILWIND_BOREAS` | `ARCANA_TAILWIND_NOTUS` |
| Boosts | `RollBonus(SavingThrow,-1)` | `ActionResource(Movement,3,0)` | `IF(IsRangedAttack()):Disadvantage(AttackTarget)` |
| StatusPropertyFlags | `ForceOverhead` | `ForceOverhead` | `ForceOverhead` |

Notes — `ARCANA_HEADWIND_NOTUS` (`Using` = `ARCANA_HEADWIND_BOREAS`; search `ARCANA_HEADWIND_BOREAS` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Icon, StatusPropertyFlags.
- **Ours:** DisplayName, Description, DescriptionParams (the parent has `Distance(3)`), StackId (the parent has
  `ARCANA_HEADWIND_BOREAS`), Boosts (the parent has `ActionResource(Movement,-3,0)`).
- The Icon is a suggestion.

Numbers: `1` = `FEAT_Unbound_AeolusBag#notus_enemy_next`.

Notes — `ARCANA_TAILWIND_BOREAS`:
- The Icon is a suggestion.

Numbers: `3` = `FEAT_Unbound_AeolusBag#boreas_ally_next`.

Notes — `ARCANA_TAILWIND_NOTUS` (`Using` = `ARCANA_TAILWIND_BOREAS`; search `ARCANA_TAILWIND_BOREAS` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Icon, StatusPropertyFlags.
- **Ours:** DisplayName, Description, StackId (the parent has `ARCANA_TAILWIND_BOREAS`), Boosts (the parent has
  `ActionResource(Movement,3,0)`).
- **Clears the parent:** DescriptionParams (the parent has `Distance(3)`).
- The Icon is a suggestion.

#### 07–08 · NEW · StatusData / Status_BOOST · Aeolus' Bag: Boreas, Aeolus' Bag: Notus

| Field | `ARCANA_WIND_BOREAS` | `ARCANA_WIND_NOTUS` |
|---|---|---|
| Name | `ARCANA_WIND_BOREAS` | `ARCANA_WIND_NOTUS` |
| Using | — | `ARCANA_WIND_BOREAS` |
| DisplayName | `Aeolus' Bag: Boreas` | `Aeolus' Bag: Notus` |
| StackId | `ARCANA_WIND_BOREAS` | `ARCANA_WIND_NOTUS` |
| AuraRadius | `30` | `30` |
| AuraStatuses | `IF(Ally()):ApplyStatus(ARCANA_TAILWIND_BOREAS);IF(Enemy() and HasStatus('ARCANA_WINDSWEPT')):ApplyStatus(ARCANA_HEADWIND_BOREAS)` | `IF(Ally()):ApplyStatus(ARCANA_TAILWIND_NOTUS);IF(Enemy() and HasStatus('ARCANA_WINDSWEPT')):ApplyStatus(ARCANA_HEADWIND_NOTUS)` |
| RemoveEvents | `OnCombatEnded` | `OnCombatEnded` |
| StatusPropertyFlags | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |

Notes — `ARCANA_WIND_BOREAS`:
- One aura per wind on her, the whole field (30 m). Osiris applies and removes it. Boon on allies, bane on Windswept enemies.

Notes — `ARCANA_WIND_NOTUS` (`Using` = `ARCANA_WIND_BOREAS`; search `ARCANA_WIND_BOREAS` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** AuraRadius, RemoveEvents, StatusPropertyFlags.
- **Ours:** DisplayName, StackId (the parent has `ARCANA_WIND_BOREAS`), AuraStatuses (the parent has
  `IF(Ally()):ApplyStatus(ARCANA_TAILWIND_BOREAS);IF(Enemy() and
  HasStatus('ARCANA_WINDSWEPT')):ApplyStatus(ARCANA_HEADWIND_BOREAS)`).

#### 09 · NEW · Stats / Passive · Aeolus' Bag

| Field | `Arcana_Passive_AeolusBag` |
|---|---|
| Name | `Arcana_Passive_AeolusBag` |
| DisplayName | `Aeolus' Bag` |
| Properties | `IsHidden` |

Notes — `Arcana_Passive_AeolusBag`:
- Hidden marker of level 2 (the goal and the bag read it).

#### 10–12 · NEW · SpellData / Shout · Aeolus' Bag, Aeolus' Bag: Boreas, Aeolus' Bag: Notus

| Field | `Shout_Arcana_Created_AeolusBag` | `Shout_Arcana_Created_AeolusBag_Boreas` | `Shout_Arcana_Created_AeolusBag_Notus` |
|---|---|---|---|
| Name | `Arcana_Created_AeolusBag` | `Arcana_Created_AeolusBag_Boreas` | `Arcana_Created_AeolusBag_Notus` |
| Using | `Arcana_Card_Spell_FlowState` | `Arcana_Created_AeolusBag` | `Arcana_Created_AeolusBag_Boreas` |
| Level | `0` | `0` | `0` |
| SpellSchool | `Evocation` | `Evocation` | `Evocation` |
| SpellContainerID | — | `Shout_Arcana_Created_AeolusBag` | `Shout_Arcana_Created_AeolusBag` |
| ContainerSpells | `Shout_Arcana_Created_AeolusBag_Boreas;Shout_Arcana_Created_AeolusBag_Notus` | — | — |
| SpellProperties | — | — | — |
| TargetConditions | — | — | — |
| Icon | `Spell_Evocation_GustOfWind` | `Spell_Evocation_GustOfWind` | `Spell_Evocation_GustOfWind` |
| DisplayName | `Aeolus' Bag` | `Aeolus' Bag: Boreas` | `Aeolus' Bag: Notus` |
| Description | `Untie the bag of winds and release one of them over the battle. It blows for 1 turn for each <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> enemy, and every mark is swept away.` | `Release Boreas, the North Wind. Your allies move faster, and Windswept enemies are slowed.` | `Release Notus, the South Wind. Rain and fog cloak your allies from ranged attacks, and Windswept enemies falter on their Saving Throws.` |
| ExtraDescription | `While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind.` | `While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind.` | `While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind.` |
| TooltipDamageList | — | — | — |
| TooltipStatusApply | — | — | — |
| CastSound | `Spell_Cast_Monk_WholenessOfBody_L1to3` | `Spell_Cast_Monk_WholenessOfBody_L1to3` | `Spell_Cast_Monk_WholenessOfBody_L1to3` |
| TargetSound | `Spell_Impact_Monk_WholenessOfBody_L1to3` | `Spell_Impact_Monk_WholenessOfBody_L1to3` | `Spell_Impact_Monk_WholenessOfBody_L1to3` |
| VocalComponentSound | — | — | — |
| PreviewCursor | `Cast` | `Cast` | `Cast` |
| CastTextEvent | `Cast` | `Cast` | `Cast` |
| UseCosts | `BonusActionPoint:1;` | `BonusActionPoint:1;` | `BonusActionPoint:1;` |
| Intent | `Buff` | `Buff` | `Buff` |
| Spell Style Group | `Class` | `Class` | `Class` |
| SpellFlags | `IsSpell;HasSomaticComponent;IsLinkedSpellContainer` | `IsSpell;HasSomaticComponent` | `IsSpell;HasSomaticComponent` |
| Requirements | `Combat` | `Combat` | `Combat` |
| RequirementConditions | `HasStatus('ARCANA_BAG_READY') and not HasStatus('ARCANA_BAG_OPEN') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` | `HasStatus('ARCANA_BAG_READY') and not HasStatus('ARCANA_BAG_OPEN') and not HasPassive('Arcana_Passive_Zephyr_Hurricane') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` | `HasStatus('ARCANA_BAG_READY') and not HasStatus('ARCANA_BAG_OPEN') and not HasPassive('Arcana_Passive_Zephyr_Hurricane') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` |
| Sheathing | — | — | — |

Notes — `Shout_Arcana_Created_AeolusBag` (`Using` = `Arcana_Card_Spell_FlowState`; search `Arcana_Card_Spell_FlowState` in the picker):
- **Copy from the parent in the Toolkit, then remove `Using`:** CastEffect, PrepareEffect, Spell Animation.
- **From the parent:** SpellSchool, CastSound, TargetSound, PreviewCursor, CastTextEvent, Intent, Spell Style Group,
  Requirements.
- **Ours:** Level (the parent has `2`), ContainerSpells, Icon (the parent has `Action_Monk_StillnessOfMind`),
  DisplayName, Description, ExtraDescription, UseCosts (the parent has `ActionPoint:1;SpellSlotsGroup:1:1:2;`),
  SpellFlags (the parent has `IsSpell;HasSomaticComponent`), RequirementConditions (the parent has `not
  WearingArmor(context.Source) and not HasShieldEquipped(context.Source)`).
- **Clears the parent:** SpellProperties (the parent has `ApplyStatus(SELF,FLOW_STATE,100,2);`), TargetConditions (the
  parent has `Self() and not HasPassive('ARCANA_IS_CARD', context.Source)`), TooltipDamageList (the parent has
  `GainTemporaryHitPoints(ClassLevel(Arcana)*2)`), TooltipStatusApply (the parent has
  `ApplyStatus(FLOW_STATE,100,2)`), VocalComponentSound (the parent has `Vocal_Component_Stop`), Sheathing (the parent
  has `Sheathed`).
- Aeolus' Bag (WB11–WB14): a container, one child per wind. Osiris puts `ARCANA_BAG_READY` on her while she has a Windswept enemy and `ARCANA_BAG_OPEN` while a wind blows. At level 2 it lists Boreas and Notus; Eurus joins at 4, the pairs at 12.
- The Icon is a suggestion.

Notes — `Shout_Arcana_Created_AeolusBag_Boreas` (`Using` = `Arcana_Created_AeolusBag`; search `Arcana_Created_AeolusBag` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Level, SpellSchool, Icon, ExtraDescription, CastSound, TargetSound, PreviewCursor,
  CastTextEvent, UseCosts, Intent, Spell Style Group, Requirements.
- **Ours:** SpellContainerID, DisplayName, Description, SpellFlags (the parent has
  `IsSpell;HasSomaticComponent;IsLinkedSpellContainer`), RequirementConditions (the parent has
  `HasStatus('ARCANA_BAG_READY') and not HasStatus('ARCANA_BAG_OPEN') and not WearingArmor(context.Source) and not
  HasShieldEquipped(context.Source)`).
- **Clears the parent:** ContainerSpells (the parent has
  `Shout_Arcana_Created_AeolusBag_Boreas;Shout_Arcana_Created_AeolusBag_Notus`).
- A child of the bag. Its own `RequirementConditions` add "not Hurricane" (at 12 the pairs replace the single winds). Notus inherits everything from Boreas; the goal reads which child was cast.
- The Icon is a suggestion.

Notes — `Shout_Arcana_Created_AeolusBag_Notus` (`Using` = `Arcana_Created_AeolusBag_Boreas`; search `Arcana_Created_AeolusBag_Boreas` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Level, SpellSchool, SpellContainerID, Icon, ExtraDescription, CastSound, TargetSound,
  PreviewCursor, CastTextEvent, UseCosts, Intent, Spell Style Group, SpellFlags, Requirements, RequirementConditions.
- **Ours:** DisplayName, Description.
- The Icon is a suggestion.

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 16 | Aeolus' Bag: a 0-Thread card conjured by `ARCANA_BAG_READY`, with its container children. | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**New handles** (typed in the blocks above):

| Key | English text |
|---|---|
| `WB_BAG_OPEN_NAME` | `Aeolus' Bag: Untied` |
| `WB_BAG_OPEN_DESC` | `A wind blows over the battle. The bag can't be opened again until it stops.` |
| `WB_BAG_NAME` | `Aeolus' Bag` |
| `WB_HEAD_BOREAS` | `Headwind: Boreas` |
| `WB_HEAD_BOREAS_DESC` | `Chilled by the North Wind. Movement speed reduced by [1].` |
| `WB_HEAD_NOTUS_DESC` | `Battered by the South Wind. [1] penalty to Saving Throws.` |
| `WB_HEAD_NOTUS` | `Headwind: Notus` |
| `WB_TAIL_BOREAS_DESC` | `Carried by the North Wind. Movement speed increased by [1].` |
| `WB_TAIL_BOREAS` | `Tailwind: Boreas` |
| `WB_TAIL_NOTUS_DESC` | `Cloaked by rain and fog. Ranged attacks against this creature have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag>.` |
| `WB_TAIL_NOTUS` | `Tailwind: Notus` |
| `WB_BAG_BOREAS` | `Aeolus' Bag: Boreas` |
| `WB_BAG_NOTUS` | `Aeolus' Bag: Notus` |
| `WB_BAG_EXTRA` | `While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind.` |
| `WB_BAG_DESC` | `Untie the bag of winds and release one of them over the battle. It blows for 1 turn for each <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> enemy, and every mark is swept away.` |
| `WB_BAG_BOREAS_DESC` | `Release Boreas, the North Wind. Your allies move faster, and Windswept enemies are slowed.` |
| `WB_BAG_NOTUS_DESC` | `Release Notus, the South Wind. Rain and fog cloak your allies from ranged attacks, and Windswept enemies falter on their Saving Throws.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt` (`0 error(s)`).
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 2 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-2 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L2) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 3

> **What this file is.** The point-by-point guide to enter **level 3** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Tier I The First Step + The Calm; Wind Blast*. Headline: "My Aspect wakes; I can stop the wind". Technical source: `SPEC_ARC-0026` (stage 3).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 2 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `ARCANA_CALM_GUST_1` | new | — | ☐ |
| 02 | Stats Editor | StatusData / Status_BOOST | `ARCANA_CALM_GUST_2` | new | — | ☐ |
| 03 | Stats Editor | StatusData / Status_BOOST | `ARCANA_CALM_GUST_3` | new | — | ☐ |
| 04 | Stats Editor | StatusData / Status_BOOST | `ARCANA_CALM_GUST_4` | new | — | ☐ |
| 05 | Stats Editor | StatusData / Status_BOOST | `ARCANA_CALM_GUST_5` | new | — | ☐ |
| 06 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_TheCalm` | new | — | ☐ |
| 07 | Stats Editor | StatusData / Status_BOOST | `ASPECT_AWAKENED_FOOL` | change | — | ☐ |
| 08 | Stats Editor | StatusData / Status_BOOST | `FOOL_ZEPHYR_FREE` | change | — | ☐ |
| 09 | Stats Editor | Stats / Passive | `Arcana_Passive_Aspect_Fool_Awakened_I` | change | — | ☐ |
| 10 | Stats Editor | Stats / Passive | `Arcana_Passive_Aspect_Fool_I` | change | — | ☐ |
| 11 | Stats Editor | SpellData / Zone | `Zone_Arcana_Card_Spell_WindBlast` | change | — | ☐ |
| 12 | UUID Object Editor | Lists / SpellLists | "Unbound Level 3" | change | — | ☐ |
| 13 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 3 | change | — | ☐ |
| 14 | Stories | Goals | `ARCANA_Aspect_Common` | change 3 lines | — | ☐ |
| 15 | — | Generated | Wind Blast's variants (they inherit the base `SpellSuccess`) | Claude runs scripts | all above | ☐ |
| 16 | — | PC edition | `CardDB.lua` | Claude adds the lines | all above | ☐ |

---

### 1 · Stories (Osiris)

#### 14 · CHANGED goal `ARCANA_Aspect_Common` — the three Fool goals

In `PROC_ARCANA_Aspect_Init()`, find these three lines:

```
DB_ARCANA_AspectTier("FOOL", 1, "Arcana_Passive_Aspect_Fool_I", "ASPECT_AWAKENED_FOOL_I", 3);
DB_ARCANA_AspectTier("FOOL", 2, "Arcana_Passive_Aspect_Fool_II", "ASPECT_AWAKENED_FOOL_II", 4);
DB_ARCANA_AspectTier("FOOL", 3, "Arcana_Passive_Aspect_Fool_III", "ASPECT_AWAKENED_FOOL_III", 5);
```

and paste these over them. Nothing else in the goal changes.

```
DB_ARCANA_AspectTier("FOOL", 1, "Arcana_Passive_Aspect_Fool_I", "ASPECT_AWAKENED_FOOL_I", 3);
DB_ARCANA_AspectTier("FOOL", 2, "Arcana_Passive_Aspect_Fool_II", "ASPECT_AWAKENED_FOOL_II", 5);
DB_ARCANA_AspectTier("FOOL", 3, "Arcana_Passive_Aspect_Fool_III", "ASPECT_AWAKENED_FOOL_III", 8);
```

Numbers: goals `3` / `5` / `8` (marks released in the fight) = `FEAT_Unbound_AspectAwakening#goals_next` `by_level`.

After pasting: **compile** in the Story Editor and read `Mods/AspectClass_…/Story/log.txt` — it must end with `0 error(s)`. A warning such as *Database defined but never checked* is a defect: send me the log.

---

### 2 · UUID Object Editor

#### 12 · CHANGED · Lists / SpellLists · `706b4719-9a6d-42c0-8e08-8b273eb3e0e4` ("Unbound Level 3")

| Field | Before | After |
|---|---|---|
| Spells | `Zone_Arcana_Card_Spell_WindBlast;Shout_Arcana_Card_Spell_FlowState;Shout_Arcana_Card_Passive_GaleDeflection` | `Zone_Arcana_Card_Spell_WindBlast` |

#### 13 · CHANGED · Progressions / Progressions · `fb53cf40-4c7a-4130-9b21-6f42fb58cb1c` (table `d75cb44d…`, level 3)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_3;Arcana_Passive_Aspect_Fool_I;Arcana_Passive_Aspect_Fool_Awakening` | `Arcana_Passive_Aspect_Fool_I;Arcana_Passive_Aspect_Fool_Awakening` |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_1` | — |
| Boosts | `ActionResource(ArcanaGaleDeflectReturn,1,0);ActionResource(ArcanaReactGaleDeflection,3,0)` | — |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01–03 · NEW · StatusData / Status_BOOST · The Calm, `ARCANA_CALM_GUST_2`, `ARCANA_CALM_GUST_3`

| Field | `ARCANA_CALM_GUST_1` | `ARCANA_CALM_GUST_2` | `ARCANA_CALM_GUST_3` |
|---|---|---|---|
| Name | `ARCANA_CALM_GUST_1` | `ARCANA_CALM_GUST_2` | `ARCANA_CALM_GUST_3` |
| Using | — | `ARCANA_CALM_GUST_1` | `ARCANA_CALM_GUST_1` |
| DisplayName | `The Calm` | `The Calm` | `The Calm` |
| StackId | `ARCANA_CALM_GUST` | `ARCANA_CALM_GUST` | `ARCANA_CALM_GUST` |
| StatusPropertyFlags | `DisableOverhead;DisablePortraitIndicator` | `DisableOverhead;DisablePortraitIndicator` | `DisableOverhead;DisablePortraitIndicator` |
| OnApplyFunctors | `IF(not CharacterLevelGreaterThan(6,context.Source)):DealDamage(1d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(2d6,Thunder,Magical)` | `IF(not CharacterLevelGreaterThan(6,context.Source)):DealDamage(2d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(4d6,Thunder,Magical)` | `IF(not CharacterLevelGreaterThan(6,context.Source)):DealDamage(3d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(6d6,Thunder,Magical)` |

Notes — `ARCANA_CALM_GUST_1`:
- One gust status per number of turns left (1–5); the goal applies the one that matches. 1d8 per gust to level 6, 2d6 from 7 (WB48).

Numbers: `1d8` per gust (levels 3–6) and `2d6` (7+, `CharacterLevelGreaterThan(6)`) = `SPL_Unbound_TheCalm#gust_damage_next` `by_level`; gust *n* deals *n* times that.

Notes — `ARCANA_CALM_GUST_2` (`Using` = `ARCANA_CALM_GUST_1`; search `ARCANA_CALM_GUST_1` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** DisplayName, StackId, StatusPropertyFlags.
- **Ours:** OnApplyFunctors (the parent has `IF(not
  CharacterLevelGreaterThan(6,context.Source)):DealDamage(1d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(2d6,Thunder,Magical)`).

Notes — `ARCANA_CALM_GUST_3` (`Using` = `ARCANA_CALM_GUST_1`; search `ARCANA_CALM_GUST_1` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** DisplayName, StackId, StatusPropertyFlags.
- **Ours:** OnApplyFunctors (the parent has `IF(not
  CharacterLevelGreaterThan(6,context.Source)):DealDamage(1d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(2d6,Thunder,Magical)`).

#### 04–05 · NEW · StatusData / Status_BOOST · `ARCANA_CALM_GUST_4`, `ARCANA_CALM_GUST_5`

| Field | `ARCANA_CALM_GUST_4` | `ARCANA_CALM_GUST_5` |
|---|---|---|
| Name | `ARCANA_CALM_GUST_4` | `ARCANA_CALM_GUST_5` |
| Using | `ARCANA_CALM_GUST_1` | `ARCANA_CALM_GUST_1` |
| DisplayName | `The Calm` | `The Calm` |
| StackId | `ARCANA_CALM_GUST` | `ARCANA_CALM_GUST` |
| StatusPropertyFlags | `DisableOverhead;DisablePortraitIndicator` | `DisableOverhead;DisablePortraitIndicator` |
| OnApplyFunctors | `IF(not CharacterLevelGreaterThan(6,context.Source)):DealDamage(4d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(8d6,Thunder,Magical)` | `IF(not CharacterLevelGreaterThan(6,context.Source)):DealDamage(5d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(10d6,Thunder,Magical)` |

Notes — `ARCANA_CALM_GUST_4` (`Using` = `ARCANA_CALM_GUST_1`; search `ARCANA_CALM_GUST_1` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** DisplayName, StackId, StatusPropertyFlags.
- **Ours:** OnApplyFunctors (the parent has `IF(not
  CharacterLevelGreaterThan(6,context.Source)):DealDamage(1d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(2d6,Thunder,Magical)`).

Notes — `ARCANA_CALM_GUST_5` (`Using` = `ARCANA_CALM_GUST_1`; search `ARCANA_CALM_GUST_1` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** DisplayName, StackId, StatusPropertyFlags.
- **Ours:** OnApplyFunctors (the parent has `IF(not
  CharacterLevelGreaterThan(6,context.Source)):DealDamage(1d8,Thunder,Magical);IF(CharacterLevelGreaterThan(6,context.Source)):DealDamage(2d6,Thunder,Magical)`).

#### 06 · NEW · SpellData / Shout · The Calm

| Field | `Shout_Arcana_Created_TheCalm` |
|---|---|
| Name | `Arcana_Created_TheCalm` |
| Using | `Arcana_Card_Spell_FlowState` |
| Level | `0` |
| SpellSchool | `Evocation` |
| Cooldown | `OncePerCombat` |
| SpellProperties | — |
| TargetConditions | — |
| Icon | `Spell_Abjuration_Sanctuary` |
| DisplayName | `The Calm` |
| Description | `Still the wind at once. Each turn it had left becomes a gust that strikes every <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> enemy for [1], and the bag can be opened again.` |
| DescriptionParams | `DealDamage(1d8,Thunder)` |
| ExtraDescription | `Can only be used while a wind blows. Every Windswept mark is swept away.` |
| TooltipDamageList | — |
| TooltipStatusApply | — |
| CastSound | `Spell_Cast_Monk_WholenessOfBody_L1to3` |
| TargetSound | `Spell_Impact_Monk_WholenessOfBody_L1to3` |
| VocalComponentSound | — |
| PreviewCursor | `Cast` |
| CastTextEvent | `Cast` |
| UseCosts | `ActionPoint:1;` |
| Intent | `Damage` |
| Spell Style Group | `Class` |
| SpellFlags | `IsSpell;HasSomaticComponent` |
| Requirements | `Combat` |
| RequirementConditions | `HasStatus('ARCANA_BAG_OPEN') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` |
| Sheathing | — |

Notes — `Shout_Arcana_Created_TheCalm` (`Using` = `Arcana_Card_Spell_FlowState`; search `Arcana_Card_Spell_FlowState` in the picker):
- **Copy from the parent in the Toolkit, then remove `Using`:** CastEffect, PrepareEffect, Spell Animation.
- **From the parent:** SpellSchool, CastSound, TargetSound, PreviewCursor, CastTextEvent, Spell Style Group,
  SpellFlags, Requirements.
- **Ours:** Level (the parent has `2`), Cooldown, Icon (the parent has `Action_Monk_StillnessOfMind`), DisplayName,
  Description, DescriptionParams, ExtraDescription, UseCosts (the parent has `ActionPoint:1;SpellSlotsGroup:1:1:2;`),
  Intent (the parent has `Buff`), RequirementConditions (the parent has `not WearingArmor(context.Source) and not
  HasShieldEquipped(context.Source)`).
- **Clears the parent:** SpellProperties (the parent has `ApplyStatus(SELF,FLOW_STATE,100,2);`), TargetConditions (the
  parent has `Self() and not HasPassive('ARCANA_IS_CARD', context.Source)`), TooltipDamageList (the parent has
  `GainTemporaryHitPoints(ClassLevel(Arcana)*2)`), TooltipStatusApply (the parent has
  `ApplyStatus(FLOW_STATE,100,2)`), VocalComponentSound (the parent has `Vocal_Component_Stop`), Sheathing (the parent
  has `Sheathed`).
- The Calm (WB25), the Aspect card of Tier I: only while a wind blows. The spell only spends the action; Osiris turns the turns left into gusts (`ARCANA_CALM_GUST_1`–`_5`) and reopens the bag.
- The Icon is a suggestion.

Numbers: `1d8` (DescriptionParams) = `SPL_Unbound_TheCalm#gust_damage_next`.

#### 07 · CHANGED · StatusData / Status_BOOST · `ASPECT_AWAKENED_FOOL`

| Field | Before | After |
|---|---|---|
| Boosts | `UnlockSpell(Rush_Arcana_Created_Aspect_LeapOfFaith);` | `UnlockSpell(Shout_Arcana_Created_TheCalm);` |

Notes — `ASPECT_AWAKENED_FOOL`:
- The Aspect card is The Calm now (WB25); Leap of Faith becomes a level-10 card.

#### 08 · CHANGED · StatusData / Status_BOOST · `FOOL_ZEPHYR_FREE`

| Field | Before | After |
|---|---|---|
| Boosts | `UnlockSpellVariant(SpellId('Target_Arcana_Created_ZephyrStrike'),ModifyUseCosts(Replace,BonusActionPoint,0,0,BonusActionPoint));` | `UnlockSpellVariant(SpellId('Rush_Arcana_Created_ZephyrRush'),ModifyUseCosts(Replace,BonusActionPoint,0,0,BonusActionPoint));` |

Notes — `FOOL_ZEPHYR_FREE`:
- Tier I: once per turn the Rush to an enemy costs no bonus action — the free variant of Zephyr Rush (the old Leap of Faith discount goes).

#### 09 · CHANGED · Stats / Passive · `Arcana_Passive_Aspect_Fool_Awakened_I`

| Field | Before | After |
|---|---|---|
| Boosts | `ActionResource(Movement,3,0);IgnoreLeaveAttackRange();IF(IsMeleeUnarmedAttack()):DamageBonus(1d4,Thunder);` | — |

Notes — `Arcana_Passive_Aspect_Fool_Awakened_I`:
- The old tier bonus goes (WB24: no ability bonus).

#### 10 · CHANGED · Stats / Passive · `Arcana_Passive_Aspect_Fool_I`

| Field | Before | After |
|---|---|---|
| StatsFunctorContext | `OnAttack` | — |
| StatsFunctorConditions | `Combat() and IsAttack() and IsHit() and Enemy() and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);` | — |
| StatsFunctors | `ApplyStatus(WANDERLUST_HIT_TECH,100,0)` | — |

Notes — `Arcana_Passive_Aspect_Fool_I`:
- Tier I *The First Step* (WB22): the old Wanderlust round count (`WANDERLUST_HIT_TECH`) leaves; Osiris counts the marks released now.

#### 11 · CHANGED · SpellData / Zone · `Zone_Arcana_Card_Spell_WindBlast`

| Field | Before | After |
|---|---|---|
| SpellSuccess | `Force(5);IF(not Item()):ApplyStatus(OFF_BALANCED,100,1);` | `Force(5);IF(not Item()):ApplyStatus(OFF_BALANCED,100,1);IF(not Item()):ApplyStatus(ARCANA_WINDSWEPT,100,2);` |

Notes — `Zone_Arcana_Card_Spell_WindBlast`:
- Wind Blast marks every creature that fails its save (WB8); its variants inherit this field.

#### RETIRE · entries that leave the Windborn at this level — do not delete them

Nothing to type. After the steps above no list, progression or entry of the mod points to them any more; they stay in the mod, unused (OR-10: a published entry is never renamed or deleted — an old save may still name it).

| Entry | File | Why it leaves |
|---|---|---|
| `Arcana_Passive_TwinkleToes_1` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `WANDERLUST_HIT_TECH` | StatusData / Status_BOOST | the Wanderlust round count (old Tier I) |

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 15 | Wind Blast's variants (they inherit the base `SpellSuccess`) | `82_Automation/stats/gen_upcast_variants.pl --apply`, then `sort_stats.pl --apply` and `check_cards.pl` | after you save |
| 16 | The Calm: conjured by `ASPECT_AWAKENED_FOOL` (replaces the Leap of Faith line). | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**New handles** (typed in the blocks above):

| Key | English text |
|---|---|
| `WB_CALM_NAME` | `The Calm` |
| `WB_CALM_EXTRA` | `Can only be used while a wind blows. Every Windswept mark is swept away.` |
| `WB_CALM_DESC` | `Still the wind at once. Each turn it had left becomes a gust that strikes every <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> enemy for [1], and the bag can be opened again.` |

**Existing handles whose text changes** (open the entry, then the text of the field):

| Handle | Used by | Before | After |
|---|---|---|---|
| `h4b9d78b5g0ee3g2d1eg65e8g48fd9771f335` | `FOOL_ZEPHYR_FREE.Description` | `The next Zephyr Strike this turn doesn't cost a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `Your next Zephyr Strike that carries you to an enemy this turn doesn't cost a bonus action.` |
| `h4d2c7825gb331gaf07gcd46g2c58bd100639` | `Zone_Arcana_Card_Spell_WindBlast.Description` | `Bend the air to unleash a strong gust of wind that clears clouds and pushes creatures back [1], leaving them <LSTag Type="Status" Tooltip="OFF_BALANCED">Off Balance</LSTag>.<br><br>Afterwards, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `Bend the air to unleash a strong gust of wind that clears clouds and pushes creatures back [1], leaving them <LSTag Type="Status" Tooltip="OFF_BALANCED">Off Balance</LSTag>.` |
| `h5aa211b3g50d8gd054g2146g6b9097806a16` | `ASPECT_AWAKENED_FOOL_I.Description` | `Wanderlust: Your <LSTag Tooltip="MovementSpeed">movement speed</LSTag> increases by [1], you can move without provoking <LSTag Tooltip="OpportunityAttack">Opportunity Attacks</LSTag>, and your unarmed attacks deal an additional [2].<br><br>Only active while not wearing armour or using a shield.` | `The First Step: Once per turn, a Zephyr Strike that carries you to an enemy doesn't cost a bonus action.<br><br>Only active while not wearing armour or using a shield.` |
| `h5f2ec141gf782gfaeag0976g4dd84ea7176d` | `Arcana_Passive_Aspect_Fool_I.Description` | `Your <LSTag Tooltip="MovementSpeed">movement speed</LSTag> increases by [1], you can move without provoking <LSTag Tooltip="OpportunityAttack">Opportunity Attacks</LSTag>, and your unarmed attacks deal an additional [2].` | `Once per turn, a Zephyr Strike that carries you to an enemy doesn't cost a bonus action.` |
| `h6ff4a520gc021g1333gc4b8g32cf0463e96e` | `ASPECT_PROGRESS_FOOL_II.Description` | `Different enemies left to strike this round to awaken Restless Wind.` | `Windswept marks left to release to awaken Fellow Travellers.` |
| `h76abef56g542egceedg9549gf86ef239edc5` | `Arcana_Passive_Aspect_Fool_Awakening.Description` | `Strike different enemies with attacks within a single round during a fight to awaken the Aspect of Curiosity until combat ends. If fewer enemies stand when your turn begins than a goal asks for, strikes on any enemy count towards that goal instead. Each goal you reach awakens one more tier.<br><br>Level 3: strike 3 different enemies in one round to gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_I">Wanderlust</LSTag>.<br><br>Level 7: strike 4 different enemies in one round to also gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_II">Restless Wind</LSTag>.<br><br>Level 12: strike 5 different enemies in one round to awaken as the <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_III">Aspect of Curiosity</LSTag>.<br><br>The Awakening status shows how much is left to the next tier.` | `Release <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> marks with the wind to awaken the Aspect of Curiosity until combat ends. Every mark the wind sweeps away counts - when you open the bag, at the start of each turn it blows, and with The Calm. Each goal you reach awakens one more tier.<br><br>Level 3: release 3 marks to gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_I">The First Step</LSTag> and <LSTag Type="Spell" Tooltip="Shout_Arcana_Created_TheCalm">The Calm</LSTag>.<br><br>Level 7: release 5 marks to also gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_II">Fellow Travellers</LSTag>.<br><br>Level 12: release 8 marks to awaken <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_III">Into the Storm</LSTag>.<br><br>The Awakening status shows how much is left to the next tier.` |
| `h7827d3b6gcc72g6ed8g0201g54d40339f494` | `ASPECT_PROGRESS_FOOL_I.Description` | `Different enemies left to strike this round to awaken Wanderlust.` | `Windswept marks left to release to awaken The First Step.` |
| `hb0c9372cg8418g080dg046cg61d05ca39723` | `Arcana_Passive_Aspect_Fool_Awakened_I.DisplayName`, `Arcana_Passive_Aspect_Fool_I.DisplayName` | `Wanderlust` | `The First Step` |
| `he80cdc45g60adg8d77g50f5g626fd82b42a4` | `FOOL_ZEPHYR_FREE.DisplayName` | `Restless Wind` | `The First Step` |
| `hec7e5e37g3dfcgdec4gfc28ga74bd2ce796b` | `ASPECT_PROGRESS_FOOL_III.Description` | `Different enemies left to strike this round to awaken the Aspect of Curiosity.` | `Windswept marks left to release to awaken Into the Storm.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt` (`0 error(s)`).
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 3 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-3 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L3) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 4

> **What this file is.** The point-by-point guide to enter **level 4** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Gale: push, Eurus, longer wind, Weightless 2*. Headline: "My Zephyr pushes; a new wind". Technical source: `SPEC_ARC-0026` (stage 4).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 3 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `ARCANA_HEADWIND_EURUS` | new | — | ☐ |
| 02 | Stats Editor | StatusData / Status_BOOST | `ARCANA_TAILWIND_EURUS` | new | — | ☐ |
| 03 | Stats Editor | StatusData / Status_BOOST | `ARCANA_WIND_EURUS` | new | — | ☐ |
| 04 | Stats Editor | Stats / Passive | `Arcana_Passive_Weightless_4` | new | — | ☐ |
| 05 | Stats Editor | Stats / Passive | `Arcana_Passive_Zephyr_Gale` | new | — | ☐ |
| 06 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag_Eurus` | new | — | ☐ |
| 07 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag` | change | — | ☐ |
| 08 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 4 | change | — | ☐ |
| 09 | — | PC edition | `CardDB.lua` | Claude adds the lines | all above | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 08 · CHANGED · Progressions / Progressions · `c16cd90e-8c94-4cde-8b8c-fca87eae54df` (table `d75cb44d…`, level 4)

| Field | Before | After |
|---|---|---|
| PassivesAdded | — | `Arcana_Passive_Zephyr_Gale;Arcana_Passive_Weightless_4` |
| PassivesRemoved | — | `Arcana_Passive_Weightless_1` |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01–03 · NEW · StatusData / Status_BOOST · Headwind: Eurus, Tailwind: Eurus, Aeolus' Bag: Eurus

| Field | `ARCANA_HEADWIND_EURUS` | `ARCANA_TAILWIND_EURUS` | `ARCANA_WIND_EURUS` |
|---|---|---|---|
| Name | `ARCANA_HEADWIND_EURUS` | `ARCANA_TAILWIND_EURUS` | `ARCANA_WIND_EURUS` |
| Using | `ARCANA_HEADWIND_BOREAS` | `ARCANA_TAILWIND_BOREAS` | `ARCANA_WIND_BOREAS` |
| DisplayName | `Headwind: Eurus` | `Tailwind: Eurus` | `Aeolus' Bag: Eurus` |
| Description | `Buffeted by the East Wind. [1] penalty to Attack Rolls.` | `Steadied by the East Wind. [1] bonus to Attack Rolls.` | — |
| DescriptionParams | `1` | `1` | — |
| Icon | `Spell_Evocation_GustOfWind` | `Action_Monk_StepOfTheWind_Dash` | — |
| StackId | `ARCANA_HEADWIND_EURUS` | `ARCANA_TAILWIND_EURUS` | `ARCANA_WIND_EURUS` |
| AuraRadius | — | — | `30` |
| AuraStatuses | — | — | `IF(Ally()):ApplyStatus(ARCANA_TAILWIND_EURUS);IF(Enemy() and HasStatus('ARCANA_WINDSWEPT')):ApplyStatus(ARCANA_HEADWIND_EURUS)` |
| Boosts | `RollBonus(Attack,-1)` | `RollBonus(Attack,1)` | — |
| RemoveEvents | — | — | `OnCombatEnded` |
| StatusPropertyFlags | `ForceOverhead` | `ForceOverhead` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |

Notes — `ARCANA_HEADWIND_EURUS` (`Using` = `ARCANA_HEADWIND_BOREAS`; search `ARCANA_HEADWIND_BOREAS` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Icon, StatusPropertyFlags.
- **Ours:** DisplayName, Description, DescriptionParams (the parent has `Distance(3)`), StackId (the parent has
  `ARCANA_HEADWIND_BOREAS`), Boosts (the parent has `ActionResource(Movement,-3,0)`).
- The Icon is a suggestion.

Numbers: `1` = `FEAT_Unbound_AeolusBag#eurus_enemy_next`.

Notes — `ARCANA_TAILWIND_EURUS` (`Using` = `ARCANA_TAILWIND_BOREAS`; search `ARCANA_TAILWIND_BOREAS` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Icon, StatusPropertyFlags.
- **Ours:** DisplayName, Description, DescriptionParams (the parent has `Distance(3)`), StackId (the parent has
  `ARCANA_TAILWIND_BOREAS`), Boosts (the parent has `ActionResource(Movement,3,0)`).
- The Icon is a suggestion.

Numbers: `1` = `FEAT_Unbound_AeolusBag#eurus_ally_next`.

Notes — `ARCANA_WIND_EURUS` (`Using` = `ARCANA_WIND_BOREAS`; search `ARCANA_WIND_BOREAS` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** AuraRadius, RemoveEvents, StatusPropertyFlags.
- **Ours:** DisplayName, StackId (the parent has `ARCANA_WIND_BOREAS`), AuraStatuses (the parent has
  `IF(Ally()):ApplyStatus(ARCANA_TAILWIND_BOREAS);IF(Enemy() and
  HasStatus('ARCANA_WINDSWEPT')):ApplyStatus(ARCANA_HEADWIND_BOREAS)`).

#### 04–05 · NEW · Stats / Passive · `Arcana_Passive_Weightless_4`, Zephyr Strike: Gale

| Field | `Arcana_Passive_Weightless_4` | `Arcana_Passive_Zephyr_Gale` |
|---|---|---|
| Name | `Arcana_Passive_Weightless_4` | `Arcana_Passive_Zephyr_Gale` |
| Using | `Arcana_Passive_Weightless_1` | — |
| DisplayName | `Weightless` | `Zephyr Strike: Gale` |
| Description | `You move as if the air carried you. Your movement speed increases by [1], your jumps reach [2] times as far, and you take only half Falling damage.` | `The wind grows. Your Zephyr Strike pushes the target back [1] and carries you farther, the bag's winds blow longer, and <LSTag Type="Spell" Tooltip="Shout_Arcana_Created_AeolusBag_Eurus">Eurus</LSTag> joins <LSTag Type="Spell" Tooltip="Shout_Arcana_Created_AeolusBag">Aeolus' Bag</LSTag>.` |
| DescriptionParams | `Distance(4.5);2` | `Distance(3)` |
| ExtraDescription | `Only active while not wearing armour or using a shield.` | — |
| Icon | `PassiveFeature_UnarmoredMovement` | `Action_Monk_FreeUnarmedStrike` |
| Properties | `Highlighted` | `Highlighted` |
| BoostContext | `OnEquip;OnCreate` | — |
| BoostConditions | `not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` | — |
| Boosts | `ActionResource(Movement,4.5,0);JumpMaxDistanceMultiplier(2);FallDamageMultiplier(0.5);` | — |

Notes — `Arcana_Passive_Weightless_4` (`Using` = `Arcana_Passive_Weightless_1`; search `Arcana_Passive_Weightless_1` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** DisplayName, ExtraDescription, Icon, Properties, BoostContext, BoostConditions.
- **Ours:** Description, DescriptionParams (the parent has `Distance(3)`), Boosts (the parent has
  `ActionResource(Movement,3,0);`).
- The Icon is a suggestion.

Numbers: `4.5` / `2` / `0.5` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (level 4).

Notes — `Arcana_Passive_Zephyr_Gale`:
- Rank 2 of Zephyr (level 4): the push and 12 m Rush read this passive; Eurus needs it.
- The Icon is a suggestion.

Numbers: `3` = `FEAT_Unbound_TheOpenRoad#gale_push_next`.

#### 06 · NEW · SpellData / Shout · Aeolus' Bag: Eurus

| Field | `Shout_Arcana_Created_AeolusBag_Eurus` |
|---|---|
| Name | `Arcana_Created_AeolusBag_Eurus` |
| Using | `Arcana_Created_AeolusBag_Boreas` |
| Level | `0` |
| SpellSchool | `Evocation` |
| SpellContainerID | `Shout_Arcana_Created_AeolusBag` |
| Icon | `Spell_Evocation_GustOfWind` |
| DisplayName | `Aeolus' Bag: Eurus` |
| Description | `Release Eurus, the East Wind. Your allies strike truer, and Windswept enemies' attacks go astray.` |
| ExtraDescription | `While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind.` |
| CastSound | `Spell_Cast_Monk_WholenessOfBody_L1to3` |
| TargetSound | `Spell_Impact_Monk_WholenessOfBody_L1to3` |
| PreviewCursor | `Cast` |
| CastTextEvent | `Cast` |
| UseCosts | `BonusActionPoint:1;` |
| Intent | `Buff` |
| Spell Style Group | `Class` |
| SpellFlags | `IsSpell;HasSomaticComponent` |
| Requirements | `Combat` |
| RequirementConditions | `HasStatus('ARCANA_BAG_READY') and not HasStatus('ARCANA_BAG_OPEN') and HasPassive('Arcana_Passive_Zephyr_Gale') and not HasPassive('Arcana_Passive_Zephyr_Hurricane') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` |

Notes — `Shout_Arcana_Created_AeolusBag_Eurus` (`Using` = `Arcana_Created_AeolusBag_Boreas`; search `Arcana_Created_AeolusBag_Boreas` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Level, SpellSchool, SpellContainerID, Icon, ExtraDescription, CastSound, TargetSound,
  PreviewCursor, CastTextEvent, UseCosts, Intent, Spell Style Group, SpellFlags, Requirements.
- **Ours:** DisplayName, Description, RequirementConditions (the parent has `HasStatus('ARCANA_BAG_READY') and not
  HasStatus('ARCANA_BAG_OPEN') and not HasPassive('Arcana_Passive_Zephyr_Hurricane') and not
  WearingArmor(context.Source) and not HasShieldEquipped(context.Source)`).
- The Icon is a suggestion.

#### 07 · CHANGED · SpellData / Shout · `Shout_Arcana_Created_AeolusBag`

| Field | Before | After |
|---|---|---|
| ContainerSpells | — | `Shout_Arcana_Created_AeolusBag_Boreas;Shout_Arcana_Created_AeolusBag_Notus;Shout_Arcana_Created_AeolusBag_Eurus` |

Notes — `Shout_Arcana_Created_AeolusBag`:
- Aeolus' Bag (WB11–WB14): a container, one child per wind. Osiris puts `ARCANA_BAG_READY` on her while she has a Windswept enemy and `ARCANA_BAG_OPEN` while a wind blows. At level 2 it lists Boreas and Notus; Eurus joins at 4, the pairs at 12.

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 09 | The bag's container gains Eurus. | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**New handles** (typed in the blocks above):

| Key | English text |
|---|---|
| `WB_HEAD_EURUS` | `Headwind: Eurus` |
| `WB_HEAD_EURUS_DESC` | `Buffeted by the East Wind. [1] penalty to Attack Rolls.` |
| `WB_TAIL_EURUS_DESC` | `Steadied by the East Wind. [1] bonus to Attack Rolls.` |
| `WB_TAIL_EURUS` | `Tailwind: Eurus` |
| `WB_BAG_EURUS` | `Aeolus' Bag: Eurus` |
| `WB_WEIGHTLESS_2_DESC` | `You move as if the air carried you. Your movement speed increases by [1], your jumps reach [2] times as far, and you take only half Falling damage.` |
| `WB_RANK_GALE_DESC` | `The wind grows. Your Zephyr Strike pushes the target back [1] and carries you farther, the bag's winds blow longer, and <LSTag Type="Spell" Tooltip="Shout_Arcana_Created_AeolusBag_Eurus">Eurus</LSTag> joins <LSTag Type="Spell" Tooltip="Shout_Arcana_Created_AeolusBag">Aeolus' Bag</LSTag>.` |
| `WB_RANK_GALE` | `Zephyr Strike: Gale` |
| `WB_BAG_EURUS_DESC` | `Release Eurus, the East Wind. Your allies strike truer, and Windswept enemies' attacks go astray.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 4 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-4 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L4) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 5

> **What this file is.** The point-by-point guide to enter **level 5** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Flowing Assault; Wind Whispers*. Headline: "Two strikes; the air warns me". Technical source: `SPEC_ARC-0026` (stage 5).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 4 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_WindWhispers` | change | — | ☐ |
| 02 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 5 | change | — | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 02 · CHANGED · Progressions / Progressions · `bc0188a8-1914-4bb8-bb2c-e6f056ebad3b` (table `d75cb44d…`, level 5)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_5;Arcana_Passive_Weightless_5;Arcana_Passive_FlowingAssault;` | `Arcana_Passive_FlowingAssault` |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_3` | — |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_WindWhispers`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,WIND_WHISPERS,100,1);` | `ApplyStatus(SELF,WIND_WHISPERS,100,1);ApplyStatus(SELF,EVASIVE_FLOW_OPENING,100,1);` |

Notes — `Shout_Arcana_Card_Spell_WindWhispers`:
- Wind Whispers absorbs Evasive Flow's Advantage (WB33): it applies `EVASIVE_FLOW_OPENING` (kept) too.

#### RETIRE · entries that leave the Windborn at this level — do not delete them

Nothing to type. After the steps above no list, progression or entry of the mod points to them any more; they stay in the mod, unused (OR-10: a published entry is never renamed or deleted — an old save may still name it).

| Entry | File | Why it leaves |
|---|---|---|
| `Arcana_Passive_TwinkleToes_3` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**Existing handles whose text changes** (open the entry, then the text of the field):

| Handle | Used by | Before | After |
|---|---|---|---|
| `h64279279ga897g3b4bgc173gcc1156e709e0` | `Shout_Arcana_Card_Spell_WindWhispers.Description` | `You can sense movement in the air. <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag> against you have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag>, and when an enemy's melee attack misses you, you use your <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag> to strike back with an unarmed attack.<br><br>Afterwards, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `You can sense movement in the air. Attack Rolls against you have Disadvantage, your next unarmed attack has Advantage, and when an enemy's melee attack misses you, you strike back with an unarmed attack.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 5 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-5 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L5) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 6

> **What this file is.** The point-by-point guide to enter **level 6** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Flow State; Ready: Gale Deflection*. Headline: "I flow; I turn arrows back". Technical source: `SPEC_ARC-0026` (stage 6).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 5 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `GALE_DEFLECTION_READY` | change | — | ☐ |
| 02 | Stats Editor | StatusData / Status_BOOST | `INTERRUPT_GALE_DEFLECT_MISSILES_HIT` | change | — | ☐ |
| 03 | Stats Editor | Stats / Passive | `Arcana_Passive_GaleDeflection` | change | — | ☐ |
| 04 | Stats Editor | Stats / Interrupt | `Interrupt_Arcana_Reaction_GaleDeflection` | change | — | ☐ |
| 05 | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_FlowState` | change | — | ☐ |
| 06 | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_FlowState_3` | change | — | ☐ |
| 07 | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_FlowState_4` | change | — | ☐ |
| 08 | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_FlowState_5` | change | — | ☐ |
| 09 | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_FlowState_6` | change | — | ☐ |
| 10 | UUID Object Editor | Lists / SpellLists | "Unbound Level 6" | new | — | ☐ |
| 11 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 6 | change | — | ☐ |
| 12 | — | Generated | Flow State `_2` (inherits the base) | Claude runs scripts | all above | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 10 · NEW · Lists / SpellLists · "Unbound Level 6"

| Field | Value |
|---|---|
| Name | `Unbound Level 6` |
| Spells | `Shout_Arcana_Card_Spell_FlowState;Shout_Arcana_Card_Passive_GaleDeflection` |

UUID: ________ (used in step 11)

#### 11 · CHANGED · Progressions / Progressions · `494b7973-b45e-478c-a695-be4e0cb66e05` (table `d75cb44d…`, level 6)

| Field | Before | After |
|---|---|---|
| Boosts | — | `ActionResource(ArcanaGaleDeflectReturn,1,0);ActionResource(ArcanaReactGaleDeflection,3,0)` |
| Selectors | — | `AddSpells(<UUID from step 10>,,,,AlwaysPrepared)` |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01 · CHANGED · StatusData / Status_BOOST · `GALE_DEFLECTION_READY`

| Field | Before | After |
|---|---|---|
| DescriptionParams | — | `Distance(3)` |

Numbers: `3` = `SPL_Unbound_GaleDeflection#ally_range_next`.

#### 02 · CHANGED · StatusData / Status_BOOST · `INTERRUPT_GALE_DEFLECT_MISSILES_HIT`

| Field | Before | After |
|---|---|---|
| StatusPropertyFlags | inherits `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |

Notes — `INTERRUPT_GALE_DEFLECT_MISSILES_HIT`:
- Its id showed in the combat log (32.01 review): hidden.

#### 03 · CHANGED · Stats / Passive · `Arcana_Passive_GaleDeflection`

| Field | Before | After |
|---|---|---|
| DescriptionParams | `1` | `Distance(3)` |

Numbers: `3` = `SPL_Unbound_GaleDeflection#ally_range_next`.

#### 04 · CHANGED · Stats / Interrupt · `Interrupt_Arcana_Reaction_GaleDeflection`

| Field | Before | After |
|---|---|---|
| InterruptContextScope | `Self` | `Nearby` |
| DescriptionParams | — | `Distance(3)` |
| Conditions | `IsAbleToReact(context.Observer) and Self(context.Target,context.Observer) and IsRangedWeaponAttack() and not HasStatus('SG_Polymorph_BeastShape') and not AnyEntityIsItem()` | `IsAbleToReact(context.Observer) and IsRangedWeaponAttack() and (Self(context.Target,context.Observer) or (Ally(context.Target,context.Observer) and not DistanceToEntityGreaterThan(3, context.ObserverPosition, context.Target))) and not HasStatus('SG_Polymorph_BeastShape') and not AnyEntityIsItem()` |

Notes — `Interrupt_Arcana_Reaction_GaleDeflection`:
- Ready: Gale Deflection (WB32) also protects an ally within 3 m. Anchor: vanilla `Interrupt_FightingStyle_Protection` (scope `Nearby`, `DistanceToEntityGreaterThan(_, context.ObserverPosition, context.Target)`).

Numbers: `3` = `SPL_Unbound_GaleDeflection#ally_range_next`.

#### 05 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_FlowState`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,FLOW_STATE,100,2);` | `ApplyStatus(SELF,FLOW_STATE,100,3);` |
| TooltipStatusApply | `ApplyStatus(FLOW_STATE,100,2)` | `ApplyStatus(FLOW_STATE,100,3)` |

Notes — `Shout_Arcana_Card_Spell_FlowState`:
- Flow State (WB31): 3 turns and one extra bonus action at every slot; the per-slot statuses `FLOW_STATE_3`–`_6` go (removed at this level).

Numbers: `3` (turns) = `SPL_Unbound_FlowState#duration_next`, the same at every slot (`_3`…`_6`).

#### 06 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_FlowState_3`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,FLOW_STATE_3,100,3);` | `ApplyStatus(SELF,FLOW_STATE,100,3);` |
| TooltipStatusApply | `ApplyStatus(FLOW_STATE_3,100,3)` | `ApplyStatus(FLOW_STATE,100,3)` |

Notes — `Shout_Arcana_Card_Spell_FlowState_3`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Flow State (WB31): 3 turns and one extra bonus action at every slot; the per-slot statuses `FLOW_STATE_3`–`_6` go (removed at this level).

Numbers: `3` (turns) = `SPL_Unbound_FlowState#duration_next`, the same at every slot (`_3`…`_6`).

#### 07 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_FlowState_4`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,FLOW_STATE_4,100,4);` | `ApplyStatus(SELF,FLOW_STATE,100,3);` |
| TooltipStatusApply | `ApplyStatus(FLOW_STATE_4,100,4)` | `ApplyStatus(FLOW_STATE,100,3)` |

Notes — `Shout_Arcana_Card_Spell_FlowState_4`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Flow State (WB31): 3 turns and one extra bonus action at every slot; the per-slot statuses `FLOW_STATE_3`–`_6` go (removed at this level).

Numbers: `3` (turns) = `SPL_Unbound_FlowState#duration_next`, the same at every slot (`_3`…`_6`).

#### 08 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_FlowState_5`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,FLOW_STATE_5,100,5);` | `ApplyStatus(SELF,FLOW_STATE,100,3);` |
| TooltipStatusApply | `ApplyStatus(FLOW_STATE_5,100,5)` | `ApplyStatus(FLOW_STATE,100,3)` |
| Description | (existing handle `hf33d690dgec42g3152g81e3g18cadacd3f32`) | (existing handle `h5c5dd9ccg21a6ge6e1g1f8fg8f392e8e5ce5` — new text in §4) |

Notes — `Shout_Arcana_Card_Spell_FlowState_5`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Flow State (WB31): 3 turns and one extra bonus action at every slot; the per-slot statuses `FLOW_STATE_3`–`_6` go (removed at this level).

Numbers: `3` (turns) = `SPL_Unbound_FlowState#duration_next`, the same at every slot (`_3`…`_6`).

#### 09 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_FlowState_6`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,FLOW_STATE_6,100,6);` | `ApplyStatus(SELF,FLOW_STATE,100,3);` |
| TooltipStatusApply | `ApplyStatus(FLOW_STATE_6,100,6)` | `ApplyStatus(FLOW_STATE,100,3)` |
| Description | (existing handle `h3c90790fg6444g0b67g0c79gb0826af77f5b`) | (existing handle `h5c5dd9ccg21a6ge6e1g1f8fg8f392e8e5ce5` — new text in §4) |

Notes — `Shout_Arcana_Card_Spell_FlowState_6`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Flow State (WB31): 3 turns and one extra bonus action at every slot; the per-slot statuses `FLOW_STATE_3`–`_6` go (removed at this level).

Numbers: `3` (turns) = `SPL_Unbound_FlowState#duration_next`, the same at every slot (`_3`…`_6`).

#### RETIRE · entries that leave the Windborn at this level — do not delete them

Nothing to type. After the steps above no list, progression or entry of the mod points to them any more; they stay in the mod, unused (OR-10: a published entry is never renamed or deleted — an old save may still name it).

| Entry | File | Why it leaves |
|---|---|---|
| `FLOW_STATE_6` | StatusData / Status_BOOST | a per-slot Flow State status (WB31: one status at every slot) |
| `FLOW_STATE_5` | StatusData / Status_BOOST | a per-slot Flow State status (WB31: one status at every slot) |
| `FLOW_STATE_4` | StatusData / Status_BOOST | a per-slot Flow State status (WB31: one status at every slot) |
| `FLOW_STATE_3` | StatusData / Status_BOOST | a per-slot Flow State status (WB31: one status at every slot) |

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 12 | Flow State `_2` (inherits the base) | `82_Automation/stats/gen_upcast_variants.pl --apply`, then `sort_stats.pl --apply` and `check_cards.pl` | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**Existing handles whose text changes** (open the entry, then the text of the field):

| Handle | Used by | Before | After |
|---|---|---|---|
| `h402ace5bgf1e8g2fe1gf6e4g220b7505458b` | `Interrupt_Arcana_Reaction_GaleDeflection.Description` | `Reduce the damage from a ranged weapon attack by 1d10 + your Dexterity <LSTag Tooltip="AbilityModifier">Modifier</LSTag> + your Arcana level.<br><br>If the damage is reduced to 0, you use an Arcane Card to <LSTag Type="Spell" Tooltip="Projectile_Arcana_Reaction_GaleDeflection">Deflect the Missile</LSTag>.` | `Reduce the damage of a ranged weapon attack against you or an ally within [1] by 1d10 + your Dexterity <LSTag Tooltip="AbilityModifier">Modifier</LSTag> + your Arcana level. If the damage is reduced to 0, you can hurl the missile back at your attacker.` |
| `h5c5dd9ccg21a6ge6e1g1f8fg8f392e8e5ce5` | `Shout_Arcana_Card_Spell_FlowState.Description` | `Enter a temporary state of flow where you gain <LSTag Tooltip="TemporaryHitPoints">temporary hit points</LSTag>, and an additional <LSTag Tooltip="BonusAction">bonus action</LSTag>.<br><br>Afterwards, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `Enter a temporary state of flow where you gain temporary hit points and an additional bonus action.` |
| `hcfea4405g7556g969dg0f13gdb93207a863d` | `Arcana_Passive_GaleDeflection.Description`, `GALE_DEFLECTION_READY.Description` | `Use your reaction to reduce the damage from a ranged weapon attack by 1d10 + your Dexterity <LSTag Tooltip="AbilityModifier">Modifier</LSTag> + your Arcana level. If the damage is reduced to 0, you can <LSTag Type="Spell" Tooltip="Projectile_Arcana_Reaction_GaleDeflection">Deflect the Missile</LSTag>.` | `Use your reaction to reduce the damage of a ranged weapon attack against you or an ally within [1] by 1d10 + your Dexterity <LSTag Tooltip="AbilityModifier">Modifier</LSTag> + your Arcana level. If the damage is reduced to 0, you can hurl the missile back at your attacker, who becomes <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag>.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 6 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-6 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L6) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 7

> **What this file is.** The point-by-point guide to enter **level 7** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Tier II Fellow Travellers; Magic Strikes; Storm Fists*. Headline: "The party carries my wind". Technical source: `SPEC_ARC-0026` (stage 7).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 6 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `STORM_FISTS` | change | — | ☐ |
| 02 | Stats Editor | StatusData / Status_BOOST | `STORM_FISTS_5` | change | — | ☐ |
| 03 | Stats Editor | StatusData / Status_BOOST | `STORM_FISTS_6` | change | — | ☐ |
| 04 | Stats Editor | Stats / Passive | `Arcana_Passive_Aspect_Fool_Awakened_II` | change | — | ☐ |
| 05 | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_StormFists_5` | change | — | ☐ |
| 06 | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_StormFists_6` | change | — | ☐ |
| 07 | UUID Object Editor | Lists / SpellLists | "Unboung Level 7" | change | — | ☐ |
| 08 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 7 | change | — | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 07 · CHANGED · Lists / SpellLists · `87872209-4d00-4a57-8e24-02fbb18c75bc` ("Unboung Level 7")

| Field | Before | After |
|---|---|---|
| Name | `Unboung Level 7` | `Unbound Level 7` |

#### 08 · CHANGED · Progressions / Progressions · `d67189a0-6e3b-4800-8155-6295ea2a8158` (table `d75cb44d…`, level 7)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_7;Arcana_Passive_Weightless_7;Arcana_Passive_MagicStrikes;Arcana_Passive_Aspect_Fool_II` | `Arcana_Passive_MagicStrikes;Arcana_Passive_Aspect_Fool_II` |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_5;Arcana_Passive_Weightless_5` | — |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01 · CHANGED · StatusData / Status_BOOST · `STORM_FISTS`

| Field | Before | After |
|---|---|---|
| Boosts | `IF(IsMeleeUnarmedAttack()):DamageBonus(1d4+DexterityModifier,Thunder);` | `IF(IsMeleeUnarmedAttack() and not HasStatus('ARCANA_WINDSWEPT',context.Target)):DamageBonus(1d4+DexterityModifier,Thunder);` |

Notes — `STORM_FISTS`:
- Storm Fists (WB34) adds its damage only against an enemy that isn't Windswept; it absorbs Thunderclap (removed at level 11 with its list).

Numbers: `3` turns (the cards) = `SPL_Unbound_StormFists#duration_next`; the dice are today's.

#### 02 · CHANGED · StatusData / Status_BOOST · `STORM_FISTS_5`

| Field | Before | After |
|---|---|---|
| Boosts | `IF(IsMeleeUnarmedAttack()):DamageBonus(1d6+DexterityModifier,Thunder);` | `IF(IsMeleeUnarmedAttack() and not HasStatus('ARCANA_WINDSWEPT',context.Target)):DamageBonus(1d6+DexterityModifier,Thunder);` |

Notes — `STORM_FISTS_5`:
- Storm Fists (WB34) adds its damage only against an enemy that isn't Windswept; it absorbs Thunderclap (removed at level 11 with its list).

Numbers: `3` turns (the cards) = `SPL_Unbound_StormFists#duration_next`; the dice are today's.

#### 03 · CHANGED · StatusData / Status_BOOST · `STORM_FISTS_6`

| Field | Before | After |
|---|---|---|
| Boosts | `IF(IsMeleeUnarmedAttack()):DamageBonus(1d8+DexterityModifier,Thunder);` | `IF(IsMeleeUnarmedAttack() and not HasStatus('ARCANA_WINDSWEPT',context.Target)):DamageBonus(1d8+DexterityModifier,Thunder);` |

Notes — `STORM_FISTS_6`:
- Storm Fists (WB34) adds its damage only against an enemy that isn't Windswept; it absorbs Thunderclap (removed at level 11 with its list).

Numbers: `3` turns (the cards) = `SPL_Unbound_StormFists#duration_next`; the dice are today's.

#### 04 · CHANGED · Stats / Passive · `Arcana_Passive_Aspect_Fool_Awakened_II`

| Field | Before | After |
|---|---|---|
| Boosts | `Advantage(SavingThrow, Dexterity);ActionResource(ReactionActionPoint,1,0);` | — |

Notes — `Arcana_Passive_Aspect_Fool_Awakened_II`:
- The old tier bonus goes (WB24).

#### 05 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_StormFists_5`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,STORM_FISTS_5,100,4);` | `ApplyStatus(SELF,STORM_FISTS_5,100,3);` |
| TooltipStatusApply | `ApplyStatus(STORM_FISTS_5,100,4)` | `ApplyStatus(STORM_FISTS_5,100,3)` |

Notes — `Shout_Arcana_Card_Spell_StormFists_5`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Storm Fists lasts 3 turns at every slot (WB34).

Numbers: `3` turns (the cards) = `SPL_Unbound_StormFists#duration_next`; the dice are today's.

#### 06 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_StormFists_6`

| Field | Before | After |
|---|---|---|
| SpellProperties | `ApplyStatus(SELF,STORM_FISTS_6,100,5);` | `ApplyStatus(SELF,STORM_FISTS_6,100,3);` |
| TooltipStatusApply | `ApplyStatus(STORM_FISTS_6,100,5)` | `ApplyStatus(STORM_FISTS_6,100,3)` |

Notes — `Shout_Arcana_Card_Spell_StormFists_6`:
- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.
- Storm Fists lasts 3 turns at every slot (WB34).

Numbers: `3` turns (the cards) = `SPL_Unbound_StormFists#duration_next`; the dice are today's.

#### RETIRE · entries that leave the Windborn at this level — do not delete them

Nothing to type. After the steps above no list, progression or entry of the mod points to them any more; they stay in the mod, unused (OR-10: a published entry is never renamed or deleted — an old save may still name it).

| Entry | File | Why it leaves |
|---|---|---|
| `Arcana_Passive_Weightless_5` | Stats / Passive | the old Feather Fall chain, replaced by Weightless 1/4/8/12 (WB47) |
| `Arcana_Passive_TwinkleToes_5` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**Existing handles whose text changes** (open the entry, then the text of the field):

| Handle | Used by | Before | After |
|---|---|---|---|
| `h4126aefbgab9bg78e3gbbc7g4054d670e393` | `STORM_FISTS.Description` | `The wind flows through your hands. Your unarmed attacks deal an additional [1].<br><br>Equipping armour or a shield ends this effect.` | `The wind flows through your hands. Unarmed attacks deal an additional [1] against enemies that aren't Windswept.` |
| `h456b6976gfa1cg7d54geb90g1660c0e4606b` | `Shout_Arcana_Card_Spell_StormFists.Description` | `The wind flows through your hands. Your unarmed attacks deal an additional [1].<br><br>Afterwards, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `The wind flows through your hands. Your unarmed attacks deal an additional [1] against enemies that aren't <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag>.` |
| `h8451466fg943fg2766g54bbge5811a2ba1a9` | `Arcana_Passive_Aspect_Fool_II.DisplayName`, `Arcana_Passive_Aspect_Fool_Awakened_II.DisplayName` | `Restless Wind` | `Fellow Travellers` |
| `hc98e7379g11e3gb428g4681g9f94f5551213` | `ASPECT_AWAKENED_FOOL_II.Description` | `Wanderlust: Your <LSTag Tooltip="MovementSpeed">movement speed</LSTag> increases by [1], you can move without provoking <LSTag Tooltip="OpportunityAttack">Opportunity Attacks</LSTag>, and your unarmed attacks deal an additional [2].<br><br>Restless Wind: You have <LSTag Tooltip="Advantage">Advantage</LSTag> on Dexterity <LSTag Tooltip="SavingThrow">Saving Throws</LSTag> and an additional <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag>. Once per turn, Zephyr Strike doesn't cost a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.<br><br>Only active while not wearing armour or using a shield.` | `The First Step: Once per turn, a Zephyr Strike that carries you to an enemy doesn't cost a bonus action.<br>Fellow Travellers: Your allies' hits also make enemies Windswept.<br><br>Only active while not wearing armour or using a shield.` |
| `hd61170aagfbdeg9e94g39f3gab4d01140c21` | `Arcana_Passive_Aspect_Fool_II.Description` | `You have <LSTag Tooltip="Advantage">Advantage</LSTag> on Dexterity <LSTag Tooltip="SavingThrow">Saving Throws</LSTag> and an additional <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag>. Once per turn, Zephyr Strike doesn't cost a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `Your allies' hits also make enemies Windswept.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 7 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-7 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L7) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 8

> **What this file is.** The point-by-point guide to enter **level 8** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Storm: second Rush, longer wind, Weightless 3*. Headline: "The wind doesn't stop". Technical source: `SPEC_ARC-0026` (stage 8).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 7 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `ARCANA_STORM_RUSH` | new | — | ☐ |
| 02 | Stats Editor | Stats / Passive | `Arcana_Passive_Weightless_8` | new | — | ☐ |
| 03 | Stats Editor | Stats / Passive | `Arcana_Passive_Zephyr_Storm` | new | — | ☐ |
| 04 | Stats Editor | SpellData / Rush | `Rush_Arcana_Created_ZephyrRush_Storm` | new | — | ☐ |
| 05 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 8 | change | — | ☐ |
| 06 | — | PC edition | `CardDB.lua` | Claude adds the lines | all above | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 05 · CHANGED · Progressions / Progressions · `bacab022-3911-456f-9847-025d9e6ab7b5` (table `d75cb44d…`, level 8)

| Field | Before | After |
|---|---|---|
| PassivesAdded | — | `Arcana_Passive_Zephyr_Storm;Arcana_Passive_Weightless_8` |
| PassivesRemoved | — | `Arcana_Passive_Weightless_4` |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01 · NEW · StatusData / Status_BOOST · Storm: The Wind Doesn't Stop

| Field | `ARCANA_STORM_RUSH` |
|---|---|
| Name | `ARCANA_STORM_RUSH` |
| DisplayName | `Storm: The Wind Doesn't Stop` |
| Description | `The wind can carry you to one more enemy that isn't <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> this turn.` |
| Icon | `Action_Monk_StepOfTheWind_Dash` |
| StackId | `ARCANA_STORM_RUSH` |
| TickType | `EndTurn` |
| Boosts | `UnlockSpell(Rush_Arcana_Created_ZephyrRush_Storm);` |
| RemoveConditions | `WearingArmor(context.Source) or HasShieldEquipped(context.Source)` |
| RemoveEvents | `OnEquip;OnCombatEnded` |
| StatusPropertyFlags | `ForceOverhead` |

Notes — `ARCANA_STORM_RUSH`:
- Unlocks the free second Rush until the end of the turn; casting it removes the status.
- The Icon is a suggestion.

#### 02–03 · NEW · Stats / Passive · `Arcana_Passive_Weightless_8`, Zephyr Strike: Storm

| Field | `Arcana_Passive_Weightless_8` | `Arcana_Passive_Zephyr_Storm` |
|---|---|---|
| Name | `Arcana_Passive_Weightless_8` | `Arcana_Passive_Zephyr_Storm` |
| Using | `Arcana_Passive_Weightless_1` | — |
| DisplayName | `Weightless` | `Zephyr Strike: Storm` |
| Description | `You move as if the air carried you. Your movement speed increases by [1], your jumps reach [2] times as far, and you take only half Falling damage.` | `The wind doesn't stop. After a Zephyr Strike carries you to an enemy, the wind can carry you to one more, and the bag's winds blow longer.` |
| DescriptionParams | `Distance(6);3` | — |
| ExtraDescription | `Only active while not wearing armour or using a shield.` | — |
| Icon | `PassiveFeature_UnarmoredMovement` | `Action_Monk_StepOfTheWind_Dash` |
| Properties | `Highlighted` | `Highlighted` |
| BoostContext | `OnEquip;OnCreate` | — |
| BoostConditions | `not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` | — |
| Boosts | `ActionResource(Movement,6,0);JumpMaxDistanceMultiplier(3);FallDamageMultiplier(0.5);` | — |
| StatsFunctorContext | — | `OnDamage` |
| StatsFunctorConditions | — | `SpellId('Rush_Arcana_Created_ZephyrRush') and TotalDamageDoneGreaterThan(0) and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` |
| StatsFunctors | — | `ApplyStatus(SELF,ARCANA_STORM_RUSH,100,1)` |

Notes — `Arcana_Passive_Weightless_8` (`Using` = `Arcana_Passive_Weightless_1`; search `Arcana_Passive_Weightless_1` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** DisplayName, ExtraDescription, Icon, Properties, BoostContext, BoostConditions.
- **Ours:** Description, DescriptionParams (the parent has `Distance(3)`), Boosts (the parent has
  `ActionResource(Movement,3,0);`).
- The Icon is a suggestion.

Numbers: `6` / `3` / `0.5` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (level 8).

Notes — `Arcana_Passive_Zephyr_Storm`:
- Rank 3 (level 8): after a Rush that deals damage, one more free Rush this turn (`ARCANA_STORM_RUSH`).
- The Icon is a suggestion.

#### 04 · NEW · SpellData / Rush · Storm: The Wind Doesn't Stop

| Field | `Rush_Arcana_Created_ZephyrRush_Storm` |
|---|---|
| Name | `Arcana_Created_ZephyrRush_Storm` |
| Using | `Arcana_Created_ZephyrRush` |
| Level | `1` |
| SpellProperties | `RemoveStatus(SELF,ARCANA_STORM_RUSH);IF(not Player(context.Source)):ApplyStatus(SELF,AI_HELPER_EXTRAATTACK,100,1);` |
| TargetRadius | `9` |
| HitRadius | `1.5` |
| Movement Speed | `60000` |
| SpellRoll | `Attack(AttackType.MeleeUnarmedAttack)` |
| SpellSuccess | `DealDamage(UnarmedDamage,Bludgeoning);IF(HasPassive('Arcana_Passive_Zephyr_Gale',context.Source)):Force(3);` |
| TargetConditions | `Character() and Enemy() and not Dead() and not HasStatus('ARCANA_WINDSWEPT') and not HasPassive('ARCANA_IS_CARD', context.Source)` |
| Icon | `Action_Monk_StepOfTheWind_Dash` |
| DisplayName | `Storm: The Wind Doesn't Stop` |
| Description | `The wind can carry you to one more enemy that isn't <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> this turn.` |
| ExtraDescription | `Only an enemy that isn't <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag>.<br><br>Gale: the strike pushes the target back.<br>Storm: after this strike, the wind can carry you to one more.<br><br>Can only be used while not wearing armour or using a shield.` |
| TooltipDamageList | `DealDamage(UnarmedDamage,Bludgeoning)` |
| TooltipAttackSave | `MeleeUnarmedAttack` |
| TooltipPermanentWarnings | `Doesn't provoke Opportunity Attacks.` |
| CastSound | `Action_Cast_SpringAttack` |
| PreviewCursor | `Melee` |
| CastTextEvent | `Cast` |
| Requirements | `!Immobile` |
| CycleConditions | `Enemy() and not Dead()` |
| UseCosts | — |
| SpellFlags | `IsMelee;IsHarmful;Temporary;DisableBlood` |
| AnimationIntentType | `Aggressive` |
| Intent | `Damage` |
| RequirementConditions | `not HasStatus('SG_Polymorph_BeastShape') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);` |
| StopAtFirstContact | `0` |
| HitExtension | `1` |
| OnlyHit1Target | `1` |
| DamageType | `Bludgeoning` |
| Sheathing | `DontChange` |

Notes — `Rush_Arcana_Created_ZephyrRush_Storm` (`Using` = `Arcana_Created_ZephyrRush`; search `Arcana_Created_ZephyrRush` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Level, HitRadius, Movement Speed, SpellRoll, SpellSuccess, Icon, ExtraDescription,
  TooltipDamageList, TooltipAttackSave, TooltipPermanentWarnings, CastSound, PreviewCursor, CastTextEvent,
  Requirements, CycleConditions, SpellFlags, AnimationIntentType, Intent, RequirementConditions, StopAtFirstContact,
  HitExtension, OnlyHit1Target, DamageType, Sheathing.
- **Ours:** SpellProperties (the parent has `IF(not
  Player(context.Source)):ApplyStatus(SELF,AI_HELPER_EXTRAATTACK,100,1);`), TargetRadius (the parent has `12`),
  TargetConditions (the parent has `Character() and Enemy() and not Dead() and not HasStatus('ARCANA_WINDSWEPT') and
  not HasPassive('ARCANA_IS_CARD', context.Source) and (DistanceToTargetLessThan(9) or
  HasPassive('Arcana_Passive_Zephyr_Gale', context.Source))`), DisplayName, Description.
- **Clears the parent:** UseCosts (the parent has `BonusActionPoint:1;`).
- Storm's second Rush: free, 9 m, only to another enemy that isn't Windswept.
- The Icon is a suggestion.

Numbers: `9` = `FEAT_Unbound_TheOpenRoad#storm_rush_range_next`.

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 06 | Storm's second Rush: conjured by `ARCANA_STORM_RUSH`. | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**New handles** (typed in the blocks above):

| Key | English text |
|---|---|
| `WB_STORM_RUSH_DESC` | `The wind can carry you to one more enemy that isn't <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> this turn.` |
| `WB_STORM_RUSH_NAME` | `Storm: The Wind Doesn't Stop` |
| `WB_WEIGHTLESS_2_DESC` | `You move as if the air carried you. Your movement speed increases by [1], your jumps reach [2] times as far, and you take only half Falling damage.` |
| `WB_RANK_STORM` | `Zephyr Strike: Storm` |
| `WB_RANK_STORM_DESC` | `The wind doesn't stop. After a Zephyr Strike carries you to an enemy, the wind can carry you to one more, and the bag's winds blow longer.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 8 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-8 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L8) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 9

> **What this file is.** The point-by-point guide to enter **level 9** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Untethered; Empty State*. Headline: "I fly; blows barely touch me". Technical source: `SPEC_ARC-0026` (stage 9).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 8 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `FLY_UNTETHERED` | change | — | ☐ |
| 02 | UUID Object Editor | Lists / SpellLists | "Unbound Level 9" | change | — | ☐ |
| 03 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 9 | change | — | ☐ |
| 04 | — | Generated | `ARCANA_CardFamilies` without Evasive Flow | Claude runs scripts | all above | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 02 · CHANGED · Lists / SpellLists · `fc46dcfe-4126-4b55-92ab-87e8fb43e8f9` ("Unbound Level 9")

| Field | Before | After |
|---|---|---|
| Spells | `Shout_Arcana_Card_Ability_Untethered;Shout_Arcana_Card_Spell_EvasiveFlow` | `Shout_Arcana_Card_Ability_Untethered` |

#### 03 · CHANGED · Progressions / Progressions · `1e8fdfd5-879c-455b-a5bd-0a52c7ea5dd9` (table `d75cb44d…`, level 9)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_9;Arcana_Passive_Weightless_9;Arcana_Passive_EyeOfTheStorm_UI` | `Arcana_Passive_EmptyState` |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_7;Arcana_Passive_Weightless_7` | — |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01 · CHANGED · StatusData / Status_BOOST · `FLY_UNTETHERED`

| Field | Before | After |
|---|---|---|
| Boosts | `UnlockSpell(Projectile_Arcana_Card_Ability_Fly_Untethered);` | `UnlockSpell(Projectile_Arcana_Card_Ability_Fly_Untethered);AC(2);` |
| Passives | `Arcana_Passive_EyeOfTheStorm;` | — |

Notes — `FLY_UNTETHERED`:
- Untethered (WB35) folds Eye of the Storm's +2 Armour Class into the flight; the passive goes (removed at this level).

Numbers: `2` = `SPL_Unbound_Untethered#flying_ac_next`.

#### RETIRE · entries that leave the Windborn at this level — do not delete them

Nothing to type. After the steps above no list, progression or entry of the mod points to them any more; they stay in the mod, unused (OR-10: a published entry is never renamed or deleted — an old save may still name it).

| Entry | File | Why it leaves |
|---|---|---|
| `Shout_Arcana_Card_Spell_EvasiveFlow_6` | SpellData / Shout | a variant of Evasive Flow |
| `Shout_Arcana_Card_Spell_EvasiveFlow_5` | SpellData / Shout | a variant of Evasive Flow |
| `Arcana_Passive_Weightless_7` | Stats / Passive | the old Feather Fall chain, replaced by Weightless 1/4/8/12 (WB47) |
| `Arcana_Passive_TwinkleToes_7` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `Arcana_Passive_EyeOfTheStorm_UI` | Stats / Passive | its level-9 marker; Empty State takes the slot |
| `Arcana_Passive_EyeOfTheStorm` | Stats / Passive | folded into Untethered (WB35) |
| `Shout_Arcana_Card_Spell_EvasiveFlow` | SpellData / Shout | retired (WB36); Wind Whispers keeps its Advantage |
| `EVASIVE_FLOW` | StatusData / Status_BOOST | Evasive Flow's status |

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 04 | `ARCANA_CardFamilies` without Evasive Flow | `82_Automation/stats/gen_upcast_variants.pl --apply`, then `sort_stats.pl --apply` and `check_cards.pl` | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**Existing handles whose text changes** (open the entry, then the text of the field):

| Handle | Used by | Before | After |
|---|---|---|---|
| `hc722a395gc58egeaa3g741ag3ed8de7bb01f` | `Shout_Arcana_Card_Ability_Untethered.Description` | `Freed from earthly ties, gain the ability to <LSTag Type="Spell" Tooltip="Projectile_Arcana_Card_Ability_Fly_Untethered">Fly</LSTag>.<br><br>Afterwards, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `Freed from earthly ties, gain the ability to Fly. While you fly, the air wraps around you and protects you.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 9 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-9 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L9) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 10

> **What this file is.** The point-by-point guide to enter **level 10** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Leap of Faith*. Headline: "I leap through them all". Technical source: `SPEC_ARC-0026` (stage 10).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 9 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | SpellData / Rush | `Rush_Arcana_Created_Aspect_LeapOfFaith` | change | — | ☐ |
| 02 | UUID Object Editor | Lists / SpellLists | "Unbound Level 10" | new | — | ☐ |
| 03 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 10 | change | — | ☐ |
| 04 | — | Generated | `ARCANA_CardFamilies` row for Leap of Faith | Claude runs scripts | all above | ☐ |
| 05 | — | PC edition | `CardDB.lua` | Claude adds the lines | all above | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 02 · NEW · Lists / SpellLists · "Unbound Level 10"

| Field | Value |
|---|---|
| Name | `Unbound Level 10` |
| Spells | `Rush_Arcana_Created_Aspect_LeapOfFaith` |

UUID: ________ (used in step 03)

#### 03 · CHANGED · Progressions / Progressions · `e94f9a80-20e2-44cc-ab3c-bebfa5b61ab9` (table `d75cb44d…`, level 10)

| Field | Before | After |
|---|---|---|
| Selectors | — | `AddSpells(<UUID from step 02>,,,,AlwaysPrepared)` |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01 · CHANGED · SpellData / Rush · `Rush_Arcana_Created_Aspect_LeapOfFaith`

| Field | Before | After |
|---|---|---|
| Cooldown | `OncePerCombat` | `OncePerShortRest` |
| SpellProperties | `GROUND:ApplyStatus(SELF,ZEPHYR_STRIKE,100,1)` | — |
| Spell Animation | the current animation | copy it from vanilla `Rush_ForceTunnel` (open it, copy the field, paste it here) |

Notes — `Rush_Arcana_Created_Aspect_LeapOfFaith`:
- Leap of Faith (WB7, WB38): a level-10 card, once per Short Rest, on the Force Tunnel dash. Its old `SpellProperties` (the Zephyr it granted) go: it is a card, so The Open Road grants Zephyr after it.

Numbers: Level `10` (the list it joins) = `SPL_Unbound_LeapOfFaith#level_next`.

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 04 | `ARCANA_CardFamilies` row for Leap of Faith | `82_Automation/stats/gen_upcast_variants.pl --apply`, then `sort_stats.pl --apply` and `check_cards.pl` | after you save |
| 05 | Leap of Faith: a deck card (`cost 0`). | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**Existing handles whose text changes** (open the entry, then the text of the field):

| Handle | Used by | Before | After |
|---|---|---|---|
| `hf3ca749cg6cdag38d5g9156g1224545d6d20` | `Rush_Arcana_Created_Aspect_LeapOfFaith.Description` | `Dash through the fray, striking every creature in your path with an unarmed attack that also deals [1].<br><br>Afterwards, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.` | `Dash through the fray, striking every creature in your path with an unarmed attack that also deals [1]. Every enemy you strike becomes <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag>.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 10 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-10 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L10) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 11

> **What this file is.** The point-by-point guide to enter **level 11** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Where the Winds Meet*. Headline: "I gather the battlefield". Technical source: `SPEC_ARC-0026` (stage 11).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 10 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | SpellData / Target | `Target_Arcana_Created_WhereTheWindsMeet` | new | — | ☐ |
| 02 | UUID Object Editor | Lists / SpellLists | "Unbound Level 11" | change | — | ☐ |
| 03 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 11 | change | — | ☐ |
| 04 | — | Generated | `ARCANA_CardFamilies` without Thunderclap, with Where the Winds Meet | Claude runs scripts | all above | ☐ |
| 05 | — | PC edition | `CardDB.lua` | Claude adds the lines | all above | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 02 · CHANGED · Lists / SpellLists · `f0892650-f4dd-41c1-bbe3-76cd7e361985` ("Unbound Level 11")

| Field | Before | After |
|---|---|---|
| Spells | `Shout_Arcana_Card_Spell_Thunderclap` | `Target_Arcana_Created_WhereTheWindsMeet` |

#### 03 · CHANGED · Progressions / Progressions · `3be9c808-f46a-47c0-9562-9ca8009b2964` (table `d75cb44d…`, level 11)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_11;Arcana_Passive_Weightless_11;Arcana_Passive_Momentum_UI` | — |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_9;Arcana_Passive_Weightless_9` | — |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01 · NEW · SpellData / Target · Where the Winds Meet

| Field | `Target_Arcana_Created_WhereTheWindsMeet` |
|---|---|
| Name | `Arcana_Created_WhereTheWindsMeet` |
| Using | `Shatter` |
| Level | `0` |
| SpellSchool | `Evocation` |
| Cooldown | `OncePerRest` |
| TargetRadius | `18` |
| AreaRadius | `9` |
| Requirements | `Combat` |
| RequirementConditions | `not HasStatus('ARCANA_BAG_OPEN') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` |
| SpellRoll | `not SavingThrow(Ability.Dexterity, SourceSpellDC())` |
| SpellSuccess | `IF(HasStatus('ARCANA_WINDSWEPT')):Force(-9, TargetToEntity);IF(not HasStatus('ARCANA_WINDSWEPT')):Force(-6, TargetToEntity);DealDamage(4d8,Thunder,Magical);ApplyStatus(OFF_BALANCED,100,1);ApplyStatus(ARCANA_WINDSWEPT,100,2)` |
| SpellFail | `IF(HasStatus('ARCANA_WINDSWEPT')):Force(-9, TargetToEntity);IF(not HasStatus('ARCANA_WINDSWEPT')):Force(-6, TargetToEntity);DealDamage((4d8)/2,Thunder,Magical);ApplyStatus(OFF_BALANCED,100,1);ApplyStatus(ARCANA_WINDSWEPT,100,2)` |
| TargetConditions | `Enemy() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)` |
| Icon | `Spell_Evocation_GustOfWind` |
| DisplayName | `Where the Winds Meet` |
| Description | `Call the four winds to a single point. Enemies around it are pulled to its centre, take [1] and become <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> and <LSTag Type="Status" Tooltip="OFF_BALANCED">Off Balance</LSTag>.` |
| DescriptionParams | `DealDamage(4d8,Thunder)` |
| ExtraDescription | `Windswept enemies are pulled from farther away. A successful <LSTag Tooltip="SavingThrow">Dexterity Saving Throw</LSTag> halves the damage.<br><br>Can only be used while no wind blows.` |
| TooltipDamageList | `DealDamage(4d8,Thunder)` |
| TooltipAttackSave | `Dexterity` |
| TooltipStatusApply | `ApplyStatus(OFF_BALANCED,100,1);ApplyStatus(ARCANA_WINDSWEPT,100,2)` |
| TooltipOnSave | `Targets still take half damage.` |
| TooltipUpcastDescription | `Additional damage` |
| TooltipUpcastDescriptionParams | `DealDamage(1d8,Thunder)` |
| PrepareSound | `Spell_Prepare_Damage_Thunder_Gen_L1to3` |
| PrepareLoopSound | `Spell_Loop_Damage_Thunder_Gen_L1to3` |
| CastSound | `Spell_Cast_Damage_Thunder_Shatter_L1to3` |
| TargetSound | `Spell_Impact_Damage_Thunder_Shatter_L1to3` |
| CastTextEvent | `Cast` |
| CycleConditions | `Enemy() and not Dead()` |
| UseCosts | `ActionPoint:1;` |
| Intent | `Control` |
| SpellFlags | `IsSpell;HasSomaticComponent;IsHarmful` |
| HitAnimationType | `MagicalDamage_Psychic` |
| DamageType | `Thunder` |

Notes — `Target_Arcana_Created_WhereTheWindsMeet` (`Using` = `Shatter`; search `Shatter` in the picker):
- **Copy from the parent in the Toolkit, then remove `Using`:** CastEffect, PositionEffect, PrepareEffect, Spell Animation.
- **From the parent:** SpellSchool, TargetRadius, TooltipOnSave, TooltipUpcastDescription,
  TooltipUpcastDescriptionParams, PrepareSound, PrepareLoopSound, CastSound, TargetSound, CastTextEvent,
  CycleConditions, HitAnimationType, DamageType.
- **Ours:** Level (the parent has `2`), Cooldown, AreaRadius (the parent has `3`), Requirements,
  RequirementConditions, SpellRoll (the parent has `not SavingThrow(Ability.Constitution,
  SourceSpellDC(),false,IsInorganic())`), SpellSuccess (the parent has `DealDamage(3d8,Thunder,Magical)`), SpellFail
  (the parent has `DealDamage((3d8)/2,Thunder,Magical)`), TargetConditions (the parent has `not Dead() and not
  (HasPassive('SculptSpells', context.Source) and Ally())`), Icon (the parent has `Spell_Evocation_Shatter`),
  DisplayName, Description, DescriptionParams, ExtraDescription, TooltipDamageList (the parent has
  `DealDamage(3d8,Thunder)`), TooltipAttackSave (the parent has `Constitution`), TooltipStatusApply, UseCosts (the
  parent has `ActionPoint:1;SpellSlotsGroup:1:1:2`), Intent (the parent has `Damage`), SpellFlags (the parent has
  `IsSpell;HasHighGroundRangeExtension;HasVerbalComponent;HasSomaticComponent;IsHarmful`).
- MemoryCost: the parent's `1` stays and does no harm (cards are always prepared).
- The capstone (WB26, WB46, WB49, WB50): aimed at a point on the ground. One 9 m area for every enemy; a Windswept enemy is pulled 9 m, any other 6 m (the `IF` is read before the mark is applied). Only while no wind blows. Check in game that the pull goes to the point, not to her; plan B: `GROUND:CreateExplosion` of a pulling explosion.
- The Icon is a suggestion.

Numbers: `18` = `SPL_Unbound_WhereTheWindsMeet#range_next`; `9` (AreaRadius) = `#area_radius_next`; `9` / `6` (`Force`) = `#pull_distance_windswept_next` / `#pull_distance_next`; `4d8` = `#damage_next`.

#### RETIRE · entries that leave the Windborn at this level — do not delete them

Nothing to type. After the steps above no list, progression or entry of the mod points to them any more; they stay in the mod, unused (OR-10: a published entry is never renamed or deleted — an old save may still name it).

| Entry | File | Why it leaves |
|---|---|---|
| `Shout_Arcana_Card_Spell_Thunderclap_6` | SpellData / Shout | a variant of Thunderclap |
| `Arcana_Passive_Weightless_9` | Stats / Passive | the old Feather Fall chain, replaced by Weightless 1/4/8/12 (WB47) |
| `Arcana_Passive_TwinkleToes_9` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `Arcana_Passive_Momentum_UI` | Stats / Passive | its level-11 marker |
| `Shout_Arcana_Card_Spell_Thunderclap` | SpellData / Shout | absorbed by Storm Fists (WB34, WB37) |
| `THUNDERCLAP` | StatusData / Status_BOOST | Thunderclap's status |
| `Arcana_Passive_Thunderclap` | Stats / Passive | Thunderclap's passive |
| `Arcana_Passive_Momentum` | Stats / Passive | retired (WB37) |

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 04 | `ARCANA_CardFamilies` without Thunderclap, with Where the Winds Meet | `82_Automation/stats/gen_upcast_variants.pl --apply`, then `sort_stats.pl --apply` and `check_cards.pl` | after you save |
| 05 | Where the Winds Meet: a 0-Thread card. | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**New handles** (typed in the blocks above):

| Key | English text |
|---|---|
| `WB_MEET_EXTRA` | `Windswept enemies are pulled from farther away. A successful <LSTag Tooltip="SavingThrow">Dexterity Saving Throw</LSTag> halves the damage.<br><br>Can only be used while no wind blows.` |
| `WB_MEET_NAME` | `Where the Winds Meet` |
| `WB_MEET_DESC` | `Call the four winds to a single point. Enemies around it are pulled to its centre, take [1] and become <LSTag Type="Status" Tooltip="ARCANA_WINDSWEPT">Windswept</LSTag> and <LSTag Type="Status" Tooltip="OFF_BALANCED">Off Balance</LSTag>.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 11 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-11 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L11) and write the results there.
4. Tick the steps in section 0.

---

# The Windborn — level 12

> **What this file is.** The point-by-point guide to enter **level 12** of the Windborn (internal name *Unbound*)
> by hand in the BG3 Toolkit — *Tier III Into the Storm + Hurricane (two winds), Weightless 4*. Headline: "The storm". Technical source: `SPEC_ARC-0026` (stage 12).
> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026
> (commit `09f30e0`): regenerate it, never edit a number by hand (ADR-0008).
>
> **Before you start:** level 11 is typed, compiled and its tests in `QA-0004` passed.

---

### 0 · Order of work

| # | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|
| 01 | Stats Editor | StatusData / Status_BOOST | `ARCANA_INTO_THE_STORM` | new | — | ☐ |
| 02 | Stats Editor | Stats / Passive | `Arcana_Passive_Zephyr_Hurricane` | new | — | ☐ |
| 03 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag_BoreasEurus` | new | — | ☐ |
| 04 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag_BoreasNotus` | new | — | ☐ |
| 05 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag_NotusEurus` | new | — | ☐ |
| 06 | Stats Editor | Stats / Passive | `Arcana_Passive_Weightless_12` | change (rewritten) | — | ☐ |
| 07 | Stats Editor | Stats / Passive | `Arcana_Passive_Aspect_Fool_Awakened_III` | change | — | ☐ |
| 08 | Stats Editor | Stats / Passive | `Arcana_Passive_Aspect_Fool_III` | change | — | ☐ |
| 09 | Stats Editor | SpellData / Shout | `Shout_Arcana_Created_AeolusBag` | change | — | ☐ |
| 10 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 12 | change | — | ☐ |
| 11 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 13 | change | — | ☐ |
| 12 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 15 | change | — | ☐ |
| 13 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 17 | change | — | ☐ |
| 14 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 19 | change | — | ☐ |
| 15 | UUID Object Editor | Progressions / Progressions | table `d75cb44d…` level 20 | change | — | ☐ |
| 16 | — | PC edition | `CardDB.lua` | Claude adds the lines | all above | ☐ |

---

### 1 · Stories (Osiris)

Nothing at this level: the goal entered at level 2 already handles it.

---

### 2 · UUID Object Editor

#### 10 · CHANGED · Progressions / Progressions · `207f9358-88f8-4c28-a7e5-4cbc5b528cc3` (table `d75cb44d…`, level 12)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_12;Arcana_Passive_Weightless_12;Arcana_Passive_EmptyState;Arcana_Passive_Aspect_Fool_III` | `Arcana_Passive_Weightless_12;Arcana_Passive_Aspect_Fool_III;Arcana_Passive_Zephyr_Hurricane` |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_11;Arcana_Passive_Weightless_11` | `Arcana_Passive_Weightless_8` |

#### 11 · CHANGED · Progressions / Progressions · `e6cfeae8-e674-4047-a700-b16aadb04a2e` (table `d75cb44d…`, level 13)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_13` | — |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_12` | — |

#### 12 · CHANGED · Progressions / Progressions · `c63a38be-8cd1-43ba-9df2-cd790e25354b` (table `d75cb44d…`, level 15)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_15` | — |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_13` | — |

#### 13 · CHANGED · Progressions / Progressions · `f654f991-a4b7-452b-96b1-57029a496eb6` (table `d75cb44d…`, level 17)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_17` | — |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_15` | — |

#### 14 · CHANGED · Progressions / Progressions · `916ca4c5-e2fe-49a4-a2b2-b16addc0025e` (table `d75cb44d…`, level 19)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_19` | — |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_17` | — |

#### 15 · CHANGED · Progressions / Progressions · `d33bb4ba-8201-4993-a418-8c697850a2a1` (table `d75cb44d…`, level 20)

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_TwinkleToes_20` | — |
| PassivesRemoved | `Arcana_Passive_TwinkleToes_19` | — |

---

### 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles. **Notes**
> under each block: **From the parent** = the `Using` parent already has exactly this value — confirm it, and type it
> when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the parent has a value:
> clear it while `Using` is set. Spell names and `Using` are written
> without the type prefix (search the parent by its name in the picker). Rows follow the Toolkit field order below and only the fields to fill, confirm or clear have a row. The numbers of each block are listed under it.

#### 01 · NEW · StatusData / Status_BOOST · Windswept

| Field | `ARCANA_INTO_THE_STORM` |
|---|---|
| Name | `ARCANA_INTO_THE_STORM` |
| DisplayName | `Windswept` |
| StackId | `ARCANA_INTO_THE_STORM` |
| StatusPropertyFlags | `DisableOverhead;DisablePortraitIndicator` |
| OnApplyFunctors | `Force(3);ApplyStatus(OFF_BALANCED,100,1)` |

Notes — `ARCANA_INTO_THE_STORM`:
- Tier III: what a sweep does to each swept enemy. `Force` in a status functor pushes away from the status source (probe P9: pass).

Numbers: `3` (`Force`) = `FEAT_Unbound_AspectAwakening#tier3_push_next`.

#### 02 · NEW · Stats / Passive · Hurricane

| Field | `Arcana_Passive_Zephyr_Hurricane` |
|---|---|
| Name | `Arcana_Passive_Zephyr_Hurricane` |
| DisplayName | `Hurricane` |
| Description | `When you open Aeolus' Bag, you release two winds at once.` |
| Icon | `Spell_Evocation_GustOfWind` |
| Properties | `Highlighted` |

Notes — `Arcana_Passive_Zephyr_Hurricane`:
- Rank 4 (level 12): the bag offers the pairs of winds instead of single ones.
- The Icon is a suggestion.

Numbers: `2` winds at once (the pair children of the bag) = `FEAT_Unbound_AeolusBag#hurricane_winds_next`.

#### 03–05 · NEW · SpellData / Shout · Aeolus' Bag: Boreas and Eurus, Aeolus' Bag: Boreas and Notus, Aeolus' Bag: Notus and Eurus

| Field | `Shout_Arcana_Created_AeolusBag_BoreasEurus` | `Shout_Arcana_Created_AeolusBag_BoreasNotus` | `Shout_Arcana_Created_AeolusBag_NotusEurus` |
|---|---|---|---|
| Name | `Arcana_Created_AeolusBag_BoreasEurus` | `Arcana_Created_AeolusBag_BoreasNotus` | `Arcana_Created_AeolusBag_NotusEurus` |
| Using | `Arcana_Created_AeolusBag_BoreasNotus` | `Arcana_Created_AeolusBag_Boreas` | `Arcana_Created_AeolusBag_BoreasNotus` |
| Level | `0` | `0` | `0` |
| SpellSchool | `Evocation` | `Evocation` | `Evocation` |
| SpellContainerID | `Shout_Arcana_Created_AeolusBag` | `Shout_Arcana_Created_AeolusBag` | `Shout_Arcana_Created_AeolusBag` |
| Icon | `Spell_Evocation_GustOfWind` | `Spell_Evocation_GustOfWind` | `Spell_Evocation_GustOfWind` |
| DisplayName | `Aeolus' Bag: Boreas and Eurus` | `Aeolus' Bag: Boreas and Notus` | `Aeolus' Bag: Notus and Eurus` |
| Description | `Release two winds at once. Both blow for the same turns.` | `Release two winds at once. Both blow for the same turns.` | `Release two winds at once. Both blow for the same turns.` |
| ExtraDescription | `While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind.` | `While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind.` | `While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind.` |
| CastSound | `Spell_Cast_Monk_WholenessOfBody_L1to3` | `Spell_Cast_Monk_WholenessOfBody_L1to3` | `Spell_Cast_Monk_WholenessOfBody_L1to3` |
| TargetSound | `Spell_Impact_Monk_WholenessOfBody_L1to3` | `Spell_Impact_Monk_WholenessOfBody_L1to3` | `Spell_Impact_Monk_WholenessOfBody_L1to3` |
| PreviewCursor | `Cast` | `Cast` | `Cast` |
| CastTextEvent | `Cast` | `Cast` | `Cast` |
| UseCosts | `BonusActionPoint:1;` | `BonusActionPoint:1;` | `BonusActionPoint:1;` |
| Intent | `Buff` | `Buff` | `Buff` |
| Spell Style Group | `Class` | `Class` | `Class` |
| SpellFlags | `IsSpell;HasSomaticComponent` | `IsSpell;HasSomaticComponent` | `IsSpell;HasSomaticComponent` |
| Requirements | `Combat` | `Combat` | `Combat` |
| RequirementConditions | `HasStatus('ARCANA_BAG_READY') and not HasStatus('ARCANA_BAG_OPEN') and HasPassive('Arcana_Passive_Zephyr_Hurricane') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` | `HasStatus('ARCANA_BAG_READY') and not HasStatus('ARCANA_BAG_OPEN') and HasPassive('Arcana_Passive_Zephyr_Hurricane') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` | `HasStatus('ARCANA_BAG_READY') and not HasStatus('ARCANA_BAG_OPEN') and HasPassive('Arcana_Passive_Zephyr_Hurricane') and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)` |

Notes — `Shout_Arcana_Created_AeolusBag_BoreasEurus` (`Using` = `Arcana_Created_AeolusBag_BoreasNotus`; search `Arcana_Created_AeolusBag_BoreasNotus` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Level, SpellSchool, SpellContainerID, Icon, Description, ExtraDescription, CastSound,
  TargetSound, PreviewCursor, CastTextEvent, UseCosts, Intent, Spell Style Group, SpellFlags, Requirements,
  RequirementConditions.
- **Ours:** DisplayName.
- The Icon is a suggestion.

Notes — `Shout_Arcana_Created_AeolusBag_BoreasNotus` (`Using` = `Arcana_Created_AeolusBag_Boreas`; search `Arcana_Created_AeolusBag_Boreas` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Level, SpellSchool, SpellContainerID, Icon, ExtraDescription, CastSound, TargetSound,
  PreviewCursor, CastTextEvent, UseCosts, Intent, Spell Style Group, SpellFlags, Requirements.
- **Ours:** DisplayName, Description, RequirementConditions (the parent has `HasStatus('ARCANA_BAG_READY') and not
  HasStatus('ARCANA_BAG_OPEN') and not HasPassive('Arcana_Passive_Zephyr_Hurricane') and not
  WearingArmor(context.Source) and not HasShieldEquipped(context.Source)`).
- The Icon is a suggestion.

Notes — `Shout_Arcana_Created_AeolusBag_NotusEurus` (`Using` = `Arcana_Created_AeolusBag_BoreasNotus`; search `Arcana_Created_AeolusBag_BoreasNotus` in the picker, our own entry):
- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.
- **From the parent:** Level, SpellSchool, SpellContainerID, Icon, Description, ExtraDescription, CastSound,
  TargetSound, PreviewCursor, CastTextEvent, UseCosts, Intent, Spell Style Group, SpellFlags, Requirements,
  RequirementConditions.
- **Ours:** DisplayName.
- The Icon is a suggestion.

#### 06 · CHANGED (rewritten) · Stats / Passive · `Arcana_Passive_Weightless_12`

| Field | Before | After |
|---|---|---|
| Using | `Arcana_Passive_Weightless_5` | `Arcana_Passive_Weightless_1` |
| Boosts | `IgnoreFallDamage();JumpMaxDistanceMultiplier(6);` | `ActionResource(Movement,9,0);JumpMaxDistanceMultiplier(4);FallDamageMultiplier(0);` |
| Description | (existing handle `h4f6fcb05g4085gfdcfg2308g712317547400`) | `You move as if the air carried you. Your movement speed increases by [1], your jumps reach [2] times as far, and you are <LSTag Tooltip="Immune">Immune</LSTag> to Falling damage.` |
| DescriptionParams | `6` | `Distance(9);4` |

Notes — `Arcana_Passive_Weightless_12`: the old entry is reused under the same name; every row that differs is listed. With `Using` set, the cleared rows come from the parent.

Numbers: `9` / `4` / `0` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (level 12).

#### 07 · CHANGED · Stats / Passive · `Arcana_Passive_Aspect_Fool_Awakened_III`

| Field | Before | After |
|---|---|---|
| Boosts | `Ability(Dexterity,3);ActionResource(ReactionActionPoint,1,0);UnlockInterrupt(Interrupt_Arcana_Aspect_FoolsLuck);ActionResource(ArcanaFoolsLuck,1,0);` | — |

Notes — `Arcana_Passive_Aspect_Fool_Awakened_III`:
- The old tier bonus goes (WB24), Fool's Luck with it (its interrupt and resource are removed at this level).

#### 08 · CHANGED · Stats / Passive · `Arcana_Passive_Aspect_Fool_III`

| Field | Before | After |
|---|---|---|
| DescriptionParams | `3` | `Distance(3)` |

Notes — `Arcana_Passive_Aspect_Fool_III`:
- Tier III *Into the Storm*: the push in its text.

Numbers: `3` = `FEAT_Unbound_AspectAwakening#tier3_push_next`.

#### 09 · CHANGED · SpellData / Shout · `Shout_Arcana_Created_AeolusBag`

| Field | Before | After |
|---|---|---|
| ContainerSpells | — | `Shout_Arcana_Created_AeolusBag_Boreas;Shout_Arcana_Created_AeolusBag_Notus;Shout_Arcana_Created_AeolusBag_Eurus;Shout_Arcana_Created_AeolusBag_BoreasNotus;Shout_Arcana_Created_AeolusBag_BoreasEurus;Shout_Arcana_Created_AeolusBag_NotusEurus` |

Notes — `Shout_Arcana_Created_AeolusBag`:
- Aeolus' Bag (WB11–WB14): a container, one child per wind. Osiris puts `ARCANA_BAG_READY` on her while she has a Windswept enemy and `ARCANA_BAG_OPEN` while a wind blows. At level 2 it lists Boreas and Notus; Eurus joins at 4, the pairs at 12.

#### RETIRE · entries that leave the Windborn at this level — do not delete them

Nothing to type. After the steps above no list, progression or entry of the mod points to them any more; they stay in the mod, unused (OR-10: a published entry is never renamed or deleted — an old save may still name it).

| Entry | File | Why it leaves |
|---|---|---|
| `Interrupt_Arcana_Aspect_FoolsLuck` | Stats / Interrupt | Fool's Luck (old Tier III, WB24) |
| `Arcana_Passive_Weightless_11` | Stats / Passive | the old Feather Fall chain, replaced by Weightless 1/4/8/12 (WB47) |
| `Arcana_Passive_TwinkleToes_20` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `Arcana_Passive_TwinkleToes_19` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `Arcana_Passive_TwinkleToes_17` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `Arcana_Passive_TwinkleToes_15` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `Arcana_Passive_TwinkleToes_13` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `Arcana_Passive_TwinkleToes_12` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |
| `Arcana_Passive_TwinkleToes_11` | Stats / Passive | Twinkle Toes, replaced by Weightless (WB39) |

The resource `ArcanaFoolsLuck` (UUID Object Editor → ActionResourceDefinitions; old Tier III Fool's Luck, WB24) is retired the same way: after this level only the retired interrupt names it.

#### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 16 | The bag's container gains the three pairs. | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |

---

### 4 · Localisation summary

Every text of this level, so nothing is missed.

**New handles** (typed in the blocks above):

| Key | English text |
|---|---|
| `WB_WINDSWEPT_NAME` | `Windswept` |
| `WB_RANK_HURRICANE` | `Hurricane` |
| `WB_RANK_HURRICANE_DESC` | `When you open Aeolus' Bag, you release two winds at once.` |
| `WB_BAG_PAIR_BE` | `Aeolus' Bag: Boreas and Eurus` |
| `WB_BAG_PAIR_DESC` | `Release two winds at once. Both blow for the same turns.` |
| `WB_BAG_PAIR_BN` | `Aeolus' Bag: Boreas and Notus` |
| `WB_BAG_PAIR_NE` | `Aeolus' Bag: Notus and Eurus` |
| `WB_WEIGHTLESS_4_DESC` | `You move as if the air carried you. Your movement speed increases by [1], your jumps reach [2] times as far, and you are <LSTag Tooltip="Immune">Immune</LSTag> to Falling damage.` |

**Existing handles whose text changes** (open the entry, then the text of the field):

| Handle | Used by | Before | After |
|---|---|---|---|
| `h0d5de297g3e6egdc22gc822gf7519e223fc6` | `ASPECT_AWAKENED_FOOL_III.Description` | `Wanderlust: Your <LSTag Tooltip="MovementSpeed">movement speed</LSTag> increases by [1], you can move without provoking <LSTag Tooltip="OpportunityAttack">Opportunity Attacks</LSTag>, and your unarmed attacks deal an additional [2].<br><br>Restless Wind: You have <LSTag Tooltip="Advantage">Advantage</LSTag> on Dexterity <LSTag Tooltip="SavingThrow">Saving Throws</LSTag> and an additional <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag>. Once per turn, Zephyr Strike doesn't cost a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.<br><br>Aspect of Curiosity: Your Dexterity increases by [3] and you have another additional <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag>. Once per round, the first attack against you misses.<br><br>Only active while not wearing armour or using a shield.` | `The First Step: Once per turn, a Zephyr Strike that carries you to an enemy doesn't cost a bonus action.<br>Fellow Travellers: Your allies' hits also make enemies Windswept.<br>Into the Storm: Each time the wind sweeps the marks away, every swept enemy is pushed back and becomes Off Balance.<br><br>Only active while not wearing armour or using a shield.` |
| `hb6f88d63g8e4fg7022gb6fag9bfa869369c6` | `Arcana_Passive_Aspect_Fool_Awakened_III.DisplayName`, `Arcana_Passive_Aspect_Fool_III.DisplayName` | `Aspect of Curiosity` | `Into the Storm` |
| `hd927c9e2gb38ega2c3gb9f5g7e9604a31909` | `Arcana_Passive_Aspect_Fool_III.Description` | `Your Dexterity increases by [1] and you have another additional <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag>. Once per round, the first attack against you misses.` | `Each time the wind sweeps the marks away, every swept enemy is pushed back [1] and becomes <LSTag Type="Status" Tooltip="OFF_BALANCED">Off Balance</LSTag>.` |

---

### 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*.
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível 12 digitado`): I check every block against this
   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.
3. Play the level-12 tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L12) and write the results there.
4. Tick the steps in section 0.

