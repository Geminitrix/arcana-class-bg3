# The Spinner — three proposals (ARC-0008 brainstorm)

> Working note for the raise of **X · Wheel of Fortune · Aspect of Anticipation**. Three alternative
> designs, each built against `21.04/_SUBCLASS_STANDARD.md` (§1.2 ladder, §2 Identity Sheet, §3 questions,
> §7 pool, §9 Awakening, §11 feasibility). **No proposal is approved.** They exist so the Owner can choose a
> direction (or mix parts) before the raising spec is written.
>
> **No numbers here** (standard §1.2, ADR-0005). Where a value is needed the text names the master-data
> entry to create (`FEAT_Spinner_*`, `SPL_Spinner_*`, `STA_Spinner_*`). Durations in turns and ranges in
> metres are design.
>
> Every technical claim either reuses a pattern from standard §11 / decisions SP5, SP6, SP10 (found in
> vanilla during the 2026-10-08 design) or is marked **T2** (to probe before building).

---

## 0. The starting point

### 0.1 What the 2026-10-08 design gets right (keep in every proposal)

- **The card is read for mechanics, not decoration**: the Rota's four Latin positions, the four winged
  creatures, the sphinx, Typhon descending, Hermanubis rising.
- **Anticipation is played, not stated** (I4 ✅): the player reads visible numbers and plans two turns
  ahead — exactly what BG3's turn-based determinism rewards (§4.6).
- **Myth with rules attached**: Clotho / Lachesis / Atropos, Ananke's spindle, Fortuna.
- **A real model that structures content**: the nuclear chain reaction (sub/critical/supercritical).
- **Stats + Osiris only**, with proven patterns (TickingWithSource, Additive, GetStatusTurns, reapply
  with `_Source`).

### 0.2 What the audit (handoff ARC-0008, 2026-10-13) says must change

| Gap | Why it matters | What every proposal must answer |
|---|---|---|
| **K3 ❌** no ultimate | No single piece makes the gears turn together | A named ultimate, distinct from the Aspect card (A3) |
| **Complexity** ~25 combat actions, two core systems at level 1 (M2, P7) | Standard §15 suggests ~3 new actions; a new player can't hold 25 | A pool derived from **verbs** (§7.1), one core rule at level 1 |
| **P5 ⚠️** waits up to 6 turns vs fights of 3–5 rounds | Payoff after the fight is decided is no payoff | Value on turn 1, payoff by round 3 |
| **P7 ⚠️** Cascade range invisible | The player can't plan what they can't see | State on icons, with numbers |
| **PC deck** 7 of 10 elements locked each turn | Locked cards are dead cards in hand (§5) | No hand-clogging lock |
| **I6 ⚠️** "Spark" next to Starchild's *Final Spark* | Vocabulary bleed | Names from the card, its myth or its science |
| **SP44 Alignment** resolves Rituals in the window | Reopens the problem SP38 closed (a 6-turn wait skipped) | Any "resolve now" respects a cap |

### 0.3 The roster it must stand beside

| Subclass | Axis (as the matrix and specs suggest) | What the Spinner must not repeat |
|---|---|---|
| Unbound (0, Curiosity) | Position / mobility | Movement tricks as the core |
| Deceiver (II) | Presence (Doubles) · mark → detonate (Sigils) | A mark the Spinner detonates by hand |
| Starchild (XVII, Hope) | Healing support | Healing as the main payoff |
| Eternal (XIII, Sorrow) | Resource conversion (HP) | Self-damage as the resource |
| Resonant (XIV, Empathy) | Combination (emotions by distance on a wheel) | A wheel of states read by **distance**; the word "Turn the Wheel" |
| Lionheart (VIII) | Being defined | — |
| Base class | Portent (replace a d20) | Dice replacement |

Three answers follow, each with a different **axis** (§2.3): **Timing**, **Balance (rise and fall)** and
**Risk**.

---

## 1. Proposal A — *The Measured Thread* (Timing, consolidated)

> The 2026-10-08 Spinner, cut down to one system. Fates count down and cascade; the wheel of elements
> stops being a lock. Honours SP1–SP43 except the elemental window (SP31–SP36, SP39) and replaces SP44–SP46.

### 1.1 Identity Sheet

| Field | Answer |
|---|---|
| Card and why | **Rota Fortunae**: the wheel turns and no one on it can stop it → fates turn on the Spinner's turn and, once spun, land. **Cycles** → Recurrence. **The turning point** → the Cascade |
| Aspect and why | **Anticipation**: every fate is a number the player watches fall; the skill is lining numbers up so they fall together |
| Mystra and the Weave | *Mystra wove the Spinner holding the spindle: they see how long each thread of the Weave runs, and choose the moment it is cut* |
| Myth | **The Moirai** (Clotho spins → Tier I; Lachesis measures → Tier II; Atropos cuts → the Shears) · **Ixion** bound to a burning wheel → *Doom of Ixion* · **Ananke's spindle** (Myth of Er) → Spindle of Necessity |
| Science | **Nuclear chain reaction**: *k* < 1 dies out, *k* = 1 sustains, *k* > 1 grows → Cascade, Critical Mass, and the ultimate *Synchrony* (bring the field to criticality on purpose) |
| Fiction / powers | **Zilean** (*Time Bomb* passing on death → Transfer) · **Ares' Doom** in *Hades* (a curse that lands after a delay → Misfortunes) · **Faceless Void / DIO** (time stopped, one person moves → The Wheel Stops) · ***Final Destination*** (a chain of "accidents" → Cascade) · ***Death Note*** (a death on schedule → *Final Measure*) |
| Archetype | **The clockmaker of fate** |
| Fantasy line | *"The fight ended two turns ago. Everyone else is just catching up."* |
| Role | Ranged magical damage — sustained while fates wait, burst when they fall together (SP8); secondary: timed support |
| Specialist / versatile | **Specialist**: delayed area damage |
| Play style | Plant fates, line their counts up, release them together |
| Combat style | Back line, 18 m, high initiative. Turn 1: a Fast fate + Needle. Turn 3: the chain |
| Strengths | Multi-target burst; damage that runs while the Spinner does other things; acting first |
| Weaknesses | Short fights; cleanses; frozen while downed; spread-out enemies |
| Chassis | INT / **DEX** (initiative, SP11); saves INT + DEX; light armour; Daggers, Darts, Hand and Light Crossbows; skill list *The Fortune-Teller*; preset as SP12; sound set Wizard |
| Colour | Teal `#60d7d2` (SP13); emoji and VFX open |

### 1.2 The mechanic

**Core rule (one passive, *Spun Fates*):** *Your fates count down at the start of your turn and land at 0;
from level 3, each fate that lands pushes your other fates one step closer.*

- **Misfortune** on an enemy, **Fortune** on an ally (SP2). Countdown = status duration (SP5).
- **One fate per card per creature; the same card again adds turns** (SP6).
- **Bleed or pull down** (SP9); **waves, oldest first, removed before effect** (SP18); edge cases as SP28.
- **The wheel of elements leaves.** Each card owns its damage type. The Rota stays as the **clock** — the
  one wheel that turns for the whole field on the Spinner's turn.
- **No Rituals.** The longest card waits 4 turns (fixes P5 and the SP38/SP44 hole by construction).
- **Readability (P7):** from level 3, a fate within Cascade range of another of your fates shows a
  **Linked** marker (aura status around each fate bearer — **T2**). The player sees the chain before
  pulling it.

**Worked example (level 5).** Turn 1: *Fraying* (2) on the ogre, *Ill Omen* (1) on a goblin, Needle on the
goblin → its Omen lands now and cascades: ogre 2 → 1. Turn 2 start: the ogre's Fraying lands. Turn 2: *Doom of
Ixion* (3) on the gnoll pack, *Synchrony* next turn will pull every fate down to the shortest count.

### 1.3 Pool (derived from verbs, §7.1)

Time axis: Fast (1) · Measured (2) · Slow (3–4). Verbs: **spin** (fate cards), **advance** (Needle),
**synchronise** (ultimate), **cut** (Shears), **stop** (capstone).

| Card | Lvl | Verb | Action | What it does |
|---|---|---|---|---|
| *Spoke of the Wheel* (cantrip) | 1 | — | Action | Ranged spell attack, Bludgeoning; the baseline turn |
| *Spindle Needle* | 1 | advance | **Bonus Action** | Piercing; every fate on one creature advances 1 (K6) |
| *Ill Omen* | 1 | spin | Action | Misfortune, Fast 1: Psychic; Disadvantage on its next attack |
| *Fraying* | 1 | spin | Action | Misfortune, Measured 2: Necrotic bleed + resolution |
| *The Bull* | 3 | spin | Action | Fortune, Fast 1: temporary HP, can't be moved or knocked Prone |
| ***Synchrony*** (ultimate) | 5 | synchronise | Action, once per combat, no slot | Choose one of your fates: every other fate of yours with a **higher** count is set to its count. Nothing lands now; next turn they land together |
| *Doom of Ixion* | 5 | spin | Action | Misfortune, Slow 3: Fire burst in 3 m + Prone |
| *Atropos' Shears* | 7 | cut | Action | Every fate on one creature with 2 turns or fewer lands now (SP38) |
| *Final Measure* | 9 | spin | Action | Misfortune, Slow 4: heavy Force; below an HP threshold, the target dies |
| *The Angel* | 9 | spin | Action | Fortune, Slow 4: large heal; lifts a downed ally (SP40) |
| *The Wheel Stops* (capstone) | 11 | stop | Action, Long Rest, Unique | As SP17 |
| *Rota Fortunae* (Aspect card) | T I | advance all | Action, once per combat | Every fate advances 1 (SP16) |
| *Ready: Foreseen* | T III | advance | Reaction | As SP24 |

**13 combat actions** by level 12 (from ~25). Two of the four winged creatures stay; the Eagle and the
Lion return only if a playtest asks for more support (their effects are recorded in SP40).

**Why Synchrony is the ultimate (K3) and differs from the Aspect card (A3):** the whole kit is about making
fates land **together** (Cascade, Spindle of Necessity, Critical Mass); Synchrony is the one card that does
it on purpose, and it telegraphs a turn (counterplay, no skipped wait — the minimum count stays 1). *Rota
Fortunae* moves everything **now** by one; Synchrony **aligns** everything for **next** turn.

### 1.4 Progression

| Lvl | Rules | Cards |
|---|---|---|
| 1 | **Spun Fates** | Spoke · Needle · Ill Omen · Fraying |
| 3 | **Cascade** (9 m, Linked marker) · Tier I **Clotho** → *Rota Fortunae* | The Bull |
| 5 | **Transfer** (SP28) | **Synchrony** · Doom of Ixion |
| 7 | **Spindle of Necessity** · Tier II **Lachesis** | Atropos' Shears |
| 9 | **Critical Mass** (SP27) | Final Measure · The Angel |
| 11 | — | **The Wheel Stops** |
| 12 | **Cascade without limit** · Tier III **Aspect of Anticipation** (Recurrence + Ready: Foreseen) | — |

### 1.5 Aspect Awakening

Goal **fates landed** (SP15; values `FEAT_Spinner_AspectAwakening`). Tiers as SP21–SP23: **Clotho** (the
first fate each turn starts 1 closer) · **Lachesis** (a landing Misfortune gives temporary HP to allies
within 3 m) · **Aspect of Anticipation** (Recurrence once per fate, after the chain; Ready: Foreseen).

### 1.6 Self-audit (only what changes from the 2026-10-13 audit)

K3 ✅ Synchrony · A3 ✅ advance-now vs align-for-next · M2 ✅ one system · P7 ⚠️→✅ if the Linked marker
passes T2 · P5 ✅ longest wait 4, Fast cards at 1 · complexity 13 actions, one resource (fates) · I6 ✅
"Spark" gone · B ❌ still (balance pass).

**Cost:** lowest rework; keeps almost every recorded decision. **Risk:** loses the wheel of elements, the
most visual idea of the original; the subclass may read as "damage over time with extra steps" (K2 ⚠️) if
the Cascade isn't felt early.

---

## 2. Proposal B — *Rise and Fall* (Balance)

> The card's own words become the mechanic. Every creature the Spinner binds rides the Rota through its
> four Latin positions; the party's power comes from **opposition** — allies at the top while enemies are
> at the bottom.

### 2.1 Identity Sheet

| Field | Answer |
|---|---|
| Card and why | The **Rota Fortunae** with its four inscriptions: *Regnabo* (I shall reign), *Regno* (I reign), *Regnavi* (I have reigned), *Sum sine regno* (I am without reign). They become the four positions of the mechanic — the card, read literally |
| Aspect and why | **Anticipation**: every position shows what comes next; the player knows the fighter will reign next turn and the ogre will hit the bottom, and plans the party's turns around it |
| Mystra and the Weave | *Mystra wove the Spinner into the hub of the wheel: every thread of the Weave runs through their hands, and they choose who rises on it and who falls* |
| Myth | **Fortuna / Tyche** turning the wheel · **Nemesis**, who restores the balance of fortune → *Exchange* · **Ixion** on his wheel → *Bind to the Wheel* · **Aristotle's *peripeteia*** (the reversal of fortune in Greek tragedy) → the ultimate · **Boethius**, *Consolation of Philosophy* ("it is my nature to turn") → the core rule |
| Science | **Phase in a cycle (oscillators in anti-phase):** two waves half a cycle apart are at opposite extremes. Four positions = four quarter-phases; Rising ↔ Falling and Reigning ↔ Fallen are opposite. The puzzle is putting the party and the enemies in **anti-phase** |
| Fiction / powers | ***Wheel of Time*** (Jordan) — the Wheel weaves lives as threads into the Pattern; *ta'veren* bend the threads around them → binding creatures to the wheel · **Bard** (LoL) *Tempered Fate* → The Wheel Stops · **Faceless Void / DIO** → The Wheel Stops · **Persona's Fortune Arcana** → the four positions as a visible "state" · ***Kingdom*** tragedies / kings' falls → Succession |
| Archetype | **The kingmaker** — the one who crowns and uncrowns |
| Fantasy line | *"I don't win fights. I decide who does."* |
| Role | **Force multiplier**: controller-support through Advantage and Disadvantage, the biggest lever in BG3 (§4.3); damage comes from the party and from the crossings |
| Specialist / versatile | **Specialist**: party amplification |
| Play style | Bind allies and enemies at the right positions so they **cross** at the right moment |
| Combat style | Mid range (18 m), any initiative; positions **others**. Turn 1: Crown an ally and Cast Down an enemy. Turn 2: the first crossing; the party plays its big turn |
| Strengths | Makes three other characters stronger on their own turns (P3); swings a fight in one turn (Peripeteia) |
| Weaknesses | Little damage alone · enemies left on the wheel **rise again** if not killed or cut · allies **fall** after they reign |
| Chassis | INT / **CHA** (sovereignty — crowns and courts; Persuasion, Intimidation); saves INT + CHA; light armour; simple weapons + light crossbows; sound set Wizard |
| Colour | Teal `#60d7d2`; emoji and VFX open |

### 2.2 The mechanic

**Core rule (one passive, *The Rota*):** *A creature bound to the Wheel moves one position down the Rota at
the start of your turn — Rising, Reigning, Falling, Fallen, and round again.*

| Position | Inscription | Effect on whoever carries it (ally or enemy) |
|---|---|---|
| **Rising** | *Regnabo* | Extra movement; can't be knocked Prone |
| **Reigning** | *Regno* | Advantage on attack rolls and saving throws |
| **Falling** | *Regnavi* | Disadvantage on attack rolls |
| **Fallen** | *Sum sine regno* | Attacks against it have Advantage; no reactions |

- **One table, both sides** (M2, M5). The same positions on allies and enemies — the player learns four
  states, not eight. The cost of the symmetry is the design: **an enemy left on the wheel will reign**,
  and **an ally who reigns will fall**.
- **Binding** lasts until combat ends, the creature dies, or the Spinner **cuts** it. The Wheel never
  releases on its own (inevitability).
- **Readable (P7):** the position is a status icon on the portrait, named in Latin and English; its tooltip
  says the **next** position. Between the Spinner's turns nothing changes, so the whole round is played in a
  known state.
- **Opposition.** Rising ↔ Falling and Reigning ↔ Fallen are opposite. From level 3, **the Crossing**:
  *when the Wheel turns, every bound enemy that becomes Fallen within 9 m of a bound ally that becomes
  Reigning takes damage (`STA_Spinner_Crossing`)* — one rises as another falls.
- **Simultaneity (M6):** the Wheel moves every bound creature at once, then crossings are collected and
  resolved, oldest binding first. A crossing moves nothing, so nothing chains.

**Worked example (level 3).** Turn 1: *Crown* on the fighter (binds at Rising) and *Cast Down* on the ogre
(binds at Falling, with damage); both are in opposite phases. The Spinner's turn 2 starts: the fighter
becomes **Reigning**, the ogre **Fallen** → the Crossing deals damage to the ogre. For the whole round the
fighter attacks with Advantage and everyone attacks the ogre with Advantage. Turn 3: the fighter will Fall,
the ogre will Rise — the Spinner *Exchanges* them, cuts the ogre, or lets the rogue finish it first.

### 2.3 Pool (derived from verbs)

Content axis: the four positions. Verbs: **bind** (enter the wheel), **nudge** (one step), **exchange**
(swap two), **hold** (stop one), **cut** (leave the wheel with a payoff), **reverse** (the ultimate).

| Card | Lvl | Verb | Action | What it does |
|---|---|---|---|---|
| *Spoke of the Wheel* (cantrip) | 1 | — | Action | Ranged spell attack, Bludgeoning |
| *Crown* | 1 | bind | Action | Bind an ally (or yourself) at **Rising** |
| *Cast Down* | 1 | bind | Action | Damage to an enemy and bind it at **Falling** (save for half damage; the binding always lands) |
| *Nudge* | 1 | nudge | **Bonus Action** | **Choose:** move one bound creature one position forward or back (K6) |
| *Nemesis' Exchange* | 3 | exchange | Action | Two bound creatures within 18 m swap positions |
| ***Peripeteia*** (ultimate) | 5 | reverse | Action, once per combat, no slot | Every bound creature within 18 m moves to the **opposite** position; every crossing this creates pays at once |
| *Wheel of Ixion* | 5 | bind | Action | Damage in 3 m; every enemy hit is bound at **Falling** |
| *Atropos' Cut* | 7 | cut | Action | Release one bound creature; its position pays out: **Fallen** enemy takes heavy damage · **Reigning** ally keeps Reigning one more turn · **Rising** ally regains HP · **Falling** enemy is Prone |
| *The Sphinx* | 9 | hold | Bonus Action | One bound creature keeps its position at the next turn of the Wheel |
| *The Wheel Stops* (capstone) | 11 | hold all | Action, Long Rest, Unique | No bound creature changes position for the next turns (`FEAT_Spinner_WheelStops`); crossings still pay each turn |
| *Rota Fortunae* (Aspect card) | T I | turn | Action, once per combat | The Wheel turns once more now: every bound creature moves one step and crossings pay |
| *Ready: Foreseen* | T III | nudge | Reaction | When a bound enemy attacks, move it one position down first |

**12 combat actions**; one resource (positions), one visible state per creature.

**Why Peripeteia is the ultimate (K3) and differs from the Aspect card (A3):** it is the turning point the
card is named for. It uses everything — positions, opposition, crossings — and flips a lost round into a
won one (an enemy that reached Reigning becomes Fallen; an ally that hit the bottom reigns). *Rota
Fortunae* advances the clock one step; Peripeteia **inverts** it.

### 2.4 Progression

| Lvl | Rules | Cards |
|---|---|---|
| 1 | **The Rota** | Spoke · Crown · Cast Down · Nudge |
| 3 | **The Crossing** · Tier I **Typhon** → *Rota Fortunae* | Nemesis' Exchange |
| 5 | — | **Peripeteia** · Wheel of Ixion |
| 7 | **Hubris** — a bound enemy that is Reigning takes extra damage from crossings and from your Cast Down (the higher they climb…) · Tier II **Hermanubis** | Atropos' Cut |
| 9 | **Succession** — when a bound enemy dies, the nearest enemy within 9 m takes its place on the wheel, at the same position (*the king is dead…*) | The Sphinx |
| 11 | — | **The Wheel Stops** |
| 12 | **The Crossing reaches the whole field** · Tier III **Aspect of Anticipation** | — |

### 2.5 Aspect Awakening

**Goal: crossings** — each enemy that becomes Fallen opposite a Reigning ally counts 1 (A1: only reachable
by playing the mechanic). Values `FEAT_Spinner_AspectAwakening`.

| Tier | Name (the card's figures, descending then rising) | Bonus |
|---|---|---|
| I | **Typhon** — the serpent descending | Enemies you bind enter **one position lower** (Cast Down binds at Fallen) |
| II | **Hermanubis** — rising on the wheel | When a bound ally becomes Reigning, one ally within 3 m becomes Rising (bound); the rise spreads |
| III | **Aspect of Anticipation** | Ready: Foreseen; and your bound allies can't move below Falling (the sphinx's balance) |

### 2.6 Self-audit

I2 ✅ "kingmaker of the wheel" · I4 ✅ reading the next position is the play · I5 ✅ new axis (Balance —
*who rises, who falls, and when do they cross?*; not Timing: nothing is delayed, the question is phase) ·
S2 ✅ strongest card link of the three · M3 ✅ bind / nudge / exchange / hold / cut / reverse · M5 ✅ both
sides share one table · M6 ✅ crossings move nothing · K3 ✅ Peripeteia · P3 ✅ every ally feels it on their
own turn · P5 ✅ first payoff on turn 2 · P7 ✅ one icon per creature · P8 ✅ nothing needs the AI ·
complexity 12 actions, one resource · B ❌ balance pass.

**Conflicts with recorded decisions (raise openly):** SP2 (fates), SP8 (role: damage → force multiplier),
SP11 (DEX → CHA). **Risk:** party-wide Advantage is strong (B1) — the counterweight is that enemies rise
again and allies fall; must be costed in `22.05`. **T2:** a position status that reapplies the next one on
`TimeOut` and keeps the Spinner as source (otherwise Osiris reapplies it, SP10); the Crossing pair check
(distance between bearers) in Osiris.

---

## 3. Proposal C — *Fortuna's Wager* (Risk)

> Anticipation as a bet. Before their next turn, the Spinner **calls** what the party will make happen.
> When the call comes true, Fortuna pays the ally who made it true; when it fails, Nemesis collects from
> the Spinner.

### 3.1 Identity Sheet

| Field | Answer |
|---|---|
| Card and why | **Fortune and misfortune, luck and its reversal**: the wheel as the gambler's wheel. Reversed meaning (bad luck) is the stake |
| Aspect and why | **Anticipation** in its neuroscience sense: the thrill is in the call, before the outcome. Every turn the player predicts the next round and commits to it |
| Mystra and the Weave | *Mystra wove the Spinner from a thread not yet pulled: they can call which way it will fall — and the Weave holds them to the call* |
| Myth | **Tyche / Fortuna** (the payout) · **Nemesis**, who punishes those who take more than their share (the stake) · **Kairos**, the god of the right moment, seized by the forelock as he passes → the capstone · **Hermes**, god of luck and of games of chance |
| Science | **Reward prediction error** (Schultz, 1997): dopamine fires on the cue, not the reward; a reward as predicted keeps it, a missing one makes it dip → three outcomes per wager (paid, raised, lost). **Kelly criterion** (bet size follows your edge) → *Raise the Stakes* |
| Fiction / powers | **D'Arby the Gambler** (*JoJo* Part 3, "Good!" — a bet the opponent can't refuse) → wagers · **Twisted Fate** (the gambler) → the Spinner's look · **Doctor Strange** (14,000,605 futures, one where they win) → *Kairos* · **Yumeko Jabami** (*Kakegurui*, the joy of risk) → *Let It Ride* · **Gambit** → payouts carried in cards |
| Archetype | **The gambler of fate** |
| Fantasy line | *"Call it. Then make it true."* |
| Role | **Tempo support with damage**: directs the party's focus and pays it for following; its own damage comes from payouts |
| Specialist / versatile | **Versatile**: wagers on kills, focus, protection and control |
| Play style | Each turn: which call, on whom, and how much to stake |
| Combat style | Mid range, close enough to read the field; turn 1 already wagers (fights of any length pay in one round) |
| Strengths | Fast payoff; tells the party what to do and rewards it; scales with a coordinated party |
| Weaknesses | A wager that fails hurts the Spinner · a scattered party wins few calls · weak when the fight is chaos |
| Chassis | INT / **WIS** (reading the table: Insight, Perception); saves INT + WIS; light armour; Daggers, Darts, Hand Crossbows; skill list *The Cardsharp* (Insight, Perception, Sleight of Hand, Deception, Investigation, Arcana, Acrobatics, Persuasion); sound set Wizard |
| Colour | Teal `#60d7d2`; emoji and VFX open |

### 3.2 The mechanic

**Core rule (one passive, *Fortuna's Wager*):** *You call what the party will make happen before your next
turn; if it happens, Fortuna pays the ally who made it happen; if not, Nemesis takes your stake.*

- A **wager** is a status on its target with a deadline: the start of the Spinner's next turn
  (`TickingWithSource` + `StartTurn`, duration 1 — SP5 pattern). The icon shows the call.
- **Paid:** Osiris removes the wager by script when the condition is met (not a `TimeOut`), and the payout
  lands on the **ally who fulfilled it** (the slayer, the last hitter, the guarded ally).
- **Lost:** the wager reaches `TimeOut` and its `OnRemoveFunctors` apply the **stake** to the Spinner:
  Psychic damage (`STA_Spinner_Stake`). The proven pattern: a cleanse is not a loss.
- **Deterministic rules, ordinary dice** (SP1): no wager uses chance of its own; whether it pays depends on
  the party's attacks and saves, as any spell does.
- **One wager per card per creature;** different calls coexist on one creature.

| Call (card) | Target | Pays when… | Payout (to the ally who made it true) |
|---|---|---|---|
| *Called Fall* | enemy | it drops to 0 HP | the slayer gains temporary HP; you regain the slot (PC: the Thread) |
| *Called Shot* | enemy | 2 different allies damage it (3 from level 9) | the last hitter's attack deals extra damage |
| *Called Guard* | ally | it takes no damage | it gains Advantage on attacks and saves on its next turn |
| *Called Ruin* | enemy | it fails a saving throw against an ally's effect | it is Incapacitated for 1 turn |
| *Called Rescue* | ally | it is healed from below half HP (or from downed) | it gains temporary HP and its movement doubles |

**Worked example (level 5).** Turn 1: *Called Fall* on the wounded goblin, *Called Shot* on the ogre, *Raise
the Stakes* (Bonus Action) on the Shot (3 allies, bigger payout). The rogue kills the goblin → the rogue
gains temporary HP, the Spinner regains the slot; the fighter, the cleric and the wizard hit the ogre → the
wizard's attack deals the raised extra damage. *Let It Ride* appears: the Spinner moves the goblin's
winnings onto a new *Called Fall* on the archer, doubled.

### 3.3 Pool (derived from verbs)

Content axis: **the five things a party does to win a fight** (kill, focus, protect, break, rescue) → five
calls. Verbs: **call**, **raise**, **let it ride**, **settle**.

| Card | Lvl | Verb | Action | What it does |
|---|---|---|---|---|
| *Spoke of the Wheel* (cantrip) | 1 | — | Action | Ranged spell attack, Bludgeoning |
| *Called Fall* | 1 | call | Action | See table |
| *Called Guard* | 1 | call | Action | See table |
| *Raise the Stakes* | 1 | raise | **Bonus Action** | One wager of yours: harder condition, bigger payout, bigger stake (K6) |
| *Called Shot* | 3 | call | Action | See table |
| ***Let It Ride*** (ultimate) | 5 | let it ride | Bonus Action, Created when a wager pays, once per turn, no slot | Instead of collecting, move the payout onto a new wager of the same call on another creature; its payout doubles. Up to 3 rides (`FEAT_Spinner_LetItRide`); a lost ride loses everything and the stake doubles |
| *Called Ruin* | 5 | call | Action | See table |
| *Called Rescue* | 7 | call | Action | See table |
| *Kairos* (capstone) | 11 | settle | Action, Long Rest, Unique | Until your next turn, every wager paid gives the ally who fulfilled it an **extra Action** |
| *Rota Fortunae* (Aspect card) | T I | settle | Action, once per combat | Every wager of yours on the field pays now, whether or not it came true |
| *Ready: Called It* | T III | call | Reaction | When an ally drops an enemy to 0 HP, place *Called Fall* on the nearest enemy |

**11 combat actions**; one resource (wagers) plus the stake on the Spinner's HP.

**Why Let It Ride is the ultimate (K3) and differs from the Aspect card (A3):** it ties call, payout and
stake into one decision — collect now or press the luck — and makes the party chain kills. Capped at 3 rides
(B3). *Rota Fortunae* is the opposite: a sure thing, everything settles at once.

### 3.4 Progression

| Lvl | Rules | Cards |
|---|---|---|
| 1 | **Fortuna's Wager** | Spoke · Called Fall · Called Guard · Raise the Stakes |
| 3 | Tier I **Tyche** → *Rota Fortunae* | Called Shot |
| 5 | — | **Let It Ride** · Called Ruin |
| 7 | **Hedge** — a creature carrying two of your wagers: if one pays and the other is lost, the stake is halved · Tier II **Nemesis** | Called Rescue |
| 9 | **Long Odds** — *Choose* on every call: a 2-turn deadline for a doubled payout | — |
| 11 | — | **Kairos** |
| 12 | Tier III **Aspect of Anticipation** | Ready: Called It |

### 3.5 Aspect Awakening

**Goal: wagers paid** (A1). Values `FEAT_Spinner_AspectAwakening`.

| Tier | Name | Bonus |
|---|---|---|
| I | **Tyche** — fortune | The first wager you place each turn costs no action (two calls a turn) |
| II | **Nemesis** — balance | A lost wager's stake falls on its **target** instead of you (enemy targets), or is halved (ally targets) |
| III | **Aspect of Anticipation** | Ready: Called It; *Let It Ride* can ride 5 times |

### 3.6 Self-audit

I1 ✅ likely the most exciting turns of the three (press-your-luck) · I4 ✅ the call before the outcome ·
I5 ✅ Risk is free · M1 ✅ wagers read only by the Spinner · M5 ✅ calls on allies and enemies · P3 ✅ the
party is told what to do and paid for it · P5 ✅ every wager settles inside one round · P6 ✅ which call,
whom, how much · P8 ⚠️ *Called Guard* depends on whom the AI attacks — that is the risk, by design ·
complexity 11 actions · B ❌ balance pass.

**Conflicts with recorded decisions:** SP2 (fates), SP8 (role), SP11 (DEX → WIS); leans on dice outcomes
more than the other two (SP1 is honoured in the rules, but the *feel* is luckier). **T2:** detecting each
condition in Osiris — kill and damage-by-attacker exist in the mod (the Sorrow ledger reads `AttackedBy`);
a **failed save against an ally's effect** and **healed from below half** need a probe each, with a plan B
(drop the card).

---

## 4. Side by side

| | A · Measured Thread | B · Rise and Fall | C · Fortuna's Wager |
|---|---|---|---|
| Axis | Timing | **Balance** (new) | Risk |
| Core state | Fates (countdowns) | Positions on the Rota (cycle) | Wagers (calls with a deadline) |
| Role | Delayed area damage | Force multiplier (Advantage / Disadvantage) | Tempo support + payouts |
| Secondary | DEX | CHA | WIS |
| Ultimate (K3) | *Synchrony* | *Peripeteia* | *Let It Ride* |
| Capstone | The Wheel Stops | The Wheel Stops (held) | Kairos |
| Combat actions by 12 | 13 | 12 | 11 |
| First payoff | Turn 2 (turn 1 with Needle) | Turn 2 | Turn 1 |
| Card link (S2) | Strong (wheel, Moirai) | **Strongest** (the inscriptions themselves) | Medium (fortune, luck) |
| Party feel (P3) | Medium | **Highest** | High |
| Recorded decisions kept | **Almost all** | Few (identity, chassis parts) | Few |
| Rework cost | Low | Medium | Medium |
| Main risk | Reads as DoT (K2) | Party Advantage too strong (B1) | Calls the AI can deny (P8); condition probes |

## 5. Recommendation

**B · Rise and Fall** is the strongest answer to the standard: the card's inscriptions *are* the mechanic,
the axis is new, the state is one icon per creature, and every ally feels it on their own turn — the
standard's P3 at its best. It changes the role recorded in SP8, so it needs the Owner's word.

If the Owner wants to keep the 2026-10-08 design, **A** fixes every audit gap with the least loss.
**C** is the boldest and the most fun on paper, and the riskiest to build.

Parts travel between them: B's *Peripeteia* or C's *Let It Ride* could replace A's *Synchrony*; A's fates
could be the damage layer under B's positions (at the cost of a second system).

## 6. Next step

The Owner picks a direction (or a mix). The choice becomes SP47 in `decisions.md`; the brainstorm then goes
one question at a time through the rungs the choice reopens (§1.2), before the raising spec and the
balance pass.
