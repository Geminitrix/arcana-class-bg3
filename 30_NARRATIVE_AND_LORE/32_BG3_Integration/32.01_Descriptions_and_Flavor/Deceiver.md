---
id: 32.01/Deceiver
owner: Lore Writer
source: game loca (51 Mods/…/Localization/English/english.xml) + Stats ids, extracted 2026-10-16 with dossier_texts.pl; 21.04/Deceiver/DESIGN.md §11; DECISIONS.md DV29
reviewed: 2026-10-16 ARC-0019 — created (propagation, 00.08); names of the build (DV29) at the end; 2026-10-16 ARC-0019 — DV32 checked, no change; 2026-10-16 ARC-0020 — the build's texts drafted in `55/_wip/Deceiver/arc0020/10_names.patch`, Narrative gate passed (32.04/ARC-0020_Deceiver.md); 2026-10-16 ARC-0021 — display name *Veilwalker* (DV33)
---

# 32.01 · Player-facing text — The Veilwalker (internal: Deceiver)

Every name and description the player reads, **as it is in the game today** (the Veil build of 2026-10-07; English;
`[n]` are the game's parameters, numbers come from `25`). The 15 other languages do not have these strings yet
(Localization). Polishing the English waits for the end of the rework (ARC-0006); voice and style: `31.03`.

## Review notes (Lore Writer, 2026-10-16)

| Text | Issue | Fix (with the ARC-0019 build — game text) |
|---|---|---|
| Five LeBlanc names and the Doubles' Shatter | Replaced by DV29 | Rename as in the table at the end; every description that names them follows |
| *Doubt* passive | Folded into The Veil (DV19) | The Veil's description carries the core rule in one sentence: *every lie an enemy believes plants Doubt; at the third, it is Deluded* |
| *Aspect of Doubt* (Tier III) and `ASPECT_AWAKENED_EMPRESS_III` | Say +Charisma and Charisma to damage; DV21 replaces both | "A Double destroyed by an enemy splinters by itself, and every Splinter reaches farther. You can use Ready: Which One? until combat ends." |
| *Grand Deception* | Says "possibly fill the mind… with Doubt"; DV22 reads the Doubles near each enemy | Name the rule: each enemy that fails gains Doubt for each of your Doubles near it |
| *Mirrored Self* (passive) | Says two creatures; DV25 casts the second from a Double | Rewrite after V4 decides the engine path |
| *Double of the Veil* status | No description | One line: an illusion of the Deceiver, 1 hit point, gone when struck |
| Two Pillars (`Arcana_Passive_Aspect_Empress_II`) | "unmarked enemy … gains your Sigil" | "…an enemy without a Seed … gains your Seed" |
| Narrative gate | No approval recorded in `32.04` for these texts | Record it when the build's texts are written |

## Spells and cards

| Internal id | Name | Description |
|---|---|---|
| `Projectile_Arcana_Card_Spell_SigilofMalice` | Sigil of Malice | Hurl a surge of arcane force at a creature, dealing [1] and marking it with a Sigil. |
| `Projectile_Arcana_Created_MimicSigilofMalice` | Mimic: Sigil of Malice | Recast Sigil of Malice at a creature, dealing [1] and marking it with a Sigil. |
| `Projectile_Deceiver_Double_MirrorSigil` | Mirror: Sigil of Malice | Hurl a sliver of Sigil of Malice at a creature, dealing [1] and marking it with the Deceiver's Sigil. |
| `Shout_Arcana_Util_Faceless` | Faceless | Assume the identity of another person, altering your appearance. |
| `Shout_Arcana_Card_Passive_MirroredCharm` | Mirrored Self | Split your reflection across the Weave. You gain Mirrored Self until the end of your turn. |
| `Shout_Arcana_Created_Withdraw` | Withdraw | Swap places with the Double you left behind. |
| `Shout_Arcana_Card_Passive_MirroredSpell` | Mirrored Spell | Every spell woven near you leaves its reflection on Mystra's Weave. Until your next Long Rest or until combat ends, you gain Mirrored Spell. |
| `Shout_Arcana_Card_Spell_GrandDeception` | Grand Deception | Surround yourself with Doubles until you reach your limit, and possibly fill the mind of every nearby enemy with Doubt. |
| `Shout_Deceiver_Double_Shatter` | Shatter | Burst in a flash of illusory glass, dealing [1] to enemies within [2] and sowing Doubt in their minds. The Double is destroyed. |
| `Shout_Arcana_Created_Aspect_VeilLifts` | The Veil Lifts | Lift the veil all at once: every one of your Doubles shatters and every Sigil you laid detonates. Surviving enemies with Doubt become Deluded. |
| `Shout_Arcana_Card_Passive_WhichOne` | Ready: Which One? | Until combat ends, once per round, when an attack is about to hit you, you can use your reaction to swap places with your nearest Double. The attack misses, the Double is destroyed in your place and the attacker gains Doubt. |
| `Target_Arcana_Card_Spell_MaliciousWhispers` | Malicious Whispers | Invade a creature's mind with malicious whispers, imposing Disadvantage on its next Attack Roll. A creature marked with your Sigil also suffers Paranoia and gains Doubt. |
| `Target_Arcana_Card_Spell_MirrorImage` | Mirror Image | Summon a Double of the Veil: an illusion of you with 1 hit point that acts on its own turn and can Shatter. |
| `Target_Arcana_Util_Friends` | Friends | Gain Advantage on Charisma Checks against a non-hostile creature. |
| `Target_Arcana_Card_Spell_EtherealChains` | Ethereal Chains | Bind a creature with Ethereal Chains. At the end of its turn, it becomes Restrained. |
| `Target_Arcana_Created_MimicEtherealChains` | Mimic: Ethereal Chains | Recast Ethereal Chains on a creature. At the end of its turn, it becomes Restrained. |
| `Target_Arcana_Card_Spell_VeiledPrison` | Veiled Prison | Trap a creature behind a veil in its own mind, preventing movement, actions and reactions. Attacks from within [1] are always Critical Hits. |
| `Target_Arcana_Card_Spell_Distortion` | Distortion | Dash through space, dealing damage where you arrive, and leave a Double standing where you were. For 2 turns, you can cast Withdraw to swap places with it. |
| `Target_Arcana_Card_Spell_Marionette` | Marionette | Manipulate a creature's reality, forcing it to fight alongside you. Each time it takes damage, it must succeed a Wisdom Saving Throw or break free. |
| `Target_Arcana_Created_Mimic` | Mimic | Recast your last damaging Arcane spells as a bonus action, once per turn. |
| `Target_Deceiver_Double_MirrorChains` | Mirror: Ethereal Chains | Bind a creature with a weakened Ethereal Chains. If it fails the Saving Throw, it takes [1] and becomes Restrained for [2]. |
| `Target_Deceiver_Double_Unveil` | Unveil | Swap places with the Deceiver. |

## Passives

| Internal id | Name | Description |
|---|---|---|
| `Arcana_Passive_Doubt` | Doubt | Your illusions and whispers make enemies doubt what is real. An enemy gains Doubt when it destroys one of your Doubles, when a Shatter hits it, when your Sigil detonates on it, when Malicious Whispers hits it while marked and when it fails to resist Grand Deception.Each stack reduces its Wisdom Saving Throws and its Attack Rolls against you and your Doubles by 1. At 3 stacks it becomes Deluded. |
| `Arcana_Passive_TheVeil` | The Veil | Mirror Image and Distortion summon Doubles: illusions of you with 1 hit point that act on their own turn and can Shatter. You can keep 3 Doubles at once, 4 from level 7 and 5 from level 12, and you gain +1 Armour Class for each one.Your Doubles vanish when combat ends, after a Long Rest or if you die. |
| `Arcana_Passive_TwoTruths` | Two Truths | Your Doubles can also cast Mirror: Sigil of Malice and Mirror: Ethereal Chains. Both deal half the damage of your Sigil of Malice at your highest spell slot. |
| `Arcana_Passive_Unveil` | Unveil | Your Doubles can also cast Unveil to swap places with you. Only one Double can do so each round. |
| `Arcana_Passive_MirroredCharm` | Mirrored Self | You have mastered the art of mirrors. Arcane spells that normally target only one creature can instead target two creatures. |
| `Arcana_Passive_WhichOne` | Which One? | Once per round, when an attack is about to hit you, you can use your reaction to swap places with your nearest Double. The attack misses and the Double is destroyed in your place. |
| `Arcana_Passive_Aspect_Empress_Awakening` | 2 - The High Priestess: Awakening | Sow Doubt in your enemies during a fight to awaken the Aspect of Doubt until combat ends. Each goal you reach awakens one more tier.Level 3: apply 4 stacks of Doubt to gain Veiled.Level 7: apply 7 stacks of Doubt to also gain Two Pillars.Level 12: apply 10 stacks of Doubt to awaken as the Aspect of Doubt.The Awakening status shows how much is left to the next tier. |
| `Arcana_Passive_Aspect_Empress_I` | Veiled | Enemies with Doubt have Disadvantage on Attack Rolls against you and your Doubles. |
| `Arcana_Passive_Aspect_Empress_II` | Two Pillars | Once per turn, when an enemy becomes Deluded, the nearest unmarked enemy within [1] of it gains your Sigil. |
| `Arcana_Passive_Aspect_Empress_III` | Aspect of Doubt | Your Charisma increases by [1] and your Arcane spells add your Charisma Modifier to their damage. You can use Ready: Which One? until combat ends. |

## Statuses

| Internal id | Name | Description |
|---|---|---|
| `SIGIL` | Sigil | The affected entity is marked by the Deceiver and takes additional [1] from their Arcane spells. Triggering the mark also inflicts Doubt. |
| `WHISPERED_PARANOIA` | Paranoia | Malicious Whispers on a creature marked with a Sigil. Can't take reactions. |
| `ETHEREAL_CHAINS` | Ethereal Chains | The affected entity is bound by ethereal chains that deal [1] twice and cause it to become Restrained at the end of its turn. |
| `DOUBLE_OF_THE_VEIL` | Double of the Veil |  |
| `ASPECT_AWAKENED_EMPRESS_I` | 2 - The High Priestess: Awakened I | Veiled: Enemies with Doubt have Disadvantage on Attack Rolls against you and your Doubles. |
| `ASPECT_AWAKENED_EMPRESS_II` | 2 - The High Priestess: Awakened II | Veiled: Enemies with Doubt have Disadvantage on Attack Rolls against you and your Doubles.Two Pillars: Once per turn, when an enemy becomes Deluded, the nearest unmarked enemy within [1] of it gains your Sigil. |
| `ASPECT_AWAKENED_EMPRESS_III` | 2 - The High Priestess: Awakened III | Veiled: Enemies with Doubt have Disadvantage on Attack Rolls against you and your Doubles.Two Pillars: Once per turn, when an enemy becomes Deluded, the nearest unmarked enemy within [1] of it gains your Sigil.Aspect of Doubt: Your Charisma increases by [2], your Arcane spells add your Charisma Modifier to their damage, and you can use Ready: Which One?. |
| `DELUDED` | Deluded | Confused by illusions that cannot be told from the real thing. Acts at random and may lose its turn.At the start of each turn, can end the effect with a Wisdom Saving Throw. |
| `VEILED_PRISON` | Veiled Prison | Lost behind a veil in its own mind. Can't move, act or react. Automatically fails Strength and Dexterity Saving Throws, and attacks from within [1] are always Critical Hits.At the end of each turn, can end the effect with a Wisdom Saving Throw, made with Disadvantage while it has 2 or more stacks of Doubt. |

## Reactions

| Internal id | Name | Description |
|---|---|---|
| `Interrupt_Arcana_Aspect_WhichOne` | Which One? | Swap places with your nearest Double: the attack misses, the Double is destroyed in your place and the attacker gains Doubt. |

## Names after the ARC-0019 build (DV29, approved 2026-10-16)

Internal ids keep their names until the build decides (DV12's rule).

| Internal id | Name today | Name after the build |
|---|---|---|
| `Target_Arcana_Card_Spell_MirrorImage` | Mirror Image | **Eidolon** |
| `Projectile_Arcana_Card_Spell_SigilofMalice` | Sigil of Malice | **Seed of Doubt** |
| `SIGIL` | Sigil | **Seed** |
| `Target_Arcana_Card_Spell_Distortion` | Distortion | **Veilstep** |
| `Target_Arcana_Card_Spell_EtherealChains` · `ETHEREAL_CHAINS` | Ethereal Chains | **Binding Falsehood** |
| `Target_Arcana_Created_Mimic` | Mimic | **Twice-Told** |
| `…_Created_Mimic<Card>` | Mimic: <Card> | **Twice-Told: <new card name>** (e.g. *Twice-Told: Veilstep*) |
| `Shout_Deceiver_Double_Shatter` | Shatter | **Splinter** |
| `Projectile_Deceiver_Double_MirrorSigil` | Mirror: Sigil of Malice | **Reflected Seed** |
| `Target_Deceiver_Double_MirrorChains` | Mirror: Ethereal Chains | **Reflected Falsehood** |
| — (new, DV24) | — | **Splinter on command** (DV31) |
| `Arcana_Passive_Doubt` | Doubt | leaves (DV19) — *Doubt* stays as the status name |
| Telepathy (level 1) | Telepathy | leaves the Deceiver (DV26) |
