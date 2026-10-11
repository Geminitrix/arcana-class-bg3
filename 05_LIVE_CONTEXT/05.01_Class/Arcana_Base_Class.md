---
source: 51 (Progressions, Lists, Stats, Story) — carried over from the pre-migration knowledge base
synced_at: 2026-10-11 (every granted spell and passive matched by 82_Automation/verify_context.pl; numbers last re-checked 2026-10-04)
state: synced
---

# 03 · Base Class — Arcana

> Last verified: **2026-10-04** · Sources: `ClassDescriptions.lsx`, `Progressions.lsx` (table
> `99f583de-f62e-43a7-b8f7-4aa29812709f`), `SpellLists.lsx`, `Passive.txt`, `Spell_*.txt`, `english.xml`.
> Check with `82_Automation/dump_progression.pl`.

---

## 1. Role

🎯 Design intent: the base class is **the seer** — mostly useful **out of combat**, with utilities
themed by level (divination, locks, sight, portals). Combat power comes from the subclass. The base
class is the **Aspect of Mystra**.

---

## 2. Chassis

| Field | Value |
|---|---|
| Hit points | **10** at level 1, **+6** per level (d10 curve, like Fighter/Paladin/Ranger) |
| Primary / spellcasting ability | **Intelligence** for every subclass (set on the base class) |
| Secondary ability | Set by the subclass: Unbound DEX · Deceiver CHA · Starchild WIS · Eternal CON |
| Subclass | Chosen at **level 1** |
| Proficiencies | **None** from the base class — armour, weapons and saving throws all come from the subclass |
| Skills | From the subclass list: **4 skills + 2 Expertise** at level 1 |
| Ability scores | `SelectAbilityBonus(…,3,2)` (standard +2/+1) at level 1; preset per subclass |
| Feats (ASI) | Levels **4, 8, 12, 16, 20** |
| Spells | All Always Prepared |
| Familiar | Pick 1 of 7 at level 1 (default Cat) |
| Hotbar columns | Class 5 · Common 9 · Items 2 |
| UUID | `799a9fd7-f042-411a-80ae-a0eb46e7f829` |

Starting gear for everyone: shoes, camp clothes, 2 Healing potions, Scroll of Revivify, keychain,
alchemy pouch, camp supplies. Subclass gear in each subclass file.

---

## 3. Level table

| Lvl | Slot level / total | Gains |
|---|---|---|
| 1 | L1 / 2 | **Choose 2:** Weaver Hand: Summon, Flame, Protect, Transmute · **Arcane Familiar** (choose 1) · Arcane Recovery · pick subclass |
| 2 | L1 / 4 | **Portent** ⭐ · **Choose 1:** Detect Supernatural, Comprehend Languages |
| 3 | L2 / 6 | — |
| 4 | L2 / 7 | **Expert Divination** ⭐ · **Choose 2:** Weaver Hand: Guide, Command, Chill, Burn, Blind, Electrify · Arcane Lock · Arcane Unlock · Feat |
| 5 | L3 / 9 | — |
| 6 | L3 / 10 | Dispel Magic |
| 7 | L4 / 11 | — |
| 8 | L4 / 12 | Third Eye · Feat |
| 9 | L5 / 14 | — |
| 10 | L5 / 15 | Third Eye: Projection |
| 11 | L6 / 16 | — |
| 12 | L6 / 16 | Arcane Gate · Feat |
| 13 | L6 / 17 | — |
| 14 | L6 / 17 | **Arcane Overflow** |
| 15 | L6 / 18 | — |
| 16 | L6 / 18 | **Arcane Mastery** · Feat |
| 17 | L6 / 19 | — |
| 18 | L6 / 20 | **Arcane Veil** |
| 19 | L6 / 21 | — |
| 20 | L6 / 22 | **Arcane Avatar** · Feat |

⭐ = vanilla feature reused as-is (Divination Wizard).

---

## 4. Utilities

All are `Arcana_Util_` — never cards, locked during combat in the PC edition. All cost only an action
except **Weaver Hand: Guide**, a *ritual utility*: it has a slot cost so it can be upcast, but its
`RitualCosts` (action only) lets it be cast without a slot — and it can't be cast in combat anyway.

| Utility | Lvl | Spell lvl · School | Cooldown | Effect |
|---|---|---|---|---|
| **Weaver Hand: Summon** (Mage Hand) | 1 (choice) | 0 · Conjuration | — · Concentration | *"Summon an invisible hand that can manipulate and interact with objects."* 9 m |
| **Weaver Hand: Flame** (Produce Flame) | 1 (choice) | 0 · Conjuration | — | A flame that sheds light in 9 m and can be thrown for 1d8 Fire |
| **Arcane Familiar** (7 kinds) | 1 | 1 · Conjuration | Short Rest | Summon the chosen familiar (see §6). Can't be cast in combat |
| **Arcane Recovery** | 1 | 1 · Divination | `OncePerRest` | *"In the stillness, the Weave draws itself taut again. Regain 1 Woven Spell Slot."* |
| **Detect Supernatural** | 2 (choice) | 1 · Divination | Long Rest | Detect Aberrations, Celestials, Elementals, Fey, Fiends and Undead within 72 m |
| **Comprehend Languages** | 2 (choice) | 1 · Divination | Long Rest | Understand any spoken/written language and speak with animals and beasts |
| **Weaver Hand: Guide** (Guidance) | 4 (choice) | 2 · Divination | — · Ritual | Touch: +1d4 to Ability Checks for 10 turns, no Concentration. Slot 2 cost, `RitualCosts` action only. Upcast `_3`–`_6` apply `GUIDANCE_3`–`_6`: +2d4 / 3d4 / 4d4 / 5d4 (stack priority = slot) |
| **Arcane Lock** | 4 | 2 · Abjuration | — | Magically lock a door or container (no lockpick, no Knock) |
| **Arcane Unlock** | 4 | 2 · Transmutation | — | Open a mundane or magical lock |
| **Dispel Magic** | 6 | 2 · Abjuration | Long Rest · Concentration | Dispel the magical energies around a character or object |
| **Third Eye** | 8 | 4 · Divination | Long Rest | See in magical and non-magical darkness to 24 m, and see Invisible creatures and objects |
| **Third Eye: Projection** | 10 | 4 · Conjuration | Long Rest · Concentration | Project an invisible magical eye to scout ahead |
| **Arcane Gate** | 12 | 6 · Conjuration | Long Rest · Concentration | Two linked teleportation portals |

Deceiver and Eternal add their own subclass utilities (Faceless, Friends, Dead Whispers).

---

## 5. Passives

| Passive | Lvl | Effect |
|---|---|---|
| **Portent** ⭐ | 2 | After each Long Rest, roll two Portent dice; use your reaction to replace a nearby attack roll or save with one |
| **Expert Divination** ⭐ | 4 | Extra Portent die; a Short Rest gives a Prophecy that restores a spent die when completed |
| **Arcane Overflow** | 14 | Once per turn in combat, when you cast an Arcane spell, regain 1 Thread and 1 Woven Spell Slot |
| **Arcane Mastery** | 16 | Toggle, once per Long Rest: the next Arcane spell costs no Threads and no slot |
| **Arcane Veil** | 18 | *"The Weave surrounds you, giving you protection and Resistance to all magical damage."* |
| **Arcane Avatar** | 20 | *"You have transcended the material plane and become true Arcana."* +3 Spell Attack, +3 Spell Save DC, +3 Intelligence, Advantage on Concentration saves |

---

## 6. Arcane Familiar (choose 1 at level 1)

Each familiar is a passive that unlocks its summon (Action, once per Short Rest, 18 m, out of combat).

| Familiar | What it does |
|---|---|
| Cat *(default)* | Meow — distracts enemies |
| Dog | Finds hidden things; Bite |
| Crab | Crippling Pinch — slows |
| Frog | Bufotoxin |
| Rat | Infectious Bite |
| Raven | Blinds with its beak |
| Spider | Poisonous Bite |

---

## 7. Weaver Hand cards (base-class picks)

The first piece of the "Closer to Mystra" rework (`07-open-questions.md`): the **Hand** list, vanilla
spells re-themed as the Weave shaped into a hand. Every name starts with *Weaver Hand:*. The utilities
(Summon, Flame, Guide) are in §4; the rest are **cards** (`ARCANA_IS_CARD`).

| Card | Lvl | Spell lvl · School | Effect | Upcast (slot 3 → 6) |
|---|---|---|---|---|
| **Protect** (Blade Ward) | 1 (choice) | 0 · Abjuration | Ally within 9 m: Resistance to Bludgeoning, Piercing and Slashing, 2 turns. Combat only | — (cantrip) |
| **Transmute** (Enlarge) | 1 (choice) | 0 · Transmutation | Ally within 9 m: Enlarged for 5 turns (+1d4 weapon damage, Advantage on Strength). Concentration | — (cantrip) |
| **Command** | 4 (choice) | 2 · Enchantment | 18 m, Wisdom save: Halt / Approach / Drop / Flee / Grovel for 1 turn. Container, Hemoplague pattern | 2 / 3 / 4 / 5 targets |
| **Chill** (Chill Touch) | 4 (choice) | 2 · Necromancy | 18 m spell attack: 1d8 Necrotic, no healing until your next turn | 2d8 / 3d8 / 4d8 / 5d8 |
| **Burn** (Burning Hands) | 4 (choice) | 2 · Evocation | 5 m cone, Dexterity save: 1d4 Fire, half on a save, ignites | 2d4 / 3d4 / 4d4 / 5d4 |
| **Blind** (Color Spray) | 4 (choice) | 2 · Illusion | 5 m cone: Blinds creatures up to a combined 44 hit points | 55 / 66 / 77 / 88 HP |
| **Electrify** (Shocking Grasp) | 4 (choice) | 2 · Evocation | Melee spell attack: 1d8 Lightning, no reactions, Advantage against metal | 2d8 / 3d8 / 4d8 / 5d8 |

Granted at level 4, the level-2 cards never meet a slot below 2, so their variants start at `_3`. The
vanilla Produce Flame (Starchild) and Chill Touch (Eternal) grants were removed when these arrived.

---

## 8. Deck pieces granted by the base class

- **Reweave** (`Shout_Arcana_Created_Reweave`) — the mulligan. Not in the progression (the console
  edition has no deck): the PC edition teaches it from Lua, `Server/Deck/Grants.lua`, to every deck user
  (`Po.IsDeckUser`) on session load, `LevelGameplayStarted`, `LeveledUp`, `CharacterJoinedParty` and at
  the start of each fight. `HasSpell` first, so repeats are no-ops. The list "Arcana Deck Core"
  (`20d9404e-…`) is no longer used.
- List **"Arcana Deck DEBUG"** (level 1): `[DEBUG]` Fated / Fleeting / Unique / Tangler cards and a
  `[DEBUG] Tangle`. Test tools for the keywords; they stay in the build on purpose.

---

## 9. Strengths and weaknesses of the base kit

| Strengths | Weaknesses |
|---|---|
| Divination and exploration nobody else has in one package: Portent, Third Eye, Detect Supernatural, Arcane Gate, locks | Few combat spells of its own — two picks among the Weaver Hand cards; the rest of combat is the subclass |
| Large pool of Woven Spell Slots that rise in level with the character | Utilities are locked in combat |
| 4 skills + 2 Expertise at level 1 | Levels 13–20 have only the four capstone passives — 🎯 reserved for future content |
| d10 hit die | Only the Hand list of the planned rework exists so far |
