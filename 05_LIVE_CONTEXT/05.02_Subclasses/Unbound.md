---
source: 51 (Progressions, Lists, Stats, Story) — carried over from the pre-migration knowledge base
synced_at: 2026-10-11 (every granted spell and passive matched by 82_Automation/verify_context.pl; numbers last re-checked 2026-10-02)
state: synced
reviewed: 2026-10-17 ARC-0022 — the game is unchanged (still the old Unbound build); the approved redesign (WB0–WB48) lives in `21.04_Subclasses/Unbound/DESIGN.md` until its build ships; 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — QA-0004: 7 probes pass, the Owner's probe edits live in the game, stage 1 complete (all 9 probes pass), the Owner's probes live in the game until the stage 2 cleanup
---

# 🍃 The Unbound — 0 · The Fool · Aspect of Curiosity

> **Approved redesign, not in the game yet (ARC-0022, 2026-10-16):** display name *The Windborn*; the Open Road
> (Windswept, Zephyr's Rush, Aeolus' Bag), new tiers, The Calm, Where the Winds Meet, Weightless. Design:
> `21.04_Subclasses/Unbound/DESIGN.md`. Everything below is the game as it is today.

> Last verified: **2026-10-02** · Progression table `d75cb44d-bba6-43ad-851f-4497ec526e80` ·
> Lists "Unbound Level N" · Osiris `ARCANA_Aspect_Fool.txt` · Check with `82_Automation/dump_progression.pl`.

---

## 1. Identity

| | |
|---|---|
| **Arcanum** | 0 · The Fool — the start of the journey, freedom, the leap into the unknown |
| **Aspect** | Curiosity |
| **Colour** | Yellow `#f2c939` · 🍃 |
| **Role** | Unarmoured unarmed striker; mobility, evasion, action economy |
| **Fantasy** | "Weightless, fast, and always exactly where you need to be." |
| **Inspirations** | Aang and the Air Nomads (*Avatar: The Last Airbender*); wild folk, animal friends, travellers and wanderers |
| **Sound set / dialogue** | Monk |

Curiosity of movement: very fast, a world traveller crossing countries and horizons. "Unbound" means
free to move, not in conflict with Mystra.

---

## 2. Chassis

| Field | Value |
|---|---|
| Abilities | Spellcasting **Intelligence** · secondary **Dexterity** |
| Saving throws | Dexterity, Wisdom |
| Armour | **None — by design** |
| Weapons | None (unarmed) |
| Skills (choose 4, then 2 Expertise) | *The Wanderer*: Acrobatics, Animal Handling, Nature, Perception, Survival, Stealth, Sleight of Hand, Athletics |
| Ability preset | STR 10 · DEX **15** · CON 13 · INT 8 · WIS **15** · CHA 10 |
| Starting gear | Unbound robe (cloth, AC 10), no weapon |

**The armour rule:** every Unbound passive, card and status carries *"Only active while not wearing
armour or using a shield"* (`not WearingArmor() and not HasShieldEquipped()`). Putting on armour or a
shield ends the Unbound's statuses.

---

## 3. How it plays

1. Close the gap with huge movement speed (Twinkle Toes) and jumps.
2. Punch: unarmed attacks scale on Dexterity with a rising damage die (Flowing Strikes).
3. **Every unarmed attack and every Arcane card grants Zephyr Strike** — an extra unarmed attack as a
   bonus action. Flow State adds bonus actions to spend on it.
4. Stay alive by not being hit: Be the Leaf (WIS to AC), Wind Whispers (Disadvantage + riposte),
   Gale Deflection against ranged attacks, Empty State.
5. Hit many different enemies in one round to awaken **The Fool**.

---

## 4. Strengths · weaknesses · what sets it apart

| Strengths | Weaknesses |
|---|---|
| Best **mobility** of the class: up to +38 m speed at level 12, jump ×6, immune to falling | **No armour or shield, ever** — the whole kit turns off |
| **Action economy**: Zephyr Strike after everything, Flow State's extra bonus actions, Flowing Assault (Extra Attack) | Low **sustain**: no healing; THP from Flow State only |
| Layered **evasion**: Be the Leaf, Wind Whispers, Gale Deflection (3/round), Empty State, Fool's Luck | Damage is mostly single-target, melee-range |
| Strong **utility** out of combat: Untethered flight, jumps, skills | Little control (Prone, push, Off Balance) |
| Awakening rewards spreading hits — good in crowded fights | The Aspect goal asks for **different** enemies; a duel only counts if few enemies stand |

**What sets it apart:** the only Arcana that is a martial first — no weapons, no armour, and its cards
are mostly self-buffs that feed more attacks. Every card ends with *"Afterwards, you can make a Zephyr
Strike as a bonus action."*

**Related to:** Monk (chassis, sound set, unarmed scaling), Air/wind elementalism, the Fool's leap.

---

## 5. Level table

| Lvl | Passives | Cards / spells |
|---|---|---|
| 1 | Be the Leaf · Twinkle Toes (+3 m) · Flowing Strikes: Agility / Precision / Zephyr | Gale Burst · True Strike ⭐ |
| 2 | — | — |
| 3 | Twinkle Toes (+8 m) · **0 - The Fool: Awakening** · *Wanderlust* (Tier I) | Wind Blast · Flow State · Ready: Gale Deflection |
| 4 | — | — |
| 5 | Twinkle Toes (+13 m) · Feather Fall (50%, jump ×2) · Flowing Assault | Wind Whispers |
| 6 | — | — |
| 7 | Twinkle Toes (+18 m) · Feather Fall (40%, ×3) · Magic Strikes · *Restless Wind* (Tier II) | Storm Fists |
| 8 | — | — |
| 9 | Twinkle Toes (+23 m) · Feather Fall (30%, ×4) · Eye of the Storm | Untethered · Evasive Flow |
| 10 | — | — |
| 11 | Twinkle Toes (+28 m) · Feather Fall (20%, ×5) · Momentum | Thunderclap |
| 12 | Twinkle Toes (+38 m) · Feather Fall (immune, ×6) · Empty State · *Aspect of Curiosity* (Tier III) | — |
| 13–20 | Twinkle Toes only: +43 / +48 / +53 / +58 / +68 m at 13 / 15 / 17 / 19 / 20 | — |

⭐ vanilla cantrip. Hidden: `Monk_SoundSwitch` (L1).

---

## 6. Cards

Cost = **one Woven Spell Slot** of the card's level (out of combat / console) or **Threads = card level**
(combat, PC). All grant **Zephyr Strike** afterwards. All require no armour and no shield.

| Card | Gained | Card lvl | Action | Effect | Upcast |
|---|---|---|---|---|---|
| **Gale Burst** | 1 | 1 | Action | 9 m. STR save: Thunder damage, pushed back, Prone; half damage on a success. Also grants a free unarmed strike | SL1–2 1d10, push 6 m · SL3–4 2d10, 7 m · SL5–6 3d10, 8 m |
| **Wind Blast** | 3 | 2 | Action | 12 m line. STR save: pushed 5 m and Off Balance. Clears cloud surfaces and Burning | — |
| **Flow State** | 3 | 2 | Action | Combat only. THP = 2 × Arcana level and +1 bonus action | Lasts 2/3/4/5/6 turns at SL2–6; **2** bonus actions from SL5 |
| **Ready: Gale Deflection** | 3 | 2 | (reaction card) | Until combat ends, gain Gale Deflection and one use. Up to **3 uses per round** | — |
| **Wind Whispers** | 5 | 3 | Bonus | Combat only. Until the start of your next turn: attacks against you have Disadvantage; **Wind Riposte** — an enemy melee miss triggers an automatic unarmed counter (reaction) | — |
| **Storm Fists** | 7 | 4 | Bonus | Combat only. Unarmed attacks deal extra Thunder + DEX mod | 1d4 / 1d6 / 1d8 at SL4/5/6; lasts 3/4/5 turns |
| **Untethered** *(ability card)* | 9 | 5 | Action | Gain Fly. Enables **Eye of the Storm** (+2 AC while flying). Castable outside combat, but the flight ends when combat starts and when it ends | — |
| **Evasive Flow** | 9 | 3 | Bonus | Combat only. Jumping costs no bonus action and your next unarmed attack this turn has Advantage | Lasts 2 / 3 turns at SL5–6 (arrives at level 9, slot 5) |
| **Thunderclap** | 11 | 4 | Bonus | Combat only. Thunder damage you deal inflicts 2 turns of Reverberation. Enables **Momentum** (+2 AC) | Lasts 5 turns (arrives at level 11, always slot 6) |

### Created cards

| Card | Source | Cost | Effect |
|---|---|---|---|
| **Zephyr Strike** | Status `ZEPHYR_STRIKE`, from any unarmed attack, any Arcane card or True Strike | Bonus action · 1 Thread (PC) · no slot | One unarmed attack. Lasts 1 turn in hand |
| **Leap of Faith** *(Aspect card)* | Awakening Tier I | Action · 0 Threads · once per combat | Rush up to 18 m; unarmed attack against every creature in the path, each adding Thunder damage (`GaleBurst_Damage`, by character level); then Zephyr Strike |

---

## 7. Passives

| Passive | Lvl | Effect |
|---|---|---|
| **Be the Leaf** | 1 | AC = 10 + DEX + WIS (`ACOverrideFormula`). Doesn't stack with Mage Armour |
| **Twinkle Toes** | 1→20 | Movement speed +3 / 8 / 13 / 18 / 23 / 28 / 38 / 43 / 48 / 53 / 58 / 68 m |
| **Flowing Strikes: Agility** | 1 | Unarmed attacks use DEX instead of STR if higher |
| **Flowing Strikes: Precision** | 1 | Unarmed damage die by character level: 1d4 (1–3), 1d6 (4–6), 1d8 (7–9), 1d10 (10–12), 1d12 (13–18), 1d20 (19–20) |
| **Flowing Strikes: Zephyr** | 1 | After an unarmed attack or an Arcane spell, Zephyr Strike as a bonus action |
| **Gale Deflection** *(via card)* | 3 | Reaction: reduce a ranged weapon attack's damage by 1d10 + DEX mod + Arcana level; at 0, hurl the missile back (Redirect) |
| **Feather Fall** | 5→12 | Falling damage 50 / 40 / 30 / 20 % / immune; Jump ×2 / ×3 / ×4 / ×5 / ×6 |
| **Flowing Assault** | 5 | Extra Attack (unarmed or weapon), restricted to no armour / no shield |
| **Magic Strikes** | 7 | Unarmed attacks count as magical |
| **Eye of the Storm** | 9 | +2 AC while Untethered is active |
| **Momentum** | 11 | +2 AC while Thunderclap is active |
| **Empty State** | 12 | Half damage from attacks that hit; Evasion against DEX-save spells. Doesn't spend the reaction |

---

## 8. Aspect Awakening — 0 · The Fool

**Objective — strike different enemies within a single round** (from the start of your turn to the start
of the next, so reactions count). Any attack that hits counts: unarmed, Zephyr, Gale Deflection, spell
attacks. If fewer enemies stand at the start of your turn than the goal, hits on any enemy count.
Progress **counts down** what is left (ARC-0007, one status per tier) and resets each round.

| Tier | Level | Goal | Name | Bonus (until combat ends) |
|---|---|---|---|---|
| I | 3 | 3 enemies | **Wanderlust** | +3 m movement; moving doesn't provoke Opportunity Attacks; unarmed attacks +1d4 Thunder |
| II | 7 | 4 enemies | **Restless Wind** | Advantage on DEX saves; +1 reaction; once per turn, Zephyr Strike costs no bonus action |
| III | 12 | 5 enemies | **Aspect of Curiosity** | +3 DEX; another +1 reaction; **Fool's Luck**: once per round, the first attack against you misses |

Aspect card: **Leap of Faith**. VFX: Haste. All bonuses need no armour / no shield.
