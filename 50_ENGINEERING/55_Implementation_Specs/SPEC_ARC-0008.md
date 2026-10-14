---
id: SPEC_ARC-0008
ticket: ARC-0008
status: draft
implementation: owner
author: Mod Engineer
updated: 2026-10-13
---

# SPEC_ARC-0008 · The Kingmaker — implementation plan

> Technical source for building the Kingmaker. The Owner enters it by hand from the Toolkit guide
> **`TOOLKIT_ARC-0008.md`** (the typing view of this spec, ADR-0008). **One stage at a time**; each stage ends with
> its probes in game before the next one is written in full.

**Intent** (ARC-0008): *the Kingmaker makes the party stronger by keeping allies at the top of Fortune's Wheel while
enemies hit the bottom — and every fall beside a reign hurts.*

**Design:** `21.04/Kingmaker/2026-10-13-kingmaker-design.md` · **Decisions:** `55/_wip/Kingmaker/decisions.md`
(SP47–SP111) · **Numbers:** `25.01/SPL_Kingmaker_*`, `25.02/FEAT_Kingmaker_*` · **Texts:** `55/_wip/Kingmaker/texts.md`
(pending the Narrative gate) · **Balance:** `22.05/2026-10-13_ARC-0008_Kingmaker_Balance.md`.

## Global constraints

- Everything in Stats / LSX / Osiris; **no Script Extender** in the mechanic (console edition). The PC deck entries
  (`CardDB.lua`) are a separate stage written by Claude, not typed in the Toolkit.
- Fixed prefixes (ADR-0002): cards `<Type>_Arcana_Card_Spell_*`, created `<Type>_Arcana_Created_*`, utilities
  `<Type>_Arcana_Util_*`, passives `Arcana_Passive_*`, Osiris `ARCANA_` / `DB_ARCANA_` / `PROC_ARCANA_`. New statuses
  use `KINGMAKER_` (positions, crown, techs) and `COURT_` (offices); technical ones end in `_TECH`.
- A card carries the marker `not HasPassive('ARCANA_IS_CARD', context.Source)` in `TargetConditions` (the mod's
  `IsCardSpell()` pattern, e.g. `Target_Arcana_Card_Spell_Heartstring`).
- Numbers come from `25`; every vanilla function or field below cites its anchor. Where none exists, the item is a
  **probe** with a plan B.
- Upcast variants (`_2`…`_6`) are **generated** (`82_Automation/stats/gen_upcast_variants.pl`), never typed.
- Visible statuses carry `ForceOverhead`; visible passives `Properties "Highlighted"` (project rule).

## Stages

| Stage | Level | What | Gate |
|---|---|---|---|
| **1** | 1 | **The Wheel core**: four position statuses, King/Regent, the Osiris goal that binds, turns and crowns; *The Rota*; cantrip, *Coronation*, *Dethrone*, *Turn the Spoke*; chassis (ClassDescription, ProgressionDescription, preset, defaults, skill list), level-1 list and progression | **Written in full below**; probes P1–P8 |
| 2 | 3 | *The Crossing* (pairs within 9 m, once per enemy per round), *Atropos' Cut*, Awakening *10 · Wheel of Fortune* (count, lone enemy ×2, Tier I *Tyche*), *Rota Fortunae* | Written after stage 1's probes |
| 3 | 5 | *Peripeteia*, *Convene the Court* (container) + King's Hand, Lord Commander, Master of Healing | After stage 2 |
| 4 | 7 | *Hubris*, Tier II *Nemesis*, *Usurp*, Master of Laws, Master of Secrets | After stage 3 |
| 5 | 9 | *Succession*, *Wheel of Ixion* (line + fire surface), Master of Coin, Master of Ships | After stage 4 |
| 6 | 11–12 | *The Wheel Stops*, *Fortune's Reach*, Tier III (allies never Fallen), *Ready: Foreseen*; two Kingmakers share one Wheel (SP93) | After stage 5 |
| 7 | — | PC edition `CardDB.lua` (Claude), test cases in `60`, `05` handoff, renames and icons | DoD |

---

## Stage 1 — the Wheel core (level 1)

### Item index — enter top to bottom

| # | Type | Entry | Where in the Toolkit | Needs |
|---|---|---|---|---|
| 01 | Status BOOST | `KINGMAKER_RISING`, `_REIGNING`, `_FALLING`, `_FALLEN` | Stats → StatusData / Status_BOOST | — |
| 02 | Status BOOST | `KINGMAKER_KING`, `KINGMAKER_REGENT` | Stats → StatusData / Status_BOOST | — |
| 03 | Status BOOST | `KINGMAKER_BIND_ALLY_TECH`, `KINGMAKER_BIND_ENEMY_TECH`, `KINGMAKER_STEP_TECH` | Stats → StatusData / Status_BOOST | — |
| 04 | Passive | `Arcana_Passive_TheRota` | Stats → Passive | — |
| 05 | Spell Projectile | `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` (cantrip) | Stats → SpellData / Projectile | 01 |
| 06 | Spell Target | `Target_Arcana_Card_Spell_Coronation` | Stats → SpellData / Target | 03 |
| 07 | Spell Target | `Target_Arcana_Card_Spell_Dethrone` | Stats → SpellData / Target | 03 |
| 08 | Spell Target | `Target_Arcana_Card_Spell_TurnTheSpoke` | Stats → SpellData / Target | 01, 03 |
| 09 | Generated | upcast variants of 06–07 | `gen_upcast_variants.pl` | 06, 07 |
| 10 | Osiris goal | `ARCANA_Kingmaker_Wheel` | Stories | 01–03 |
| 11 | Skill list | *The Courtier* | UUID Object Editor → Lists / SkillLists | — |
| 12 | Spell list | *Kingmaker Level 1* | UUID Object Editor → Lists / SpellLists | 05–08 |
| 13 | ClassDescription | the Spinner placeholder → Kingmaker | UUID Object Editor → ClassDescriptions | — |
| 14 | ProgressionDescription | `Type` Spinner → Kingmaker | UUID Object Editor → Progressions / ProgressionDescriptions | — |
| 15 | Progression | table `a688d11f…` level 1 | UUID Object Editor → Progressions / Progressions | 04, 11, 12 |
| 16 | Preset, defaults | AbilityDistributionPresets, DefaultValues Abilities / Skills | UUID Object Editor | 11 |

### 01 · Position statuses (vanilla anchors)

| Entry | Boosts | Anchor |
|---|---|---|
| `KINGMAKER_RISING` | `ActionResource(Movement,3,0);StatusImmunity(PRONE)` | `LONGSTRIDER` (Shared `Status_BOOST.txt`); `StatusImmunity(PRONE)` 5 uses in Gustav passives |
| `KINGMAKER_REIGNING` | `ReduceCriticalAttackThreshold(1);Advantage(AllSavingThrows)` | Champion's Improved Critical (SharedDev `Passive.txt`, 11 uses); 16 uses in Shared `Passive.txt` |
| `KINGMAKER_FALLING` | `ActionResource(Movement,-3,0);RollBonus(Attack,-1d4)` | `RAY_OF_FROST`; Bane-like penalty (3 uses, Shared `Status_BOOST.txt`) |
| `KINGMAKER_FALLEN` | `Advantage(AttackTarget);ActionResourceBlock(ReactionActionPoint)` | 62 and 52 uses in Shared `Status_BOOST.txt` |

All four: `StackId "KINGMAKER_POSITION"`, `StackType "Overwrite"`, `StatusPropertyFlags "ForceOverhead"`, applied by
Osiris with duration `-1` (permanent until Osiris swaps or removes it). Values: `FEAT_Kingmaker_TheRota`.

### 02 · The crown

`KINGMAKER_KING`, `KINGMAKER_REGENT`: no boosts (the Reigning status carries the effects); `StackId
"KINGMAKER_CROWN"`, `StackType "Overwrite"`, `ForceOverhead`. Offices that read "the King" (stage 3) test
`HasStatus('KINGMAKER_KING')`.

### 03 · Technical statuses

`KINGMAKER_BIND_ALLY_TECH`, `KINGMAKER_BIND_ENEMY_TECH`, `KINGMAKER_STEP_TECH`: no boosts, `StatusPropertyFlags
"DisableOverhead;DisableCombatlog;DisablePortraitIndicator"`, applied for `0` turns; Osiris reacts to
`StatusApplied` (pattern of `DOUBT_ADD_TECH`).

### 04 · `Arcana_Passive_TheRota`

`Properties "Highlighted"`; no boosts. Osiris doesn't read it in stage 1 (the casters are known from the tech statuses).

### 05–08 · Cards

| Entry | Using (parent) | Key fields | Anchor |
|---|---|---|---|
| `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` | `Projectile_FireBolt` | `Level 0`; `SpellRoll Attack(AttackType.RangedSpellAttack)`; `SpellSuccess DealDamage(LevelMapValue(D6Cantrip),Bludgeoning,Magical);IF(HasStatus('KINGMAKER_FALLING') or HasStatus('KINGMAKER_FALLEN')):DealDamage(1d4,Bludgeoning,Magical)`; `SpellProperties ""` (no ignite); card marker | `Projectile_FireBolt`; `D6Cantrip` (6 vanilla uses) |
| `Target_Arcana_Card_Spell_Coronation` | `Target_ShieldOfFaith` | `Level 1`; `UseCosts BonusActionPoint:1;SpellSlotsGroup:1:1:1`; `SpellProperties ApplyStatus(KINGMAKER_BIND_ALLY_TECH,100,0)`; `TargetConditions (Ally() or Self()) and not Dead() and` not on the Wheel and the card marker; `SpellFlags IsSpell;HasVerbalComponent;HasSomaticComponent` (**drops the parent's `IsConcentration`**) | `Target_ShieldOfFaith` (bonus action, ally) |
| `Target_Arcana_Card_Spell_Dethrone` | `Target_DissonantWhispers` | `Level 1`; `UseCosts ActionPoint:1;SpellSlotsGroup:1:1:1`; `SpellRoll not SavingThrow(Ability.Charisma, SourceSpellDC())`; `SpellSuccess DealDamage(3d6,Bludgeoning,Magical);ApplyStatus(KINGMAKER_BIND_ENEMY_TECH,100,0)`; `SpellFail DealDamage((3d6)/2,Bludgeoning,Magical);ApplyStatus(KINGMAKER_BIND_ENEMY_TECH,100,0)`; `TargetConditions Enemy() and not Dead()` + marker; `TooltipAttackSave Charisma` | `Target_DissonantWhispers` (3d6, half on a save) |
| `Target_Arcana_Card_Spell_TurnTheSpoke` | `Target_Arcana_Card_Spell_Temper` (visuals) | `Level 0`; `UseCosts BonusActionPoint:1`; `SpellRoll ""`; `SpellSuccess ""`; `SpellProperties ApplyStatus(KINGMAKER_STEP_TECH,100,0)`; `TargetConditions` on the Wheel + marker | Temper: level-0 bonus-action card (R34, R45) |

"Not on the Wheel" = `not HasStatus('KINGMAKER_RISING') and not HasStatus('KINGMAKER_REIGNING') and not
HasStatus('KINGMAKER_FALLING') and not HasStatus('KINGMAKER_FALLEN')`; "on the Wheel" = the same four joined by `or`.

### 10 · Osiris goal `ARCANA_Kingmaker_Wheel`

Signatures (`story_header.div`): `StatusApplied(_Object,_Status,_Causee,_StoryActionID)` :1169 · `TurnStarted(_Object)` :1205 ·
`Died(_Character)` :312 · `CombatEnded(_CombatGuid)` :1199 · `ApplyStatus(_Object,_Status,_Duration,_Force,_Source)` :850 ·
`RemoveStatus(_Target,_Status,_Cause)` :851 · `IsSummon(_PotentialSummon,_Bool)` :911. Pattern of the mod's goals:
`ARCANA_Resonant_Grudge.txt`. The full text is in `TOOLKIT_ARC-0008.md` §1.

- **Ledger** `DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order)`: position `"RISING"` … `"FALLEN"`,
  side `1` ally / `0` enemy (fixed at entry, SP92), order = entry order (SP61). Tables `DB_ARCANA_Kingmaker_Next` and
  `DB_ARCANA_Kingmaker_PositionStatus` are filled in the INITSECTION.
- **Bind** on the two bind techs: a creature not yet on the Wheel enters at Rising (ally) or Falling (enemy).
- **Turn** on `TurnStarted` of an owner: copy every row to `DB_ARCANA_Kingmaker_Pending`, then move each pending row one
  step (two phases, so the ledger is never changed while it is read).
- **Step** on `KINGMAKER_STEP_TECH`: one step for that creature.
- **Every move** calls `PROC_ARCANA_Kingmaker_Entered(_Owner, _Creature, _Position, _Side)` — empty in stage 1; the
  Crossing hooks into it in stage 2.
- **Crown** after every change: the ally Reigning with the lowest order and `IsSummon = 0` is King; every other Reigning
  ally is Regent.
- **Death** removes the creature; **combat end** clears the ledger and the statuses.
- Stage 1 assumes **one Kingmaker per Wheel**; the shared Wheel of SP93 comes in stage 6.

### 11–16 · Chassis and progression

| # | Change | Value |
|---|---|---|
| 11 | New skill list *The Courtier* | `Persuasion;Intimidation;Insight;History;Deception;Performance;Arcana;Religion` (SP70) |
| 12 | New spell list *Kingmaker Level 1* | items 05–08 |
| 13 | ClassDescription `bf046347…` | `NameFS` Spinner → Kingmaker; `SoundClassType` Warlock → **Sorcerer**; DisplayName "Kingmaker" and Description (texts.md §1) as new handles. `ClassEquipment` stays `EQP_CC_Resonant` until the Owner builds the Kingmaker's gear |
| 14 | ProgressionDescription `2cafa52b…` | `Type` Spinner → Kingmaker; panel line (texts.md §1) as a new handle |
| 15 | Progression `76a78614…` (level 1) | `PassivesAdded` → `Arcana_Passive_TheRota`; `Boosts` → `ProficiencyBonus(SavingThrow,Charisma);ProficiencyBonus(SavingThrow,Wisdom);Proficiency(LightArmor);Proficiency(MediumArmor);Proficiency(SimpleWeapons);Proficiency(Rapiers);Proficiency(HandCrossbows)` (all vanilla in `Progressions.lsx`); `Selectors` → the same ability bonus, `SelectSkills(<11>,4)`, `SelectSkillsExpertise(<11>,2)`, `AddSpells(<12>,,,,AlwaysPrepared)` |
| 16 | Preset `6d9d9bc2…`; DefaultValues Abilities `b12e3a18…`, Skills `a389eb39…` | STR 8 DEX 12 CON 13 INT 15 WIS 8 CHA 15; abilities `Intelligence;Charisma` (unchanged); skills `Persuasion;Intimidation;Insight;History` |

The level-1 row of the placeholder carries the Resonant's level-1 kit today; this replaces it. Levels 3–12 of the table get
their content in their own stages.

### Probes — the Owner plays these after stage 1 (one rule each)

| # | Do | Proves it works |
|---|---|---|
| P1 | Coronation on an ally | It shows **Rising** (+3 m, can't be Prone) |
| P2 | Dethrone on an enemy, then a save success on another | Damage (half on the save) and **Falling** on both |
| P3 | End the turn; at your next turn start | Ally → **Reigning** and **King**; enemy → **Fallen**; the change shows before you act, with you as the source (tooltip) |
| P4 | Crown two allies on different turns | When both Reign, the older one is King, the other Regent |
| P5 | Turn the Spoke on the Falling enemy | It drops to Fallen at once; no slot spent |
| P6 | Be downed with creatures on the Wheel | The Wheel still turns at your turn start (SP90); plan B: Osiris drives the turn from the next creature's `TurnStarted` |
| P7 | Kill a creature on the Wheel; end combat | The dead one leaves the Wheel; at combat end every position status is gone |
| P8 | Spoke of the Wheel on a Fallen enemy vs a normal one | The extra 1d4 shows only on the Falling / Fallen target |
