# Task 5 - Kit changes (prepared, not applied)

Files: `50_kit.patch` (stats + English loca), `55_friends_upcast.patch` (Friends `_2`..`_6`, Faux Amis on `_6`),
`goals/ARCANA_Status_Sigil.txt` (edited copy of the LIVE goal), the "Task 5" region of the prepared
`goals/ARCANA_Deceiver_Doubles.txt` (it already holds Task 4), this note. Nothing under the game folder was touched.
Spec: §4.2, D10, D14, §5 (Tier III). Contracts: `10_doubt.md`, `20_doubles.md`, `30_double_spells.md`.

## What changes for the player

| # | Change | How |
|---|---|---|
| 1 | **Sigil of Malice**: triggering a Sigil also gives the foe 1 Doubt (also when a Double lays or triggers it, and for Mimic: Sigil) | Sigil goal (below); SIGIL description |
| 2 | **Malicious Whispers**: a target marked with her Sigil also gains 1 Doubt | `SpellSuccess` gets `IF(HasStatus('SIGIL',context.Target,context.Source)):ApplyStatus(DOUBT_ADD_TECH,100,0)` before the damage; description |
| 3 | **Veiled Prison** (new, level 3, card level 2): 18 m, WIS save, Incapacitated (Hold Person's paralysis) 10 turns, attacks within 3 m always crit, repeat save at the end of each turn, Disadvantage on every save while it has 2+ Doubt. Concentration, Short Rest | `Target_Arcana_Card_Spell_VeiledPrison` + status `VEILED_PRISON` (Status_INCAPACITATED, `using HOLD_PERSON`) |
| 4 | **Marionette**: Disadvantage on the save with 2+ Doubt; the Advantage when the target is Charmed is gone | `SpellRoll` 3rd arg `false`, 4th arg the Doubt test; new ExtraDescription |
| 5 | **Grand Deception** (new, level 11, card level 5): summons the Doubles she is missing up to her cap, around her; every enemy within 9 m: WIS save or 2 Doubt (Deluded at 3). No Concentration, Long Rest | `Shout_Arcana_Card_Spell_GrandDeception` + `GRAND_DECEPTION_TECH` + Doubles goal region |
| 6 | **Friends**: a level-1 spell paid with a slot (Concentration kept); its level-6 upcast is the old Faux Amis (no Concentration, unnoticed, unchanged on higher difficulties). Friends: Faux Amis as a level-13 spell is gone | `50_kit.patch` (base, `Friends_EX` removed) + `55_friends_upcast.patch` |
| 7 | **Removed**: Mental Prison, Hypnotic Gaze, Hostile Takeover, Terrify, Ready: Instinctive Charm, Ready: Hollow Image (cards, variants, passives, interrupts, reaction spell, their statuses), the NEMESIS leftovers | 39 `@remove` |

## How it works

### Sigil detonation -> Doubt (`goals/ARCANA_Status_Sigil.txt`)
`SIGIL.OnRemoveFunctors` applies `SIGIL_DETONATED_TECH`, but a status applied there has no guaranteed source (contract in
`10_doubt.md`; the Empress goal says the same). So the goal remembers the owner when the mark lands
(`StatusApplied(Foe,"SIGIL",Owner)` -> `DB_ARCANA_SigilDoubtOwner(Foe,Owner)`, replaced on every new mark) and, on
`StatusApplied(Foe,"SIGIL_DETONATED_TECH")`, deletes the row and applies `ApplyStatus(Foe,"DOUBT_ADD_TECH",0.0,1,Owner)`
if the foe is not dead. The existing two rules always put the mark in the Deceiver's name (also for a Double), so the
Doubt is credited to her. Own DB on purpose: `ARCANA_Aspect_Empress.txt` deletes `DB_ARCANA_SigilOwner` on the same event,
and two goals reacting to one event in an unknown order must not share a row. Cleanup: the foe's `Died`, and
`PROC_ARCANA_Aspect_Reset` (Common calls it on `LeftCombat` for every character) for either side. A row left by a mark that
went without detonating is harmless (only a new mark, which replaces the row, can detonate).
`diff` against the live file: the INITSECTION pin (3 lines) and `//REGION Task 5` only; the old rules are untouched.

### Grand Deception
- **Type: Shout** (decision 1). AreaRadius 9, `TargetConditions "Enemy() and Character() and not Dead() and <card mark>"`,
  SpellRoll WIS against `SourceSpellDC()`. Shape proven in vanilla: Radiance of the Dawn (Shout, AreaRadius 9, roll on
  `Enemy()`, a `GROUND:` functor in SpellProperties) and Heroes' Feast (Shout + one `GROUND:Summon` at the caster).
- **Summons = the Doubles' tech path**, the exact Mirror Image functor `GROUND:Summon(8807d230-...,-1,,,,DOUBLE_OF_THE_VEIL_TECH)`
  (cause = her), so `ARCANA_Deceiver_Doubles.txt` registers, caps, forms and kits each Double with no new Osiris.
  **Only the missing ones**: five summons, number *i* guarded by `GROUND:IF(...)` = "N + i <= cap", where N = her
  `VEIL_LAYER_N` (the Doubles goal keeps exactly one of `VEIL_LAYER_1..5` on her = live Doubles; none = 0) and cap = 5 with
  `Arcana_Passive_VeilCap5`, 4 with `_VeilCap4`, else 3 (the same rule as `QRY_ARCANA_Doubles_OverCap`). Each guard is
  `(Cap5 and N<=5-i) or (Cap4 and N<=4-i) or N<=3-i` (terms that can never hold are dropped); "N<=k" is
  `not HasAnyStatus({'VEIL_LAYER_k+1',...,'VEIL_LAYER_5'},{},{},context.Source)` (vanilla signature). Brute-forced:
  4 cap cases x N = 0..5, the number of summons always equals `max(0, cap - N)`. `GROUND:IF(...):Summon(...)` is vanilla
  (Find Familiar, Mage Hand). The guards are read at the cast, before any of these Doubles registers. No Double is retired.
- **2 Doubt**: a failed save applies `GRAND_DECEPTION_TECH` (hidden, duration 0) once. The Doubles goal's Task 5 region:
  `StatusApplied((CHARACTER)_Foe,"GRAND_DECEPTION_TECH",(CHARACTER)_Cause,_)` -> `PROC_ARCANA_Doubt_Add(_Foe,_Cause)` twice.
  That PROC is the Doubt goal's own entry point (its `DOUBT_ADD_TECH` rule calls exactly it), so owner credit, the count,
  Deluded and the Awakening rows behave as for any other source. Two calls in one THEN run one after the other, each
  finishing its DB work first, so the count rises by exactly 2 (0->2, 1->3 = Deluded and reset, 2->3 = Deluded -> 1).
  Two `DOUBT_ADD_TECH` in one functor list were NOT used: one status, one instant, StackType Overwrite - that it raises
  `StatusApplied` twice is unproven. Calling a PROC that another goal defines is ordinary Osiris (vanilla Shared does it
  across goals in every order, e.g. `PROC_AppearOutOfSightTo` called from `_CRIME_CrimeGuards.txt`, defined in `__PROC.txt`).

### Veiled Prison
Card = Mental Prison's frame (range, target rules, Concentration, `OncePerShortRest`, sounds/effects) with
`SpellRoll "not SavingThrow(Ability.Wisdom,SourceSpellDC(),false,HasAnyStatus({'DOUBT_2','DOUBT_3'},{},{},context.Target))"`
(vanilla passes `false` + an expression as 3rd/4th args: `SavingThrow(Ability.Constitution, SourceSpellDC(),false,IsInorganic())`).
Status `VEILED_PRISON`: `StatusType INCAPACITATED` before `using "HOLD_PERSON"` (vanilla `Status_INCAPACITATED.txt`, so it
goes in the mod's `Status_INCAPACITATED.txt`), own name/description/StackId, and only `RemoveConditions` rewritten with the
same Disadvantage test. Everything else is inherited (boosts, `TickType EndTurn` + `RemoveEvents OnTurn` = repeat save at
the end of each turn, `OnApplyFunctors BreakConcentration()` kept). In a status' RemoveConditions `context.Target` is the
carrier (vanilla `AdvantageOnCharmed()` defaults to it there). `DOUBT_3` never lingers but keeps "2 or more" literal.

### Friends (D14)
Base: `Level 1`, `UseCosts ActionPoint:1;SpellSlotsGroup:1:1:1;`, Concentration and vanilla `FRIENDS` kept, ExtraDescription
(handle `h9dd95e32`, used only here) now also states the level-6 rider. **`gen_upcast_variants.pl` never makes variants of
`_Arcana_Util_` spells** (`$WANTS_VARIANTS = _Arcana_(Card_Spell|Card_Ability|Card_Passive|Created)_`), so
`55_friends_upcast.patch` creates `_2`..`_6` itself in the generator's shape (SpellType before `using`, RootSpellID,
PowerLevel, UseCosts). All five are needed: the Arcana slots have one level at a time, so without them Friends could not be
cast from character level 3. `_6` = Faux Amis: `ApplyStatus(FRIENDS_EX,100,-1)` (FRIENDS_EX **stays**), no
`IsConcentration`, `TooltipPermanentWarnings ""`, Description = Faux Amis' own handle `h74b1ce07` (used by nothing else once
Friends_EX goes); the name stays "Friends", as in every vanilla upcast. The generator neither creates nor deletes these, so
55 is independent of it (it dry-runs today); it is still applied in Task 6 right after the generator, as planned.
`Arcana_Passive_UnlockFriends` still has `UnlockSpell(Target_Arcana_Util_Friends)` (unchanged), but **no progression grants
that passive** (only `PassivesRemoved` at level 20): Task 6 must add `Target_Arcana_Util_Friends` to "Deceiver Level 1".

### Removals (`@remove`, both sides)
Cards and variants: Mental Prison (+`_3`..`_6`), Hypnotic Gaze (+`_3`..`_6`), Hostile Takeover (+`_6`), Terrify (+`_5`,`_6`),
`Shout_Arcana_Card_Passive_InstinctiveCharm` (+`_3`..`_6`), `Shout_Arcana_Card_Passive_HollowImage` (+`_6`). Passives
`Arcana_Passive_InstinctiveCharm`, `_HollowImage`, `_Nemesis_Owner`, `_Nemesis_Target`. Interrupts
`Interrupt_Arcana_Reaction_InstinctiveCharm`, `_HollowImage`. Reaction spell `Target_Arcana_Reaction_InstinctiveCharm`.
Statuses `INSTINCTIVE_CHARM_READY`, `_FERVOR`, `_USED_TECH`, `HOLLOW_IMAGE_READY`, `_USED_TECH`, `INTERRUPT_HOLLOW_IMAGE`,
`HOLLOW_IMAGE_INVISIBLE` (referenced by nothing), `NEMESIS`, `NEMESIS_OWNER`. Spell `Target_Arcana_Util_Friends_EX`.
Kept: `MirroredCharm` (Mirrored Self), `FRIENDS_EX` (Friends `_6`), `INSTINCTIVE_CHARM_UNTARGETABLE` (vanilla SharedDev),
the vanilla statuses the removed cards applied (HOLD_PERSON, HYPNOTIC_GAZE(_OWNER), FEARED, DISARM, CONFUSION, PARALYZED).
Stats check on the live tree: after the removals, the only kept stats entry that names a removed-or-deferred id is
`Arcana_Passive_Aspect_Empress_Awakened_III` (Beloved, decision 2). Script: scratchpad `t5_refs.pl` + `t5_owner.pl`.

## Decisions

1. **Grand Deception is `Shout_Arcana_Card_Spell_GrandDeception`, not the plan's `Target_...`**. Both halves are centred on
   her (spec: "around you", "every enemy within 9 m"); vanilla does exactly this with Shouts (above); a `Target_` spell would
   need a point to aim at (Hostile Takeover's 18 m + 6 m circle), which the spec no longer describes. The prefix must match
   the SpellType (`stats_add.pl` maps `Spell_<Type>` from it). **Tasks 6 and 7 must use the Shout id.** If the user wants a
   targeted area instead, it is a rename + `TargetRadius`/`AreaRadius` swap in this one entry.
2. **Beloved goes in Task 9, not here.** `Interrupt_Arcana_Aspect_Beloved` and `ArcanaBeloved` are Tier III's bonus, and
   Task 9 rewrites that same passive (`Arcana_Passive_Aspect_Empress_Awakened_III`) to give *Which One?*. Removing them here
   would leave Tier III as "+3 CHA" with the old description until Task 9, and split one passive's Boosts across two
   patches. Task 9's patch removes the interrupt and edits the Boosts; the `ArcanaBeloved` definition is removed in the same
   apply session (never earlier: the interrupt's `Cost` names it), and `aspect_structure.pl` must stop re-creating it.
3. **Sigil Doubt through Osiris, MW Doubt through stats.** The detonation status comes from an OnRemoveFunctors (no
   reliable source); Malicious Whispers' `SpellSuccess` has the caster as source, so a plain functor is enough there.
4. **Malicious Whispers on a marked target gives 2 Doubt**, by design of the parts: its own +1 and, since it is an Arcane
   spell, its damage triggers the Sigil (+1). Spec lists both sources; flagged for the balance pass.
5. **Grand Deception overflows**: a foe at 2 stacks becomes Deluded and keeps 1 stack. Capping instead would need the second
   raise to look at the first one's result; overflow also counts 2 Awakening steps, as "2 Doubt" says.
6. **Grand Deception fills, never replaces**: at the cap it summons nothing (no Double is retired). It still applies Doubt.
7. **Variants removed now** rather than left to the generator, so the files stay consistent if Task 6 runs later.
8. **New loca handles** for Veiled Prison / Grand Deception (not Mental Prison's / Hostile Takeover's, whose other-language
   texts describe the old cards). Three existing handles get new English text (each used by exactly one entry).
9. Veiled Prison keeps Mental Prison's targets (characters, not Undead) and Hold Person's full paralysis (auto-fail STR/DEX
   saves, Advantage to hit it), which is what Mental Prison did; the spec's "Incapacitated" is that status' type.

## References for later tasks (non-stats; live tree, 2026-10-06)

| Task | File (both sides where there are two) | What | Count |
|---|---|---|---|
| 6 | `Public/$M/Lists/SpellLists.lsx` + `Editor/.../Lists/SpellLists.tbl` | "Deceiver Level 3" `f5216d9b` (lsx:94 / tbl:127): drop MentalPrison, HypnoticGaze, add `Target_Arcana_Card_Spell_VeiledPrison`. "Level 5" `9aac7d55` (99/134): drop `Shout_Arcana_Card_Passive_InstinctiveCharm`. "Level 9" `55ff77d4` (109/148): drop Terrify. "Level 11" `7134712c` (114/155): drop HostileTakeover, HollowImage, add **`Shout_Arcana_Card_Spell_GrandDeception`**. "Level 13" `4657a3f6` (124/169): drop `Target_Arcana_Util_Friends_EX` (list then empty). "Level 1" `507f2c2a`: add `Target_Arcana_Util_Friends` | 14 id occurrences on 10 lines; +4 additions |
| 6 | `Progressions.lsx:420` + `.tbl:560` | Deceiver L5 `ebf883a0` Boosts `ActionResource(ArcanaReactInstinctiveCharm,1,0)`: remove | 2 |
| 6 | `ActionResourceDefinitions.lsx:61,73` + `.tbl:81,99` | resource nodes `ArcanaReactHollowImage` (tbl Name `New_Stat_3`, UUID `66be75e2-...`), `ArcanaReactInstinctiveCharm` (`New_Stat_16`, `509598ba-...`): remove the whole nodes. **Not** `ArcanaBeloved` (decision 2) | 2 nodes x 2 files |
| 6 | `82_Automation/stats/aspect_structure.pl` and its twin `82_Automation/stats/aspect_structure.pl` (identical) | line 55: list `4657a3f6` adds `Target_Arcana_Util_Friends_EX` -> must stop (or remove it); line 72: `@resources` re-creates `ArcanaBeloved` -> drop together with Task 9; line 35 removes the dead `Arcana_Passive_HollowImage_EX` (harmless) | 3 lines x 2 copies |
| 6 | `Goals/ARCANA_CardFamilies.txt` | regenerated by `gen_upcast_variants.pl --apply`: 22 rows go (lines 38-39 HollowImage 2, 50-54 InstinctiveCharm 5, 248-249 HostileTakeover 2, 250-254 HypnoticGaze 5, 267-271 MentalPrison 5, 298-300 Terrify 3); new rows for VeiledPrison (+`_3`..`_6`) and GrandDeception (+`_6`: granted at 11, first slot 6). Friends never appears (Util) | 22 |
| 6 | `25_mirror_image_upcast.patch`, then **`55_friends_upcast.patch`** | apply after the generator (55 needs 50 first) | - |
| 6/10 | `Mods/$M/Scripts/thoth/helpers/IsArcanaCantrip.khn:5` | `SpellId('Target_Arcana_Util_Friends')`: Friends is no longer a cantrip. Only damage bonuses read the helper and Friends deals none, so harmless; remove for accuracy (the variants would not match anyway) | 1 |
| 7 | `ScriptExtender/Lua/Server/Cards/CardDB.lua` | lines 70 (InstinctiveCharm), 71 (HollowImage), 74 (MentalPrison Unique), 146-149 and 150-153 (`D.reactions` HollowImage / InstinctiveCharm), comment 67-68 ("the Deceiver's two"). Add `Target_Arcana_Card_Spell_VeiledPrison` and `Shout_Arcana_Card_Spell_GrandDeception` with `keywords = { Unique = true }` (Marionette stays Unique). Hypnotic Gaze, Terrify, Hostile Takeover have no entry | 9 lines |
| 7 | `Lua/Tests/DestinationTest.lua:69` | MentalPrison in "Cards with a cooldown of their own are Unique" -> VeiledPrison, GrandDeception | 1 |
| 7 | `Lua/Tests/ReactionsTest.lua:10` (+77-85) | `HOLLOW` and `world.res.ArcanaReactHollowImage`: move the test to Gale Deflection (the one reaction card left, perRound 3) | 5 lines |
| 8 | `Goals/ARCANA_Spell_FacelessCopy_EX.txt:50,52` | `StatusRemoved(..., "NEMESIS_OWNER", ...)`: the whole goal is deleted in Task 8 | 2 |
| 9 | stats (60_awakening.patch) | `Interrupt_Arcana_Aspect_Beloved` (Interrupt.txt:87 + .stats); `Arcana_Passive_Aspect_Empress_Awakened_III` Boosts `UnlockInterrupt(...Beloved);ActionResource(ArcanaBeloved,1,0)` | 2 entries |
| 9 | `ActionResourceDefinitions.lsx:85` + `.tbl:115,117`; `aspect_structure.pl:72` | `ArcanaBeloved` | 3 + 1 |
| 9 | design note | The Veil Lifts detonates every Sigil: through this Sigil goal each detonation already adds 1 Doubt. Decide whether that is wanted on top of "survivors with any Doubt become Deluded" | - |
| 10 | `Localization/English/english.xml` | handles orphaned by the removals (scratchpad `t5_loca_orphans.pl`): lines 137-140, 143-144, 197-198, 202-207, 210, 711, 713-714, 716-717, 726-727, 729, 738, 789-790, 861-864, 945-946; Beloved's 939-940 after Task 9; already-orphan 710 (Nemesis) and 734 (names Friends_EX). The status `FRIENDS_EX` keeps its name "Friends: Faux Amis" (`hef9df044`) | 32 handles |
| 10 | `76.05_Published/Patch_Notes_History.md` (only once applied), `05.02_Subclasses/Deceiver.md` | new/removed cards, Friends | - |

**Keep Lua in step:** CardDB names the removed cards and statuses. If Task 7 waits for session #3, the PC edition runs one
session with CardDB entries for cards that no longer exist; moving the CardDB removals into session #2 avoids it.

## Apply steps (session #2, `[fechado]`, after the backup in `Data\Backup\deceiver_veil_<date>\`)

1. Stats: `perl tools/stats_add.pl deceiver/40_distortion.patch deceiver/50_kit.patch` (dry run first: 50 adds 12 loca
   lines - 3 `~` bumps h358611e4;3, h28e6ebc5;11, h9dd95e32;4 and 9 `+` -, 5 `@set`, 39 `remove`, 4 `txt +`; no `AVISO`),
   then `--apply`.
2. Goals: `diff` then copy `goals/ARCANA_Status_Sigil.txt` (vs live: the pin + `//REGION Task 5` only) and
   `goals/ARCANA_Deceiver_Doubles.txt` (vs live: Task 4's four places, the header line "Grand Deception, Task 5", and
   `//REGION Task 5`) to `$GOALS/`. Both are CRLF, no BOM.
3. Task 6 in the same session: structure script (lists/progression/resources above), `gen_upcast_variants.pl --apply`,
   `25_mirror_image_upcast.patch`, **`55_friends_upcast.patch`** (dry run: 5 `txt +` after Target_Arcana_Util_Friends),
   `sort_stats.pl`, `check_cards.pl` (exit 0; marked roots drop by 4: -6 removed, +2 new), `stats_add.pl --selftest`.
   Do not run check_cards between 50 and the structure script expecting the lists to be clean: they still name the
   removed cards until then.
4. Compile in the Story Editor; `Story/log.txt`: 0 errors; no "never checked" on `DB_ARCANA_SigilDoubtOwner`; the call to
   `PROC_ARCANA_Doubt_Add` from the Doubles goal resolves (defined in `ARCANA_Deceiver_Doubt.txt`).
5. Acceptance grep after Tasks 6-8: no reference to any removed id (`t5_ids.txt` + `t5_refs.pl` in the scratchpad).
6. Fresh save; guide rows K1-K6.

## Guide rows (fresh save, Tasks 1-6 applied)

| Row | Do | Expect | Risk |
|---|---|---|---|
| K1 | Sigil of Malice on an enemy, then trigger the mark (an Arcane spell's damage, Ethereal Chains; also a Double's Mirror: Sigil + a Double's Mirror spell; also Mimic: Sigil) | The mark bursts as before and the foe shows "Doubt (1)" (one stack per detonation). A killing detonation adds nothing. Her Awakening count rises once per stack (after Task 9) | source of SIGIL_DETONATED_TECH (handled by the owner DB) |
| K2 | Malicious Whispers on an unmarked enemy (failed save), then on a marked one | Unmarked: no Doubt. Marked: no reactions, and Doubt rises by 2 (its own + the Sigil it triggers) | decision 4 |
| K3 | Veiled Prison on a humanoid with no Doubt; again (next Short Rest) on one with Doubt (2) | Paralysed 10 turns, Concentration; melee within 3 m crits; at the end of each of its turns it rolls WIS again. With Doubt (2) the first save and each repeat show Disadvantage (while Doubt lasts, 3 turns per refresh). Card on cooldown until a Short Rest | 4th-arg expression in SpellRoll / RemoveConditions |
| K4 | Marionette on a Charmed enemy, then on an enemy with Doubt (2) | Charmed: no Advantage any more. Doubt (2): the save shows Disadvantage. The repeat-on-damage save of DOMINATE_PERSON is unchanged | - |
| K5 | Level 11-12 Deceiver. Grand Deception with 0 Doubles, with 2, with the cap reached; enemies at 5 m and 12 m with 0 / 1 / 2 Doubt | Doubles appear around her up to 4 (5 at 12) - none past the cap, none retired - and each forms like a Mirror Image Double ("The Veil (N)" right). Enemies within 9 m that fail: 0 -> Doubt (2); 1 -> Deluded; 2 -> Deluded + Doubt (1). 12 m: untouched. No Concentration; Long Rest cooldown. Also cast it with no enemy in range: Doubles still appear | GROUND summons in a Shout with no target; spacing of up to 5 simultaneous summons |
| K6 | Friends at level 1-2 and at 11+ (slot 6); look for Faux Amis at 13 | Costs an action and a slot, Concentration, vanilla Friends behaviour. With a level-6 slot: no Concentration, the target does not turn hostile/notice, description is Faux Amis'. No Faux Amis spell at level 13. Mental Prison, Hypnotic Gaze, Hostile Takeover, Terrify and the two Ready cards are gone from every list and hotbar | engine lists Util variants |

## Dry runs (no `--apply`)

| Patches | Result |
|---|---|
| `50_kit.patch` | exit 0; 12 loca (3 bumped, 9 new), 5 set, 39 remove, 4 new entries; no warning |
| `40_distortion.patch 50_kit.patch` | exit 0; 78 log lines; no warning, no conflict |
| `50_kit.patch 55_friends_upcast.patch` | exit 0; + 5 entries placed right after `Target_Arcana_Util_Friends` |
| `40 50 55` | exit 0; 83 lines; no warning |

Goal lint (`osi_lint.pl` against `story_header.div`): `ARCANA_Status_Sigil.txt` 10 rules, no unknown function, events
`Died`/`StatusApplied` ok, `DB_ARCANA_SigilDoubtOwner` pinned and read; `PROC_ARCANA_Aspect_Reset` "defined but never
called here" = the Common extension pattern. `ARCANA_Deceiver_Doubles.txt` 52 rules (51 before), no unknown function, all
DBs pinned and read; "PROC called but not defined here: `PROC_ARCANA_Doubt_Add`" = the deliberate cross-goal call.

## Not verified (no compile, no game)

- Osiris not compiled: the cross-goal `PROC_ARCANA_Doubt_Add` call (normal Osiris, vanilla does it), the new region and DB.
- `GROUND:IF(...):Summon(...)` with `HasAnyStatus(...,context.Source)` / `HasPassive(...,context.Source)` in a **Shout**;
  that up to 5 summons at her spot spread out; that the GROUND part runs when no enemy is in the area.
- That `VEIL_LAYER_N` matches the live count at the cast (it lags only while Osiris has not processed a registration).
- `SavingThrow(...,false,HasAnyStatus({...},{},{},context.Target))` as SpellRoll and as a status RemoveConditions;
  `context.Target` = the carrier there.
- `VEILED_PRISON` inherits everything from HOLD_PERSON (sound/animation/flags); its own StackId (HOLD_PERSON has none).
- Doubt overflow order (DOUBT_3 then DOUBT_1 queued in one frame): that DELUDED still lands.
- `SIGIL_DETONATED_TECH` on a killing detonation and `IsDead` at that moment.
- Functor order in Malicious Whispers' SpellSuccess: the Sigil test runs before its own damage removes the mark.
- That the engine offers `Target_Arcana_Util_Friends_2.._6` as upcasts (same RootSpellID mechanism as the cards; first
  `_Arcana_Util_` spell to use it) and that `_6` without `IsConcentration`/warning behaves as the old Faux Amis.
- `LSTag Type="Passive"` in Grand Deception's description; `ExtraDescriptionParams "Distance(9)"` rendering `[1]`.
