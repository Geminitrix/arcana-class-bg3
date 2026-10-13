# The Kingmaker — X · Wheel of Fortune · Aspect of Anticipation

> Design document for the Arcana's subclass **The Kingmaker**. It describes everything the subclass is and
> does: identity, the Wheel and every one of its rules, the Crossing, the Court, every spell and passive,
> the Aspect Awakening, the progression, the edge cases and the technical pattern that builds it.
>
> Designed 2026-10-13 through the process in `21.04_Subclasses/_SUBCLASS_STANDARD.md` (ticket ARC-0008;
> decisions SP47–SP103 in `55_Implementation_Specs/_wip/Kingmaker/decisions.md`). It replaces the Spinner
> design of 2026-10-08 (archived in `90_ARCHIVE/93_Old_Versions/2026-10-13_ARC-0008_spinner_design/`). Every
> gameplay effect lives in Stats, Osiris and Khonsu, so the subclass runs in **both editions** (PC with the
> deck, console without Script Extender).
>
> **Numbers live in `25_Master_Data`** (ADR-0005), arithmetic in `22.05/2026-10-13_ARC-0008_Kingmaker_Balance.md`. Where a value is needed
> this spec says *(25)* and the file that will hold it is named in §13. Positions, durations in turns,
> ranges in metres and level placement are design and are final unless a test proves them wrong.

---

## 1. The subclass in one page

The Kingmaker is the Arcana who **decides who reigns**. They put creatures **on the Wheel** — the Wheel of
Fortune of the card, with its four positions: **Rising**, **Reigning**, **Falling**, **Fallen**. At the
start of every one of the Kingmaker's turns the Wheel turns and every creature on it moves one position
on. Allies and enemies ride the same Wheel: an ally at the top is strong, an enemy at the bottom is
exposed — and an ally who reigns **will** fall, an enemy left on the Wheel **will** reign.

The power comes from **opposition**. From level 3, when an enemy hits the bottom while an ally reigns
near it, the enemy suffers a **Crossing** — one rises as another falls. The player's puzzle is to keep the
party and the enemies in opposite phases, and to break the cycle when it turns against them: cut a
creature off the Wheel, swap two of them, or turn the whole Wheel upside down with **Peripeteia**, the
reversal of fortune.

Before the battle the Kingmaker **convenes a Court**: the allies receive offices — the King's Hand, the
Lord Commander, the Master of Coin and the others — each changing how that ally plays with the Wheel and
with the **King**, the ally who currently wears the crown.

**Fantasy:** *"I don't win fights. I decide who does."*
**Role:** force multiplier — the Kingmaker shines on the other characters' turns.

---

## 2. Identity

### 2.1 The card — X · Wheel of Fortune

The card is the medieval **Rota Fortunae**: the wheel the goddess Fortuna turns, with a figure at each of
its four points and an inscription for each — *Regnabo* (I shall reign), *Regno* (I reign), *Regnavi* (I
have reigned), *Sum sine regno* (I am without reign). Kings rise on it, reign at its top, fall, and lie at
its bottom until it turns again; no one on the wheel controls it. The Kingmaker reads the card **literally**:
the four inscriptions are the four positions, and "one rises as another falls" is the Crossing.

| Reading of the card | Where it lives in the Kingmaker |
|---|---|
| The four inscriptions | The four positions (§4.2), Latin on every tooltip |
| The wheel always turns | The Wheel turns at every one of the Kingmaker's turns and never releases a creature on its own (§4.1) |
| One rises as another falls | The Crossing (§5) |
| Whoever reigns will fall | Allies fall after they reign (until Tier III); enemies left on the Wheel reign again |
| The turning point | Peripeteia, the ultimate (§7.6) |

### 2.2 The Aspect — Anticipation

Every Arcana Aspect is an emotion. **Anticipation** is the Kingmaker's: every position says what comes
next, and between two of the Kingmaker's turns nothing changes. The player knows that the fighter will
reign next turn and the ogre will hit the bottom, and plans the whole party's round around it. The
Resonant also casts a Weave Surge called Anticipation (Plutchik's emotion); the overlap is deliberate —
the feeling the Resonant surges for one turn is the one the Kingmaker lives in.

### 2.3 Mystra and the Weave

*"Mystra wove the Kingmaker from the crowns that rise and fall on Fortune's wheel, a thread that decides
who reigns."* The creatures on the Wheel are threads of the Weave run through the Kingmaker's hands: they
crown one, cast down another, cut a thread off the Wheel.

### 2.4 References

| Source | Kind | What it lends |
|---|---|---|
| The **Rota Fortunae** and its four inscriptions | Card | The positions and the Crossing |
| **Fortuna / Tyche** | Myth | The Wheel that turns; Tier I *Tyche* |
| **Nemesis** | Myth | Tier II *Nemesis*, who punishes hubris |
| **Atropos**, the Fate who cuts | Myth | *Atropos' Cut* |
| **Ixion**, bound to a burning wheel | Myth | *Wheel of Ixion* |
| **Boethius**, *The Consolation of Philosophy* ("it is my nature to turn") | Philosophy | The core rule: the Wheel always turns |
| **Aristotle's *peripeteia*** — the reversal of fortune in tragedy | Philosophy | The ultimate *Peripeteia* |
| ***"Le roi est mort, vive le roi"*** — the French royal proclamation (1422) | History | *Succession* |
| **Phase in a cycle** — oscillators in anti-phase are at opposite extremes at the same moment | Science | Opposition and the four-step cycle: the puzzle is keeping the party and the enemies in anti-phase |
| ***A Song of Ice and Fire* / *Game of Thrones*** — the Small Council | Fiction | The Court and its offices |
| **DIO** (*JoJo*), **Faceless Void** (Dota 2), **Bard** (League of Legends) | Fiction | *The Wheel Stops*: time stopped for everyone, allies included |

### 2.5 Identity Sheet

| Field | Answer |
|---|---|
| **Card and why** | X · Wheel of Fortune — its four inscriptions become the four positions (§2.1) |
| **Aspect and why** | Anticipation — the next position is always known (§2.2) |
| **Mystra and the Weave** | §2.3 |
| **Myth** | Fortuna/Tyche, Nemesis, Atropos, Ixion |
| **Science** | Phase in a cycle (oscillators in anti-phase) |
| **Fiction and powers** | The Small Council → the Court · DIO, Faceless Void, Bard → The Wheel Stops |
| **Archetype** | The kingmaker — the one who crowns and uncrowns |
| **Fantasy line** | *"I don't win fights. I decide who does."* (a possible mod-page tagline: *"Fortune is blind. I am not."*) |
| **Axis** | **Balance** — *who rises, who falls, and when do they cross?* |
| **Role** | Force multiplier: Advantage, crits and Disadvantage spread over the party and the enemies |
| **Specialist or versatile** | **Specialist** in party amplification; solo damage stays low on purpose |
| **Play style** | Put allies and enemies on the Wheel in opposite phases so they cross at the right moment; break the cycle when it turns against the party |
| **Combat style** | Mid range (18 m), within 9 m of the party for the Crossings; medium armour. Turn 1: Coronation on an ally, Dethrone on an enemy. Turn 2: the first Crossing; the party plays its big turn |
| **Strengths** | (1) Makes the party stronger on each one's own turn · (2) turns a fight in one turn (Peripeteia, Rota Fortunae) · (3) the whole round is played in a known state |
| **Weaknesses** | (1) Depends on the party and on position · (2) the Wheel is relentless: enemies left on it reign again, and with few enemies Crossings come slowly · (3) allies who reign will fall (until Tier III) |
| **Colour** | Teal `#60d7d2` (the emblem); a crown on the emblem is left to the Owner and the Icon Artist |
| **Emoji / Aspect VFX** | To choose (§14) |

---

## 3. Chassis

| Field | Value |
|---|---|
| Spellcasting ability | **Intelligence** (the whole class) |
| Secondary ability | **Charisma** — sovereignty and courts; it sets how many offices the Court holds (§6.1) |
| Saving throws | Charisma, Wisdom |
| Armour | Light, Medium — the Kingmaker stands within 9 m of the party |
| Weapons | Simple weapons, Rapiers, Hand Crossbows |
| Skills (choose 4, then 2 Expertise) | Skill list ***The Courtier***: Persuasion, Intimidation, Insight, History, Deception, Performance, Arcana, Religion |
| Ability preset | STR 8 · DEX 12 · CON 13 · INT 15 · WIS 8 · CHA 15 (27 points) |
| Starting gear | Court clothes, Rapier, Hand Crossbow (built in the Toolkit) |
| Sound set | Sorcerer (used by no other subclass) |

> The game holds a **placeholder** progression named *Spinner* (`a688d11f-edff-44c5-95ac-0e4999ebf876`)
> whose level 1 copies the Resonant's. The build replaces it with this chassis and §10, and renames
> ClassDescription, progression and texts to the Kingmaker.

---

## 4. The Wheel

### 4.1 The core rule — *The Rota* (level 1)

> **A creature on the Wheel moves one position on at the start of your turn — Rising, Reigning, Falling,
> Fallen, and round again.**

- **On the Wheel** is a position in the cycle, never a physical condition: a creature is on the Wheel
  while it carries one of the four position statuses.
- **Once on the Wheel, a creature stays on it** and cycles through all four positions — allies included,
  who fall after they reign. It leaves only through **Atropos' Cut** (§7.5), its death, or the end of
  combat. The Wheel never releases anyone on its own.
- **Forward only.** The Wheel and *Turn the Spoke* move creatures forward. Only **Peripeteia** sends them
  to the opposite position, and only **The Wheel Stops** holds them in place.
- **One table for both sides.** The same four positions apply to allies and enemies: the player learns four
  states, not eight.

### 4.2 The four positions

| Position | Inscription (tooltip) | Effect on whoever carries it |
|---|---|---|
| **Rising** | *Regnabo* — "I shall reign" | Increased movement speed (25); can't be knocked Prone |
| **Reigning** | *Regno* — "I reign" | Critical hits on 19–20; Advantage on saving throws |
| **Falling** | *Regnavi* — "I have reigned" | Reduced movement speed (25); −1d4 to attack rolls |
| **Fallen** | *Sum sine regno* — "I am without reign" | Attack rolls against it have Advantage; it can't take reactions |

The two peaks pay in different currencies — the Reigning ally crits more and resists, the Fallen enemy is
easier to hit and can't react — so a Crossing pair multiplies instead of stacking two sources of Advantage.

### 4.3 The King and the Regents

- The ally **Reigning** carries a visible **King** status: a crown on the portrait, named in the combat log.
  It moves with the Reigning position.
- **One King at a time.** When several allies are Reigning, one is the King and the others are **Regent**
  (same Reigning effects, no crown). Offices that read "the King" ignore Regents.
- **Who wears the crown:** among the allies Reigning, the one that has been on the Wheel the longest. The
  crown stays with it while it Reigns, then passes to the next Regent in the same order.
- **A summon is never King**, only Regent: it still enables Crossings, but the crown — and the offices
  that read it — always belong to a party member.
- **The King's Hand** (§6.2) wears the crown while no ally is Reigning.

### 4.4 Entering the Wheel

| Way in | Who | Position (Tier I *Tyche*: one ahead) |
|---|---|---|
| *Coronation* (§7.2) | An ally or the Kingmaker | Rising (**Reigning**) |
| *Dethrone* (§7.3) | An enemy | Falling (**Fallen**) |
| *Wheel of Ixion* (§7.8) | Every enemy in the line | Falling (**Fallen**) |
| *Succession* (§8.4) | The nearest enemy off the Wheel | The dead enemy's position |

Coronation at Rising and Dethrone at Falling put the two creatures in **anti-phase**: at the next turn of
the Wheel the ally reigns while the enemy hits the bottom.

### 4.5 The start of the Kingmaker's turn

1. Every creature on the Wheel moves one position on, **all at once**.
2. Every enemy that **entered Fallen** is checked for a Crossing (§5).
3. The Crossings resolve **oldest on the Wheel first**.

Nothing changes between two of the Kingmaker's turns, except what the Kingmaker's own cards, the Court and
Ready: Foreseen do. The whole round is played in a known state.

### 4.6 Edge cases

| Case | Rule |
|---|---|
| **Combat ends** | Everyone leaves the Wheel |
| **The Kingmaker is downed** | The Wheel keeps turning: a downed character still has turns (death saving throws), so positions move and Crossings pay. Fortuna is blind; the Wheel needs no hand |
| **The Kingmaker dies** | No turn, so the Wheel stops; positions stay until combat ends |
| **A creature on the Wheel dies** | It leaves the Wheel. An enemy's position may pass by *Succession* (level 9); an ally's never does (the crown follows §4.3) |
| **Summons and temporary allies** | Can be on the Wheel (summons count as allies, enemy summons as enemies); a creature unsummoned leaves the Wheel; a summon is never King |
| **Charm, domination, a change of faction** | **A creature's side is fixed when it enters the Wheel.** Whoever entered as an ally counts as an ally until it leaves, and the reverse. The party never takes its own Crossing; an enemy dominated by the Deceiver's Marionette can still be crossed |
| **Creatures that join mid-combat** | Start off the Wheel until bound |
| **Two Kingmakers in the party** | **One shared Wheel that turns once per round.** Its **owner** is the Kingmaker who acts first in initiative; every binding, by either Kingmaker, is registered to the owner and the Wheel turns at the start of the owner's turn only. If the owner dies or leaves combat, the next Kingmaker in initiative becomes the owner. One King for the whole Wheel; each Kingmaker keeps their own Court; every Crossing counts for every Kingmaker's Awakening |

---

## 5. The Crossing (level 3)

> **When an enemy on the Wheel enters Fallen while an ally on the Wheel within 9 m is Reigning, the enemy
> takes Force damage** (`FEAT_Kingmaker_Crossing`).

- **Any cause** counts: the turn of the Wheel, *Turn the Spoke*, *Dethrone* under Tyche, *Peripeteia*,
  *Usurp*, *Succession*, Ready: Foreseen.
- **Once per enemy per round**, however many allies Reign near it.
- The **Master of Ships** extends the source (§6.2); **The Wheel Stops** presses every turn (§7.10).
- **Range by level:** 9 m from level 3; **the whole field** at level 12.
- **Hubris** (level 7, §8.3) amplifies the Crossing of an enemy that has reigned.
- A Crossing **moves nothing** by itself; only Tier II *Nemesis* moves creatures after a Crossing, and only
  those already Falling (§9.3), so every chain ends.

**Worked example (level 3).** Turn 1: *Coronation* on the fighter (Rising) as a Bonus Action and *Dethrone* on the ogre
(Falling, with damage). The Kingmaker's turn 2 starts: the fighter becomes **Reigning** (King), the ogre
**Fallen** → the ogre takes its Crossing. For the whole round the fighter crits on 19–20 and everyone
attacks the ogre with Advantage while it can't react. Turn 3 will make the fighter Fall and the ogre Rise:
the Kingmaker kills it first, cuts it off the Wheel, or saves *Usurp* for the moment the ogre reigns.

---

## 6. The Court

### 6.1 Convening the Court

***Convene the Court*** (utility, level 5) names the Court **before the battle**:
- **Outside combat only**; no combat action, no Woven Spell Slot.
- The Court holds as many offices at once as the Kingmaker's **Charisma modifier** (minimum 1). Each office
  slot is filled **once per Long Rest**; offices last **until the next Long Rest**, in every fight.
- Each ally holds **at most one** office. **The Kingmaker never holds an office** — they name the Court,
  they never serve on it. In a small party a slot may stay empty.
- An office whose holder **dies** stays vacant until the next Long Rest.
- The choice of offices grows with level: three at level 5, two more at 7, two more at 9.

### 6.2 The seven offices

| Level | Office | Effect on the holder |
|---|---|---|
| 5 | **King's Hand** | While no ally is Reigning, the Hand wears the crown: it is the King and crits on 19–20 |
| 5 | **Lord Commander** | Within 3 m of the King, attack rolls against the King have Disadvantage |
| 5 | **Master of Healing** | Healing an ally on the Wheel moves it one position on **only when that step brings it toward Reigning** (Fallen → Rising, Rising → Reigning); at Reigning or Falling nothing happens |
| 7 | **Master of Laws** | An enemy that attacks the King falls one step further at the next turn of the Wheel — **never past Fallen and never up to Reigning**: from Rising it skips its reign and lands on Falling; from Reigning it drops to Fallen (and may cross); from Falling or Fallen it takes the normal step only |
| 7 | **Master of Secrets** | Enemies on the Wheel within 9 m can't be invisible or hidden; the holder has Advantage against Falling enemies |
| 9 | **Master of Coin** | **Once per Long Rest**, when it hits a Fallen enemy, the Kingmaker regains a Woven Spell Slot (PC: a Thread) |
| 9 | **Master of Ships** | A Crossing also pays when the Fallen enemy is within 9 m of the Master of Ships, not only of a Reigning ally |

Offices show as a status on the holder, named after the office.

---

## 7. Spells

Eleven combat actions by level 12, one utility.

### 7.1 *Spoke of the Wheel* — cantrip (level 1)

Ranged spell attack, 18 m, **Bludgeoning** *(25)*. **One extra damage die against an enemy on the Wheel
that is Falling or Fallen** — the fallback turn reads the Wheel and rewards picking the right target. It
binds no one.

### 7.2 *Coronation* (level 1)

**Bonus Action**, level-1 card. An ally or the Kingmaker within 18 m enters the Wheel at **Rising** (Reigning with Tyche).
Self-coronation costs what the Wheel costs: the Kingmaker will fall too, and while Fallen loses its
reactions — Ready: Foreseen included.

### 7.3 *Dethrone* (level 1)

**Action**, one enemy within 18 m: **Bludgeoning** damage *(25)*, **Charisma saving throw for half**; the
enemy enters the Wheel at **Falling** (Fallen with Tyche) **whatever the save** — the Wheel never depends
on a die.

### 7.4 *Turn the Spoke* (level 1)

**Bonus Action, no slot** (PC: 1 Thread, the level-0 card rule). One creature on the Wheel within 18 m moves **one position on** — forward only. It
hastens a Crossing (a Falling enemy drops to Fallen), brings an ally up to Reigning a turn early, or moves
an enemy out of Reigning. The early bonus-action play (K6).

### 7.5 *Atropos' Cut* (level 3)

**Action** *(cost: 25)*. Removes one creature from the Wheel — *the thread falls where it is*:
- **Enemy:** takes damage that grows the lower it is — highest at Fallen, lowest at Reigning *(25)*.
- **Ally:** leaves the Wheel; if it was Reigning it keeps the Reigning effects until the end of its next turn
  (it leaves on top).

### 7.6 *Peripeteia* — the ultimate (level 5)

**Action, level-3 card (Woven Spell Slot / 3 Threads), once per combat.** Every creature on the Wheel within 18 m — allies included — moves to the
**opposite** position (Reigning ↔ Fallen, Rising ↔ Falling). Every enemy that enters Fallen next to a
Reigning ally pays its Crossing at once. The turning point: best when the Wheel is against the party,
costly otherwise. It uses positions, opposition and Crossings at once (K3).

### 7.7 *Usurp* (level 7)

**Action, once per combat.** One ally and one enemy, both on the Wheel within 18 m, **swap positions** —
one takes the other's throne.

### 7.8 *Wheel of Ixion* (level 9)

**Action.** Ixion's burning wheel rolls: a **line 18 m long and 2 m wide**, **Fire** damage *(25)*,
Charisma saving throw for half; every **enemy** hit enters the Wheel at **Falling** (Fallen with Tyche)
whatever the save. The line leaves a **burning trail** (fire surface) that burns whoever stands in it,
allies included — aim it away from the party.

### 7.9 *Ready: Foreseen* (Tier III)

**Reaction, once per round.** When an enemy on the Wheel is about to attack you or an ally: if it is
**Reigning** or **Falling**, it moves one position on **before** the attack — Reigning → Falling (loses the
19–20 crit, takes −1d4), Falling → Fallen (Advantage against it, and a Crossing if a Reigning ally is within
9 m). Rising or Fallen: nothing happens, so it never crowns the attacker. A Reigning enemy dropped this way
keeps its *Hubris*. On console the card is cast and readies the reaction until combat ends; on PC holding it
in hand is the charge (`02-systems` §8).

### 7.10 *The Wheel Stops* — capstone (level 11)

**Action, Long Rest, Unique.** Every position on the Wheel is **frozen** for a few turns *(25)*: the Wheel
doesn't turn. While it is stopped, at the start of each of the Kingmaker's turns, every Fallen enemy within
9 m of a Reigning ally takes Crossing damage — the stopped Wheel keeps pressing (an explicit exception to
"enters Fallen"). It is the only way to hold positions.

### 7.11 *Rota Fortunae* — the Aspect card (Tier I)

Created, 0 Threads, 0 slots, **Action, once per combat.** **The Wheel turns once more, now**: every creature
on the Wheel moves one position on and the Crossings pay — a second payoff in the same round. Allies move
too, so the timing is the player's decision. It **advances** the clock; Peripeteia **inverts** it (A3).

### 7.12 *Convene the Court* — utility (level 5)

§6.1.

---

## 8. Passives

### 8.1 *The Rota* (level 1)
The core rule (§4.1), the four positions (§4.2) and the King (§4.3), explained once.

### 8.2 *The Crossing* (level 3)
§5, at 9 m.

### 8.3 *Hubris* (level 7) — *the higher they climb, the harder they fall*
When an enemy on the Wheel enters **Reigning**, it gains the status *Hubris*; the **next Crossing** it
suffers is amplified *(25)* and consumes the status. Every enemy reigns once per cycle, so it pays every
cycle; an enemy dropped straight from Reigning to Fallen (Peripeteia, Usurp) still carries *Hubris* and pays
at once.

### 8.4 *Succession* (level 9) — *le roi est mort, vive le roi*
When an enemy on the Wheel dies, its position passes to the **nearest enemy not on the Wheel within 9 m of
the body**; enemies already on the Wheel are skipped, and with no such enemy the position is lost. An heir
that enters Reigning gains *Hubris*. Several deaths at once resolve oldest on the Wheel first.

### 8.5 The Crossing across the field (level 12)
The Crossing loses its 9 m limit (§5).

---

## 9. Aspect Awakening — 10 · Wheel of Fortune

### 9.1 The goal — Crossings

**Each time an enemy takes Crossing damage, count 1** — at most once per enemy per round. The Master of
Ships' Crossings and the stopped Wheel's pressing count too. The goal shows as the ARC-0007 countdown
(COUNT type) on the *Awakening* status. Goals **3 / 5 / 8** (`FEAT_Kingmaker_AspectAwakening`). **A lone enemy:** while only one enemy is on the Wheel, each Crossing counts **2**.

| Tier | Level | Name | Source |
|---|---|---|---|
| I | 3 | **Tyche** | Fortune who gives |
| II | 7 | **Nemesis** | the goddess who restores the balance and punishes hubris |
| III | 12 | **Aspect of Anticipation** | — |

### 9.2 Tier I — Tyche: the Wheel turns faster for those you touch

Your bindings enter **one position ahead**: Coronation binds an ally at **Reigning**; Dethrone and Wheel of
Ixion bind enemies at **Fallen**. The phase stays aligned, and a Dethrone next to a Reigning ally crosses at
once. Still one Crossing per enemy per round. Tier I also creates the Aspect card *Rota Fortunae* (§7.11).

### 9.3 Tier II — Nemesis: the fall drags its neighbours

When an enemy carrying *Hubris* takes its Crossing, every enemy on the Wheel **within 3 m of it that is
Falling drops to Fallen**; those cross too if a Reigning ally is within 9 m. Only Falling enemies move, and
each enemy crosses once per round, so the chain ends.

### 9.4 Tier III — Aspect of Anticipation: no ally touches the bottom

An ally on the Wheel **never enters Fallen**: it stays **Falling for two turns** instead (Rising → Reigning →
Falling → Falling → Rising). The cycle keeps four steps, so allies and enemies stay in phase. Tier III also
grants ***Ready: Foreseen*** (§7.9). No ability score bonus.

---

## 10. Progression

| Level | Rules (passives) | Spells |
|---|---|---|
| **1** | **The Rota** | Cantrip *Spoke of the Wheel* · *Coronation* · *Dethrone* · *Turn the Spoke* (Bonus Action) |
| 2 | — (base class) | — |
| **3** | **The Crossing** (9 m) · **10 - Wheel of Fortune: Awakening** · Tier I **Tyche** → *Rota Fortunae* | *Atropos' Cut* |
| 4 | — | — |
| **5** | — | ***Peripeteia*** (ultimate) · utility *Convene the Court* (King's Hand, Lord Commander, Master of Healing) |
| 6 | — | — |
| **7** | **Hubris** · Tier II **Nemesis** | *Usurp* · Court: + Master of Laws, Master of Secrets |
| 8 | — | — |
| **9** | **Succession** | *Wheel of Ixion* · Court: + Master of Coin, Master of Ships |
| 10 | — | — |
| **11** | — | ***The Wheel Stops*** (capstone) |
| **12** | **The Crossing across the field** · Tier III **Aspect of Anticipation** → *Ready: Foreseen* | — |
| 13–20 | Reserved, like the rest of the class | |

**The journey:** learn the Wheel (1–3), then govern (5+). Level 1 already plays it — bind both sides, nudge
the Spoke, fall back on the cantrip. Level 3 brings the payoff (Crossing) and the way out (Cut). Level 5 the
turning point and the Court. Level 7 punishes the enemies that reigned and swaps a throne. Level 9 spreads
the Wheel (Succession, Ixion). Level 11 stops it.

---

## 11. How it plays

### 11.1 A turn

1. **Read the turn start:** who moved where, who crossed.
2. **Set the phases:** bind an ally and an enemy in anti-phase, or nudge one creature a step on.
3. **Break a bad cycle:** cut an enemy about to reign, swap a throne, or — once — reverse the whole Wheel.
4. **Fall back:** the cantrip on a Falling or Fallen enemy.

### 11.2 A fight

- **Turn 1:** Dethrone (Action) and Coronation (Bonus Action) — or Turn the Spoke on an enemy already Falling.
- **Turn 2:** the first Crossing; the King plays its big turn; everyone hits the Fallen enemy.
- **Turns 3–4:** the cycle turns against the party — Cut, Usurp or Peripeteia; Rota Fortunae for a second
  payoff in the round when the phases are right.
- **Long fights:** enemies left on the Wheel come back to reign; *Hubris* makes them pay when they fall; at
  level 11 The Wheel Stops freezes a won position and keeps pressing.

### 11.3 Party

The Kingmaker is strongest with allies who hit often (a crit range of 19–20 rewards many attacks) and who
stand near the enemies (the 9 m of the Crossing). Alone or with a scattered party it does little; with few
enemies, Crossings come slowly. The Court is named for the party it has: the Lord Commander for a melee
King, the Master of Secrets for a rogue, the Master of Coin for long days.

---

## 12. Text

English, Larian voice (`31.03`), following the formulas of `31.01` §5. Narrative gate: `32.04`.

- **Class description:** *"Mystra wove the Kingmaker from the crowns that rise and fall on Fortune's wheel, a
  thread that decides who reigns."* + one sentence of what they do *(text pass)*.
- **Names:** cantrip *Spoke of the Wheel*; *Coronation*, *Dethrone*, *Turn the Spoke*, *Atropos' Cut*,
  *Peripeteia*, *Usurp*, *Wheel of Ixion*, *The Wheel Stops*, *Rota Fortunae*, *Ready: Foreseen*,
  *Convene the Court*; passives *The Rota*, *The Crossing*, *Hubris*, *Succession*; statuses **Rising /
  Reigning / Falling / Fallen**, **King**, **Regent**, **Hubris**; offices **King's Hand, Lord Commander,
  Master of Healing, Master of Laws, Master of Secrets, Master of Coin, Master of Ships**.
- **Position tooltips** open with their Latin inscription and say the **next** position.
- Final polish after every subclass's rework (ARC-0006).

---

## 13. Technical pattern

Everything is Stats, Osiris and Khonsu; nothing needs Script Extender. Signatures from `story_header.div`.

### 13.1 Osiris drives the Wheel

- **Ledger** — one row per creature on the Wheel: owner, creature, position, **side fixed at entry**, entry
  order.
- **Turn** — on `TurnStarted(_Object)` (:1205) of the owner, swap every position for the next with
  `ApplyStatus(_Object, _Status, _Duration, _Force, _Source)` (:850), the owner as `_Source`; positions are
  permanent statuses, so nothing ticks on its own.
- **Crossing** — collect the enemies that entered Fallen; for each, look for a Reigning ally within 9 m with
  `GetDistanceTo` (:626); apply the Crossing damage through a `_TECH` status (`ApplyStatus(<X>_TECH,100,0)`
  pattern); once per enemy per round.
- **Cards** — Coronation, Dethrone, Ixion, Turn the Spoke, Usurp, Peripeteia, Rota Fortunae, Cut, The Wheel
  Stops and Foreseen apply a `_TECH` status that Osiris turns into the ledger change.
- **Deaths** — `Died` (:312) feeds Succession and removes the dead; **summons** — `IsSummon` (:911) bars the
  crown; **combat end** — `CombatEnded` (:1199) clears the ledger.
- **Awakening** — each Crossing feeds `PROC_ARCANA_Aspect_Progress` (ARC-0007, COUNT).

### 13.2 Position boosts — vanilla patterns

| Effect | Pattern | Vanilla uses |
|---|---|---|
| Reigning: crit 19–20 | `ReduceCriticalAttackThreshold(1)` | 11 |
| Reigning: Advantage on saves | `Advantage(AllSavingThrows)` | 16 |
| Falling: −1d4 to attacks | `RollBonus(Attack,-1d4)` | 3 |
| Rising / Falling: +3 m / −3 m movement | `ActionResource(Movement,3,0)` (Longstrider) / `ActionResource(Movement,-3,0)` (Ray of Frost) | vanilla statuses LONGSTRIDER, RAY_OF_FROST |
| Rising: can't be Prone | `StatusImmunity(PRONE)` | 5 |
| Fallen: attacks against it have Advantage | `Advantage(AttackTarget)` | 62 |
| Fallen: no reactions | `ActionResourceBlock(ReactionActionPoint)` | 52 |

### 13.3 Master data (25) — to be written in the balance pass

`FEAT_Kingmaker_TheRota` (movement values) · `FEAT_Kingmaker_Crossing` (damage per level) ·
`FEAT_Kingmaker_Hubris` · `FEAT_Kingmaker_AspectAwakening` (goals) · `SPL_Kingmaker_SpokeOfTheWheel` ·
`SPL_Kingmaker_Dethrone` · `SPL_Kingmaker_AtroposCut` · `SPL_Kingmaker_WheelOfIxion` (damage, surface) ·
`SPL_Kingmaker_TheWheelStops` (duration) · `FEAT_Kingmaker_Court` (offices) — the names follow
`25.00/master_data.schema.yaml`.

### 13.4 Ids

Final ids are fixed in `SPEC_ARC-0008` against `33.03` (glossary) and ADR-0002: cards
`<Type>_Arcana_Card_Spell_*`, the Aspect card `<Type>_Arcana_Created_RotaFortunae`, the reaction
`Interrupt_Arcana_Reaction_Foreseen`, the utility `<Type>_Arcana_Util_ConveneTheCourt` (a *Choose*
container), passives `Arcana_Passive_*`, statuses in `SCREAMING_SNAKE_CASE`, technical ones ending in `_TECH`.

---

## 14. Open

| Item | Decided in |
|---|---|
| Every value marked *(25)*: set in `25_Master_Data` from the approved balance pass (`22.05/2026-10-13_ARC-0008_Kingmaker_Balance.md`); playtest checks in its §8 | Playtest |
| Ranges of Dethrone, Usurp and Cut (18 m assumed) | Owner, with the balance pass |
| Emoji and Aspect VFX; a crown on the emblem | Owner, Icon Artist |
| Renames in the game files (ClassDescription, progression, ProgressionDescription, icons) from Spinner to Kingmaker | Build |
| The role sits close to the Resonant's (support through states); a future magical burst/DPR subclass fills the class's gap | Future ticket (Owner) |

## 15. To test in game

| Test | What proves it |
|---|---|
| `TurnStarted` on a downed Kingmaker | The Wheel still turns while the Kingmaker is downed |
| Position swap at the owner's turn start | The new position shows before the Kingmaker acts and keeps the Kingmaker as source |
| The Crossing's range | An enemy at 8 m from a Reigning ally crosses; at 10 m it doesn't; the damage is credited to the Kingmaker |
| The seven position boosts | Each effect on an ally and on an enemy (§13.2) |
| The King and the Regents | Two allies Reigning: the older one wears the crown; a summon never does |
| Side fixed at entry | A dominated ally on the Wheel never takes a Crossing |
| Two Kingmakers | The Wheel turns once per round, on the first Kingmaker's turn |
| Each office | One probe per office, with its vanilla example (in `SPEC_ARC-0008`) |
| Wheel of Ixion | The line's size, enemies-only binding, the fire surface |
| Fight length | Crossings in a normal fight and in a lone-boss fight (the Awakening risk) |
