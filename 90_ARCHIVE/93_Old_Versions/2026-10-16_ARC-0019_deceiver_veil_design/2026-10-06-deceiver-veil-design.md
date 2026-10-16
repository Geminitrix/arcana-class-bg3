# Arcana — The Deceiver, reworked: The Veil (II · The High Priestess · Aspect of Doubt)

Design approved by the user on 2026-10-06 (direction B, the engine rules, the Doubles' form and turns).
Numbers are drafts until the balance pass. This raises the Deceiver to the **Depth Model** (Heartweaver
spec §2) without losing LeBlanc's core: **Sigil of Malice, Distortion, Ethereal Chains, Mimic, Mirror Image**.

Everything is Stats + Osiris, so the console edition plays it; the PC edition adds only the deck layer.

---

## 1. Decisions

| # | Decision | Source |
|---|---|---|
| D1 | Arcanum changes from III · The Empress to **II · The High Priestess** — secrets, the veil, the two pillars of truth and lie; Mystra is the **Lady of Mysteries**. | user |
| D2 | Aspect of Love becomes **Aspect of Doubt** (a point on Plutchik's wheel, next to the Heartweaver's Unbelief). The subclass keeps the name **Deceiver**. | user |
| D3 | Engine **"The Veil"**: **Doubles** (illusory copies) on the field and **Doubt** on enemies. | user |
| D4 | Doubles are **summoned entities with 1 HP** that copy her look, carry the Invoke Duplicity shimmer, have **fixed** stats and damage (no level scaling — what grows is how many), up to **3 → 4 → 5**. | user |
| D5 | Each Double has **its own turn, player-controlled**, with a **minimal kit**: movement + 1 action; no bonus action, no reaction, no weapon attacks. | user |
| D6 | Doubles are **immune to loss-of-control** effects (Charmed, Madness, Possessed/Dominated, fleeing Fear). | user |
| D7 | She gains **+1 AC per Double** on the field. | user |
| D8 | **Mirror Image** stops being the full clone and becomes the card that summons Doubles. | user |
| D9 | **Distortion** leaves a Double where she stood; **Withdraw** swaps places with it. | user |
| D10 | **Mental Prison + Hypnotic Gaze** merge into one card, stronger against Doubt. **Terrify** leaves (fear belongs to the Heartweaver). **Hostile Takeover** becomes **Grand Deception**. **Ready: Instinctive Charm** and **Ready: Hollow Image** leave (the Doubles and Doubt take their roles). Telepathy, Faceless and Friends stay. | user |
| D11 | Faceless: Copy gets a cleaner script (see §9.3; the "Rulebook" check needs the user's meaning). | user |
| D12 | Internal ids of the Awakening plumbing keep the word *Empress* (`ASPECT_AWAKENED_EMPRESS`, `ARCANA_Aspect_Empress.txt`…); only player-facing text changes. Same rule as the legacy folder name `AspectClass`. | proposal |
| D13 | Colour stays pink `#f83fa5` (the Black Rose); the emoji stays 🪞. | proposal |
| D14 | **Friends** becomes a **level-1 spell**; its **level-6 upcast** (`Target_Arcana_Util_Friends_6`) carries what Faux Amis did — Friends without Concentration that the target never notices, unchanged in higher difficulties. **Faux Amis stops being a separate grant** (`Target_Arcana_Util_Friends_EX` and the level-13 list entry go). | user, 2026-10-06 |
| D15 | **Malicious Whispers** keeps its own Doubt rider: on a Sigil-marked target it gives **2 Doubt** (its rider + the detonation). A cantrip's bonus. | user, 2026-10-07 |
| D16 | **No lower caps:** Doubles stay 3 / 4 / 5 and +1 AC each (up to +5). Keeping five alive costs slots and survival, so the ceiling is rarely reached. | user, 2026-10-07 |
| D17 | **Mirror spells deal half of her own spell:** the Double casts with the dice of her card at her highest slot, halved: `DealDamage((Nd6)/2,Force)`, N = 3 at levels 5–6, 4 at 7–8, 5 at 9–10, 6 at 11+ (variants `_3`…`_6`, Osiris gives the one for her level). Shatter stays 1d6. Replaces the fixed 1d4. | user + proposal, 2026-10-07 |

---

## 2. Depth Model after the rework

| # | Criterion | Before | After |
|---|---|---|---|
| M1 | Engine of its own | Sigil combo only | **Doubles + Doubt**, with the Sigil feeding Doubt |
| M2 | Levels unlock rules | ❌ | Doubles (1) → Mirror spells (5) → cap 4 (7) → Unveil (9) → cap 5 (12) |
| M3 | Generate / convert / spend | no converter | Generate: Mirror Image, Distortion, Grand Deception · Convert: Doubles' Unveil swap, Mimic · Spend: Shatter, Sigil detonation, The Veil Lifts |
| M4 | Allies play too | ❌ | Doubles are bodies on the field that shield allies (AC, decoys, Shatter around them); Grand Deception protects the party |
| M5 | Awakening = engine climax | Sigil detonations | Doubt applied |
| M6 | Readable | ✅ | Doubt shows its stack count on the portrait; Doubles shimmer |
| M7 | Real source + Mystra | LeBlanc only | LeBlanc + the High Priestess + Mystra, Lady of Mysteries |
| M8 | No SE in the engine | ✅ | ✅ |

---

## 3. The engine: The Veil

### 3.1 Doubles

| Rule | Value |
|---|---|
| What | A summon of the vanilla Duplicity template (`8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8`), `Transform`ed into her look; **1 HP**, fixed AC 12, no level scaling |
| Cap on the field | 3 at level 1 · 4 at level 7 · 5 at level 12. Summoning past the cap destroys the oldest Double (it does **not** shatter) |
| For her | **+1 AC per Double** (status `VEIL_LAYER_1`…`_5`, kept in sync by Osiris) |
| Turn | Own turn, player-controlled. Movement + 1 action. No bonus action, no reaction |
| Kit, level 1 | **Shatter** (action): the Double bursts — 3 m, **1d6 Psychic** (fixed), **1 Doubt** on each enemy hit; the Double dies |
| Kit, level 5 (*Two Truths*) | **Mirror: Sigil of Malice**: half her Sigil, `(Nd6)/2` Force (D17), and lays **her** Sigil; **Mirror: Ethereal Chains**: `(Nd6)/2` Force, Restrained 1 turn on a failed save, no second hit |
| Kit, level 9 (*Unveil*) | **Unveil** (action of the Double): swap places with her. Once per round across all Doubles |
| Death by an enemy | The creature that destroyed it gains **1 Doubt** ("it believed the lie") |
| Detonation | A Double's Mirror spells can detonate her Sigils (as the clone does today) |
| Immunities | `SG_Charmed`, `SG_Mad`, `SG_Possessed`, `SG_Fleeing`, and Dominate |
| Common actions | Only **Dash** and **Disengage** (no Throw, Shove or Help); **Dismiss** is free | 
| Never | Weapon attacks, healing, concentration, cards (their spells are `_Deceiver_Clone_` spells, never in the deck) |
| Ends | At the end of combat or a Long Rest; on her death |

### 3.2 Doubt (on enemies)

| Rule | Value |
|---|---|
| Stacks | Up to 3 (`DOUBT_1`, `DOUBT_2`, `DOUBT_3`, one StackId `DOUBT`, raised by Osiris). Lasts 3 turns, refreshed by each new stack |
| Sources | Destroying a Double · hit by Shatter · her Sigil detonating on it · Malicious Whispers on a marked target · Grand Deception |
| Per stack | −1 to Wisdom saving throws and −1 to Attack Rolls against her and her Doubles |
| At the 3rd stack | **Deluded**: Confused for 1 turn (vanilla CONFUSION behaviour); the stacks reset |
| Synergy | Her control cards give **Disadvantage** on the save to a target with 2+ stacks |

### 3.3 Distortion and Withdraw

Distortion teleports her (unchanged, with its Force blast where she lands) **and leaves a Double where she
stood** — it counts toward the cap. **Withdraw** (created card, 2 turns) now **swaps places with that
Double**; if it was destroyed, Withdraw is lost.

---

## 4. Kit and progression

### 4.1 Level table

| Lvl | Passives | Cards / utilities |
|---|---|---|
| 1 | **The Veil** (Doubles cap 3, AC layers, Doubt on a destroyed Double, Shatter) · Telepathy · (hidden) Friends unlock | Sigil of Malice · Malicious Whispers *(cantrip)* · **Mirror Image** *(moved from 7)* · Faceless *(util)* · **Friends** *(util, now a level-1 spell; level-6 upcast = the old Faux Amis)* |
| 2 | — | — |
| 3 | **2 - The High Priestess: Awakening** · *Veiled* (Tier I) | Ethereal Chains · **Veiled Prison** *(Mental Prison + Hypnotic Gaze)* |
| 4 | — | — |
| 5 | **Two Truths** (Doubles learn Mirror: Sigil and Mirror: Chains) | Distortion *(leaves a Double)* |
| 6 | — | — |
| 7 | *Two Pillars* (Tier II) · cap 4 | Mimic |
| 8 | — | — |
| 9 | **Unveil** (Doubles learn the swap) | Marionette |
| 10 | — | — |
| 11 | — | **Grand Deception** *(was Hostile Takeover)* |
| 12 | *Aspect of Doubt* (Tier III) · cap 5 | Mirrored Self · Mirrored Spell |
| 13 | — | — *(Faux Amis is now Friends at level 6)* |

### 4.2 Cards

| Card | Lvl | Card lvl | Role | Effect | Change |
|---|---|---|---|---|---|
| **Sigil of Malice** | 1 | 1 | generator | 18 m auto-hit: Force damage and a Sigil; detonation also adds **1 Doubt** | + Doubt on detonation |
| **Malicious Whispers** | 1 | 0 | generator | 18 m, WIS save: Psychic (`D4Cantrip`), Disadvantage on its next attack; a marked target also can't react **and gains 1 Doubt** | + Doubt |
| **Mirror Image** | 1 | 1 | generator | Summon **1 Double** within 9 m (cap applies). Upcast: 2 Doubles at slot 3+, 3 at slot 5+ | Was the level-7 full clone |
| **Ethereal Chains** | 3 | 2 | control | Unchanged | — |
| **Veiled Prison** | 3 | 2 | control | 18 m, WIS save: **Incapacitated** 10 turns, attacks from within 3 m always crit; it repeats the save at the end of each turn. A target with 2+ Doubt saves with Disadvantage. Concentration · Short Rest · **Unique** | Merges Mental Prison and Hypnotic Gaze |
| **Distortion** | 5 | 3 | mobility | Unchanged + leaves a Double at the origin; creates **Withdraw** (swap) and **Mimic: Distortion** | + Double |
| **Mimic** | 7 | — | converter | Unchanged (recast the last damaging card, bonus action) | — |
| **Marionette** | 9 | 5 | control | Dominate 10 turns; Advantage on the save if Charmed **becomes** Disadvantage on the save if 2+ Doubt. Concentration · Long Rest · **Unique** | Doubt synergy |
| **Grand Deception** | 11 | 5 | generator / control | Summon Doubles up to your cap around you; every enemy within 9 m: WIS save or **2 Doubt** (Deluded if it reaches 3). No Concentration · Long Rest · **Unique** | Replaces Hostile Takeover |
| **Mirrored Self** | 12 | 2 | passive card | Unchanged | — |
| **Mirrored Spell** | 12 | 3 | passive card | Unchanged | — |

**Removed:** Hypnotic Gaze, Mental Prison (both into Veiled Prison), Terrify, Hostile Takeover,
Ready: Instinctive Charm, Ready: Hollow Image (+ their passives and interrupts), the retired
`NEMESIS` statuses and `ARCANA_Spell_FacelessCopy_EX.txt`.

### 4.3 Doubles' spells (not cards)

| Spell | From | Effect |
|---|---|---|
| `Shout_Deceiver_Double_Shatter` | level 1 | 3 m burst, 1d6 Psychic, 1 Doubt per enemy hit; the Double dies |
| `Projectile_Deceiver_Double_MirrorSigil` | level 5 | 1d4 Force, lays her Sigil |
| `Target_Deceiver_Double_MirrorChains` | level 5 | 1d4 Force, WIS save or Restrained 1 turn |
| `Target_Deceiver_Double_Unveil` | level 9 | Swap places with her; once per round across all Doubles |
| `Shout_Deceiver_Clone_Dismiss` | always | Dismiss (kept) |

### 4.4 Passives

| Passive | Lvl | Effect |
|---|---|---|
| **The Veil** | 1 | Explains Doubles and Doubt; cap 3; +1 AC per Double; Doubt when an enemy destroys a Double |
| **Telepathy** | 1 | Unchanged |
| **Two Truths** | 5 | Doubles gain Mirror: Sigil of Malice and Mirror: Ethereal Chains |
| **Unveil** | 9 | Doubles gain Unveil |

---

## 5. Aspect Awakening — 2 · The High Priestess

**Goal — apply Doubt.** Each stack of Doubt you or your Doubles apply counts 1 (a Deluded reset counts its
third stack). Counted in Osiris, as today.

| Tier | Lvl | Goal | Name | Bonus (until combat ends) |
|---|---|---|---|---|
| I | 3 | 4 Doubt | **Veiled** | Enemies with Doubt have Disadvantage on attacks against you and your Doubles |
| II | 7 | 7 Doubt | **Two Pillars** | Once per turn, when an enemy becomes Deluded, it gains your Sigil |
| III | 12 | 10 Doubt | **Aspect of Doubt** | +3 CHA; Arcane spells add your CHA modifier to damage; **Which One?**: once per round, when an attack hits you, swap places with a Double and the Double takes the hit |

Aspect card: **The Veil Lifts** (replaces Heartbreak) — every Double shatters at once (each a Shatter) and
every one of your Sigils detonates; survivors with any Doubt become Deluded. Action · 0 Threads · once per
combat. VFX: Blur (unchanged).

---

## 6. Text (English)

- Aspect names in game: **2 - The High Priestess**, *Veiled*, *Two Pillars*, *Aspect of Doubt*.
- Class line: *"Mystra keeps a veil between what is and what seems. The Deceiver walks it - and no one
  watching can say which of her is real."*
- Doubles: `Double of the Veil`. Doubt: `Doubt` (status shows 1/2/3). Deluded: `Deluded`.
- Voice: the style memory (British, spaced hyphen, LSTag on first mention).

---

## 7. Balance notes (for the game-balance pass)

- **Action economy:** 5 Doubles × 1 action at fixed 1d4–1d6 ≈ one extra cantrip-sized hit per Double per
  round, paid for by cards and lost to any hit. Watch levels 11–12 (Grand Deception fills the cap at once).
- **AC:** +5 at the cap stays (D16).
- **Doubt snowball:** Deluded resets the stacks; control cards only gain Disadvantage on the save.
- **Sigil + Doubles:** Doubles can lay and detonate marks; one detonation per mark. Watch burst with Mimic.
- **Losses:** the Deceiver drops two reactions (Instinctive Charm, Hollow Image) and one control card
  (Terrify); the Doubles replace the defence.

---

## 8. Risks — test in the game

| # | What | Plan B |
|---|---|---|
| R1 | `Transform` may copy her stats along with her look | Fixed stats through a status on the Double (`SetMaxHP`-style boosts) or a dedicated character template |
| R2 | Summons from the Duplicity template may be AI-driven in combat | Mark them player-controlled like the current clone (same template, same goal) |
| R3 | Doubles' turns slow combat | Lower caps (2/3/4) |
| R4 | Detecting "who destroyed the Double" | Osiris `Died` + the last `AttackedBy` attacker; fallback: Doubt on the nearest enemy |
| R5 | Confused (CONFUSION) status type and duration for Deluded | A BOOST copy with the confusion archetype |
| R6 | Withdraw swap with `TeleportTo` both ways | Swap through a temporary marker object |

---

## 9. Technical pattern

### 9.1 Osiris goals

| Goal | Role |
|---|---|
| `ARCANA_Deceiver_Doubles.txt` (new, replaces `ARCANA_Spell_MirrorImage.txt`) | Summon, transform, kit by level, cap, AC layers, Doubt on destruction, end-of-combat cleanup |
| `ARCANA_Deceiver_Doubt.txt` (new) | Doubt counter, Deluded, Awakening steps |
| `ARCANA_Spell_Withdraw.txt` (+ Mimic/Mirror variants) | Double at the origin, swap |
| `ARCANA_Aspect_Empress.txt` | Objective switches from Sigil detonations to Doubt; tier bonuses; The Veil Lifts |
| `ARCANA_Status_Sigil.txt` | Detonation adds Doubt |
| `ARCANA_Spell_FacelessCopy.txt` | Cleaner copy (§9.3); `_EX` goal deleted |

### 9.2 Data

Stats through `stats_add.pl` patches; lists and progression through a structure script (lsx + tbl);
CardDB entries (Unique flags, conjures, the Aspect card) with Lua tests; loca in English only.

### 9.3 Faceless: Copy

Re-read `ARCANA_Spell_FacelessCopy.txt`, merge what `_EX` still does, and remove dead paths. The user
mentioned checking the "Rulebook": what that refers to is open (§10).

---

## 10. Open

- What "Rulebook" means for Faceless: Copy.
- Whether Doubles should also inherit her Mirrored Self / Mirrored Spell interactions (default: no).
