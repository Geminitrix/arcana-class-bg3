# Subclass Design Criteria — how the Arcana designs and evaluates a subclass

> How every design change to the **Arcana** is made and judged: a new subclass, a rework of an existing
> one, a new card or passive for a subclass, or a change to the **base class**. At its heart is a set of
> **evaluation questions** (§3): a game-design review that asks whether things make sense together. It is
> not a template to copy. Around the questions sit the process, what Baldur's Gate 3 rewards and
> punishes, how to balance, and what can be built.
>
> This file holds **criteria and method only** — no subclass, card, myth or deck is named in it. The
> current state of each subclass lives in `05.02_Subclasses/<name>.md` (including its Depth audit); the
> current state of the base class in `05.01_Class/Arcana_Base_Class.md`. When a rule here proves wrong, rewrite
> the rule — don't append history.

---

## The golden rule

**Fun comes first.** When the questions pull in different directions, the design that best joins the
card, the references, the archetype and the Aspect — the one that is most fun to play — wins, as long as
it stays balanced (§8). Every question below serves this one.

---

## 0. When this applies

| The work | What it goes through |
|---|---|
| **New subclass** | The whole process (§1), every question (§3), a written spec |
| **Rework of a subclass** | Audit against §3 first; then the process from the phase the audit points at |
| **New key feature, spell, passive or awaken power** for a subclass | §1.2 brainstorm (short), the §3 questions it touches, §7 placement, §8 balance |
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

1. **Read before asking.** `05.00_READ_FIRST.md`, `01-identity-and-lore.md`, `02-systems.md`,
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
  by grepping vanilla data and `57.05_Osiris/OSIRIS.md` / `57.03_Khonsu_Thoth/KHONSU.md`, then reported in one or two lines.
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
| 1 | **The card** | What does the card really mean (tradition, imagery, numbers, reversed meaning)? Which readings can become mechanics? |
| 2 | **References** | Myth, science, fiction and powers that carry the same idea (§2) |
| 3 | **The axis** | Which question does the player answer that no other subclass asks? (§2.3) |
| 4 | **The mechanic** | The state only this subclass creates and reads, and its one core rule |
| 5 | **Mechanic rules** | Timing, stacking, targets, simultaneous events, what ends it |
| 6 | **Role** | Damage, control, support, tank: primary and secondary styles |
| 7 | **Chassis** | Secondary ability, saves, armour, weapons, skills, preset, sound set, colour |
| 8 | **Progression** | What arrives at each level, and which feature ties the mechanic together (§7.4) |
| 9 | **Awakening** | Goal, three tiers, Aspect card (§9) |
| 10 | **Spell and passive pool** | Derived from the axes and verbs of the mechanic (§7) |
| 11 | **Texts** | Names, descriptions, tag line (§10) |
| 12 | **Numbers** | Balance pass (§8) |

### 1.3 Synthesis

Assemble the decisions into the **Identity Sheet** (§2) and a **description of the mechanic** (core
rule, edge rules, worked example). Every decision has an id and a source (author / proposal accepted).

### 1.4 Analysis

Run the design through **every question in §3** and the **BG3 facts in §4**. Present only what is
missing or borderline, with a proposed fix. A gap in identity or in the mechanic sends the work back to
the brainstorm rung it belongs to; a gap in numbers stays in §8.

### 1.5 Spec

Write `21.04_Subclasses/ (design specs)YYYY-MM-DD-<subclass>-design.md` in English: the **design document**, a
complete description of the subclass — everything it is and does, explained in full, with no audit in it.
Sections: Identity · Chassis · Mechanic (rules, worked example, resolution order, edge cases) · the
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

The Identity Sheet records the answers to the descriptive questions of §3. "To decide" is fine during
the brainstorm, not in a spec.

| Field | What it contains | A good answer |
|---|---|---|
| **The card and why** | Number, name, and the readings of the card that the subclass carries | Each carried reading points at a mechanic. A reading with no mechanic is decoration; drop it or give it one |
| **Aspect and why** | The Aspect's name, and why that word | The Aspect is **what the mechanic makes the player do or feel**; it couldn't be swapped with another subclass's without anyone noticing |
| **Relation to Mystra and the Weave** | How this destiny was woven: which part of the Weave it holds or pulls | One sentence that could only be written about this subclass; uses the class's Weave vocabulary |
| **Myth** | Greek mythology first (the class's planned boons are Greek), others where they fit better | A named figure or story that lends a specific rule, name or image |
| **Science / real source** | A real-world model (psychology, physics, astronomy, biology…) when one exists | It structures the content rather than just naming it: a model with N parts gives the subclass N pieces |
| **Fictional characters** | The characters it draws on | Each lends something named: an ability, a fantasy, a visual |
| **Reference powers** | The abilities borrowed and what became of each | Clear line from source to card |
| **Archetype** | The role-playing image in a few words | Recognisable without the card: a stranger could picture it from the words alone |
| **Fantasy line** | One sentence the player should feel | Short; would fit on the mod page |
| **Role** | Primary and secondary role in a party of four | Fills a gap or plays a shared role in a new way (§2.3) |
| **Specialist or versatile** | Whether it does one thing very well or many things well enough | Said plainly, and the kit matches it |
| **Play style** | What the player plans and decides | Names the main decision of a turn |
| **Combat style** | Range, position, action economy, tempo across a fight | Concrete: where they stand, what turn 1 and turn 3 look like |
| **Strengths** | What it does best | A few, each traceable to a mechanic |
| **Weaknesses** | What beats it | Real and visible in play: a weakness that never shows up isn't one |
| **Chassis** | Secondary ability, saves, armour, weapons, skills list, preset, starting gear, sound set | Secondary ability serves the mechanic, not only the theme. Saves, armour and weapons match the role |
| **Colour, emoji, VFX** | Hex colour, emoji, Aspect VFX | Distinct from every other subclass's colour on black; matches the emblem art |
| **Voice** | Class description, panel line, tag line (§10) | Same register as the other subclasses |

### 2.1 Reading a tarot card for mechanics

- Start from the **traditional meaning** (upright and reversed), then the **imagery** (the classic decks and
  the older ones they adapt), then **number and astrology** (the traditional correspondences).
- Mechanics hide in the imagery: a figure in motion, something passed from one hand to another,
  something hidden behind something else. Name the image when using it.
- Prefer a reading that **creates a decision** over one that creates a bonus.

### 2.2 References

- **Myth:** look for the figure that *does* the card's idea, not only the one with the right name.
- **Science:** a real model gives free structure: a fixed set of elements, distances, opposites, cycles.
  If the model has N parts, the content can have N pieces — and that justifies the size of the list.
- **Fiction:** take characters whose *kit* expresses the idea (games, comics, anime, films). Borrowed
  ability names are fine when they become our own mechanic.

### 2.3 The axis — what makes a subclass different

Each subclass owns **one axis**: the question the player keeps answering. Two subclasses may share a role
(two controllers) but should not share an axis. Examples of axes:

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
subclass is designed or audited). A new subclass's axis should be free, or the overlap argued and
accepted.

---

## 3. Evaluation questions (the Depth Model)

A game-design review: the questions ask whether the pieces make sense together and are fun. They don't
prescribe a shape. Some questions are **descriptive** (which card, which characters) — their answers go
in the Identity Sheet (§2). The others are **evaluative**: in an audit each gets ✅ yes · ⚠️ partly ·
❌ no, with one line of evidence. A ❌ is a prompt for the brainstorm, not a veto; when a question and
fun disagree, the golden rule decides.

### Identity and fun (I)

| # | Question | A good answer |
|---|---|---|
| I1 | **Is it cool and fun to play?** | The author and a playtester want to play it again; the turns feel good, not just efficient |
| I2 | **Does it have a defined, striking characteristic?** | Someone who played it once can describe it in one sentence |
| I3 | **What is its archetype, and how is it built into the abilities?** | The archetype shows in what the abilities *do*, not only in their names |
| I4 | **Does playing the mechanic feel like its Aspect?** | Using the mechanic is the Aspect; it isn't a stat bonus with a mood word on it |
| I5 | **Does it ask the player a question no other subclass asks?** | Its axis (§2.3) is free, or the overlap is argued |
| I6 | **Do its names belong to its theme, and to no other subclass's?** | Every name comes from its card, its references or its science |

### Sources (S)

| # | Question | A good answer |
|---|---|---|
| S1 | **Which tarot card is it based on, and why?** | The link between the main mechanic and the card fits in one sentence |
| S2 | **Which elements of the card are adapted into it?** | Each reading or image used points at a rule, a feature or a name |
| S3 | **Which fictional characters is it based on?** | Characters whose kit or story carries the same idea |
| S4 | **Which elements of those characters are adapted into it?** | Each character lends something named: an ability, a fantasy, a visual |
| S5 | **Is it based on something real — a science, a field of study, something from life?** | A real model that gives the content its structure, when one fits |
| S6 | **Does a myth lend it a rule, a name or an image?** | A named figure or story, Greek first, that does the card's idea |

### Mystra and the Weave (W)

| # | Question | A good answer |
|---|---|---|
| W1 | **What is its relation to Mystra's universe?** | One sentence on how this destiny was woven, which could only be written about this subclass |
| W2 | **How does it weave the Weave into its features?** | The Weave shows in the mechanic and the texts — threads pulled, woven, cut, braided — not only in the lore |

### The mechanic (M)

| # | Question | A good answer |
|---|---|---|
| M1 | **Does it have a new, exclusive mechanic?** | A state only this subclass creates and reads |
| M2 | **Can the core rule be said in one sentence, and is it explained once?** | One passive explains it; cards don't carry their own exceptions |
| M3 | **Do its features work like gears that talk to each other?** | Some features create the state, some change it, some spend it, and each feeds or reads another |
| M4 | **Does the mechanic grow along the journey, with something new at each odd level?** | The subclass at 9 plays differently from 3, not just with bigger dice |
| M5 | **Do allies and enemies both take part?** | Both sides of the field matter to the mechanic, or leaving one out is a deliberate choice |
| M6 | **Is every chain finite, with its order defined?** | No loops, no double counting; simultaneous events resolve in a stated order |

### Key features and passives (K)

A **key feature** is a signature spell: one only this subclass has, which defines how it plays by
creating, changing or spending the mechanic's state.

| # | Question | A good answer |
|---|---|---|
| K1 | **Does it have key features that drive the new mechanic?** | The mechanic is played through them, not beside them |
| K2 | **Are its key features exclusive and unique?** | None of them would fit another subclass, or a vanilla class, unchanged |
| K3 | **Does it have a feature that ties its core mechanic together completely?** | One key feature completes the kit and makes the gears turn as a whole — what the project calls the subclass's **ultimate**. *Key*, not necessarily the strongest |
| K4 | **Do its passive features make sense with the mechanic?** | Each passive belongs to the mechanic or the identity, not to a generic list |
| K5 | **Does it get passive features that drive the core of the mechanic?** | Passives unlock new rules of the mechanic, not only bigger numbers |
| K6 | **Can a turn combine two plays early on, and is there something to fall back on?** | A bonus-action option early, and a cantrip (or equivalent) as the baseline turn |

### Play (P)

| # | Question | A good answer |
|---|---|---|
| P1 | **What combat style is it focused on?** | Range, position and tempo are clear, and the kit supports them |
| P2 | **Is it a specialist or versatile?** | The answer is deliberate and the kit matches it |
| P3 | **What does it bring to the party that no one else does?** | Something the other three feel on their own turns |
| P4 | **Does it play the mechanic from level 1?** | A level-1 character already uses it |
| P5 | **Does the setup pay back inside a typical fight?** | The payoff lands while the fight still matters (§4.2) |
| P6 | **Is there a real decision most turns?** | Usually more than one sensible play; never one solved answer |
| P7 | **Can the player read the state in BG3's UI?** | On the portrait or status icon, with a number when it counts, named in the combat log |
| P8 | **Does it work when the AI ignores it?** | No effect needs the enemy to cooperate |
| P9 | **Are its weaknesses real and visible?** | The listed weaknesses show up in normal play |
| P10 | **Does the console edition play the same mechanic?** | Nothing in the mechanic needs the PC deck |

### Awakening (A)

| # | Question | A good answer |
|---|---|---|
| A1 | **Does the Awakening goal count uses of the mechanic?** | It can only be reached by playing the mechanic |
| A2 | **Do the tier bonuses push the theme of the mechanic?** | Each tier changes how the mechanic runs; no ability score bonus (§9) |
| A3 | **Does the Aspect card play the mechanic, differently from the feature of K3?** | A once-per-combat spell that uses the mechanic in a way nothing else in the kit does |

### Balance (B)

| # | Question | A good answer |
|---|---|---|
| B1 | **Is its power in each level band close to a vanilla class of the same role?** | No spikes or dead levels against the benchmark (§8.3) |
| B2 | **Are combos priced at their best case minus the setup?** | No combo is free once assembled |
| B3 | **Is every self-feeding loop capped?** | Per turn, per chain or a maximum count |
| B4 | **Where unsure, does it lean weak?** | Nothing ships on "we'll nerf it later" |

### Technical (T)

| # | Question | A good answer |
|---|---|---|
| T1 | **Does the mechanic run without Script Extender?** | Stats, Osiris, Khonsu and LSX only |
| T2 | **Is there a vanilla example, or a cheap test, for each uncertain piece?** | Nothing is built from the schema alone |
| T3 | **Do large families of statuses or spells come from a generator?** | One table, regenerated; nothing hand-copied by the dozen |
| T4 | **Do ids, prefixes and helpers follow the glossary?** | No new naming patterns |

### Documentation (D)

| # | Question | A good answer |
|---|---|---|
| D1 | **Is the Identity Sheet complete?** | Every field of §2 answered in the spec, nothing "to decide" |
| D2 | **Do the spec, the subclass file, the wiki and the game files agree?** | The spec follows §1.5, `05.02_Subclasses/<name>.md` exists with its Depth audit, and no source contradicts another |

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
  should pay back by round 3, and nothing core should wait past round 4.
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

- **Turn-based determinism** rewards mechanics the player can plan two turns ahead.
- **Status durations as visible numbers** make timers and countdowns readable for free.
- **Positioning** (allies included) is a decision players already enjoy.
- **Status types and stack types** (`Additive`, `Overwrite`, `StackPriority`) carry a lot of logic without
  scripts.

---

## 5. The Arcana framework every subclass plugs into

These are fixed by the class. A subclass designs *within* them; changing them is a base-class change (§6).

- **Spellcasting is Intelligence** for every subclass; each subclass has one secondary ability, the one
  its mechanic leans on.
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
- **What never belongs to it:** a combat mechanic. If a base feature starts doing a subclass's job, it
  takes away that subclass's identity (opportunity cost of design).
- **Impact matrix — required for every base change.** One row per subclass: what the change does to its
  mechanic, its numbers, its readability and its console version. A change that helps one subclass much
  more than the others needs a reason.
- Base-class changes go through the same brainstorm and approval; numbers through §8 against every
  subclass at once.

---

## 7. Building the spell and passive pool

### 7.1 The size is a consequence

There is **no standard number of cards** per subclass or per level. The pool is derived from the
mechanic:

1. **Content axis** — what varies between states (a fixed set of types, states or forms). If a real
   model fixes N parts, the pool may have N pieces of that kind.
2. **Time / intensity axis** — short vs long, weak vs strong, if the mechanic has one.
3. **Verbs** — what the player does to the state (create, move, change, copy, delay, spend). **One card
   per verb at most**; a verb already covered by a rule doesn't need a card.
4. **Roles** — check that something creates the state, something changes it and something spends it
   (M3), and that every stretch of the journey has something new (M4).

A caster whose variety *is* the mechanic can have a large pool; a martial subclass whose mechanic lives
in its attacks needs few cards. Both are fine when the size is explained.

### 7.2 Every card answers

- Which axis or verb is it? Does it create, change or spend the state?
- Which **action** (Action, Bonus Action, Reaction) and which **limiter** (none, Concentration,
  once per turn/round/combat, Short/Long Rest, Unique)?
- Why at this level, and what does it add that the cards before it didn't?
- What does it do in a level-12 deck: still a choice, or dead weight?

### 7.3 Spread of action types

- A **bonus-action** option early, so turns combine two plays.
- A **cantrip** as the baseline when the subclass casts; it is what the turn falls back on.
- Reactions are cards with a per-round limit (`02-systems.md` §8).

### 7.4 The journey from level 1 to 12

Guidance on where things tend to land; the mechanic decides the details.

- **Level 1:** the mechanic is already playable, explained on one passive, with key features to play it
  and a cantrip to fall back on.
- **Odd levels:** each brings something new — a rule, a verb, a key feature — so the subclass changes as
  it grows. Avoid piling several new things on one level while the next is empty.
- **The feature that ties it together** (K3, the subclass's **ultimate**): an exclusive key feature built
  on the mechanic, the piece that completes the kit. It needn't be the strongest thing in the kit, and
  it lands where the kit needs it.
- **Level 11:** the capstone, the end of the journey — typically Long Rest and Unique.
- **Level 12:** Awakening Tier III.
- **Even levels** belong mostly to the base class; a subclass uses one when it has a reason.
- **A feature that uses a resource** (a meter, charges) fills it by playing the mechanic, shows it on a
  status with a count, and resets it when combat ends.
- **The ultimate and the Aspect card** never do the same thing; how they differ is the subclass's choice.

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
- **A good place to aim:** 90–100 % of the benchmark in every band, leaning weak; levels 5 and 11,
  vanilla's own spikes, may go a little above.
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

- **The goal counts the mechanic** (A1): the mechanic's own state created, spent or resolved. Never a
  generic metric the subclass would reach without playing its mechanic.
- **Three goals, one per tier** (levels 3/7/12), cumulative within a fight. Check with §8 that Tier I is
  reachable in a normal fight at level 3 and Tier III in a long one at level 12.
- **Tier names** come from the card or its myth, in order (the card's figures or positions, the myth's
  characters in story order).
- **Tier bonuses push the theme of the mechanic** (A2). Tier I: a change to how the mechanic runs.
  Tier II: the mechanic spreads or protects. Tier III: the theme at its peak, with something only this
  subclass could have. **No tier gives an ability score bonus** (+3 to an ability, its modifier to
  damage), not even as an addition: it is generic and makes every subclass's peak feel the same.
- **The Aspect card** (Tier I, Created, 0 Threads, 0 slots, once per combat) is a spell that plays the
  mechanic (A3). It can turn a fight, but it needn't be the strongest thing in the kit, and it never
  does the same thing as the ultimate.

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
`57.05_Osiris/OSIRIS.md`, `57.03_Khonsu_Thoth/KHONSU.md`, the vanilla data in `C:\Projetos\BG3 Modding\Base Game BG3\Assets\`,
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
| Families of statuses or spells | A generator script in `82_Automation/stats/` with a table; patches applied from it |

- **Simultaneous events:** Osiris runs one event at a time. When several things "happen at once"
  (two timers end together), the design defines a **queue**: collect, resolve in a fixed order, remove
  each before its effect fires, then process what it caused as the next wave.

---

## 12. Auditing an existing subclass

1. Fill the Identity Sheet (§2) from the subclass file, the wiki and the game files.
2. Answer every question of §3: the descriptive ones in the Identity Sheet, the evaluative ones with
   ✅ yes · ⚠️ partly · ❌ no and one line of evidence each.
3. Write the result in the subclass file under **Depth audit**, with the date.
4. Each ❌ becomes a question for a raising brainstorm; the raising goes through the process (§1) and
   gets its own spec.

---

## 13. Traps

| Don't | Because | Do |
|---|---|---|
| Copy another subclass's cards, mechanic or numbers | Each subclass is its own archetype | Derive the kit from its own mechanic |
| Give a tier a stat bonus (+3 to an ability, even as an extra) | Generic; every subclass's peak would feel the same (I4, A2) | Push the mechanic's theme (§9) |
| Use randomness in a mechanic built on foresight or planning | Breaks readability and the Aspect | Deterministic rules, visible state |
| Design around choosing a slot level | Arcana always casts at its highest slot | Scale by slot level; vary by card |
| Need two statuses per effect without a strong reason | Doubles the scope and the things to read | One status, its duration and stack type carry the logic |
| Leave simultaneous resolution undefined | Double counting, skipped effects, loops | Define the queue and the order (§11) |
| Let a chain feed itself without a cap | Snowball (B3) | Cap per turn or per chain |
| Rely on the AI reacting to the mechanic | It won't (P8) | Effects that work when ignored |
| Borrow a word from another subclass's world | Muddles both identities (I6) | Names from the card, its myth or its science |
| Ask several things in one brainstorm message | The author answers one and the rest get lost | One question per message |
| Put numbers in the brainstorm | Anchors the discussion on placeholders | Numbers in §8, after the design is approved |

---

## 14. Checklist (use during analysis and audits)

```
Identity & fun  I1 fun · I2 striking trait · I3 archetype · I4 aspect · I5 axis · I6 vocabulary
Sources         S1 card · S2 card elements · S3 characters · S4 character elements · S5 real source · S6 myth
Mystra          W1 relation to Mystra · W2 the Weave in the features
Mechanic        M1 new & exclusive · M2 one rule · M3 gears · M4 grows · M5 both sides · M6 bounded
Key features    K1 drive the mechanic · K2 exclusive · K3 ties it together · K4 passives fit · K5 passives drive · K6 two plays + fallback
Play            P1 combat style · P2 specialist/versatile · P3 party · P4 level 1 · P5 fight length · P6 decisions · P7 readable · P8 vs AI · P9 weaknesses · P10 console
Awakening       A1 goal · A2 tiers · A3 Aspect card
Balance         B1 curve · B2 combos · B3 loops · B4 lean weak
Technical       T1 no SE · T2 proven · T3 generated · T4 conventions
Documentation   D1 Identity Sheet · D2 sources agree
Also            Texts · Test plan
```
