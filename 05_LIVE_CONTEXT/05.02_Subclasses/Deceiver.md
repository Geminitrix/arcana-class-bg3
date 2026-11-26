---
source: 51 (Progressions, Lists, Stats, Story) — carried over from the pre-migration knowledge base
synced_at: 2026-11-25 (ARC-0020 build: the Owner's Stats, lists and progression of TOOLKIT_ARC-0020; Claude's goal split DV36; levels from dump_progression.pl)
state: synced
reviewed: 2026-10-16 ARC-0019 — DV32 checked, no change (game unchanged); 2026-10-16 ARC-0020 — sizes approved (25), names patch drafted; no change; 2026-10-16 ARC-0021 — display name checked, no change; 2026-10-16 ARC-0020 — Task 0.5 prepared (Splinter on Command), no change; 2026-10-16 ARC-0020 — Tasks 0.6–0.7 prepared, no change; 2026-10-16 ARC-0020 — stage 1 applied (names in game), no change; 2026-11-25 ARC-0020 — level map v2 (DV35) checked, no change; 2026-11-25 ARC-0020 — build kit checked, no change (game unchanged); 2026-11-25 ARC-0020 — the build in the game (map v2, Tier III burst, Grand Deception, Splinter on Command, goals split)
---

# 🪞 The Veilwalker (internal: Deceiver) — II · The High Priestess · Aspect of Doubt

> **In game since 2026-11-25 (ARC-0020 build, not yet played):** the map of DV35 (something at every level 1–12; Telepathy
> and the *Doubt* passive out of the progression), *Splinter on Command*, the Tier III burst (no Charisma), Grand Deception
> reading the Doubles, and the Osiris goals one per feature (DV36). *Mirrored Self* from a Double (DV25) is deferred.
>
> Last verified: **2026-11-25** (ARC-0020 build, levels by `dump_progression.pl`; numbers of the Veil build last re-checked 2026-10-07) · Progression table `8fe1f693-d8ff-4b02-a655-efd4acbc04cb` ·
> Lists "Veilwalker Level N" · Osiris `ARCANA_Deceiver_TheVeil` · `_Doubt` · `_Splinter` · `_SplinterOnCommand` · `_SeedOfDoubt` ·
> `_Veilstep` · `_TwiceTold` · `_GrandDeception` · `_MirroredSpell` · `_Faceless`, Aspect `ARCANA_Aspect_HighPriestess` (Stats ids keep
> *Empress*) · Design `21.04_Subclasses/Deceiver/DESIGN.md` (approved DV1–DV36, built by ARC-0020, in playtest — this file stays the game as it is; the old spec is in `90/93/2026-10-16_ARC-0019_deceiver_veil_design/`)
> (D1–D17) · Patches and scripts in `55_Implementation_Specs/_wip/Deceiver/` · Wiki artifact: https://claude.ai/artifact/439SJbZifq1fWxUsvPtnuh

---

## 1. Identity

| | |
|---|---|
| **Arcanum** | II · The High Priestess — secrets, the veil between what is and what seems, the two pillars; Mystra as the Lady of Mysteries |
| **Aspect** | Doubt |
| **Colour** | Pink `#f83fa5` · 🪞 |
| **Role** | Controller and burst caster who fights with illusions |
| **Fantasy** | "Mystra wove the Veilwalker from the veil between what is and what seems." No one watching can say which of her is real. |
| **Inspirations** | **LeBlanc** (League of Legends): Mirror Image, Sigil of Malice, Distortion, Ethereal Chains, Mimic — renamed in game to Eidolon, Seed of Doubt, Veilstep, Binding Falsehood, Twice-Told (DV29). **Bene Gesserit** (Dune). **The High Priestess** (tarot) |
| **Sound set / dialogue** | Bard |

The engine is **The Veil**: **Doubles** (1-HP illusions of her) on the field and **Doubt** on her enemies.

---

## 2. Chassis

| Field | Value |
|---|---|
| Abilities | Spellcasting **Intelligence** · secondary **Charisma** |
| Saving throws | Charisma, Intelligence |
| Armour | Light |
| Weapons | Daggers, Light Crossbows, Quarterstaffs · Musical Instrument |
| Skills (choose 4, then 2 Expertise) | *The Witch*: Deception, Insight, Intimidation, Performance, Persuasion, Perception, History, Investigation |
| Ability preset | STR 8 · DEX 10 · CON 13 · INT **15** · WIS 10 · CHA **15** |
| Starting gear | Deceiver robe (cloth, AC 10), Dagger, Light Crossbow, choice of instrument (default Violin) |

---

## 3. The Veil

### Doubles

| Rule | Value |
|---|---|
| Body | The mod's clone template `8807d230…` (stats `Clone_1`), transformed into her look by a shapeshift rule; 1 HP, AC 12, never scales |
| Summoned by | Eidolon (1 / 2 at slot 3 / 3 at slot 5), Veilstep (one where she stood), Grand Deception (up to the cap) |
| Cap | 3 · 4 at level 7 (`Arcana_Passive_VeilCap4`) · 5 at level 12 (`VeilCap5`); past the cap the oldest goes without a Splinter |
| For her | +1 AC per Double (`VEIL_LAYER_1`…`_5`) |
| Turn | Own turn, player-controlled: movement + one action; Dash, Disengage; Dismiss is free; no attacks |
| Spells | Come from its **shapeshift rule** (Transform's `RemovePrevSpells` hides anything `AddSpell` gives). 7 rules in `Shapeshift/Rulebook` (`DoubleOfTheVeil`, `_Slot3`…`_Slot6`, `_Slot5/6_NoUnveil`); the goal picks one by her passives and level |
| Immune to | Charmed, Madness, Possessed/Dominated, fleeing Fear |
| Ends | Combat end, Long Rest, her death |

| Double spell | From | Effect |
|---|---|---|
| Splinter (`Shout_Arcana_Double_Splinter`) | 1 | 3 m burst, 1d6 Psychic, 1 Doubt per enemy hit; the Double dies |
| Reflected Seed (`…MirrorSigil_SlotN`) | 5 (Two Truths) | `(Nd6)/2` Force and her Seed; N = her highest slot (3 at 5–6 … 6 at 11+) |
| Reflected Falsehood (`…MirrorChains_SlotN`) | 5 | Same damage, WIS save or Restrained 1 turn |
| Unveil | 9 | Swap places with her, once per round across all Doubles |
| Dismiss | 1 | Free, no Splinter |

### Doubt

| Rule | Value |
|---|---|
| Stacks | `DOUBT_1`/`_2` (3 turns, refreshed), raised by Osiris through `DOUBT_ADD_TECH`; the 3rd stack makes the enemy **Deluded** (Confused 1 turn) and resets |
| Per stack | −1 to Wisdom saves and −1 to Attack Rolls against her and her Doubles |
| Sources | A Double destroyed by an enemy · Splinter · her Seed detonating · Malicious Whispers on a marked target (2 with the detonation, D15) · Grand Deception (2) · Which One? |
| Payoffs | Veiled Prison and Marionette: Disadvantage on the save at 2+ Doubt |
| UI | Passive **Doubt** at level 1 explains it; The Veil explains the Doubles |

### The Seed

Seed of Doubt marks for 6 turns; the next Arcane spell damage from her (or a Double's Mirror spell) detonates it for
`Seed_BurstDamage` Psychic and 1 Doubt. Applying a status never detonates. Malicious Whispers on a marked target also
gives **Paranoia** (`WHISPERED_PARANOIA`: no reactions).

---

## 4. Level table

| Lvl | Passives | Cards / spells |
|---|---|---|
| 1 | **The Veil** | Malicious Whispers *(cantrip)* · Eidolon · Friends *(level-1 spell)* |
| 2 | — | Seed of Doubt · Faceless *(util)* |
| 3 | **2 - The High Priestess: Awakening** · Veiled (Tier I) | Veiled Prison |
| 4 | — | Splinter on Command |
| 5 | **Two Truths** | Binding Falsehood |
| 6 | — | Veilstep · Twice-Told |
| 7 | Two Pillars (Tier II) | — |
| 8 | cap 4 (`Arcana_Passive_VeilCap4`) | — |
| 9 | **Unveil** | Marionette |
| 10 | — | Mirrored Self · Mirrored Spell |
| 11 | — | Grand Deception |
| 12 | Aspect of Doubt (Tier III) · cap 5 (`Arcana_Passive_VeilCap5`) | — |
| 13–20 | — | — |

---

## 5. Cards

| Card | Lvl | Card lvl | Effect |
|---|---|---|---|
| **Seed of Doubt** | 2 | 1 | 18 m, never misses: Force (1d6 per slot) and a Seed |
| **Malicious Whispers** | 1 | cantrip | WIS save: Psychic (`D4Cantrip`), Disadvantage on its next attack; marked target: Paranoia + 1 Doubt |
| **Eidolon** | 1 | 1 | Summon 1 Double within 9 m (2 at slot 3, 3 at slot 5) |
| **Friends** | 1 | 1 | Advantage on Charisma checks; at slot 6 the old Faux Amis (no Concentration, unnoticed) |
| **Binding Falsehood** | 5 | 2 | WIS save: Force when bound and at turn end, then Restrained 1 turn |
| **Veiled Prison** | 3 | 2 | WIS save: Incapacitated 10 turns, crits from 3 m, repeats the save; 2+ Doubt: Disadvantage. Concentration · Short Rest · Unique |
| **Veilstep** | 6 | 3 | Teleport 18 m, Force blast on landing, a Double where she stood; creates Withdraw (swap with that Double) and Twice-Told: Veilstep |
| **Twice-Told** | 6 | — | Bonus action: recast the last damaging card |
| **Marionette** | 9 | 5 | Dominate 10 turns; 2+ Doubt: Disadvantage. Concentration · Long Rest · Unique |
| **Grand Deception** | 11 | 5 | Doubles up to the cap; enemies within 9 m that fail a WIS save gain 1 Doubt per Double of hers that stood within 3 m of them before the cast. Long Rest · Unique |
| **Mirrored Self** / **Mirrored Spell** | 10 | 2 / 3 | Unchanged passive cards (Mirrored Self: one more target; DV25 deferred) |
| **Splinter on Command** | 4 | 0 | Bonus action, 18 m: one of her Doubles Splinters at once. A deck card (1 Thread on PC) |
| **Ready: Which One?** | Tier III | 3 | Conjured at Tier III (console: `UnlockSpell` while awakened). Once per round (`ArcanaReactWhichOne`, Turn), reaction when an attack would hit: swap with the nearest Double, the attack misses, the Double is destroyed, the attacker gains Doubt |
| **The Veil Lifts** *(Aspect card)* | Tier I | — | Every Double casts Splinter, every Seed of hers detonates, survivors with Doubt go to Deluded. Once per combat |

Removed by the rework: Mental Prison, Hypnotic Gaze, Terrify, Hostile Takeover, Ready: Instinctive Charm, Ready: Hollow
Image, Friends: Faux Amis, Heartbreak, Beloved, the old clone's Mirror spells, `NEMESIS*`, `ARCANA_Spell_FacelessCopy_EX.txt`.

---

## 6. Aspect Awakening — 2 · The High Priestess

**Goal — apply Doubt.** Each stack counts 1 (`DB_ARCANA_DoubtStep`). Goals **4 / 7 / 10** (`ARCANA_Aspect_Common.txt`). Progress **counts down** the stacks left (ARC-0007, one status per tier).

| Tier | Level | Goal | Name | Bonus (until combat ends) |
|---|---|---|---|---|
| I | 3 | 4 | **Veiled** | Enemies with Doubt have Disadvantage on attacks against her and her Doubles (in the DOUBT statuses, `GetSummoner` for Doubles) |
| II | 7 | 7 | **Two Pillars** | Once per turn, when an enemy becomes Deluded in her name, the nearest unmarked enemy within 6 m gains her Seed |
| III | 12 | 10 | **Aspect of Doubt** | Every Splinter is one 4 m burst (`Projectile_Arcana_Splinter_Explosion`, hers); a Double an enemy destroys bursts where it was struck; Ready: Which One? |

---

## 7. Strengths · weaknesses

| Strengths | Weaknesses |
|---|---|
| Control that snowballs: Doubt makes every save worse, Deluded every few hits | No healing; light armour |
| Bodies on the field: decoys, +AC, Splinter bursts, Which One? | Doubles die to any hit or area |
| Burst: Seed + Twice-Told + Mirror spells | Damage needs setup |
| Utility: Faceless, Friends, Mirrored Spell | Many control cards share Concentration |

**What sets it apart:** the only subclass with bodies to spend, and the one whose debuff (Doubt) feeds both its control and its Awakening.

---

## 8. Still to test in game

Everything of the build above: `61.02/Deceiver/QA_ARC-0020.md`, levels 1–12 (Arcana Test Guides, tab Veilwalker).
