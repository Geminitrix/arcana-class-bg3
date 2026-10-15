---
id: SPEC_ARC-0008
ticket: ARC-0008
status: draft
implementation: owner
author: Mod Engineer
updated: 2026-10-15
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
| **2** | 3 | *The Crossing* (pairs within 9 m, once per enemy per round), *Atropos' Cut*, Awakening *10 · Wheel of Fortune* (count, lone enemy ×2, Tier I *Tyche*), *Rota Fortunae* | **Written below** (2026-10-14); probes P9–P16 |
| **3** | 5 | *Peripeteia*, *Convene the Court* (container) + King's Hand, Lord Commander, Master of Healing | **Written below** (2026-10-15); Claude implements; probes P17–P24 at the end |
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

---

## Stage 2 — the Crossing (level 3)

Written 2026-10-14 at the Owner's request, before stage 1's probes were played: if a probe of P1–P8 fails, its fix goes
into the stage-2 goal before the Owner types it. Typing view: **`TOOLKIT_ARC-0008_stage2.md`**.

### Item index — enter top to bottom

| # | Kind | Entry | Where | Needs |
|---|---|---|---|---|
| 01 | LevelMap | `Kingmaker_Crossing` (1d4 / 1d6 at 5 / 1d8 at 9) | UUID Object Editor → Levelmaps / LevelMapValues | — |
| 02 | Status BOOST | `KINGMAKER_CROSSING_TECH` (deals the Crossing) | Stats → StatusData / Status_BOOST | 01 |
| 03 | Status BOOST | `KINGMAKER_CUT_TECH`, `KINGMAKER_TURN_TECH` | Stats → StatusData / Status_BOOST | — |
| 04 | Status BOOST | `KINGMAKER_REIGNING_LINGER` | Stats → StatusData / Status_BOOST | — |
| 05 | Status BOOST | `ASPECT_AWAKENED_WHEEL`, `ASPECT_AWAKENED_WHEEL_I` | Stats → StatusData / Status_BOOST | 09 |
| 06 | Passive | `Arcana_Passive_TheCrossing` | Stats → Passive | 01 |
| 07 | Passive | `Arcana_Passive_Aspect_WheelOfFortune_Awakening`, `…_I` (Tyche) | Stats → Passive | — |
| 08 | Spell Target | `Target_Arcana_Card_Spell_AtroposCut` (level-2 card) | Stats → SpellData / Target | 03 |
| 09 | Spell Shout | `Shout_Arcana_Created_Aspect_RotaFortunae` (Aspect card) | Stats → SpellData / Shout | 03 |
| 10 | Osiris goal | `ARCANA_Kingmaker_Wheel` — the whole text replaced | Stories | 02–04 |
| 11 | Osiris goal | `ARCANA_Aspect_Common` — 6 table rows for `WHEEL` | Stories | 05, 07 |
| 12 | Spell list | *Kingmaker Level 3* | UUID Object Editor → Lists / SpellLists | 08 |
| 13 | Progression | table `a688d11f…` level 3 (`504e7b34…`) | UUID Object Editor → Progressions | 06, 07, 12 |
| 14 | Generated | Atropos' Cut variants with damage; Dethrone's variants' damage; Awakening progress | Claude | 08, 11 |

### How each rule is built

| Rule (design) | Build | Anchor |
|---|---|---|
| **Crossing** (§5): an enemy that enters Fallen with a Reigning ally within 9 m takes Force damage, once per enemy per round | Every move and binding calls `PROC_ARCANA_Kingmaker_Fell`, which notes an enemy entering Fallen; every change ends with `PROC_ARCANA_Kingmaker_Settle`, which checks the notes **after all creatures moved** (turn start, Turn the Spoke, Tyche's Dethrone, Rota Fortunae). The once-per-round set `DB_ARCANA_Kingmaker_Crossed` is cleared at the owner's turn start. Damage: Osiris applies `KINGMAKER_CROSSING_TECH` with the Kingmaker as cause; its `OnApplyFunctors DealDamage(Cause.LevelMapValue(Kingmaker_Crossing),Force,Magical)` | `SIGIL` (`Cause.LevelMapValue(Sigil_MarkDamage)`, applied by `ARCANA_Status_Sigil`); `GetDistanceTo` (`story_header.div` :626) used by `ARCANA_Aspect_Temperance`; `ApplyStatus(…, 0.0, 1, …)` in vanilla goals |
| Crossing tooltip by level | `DescriptionParams Distance(9);DealDamage(LevelMapValue(Kingmaker_Crossing),Force)` | Battle Master manoeuvres (`LevelMapValue(SuperiorityDie)`) |
| **Awakening** (§9.1): +1 per Crossing, +2 with a lone enemy; goals 3/5/8 | `PROC_ARCANA_Aspect_Step(_Owner, "WHEEL")` once, twice when `DB_ARCANA_Kingmaker_Enemies(_Owner, 1)`; the count of enemies on the Wheel is rebuilt before each step. The rows of `ARCANA_Aspect_Common` (aspect `WHEEL`, COUNT) make the tiers; `gen_awakening_progress.pl` builds the countdown statuses | ARC-0007; `ARCANA_Aspect_Temperance` (the Resonant) |
| **Tyche** (§9.2): bindings one position ahead | The two bind events read `DB_ARCANA_AspectReached(_Owner, 1)`: Coronation binds at Reigning, Dethrone at Fallen (and may cross at once) | `ARCANA_Aspect_Common` |
| **Rota Fortunae** (§7.11) | Created Shout, level 0, Action, `Cooldown OncePerCombat`, `Requirements Combat`; lands on the Kingmaker (`KINGMAKER_TURN_TECH`), and Osiris turns the whole Wheel as at a turn start (without clearing the round's Crossings: an enemy that crossed this round doesn't cross again). Unlocked by `ASPECT_AWAKENED_WHEEL` | `Shout_Arcana_Created_Aspect_TwoCups`; `Shout_Dash` (self Shout) |
| **Atropos' Cut** (§7.5) | Level-2 card, Action, 18 m, any creature on the Wheel. Damage by position in `SpellProperties` (first), then `KINGMAKER_CUT_TECH`; Osiris removes the creature and its statuses. An ally cut while Reigning gets `KINGMAKER_REIGNING_LINGER` (Reigning's boosts, `TickType EndTurn`, 1 turn): off the Wheel, no crown, no Crossing source | `Target_CloudOfDaggers` (look); `ETHEREAL_CHAINS` (`TickType EndTurn`) |
| **Upcast damage** (Dethrone +1d6, Atropos' Cut +1d8 per slot level) | `gen_upcast_variants.pl` reads `game_ids` + `upcast_die` in `25.01` and adds the dice to every matching term of the variant's damage fields (Owner's choice, 2026-10-14). Fixes Dethrone, whose variants had only the cost | vanilla variants (`Projectile_MagicMissile_2`…) |

Ids follow the Resonant's Awakening (`Arcana_Passive_Aspect_<X>_Awakening` / `_I`, `ASPECT_AWAKENED_<X>` / `_I`, Aspect
card `Shout_Arcana_Created_Aspect_*`); the Aspect key is `WHEEL`. Tiers II–III (Nemesis, Anticipation) come in stages 4
and 6: their rows are in the Common table from now, but their passives aren't granted yet.

**Stage 1 correction:** the hook this SPEC called `PROC_ARCANA_Kingmaker_Entered` wasn't in stage 1's goal; stage 2
replaces the goal and the hook is `PROC_ARCANA_Kingmaker_Fell` + `PROC_ARCANA_Kingmaker_Settle`.

### Probes — the Owner plays these after stage 2 (one rule each)

| # | Do | Proves it works | Plan B |
|---|---|---|---|
| P9 | Level 3: Coronation on an ally, Dethrone on an enemy within 9 m of it; end the turn | At your turn start the ally Reigns and the enemy, Fallen, shows **The Crossing** and takes 1d4 Force from you (combat log) | No damage: `Cause.` not resolved from Osiris → three statuses with fixed dice, chosen by `GetLevel` |
| P10 | Same, with the enemy more than 9 m from the ally | Fallen, no Crossing | — |
| P11 | Two Reigning allies next to one enemy entering Fallen; then Turn the Spoke it round to Fallen again in the same round | One Crossing only, both times | — |
| P12 | Fight with one enemy on the Wheel, then two | The Awakening counts 2 per Crossing with one enemy, 1 with two; 3 Crossings awaken **Tyche** (status, card *Rota Fortunae* in the hotbar) | — |
| P13 | With Tyche: Coronation, then Dethrone next to the Reigning ally | The ally enters Reigning (King at once); the enemy enters Fallen and crosses at once | — |
| P14 | Rota Fortunae | Every creature on the Wheel moves one step; a Falling enemy near a Reigning ally crosses; it can't be cast again this combat | — |
| P15 | Atropos' Cut on a Fallen, a Falling and a Rising enemy (one each) | 3d8 / 2d8 / 1d8 Slashing; the enemy loses its position status and the Wheel ignores it | — |
| P16 | Atropos' Cut on the Reigning King; then cast Dethrone and Atropos' Cut with a higher slot | The ally leaves the Wheel, keeps *Reigning* until the end of its next turn, loses the crown; Dethrone at slot 2 shows 4d6, the Cut at slot 3 shows 4d8 / 3d8 / 2d8 | — |

---

## Stage 3 — Peripeteia and the Court (level 5)

Written 2026-10-15. **Implementation: Claude** (the ticket switched to `implementation: claude`, Owner option 1): no
Toolkit guide; the stage is a set of scripts in `55/_wip/Kingmaker/stage3/` applied in the game with `[fechado] ARC-0008`.
The Owner plays all probes at the end of the subclass (the Owner's choice, 2026-10-15), so each stage is validated by everything
short of play: patch dry-run, scripts on a copy of the mod, goal built from the live one by exact anchors.

### What is written

| # | Kind | Entry | How |
|---|---|---|---|
| 01 | Status BOOST | `KINGMAKER_INVERT_TECH`, `KINGMAKER_HEAL_STEP_TECH`, `KINGMAKER_HAND_CROWN`, `COURT_HOLDER`, `COURT_FULL` (technical) | `30_stage3.patch` (`stats_add.pl`, both sides) |
| 02 | Status BOOST | `COURT_KINGS_HAND`, `COURT_LORD_COMMANDER` (aura), `COURT_MASTER_OF_HEALING`, `KINGMAKER_GUARDED` | same |
| 03 | Passive | `Arcana_Passive_Court_MasterOfHealing` (hidden, given by the office status) | same |
| 04 | Spell Shout | `Shout_Arcana_Card_Spell_Peripeteia` (level-3 card) | same; variants `_4`–`_6` by `gen_upcast_variants.pl` |
| 05 | Spell Target | `Target_Arcana_Util_ConveneTheCourt` (container) + `Target_Arcana_Util_Court_KingsHand` / `_LordCommander` / `_MasterOfHealing` | same |
| 06 | Spell list | *Kingmaker Level 5* = Peripeteia, Convene the Court (UUID `293ae797-c86c-41fd-a0e0-dff628b1ea57`, deterministic) | `31_uuid.pl` (`.lsx` and `.tbl`) |
| 07 | Progression | `856b4cd7…` (level 5): `Selectors AddSpells(<06>,,,,AlwaysPrepared)` | `31_uuid.pl` |
| 08 | Osiris | `ARCANA_Kingmaker_Wheel`: + the Court, Peripeteia, Master of Healing, the Hand's crown (228 lines added, none changed) | `32_goal.pl` builds it from the live goal |

### How each rule is built

| Rule (design) | Build | Anchor |
|---|---|---|
| **Peripeteia** (§7.6): every creature on the Wheel within 18 m to the opposite position, Crossings at once; level-3 card, once per combat | Shout on the Kingmaker (`AreaRadius 18` for the preview, `TargetConditions Self()`), `KINGMAKER_INVERT_TECH`; Osiris collects every ledger row within 18 m (`GetDistanceTo`), then swaps each to `DB_ARCANA_Kingmaker_Opposite` (staged, like the turn), notes enemies entering Fallen, crowns and settles the Crossings. `Cooldown OncePerCombat` on the base card; the variants inherit it | `Shout_SpiritGuardians` (self Shout with a radius; its look); `Shout_Arcana_Card_Spell_Wish` (once-per-combat card with variants) |
| **Convene the Court** (§6.1): out of combat; one office per ally; never the Kingmaker; offices until the next Long Rest; seats = CHA modifier (min 1); each office once per Long Rest | Container `IsLinkedSpellContainer`, `Requirements !Combat`; each option: `Cooldown OncePerRest`, `TargetConditions Ally() and not Self() … not HasStatus('COURT_HOLDER') and not HasStatus('COURT_FULL', context.Source)`, applies its office status with duration −1 (no `IgnoreResting`, so the Long Rest ends it). Osiris registers `DB_ARCANA_Kingmaker_Court(owner, holder, office)`, marks the holder `COURT_HOLDER`, counts the seats and sets `COURT_FULL` on the Kingmaker when they reach `max(1, (Charisma − 10) / 2)` (`GetAbility`). An office that ends (death, Long Rest) leaves the Court; its seat stays taken until `LongRestFinished` | `Shout_Arcana_Util_Faceless` (the mod's container); `story_header.div` `GetAbility` :154, `StatusRemoved` :1170, `LongRestFinished` :1250 |
| **King's Hand** (§6.2): while no ally Reigns, the Hand wears the crown and crits on 19–20 | The crown proc takes `KINGMAKER_KING` and `KINGMAKER_HAND_CROWN` (`ReduceCriticalAttackThreshold(1)`) off the Hand first; when no ally is chosen King, the Hand (alive, in combat) gets both. The crown is also checked at the Kingmaker's turn start when nobody is on the Wheel yet | `KINGMAKER_REIGNING` (the crit boost) |
| **Lord Commander** (§6.2): attack rolls against the King within 3 m have Disadvantage | Office status with `AuraRadius 3`, `AuraStatuses TARGET:IF(HasStatus('KINGMAKER_KING')):ApplyStatus(KINGMAKER_GUARDED,100,1)`; `KINGMAKER_GUARDED` = `Disadvantage(AttackTarget)` | vanilla aura statuses (`AuraStatuses "TARGET:IF(…)"`); `Disadvantage(AttackTarget)` (11 vanilla statuses) |
| **Master of Healing** (§6.2, SP104): healing an ally on the Wheel that is Fallen or Rising moves it one step | The office status gives a hidden passive, `StatsFunctorContext OnHeal`, which applies `KINGMAKER_HEAL_STEP_TECH` to a healed creature that is Fallen or Rising; Osiris checks the healer holds this Kingmaker's office and the creature is an ally on the Wheel, then moves it one step, crowns and settles | `DiscipleOfLife`, `DEN_HellridersPride_Passive` (`OnHeal` functors on the healed creature) |

Assumption to confirm in play: each office is unique (one King's Hand, one Lord Commander…), which the once-per-Long-Rest
cooldown of each option gives.

### Probes — after the whole subclass (one rule each)

| # | Do | Proves it works | Plan B |
|---|---|---|---|
| P17 | Level 5, CHA 15 (+2): Convene the Court twice out of combat, then try a third | Two offices land; the third option can't be cast (`COURT_FULL`); in combat the container can't be cast | `GetAbility` key not `"Charisma"` → read the modifier from a boost-free stat |
| P18 | Appoint the King's Hand; start a fight with nobody on the Wheel | At your turn start the Hand wears **King** and crits on 19–20; when an ally reigns, the crown moves to it | — |
| P19 | Appoint the Lord Commander next to the King | Attacks against the King show Disadvantage while the King is within 3 m of the Commander | — |
| P20 | Master of Healing heals a Fallen ally, then a Falling one | Fallen → Rising at once; the Falling ally doesn't move | `OnHeal` doesn't fire from potions/items → note it |
| P21 | Long Rest | Every office and `COURT_FULL` are gone; the options can be cast again | Statuses survive the rest → Osiris removes them at `LongRestFinished` (already written) |
| P22 | A holder dies | Its office ends; the seat isn't given back until the Long Rest | — |
| P23 | Peripeteia with allies and enemies on the Wheel, some beyond 18 m | Within 18 m: Reigning ↔ Fallen, Rising ↔ Falling; an enemy turned Fallen next to a Reigning ally crosses at once; beyond 18 m nothing moves | — |
| P24 | Cast Peripeteia again in the same fight, with a higher slot | It can't (once per combat, variants included) | Variants don't share the cooldown → a `PERIPETEIA_USED` status like `ARCANE_MASTERY_USED` |
