# Task 2 - Doubles: summon, form, cap, AC layers (prepared, not applied)

Files (all under `Design/work/deceiver/`; nothing under the game folder was touched):

| File | What |
|---|---|
| `20_doubles.patch` | Stats + English loca (`stats_add.pl` format) |
| `goals/ARCANA_Deceiver_Doubles.txt` | Osiris draft, CRLF. Replaces `ARCANA_Spell_MirrorImage.txt` |
| `rulebook/DoubleOfTheVeil.lsx-fragment.xml` | The rule node for `Public/$M/Shapeshift/Rulebook.lsx` (game) |
| `25_mirror_image_upcast.patch` | Upcast: SpellProperties of variants `_3`/`_4` (2 Doubles) and `_5`/`_6` (3 Doubles); applied in Task 6 after the variant generator |
| `rulebook/DoubleOfTheVeil.tbl-fragment.xml` | The same rule for `Editor/Mods/$M/Shapeshift/Rulebook.tbl` (Toolkit), CRLF, so a Toolkit save cannot drop it |
| this note | |

## What each piece does

### Stats (`20_doubles.patch`)

| Piece | Where | Role |
|---|---|---|
| `Target_Arcana_Card_Spell_MirrorImage` | Spell_Target (`@set`) | Level 4 -> **1**, `UseCosts ActionPoint:1;SpellSlotsGroup:1:1:1;`, `SpellProperties GROUND:Summon(8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8,-1,,,,DOUBLE_OF_THE_VEIL_TECH);` (one Double, permanent lifetime, **empty stack id** so several coexist - vanilla Dancing Lights shape; the old `CreateCloneStack1` would let only one live). `TargetRadius` 18 -> **9** (user decision, spec 3.1; vanilla Invoke Duplicity is 9 too). Icon, sounds, effects, the card mark in `TargetConditions` are unchanged. New description on its existing handle (v12). |
| `MIRROR_IMAGE_TECHNICAL`, `MIRROR_IMAGE_CLONE_SCALING` | `@remove` | Only the old card and the old goal used them (inventory B11). |
| `Shout_Deceiver_Clone_Dismiss` | `@set UseCosts ""` | The Double has no bonus action, so Dismiss becomes free (the vanilla parent costs a bonus action). |
| `Clone_1` | Character (`@set` / `@unset`) | The Double's fixed stats. `Vitality 1` (1 HP; vanilla `MinorIllusion` is Vitality 1), `Armor 11` (+ DEX 12 = **AC 12**; vanilla Raven: Armor 10 + DEX 14 = AC 12), `ActionResources ActionPoint:1;Movement:9` (no bonus action, no reaction), `Passives Arcana_Passive_DoubleOfTheVeil;DarknessRules` (no Attack of Opportunity), `BlockRegainHP(Undead;Construct;Living)` (never healed), `DifficultyStatuses` removed (no Easy/Tactician HP statuses; vanilla `MinorIllusion` clears them too). **Clone_1 is not shared**: only the mod's templates 8807d230 (`ARCANA_CHAR_CreateClone_1`) and its unused sibling 4267f207 (`CreateClone_2`, referenced nowhere) name it, so no `Clone_Double` entry was needed and the binary template stays untouched. |
| `h7ce24c2b...` (template name) | `@loca` | "Clone" -> "Double of the Veil" (v40). The handle is used only by template 8807d230 and the loca files. |
| `Arcana_Passive_TheVeil` | Passive (DECEIVER PASSIVES) | Visible on her: Doubles, Shatter, cap 3/4/5, +1 AC per Double, Doubt on a destroyed Double, cleanup. Also what the Doubt statuses test (`HasPassive(...,context.Target)`). |
| `Arcana_Passive_VeilCap4`, `_VeilCap5` | Passive | Hidden, no boosts; Osiris reads them for the cap. Granted at 7 / 12 by Task 6. |
| `Arcana_Passive_TwoTruths`, `Arcana_Passive_Unveil` | Passive | Visible, text only; Osiris reads them for the kit. **Not in the brief** but no task created them and this goal needs their ids. Granted at 5 / 9 by Task 6. |
| `Arcana_Passive_DoubleOfTheVeil` | Passive (on the Double via Clone_1) | `StatusImmunity(SG_Charmed / SG_Mad / SG_Possessed / SG_Dominated / SG_Fleeing)` (spec D6; group names from inventory E4; `SG_Charmed` already holds DOMINATE_PERSON and FRIENDS). No weapon-attack boost exists (every Boosts function in the vanilla stats was listed): Osiris removes the attack spells instead. |
| `DOUBLE_OF_THE_VEIL_TECH` | Status_INVISIBLE | The Summon status Osiris reacts to. Same shape as the old `MIRROR_IMAGE_TECHNICAL` (`using INVOKE_DUPLICITY_TECHNICAL`, Boosts/RemoveEvents/RemoveConditions/OnRemoveFunctors/StatusGroups/StatusEffect blanked, parent's `OnApplyFunctors` untouched - it has none). INVISIBLE type keeps the raw template hidden while it forms. |
| `DOUBLE_OF_THE_VEIL` | Status_BOOST | The Invoke Duplicity shimmer alone: `StatusEffect d798b3cf-15ab-4911-9884-82799e6fd3ef` (the vanilla `INVOKE_DUPLICITY_AURA` effect, inventory E1/F2) without the aura's ally buff. Hidden. Osiris applies it permanently after the form. |
| `VEIL_LAYER_1..5` | Status_BOOST | On her: `AC(N)`, StackId `VEIL_LAYER`, Overwrite, equal priority, visible on the portrait as "The Veil (N)" (no overhead, no log). |

Dry run (`timeout 300 perl tools/stats_add.pl deceiver/20_doubles.patch`): exit 0, no warning; (re-run after fix round 1: same, plus `set ...MirrorImage.TargetRadius`) 16 new loca strings + 2
existing handles bumped (h805db51f -> v12, h7ce24c2b -> v40); 4 `@set` on the card, 1 on Dismiss, 5 `@set` + 1 `@unset`
on Clone_1, 2 `@remove`; 6 passives, 1 INVISIBLE status, 6 BOOST statuses added under the Deceiver dividers.
Together with `10_doubt.patch` (`perl tools/stats_add.pl deceiver/10_doubt.patch deceiver/20_doubles.patch`): exit 0.

### Shapeshift rule `DoubleOfTheVeil` (`21aacde3-d14d-7a32-7dbb-5418cc3bdf9d`)

Modelled on `MirrorImage` (look: `ApplyVisual`, `ChangeBodyType`, `ChangeRace`, `ChangeIcon`, `DisableEquipmentSlots`,
`MuteEquipmentSound`, `BlockLevelUp`, `RetainDisplayName` all true; `ApplySpellsFromTemplate` false;
`TagsAdd` SUMMON `26c78224-...`) but **appearance only**: every inheritance type is `KeepOriginal` (DefaultBoosts,
Passives, ProficiencyGroups, SpellCastingAbility, Resistances, DifficultyStatuses, PersonalStatusImmunities, Flags -
the value set the mod's `FacelessCopy` rule already uses), `ApplyTagsFromTemplate` false and `RemoveOldTags` false
(her race/class tags are not copied), `UnarmedAbilityFromTemplate` false. No `Hp` / ability / stat nodes.
**Spells (fix round 1, spec 3.1 "Common actions"):** `RemovePrevSpells` **true** and `SpellsAdd` `Shout_Dash;Shout_Disengage`
(vanilla ids, the `CommonPlayerActions` spellset names; pattern = vanilla `EPI_WYLL` rule, GustavDev Rulebook.lsx
1975-1978, which wipes the book and re-adds the common actions it wants). The Transform therefore wipes the template's
spellbook - its old Mirror spells, Malicious Whispers, `Shout_Dismiss_Self` and the rest of `CommonPlayerActions`
(Jump, Dip, Hide, Shove, Throw, Improvised Weapon, Help) - and leaves only Dash and Disengage. The Osiris kit is added
200 ms after the Transform, so the wipe never touches it. In the .tbl the field is `SpellsAdd`
(`StringTableFieldDefinition`, as in the vanilla Editor Rulebook.tbl files). UUID is
deterministic (md5 of `arcana-aspect:Shapeshift_DoubleOfTheVeil`, the `stats_add.pl` scheme). Both fragments were
parsed merged into the current files (in memory): 3 rules each, XML well-formed.

### The goal (`goals/ARCANA_Deceiver_Doubles.txt`)

1. `StatusApplied(Double,"DOUBLE_OF_THE_VEIL_TECH",Owner)` -> rows in `DB_ARCANA_MirrorImageOf` (shared contract) and
   `DB_ARCANA_DoubleSetup`; `PROC_ARCANA_Doubles_Register` (Order = last + 1 in `DB_ARCANA_DoubleSeq`, row in
   `DB_ARCANA_Double(Double,Owner,Order)`, count +1 -> `VEIL_LAYER_N`); `PROC_ARCANA_Doubles_Enforce`; 300 ms timer.
2. Cap: `QRY_ARCANA_Doubles_OverCap` (three definitions = OR: >5; >4 without VeilCap5; >3 without either). The oldest is the
   row with `NOT QRY_ARCANA_Doubles_HasOlder`; it is picked into `DB_ARCANA_DoubleOldest` first and retired in a second
   definition (no deletion inside the iteration that finds it). One per registration is enough because every
   registration enforces at once.
3. Retire (cap, cleanup, and since Task 3 fix round 1 also Shatter): `DB_ARCANA_DoubleNoBlame`, unregister, `Die(Double, DEATHTYPE.Lifetime, Double, 0, 0, 0.0)` -
   no shatter, no Doubt. Shatter reaches it from the goal region "Task 3, fix round 1": `CastSpell(Double, Shout_Deceiver_Double_Shatter)` starts an
   800 ms `RealtimeObjectTimerLaunch` (`ARCANA_Double_Shatter`), and on finish `PROC_ARCANA_Doubles_Retire` runs if the Double is registered and alive.
4. 300 ms: `Transform(Double, Owner, (SHAPESHIFTRULE)DoubleOfTheVeil_21aacde3-...)`; 200 ms later
   `CopyCharacterEquipment`, `SetHitpoints(Double,1)` (R1 safety net), the kit, `DOUBLE_OF_THE_VEIL` (shimmer),
   `RemoveStatus(DOUBLE_OF_THE_VEIL_TECH)`. Same delays and order as the old clone (empirical, OSIRIS.md section 10).
5. Kit (after the Transform): the template's own spells are already gone (rule `RemovePrevSpells`); it removes the
   five attack spells (`Target_MainHandAttack`, `Projectile_MainHandAttack`, `Target_OffhandAttack`,
   `Projectile_OffhandAttack`, `Target_UnarmedAttack`) - kept on purpose: no vanilla rule lists attack spells in
   `SpellsAdd`, yet `EPI_WYLL` (`RemovePrevSpells` true, a playable form) must still attack, so the engine most likely
   grants them outside the spellbook the rule wipes (inference; V3 tells); adds `Shout_Deceiver_Clone_Dismiss` and
   `Shout_Deceiver_Double_Shatter`; with `Arcana_Passive_TwoTruths` also `Projectile_Deceiver_Double_MirrorSigil` and
   `Target_Deceiver_Double_MirrorChains`; with `Arcana_Passive_Unveil` also `Target_Deceiver_Double_Unveil` (ids from
   spec section 4.3; the spells themselves come in Task 3).
6. Killer (R4): `AttackedBy` with damage > 0 on a registered Double records the attacker; `KilledBy` overwrites it.
   `CastSpell(Double, Shatter)` and Dismiss mark `NoBlame`.
7. `Died(Double)` / Dismiss -> `PROC_ARCANA_Doubles_Gone` (idempotent: unregister if still live, drop the setup row,
   `DB_ARCANA_DoubleGone`, relaunch the global 1 s timer `ARCANA_Doubles_Purge`).
8. Purge (global timer, so it also runs when she is the one who died): for each gone Double, if not `NoBlame` and its
   killer is an enemy of hers and alive -> `ApplyStatus(Killer,"DOUBT_ADD_TECH",0.0,1,Owner)` (Task 1 contract: cause =
   the Deceiver). Then its rows go, `DB_ARCANA_MirrorImageOf` last - so a Shatter's own Doubt, which lands as its
   caster dies, still resolves the owner (Task 1 requirement).
9. Cleanup: `LeftCombat(Owner)`, `LongRestFinished()`, `Died(Owner)` -> `PROC_ARCANA_Doubles_ClearAll` (retire every
   live Double, drop the sequence row, remove `VEIL_LAYER_*`). The trigger tests `DB_ARCANA_DoubleSeq(Owner,_)`
   ("has summoned since the last cleanup"), which also cleans that row.

INITSECTION pins all nine DBs (declare-then-NOT, the mod's null-GUID style). The structural lint
(`scratchpad/.../osi_lint.pl`: rule shape, `AND`/`;` placement, every call/query/event looked up in
`story_header.div`, every written DB pinned and read) reports: 47 rules, 0 unknown functions, every DB pinned and read.
`DB_NOOP` is vanilla's (the mod already uses it in `ARCANA_Passive_MirroredSpell.txt`).

### Osiris signatures used (from `story_header.div`, re-read 2026-10-06)

```
event StatusApplied((GUIDSTRING)_Object, (STRING)_Status, (GUIDSTRING)_Causee, (INTEGER)_StoryActionID)
event ObjectTimerFinished((GUIDSTRING)_Object, (STRING)_Timer)
event TimerFinished((STRING)_Timer)
event AttackedBy((GUIDSTRING)_Defender, (GUIDSTRING)_AttackerOwner, (GUIDSTRING)_Attacker, (STRING)_DamageType, (INTEGER)_DamageAmount, (STRING)_DamageCause, (INTEGER)_StoryActionID)
event KilledBy((CHARACTER)_Defender, (GUIDSTRING)_AttackOwner, (GUIDSTRING)_Attacker, (INTEGER)_StoryActionID)
event Died((CHARACTER)_Character)
event CastSpell((GUIDSTRING)_Caster, (STRING)_Spell, (STRING)_SpellType, (STRING)_SpellElement, (INTEGER)_StoryActionID)
event LeftCombat((GUIDSTRING)_Object, (GUIDSTRING)_CombatGuid)
event LongRestFinished()
call  RealtimeObjectTimerLaunch((GUIDSTRING)_Entity, (STRING)_Timer, (INTEGER)_Time)
call  TimerLaunch((STRING)_Timer, (INTEGER)_Time)
call  TimerCancel((STRING)_Timer)
call  Transform((GUIDSTRING)_Object, (GUIDSTRING)_TargetTemplate, (SHAPESHIFTRULE)_ShapeshiftRules)
call  CopyCharacterEquipment((CHARACTER)_Target, (CHARACTER)_Source)
call  SetHitpoints((GUIDSTRING)_Entity, (INTEGER)_HP, (STRING)_HealTypes)      -- called with 2 args, as vanilla does
call  AddSpell((CHARACTER)_Character, (STRING)_Spell, (INTEGER)_ShowNotification, (INTEGER)_AddContainerSpells)
call  RemoveSpell((CHARACTER)_Character, (STRING)_Spell, (INTEGER)_RemoveContainerSpells)
call  ApplyStatus((GUIDSTRING)_Object, (STRING)_Status, (REAL)_Duration, (INTEGER)_Force, (GUIDSTRING)_Source)
call  RemoveStatus((GUIDSTRING)_Target, (STRING)_Status, (GUIDSTRING)_Cause)
call  Die((GUIDSTRING)_Target, (DEATHTYPE)_DeathType, (GUIDSTRING)_Source, (INTEGER)_GenerateTreasure, (INTEGER)_Immediate, (REAL)_ImpactForce)
query IntegerSum([in](INTEGER)_A, [in](INTEGER)_B, [out](INTEGER)_Sum)
query HasPassive([in](GUIDSTRING)_Entity, [in](STRING)_PassiveID, [out](INTEGER)_BoolHasPassive)
query IsDead([in](CHARACTER)_Character, [out](INTEGER)_Bool)
query IsCharacter([in](GUIDSTRING)_Object, [out](INTEGER)_Bool)
query IsEnemy([in](CHARACTER)_Character, [in](CHARACTER)_OtherCharacter, [out](INTEGER)_Bool)
enum  DEATHTYPE ... Lifetime = 9
```

## Apply steps (a `[fechado]` session, after the backup in `Data\Backup\deceiver_veil_<date>\`)

Apply after Task 1 (`10_doubt.patch` + its goal) and together with Task 3 (the Doubles' spells), as the plan's session #1 says.

1. Stats: `perl tools/stats_add.pl deceiver/20_doubles.patch` (read the dry run), then `--apply`.
2. Rulebook (game): in `$G/Public/$M/Shapeshift/Rulebook.lsx` (LF), paste `rulebook/DoubleOfTheVeil.lsx-fragment.xml`
   as the **third** `<node id="Rule">`, right after the `FacelessCopy` rule's closing `</node>` and before the
   `</children>` that closes `root` (i.e. before `            </children>\n        </node>\n    </region>`).
3. Rulebook (Toolkit): in `$G/Editor/Mods/$M/Shapeshift/Rulebook.tbl` (CRLF), paste `rulebook/DoubleOfTheVeil.tbl-fragment.xml`
   as the third `<stat_object>`, right before `  </stat_objects>`.
4. Goal: copy `goals/ARCANA_Deceiver_Doubles.txt` to `$GOALS/`, and **delete** `$GOALS/ARCANA_Spell_MirrorImage.txt`
   (nothing else reads `DB_MirrorImage` / `DB_OriginalPlayerLevel`; `DB_ARCANA_MirrorImageOf` is now pinned here).
5. `perl tools/sort_stats.pl --apply`, `perl tools/check_cards.pl`, `perl tools/stats_add.pl --selftest`. Mirror Image's
   variants `_5`/`_6` still exist until Task 6 reruns `gen_upcast_variants.pl` (they inherit the new SpellProperties and
   summon one Double at slot 5/6 meanwhile).
6. The user compiles in the Toolkit; read `Story\log.txt`: 0 errors, no `DB_ARCANA_*` "never checked" warning.
7. In game, on a fresh save: guide rows V1-V8 below.

### Upcast variants: `25_mirror_image_upcast.patch` (apply in Task 6)

Task 6 sets Mirror Image to level 1 in the lists and reruns `gen_upcast_variants.pl --apply`, which then emits
`Target_Arcana_Card_Spell_MirrorImage_2` ... `_6` (`using` the root, `RootSpellID`, `PowerLevel N`,
`UseCosts ActionPoint:1;SpellSlotsGroup:1:1:N;`). **Right after that run**, apply `25_mirror_image_upcast.patch`:

- `_3`, `_4`: `SpellProperties` = the root's `GROUND:Summon(8807d230-...,-1,,,,DOUBLE_OF_THE_VEIL_TECH);` twice (2 Doubles);
- `_5`, `_6`: the same Summon three times (3 Doubles);
- `_2`: no line - it inherits the root's single Summon through `using`.

Repeating `Summon` in one `SpellProperties` is the vanilla way to summon several (`Projectile_SpiderlingSpawning`).
Each Summon applies `DOUBLE_OF_THE_VEIL_TECH`, so each Double fires its own `StatusApplied` and registers / checks the
cap on its own. `SpellProperties` is not one of the generator's own fields (`%OWN_TXT` / `%OWN_STATS`), so later
reruns keep it (`%keepTxt` / `%keepStats`).

**It cannot be dry-run now:** `_3` / `_4` do not exist until the generator runs; today `stats_add.pl` stops with
`@set: Target_Arcana_Card_Spell_MirrorImage_3 nao existe` (exit 255). Syntax checked instead: every line matches
`stats_add.pl`'s `^\@set (\S+) (\S+) ?(.*)$` (entry, field `SpellProperties`, a value with no spaces), and the `_5` /
`_6` lines alone, dry-run against today's `_5` / `_6` entries, give `set ..._5.SpellProperties`, `set
..._6.SpellProperties`, exit 0. The root description's upcast sentence is a text task (Task 10).

## Guide rows (in-game, fresh save; Task 3 spells applied for V3/V6)

| Row | Do | Expect | Risk |
|---|---|---|---|
| V1 | Cast Mirror Image (level-1 slot) | One Double appears, looks like her (body, face, outfit), shimmers like Invoke Duplicity, is named "Double of the Veil", gets its **own turn** and is player-controlled | R2 |
| V2 | Inspect the Double (her in her best armour and an AC ring) | **1 HP max, AC 12**, no bonus action, no reaction; passives: Double of the Veil (+ DarknessRules) only, none of hers; level 1 | R1 |
| V3 | Its hotbar and spellbook, at level 1 / with Two Truths / with Unveil (Task 6 passives, or add them by hand) | **Only** Dash, Disengage, Dismiss (free) and the Veil kit: Shatter; then + Mirror: Sigil of Malice, Mirror: Ethereal Chains; then + Unveil. **None** of: Jump, Dip, Hide, Shove, Throw, Improvised Weapon, Help, main-hand / off-hand / unarmed attacks, weapon actions, Malicious Whispers, the old Mirror spells. If attacks are missing even without the Osiris `RemoveSpell` lines, those lines can go | R1 |
| V4 | Summon 1, 2, 3 Doubles; let one die | Her portrait shows "The Veil (N)" and her AC rises by N; it goes down with each loss; at 0 the status is gone | - |
| V5 | Summon a 4th at levels 1-6 (a 5th with VeilCap4, a 6th with VeilCap5) | The oldest one vanishes (no Shatter, nobody gains Doubt); count and AC stay at the cap | - |
| V6 | Let an enemy kill a Double; then kill one with an ally's area spell; then Dismiss one | ~1 s after the enemy's kill it shows Doubt (1) (her Awakening step counts after Task 9); nothing for the ally's kill or the Dismiss | R4 |
| V7 | End combat with Doubles alive; repeat with a Long Rest out of combat; repeat with her dying | All her Doubles vanish each time and "The Veil (N)" is removed | - |
| V8 | Charm (Friends / Command: Flee / Fear / Crown of Madness / Dominate Person) a Double | Immune each time | - |

## Risks

| # | Status |
|---|---|
| **R1** (Transform copies her stats) | Addressed three ways: the new rule inherits nothing (`KeepOriginal` everywhere, no `SetLevel`), the stats live in `Clone_1`, and `SetHitpoints(Double,1)` after the form. **Open:** her copied equipment. With `DisableEquipmentSlots` true (as the working MirrorImage rule) the gear should stay inert, but if V2 shows her armour/ring AC or V3 shows weapon actions, delete the `CopyCharacterEquipment` line (the Double then wears only the template's outfit) - boosts cannot cap AC, only add. |
| **R2** (AI-controlled summons) | Same template and same summon path as today's player-controlled clone, so it should behave the same; untested with several Doubles at once (V1). |
| **R4** (who destroyed it) | Implemented as `AttackedBy` (damage > 0) recorded + `KilledBy` overwriting, decided 1 s after the death, enemy of hers and alive. The spec's "nearest enemy" fallback is **not** implemented (only needed if V6 fails). |

## Not verified (no compile, no game)

- **Osiris was not compiled** (no Story Editor here): read against `story_header.div` and the lint only.
- `SetHitpoints` with 2 arguments (vanilla goals do it about a dozen times, once with 3; the header declares 3) and
  `Die` with all 6 (vanilla uses 5 and 6).
- That `KeepOriginal` keeps the Double's own boosts/passives/stats in a Transform **of a summon into a character** (only
  `FacelessCopy` uses it, for the player). V2.
- That `DisableEquipmentSlots` makes copied gear inert (AC, rings, weapon actions). V2/V3.
- `RemovePrevSpells` wiping the `CommonPlayerActions` spellset (inferred from `EPI_WYLL` re-adding those spells in its
  `SpellsAdd`) and `SpellsAdd` giving Dash / Disengage to a Transformed summon. V3.
- `RemoveSpell` on the engine-given attack spells (no vanilla precedent; they may come back on an equipment change).
  Fallback, also unverified: add `<node id="ActionsCapabilities"><children><node id="ActionCapabilities"><attribute
  id="Name" type="LSString" value="Attack"/></node></children></node>` to the rule's `<children>`. Vanilla's
  `InvokeDuplicity` rule lists `CastSpell`, `Attack`, ... and the LeBlanc mod's mimic rule (with `SpellsAdd`) lists
  only Disarming/Lockpicking/Pickpocketing, which reads as a **block** list - but if it is an allow list it would
  block everything else, so test it alone first.
- AC = Armor + Dex modifier for a character entry (inferred from vanilla Raven/Cat, not measured in game).
- `Summon` with an empty stack id letting several Doubles coexist; any engine limit on summons per caster.
- The order of `AttackedBy` / `KilledBy` / `Died` for a summon, and whether `KilledBy` fires for one (the 1 s purge makes
  the order irrelevant if all three fire within it).
- `DOUBLE_OF_THE_VEIL` (a hidden BOOST) playing the shimmer effect; `VEIL_LAYER` going **down** (3 -> 2) by Overwrite with
  equal priority (Task 1 relies on the same; fallback: `RemoveStatus` the old layer first).
- `LeftCombat` firing for her at combat end (and maybe when she is removed from a fight early - Doubles go then too);
  Doubles at camp before `LongRestFinished`.
- The template's name handle now at v40 while the binary template stores the handle (only the handle matters for lookup, as
  far as known).
- `ApplyTagsFromTemplate false`: no effect expected on animations (body type and race come from `ChangeBodyType` /
  `ChangeRace`).
- Copied gear cannot be taken from the Double (same as today's clone; not re-checked).
- Until Task 3 applies, `AddSpell` of the Double spells silently adds nothing (unknown spell ids).
- Old clones in an existing save (rows only in `DB_ARCANA_MirrorImageOf`) are purged on their death; they are not cleared
  at combat end. Stale `DB_MirrorImage` / `DB_OriginalPlayerLevel` rows stay in such saves (goal deleted). Use a fresh save.
- If her cap drops (respec below 7/12), each new summon retires only one Double.
- `25_mirror_image_upcast.patch` against the regenerated variants (only syntax and the `_5`/`_6` lines checked today).
