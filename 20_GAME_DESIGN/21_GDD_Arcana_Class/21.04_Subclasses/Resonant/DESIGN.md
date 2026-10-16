---
id: 21.04/Resonant/DESIGN
owner: Lead Class Designer
state: approved design R1–R68 — R1–R48 built and tested (ARC-0002, closed 2026-10-12); R49–R68 approved 2026-10-15/16 (ARC-0014 refining), build pending. The game today: 05.02/Resonant.md
reviewed: 2026-10-16 ARC-0014 — rewritten with R49–R68 and the documentation fixes of SG13
---

# The Resonant — XIV · Temperance · Aspect of Empathy

> Design document for the Arcana's subclass **The Resonant**: identity, the emotion mechanic and every one of its
> rules, every state, spell and passive, the Overload, the progression, the Aspect Awakening, the edge cases and the
> technical pattern that builds it.
>
> Raised 2026-10-11 through `21.04_Subclasses/_SUBCLASS_STANDARD.md` (ARC-0002, R1–R48) and refined 2026-10-15/16
> through `_SUBCLASS_REFINING.md` (ARC-0014, `REFINE_Resonant_2026-10-15.md`, R49–R68). Decisions: `DECISIONS.md`. Every
> gameplay effect lives in Stats, Osiris and Khonsu, so the subclass runs in **both editions** (PC with the deck,
> console without Script Extender).
>
> **This file shows the approved design.** Until the R49–R68 build ships, the game is the R1–R48 version described
> in `05_LIVE_CONTEXT/05.02_Subclasses/Resonant.md`.
>
> **Numbers live in `25_Master_Data`** (ADR-0005): where a value is needed this file names the file that holds it
> (`STA_Resonant_*`, `FEAT_Resonant_*`, `SPL_Resonant_*`); sizes still open are placeholders `‹…›` for the balance
> pass. Durations in turns and ranges in metres are design. Names marked *(working name)* are settled in the text pass
> (ARC-0006).

---

## 1. The subclass in one page

The Resonant is the Arcana who **tunes in** to what others feel, so closely that they can change it. In combat they
cast a **Weave Surge**: one button that opens the wheel of emotions they know. Each emotion fills a creature for a
turn and changes what it **does** — it freezes, lashes out, lets go, rushes to an ally's side. When the emotion fades
on its own it leaves a milder **mood** for 5 turns. A second Surge on a creature that carries a mood **reacts** with
it instead of landing alone, by the distance between the two emotions on Plutchik's wheel: the same emotion
overwhelms, neighbours braid into a **feeling**, opposites snap into **Catharsis**. Using a mood spends it. Every
reaction gives back the slot the Surge spent.

The Resonant feels everything they make others feel. An **Overload** meter fills with each emotion they cause; when
it is full they are ***Overloaded*** — their own mind frays and hurts, but every Surge that lands strikes with the same
raw feeling. With a Bonus Action they pour it all out as **Emotional Overload**: the target's feelings snap into
Psychic damage, its mind is left fatigued, and it is swept into an irresistible dance. At level 11 they link the whole
party into one **Shared Heart**; at level 12 the dam breaks.

**Fantasy:** *"No one in the room feels anything the Resonant hasn't braided."*
**Role:** control and support through emotions — the same spell lifts an ally or breaks an enemy; low damage of
their own, spikes through Catharsis, the Overload and Emotional Overload.

---

## 2. Identity

### 2.1 The card — XIV · Temperance

Temperance shows a winged figure with one foot in a stream and one on dry land, pouring water from one cup into
another. The stream runs at an angle no water should follow, and not a drop is spilled. The card means **moderation,
patience, blending, balance and healing**; it is the alchemist's card (in the Thoth deck it is called **Art**).
Reversed, it means **excess, imbalance and clashing extremes**.

The name **Resonant** comes from the card (R1): to temper is to bring two things into tune, and to be in tune with
what another creature feels is to be able to change it. That tuning is the Aspect, Empathy.

| Reading of the card | Where it lives in the Resonant |
|---|---|
| **Blending two into a third** | Emotional Alchemy: a Surge poured into a mood becomes something new |
| **Pouring from one cup into another** | Every Surge pours one emotion into a creature that already holds another |
| **Balance, healing** (upright) | The ally side: Surges that steady and lift, Catharsis that heals |
| **Excess, clashing extremes** (reversed) | Overwhelming emotions (distance 0, once per fight), Catharsis, the Overload and Emotional Overload |
| **The two cups** | The Aspect card **The Two Cups** |
| **One foot on land, one in water** | Both sides of the field: every reaction exists on allies and on enemies |
| **The irises by the water** | Iris and the rainbow: the wheel of emotions as a spectrum of colours (§2.4) |

### 2.2 The Aspect — Empathy

Empathy is tuning in to another's feeling, and the Resonant's empathy goes one step further: once in tune, they turn
the feeling into something else. Playing the Resonant **is** that — reading the mood a creature carries, then choosing
which emotion to pour into it. The Overload is the cost of empathy: the Resonant feels what they cause, and for a while
that feeling is also a weapon.

### 2.3 Mystra and the Weave

*"Mystra wove the Resonant from the feelings that pass between every living thing, a thread that tempers one emotion
with another."* Every Surge plucks, braids or snaps a thread of feeling in a creature's Weave.

### 2.4 Myth

| Source | What it lends |
|---|---|
| **Iris** — the rainbow, messenger between gods and mortals, carrying water in a golden ewer | The irises of the card; the wheel of emotions as a rainbow; the pouring of every Surge |
| **Harmonia** — daughter of Ares (war) and Aphrodite (love), goddess of concord | Concord born of opposites: Catharsis, and the name of Tier II **Harmony** |

### 2.5 Science — Plutchik's wheel and emotional contagion

**Robert Plutchik's wheel of emotions** (1980) structures the whole content: 8 basic emotions in a circle, each with a
mild ring (moods) and an intense ring, 24 dyads between them (feelings), and 4 pairs of opposites. The size of every
list in the kit is the size of a part of the wheel. Intensity is the cone's vertical axis: the intense ring is the
extreme of an emotion, and an extreme is felt once (R50).

**Emotional contagion** (Hatfield, Cacioppo and Rapson, 1994) gives its name and idea to *Emotional Contagion*.
**Compassion fatigue** (the cost of feeling others' pain) is the Overload, built on BG3's own *Mental Fatigue*.

### 2.6 Fiction

| Reference | What it lends |
|---|---|
| ***Inside Out*** | Emotions as characters, and two emotions mixing into one memory → braiding a feeling |
| **Mantis** (*Guardians of the Galaxy*) | The empath who touches someone, reads them and says "Sleep!" → **Awe** |
| **Seraphine** (*League of Legends*) | Hears the souls of others; *Encore* spreads through every champion it touches and sweeps them into her rhythm → **Emotional Contagion**, and **Emotional Overload**'s dance (R68) |
| **Jean Grey** (Marvel) | The telepath who holds every mind at once → **Emotional Overload III**, the area |
| **Deanna Troi** (*Star Trek: The Next Generation*) | The counsellor who feels the room before anyone speaks → **Empathic Sight** |
| **The Emotional Spectrum** (DC, the Lantern Corps) | A colour for every emotion; the Indigo Tribe of Compassion → the Surges' colours, **Ready: Compassion** |

### 2.7 Summary sheet

| | |
|---|---|
| **Arcanum** | XIV · Temperance |
| **Aspect** | Empathy (in game: *14 - Temperance*) |
| **Archetype** | The empath who plays the room |
| **Axis** | **Combination** — *what* goes with *what*? |
| **Role** | Control and support through emotions; low damage of their own |
| **Specialist or versatile** | **Versatile**: the same Surge buffs an ally or hinders an enemy, and the reaction depends on what the creature already feels |
| **Play style** | Lay emotions, read the moods they leave, then pour the right second emotion. The decision of each turn: *which emotion, on whom, on top of what?* — and, while *Overloaded*: *pour it out now, or ride it?* |
| **Combat style** | Back line, at range (18 m). Turn 1: a Surge whose emotion changes behaviour now. Turn 2: the reaction. From level 2 a Surge and a Temper share a turn |
| **Strengths** | Control from level-1 spells · one spell is both buff and debuff, more targets with every slot level · allies never roll against the Resonant |
| **Weaknesses** | Needs a turn of setup · enemies resist with Wisdom saves · constructs feel nothing · charm-immune creatures don't dance · *Overloaded* hurts and weakens their mind while it lasts |
| **Colour** | Coral `#bd4f2b` (light) / `#f39a78` (dark) |
| **Emoji / Aspect VFX** | 🌈 · VFX: each emotion in its own colour (the spectrum) |

---

## 3. Chassis

| Field | Value |
|---|---|
| Hit points | 6 + Constitution modifier at level 1, then 4 + Constitution modifier per level (the class's) |
| Spellcasting ability | **Intelligence** (the whole class) |
| Secondary ability | **Wisdom** — Insight is the empathy skill, and the Resonant's own saves against the mind |
| Saving throws | Wisdom, Charisma |
| Armour | Light |
| Weapons | Daggers, Quarterstaffs, Light Crossbows, Darts |
| Skills (choose 4, then 2 Expertise) | Skill list **The Empath**: Animal Handling, Insight, Intimidation, Medicine, Perception, Performance, Persuasion, Religion |
| Ability preset | STR 8 · DEX 10 · CON 10 · INT 15 · WIS 15 · CHA 13 |
| Starting gear | Leather Armour, Dagger, Darts, 2 Potions of Healing, Scroll of Revivify, Alchemy Pouch, camp clothes, camp supplies (`EQP_CC_Resonant`) |
| Sound set | Cleric |

---

## 4. The mechanic — Emotional Alchemy

### 4.1 The wheel

Clockwise: **Joy, Trust, Fear, Surprise, Sadness, Disgust, Anger, Anticipation**.
Opposites: Joy ↔ Sadness · Trust ↔ Disgust · Fear ↔ Anger · Surprise ↔ Anticipation.

| Emotion (peak) | Mood (mild ring) | Intense (inner ring) | Default side |
|---|---|---|---|
| Joy | Serene | Ecstasy | ally |
| Trust | Accepting | Admiration | ally |
| Fear | Apprehensive | Terror | enemy |
| Surprise | Distracted | Amazement | enemy |
| Sadness | Pensive | Grief | enemy |
| Disgust | Bored | Loathing | enemy |
| Anger | Annoyed | Rage | enemy |
| Anticipation | Interested | Vigilance | ally |

### 4.2 The states

**A peak changes what the creature does; a mood changes a number; a feeling mixes both** (R15).

- **Peak** (`EMOTION_*`, 1 turn): what a Surge applies on its own. When it fades **on its own** (`TimeOut`) it leaves
  its **mood**; removed any other way, it leaves nothing.
- **Mood** (`MOOD_*`, 5 turns): a milder echo. It fades; it does not rebound.
- **Feeling** (`FEELING_*`, 2 turns): two emotions braided. Leaves no mood.
- **Intense** (`EMOTION_*`, 1 turn): an emotion surged onto its own mood. Leaves nothing (R49); a creature feels one
  at most **once per fight** (R50).

### 4.3 The core rule — distance

> **A Weave Surge cast on a creature that carries a mood reacts with it instead of landing alone, by the distance
> between the two emotions on the wheel. Using a mood spends it; only an emotion that fades on its own leaves a mood.**
> (R49)

| Distance | Reaction | Plutchik | Unlocked at | Lasts |
|---|---|---|---|---|
| 0 | **Intensify** → the intense ring | intensity | level 7 (*Overwhelm*) | 1 turn; once per creature per fight (R50) |
| 1 | **Primary feeling** | primary dyad | level 1 | 2 turns |
| 2 | **Secondary feeling** | secondary dyad | level 6 (*Complex Feelings*) | 2 turns |
| 3 | **Tertiary feeling** | tertiary dyad | level 9 (*Mixed Feelings*) | 2 turns |
| 4 | **Catharsis** | opposites | level 3 (*Opposites*) | instant |

- A reaction still locked (its passive not learnt): the Surge lands as a plain peak.
- A Surge at distance 0 on a creature that has already felt an intense emotion this fight lands as a plain peak (R50).
- The order of the two Surges doesn't matter: Joy on Accepting and Trust on Serene both braid Love.
- Emotional Alchemy (level 1) teaches peaks, moods, distance 1, the refund, R49 and the kindness rule (§4.7); the
  passive *Opposites* (level 3) teaches Catharsis, the level the first opposite pair exists (R60).

### 4.4 The refund (R16)

> **When a Weave Surge causes a reaction, you regain the Woven Spell Slot it spent (on PC, in combat, the Thread).
> Once per turn.**

A reaction costs one slot: the Surge that prepares pays, the Surge that reacts is free when it works. A failed save
causes no reaction and refunds nothing.

### 4.5 Stacking

- Peaks and intense emotions share `StackId EMOTION`: a creature feels **one emotion** at a time; a new one replaces the
  old, so at most one mood comes out of it.
- Moods share `StackId MOOD`: **one mood** at a time, so each Surge causes at most one reaction.
- Every feeling has **its own** StackId: different feelings coexist on one creature, and a feeling braided again adds
  its turns (`StackType Additive`, R47).

### 4.6 Targets and saves

- **Any** Surge can target **any** creature (R41): a dark peak on an ally can set up a bright feeling; the player decides.
- A **Wisdom** save only when the target is a non-ally (`SpellAutoResolveOnAlly`). Allies never roll.
- None works on a **construct** (`not Tagged('CONSTRUCT')`, R25): everything else that lives feels.

### 4.7 Who causes reactions, and the kindness rule

- **Only Weave Surges cause reactions** (R7). A mood applied by any other source — Emotional Contagion, Harmony,
  Shared Heart — **replaces** the creature's mood. No chain can form.
- **Your automatic effects never braid a hindering feeling on an ally** (R57). A Surge cast by a rule (Ready:
  Compassion) lands as a plain peak when its reaction would be hindering; Shared Heart copies only helpful feelings.
  By hand, the player can still braid anything on anyone.

### 4.8 Edge cases

| Case | Rule |
|---|---|
| **A peak is cleansed or replaced** | No mood is left (only a peak that fades on its own leaves its mood) |
| **Temper's replayed emotion fades** | It leaves nothing (R49) |
| **Combat ends** | The Overload meter settles to half and *Overloaded* ends (R53); states follow their own durations; the once-per-fight marks of R50 clear |
| **A Surge on a creature carrying a peak but no mood** | The new peak replaces the old; no reaction |
| **Contempt + Catharsis** | Contempt makes the target vulnerable to Psychic: a Catharsis on it deals double |
| **Multi-target Surges** | Each target reacts with its own mood; the refund still happens once per turn |

---

## 5. The states

A = helps whoever carries it · I = hinders it. Status type is BOOST unless the table says otherwise; a different type
lives in its own file and inherits from a vanilla parent with `using`. Values with dice grow at levels 5 and 9 (R62,
R67): marked ▲.

### 5.1 Peaks — `EMOTION_*`, 1 turn (behaviour, R17)

| Peak | | What the creature does |
|---|---|---|
| **Joy** | A | **Contagious:** it and its allies near it gain Advantage on their next attack (R28) |
| **Trust** | A | **Shoulder to shoulder:** when an ally near it is hit by an attack, it can use its reaction to share the blow — the ally is Resistant to it, and it takes the same damage (R27) |
| **Anticipation** | A | **On guard:** when an enemy enters its reach, it can use its reaction to attack first; lasts until your next turn (R28) |
| **Fear** | I | **Frozen with fear:** can't move; Disadvantage on Ability Checks and Attack Rolls (vanilla Frightened boosts and group) |
| **Surprise** | I | **Caught off guard:** loses its reaction; the next attack against it has Advantage |
| **Sadness** | I | **Lets go:** loses Concentration and its bonus action |
| **Disgust** | I | **Recoils:** can't take actions; Disadvantage on Constitution saves |
| **Anger** | I | **A grudge — a taunt:** it attacks the last creature that hurt it during the fight, or the nearest one if nobody has (R26). Let the tank hit first, then Anger locks the enemy onto it and away from the back line; on an ally it focuses whoever hurt it (R65) |

### 5.2 Moods — `MOOD_*`, 5 turns

| Mood | | Effect |
|---|---|---|
| Serene | A | Advantage on Wisdom saves |
| Accepting | A | +1 Armour Class |
| Interested | A | +3 m movement |
| Apprehensive | I | ▲ subtracts a die from Wisdom saves (`STA_Resonant_States`) |
| Distracted | I | Disadvantage on saves to keep Concentration |
| Pensive | I | −3 m movement |
| Bored | I | No reactions |
| Annoyed | I | −1 Armour Class |

### 5.3 Intense — `EMOTION_*` (same StackId as the peaks), 1 turn, once per creature per fight

| Intense | | Type | Effect |
|---|---|---|---|
| Ecstasy | A | BOOST | +1 action |
| Admiration | A | BOOST | Resistant to all damage, immune to Charmed and Frightened |
| Vigilance | A | BOOST | +2 reactions, Advantage on Dexterity saves |
| Terror | I | **FEAR** (`using FEARED`) | Flees in terror; Disadvantage on Ability Checks and Attack Rolls; no early save |
| Amazement | I | **INCAPACITATED** (`using STUNNED`) | Stunned |
| Grief | I | **INCAPACITATED** | Incapacitated, no movement |
| Loathing | I | BOOST | No action or bonus action; Disadvantage on Attack Rolls and Ability Checks |
| Rage | I | BOOST | **Grudge, overwhelming:** attacks the last creature that hurt it (or the nearest), with Advantage; attacks against it also have Advantage (R23) |

### 5.4 Feelings — `FEELING_*`, 2 turns (4 with Tier II)

**Primary** (distance 1)

| Feeling | Blend | | Effect |
|---|---|---|---|
| Optimism | Anticipation + Joy | A | Immune to Frightened, temporary hit points each turn |
| Love | Joy + Trust | A | +1 AC and saves, Resistant to all damage; the Resonant takes the same damage |
| Submission | Trust + Fear | I | Knocked Prone; can't harm the Resonant |
| Awe | Fear + Surprise | I | **INCAPACITATED** until it takes damage (`using HYPNOTIC_PATTERN`) |
| Disapproval | Surprise + Sadness | I | Its allies within 3 m have Disadvantage on Attack Rolls |
| Remorse | Sadness + Disgust | I | ▲ The first time it deals damage each turn, it takes Psychic damage |
| Contempt | Disgust + Anger | I | Vulnerable to Psychic |
| Aggressiveness | Anger + Anticipation | A | ▲ Extra weapon damage, +1 reaction |

**Secondary** (distance 2)

| Feeling | Blend | | Effect |
|---|---|---|---|
| Hope | Trust + Anticipation | A | ▲ Bonus die to Attack Rolls and Saving Throws (Bless) |
| Guilt | Joy + Fear | I | No bonus action; Disadvantage on Wisdom saves |
| Curiosity | Trust + Surprise | A | Advantage on Ability Checks, +3 m, sees Invisible |
| Despair | Fear + Sadness | I | ▲ Penalty die to Attack Rolls and Saving Throws (Bane) |
| Unbelief | Surprise + Disgust | I | Can't cast spells |
| Envy | Sadness + Anger | I | Attacks the nearest creature, its own allies included |
| Cynicism | Disgust + Anticipation | I | Can't regain hit points |
| Pride | Anger + Joy | A | Critical Hit on 19–20 |

**Tertiary** (distance 3)

| Feeling | Blend | | Effect |
|---|---|---|---|
| Delight | Joy + Surprise | A | ▲ Regains hit points at the end of each turn |
| Sentimentality | Trust + Sadness | A | Resistant to Psychic; immune to Charmed |
| Shame | Fear + Disgust | I | No reactions; Disadvantage on Attack Rolls |
| Outrage | Surprise + Anger | I | Disadvantage on Attack Rolls; attacks against it have Advantage |
| Pessimism | Sadness + Anticipation | I | ▲ Penalty die to Saving Throws and Ability Checks |
| Morbidness | Disgust + Joy | A | ▲ The first weapon hit each turn restores hit points |
| Dominance | Anger + Trust | A | Advantage on Athletics and Intimidation; +1 AC |
| Anxiety | Anticipation + Fear | I | Loses Concentration; no reactions; Disadvantage on Concentration saves |

Dice and their steps: `STA_Resonant_Feelings` (R62: the d4 states ‹1d4 → 1d6 → 1d8›, the d6 states ‹1d6 → 1d8 → 1d10›).

### 5.5 Catharsis — `CATHARSIS`, instant

Opposing threads snap. A non-ally takes Psychic damage; an ally regains hit points (`STA_Resonant_Catharsis`, growing
at levels 5 and 9, R67; more with Tier I). Spends the mood. Shows in the combat log.

### 5.6 Each state says what it reacts with (R64)

Each mood's description lists the outcome names by the emotion poured, with the level that unlocks them — *Mood:
Serene* — **Trust** → Love · **Anticipation** → Optimism · **Sadness** → Catharsis · **Fear** → Guilt (level 6) ·
**Joy** → Ecstasy (level 7) · … Each emotion of *Weave Surge* lists the moods it reacts with. Names only; the effect is
one hover away on the feeling's own status.

---

## 6. The Overload

> **The Resonant feels everything they make others feel.**

- **The meter** (`OVERLOAD`, a status on the Resonant with a visible count) fills by **+1** for each peak that lands
  and **+2** for each reaction (feeling, Intensify, Catharsis) (R12). A failed save adds nothing; The Two Cups adds
  nothing (R38). Its size grows with the slot level (`FEAT_Resonant_Overload`), so it fills around the fourth turn at
  every level. It shows as a percentage of its maximum (R31), in and out of combat (R32).
- **When a fight ends** the meter **settles to half** and *Overloaded* ends (R53) — a justified exception to the
  reset default (D4 of ARC-0016): ‹1–2› releases a day, the counter shows out of combat, the first and fourth fights of
  a day differ by at most half a meter.
- **Shared Heart** counts **once per Surge**, however many linked creatures react (R19).
- **Waking Tier III fills the meter** at once (R56).

### 6.1 *Overloaded* (R51, R52, R67)

When the meter is full the Resonant becomes ***Overloaded*** — a variant of vanilla *Mental Fatigue* — for turns equal
to their **character level**:

- a flat penalty to **Intelligence, Wisdom and Charisma** saving throws ‹−1 / −2 from level 5 / −3 from level 9› (not
  multiplied by duration; no discharge);
- **Psychic damage** at the start of each of their turns ‹1d4 / 2d4 from level 5 / 3d4 from level 9›;
- **once per turn**, a Weave Surge that **lands on an enemy** (it fails the save) also deals it the same Psychic damage;
- **no silence**: they cast as usual.

It ends only when its turns run out, when Emotional Overload transfers it, or when the fight ends. The choice it asks:
*pour it out now, or ride it — and braid one more feeling into the target first?*

### 6.2 Emotional Overload — the ultimate (R51, R66, R68)

The key feature that ties the mechanic together: everything the Resonant felt, poured into the enemy.

**Bonus Action · not a spell (works whatever the Resonant's state) · only while *Overloaded* · the full meter is its
cost.** Icon: `Spell_IntellectDevourer_SynapticDischarge`. The target makes a **Wisdom** save, and loses **every feeling**
it carries either way:

| | Effect |
|---|---|
| **Fails** | Psychic damage for each feeling spent, and it **dances** — vanilla `IRRESISTIBLE_DANCE` for 1 turn (2 at Tier III): no actions, no movement, attackers have Advantage, Disadvantage on its attacks and Dexterity saves; a Wisdom save at the start of its turn ends it, and the turn it breaks free it loses its action. Charm-immune creatures don't dance (`SG_Charmed`) |
| **Succeeds** | Half the feelings' damage; no dance |
| **Either way** | Vanilla **Mental Fatigue** (`MAG_PSYCHIC_MENTAL_FATIGUE`, with its duration technical status) for turns equal to the Resonant's level: −1 to Intelligence, Wisdom and Charisma saves per turn remaining (cap 7); a failed mental save at 5+ turns discharges it for 1d4 Psychic — the next Surge on it almost always lands |

Then *Overloaded* ends and the meter empties.

**Ranks** — the spell is a level-1 slot spell with generated upcast variants; one hidden passive at level 1 makes it
free (R66). The Arcana's slots are one level at a time, so only the variant of the current slot shows:

| Ranks | Levels (slot) | Targets |
|---|---|---|
| **I** | 1–4 (slots 1–2) | One enemy within 18 m |
| **II** | 5–8 (slots 3–4) | Two enemies |
| **III** | 9–12 (slots 5–6) | Every enemy within 9 m of a point within 18 m |

---

## 7. Spells outside the Overload

### 7.1 Weave Surge — the container (R54, R55)

**One spell container, *Weave Surge*,** whose spells are named after the emotions — *Joy*, *Trust*, *Fear*, … — and
grows as the Resonant learns them (§10): one hotbar button instead of eight. Each emotion is a level-1 card (1 Thread)
that gains one target per slot level through generated upcast variants (the container's variants list its children's,
`gen_upcast_variants.pl` §1b). **PC deck:** the container and its emotions are one card (`CardDB.lua`); it holds **3
copies per emotion the Resonant knows** (9 at level 1, up to 24 at level 5) — an exception to the deck's 3 copies per
card, for this card only.

### 7.2 Heartstring — cantrip (level 1, R61)

18 m, Wisdom save: Psychic damage that scales like vanilla cantrips (5 and 10), plus ‹1d4 Psychic› for **each feeling
the target carries**. The turn the Resonant falls back on still advances the plan: keep feelings on the enemy.

### 7.3 Temper (level 2) — R4, R6, R49

**Bonus Action, no slot** (R34); in the PC edition **1 Thread**, like every level-0 card (R45). **Spend a creature's mood
to make it relive the emotion it came from** for 1 turn (a non-ally rolls a Wisdom save): it replays that peak's
behaviour now — Fear freezes again, Joy spreads again, Disgust takes the action — and the replayed emotion leaves
nothing when it fades. It applies a peak, never a reaction (§4.7).

### 7.4 Emotional Contagion (level 9)

**Level 3 card · Action · Concentration** (R33, R34). While you concentrate, every **ally of the target** within 6 m
catches the **mood** it carries, again each turn; no saving throw (R35: a bright mood stays on its side, a dark one on
the other). Copied moods replace; they never react (§4.7). Mass setup for reactions, weak on its own; the intense ring
still lands once per creature per fight (R50).

### 7.5 Ready: Compassion (level 10)

**Reaction card · Unique · level 3** (R34). Until combat ends: when an ally within 9 m **takes damage from an enemy**,
cast Weave Surge: Trust on it (it can trigger Alchemy; the kindness rule applies — a hindering reaction lands as a
plain peak, R57). Once per round.

### 7.6 Shared Heart — capstone (level 11) — R18, R43, R44, R46, R57, R58

**Level 5 card · Action · Long Rest · Unique.** You and every ally within 18 m are **linked** until combat ends, and on
cast **every linked creature feels Joy** (a peak — no reaction, refund, Overload or Awakening); when it fades it leaves
*Serene* on the party. A **helpful feeling** braided in one linked creature is braided in **all** of them (R46, R57): one
reaction braids Love or Hope into the whole party. It counts once for the refund, the Overload and the Awakening
(R19). A Catharsis on a linked ally heals every linked ally (R44). Feelings stack additively (R47).

### 7.7 Read the Room — removed (R37)

Empathic Sight already gives Advantage on Insight.

---

## 8. Passives by level

| Passive | Level | What it explains |
|---|---|---|
| **Emotional Alchemy** | 1 | The core rule once: peaks and moods, distance 1, using a mood spends it, the kindness rule and the refund |
| **Empathic Sight** | 1 | Advantage on Insight; the Resonant reads the threads of feeling in others |
| **Overload** *(working name)* | 1 | The meter, *Overloaded* and Emotional Overload (§6) |
| *(hidden)* Emotional Overload's free cast | 1 | `UnlockSpellVariant(…ModifyUseCosts(Replace,ArcanaSpellSlot,0,-1,ArcanaSpellSlot))` (R66) |
| **Opposites** *(working name)* | 3 | Catharsis — distance 4 (R60) |
| **Complex Feelings** | 6 | Unlocks distance 2 |
| **Overwhelm** | 7 | Unlocks distance 0, once per creature per fight |
| **Mixed Feelings** | 9 | Unlocks distance 3 |

The level-up texts at 5 and 9 say it: *"Your moods and feelings grow stronger."* (R62)

---

## 9. Aspect Awakening — 14 · Temperance

**Goal — cause reactions.** Each feeling braided, each Intensify and each Catharsis counts 1, on allies and enemies
alike; every Catharsis of The Two Cups counts separately; a Shared Heart Surge counts once. Counted in Osiris
(`ARCANA_Aspect_Temperance`); the Awakening status shows how many are left (ARC-0007). Tiers stack and last until
combat ends.

| Tier | Level | Goal | Name | Bonus |
|---|---|---|---|---|
| I | 3 | `FEAT_Resonant_AspectAwakening` | **Resonance** (R21) | Catharsis deals or restores more (`STA_Resonant_Catharsis`) and the Aspect card **The Two Cups** (R63) |
| II | 7 | `FEAT_Resonant_AspectAwakening` | **Harmony** (R40) | Feelings you braid last 2 turns longer; once per turn a Weave Surge costs no action (`IsWeaveSurge()`) and its emotion brings its mood at once, so the next Surge can react (R42) |
| III | 12 | `FEAT_Resonant_AspectAwakening` | **Aspect of Empathy** | **The dam breaks:** waking it fills the meter at once (R56), and Emotional Overload's dance lasts ‹2› turns (R68). No ability bonus |

### 9.1 The Two Cups — the Aspect card (Tier I)

**Created · 0 Threads · 0 slots · Action · once per combat.** Every creature within 18 m that carries a mood undergoes
Catharsis at once: enemies take Psychic damage, allies regain hit points. It works the field; Emotional Overload works
its targets' feelings — the two never do the same thing.

---

## 10. Progression

The kit spreads over every level (standard v2.1, R59); levels 4 and 8 are the feats. Growth follows the class's slot
levels: 1, 5 and 9 (R67).

| Level | Passives | Spells and features | Headline | New concepts |
|---|---|---|---|---|
| **1** | Emotional Alchemy · Empathic Sight · Overload | *Weave Surge*: Joy, Trust, Fear · Heartstring · Emotional Overload I | *Pour, braid, let it out* | 5 |
| **2** | — | *Weave Surge*: Anticipation · **Temper** | *A second play each turn* | 2 |
| **3** | **Opposites** · Tier I Resonance | *Weave Surge*: Surprise, Sadness · The Two Cups | *Opposites snap* | 3 |
| 4 | — (feat) | — | | |
| **5** | — | *Weave Surge*: Disgust, Anger (the full wheel) · **Emotional Overload II** · first growth step | *The whole wheel; the release reaches two* | 3 |
| **6** | **Complex Feelings** | — | *Emotions further apart still blend* | 1 rule (8 names) |
| **7** | **Overwhelm** · Tier II Harmony | — | *Excess* | 2 |
| 8 | — (feat) | — | | |
| **9** | **Mixed Feelings** | **Emotional Contagion** · **Emotional Overload III** · second growth step | *A feeling runs through a crowd* | 3 |
| **10** | — | **Ready: Compassion** | *I answer an ally's pain* | 1 |
| **11** | — | **Shared Heart** (capstone) | *One heart for the party* | 1 |
| **12** | Tier III Aspect of Empathy | — | *The dam breaks* | 1 |
| 13–20 | Reserved, like the rest of the class | | | |

**The arc** (DM-J7): **Feeling** (1–3: read, pour, let it out, opposites) → **Blending and excess** (5–7: the whole wheel,
further blends, one extreme) → **Contagion** (9–10: feelings spread, answering pain) → **Union** (11–12: one heart; the
dam breaks).

**The signature button:** Emotional Overload, ranks I · II · III at 1 · 5 · 9; Tier III deepens it at 12.

---

## 11. How it plays

### 11.1 A turn

1. **Read the field:** which creatures carry which mood, and which peaks will fade into moods this round. Hover a mood:
   it says what each emotion would make of it.
2. **Choose the pour:** which emotion of *Weave Surge* on which mood — a feeling for an ally, a feeling or Catharsis
   for an enemy, a plain peak to change behaviour now.
3. **Bonus Action (level 2+):** Temper — spend a mood to replay its emotion now.
4. **While *Overloaded*:** ride it (every Surge that lands hurts, and so do you) or pour it out with Emotional Overload,
   ideally into an enemy carrying several feelings.

### 11.2 A fight

- **Turn 1:** Surges whose peaks change behaviour now — Fear freezes the brute, Anger (after the tank's hit) locks an
  enemy on the tank, Trust or Joy on the front line.
- **Turns 2–3:** the peaks have left moods; the reactions start, each one refunding its slot.
- **Mid-fight:** the Overload fills; the Resonant rides it for a turn or two, then pours it out — feelings into damage,
  the target dancing and mentally fatigued, so the next Surges land.
- **Long fights:** The Two Cups snaps every mood on the field at once; at 11 Shared Heart braids the whole party; at 12
  waking Tier III fills the meter and the release makes the field dance.

### 11.3 Party

The Resonant is strongest beside allies who hit hard (Joy, Trust, Pride, Ecstasy make their turns better) and who
punish dancing, frozen or incapacitated enemies. Mental Fatigue on the enemies also helps every ally whose spells ask
for Intelligence, Wisdom or Charisma saves. Their weakness to mindless and charm-immune creatures is covered by allies
who deal damage the plain way.

---

## 12. Text

All player-facing text is English, in Larian's voice (`31.03_BG3_Style_Guide`), following the shared formulas of the
Lore Bible:

- **Class description:** *"Mystra wove the Resonant from the feelings that pass between every living thing, a thread
  that tempers one emotion with another. They surge joy, trust or fear into a creature's Weave, then braid what lingers
  into stronger feelings that lift allies and break enemies from within."*
- **Tag line:** *"We feel what you feel before you do, and the Weave lets us turn it into something else."*
- **Moulds:** the container `Weave Surge`, its spells named by the emotion (`Joy`, `Trust`, …); peak
  `Emotion: <Emotion>`; mood `Mood: <Mood>` (with its reactions, §5.6); feeling `Feeling: <Feeling>` — *"Threads of <A>
  and <B>, braided into one."*
- **Anger** is written as a taunt (R65).
- Names stay inside the Resonant's vocabulary: threads, braiding, pouring, tuning, the wheel of emotions.
  **Overflow** is not used (the base class has Arcane Overflow); **Attunement** is not used (the deck has the keyword
  Attuned). Vanilla names kept as they are: *Mental Fatigue*, *Irresistible Dance*.
- The polish of every text waits for the end of the class rework (ARC-0006).

---

## 13. Technical pattern

Everything below is Stats, Osiris and Khonsu; nothing needs Script Extender (the PC deck reads the same spells).

### 13.1 Generation

`80_TOOLS_AND_PIPELINE/82_Automation/stats/gen_emotion_alchemy.pl` reads one table (wheel order, names, boosts and text
of every state) and writes the Surges with the reaction matrix in `SpellSuccess`, every status in the file of its type,
and the English strings. Change the table, never the patches; then `gen_upcast_variants.pl`, `sort_stats.pl --apply`,
`check_cards.pl`.

### 13.2 Statuses and spells

| Piece | Pattern |
|---|---|
| Peaks, moods, feelings, Catharsis | `OnRemoveFunctors` with `IF(RemoveCause(StatusRemoveCause.TimeOut))` leaves the mood (peaks only) |
| **Intense** (R49, R50) | No mood on fade; a hidden marker per creature (`RemoveEvents OnCombatEnded`, the pattern of `ASPECT_PROGRESS_*`); the distance-0 reaction requires its absence |
| **Temper** (R49) | Applies the peak and a hidden replay marker, removes the mood; each peak's fade leaves the mood only `not HasStatus(<marker>)`, and removes the marker — **T2** (functor order inside `OnRemoveFunctors`; plan B: the marker clears at the start of the Resonant's next turn) |
| **Refund** (§4.4) | Osiris (`ARCANA_Resonant_Overload`): a reaction status landing applies `RESONANT_REFUND_TECH`, guarded by `RESONANT_REFUND_USED` (once per turn) |
| **Overload meter** | Osiris counts peaks (+1) and reactions (+2) per Resonant; percentage on `RESONANT_OVERLOAD`; full → *Overloaded* for the character level in turns; on combat end, half the meter and *Overloaded* removed (R53); Tier III waking → full (R56) |
| ***Overloaded*** (R51) | A BOOST on the Resonant: flat mental-save penalty and Psychic tick by level band; the Surge rider once per turn on an enemy that failed the save (Osiris on the Surge's landing, a per-turn guard like the refund's) |
| **Emotional Overload** (R51, R66, R68) | A level-1 slot spell with upcast variants (targets: 1 / 2 / area by variant) made free by one hidden passive (`UnlockSpellVariant` + `ModifyUseCosts(Replace,ArcanaSpellSlot,0,-1,ArcanaSpellSlot)`, no tooltip change — Owner-tested: only the current slot's variant shows); requires *Overloaded*; Wisdom save; removes every `FEELING_*` with damage per feeling (half on a save); `IRRESISTIBLE_DANCE` 1 turn on a fail (2 at Tier III); `MAG_PSYCHIC_MENTAL_FATIGUE` + its duration technical status either way; Osiris ends *Overloaded* and empties the meter. Rank III's area shape — **T2** (a variant with an area, or a separate spell) |
| **Weave Surge** (R54, R55) | A spell container (Hemoplague pattern) whose children are the eight emotions; upcast variants per container level; `CardDB.lua` maps container + children to one card with 3 copies per emotion known |
| **Anger's and Rage's grudge** | Osiris (`ARCANA_Resonant_Grudge`) remembers who last hurt each creature during the fight (R26) |
| **Shared Heart** | `SHARED_HEART` on the linked creatures; Joy peak on cast (R58); Osiris (`ARCANA_Resonant_SharedHeart`) copies **helpful** feelings to the others, counted once (R19, R46, R57), and heals them on a Catharsis (R44) |
| **Ready: Compassion** | Interrupt on an enemy's damage to an ally (Hellish Rebuke pattern); Trust lands as a plain peak when the reaction would be hindering (R57) |
| **Heartstring** (R61) | Cantrip damage by `LevelMapValue(D4Cantrip)` plus conditional damage per `FEELING_*` (the pattern of Emotional Overload); line ≤ 3900 characters |
| **Growth** (R62, R67) | The dice states in one version per band (1–4, 5–8, 9–12), swapped by level |

### 13.3 Ids

| What | Ids |
|---|---|
| Emotions | `Target_Arcana_Card_Spell_Emotion{Joy,Trust,Fear,Surprise,Sadness,Disgust,Anger,Anticipation}` — children of the new container (id per `33.03`) |
| Passives | `Arcana_Passive_{EmotionalAlchemy,EmpathicSight,ComplexFeelings,Overwhelm,MixedFeelings}`, the Overload passive, and new: *Opposites*, Emotional Overload's free cast |
| Spells | Heartstring, Temper, Emotional Contagion, Ready: Compassion, Shared Heart, Emotional Overload, The Two Cups — ids follow `33.03` and ADR-0002 |
| Legacy names to rename in the Toolkit | Tag `THEHEARTWEAVER`, ClassDescription Name, ProgressionDescription Type/Name `Heartweaver` |

---

## 14. Open

| Item | Decided in |
|---|---|
| Every `‹…›` value | Balance pass (`25`, `22.05`) |
| Temper's replay marker: functor order (§13.2) | Probe in the build spec |
| Does the dance's failed turn-start save discharge Mental Fatigue? | Probe in the build spec |
| The PC `ARCANA_WEAVING` must not charge Threads for Emotional Overload | Probe in the build spec |
| Emotional Overload III's area: variant or separate spell | Build spec (T2) |
| Every *(working name)* | Text pass (ARC-0006) |
| Aspect VFX per emotion | Author |
| Translations (strings are English only) | Localization |

## 15. To test in game

**R1–R48** passed in game (ARC-0002; `61.02_Test_Cases/Resonant/TC_ARC-0002.md`). **R49–R68** are tested after their
build: the verification rows V1–V11 of `REFINE_Resonant_2026-10-15.md` §11 and the probes of §14, in
`61.02_Test_Cases/Resonant/` and the balance playtest ARC-0010.
