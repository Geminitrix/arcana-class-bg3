---
source: 51 (Progressions, Lists, Stats, Story) — carried over from the pre-migration knowledge base
synced_at: 2026-10-11 (every granted spell and passive matched by 82_Automation/verify_context.pl; numbers last re-checked 2026-10-02)
state: synced
reviewed: 2026-10-17 ARC-0023 — SC0–SC32 checked; the game is unchanged (3.1 kit), so this file is unchanged but for the note below; 2026-10-17 ARC-0025 — R1–R4 sizes (SC33–SC36): game unchanged, no change; 2026-10-17 ARC-0025 — stage 1 probes (_wip): no change
---

# 🌟 The Starchild — XVII · The Star · Aspect of Hope

> Last verified: **2026-10-02** · Progression table `464a3bfd-859a-43d5-a20d-d6a9270ce6eb` ·
> Lists "Starchild Level N" · Osiris `ARCANA_Aspect_Star.txt` · Check with `82_Automation/dump_progression.pl`.
>
> **Approved rework, not built (ARC-0023, SC0–SC32, 2026-10-16):** the Hymns, Dusk / Nightfall / Dawn, every card a
> container with a child per Hymn, new names and level map — design in `21.04_Subclasses/Starchild/DESIGN.md`. This
> file stays the game as it is until the build ships.

---

## 1. Identity

| | |
|---|---|
| **Arcanum** | XVII · The Star — hope, healing, renewal after disaster, the guiding light |
| **Aspect** | Hope |
| **Colour** | Blue `#79baf8` · 🌟 |
| **Role** | Healer and celestial support; buffs, cleansing, revival, area control |
| **Fantasy** | "A healer whose magic is starlight given purpose." |
| **Inspirations** | **Soraka** (League of Legends): Starcall, Astral Infusion, Equinox, Wish, Rejuvenation. **Lux** (League of Legends): Lucent Singularity, Final Spark. The cosmos — sun, moon and stars |
| **Sound set / dialogue** | Druid |

Known for compassion — helping people in need — and for understanding the universe. A healer, not an
oracle: divination belongs to the base class.

---

## 2. Chassis

| Field | Value |
|---|---|
| Abilities | Spellcasting **Intelligence** · secondary **Wisdom** |
| Saving throws | Wisdom, Constitution |
| Armour | Light, Medium, Shields |
| Weapons | Clubs, Daggers, Javelins, Maces, Quarterstaffs, Sickles, Spears |
| Skills (choose 4, then 2 Expertise) | *The Shaman*: Arcana, History, Medicine, Nature, Religion, Perception, Survival, Animal Handling |
| Ability preset | STR 8 · DEX 13 · CON **15** · INT 10 · WIS **15** · CHA 10 |
| Starting gear | Starchild robe (cloth, AC 10), Mace, Shield |

---

## 3. How it plays

1. **Starcall** an enemy: damage, slow, and you gain **Rejuvenation** (+30% speed, regain WIS mod HP
   each turn end).
2. **Astral Infusion** an ally as a bonus action — free while you have Rejuvenation, otherwise it costs
   10% of your own max HP. That's the core loop: Starcall → Infusion.
3. Keep the party standing with wards (Lunar Aegis, Moon Gravity, Astral Fortitude, Stellar Grace),
   cleanse (Solar Purge), revive (Starbreath), mass heal (Wish).
4. Control the field with light: Lucent Singularity, Equinox, Solar Flare, Final Spark.
5. Heal enough to awaken **The Star**: healed or targeted allies become Moonlit / Sunlit and hit harder.

---

## 4. Strengths · weaknesses · what sets it apart

| Strengths | Weaknesses |
|---|---|
| Best **sustain and support**: single heal, mass heal, revive, cleanse, AC, max HP, THP | Lowest **damage** until level 11 |
| Self-sustaining loop (Starcall → Rejuvenation → free Infusion) | Infusion without Rejuvenation costs your own HP and can't be cast at ≤11% HP |
| Strong **utility**: Solar Purge clears ~20 conditions, Moon Gravity, Lucent Singularity dispels magical darkness | Limited **mobility** |
| Late **area control and damage**: Equinox, Solar Flare (8d6 + Stun), Final Spark (+ recast that resets cooldowns on a kill) | Several key cards need **Concentration** (Lunar Aegis, Star Radiance, Lucent Singularity, Final Spark, Stellar Grace) |
| Medium armour and shield | Its Awakening depends on allies getting hurt first |

**What sets it apart:** the only true healer of the class, and its Awakening turns healing into
**party damage** (Moonlit cold, Sunlit fire, Eclipse resistances). Sun-and-moon duality runs through
the kit: solar cards cleanse and burn, lunar cards protect.

**Related to:** Cleric of Light / Circle of the Stars Druid (Cosmic Omen is reused), Soraka and Lux.

---

## 5. Level table

| Lvl | Passives | Cards / spells |
|---|---|---|
| 1 | Cosmic Omen ⭐ (+ Rest / Ability parts) | Starcall · Astral Infusion · Light ⭐ |
| 2 | — | — |
| 3 | Stellar Anchor · **17 - The Star: Awakening** · *Beacon* (Tier I) | Solar Purge · Lunar Aegis · Lunar Wisp |
| 4 | — | — |
| 5 | — | Starbreath · Lucent Singularity · Star Radiance |
| 6 | — | — |
| 7 | *Sunrise* (Tier II) | Wish · Moon Gravity |
| 8 | — | — |
| 9 | — | Equinox · Astral Fortitude |
| 10 | — | — |
| 11 | — | Solar Flare · Final Spark |
| 12 | *Aspect of Hope* (Tier III) | Stellar Grace |
| 13–20 | — | — |

⭐ vanilla (Cosmic Omen from the Circle of the Stars Druid; cantrips).

---

## 6. Cards

| Card | Gained | Card lvl | Action | Effect | Upcast / notes |
|---|---|---|---|---|---|
| **Starcall** | 1 | 1 | Action | 18 m ranged spell attack: Radiant, target −30% speed 1 turn; you gain Rejuvenation 2 turns | 1d6 per SL (1d6 → 6d6) |
| **Astral Infusion** | 1 | 1 | Bonus | 9 m: heal an ally. Without Rejuvenation, you lose 10% of your max HP. Not castable at ≤11% HP | 1d10 per SL (1d10 → 6d10) |
| **Solar Purge** | 3 | 2 | Action | 6 m: remove Charm, Domination, Confusion, Madness, Fear, Sleep, Paralysis, Stun, Petrification, Burning, Poison, Chill, Frozen, Shock, Bleeding, Blindness, Restraint, Polymorph, Daze, Disease, Curse. Short Rest cooldown · **Unique** | — |
| **Lunar Aegis** | 3 | 2 | Bonus | 18 m: an ally gains +2 AC. Concentration | — |
| **Lunar Wisp** | 3 | 1 | (passive card) | Until Long Rest or combat ends: your heals also give the ally THP = Arcana level + 2 × WIS mod. **Unique** · Unravel | — |
| **Starbreath** | 5 | 3 | Action | Revive a fallen ally with a % of their max HP. Long Rest cooldown · **Unique** | 10% / 30% / 60% / 100% at SL3–6 |
| **Lucent Singularity** | 5 | 3 | Action | 18 m: a 15 m point of light for 2 turns (Daylight surface) that dispels magical darkness; enemies get Difficult Terrain and Faerie Fire. Concentration | — |
| **Star Radiance** | 5 | 3 | Action | 9 m aura, 10 turns: your and allies' weapon attacks +1d4 Radiant. Concentration | — |
| **Wish** | 7 | 4 | Bonus | Heal yourself and allies within 18 m. Once per combat · **Unique** | 4d4 / 5d4 / 6d4 at SL4–6 |
| **Moon Gravity** | 7 | 4 | Action | Touch: remove Stun; the ally ignores Difficult Terrain and can't be magically Paralysed or Restrained | — |
| **Equinox** | 9 | 5 | Action | 18 m, 6 m zone for 1 turn: enemies inside are Silenced; those still inside when it ends are Restrained | — |
| **Astral Fortitude** | 9 | 5 | Action | Allies within 6 m gain max HP equal to your Arcana level | — |
| **Solar Flare** | 11 | 6 | Action | 18 m, 3 m radius, DEX save: 8d6 Fire, Stunned 1 turn + Burning 3; half + Burning 1 on a save. Ignites the ground. No cooldown (3 copies) | Level-6 card, no upcast |
| **Final Spark** | 11 | 6 | Action | 18 m beam, CON save: 6d6 Radiant, Blinded and Faerie Fire 1 turn. Concentration. Creates **Recast Final Spark** | Level-6 card |
| **Stellar Grace** | 12 | 6 | Action | Allies within 18 m: healing on them is maximised; Advantage on WIS saves and Death saves. Concentration · Long Rest cooldown · **Unique** | — |

### Created cards

| Card | Source | Cost | Effect |
|---|---|---|---|
| **Recast Final Spark** | Final Spark (2 turns) | Action · 1 Thread, no slot | Another 6d6 beam; a kill resets all your ability cooldowns. Ends Final Spark |
| **Wish Upon a Star** *(Aspect card)* | Awakening Tier I | Action · 0 Threads · once per combat | Allies within 18 m gain Advantage on their next attack roll (2 turns) |

---

## 7. Passives

| Passive | Lvl | Effect |
|---|---|---|
| **Cosmic Omen** ⭐ | 1 | On Long Rest, an omen of Weal or Woe: spend charges to raise (Weal) or lower (Woe) attack rolls and saves, or (Weal) allies' ability checks |
| **Stellar Anchor** | 3 | Advantage on Concentration saves |
| **Lunar Wisp** *(via card)* | 3 | See the card |

Status **Rejuvenation**: +30% movement speed, regain WIS mod HP at the end of each turn (2 turns, from Starcall).

---

## 8. Aspect Awakening — 17 · The Star

**Objective — heal your allies during the fight.** Only effective healing counts (not beyond max HP).
Progress **counts down** the hit points of healing left to the next tier (ARC-0007, one status per tier).

| Tier | Level | Goal | Name | Bonus (until combat ends) |
|---|---|---|---|---|
| I | 3 | 5 × your level | **Beacon** | Allies you heal or target with an Arcane spell become **Moonlit**: next attack that hits +1d4 Cold and slows the target |
| II | 7 | 8 × your level | **Sunrise** | Moonlit becomes 2d4 Cold; allies also become **Sunlit**: next hit +1d4 Fire and Burning (2 turns) |
| III | 12 | 12 × your level | **Aspect of Hope** | +3 WIS; Sunlit becomes 2d4 Fire; allies also gain **Eclipse** (Resistant to Cold and Fire, 2 turns); **Undying Hope**: the first ally who would be downed this fight regains half their HP instead |

Moonlit / Sunlit last 2 turns or until the next hit. Aspect card: **Wish Upon a Star**. VFX: Bless.
