---
id: 21.04/Unbound/DESIGN
owner: Lead Class Designer
state: built by the Owner in the Toolkit (ARC-0026, WB51), playtested to level 8; design WB0–WB62 — the Owner's changes of 2026-10-23 (WB52–WB61) folded in
reviewed: 2026-10-16 ARC-0022 — written from DECISIONS.md (WB0–WB44) and REFINE_Unbound.md; 2026-10-16 ARC-0022 — balance pass approved (WB45–WB48), sizes in 25; 2026-10-17 ARC-0022 — propagation, no change; 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — P8 fix applied, no change; 2026-10-17 ARC-0026 — stage 1 complete, WB50 checked, no change; 2026-10-17 ARC-0026 — stage 2 applied, no change; 2026-10-17 ARC-0026 — Toolkit guides per level (the Owner types), no change; retired entries kept (OR-10); 2026-10-18 ARC-0026 — WB51 (rebuild from zero, OR-59 ids) checked, no change; 2026-10-23 ARC-0026 — WB52–WB62 (the Owner's Toolkit changes: Zephyr: Tempest, Ally Tempest, Unleashed Winds, the Windswept split in the defences) folded in
---

# The Windborn (internal: Unbound) — 0 · The Fool · Aspect of Curiosity

> Design document for the Arcana's subclass **The Windborn**: identity, the Open Road and every one of its rules, every
> card and passive, the Aspect Awakening, the progression and the technical pattern. Decisions are in `DECISIONS.md`
> (WB0–WB62); the review behind them is `REFINE_Unbound.md` (ARC-0022). Every gameplay effect lives in Stats, Osiris
> and Khonsu, so the subclass runs in **both editions**.
>
> **Numbers live in `25_Master_Data`** (ADR-0005). Where a value is needed this document says *(25)*; the sizes were approved in the
> balance pass (WB45–WB48) and live in `*_Unbound_*`. Level placement, which rule applies when and what each piece does are design and final
> unless a test proves them wrong.

---

## 1. The subclass in one page

The Windborn is the Arcana who **fights like the wind**: an unarmoured, open-handed wanderer. Every enemy the wind
touches becomes **Windswept**; the wind carries the Windborn to the ones it hasn't touched yet (**Zephyr Strike**), keeps
the touched ones from striking at the party, and gathers in **Aeolus' Bag** until she opens it and lets one of the
winds blow over the battle.

Her question every turn is the axis **Position**: *where is everyone, and where do I go?* Touch many at once and the
party walks free and the bag fills; keep enemies untouched and the wind carries her to them.

**Core rule (The Open Road):** *the wind marks every enemy you touch; Zephyr Strike carries you to the ones it hasn't
touched yet, and Aeolus' Bag releases what it has gathered.*

**Fantasy:** *"Weightless, fast, and always exactly where you need to be."*
**Role:** a mobile unarmed striker and a party supporter in equal measure (WB19).

---

## 2. Identity

### 2.1 The card — 0 · The Fool

A young traveller steps toward a cliff edge, looking up, not down; a white rose in one hand, a small bundle on a staff
over the shoulder, a small dog at the heels, the sun behind. The number is **0** — the beginning before every
beginning. Upright: beginnings, the leap, curiosity; reversed: recklessness (Waite, 1910). In the Thoth deck Atu 0 is
attributed to **Air** (Crowley, 1944) — the primary-source link to the wind. Citations are checked in the primary text
before any shipped text quotes them (DM-S7).

| Reading or image | Where it lives |
|---|---|
| The first step of the journey | **The Open Road** (core rule); Tier I **The First Step** |
| Air (Thoth) | The whole kit is wind: Zephyr Strike, the four winds, Weightless |
| The small dog, the companion on the road | Tier II **Fellow Travellers** — the party carries the wind |
| The leap into the unknown | Tier III **Into the Storm**; the Rush into the untouched (Leap of Faith retired, WB55) |
| Number 0 | **The Calm** — Beaufort force 0, the Fool's zero |
| The bundle carried light | No armour, no weapons (chassis) |
| Reversed: recklessness | The Windborn's weakness — she goes where no one is guarding her |

### 2.2 The Aspect — Curiosity

Playing the mechanic *is* curiosity: the Rush rewards only the enemy she hasn't touched yet, so she is always pulled
toward the next one, never the same twice in a row. In the myth, curiosity opens the bag of winds (§2.4).

### 2.3 Mystra and the Weave

*Mystra wove the Windborn from the first step of every journey, a thread that answers only to curiosity and the open
road* (`31.01` §5, to be renamed with ARC-0021). The Weave shows as wind pulled and released: Ready: Gale Deflection
pulls a thread of wind back into reach; the bag gathers what the wind has touched.

### 2.4 References

| Source | What it lends |
|---|---|
| **Aeolus and the bag of winds** (Homer, *Odyssey* X) — the keeper of the winds binds them in a bag and leaves only Zephyrus free to carry Odysseus home; the crew opens the bag out of curiosity and every wind breaks loose | **Aeolus' Bag** (the ultimate: a controlled opening); **Zephyr Strike** (the free wind that carries you); **Where the Winds Meet** (every wind at once) |
| **The Anemoi** (Hesiod, *Theogony*; Homer) — Boreas, Notus, Eurus, Zephyrus | The winds of the bag and their domains (§4.6) |
| **The Beaufort scale** — wind force 0 (calm) to 12 (hurricane) | Real model: Zephyr's ranks Breeze · Gale · Storm · Hurricane (levels 1/4/8/12); **The Calm** (force 0) |
| **Aang and the Air Nomads** (*Avatar: The Last Airbender*) | The monk-like chassis, evasion, deflecting missiles (Gale Deflection), the glider (Untethered), the air scooter (the Rush), a people who protect and carry others (the party support) |

### 2.5 Identity Sheet

| Field | Answer |
|---|---|
| The card and why | 0 · The Fool — the first step, the leap, Air (§2.1) |
| Aspect and why | Curiosity — always the next, untouched enemy (§2.2) |
| Mystra and the Weave | Woven from the first step of every journey (§2.3) |
| Myth | Aeolus' bag of winds and the Anemoi (§2.4) |
| Science / real source | The Beaufort scale (§2.4) |
| Fictional characters | Aang and the Air Nomads (§2.4) |
| Reference powers | Air scooter → Rush; glider → Untethered; deflection → Gale Deflection; the Air Nomads carrying others → the bag and the Open Path |
| Archetype | The wandering air monk |
| Fantasy line | *"Weightless, fast, and always exactly where you need to be."* |
| Role | Mobile unarmed striker and party support, balanced (WB19) |
| Specialist or versatile | Versatile |
| Play style | Each turn: whom to touch, whom to leave untouched for the Rush, and when to open the bag |
| Combat style | Melee, very mobile; turn 1 marks wide or rushes to the back line, turn 2 opens the bag, turns 3–4 ride the wind |
| Strengths / weaknesses | Mobility, reach to any enemy, party movement and protection, many targets touched · no armour ever, low sustain (Flow State's THP only), mostly single-target damage, weaker in duels outside a wind |
| Chassis | §3 |
| Colour, emoji, VFX | Yellow `#f2c939` · 🍃 · Haste |
| Voice | Class description, panel line and tag line in `31.01` §5; she is **not** a rebel against Mystra (unbound means free to move), not a storm-calling caster (her wind is in her hands and feet), not a brawler who stands and trades blows |

---

## 3. Chassis

| Field | Value |
|---|---|
| Spellcasting / secondary | Intelligence / **Dexterity**; Intelligence also in the AC (Be the Leaf, WB21) |
| Saving throws | Dexterity, Wisdom |
| Armour | **None** — every Windborn passive, card and status needs no armour and no shield |
| Weapons | None (unarmed) |
| Skills (choose 4, then 2 Expertise) | *The Wanderer*: Acrobatics, Animal Handling, Nature, Perception, Survival, Stealth, Sleight of Hand, Athletics |
| Ability preset | Favours **DEX and INT** (25; closes `10.06` #12 for the Windborn) |
| Starting gear | Windborn robe (cloth), no weapon |
| Sound set | Monk |

---

## 4. The Open Road

### 4.1 The core rule — *The Open Road* (level 1)

One passive teaches it once (WB27); cards don't repeat it in their tooltips.

- **Windswept** (WB8, WB9): an enemy becomes Windswept when **any attack of yours hits it**, or when it **fails a saving
  throw against any effect of yours**. It lasts **until the end of your next turn**.
- **The Open Path** (WB10): a Windswept enemy **can't make opportunity attacks**.
- **Zephyr Strike** (WB5, WB18): after an unarmed attack or one of your cards, you can make a Zephyr Strike as a bonus
  action. Against an enemy that **isn't Windswept** it is a **Rush** — the wind carries you to it (range (25)) and you
  strike. Against a Windswept enemy it is a plain strike. When every standing enemy is Windswept there is no Rush:
  opening the bag reopens the road. The Rush reaches **9 m at every rank** and costs, beside the bonus action, **the
  movement it covers** (WB52).

### 4.2 Zephyr Strike in ranks (WB4, WB6, WB16, WB17)

| Level | Rank | Zephyr Strike | Aeolus' Bag | Weightless |
|---|---|---|---|---|
| 1 | **Breeze** | The Rush to an unmarked enemy | (level 2) Boreas, Notus; wind cap (25) | rank 1 |
| 4 | **Gale** | + pushes the target (25) m | + Eurus; cap (25) | rank 2 |
| 8 | **Storm** | + casting a Rush grants **one more Rush** the same turn: to **any enemy, Windswept or not**, within 12 m, for half the movement it covers (WB53) | cap (25) | rank 3 |
| 12 | **Hurricane** | — | the bag releases **two winds at once**; cap (25) | rank 4 |

Each rank is announced at level-up ("your wind grows: …") — the Windborn's exception to the standard's empty levels
4 and 8 (WB16).

### 4.3 Aeolus' Bag — the ultimate (level 2; WB11–WB15, WB23)

- **Bonus action.** Needs **at least one Windswept enemy**.
- **Choose one wind** from the bag (§4.6). It blows for **X turns**, X = Windswept enemies when you open it, capped by
  Zephyr's rank. The bag can't be opened again while a wind blows.
- **Exhale:** opening the bag **clears every mark**; the road reopens.
- **The wind sweeps:** while a wind blows, **at the start of your turn it sweeps every mark away**. Marks therefore work
  through the whole round (the Open Path, the bane) and the road reopens each turn of wind. The sweep doesn't extend the
  wind, and a wind already blowing is never refreshed (WB60).
- **Boon and bane:** the wind's boon is for allies; its bane falls on **Windswept** enemies.
- **Hurricane (level 12):** choose two winds; both blow for the same X.

### 4.4 The Calm — Aspect card (Tier I; WB25)

Created card, free, once per combat (standard §5.6). **Usable only while a wind blows.** The wind stops at once; each
turn it had left becomes a gust of (25) Thunder on every Windswept enemy; every mark is swept (each counts for the
Awakening) and the bag can be opened again immediately. **Action** (WB48), so the bag can reopen the same turn.

### 4.5 Unleashed Winds — capstone (level 11; WB56)

**Action**, level-6 slot. **Not while the bag is open.** Choose a point within 18 m; every enemy within 9 m of it makes a
**Strength** saving throw. On a failure it takes (25) Thunder, a **Windswept** enemy is **pulled 6 m to the centre** and any
other is **thrown 6 m away**, and all of them are Off Balance; on a success, half damage. The four winds scatter the field
by the marks: the touched are gathered, the untouched are cast out. The mirror of The Calm. (Replaces Where the Winds
Meet, WB46, WB49, WB50.)

### 4.6 The winds (WB15)

| Wind | Joins the bag | Allies (boon) | Windswept enemies (bane) |
|---|---|---|---|
| **Boreas**, the North Wind | Breeze (level 2) | +(25) m movement | −(25) m movement |
| **Notus**, the South Wind | Breeze (level 2) | Ranged attacks against them have Disadvantage | −(25) on saving throws |
| **Eurus**, the East Wind | Gale (level 4) | +(25) attack rolls | −(25) attack rolls |
| *Zephyrus*, the West Wind | — not in the bag: it is Zephyr Strike | | |

Eurus is weighed against the others so it isn't always the right choice (DM-B5).

### 4.7 Gears

| Creates | Changes | Spends | Reads |
|---|---|---|---|
| any hit; failed saves against your cards; Riposte and Gale Deflection hits; allies' hits (Tier II); Unleashed Winds | Gale push, Wind Blast, Gale Burst (move marked enemies); Unleashed Winds (pulls the marked, throws the rest); Storm's second Rush | **Aeolus' Bag** (opening and sweeps); **The Calm** | Zephyr Strike (Rush or not); the Open Path; the bag (X, the bane's targets); Zephyr: Tempest and Ally Tempest (bonus on the marked); Wind Whispers, Gale Deflection, Empty State (which attackers they answer); the Awakening |

### 4.8 Both sides of the field

- **Windswept** lands only on enemies. Allies are never marked.
- **The winds:** boon on allies, bane on Windswept enemies only. No wind harms an ally.
- **Pushes and pulls** (Gale, Wind Blast, Gale Burst, Unleashed Winds) move enemies only; the player aims them and
  chooses the point of the pull, so an enemy pulled next to an ally is a choice, not a rule.

### 4.9 Resolution order

1. **A hit or a failed save:** the effect resolves (damage, push), then the target becomes Windswept.
2. **Zephyr Strike:** whether it is a Rush is read **when it is cast** (the target's state before the strike). At Storm,
   casting the Rush grants the second Rush (WB53).
3. **Start of your turn, wind blowing:** sweep every mark → count each for the Awakening → Tier III pushes each swept
   enemy → the turn begins.
4. **Opening the bag:** count X (standing Windswept enemies, capped) → clear the marks (each counts) → the chosen wind
   starts for X turns.
5. **The Calm:** read the wind's remaining turns R → R gusts on each Windswept enemy → sweep (each counts) → the wind
   ends → the bag can open.
6. **Unleashed Winds:** Strength save → damage → pull (Windswept) or push (the others) → Off Balance → mark.

What ends a mark: the end of your next turn, a sweep, opening the bag, The Calm, the target's death, the end of combat.

### 4.10 Worked example (level 4, Gale)

Four enemies: two goblins on the fighter, an orc mid-field, an archer on a roof.

| Turn | The Windborn | State after |
|---|---|---|
| 1 | Wind Blast — goblins and orc fail → marked. Zephyr (after the card): Rush to the archer, Gale push off the roof → marked | 4 marked |
| Allies | The fighter leaves the goblins with no opportunity attack (the Open Path) | 4 marked |
| 2 | Punch goblin 1 (already marked). Bonus action: open the bag — X = 4, capped by Gale; choose Eurus (allies +attack). Marks cleared, 4 counted | 0 marked; Eurus blows |
| 3 | The wind sweeps (nothing to sweep). Punch the orc → marked, suffers Eurus's bane. Zephyr: Rush to goblin 2 (unmarked) → marked | 2 marked |
| 4 | The wind sweeps the 2 marks (counted). The road is open again | 0 marked |

Checked against the rule sentence: every mark comes from a touch, every Rush goes to an untouched enemy, the bag
releases what was gathered.

### 4.11 Edge cases

- **A duel:** the first hit marks the only enemy, so the Zephyr is a plain strike; the bag (X = 1) is the way to reopen
  the road, and while it blows the sweep reopens it every turn (WB18).
- **Summons and neutrals** made hostile count as enemies; dead enemies don't count for X.
- **Armour or a shield:** every Windborn passive, card and status stops working while worn.
- **Zephyr after a card that doesn't attack** (Flow State, Untethered): the next Zephyr may Rush to any unmarked enemy.

---

## 5. Cards

| Card | Level | Action | Gear | What it does | Decision |
|---|---|---|---|---|---|
| **Gale Burst** | 1 | Action | creates, changes | 9 m; STR save: Thunder, pushed, Prone; half on a success | WB28 |
| **Wind Blast** | 3 | Action | creates, changes | 12 m line; STR save: pushed, Off Balance; clears clouds and Burning — the wide marker | WB30 |
| **Wind Whispers** | 5 | Bonus | creates | 2 turns: melee attacks against you **by enemies that aren't Windswept** have Disadvantage; Riposte when one of them misses (marks; the reaction asks); jumping costs no bonus action; usable out of combat | WB33, WB57, WB58 |
| **Flow State** | 6 | Action | (enabler) | THP and one extra bonus action, for (25) turns within the reference fight; usable out of combat | WB31, WB58 |
| **Ready: Gale Deflection** | 6 | (reaction card, level 3) | creates | Until combat ends, one Gale Deflection per turn against ranged attacks **by enemies that aren't Windswept**, for you or an ally nearby; the returned missile marks | WB32, WB57 |
| **Zephyr: Tempest** | 7 | Bonus | reads | Level-4 card; 3 turns: your unarmed hits **against Windswept enemies** deal extra (25) Thunder and inflict Reverberation; upcasts at 5 and 6 | WB54 |
| **Untethered** *(ability card)* | 9 | Action | (identity) | Fly; +(25) AC while flying (Eye of the Storm folded in) | WB35 |
| **Zephyr: Ally Tempest** | 10 | Bonus | reads | Level-5 card on an ally; 5 turns: their weapon hits **against Windswept enemies** deal extra (25) Thunder and inflict Reverberation; upcast at 6 | WB55 |

**Created cards:** Zephyr Strike (§4.1, §4.2), The Calm (§4.4). **Features:** Aeolus' Bag (§4.3), Unleashed Winds
(§4.5). **Retired:** True Strike (WB29), Evasive Flow (WB36), Thunderclap (WB37), Storm Fists (WB54), Leap of Faith
(WB55), Where the Winds Meet (WB56). Blade Ward, Aeolus' Bag and The Calm can be used out of combat (WB58).

---

## 6. Passives

| Passive | Level | Effect | Decision |
|---|---|---|---|
| **The Open Road** | 1 | The core rule (§4.1) | WB27 |
| **Be the Leaf** | 1 | AC = 10 + DEX + INT; doesn't stack with Mage Armour | WB21, WB40 |
| **Flowing Strikes: Agility** | 1 | Unarmed attacks use DEX if higher | WB41 |
| **Flowing Strikes: Precision** | 1 | Unarmed damage die by level | WB41 |
| **Weightless** | 1 · 4 · 8 · 12 | Movement speed, jump distance and falling damage improve with Zephyr's ranks; announced at each rank | WB39, WB47, WB59 |
| **Flowing Assault** | 5 | Extra Attack | WB41 |
| **Magic Strikes** | 7 | Unarmed attacks count as magical | WB41 |
| **Empty State** | 9 | Against **Windswept** attackers: half damage from their hits; Evasion against their DEX saves | WB42, WB57 |
| **0 - The Fool: Awakening** | 3 | Explains the goal and tiers (§8) | WB22, WB24 |

**Retired:** Twinkle Toes and Feather Fall (merged into Weightless, WB39), Eye of the Storm (WB35), Momentum (WB37).

---

## 7. Statuses

| Status | On | Shows | Notes |
|---|---|---|---|
| **Windswept** | enemies | icon + ForceOverhead; turns left on the icon | Blocks opportunity attacks; the bane's target |
| **The wind** (one per wind: Boreas, Notus, Eurus) | allies (boon) and Windswept enemies (bane) | icon with turns left | Lasts X; ends early with The Calm |
| **The bag is open** | the Windborn | icon with turns left | Blocks opening the bag; the cue for The Calm and the capstone |
| **Zephyr Strike** (existing `ZEPHYR_STRIKE`) | the Windborn | created card in hand | Rush or plain strike by target |
| **Storm: the wind doesn't stop** (`ZEPHYR_RUSH_STORM`) | the Windborn | hidden; grants the second Rush | Granted when the Rush is cast; ends when the second Rush is cast (WB53) |
| **Zephyr: Tempest** (`ZEPHYR_TEMPEST`, `_2`, `_3`) | the Windborn | icon + ForceOverhead, 3 turns | Bonus Thunder and Reverberation on the marked (WB54) |
| **Zephyr: Ally Tempest** (`ZEPHYR_TEMPEST_ALLY`) | an ally | icon, 5 turns | Bonus Thunder and Reverberation on the marked (WB55) |
| **Awakening progress** | the Windborn | counter (ARC-0007 pattern) | Marks released toward the next tier |
| **Tiers I–III** | the Windborn | tier status with its bonus | §8 |

---

## 8. Aspect Awakening — 0 · The Fool

**Goal (WB22):** count the **Windswept marks the wind releases** — by opening the bag, by its sweeps and by The Calm —
cumulative within the fight. Progress shows as a counter. Goals per tier (25).

| Tier | Level | Name | Bonus (until combat ends) |
|---|---|---|---|
| I | 3 | **The First Step** | Your first Rush each turn costs no bonus action — Zephyr and the bag can share a turn. Grants **The Calm** |
| II | 7 | **Fellow Travellers** | Your allies' hits also mark Windswept |
| III | 12 | **Into the Storm** | Each sweep of the wind pushes every swept enemy (25) m and leaves it Off Balance |

No tier gives an ability bonus (`10.06`: the old +3 DEX goes). VFX: Haste.

---

## 9. Progression

### 9.1 Level table (WB43)

| Lvl | Arrives | Headline | New concepts |
|---|---|---|---|
| 1 | The Open Road (Windswept, Open Path, Zephyr's Rush), Be the Leaf, Flowing Strikes, Weightless 1, Gale Burst | "The wind marks what I touch and carries me to the rest" | 3 (mark, Open Path, Rush) |
| 2 | Aeolus' Bag (Boreas, Notus) | "I can open the bag" | 2 (the bag, winds) |
| 3 | Tier I The First Step + The Calm; Wind Blast | "My Aspect wakes; I can stop the wind" | 2 (Awakening, The Calm) |
| 4 | Gale: push, Eurus, longer wind, Weightless 2 | "My Zephyr pushes; a new wind" | 1 (push) |
| 5 | Flowing Assault; Wind Whispers | "Two strikes; the air warns me" | 1 (Riposte) |
| 6 | Flow State; Ready: Gale Deflection | "I flow; I turn arrows back" | 2 |
| 7 | Tier II Fellow Travellers; Magic Strikes; Zephyr: Tempest | "The party carries my wind" | 1 (allies mark) |
| 8 | Storm: second Rush, longer wind, Weightless 3 | "The wind doesn't stop" | 1 (chain) |
| 9 | Untethered; Empty State | "I fly; blows barely touch me" | 1 (flight) |
| 10 | Zephyr: Ally Tempest | "My wind fights beside them" | 1 (allies strike the marked) |
| 11 | Unleashed Winds | "I unleash the four winds" | 1 (pull the marked, throw the rest) |
| 12 | Tier III Into the Storm + Hurricane (two winds), Weightless 4 | "The storm" | 1 (sweeps push) |

Every level has a headline; no level is empty; levels 4 and 8 carry only Zephyr's ranks (WB16).

### 9.2 The arc

| Part | Levels | What the player feels |
|---|---|---|
| Introduce | 1–3 | The wind marks and carries; the bag; the Aspect wakes |
| Develop | 4–7 | The wind pushes, strikes twice, deflects, and the party carries it |
| Turn | 8–10 | The wind doesn't stop: chains, flight, the wind lent to the party |
| Conclude | 11–12 | She gathers the field and becomes the storm |

### 9.3 The peak

Tier I is reachable on turn 2 of a reference fight at level 3 (open the bag with the first marks); the level-12 peak (the
sweeps that push, two winds) shows on every turn of wind from the second turn on. Checked again with the goals in the
balance pass (DM-J6).

---

## 10. How it plays

Turn 1: mark wide (Wind Blast, Gale Burst) or rush to the back line. Turn 2: open the bag with what was gathered — the
party gets its wind, the marked enemies its bane, and the road reopens. While the wind blows, every turn starts with a
clean road: rush to the untouched, mark, and let the sweep carry the count toward the Aspect. When the fight needs it,
The Calm cashes the remaining wind and reopens the bag; at level 11 the four winds are unleashed — the marked are gathered, the rest thrown back — for the
storm of level 12.

---

## 11. Text

Names (WB44): Windswept · The Open Road · Zephyr Strike · Breeze, Gale, Storm, Hurricane · Weightless · Aeolus' Bag ·
Boreas, Notus, Eurus · The Calm · Unleashed Winds · Zephyr: Tempest · Zephyr: Ally Tempest · The First Step, Fellow
Travellers, Into the Storm; the passive is **Zephyr**, its ranks **Zephyr: Gale / Storm / Hurricane** (WB61). The wind is
Zephyrus, **the West Wind**, in the texts (WB61). Display name **The Windborn** (WB0). Descriptions follow `31.03` and the class voice (`31.01` §5); written in `32.01/Unbound.md`.

---

## 12. Balance notes (for the balance pass)

- Watch: **Eurus** (party attack bonus — bounded accuracy, standard §8.3); **Tier II** (allies mark — the bag fills
  fast); **Storm's** second Rush (an extra attack per turn, any target since WB53); **Tier III** mass push; **Unleashed
  Winds**; **Zephyr: Tempest** and **Ally Tempest** (two damage riders on the marked, WB54–WB55).
- The bag's **uptime** in a reference fight (X capped by rank; the sweep doesn't extend it).
- **Weightless** values: today's speed bonus reaches +38 m at level 12 — re-cost against vanilla and the reference fight.
- **Flow State** duration within the fight (B6); the Awakening goals against the peak timeline (J6).
- Benchmark: the Monk for the striker share, a support class for the rest (WB19).

---

## 13. Technical pattern

### 13.1 Osiris goals

`ARCANA_Aspect_Fool.txt` is rewritten: apply Windswept from hits (the "hit" hook it already uses for the per-round
goal) and from failed saves (in each card's Stats, `ApplyStatus` beside its effect); count marks released (opening,
sweeps, The Calm); the sweep at the start of the Windborn's turn while the wind status is on her (**T2**: the turn-start
hook — confirm in `56`/`57`); tiers by the released count. Combat start and end: `EnteredCombat` / `CombatEnded`
(already used by the mod).

### 13.2 Patterns

| Piece | Pattern |
|---|---|
| Zephyr's Rush | `Rush_SpringAttack` (as vanilla `Rush_MAG_ZephyrFlash`) with a target condition on Windswept; `Movement:Distance` in its costs (WB52) |
| Zephyr: Tempest / Ally Tempest | A BOOST status with `IF(… HasStatus('WINDSWEPT',context.Target)):DamageBonus(…,Thunder)` and a passive applying vanilla `MAG_THUNDER_REVERBERATION` once per attack |
| Storm's second Rush | A status granted on casting the Rush unlocks a second Rush spell (`UnlockSpell`), removed when it is cast |
| Unleashed Winds | `Target_Shatter` pattern (a point on the ground, an area around it); STR save; `Force(-6, OriginToTarget)` on Windswept, `Force(6, OriginToTarget)` on the others |
| The winds | Aura-style statuses (vanilla `AURA_OF_PROTECTION`) or statuses applied to the party; bane on Windswept |
| The bag's choice | One variant per wind (container) |
| Weightless | One generator table (`82_Automation/stats/`), four ranks |

### 13.3 Master data (25)

`*_Unbound_*` entries are written in the balance pass with every (25) of this document.

### 13.4 Ids

Ids keep the `Arcana_` / `ARCANA_` prefixes and the literal `Card_Spell` / `Card_Ability` / `Created` / `Util`
segments (ADR-0002, `33.03`); internal name **Unbound** stays.

---

## 14. Open

- Sizes the playtest may move: Storm's second Rush, Hurricane, Tier III push (§12).
- Vanilla loca collision check of the names (ARC-0021).

## 15. To test in game

1. A Rush provokes no opportunity attacks and paths around obstacles (T2).
2. Windswept from a failed save on each card; from Riposte and Gale Deflection.
3. The Open Path: a Windswept enemy makes no opportunity attack on an ally.
4. The bag: X counted and capped; marks cleared; the sweep at the start of the turn while the wind blows; the bag
   shut while it blows.
5. The Calm: gusts = remaining turns; the bag reopens.
6. Unleashed Winds: refused while the bag is open; STR save; Windswept enemies pulled in, the others thrown out (WB56).
7. Storm: casting the Rush grants a second Rush to any enemy within 12 m (WB53).
8. Tier II: an ally's hit marks; Tier III: sweeps push.
9. Armour or a shield turns everything off.
10. Zephyr: Tempest and Ally Tempest: extra Thunder and Reverberation only on Windswept targets (WB54, WB55).
