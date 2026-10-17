# ARC-0026 Task 0.2 — the build's texts (approved, Narrative gate 32.04 passed 2026-10-17)

Source: names WB44, rules `21.04/Unbound/DESIGN.md` §4–§8, values `25` (`*_Unbound_*`). Style: `31.03` and the measured
Larian corpus — British spelling, no em dash, single quotes, `[n]` as a noun phrase, the first mention tagged.
Internal ids stay (ADR-0002). The patches (Tasks 0.3–0.6) carry these strings as `@loca` lines once approved.
LSTag ids marked `<NEW_…>` are the new entries' ids, fixed in the patches.

## A · The subclass (the old strings, new text)

| # | Handle (today) | Today | Draft |
|---|---|---|---|
| A1 | h8bcf3e57… · hf4767cea… · h869a34de… | The Unbound | **The Windborn** |
| A2 | h9a3184f7… (panel line) | The Unbound follows the Weave into the unknown, striking with open hands and moving air and never standing where an enemy expects. | The Windborn follows the Weave into the unknown, touching every foe once and riding the wind to the next. |
| A3 | hf756bce1… (class description) | Mystra wove the Unbound from the first step of every journey… slipping past every blow until the ground itself stops holding them down. | Mystra wove the Windborn from the first step of every journey, a thread that answers only to curiosity and the open road. They wear no armour and strike with open hands and moving air, carried from one foe to the next until the winds they gather break loose. |
| A4 | he3d63e7e… | Unbound's Robe | Windborn's Robe |
| A5 | hd9d08b83… | Arcane Spells: The Unbound | Arcane Spells: The Windborn |

Left as they are: three legacy *Nomadic Card* strings (h37f8a005…, hf235c001…, hb4e10045…) — no Windborn entry uses them
today; listed for the cleanup of `10.06`.

## B · The Open Road (the core rule, WB27)

| # | Entry | Field | Draft |
|---|---|---|---|
| B1 | `Arcana_Passive_FlowingStrikeZephyr` | DisplayName | The Open Road |
| B2 | 〃 | Description | Every enemy you hit, or that fails a `<LSTag Tooltip="SavingThrow">`Saving Throw`</LSTag>` against you, becomes `<LSTag Type="Status" Tooltip="<NEW_WINDSWEPT>">`Windswept`</LSTag>`. After an unarmed attack or a card, you can make a `<LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">`Zephyr Strike`</LSTag>` as a bonus action - against an enemy that isn't Windswept, the wind carries you to it. |
| B3 | 〃 | ExtraDescription | Windswept lasts until the end of your next turn. Windswept enemies can't make Opportunity Attacks.`<br><br>`Only active while not wearing armour or using a shield. |
| B4 | `<NEW_WINDSWEPT>` (status) | DisplayName | Windswept |
| B5 | 〃 | Description | Touched by the wind. Can't make Opportunity Attacks.`<br><br>`Suffers the bane of any wind the Windborn releases. |
| B6 | `Target_Arcana_Created_ZephyrStrike` (and its Rush twin) | Description | Ride the wind to an enemy it hasn't touched yet and strike it with an open hand. |
| B7 | 〃 | ExtraDescription | Against a Windswept enemy, you strike where you stand.`<br><br>`Gale: the strike pushes the target back.`<br>`Storm: after striking an enemy that wasn't Windswept, the wind can carry you to one more.`<br><br>`Can only be used while not wearing armour or using a shield. |
| B8 | `ZEPHYR_STRIKE` (status) | Description | You can make a Zephyr Strike as a bonus action this turn.`<br><br>`Equipping armour or a shield ends this effect. *(unchanged)* |
| B9 | `<NEW_STORM_RUSH>` (status + created card) | DisplayName · Description | Storm: The Wind Doesn't Stop · The wind can carry you to one more enemy that isn't Windswept this turn. |

## C · Aeolus' Bag and the winds (WB11–WB15, WB23)

| # | Entry | Field | Draft |
|---|---|---|---|
| C1 | `<NEW_BAG>` (container) | DisplayName | Aeolus' Bag |
| C2 | 〃 | Description | Untie the bag of winds and release one of them over the battle. It blows for 1 turn for each `<LSTag Type="Status" Tooltip="<NEW_WINDSWEPT>">`Windswept`</LSTag>` enemy, and every mark is swept away. |
| C3 | 〃 | ExtraDescription | While a wind blows, the bag stays shut, and at the start of your turn the wind sweeps every Windswept mark away. Your allies ride its tailwind; Windswept enemies face its headwind. |
| C4 | `<NEW_BAG_BOREAS>` | DisplayName · Description | Aeolus' Bag: Boreas · Release Boreas, the North Wind. Your allies move faster, and Windswept enemies are slowed. |
| C5 | `<NEW_BAG_NOTUS>` | DisplayName · Description | Aeolus' Bag: Notus · Release Notus, the South Wind. Rain and fog cloak your allies from ranged attacks, and Windswept enemies falter on their Saving Throws. |
| C6 | `<NEW_BAG_EURUS>` | DisplayName · Description | Aeolus' Bag: Eurus · Release Eurus, the East Wind. Your allies strike truer, and Windswept enemies' attacks go astray. |
| C7 | `<NEW_TAILWIND_BOREAS>` (ally) | DisplayName · Description | Tailwind: Boreas · Carried by the North Wind. Movement speed increased by [1]. |
| C8 | `<NEW_HEADWIND_BOREAS>` (enemy) | DisplayName · Description | Headwind: Boreas · Chilled by the North Wind. Movement speed reduced by [1]. |
| C9 | `<NEW_TAILWIND_NOTUS>` | DisplayName · Description | Tailwind: Notus · Cloaked by rain and fog. Ranged attacks against this creature have `<LSTag Tooltip="Disadvantage">`Disadvantage`</LSTag>`. |
| C10 | `<NEW_HEADWIND_NOTUS>` | DisplayName · Description | Headwind: Notus · Battered by the South Wind. [1] penalty to Saving Throws. |
| C11 | `<NEW_TAILWIND_EURUS>` | DisplayName · Description | Tailwind: Eurus · Steadied by the East Wind. [1] bonus to Attack Rolls. |
| C12 | `<NEW_HEADWIND_EURUS>` | DisplayName · Description | Headwind: Eurus · Buffeted by the East Wind. [1] penalty to Attack Rolls. |
| C13 | `<NEW_BAG_OPEN>` (on her) | DisplayName · Description | Aeolus' Bag: Untied · A wind blows over the battle. The bag can't be opened again until it stops. |
| C14 | `<NEW_HURRICANE>` (passive, 12) | DisplayName · Description | Hurricane · When you open Aeolus' Bag, you release two winds at once. |

## D · The Calm and Where the Winds Meet (WB25, WB26, WB46, WB48)

| # | Entry | Field | Draft |
|---|---|---|---|
| D1 | `<NEW_CALM>` | DisplayName | The Calm |
| D2 | 〃 | Description | Still the wind at once. Each turn it had left becomes a gust that strikes every `<LSTag Type="Status" Tooltip="<NEW_WINDSWEPT>">`Windswept`</LSTag>` enemy for [1], and the bag can be opened again. |
| D3 | 〃 | ExtraDescription | Can only be used while a wind blows. Every Windswept mark is swept away. |
| D4 | `<NEW_WINDS_MEET>` | DisplayName | Where the Winds Meet |
| D5 | 〃 | Description | Call the four winds to a single point. Enemies around it are pulled to its centre, take [1] and become `<LSTag Type="Status" Tooltip="<NEW_WINDSWEPT>">`Windswept`</LSTag>` and `<LSTag Type="Status" Tooltip="OFF_BALANCED">`Off Balance`</LSTag>`. |
| D6 | 〃 | ExtraDescription | Windswept enemies are pulled from farther away. A successful `<LSTag Tooltip="SavingThrow">`Dexterity Saving Throw`</LSTag>` halves the damage.`<br><br>`Can only be used while no wind blows. |

## E · The Awakening (WB22, WB24, WB45)

| # | Entry | Field | Draft |
|---|---|---|---|
| E1 | `Arcana_Passive_Aspect_Fool_Awakening` | Description | Release `<LSTag Type="Status" Tooltip="<NEW_WINDSWEPT>">`Windswept`</LSTag>` marks with the wind to awaken the Aspect of Curiosity until combat ends. Every mark the wind sweeps away counts - when you open the bag, at the start of each turn it blows, and with The Calm. Each goal you reach awakens one more tier.`<br><br>`Level 3: release 3 marks to gain `<LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_I">`The First Step`</LSTag>` and `<LSTag Type="Spell" Tooltip="<NEW_CALM>">`The Calm`</LSTag>`.`<br><br>`Level 7: release 5 marks to also gain `<LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_II">`Fellow Travellers`</LSTag>`.`<br><br>`Level 12: release 8 marks to awaken `<LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Fool_III">`Into the Storm`</LSTag>`.`<br><br>`The Awakening status shows how much is left to the next tier. |
| E2 | `Arcana_Passive_Aspect_Fool_I` · `_Awakened_I` | DisplayName · Description | The First Step · Once per turn, a Zephyr Strike that carries you to an enemy doesn't cost a bonus action. |
| E3 | `Arcana_Passive_Aspect_Fool_II` · `_Awakened_II` | DisplayName · Description | Fellow Travellers · Your allies' hits also make enemies Windswept. |
| E4 | `Arcana_Passive_Aspect_Fool_III` · `_Awakened_III` | DisplayName · Description | Into the Storm · Each time the wind sweeps the marks away, every swept enemy is pushed back [1] and becomes Off Balance. |
| E5 | `ASPECT_AWAKENED_FOOL_I–III` | Description | The tier texts above, cumulative as today (I; I + II; I + II + III), each ending "Only active while not wearing armour or using a shield." |

## F · Kept cards and passives (text changes only)

Every card below drops "Afterwards, you can make a Zephyr Strike as a bonus action." (WB27).

| # | Entry | Draft |
|---|---|---|
| F1 | Gale Burst | Channel the air into your fist and release it in a focused burst, launching your target backwards [1] and knocking it `<LSTag Type="Status" Tooltip="PRONE">`Prone`</LSTag>`. |
| F2 | Wind Blast | Bend the air to unleash a strong gust of wind that clears clouds and pushes creatures back [1], leaving them `<LSTag Type="Status" Tooltip="OFF_BALANCED">`Off Balance`</LSTag>`. |
| F3 | Flow State | Enter a temporary state of flow where you gain temporary hit points and an additional bonus action. |
| F4 | Wind Whispers | You can sense movement in the air. Attack Rolls against you have Disadvantage, your next unarmed attack has Advantage, and when an enemy's melee attack misses you, you strike back with an unarmed attack. |
| F5 | Storm Fists | The wind flows through your hands. Your unarmed attacks deal an additional [1] against enemies that aren't `<LSTag Type="Status" Tooltip="<NEW_WINDSWEPT>">`Windswept`</LSTag>`. |
| F6 | Untethered | Freed from earthly ties, gain the ability to Fly. While you fly, the air wraps around you and protects you. |
| F7 | Ready: Gale Deflection · Gale Deflection | ...If the damage is reduced to 0, you can hurl the missile back at your attacker, who becomes Windswept. You can also catch a missile aimed at an ally within [1]. |
| F8 | Leap of Faith | Dash through the fray, striking every creature in your path with an unarmed attack that also deals [1]. Every enemy you strike becomes Windswept. |
| F9 | Be the Leaf | Your reflexes are as effective as armour. You add your Intelligence `<LSTag Tooltip="AbilityModifier">`Modifier`</LSTag>` to your Armour Class. |
| F10 | Weightless (rank 1–4; was Twinkle Toes / Feather Fall) | DisplayName: Weightless · Description: You move as if the air carried you. Your movement speed increases by [1]. *(ranks 2–4 add:)* Your jumps reach [2] as far and you take only half Falling damage. *(rank 4:)* You are Immune to Falling damage. |

## G · Removed with their entries (no text): True Strike from the subclass, Evasive Flow, Thunderclap, Momentum, Eye of the Storm, Twinkle Toes, Feather Fall, Wanderlust / Restless Wind / Aspect of Curiosity / Fool's Luck texts.

## H · Addendum (Task 0.5, 2026-10-17) — texts the draft did not have; Owner check pending

| # | Entry | Text |
|---|---|---|
| H1 | `Arcana_Passive_Zephyr_Gale` | **Zephyr Strike: Gale** · The wind grows. Your Zephyr Strike pushes the target back [1] and carries you farther, the bag's winds blow longer, and Eurus joins Aeolus' Bag. |
| H2 | `Arcana_Passive_Zephyr_Storm` | **Zephyr Strike: Storm** · The wind doesn't stop. After a Zephyr Strike carries you to an enemy, the wind can carry you to one more, and the bag's winds blow longer. |
| H3 | `STORM_FISTS` (status) | The wind flows through your hands. Unarmed attacks deal an additional [1] against enemies that aren't Windswept. |
| H4 | `Interrupt_Arcana_Reaction_GaleDeflection` | Reduce the damage of a ranged weapon attack against you or an ally within [1] by 1d10 + your Dexterity Modifier + your Arcana level. If the damage is reduced to 0, you can hurl the missile back at your attacker. |
| H5 | Weightless (F10, wording) | "your jumps reach [2] times as far" (F10 had "reach [2] as far", which reads wrongly with a number) |
