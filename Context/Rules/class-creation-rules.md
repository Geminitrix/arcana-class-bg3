# Class Creation Rules — the Arcana design process

> The rules every design change to the **Arcana** follows: a new subclass, a rework of an existing one,
> a new card or passive for a subclass, or a change to the **base class**. It holds the process, the
> criteria a design is judged by, what Baldur's Gate 3 rewards and punishes, and how to balance.
>
> This file holds **rules and method only**. The current state of each subclass lives in
> `Context/subclasses/<name>.md` (including its Depth audit); the current state of the base class in
> `Context/03-base-class.md`. When a rule here proves wrong, rewrite the rule — don't append history.

---

## 0. When this applies

| The work | What it must go through |
|---|---|
| **New subclass** | The whole process (§1), every criterion (§3), a written spec |
| **Rework of a subclass** | Audit against §3 first; then the process from the phase the audit points at |
| **New card, passive or tier bonus** for a subclass | §1.2 brainstorm (short), §3 criteria it touches, §7 placement, §8 balance |
| **Base class change** (chassis, resources, deck rules, Awakening framework, utilities) | §6 impact matrix across every subclass, then §3 and §8 for what it touches |
| **Number-only tweak** | §8 (show the arithmetic) and a test plan |
| **Text-only change** | §10 |

Nothing reaches the game files without the author's approval of the design first. Approval of one
design never extends to the next.

---

## 1. The process

```
Frame → Brainstorm → Synthesis → Analysis → Spec → Plan → Build → Test → Record
                ↑__________________|  (analysis can send it back)
```

### 1.1 Frame

1. **Read before asking.** `Context/README.md`, `01-identity-and-lore.md`, `02-systems.md`,
   `04-subclass-comparison.md`, `07-open-questions.md`, and the subclass file if it exists. Earlier
   sessions may already have decided things: honour them, or raise the conflict openly.
2. **Classify** the work (§0) and say the classification out loud so the author can correct it.
3. **List what is already decided** and what is open before the first question.

### 1.2 Brainstorm — the conversation

The brainstorm is a dialogue between the author and Claude, slow on purpose. Ideas come from both sides
and get built on, not replaced.

**How each turn works**
- **One question per message.** A topic that needs more goes into several messages.
- **Multiple choice when it can be:** 2–4 options, each with what it gives *and* what it costs, the
  recommendation first or clearly marked, and the reason for it. Open questions are fine for taste and
  identity.
- **Make it concrete.** A worked example of a turn of play beats an abstract rule. When the author
  gives their own example, check it against the rule and say whether it matches.
- **Bring ideas, not only questions.** Research the source (card, myth, science, fiction) and offer what
  it suggests. When an author idea conflicts with a recorded decision or with another subclass, say so
  and offer a way to reconcile.
- **Check feasibility as you go**, but don't let it lead. A mechanic that can't be built is caught early
  by grepping vanilla data and `Docs/OSIRIS.md` / `Docs/KHONSU.md`, then reported in one or two lines.
  When the author knows an engine trick (a status flag, a stack type), verify it and adopt it.
- **No numbers during the brainstorm** beyond placeholders. Numbers come in §8.
- **Keep a decision log in the conversation:** `D1, D2…`, one line each, re-shown as a table every few
  decisions so both sides see the same state.
- **Admit mistakes plainly** and fix them in the next message. A recommendation the author rejects is
  dropped, not re-argued.

**The order of questions (the design ladder).** Each rung depends on the ones above it. Skip a rung only
when it's already decided.

| # | Rung | The question it answers |
|---|---|---|
| 1 | **The card** | What does the Arcanum really mean (tradition, imagery, numbers, reversed meaning)? Which readings can become mechanics? |
| 2 | **References** | Myth, science, fiction and powers that carry the same idea (§2) |
| 3 | **The axis** | Which question does the player answer that no other subclass asks? (§2.3) |
| 4 | **The engine** | The state only this subclass creates and reads, and its one core rule |
| 5 | **Engine rules** | Timing, stacking, targets, simultaneous events, what ends it |
| 6 | **Role** | Damage, control, support, tank: primary and secondary styles |
| 7 | **Chassis** | Secondary ability, saves, armour, weapons, skills, preset, sound set, colour |
| 8 | **Progression ladder** | Which rule arrives at which level (§7.4) |
| 9 | **Awakening** | Goal, three tiers, Aspect card (§9) |
| 10 | **Spell and passive pool** | Derived from the axes and verbs of the engine (§7) |
| 11 | **Texts** | Names, descriptions, tag line (§10) |
| 12 | **Numbers** | Balance pass (§8) |

### 1.3 Synthesis

Assemble the decisions into the **Identity Sheet** (§2) and an **engine description** (core rule, edge
rules, worked example). Every decision has an id and a source (author / proposal accepted).

### 1.4 Analysis

Run the design against **every criterion in §3** and the **BG3 checks in §4**. Present only what fails
or is borderline, with a proposed fix. A failure in identity or engine sends the work back to the
brainstorm rung it belongs to; a failure in numbers stays in §8.

### 1.5 Spec

Write `Design/specs/YYYY-MM-DD-<subclass>-design.md` in English: the **design document**, a
complete description of the subclass — everything it is and does, explained in full, with no audit in it.
Sections: Identity · Chassis · Engine (rules, worked example, resolution order, edge cases) · the
subclass's own systems · Spells · Passives · Aspect Awakening · Progression · How it plays · Text ·
Technical pattern (statuses, Osiris, generator, ids) · Open · To test in game.
Self-review it for placeholders, contradictions and ambiguity, then the author reviews it. The §3 audit
is a working step of the analysis; its result is recorded in the subclass file (§12), never in the
design document.

### 1.6 Plan, build, test

- An implementation plan (writing-plans) with **one gate per stage**. A `[fechado]` message is one stage.
- Families of more than a handful of statuses or spells come from a **generator script**; change the
  generator's table, never the generated output.
- **One rule per in-game test.** The test says what to do and what proves it works.

### 1.7 Record

Update in the same round of work: the subclass file (fixed section order: Identity · Chassis · How it
plays · Strengths/weaknesses · Level table · Cards · Passives · Aspect Awakening · Depth audit), the
tarot and inspirations tables in `01`, `04-subclass-comparison.md`, `06-glossary.md`,
`07-open-questions.md` (remove what got answered), and the patch notes.

---

## 2. The Identity Sheet

Every subclass fills every field. "To decide" is allowed during the brainstorm, never in a spec.

| Field | What it must contain | Quality bar |
|---|---|---|
| **Arcanum and why** | Number, name, and the readings of the card that the subclass carries | Each carried reading points at a mechanic. A reading with no mechanic is decoration; drop it or give it one |
| **Aspect and why** | The Aspect's name, and why that word | The Aspect is **what the engine makes the player do or feel**. If the Aspect could be swapped with another subclass's without anyone noticing, it fails |
| **Relation to Mystra and the Weave** | How this destiny was woven: which part of the Weave it holds or pulls | One sentence that could only be written about this subclass; uses the class's Weave vocabulary |
| **Myth** | Greek mythology first (the class's planned boons are Greek), others where they fit better | A named figure or story that lends a specific rule, name or image |
| **Science / real source** | A real-world model (psychology, physics, astronomy, biology…) when one exists | It structures the content (Plutchik's wheel gives the Resonant its states) rather than just naming them |
| **Fictional characters** | 2–4 characters | Each lends something named: an ability, a fantasy, a visual |
| **Reference powers** | The abilities borrowed and what became of each | Clear line from source to card |
| **Archetype** | The role-playing image in a few words | Recognisable without the card ("the clockmaker of fate") |
| **Fantasy line** | One sentence the player should feel | Short; would fit on the mod page |
| **Role** | Primary and secondary role in a party of four | Fills a gap or plays a shared role in a new way (§2.3) |
| **Play style** | What the player plans and decides | Names the main decision of a turn |
| **Combat style** | Range, position, action economy, tempo across a fight | Concrete: where they stand, what turn 1 and turn 3 look like |
| **Strengths** | What it does best | At most three; each traceable to a mechanic |
| **Weaknesses** | What beats it | Real and visible in play: a weakness that never shows up isn't one |
| **Chassis** | Secondary ability, saves, armour, weapons, skills list, preset, starting gear, sound set | Secondary ability serves the engine, not only the theme. Saves, armour and weapons match the role |
| **Colour, emoji, VFX** | Hex colour, emoji, Aspect VFX | Distinct from every other subclass's colour on black; matches the emblem art |
| **Voice** | Class description, panel line, tag line (§10) | Same register as the other subclasses |

### 2.1 Reading a tarot card for mechanics

- Start from the **traditional meaning** (upright and reversed), then the **imagery** (Rider-Waite and
  the older decks it adapts: Marseille, Thoth), then **number and astrology** (Golden Dawn correspondences).
- Mechanics hide in the imagery: a figure rising and another falling, two cups pouring, a veil between
  pillars. Name the image when using it.
- Prefer a reading that **creates a decision** over one that creates a bonus.

### 2.2 References

- **Myth:** look for the figure that *does* the card's idea (the Moirai spin, measure and cut; Nemesis
  balances fortune), not only the one with the right name.
- **Science:** a real model gives free structure: a fixed set of elements, distances, opposites, cycles.
  If the model has N parts, the content can have N pieces — and that justifies the size of the list.
- **Fiction:** take characters whose *kit* expresses the idea (League of Legends, Dota, JoJo, anime,
  films). Borrowed ability names are fine when they become our own mechanic.

### 2.3 The axis — what makes a subclass different

Each subclass owns **one axis**: the question the player keeps answering. Two subclasses may share a role
(two controllers) but never an axis. Examples of axes:

| Axis | The player's question |
|---|---|
| Combination | *What* goes with *what*? |
| Accumulation | *How much* have I built up, and when do I spend it? |
| Timing | *When* does it happen, and what happens with it? |
| Position | *Where* is everyone, and where do I go? |
| Resource conversion | What do I pay (HP, allies, items) and for what? |
| Risk | How close to losing do I dare to play? |
| Presence | How many bodies (summons, doubles) do I hold on the field? |
| Transformation | Which form am I in, and when do I switch? |

The axis each subclass owns goes in the **Axis** row of `04-subclass-comparison.md` (filled when the
subclass is designed or audited). A new subclass's axis must be free, or the overlap must be argued and
accepted.

---

## 3. The Depth Model — criteria

A design is **complete** when it passes every criterion. Each one has a test question and what failure
looks like. The audit table in a spec or subclass file uses these ids.

### Identity (I)

| # | Criterion | Test | Failure looks like |
|---|---|---|---|
| I1 | **Card fidelity** | Can the link between the main mechanic and the card be explained in one sentence? | The card is only the name and the art |
| I2 | **The Aspect is the engine** | Does using the engine *feel like* the Aspect? | The Aspect is a stat bonus with a mood word on it |
| I3 | **Real sources** | Does each reference lend a specific rule, name or image? | A list of names with nothing borrowed |
| I4 | **Mystra and the Weave** | Is there one sentence on how this destiny was woven, unique to it? | Generic "Mystra chose them" |
| I5 | **Own axis** | Is the axis (§2.3) free among the subclasses? | Plays like another subclass with new names |
| I6 | **Own vocabulary** | Do its names belong to its theme and to no other subclass's? | A word that fits another subclass better (a wind word on a time mage) |

### Engine (E)

| # | Criterion | Test | Failure looks like |
|---|---|---|---|
| E1 | **An engine of its own** | Is there a state only this subclass creates and reads? | Its cards are independent spells |
| E2 | **One rule, explained once** | Can the core rule be stated in one sentence on one passive? | Each card carries its own exception |
| E3 | **Grows by rules** | Do levels unlock *new rules*, not only bigger numbers? | Level 9 plays like level 3 with bigger dice |
| E4 | **Three roles** | Are there generators (create state), converters (change state) and payoffs (spend state)? | Only generators, or a payoff that needs no setup |
| E5 | **Allies and enemies** | Do both sides of the field take part in the engine? | The engine only touches enemies (or only allies) |
| E6 | **Deterministic and bounded** | Is every chain finite and its resolution order defined, including simultaneous events? | Loops, double counting, order that depends on engine luck |
| E7 | **Awakening is the climax** | Does the goal count uses of the engine, and do the tier bonuses push the engine's theme? | The goal counts something the engine doesn't do; tiers are generic stats |

### Play (P)

| # | Criterion | Test | Failure looks like |
|---|---|---|---|
| P1 | **Plays from level 1** | Does a level-1 character already play the engine? | The identity arrives at level 5 |
| P2 | **Fits the fight's length** | Does the setup pay back inside a typical fight (§4.2)? | The payoff arrives after the fight is over |
| P3 | **A real decision most turns** | Is there usually a non-obvious choice? | One correct play every turn (solved = boring) |
| P4 | **Readable in BG3's UI** | Is the state on the portrait or status icon, with a number when it counts, and named in the combat log? | The player has to remember hidden state |
| P5 | **Works against the AI** | Does it work when enemies ignore it? | It needs the enemy to cooperate |
| P6 | **Real weaknesses** | Do the listed weaknesses show up in normal play? | Unbeatable on paper, or weaknesses that never matter |
| P7 | **Both editions** | Does the console edition (no deck, slots only) play the same engine? | The engine only works with the PC deck |

### Balance (B)

| # | Criterion | Test | Failure looks like |
|---|---|---|---|
| B1 | **On the curve** | Is its power per level band near the benchmark (§8.3)? | Spikes or dead levels |
| B2 | **Combos costed** | Are payoffs priced at the best case minus the setup cost? | A combo that is free once assembled |
| B3 | **Loops bounded** | Is every positive feedback loop capped? | Snowball that ends fights by itself |
| B4 | **Err weak** | Where unsure, is it on the weak side? | "We'll nerf it later" |

### Technical (T)

| # | Criterion | Test | Failure looks like |
|---|---|---|---|
| T1 | **No Script Extender in the engine** | Stats, Osiris, Khonsu and LSX only? | The engine needs Lua |
| T2 | **Proven pattern** | Is there a vanilla example, or a cheap test planned? | Built from the schema alone |
| T3 | **Generated at scale** | Do families of statuses or spells come from a generator? | Dozens of hand-copied entries |
| T4 | **Conventions** | Ids, prefixes, `_TECH` helpers and markers follow the glossary? | New naming patterns |

### Form (F)

| # | Criterion | Test | Failure looks like |
|---|---|---|---|
| F1 | **Identity Sheet complete** | Is every field of §2 filled and does each meet its quality bar? | Fields missing or "to decide" in a spec; references with nothing borrowed; strengths and weaknesses only on the wiki |
| F2 | **Ladder complete** | Does every rung of §7.4 hold what it must: level 1 plays the engine, 3/5/7/9 each bring a new rule or verb, 11 the capstone, 12 Tier III? | A dead odd level, several new rules piled on one level while the next is empty, an empty level 12 |
| F3 | **Structure** | Does the spec follow §1.5 (sections, no audit inside), does `Context/subclasses/<name>.md` exist in the §1.7 order with its Depth audit, and do the spec, the Context, the wiki and the game files agree? | Decision logs or audits inside the design document; no subclass file; the wiki says one chassis and the spec another |

---

## 4. What Baldur's Gate 3 rewards and punishes

Design for the game the player is in. These are the facts that shape every mechanic; estimates are
marked and get corrected by playtest.

### 4.1 The turn

- **Action economy:** one **Action**, one **Bonus Action**, one **Reaction** per round, plus **Movement**.
  Extra actions (Haste, Action Surge) are the most valuable resource in the game. Cost every effect in
  the action it uses: a bonus-action card lets a turn combine two things, so it is worth more than the
  same effect as an action.
- **A round is 6 seconds; a status lasts N turns = N rounds.** Duration counts down on the bearer's turn
  (`TickType` `StartTurn` / `EndTurn`), or on the **source's** turn with `TickingWithSource`. The
  remaining turns show as a number on the status icon — free readability for anything timed.
- **Reactions** fire on enemy turns; each Arcana reaction has a per-round limit (`02-systems.md` §8).
- **Shared initiative:** party members next to each other in the order can act together, and initiative
  is rolled once (DEX). A subclass that acts first sets up before enemies move.

### 4.2 The fight

- **Typical length (estimate):** easy fights 1–2 rounds, normal 3–5, bosses 6–8. Rule of thumb: setup
  must pay back by round 3, and nothing core should wait past round 4.
- **Turn 1 matters.** Every subclass needs something useful on its first turn; a pure-setup turn 1 must
  be paid back later with interest.
- **Party of four.** A subclass shines by what it does for the other three, too: positioning allies,
  enabling their turns, covering their weak points.
- **The AI doesn't play around states.** Enemies don't read the mod's mechanics; design effects that work
  when ignored, and use the AI's predictability (it attacks the closest, the weakest, the summon).

### 4.3 The dice

- Bounded accuracy: attack and save bonuses stay small, so **Advantage/Disadvantage** (≈ ±5 on a d20)
  is the biggest lever. Stacking several sources of Advantage gains nothing.
- **Save DC** = 8 + proficiency + Intelligence modifier for the whole class.
- **Concentration:** one at a time; damage forces a CON save. Concentration is a limit on *simultaneity*,
  not on uses.
- **Damage types:** 13 (Acid, Bludgeoning, Cold, Fire, Force, Lightning, Necrotic, Piercing, Poison,
  Psychic, Radiant, Slashing, Thunder). Resistance and immunity vary by enemy; check vanilla stats before
  relying on a type. Force and Radiant are the least resisted in practice; Poison and Necrotic the most
  (undead, constructs) — verify per act before balancing around it.

### 4.4 The world

- **Verticality and terrain:** high ground gives Advantage on ranged attacks; jump, shove and throw are
  universal. Mechanics that use position feel native.
- **Surfaces and elements:** water + lightning, grease + fire, ice, darkness and light (obscurement).
  An effect that creates or reacts to a surface plugs into a system the player already knows.
- **Vanilla conditions** (Prone, Blinded, Frightened, Restrained, Incapacitated, Stunned, Paralysed…)
  are understood by players and the AI. A custom state should use the **vanilla status type** that fits
  (FEAR flees, INCAPACITATED can't act) rather than imitating it.

### 4.5 Pacing across a playthrough

- **Levels 1–12**, and the class must be complete at 12. Rough acts (estimate): Act 1 ≈ levels 1–5,
  Act 2 ≈ 5–8, Act 3 ≈ 8–12.
- **Vanilla spikes:** level 5 (third-level spells, Extra Attack), level 11 (sixth-level spells). Feats at
  4, 8, 12. Arcana slot levels follow the full-caster curve (1, 2 at 3, 3 at 5 … 6 at 11).
- **Rests are cheap.** Two Short Rests per Long Rest, and camp supplies make Long Rests frequent. A
  once-per-Long-Rest limit restricts much less than at a tabletop; once-per-combat and per-turn limits do
  the real work.
- **Out of combat** is half the game: dialogue checks, exploration, puzzles. The base class owns the
  seer's utility; a subclass adds at most one utility, and only if it reflects its identity.

### 4.6 What to exploit

- **Turn-based determinism** rewards engines the player can plan two turns ahead.
- **Status durations as visible numbers** make timers and countdowns readable for free.
- **Positioning** (allies included) is a decision players already enjoy.
- **Status types and stack types** (`Additive`, `Overwrite`, `StackPriority`) carry a lot of logic without
  scripts.

---

## 5. The Arcana framework every subclass plugs into

These are fixed by the class. A subclass designs *within* them; changing them is a base-class change (§6).

- **Spellcasting is Intelligence** for every subclass; each subclass has one secondary ability, the one
  its engine leans on.
- **Woven Spell Slots** all share one level and **every card is cast at the highest slot level**
  (Warlock-style). There is no "cast lower or higher" choice: designs that ask the player to pick a slot
  level do not work. Cards scale by slot level through generated upcast variants; statuses get one
  version per spell level.
- **Threads (PC):** card cost = card level; cantrips cost 1; the per-turn curve is in `02-systems.md`.
  Cheap cards are what make a turn of several plays possible.
- **The deck (PC):** 3 copies per card, 1 for Unique; opening hand 4, draw 1 per turn. A subclass's pool
  must make a legal and varied deck at every level. A card that is only good in multiples, or useless
  alone, is a deck problem.
- **Keywords** (Unique, Created, Choose, Fleeting, Fated…) are shared vocabulary: use them before
  inventing new ones.
- **Aspect Awakening:** three tiers at levels 3/7/12, a goal per tier counted in Osiris, the Aspect card
  at Tier I (§9).
- **Both editions:** every gameplay effect lives in Stats/Osiris/Khonsu/LSX. Lua only manages the deck.

---

## 6. Base-class changes

The base class is the **seer**: divination and out-of-combat utility, the resources, the deck, the
Awakening framework. The subclasses carry the combat.

- **What belongs to the base class:** utilities, familiars, divination features, the Weaver Hand picks,
  resources and their curves, deck rules, keywords, the Awakening framework.
- **What never belongs to it:** a combat engine. If a base feature starts doing a subclass's job, it
  takes away that subclass's identity (opportunity cost of design).
- **Impact matrix — required for every base change.** One row per subclass: what the change does to its
  engine, its numbers, its readability and its console version. A change that helps one subclass much
  more than the others needs a reason.
- Base-class changes go through the same brainstorm and approval; numbers through §8 against every
  subclass at once.

---

## 7. Building the spell and passive pool

### 7.1 The size is a consequence

There is **no standard number of cards** per subclass or per level. The pool is derived from the engine:

1. **Content axis** — what varies between states (the 8 emotions; the elements; the forms). If a real
   model fixes N parts, the pool may have N pieces of that kind.
2. **Time / intensity axis** — short vs long, weak vs strong, if the engine has one.
3. **Verbs** — what the player does to the state (create, move, change, copy, delay, spend). **One card
   per verb at most**; a verb already covered by a rule doesn't need a card.
4. **Roles** — check generators, converters and payoffs are all present (E4) and that the curve of the
   level bands has something in each.

A caster whose variety *is* the engine can have a large pool; a martial subclass whose engine lives in
its attacks needs few cards. Both are fine when the size is explained.

### 7.2 Every card answers

- Which axis or verb is it? Which role (generator / converter / payoff)?
- Which **action** (Action, Bonus Action, Reaction) and which **limiter** (none, Concentration,
  once per turn/round/combat, Short/Long Rest, Unique)?
- Why at this level, and what does it add that the cards before it didn't?
- What does it do in a level-12 deck: still a choice, or dead weight?

### 7.3 Spread of action types

- At least one **bonus-action** option early, so turns combine two plays.
- A **cantrip** as the baseline when the subclass casts; it is what the turn falls back on.
- Reactions are cards with a per-round limit (`02-systems.md` §8).

### 7.4 The progression ladder

- **Level 1:** the engine is playable (P1). Explain the core rule on one passive.
- **Levels 3 / 5 / 7 / 9:** each brings **a new rule** or a new verb (E3). Avoid stacking several new
  rules on one level when the next ones are empty.
- **Level 11:** the capstone card (Long Rest, Unique is typical).
- **Level 12:** Tier III, and any passive cards.
- Even levels belong mostly to the base class; a subclass may use them when it has a reason.

### 7.5 Passives

- **Rule passives** explain one rule once and unlock it at a level.
- **Tier passives** are hidden; the visible "Awakening" passive explains the goals.
- A passive that only adds numbers is a balance knob, not a design; use it sparingly.

---

## 8. Balance

Balance serves the experience: first say what the player should feel, then choose numbers. Show the
arithmetic, declare assumptions, err weak.

### 8.1 The budget

- Declare **E** (encounters per Long Rest) and **T** (rounds per encounter) before any number. Show the
  result again with another E or T if the conclusion depends on it.
- Convert everything to one currency: expected damage per round, HP saved, enemy actions denied.

### 8.2 The formulas

- Average of XdN = X·(N+1)/2.
- Attack hit chance p = (21 − (AC − bonus)) / 20, clamped to [0.05, 0.95]. Expected damage = p × average
  (+ crits when relevant).
- Save fail chance p = (DC − save bonus − 1) / 20, clamped. Half on success: EV = dmg × (p + 0.5·(1 − p)).
- Advantage on a roll with success chance q: 1 − (1 − q)².
- **Control:** value ≈ enemy actions denied × value of an enemy action × chance it works × expected
  duration (a repeated save each turn gives ≈ 1/p_success turns, capped).
- **Area:** × the expected number of targets (minus allies hit and enemies already dead).
- **Delay:** a delayed effect is worth its value × the chance it still matters when it lands (target
  alive, fight still on). A countdown of N turns must pay more than the same effect now.
- **Limiters as uses per adventuring day:** once per turn ≈ E × T (capped by the action it uses); once per
  combat ≈ E; once per Short Rest ≈ R + 1 (R = Short Rests per Long Rest); once per Long Rest = 1.
  Concentration limits simultaneity, not uses. Two limiters on one effect: check they don't double-count.

### 8.3 The benchmark

- Compare each **level band** (1–2, 3–4, 5–6, 7–8, 9–10, 11–12) against a vanilla class of the **same
  role**: a damage caster against Wizard/Sorcerer/Warlock, a healer against Life Cleric, a tank against
  Paladin/Fighter. Use their real numbers from the vanilla files, not memory.
- Sum the expected value per adventuring day of everything the subclass has at each band and plot it.
  Peaks are explosive levels, valleys are dead ones.
- Compare the subclasses of the Arcana with each other the same way.

### 8.4 Costing rules

- Costs = benefits. A card's cost includes its resource, its action, its limiter and its conditions.
- A restricted benefit is never a cost and is worth more than zero.
- A choice between A or B costs at least the more expensive one.
- **Combos under the player's control** are costed at the best case minus the cost of assembling them.
- **Feedback loops** (a payoff that creates the state that feeds it) need a cap: once per turn, once per
  chain, a maximum count.
- Overpowered (too much benefit) and undercosted (too little cost) are different fixes: change the one
  that is wrong.

### 8.5 Verification

Every number ships with how it will be checked: the fight to run (one target, outnumbered, boss), the
metric (damage per round, rounds to win, resources left), and what result would prove it wrong.

---

## 9. Aspect Awakening

- **The goal counts the engine** (E7): Doubt applied, fates resolved, emotions triggered. Never a generic
  metric the subclass would reach without playing its engine.
- **Three goals, one per tier** (levels 3/7/12), cumulative within a fight. Check with §8 that Tier I is
  reachable in a normal fight at level 3 and Tier III in a long one at level 12.
- **Tier names** come from the card or its myth, in order (the Rota Fortunae's positions, the card's
  figures…).
- **Tier bonuses push the theme of the engine.** Tier I: a change to how the engine runs. Tier II: the
  engine spreads or protects. Tier III: the theme at its peak, with a mechanic only this subclass could
  have. A "+3 ability and its modifier to damage" bonus is allowed only as an addition to a thematic
  bonus, never as the bonus itself.
- **The Aspect card** (Tier I, Created, 0 Threads, 0 slots, once per combat) is the engine's climax:
  it releases or multiplies the state built up so far, so it grows with the level by itself.

---

## 10. Names and texts

- **English, Larian voice** (`bg3-english-writing-style` memory): first sentence states origin or nature,
  second gives the gameplay promise.
- Subclass texts follow the shared formulas in `01-identity-and-lore.md` §5 (class description, panel
  line, tag line).
- **Names belong to the theme** (I6): a word that fits another subclass's world better goes back to the
  brainstorm. Prefer names from the card, its myth or its science.
- Ids follow `06-glossary.md`; the literal prefix decides what a spell is to the deck.

---

## 11. Technical feasibility

Feasibility is checked during the brainstorm in a line or two, and in full during analysis. Sources:
`Docs/OSIRIS.md`, `Docs/KHONSU.md`, the vanilla data in `C:\Projetos\BG3 Modding\Base Game BG3\Assets\`,
other mods in `C:\Projetos\BG3 Modding\References\`, and `story_header.div` for Osiris signatures.

- **Grep before claiming.** A field, functor or Osiris call exists only when a vanilla or working file
  uses it. Schema-valid isn't proof.
- **One cheap test per uncertainty.** If the author is sure from experience, take their word and drop
  the test.
- **Proven patterns in this mod** (reuse before inventing):

| Need | Pattern |
|---|---|
| Stats → script hand-off | `ApplyStatus(<X>_TECH,100,0)` on the target; Osiris reacts to the status and runs a `PROC` |
| Timer that counts on the caster's turn | `TickingWithSource` + `TickType "StartTurn"` |
| Effect when a status expires naturally | `OnRemoveFunctors` with `IF(RemoveCause(StatusRemoveCause.TimeOut)):…` — a cleanse doesn't trigger it |
| Add turns to a running status | `StackType "Additive"` and reapply (negative durations don't subtract; −1 means permanent) |
| Read remaining turns | Osiris `GetStatusTurns(target, status, _Turns)` |
| One state at a time vs coexisting | Shared `StackId` (with `StackPriority` for tiers) vs separate `StackId`s |
| Reaction card | Interrupt + charge resource + per-round limit |
| Families of statuses or spells | A generator script in `tools/stats/` with a table; patches applied from it |

- **Simultaneous events:** Osiris runs one event at a time. When several things "happen at once"
  (two timers end together), the design defines a **queue**: collect, resolve in a fixed order, remove
  each before its effect fires, then process what it caused as the next wave.

---

## 12. Auditing an existing subclass

1. Fill the Identity Sheet (§2) from the subclass file and the game files.
2. Score every criterion of §3: ✅ pass · ⚠️ partial · ❌ fail, one line of evidence each.
3. Write the result in the subclass file under **Depth audit**, with the date.
4. Each ❌ becomes a question for a raising brainstorm; the raising goes through the process (§1) and
   gets its own spec.

---

## 13. Anti-patterns

| Don't | Because | Do |
|---|---|---|
| Copy another subclass's card count or level layout | Each subclass is its own archetype (§7.1) | Derive the pool from the engine's axes and verbs |
| Give a tier a generic stat bonus | Fails I2 and E7; every subclass would feel the same | Push the engine's theme (§9) |
| Use randomness in an engine built on foresight or planning | Breaks readability and the Aspect | Deterministic rules, visible state |
| Design around choosing a slot level | Arcana always casts at its highest slot | Scale by slot level; vary by card |
| Need two statuses per effect without a strong reason | Doubles the scope and the things to read | One status, its duration and stack type carry the logic |
| Leave simultaneous resolution undefined | Double counting, skipped effects, loops | Define the queue and the order (§11) |
| Let a chain feed itself without a cap | Snowball (B3) | Cap per turn or per chain |
| Rely on the AI reacting to the mechanic | It won't (P5) | Effects that work when ignored |
| Borrow a word from another subclass's world | Muddles both identities (I6) | Names from the card, its myth or its science |
| Ask several things in one brainstorm message | The author answers one and the rest get lost | One question per message |
| Put numbers in the brainstorm | Anchors the discussion on placeholders | Numbers in §8, after the design is approved |

---

## 14. Checklist (use during analysis and audits)

```
Identity    I1 card · I2 aspect · I3 sources · I4 Mystra · I5 axis · I6 vocabulary
Engine      E1 own state · E2 one rule · E3 grows by rules · E4 G/C/P · E5 both sides · E6 bounded · E7 awakening
Play        P1 level 1 · P2 fight length · P3 decisions · P4 readable · P5 vs AI · P6 weaknesses · P7 console
Balance     B1 curve · B2 combos · B3 loops · B4 err weak
Technical   T1 no SE · T2 proven · T3 generated · T4 conventions
Form        F1 Identity Sheet · F2 ladder 1/3/5/7/9/11/12 · F3 structure (spec · subclass file · sources agree)
Also        Awakening goal + tiers + card · Texts · Test plan
```
