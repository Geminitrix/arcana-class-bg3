# The Kingmaker — player-facing texts (ARC-0008)

Draft English for every string the Kingmaker shows in game, written against `31.03_BG3_Style_Guide/ENGLISH_WRITING_STYLE.md`
(British spelling; spaced hyphen ` - `, never an em dash; single quotes; Title Case for rules nouns, lowercase for
resources; `[1]`-style placeholders as noun phrases; `<br><br>` only between separate rules). **Status: draft, to the
Lore Writer for the Narrative gate (`32.04`).** Design: `21.04/Kingmaker/2026-10-13-kingmaker-design.md`.

- **Placeholders:** a `[n]` in a Description reads `DescriptionParams`; in an ExtraDescription it reads `ExtraDescriptionParams`; each list starts at `[1]`.
- **Numbers** never appear as typed figures where a placeholder can carry them: `[n]` lists the `DescriptionParams`
  entry and the `25` value it reads. The Awakening passive keeps the literal goals, like the other five subclasses.
- **Ids** in `<LSTag>` are the proposed ones; `SPEC_ARC-0008` fixes them against the glossary and this file follows.

---

## 1. Class

| Where | Text |
|---|---|
| ClassDescription `Description` | Mystra wove the Kingmaker from the crowns that rise and fall on Fortune's wheel, a thread that decides who reigns. They bind friend and foe to the turning wheel, crown their allies as their enemies hit the bottom, and turn the whole wheel over when fortune runs against them. |
| ProgressionDescription (subclass panel) | The Kingmaker turns the Weave into Fortune's wheel, raising allies to reign while their enemies fall. |
| Tag line | We crown and we uncrown, and the Weave turns the wheel at our word. |

## 2. Passives

| Id (proposed) | DisplayName | Description | Params |
|---|---|---|---|
| `Arcana_Passive_TheRota` | The Rota | Creatures you set on Fortune's wheel move one position at the start of your turn - Rising, Reigning, Falling, Fallen, and round again. They stay on the Wheel until they die, combat ends or you cut their thread.<br><br>The ally that has Reigned the longest wears the crown as the <LSTag Type="Status" Tooltip="KINGMAKER_KING">King</LSTag>. | — |
| `Arcana_Passive_TheCrossing` | The Crossing | When an enemy on the Wheel becomes Fallen while an ally on the Wheel is Reigning within [1], the enemy takes [2]. Once per enemy per round. | [1] `Distance(9)` · [2] `DealDamage(LevelMapValue(Kingmaker_Crossing),Force)` — `FEAT_Kingmaker_Crossing` (1d4/1d6/1d8 by level, LevelMap `Kingmaker_Crossing`) |
| `Arcana_Passive_Hubris` | Hubris | An enemy that begins Reigning on the Wheel gains <LSTag Type="Status" Tooltip="KINGMAKER_HUBRIS">Hubris</LSTag>. The higher it climbs, the harder it falls - its next Crossing deals an additional [1]. | [1] one Crossing die — `FEAT_Kingmaker_Hubris` |
| `Arcana_Passive_Succession` | Succession | When an enemy on the Wheel dies, the nearest enemy within [1] that isn't on the Wheel takes its place, in the same position. The king is dead - long live the king. | [1] `Distance(9)` — `FEAT_Kingmaker_Succession` |
| `Arcana_Passive_FortunesReach` *(working name)* | Fortune's Reach | Your Crossings no longer need an ally nearby: an enemy that becomes Fallen while any ally on the Wheel is Reigning takes Crossing damage. | — |

### Awakening (the ARC-0007 shape)

| Id (proposed) | DisplayName | Description |
|---|---|---|
| `Arcana_Passive_Aspect_WheelOfFortune_Awakening` | 10 - Wheel of Fortune: Awakening | Make your enemies fall while your allies reign during a fight to awaken the Aspect of Anticipation until combat ends. Every Crossing counts, and while only one enemy is on the Wheel each Crossing counts twice. Each goal you reach awakens one more tier.<br><br>Level 3: cause 3 Crossings to gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_WheelOfFortune_I">Tyche</LSTag>.<br><br>Level 7: cause 5 Crossings to also gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_WheelOfFortune_II">Nemesis</LSTag>.<br><br>Level 12: cause 8 Crossings to awaken as the <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_WheelOfFortune_III">Aspect of Anticipation</LSTag>.<br><br>The Awakening status shows how much is left to the next tier. |
| `…_I` | Tyche | Fortune favours those you touch: creatures you set on the Wheel enter one position ahead. Allies you crown begin Reigning, and enemies you cast down begin Fallen. |
| `…_II` | Nemesis | When an enemy with Hubris suffers its Crossing, every enemy within [1] of it that is Falling drops to Fallen. *(param: `Distance(3)`)* |
| `…_III` | Aspect of Anticipation | Your allies never touch the bottom of the Wheel: instead of becoming Fallen, they stay Falling for one more turn. You can also prepare <LSTag Type="Spell" Tooltip="Interrupt_Arcana_Aspect_Foreseen">Foreseen</LSTag>. |

Awakened statuses (`10 - Wheel of Fortune: Awakened I / II / III`) list the bonuses above with the tier names as
labels, like the other subclasses. Stage 2 (SPEC_ARC-0008) fixes the Tier I ones:

| Id | DisplayName | Description |
|---|---|---|
| `ASPECT_AWAKENED_WHEEL` | 10 - Wheel of Fortune | Awakened as the Aspect of Anticipation until combat ends. |
| `ASPECT_AWAKENED_WHEEL_I` | 10 - Wheel of Fortune: Awakened I | Tyche: creatures you set on the Wheel enter one position ahead. Allies you crown begin Reigning, and enemies you cast down begin Fallen. |

## 3. Statuses

Status descriptions are written from outside the creature. Each position opens with its inscription.

| Id (proposed) | DisplayName | Description | Params |
|---|---|---|---|
| `KINGMAKER_RISING` | Rising | Regnabo - 'I shall reign.' Moves faster and can't be knocked <LSTag Type="Status" Tooltip="PRONE">Prone</LSTag>.<br><br>Becomes Reigning when the Wheel next turns. | — |
| `KINGMAKER_REIGNING` | Reigning | Regno - 'I reign.' Lands a <LSTag Tooltip="CriticalHit">Critical Hit</LSTag> on a roll of 19 or 20 and has <LSTag Tooltip="Advantage">Advantage</LSTag> on <LSTag Tooltip="SavingThrow">Saving Throws</LSTag>.<br><br>Becomes Falling when the Wheel next turns. | — |
| `KINGMAKER_FALLING` | Falling | Regnavi - 'I have reigned.' Moves slower and subtracts [1] from <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag>.<br><br>Becomes Fallen when the Wheel next turns. | [1] `1d4` — `FEAT_Kingmaker_TheRota` |
| `KINGMAKER_FALLEN` | Fallen | Sum sine regno - 'I am without reign.' Attack Rolls against it have Advantage, and it can't take reactions.<br><br>Becomes Rising when the Wheel next turns. | — |
| `KINGMAKER_KING` | King | Wears the crown of Fortune's wheel. The Kingmaker's Court serves the King. | — |
| `KINGMAKER_REGENT` | Regent | Reigns beside the King without wearing the crown. | — |
| `KINGMAKER_HUBRIS` | Hubris | Climbed too high. The next Crossing it suffers deals an additional [1]. | [1] one Crossing die — `FEAT_Kingmaker_Hubris` |
| `KINGMAKER_WHEEL_STOPPED` | The Wheel Stops | Held on Fortune's wheel: the Wheel doesn't turn it while it is stopped. (SP112) | — |
| `KINGMAKER_CROSSING_TECH` | The Crossing | Fell while an ally reigned nearby, and took Force damage. *(shown over the enemy)* | — |
| `KINGMAKER_REIGNING_LINGER` | Reigning | Cut from the Wheel at its peak. Lands a <LSTag Tooltip="CriticalHit">Critical Hit</LSTag> on a roll of 19 or 20 and has <LSTag Tooltip="Advantage">Advantage</LSTag> on <LSTag Tooltip="SavingThrow">Saving Throws</LSTag> until the end of its next turn. | — |

### The Court (one status per office, on the holder)

| Id (proposed) | DisplayName | Description | Params |
|---|---|---|---|
| `COURT_KINGS_HAND` | King's Hand | Serves as the King's Hand. While no ally is Reigning, wears the crown and lands a Critical Hit on a roll of 19 or 20. | — |
| `COURT_LORD_COMMANDER` | Lord Commander | Guards the crown. Attack Rolls against the King have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag> while the King is within [1]. | [1] `Distance(3)` — `FEAT_Kingmaker_Court` |
| `KINGMAKER_GUARDED` | Guarded | The Lord Commander stands guard. <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag> against it have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag>. | — |
| `KINGMAKER_EXPOSED` | Exposed | The Master of Secrets has its measure. Can't become <LSTag Type="Status" Tooltip="INVISIBLE">Invisible</LSTag> or hide. | — |
| `KINGMAKER_CROSSING_HUBRIS_TECH` | The Crossing | Fell from its pride while an ally reigned nearby, and took greater Force damage. | — |
| `ASPECT_AWAKENED_WHEEL_II` | 10 - Wheel of Fortune: Awakened II | Tyche: … (as Awakened I)<br><br>Nemesis: when an enemy with Hubris suffers its Crossing, every enemy within [1] of it that is Falling drops to Fallen. | [1] `Distance(3)` |
| `COURT_MASTER_OF_HEALING` | Master of Healing | Healing an ally on the Wheel lifts it one position closer to Reigning, if it is Fallen or Rising. | — |
| `COURT_MASTER_OF_LAWS` | Master of Laws | An enemy that attacks the King falls one position further when the Wheel next turns, but never past Fallen and never up to Reigning. | — |
| `COURT_MASTER_OF_SECRETS` | Master of Secrets | Enemies on the Wheel within [1] can't be <LSTag Type="Status" Tooltip="INVISIBLE">Invisible</LSTag> or hide. Has Advantage on Attack Rolls against Falling enemies. | [1] `Distance(9)` — `FEAT_Kingmaker_Court` |
| `COURT_MASTER_OF_COIN` | Master of Coin | Once per <LSTag Tooltip="LongRest">Long Rest</LSTag>, hitting a Fallen enemy returns a spell slot to the Kingmaker. | — |
| `COURT_MASTER_OF_SHIPS` | Master of Ships | Carries the Crossing across the field: an enemy within [1] that becomes Fallen suffers its Crossing as if a Reigning ally stood beside it. | [1] `Distance(9)` — `FEAT_Kingmaker_Court` |

Stage 5 strings (exact): `55/_wip/Kingmaker/stage5/50_stage5.patch` (`@loca KM_*`); the Master of Coin's option reads "Appoint an ally as Master of Coin. Once per Long Rest, when it hits a Fallen enemy, you regain a spell slot."

## 4. Spells

`Description` is the imperative line; `ExtraDescription` holds the fine print.

| Id (proposed) | DisplayName | Description | ExtraDescription | Params |
|---|---|---|---|---|
| `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` | Spoke of the Wheel | Hurl a spoke of Fortune's wheel at a foe. | Deals an additional [1] to a creature that is Falling or Fallen. | ExtraDescriptionParams [1] `DealDamage(1d4,Bludgeoning)` — `SPL_Kingmaker_SpokeOfTheWheel`; damage shown by TooltipDamageList |
| `Target_Arcana_Card_Spell_Coronation` | Coronation | Crown an ally or yourself and set them Rising on Fortune's wheel. | The crowned creature stays on the Wheel until it dies, combat ends or its thread is cut. | — |
| `Target_Arcana_Card_Spell_Dethrone` | Dethrone | Cast an enemy down and set it Falling on Fortune's wheel. | On a successful <LSTag Tooltip="SavingThrow">Saving Throw</LSTag> the target takes half damage, but it still joins the Wheel. | no `[n]`; damage shown by TooltipDamageList `DealDamage(3d6,Bludgeoning)` — `SPL_Kingmaker_Dethrone` |
| `Target_Arcana_Card_Spell_TurnTheSpoke` | Turn the Spoke | Turn a creature on the Wheel one position onward. | The Wheel only turns forward. | — |
| `Target_Arcana_Card_Spell_AtroposCut` | Atropos' Cut | Cut a creature's thread from Fortune's wheel. | An enemy takes damage that grows the lower it sits: [1] if Fallen, [2] if Falling, [3] if Rising or Reigning.<br><br>An ally leaves the Wheel. If it was Reigning, it keeps Reigning until the end of its next turn. | ExtraDescriptionParams [1] `DealDamage(3d8,Slashing)` · [2] `DealDamage(2d8,Slashing)` · [3] `DealDamage(1d8,Slashing)` — `SPL_Kingmaker_AtroposCut` |
| `Shout_Arcana_Card_Spell_Peripeteia` | Peripeteia | Reverse the fortunes of every creature on the Wheel within [1]. | Reigning becomes Fallen and Rising becomes Falling, and the reverse. Your allies turn too.<br><br>Once per combat. | DescriptionParams [1] `Distance(18)` — `SPL_Kingmaker_Peripeteia` |
| `Target_Arcana_Card_Spell_Usurp` | Usurp | An ally and an enemy on the Wheel trade places on it. | Choose one ally and one enemy. Two allies or two enemies don't trade.<br><br>Once per combat. | — |
| `Zone_Arcana_Card_Spell_WheelOfIxion` | Wheel of Ixion | Send a burning wheel rolling through your foes and bind them to Fortune's wheel, Falling. | Enemies that succeed the <LSTag Tooltip="SavingThrow">Saving Throw</LSTag> take half damage but still join the Wheel. The wheel leaves a trail of fire behind it - allies included. | [1] `DealDamage(5d6,Fire)` — `SPL_Kingmaker_WheelOfIxion` |
| `Shout_Arcana_Card_Spell_TheWheelStops` | The Wheel Stops | Stop Fortune's wheel. It doesn't turn at the start of your next [1] turns. (SP112) | While the Wheel is stopped, at the start of each of your turns every Fallen enemy within [1] of a Reigning ally suffers its Crossing. | DescriptionParams [1] `2` turns · ExtraDescriptionParams [1] `Distance(9)` — `SPL_Kingmaker_TheWheelStops` |
| `Shout_Arcana_Created_Aspect_RotaFortunae` | Rota Fortunae | Turn Fortune's wheel once more. Every creature on it moves one position onward. | Crossings happen as they do when the Wheel turns.<br><br>Once per combat. | — |
| `Interrupt_Arcana_Aspect_Foreseen` | Foreseen | When an enemy on the Wheel is about to attack you or an ally, push it one position onward before the blow lands, if it is Reigning or Falling. | You saw it coming. | — |
| `Target_Arcana_Util_ConveneTheCourt` | Convene the Court | Name your Court. Each ally you appoint holds an office until your next <LSTag Tooltip="LongRest">Long Rest</LSTag>. | You can appoint as many offices as your Charisma <LSTag Tooltip="AbilityModifier">Modifier</LSTag>, at least one. You can't hold an office yourself, and an ally holds one office at most. | — |

The seven *Convene the Court* options (`Target_Arcana_Util_Court_<Office>`) take the office's name; their Description appoints (stage 3: "Appoint an ally as the King's Hand. While no ally is Reigning, it wears the crown…"), and every option's ExtraDescription reads: The office lasts until your next <LSTag Tooltip="LongRest">Long Rest</LSTag>. Each office can be given once per <LSTag Tooltip="LongRest">Long Rest</LSTag>. The exact strings are in `55/_wip/Kingmaker/stage3/30_stage3.patch` (`@loca KM_*`).

## 5. Notes for the Lore Writer

- The tag line and the class description's second sentence are new; the first sentence is the Owner's (SP95).
- *Fortune's Reach* is a working name for the level-12 passive.
- Check every `Distance(n)` / `DealDamage(…)` param against the final ids in `SPEC_ARC-0008`.
