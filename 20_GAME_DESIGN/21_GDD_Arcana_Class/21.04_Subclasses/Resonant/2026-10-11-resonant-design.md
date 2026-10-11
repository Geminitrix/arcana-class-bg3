# The Resonant — XIV · Temperance · Aspect of Empathy

> Design document for the Arcana's subclass **The Resonant**. It describes everything the subclass is and
> does: identity, the emotion mechanic and every one of its rules, every state, spell and passive, the
> overload, the progression, the Aspect Awakening, the edge cases and the technical pattern that builds it.
>
> Raised 2026-10-11 through the process in `21.04_Subclasses/_SUBCLASS_STANDARD.md` (ticket ARC-0002;
> decisions R1–R23 in `55_Implementation_Specs/_wip/Resonant/decisions.md`). It replaces
> `2026-10-06-heartweaver-design.md`, which stays as the record of the first version. Every gameplay
> effect lives in Stats, Osiris and Khonsu, so the subclass runs in **both editions** (PC with the deck,
> console without Script Extender).
>
> **Numbers are not set here.** Wherever a value says *TBD* it is decided in the balance pass and lives
> in `25_Master_Data` (ADR-0005). Durations in turns and ranges in metres are design and are final unless
> a test proves them wrong. Names marked *(working name)* are settled in the text pass.

---

## 1. The subclass in one page

The Resonant is the Arcana who **tunes in** to what others feel, so closely that they can change it. In
combat they cast **Weave Surges**: each fills a creature with one emotion for a turn, and a strong
emotion changes what the creature **does** — it freezes, lashes out, lets go, rushes to an ally's side.
When the emotion fades it leaves a milder **mood** for 5 turns. A second Surge on a creature that carries
a mood **reacts** with it instead of landing alone, by the distance between the two emotions on
Plutchik's wheel: the same emotion overwhelms, neighbours braid into a **feeling**, opposites snap into
**Catharsis**. Every reaction gives back the slot the Surge spent.

The Resonant feels everything they make others feel. From level 5 an **Overload** meter fills with each
emotion they cause; when it is full it hurts them, and they can pour it all into one enemy with
**Emotional Overload**, leaving it paralysed. At level 11 they link the whole party into one **Shared
Heart**; at level 12 the overload spills over every enemy they have touched.

**Fantasy:** *"No one in the room feels anything the Resonant hasn't braided."*
**Role:** control and support through emotions — the same spell lifts an ally or breaks an enemy; low
damage of their own, spikes through Catharsis and Emotional Overload.

---

## 2. Identity

### 2.1 The card — XIV · Temperance

Temperance shows a winged figure with one foot in a stream and one on dry land, pouring water from one
cup into another. The stream runs at an angle no water should follow, and not a drop is spilled. The
card means **moderation, patience, blending, balance and healing**; it is the alchemist's card (in the
Thoth deck it is called **Art**). Reversed, it means **excess, imbalance and clashing extremes**.

The name **Resonant** comes from the card (R1): to temper is to bring two things into tune, and to be in
tune with what another creature feels is to be able to change it. That tuning is the Aspect, Empathy.

| Reading of the card | Where it lives in the Resonant |
|---|---|
| **Blending two into a third** | Emotional Alchemy: a Surge poured into a mood becomes something new |
| **Pouring from one cup into another** | Every Surge pours one emotion into a creature that already holds another |
| **Balance, healing** (upright) | The ally side: Surges that steady and lift, Catharsis that heals |
| **Excess, clashing extremes** (reversed) | Overwhelming emotions (distance 0), Catharsis (opposites), the Overload and Emotional Overload |
| **The two cups** | The Aspect card **The Two Cups** |
| **One foot on land, one in water** | Both sides of the field: every reaction exists on allies and on enemies |
| **The irises by the water** | Iris and the rainbow: the wheel of emotions as a spectrum of colours (§2.4) |

### 2.2 The Aspect — Empathy

Empathy is tuning in to another's feeling, and the Resonant's empathy goes one step further: once in
tune, they turn the feeling into something else. Playing the Resonant **is** that — reading the mood a
creature carries, then choosing which emotion to pour into it. The Overload is the cost of empathy: the
Resonant feels what they cause.

### 2.3 Mystra and the Weave

*"Mystra wove the Resonant from the feelings that pass between every living thing, a thread that tempers
one emotion with another."* Every Surge plucks, braids or snaps a thread of feeling in a creature's
Weave.

### 2.4 Myth

| Source | What it lends |
|---|---|
| **Iris** — the rainbow, messenger between gods and mortals, carrying water in a golden ewer | The irises of the card; the wheel of emotions as a rainbow; the pouring of every Surge |
| **Harmonia** — daughter of Ares (war) and Aphrodite (love), goddess of concord | Concord born of opposites: Catharsis, and the name of Tier II **Harmony** |

### 2.5 Science — Plutchik's wheel and emotional contagion

**Robert Plutchik's wheel of emotions** (1980) structures the whole content: 8 basic emotions in a circle,
each with a mild ring (moods) and an intense ring, 24 dyads between them (feelings), and 4 pairs of
opposites. The size of every list in the kit is the size of a part of the wheel.

**Emotional contagion** (Hatfield, Cacioppo and Rapson, 1994) — the real tendency to catch the emotions
of the people around us — gives its name and idea to *Emotional Contagion*. **Compassion fatigue** (the
cost of feeling others' pain) is the Overload.

### 2.6 Fiction

| Reference | What it lends |
|---|---|
| ***Inside Out*** | Emotions as characters, and two emotions mixing into one memory → braiding a feeling |
| **Mantis** (*Guardians of the Galaxy*) | The empath who touches someone, reads them and says "Sleep!" → **Awe** |
| **Seraphine** (*League of Legends*) | Hears the souls of others; *Encore* spreads through every champion it touches → **Emotional Contagion**; it also roots the charmed → **Emotional Overload** |
| **Jean Grey** (Marvel) | The telepath who holds every mind at once and freezes a crowd → Tier III, **Emotional Overload in an area** |
| **Deanna Troi** (*Star Trek: The Next Generation*) | The counsellor who feels the room before anyone speaks → **Empathic Sight**, **Read the Room** |
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
| **Play style** | Lay emotions, read the moods they leave, then pour the right second emotion. The decision of each turn: *which emotion, on whom, on top of what?* |
| **Combat style** | Back line, at range (18 m). Turn 1: a Surge whose peak changes behaviour now. Turn 2: the reaction. From level 3 a Surge and a Temper share a turn |
| **Strengths** | Control from level-1 spells · one spell is both buff and debuff, more targets with every slot level · allies never roll against the Resonant |
| **Weaknesses** | Needs a turn of setup · enemies resist with Wisdom saves · creatures with Intelligence 4 or lower feel nothing · the Overload hurts if it is held too long |
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

### 4.2 The three states

**A peak changes what the creature does; a mood changes a number; a feeling mixes both** (R15).

- **Peak** (`EMOTION_*`, 1 turn): what a Surge applies on its own. When it expires on its own
  (`TimeOut`) it leaves its **mood**; removed any other way, it leaves nothing.
- **Mood** (`MOOD_*`, 5 turns): a milder echo. It fades; it does not rebound.
- **Feeling** (`FEELING_*`, 2 turns): two emotions braided. Leaves no mood.
- **Intense** (`EMOTION_*`, 1 turn): an emotion surged onto its own mood; when it ends the mood returns.

### 4.3 The core rule — distance

> **A Weave Surge cast on a creature that carries a mood reacts with it instead of landing alone, by the
> distance between the two emotions on the wheel, and the mood is spent.**

| Distance | Reaction | Plutchik | Unlocked at | Lasts |
|---|---|---|---|---|
| 0 | **Intensify** → the intense ring | intensity | level 7 (*Overwhelm*) | 1 turn, then back to the mood |
| 1 | **Primary feeling** | primary dyad | level 1 | 2 turns |
| 2 | **Secondary feeling** | secondary dyad | level 5 (*Complex Feelings*) | 2 turns |
| 3 | **Tertiary feeling** | tertiary dyad | level 9 (*Mixed Feelings*) | 2 turns |
| 4 | **Catharsis** | opposites | level 1 | instant |

- A reaction still locked (its passive not learnt): the Surge lands as a plain peak.
- The order of the two Surges doesn't matter: Joy on Accepting and Trust on Serene both braid Love.

### 4.4 The refund (R16)

> **When a Weave Surge causes a reaction, you regain the Woven Spell Slot it spent (on PC, in combat,
> the Thread). Once per turn.**

A reaction costs one slot: the Surge that prepares pays, the Surge that reacts is free when it works. A
failed save causes no reaction and refunds nothing.

### 4.5 Stacking

- Peaks and intense emotions share `StackId EMOTION`: a creature feels **one emotion** at a time; a new
  one replaces the old, so at most one mood comes out of it.
- Moods share `StackId MOOD`: **one mood** at a time, so each Surge causes at most one reaction.
- Every feeling has **its own** StackId: different feelings coexist on one creature.

### 4.6 Targets and saves

- **Any** Surge can target **any** creature that carries a mood.
- Without a mood: Joy, Trust and Anticipation only on allies (or yourself); the other five only on
  non-allies.
- A **Wisdom** save only when the target is a non-ally. Allies never roll.
- All require `IntelligenceGreaterThan(4)` (an emotion needs a mind).

### 4.7 Who causes reactions (R7)

**Only Weave Surges cause reactions.** A mood applied by any other source — Temper, Emotional Contagion,
Harmony, Shared Heart — **replaces** the creature's mood. No chain can form.

### 4.8 Edge cases

| Case | Rule |
|---|---|
| **A peak is cleansed or replaced** | No mood is left (only a peak that runs out leaves its mood) |
| **Combat ends** | The Overload meter resets (§6); states follow their own durations |
| **A Surge on a creature carrying a peak but no mood** | The new peak replaces the old; no reaction |
| **Contempt + Catharsis** | Contempt makes the target vulnerable to Psychic: a Catharsis on it deals double |
| **Multi-target Surges** | Each target reacts with its own mood; the refund still happens once per turn |

---

## 5. The states

A = helps whoever carries it · I = hinders it. Status type is BOOST unless the table says otherwise; a
different type lives in its own file and inherits from a vanilla parent with `using`.

### 5.1 Peaks — `EMOTION_*`, 1 turn (behaviour, R17)

| Peak | | What the creature does | To test |
|---|---|---|---|
| **Joy** | A | **Contagious:** allies near it gain Advantage on their next attack | Aura status |
| **Trust** | A | **Follows your lead:** when you or an ally attacks a creature, it can use its reaction to attack the same target | Interrupt — **T2** |
| **Anticipation** | A | **On guard:** when an enemy enters its reach, it attacks first | Interrupt on movement — **T2** |
| **Fear** | I | **Frozen with fear:** Frightened of you (vanilla type). Fleeing belongs to Terror | Vanilla |
| **Surprise** | I | **Caught off guard:** loses its reaction; the first attack against it has Advantage | — |
| **Sadness** | I | **Lets go:** loses Concentration and its Bonus Action | `BreakConcentration()` |
| **Disgust** | I | **Recoils:** moves away from the nearest creature and makes no melee attacks | Melee block — **T2** |
| **Anger** | I | **Grudge:** attacks the last creature that hurt it | Osiris tracks the last attacker — **T2** |

Each **T2** row gets a plan B if the test fails: Trust → its current +2 AC and Advantage on saves;
Anticipation → +1 reaction and doubled movement; Disgust → no action; Anger → attacks the nearest
creature other than you.

### 5.2 Moods — `MOOD_*`, 5 turns

| Mood | | Effect |
|---|---|---|
| Serene | A | Advantage on Wisdom saves |
| Accepting | A | +1 Armour Class |
| Interested | A | +3 m movement |
| Apprehensive | I | −1d4 on Wisdom saves |
| Distracted | I | Disadvantage on saves to keep Concentration |
| Pensive | I | −3 m movement |
| Bored | I | No reactions |
| Annoyed | I | −1 Armour Class |

### 5.3 Intense — `EMOTION_*` (same StackId as the peaks), 1 turn

| Intense | | Type | Effect |
|---|---|---|---|
| Ecstasy | A | BOOST | +1 action |
| Admiration | A | BOOST | Resistant to all damage, immune to Charmed and Frightened |
| Vigilance | A | BOOST | +2 reactions, Advantage on Dexterity saves |
| Terror | I | **FEAR** (`using FEARED`) | Flees in terror; Disadvantage on Ability Checks and Attack Rolls; no early save |
| Amazement | I | **INCAPACITATED** (`using STUNNED`) | Stunned |
| Grief | I | **INCAPACITATED** | Incapacitated, no movement |
| Loathing | I | BOOST | No action or bonus action; Disadvantage on Attack Rolls and Ability Checks |
| Rage | I | BOOST | **Grudge, overwhelming:** attacks the last creature that hurt it, with Advantage; attacks against it also have Advantage (R23) |

### 5.4 Feelings — `FEELING_*`, 2 turns

**Primary** (distance 1)

| Feeling | Blend | | Effect |
|---|---|---|---|
| Optimism | Anticipation + Joy | A | Immune to Frightened, temporary hit points each turn |
| Love | Joy + Trust | A | +1 AC and saves, Resistant to all damage; the Resonant takes the same damage |
| Submission | Trust + Fear | I | Knocked Prone; can't harm the Resonant |
| Awe | Fear + Surprise | I | **INCAPACITATED** until it takes damage (`using HYPNOTIC_PATTERN`) |
| Disapproval | Surprise + Sadness | I | Its allies within 3 m have Disadvantage on Attack Rolls |
| Remorse | Sadness + Disgust | I | The first time it deals damage each turn, it takes Psychic damage (TBD) |
| Contempt | Disgust + Anger | I | Vulnerable to Psychic |
| Aggressiveness | Anger + Anticipation | A | Extra weapon damage (TBD), +1 reaction |

**Secondary** (distance 2)

| Feeling | Blend | | Effect |
|---|---|---|---|
| Hope | Trust + Anticipation | A | Bonus to Attack Rolls and Saving Throws (Bless) |
| Guilt | Joy + Fear | I | No bonus action; Disadvantage on Wisdom saves |
| Curiosity | Trust + Surprise | A | Advantage on Ability Checks, +3 m, sees Invisible |
| Despair | Fear + Sadness | I | Penalty to Attack Rolls and Saving Throws (Bane) |
| Unbelief | Surprise + Disgust | I | Can't cast spells |
| Envy | Sadness + Anger | I | Attacks the nearest creature, its own allies included |
| Cynicism | Disgust + Anticipation | I | Can't regain hit points |
| Pride | Anger + Joy | A | Critical Hit on 19–20 |

**Tertiary** (distance 3)

| Feeling | Blend | | Effect |
|---|---|---|---|
| Delight | Joy + Surprise | A | Regains hit points at the end of each turn (TBD) |
| Sentimentality | Trust + Sadness | A | Resistant to Psychic; immune to Charmed |
| Shame | Fear + Disgust | I | No reactions; Disadvantage on Attack Rolls |
| Outrage | Surprise + Anger | I | Disadvantage on Attack Rolls; attacks against it have Advantage |
| Pessimism | Sadness + Anticipation | I | Penalty to Saving Throws and Ability Checks (TBD) |
| Morbidness | Disgust + Joy | A | The first weapon hit each turn restores hit points (TBD) |
| Dominance | Anger + Trust | A | Advantage on Athletics and Intimidation; +1 AC |
| Anxiety | Anticipation + Fear | I | Loses Concentration; no reactions; Disadvantage on Concentration saves |

### 5.5 Catharsis — `CATHARSIS`, instant

Opposing threads snap. A non-ally takes Psychic damage; an ally regains hit points (both TBD). Spends
the mood. Shows in the combat log.

---

## 6. The Overload (level 5)

> **The Resonant feels everything they make others feel.**

- **The meter** (`OVERLOAD`, a status on the Resonant with a visible count) fills by **+1** for each peak
  that lands and **+2** for each reaction (feeling, Intensify, Catharsis) (R12). A failed save adds
  nothing. Its size is TBD.
- **It resets when combat ends.**
- **Full:** at the start of each of the Resonant's turns they take Psychic damage (TBD) until they
  release it (R11). The decision: release now, or hold for the right target.
- **Shared Heart** (§7.6) counts **once per Surge**, however many linked allies react (R19).

### 6.1 Emotional Overload — the subclass's ultimate (R9, R10, R20)

The key feature that ties the mechanic together: everything the Resonant braided, poured into one enemy.

**Action, only with the meter full; the full meter is its cost — no slot, no Thread** (R22). One enemy within 18 m, no saving throw:
- every **feeling** it carries is spent, and it takes Psychic damage for each (TBD);
- it is **Paralysed for 2 turns**;
- the meter empties.

At Tier III it reaches an area (§9).

---

## 7. Spells outside the Surges

### 7.1 Heartstring — cantrip (level 1)

18 m, Wisdom save: Psychic damage that scales like vanilla cantrips. A target that carries a mood keeps
it 2 turns longer. The turn the Resonant falls back on, and a way to keep a mood alive for the next Surge.

### 7.2 Temper (level 3) — R4, R6

**Bonus Action.** Turn a creature's mood **one step** left or right on the wheel (a non-ally rolls a
Wisdom save). The mood keeps its remaining turns. It **replaces** the mood; it never causes a reaction
(§4.7). Surge and Temper share a turn: lay a peak, or turn a mood into the one the next Surge needs.

### 7.3 Emotional Contagion (level 9)

**Action · Concentration.** A creature's peak, mood or feeling copies to every creature within 6 m
(non-allies roll a Wisdom save). Copied moods replace; they never react (§4.7).

### 7.4 Ready: Compassion (level 11)

**Reaction card · Unique.** Until combat ends: when an ally within 9 m takes damage, cast Weave Surge:
Trust on it (it can trigger Alchemy). Once per round.

### 7.5 Read the Room — utility (level 1)

**Out of combat.** Advantage on Insight and Persuasion against a non-hostile creature. Concentration,
10 turns.

### 7.6 Shared Heart — capstone (level 11) — R18

**Action · Long Rest · Unique.** You and every ally within 18 m are **linked** for a few turns (TBD). A
Weave Surge on one linked ally lands on **all** of them, and they share the same mood: one Surge: Joy
makes the whole party contagious, one reaction braids Love or Hope into everyone. The Surge counts as one
reaction for the refund, the Overload and the Awakening (R19).

---

## 8. Passives by level

| Passive | Level | What it explains |
|---|---|---|
| **Emotional Alchemy** | 1 | The core rule once: peaks and moods, the distance rule, Catharsis and the primary feelings, and the refund (§4.4) |
| **Empathic Sight** | 1 | Advantage on Insight; the Resonant reads the threads of feeling in others |
| **Complex Feelings** | 5 | Unlocks distance 2 |
| **Overload** *(working name)* | 5 | The meter, its cost when full, and Emotional Overload (§6) |
| **Overwhelm** | 7 | Unlocks distance 0 |
| **Mixed Feelings** | 9 | Unlocks distance 3 |

---

## 9. Aspect Awakening — 14 · Temperance

**Goal — cause reactions.** Each feeling braided, each Intensify and each Catharsis counts 1, on allies
and enemies alike; every Catharsis of The Two Cups counts separately; a Shared Heart Surge counts once.
Counted in Osiris (`ARCANA_Aspect_Temperance`). Tiers stack and last until combat ends.

| Tier | Level | Goal | Name | Bonus |
|---|---|---|---|---|
| I | 3 | 3 reactions (TBD) | **Resonance** (R21) | Catharsis deals or restores more (TBD); moods you create last 2 turns longer; the Aspect card **The Two Cups** |
| II | 7 | 5 reactions (TBD) | **Harmony** (R8) | Once per turn, when you braid a feeling, the nearest other creature within 6 m gains the mood of one of that feeling's two emotions (it replaces, §4.7) |
| III | 12 | 7 reactions (TBD) | **Aspect of Empathy** (R14) | **Emotional Overload reaches an area:** the target and every enemy within 6 m carrying one of your feelings lose their feelings and are Paralysed — the target 2 turns, the others 1. No ability bonus |

### 9.1 The Two Cups — the Aspect card (Tier I)

**Created · 0 Threads · 0 slots · Action · once per combat.** Every creature within 18 m that carries a
mood undergoes Catharsis at once: enemies take Psychic damage, allies regain hit points. It works the
field; Emotional Overload works one target — the two never do the same thing.

---

## 10. Progression

| Level | Passives | Spells and features |
|---|---|---|
| **1** | **Emotional Alchemy** (with the refund) · **Empathic Sight** | Weave Surge: **Joy**, **Trust**, **Fear** · cantrip **Heartstring** · utility **Read the Room** |
| 2 | — (base class) | — |
| **3** | Tier I **Resonance** | Weave Surge: **Anticipation**, **Surprise**, **Sadness** · **Temper** (Bonus Action) · Aspect card **The Two Cups** |
| 4 | — | — |
| **5** | **Complex Feelings** · **Overload** | Weave Surge: **Disgust**, **Anger** (the full wheel) · **Emotional Overload** |
| 6 | — | — |
| **7** | **Overwhelm** · Tier II **Harmony** | — |
| 8 | — | — |
| **9** | **Mixed Feelings** | **Emotional Contagion** |
| 10 | — | — |
| **11** | — | **Shared Heart** (capstone) · **Ready: Compassion** |
| **12** | Tier III **Aspect of Empathy** | — |
| 13–20 | Reserved, like the rest of the class | |

**Why this order:**
- **Level 1** already braids two primary feelings (Love from Joy + Trust, Submission from Trust + Fear),
  and the refund makes two slots enough for two reactions.
- **Level 3** completes the bright arc and adds Sadness (the first Catharsis, Joy ↔ Sadness) and the
  Temper, so a turn can combine two plays.
- **Level 5** closes the wheel, opens distance 2 and brings the Overload with its ultimate, at vanilla's
  level-5 spike.
- **Level 7** overwhelms (distance 0); **level 9** opens the last ring and spreads states; **level 11**
  links the party; **level 12** spills the overload over the field.

Surges are level-1 cards (1 Thread) and gain **one extra target per slot level above 1** through
generated upcast variants.

---

## 11. How it plays

### 11.1 A turn

1. **Read the field:** which creatures carry which mood, and which peaks will fade into moods this round.
2. **Choose the pour:** which Surge on which mood — a feeling for an ally, a feeling or Catharsis for an
   enemy, a plain peak to change behaviour now.
3. **Bonus Action (level 3+):** Temper a mood one step to set up the next reaction.
4. **Watch the meter (level 5+):** release Emotional Overload, or hold it for a better target and take
   the damage.

### 11.2 A fight

- **Turn 1:** Surges whose peaks change behaviour now — Fear freezes the brute, Anger turns an enemy on
  its ally, Trust or Joy on the front line.
- **Turn 2–3:** the peaks have left moods; the reactions start, each one refunding its slot.
- **Mid-fight:** the Overload fills; Emotional Overload paralyses the enemy carrying the most feelings.
- **Long fights:** The Two Cups snaps every mood on the field at once; at 11 Shared Heart braids the whole
  party; at 12 Emotional Overload freezes everyone the Resonant has touched.

### 11.3 Party

The Resonant is strongest beside allies who hit hard (Joy, Trust, Pride, Ecstasy make their turns
better) and who can punish frozen or paralysed enemies. Their weakness to mindless creatures is covered
by allies who deal damage the plain way.

---

## 12. Text

All player-facing text is English, in Larian's voice (`31.03_BG3_Style_Guide`), following the shared
formulas of the Lore Bible:

- **Class description:** *"Mystra wove the Resonant from the feelings that pass between every living
  thing, a thread that tempers one emotion with another. They surge joy, trust or fear into a creature's
  Weave, then braid what lingers into stronger feelings that lift allies and break enemies from within."*
- **Tag line:** *"We feel what you feel before you do, and the Weave lets us turn it into something else."*
- **Moulds** (from the first version): spell `Weave Surge: <Emotion>`; peak `Emotion: <Emotion>`; mood
  `Mood: <Mood>`; feeling `Feeling: <Feeling>` — *"Threads of <A> and <B>, braided into one."*
- Peak descriptions are rewritten for the behaviour of §5.1.
- Names stay inside the Resonant's vocabulary: threads, braiding, pouring, tuning, the wheel of
  emotions. **Overflow** is not used (the base class has Arcane Overflow); **Attunement** is not used
  (the deck has the keyword Attuned).

---

## 13. Technical pattern

Everything below is Stats, Osiris and Khonsu; nothing needs Script Extender.

### 13.1 Generation

`80_TOOLS_AND_PIPELINE/82_Automation/stats/gen_emotion_alchemy.pl` reads one table (wheel order, names,
boosts and text of every state) and writes the 8 Surges with the reaction matrix in `SpellSuccess`, every
status in the file of its type, and the English strings. Change the table, never the patches; then
`gen_upcast_variants.pl`, `sort_stats.pl --apply`, `check_cards.pl`. The table gains the behaviour peaks
of §5.1.

### 13.2 Statuses and spells

| Piece | Pattern |
|---|---|
| Peaks, moods, intense, feelings, Catharsis | As built (`10_engine.patch`); `OnRemoveFunctors` with `IF(RemoveCause(StatusRemoveCause.TimeOut))` leaves the mood |
| **Refund** (§4.4) | In each reaction branch of the Surge's `SpellSuccess`: `RestoreResource(SELF,ArcanaSpellSlot,1,<level>)` by class level, plus `RestoreResource(SELF,ArcanaThread,1,0)`, guarded by a used-this-turn status — the pattern of `Arcana_Passive_ArcaneOverflow` (`Passive.txt`) |
| **Overload meter** | Osiris counts peaks applied (+1) and reaction statuses applied (+2) per Resonant, as `PROC_ARCANA_Aspect_Progress` does; shows the count on `OVERLOAD`; at full applies `OVERLOAD_FULL` (TickFunctors: Psychic damage at turn start); `CombatEnded` resets |
| **Emotional Overload** | Requirement: `HasStatus('OVERLOAD_FULL')`; removes every `FEELING_*` on the target with damage per feeling; Paralysed 2 turns; Osiris empties the meter. Tier III variant with a 6 m area filter on targets carrying the Resonant's feelings |
| **Anger's and Rage's grudge** | Osiris records the last creature that damaged the target and points the peak (or Rage) at it — **T2** |
| **Shared Heart** | `SHARED_HEART` on the linked creatures; Osiris copies a Surge's result from one linked ally to the others and counts it once — **T2** |
| **Temper** | Removes the mood and applies its neighbour with the same remaining turns (`GetStatusTurns`) |

### 13.3 Ids

| What | Ids |
|---|---|
| Surges | `Target_Arcana_Card_Spell_Emotion{Joy,Trust,Fear,Surprise,Sadness,Disgust,Anger,Anticipation}` |
| Passives | `Arcana_Passive_{EmotionalAlchemy,EmpathicSight,ComplexFeelings,Overwhelm,MixedFeelings}` + the Overload passive (new) |
| New spells | Heartstring, Temper, Emotional Contagion, Ready: Compassion, Read the Room, Shared Heart, Emotional Overload, The Two Cups — ids follow `33.03` and ADR-0002 |
| Legacy names to rename in the Toolkit | Tag `THEHEARTWEAVER`, ClassDescription Name, ProgressionDescription Type/Name `Heartweaver` |

---

## 14. Open

| Item | Decided in |
|---|---|
| Catharsis value and the Tier I bonus; Overload size and damage when full; Emotional Overload damage per feeling; Shared Heart duration; feeling values marked TBD; Awakening goals | Balance pass (`25_Master_Data`) |
| Plan B for each T2 peak if its test fails (§5.1) | After the tests |
| Every *(working name)*; the peak descriptions | Text pass |
| Aspect VFX per emotion | Author |
| Translations (strings are English only) | Localization |

## 15. To test in game

| Test | What proves it |
|---|---|
| A reaction refunds | A Surge that braids a feeling gives its slot back, once per turn; a failed save gives nothing |
| Joy's aura | Allies near the target gain Advantage on their next attack |
| Trust's follow-up attack | When you attack an enemy, the Trusting ally gets a reaction attack on it |
| Anticipation's guard | An enemy entering the ally's reach is attacked first |
| Disgust's recoil | The enemy moves away and makes no melee attack |
| Anger's and Rage's grudge | The enemy attacks whoever hurt it last, even its own ally (Rage with Advantage) |
| Overload count | Peaks add 1, reactions 2, failed saves 0; resets at combat end |
| Overload full | Psychic damage at the start of each of the Resonant's turns |
| Emotional Overload | Only castable at full; spends feelings, paralyses 2 turns with no save, empties the meter |
| Shared Heart | A Surge on one linked ally lands on all; counts once |
| The engine test of the first version | Its rows still pass (peaks → moods, reactions, locked rings, R9 StackId) |
