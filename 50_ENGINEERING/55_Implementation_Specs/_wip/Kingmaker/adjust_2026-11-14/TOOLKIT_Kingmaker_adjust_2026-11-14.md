# TOOLKIT · Kingmaker adjustments (2026-11-14)

Owner request, no ticket (ARC-0008 follow-up). Decisions (Owner, 2026-11-14): King's Hand = crit without the crown ·
Crossing 1d8 / 2d6 / 2d8 · Swift Shears every turn · Swift Shears at level 3.

**2026-11-16 — the Owner asked Claude to apply it** (`[fechado] ARC-0008`), together with the Owner's own Toolkit
work: Atropos' Cut now hits harder the higher the enemy stands (Reigning 3d8 · Rising 2d8 · Falling 1d8 · Fallen
1d4), and the level-4 passive PLACEHOLDER1 — after Atropos' Cut, the next Dethrone costs a bonus action — named
**Severance** (`Arcana_Passive_Severance` / `KINGMAKER_SEVERANCE`). Fixed while renaming: the status went on the
cut enemy (`ApplyStatus` without `SELF`), the Conditions ended in `;`, nothing spent it after the first Dethrone
(now a Story rule), the Dethrone icon glows while it is ready. Applied with, in order:
`stats_add.pl 70_adjust.patch --apply` (stats both sides + texts), `71_files.pl BACKUP --apply` (LevelMaps,
Progressions, the goal). Sections 1–5 below stay as the record of what those two write.

| # | Change | Where |
|---|---|---|
| 1 | The crown stays with the King (off the Wheel too, Atropos' Cut included) until another ally has Reigned **more rounds** | Story |
| 2 | A Court office holder (King's Hand included) is never King nor Regent | Story + texts |
| 3 | The Crossing also fires when an **ally enters Reigning** (Fallen enemies near it cross) | Story + texts |
| 4 | One Crossing **per Reigning ally** (2 Reigning × 2 Fallen = 4 hits), once per pair per round; damage raised | Story + LevelMaps + Stats + texts |
| 5 | Swift Shears (level 3): the first Atropos' Cut of each turn costs no action | Stats + Progression + Story + texts |

Order: 1 LevelMaps → 2 Stats → 3 Progression → 4 Localisation → 5 Story (replace the goal, recompile) → 6 Tests.

## 1 · LevelMaps

| LevelMap | Level 1–4 | Level 5–8 | Level 9–20 |
|---|---|---|---|
| `Kingmaker_Crossing` | `1d8` | `2d6` | `2d8` |
| `Kingmaker_CrossingHubris` | `2d8` | `3d6` | `3d8` |

Notes: today `1d4 / 1d6 / 1d8` and `2d4 / 2d6 / 2d8`. Hubris stays "the Crossing plus one die".

## 2 · Stats Editor

### 01 · NEW · StatusData / Status_BOOST · Crossing slots 2–4

| Field | `KINGMAKER_CROSSING_TECH_2` | `KINGMAKER_CROSSING_TECH_3` | `KINGMAKER_CROSSING_TECH_4` |
|---|---|---|---|
| Name | `KINGMAKER_CROSSING_TECH_2` | `KINGMAKER_CROSSING_TECH_3` | `KINGMAKER_CROSSING_TECH_4` |
| Using | `KINGMAKER_CROSSING_TECH` | `KINGMAKER_CROSSING_TECH` | `KINGMAKER_CROSSING_TECH` |
| StackId | `KINGMAKER_CROSSING_TECH_2` | `KINGMAKER_CROSSING_TECH_3` | `KINGMAKER_CROSSING_TECH_4` |

Notes:
- **From the parent:** DisplayName, Description, Icon, StackType, StatusPropertyFlags, OnApplyFunctors (the damage).
- **Ours:** StackId — each Crossing an enemy takes in a round uses the next status, so two Crossings in the same
  moment are never merged into one hit. Keep the `Using`: these three are copies, not look donors.

### 02 · NEW · StatusData / Status_BOOST · `KINGMAKER_SHEARS_FREE`

| Field | `KINGMAKER_SHEARS_FREE` |
|---|---|
| Name | `KINGMAKER_SHEARS_FREE` |
| DisplayName | `Swift Shears` |
| Description | `Can cast <LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_AtroposCut">Atropos' Cut</LSTag> without using an action. Ends after that cast, or at the end of the turn.` |
| Icon | `Spell_Abjuration_BanishingSmite_Melee` |
| StackId | `KINGMAKER_SHEARS_FREE` |
| StackType | `Overwrite` |
| TickType | `EndTurn` |
| Boosts | `UnlockSpellVariant(SpellId('Target_Arcana_Card_Spell_AtroposCut') or SpellId('Target_Arcana_Card_Spell_AtroposCut_3') or SpellId('Target_Arcana_Card_Spell_AtroposCut_4') or SpellId('Target_Arcana_Card_Spell_AtroposCut_5') or SpellId('Target_Arcana_Card_Spell_AtroposCut_6'),ModifyUseCosts(Replace,ActionPoint,0,0,ActionPoint),ModifyIconGlow(),ModifyTooltipDescription())` |
| RemoveEvents | `OnCombatEnded` |
| StatusPropertyFlags | `ForceOverhead` |

Notes:
- **Ours:** the same recipe as `RESONANT_SURGE_FREE` (Temperance Tier II, already in the game). The five spell ids
  list every upcast variant: `SpellId()` of the root alone would miss `_3` to `_6`. The spell slot is still spent.
  Icon is a suggestion.

### 03 · NEW · PassiveData · `Arcana_Passive_SwiftShears`

| Field | `Arcana_Passive_SwiftShears` |
|---|---|
| Name | `Arcana_Passive_SwiftShears` |
| DisplayName | `Swift Shears` |
| Description | `Once per turn, you can cast <LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_AtroposCut">Atropos' Cut</LSTag> without using an action.` |
| Icon | `Spell_Abjuration_BanishingSmite_Melee` |
| Properties | `Highlighted` |

Notes:
- **Ours:** no Boosts — the Story gives `KINGMAKER_SHEARS_FREE` at each turn start and takes it at the first
  Atropos' Cut. Icon is a suggestion.

### 04 · CHANGED · PassiveData · `Arcana_Passive_Hubris`

| Field | Before | After |
|---|---|---|
| DescriptionParams | `DealDamage(LevelMapValue(Kingmaker_Crossing),Force)` | `DealDamage(LevelMapValue(Kingmaker_CrossingHubris),Force)` |

### 05 · CHANGED · StatusData / Status_BOOST · `KINGMAKER_HUBRIS`

| Field | Before | After |
|---|---|---|
| DescriptionParams | `DealDamage(Cause.LevelMapValue(Kingmaker_Crossing),Force)` | `DealDamage(Cause.LevelMapValue(Kingmaker_CrossingHubris),Force)` |

Notes (04, 05): with the new numbers the extra die is no longer the Crossing's value (2d6 → 3d6 adds 1d6, not
2d6), so the text now shows the whole Hubris Crossing — see the two Hubris texts in section 4.

## 3 · Progression

| Progression | Field | Before | After |
|---|---|---|---|
| `Kingmaker` level 3 | PassivesAdded | `Arcana_Passive_TheCrossing;Arcana_Passive_Aspect_WheelOfFortune_Awakening;Arcana_Passive_Aspect_WheelOfFortune_I` | `Arcana_Passive_TheCrossing;Arcana_Passive_Aspect_WheelOfFortune_Awakening;Arcana_Passive_Aspect_WheelOfFortune_I;Arcana_Passive_SwiftShears` |

## 4 · Localisation (English) — changed texts

| Entry · field | Handle | New text |
|---|---|---|
| `Arcana_Passive_TheRota` · Description | `hc49689c0g291cg629bg2075g0bbfb07af743` | `Creatures you set on Fortune's wheel move one position at the start of your turn - <LSTag Type="Status" Tooltip="KINGMAKER_RISING">Rising</LSTag>, <LSTag Type="Status" Tooltip="KINGMAKER_REIGNING">Reigning</LSTag>, <LSTag Type="Status" Tooltip="KINGMAKER_FALLING">Falling</LSTag>, <LSTag Type="Status" Tooltip="KINGMAKER_FALLEN">Fallen</LSTag>, and round again. They stay on the Wheel until they die, combat ends or you cut their thread.<br><br>The ally that has Reigned the longest wears the crown as the <LSTag Type="Status" Tooltip="KINGMAKER_KING">King</LSTag>, and keeps it - even off the Wheel - until another ally has Reigned longer.` |
| `Arcana_Passive_TheCrossing` · Description | `he8aeaef6ge103gb1eeg33bfg1739036090df` | `When an enemy on the Wheel becomes <LSTag Type="Status" Tooltip="KINGMAKER_FALLEN">Fallen</LSTag>, it takes [2] for each ally on the Wheel <LSTag Type="Status" Tooltip="KINGMAKER_REIGNING">Reigning</LSTag> within [1]. When an ally on the Wheel becomes Reigning, each Fallen enemy within [1] of it takes [2]. Each ally does this to an enemy only once per round.` |
| `Arcana_Passive_Hubris` · Description | `h98a1667ag257bg89c1g3a7bg812ce656a521` | `An enemy that begins <LSTag Type="Status" Tooltip="KINGMAKER_REIGNING">Reigning</LSTag> on the Wheel gains <LSTag Type="Status" Tooltip="KINGMAKER_HUBRIS">Hubris</LSTag>. The higher it climbs, the harder it falls - its next <LSTag Type="Passive" Tooltip="Arcana_Passive_TheCrossing">Crossing</LSTag> deals [1] instead.` |
| `KINGMAKER_HUBRIS` · Description | `hbf648abdgae22gea64g24cegda87df7bc3d1` | `Climbed too high. The next Crossing it suffers deals [1] instead.` |
| `KINGMAKER_CROSSING_TECH` · Description | `h8056fb4fgea1fg274cg6ef6gd12ea0f42956` | `Lay Fallen while an ally reigned nearby, and took Force damage.` |
| `Arcana_Passive_FortunesReach` · Description | `h6151f413g0c66gb00bg764agd7b88239daf0` | `Your Crossings no longer need an ally nearby: every ally on the Wheel that is Reigning counts, wherever it stands.` |
| `KINGMAKER_KING` · Description | `h3b48dcb1g0180geefbg8b4cgd0eb5735c31c` | `Wears the crown of Fortune's wheel, on the Wheel or off it, until another ally has Reigned longer. The Kingmaker's Court serves the King.` |
| `Target_Arcana_Util_ConveneTheCourt` · Description | `h3c47e40ag0ca9g7ee5g3da5g7fc7b9ec55ff` | `Name your Court. Each ally you appoint holds an office until your next <LSTag Tooltip="LongRest">Long Rest</LSTag>. An office holder can never be the King or a Regent.` |
| `COURT_KINGS_HAND` · Description | `hf5ce5edag27cdgeb7cg6ab0g0dd731cae197` | `Serves as the King's Hand and never wears the crown. While there is no King, or the King is not Reigning, lands a <LSTag Tooltip="CriticalHit">Critical Hit</LSTag> on a roll of 19 or 20.` |
| `Target_Arcana_Util_Court_KingsHand` · Description | `hae806e9bg81e9gff5dgdadfg62be7fc047d4` | `Appoint an ally as the King's Hand. It never wears the crown, but while there is no King, or the King is not Reigning, it lands a <LSTag Tooltip="CriticalHit">Critical Hit</LSTag> on a roll of 19 or 20.` |
| `COURT_MASTER_OF_SHIPS` · Description | `h8312755bg6e76g27d3g11f6gb268c41fc2c2` | `Carries the Crossing across the field: an enemy within [1] that becomes Fallen suffers one more Crossing, as if a Reigning ally stood beside it.` |
| `Target_Arcana_Util_Court_MasterOfShips` · Description | `h859f8ee7g4399gc9cbg6818gca91d9e2d9b5` | `Appoint an ally as Master of Ships. An enemy within [1] of it that becomes Fallen suffers one more Crossing, as if a Reigning ally stood beside it.` |

Notes: the new texts of section 2 (Swift Shears ×2) get new handles in the Toolkit. The other languages follow
the usual EN → FR/DE/RU/ZH/PT-BR sync afterwards.

## 5 · Story

Replace the whole goal `Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Story/RawFiles/Goals/ARCANA_Kingmaker_Wheel.txt`
with [`ARCANA_Kingmaker_Wheel.txt`](ARCANA_Kingmaker_Wheel.txt) from this folder, then recompile the Story (expect 0 errors).

What changed in the goal, region by region:

| Region | Change |
|---|---|
| Tables | `DB_ARCANA_Kingmaker_CrossStatus(1..4)` — the four Crossing statuses |
| The Court | appointing an office calls the crown again (a King given an office loses the crown) |
| Move | `PROC_ARCANA_Kingmaker_Fell` marks an ally entering Reigning (`NewRuler`) and starts its `ReignTime` at 0 |
| Turn start | `ReignTime` +1 for every ally Reigning, before the Wheel turns; per-round DBs are now per pair |
| Atropos' Cut | no longer takes `KINGMAKER_KING` away |
| Swift Shears (new) | `KINGMAKER_SHEARS_FREE` at each turn start; removed by the first Atropos' Cut (any variant) |
| The crown | rewritten: King = most `ReignTime`, kept until strictly beaten; Court holders and summons excluded; Regent never on a Court holder; the King's Hand only gets the 19-20 crit while there is no King or the King isn't Reigning; a dead King hands the crown on |
| The Crossing | rewritten: pairs (enemy, source) from both sides, once per pair per round; Hubris pays for the first pair only; each hit uses the next of the four statuses |
| Leaving the Wheel | clean-up of the new DBs at the end of the fight |

## 6 · Tests (play after the Story compiles)

| # | Level | Setup | Expected |
|---|---|---|---|
| A1 | 1 | Crown ally A (first to Reign). Let the Wheel move A to Falling | A keeps King; no other ally is King |
| A2 | 1 | Atropos' Cut on King A | A leaves the Wheel and **keeps** King |
| A3 | 1 | Ally B Reigns as many rounds as A | A keeps King (a tie keeps the King) |
| A4 | 1 | Ally B Reigns one round more than A in total | B becomes King, A loses it |
| A5 | 1 | King A dies | the ally with the most rounds Reigning becomes King |
| B1 | 5 | Give King A a Court office | A loses the crown; the next ally by rounds Reigning takes it |
| B2 | 5 | A Court holder Reigns | no Regent status on it; it never becomes King |
| B3 | 5 | King's Hand, King Reigning | no 19-20 crit on the Hand |
| B4 | 5 | King's Hand, King Falling / no King yet | the Hand crits on 19-20; never shows the King status |
| C1 | 3 | Enemy already Fallen within 9 m; Turn the Spoke an ally from Rising to Reigning | the enemy takes the Crossing |
| C2 | 3 | Two Reigning allies within 9 m; an enemy enters Fallen | **two** Crossing hits in the log |
| C3 | 3 | Two Reigning allies, two enemies enter Fallen | four hits, two on each enemy |
| C4 | 3 | Same ally and enemy, try to cross again in the same round | no second hit from that pair |
| C5 | 3/5/9 | Crossing damage | 1d8 at level 3–4, 2d6 at 5–8, 2d8 at 9+ |
| C6 | 7 | Enemy with Hubris enters Fallen near two Reigning allies | one Hubris hit (2d8/3d6/3d8) + one normal hit; Hubris gone |
| C7 | 9 | Master of Ships within 9 m + one Reigning ally; an enemy enters Fallen | two hits |
| D1 | 3 | Cast Atropos' Cut twice in one turn | the first costs no action, the second does; the slot is spent both times |
| D2 | 3 | Upcast Atropos' Cut as the first cast of a turn | free of action too |
| D3 | 3 | Next turn | the first cast is free again |

## Consequence to watch

Each Crossing is still one Awakening step (two with a lone enemy). With one Crossing per Reigning ally, the WHEEL
goals (3 / 5 / 8) fill about twice as fast. Probes C2–C3 will show it; the goals live in 25.
