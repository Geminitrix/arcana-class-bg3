---
id: 32.01/Unbound
owner: Lore Writer
source: game loca (51 Mods/…/Localization/English/english.xml) + Stats ids, extracted 2026-10-17 with dossier_texts.pl; 21.04/Unbound/DESIGN.md §11; DECISIONS.md WB0, WB27–WB44
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); names of the build (WB44) at the end; 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — WB49 (QA-0004 probe outcomes) checked, no change; 2026-10-17 ARC-0026 — P8 fix applied, no change
---

# 32.01 · Player-facing text — The Windborn (internal: Unbound)

Every name and description the player reads, **as it is in the game today** (the old Unbound build; English; `[n]` are
the game's parameters, numbers come from `25`). The other languages follow Localization. Polishing the English waits
for the end of the rework (ARC-0006); voice and style: `31.03`.

## Review notes (Lore Writer, 2026-10-17)

| Text | Issue | Fix (with the build — game text) |
|---|---|---|
| Every card | Ends with "Afterwards, you can make a Zephyr Strike as a bonus action." | Drop it; The Open Road teaches the rule once (WB27) |
| Flowing Strikes: Zephyr | The old rule | Becomes **The Open Road**: Windswept, the Open Path, the Rush |
| Be the Leaf | Says Wisdom | "…You add your Intelligence Modifier to your Armour Class." (WB21) |
| Twinkle Toes · Feather Fall | Off-register name; vanilla spell name | **Weightless**, by rank (WB39, WB47) |
| Thunderclap, Evasive Flow, Momentum, Eye of the Storm, Wanderlust, Restless Wind, Aspect of Curiosity (tier), Fool's Luck | Retired or replaced | Removed; tiers renamed (WB24, WB44) |
| `GALE_DEFLECTION_USED_TECH` shows "Aspect"; `INTERRUPT_GALE_DEFLECT_MISSILES_HIT` shows its id | Technical statuses with a visible name | Hide them, or give no name |
| Class name | "The Unbound" | **The Windborn** (WB0, ARC-0021) |


## Spells and cards

| Internal id | Name | Description |
|---|---|---|
| `Projectile_Arcana_Reaction_GaleDeflection` | Gale Deflection: Redirect | Use your reflexes to catch a projectile from a ranged weapon attack and shoot it back at your attacker. |
| `Rush_Arcana_Created_Aspect_LeapOfFaith` | Leap of Faith | Dash through the fray, striking every creature in your path with an unarmed attack that also deals [1].Afterwards, you can make a Zephyr Strike as a bonus action. |
| `Shout_Arcana_Card_Passive_GaleDeflection` | Ready: Gale Deflection | Pull a thread of wind back into your reach. Until combat ends, you gain Gale Deflection and one use of it. You can hold up to 3 uses. |
| `Shout_Arcana_Card_Spell_FlowState` | Flow State | Enter a temporary state of flow where you gain temporary hit points, and an additional bonus action.Afterwards, you can make a Zephyr Strike as a bonus action. |
| `Shout_Arcana_Card_Spell_WindWhispers` | Wind Whispers | You can sense movement in the air. Attack Rolls against you have Disadvantage, and when an enemy's melee attack misses you, you use your reaction to strike back with an unarmed attack.Afterwards, you can make a Zephyr Strike as a bonus action. |
| `Shout_Arcana_Card_Spell_EvasiveFlow` | Evasive Flow | Leap into an opening. Jumping no longer requires a bonus action, and your next unarmed attack this turn has Advantage.Afterwards, you can make a Zephyr Strike as a bonus action. |
| `Shout_Arcana_Card_Spell_StormFists` | Storm Fists | The wind flows through your hands. Your unarmed attacks deal an additional [1].Afterwards, you can make a Zephyr Strike as a bonus action. |
| `Shout_Arcana_Card_Spell_Thunderclap` | Thunderclap | When you deal [1], inflict 2 turns of Reverberation upon the target.Afterwards, you can make a Zephyr Strike as a bonus action. |
| `Shout_Arcana_Card_Ability_Untethered` | Untethered | Freed from earthly ties, gain the ability to Fly.Afterwards, you can make a Zephyr Strike as a bonus action. |
| `Target_Arcana_Card_Spell_GaleBurst` | Gale Burst | Channel the air into your fist and release it in a focused burst, launching your target backwards [1] and knocking it Prone.Afterwards, you can make a Zephyr Strike as a bonus action. |
| `Target_Arcana_Created_ZephyrStrike` | Zephyr Strike | Swiftly strike an enemy as a bonus action. |
| `Zone_Arcana_Card_Spell_WindBlast` | Wind Blast | Bend the air to unleash a strong gust of wind that clears clouds and pushes creatures back [1], leaving them Off Balance.Afterwards, you can make a Zephyr Strike as a bonus action. |

## Passives

| Internal id | Name | Description |
|---|---|---|
| `Arcana_Passive_BetheLeaf` | Be the Leaf | Your reflexes are as effective as armour. You add your Wisdom Modifier to your Armour Class. |
| `Arcana_Passive_FlowingStrikeZephyr` | Flowing Strikes: Zephyr | After making an unarmed attack or casting an Arcane spell, you can make a Zephyr Strike as a bonus action. |
| `Arcana_Passive_FlowingStrikesAgility` | Flowing Strikes: Agility | Your unarmed attacks scale with Dexterity instead of Strength if your Dexterity is higher. |
| `Arcana_Passive_FlowingStrikesPrecision` | Flowing Strikes: Precision | Your unarmed attacks deal [1], unless their normal damage is higher. |
| `Arcana_Passive_FlowingAssault` | Flowing Assault | You can make an additional free attack after making an unarmed or weapon attack. |
| `Arcana_Passive_MagicStrikes` | Magic Strikes | Your unarmed attacks count as magical, ignoring Resistance and Immunity to non-magical damage. |
| `Arcana_Passive_EyeOfTheStorm_UI` | Eye of the Storm | While Untethered is active, the air surrounds your body, protecting you. You gain a bonus of +[1] to your Armour Class. |
| `Arcana_Passive_Momentum_UI` | Momentum | While Thunderclap is active, you gain a bonus of +[1] to your Armour Class. |
| `Arcana_Passive_EmptyState` | Empty State | Your agility lets you dodge incoming attacks and certain spells. When an attack hits you, you take only half damage.When a spell or effect allows a Dexterity Saving Throw for half damage, you take no damage on a success, and only half damage on a failure. |
| `Arcana_Passive_GaleDeflection` | Gale Deflection | Use your reaction to reduce the damage from a ranged weapon attack by 1d10 + your Dexterity Modifier + your Arcana level. If the damage is reduced to 0, you can Deflect the Missile. |
| `Arcana_Passive_Thunderclap` | Thunderclap |  |
| `Arcana_Passive_Aspect_Fool_Awakened_I` | Wanderlust |  |
| `Arcana_Passive_Aspect_Fool_Awakened_II` | Restless Wind |  |
| `Arcana_Passive_Aspect_Fool_Awakened_III` | Aspect of Curiosity |  |
| `Arcana_Passive_Aspect_Fool_Awakening` | 0 - The Fool: Awakening | Strike different enemies with attacks within a single round during a fight to awaken the Aspect of Curiosity until combat ends. If fewer enemies stand when your turn begins than a goal asks for, strikes on any enemy count towards that goal instead. Each goal you reach awakens one more tier.Level 3: strike 3 different enemies in one round to gain Wanderlust.Level 7: strike 4 different enemies in one round to also gain Restless Wind.Level 12: strike 5 different enemies in one round to awaken as the Aspect of Curiosity.The Awakening status shows how much is left to the next tier. |
| `Arcana_Passive_Aspect_Fool_I` | Wanderlust | Your movement speed increases by [1], you can move without provoking Opportunity Attacks, and your unarmed attacks deal an additional [2]. |
| `Arcana_Passive_Aspect_Fool_II` | Restless Wind | You have Advantage on Dexterity Saving Throws and an additional reaction. Once per turn, Zephyr Strike doesn't cost a bonus action. |
| `Arcana_Passive_Aspect_Fool_III` | Aspect of Curiosity | Your Dexterity increases by [1] and you have another additional reaction. Once per round, the first attack against you misses. |

## Statuses

| Internal id | Name | Description |
|---|---|---|
| `GALE_DEFLECTION_READY` | Gale Deflection | Use your reaction to reduce the damage from a ranged weapon attack by 1d10 + your Dexterity Modifier + your Arcana level. If the damage is reduced to 0, you can Deflect the Missile. |
| `GALE_DEFLECTION_USED_TECH` | Aspect |  |
| `FLOW_STATE` | Flow State | You gained [1] and an additional bonus action.Equipping armour or a shield ends this effect. |
| `WIND_WHISPERS` | Wind Whispers | Focusing on avoiding attacks. Attack Rolls against you have Disadvantage. When a melee attack misses, strikes back with an unarmed attack as a reaction.Equipping armour or a shield ends this effect. |
| `EVASIVE_FLOW` | Evasive Flow | Jumping no longer requires a bonus action.Equipping armour or a shield ends this effect. |
| `EVASIVE_FLOW_OPENING` | Opening | Has Advantage on the next unarmed Attack Roll this turn. |
| `STORM_FISTS` | Storm Fists | The wind flows through your hands. Your unarmed attacks deal an additional [1].Equipping armour or a shield ends this effect. |
| `THUNDERCLAP` | Thunderclap | When you deal [1], inflict 2 turns of Reverberation upon the target.Equipping armour or a shield ends this effect. |
| `MAG_THUNDER_REVERBERATION` | Reverberation | The affected entity has a -1 penalty to Strength, Dexterity, and Constitution Saving Throws per remaining turn.When the entity has [1] or more turns of Reverberation, it takes [2] and possibly falls Prone. The condition is removed afterward.Creatures Immune to Thunder damage can't receive Reverberation. |
| `ZEPHYR_STRIKE` | Zephyr Strike | You can make a Zephyr Strike as a bonus action this turn.Equipping armour or a shield ends this effect. |
| `GALE_DEFLECT_MISSILES` | Gale Deflect Missiles | You can use your reaction to deflect the missiles from ranged weapon attacks. When you do so, the damage is reduced by 1d10 + [1] + your Arcana level. |
| `ASPECT_AWAKENED_FOOL` | 0 - The Fool | Awakened as the Aspect of Curiosity until combat ends. |
| `ASPECT_AWAKENED_FOOL_I` | 0 - The Fool: Awakened I | Wanderlust: Your movement speed increases by [1], you can move without provoking Opportunity Attacks, and your unarmed attacks deal an additional [2].Only active while not wearing armour or using a shield. |
| `ASPECT_AWAKENED_FOOL_II` | 0 - The Fool: Awakened II | Wanderlust: Your movement speed increases by [1], you can move without provoking Opportunity Attacks, and your unarmed attacks deal an additional [2].Restless Wind: You have Advantage on Dexterity Saving Throws and an additional reaction. Once per turn, Zephyr Strike doesn't cost a bonus action.Only active while not wearing armour or using a shield. |
| `ASPECT_AWAKENED_FOOL_III` | 0 - The Fool: Awakened III | Wanderlust: Your movement speed increases by [1], you can move without provoking Opportunity Attacks, and your unarmed attacks deal an additional [2].Restless Wind: You have Advantage on Dexterity Saving Throws and an additional reaction. Once per turn, Zephyr Strike doesn't cost a bonus action.Aspect of Curiosity: Your Dexterity increases by [3] and you have another additional reaction. Once per round, the first attack against you misses.Only active while not wearing armour or using a shield. |
| `FOOL_ZEPHYR_FREE` | Restless Wind | The next Zephyr Strike this turn doesn't cost a bonus action. |
| `INTERRUPT_GALE_DEFLECT_MISSILES_HIT` | INTERRUPT_GALE_DEFLECT_MISSILES_HIT |  |

## Reactions

| Internal id | Name | Description |
|---|---|---|
| `Interrupt_Arcana_Reaction_GaleDeflection` | Gale Deflection | Reduce the damage from a ranged weapon attack by 1d10 + your Dexterity Modifier + your Arcana level.If the damage is reduced to 0, you use an Arcane Card to Deflect the Missile. |
| `Interrupt_Arcana_Reaction_GaleDeflection_Return` | Gale Deflection: Redirect | Bend the air around a projectile from a ranged weapon attack and hurl it back at your attacker. |
| `Interrupt_Arcana_WindWhispers_Riposte` | Wind Riposte | When an enemy's melee attack misses you while Wind Whispers is active, use your reaction to strike back with an unarmed attack. |
| `Interrupt_Arcana_Aspect_FoolsLuck` | Fool's Luck | Once per round, the first attack against you misses. |

## After the build (WB44) — names to apply, descriptions written in the build ticket and passed through `32.04`

| Piece | Name | Replaces |
|---|---|---|
| Core passive | **The Open Road** | Flowing Strikes: Zephyr |
| Mark (status) | **Windswept** | — (new) |
| Signature | **Zephyr Strike** (ranks **Breeze · Gale · Storm · Hurricane**) | Zephyr Strike |
| Movement passive | **Weightless** | Twinkle Toes, Feather Fall |
| Ultimate | **Aeolus' Bag** — winds **Boreas** (the North Wind), **Notus** (the South Wind), **Eurus** (the East Wind) | — (new) |
| Aspect card | **The Calm** | Leap of Faith (as Aspect card) |
| Capstone | **Where the Winds Meet** | — (new) |
| Tiers I · II · III | **The First Step · Fellow Travellers · Into the Storm** | Wanderlust · Restless Wind · Aspect of Curiosity |
| Kept | Gale Burst, Wind Blast, Wind Whispers, Flow State, Ready: Gale Deflection, Storm Fists, Untethered, Leap of Faith, Be the Leaf, Flowing Strikes: Agility / Precision, Flowing Assault, Magic Strikes, Empty State | — |
| Subclass | **The Windborn** | The Unbound |
