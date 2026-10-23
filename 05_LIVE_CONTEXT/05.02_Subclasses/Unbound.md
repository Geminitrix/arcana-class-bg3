---
source: 51 (Progressions, Lists, Stats, Story) — read from the game on 2026-10-23 (dump_progression.pl, dossier_texts.pl, the Editor .stats, ARCANA_Aspect_Fool.txt)
synced_at: 2026-10-23 (after the Owner's Toolkit build, commit 60afc0e)
state: synced
reviewed: 2026-10-17 ARC-0022 — the game is unchanged (still the old Unbound build); the approved redesign (WB0–WB48) lives in `21.04_Subclasses/Unbound/DESIGN.md` until its build ships; 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — QA-0004: 7 probes pass, the Owner's probe edits live in the game, stage 1 complete (all 9 probes pass); stage 2 applied (probes removed, the Open Road in the game; see the build note); 2026-10-17 ARC-0026 — the build moves to the Toolkit guides per level; retired entries kept (OR-10); 2026-10-23 ARC-0026 — rewritten from the game: the Owner's Toolkit build of the Windborn (WB51–WB61) replaces the old Unbound
---

# 🍃 The Windborn (internal: Unbound) — 0 · The Fool · Aspect of Curiosity

> **Built by the Owner in the Toolkit (ARC-0026, WB51–WB61), playtested to level 8 (`QA_ARC-0026`).** Design:
> `21.04_Subclasses/Unbound/DESIGN.md`; decisions WB0–WB62. Text fixes still owed to the game: WB62 (`32.01/Unbound.md`).

> Last verified: **2026-10-23** · Lists "Unbound Level N" · Osiris `ARCANA_Aspect_Fool.txt` · Check with
> `82_Automation/dump_progression.pl`.

---

## 1. Identity

| | |
|---|---|
| **Arcanum** | 0 · The Fool — the start of the journey, freedom, the leap into the unknown |
| **Aspect** | Curiosity |
| **Colour** | Yellow `#f2c939` · 🍃 |
| **Role** | Unarmoured unarmed striker who marks the field and releases it as wind for the party |
| **Fantasy** | "The wind marks what I touch and carries me to the rest." |
| **Voice** | Zephyrus, the West Wind (WB61); Aeolus' bag of winds (Homer); Aang and the Air Nomads |
| **Sound set / dialogue** | Monk |

---

## 2. Chassis

| Field | Value |
|---|---|
| Abilities | Spellcasting **Intelligence** · secondary **Dexterity** |
| Saving throws | Dexterity, Wisdom |
| Armour | **None — by design**: every Windborn passive, card and status needs no armour and no shield |
| Weapons | None (unarmed) |
| AC | **Be the Leaf**: 10 + DEX + INT (`ACOverrideFormula`) |

---

## 3. How it plays

1. **Mark:** any damage she deals makes an enemy **Windswept** until the end of her next turn (The Open Road); her save
   cards mark those who fail. A Windswept enemy can't make opportunity attacks.
2. **Rush:** after an unarmed attack, **Zephyr** offers a bonus action: **Zephyr Rush** (9 m, to an enemy that isn't
   Windswept; costs the movement it covers) or **Zephyr Strike** (a plain strike).
3. **Release:** **Aeolus' Bag** (bonus action, needs a mark) releases one wind for X turns (X = marks, capped 2 / 3 / 4 /
   5 by rank): allies get its tailwind, marked enemies its headwind; the marks are released and each of her turns starts
   with a sweep. **The Calm** cashes the wind left into gusts and reopens the bag.
4. **The split:** the marked and the unmarked are answered differently — the Tempests and Empty State work on the marked,
   Wind Whispers and Gale Deflection against the unmarked (WB57).
5. Released marks wake **The Fool** (3 / 5 / 8).

---

## 4. Level table

| Lvl | Passives | Cards / spells |
|---|---|---|
| 1 | Be the Leaf · Agility · Precision · The Open Road · Zephyr · Twinkle Toes rank 1 (+4 m) | Gale Burst |
| 2 | Aeolus' Bag (hidden) | Aeolus' Bag |
| 3 | **0 - The Fool: Awakening** · The First Step (Tier I, hidden) | Wind Blast · The Calm (from Tier I) |
| 4 | Zephyr: Gale · Twinkle Toes rank 2 (+7 m) | — |
| 5 | Extra Attack (vanilla `ExtraAttack`) | Wind Whispers |
| 6 | — (boosts: the Gale Deflection resources) | Ready: Gale Deflection · Flow State |
| 7 | Magic Strikes · Fellow Travellers (Tier II, hidden) | Zephyr: Tempest |
| 8 | Zephyr: Storm · Twinkle Toes rank 3 (+10 m) | — |
| 9 | Empty State | Untethered |
| 10 | — | Zephyr: Ally Tempest |
| 11 | — | Unleashed Winds (the game text still says "Unleash Winds") |
| 12 | Zephyr: Hurricane · Twinkle Toes rank 4 (+13 m) · Into the Storm (Tier III, hidden) | — |
| 13–20 | — | — |

Hidden: `Monk_SoundSwitch`, `UnlockedSpellSlotLevel1` (L1). The movement passive shows as **Twinkle Toes** in the
game; the design calls it Weightless (WB39) — see WB62.

---

## 5. Cards

Cost = **one Woven Spell Slot** of the card's level (console) or **Threads** (PC). All need no armour and no shield.

| Card | Gained | Card lvl | Action | Effect | Upcast |
|---|---|---|---|---|---|
| **Gale Burst** | 1 | 1 | Action | STR save: 1d10 Thunder, pushed 6 m, Prone 1 turn; half damage on a success | Slots 2–6 (cost only) |
| **Wind Blast** | 3 | 2 | Action | Line; STR save: pushed 5 m, Off Balance 1 turn, **Windswept**; clears clouds and Burning | Slots 3–6 |
| **Wind Whispers** | 5 | 3 | Bonus | 2 turns; usable out of combat: melee attacks by **unmarked** enemies have Disadvantage; **Wind Riposte** (asks first) when one of them misses; jumping costs no bonus action | Slots 4–6 |
| **Flow State** | 6 | 2 | Action | 3 turns; usable out of combat: THP = 2 × Arcana level and +1 bonus action | Slots 3–6 (cost only) |
| **Ready: Gale Deflection** | 6 | 3 | (reaction card) | Until combat ends: reaction against a ranged weapon attack by an **unmarked** enemy, on her or an ally nearby: −(1d10 + DEX + Arcana level) damage; at 0, Redirect (marks). The text says one use per turn; the stats give one use per cast (up to 3) with no per-turn refill — `QA_ARC-0026` L6.3 decides | Slots 4–6 |
| **Zephyr: Tempest** | 7 | 4 | Bonus | Self, 3 turns: unarmed hits on **Windswept** enemies +1d6 + DEX Thunder and 2 turns of Reverberation | Slot 5: 2d6, slot 6: 3d6 |
| **Untethered** *(ability card)* | 9 | 5 | Action | Fly and +2 AC while it lasts | Slot 6 |
| **Zephyr: Ally Tempest** | 10 | 5 | Bonus | An ally, 5 turns: their weapon hits on **Windswept** enemies +1d4 Thunder and 1 turn of Reverberation | Slot 6 |

### Created cards and features

| Card | Source | Cost | Effect |
|---|---|---|---|
| **Zephyr Rush** | Zephyr, after an unarmed attack | Bonus action + the movement it covers | 9 m at every rank, to an enemy that isn't Windswept; unarmed strike. Gale: pushes 3 m. Storm: casting it grants **Zephyr Rush: Storm** — 12 m, any enemy, half the movement, unarmed + DEX Thunder |
| **Zephyr Strike** | Zephyr | Bonus action | A plain unarmed strike (the game shows it as "Zephyr Rush" — WB62) |
| **Aeolus' Bag** | Level 2 | Bonus action; needs a Windswept enemy; usable out of combat | Boreas (allies +3 m / marked −3 m), Notus (ranged attacks on allies at Disadvantage / marked −1d4 to saves), Eurus from Gale (allies +1d4 to attacks / marked −1d4 to attacks); pairs at Hurricane; a blowing wind is never refreshed |
| **The Calm** *(Aspect card)* | Tier I | Action; once per combat; usable out of combat | Only while a wind blows: each turn left becomes a gust (1d8 Thunder) on every enemy under a headwind; marks released; the bag reopens |
| **Unleashed Winds** *(capstone)* | Level 11 | Action + level-6 slot; not while the bag is open | A point within 18 m, 9 m area, STR save: 4d8 Thunder, Windswept pulled 6 m in, the others pushed 6 m out, Off Balance 1 turn; half on a success. Its `TargetConditions` lack an `and` (WB62) |

---

## 6. Passives

| Passive | Lvl | Effect |
|---|---|---|
| **Be the Leaf** | 1 | AC = 10 + DEX + INT |
| **Agility · Precision** | 1 | Unarmed attacks on DEX; unarmed damage die by level (the design's Flowing Strikes) |
| **The Open Road** | 1 | An enemy she damages becomes Windswept (2 of her turns) |
| **Zephyr** · Gale · Storm · Hurricane | 1 · 4 · 8 · 12 | Zephyr Rush / Strike after an unarmed attack; Gale: push 3 m and Eurus; Storm: the second Rush; Hurricane: two winds |
| **Twinkle Toes** (Weightless) | 1 · 4 · 8 · 12 | Speed +4 / +7 / +10 / +13 m; jump ×1 / ×2 / ×3 / ×4; falling damage full / half / half / none |
| **Extra Attack** | 5 | Vanilla |
| **Magic Strikes** | 7 | Unarmed attacks count as magical |
| **Empty State** | 9 | Against **Windswept** attackers: half damage; Evasion on their DEX saves |

---

## 7. Aspect Awakening — 0 · The Fool

**Objective — release Windswept marks** (opening the bag, its sweeps, The Calm), cumulative within the fight; goals
**3 / 5 / 8** (`ARCANA_Aspect_Common.txt`).

| Tier | Level | Name | Bonus (until combat ends) |
|---|---|---|---|
| I | 3 | **The First Step** | The first Zephyr Rush each turn costs no bonus action; grants The Calm |
| II | 7 | **Fellow Travellers** | Allies' hits also mark Windswept |
| III | 12 | **Into the Storm** | Each sweep pushes every swept enemy 3 m and leaves it Off Balance |

VFX: Haste. Retired and unreachable (OR-10): Fool's Luck (`Interrupt_Arcana_Aspect_FoolsLuck`).
