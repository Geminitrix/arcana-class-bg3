# The Spinner — X · Wheel of Fortune · Aspect of Anticipation

> Design document for the Arcana's subclass **The Spinner**. It describes everything the subclass is and
> does: identity, the engine and every one of its rules, the wheel of elements, every spell and passive,
> the progression, the Aspect Awakening, the edge cases and the technical pattern that builds it.
>
> Designed 2026-10-08 through the process in `21.04_Subclasses/_SUBCLASS_STANDARD.md`. Every gameplay
> effect lives in Stats, Osiris and Khonsu, so the subclass runs in **both editions** (PC with the deck,
> console without Script Extender).
>
> **Numbers are not set yet.** Wherever a value says *TBD* it is decided in the balance pass; durations
> (turn counts) are design and are final unless a test proves them wrong. Names marked *(working name)*
> are settled in the text pass.

---

## 1. The subclass in one page

The Spinner is the Arcana who holds the **spindle**. Where other Arcana pull on threads of the Weave, the
Spinner sees where each thread ends and decides when it is cut. In combat they **spin fates** onto
creatures — a **Misfortune** on an enemy, a **Fortune** on an ally — and every fate is a countdown that
the player can read on the creature's status icon. When a countdown reaches zero the fate **resolves**:
its damage, its condition or its blessing lands. From level 3, every fate that resolves pushes the
Spinner's other fates one step closer: the **Cascade**, a chain reaction the player builds over two or
three turns and then releases at once.

What the Spinner can cast each turn is set by the **wheel of elements**: ten magical damage types on a
fixed wheel that turns one step at the start of every one of the Spinner's turns. Only three elements are
open at a time — the **Past**, the **Present** and the **Future** — and each changes the spell cast in it:
the Past makes the fate one turn shorter, the Present adds an immediate strike, the Future makes it one
turn longer.

Nothing is random. Everything is visible. Nothing can be stopped once it starts.

**Fantasy:** the one who already knows how the fight ends.
**Role:** ranged magical damage — sustained damage while fates wait, burst when they fall together —
with a secondary support style through Fortunes.

---

## 2. Identity

### 2.1 The card — X · Wheel of Fortune

The card descends from the medieval **Rota Fortunae**, the wheel that the goddess **Fortuna** turns
(Boethius, *The Consolation of Philosophy*). Kings rise on it, reign at its top, fall, and lie at its
bottom until it turns again; no one on the wheel controls it. Fortuna is blind, so for the people on the
wheel it looks like luck; the wheel itself is a machine, so the outcome is inevitable. Modern readings
call the card **destiny, cycles, karma and the turning point**; reversed, it means bad luck and broken
cycles.

| Reading of the card | Where it lives in the Spinner |
|---|---|
| **Cycles** — the wheel always comes back round | The wheel of elements cycles forever and never stops between fights; **Recurrence** (Tier III) returns every fate once |
| **Rise and fall** — one rises as another falls | Fortunes rise on allies while Misfortunes fall on enemies; **Lachesis** (Tier II) turns an enemy's fall into an ally's protection |
| **Inevitability** — the wheel can't be stopped | Fates are deterministic and visible; once a Cascade starts, nothing interrupts it |
| **The turning point** | The Cascade: the moment a prepared field collapses |
| **Past, present and future** | The four Latin positions of the Rota are verb tenses — *Regnabo* (I shall reign), *Regno* (I reign), *Regnavi* (I have reigned), *Sum sine regno* (I am without reign). The wheel of elements uses them as **Future, Present, Past** and **locked** |
| **Fortune and misfortune** | The two kinds of fate |

**The imagery of the Rider-Waite card:**
- The **four winged creatures** in the corners — the fixed signs Taurus (bull), Leo (lion), Scorpio
  (eagle) and Aquarius (angel), reading books while the wheel turns — are the **four Fortunes**.
- The **sphinx** with a sword at the top of the wheel, judgement and balance, is the **Radiant Ritual**
  at the top of the wheel of elements.
- The **serpent** descending on one side is the descending half of the wheel of elements, down to
  Necrotic at the bottom.
- **Anubis** rising on the other side is the **Angel**, the Fortune that lifts a fallen ally.

### 2.2 The Aspect — Anticipation

Every Arcana Aspect is an emotion (Curiosity, Doubt, Hope, Sorrow, Empathy). **Anticipation** is the
Spinner's: the feeling of seeing something coming and waiting for it. Playing the Spinner *is*
anticipating — reading the countdowns, reading the wheel, knowing that the Fire comes back in two turns
and holding the card for it.

Anticipation is also one of the eight basic emotions on Plutchik's wheel, so the Resonant has a Weave
Surge called Anticipation. That overlap is deliberate and coherent: the feeling the Resonant can only
surge into a creature for one turn is the one the Spinner lives in.

### 2.3 Mystra and the Weave

The Weave is spun. The other Arcana are woven into it and pull on its threads; the Spinner was woven
holding the **spindle** — the point where every thread is drawn out and measured. They see how long
each thread is, and they choose the moment it is cut. *(The in-game sentence is written in the text
pass, §13.)*

### 2.4 Myth

| Source | What it lends |
|---|---|
| **Fortuna** and the **Rota Fortunae** | The card itself, the four positions, the wheel of elements |
| **The Moirai** — Clotho spins, Lachesis measures and allots, Atropos cuts | Tier I **Clotho**, Tier II **Lachesis**, the card **Atropos' Shears** |
| **Ananke** and the **Spindle of Necessity** (Plato, the Myth of Er: the universe turns on a spindle resting on the knees of Necessity, and the Fates turn it) | The level-7 passive **Spindle of Necessity**; the needle of the spindle is **Spindle Needle** |
| **The Norns** — Urðr (what was), Verðandi (what is becoming), Skuld (what shall be) | The idea of a Past, a Present and a Future that a weaver can see at once |
| **Nemesis** — the balance of fortune | Lore for "what rises must fall" |

### 2.5 Science — the chain reaction

A **nuclear chain reaction**: every event releases particles that set off further events. Its
behaviour is set by the **multiplication factor *k***, the average number of new events each event
causes.

| *k* | State | In the Spinner |
|---|---|---|
| < 1 | **Subcritical** — the chain dies out | Fates scattered: a Cascade pushes them but none reaches zero |
| = 1 | **Critical** — each event sets off exactly one more | Fates laid out as a staircase (1, 2, 3…): the chain sustains itself |
| > 1 | **Supercritical** — the chain grows | Several fates on the same count: every resolution brings more than one to zero |

The player's skill is to **bring the field to criticality**. The model gives the level-9 rule its name
and shape (**Critical Mass**).

### 2.6 Fiction and powers

| Reference | What it lent |
|---|---|
| **Zilean** (League of Legends) | *Time Bomb* passing from target to target → the **Transfer** of a Misfortune when its target dies |
| **Faceless Void** (Dota 2) | *Chronosphere*, time stopped in an area → **The Wheel Stops** |
| **Bard** (League of Legends) | *Tempered Fate* freezes allies and enemies alike → The Wheel Stops freezes **everyone** |
| **DIO** (*JoJo's Bizarre Adventure*, Part 3) | *The World*: the moment the world stops and only one person moves — the fantasy of The Wheel Stops |
| **Twisted Fate** (League of Legends) | *Pick a Card*, cards cycling until you take one → the wheel of elements cycling under your hand |
| ***Final Destination*** | Death's design: a chain of accidents that looks like chance and is inevitable → the Cascade |
| ***Death Note*** | A name written, a death that arrives on schedule → the **Necrotic Ritual** |
| **Legends of Runeterra** | Spell speeds (Burst, Fast, Slow) → the Spinner's **speeds** (§5.1) |

### 2.7 Summary sheet

| | |
|---|---|
| **Arcanum** | X · Wheel of Fortune |
| **Aspect** | Anticipation (in game: *10 - Wheel of Fortune*) |
| **Archetype** | The clockmaker of fate |
| **Role** | Ranged magical damage (sustained + burst); secondary: timed support |
| **Play style** | Plant fates over two or three turns, read the wheel, then release them together. The decision of each turn: *now, or later, and with what?* |
| **Combat style** | Back line, at range, high initiative (DEX). Positions **others**: allies with Fortunes beside enemies with Misfortunes, enemies pulled together for the Cascade |
| **Strengths** | Burst across many targets through the Cascade · damage that keeps working while the Spinner does other things · acting first and setting up before enemies move |
| **Weaknesses** | Slow to start; a fight that ends in two rounds wastes the setup · fates can be cleansed · the wheel freezes while the Spinner is down · the wheel decides which elements are open, so some turns are weaker |
| **Colour** | Teal `#60d7d2` (the emblem `finalv2_iconpng_spinner.png`: teal ribbons around a silver wheel) |
| **Emoji / Aspect VFX** | To choose (open, §15) |

---

## 3. Chassis

| Field | Value |
|---|---|
| Spellcasting ability | **Intelligence** (the whole class) |
| Secondary ability | **Dexterity** — initiative is the only place where Anticipation becomes a number on the sheet: the wheel turns at the start of the Spinner's turn, so acting earlier means fates resolve before enemies act. It also gives AC in light armour |
| Saving throws | Intelligence, Dexterity |
| Armour | Light |
| Weapons | Daggers, Darts, Hand Crossbows, Light Crossbows |
| Skills (choose 4, then 2 Expertise) | Skill list **The Fortune-Teller** *(working name)*: Arcana, History, Insight, Investigation, Perception, Sleight of Hand, Acrobatics, Deception |
| Ability preset | STR 8 · DEX 15 · CON 13 · INT 15 · WIS 10 · CHA 10 |
| Starting gear | Spinner robe (cloth), Dagger, Light Crossbow, Darts (to be built in the Toolkit) |
| Sound set | Wizard |

> The Spinner's progression table (`a688d11f-edff-44c5-95ac-0e4999ebf876`) currently holds a placeholder
> copied from the Resonant at level 1 (Emotional Alchemy, Empathic Sight, WIS and CHA saves). It is
> replaced by this chassis and §9.

---

## 4. The engine — fates

### 4.1 Fortune and Misfortune

A **fate** is a status the Spinner spins onto a creature.

| Kind | On | What it is |
|---|---|---|
| **Misfortune** | An enemy | Damage, sometimes with a condition: while it waits, when it resolves, or both |
| **Fortune** | An ally or the Spinner | A blessing that lands when it resolves |

- **The countdown is the status's duration.** A fate spun with 3 turns shows **3** on its icon, as every
  timed status does in BG3.
- **The wheel of fate turns on the Spinner's turn.** At the start of each of the Spinner's turns, every
  fate they have spun counts down by 1 — on every creature, at the same moment. One clock for the whole
  field.
- **At 0 the fate resolves.** Its effect lands. A fate removed in any other way (cleansed, dispelled,
  combat over) does nothing.
- **The power of a fate is fixed by its card.** Waiting is the price a card pays: a 4-turn card is
  stronger than a 1-turn card. Spinning the same card again doesn't make the fate stronger (§4.3).
- **Deterministic.** No fate, rule or effect of the Spinner uses chance beyond the ordinary damage dice
  and saving throws every spell has.

### 4.2 Bleed and resolution

A Misfortune has a **bleed**, a **resolution**, or both:
- **Bleed:** low damage each time the wheel of fate turns (start of the Spinner's turn) while the fate
  waits. This is the sustained damage of the style.
- **Resolution:** the effect when it reaches 0. This is the burst.
- Some Misfortunes also apply a condition **while they wait** (−AC, no healing, Poisoned…).

**Advancing a fate skips its bleed for the skipped turn.** If a Misfortune had 3 turns of bleed left
and is advanced by 1, it bleeds twice more and resolves. The player chooses between **letting it bleed**
(more total damage) and **pulling it down** (the resolution now, when timing matters more than total).

### 4.3 Stacking

- **One fate per card per creature.** Different cards coexist on the same creature: a boss can carry the
  Fire, the Poison and the Necrotic fates at once.
- **The same card again adds turns.** Spinning a card on a creature that already carries that card's fate
  adds the new duration to what remains (*Fire with 1 turn left + a new Fire of 2 = Fire with 3*). It is
  one fate, further away; the effect stays the same.

### 4.4 Advancing a fate

Several cards and rules **advance** a fate: they move its countdown 1 step closer to 0. A fate advanced
to 0 resolves at once, exactly as if the wheel had brought it there. Advancing never goes below 0.

### 4.5 The Cascade (level 3)

> **When one of your fates resolves, every other fate of yours within 9 m of it advances 1 step.**

- A fate that reaches 0 through a Cascade resolves too, and sets off its own Cascade.
- **Every resolution is one push.** Two fates resolving together push the others twice.
- The Cascade moves only the Spinner's **own** fates.
- Fortunes and Misfortunes push each other: an ally's Fortune resolving next to cursed enemies pushes
  their Misfortunes. Positioning allies is part of the engine.

**Range by level:**

| Level | Range of each Cascade |
|---|---|
| 3 | 9 m around the fate that resolved |
| 9 | 9 m, until the chain has resolved **3** fates; from then on that chain's Cascades have **no limit** (Critical Mass, §9.6) |
| 12 | Every Cascade reaches every fate of the Spinner in the combat |

### 4.6 Resolving a chain — waves

When several fates reach 0 at once, they resolve in **waves**:

1. **Advance** every affected fate by 1.
2. **Collect** the fates that reached 0 into this wave's queue. A fate already in the queue is not
   advanced again.
3. **Resolve** the queue **oldest first** (the fate spun earliest resolves first). Each fate is removed
   **before** its effect fires, so it can never resolve twice.
4. Each resolution makes **one Cascade**. The fates its Cascades bring to 0 form the **next wave**.
5. The chain ends when a wave is empty.

Order matters in two places: **Spindle of Necessity** (the first fate of a chain gets no bonus), and the
**Transfer** (an enemy who dies mid-chain passes its Misfortune before the next wave).

**Worked example (level 9):** the ogre carries a Misfortune at 4, a goblin and a gnoll each one at 1.
The Spinner plays a card that advances every fate by 1 → 3, 0, 0.
- Wave 1: the goblin's fate (spun first) resolves → Cascade: ogre 3 → 2. The gnoll's fate resolves →
  Cascade: ogre 2 → 1. Two fates resolved; the gnoll's gets the Spindle bonus.
- Wave 2: nothing at 0 → the chain ends with the ogre at 1, ready for next turn.

### 4.7 The start of the Spinner's turn

In this order, before the Spinner can act:
1. The **wheel of elements** turns one step (§5).
2. Every fate of the Spinner **counts down** by 1 (bleeds happen here).
3. Fates at 0 **resolve**, in waves (§4.6).

No resolution reads the wheel, so steps 1 and 2 never affect each other; the Spinner always acts
knowing both the new element and the state of every fate.

### 4.8 Edge cases

| Case | Rule |
|---|---|
| **Combat ends** | Every fate is removed without resolving: no effect, no count for the Awakening. Fates never run outside combat |
| **Casting outside combat** | A Misfortune is hostile and starts combat, like any hostile spell. A Fortune can only be spun in combat |
| **The Spinner is downed** | The wheel of fate freezes: nothing counts down or resolves until they are back up. The wheel of elements doesn't turn either |
| **A Misfortune's bearer dies** | Its Misfortunes move by the **Transfer** (level 5, §9.4); before level 5 they are lost. Lost fates don't count for the Awakening |
| **A Fortune's bearer dies** | The Fortune is lost (the **Angel** is the exception: it resolves on a *downed* ally, §7.2) |
| **Cleansed or dispelled** | Removed: no effect, no Cascade, no count |
| **Two Spinners in the party** | Each moves only their own fates; each has their own wheel of elements |
| **A frozen fate** (*Frozen Moment*) | Doesn't count down and **can't be advanced** by anything (Cascade, Needle, Rota Fortunae) while frozen |
| **Recurrence** (Tier III) | A resolved fate returns **after the whole chain has ended**, never during it, so the chain that resolved it can't push it again. It returns once (a hidden marker) |
| **Recurrence and Transfer** | Transfer happens on death, not on resolution: a transferred fate keeps its right to return. A fate that has already returned can be transferred, but never returns again |
| **Transfer target** | The nearest enemy within 9 m. If it already carries the same card's fate, the turns add up (§4.3). No enemy in range: the fate is lost |

---

## 5. The wheel of elements

### 5.1 Speeds

Every Spinner spell has a **speed**, adapted from Legends of Runeterra. The speed is the length of the
fate and decides the cost.

| Speed | Fate length | Cost | Use |
|---|---|---|---|
| **Ready** | — (reaction) | The reaction (`02-systems.md` §8) | Answer a condition you saw coming |
| **Burst** | 0 — resolves on cast | Bonus Action, or free | Emergency trigger, shallow damage |
| **Fast** | 1–2 turns | Action or Bonus Action | Quick pieces |
| **Measured** *(working name)* | 2–3 turns | Action | The body of the kit |
| **Slow** | 3–4 turns | **Action + Reaction** — casting a Slow spell spends the reaction, so Ready cards are unavailable that round |
| **Ritual** | 5–6 turns | **Action, and the Spinner can't move for the rest of the turn** (a self status with `ActionResourceBlock(Movement)`) — they stand still to perform it |

Every spell also pays its card level: a Woven Spell Slot, or Threads in combat on PC.

### 5.2 The wheel

Ten magical damage types on a fixed wheel. **Radiant at the top** (the king, *Regno* of the Rota),
**Necrotic at the bottom** (*Sum sine regno*), one side descending and the other rising, and **every
element facing its opposite** across the wheel:

```
                 1 · Radiant (top)
     10 · Psychic                2 · Fire
   9 · Poison                       3 · Lightning
     8 · Acid                    4 · Thunder
         7 · Cold          5 · Force
                 6 · Necrotic (bottom)
```

Clockwise: Radiant → Fire → Lightning → Thunder → Force → **Necrotic** → Cold → Acid → Poison → Psychic →
back to Radiant.

| Opposites | Meaning |
|---|---|
| Radiant ↔ Necrotic | Life and death |
| Fire ↔ Cold | Heat and its absence |
| Lightning ↔ Acid | The electric and the chemical |
| Thunder ↔ Poison | The roar and the silent |
| Force ↔ Psychic | Body and mind |

The three physical types are not on the wheel: they belong to the Spinner's **tools** — Piercing to the
needle of the spindle, Slashing to Atropos' shears, Bludgeoning to the wheel itself (Rota Fortunae).

### 5.3 Turning

- The wheel turns **one step at the start of each of the Spinner's turns**, clockwise.
- **It never stops, it pauses.** When a combat ends, the wheel keeps its position; the next combat
  starts on the **next** element. A status on the Spinner shows the current element at all times,
  inside and outside combat, so the player knows what the next fight opens with.
- **The very first combat** of a Spinner starts on **Lightning**: the spark of the chain reaction.
- The only way to move it outside combat is the utility **Nudge the Wheel** *(working name)* (§8.4).

### 5.4 The window — Past, Present, Future

Three positions are open at any time; the other seven are locked.

| Position | Rota Fortunae | Element | Casting a spell of that element |
|---|---|---|---|
| **Future** | *Regnabo* — I shall reign | The next one | The fate is spun **1 turn longer** |
| **Present** | *Regno* — I reign | The current one | Normal length, and the **Crown strike**: an immediate hit on the target, on top of spinning the fate |
| **Past** | *Regnavi* — I have reigned | The previous one | The fate is spun **1 turn shorter** |
| **Locked** | *Sum sine regno* — I am without reign | The other seven | Can't be cast |

- **What each position is for:** the Past is **haste** (the piece lands sooner), the Present is
  **impact now** (the Crown strike), the Future is **synchronisation** (push a piece so it falls together
  with the others and reaches Critical Mass).
- **Burst and Ready spells** have no countdown: the Past and the Future don't change them. A Burst spell
  cast in the Present still gets the Crown strike; a Ready card has no target and doesn't.
- **Minimum length 1.** A Fast spell of 1 cast in the Past stays at 1. Clotho (Tier I) also shortens:
  Past + Clotho = −2, still minimum 1.
- The Future has **no power bonus**, only the extra turn: its value is timing. *(If tests show nobody
  casts in the Future, it gets a small bonus in the balance pass.)*
- **Never locked:** Fortunes, the cantrip, Spindle Needle, Atropos' Shears, The Wheel Stops, the Aspect
  card, Ready: Foreseen and the utility. Only elemental spells follow the wheel.

**First combat ever:** Past = Fire · Present = Lightning · Future = Thunder.

**Reading it in game:** the status on the Spinner is named after the Present element and its tooltip
lists the window (*Future: Thunder · Present: Lightning · Past: Fire*). Locked spells are greyed out
on the hotbar, as any spell that can't be paid is.

---

## 6. Elemental spells

Fifteen spells: one for each element, two Rituals at the poles of the wheel, and four **wildcards**
that explore a side of their element the first set didn't use. Lengths are the base length (before
Past/Future). Damage values are *TBD*.

| # | Element | Spell *(working names)* | Speed | While it waits | When it resolves |
|---|---|---|---|---|---|
| 1 | **Radiant** | *Radiant Fate* | Fast · 1 | — | Radiant damage and **Blinded** for 2 turns |
| 1 | **Radiant** | **Radiant Ritual** — *the Judgement* | **Ritual · 6** | The target **shines**: it can't be invisible or hide | A large Radiant **explosion around the target** |
| 2 | **Fire** | *Fire Fate* | Measured · 2 | **Bleed** (burning) | Fire damage |
| 3 | **Lightning** | *Spark* | **Burst** | — | Shallow Lightning damage that **arcs between every enemy carrying one of your fates** |
| 4 | **Thunder** | *Thunder Fate* | Slow · 3 | Silence before the storm (no effect) | A **shockwave**: Thunder damage in 3 m around the target and a push |
| 5 | **Force** | *Force Fate* | Fast · 1 | — | Force damage and **Prone** |
| 5 | **Force** | ***Pull of Fate*** *(wildcard)* | Measured · 2 | — | Force damage and **pulls every enemy within 6 m** to the target — gathers pieces for the Cascade and for Thunder |
| 6 | **Necrotic** | **Necrotic Ritual** — *the Death Note* | **Ritual · 5** | The target **can't be healed** | Massive Necrotic damage; **below a HP threshold, it dies** |
| 7 | **Cold** | *Cold Fate* | Measured · 2 | **Bleed** and reduced movement speed | Cold damage |
| 7 | **Cold** | ***Frozen Moment*** *(wildcard)* | **Burst** · Bonus Action | — | **Freezes** every fate on one creature for 2 turns: they neither count down nor can be advanced. Holds a piece until the others catch up |
| 8 | **Acid** | *Acid Fate* | Fast · 2 | **Bleed** and **−2 AC** | Acid damage splashing nearby enemies |
| 8 | **Acid** | ***Dissolve*** *(wildcard)* | Fast · 1 | The target **loses its damage resistances** | Acid damage — the answer to enemies that resist Poison or Necrotic |
| 9 | **Poison** | *Poison Fate* | Slow · 4 | **Poisoned** and a strong **bleed** | Poison damage — the strongest sustained damage if left to run |
| 10 | **Psychic** | *Premonition* | **Ready** | — | When an enemy attacks you or an ally within 9 m: Psychic damage and Disadvantage on that attack. Once per round |
| 10 | **Psychic** | ***Déjà Vu*** *(wildcard)* | Measured · 3 | — | The target **relives the last hit it took**: that damage happens again, whoever dealt it. Repeats damage only — never statuses or fates — and only one hit, with a damage cap *TBD* |

**Speeds across the wheel:** Burst 2 · Fast 4 · Measured 4 · Slow 2 · Ritual 2 · Ready 1. Speeds are
interleaved around the wheel so that every window of three positions offers different speeds.

**Not crowd control:** the conditions (Blinded, Prone, −AC, no healing, Poisoned) are riders on damage.
The only hard effect is the Necrotic Ritual's execution threshold, the payoff of a 5-turn wait.

**Ready cards (Premonition):** it can only be **readied** while Psychic is in the window; once readied it
fires at any time. On console the card is cast and applies its READY status until combat ends; on PC,
holding it in hand is the charge (`02-systems.md` §8).

---

## 7. Fortunes — the four winged creatures

### 7.1 Rules common to all Fortunes

- Spun on an **ally or the Spinner**, only in combat.
- They resolve at the start of the Spinner's turn; **their effect lasts until the end of the bearer's
  next turn**, so the ally benefits whether they act before or after the Spinner.
- They are **not on the wheel of elements**: never locked, no Crown strike, unchanged by Past/Future.
- They take part in the **Cascade** like any fate: a Fortune resolving pushes the fates around it.

### 7.2 The four Fortunes

| Creature | Sign | Speed | When it resolves | Virtue |
|---|---|---|---|---|
| **The Bull** | Taurus (earth) | Fast · 1 | Temporary HP; **can't be pushed or knocked Prone** | Steadfastness |
| **The Eagle** | Scorpio (water) | Measured · 2 | Attacks **critically hit on 19–20**; **sees invisible creatures** | Sight |
| **The Lion** | Leo (fire) | Measured · 3 | An **extra action** on the bearer's next turn; immune to Frightened | Courage |
| **The Angel** | Aquarius (air) | Slow · 4 | A **large heal**; if the bearer is **downed** at that moment, they **get back up** with that HP | Grace — the rescue prepared before the fall |

The Angel is the only fate that works on a downed creature, and the clearest image of Anticipation in the
kit: you place the rescue at the start of a hard fight, before anyone has fallen.

---

## 8. Tools — spells outside the wheel

### 8.1 Cantrip — *Spoke of the Wheel* (level 1)

A ranged spell attack (18 m) that deals the damage type of the **Present** element. It is the Spinner's
baseline turn and the reason no turn is ever empty. Damage scales with character level, like vanilla
cantrips. It spins no fate.

### 8.2 *Spindle Needle* (level 1) — Piercing

**Burst · Bonus Action.** Shallow Piercing damage to a creature, and **every fate of yours on that
creature advances 1 step**. The basic converter: pull a fate down, start a chain, finish a staircase. As
a Bonus Action it combines with any spell the same turn.

### 8.3 *Atropos' Shears* (level 5) — Slashing

**Action.** Every fate of yours on one creature with **2 turns or fewer** remaining **resolves now**,
each with its own Cascade, plus Slashing damage *TBD*. *"Only a thread that is already short can be
cut."* A long fate (a Ritual) must still wait until it is near its end: the shears finish a wait, they
never skip it.

### 8.4 Utility — *Nudge the Wheel* *(working name)* (level 1)

**Outside combat only.** Turns the wheel of elements **one step** forward. Costs no Woven Spell Slot;
**once per Long Rest**. Lets the player prepare before a fight they can see coming: *the wheel is on
Necrotic and the undead are ahead — nudge it first.* A utility (`Arcana_Util_` family): locked in combat
like every utility.

### 8.5 *The Wheel Stops* (level 11) — the capstone

**Long Rest · Unique.** Every creature in the combat — **allies included** — is frozen: they skip their
turns while it lasts. Only the Spinner acts, and **every action the Spinner takes advances all their
fates by 1**, with Cascades resolving normally. Frozen creatures still take damage. It is the moment the
world stops and the Spinner places every piece where it will fall. Duration *TBD* (in turns of the
Spinner).

---

## 9. Passives and rules by level

### 9.1 *Spun Fates* (level 1) *(working name)*

Explains the engine once: fates, the countdown on the Spinner's turn, resolution at 0, bleed, one fate
per card (the same card adds turns), advancing.

### 9.2 *The Turning Wheel* (level 1) *(working name)*

Explains the wheel of elements once: one step per turn, never stops, the window (Past −1 turn, Present
Crown strike, Future +1 turn), the locked elements, what is never locked.

### 9.3 *Cascade* (level 3)

The chain reaction (§4.5) at 9 m.

### 9.4 *Transfer* (level 5) *(working name)*

When an enemy carrying one of your Misfortunes dies, each of its Misfortunes **jumps to the nearest
enemy within 9 m** with the turns it had left (§4.8 for the details). An enemy's death feeds the chain
instead of breaking it.

### 9.5 *Spindle of Necessity* (level 7)

*The Fates turn the spindle, and every thread that falls pulls the next one harder.* Every fate after the
first that resolves **within the same chain** deals extra **Force** damage (*TBD*, first estimate 1d6).
Long chains are rewarded for being long.

### 9.6 *Critical Mass* (level 9)

When a chain has resolved **3 fates**, it goes critical: from then on, every Cascade **in that chain** has
no range limit. The goal of a turn becomes clear — reach three.

### 9.7 Level 12 — the Cascade without limit *(working name)*

Every Cascade reaches every fate of the Spinner in the combat, from the first resolution.

---

## 10. Aspect Awakening — 10 · Wheel of Fortune

### 10.1 The goal — fates resolved

Every fate of the Spinner that **resolves** counts 1 — Fortune or Misfortune, through the wheel or
through any advance. Fates lost, cleansed or removed at combat end don't count. A chain of four counts
four, so the Cascade drives the Awakening by itself.

| Tier | Level | Goal (provisional) | Name |
|---|---|---|---|
| I | 3 | 3 fates | **Clotho** — the one who spins |
| II | 7 | 6 fates | **Lachesis** — the one who measures |
| III | 12 | 10 fates (X, the card's number) | **Aspect of Anticipation** |

*The goals are expected to rise in the balance pass (the author finds them low).*

Tiers stack and last until combat ends, as for every Arcana subclass (`02-systems.md` §10).

### 10.2 Tier bonuses

| Tier | Bonus | Why |
|---|---|---|
| **I · Clotho** | Once per turn, the **first fate you spin starts 1 step closer** (minimum 1). A 4-turn card resolves in 3, with the same effect | The spinner spins faster: the engine runs quicker without changing the cards' power |
| **II · Lachesis** | When one of your **Misfortunes resolves**, you and allies within **3 m of its target** gain temporary HP (*TBD*). Temporary HP doesn't stack in BG3 — the highest stays — so a chain never builds a triple shield | Lachesis measures and allots each life's length; the wheel's image — one falls, another rises. It rewards allies standing beside cursed enemies |
| **III · Aspect of Anticipation** | **Recurrence**: when a fate of yours resolves, it **returns once** to the same creature with its original length, after the chain ends (§4.8). And the card **Ready: Foreseen** is conjured | The cycle at its peak: the Spinner sees it coming (Foreseen) and knows it will come back (Recurrence) |

### 10.3 Ready: Foreseen (Tier III)

**Reaction, once per round.** When an enemy carrying one of your Misfortunes is about to attack or cast,
advance that Misfortune by 1. If it reaches 0, it resolves **before** the attack happens, and its Cascade
fires. *You saw it coming.*

### 10.4 The Aspect card — *Rota Fortunae* (Tier I)

Created, 0 Threads, 0 slots, costs the action, **once per combat**. **Every fate of yours on the field
advances 1 step.** At level 3 it pulls the wheel once; at level 12, with the Cascade without limit, it can
bring the whole field down. The Spinner's Bludgeoning — the wheel itself — belongs to this card (whether
it also deals damage of its own is open, §15).

---

## 11. Progression

| Level | Rules (passives) | Spells | Card level |
|---|---|---|---|
| **1** | **Spun Fates** · **The Turning Wheel** | Cantrip *Spoke of the Wheel* · *Spindle Needle* · **Fire** (Measured 2) · **Force** (Fast 1) · **Acid** (Fast 2) · Fortune **Bull** (Fast 1) · utility *Nudge the Wheel* | 0 / 1 |
| 2 | — (base class) | — | |
| **3** | **Cascade** (9 m) · **10 - Wheel of Fortune: Awakening** · Tier I **Clotho** → *Rota Fortunae* | **Lightning** (*Spark*, Burst) · **Cold** (Measured 2) · **Radiant** (Fast 1) · Fortune **Eagle** (Measured 2) | 2 |
| 4 | — | — | |
| **5** | **Transfer** | **Thunder** (Slow 3) · **Poison** (Slow 4) · **Psychic** (*Premonition*, Ready) · *Atropos' Shears* | 3 |
| 6 | — | — | |
| **7** | **Spindle of Necessity** · Tier II **Lachesis** | *Pull of Fate* · *Frozen Moment* · *Dissolve* · Fortune **Lion** | 4 |
| 8 | — | — | |
| **9** | **Critical Mass** | **Necrotic Ritual** (5) · *Déjà Vu* · Fortune **Angel** (Slow 4) | 5 |
| 10 | — | — | |
| **11** | — | ***The Wheel Stops*** · **Radiant Ritual** (6) | 6 |
| **12** | **Cascade without limit** · Tier III **Aspect of Anticipation** (Recurrence + *Ready: Foreseen*) | — | |
| 13–20 | Reserved, like the rest of the class | | |

**Why this order:**
- **Level 1** places Fire, Force and Acid at positions 2, 5 and 8 of the wheel: one of them is in the
  window on 9 turns out of 10 (the gap is when Psychic is the Present, and the cantrip, the Needle and the
  Bull still cover it). The first combat ever opens with Fire in the Past. No Slow spell at level 1:
  early fights are short.
- **Level 3** brings Lightning together with the Cascade — the spark and the chain arrive together — and
  Radiant closes the last gap: from level 3 every window has an elemental spell.
- **Level 5** brings the Slow spells (Thunder's area burst, Poison's long bleed) and the shears, when
  there are long fates to finish.
- **Level 7** brings the wildcards once the basics are known, and the Lion, whose extra action is too
  strong early.
- **Levels 9 and 11** bring the two Rituals: the bottom of the wheel (Necrotic) first, the top (Radiant)
  last. The Spinner climbs the wheel to the crown by the end of the journey.

**Card level** is the Thread price and the lowest slot the card is cast with; provisional, set in the
balance pass. Every card scales with the Spinner's slot level through generated upcast variants
(`02-systems.md` §4).

---

## 12. How it plays

### 12.1 A turn

1. **Read the start of the turn:** the wheel has turned (which three elements are open, which one is the
   Present), fates have counted down, bleeds have hit, anything at 0 has resolved and cascaded.
2. **Decide what to build:** which elements are open, and in which position — haste (Past), impact
   (Present), timing (Future).
3. **Decide what to release:** is there a staircase close to critical? A Needle (Bonus Action) on the
   right fate can start the chain.
4. **Place the others:** a Fortune on an ally who is standing among cursed enemies; Pull of Fate to
   gather enemies into range.

### 12.2 A fight

- **Turn 1:** a Present spell for its Crown strike, a Fast fate, a Needle or a cantrip. Something useful
  now, while the first pieces go down.
- **Turns 2–3:** the field fills with countdowns; bleeds tick; the player builds a staircase.
- **Turn 3–4:** the release — a Needle, a Spark, Rota Fortunae or the shears set off the chain; with
  Critical Mass the whole field resolves.
- **Long fights:** Rituals planted early land late; the Angel waits for the ally who will fall; Recurrence
  brings every fate back for a second cycle.

### 12.3 The two styles

| Style | Core | What it does |
|---|---|---|
| **Misfortune** (main) | Elemental fates | Sustained damage while they bleed, burst when they cascade |
| **Fortune** (secondary) | The four creatures | Blessings that land at the right moment, and allies as dominoes in the chain |

A player can lean on either or mix them; both feed the same Cascade.

### 12.4 Party

The Spinner is strongest beside melee allies who stand among enemies (Fortunes and Misfortunes in the
same 9 m), and beside anyone who can group enemies (Pull of Fate does it alone). Their weakness to short
fights is covered by allies who deal damage up front; their weakness to being downed is covered by a
healer, or by the Angel they placed themselves.

---

## 13. Text

All player-facing text is English, in Larian's voice (`bg3-english-writing-style`), following the shared
formulas of `31.01_Lore_Bible.md` §5:

- **Class description:** "Mystra wove the Spinner from <…>, a thread that <…>." + one sentence of what
  they do.
- **Subclass panel:** "The Spinner <verb> the Weave …"
- **Tag line:** "We <archetype>, and the Weave <what it lets us do>."
- Spell, passive and status names: everything marked *(working name)* is decided in the text pass. Names
  stay inside the Spinner's vocabulary — fate, thread, spindle, wheel, the Moirai, the Rota, time. The
  name **Turn the Wheel** belongs to the Resonant and is never used here.

---

## 14. Technical pattern

Everything below is Stats, Osiris and Khonsu; nothing needs Script Extender.

### 14.1 Statuses

| Status family | Type and flags | Notes |
|---|---|---|
| **Fates** — one per card per spell level (`MISFORTUNE_<CARD>_<N>`, `FORTUNE_<CREATURE>_<N>`) | The vanilla type that fits each effect; `TickingWithSource`; `TickType "StartTurn"`; `StackType "Additive"`; one `StackId` per card | Duration = countdown. Bleed in `TickFunctors`. Resolution in `OnRemoveFunctors` with `IF(RemoveCause(StatusRemoveCause.TimeOut)):…`, so a cleanse does nothing |
| **Wheel** — 10, one per Present element (`WHEEL_<ELEMENT>`) | Permanent (`-1`) on the Spinner, visible | Its name is the Present; its tooltip lists the window. Its boosts lock the seven elements outside the window (an unpayable cost through `UnlockSpellVariant`, as the deck's lock does) |
| **Advance trigger** (`FATE_ADVANCE_TECH`) | Duration 0, hidden | Applied by Needle, Spark, Rota Fortunae, Foreseen… Osiris does the rest |
| **Frozen** (`FATE_FROZEN`) | 2 turns, visible | Osiris skips frozen fates; their countdown is held |
| **Recurrence marker** (`FATE_RETURNED_TECH`) | Hidden | A fate that has already returned never returns again |
| **Ritual stillness** | Until end of turn, on the Spinner | `ActionResourceBlock(Movement)` |
| **Awakening** | `ASPECT_AWAKENED_SPINNER`, `_I/_II/_III` | Same pattern as every subclass (`02-systems.md` §10) |

**Past and Future** need no status of their own: each spell checks the wheel status of the Present.
*Fire* is in the Past when the Present is Lightning, in the Present when it is Fire, in the Future when it
is Radiant — so the spell reads `IF(HasStatus('WHEEL_LIGHTNING',context.Source)):ApplyStatus(…,N-1)`,
and so on. Elemental spells carry a marker in `TargetConditions` (`ARCANA_SPOKE_<ELEMENT>`) so the lock
can find them.

**Costs:** Slow = `ActionPoint:1;ReactionActionPoint:1`; Ritual = `ActionPoint:1` plus the stillness
status; Burst = `BonusActionPoint:1` (or none).

### 14.2 Osiris

- **Ledger:** a database of every live fate — Spinner, creature, status, order spun — kept in step with
  `StatusApplied` and `StatusRemoved`.
- **Advance:** on `FATE_ADVANCE_TECH`, read each fate on that creature with `GetStatusTurns`, remove it,
  and reapply it with N − 1 **with the Spinner as `_Source`** (`ApplyStatus(_Object, _Status, _Duration,
  _Force, _Source)`), so `TickingWithSource` keeps counting on the Spinner's turn. At 0, the script
  fires the resolution itself (a removal by script isn't a `TimeOut`).
- **Chains:** the wave queue of §4.6 — collect, resolve oldest first, remove before effect, Cascade,
  next wave. The chain count drives Spindle of Necessity and Critical Mass.
- **Cascade range:** 9 m from the fate that resolved (distance check); unlimited after Critical Mass
  (level 9) or always (level 12).
- **Transfer:** on the death of a creature in the ledger, move each Misfortune to the nearest enemy
  within 9 m.
- **Recurrence:** after a chain ends, reapply each resolved fate once (marker).
- **Wheel of elements:** a database holds each Spinner's position. On the Spinner's turn start, step it
  and swap the wheel status. It persists across combats; it starts at Lightning the first time. The
  utility steps it outside combat.
- **Combat end:** `CombatEnded` removes every fate without resolution.
- **Awakening:** each resolution feeds `PROC_ARCANA_Aspect_Progress` (goal table in
  `ARCANA_Aspect_Common.txt`).

### 14.3 Generation

Fates, their spell-level versions, the elemental spells and their upcast variants come from a generator
(`82_Automation/stats/gen_spinner.pl`, *to write*) driven by one table: element, speed, length, bleed,
waiting effect, resolution, damage per level. Change the table, never the generated patches. The
upcast generator (`gen_upcast_variants.pl`) runs after it, as for every card.

---

## 15. Open

| Item | Decided in |
|---|---|
| Every damage, healing and temporary-HP value; Spindle's bonus; Déjà Vu's cap; the Necrotic execution threshold; Shears' damage; Crown strike's damage | Balance pass |
| Awakening goals (3 / 6 / 10 now, expected to rise) | Balance pass |
| Card levels (Thread price) | Balance pass |
| Duration of The Wheel Stops | Balance pass |
| Whether Rota Fortunae deals Bludgeoning damage of its own | Balance pass |
| Whether the Rituals are Unique | Balance pass |
| Every *(working name)*; the Mystra sentence; class description, panel line, tag line | Text pass |
| Emoji and Aspect VFX | Author |
| Starting gear | Author, in the Toolkit |

## 16. To test in game

| Test | What proves it |
|---|---|
| `TickingWithSource` + `StartTurn` on an enemy | The countdown drops at the Spinner's turn start, not the enemy's |
| Reapply by Osiris with `_Source` | After an advance, the fate still counts on the Spinner's turn |
| `Additive` with the same card | 1 turn left + a new 2 = 3 |
| `TimeOut` vs script removal | A cleanse doesn't resolve; an advance to 0 resolves through the script |
| The Spinner downed | Fates don't count down while they are down |
| The lock on console | Off-window elemental spells are greyed out without Lua |
| `ActionPoint:1;ReactionActionPoint:1` | A Slow spell spends both |
| The Wheel Stops | Every other creature skips its turns, allies included |
| Fight length | How many fates resolve in a short fight and in a long one (the pacing risk) |
