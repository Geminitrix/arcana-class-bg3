---
id: 21.04/Deceiver/DESIGN
owner: Lead Class Designer
state: approved design (DV1–DV30, 2026-10-16). The game still has the Veil build of 2026-10-07 with the old names and map (`05.02/Deceiver.md`) until the ARC-0019 build ships
reviewed: 2026-10-16 ARC-0019 — written from DECISIONS.md (DV1–DV30) and REFINE_Deceiver.md; replaces 2026-10-06-deceiver-veil-design.md (archived)
---

# The Deceiver — II · The High Priestess · Aspect of Doubt

> Design document for the Arcana's subclass **The Deceiver**: identity, the Veil and every one of its rules, every
> spell and passive, the Aspect Awakening, the progression and the technical pattern. Decisions are in
> `DECISIONS.md` (DV1–DV30); the review behind DV18–DV30 is `REFINE_Deceiver.md` (ARC-0019). Every gameplay effect
> lives in Stats, Osiris and Khonsu, so the subclass runs in **both editions**.
>
> **Numbers live in `25_Master_Data`** (ADR-0005). Where a value is needed this document says *(25)*; the Deceiver's
> YAML files are still to be written in the balance pass (§13.3). Caps, stack counts, ranges in metres, durations in
> turns and level placement are design and final unless a test proves them wrong.

---

## 1. The subclass in one page

The Deceiver is the Arcana who **fights with lies**. She puts **Doubles** of herself on the field — 1-HP illusions
that walk, cast and burst — and every lie an enemy believes plants **Doubt** in it. At the third Doubt the enemy is
**Deluded** and loses its grip on what is real. Her control cards bite harder on a doubting mind; her Doubles learn
her spells, trade places with her and, at the peak, burst in the face of whoever strikes them.

Her question every turn is the axis **Presence**: *how many bodies do I hold on the field, and when do I spend
them?* A Double kept is AC for her and a body between the enemy and the party; a Double spent is a burst of Doubt.

**Fantasy:** *"No one watching can say which of her is real."*
**Role:** controller and burst caster who fights with illusions; infiltration out of combat.

---

## 2. Identity

### 2.1 The card — II · The High Priestess

The priestess sits between two pillars, **B** and **J** — one black, one white — before a **veil embroidered with
pomegranates** that hides what lies behind it. A scroll, half covered by her mantle, holds a law she does not show;
the moon lies at her feet. She is the keeper of secrets: what is and what seems, side by side (Waite, 1910; Pollack,
1980 — citations checked in the primary text before any shipped text quotes them, DM-S7).

| Reading or image | Where it lives |
|---|---|
| The veil between what is and what seems | **The Veil** — the core rule; *Veilstep*, *Veiled Prison*, *Veiled* (Tier I) |
| The pomegranates on the veil | **Seed of Doubt** — a seed planted now that bursts later and plants Doubt |
| The two pillars, black and white | *Two Truths* (Doubles cast her spells) and *Two Pillars* (Tier II) |
| The half-hidden scroll — the hidden law | Doubt: the rule the enemy can't read; Deluded |
| Reversed: secrets revealed | **The Veil Lifts** (Aspect card): every lie bursts at once |

### 2.2 The Aspect — Doubt

Playing the mechanic *is* doubting: the enemy strikes a body that isn't there, steps into a burst it didn't see, and
at the third lie can no longer trust its own eyes. The Aspect is a point on Plutchik's wheel, apart from the
Resonant's emotions.

### 2.3 Mystra and the Weave

*Mystra, the Lady of Mysteries, keeps a veil between what is and what seems; the Deceiver was woven from it, a thread
no one watching can follow.* Her Doubles are the Weave bent into her shape; *Binding Falsehood* binds with a woven lie.

### 2.4 References

| Source | What it lends |
|---|---|
| **The eidolon of Helen** (Euripides, *Helen*; Stesichorus' palinode) — the cloud-Helen Hera made; Greeks and Trojans fought for a Double while the real one was elsewhere | The Double that draws the war: **Eidolon** (the card that summons Doubles); "the enemy fights for the false one" |
| **The Ghost Army** (WWII deception unit: inflatable tanks, false radio and sound) | Real model: decoys that draw fire and make the enemy doubt what it sees — the Doubles' AC and their burst when struck |
| **LeBlanc** (*League of Legends*) | The kit's shape: a mark that detonates, a blink that leaves an image, binding chains, a recast, decoys. Her ability names left the kit (DV29) |
| **Bene Gesserit** (*Dune*) | Manipulation by word and voice: *Malicious Whispers*, *Marionette*, *Friends* |

### 2.5 Identity Sheet

| Field | Answer |
|---|---|
| The card and why | II · The High Priestess — the veil between what is and what seems (§2.1) |
| Aspect and why | Doubt — what every lie she tells plants (§2.2) |
| Mystra and the Weave | Woven from the Lady of Mysteries' veil (§2.3) |
| Myth | The eidolon of Helen (§2.4) |
| Science / real source | The Ghost Army (§2.4) |
| Fictional characters | LeBlanc, the Bene Gesserit (§2.4) |
| Reference powers | LeBlanc's mark, blink, chains, recast and decoys → Seed of Doubt, Veilstep, Binding Falsehood, Twice-Told, Doubles |
| Archetype | The illusionist who is never where you strike |
| Fantasy line | *"No one watching can say which of her is real."* |
| Role | Controller and burst caster (primary); infiltration and social utility (secondary) |
| Specialist or versatile | Specialist: control through Doubt, burst through the Seed |
| Play style | Each turn: place, keep or spend Doubles; plant and burst Seeds |
| Combat style | Ranged (18 m); bodies forward, herself behind them; turn 1 sets Doubles and a Seed, turn 3 bursts them |
| Strengths / weaknesses | Snowballing control, bodies to spend, burst · no healing, light armour, Doubles die to any hit or area, many Concentration cards |
| Chassis | §3 |
| Colour, emoji, VFX | Pink `#f83fa5` · 🪞 · Blur (DV13) |
| Voice | Class description, panel line and tag line in `31.01` §5; she is **not** cruel for its own sake, not a fear-monger (fear is another subclass's), not a shapeshifter (her Doubles are illusions, not forms) |

---

## 3. Chassis

| Field | Value |
|---|---|
| Spellcasting / secondary | Intelligence / **Charisma** |
| Saving throws | Charisma, Intelligence |
| Armour | Light |
| Weapons | Daggers, light crossbows, quarterstaffs · musical instrument |
| Skills (choose 4, then 2 Expertise) | *The Witch*: Deception, Insight, Intimidation, Performance, Persuasion, Perception, History, Investigation |
| Ability preset | STR 8 · DEX 10 · CON 13 · INT 15 · WIS 10 · CHA 15 |
| Starting gear | Deceiver robe, dagger, light crossbow, an instrument |
| Sound set | Bard |

---

## 4. The Veil

### 4.1 The core rule — *The Veil* (level 1)

> **Every lie an enemy believes plants Doubt; at the third, it is Deluded.**

Taught once, on the visible passive **The Veil**, which also explains the Doubles (DV19). A *lie believed* is: a
Double destroyed by an enemy (the destroyer believed it), an enemy caught in a *Splinter*, her Seed bursting on it,
and *Malicious Whispers* on a Seeded target. No card carries its own exception.

### 4.2 Doubles

| Rule | Value |
|---|---|
| Body | 1 HP, fixed AC, no level scaling (DV4); her look, the Duplicity shimmer |
| Summoned by | *Eidolon* (1, then 2, then 3 by slot), *Veilstep* (one where she stood), *Grand Deception* (up to the cap) |
| Cap | 3 · 4 at level 7 · 5 at level 12 (DV16). Past the cap the oldest goes without a Splinter and without Doubt |
| For her | +1 AC per Double (DV7) |
| Turn | Its own turn, player-controlled: movement + one action; Dash, Disengage; *Dismiss* is free; no attacks, no bonus action, no reaction (DV5) |
| Immune to | Charmed, Madness, Possessed/Dominated, fleeing Fear (DV6) |
| Ends | Combat end, Long Rest, her death |

| Double's spell | From | Effect |
|---|---|---|
| **Splinter** | 1 | 3 m burst, Psychic *(25)*, 1 Doubt per enemy hit; the Double is gone. From Tier III the area is ‹wide› (DV21) |
| **Reflected Seed** | 5 (*Two Truths*) | Half of her *Seed of Doubt* at her highest slot, and lays her Seed (DV17) |
| **Reflected Falsehood** | 5 | Half of her *Binding Falsehood*'s damage; WIS save or Restrained 1 turn |
| **Unveil** | 9 | Swap places with her; once per round across all Doubles |
| **Dismiss** | 1 | Free; no Splinter, no Doubt |

### 4.3 Doubt

| Rule | Value |
|---|---|
| Stacks | 1 and 2, lasting 3 turns, refreshed by each new stack; the **third** makes the enemy **Deluded** (Confused, 1 turn) and the stacks reset |
| Per stack | −1 to Wisdom saves and −1 to attack rolls against her and her Doubles *(25)* |
| Sources | §4.1 (every lie believed); *Grand Deception*; *Ready: Which One?*; the Tier II spread |
| Payoffs | *Veiled Prison* and *Marionette*: Disadvantage on the save at 2+ Doubt; *Veiled* (Tier I) |

### 4.4 The Seed

*Seed of Doubt* lays a **Seed** on its target for 6 turns. Her next Arcane spell damage on that target (or a
Double's *Reflected* spell) bursts it for Psychic damage *(25)* and 1 Doubt. Applying a status never bursts a Seed.
*Malicious Whispers* on a Seeded target also gives **Paranoia** (no reactions) and its own Doubt (DV15).

### 4.5 Both sides of the field

Doubles and Splinters target enemies only; Doubt and the Seed land only on enemies. Nothing in the Veil can harm an
ally by rule. Allies gain from the Doubles' bodies (decoys, blocked lines) and from enemies that miss more.

### 4.6 Resolution order

1. A Double is destroyed by an enemy → the destroyer gains 1 Doubt → (Tier III) the Double bursts: its Splinter
   resolves at its last position, credited to her.
2. A Splinter or a burst Seed resolves its damage, then its Doubt, enemy by enemy.
3. An enemy whose Doubt reaches the third stack becomes Deluded at once and its stacks reset; Doubt from the same
   event beyond the third is lost.
4. *Two Pillars* (Tier II) fires once per turn after step 3.
Every chain ends: Doubles are finite, Deluded resets the stacks, Two Pillars is once per turn (DM-M6).

### 4.7 Worked example (level 5)

| Turn | Action | State after |
|---|---|---|
| 1 | *Eidolon* (2 Doubles) ahead of the party; *Seed of Doubt* on the ogre | 2 Doubles (her AC +2) · ogre: Seed |
| Ogre | Smashes a Double | 1 Double · ogre: 1 Doubt (it believed the lie) |
| Double | Walks beside the ogre and the goblin; casts *Reflected Seed* on the ogre | Ogre: Seed bursts → 2 Doubt · goblin untouched |
| 2 | *Shatter on command* (bonus action): the Double splinters | 0 Doubles · ogre: 3rd Doubt → **Deluded** · goblin: 1 Doubt |
| 2 | *Veiled Prison* on the goblin | Goblin saves at −1; Disadvantage only at 2+ Doubt |

### 4.8 Edge cases

| Case | Ruling |
|---|---|
| A Double dies to an area that kills several | Each destroyer gains Doubt once per Double |
| A Double dies to an ally's spell | No Doubt (an ally doesn't believe the lie); no Tier III burst |
| A Double is retired by the cap, Dismiss, combat end | No Splinter, no Doubt |
| She dies | Every Double ends, without bursting |
| A Deluded enemy hits a Double | It gains Doubt as usual (the stacks restarted) |

---

## 5. Spells

| Card | Level | Card level | Effect | Limiter |
|---|---|---|---|---|
| **Malicious Whispers** *(cantrip)* | 1 | 0 | 18 m, WIS save: Psychic *(25)*, Disadvantage on its next attack; Seeded target: Paranoia + 1 Doubt | — |
| **Eidolon** | 1 | 1 | Summon 1 Double within 9 m; 2 from slot 3, 3 from slot 5 | — |
| **Seed of Doubt** | 1 | 1 | 18 m, never misses: Force *(25)* and a Seed (§4.4) | — |
| **Shatter on command** | 2 | — | Bonus action: one of her Doubles splinters now (DV24) | — |
| **Faceless** *(utility)* | 2 | 0 | Assume the identity of another person, altering her appearance | — |
| **Friends** *(utility)* | 2 | 1 | Advantage on Charisma checks; at slot 6 no Concentration and the target never notices (DV14) | Concentration (below slot 6) |
| **Binding Falsehood** | 3 | 2 | WIS save: Force when bound and at turn end, then Restrained 1 turn | — |
| **Veiled Prison** | 3 | 2 | WIS save: Incapacitated, crits from 3 m, repeats the save; 2+ Doubt: Disadvantage | Concentration · Short Rest · Unique |
| **Veilstep** | 5 | 3 | Teleport 18 m, Force burst on landing, a Double where she stood; creates *Withdraw* (swap with that Double) and *Twice-Told: Veilstep* | — |
| **Twice-Told** | 6 | — | Bonus action: recast the last damaging card | — |
| **Mirrored Spell** *(passive card)* | 6 | 3 | Copy a spell cast within 18 m that she doesn't know | — |
| **Marionette** | 9 | 5 | Dominate; 2+ Doubt: Disadvantage on the save | Concentration · Long Rest · Unique |
| **Mirrored Self** *(passive card)* | 10 | 2 | Her next single-target spell gains a second target, **cast from one of her Doubles' positions** (DV25, T2) | — |
| **Grand Deception** — the ultimate | 11 | 5 | Every enemy within 9 m: WIS save; on a failure it gains 1 Doubt per Double already within ‹x› m of it; then Doubles fill her cap (DV22) | Long Rest · Unique |
| **Ready: Which One?** *(reaction)* | Tier III | 3 | Once per round, when an attack would hit her: swap with the nearest Double; the attack misses, the Double is destroyed, the attacker gains Doubt | Once per round |
| **The Veil Lifts** — Aspect card | Tier I | — | Every Double splinters, every Seed of hers bursts, survivors with Doubt become Deluded | Once per combat |

The ultimate **builds and reads** (where she placed her Doubles); the Aspect card **spends everything** (DM-A3).

---

## 6. Passives

| Passive | Level | Effect |
|---|---|---|
| **The Veil** | 1 | The core rule (§4.1) and the Doubles (§4.2) |
| **Two Truths** | 5 | Doubles learn *Reflected Seed* and *Reflected Falsehood* |
| **Unveil** | 9 | Doubles learn *Unveil* |
| Cap 4 / cap 5 *(hidden)* | 7 / 12 | The Doubles' cap |

---

## 7. Statuses

| Status | On | Notes |
|---|---|---|
| Double of the Veil | Doubles | Marks a Double; its spells come from its shapeshift rule |
| Veil layer 1–5 | Her | +1 AC per Double, kept in sync by Osiris |
| Doubt 1 / 2 | Enemies | Count on the portrait; Osiris raises them through a technical status |
| Deluded | Enemies | Confused for 1 turn (vanilla behaviour) |
| Seed | Enemies | 6 turns; bursts on her Arcane damage |
| Paranoia | Enemies | No reactions |
| Veiled / Two Pillars / Aspect of Doubt | Her | Awakening tiers (§8), each carrying the bonuses of the tiers below |

---

## 8. Aspect Awakening — 2 · The High Priestess

**Goal — apply Doubt.** Each stack she or her Doubles apply counts 1. Goals 4 / 7 / 10 *(25)*, counted down on the
progress status.

| Tier | Level | Name | Bonus (until combat ends) |
|---|---|---|---|
| I | 3 | **Veiled** | Enemies with Doubt have Disadvantage on attacks against her and her Doubles · Aspect card *The Veil Lifts* |
| II | 7 | **Two Pillars** | Once per turn, when an enemy becomes Deluded in her name, the nearest un-Seeded enemy within 6 m gains her Seed |
| III | 12 | **Aspect of Doubt** | **The lie explodes:** a Double destroyed by an enemy splinters by itself, and every Splinter's area grows to ‹wide› · *Ready: Which One?* (DV21) |

No tier gives an ability bonus (DV21 replaces the old +3 Charisma and Charisma to damage).

---

## 9. Progression

### 9.1 Level table

| Level | What arrives | Headline the player feels | Kind | New concepts |
|---|---|---|---|---|
| 1 | The Veil · Eidolon · Seed of Doubt · Malicious Whispers | "I fight with lies: Doubles on the field, Doubt on enemies" | rule + buttons | ~8 |
| 2 | Shatter on command · Faceless · Friends | "I burst a Double when I choose — and wear other faces" | button | 1 (+2 utilities) |
| 3 | Tier I *Veiled* · Binding Falsehood · Veiled Prison · The Veil Lifts | "Doubt pays: doubting minds fail my prisons" | rule + buttons | 3 |
| 4 | — (feat) | — | — | 0 |
| 5 | Two Truths · Veilstep | "My Doubles cast my spells; I leave myself behind" | rule + button | 2 |
| 6 | Twice-Told · Mirrored Spell | "I tell it twice — even with other people's spells" | buttons (one idea: copy) | 2 |
| 7 | Tier II *Two Pillars* · cap 4 | "Every Deluded enemy seeds the next" | rule + growth | 2 |
| 8 | — (feat) | — | — | 0 |
| 9 | Unveil · Marionette | "The Double becomes me — and the enemy becomes mine" | rule + button | 2 |
| 10 | Mirrored Self | "My twin spell comes from a Double" | button | 1 |
| 11 | Grand Deception | "The whole field is a lie I placed" | ultimate | 1 |
| 12 | Tier III *Aspect of Doubt* · cap 5 | "Strike me and the lie explodes" | rule + growth | 2 |

Base class underneath: Portent and a choice at 2, Dispel Magic at 6, Third Eye at 10, Arcane Gate and a feat at 12.

### 9.2 The signature button in ranks — the Double

| Level | Rank | What a Double does now |
|---|---|---|
| 1 | 1 | Walks, draws fire, gives AC, *Splinters* |
| 2 | 2 | Splinters on her command (bonus action) |
| 5 | 3 | Casts her Seed and her Falsehood |
| 9 | 4 | Trades places with her |
| 12 | 5 | Bursts when struck, wider |

*Eidolon* grows by slot: 1 Double (levels 1–4), 2 (5–8), 3 (9+).

### 9.3 The arc

| Part | Levels | What the player feels |
|---|---|---|
| Introduce | 1–2 | Lies on the field: bodies to keep or spend |
| Develop | 3–6 | Doubt pays off; the Doubles cast her spells; everything is told twice |
| Turn | 7–10 | The lie spreads (Two Pillars), the Double becomes her (Unveil), the enemy becomes hers (Marionette) |
| Conclude | 11–12 | The whole field is a lie (Grand Deception); the lie explodes (Tier III). Reversed, the card reveals: *The Veil Lifts* |

---

## 10. How it plays

- **A turn:** an action (a card or Eidolon), a bonus action (Shatter on command, Twice-Told, Withdraw), and one
  action per Double on its own turn.
- **A fight:** turn 1 sets Doubles in front of the party and a Seed on the biggest threat; turns 2–3 burst Seeds and
  Splinters until the first Deluded; then the prisons land with Disadvantage.
- **Party:** Doubles are bodies between enemies and allies; enemies with Doubt miss more; Paranoia removes reactions.

---

## 11. Text

- Aspect names in game: **2 - The High Priestess**, *Veiled*, *Two Pillars*, *Aspect of Doubt*.
- Class line: *"Mystra keeps a veil between what is and what seems. The Deceiver walks it - and no one watching can
  say which of her is real."*
- Names (DV29): Eidolon, Seed of Doubt (status *Seed*), Veilstep, Binding Falsehood, Twice-Told, Splinter, Reflected
  Seed, Reflected Falsehood; Doubles: *Double of the Veil*; *Doubt*, *Deluded*.
- Voice and style: `31.03` (British spelling, spaced hyphen); texts go through the Narrative gate (`32.04`).

---

## 12. Balance notes (for the balance pass)

- **Action economy:** up to 5 Doubles × 1 action, each a small fixed burst, paid by cards and lost to any hit (DV16).
- **Tier III:** every Double struck bursts, wider — watch the burst count per fight at level 12 (V3).
- **Grand Deception:** Doubt per Double near each enemy can Delude a crowd in one cast — the per-enemy count is the knob.
- **Seed + Doubles + Twice-Told:** one burst per Seed; watch Twice-Told on *Seed of Doubt*.

---

## 13. Technical pattern

### 13.1 Osiris goals

| Goal | Role |
|---|---|
| `ARCANA_Deceiver_Doubles.txt` | Summon, transform, kit by level, cap, AC layers, Doubt on destruction, cleanup; **new:** Shatter on command, the Tier III burst, the Doubles counted by Grand Deception |
| `ARCANA_Deceiver_Doubt.txt` | Doubt counter, Deluded, Awakening steps |
| `ARCANA_Aspect_Empress.txt` | Tier bonuses, The Veil Lifts, Which One? (ids keep *Empress*, DV12) |
| `ARCANA_Status_Sigil.txt` | The Seed's burst and its Doubt (file and status ids renamed or kept in the build) |
| `ARCANA_Spell_Withdraw.txt`, `…MimicWithdraw.txt`, `…MirrorWithdraw.txt` | Veilstep's Double and the swap |
| `ARCANA_Passive_MirroredSpell.txt`, `ARCANA_Spell_FacelessCopy.txt` | Mirrored Spell, Faceless |

### 13.2 Patterns

| Need | Pattern |
|---|---|
| Tier III burst on death | Vanilla **Death Burst**: `GLO_CombatNPCs.txt` explodes a dying creature with `CreateExplosionAtPosition(…, "Projectile_DeathBurst_*", 1, _Char)`; the projectile's `ExplodeRadius` sets the area (`Projectile_DeathBurst_Died_IceMephit`). Run from the Doubles goal, only on the "destroyed by an enemy" path, caster = her — **T2** |
| A Double casting off its turn | `UseSpell(_Double, …)` from Osiris, as The Veil Lifts does |
| Mirrored Self from a Double's position | Unknown — **T2**, test before the spec; plan B: the second target must be within ‹x› m of a Double |

### 13.3 Master data (25) — to be written in the balance pass

`SPL_Deceiver_*.yaml` per card, `FEAT_Deceiver_*.yaml` per passive, `STA_Deceiver_*.yaml` per status family, from
today's game values.

### 13.4 Ids

Internal ids keep their current names until the build decides (DV12, DV29): e.g. `Projectile_Arcana_Card_Spell_SigilofMalice`
is *Seed of Doubt* in game text. A rename of ids, if chosen, follows ADR-0002 and the naming memory of the project.

---

## 14. Open

- The Tier III burst's ‹wide› radius and Grand Deception's ‹x› m and Doubt per Double — balance pass.
- Whether the build renames internal ids to the new names (DV29) or keeps them (DV12's rule).
- Telepathy leaves the progression (DV26): its passive goes to the archive in the build.

## 15. To test in game

From the Veil build (`05.02` §8): the Doubles' spells by tier, the Mirror damage, Veiled Prison, Grand Deception,
the Awakening. New: V1–V4 of `REFINE_Deceiver.md` §5 (Shatter on command use, Grand Deception placement, the Tier III
burst, Mirrored Self from a Double).
