---
id: 21.04/_SUBCLASS_REFINING
version: 1
owner: Lead Class Designer
status: approved — Owner, 2026-10-15 (ARC-0016)
updated: 2026-10-15
uses: 21.04/_SUBCLASS_STANDARD.md v2 (the Depth Model, cited as DM-<id>)
---

# Refining Method — how the Arcana diagnoses and improves a design that already exists

> The standard (`_SUBCLASS_STANDARD.md`) says **how to create and judge** a design. This file says **how to take one
> that exists** — the base class, a subclass, a feature, a card, a status family — **diagnose it and propose
> improvements** that make it tighter, tied to its kit, grounded in research, and a progression the player **feels**.
>
> It never restates a criterion. Every judgement cites a Depth Model question by id (`DM-K3`); every "why" cites a card
> of `27`. Numbers never live here or in a review (ADR-0005): a review uses the currency of `22.06` for direction and
> placeholders `‹…›` for sizes.

**See also:** a full subclass review written before this method — `21.04_Subclasses/<S>/REFINE_<S>.md` of ARC-0014 (it
uses the v1 section numbers and `S#` suggestion ids; its header explains the mapping).

## Contents

0. Status of a review · 1. Which variant, and when · 2. Inputs · 3. The pipeline · 4. Diagnostic tools ·
5. Suggestions and priorities · 6. The felt-progression pass · 7. Balance impact · 8. Feasibility and verification ·
9. Rollout and propagation · 10. Guardrails · 11. Templates

---

## 0. Status of a review

- A review is a **proposal**. Its header says so, and so does its first paragraph.
- **Nothing in it is a decision** until the Owner approves a suggestion. An approved suggestion becomes a line in the
  dossier's `DECISIONS.md` (§9); the review stays as it is, as the record of why.
- The design (`DESIGN.md`), the master data (`25`) and the game files **do not change because of a review**.
- A suggestion that contradicts a recorded decision **names that decision** and says why it should change. Silence is
  not allowed.

---

## 1. Which variant, and when

### 1.1 The variants

| Variant | Scope | Depth Model families that apply | Output (where it is saved) |
|---|---|---|---|
| **Base class** | Chassis, resources, deck rules, Awakening framework, utilities | M, P, B, X, T, D — and the impact matrix (standard §9.3) for every subclass | `21.05_Class_Features/REFINE_<System>.md` |
| **Subclass** | The whole kit, levels 1–12 | All of them | `21.04_Subclasses/<S>/REFINE_<S>.md` |
| **Feature** — an ultimate, the Awakening, a resource or meter | One piece and the gears it touches | M2–M7, K, J, A (if Awakening), B, X | `21.04_Subclasses/<S>/REFINE_<Piece>.md` |
| **Card** | One spell or card and its place in the deck | K, P5–P7, P11–P12, B, the card checklist (standard §5.1) | `21.04_Subclasses/<S>/REFINE_<Piece>.md` (short template) |
| **Status family** | A set of statuses that share a rule or a generator | M5, M6, P7, B3, B6, T3, the status checklist (standard §5.3) | `21.04_Subclasses/<S>/REFINE_<Piece>.md` |

A piece that belongs to the base class is saved under `21.05`; a piece of a subclass, in its dossier. When a
piece already has a review, a new one gets a dated name (`REFINE_<Piece>_<YYYY-MM-DD>.md`) and the old one
stays.

### 1.2 Full or short

| | Full | Short |
|---|---|---|
| For | Base class, subclass, ultimate or Awakening | One card, one passive, one status, a small family |
| Pipeline (§3) | All twelve steps | Steps 1, 2, 4, 5 (only the tools that apply), 6, 9, 11, 12 |
| Audit | Every question of the families that apply | Only the questions the piece touches |
| Template | §11.1 | §11.2 |
| Effort | Several sessions; one Owner round per theme | One session |

### 1.3 Never

- Refine **without reading the real files**: the dossier, `25`, and the game files when the question is "how is it,
  really?" (`CLAUDE.md` rule 6).
- Change a recorded decision **without naming it** (§0).
- Copy a number into the review, or propose a final value (ADR-0005).
- Name a function, event, field or value from memory (`AGENTS.md` §4).
- Rewrite a Depth Model criterion inside the review: cite its id.
- Delete anything: retired material goes to `90_ARCHIVE` with date and reason.

---

## 2. Inputs

Read only what the variant needs, by id. Mark each one read in the review's header (`sources:`).

| Input | Base class | Subclass | Feature | Card | Status family |
|---|---|---|---|---|---|
| The standard (`21.04/_SUBCLASS_STANDARD.md`) | ✓ | ✓ | ✓ | ✓ | ✓ |
| Design: `21.04/<S>/DESIGN.md` or `21.05/<System>` | ✓ | ✓ | ✓ | ✓ | ✓ |
| Decisions: `21.04/<S>/DECISIONS.md` | ✓ (all dossiers touched) | ✓ | ✓ | ✓ | ✓ |
| Master data: `25_Master_Data` (`*_<S>_*`, `*_Arcana_*`) | ✓ | ✓ | ✓ | ✓ | ✓ |
| Balance reports: `22.05/<S>.md` and the dated reports | ✓ | ✓ | ✓ | if any | if any |
| Resource audit: `26.01/<S>.md` | ✓ | ✓ | if it uses a resource | — | — |
| Live context: `05.00`, `05.02/<S>.md`, `05.03`, `05.04` | ✓ | ✓ | ✓ | ✓ | ✓ |
| Role matrix: `21.08` | ✓ | ✓ | — | — | — |
| Progression: `21.03/<S>.md` | ✓ | ✓ | ✓ | ✓ | — |
| Game files (`51` copy, or the Data folder read-only) | when the question is "how is it, really?" | same | same | same | same |
| Vanilla reference (`56`, bg3.wiki — standard §8) | for every BG3 fact used | same | same | same | same |
| Research cards `27.01`–`27.08` | the cards the review cites | same | same | same | same |
| Playtest results (`61.02`, `65`), mod.io feedback | when they exist | same | same | same | same |

---

## 3. The pipeline

Each step has an input, an output and a test for "done". A step that sends the work back says so in the review.

| # | Step | Input | Output | Done when |
|---|---|---|---|---|
| 1 | **Frame and classify** | The request, §1 | Variant, scope, full or short; the list of what is **already decided** (decision ids) and what is open | The Owner can correct the classification in one reading |
| 2 | **Portrait of the current state** | Inputs of §2 | Identity in brief, the core rule in one sentence, the kit by level, the resources, the gears table (standard §4.3) | Someone who never saw the piece can describe it from the portrait alone |
| 3 | **Choose the criteria** | The standard's §3 | The list of Depth Model ids that apply, plus the research cards that sharpen them (`27.xx`) — cited, never rewritten | Every family of §1.1 for the variant is covered or marked ➖ with a reason |
| 4 | **Audit** | Steps 2–3 | One row per question: mark (✅ ⚠️ ❌ ➖ 🧪) and one line of evidence (file, §, decision id, count, test) | No mark without evidence; no 🧪 upgraded to ✅ on paper |
| 5 | **Diagnostics** | The audit's ⚠️ and ❌ | The tools of §4 that apply, each with its data (tables, timelines, counts) | Every ⚠️/❌ of step 4 has data behind it, or is marked "opinion" |
| 6 | **Findings → suggestions** | Steps 4–5 | Suggestions `SG1…` in the fixed format of §5.1 | Every ❌ has a suggestion or an explicit "accept as is" with reason |
| 7 | **Priorities** | Step 6 | must / should / could, effort XS–L, and the dependency order (§5.2) | The order can be followed one question per message in a brainstorm |
| 8 | **Felt-progression pass** | Steps 2, 6 | Current vs proposed level table with headlines, the arc, the complexity curve before and after, the signature button's ranks (§6) | Each odd level has a headline in the proposed table (`DM-J1`) |
| 9 | **Balance impact** | Steps 6, 8 | Direction and estimate per suggestion in the `22.06` currency, and the net reading (§7) | No final number; the net reading says where power leaves and where it goes |
| 10 | **Feasibility** | Step 6 | Per suggestion: where it lives, proven pattern, new piece marked T2 (§8.1) | No function or field named from memory |
| 11 | **Verification plan** | Steps 6, 9 | One test per rule (fight, metric, right if, wrong if) and qualitative questions (§8.2) | Every *must* suggestion has a test that could prove it wrong |
| 12 | **Rollout** | Steps 7, 11 | The order of decisions, and the propagation table by department (§9) | Every artifact a suggestion would touch is named with its owner |

---

## 4. Diagnostic tools

Reusable checks. Each one names when to use it, how, what signals a problem, and the questions it informs. A review
shows the data of every tool it uses — a table, a timeline, a count — so the Owner can check it.

### 4.1 Complexity curve

- **When:** subclass, base class, any change to what arrives at a level.
- **How:** for each level, list the outcomes the player can produce and the **new concepts** the level-up brings (a new
  rule, state, interaction or button). Mark the ones the player can predict from what they already know.
- **Red flag:** one level-up with far more new concepts than its neighbours; a level with none.
- **Informs:** `DM-J4`, `DM-X1`, `DM-M4`. Why: cognitive load (`27.08`).

### 4.2 Resource and meter timeline

- **When:** anything with a resource, meter, charge or countdown.
- **How:** turn by turn, through one **reference fight** (length from `22.06` §1) and through **one adventuring day**
  (fights and rests from `22.06` §1): fill, spend, what the player can do in each state, and what carries over.
- **Red flag:** a state where the player can't do anything useful; a resource that is always full or always empty; a
  carried resource without the three answers of `DM-B7`.
- **Informs:** `DM-P5`, `DM-P11`, `DM-B7`, `DM-X2`.

### 4.3 Tier and peak timeline

- **When:** subclass, Awakening, ultimate, capstone.
- **How:** on which turn of a reference fight each Awakening tier, the ultimate and the level-12 peak become available;
  note when two timers must line up.
- **Red flag:** the peak needs a fight longer than the reference, or two timers to line up.
- **Informs:** `DM-J6`, `DM-A1`, `DM-P5`. Why: peak-end (`27.08`).

### 4.4 Loop hunt

- **When:** always, in a full review; in a short one when the piece refunds, generates or reapplies anything.
- **How:** list every refund, every resource that can pay for its own source, every state that comes back by itself, and
  every payoff that creates its own trigger. Play each one turn by turn until it stops or repeats.
- **Red flag:** a cycle that repeats a benefit every turn for no net cost.
- **Informs:** `DM-B3`, `DM-M6`.

### 4.5 Exception hunt

- **When:** always.
- **How:** write the core rule's sentence; check every feature against it; list each feature that behaves differently
  (an "except", a state that returns instead of being spent, a target the rule doesn't allow).
- **Red flag:** any exception not written into the rule.
- **Informs:** `DM-M2`, `DM-M7`.

### 4.6 Taught before usable

- **When:** subclass, base class, any rule passive.
- **How:** for each rule, the level where it is taught and the first level where the player has the pieces to trigger
  it.
- **Red flag:** taught earlier than usable.
- **Informs:** `DM-J5`.

### 4.7 Dead bonuses

- **When:** any duration extension, flat bonus or value that doesn't scale.
- **How:** compare each duration with the reference fight (`22.06` §1) and with how the state usually ends (spent,
  cleansed); list each value at level 1 and level 12 next to what vanilla gains in the same span.
- **Red flag:** a bonus that only counts after the fight usually ends; a value flat from 1 to 12 while vanilla grows.
- **Informs:** `DM-B6`, `DM-J2`.

### 4.8 Dominant option

- **When:** every choice the player makes repeatedly (release or hold, which card, which target).
- **How:** for each choice, the situations where each option wins. Look for a choice whose answer never changes.
- **Red flag:** one option is right every time, or never.
- **Informs:** `DM-B5`, `DM-P6`. Why: interesting decisions (`27.08`).

### 4.9 Cost framed as punishment

- **When:** any cost, drawback, penalty state or meter that fills on its own.
- **How:** write each cost as "you give X to get Y". If it can't be written that way — the player loses options without
  choosing — it is a punishment.
- **Red flag:** a state that removes the player's turn or spells without their choice.
- **Informs:** `DM-P11`, `DM-I1`. Why: loss aversion, framing (`27.08`).

### 4.10 Both sides of the field

- **When:** any state that can land on allies and enemies.
- **How:** for each state, its effect on an ally and on an enemy; then every rule that can put a harmful state on an
  ally without the player choosing it (automatic casts, copies, spreads, links).
- **Red flag:** harm to allies by rule; a side that the mechanic never uses without saying so.
- **Informs:** `DM-M5`.

### 4.11 UI reading

- **When:** always, in a full review.
- **How:** write the question the player asks on a typical turn ("what can I do with this target?"). Check whether the
  screen answers it: status icon, count, tooltip, combat log (the status checklist, standard §5.3).
- **Red flag:** the answer lives only in the player's head.
- **Informs:** `DM-P7`, `DM-X2`. Why: clarity (`27.08`).

### 4.12 The right card in hand (PC deck)

- **When:** any PC-edition kit whose axis needs a specific piece at a specific time.
- **How:** read the deck rules (copies per card, opening hand, draw per turn — `21.05_Class_Features/
  Systems_TO_REVIEW.md`, `26.01/2026-09-17-deck-core-design.md`) and the subclass's deck size at the level checked.
  The chance of holding at least one of the *k* copies of a card after seeing *n* cards of a deck of *N* is
  `1 − C(N − k, n) / C(N, n)`. Compute it for the turns that matter; mulligans and played cards change it a little, not
  its order of magnitude.
- **Red flag:** the needed piece is often missing when the plan needs it.
- **Informs:** `DM-P12`. Why: skill vs chance (`27.08`).

### 4.13 Value by level band

- **When:** subclass, base class, any change with balance impact.
- **How:** the method of the standard §10.4, in the currency and with the formulas of `22.06`; the band table of
  `22.05/<S>.md` is the starting point.
- **Red flag:** a band well above or below the benchmark; a spike or a dead band.
- **Informs:** `DM-B1`, `DM-B2`, `DM-B4`.

---

## 5. Suggestions and priorities

### 5.1 The suggestion format

Every suggestion has an id `SG1, SG2…` (never `S#`, which the Depth Model uses for sources) and these fields, in this
order:

| Field | What it holds |
|---|---|
| **SG# · title** | A short name |
| **Problem** | One or two sentences |
| **Evidence** | File, §, decision id, tool data (§4) — checkable |
| **Why it matters** | The Depth Model ids it answers and the research card behind them (`DM-K7`; `27.08`) |
| **Proposal** | What changes, with placeholders `‹…›` for sizes; options A/B when there is a real choice, the recommendation first |
| **Alternatives considered** | What else was weighed, and why it lost |
| **Impact** | Design (`DESIGN.md` §), master data (`25` ids), Stats / Osiris / Khonsu / LSX, texts (`32.01`, `33.03`), console and PC editions, tests (`61.02`), player guide |
| **Risks** | What could go wrong, and what brakes it |
| **How to verify** | Fight, metric, **right if**, **wrong if** (§8.2) |
| **Decisions touched** | The recorded decision ids it changes or depends on (§0) |

### 5.2 Priorities, effort and order

| Priority | Meaning |
|---|---|
| **must** | A ❌ on a Depth Model question, a loop without a brake, harm to allies by rule, or a contradiction between sources |
| **should** | A ⚠️ that the player feels in a normal fight |
| **could** | A ⚠️ that is rare, or an option worth testing |

| Effort | Meaning |
|---|---|
| **XS** | Text only |
| **S** | One generator table, one Osiris rule, or one spell |
| **M** | Several files and a test round |
| **L** | Touches the base class or the PC deck (impact matrix required — §10) |

**Order of decisions:** list the dependencies (SG4 before SG6 when SG6 is only safe after SG4), then order the
brainstorm so each question can be answered without knowing the answer to a later one. Group suggestions that form one
design (a ladder, a resource and its ultimate) so they are decided together.

---

## 6. The felt-progression pass

Run it in every full review. It applies the standard's §6 to the piece as it is and as proposed.

1. **Level table, current vs proposed**, with the headline column (`DM-J1`): what the player would say changed. Mark
   levels whose headline is only a number.
2. **The arc** (`DM-J7`): name the four parts (introduce, develop, turn, conclude) and the levels of each; say what the
   player feels in each.
3. **The complexity curve, before and after** (tool §4.1, `DM-J4`).
4. **Vertical growth** (`DM-J2`): the states that grow, at which announced breakpoints.
5. **The signature button's ranks** (`DM-J3`): what it does at each rank.
6. **The peak** (tool §4.3, `DM-J6`): on which turn of a reference fight it happens, before and after.

---

## 7. Balance impact

- **Direction only:** for each suggestion, up / down / flat, at which levels, with an estimate in the `22.06` currency.
  No final value: the balance pass chooses it and writes it in `25` (ADR-0005).
- **Net reading:** where power **leaves** (what the suggestions remove) and where it **goes** (what they add), and
  whether the total lands near today's, spread more evenly (`DM-B1`).
- **Assumptions** declared, as the standard §10.1 asks.

| SG | Direction | Estimate (`22.06` currency) | Band check |
|---|---|---|---|
| … | … | … | … |

---

## 8. Feasibility and verification

### 8.1 Feasibility

| SG | Where it lives | Proven pattern in the mod (`57`, standard §13) | New piece — **T2** |
|---|---|---|---|
| … | … | … | … |

A new piece is marked **T2** and needs a real vanilla or mod example (`56`, `57`) — or a cheap test — before a spec is
written. Every gameplay effect stays in Stats, Osiris, Khonsu or LSX, so both editions share it (`DM-P10`, `DM-T1`).

### 8.2 Verification

- **One rule per test** (`27.06`): the decision the test informs, the fight (level, enemies, length), the metric,
  **right if** and **wrong if**. Tests go to the playtest ticket of the subclass and to `61.02`.
- **Qualitative questions** for the Owner or a playtester after each session, asked neutrally (`27.06`): *What did you
  want to do that you couldn't? When did you feel strongest? When did you feel the character level up? What would you
  call its signature?*

| V# | Fight | Metric | Right if | Wrong if | SG |
|---|---|---|---|---|---|
| … | … | … | … | … | … |

---

## 9. Rollout and propagation

1. **Order of decisions** — the brainstorm order of §5.2, one question per message (standard §1.2).
2. **Each approved suggestion becomes a decision** in the dossier's `DECISIONS.md`, with the dossier's prefix and the
   next free number, its source ("Owner, from SG#") and the date. A suggestion approved with changes is logged as
   approved; a rejected one is noted in the review, not in `DECISIONS.md`.
3. **`DESIGN.md` is rewritten** to show the result in the present tense (standard §1.5).
4. **Propagation** follows `00.08_Propagation_Map` for the change type (subclass, base class, system, single card):

| Artifact | Owner role | Touched by |
|---|---|---|
| `21.04/<S>/DECISIONS.md`, `DESIGN.md` | Lead Class Designer | every approved SG |
| `21.03/<S>.md`, `21.08` | Lead Class Designer | SGs that move levels or roles |
| `25_Master_Data` | Spell + Balance Designers | SGs with values |
| `22.05/<S>.md`, `26.01/<S>.md` | Balance Designer | SGs with balance or resource impact |
| `23.02/<S>/` | Spell Designer | SGs that change a card, passive or status |
| `31.02/<S>.md`, `32.01/<S>.md`, `33.03` | Lore Writer | SGs that change texts or names |
| `42.04/<S>.md` | Icon Artist | SGs that add a visible piece |
| `55` (spec, Toolkit guide) | Mod Engineer | SGs that reach the game |
| `61.02/<S>/` | QA Lead | every verification row |
| `05.02/<S>.md` | Context Keeper | after the build |
| Ticket and board | Producer | every session |

5. **Run `/propagar`**; `check_propagation.pl` prints OK before the ticket closes.

---

## 10. Guardrails

- **Numbers live only in `25`** (ADR-0005). A review uses placeholders `‹…›` and the `22.06` currency.
- **No BG3 fact from memory:** each one cites the bg3.wiki page and the game file; the file wins (standard §8).
- **Never delete:** retired material goes to `90_ARCHIVE` with date and reason.
- **Base class or PC deck:** any suggestion that touches them carries the **impact matrix** of the standard §9.3 (one
  row per subclass) and is effort **L**.
- **One review, one scope:** a finding outside the scope is written as a note for another review, not fixed in this one.
- **Owner decides:** a recommendation the Owner rejects is dropped, not re-argued.

---

## 11. Templates

### 11.1 Full review

```markdown
---
id: 21.04/<S>/REFINE_<S>            # or 21.04/<S>/REFINE_<Piece>, 21.05/REFINE_<System>
owner: Lead Class Designer (with the Balance Designer)
status: proposal — awaiting Owner review; nothing here is a decision until it is logged in DECISIONS.md
ticket: ARC-####
created: YYYY-MM-DD
variant: subclass | base class | feature
sources: <every input of §2 read, by id>
---

# <Piece> — design review

> What this document is (a proposal) and is not (the design, the decision log). Numbers: placeholders only.

## Contents
## 1. Executive summary          — themes, then the SG table (id · suggestion · priority · effort · DM ids)
## 2. Frame                       — variant, scope, already decided (decision ids), open
## 3. The current state           — portrait: identity, core rule, kit by level, resources, gears table
## 4. Criteria                    — the DM ids that apply and the 27 cards that sharpen them
## 5. Audit                       — DM id · mark · evidence · answered by SG#
## 6. Diagnostic data             — one subsection per tool of §4 used
## 7. Suggestions                 — SG1… in the format of §5.1
## 8. Felt progression            — the pass of §6
## 9. Balance impact              — §7
## 10. Feasibility                — §8.1
## 11. Verification               — §8.2
## 12. Rollout and propagation    — order of decisions, §9 table
## 13. References                 — research and studio documents cited
## Appendices                     — worked examples, timelines, derivations
```

### 11.2 Short review (one card, passive, status or small family)

```markdown
---
id: 21.04/<S>/REFINE_<Piece>
owner: Lead Class Designer
status: proposal — awaiting Owner review
ticket: ARC-####
created: YYYY-MM-DD
variant: card | passive | status family
sources: <inputs read, by id>
---

# <Piece> — short review

## 1. Current state      — what it does, cost, action, limiter, level, gear (creates / changes / spends / reads)
## 2. Audit              — only the DM ids it touches, mark · evidence; the type checklist of the standard §5
## 3. Diagnostics        — only the tools of §4 that apply, with their data
## 4. Suggestions        — SG1… in the format of §5.1
## 5. Verification       — V# rows (§8.2)
## 6. Rollout            — decision to log, artifacts to propagate (§9)
```
