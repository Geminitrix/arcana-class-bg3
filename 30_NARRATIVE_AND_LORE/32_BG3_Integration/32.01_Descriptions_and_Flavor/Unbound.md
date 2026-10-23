---
id: 32.01/Unbound
owner: Lore Writer
source: game loca (51 Mods/…/Localization/English/english.xml) + Stats ids, extracted 2026-10-23 with dossier_texts.pl (after the Owner's Toolkit build, commit 60afc0e); 21.04/Unbound/DESIGN.md §11; DECISIONS.md WB0, WB27–WB44, WB51–WB62
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); names of the build (WB44) at the end; 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — WB49 (QA-0004 probe outcomes) checked, no change; 2026-10-17 ARC-0026 — P8 fix applied, no change; 2026-10-17 ARC-0026 — stage 1 complete, WB50 checked, no change; 2026-10-17 ARC-0026 — stage 2 applied, no change; 2026-10-17 ARC-0026 — Toolkit guides per level (the Owner types), no change; retired entries kept (OR-10); 2026-10-18 ARC-0026 — WB51 (rebuild from zero, OR-59 ids) checked, no change; 2026-10-23 ARC-0026 — regenerated from the Owner's Toolkit build; review notes rewritten (WB62); 2026-10-23 ARC-0026 — WB63 (names kept as in the game; Gale Deflection once a turn) and the WB62 fixes applied (dbc714b)
---

# 32.01 · Player-facing text — The Windborn (internal: Unbound)

Every name and description the player reads, **as it is in the game today** (the Owner's Toolkit build, ARC-0026;
English; `[n]` are the game's parameters, numbers come from `25`). The other languages follow Localization. Polishing
the English waits for the end of the rework (ARC-0006); voice and style: `31.03`.

## Review notes (Lore Writer, 2026-10-23)

The 2026-10-17 notes were applied by the build (The Open Road, Be the Leaf on Intelligence, Weightless, the tiers, the
retired pieces). **Applied on 2026-10-23** (`[fechado] ARC-0026`, `dbc714b`; WB62, exact edits in `SPEC_ARC-0026` "Fixes owed") — kept as the
record; the tables below are re-read from the game after the fix:

| Text | Issue | Fix |
|---|---|---|
| `Rush_Arcana_Created_ZephyrRush`, `Rush_Arcana_Created_ZephyrRush_Storm`, `WINDSWEPT` (×2 handles) | "Weast Wind" | "West Wind" |
| Aeolus' Bag (description) | "Winswept" | "Windswept" |
| `Arcana_Passive_WindWhispers` | Name "Whind Whispers" | "Wind Whispers" |
| `Target_Arcana_Created_UnleashedWinds` | Name "Unleash Winds" | "Unleashed Winds" (WB56) |
| `Target_Arcana_Created_ZephyrStrike` | Shows "Zephyr Rush": it uses the Rush's name handle | Its own handle "Zephyr Strike" (WB51) |
| Ready: Gale Deflection, Zephyr: Tempest, Gale Deflection: Redirect | "the West wind" | "the West Wind" (WB61) |
| Aeolus' Bag: Eurus and Boreas | "the South and North Winds" | "the East and North Winds" |
| Aeolus' Bag: Notus and Eurus | "Your gain protection" | "Your allies gain protection" |
| `Interrupt_Arcana_Reaction_GaleDeflection` | The old text ("a ranged weapon attack") | As the passive: "…ranged weapon attacks made by non-Windswept enemies…" (WB57) |
| The Open Road | "Every enemy you hit, becomes Windswept." — stray comma; leaves out failed saves | "Enemies you hit, or that fail a saving throw against you, become Windswept." |
| Zephyr | "After making an attack while unarmed…" leaves out the Arcane cards (WB3) | "After an unarmed attack or an Arcane card, …" |
| `Arcana_Passive_WindWhispers`, `Arcana_Passive_ZephyrTempest`, `ZEPHYR_STRIKE`, `ZEPHYR_RUSH_STORM`, `BAG_READY` | Description "### EMPTY" | Empty (hidden) or one line |
| `GALE_DEFLECTION_USED_TECH`, `INTERRUPT_GALE_DEFLECT_MISSILES_HIT` | Technical statuses with a visible name | Hide them, or give no name |
| `Interrupt_Arcana_Aspect_FoolsLuck` (Fool's Luck) | Retired (WB24) but its entry remains | Kept unreachable (OR-10); nothing grants it |
| Class name | Both "The Windborn" and "The Unbound" in the loca | The Windborn (WB0); the old string stays for the old handle only |

## Spells and cards

| Internal id | Name | Description |
|---|---|---|
| `Projectile_Arcana_Reaction_GaleDeflection` | Gale Deflection: Redirect | Use the West Wind to catch a projectile from a ranged weapon attack and shoot it back at your attacker. |
| `Rush_Arcana_Created_ZephyrRush` | Zephyr Rush | Ride the West Wind to an enemy that isn't Windswept yet and strike it with an open hand. |
| `Rush_Arcana_Created_ZephyrRush_Storm` | Zephyr Rush: Storm | The West Wind can carry you to any enemy this turn. |
| `Shout_Arcana_Created_AeolusBag` | Aeolus' Bag | Untie the bag of winds and release one of them over the battle. It blows for 1 turn for each Windswept enemy, and every mark is swept away. |
| `Shout_Arcana_Created_AeolusBag_Boreas` | Aeolus' Bag: Boreas | Release Boreas, the North Wind. Your allies move faster, and Windswept enemies are slowed. |
| `Shout_Arcana_Created_AeolusBag_Notus` | Aeolus' Bag: Notus | Release Notus, the South Wind. Rain and fog cloak your allies from ranged attacks, and Windswept enemies falter on their Saving Throws. |
| `Shout_Arcana_Created_AeolusBag_Eurus` | Aeolus' Bag: Eurus | Release Eurus, the East Wind. Your allies strike truer, and Windswept enemies' attacks go astray. |
| `Shout_Arcana_Created_AeolusBag_BoreasNotus` | Aeolus' Bag: Boreas and Notus | Release both Boreas and Notus, the North and South Winds. Your allies move faster and gain protection against ranged attacks, while Windswept enemies are slowed and falter on their Saving Throws. |
| `Shout_Arcana_Created_AeolusBag_NotusEurus` | Aeolus' Bag: Notus and Eurus | Release both Notus and Eurus, the South and East Winds. Your allies gain protection against ranged attacks and strike truer, while Windswept enemies falter on their Saving Throws and their attacks go astray. |
| `Shout_Arcana_Created_AeolusBag_EurusBoreas` | Aeolus' Bag: Eurus and Boreas | Release both Eurus and Boreas, the East and North Winds. Your allies move faster and their attacks strike truer, while Windswept enemies are slowed and their attacks go astray. |
| `Shout_Arcana_Created_TheCalm` | The Calm | Still the wind at once. Each turn it had left becomes a gust that strikes every Windswept enemy for [1], and the bag can be opened again. |
| `Shout_Arcana_Card_Passive_GaleDeflection` | Ready: Gale Deflection | Pull a thread of the West Wind back into your reach. Until combat ends, you gain Gale Deflection and one use of it per turn. |
| `Shout_Arcana_Card_Spell_FlowState` | Flow State | Enter a temporary state of flow where you gain temporary hit points, and an additional bonus action. |
| `Shout_Arcana_Card_Spell_WindWhispers` | Wind Whispers | Attack Rolls against you from non-Windswept enemies have Disadvantage. When their attack misses, you can use your reaction to strike back with an unarmed attack. Additionally, jumping no longer requires a bonus action. |
| `Shout_Arcana_Card_Spell_ZephyrTempest` | Zephyr: Tempest | The West Wind flows through your hands, causing your unarmed attacks against Windswept enemies to deal an additional [1] and inflict [2] turns of Reverberation. |
| `Shout_Arcana_Card_Spell_ZephyrTempestAlly` | Zephyr: Ally Tempest | The West Wind joins the fight to help your allies, causing their weapon attacks against Windswept enemies to deal an additional [1] and inflict [2] turn of Reverberation. |
| `Shout_Arcana_Card_Ability_Untethered` | Untethered | Freed from earthly ties, gain the ability to Fly. |
| `Target_Arcana_Created_ZephyrStrike` | Zephyr Strike | Swiftly strike an enemy as a bonus action. |
| `Target_Arcana_Card_Spell_GaleBurst` | Gale Burst | Channel the air into your fist and release it in a focused burst, launching your target backwards [1] and knocking it Prone. |
| `Target_Arcana_Created_UnleashedWinds` | Unleashed Winds | Unleash the four winds to possibly scatter enemies, pulling Windswept enemies [1] to its centre, and pushing back non-Windswept enemies [1], leaving all of them Off Balance. |
| `Zone_Arcana_Card_Spell_WindBlast` | Wind Blast | Unleash a strong gust of the West Wind that clears clouds and possibly pushes enemies back [1], marking them with Windswept and leaving them Off Balance. |

## Passives

| Internal id | Name | Description |
|---|---|---|
| `Arcana_Passive_BetheLeaf` | Be the Leaf | Your reflexes are as effective as armour. You add your Intelligence Modifier to your Armour Class. |
| `Arcana_Passive_TheOpenRoad` | The Open Road | Enemies you hit, or that fail a saving throw against you, become Windswept. |
| `Arcana_Passive_Zephyr` | Zephyr | After an unarmed attack or an Arcane card, you can make a Zephyr Strike or a Zephyr Rush as a bonus action. |
| `Arcana_Passive_Zephyr_Gale` | Zephyr: Gale | The West Wind grows. Your Zephyr Strike pushes the target back [1], the bag's winds blow longer, and Eurus joins Aeolus' Bag. |
| `Arcana_Passive_Zephyr_Storm` | Zephyr: Storm | The West Wind doesn't stop. After a Zephyr Rush carries you to an enemy, the wind can carry you to one more, and the bag's winds blow longer. |
| `Arcana_Passive_Zephyr_Hurricane` | Zephyr: Hurricane | When you open Aeolus' Bag, you release two winds at once. |
| `Arcana_Passive_AeolusBag` | Aeolus' Bag |  |
| `Arcana_Passive_MagicStrikes` | Magic Strikes | Your unarmed attacks count as magical, ignoring Resistance and Immunity to non-magical damage. |
| `Arcana_Passive_WindWhispers` | Wind Whispers |  |
| `Arcana_Passive_EmptyState` | Empty State | When a Windswept enemy hits you with an attack, you take only half damage. If they force you to make a Dexterity Saving Throw, you take no damage on a successful save, and only half damage on a failed one. |
| `Arcana_Passive_GaleDeflection` | Gale Deflection | Use your reaction to reduce the damage from ranged weapon attacks made by non-Windswept enemies by 1d10 + your Dexterity Modifier + your Arcana level. If the damage is reduced to 0, you can Deflect the Missile. |
| `Arcana_Passive_ZephyrTempest` | Zephyr: Tempest |  |
| `Arcana_Passive_Aspect_Fool_Awakening` | 0 - The Fool: Awakening | Release Windswept marks with the wind to awaken the Aspect of Curiosity until combat ends. Every mark the wind sweeps away counts - when you open the bag, at the start of each turn it blows, and with The Calm. Each goal you reach awakens one more tier.Level 3: release 3 marks to gain The First Step and The Calm.Level 7: release 5 marks to also gain Fellow Travellers.Level 12: release 8 marks to gain Into the Storm.The Awakening status shows how much is left to the next tier. |
| `Arcana_Passive_Aspect_Fool_I` | The First Step | The first Zephyr Rush that carries you to an enemy doesn't cost a bonus action this turn. |
| `Arcana_Passive_Aspect_Fool_II` | Fellow Travellers | Your allies' hits also make enemies Windswept. |
| `Arcana_Passive_Aspect_Fool_III` | Into the Storm | Each time the wind sweeps the marks away, every swept enemy is pushed back [1] and becomes Off Balance. |

## Statuses

| Internal id | Name | Description |
|---|---|---|
| `WINDSWEPT` | Windswept | Touched by the West Wind. Can't make Opportunity Attacks. Suffers the bane of any wind the Windborn releases. |
| `ZEPHYR_STRIKE` | Zephyr Strike |  |
| `ZEPHYR_RUSH` | Zephyr Rush |  |
| `ZEPHYR_RUSH_STORM` | Storm: The Wind Doesn't Stop |  |
| `BAG_READY` | Aeolus' Bag |  |
| `BAG_OPEN` | Aeolus' Bag: Untied | A wind blows over the battle. The bag can't be opened again until it stops. |
| `TAILWIND_BOREAS` | Tailwind: Boreas | Carried by the North Wind. Movement speed increased by [1]. |
| `HEADWIND_BOREAS` | Headwind: Boreas | Chilled by the North Wind. Movement speed reduced by [1]. |
| `TAILWIND_NOTUS` | Tailwind: Notus | Cloaked by the South Wind. Ranged attacks against this creature have Disadvantage. |
| `HEADWIND_NOTUS` | Headwind: Notus | Battered by the South Wind. 1d4 penalty to Saving Throws. |
| `TAILWIND_EURUS` | Tailwind: Eurus | Steadied by the East Wind. 1d4 bonus to Attack Rolls. |
| `HEADWIND_EURUS` | Headwind: Eurus | Buffeted by the East Wind. 1d4 penalty to Attack Rolls. |
| `WIND_BOREAS` | Aeolus' Bag: Boreas |  |
| `WIND_NOTUS` | Aeolus' Bag: Notus |  |
| `WIND_EURUS` | Aeolus' Bag: Eurus |  |
| `INTO_THE_STORM` | Into the Storm | Each time the wind sweeps the marks away, every swept enemy is pushed back [1] and becomes Off Balance. |
| `ASPECT_AWAKENED_FOOL` | 0 - The Fool | Awakened as the Aspect of Curiosity until combat ends. |
| `ASPECT_AWAKENED_FOOL_I` | 0 - The Fool: Awakened I | The First Step: The first Zephyr Rush that carries you to an enemy doesn't cost a bonus action this turn. |
| `ASPECT_AWAKENED_FOOL_II` | 0 - The Fool: Awakened II | The First Step: The first Zephyr Rush that carries you to an enemy doesn't cost a bonus action this turn.Fellow Travellers: Your allies' hits also make enemies Windswept. |
| `ASPECT_AWAKENED_FOOL_III` | 0 - The Fool: Awakened III | The First Step: The first Zephyr Rush that carries you to an enemy doesn't cost a bonus action this turn.Fellow Travellers: Your allies' hits also make enemies Windswept.Into the Storm: Each time the wind sweeps the marks away, every swept enemy is pushed back [1] and becomes Off Balance. |
| `WIND_WHISPERS` | Wind Whispers | Non-Windswept enemies' Attack Rolls against you have Disadvantage. When a melee attack misses, strikes back with an unarmed attack as a reaction.Jumping no longer requires a bonus action. |
| `GALE_DEFLECTION_READY` | Gale Deflection | Use your reaction to reduce the damage from ranged weapon attacks made by non-Windswept enemies by 1d10 + your Dexterity Modifier + your Arcana level. If the damage is reduced to 0, you can Deflect the Missile. |
| `GALE_DEFLECTION_USED_TECH` | Gale Deflection |  |
| `GALE_DEFLECT_MISSILES` | Gale Deflect Missiles | You can use your reaction to deflect the missiles from ranged weapon attacks. When you do so, the damage is reduced by 1d10 + [1] + your Arcana level. |
| `FLOW_STATE` | Flow State | You gained [1] and an additional bonus action. |
| `ZEPHYR_TEMPEST` | Zephyr: Tempest | Your unarmed attacks against Windswept enemies deal an additional [1] and inflict [2] turns of Reverberation. |
| `ZEPHYR_TEMPEST_ALLY` | Zephyr: Ally Tempest | Your weapon attacks against Windswept enemies deal an additional [1] and inflict [2] turns of Reverberation. |
| `FLY_UNTETHERED` | Fly | Can Fly to a target position. |
| `INTERRUPT_GALE_DEFLECT_MISSILES_HIT` | INTERRUPT_GALE_DEFLECT_MISSILES_HIT |  |

## Reactions

| Internal id | Name | Description |
|---|---|---|
| `Interrupt_Arcana_Reaction_GaleDeflection` | Gale Deflection | Reduce the damage from a ranged weapon attack made by a non-Windswept enemy by 1d10 + your Dexterity Modifier + your Arcana level.If the damage is reduced to 0, you use an Arcane Card to Deflect the Missile. |
| `Interrupt_Arcana_Reaction_GaleDeflection_Return` | Gale Deflection: Redirect | Bend the air around a projectile from a ranged weapon attack and hurl it back to the attacker. |
| `Interrupt_Arcana_WindWhispers_Riposte` | Wind Riposte | Swiftly strike an enemy as a reaction. |
| `Interrupt_Arcana_Aspect_FoolsLuck` | Fool's Luck | Once per round, the first attack against you misses. |

## Names (WB44, WB61) — in the game since the Owner's build

| Piece | Name | Replaced |
|---|---|---|
| Core passive | **The Open Road**; the Zephyr passive **Zephyr**, ranks **Zephyr: Gale · Storm · Hurricane** | Flowing Strikes: Zephyr |
| Mark (status) | **Windswept** | — (new) |
| Signature | **Zephyr Strike** · **Zephyr Rush** · **Zephyr Rush: Storm** | Zephyr Strike |
| Movement passive | **Twinkle Toes** (WB63; designed as Weightless) | Feather Fall |
| Ultimate | **Aeolus' Bag** — winds **Boreas** (the North Wind), **Notus** (the South Wind), **Eurus** (the East Wind) | — (new) |
| Aspect card | **The Calm** | Leap of Faith (as Aspect card) |
| Capstone | **Unleashed Winds** (WB56) | Where the Winds Meet (never built) |
| Level 7 · level 10 cards | **Zephyr: Tempest** · **Zephyr: Ally Tempest** (WB54, WB55) | Storm Fists · Leap of Faith |
| Tiers I · II · III | **The First Step · Fellow Travellers · Into the Storm** | Wanderlust · Restless Wind · Aspect of Curiosity |
| Kept | Gale Burst, Wind Blast, Wind Whispers, Flow State, Ready: Gale Deflection, Untethered, Be the Leaf, Agility, Precision, Extra Attack (vanilla, WB63), Magic Strikes, Empty State | — |
| Subclass | **The Windborn** | The Unbound |
| Voice | Zephyrus is **the West Wind** (WB61) | — |
