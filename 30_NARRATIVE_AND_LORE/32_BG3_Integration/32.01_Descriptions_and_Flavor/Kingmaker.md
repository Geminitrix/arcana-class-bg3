---
id: 32.01/Kingmaker
owner: Lore Writer
source: game loca (51 Mods/…/Localization/English/english.xml) + Stats ids, extracted 2026-10-15 with dossier_texts.pl; 21.04/Kingmaker/DESIGN.md §12; Kingmaker_texts_with_params.md
reviewed: 2026-11-16 ARC-0008 — re-extracted after the Owner's adjustments (crown, Court, Crossing, Swift Shears, Severance, Atropos' Cut)
---

# 32.01 · Player-facing text — The Kingmaker

Every name and description the player reads, **as it is in the game today** (English; `[n]` are the game's
parameters, numbers come from `25`). The ExtraDescriptions and the parameter of each `[n]` are in
`Kingmaker_texts_with_params.md` (the writing source the Toolkit guides were built from). The 15 other languages do
not have these strings yet (Localization). Polishing the English waits for the end of the rework (ARC-0006).

## Review notes (Lore Writer, 2026-10-15)

| Text | Finding | Action |
|---|---|---|
| Style (`31.03`) | 52 entries checked (name + description): no em dash, no double quotes, no US spelling, spaced hyphen, rules nouns capitalised | None |
| Terms (`33.03`) | All names match SP100–SP102 and the glossary added in this propagation | None |
| Positions | Each tooltip opens with its Latin inscription and names the next position (DESIGN §12) | None |
| *The Court: second / third circle* | No Description — both passives are `IsHidden`, the player never sees them | None |
| Ready: Foreseen | Says "Watch the Wheel" — it does not say it costs a Bonus Action (SP114); the cost shows on the spell's icon, like vanilla | None |
| Narrative gate | Recorded in `32.04/ARC-0008_Kingmaker.md` | Done |


## Spells and cards

| Internal id | Name | Description |
|---|---|---|
| `Projectile_Arcana_Card_Spell_SpokeOfTheWheel` | Spoke of the Wheel | Hurl a spoke of Fortune's wheel at a foe.Deals an additional [1] to a creature that is Falling or Fallen. |
| `Shout_Arcana_Card_Spell_Peripeteia` | Peripeteia | Reverse the fortunes of every creature on the Wheel within [1]. |
| `Shout_Arcana_Card_Spell_TheWheelStops` | The Wheel Stops | Stop Fortune's wheel. It doesn't turn at the start of your next [1] turns. |
| `Shout_Arcana_Created_Aspect_RotaFortunae` | Rota Fortunae | Turn Fortune's wheel once more. Every creature on it moves one position onward. |
| `Shout_Arcana_Created_Aspect_ReadyForeseen` | Ready: Foreseen | Watch the Wheel. Until combat ends you can react with Foreseen. |
| `Target_Arcana_Card_Spell_TurnTheSpoke` | Turn the Spoke | Turn a creature on the Wheel one position onward. |
| `Target_Arcana_Util_ConveneTheCourt` | Convene the Court | Name your Court. Each ally you appoint holds an office until your next Long Rest. An office holder can never be the King or a Regent. |
| `Target_Arcana_Card_Spell_Coronation` | Coronation | Crown anyone and set them Rising on Fortune's wheel. |
| `Target_Arcana_Card_Spell_Dethrone` | Dethrone | Cast anyone down and set it Falling on Fortune's wheel.<br><br>Only enemies take the damage. |
| `Target_Arcana_Card_Spell_AtroposCut` | Atropos' Cut | Cut a creature's thread from Fortune's wheel.An enemy takes damage that grows the higher it stands:- [4] if Fallen;- [3] if Falling;- [2] if Rising;- [1] if Reigning.If an ally is chosen, they leave the Wheel. If they were Reigning, they remain Reigning until the end of their next turn. |
| `Target_Arcana_Card_Spell_Usurp` | Usurp | An ally and an enemy on the Wheel trade places on it. |
| `Zone_Arcana_Card_Spell_WheelOfIxion` | Wheel of Ixion | Send a burning wheel rolling through your foes and bind them to Fortune's wheel, Falling. |

## Passives

| Internal id | Name | Description |
|---|---|---|
| `Arcana_Passive_TheRota` | The Rota | Creatures you set on Fortune's wheel move one position at the start of your turn - Rising, Reigning, Falling, Fallen, and round again. They stay on the Wheel until they die, combat ends or you cut their thread.The ally that has Reigned the longest wears the crown as the King, and keeps it - even off the Wheel - until another ally has Reigned longer. |
| `Arcana_Passive_TheCrossing` | The Crossing | When an enemy on the Wheel becomes Fallen, it takes [2] for each ally on the Wheel Reigning within [1]. When an ally on the Wheel becomes Reigning, each Fallen enemy within [1] of it takes [2]. Each ally does this to an enemy only once per round. |
| `Arcana_Passive_Hubris` | Hubris | An enemy that begins Reigning on the Wheel gains Hubris. The higher it climbs, the harder it falls - its next Crossing deals [1] instead. |
| `Arcana_Passive_SwiftShears` | Swift Shears | When you cast Turn the Spoke, your next Atropos' Cut this turn doesn't cost an action. |
| `Arcana_Passive_Severance` | Severance | When you cast Atropos' Cut, your next Dethrone this turn doesn't cost an action. |
| `Arcana_Passive_Succession` | Succession | When an enemy on the Wheel dies, the nearest enemy within [1] that isn't on the Wheel takes its place, in the same position. The king is dead - long live the king. |
| `Arcana_Passive_FortunesReach` | Fortune's Reach | Your Crossings no longer need an ally nearby: every ally on the Wheel that is Reigning counts, wherever it stands. |
| `Arcana_Passive_Court_MasterOfCoin` | Master of Coin | Once per turn, hitting a Fallen enemy returns a Woven Spell Slot to the Kingmaker. |
| `Arcana_Passive_Court_MasterOfHealing` | Master of Healing | Healing an ally on the Wheel lifts it one position closer to Reigning, if it is Fallen or Rising. |
| `Arcana_Passive_Aspect_WheelOfFortune_Awakening` | 10 - Wheel of Fortune: Awakening | Make your enemies fall while your allies reign during a fight to awaken the Aspect of Anticipation until combat ends. Every Crossing counts, and while only one enemy is on the Wheel each Crossing counts twice. Each goal you reach awakens one more tier.Level 3: cause 3 Crossings to gain Tyche.Level 7: cause 5 Crossings to also gain Nemesis.Level 12: cause 8 Crossings to awaken as the Aspect of Anticipation.The Awakening status shows how much is left to the next tier. |
| `Arcana_Passive_Aspect_WheelOfFortune_I` | Tyche | Your first Turn the Spoke each turn doesn't cost a bonus action. |
| `Arcana_Passive_Aspect_WheelOfFortune_II` | Nemesis | When an enemy with Hubris suffers its Crossing, every enemy within [1] of it that is Falling drops to Fallen. |
| `Arcana_Passive_Aspect_WheelOfFortune_III` | Aspect of Anticipation | Your allies never touch the bottom of the Wheel: instead of becoming Fallen, they stay Falling for one more turn. You can also prepare Foreseen. |

## Statuses

| Internal id | Name | Description |
|---|---|---|
| `KINGMAKER_FALLEN` | Fallen | Sum sine regno - 'I am without reign.' Attack Rolls against it have Advantage, and it can't take reactions.Becomes Rising when the Wheel next turns. |
| `KINGMAKER_FALLING` | Falling | Regnavi - 'I have reigned.' Moves slower and subtracts [1] from Attack Rolls.Becomes Fallen when the Wheel next turns. |
| `KINGMAKER_REIGNING` | Reigning | Regno - 'I reign.' Lands a Critical Hit on a roll of 19 or 20 and has Advantage on Saving Throws.Becomes Falling when the Wheel next turns. |
| `KINGMAKER_RISING` | Rising | Regnabo - 'I shall reign.' Moves faster and can't be knocked Prone.Becomes Reigning when the Wheel next turns. |
| `COURT_KINGS_HAND` | King's Hand | Serves as the King's Hand and never wears the crown. While there is no King, or the King is not Reigning, lands a Critical Hit on a roll of 19 or 20. |
| `COURT_LORD_COMMANDER` | Lord Commander | Guards the crown. Attack Rolls against the King have Disadvantage while the King is within [1]. |
| `COURT_MASTER_OF_COIN` | Master of Coin | Once per turn, hitting a Fallen enemy returns a Woven Spell Slot to the Kingmaker. |
| `COURT_MASTER_OF_HEALING` | Master of Healing | Healing an ally on the Wheel lifts it one position closer to Reigning, if it is Fallen or Rising. |
| `COURT_MASTER_OF_LAWS` | Master of Laws | An enemy that attacks the King falls one position further when the Wheel next turns, but never past Fallen and never up to Reigning. |
| `COURT_MASTER_OF_SECRETS` | Master of Secrets | Enemies on the Wheel within [1] can't be Invisible or hide. Has Advantage on Attack Rolls against Falling enemies. |
| `COURT_MASTER_OF_SHIPS` | Master of Ships | Carries the Crossing across the field: an enemy within [1] that becomes Fallen suffers one more Crossing, as if a Reigning ally stood beside it. |
| `KINGMAKER_GUARDED` | Guarded | The Lord Commander stands guard. Attack Rolls against it have Disadvantage. |
| `KINGMAKER_KING` | King | Wears the crown of Fortune's wheel, on the Wheel or off it, until another ally has Reigned longer. The Kingmaker's Court serves the King. |
| `KINGMAKER_EXPOSED` | Exposed | The Master of Secrets has its measure. Can't become Invisible or hide. |
| `KINGMAKER_CROSSING_HUBRIS_TECH` | The Crossing | Fell from its pride while an ally reigned nearby, and took greater Force damage. |
| `KINGMAKER_CROSSING_TECH` | The Crossing | Lay Fallen while an ally reigned nearby, and took Force damage. |
| `KINGMAKER_FORESEEN_READY` | Foreseen | Can react to push an attacking enemy one position onward on the Wheel before the blow lands, if it is Reigning or Falling. A Reigning attacker also subtracts 1d4 from that Attack Roll. |
| `KINGMAKER_HUBRIS` | Hubris | Climbed too high. The next Crossing it suffers deals [1] instead. |
| `KINGMAKER_REGENT` | Regent | Reigns beside the King without wearing the crown. |
| `KINGMAKER_REIGNING_LINGER` | Reigning | Cut from the Wheel at its peak. Lands a Critical Hit on a roll of 19 or 20 and has Advantage on Saving Throws until the end of its next turn. |
| `KINGMAKER_SWIFT_SHEARS` | Swift Shears | Can cast Atropos' Cut without using an action. Ends after that cast, or at the end of the turn. |
| `KINGMAKER_SEVERANCE` | Severance | Can cast Dethrone without using an action. Ends after that cast, or at the end of the turn. |
| `KINGMAKER_TYCHE` | Tyche | The next Turn the Spoke this turn doesn't cost a bonus action. |
| `KINGMAKER_WHEEL_STOPPED` | The Wheel Stops | Held on Fortune's wheel: the Wheel doesn't turn it while it is stopped. |

## Reactions

| Internal id | Name | Description |
|---|---|---|
| `Interrupt_Arcana_Aspect_Foreseen` | Foreseen | When an enemy on the Wheel attacks you or an ally, push it one position onward before the blow lands, if it is Reigning or Falling. A Reigning attacker also takes a 1d4 penalty to that attack roll. |

## Convene the Court — the seven options

| Internal id | Name | Description |
|---|---|---|
| `Target_Arcana_Util_Court_KingsHand` | King's Hand | Appoint an ally as the King's Hand. It never wears the crown, but while there is no King, or the King is not Reigning, it lands a Critical Hit on a roll of 19 or 20. |
| `Target_Arcana_Util_Court_LordCommander` | Lord Commander | Appoint an ally as Lord Commander. While the King is within [1] of it, Attack Rolls against the King have Disadvantage. |
| `Target_Arcana_Util_Court_MasterOfCoin` | Master of Coin | Appoint an ally as Master of Coin. Once per turn, when it hits a Fallen enemy, you regain a spell slot. |
| `Target_Arcana_Util_Court_MasterOfHealing` | Master of Healing | Appoint an ally as Master of Healing. When it heals an ally on the Wheel that is Fallen or Rising, that ally moves one position closer to Reigning. |
| `Target_Arcana_Util_Court_MasterOfLaws` | Master of Laws | Appoint an ally as Master of Laws. An enemy that attacks the King falls one position further when the Wheel next turns, but never past Fallen and never up to Reigning. |
| `Target_Arcana_Util_Court_MasterOfSecrets` | Master of Secrets | Appoint an ally as Master of Secrets. Enemies on the Wheel within [1] of it can't be Invisible or hide, and it has Advantage on Attack Rolls against Falling enemies. |
| `Target_Arcana_Util_Court_MasterOfShips` | Master of Ships | Appoint an ally as Master of Ships. An enemy within [1] of it that becomes Fallen suffers one more Crossing, as if a Reigning ally stood beside it. |
