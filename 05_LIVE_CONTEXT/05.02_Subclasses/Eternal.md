---
source: 51 (Progressions, Lists, Stats, Story) — carried over from the pre-migration knowledge base
synced_at: 2026-10-02 (last verified against the game files; migrated 2026-10-11)
state: stale
---

# 💀 The Eternal — XIII · Death · Aspect of Sorrow

> Last verified: **2026-10-02** · Progression table `b5a43d76-fd80-4c29-b149-7690e1e1e18f` ·
> Lists "Eternal Level N" · Osiris `ARCANA_Aspect_Death.txt`, `ARCANA_Status_Hemorrhage.txt` ·
> Check with `82_Automation/dump_progression.pl`.

---

## 1. Identity

| | |
|---|---|
| **Arcanum** | XIII · Death — endings and transformation; the one who crossed their own end and came back |
| **Aspect** | Sorrow |
| **Colour** | Green `#5dbc74` · 💀 |
| **Role** | Necromantic frontline; tank and bruiser that wins by attrition |
| **Fantasy** | A juggernaut that turns its own health into a weapon. |
| **Inspirations** | **Mordekaiser** (League of Legends): Darkness Rise, Obliterate, Indestructible, Death's Grasp, Realm of Death — the iron revenant who died and refused to stay dead, dragging his enemies into his own realm. **Vladimir** (League of Legends): Transfusion, Hemoplague — the hemomancer who spends his own blood as power. The **Death** card of the tarot: an ending that is also a transformation, and the **Aspect of Sorrow** |
| **Sound set / dialogue** | Paladin |

Known for enduring what should have killed them: they crossed their own end, came back, and carry the
grief of it. Every wound they take becomes strength, every drop of blood a weapon, and the death they
refused is the death they hand to others. Blood, disease, decay and the grave.

---

## 2. Chassis

| Field | Value |
|---|---|
| Abilities | Spellcasting **Intelligence** · secondary **Constitution** |
| Saving throws | Constitution, Strength |
| Armour | Light, Medium, **Heavy**, Shields |
| Weapons | Light Hammers, Clubs, Maces, Greatclubs, Warhammers, Mauls |
| Skills (choose 4, then 2 Expertise) | *The Eternal*: Athletics, Intimidation, Medicine, History, Nature, Investigation, Religion, Survival |
| Ability preset | STR **15** · DEX 10 · CON **15** · INT 13 · WIS 10 · CHA 8 |
| Starting gear | Eternal heavy armour (Breastplate, **AC 16**), Maul |

---

## 3. How it plays

1. Walk into the front line in heavy armour and swing (Extra Attack at 5).
2. Add Necrotic to hits (**Obliterate**, **Blood Offering**), drain with **Transfusion**, pull runners in
   with **Death's Grasp**, open wounds with **Blood Reaper**.
3. Survive by layers: **Indestructible** THP, **Unbroken**, **Immortal Blood**, **Inured to Undeath**,
   **Death Ward** on allies.
4. **Take damage on purpose** — losing HP is the Awakening goal. Once awake, Darkness Rise grinds down
   everything around you, and The Final Toll returns the pain.
5. Late game: diseases (**Hemoplague**), banked damage (**Hemorrhage**), isolate and kill (**Realm of Death**).

---

## 4. Strengths · weaknesses · what sets it apart

| Strengths | Weaknesses |
|---|---|
| Best **defence and sustain**: heavy armour + shield, THP, lifesteal, damage halving, immunities | Lowest **mobility**: no movement tools beyond pulling enemies in |
| Strong melee **damage** with Extra Attack + Necrotic riders | Little **support**: Death Ward and nothing else for allies |
| Good **control** late: Fear, pull, Banish, diseases, Numb | Many defensive pieces are passive **cards** that must be drawn (PC edition) |
| Its Awakening goal (lose HP) happens naturally on the front line | Wants to be hit — a careful party that protects it delays the Awakening |
| Scales into a self-sufficient juggernaut (Harvest: extra action on kills) | Utility out of combat is thin (Dead Whispers) |

**What sets it apart:** the only heavy-armour frontliner, and the subclass whose **resource is its own
health** — self-damage costs (Blood Offering), Sorrow's HP-loss goal, The Final Toll scaling with HP lost.

**Related to:** Death Domain Cleric (Inescapable Destruction), Necromancy Wizard (Inured to Undeath),
Paladin (sound set, armour), blood magic, Mordekaiser's and Vladimir's kits, Ketheric Thorm's
*Howl of the Dead* (BG3).

---

## 5. Level table

| Lvl | Passives | Cards / spells |
|---|---|---|
| 1 | — | Blood Reaper · Obliterate · Transfusion · Dead Whispers *(util)* |
| 2 | — | — |
| 3 | **13 - Death: Awakening** · *Sorrow* (Tier I) | Death's Grasp · Indestructible · Immortal Blood |
| 4 | — | — |
| 5 | Extra Attack ⭐ | Death Ward · Inescapable Destruction |
| 6 | — | — |
| 7 | *Mourning* (Tier II) | Unbroken · Blood Offering |
| 8 | — | — |
| 9 | — | Death's Aspect · Hemoplague |
| 10 | — | — |
| 11 | — | Hemorrhage · Inured to Undeath |
| 12 | *Aspect of Sorrow* (Tier III) | Realm of Death |
| 13 | — | Howl of the Dead *(cantrip card)* |
| 14–20 | — | — |

⭐ vanilla (Extra Attack). The vanilla Chill Touch moved to the base class as *Weaver Hand: Chill* (2026-10-04).

---

## 6. Cards

| Card | Gained | Card lvl | Action | Effect | Upcast / notes |
|---|---|---|---|---|---|
| **Blood Reaper** | 1 | 1 | Bonus | Melee spell attack: Bleeding 2 turns | — |
| **Obliterate** | 1 | 1 | Action | Weapon attack + extra Necrotic | 1d8 per SL (1d8 → 6d8) |
| **Transfusion** | 1 | 1 | Action | 9 m ranged spell attack: Necrotic, you regain as much HP | 1d6 per SL (1d6 → 6d6) |
| **Death's Grasp** | 3 | 2 | Action | 18 m, CON save: pull 5 m toward you + Necrotic | 1d8 / 2d8 / 3d8 / 4d8 / 5d8 at SL2–6 |
| **Indestructible** | 3 | 2 | Bonus | THP = 5 × Arcana level for 2 turns; when it ends or the THP is gone, regain 2 × Arcana level | — |
| **Immortal Blood** | 3 | 2 | (passive card) | Until Long Rest or combat ends: Immune to Disease, Bleeding and Gaping Wound. **Unique** · Unravel | — |
| **Death Ward** | 5 | 3 | Action | Touch an **ally**: the next time damage would drop them to 0 HP they stay at 1. Short Rest cooldown · **Unique** | — |
| **Inescapable Destruction** | 5 | 2 | (passive card) | Until Long Rest or combat ends: your spells ignore Necrotic Resistance (vanilla passive). **Unique** · Unravel | — |
| **Unbroken** | 7 | 4 | (passive card) | Combat only. Half damage from non-magical Bludgeoning/Piercing/Slashing while above 80% max HP. **Unique** · Unravel | — |
| **Blood Offering** | 7 | 3 | Bonus | Combat only. Lose 10% of max HP; until end of turn your Arcane spells (and cantrips) deal extra Necrotic | 2d8 / 3d8 / 4d8 / 5d8 at SL3–6 |
| **Death's Aspect** | 9 | 4 | Action | 9 m radius, WIS save: Frightened 2 turns | — |
| **Hemoplague** | 9 | 4 | Action | **Choose** 1 of 6 diseases (Blinding Sickness, Filth Fever, Flesh Rot, Mindfire, Seizure, Slimy Doom); melee spell attack infects; each disease worsens over 3 stages | Native spell container |
| **Hemorrhage** | 11 | 6 | Action | 18 m, 9 m sphere, CON save: Necrotic + Gaping Wound + **Hemorrhage** 2 turns (stores all damage taken, re-deals it as Necrotic when it ends; half damage on a save) | Level-6 card |
| **Inured to Undeath** | 11 | 3 | (passive card) | Combat only. Resistant to Necrotic; max HP can't be reduced (vanilla passive). **Unique** · Unravel | — |
| **Realm of Death** | 12 | 6 | Action | 6 m: drag one enemy into the realm of death, Banishing every other creature nearby (3 turns). Inside: Vulnerable to Necrotic, 2d6 Cold at turn start and 2d6 Acid at turn end; Difficult Terrain (4 turns) | Level-6 card |
| **Howl of the Dead** | 13 | 0 (cantrip) | Bonus | 3 m, WIS save (DC 14): nearby creatures are Numbed 3 turns (Ketheric's howl) | 1 Thread |

### Created cards

| Card | Source | Cost | Effect |
|---|---|---|---|
| **Hemoplague: <disease>** (6) | Hemoplague container | as Hemoplague | The chosen disease |
| **The Final Toll** *(Aspect card)* | Awakening Tier I | Action · 0 Threads · once per combat | 18 m: Necrotic equal to the HP you lost this combat, up to half your max HP. A creature killed this way rises as a zombie |

### Utilities

| Utility | Lvl | Effect |
|---|---|---|
| **Dead Whispers** | 1 | Speak with a humanoid corpse: up to 5 questions |

---

## 7. Passives

| Passive | Lvl | Effect |
|---|---|---|
| **Extra Attack** ⭐ | 5 | One extra attack with the Attack action |

Every other Eternal passive is a card (Immortal Blood, Inescapable Destruction, Unbroken, Inured to Undeath).

---

## 8. Aspect Awakening — 13 · Death

**Objective — lose hit points during the fight.** Healing doesn't undo the loss (a running ledger of
damage taken, plus the HP that Blood Offering costs). Progress shows as a percentage towards the next tier. The same ledger powers The Final Toll.

| Tier | Level | Goal | Name | Bonus (until combat ends) |
|---|---|---|---|---|
| I | 3 | 30% of max HP | **Sorrow** | You emanate **Darkness Rise**: +50% movement speed; enemies in the aura take Necrotic equal to 10% of your max HP each turn and their speed is halved |
| II | 7 | 50% | **Mourning** | The first time you would drop to 0 HP, you drop to 1; an isolated enemy within 3 m (alone near you, no allies within 6 m of it) has Disadvantage on attacks against you |
| III | 12 | 70% | **Aspect of Sorrow** | +3 CON; **Harvest**: once per turn, when a hostile creature dies within 9 m, you gain an extra action |

Aspect card: **The Final Toll**. VFX: the Darkness Rise aura.
