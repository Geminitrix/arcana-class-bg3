---
id: 21.04/_SUBCLASS_STANDARD
version: 2
owner: Lead Class Designer
status: proposed v2 — written 2026-10-15 (ARC-0016, Owner decisions D1–D6); in force for new work once the Owner approves it. Audits made against v1 stay valid (same ids)
updated: 2026-10-15
supersedes: v1 (2026-10-11) — 90_ARCHIVE/93_Old_Versions/2026-10-15_SUBCLASS_STANDARD_v1/
companion: 21.04/_SUBCLASS_REFINING.md (how to diagnose and improve something that already exists)
---

# Subclass Design Standard — how the Arcana creates and judges a design

> How every design for the **Arcana** is made and judged: a new subclass, a new feature, card, passive or status, or a
> change to the **base class**. At its heart is the **Depth Model** (§3): evaluation questions, each with what a good
> answer looks like, how to show it and what grounds it. It is a review, not a template to copy.
>
> **This file holds criteria and method only.** No subclass, card, myth or deck is named in it; examples are generic.
> **Numbers never live here** (ADR-0005): values are in `25_Master_Data`, the costing currency and formulas in
> `22.06/Arcana_Power_Budget.md`. The current state of the mod is in `05_LIVE_CONTEXT`. Each subclass's design is in its
> dossier `21.04_Subclasses/<S>/` (`DESIGN.md` + `DECISIONS.md`, ADR-0009). The research behind the questions is in
> `27.01`–`27.08`; sources and what was actually read are in `27.07`.
>
> **Improving something that exists** (a rework, a review, a refinement) follows `_SUBCLASS_REFINING.md`, which uses
> these questions and does not repeat them.

**Citing this file.** Inside this file a question is written `K3`. Anywhere else, new documents write **`DM-K3`**
(Depth Model) so it can't be confused with probe ids, decision ids, tiers or suggestion ids that use the same letters.
Documents written before 2026-10-15 keep their bare ids. Section numbers §1.2, §2.3, §3 and §15 are stable; the rest
moved in v2 (Appendix A).

## Contents

0. Scope and principles · 1. The process · 2. The identity layer · **3. The Depth Model** · 4. The mechanic layer ·
5. Designing features, by type · 6. Felt progression · 7. Aspect Awakening · 8. What Baldur's Gate 3 rewards and
punishes · 9. The Arcana framework and base-class changes · 10. Balance — method · 11. Complexity budget ·
12. Names, texts and voice · 13. Technical feasibility · 14. Traps · **15. Studio gates and the one-page checklist** ·
16. Sources · Appendix A — migration from v1

---

## 0. Scope and principles

### 0.1 Which process applies

| The work | What it goes through |
|---|---|
| **New subclass** | The whole process (§1), every question (§3), `DESIGN.md` + `DECISIONS.md` |
| **Rework, review or refinement** of a subclass, the base class, a feature, a card or a status family | `_SUBCLASS_REFINING.md` (it picks the questions of §3 that apply) |
| **New feature, card, passive or status** for a subclass | §1.2 brainstorm (short), the §5 checklist of its type, the §3 questions it touches, §6 placement, §10 balance |
| **Base-class change** (chassis, resources, deck rules, Awakening framework, utilities) | §9.3 impact matrix across every subclass, then §3 and §10 for what it touches |
| **Number-only change** | §10 (show the arithmetic in the `22.06` currency, write the value in `25`) and a test plan (§10.5) |
| **Text-only change** | §12 and the Narrative gate (§15) |

Nothing reaches the game files without the Owner's approval of the design first. Approval of one design never extends
to the next.

### 0.2 The golden rule and five principles

**Fun comes first.** When the questions pull in different directions, the design that best joins the card, the
references, the archetype and the Aspect — the one that is most fun to play — wins, as long as it stays balanced (§10).
Every question below serves this one.

| # | Principle | Why (card) |
|---|---|---|
| 1 | **Experience first.** Every feature starts with one sentence of target aesthetic ("it should feel…"); rules and numbers come after | MDA (`27.01`) |
| 2 | **One rule, no exceptions.** The core rule fits in one sentence and is true for every feature | Cognitive load, lenticular design (`27.08`) |
| 3 | **A cost is a trade, not a fine.** The player chooses what they give up; nothing takes their turn away without their say | Loss aversion (`27.08`) |
| 4 | **Growth the player feels.** Each level-up says something new and the peak of the journey happens in play | Competence, peak-end (`27.08`) |
| 5 | **The game files are the truth.** Every BG3 fact and every engine piece is shown in vanilla data (`56`) or tested | `CLAUDE.md` rule 6, `AGENTS.md` §4 |

### 0.3 Pillars — open dependency

The class's **experience pillars** (3–5 promises of what playing the Arcana feels like, in the format of `27.01`) are
meant to live in `21.01_Vision_and_Pillars.md`, which **does not exist yet**. The question is open for the Owner in
`10.06/Open_Questions.md`. Until it is answered, Design gate question 1 (§15) checks the **subclass fantasy only**. The
**identity pillars** already written in `31.01_Lore_Bible.md` §1 (Mystra and the Weave, the tarot, the seer, a
destiny chosen at level 1) frame the identity layer (§2); they describe content, not the experience, so they don't
replace `21.01`.

---

## 1. The process

```
Frame → Brainstorm → Synthesis → Analysis → Design document → Plan → Build → Test → Record and propagate
                ↑__________________|  (analysis can send it back)
```

### 1.1 Frame

1. **Read before asking:** `05.00_READ_FIRST.md`, the base class (`05.01_Class/Arcana_Base_Class.md`), the identity
   and voice of the class (`31.01_Lore_Bible.md`), the role matrix (`21.08_Subclass_Matrix.md`), the class systems
   (`21.05_Class_Features/Systems_TO_REVIEW.md` and `26.01`), the open questions (`10.06/Open_Questions.md`), and the
   dossier `21.04_Subclasses/<S>/` if it exists. Earlier sessions may already have decided things: honour them, or raise
   the conflict openly.
2. **Classify** the work (§0.1) and say the classification out loud so the Owner can correct it.
3. **List what is already decided** and what is open before the first question.

### 1.2 Brainstorm — the conversation

The brainstorm is a dialogue between the Owner and Claude, slow on purpose. Ideas come from both sides and get built
on, not replaced.

**How each turn works**
- **One question per message.** A topic that needs more goes into several messages.
- **Multiple choice when it can be:** 2–4 options, each with what it gives *and* what it costs, the recommendation
  first and the reason for it. Open questions are fine for taste and identity.
- **Make it concrete.** A worked turn of play beats an abstract rule. When the Owner gives an example, check it against
  the rule and say whether it matches.
- **Bring ideas, not only questions.** Research the source (card, myth, science, fiction) and offer what it suggests
  (§2). When an idea conflicts with a recorded decision or with another subclass, say so and offer a way to reconcile.
- **Check feasibility as you go**, but don't let it lead: a line or two after grepping vanilla data (§13).
- **No numbers** beyond placeholders written `‹…›`. Numbers come in the balance pass (§10).
- **Keep a decision log** in the conversation (`D1, D2…`, one line each, re-shown as a table every few decisions) and
  write each decision **the moment it is taken** in the dossier's `DECISIONS.md`, under the dossier's own prefix
  (ADR-0009).
- **Admit mistakes plainly** and fix them in the next message. A recommendation the Owner rejects is dropped, not
  re-argued.

**The design ladder.** Each rung depends on the ones above it. Skip a rung only when it is already decided.

| # | Rung | The question it answers | Where |
|---|---|---|---|
| 1 | **The card** | What does the card mean (tradition, imagery, number, reversed)? Which readings can become mechanics? | §2.1 |
| 2 | **References** | Myth, science, fiction and powers that carry the same idea | §2.2 |
| 3 | **The axis** | Which question does the player answer that no other subclass asks? | §2.3 |
| 4 | **The mechanic** | The state only this subclass creates and reads, and its one core rule | §4 |
| 5 | **Mechanic rules** | Timing, stacking, targets, simultaneous events, what ends it | §4.5 |
| 6 | **Role** | Primary and secondary role in a party of four | §2.4 |
| 7 | **Chassis** | Secondary ability, saves, armour, weapons, skills, preset, sound set, colour | §2.8 |
| 8 | **Progression** | What arrives at each level, the headline of each level-up, the ultimate's place | §6 |
| 9 | **Awakening** | Goal, three tiers, Aspect card | §7 |
| 10 | **Spell and passive pool** | Derived from the axes and verbs of the mechanic | §5 |
| 11 | **Texts** | Names, descriptions, tag line | §12 |
| 12 | **Numbers** | The balance pass | §10 |

### 1.3 Synthesis

Assemble the decisions into the **Identity Sheet** (§2.8) and a **description of the mechanic**: core rule, edge rules,
resolution order and a worked example (§4). Every decision has an id and a source (Owner, or proposal accepted).

### 1.4 Analysis

Run the design through **every question of §3**, the **BG3 facts of §8** and the **complexity budget of §11**. Present
only what is missing or borderline, with a proposed fix. A gap in identity or mechanic sends the work back to its rung
of the ladder; a gap in numbers stays in §10.

### 1.5 The design document

The dossier `21.04_Subclasses/<S>/` holds two files (ADR-0009):

- **`DESIGN.md`** — the current design in the present tense, complete and readable on its own. Sections: Identity ·
  Chassis · Mechanic (rules, worked example, resolution order, edge cases) · the subclass's own systems · Spells ·
  Passives · Statuses · Aspect Awakening · Progression (with the headline of each level) · How it plays · Text ·
  Technical pattern (statuses, Osiris, generator, ids) · Open · To test in game. No audit inside it.
- **`DECISIONS.md`** — the log, one line per decision with its source and date. A decision that replaces another keeps
  both lines; `DESIGN.md` shows only the result.

Self-review the design for placeholders, contradictions and ambiguity before the Owner reviews it.

### 1.6 Plan, build, test

- An implementation plan with **one gate per stage**; a `[fechado]` message is one stage.
- A spec in `55` and a **Toolkit guide** from `55/_TEMPLATE_TOOLKIT_GUIDE.md`: the point-by-point view the Owner uses to
  enter the feature by hand. Numbers in the guide come from `25` (ADR-0008).
- Families of more than a handful of statuses or spells come from a **generator script** in `82_Automation/stats/`;
  change the generator's table, never the generated output.
- **One rule per in-game test.** The test says what to do and what proves it works.

### 1.7 Record and propagate

- The design result goes to the dossier (`DESIGN.md`, `DECISIONS.md`) and to every artifact downstream of it, **by its
  owner's role**, following `00.08_Propagation_Map` (progression `21.03`, matrix `21.08`, spell sheets `23.02`, master
  data `25`, balance `22.05`, economy `26.01`, texts `31.02`/`32.01`/`33.03`, icons `42.04`, tests `61.02`).
- The **Depth audit** (§3) is a working result: record it in the ticket and in the dossier (`DECISIONS.md`, a dated
  "Depth audit" section, or the review document of `_SUBCLASS_REFINING.md`). `05.02_Subclasses/<S>.md` is written
  only by the Context Keeper: hand it the audit (`HANDOFF_…_to_ContextKeeper`).
- Answered questions leave `10.06/Open_Questions.md`; the patch notes get the intent line.

---

## 2. The identity layer

### 2.1 Reading the card

- Start from the **traditional meaning**, upright and reversed; then the **imagery**; then **number and astrology**
  (the traditional correspondences).
- **Primary sources first** (S7): the Rider–Waite–Smith imagery and Waite's own key (Waite, 1910); a modern reading of
  the Major Arcana (Pollack, 1980); the Thoth names and correspondences, where a card is renamed or re-read (Crowley,
  1944); the older Marseille tradition the decks adapt. Wikis and card-meaning sites are starting points, never the
  source of a reading.
- Mechanics hide in the imagery: a figure in motion, something passed from one hand to another, something hidden behind
  something else. **Name the image** when using it.
- Prefer a reading that **creates a decision** over one that creates a bonus.

### 2.2 References

- **Myth:** look for the figure that *does* the card's idea, not only the one with the right name. Greek first (the
  class's planned boons are Greek), from a primary text — Hesiod, Apollodorus, Homer in a standard translation — before
  any compendium.
- **Science:** a real model gives free structure: a fixed set of elements, distances, opposites, cycles. If the model
  has N parts, the content can have N pieces — and that justifies the size of the list.
- **Fiction:** take characters whose *kit* expresses the idea (games, comics, anime, films). Borrowed ability names are
  fine when they become our own mechanic.
- **Every reference lends something named** — a rule, a name or an image. A reference that lends nothing is
  decoration: drop it.

### 2.3 The axis — what makes a subclass different

Each subclass owns **one axis**: the question the player keeps answering. Two subclasses may share a role (two
controllers) but should not share an axis.

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
| Balance | Who rises, who falls, and when do they cross? |

The axis each subclass owns is recorded in the **Axis** row of `21.08_Subclass_Matrix.md`. A new subclass's axis
should be free, or the overlap argued and accepted. A feature may borrow another axis for one decision without making
it the subclass's axis.

### 2.4 Archetype, fantasy, role and Aspect

- **Archetype:** the role-playing image in a few words, **recognisable without the card** — a stranger could picture it
  from the words alone (the 30-second test of `27.05`).
- **Fantasy line:** one sentence the player should feel; short enough for the mod page.
- **Role:** primary and secondary role in a party of four. The 4th Edition roles (Controller, Defender, Leader,
  Striker) are a useful vocabulary for "what it brings", not a requirement (`27.08`).
- **Aspect:** what the mechanic makes the player **do or feel**. It couldn't be swapped with another subclass's Aspect
  without anyone noticing.

### 2.5 Mystra and the Weave

- One sentence on how this destiny was woven — which part of the Weave it holds or pulls — that could only be written
  about this subclass (W1).
- The Weave shows in the mechanic and the texts — threads pulled, woven, cut, braided — not only in the lore (W2). The
  class's Weave vocabulary is in `31.01` §2.

### 2.6 Character and voice

- The subclass speaks in **one voice** across the class description, the panel line and the tag line (the shared
  formulas of `31.01` §5), its tooltips and its sound set (I8).
- Say what the character **is not**: the limits keep the voice from drifting toward another subclass (`27.05`, fantasy
  workshop step 2).
- Lore is revealed through use — descriptions, effects, choices — not text dumps (`27.05`).

### 2.7 Ludonarrative harmony — the mechanic tells the story

A theme stated only in a paragraph is decoration (`27.05`). The design passes when:

- each mechanic expresses the theme, and the player **acts like the character the fantasy promises** while playing it
  (I7);
- icon, VFX, sound and text tell the same thing as the rule;
- what players do freely matches what the lore claims (no rule rewards the opposite of the fantasy — the failure
  Hocking named *ludonarrative dissonance*, `27.08`);
- levels 1–12 tell an arc (§6.8).

### 2.8 The Identity Sheet

The Identity Sheet records the answers to the descriptive questions of §3. "To decide" is fine during the brainstorm,
never in `DESIGN.md`.

| Field | What it contains | A good answer |
|---|---|---|
| **The card and why** | Number, name, and the readings the subclass carries, with their source (§2.1) | Each carried reading points at a mechanic, a feature or a name |
| **Aspect and why** | The Aspect's name, and why that word | What the mechanic makes the player do or feel (§2.4) |
| **Mystra and the Weave** | How this destiny was woven | One sentence only this subclass could have (§2.5) |
| **Myth** | Figure or story, and its primary source | It lends a specific rule, name or image |
| **Science / real source** | A real-world model, when one exists | It structures the content |
| **Fictional characters** | The characters it draws on | Each lends something named |
| **Reference powers** | The abilities borrowed and what became of each | A clear line from source to card |
| **Archetype** | The role-playing image in a few words | Recognisable without the card |
| **Fantasy line** | One sentence the player should feel | Would fit on the mod page |
| **Role** | Primary and secondary role | Fills a gap or plays a shared role in a new way |
| **Specialist or versatile** | Does one thing very well, or many things well enough | Said plainly; the kit matches it |
| **Play style** | What the player plans and decides | Names the main decision of a turn |
| **Combat style** | Range, position, action economy, tempo | Concrete: where they stand, what turn 1 and turn 3 look like |
| **Strengths / weaknesses** | What it does best; what beats it | Each traceable to a mechanic; weaknesses visible in normal play |
| **Chassis** | Secondary ability, saves, armour, weapons, skills, preset, starting gear, sound set | The secondary ability serves the mechanic; saves, armour and weapons match the role |
| **Colour, emoji, VFX** | Hex colour, emoji, Aspect VFX | Distinct from every other subclass's colour on black (`31.01` §6) |
| **Voice** | Class description, panel line, tag line; what it is not | Same register as the other subclasses (§2.6) |

---

## 3. The Depth Model — evaluation questions

### 3.1 How to use it

- **Descriptive** questions (which card, which characters) are answered in the Identity Sheet (§2.8).
- **Evaluative** questions get a mark and **one line of evidence** each. The evidence points at something checkable: a
  file and section, a decision id, a count, a test result. A mark without evidence is not an audit.

| Mark | Meaning |
|---|---|
| ✅ | Yes |
| ⚠️ | Partly — say which part fails |
| ❌ | No |
| ➖ | Does not apply to this piece (an audit of one card skips the Awakening questions) |
| 🧪 | Untested — the answer depends on play that hasn't happened; never upgrade it to ✅ on paper |

- A ❌ is a prompt for the brainstorm, not a veto; when a question and fun disagree, the golden rule decides.
- **Playtest column.** Where a question can be measured in play, the table names the metric and the result that would
  prove the design **wrong**. Tests follow `27.06` (decision first, one rule per test).
- New questions get new ids; an existing id never changes meaning. Questions marked *(v2)* are new in this version.

### 3.2 Identity and fun (I)

| # | Question | A good answer | Evidence · wrong if | Grounded in |
|---|---|---|---|---|
| I1 | **Is it cool and fun to play?** | The Owner and a playtester want to play it again; the turns feel good, not only efficient | Playtest: "would you play it again?"; wrong if the answer is no or the turns are described as chores | MDA (`27.01`); SDT (`27.08`) |
| I2 | **Does it have a defined, striking characteristic?** | Someone who played it once can describe it in one sentence | Ask after one combat; wrong if the description names only numbers | Clarity (`27.08`) |
| I3 | **What is its archetype, and how is it built into the abilities?** | The archetype shows in what the abilities *do*, not only in their names | The Identity Sheet line and the features that carry it | `27.05` |
| I4 | **Does playing the mechanic feel like its Aspect?** | Using the mechanic *is* the Aspect; not a stat bonus with a mood word on it | The Aspect named in the core rule's verb | `27.05` |
| I5 | **Does it ask the player a question no other subclass asks?** | Its axis (§2.3) is free, or the overlap is argued | The axis row of `21.08` | Strategic balance (`27.03`) |
| I6 | **Do its names belong to its theme, and to no other subclass's?** | Every name comes from its card, its references or its science | A name list with the source of each | `27.05` |
| I7 *(v2)* | **Does the mechanic tell the story?** | Playing the rule makes the player act like the character the fantasy promises; nothing rewards the opposite | Each core rule mapped to a line of the fantasy; wrong if the optimal play contradicts the fantasy | Ludonarrative harmony (`27.05`, `27.08`) |
| I8 *(v2)* | **Is the voice one voice?** | Class description, panel line, tag line and tooltips sound like the same character, in the class's register | The three texts side by side; the "is not" list | `31.01` §5, `31.03` |

### 3.3 Sources (S)

| # | Question | A good answer | Evidence | Grounded in |
|---|---|---|---|---|
| S1 | **Which tarot card is it based on, and why?** | The link between the main mechanic and the card fits in one sentence | The sentence | §2.1 |
| S2 | **Which elements of the card are adapted into it?** | Each reading or image used points at a rule, a feature or a name | Reading → feature table | §2.1 |
| S3 | **Which fictional characters is it based on?** | Characters whose kit or story carries the same idea | The list | §2.2 |
| S4 | **Which elements of those characters are adapted into it?** | Each character lends something named | Character → feature table | §2.2 |
| S5 | **Is it based on something real?** | A real model that gives the content its structure, when one fits | The model and the part → piece mapping | §2.2 |
| S6 | **Does a myth lend it a rule, a name or an image?** | A named figure or story, Greek first, that does the card's idea | The figure and what it lends | §2.2 |
| S7 *(v2)* | **Are the card and myth readings traced to a primary source?** | Each reading cites the deck or text it comes from, not a website | Citation per reading; wrong if a reading has only a wiki behind it | Source weights (`27.07`) |

### 3.4 Mystra and the Weave (W)

| # | Question | A good answer | Evidence | Grounded in |
|---|---|---|---|---|
| W1 | **What is its relation to Mystra's universe?** | One sentence on how this destiny was woven, which could only be written about this subclass | The sentence | `31.01` §2 |
| W2 | **How does it weave the Weave into its features?** | The Weave shows in the mechanic and the texts, not only in the lore | Features and texts that use the Weave vocabulary | `31.01` §2, §2.5 |

### 3.5 The mechanic (M)

| # | Question | A good answer | Evidence · wrong if | Grounded in |
|---|---|---|---|---|
| M1 | **Does it have a new, exclusive mechanic?** | A state only this subclass creates and reads | The state and who creates/reads it (§4.3) | §4.1 |
| M2 | **Can the core rule be said in one sentence, and is it explained once?** | One passive explains it; cards don't carry their own exceptions | The sentence and where it is taught | Cognitive load, lenticular design (`27.08`) |
| M3 | **Do its features work like gears that talk to each other?** | Some create the state, some change it, some spend it, some read it; each feeds or reads another | The gears table (§4.3) with no empty column | Feedback structures (`27.08`) |
| M4 | **Does the mechanic grow along the journey, with something new at each odd level?** | The subclass at 9 plays differently from 3, not just with bigger dice | Level table; see J1–J7 for how the growth is *felt* | §6 |
| M5 | **Do allies and enemies both take part?** | Both sides of the field matter, or leaving one out is a deliberate choice | Each state's effect on an ally and on an enemy; harmful effects on allies listed | §4.4 |
| M6 | **Is every chain finite, with its order defined?** | No loops, no double counting; simultaneous events resolve in a stated order | The resolution order (§4.5); wrong if a test shows the same trigger twice in one event | §4.5, §13 |
| M7 *(v2)* | **Is the core rule true for every feature?** | No feature quietly behaves differently from the rule; a real exception is written into the rule | The exception hunt (§10.3): every feature checked against the sentence | Lenticular design, New World Order (`27.08`) |

### 3.6 Key features and passives (K)

A **key feature** is a signature spell: one only this subclass has, which defines how it plays by creating, changing,
spending or reading the mechanic's state. The **ultimate** is the key feature that ties the kit together (K3).

| # | Question | A good answer | Evidence | Grounded in |
|---|---|---|---|---|
| K1 | **Does it have key features that drive the new mechanic?** | The mechanic is played through them, not beside them | Gears table | §4.3 |
| K2 | **Are its key features exclusive and unique?** | None would fit another subclass, or a vanilla class, unchanged | Comparison with the matrix and vanilla | §5.1 |
| K3 | **Does it have a feature that ties its core mechanic together completely?** | One key feature — the **ultimate** — completes the kit and makes the gears turn as a whole. *Key*, not necessarily the strongest | The ultimate and the gears it touches | §5.5 |
| K4 | **Do its passive features make sense with the mechanic?** | Each passive belongs to the mechanic or the identity, not to a generic list | Passive → mechanic mapping | §5.2 |
| K5 | **Does it get passive features that drive the core of the mechanic?** | Passives unlock new rules of the mechanic, not only bigger numbers | Rule passives vs number passives count | §5.2 |
| K6 | **Can a turn combine two plays early on, and is there something to fall back on?** | A bonus-action option early, and a cantrip (or equivalent) as the baseline turn | Level of the first bonus-action option; the fallback's value against the benchmark | §5.1 |
| K7 *(v2)* | **Does the ultimate read the state?** | Its effect depends on what the player built (how much, which kind, where); the play that leads to it matters | The ultimate's effect with the state present and absent; wrong if the best target is simply the biggest enemy, whatever it carries | Kit coherence (`27.08`); B2 |

### 3.7 Play (P)

| # | Question | A good answer | Evidence · wrong if | Grounded in |
|---|---|---|---|---|
| P1 | **What combat style is it focused on?** | Range, position and tempo are clear, and the kit supports them | Identity Sheet; kit ranges | §2.8 |
| P2 | **Is it a specialist or versatile?** | Deliberate, and the kit matches | Identity Sheet | §2.8 |
| P3 | **What does it bring to the party that no one else does?** | Something the other three feel on their own turns | Features that act on allies' turns | `27.01` (relatedness) |
| P4 | **Does it play the mechanic from level 1?** | A level-1 character already uses it | Level-1 kit | §6.3 |
| P5 | **Does the setup pay back inside a typical fight?** | The payoff lands while the fight still matters | Timeline against the reference fight of `22.06` §1; playtest: turn of first payoff; wrong if it comes after the fight is usually decided | §8.2 |
| P6 | **Is there a real decision most turns?** | Usually more than one sensible play; never one solved answer | Playtest: time to decide, variety of plays; wrong if the same play is made every turn | Interesting decisions (`27.08`); B5 |
| P7 | **Can the player read the state in BG3's UI?** | On the portrait or status icon, with a number when it counts, named in the combat log | The status flags (§5.3); playtest: the player answers the turn's question by looking at the screen | Clarity (`27.08`) |
| P8 | **Does it work when the AI ignores it?** | No effect needs the enemy to cooperate | Each effect with an enemy that doesn't react | §8.2 |
| P9 | **Are its weaknesses real and visible?** | The listed weaknesses show up in normal play | Playtest: weaknesses observed | §2.8 |
| P10 | **Does the console edition play the same mechanic?** | Nothing in the mechanic needs the PC deck | Every effect in Stats/Osiris/Khonsu/LSX | §9.1 |
| P11 *(v2)* | **Is every cost felt as a trade, not a punishment?** | The player chooses what to give up and when; no feature removes their turn or their options without a choice | Each cost stated as "you give X to get Y"; playtest: wrong if players describe the cost as "the game takes my turn" | Loss aversion, framing (`27.08`) |
| P12 *(v2)* | **Does the PC deck leave the axis intact?** | The card the plan needs is in hand often enough that the decision stays one of skill, not of draw | The probability check of `_SUBCLASS_REFINING.md`; playtest (PC): share of turns where the needed card was missing | Skill vs chance (`27.08`); §9.2 |

### 3.8 Felt progression (J) *(v2)*

M4 asks whether the mechanic grows. These questions ask whether the **player feels** it grow (§6).

| # | Question | A good answer | Evidence · wrong if | Grounded in |
|---|---|---|---|---|
| J1 | **Does every odd level have a headline?** | A new verb, rule or button the player can name — not only "the table got bigger" | The headline column of the level table (§6.2); wrong if a level's headline is only a number | Competence (`27.08`) |
| J2 | **Do the states grow, at breakpoints the player is told about?** | Vertical growth (the same states get stronger) at announced levels, alongside the horizontal growth (new verbs) | The breakpoint levels and the level-up text that announces them | Competence, goal gradient (`27.08`) |
| J3 | **Does the signature button evolve in ranks?** | One button the player keeps from early on, upgraded at a few points of the journey | The rank table (§6.4) | Felt progression (`27.08`) |
| J4 | **Is the complexity curve smooth?** | New concepts per level-up are counted and spread; no level brings a cliff | The concept count per level (§6.5); wrong if one level-up carries far more new concepts than the levels around it | Cognitive load (`27.08`) |
| J5 | **Is every rule usable when it is taught?** | No rule is explained before the player has the pieces to use it | Rule → first level it can happen | Cognitive load (`27.08`) |
| J6 | **Does the peak of the journey happen in a typical fight?** | The level-12 promise shows up in an ordinary fight, not only in a long one | The peak timeline (§6.7); playtest at level 12: wrong if the peak shows in a minority of fights | Peak-end (`27.08`) |
| J7 | **Do levels 1–12 read as an arc?** | Introduce, develop, turn, conclude — the level-up texts tell it | The arc table (§6.8) | Kishōtenketsu (`27.08`), `27.05` |

### 3.9 Awakening (A)

| # | Question | A good answer | Evidence | Grounded in |
|---|---|---|---|---|
| A1 | **Does the Awakening goal count uses of the mechanic?** | It can only be reached by playing the mechanic | The goal and what increments it | §7 |
| A2 | **Do the tier bonuses push the theme of the mechanic?** | Each tier changes how the mechanic runs; no ability score bonus | Each tier's change, read against the core rule | §7 |
| A3 | **Does the Aspect card play the mechanic, differently from the ultimate (K3)?** | A once-per-combat spell that uses the mechanic in a way nothing else in the kit does | Aspect card vs ultimate side by side | §5.6 |

### 3.10 Balance (B)

| # | Question | A good answer | Evidence · wrong if | Grounded in |
|---|---|---|---|---|
| B1 | **Is its power in each level band close to a vanilla class of the same role?** | No spikes or dead levels against the benchmark | The band table of `22.05/<S>.md`; playtest metrics of `22.06` | §10.4 |
| B2 | **Are combos priced at their best case minus the setup?** | No combo is free once assembled | The costing in the `22.06` currency | §10.2 |
| B3 | **Is every self-feeding loop capped?** | Per turn, per chain, a maximum count, or a net cost | The loop hunt (§10.3); wrong if a test shows the same benefit every turn for no cost | Feedback loops (`27.08`, `27.04`) |
| B4 | **Where unsure, does it lean weak?** | Nothing ships on "we'll nerf it later" | Values marked "watch" have a test | `27.03` |
| B5 *(v2)* | **Does any decision have the same right answer every time?** | Every option of a choice is right in some situation | The dominant-option hunt (§10.3); playtest: pick rates | Interesting decisions (`27.08`), `27.03` warning signs |
| B6 *(v2)* | **Is every bonus alive in a typical fight?** | No duration longer than the fight it serves, no value that never grows while vanilla grows | The dead-bonus hunt (§10.3) | Competence (`27.08`) |
| B7 *(v2)* | **If a resource carries over between fights, is the exception justified?** | Logged in `DECISIONS.md` with three answers: uses per day against `22.06`, a counter visible out of combat, the first and the fourth fight of a day play alike | The three answers; playtest: uses per day | §5.7 (Owner decision D4, ARC-0016) |

### 3.11 Complexity (X) *(v2)*

| # | Question | A good answer | Evidence | Grounded in |
|---|---|---|---|---|
| X1 | **Does each new active action earn its hotbar slot by level 12?** | Each one is used in some fights and does something no other button does | The action count and the job of each (§11) | Cognitive load, complexity creep (`27.08`) |
| X2 | **Does each resource the player tracks have a visible counter?** | A number on a status or a resource bar, in and out of combat when it persists | The resource list with where each shows | `27.04`, clarity (`27.08`) |
| X3 | **Could a new player name the subclass's signature after one combat?** | Yes, in their own words | Playtest question after the first fight | Clarity (`27.08`) |

### 3.12 Technical (T)

| # | Question | A good answer | Evidence | Grounded in |
|---|---|---|---|---|
| T1 | **Does the mechanic run without Script Extender?** | Stats, Osiris, Khonsu and LSX only | Where each effect lives | §9.1 |
| T2 | **Is there a vanilla example, or a cheap test, for each uncertain piece?** | Nothing is built from the schema alone | The path of the example in `56`, or the test id | §13 |
| T3 | **Do large families of statuses or spells come from a generator?** | One table, regenerated; nothing hand-copied by the dozen | The generator in `82_Automation/stats/` | §13 |
| T4 | **Do ids, prefixes and helpers follow the glossary?** | No new naming patterns | Ids against `33.03` and ADR-0002 | §12 |

### 3.13 Documentation (D)

| # | Question | A good answer | Evidence | Grounded in |
|---|---|---|---|---|
| D1 | **Is the Identity Sheet complete?** | Every field of §2.8 answered in `DESIGN.md`, nothing "to decide" | The sheet | §2.8 |
| D2 | **Do the design, the decisions, the live context, the wiki and the game files agree?** | `DESIGN.md` follows `DECISIONS.md`; `05.02/<S>.md` matches the game; no source contradicts another | A diff of the claims; open contradictions listed | §1.7 |

---

## 4. The mechanic layer

### 4.1 An exclusive state

The mechanic is a **state only this subclass creates and reads** (M1): a status, a mark, a position, a meter. A
mechanic made only of vanilla effects in a new order is a combo, not a mechanic.

### 4.2 One rule, no exceptions

- The core rule fits in **one sentence** and is taught **once**, on one passive (M2).
- It is **true for every feature** (M7). When a feature needs to behave differently, either the rule says so in its
  sentence, or the feature changes. A card that carries "except…" in its tooltip is a sign the rule is wrong.

### 4.3 The gears

Fill this table for every design. Each column has at least one feature, and every feature sits in at least one column.

| Creates the state | Changes the state | Spends the state | Reads the state |
|---|---|---|---|
| … | … | … | … (the ultimate is here — K7) |

A feature that touches no column is outside the mechanic: it belongs to the identity (and says so) or it leaves.

### 4.4 Both sides of the field

For each state: what it does on an ally, what it does on an enemy, and what happens if the player puts it on the
"wrong" side. Effects that **harm allies** are listed and either chosen on purpose or blocked (M5).

### 4.5 Chains and resolution order

- Every chain is **finite** (M6): a payoff that creates the state that feeds it has a cap (B3).
- **Simultaneous events** have a stated order. Osiris runs one event at a time, so when several things "happen at
  once" the design defines a **queue**: collect, resolve in a fixed order, remove each before its effect fires, then
  process what it caused as the next wave (§13).
- What **ends** the state is listed: expiry, cleanse, death, end of combat (and §5.7 for meters).

### 4.6 A worked example

`DESIGN.md` carries at least one turn-by-turn example of the mechanic in a fight, with the state shown after each
action. The example is checked against the rule sentence.

---

## 5. Designing features, by type

### 5.1 Card or spell

| Check | The question |
|---|---|
| Verb | Does it create, change, spend or read the state (§4.3)? Which axis or verb of the pool? |
| Action | Action, Bonus Action or Reaction — and does the bonus-action space stay uncrowded (`27.04`)? |
| Cost | Slot or Thread cost, and any extra cost (HP, the state) — stated as a trade (P11) |
| Limiter | None, Concentration, once per turn / round / combat, Short or Long Rest, Unique — one limiter, not two that double-count (`22.06`) |
| Target and range | Who and how far; self, ally, enemy, area; friendly fire |
| Resolution | Attack roll or saving throw (which ability), and what a success does |
| Scaling | The Arcana always casts at its highest slot (§9.1): the card scales by slot level through generated variants; no design asks the player to pick a level |
| Anchor | The vanilla spell of the same level that does something comparable — read in `56`, priced in `22.06` (the 5e *Dungeon Master's Guide* ch. 9 gives the same advice: compare with an existing spell of that level) |
| Placement | Why at this level, and what it adds that the cards before it didn't (J1) |
| Late value | What it does in a level-12 deck: still a choice, or dead weight? |
| Tooltip | One read explains it; no paragraph of exceptions (`27.01`) |

### 5.2 Passive

- **Rule passives** explain one rule once and unlock it at a level (K5). **Number passives** only add numbers: a
  balance knob, not a design — use them sparingly.
- A passive the player should see is visible on the character sheet (`Properties` `Highlighted`, vanilla `Passive.txt`);
  tier and technical passives stay hidden, and the visible Awakening passive explains the goals.

### 5.3 Status

| Check | The question |
|---|---|
| Type | Use the **vanilla status type** that fits — vanilla data has, among others, `BOOST`, `INCAPACITATED`, `FEAR`, `KNOCKED_DOWN`, `INVISIBLE`, `EFFECT`, `POLYMORPHED` (`Status_<TYPE>.txt` in `56`) — rather than imitating its behaviour; players and the AI already understand them |
| Stacking | `StackId` shared (one at a time, `StackPriority` for tiers) or separate (they coexist); `StackType` as vanilla uses it (`Overwrite`, `Additive`, `Ignore`, `Stack`) |
| Timing | `TickType` (`StartTurn`, `EndTurn`, `StartRound`, `EndRound`), and `TickingWithSource` when it should count on the caster's turn |
| Duration | Against the reference fight of `22.06` §1: a duration longer than the fight is a dead bonus (B6) |
| Reading | Icon, `ForceOverhead` when it must show on the character, and none of `DisableOverhead`, `DisablePortraitIndicator`, `DisableCombatlog` on a status the player must read (P7) |
| Ending | What removes it, and whether expiry does something (`OnRemoveFunctors` with the `TimeOut` cause — a cleanse doesn't trigger it) |
| Count | One status per effect unless there is a strong reason; a family comes from a generator (T3) |
| Both sides | What it does on an ally and on an enemy (§4.4) |

### 5.4 Reaction or interrupt

- **Trigger:** what fires it, and whose source counts (an ally's own spell must not trigger an "enemy hits" reaction).
- **Limit:** a per-round limit, as every Arcana reaction has (`21.05_Class_Features/Systems_TO_REVIEW.md`, reactions
  table).
- **Competition:** one Reaction per round, shared with vanilla reactions (opportunity attacks among them) — what does
  the player give up?
- **Prompt fatigue:** an interrupt that asks every round is a cost to the player's attention; prefer clear triggers.
- **Works when ignored:** the AI doesn't play around it (P8).

### 5.5 The ultimate

- It **ties the kit together** (K3) and **reads the state** (K7): its effect depends on what the player built.
- It needn't be the strongest thing in the kit; it lands where the kit needs it (§6.3).
- It may evolve in **ranks** across the journey (J3, §6.4).
- It never does the same thing as the Aspect card (A3).

### 5.6 The Aspect card

- Granted at Awakening Tier I: a **Created** card, free of slots and Threads, **once per combat** (the class framework,
  `21.05_Class_Features/Systems_TO_REVIEW.md`, Aspect Awakening).
- It **plays the mechanic** in a way nothing else in the kit does (A3). It can turn a fight, but it needn't be the
  strongest thing in the kit.
- Ultimate and Aspect card differ by **what** they do (one target vs the field, advance vs invert, build vs spend…);
  the choice is the subclass's.

### 5.7 Resources and meters

- A subclass resource **fills by playing the mechanic**, never by a generic metric (A1's logic).
- It has a **visible counter** (X2): a status with a count, shown in combat — and out of combat too if it persists.
- **It resets at combat end by default** (Owner decision D4). Carrying it over is an **exception**, logged in the
  dossier's `DECISIONS.md` with three answers (B7): uses per adventuring day against the `22.06` budget; a counter the
  player sees out of combat; the first and the fourth fight of a day play alike.
- Its **cost reads as a trade** (P11): the player chooses to pay or to hold; a full meter never silently takes the
  player's options away.
- Every resource has a **source and a sink** (`27.04`); fewer distinct resources means less to track.

### 5.8 The size of the pool

There is **no standard number of cards** per subclass or per level. The pool is derived from the mechanic:

1. **Content axis** — what varies between states (a fixed set of types, states or forms). If a real model fixes N
   parts, the pool may have N pieces of that kind.
2. **Time / intensity axis** — short vs long, weak vs strong, if the mechanic has one.
3. **Verbs** — what the player does to the state (create, move, change, copy, delay, spend). **One card per verb at
   most**; a verb already covered by a rule doesn't need a card.
4. **Roles** — something creates, changes, spends and reads the state (M3), and every stretch of the journey has
   something new (J1).

A caster whose variety *is* the mechanic can have a large pool; a martial subclass whose mechanic lives in its attacks
needs few cards. Both are fine when the size is explained — and the complexity budget (§11) still applies.

**Action spread:** a bonus-action option early (two plays a turn); a cantrip or equivalent as the baseline turn (K6);
reactions with a per-round limit (§5.4).

---

## 6. Felt progression

A subclass that grows on paper but not in the player's hands has failed the journey. The research behind this section
(competence, flow, cognitive load, peak-end, goal gradient, kishōtenketsu) is in `27.08`.

### 6.1 The level table with headlines (J1)

`DESIGN.md` carries the level table with a **headline** column: what the player would say changed.

| Level | What arrives | Headline the player feels | Kind |
|---|---|---|---|
| 1 | … | "I can …" | verb / rule / button / growth |
| 3 | … | … | … |

A headline names a **verb, a rule, a button or an announced growth**. "More targets", "bigger dice" or "one more
card of the same kind" alone are not headlines.

### 6.2 Vertical and horizontal growth (J2)

- **Horizontal:** new verbs, rules and buttons (the headlines).
- **Vertical:** the subclass's **own states get stronger** at a few breakpoints, so they keep pace with vanilla spells
  that scale. Prefer the breakpoints the player already knows from vanilla scaling, so one rhythm teaches both.
- **Announce it:** a growth the player isn't told about is invisible. The level-up text names it.

### 6.3 The level map

Guidance on where things tend to land; the mechanic decides the details.

- **Level 1:** the mechanic is already playable, explained on one passive, with key features to play it and a fallback
  turn (P4, K6).
- **Odd levels:** each brings a headline. Avoid piling several new things on one level while the next is empty.
- **The ultimate** lands where the kit needs it (§5.5).
- **Level 11:** the capstone, the end of the journey — typically Long Rest and Unique — **and it does something on the
  turn it is cast**.
- **Level 12:** Awakening Tier III (§7).
- **Even levels** belong mostly to the base class (feats arrive at 4, 8 and 12 in vanilla — `Progressions.lsx`,
  `AllowImprovement`). A subclass uses an even level only with a reason written in `DECISIONS.md` (for example, a
  vertical breakpoint).

### 6.4 The signature button in ranks (J3)

One button the player keeps from early on and that **upgrades** at a few points — a small version early, the full
version mid-journey, the peak at the end. The player feels progression most clearly in a tool they already use. Fill
the rank table:

| Level | Rank | What it does now |
|---|---|---|
| … | 1 | … |

### 6.5 The complexity curve (J4)

Count, for each level-up, the **new concepts** the player must hold: a new rule, a new state, a new interaction, a new
button. Outcomes the player can predict from what they already know (a stronger form of a known effect) count less than
new names. Working memory holds a handful of chunks (`27.08`), so:

- spread new concepts; no level-up should carry far more than the levels around it;
- give a dense level a theme that groups its pieces (one idea, several buttons);
- the count goes in `DESIGN.md` next to the level table.

### 6.6 Teach a rule when it is usable (J5)

A rule taught before the player can use it costs memory and is forgotten by the time it matters. Teach it on the
level that brings the pieces to use it, and let that level carry it as its headline.

### 6.7 The peak must happen (J6)

People remember an experience by its peak and its end (`27.08`). Check, against the reference fight length of
`22.06` §1, **on which turn** each Awakening tier and the level-12 peak become available. If the peak needs a fight
longer than usual, or two timers to line up, the journey ends flat. Fixes that keep the cost: make reaching the tier
itself the trigger, lower the goal, or let the peak use what the fight already built.

### 6.8 The arc (J7)

Read levels 1–12 as a four-part arc (kishōtenketsu, `27.08`): **introduce** the mechanic, **develop** it, **turn** it
(a twist that changes how it is played), **conclude** it at the peak. The card's own faces (upright and reversed) or its
myth often give the four names. The arc is a lens, not a quota: it feeds the level-up texts (§12) and the Narrative
gate.

---

## 7. Aspect Awakening

- **The goal counts the mechanic** (A1): the mechanic's own state created, spent or resolved — never a generic metric
  the subclass would reach without playing its mechanic.
- **Three goals, one per tier** at levels 3, 7 and 12 (the class framework), cumulative within a fight. Check with the
  peak timeline (§6.7) that Tier I is reachable in a normal fight at level 3 and Tier III in a normal fight at level 12.
- **The goal shows its progress** (X2; goal gradient, `27.08`): the player sees how close the next tier is.
- **Tier names** come from the card or its myth, in order (the card's figures or positions, the myth's characters in
  story order).
- **Tier bonuses push the theme of the mechanic** (A2). Tier I: a change to how the mechanic runs. Tier II: the
  mechanic spreads or protects. Tier III: the theme at its peak, with something only this subclass could have, and a
  moment the player sees when it wakes (J6). **No tier gives an ability score bonus**, not even as an addition: it is
  generic and makes every subclass's peak feel the same.
- **The Aspect card** comes with Tier I (§5.6).

---

## 8. What Baldur's Gate 3 rewards and punishes

Design for the game the player is in.

**How a BG3 fact is cited** (Owner decision, ARC-0016): each fact names **two sources** — the **bg3.wiki** page, the
reference for the rules as the player sees them, and the **game file** that proves it. When they disagree, **the game
file wins** (`CLAUDE.md` rule 6) and the divergence is written down (§8.7). A fact found in neither is marked
**observed** or **estimate** and is corrected by playtest. Game-file paths are relative to the local extraction
`C:\Projetos\BG3\Base Game BG3\Assets\` (`56` in the project). Wiki pages were checked on 2026-10-15.

### 8.1 The turn

- **Action, Bonus Action and Reaction** are resources that refill every turn. Wiki: [Actions](https://bg3.wiki/wiki/Actions).
  File: `ActionPoint`, `BonusActionPoint`, `ReactionActionPoint` with `ReplenishType` `Turn`
  (`Shared_Extracted/Public/Shared/ActionResourceDefinitions/ActionResourceDefinitions.lsx`). Extra actions are the
  most valuable thing in the game: cost every effect in the action it uses (`22.06` §4). A bonus-action card lets a
  turn combine two plays; `Shove` and `Jump` are common bonus actions too
  ([Shove](https://bg3.wiki/wiki/Shove), [Jump](https://bg3.wiki/wiki/Jump)), so the bonus action is contested.
- **Status turns:** a status lasts N turns and counts down at the bearer's turn start (the default) or end, or at the
  round's start or end; a status that ticks at turn start effectively lasts one turn less than it says. Wiki:
  [Conditions](https://bg3.wiki/wiki/Conditions). File: `TickType` values `StartTurn`, `EndTurn`, `StartRound`,
  `EndRound` in vanilla `Status_*.txt`; `TickingWithSource` makes it count on the **source's** turn. The remaining
  turns show on the status icon — free readability for anything timed.
- **Reactions** fire on others' turns; the Arcana's reactions each have a per-round limit (§5.4).
- **Initiative:** a d4 plus the Dexterity modifier, rolled when combat begins; party members who share an initiative
  result act together, in any order. Wiki: [Initiative](https://bg3.wiki/wiki/Initiative). File: `InitiativeDie`
  (`Shared_Extracted/Public/Shared/Stats/Generated/Data/Data.txt`); the shared turn is not in the data files. A
  subclass that acts first sets up before enemies move.

### 8.2 The fight

- **Length:** the reference number of rounds per fight and fights per day are declared in `22.06` §1 (an
  **estimate**, corrected by playtest). Setup should pay back while the fight still matters; nothing core should wait
  for a fight longer than the reference (P5).
- **Turn 1 matters.** Every subclass needs something useful on its first turn; a pure-setup turn 1 must be paid back
  later with interest.
- **Party of four.** A subclass shines by what it does for the other three too (P3).
- **The AI doesn't play around states** (**observed**): enemies don't read the mod's mechanics. Design effects that
  work when ignored (P8).

### 8.3 The dice

- **Bounded accuracy** keeps attack and save bonuses small (`27.02`), so **Advantage and Disadvantage** are the
  biggest levers — and several sources of Advantage on one roll give nothing more. Wiki:
  [Advantage](https://bg3.wiki/wiki/Advantage). Flat bonuses to attack, DC or AC must justify their effect on the hit
  curve.
- **High ground is a flat modifier, not Advantage:** a bonus to attack rolls from above, a penalty from below. Wiki:
  [High ground](https://bg3.wiki/wiki/High_ground). File: `HighGroundAttackRollBonus`, `LowGroundAttackRollPenalty`
  (`Data.txt`).
- **Concentration:** one spell at a time; damage forces a Constitution save. Wiki:
  [Concentration](https://bg3.wiki/wiki/Concentration). File: the `IsConcentration` spell flag (vanilla `Spell_*.txt`).
  It limits simultaneity, not uses.
- **Damage types and resistances** vary by enemy and act; check the vanilla stats of the enemies that matter before
  relying on a type. No type is assumed "rarely resisted" without that check.

### 8.4 The world

- **Verticality and terrain:** height changes hit chances (§8.3) and ranges; shove and jump are bonus actions most
  characters have (§8.1). Mechanics that use position feel native.
- **Surfaces:** flat layers on the ground that affect whoever stands in them, created by many spells and reacting to
  elements (water electrified by lightning, oil set alight). Wiki: [Surfaces](https://bg3.wiki/wiki/Surfaces). An
  effect that creates or reacts to a surface plugs into a system the player already knows.
- **Vanilla conditions** are understood by players and the AI; use the vanilla status type that fits (§5.3). Wiki:
  [Conditions](https://bg3.wiki/wiki/Conditions). File: `Status_<TYPE>.txt`.

### 8.5 Pacing across a playthrough

- **The level cap is 12.** Wiki: [Experience](https://bg3.wiki/wiki/Experience). File: `MaxXPLevel`
  (`Shared_Extracted/Public/SharedDev/Stats/Generated/Data/XPData.txt`; see §8.7). The class must be complete at 12,
  and the 13–20 module never carries the core (`21.07`).
- **Feats** at class levels 4, 8 and 12 for every class, with extra ones for two martial classes. Wiki:
  [Feats](https://bg3.wiki/wiki/Feats). File: `AllowImprovement` in vanilla `Progressions.lsx`. Vanilla's big steps
  (the third-level and sixth-level spells for full casters, Extra Attack for martials) are where the benchmark class
  jumps — read them in `Progressions.lsx` for the class you compare with (§10.4).
- **Rests are cheap.** Two Short Rests per Long Rest; a Long Rest costs camp supplies (more on harder difficulties),
  and without them a partial rest restores only part of the resources. Wiki: [Resting](https://bg3.wiki/wiki/Resting).
  File: `MaxShortRestPoints` (`Data.txt`); the supply cost was not checked in the files. A once-per-Long-Rest limit
  restricts much less than at a tabletop; once-per-combat and per-turn limits do the real work.
- **Out of combat** is half the game: dialogue checks, exploration, puzzles. The base class owns the seer's utility; a
  subclass adds at most one utility, and only if it reflects its identity.

### 8.6 What to exploit

- **Turn-based determinism** rewards mechanics the player can plan two turns ahead.
- **Status durations as visible numbers** make timers and countdowns readable for free.
- **Positioning**, allies included, is a decision players already enjoy.
- **Status and stack types** carry a lot of logic without scripts (§5.3).

### 8.7 Divergences between the wiki and the game files

Recorded when found; the game file wins. Add a row whenever a check disagrees.

| Fact | bg3.wiki says | Game file says | Reading |
|---|---|---|---|
| Experience per level | Level 12 at a total far above the table below (page *Experience*) | `SharedDev/…/XPData.txt` lists lower totals (the `Shared` table stops at level 5) | The cap (12) agrees. The XP totals in the extracted tables don't match the wiki: the live table may be elsewhere. Not used by any design question — don't rely on either total until checked in game |

---

## 9. The Arcana framework and base-class changes

### 9.1 What the class fixes

A subclass designs *within* these; changing them is a base-class change (§9.3). The values live in `05.01`, `25` and
`21.05_Class_Features/Systems_TO_REVIEW.md`.

- **Spellcasting is Intelligence** for every subclass; each subclass has one secondary ability, the one its mechanic
  leans on.
- **Woven Spell Slots** share one level and **every card is cast at the highest slot level**. There is no "cast lower
  or higher" choice: designs that ask the player to pick a slot level don't work. Cards scale by slot level through
  generated upcast variants; statuses get one version per spell level.
- **Threads and the deck (PC edition):** card cost, the per-turn Thread curve, copies per card, hand and draw rules
  are in `21.05_Class_Features/Systems_TO_REVIEW.md` and `26.01/2026-09-17-deck-core-design.md`. Cheap cards make a turn
  of several plays possible.
- **Keywords** (Unique, Created, Choose, Fleeting, Fated…) are shared vocabulary (`33.03/MOD_TERMINOLOGY.md`): use them
  before inventing new ones.
- **Aspect Awakening:** three tiers at levels 3, 7 and 12, a goal per tier counted in Osiris, the Aspect card at Tier I
  (§7).
- **Two editions:** every gameplay effect lives in Stats, Osiris, Khonsu or LSX; Lua only manages the PC deck (P10, T1).

### 9.2 The deck and the axis (P12)

The PC deck adds a draw to every turn. For a subclass whose axis is **planning** (combination, timing), the draw can
replace the decision with luck: the right piece is not in hand. Check it with the probability tool of
`_SUBCLASS_REFINING.md` before release. Remedies, in order of cost: measure first; fewer, broader cards; a card with the
`Choose` keyword that fetches the piece; one card that opens a list of choices. Remedies that change deck rules are a
base-class change (§9.3).

### 9.3 Base-class changes

The base class is the **seer**: divination and out-of-combat utility, the resources, the deck, the Awakening framework.
The subclasses carry the combat.

- **Belongs to the base class:** utilities, familiars, divination features, the class's spell picks, resources and
  their curves, deck rules, keywords, the Awakening framework.
- **Never belongs to it:** a combat mechanic. If a base feature starts doing a subclass's job, it takes away that
  subclass's identity.
- **Impact matrix — required for every base change**, one row per subclass:

| Subclass | What it does to the mechanic | To the numbers (`22.05`) | To readability | To the console edition | To the PC deck |
|---|---|---|---|---|---|
| … | … | … | … | … | … |

  A change that helps one subclass much more than the others needs a reason.
- Base-class changes go through the same brainstorm and approval; numbers through §10 against every subclass at once;
  propagation through the "base class" or "system" change type of `00.08`.

---

## 10. Balance — method

Balance serves the experience: first say what the player should feel, then choose numbers. The currency, the
assumptions and every formula are in `22.06/Arcana_Power_Budget.md`; values are written once, in `25_Master_Data`. This
section holds only the method.

### 10.1 Before any number

- Declare the assumptions you use (fights per day, rounds per fight — `22.06` §1) and show the result again with
  other assumptions if the conclusion depends on them.
- Convert everything to the one currency of `22.06` §2; price non-damage effects with **virtual damage** (`27.03`).

### 10.2 Costing rules

- Costs = benefits. A card's cost includes its resource, its action, its limiter and its conditions.
- A restricted benefit is never a cost and is worth more than zero.
- A choice between A or B costs at least the more expensive one.
- **Combos under the player's control** are priced at their best case minus the cost of assembling them (B2).
- **Overpowered** (too much benefit) and **undercosted** (too little cost) are different fixes: change the one that is
  wrong.

### 10.3 The hunts

| Hunt | What to look for | Question |
|---|---|---|
| **Loops** | A refund, a resource that pays for itself, a state that comes back on its own, a payoff that creates its own trigger | B3, M6 |
| **Exceptions** | A feature that behaves differently from the core rule's sentence | M7 |
| **Dominant option** | A decision whose right answer never changes (always release, always pick A) | B5, P6 |
| **Dead bonuses** | A duration longer than the fight it serves; a value that never grows while vanilla grows | B6, J2 |
| **Carried resources** | A meter or charge that survives the fight | B7 |
| **Harm to allies** | A state that can land on the party by rule, not by choice | M5 |

Every positive loop gets a **brake**: once per turn, once per chain, a maximum count, or a net cost (`27.04`).

### 10.4 The benchmark

- Compare each **level band** against a vanilla class of the **same role** (a damage caster against the full casters, a
  healer against the healing cleric, a tank against the heavy-armour classes), read from the vanilla files, never from
  memory.
- Sum the expected value per adventuring day of everything the subclass has at each band; peaks are explosive levels,
  valleys are dead ones (B1).
- The **target band** and its tolerance are suggestions in `22.06` and `27.03` until an ADR fixes them; lean weak where
  unsure (B4).
- Compare the subclasses of the Arcana with each other the same way.

### 10.5 Verification

Every number ships with how it will be checked: the fight to run, the metric, and **what result would prove it wrong**
(`27.06`). The test cases go to `61.02`.

---

## 11. Complexity budget

Adding is cheap; removing is expensive (`27.01`). The questions are X1–X3 and J4; fixed limits exist only by ADR.

- **Count the active actions** the subclass adds to the hotbar by level 12, and the job of each (X1).
- **List the resources** the player must track and where each shows (X2).
- **Count the new concepts per level-up** (§6.5, J4).
- **Ask after one combat** whether a new player can name the signature (X3).

The master spec (`00.01`) suggests limits for new actions per subclass and for resources; they stay suggestions until
an ADR fixes them. A subclass over the suggestion argues it in `DECISIONS.md`.

---

## 12. Names, texts and voice

- **English, in Larian's voice:** the rules are in `31.03_BG3_Style_Guide/ENGLISH_WRITING_STYLE.md` (first sentence
  states origin or nature, second gives the gameplay promise).
- Subclass texts follow the shared formulas of `31.01_Lore_Bible.md` §5 (class description, panel line, tag line); the
  writing voice is `31.01` §7.
- **Names belong to the theme** (I6): a word that fits another subclass's world better goes back to the brainstorm.
  Prefer names from the card, its myth or its science; check `33.03/MOD_TERMINOLOGY.md` for collisions.
- **Ids** follow `33.03/Glossary_Game_and_Code_Names.md` and ADR-0002; the literal prefix decides what a spell is to the
  deck (T4).
- **Numbers in text** come from `25`, never typed by hand (ADR-0005).
- **Rule and flavour** are separate; the level-up texts can carry the arc (§6.8).
- The **Narrative gate** is recorded in `32.04_Narrative_Review/` (§15).

---

## 13. Technical feasibility

Feasibility is checked during the brainstorm in a line or two, and in full during analysis.

**Where to look:** `57.05_Osiris/OSIRIS.md`, `57.03_Khonsu_Thoth/KHONSU.md` and the other cards of `57`; the vanilla
reference `56_Vanilla_Code_Reference` and the local extraction `C:\Projetos\BG3\Base Game BG3\` (Assets, Osiris,
Localization); other mods in `C:\Projetos\BG3\References\` (their `Story/RawFiles/story_header.div` lists Osiris
signatures).

- **Grep before claiming.** A field, functor or Osiris call exists only when a vanilla or working file uses it.
  Schema-valid isn't proof (`AGENTS.md` §4).
- **One cheap test per uncertainty** (T2). Mark the uncertain piece **T2** in `DESIGN.md` with its plan B. If the Owner
  is sure from experience, take their word and drop the test.
- **Proven patterns in this mod** (reuse before inventing; details in the `57` cards):

| Need | Pattern |
|---|---|
| Stats → script hand-off | A technical status applied on the target; Osiris reacts to the status and runs a procedure |
| Timer that counts on the caster's turn | `TickingWithSource` with a turn-start tick |
| Effect when a status expires naturally | `OnRemoveFunctors` conditioned on the `TimeOut` remove cause — a cleanse doesn't trigger it |
| Add turns to a running status | `StackType` `Additive` and reapply (negative durations don't subtract) |
| Read remaining turns | Osiris query of the status turns (see `57.05`) |
| One state at a time vs coexisting | Shared `StackId` (with `StackPriority` for tiers) vs separate `StackId`s |
| Reaction card | Interrupt + a charge resource + a per-round limit |
| Families of statuses or spells | A generator script in `82_Automation/stats/` with a table |

- **Simultaneous events:** define the queue (§4.5).

---

## 14. Traps

| Don't | Because | Do |
|---|---|---|
| Copy another subclass's cards, mechanic or numbers | Each subclass is its own archetype | Derive the kit from its own mechanic |
| Give a tier a stat bonus (even as an extra) | Generic; every subclass's peak would feel the same (A2) | Push the mechanic's theme (§7) |
| Use randomness in a mechanic built on foresight or planning | Breaks readability and the axis (P12) | Deterministic rules, visible state |
| Design around choosing a slot level | The Arcana always casts at its highest slot | Scale by slot level; vary by card |
| Need two statuses per effect without a strong reason | Doubles the scope and the things to read | One status; its duration and stack type carry the logic |
| Leave simultaneous resolution undefined | Double counting, skipped effects, loops | Define the queue and the order (§4.5) |
| Let a chain feed itself without a cap | Snowball (B3) | Cap per turn, per chain, or a net cost |
| Rely on the AI reacting to the mechanic | It won't (P8) | Effects that work when ignored |
| Borrow a word from another subclass's world | Muddles both identities (I6) | Names from the card, its myth or its science |
| Ask several things in one brainstorm message | The Owner answers one and the rest get lost | One question per message |
| Put numbers in the brainstorm or in this file | Anchors the discussion; numbers live in `25` | Placeholders `‹…›`; values in the balance pass |
| Make a cost that removes the player's turn | Losses weigh more than equal gains; it reads as punishment (P11) | Frame it as a trade the player chooses |
| Teach a rule before it can be used | It costs memory and is forgotten (J5) | Teach it on the level that makes it usable |
| Put a cliff of new concepts on one level-up | Working memory is small (J4) | Spread the concepts; group a dense level under one idea |
| Let one feature quietly break the core rule | The rule stops being true; players learn exceptions (M7) | Write the exception into the rule or change the feature |
| Extend durations past the typical fight | A bonus that exists only on paper (B6) | Grow what the player sees in a normal fight |
| Put the journey's peak where few fights reach it | Peak-end: the journey ends flat (J6) | Make reaching the tier the trigger, or move the peak earlier |
| Make an ultimate that ignores the state | The play that leads to it stops mattering (K7) | Let its effect read what was built |
| Leave a decision with one right answer | It isn't a decision (B5) | Give every option a situation where it wins |
| Claim a BG3 fact from memory, or from the wiki alone | Docs are a map; the game files are the truth | Cite the bg3.wiki page and the game file (`56`); if the file can't be found, say "I don't know" (§8) |

---

## 15. Studio gates and the one-page checklist

A feature reaches **Spec Ready** only after both gates are recorded in its ticket (spec §9, §17.4, §18.8).

**Design gate** — each question answered in one or two lines:

| # | Question | Answers it |
|---|---|---|
| 1 | Is it tied to a pillar and to the subclass fantasy? While `21.01` doesn't exist, the **fantasy** only (§0.3) | Lead Class Designer |
| 2 | Is its role clear, without duplicating another subclass (matrix `21.08`)? | Lead Class Designer |
| 3 | Which resource pays for it, and how does that resource recharge (`26`)? | Spell Designer |
| 4 | Where does its power sit on the curve (virtual damage, sustained / nova DPR, `22`)? | Balance Designer |
| 5 | Does it explain itself in one tooltip read? Does the subclass stay inside its complexity budget (§11)? | Lead Class Designer |
| 6 | Interactions checked: concentration, bonus action, stacking, resource loops (§10.3)? | Balance Designer |
| 7 | Does the 1–12 core work without the 13–20 module? | Validator (`53.03`) |
| 8 | Is the intent of the change written in one sentence (it feeds the patch notes)? | Spell Designer |

**Complexity budget** — X1–X3 and J4 (§11).

**Narrative gate** — name, description and flavour approved and recorded in `32.04`; numbers in the text come from
`25`, never typed by hand.

**The one-page checklist** (analysis and audits; marks ✅ ⚠️ ❌ ➖ 🧪, one line of evidence each):

```
Identity & fun  I1 fun · I2 striking trait · I3 archetype · I4 aspect · I5 axis · I6 vocabulary · I7 story in the rule · I8 one voice
Sources         S1 card · S2 card elements · S3 characters · S4 character elements · S5 real source · S6 myth · S7 primary sources
Mystra          W1 relation to Mystra · W2 the Weave in the features
Mechanic        M1 new & exclusive · M2 one rule · M3 gears · M4 grows · M5 both sides · M6 bounded · M7 no exceptions
Key features    K1 drive · K2 exclusive · K3 ties it together · K4 passives fit · K5 passives drive · K6 two plays + fallback · K7 ultimate reads the state
Play            P1 style · P2 specialist/versatile · P3 party · P4 level 1 · P5 pays back · P6 decisions · P7 readable · P8 vs AI · P9 weaknesses · P10 console · P11 cost as trade · P12 deck vs axis
Felt progress.  J1 headlines · J2 vertical growth · J3 button in ranks · J4 smooth curve · J5 taught when usable · J6 peak happens · J7 arc
Awakening       A1 goal · A2 tiers · A3 Aspect card
Balance         B1 curve · B2 combos · B3 loops · B4 lean weak · B5 no dominant option · B6 no dead bonus · B7 carried resource
Complexity      X1 hotbar · X2 counters · X3 signature named
Technical       T1 no SE · T2 proven · T3 generated · T4 conventions
Documentation   D1 Identity Sheet · D2 sources agree
Also            Texts (§12) · Test plan (§10.5)
```

---

## 16. Sources

The full list, with what was actually read, is `27.07_Sources.md`; the ideas are condensed in `27.01`–`27.08`. The
sources that ground this standard most directly:

- **Experience and motivation:** Hunicke, LeBlanc and Zubek, *MDA* (2004); Ryan, Rigby and Przybylski (2006);
  Csikszentmihalyi, *Flow* (1990).
- **Learning and complexity:** Sweller (1988); Cowan (2001); Rosewater, *New World Order* (2011) and *Lenticular Design*
  (2014).
- **Decisions, costs and memory:** Meier, *Interesting Decisions* (GDC 2012); Kahneman and Tversky (1979); Kahneman,
  Fredrickson, Schreiber and Redelmeier (1993); Hull (1932); Kivetz, Urminsky and Zheng (2006); Nunes and Drèze (2006).
- **Systems and balance:** Adams and Dormans, *Game Mechanics* (2012); Schreiber and Romero, *Game Balance* (2021);
  `22.06`.
- **Journey and narrative:** Hayashida on kishōtenketsu (Nutt, 2012); Hocking (2007); `27.05`.
- **D&D-style classes:** Crawford, *Designing D&D Subclasses* (D&D Beyond); the 5e *Dungeon Master's Guide* (2014),
  ch. 9; `27.02`.
- **Tarot and myth (primary):** Waite (1910); Pollack (1980); Crowley (1944); Hesiod and Apollodorus (Perseus).
- **Baldur's Gate 3:** [bg3.wiki](https://bg3.wiki/) for the rules as the player sees them, always next to the game
  file that proves them (`56`, paths in §8); the file wins when they disagree (§8.7).

Most of these were verified online and skimmed, not read in full (`27.07`): treat them as lenses until the Arcana's own
playtests (`27.06`) confirm them.

---

## Appendix A — migration from v1

### A.1 Sections

| v1 § | Topic | v2 § |
|---|---|---|
| (intro), 0 | Scope | 0.1 |
| — | Principles, pillars | 0.2, 0.3 (new) |
| 1.1–1.4 | Frame, brainstorm, synthesis, analysis | 1.1–1.4 (same numbers) |
| 1.5 | Spec (dated file) | 1.5 — `DESIGN.md` + `DECISIONS.md` |
| 1.6 | Plan, build, test | 1.6 |
| 1.7 | Record | 1.7 — record and propagate (00.08) |
| 2 (sheet) | Identity Sheet | 2.8 |
| 2.1 | Reading a tarot card | 2.1 |
| 2.2 | References | 2.2 |
| **2.3** | **The axis** | **2.3** (same) |
| — | Archetype, Weave, voice, ludonarrative | 2.4–2.7 (new) |
| **3** | **Depth Model** | **3** (same ids; new ids added) |
| 4.1–4.6 | BG3 facts | 8.1–8.7 (each fact cites bg3.wiki and the game file; high ground corrected to a flat modifier; initiative corrected to a shared result, not adjacency) |
| 5 | Arcana framework | 9.1, 9.2 |
| 6 | Base-class changes | 9.3 |
| 7.1–7.3 | Pool size, card questions, action spread | 5.8, 5.1 |
| 7.4 | Journey 1–12, meters | 6.3, 5.7 (meters: reset by default, exception B7 — D4) |
| 7.5 | Passives | 5.2 |
| 8.1–8.5 | Balance (with formulas) | 10.1–10.5 (method only; formulas in `22.06`) |
| 9 | Aspect Awakening | 7 |
| 10 | Names and texts | 12 |
| 11 | Technical feasibility | 13 |
| 12 | Auditing an existing subclass | `_SUBCLASS_REFINING.md` |
| 13 | Traps | 14 |
| 14 | Checklist | 15 |
| **15** | **Studio gates** | **15** (same) |

**Documents that cite moved sections** (written before v2, not edited — read them with this table):
the subclass review of ARC-0014 (`21.04/<S>/BALANCE_SUGGESTIONS.md`) cites v1 §4.1, §4.2 (→ §8.1, §8.2), §5 (→ §9.1)
and §7.4 (→ §5.7, §6.3).

### A.2 Question ids

Every v1 id (I1–I6, S1–S6, W1–W2, M1–M6, K1–K6, P1–P10, A1–A3, B1–B4, T1–T4, D1–D2) keeps its meaning. New in v2:
I7, I8, S7, M7, K7, P11, P12, J1–J7, B5–B7, X1–X3.

### A.3 Older ids (before v1)

One decision log written before v1 (`21.04/<S>/DECISIONS.md`, "Audit state before the rules rewrite") uses ids
E1–E7 and F2–F3 from an earlier version of the criteria. Their definitions were **not found** in the repository; the
correspondences below are inferred from the decisions they are attached to and are **probable, not authoritative**:

| Old id | Context in that log | Probable v2 id |
|---|---|---|
| E3 | A new verb at level 3 | M4 / J1 |
| E4 | The ultimate | K3 |
| E6 | No chains between reactions | M6 |
| E7 | Tier names and Tier III | A2 |
| F2 | A bonus-action option at level 3 | K6 |
| F3 | Missing live-context file, chassis and colour open | D1 / D2 |
| E1, E2, E5 | Marked "passing", no context | unknown |
