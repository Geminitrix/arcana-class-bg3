---
id: TOOLKIT_ARC-0020
ticket: ARC-0020
spec: SPEC_ARC-0020
status: ready
derived_from: [25.01/SPL_Deceiver_Splinter.yaml, 25.01/SPL_Deceiver_SplinterOnCommand.yaml, 25.01/SPL_Deceiver_GrandDeception.yaml, 25.01/SPL_Deceiver_SeedOfDoubt.yaml, 25.01/SPL_Deceiver_BindingFalsehood.yaml, 25.01/SPL_Deceiver_Veilstep.yaml, 25.01/SPL_Deceiver_Friends.yaml, 25.01/SPL_Deceiver_MirroredSpell.yaml, 25.01/SPL_Deceiver_TwiceTold.yaml, 25.01/SPL_Deceiver_MirroredSelf.yaml, 25.02/FEAT_Deceiver_TheVeil.yaml]
generated_at: 2026-11-25
author: Mod Engineer
---

# TOOLKIT_ARC-0020 · The Veilwalker — what the rework changes (DV19–DV35)

> **What this file is.** What to type in the BG3 Toolkit to turn the Veilwalker (internal name *Deceiver*) that is in the
> game today — the Veil build of 2026-10-07 with the stage-1 names — into the design of `21.04/Deceiver/DESIGN.md`
> (DV1–DV35). **Only what changes** (the Owner's choice, 2026-11-25): 3 new Stats entries, 6 changed ones, 7 lists,
> 9 progression rows and one goal. Everything else of the Veil build stays as it is and is tested in `QA_ARC-0020`.
> One file, in the order to type it, **feature by feature** (OR-5): §0 is the checklist top to bottom; each feature is
> complete in its part of §3; what each level grants is written once, in the lists and the progression (§2). The tests,
> level by level, are in `61.02/Deceiver/QA_ARC-0020.md`.
>
> **Ids stay as they are** (DV12, DV29): the game ids keep the old names (`…_SigilofMalice` is *Seed of Doubt*,
> `…_MirrorImage` is *Eidolon*, `…_Distortion` is *Veilstep*, `…_EtherealChains` is *Binding Falsehood*,
> `Target_Arcana_Created_Mimic` is *Twice-Told*, `Shout_Deceiver_Double_Shatter` is *Splinter*, `…_MirroredCharm` is
> *Mirrored Self*). Published entries are never renamed (OR-10); the three new ones follow OR-59.
>
> **Not in this file — Mirrored Self from a Double (DV25).** Its engine support is unknown (probe B4 of the SPEC). It
> stays as it is today (one more target) and moves to level 10 with the map; the probe and its build come after this
> playtest (SPEC_ARC-0020 §Deferred).
>
> **Retired, not deleted (OR-10, OR-60):** `Arcana_Passive_Telepathy` (DV26), `Arcana_Passive_Doubt` (DV19) and
> `Arcana_Passive_Aspect_Empress_Awakened_III_Damage` (DV21) leave the progression and the Tier III status; their entries
> stay in the Stats files and go to the archive when the ticket closes.

---

## Rules for whoever writes this file

Keep this section in every guide; it is how the Owner reads the rest (full text: `55/_TEMPLATE_TOOLKIT_GUIDE.md`).

1. **Derived view (ADR-0005, ADR-0008).** Numbers live in `25_Master_Data`; the origin of every number is listed under
   its block. Never edit a number here by hand.
2. **Order.** §0 is the checklist in the order the work has to happen; the step number appears in each entry's title.
   Feature-complete, never level by level (OR-5); what each level grants is written once, in §2.
3. **Stats Editor blocks.** One column per entry, rows in the Toolkit's field order, only the fields to fill, confirm or
   clear. **A cell holds only what is pasted** (`—` = leave empty). Spell `Name` without the type prefix; `Using` without
   it too.
4. **New entries** list, under the block, **From the parent** / **Ours** / **Clears the parent**.
5. **Changed entries:** only what changes, as `before → after`.
6. **Icons are suggestions.**
7. **UUIDs:** the Toolkit makes them; `UUID: ________` marks a slot to fill.
8. **Text:** a new `DisplayName` / `Description` / `ExtraDescription` is a new handle with that English text; a changed
   text of an existing handle says *(existing handle hXXXX — edit its text)*. `[n]` reads `DescriptionParams` (or
   `ExtraDescriptionParams` in an `ExtraDescription`).
9. **Generated families — do not type** (§3, *Generated and PC edition*).
10. **Osiris:** each goal is one copy-paste block.
11. **Exact names (OR-59).**
12. **Look fields** (Spell Animation, the `…Effect` fields, Trajectories): copy them from the parent in the Toolkit, then
    remove `Using`; they have no row.

---

## 0 · Order of work

| # | Feature | Area | File | Entry | Action | Needs | ☐ |
|---|---|---|---|---|---|---|---|
| 01 | A · Splinter on Command | Stats Editor | StatusData / Status_BOOST | `SPLINTER_COMMAND_TECH` | new | — | ☐ |
| 02 | A · Splinter on Command | Stats Editor | SpellData / Target | `Target_Arcana_Card_Spell_SplinterOnCommand` | new | 01 | ☐ |
| 03 | B · Tier III, the lie explodes | Stats Editor | SpellData / Projectile | `Projectile_Arcana_SplinterBurst` | new | — | ☐ |
| 04 | B · Tier III, the lie explodes | Stats Editor | SpellData / Shout | `Shout_Deceiver_Double_Shatter` | change | — | ☐ |
| 05 | B · Tier III, the lie explodes | Stats Editor | Stats / Passive | `Arcana_Passive_Aspect_Empress_Awakened_III`, `Arcana_Passive_Aspect_Empress_III` | change (2) | — | ☐ |
| 06 | B · Tier III, the lie explodes | Stats Editor | StatusData / Status_BOOST | `ASPECT_AWAKENED_EMPRESS_III` | change | 05 | ☐ |
| 07 | C · Grand Deception reads the Veil | Stats Editor | SpellData / Shout | `Shout_Arcana_Card_Spell_GrandDeception` | change | — | ☐ |
| 08 | D · The Veil (cap 4 at level 8) | Stats Editor | Stats / Passive | `Arcana_Passive_TheVeil` | change (text) | — | ☐ |
| 09 | E · The map | UUID Object Editor | Lists / SpellLists | "Deceiver Level 1" | change | — | ☐ |
| 10 | E · The map | UUID Object Editor | Lists / SpellLists | "Deceiver Level 2" | new | — | ☐ |
| 11 | E · The map | UUID Object Editor | Lists / SpellLists | "Deceiver Level 3" | change | — | ☐ |
| 12 | E · The map | UUID Object Editor | Lists / SpellLists | "Deceiver Level 4" | new | 02 | ☐ |
| 13 | E · The map | UUID Object Editor | Lists / SpellLists | "Deceiver Level 5" | change | — | ☐ |
| 14 | E · The map | UUID Object Editor | Lists / SpellLists | "Deceiver Level 7" → "Deceiver Level 6" | change | — | ☐ |
| 15 | E · The map | UUID Object Editor | Lists / SpellLists | "Deceiver Level 12" → "Deceiver Level 10" | change (name) | — | ☐ |
| 16 | E · The map | UUID Object Editor | Progressions / Progressions | Deceiver level 1 (two rows) | change | — | ☐ |
| 17 | E · The map | UUID Object Editor | Progressions / Progressions | Deceiver level 2 | change | 10 | ☐ |
| 18 | E · The map | UUID Object Editor | Progressions / Progressions | Deceiver level 4 | change | 12 | ☐ |
| 19 | E · The map | UUID Object Editor | Progressions / Progressions | Deceiver levels 6 and 7 | change | 14 | ☐ |
| 20 | E · The map | UUID Object Editor | Progressions / Progressions | Deceiver levels 7 and 8 (the cap) | change | — | ☐ |
| 21 | E · The map | UUID Object Editor | Progressions / Progressions | Deceiver levels 10 and 12 | change | 15 | ☐ |
| 22 | F · The Doubles goal | Stories | Goals | `ARCANA_Deceiver_Doubles` | replace the whole goal | 01, 03 | ☐ |
| 23 | — | Generated and PC edition | `ARCANA_CardFamilies`, `CardDB.lua` | Splinter on Command | Claude, after you save | 02 | ☐ |

---

## 1 · Stories (Osiris)

### 22 · Goal `ARCANA_Deceiver_Doubles` — replace the whole goal (parent goal unchanged)

Open the goal in the Story Editor, select all, delete, paste the block below, save, **compile** and read
`Mods/AspectClass_…/Story/log.txt` — it must end with `0 error(s)`. What changed from today's goal (everything else is
identical, line for line):

| Region | Change | Decision |
|---|---|---|
| INITSECTION | two new DBs pinned: `DB_ARCANA_DoubleStruckAt`, `DB_ARCANA_GDBefore` | — |
| The cap | comment: cap 4 at level 8 | DV35 |
| Who destroyed it | new: records where a Double was struck (or died), for the Tier III burst | DV21 |
| Splinter's Double vanishes | new rule: at Tier III a Splinter cast makes the 4 m burst `Projectile_Arcana_SplinterBurst`, her as the caster | DV21 |
| Splinter on Command | new region: the Double marked by `SPLINTER_COMMAND_TECH` casts its Splinter at once | DV24, DV32 |
| Grand Deception | the flat two Doubt replaced: one Doubt per Double that stood within 3 m of the enemy before the cast | DV22 |
| Purge | new: at Tier III a Double an enemy destroyed bursts where it was struck | DV21 |

```
@@GOAL@@
```

Numbers: `3.0` (Grand Deception, metres) = `SPL_Deceiver_GrandDeception#doubles_range_next`; one `PROC_ARCANA_Doubt_Add`
per Double = `SPL_Deceiver_GrandDeception#doubt_per_double_next` (1). The burst's area is in step 03.

---

## 2 · UUID Object Editor

What each level grants, written once (DESIGN §9.1, DV35). Lists are reused where they can be: "Deceiver Level 7" becomes
the level-6 list and "Deceiver Level 12" the level-10 list, so only two lists are new.

| Level | Passives (PassivesAdded) | Spells (list) |
|---|---|---|
| 1 | The Veil | Malicious Whispers · Eidolon · Friends |
| 2 | — | Seed of Doubt · Faceless |
| 3 | Veiled · Awakening (unchanged) | Veiled Prison |
| 4 | — | Splinter on Command |
| 5 | Two Truths (unchanged) | Binding Falsehood |
| 6 | — | Veilstep · Twice-Told |
| 7 | Two Pillars | — |
| 8 | cap 4 | — |
| 9 | unchanged | unchanged |
| 10 | — | Mirrored Self · Mirrored Spell |
| 11 | — | unchanged |
| 12 | Aspect of Doubt · cap 5 (unchanged) | — |

### 09 · CHANGED · Lists / SpellLists · "Deceiver Level 1" (`507f2c2a-ccdd-44f0-bf45-ca3676e1a03f`)

| Field | Before | After |
|---|---|---|
| Spells | `Projectile_Arcana_Card_Spell_SigilofMalice;Shout_Arcana_Util_Faceless;Target_Arcana_Card_Spell_MaliciousWhispers;Target_Arcana_Card_Spell_MirrorImage;Target_Arcana_Util_Friends` | `Target_Arcana_Card_Spell_MaliciousWhispers;Target_Arcana_Card_Spell_MirrorImage;Target_Arcana_Util_Friends` |

### 10 · NEW · Lists / SpellLists · "Deceiver Level 2"

| Field | Value |
|---|---|
| Name | `Deceiver Level 2` |
| Spells | `Projectile_Arcana_Card_Spell_SigilofMalice;Shout_Arcana_Util_Faceless` |

UUID: ________ (used in step 17)

### 11 · CHANGED · Lists / SpellLists · "Deceiver Level 3" (`f5216d9b-4fed-49f0-b1ea-8a5e2b831b59`)

| Field | Before | After |
|---|---|---|
| Spells | `Target_Arcana_Card_Spell_EtherealChains;Target_Arcana_Card_Spell_VeiledPrison` | `Target_Arcana_Card_Spell_VeiledPrison` |

### 12 · NEW · Lists / SpellLists · "Deceiver Level 4"

| Field | Value |
|---|---|
| Name | `Deceiver Level 4` |
| Spells | `Target_Arcana_Card_Spell_SplinterOnCommand` |

UUID: ________ (used in step 18)

### 13 · CHANGED · Lists / SpellLists · "Deceiver Level 5" (`9aac7d55-57b7-4942-afb4-1751e506b172`)

| Field | Before | After |
|---|---|---|
| Spells | `Target_Arcana_Card_Spell_Distortion` | `Target_Arcana_Card_Spell_EtherealChains` |

### 14 · CHANGED · Lists / SpellLists · "Deceiver Level 7" → "Deceiver Level 6" (`8163075e-1c66-4173-a15c-2c78a9524021`)

| Field | Before | After |
|---|---|---|
| Name | `Deceiver Level 7` | `Deceiver Level 6` |
| Spells | `Target_Arcana_Created_Mimic` | `Target_Arcana_Card_Spell_Distortion;Target_Arcana_Created_Mimic` |

### 15 · CHANGED · Lists / SpellLists · "Deceiver Level 12" → "Deceiver Level 10" (`292cab8b-27ad-467c-9a99-2f0b7bddd406`)

| Field | Before | After |
|---|---|---|
| Name | `Deceiver Level 12` | `Deceiver Level 10` |

(Spells unchanged: `Shout_Arcana_Card_Passive_MirroredCharm;Shout_Arcana_Card_Passive_MirroredSpell`.)

### 16 · CHANGED · Progressions / Progressions · Deceiver level 1 — both rows

Table `8fe1f693-d8ff-4b02-a655-efd4acbc04cb`. Two rows at level 1: the class row (`7df73cfc-f7f2-44f5-b017-c5d0c85e333d`,
IsMulticlass false) and the multiclass row (`0c560a79-48fa-4510-897f-081b7be96c1c`, IsMulticlass true). The same change in
both:

| Field | Before | After |
|---|---|---|
| PassivesAdded | `Arcana_Passive_Telepathy;Arcana_Passive_TheVeil;Arcana_Passive_Doubt` | `Arcana_Passive_TheVeil` |

(Selectors unchanged: they keep `AddSpells(507f2c2a-…)`, the list of step 09.)

### 17 · CHANGED · Progressions / Progressions · Deceiver level 2 (`60599c85-c668-4f83-bdd5-3a4360e6812e`)

| Field | Before | After |
|---|---|---|
| Selectors | — | `AddSpells(<UUID from 10>,,,,AlwaysPrepared)` |

### 18 · CHANGED · Progressions / Progressions · Deceiver level 4 (`4d97ac51-3722-46ce-8320-167c9bf8bdb1`)

| Field | Before | After |
|---|---|---|
| Selectors | — | `AddSpells(<UUID from 12>,,,,AlwaysPrepared)` |

### 19 · CHANGED · Progressions / Progressions · Deceiver levels 6 and 7 (the level-6 list)

| Row | Field | Before | After |
|---|---|---|---|
| Level 6 (`cdee39e4-6ef1-4fca-8a34-9b9271b6751c`) | Selectors | — | `AddSpells(8163075e-1c66-4173-a15c-2c78a9524021,,,,AlwaysPrepared)` |
| Level 7 (`d355f68d-767d-42ed-81c6-b7c63e01d7f8`) | Selectors | `AddSpells(8163075e-1c66-4173-a15c-2c78a9524021,,,,AlwaysPrepared)` | — |

### 20 · CHANGED · Progressions / Progressions · Deceiver levels 7 and 8 (cap 4)

| Row | Field | Before | After |
|---|---|---|---|
| Level 7 (`d355f68d-767d-42ed-81c6-b7c63e01d7f8`) | PassivesAdded | `Arcana_Passive_Aspect_Empress_II;Arcana_Passive_VeilCap4` | `Arcana_Passive_Aspect_Empress_II` |
| Level 8 (`b4abe228-1b61-4f53-872d-e294d4bc9925`) | PassivesAdded | — | `Arcana_Passive_VeilCap4` |

Level 8 is a feat level: leave its `AllowImprovement` as it is.

### 21 · CHANGED · Progressions / Progressions · Deceiver levels 10 and 12 (the level-10 list)

| Row | Field | Before | After |
|---|---|---|---|
| Level 10 (`f513be4f-254e-48ed-819c-9ee215eac88d`) | Selectors | — | `AddSpells(292cab8b-27ad-467c-9a99-2f0b7bddd406,,,,AlwaysPrepared)` |
| Level 12 (`dd366005-9385-440c-9515-5363933908c8`) | Selectors | `AddSpells(292cab8b-27ad-467c-9a99-2f0b7bddd406,,,,AlwaysPrepared)` | — |

(Level 12 keeps `PassivesAdded` `Arcana_Passive_Aspect_Empress_III;Arcana_Passive_VeilCap5`.)

---

## 3 · Stats Editor

> **Every cell is exactly what you paste** (double-click it in the preview, copy, paste into the Toolkit) · `—` = leave
> the field empty · `DisplayName` / `Description` / `ExtraDescription` cells are new localisation handles unless they say
> *existing handle*. **Notes** under each block: **From the parent** = the `Using` parent already has exactly this value —
> confirm it, and type it when `Using` is removed · **Ours** = our value · **Clears the parent** = the cell is `—` but the
> parent has a value: clear it while `Using` is set. Spell names and `Using` are written without the type prefix.

### Feature A · Splinter on Command (DV24, DV31, DV32, DV34, DV35 — level 4)

A deck card of level 0 (no slot, no upcast variants), a Bonus Action, 18 m. It only marks one of her Doubles; the goal
(step 22) makes that Double cast its own Splinter at once.

#### 01 · NEW · StatusData / Status_BOOST · `SPLINTER_COMMAND_TECH`

| Field | `SPLINTER_COMMAND_TECH` |
|---|---|
| Name | `SPLINTER_COMMAND_TECH` |
| DisplayName | `Splinter on Command Tech` |
| StackId | `SPLINTER_COMMAND_TECH` |
| StackType | `Overwrite` |
| StatusPropertyFlags | `DisableOverhead;DisableCombatlog;DisablePortraitIndicator` |

Notes: hidden technical status (the `_TECH` pattern of `DOUBT_ADD_TECH`, `GRAND_DECEPTION_TECH`). Duration comes from the
spell (`100,0`: applied and read at once by the goal).

#### 02 · NEW · SpellData / Target · `Target_Arcana_Card_Spell_SplinterOnCommand`

| Field | `Target_Arcana_Card_Spell_SplinterOnCommand` |
|---|---|
| Name | `Arcana_Card_Spell_SplinterOnCommand` |
| Using | `Arcana_Card_Spell_MaliciousWhispers` |
| Level | `0` |
| SpellSchool | `Illusion` |
| SpellProperties | `ApplyStatus(SPLINTER_COMMAND_TECH,100,0)` |
| TargetRadius | `18` |
| SpellRoll | — |
| SpellSuccess | — |
| SpellFail | — |
| TargetConditions | `HasStatus('DOUBLE_OF_THE_VEIL') and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)` |
| AmountOfTargets | `1` |
| Icon | `Spell_Evocation_Shatter` |
| DisplayName | `Splinter on Command` |
| Description | `Command one of your Doubles to <LSTag Type="Spell" Tooltip="Shout_Deceiver_Double_Shatter">Splinter</LSTag> at once.` |
| ExtraDescription | `The Double bursts where it stands, without spending its own turn.` |
| TooltipDamageList | — |
| TooltipAttackSave | — |
| TooltipStatusApply | — |
| PrepareSound | `Vocal_Component_PrepareViciousMockery` |
| CastSound | `Spell_Cast_Damage_Psychic_ViciousMockery_L1to3` |
| TargetSound | `Spell_Impact_Damage_Psychic_ViciousMockery_L1to3` |
| VocalComponentSound | `Vocal_Component_ViciousMockery` |
| CastTextEvent | `Cast` |
| CycleConditions | — |
| UseCosts | `BonusActionPoint:1` |
| Intent | `Utility` |
| Spell Style Group | `Class` |
| SpellFlags | `IsSpell;HasVerbalComponent` |
| HitAnimationType | — |
| DamageType | — |
| Sheathing | `Sheathed` |

Notes (`Using` = `Target_Arcana_Card_Spell_MaliciousWhispers`, the Veilwalker's own cantrip card; search
`Arcana_Card_Spell_MaliciousWhispers` in the picker):
- **Copy from the parent in the Toolkit, then remove `Using`:** Spell Animation, PrepareEffect, CastEffect, TargetEffect,
  BeamEffect.
- **From the parent:** Level, TargetRadius, AmountOfTargets, PrepareSound, CastSound, TargetSound, VocalComponentSound,
  CastTextEvent, Spell Style Group, Sheathing.
- **Ours:** SpellSchool (parent `Enchantment`), SpellProperties, TargetConditions (the parent targets any creature; ours
  only a Double, with the card marker), Icon (suggestion; parent `Spell_Enchantment_DissonantWhispers`), DisplayName,
  Description, ExtraDescription, UseCosts (parent `ActionPoint:1;`), Intent (parent `Damage`), SpellFlags (parent
  `IsSpell;HasVerbalComponent;IsHarmful` — it is not harmful: it targets her own Double).
- **Clears the parent:** SpellRoll (the Wisdom save), SpellSuccess (the whispers' damage and statuses), SpellFail,
  TooltipDamageList, TooltipAttackSave, TooltipStatusApply, CycleConditions (`Enemy() and not Dead()`), HitAnimationType
  (`MagicalDamage_Psychic`), DamageType (`Psychic`).
- `MemoryCost`: the parent's `1` stays and does no harm (cards are always prepared).
- On PC its Thread cost (1) goes in `CardDB.lua` — step 23, Claude.

Numbers: `18` (TargetRadius) = `SPL_Deceiver_SplinterOnCommand#range_next`; `0` (Level, no slot) =
`SPL_Deceiver_SplinterOnCommand#cost_next`; 1 Thread on PC = `SPL_Deceiver_SplinterOnCommand#threads_next`.

### Feature B · Tier III, the lie explodes (DV21 — level 12)

From Tier III every Splinter is one burst of 4 m made by the goal with `Projectile_Arcana_SplinterBurst` (the vanilla Death
Burst pattern), and a Double an enemy destroys bursts by itself. At Tier III the Splinter shout itself deals nothing, so a
Splinter is never two bursts. The Charisma bonus and Charisma to damage leave the tier.

#### 03 · NEW · SpellData / Projectile · `Projectile_Arcana_SplinterBurst`

| Field | `Projectile_Arcana_SplinterBurst` |
|---|---|
| Name | `Arcana_SplinterBurst` |
| Using | `Arcana_Distortion_Explosion` |
| Level | — |
| SpellSchool | `Illusion` |
| SpellProperties | `DealDamage(1d6,Psychic,Magical);ApplyStatus(DOUBT_ADD_TECH,100,0)` |
| AreaRadius | `4` |
| ExplodeRadius | `4` |
| TargetConditions | `Enemy() and Character() and not Dead()` |
| ProjectileCount | `1` |
| Icon | `Spell_Evocation_Shatter` |
| DisplayName | *existing handle `h122c76dbgdcf9g6f07gcc55gacfcd3a5e30b` ("Splinter")* |
| Intent | `Damage` |
| SpellFlags | `IsHarmful;IsSpell` |
| DamageType | `Psychic` |

Notes (`Using` = `Projectile_Arcana_Distortion_Explosion`, Veilstep's own landing burst, proven in the game; search
`Arcana_Distortion_Explosion`):
- **Copy from the parent in the Toolkit, then remove `Using`:** Trajectories, Spell Animation.
- **From the parent:** ProjectileCount, Intent, SpellFlags.
- **Ours:** SpellSchool (parent `Evocation`), SpellProperties (parent `DealDamage(3d8,Force,Magical);`), AreaRadius and
  ExplodeRadius (parent `3`), TargetConditions (parent `not Dead() and Character() and not Ally() and not HasPassive('ARCANA_IS_SPELL', context.Source)`
  — ours drops the Arcana marker, like today's Splinter, so a burst never bursts a Seed), Icon (suggestion; parent
  `PassiveFeature_Generic_Explosion`), DisplayName (the Splinter's own name, so the combat log reads "Splinter"),
  DamageType (parent `Force`).
- **Clears the parent:** Level (parent `3`).
- The goal casts it with `CreateExplosionAtPosition(…, "Projectile_Arcana_SplinterBurst", 1, <her>)`: she is the caster, so
  the damage and the Doubt are hers (probe B2 in the QA).

Numbers: `1d6` = `SPL_Deceiver_Splinter#damage`; `4` (AreaRadius, ExplodeRadius) = `SPL_Deceiver_Splinter#tier3_radius_next`.

#### 04 · CHANGED · SpellData / Shout · `Shout_Deceiver_Double_Shatter` (the Splinter)

| Field | Before | After |
|---|---|---|
| SpellProperties | `DealDamage(1d6,Psychic,Magical);ApplyStatus(DOUBT_ADD_TECH,100,0)` | `IF(not HasStatus('ASPECT_AWAKENED_EMPRESS_III',GetSummoner(context.Source))):DealDamage(1d6,Psychic,Magical);IF(not HasStatus('ASPECT_AWAKENED_EMPRESS_III',GetSummoner(context.Source))):ApplyStatus(DOUBT_ADD_TECH,100,0)` |

Notes: below Tier III nothing changes (3 m, 1d6, Doubt). At Tier III the shout keeps its cost, animation and the
Double's vanishing, but deals nothing: the goal's burst (step 03) does it, 4 m. `GetSummoner(context.Source)` is the
mod's own pattern (the Doubles' `VEIL_LAYER_N` conditions). Probe B6 in the QA.

Numbers: `1d6` = `SPL_Deceiver_Splinter#damage`.

#### 05 · CHANGED · Stats / Passive · `Arcana_Passive_Aspect_Empress_Awakened_III` and `Arcana_Passive_Aspect_Empress_III`

| Entry | Field | Before | After |
|---|---|---|---|
| `Arcana_Passive_Aspect_Empress_Awakened_III` | Boosts | `Ability(Charisma,3);UnlockSpell(Shout_Arcana_Card_Passive_WhichOne);` | `UnlockSpell(Shout_Arcana_Card_Passive_WhichOne);` |
| `Arcana_Passive_Aspect_Empress_III` | Description | *existing handle `hc6233dddg7b75g1f90g74acgcae8cb86d424` — edit its text* | `A Double destroyed by an enemy splinters by itself, and your <LSTag Type="Spell" Tooltip="Shout_Deceiver_Double_Shatter">Splinters</LSTag> reach [1]. You can use <LSTag Type="Spell" Tooltip="Shout_Arcana_Card_Passive_WhichOne">Ready: Which One?</LSTag> until combat ends.` |
| `Arcana_Passive_Aspect_Empress_III` | DescriptionParams | `3` | `Distance(4)` |

Notes: DV21 — no tier gives an ability bonus. Texts approved (`32.04/ARC-0020_Deceiver.md`, stage 3 addendum).

Numbers: `4` = `SPL_Deceiver_Splinter#tier3_radius_next`.

#### 06 · CHANGED · StatusData / Status_BOOST · `ASPECT_AWAKENED_EMPRESS_III`

| Field | Before | After |
|---|---|---|
| Description | *existing handle `hb4946910g6b9agab74g91b3g4fd86b62a6b0` — edit its text* | `Veiled: Enemies with <LSTag Type="Status" Tooltip="DOUBT_1">Doubt</LSTag> have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag> on <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag> against you and your Doubles.<br><br>Two Pillars: Once per turn, when an enemy becomes <LSTag Type="Status" Tooltip="DELUDED">Deluded</LSTag>, the nearest enemy within [1] of it that carries no <LSTag Type="Status" Tooltip="SIGIL">Seed</LSTag> gains yours.<br><br>Aspect of Doubt: A Double destroyed by an enemy splinters by itself, your <LSTag Type="Spell" Tooltip="Shout_Deceiver_Double_Shatter">Splinters</LSTag> reach [2], and you can use <LSTag Type="Spell" Tooltip="Shout_Arcana_Card_Passive_WhichOne">Ready: Which One?</LSTag>.` |
| DescriptionParams | `Distance(6);3` | `Distance(6);Distance(4)` |
| Passives | `Arcana_Passive_Aspect_Empress_Awakened_III;Arcana_Passive_Aspect_Empress_Awakened_III_Damage` | `Arcana_Passive_Aspect_Empress_Awakened_III` |

Notes: `Arcana_Passive_Aspect_Empress_Awakened_III_Damage` (Charisma to damage) leaves the status; its entry stays in
`Passive` (retired, archived at the close). Text approved (`32.04`, stage 3 addendum; the Two Pillars line names the Seed).

Numbers: `6` = `FEAT_Deceiver_AspectAwakening#two_pillars_range`; `4` = `SPL_Deceiver_Splinter#tier3_radius_next`.

### Feature C · Grand Deception reads the Veil (DV22 — level 11)

The flat two Doubt leave: each enemy that fails the save gains one Doubt per Double of hers that stood within 3 m of it
before the cast (the goal, step 22). The upcast variant `_6` inherits everything below through `using`.

#### 07 · CHANGED · SpellData / Shout · `Shout_Arcana_Card_Spell_GrandDeception`

| Field | Before | After |
|---|---|---|
| Description | *existing handle `h0a59f46dgf3e2g782bg80d5g3ec6a72cd40e` — edit its text* | `Surround yourself with <LSTag Type="Passive" Tooltip="Arcana_Passive_TheVeil">Doubles</LSTag> until you reach your limit. Every nearby enemy that fails to see through the lie gains <LSTag Type="Status" Tooltip="DOUBT_1">Doubt</LSTag> for each of your Doubles already standing beside it.` |
| ExtraDescription | *existing handle `hb38d003bge7a3ge395gaf35gc74d0a5c2b52` — edit its text* | `Summons only the Doubles you are missing: you can keep 4, or 5 from level 12.<br><br>Enemies within [1] that fail a <LSTag Tooltip="SavingThrow">Wisdom Saving Throw</LSTag> gain 1 stack of Doubt for each of your Doubles that stood within [2] of them before the cast. A third stack leaves a creature <LSTag Type="Status" Tooltip="DELUDED">Deluded</LSTag>.` |
| ExtraDescriptionParams | `Distance(9)` | `Distance(9);Distance(3)` |
| TooltipStatusApply | `ApplyStatus(DOUBT_2,100,3)` | `ApplyStatus(DOUBT_1,100,3)` |

Notes: `SpellProperties` (the Summons up to the cap), `SpellRoll`, `SpellSuccess` (`GRAND_DECEPTION_TECH`) stay. Texts
approved (`32.04`, stage 3 addendum).

Numbers: `9` = `SPL_Deceiver_GrandDeception#radius`; `3` = `SPL_Deceiver_GrandDeception#doubles_range_next`; 1 stack per
Double = `#doubt_per_double_next`; 4 / 5 = `FEAT_Deceiver_TheVeil#cap_next`.

### Feature D · The Veil — cap 4 at level 8 (DV35)

#### 08 · CHANGED · Stats / Passive · `Arcana_Passive_TheVeil`

| Field | Before | After |
|---|---|---|
| ExtraDescription | *existing handle `h475554feg85f0g3262gf95agde7fb3d1ed7e` — edit its text* | `An enemy believes a lie when it destroys one of your Doubles, when a Splinter hits it, when your Seed bursts in it and when Malicious Whispers finds your Seed. Each stack of Doubt reduces its Wisdom Saving Throws and its Attack Rolls against you and your Doubles by 1.<br><br>You can keep 3 Doubles at once, 4 from level 8 and 5 from level 12. They vanish when combat ends, after a Long Rest or if you die.` |

Notes: only "level 7" → "level 8" changes (DV35); the rest is today's approved text.

Numbers: 3 / 4 / 5 and their levels = `FEAT_Deceiver_TheVeil#cap_next`; `1` per stack = `STA_Deceiver_Doubt`.

### Generated and PC edition — do not type

| # | What | Built by | When |
|---|---|---|---|
| 23 | `ARCANA_CardFamilies`: the row of `Target_Arcana_Card_Spell_SplinterOnCommand` (no upcast variants: level 0) | `82_Automation/stats/gen_upcast_variants.pl --apply`, `sort_stats.pl --apply`, `check_cards.pl` | after you save |
| 23 | The PC deck (`CardDB.lua`): Splinter on Command, 1 Thread | Claude (`_wip/Deceiver/arc0020/lua/`, refreshed against today's Lua) | after you save |

---

## 4 · Localisation summary

| Entry | Field | English text |
|---|---|---|
| `SPLINTER_COMMAND_TECH` | DisplayName (new) | `Splinter on Command Tech` |
| `Target_Arcana_Card_Spell_SplinterOnCommand` | DisplayName (new) | `Splinter on Command` |
| `Target_Arcana_Card_Spell_SplinterOnCommand` | Description (new) | `Command one of your Doubles to <LSTag Type="Spell" Tooltip="Shout_Deceiver_Double_Shatter">Splinter</LSTag> at once.` |
| `Target_Arcana_Card_Spell_SplinterOnCommand` | ExtraDescription (new) | `The Double bursts where it stands, without spending its own turn.` |
| `Projectile_Arcana_SplinterBurst` | DisplayName | existing handle `h122c76db…` ("Splinter") — no new text |
| `Arcana_Passive_Aspect_Empress_III` | Description (edit `hc6233ddd…`) | see step 05 |
| `ASPECT_AWAKENED_EMPRESS_III` | Description (edit `hb4946910…`) | see step 06 |
| `Shout_Arcana_Card_Spell_GrandDeception` | Description (edit `h0a59f46d…`), ExtraDescription (edit `hb38d003b…`) | see step 07 |
| `Arcana_Passive_TheVeil` | ExtraDescription (edit `h475554fe…`) | see step 08 |

The other 14 languages follow in the translation round (as for the Kingmaker and the Windborn).

---

## 5 · After the Toolkit

1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt` (`0 error(s)`).
2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0020`): I check every step against this file, run `sync_data`,
   the generators and `CardDB.lua` of step 23, then `check_cards.pl`, and commit (OR-11: I fix only divergences).
3. Play `QA_ARC-0020` level by level (Arcana Test Guides, tab Veilwalker).
4. Tick the steps in section 0.
