---
id: 21.04/Resonant/BALANCE_SUGGESTIONS
owner: Lead Class Designer (with the Balance Designer)
status: proposal — awaiting Owner review; nothing here is a decision until it is logged as R49+ in DECISIONS.md
ticket: ARC-0014
created: 2026-10-15
sources: DESIGN.md · DECISIONS.md (R1–R48) · _SUBCLASS_STANDARD.md · 25_Master_Data (*_Resonant_*) · 22.05/Resonant.md · 22.05/2026-10-11_ARC-0002_Resonant_Balance.md · 22.06/Arcana_Power_Budget.md · 26.01/Resonant.md · 27.01 · 27.07
---

# The Resonant — design review: balance, structure and felt progression

> An end-to-end review of the Resonant as it stands after ARC-0002 (R1–R48), with every suggested change,
> the evidence behind it, the research it rests on, the alternatives considered, its impact on every
> department and how to prove it right or wrong in play.
>
> **What this document is not.** It is not the design (that is `DESIGN.md`) and it is not a decision log (that is
> `DECISIONS.md`). Each suggestion here has an id **S1–S16**; when the Owner approves one, it becomes an `R` line in
> `DECISIONS.md`, `DESIGN.md` is rewritten to show the result, and the change is propagated (00.08). Until then
> the game, the design and the master data stay as they are.
>
> **Numbers.** ADR-0005 holds: no value here is final. Where a size is needed to explain a suggestion it is a
> *placeholder* marked `‹…›`, and the real number is chosen in the balance pass and written once in
> `25_Master_Data`. Estimates use the currency of `22.06/Arcana_Power_Budget.md` (A = 4 / 8 / 11 by tier; D = the
> daily budget; E = 4 fights, T = 4 turns).

---

## Contents

1. Executive summary
2. The evaluation framework
3. Audit of the current design (Depth Model)
4. Diagnostic data
5. The suggestions in detail (S1–S16)
6. The proposed progression, levels 1–12
7. Balance impact
8. Technical feasibility
9. How to verify (playtest plan)
10. Rollout and propagation
11. References
- Appendix A — the Intensify loop, turn by turn
- Appendix B — reaction outcomes per level
- Appendix C — the PC deck and the right emotion in hand
- Appendix D — the Overload timeline today

---

## 1. Executive summary

The Resonant's core is the strongest in the class: a real scientific model (Plutchik) gives the content its
structure, the core rule fits in one sentence (*a second emotion poured into a mood reacts by its distance on the
wheel*), the same spell is a buff or a debuff, and the refund gives the subclass a rhythm without becoming an engine.
The axis — **Combination** — is clean and no other subclass asks it.

What is loose is around the core, and it falls into five themes:

1. **The Overload is a punishment before level 5 and a solved decision after it.** The cost of the subclass's
   identity feature is felt as a loss for four levels, and its central choice (release or hold) disappears the
   moment Emotional Overload arrives.
2. **The ultimate does not read the mechanic.** Emotional Overload paralyses for 2 turns with no save whatever the
   target carries; the feelings braided into it add only small damage.
3. **Complexity arrives in steps, and one rule is taught before it can be used.** The number of reaction outcomes
   goes 2 → 7 → 20 → 28 → 36; level 5 alone adds 13. Catharsis is explained at level 1 and possible only at 3.
4. **Progression is mostly horizontal.** States never grow with level, several bonuses extend durations that rarely
   matter, and the level-12 peak almost never shows in a real fight.
5. **One loop has no brake.** Intensify gives the mood back when it ends, so with the refund (and Harmony's free
   Surge) an ally can gain an extra action every turn for nothing.

| Id | Suggestion | Theme | Priority | Effort | Main criteria |
|---|---|---|---|---|---|
| **S1** | The Overload ladder: a release at 1, Emotional Overload at 5, the area at 12; *Overloaded* becomes a risky power state, not a silence | 1 | **must** | M | Loss aversion, interesting decisions, K3, felt progression |
| **S2** | Emotional Overload reads the feelings it spends (paralysis per feeling, or no save only on a braided target) | 2 | **must** | S | K3, M3, B2 |
| **S3** | Overload frequency: align the standard and the design; the meter settles to half after a fight | 1 | **must** | S | B1, §7.4 of the standard, predictability |
| **S4** | Intensify spends the mood, like every other reaction | 5 | **must** | S | B3, M2 (no exceptions) |
| **S5** | Teach Catharsis at level 3, together with Sadness and The Two Cups | 3 | should | XS | Cognitive load, "teach when usable" |
| **S6** | Option: Overwhelm (distance 0) at 5, Complex Feelings (distance 2) at 7 | 3 | could | S | Learning curve, Plutchik's cone, theme of level 5 |
| **S7** | Readability: each mood's tooltip lists the reactions it can make | 3 | should | S | P7, competence (SDT) |
| **S8** | Moods and feelings grow at the class's breakpoints (5 and 10) | 4 | should | M | Competence, vertical progression |
| **S9** | Tier I *Resonance* becomes sympathetic resonance (a reaction spreads the spent mood to one neighbour) instead of +2 mood turns | 4 | should | M | A2, dead bonuses |
| **S10** | Heartstring deals extra Psychic per feeling the target carries, instead of +2 mood turns | 4 | should | S | K6, M3 |
| **S11** | Waking Tier III fills the Overload at once | 4 | **must** | S | Peak-end rule, A2 |
| **S12** | Shared Heart: an immediate payoff on cast (Joy on every linked creature) and only helpful feelings are shared | 4 | should | S | Capstone moment, edge-case safety |
| **S13** | Ready: Compassion moves to level 7 and never braids a hindering feeling on an ally | 4 | should | XS | Level rhythm, edge-case safety |
| **S14** | PC edition: the Surges as one card that lets the player choose the emotion (or measure the problem first) | — | could | L (base-class change) | Skill vs chance, the standard's trap list, complexity budget |
| **S15** | Anger's text and intent: a taunt-like grudge, said plainly | — | could | XS | Clarity, P8 |
| **S16** | Documentation fixes (four contradictions) | — | **must** | XS | D2 |

Effort: XS = text only · S = one generator table or one Osiris rule · M = several files and a test round ·
L = touches the base class or the deck.

---

## 2. The evaluation framework

The review uses the studio's own Depth Model (`_SUBCLASS_STANDARD.md` §3) and adds criteria from game-design
research and the psychology of play. Each criterion below names its source, the question it asks of the Resonant, and
the Depth Model questions it sharpens.

| # | Criterion | Source | Question asked of the Resonant | Sharpens |
|---|---|---|---|---|
| C1 | **Aesthetics first** | Hunicke, LeBlanc and Zubek, *MDA* (2004) | Does the feeling the player has come from the rules, or only from the names? | I1, I4 |
| C2 | **Competence** | Ryan, Rigby and Przybylski (2006), self-determination theory | Is each level's gain *noticeable*? Is the feedback clear? | M4, P7 |
| C3 | **Autonomy** | Same | Does every resource have at least two reasonable uses? Is any option a trap or a no-brainer? | P6 |
| C4 | **Interesting decisions** | Sid Meier, GDC 2012; Schell, *The Art of Game Design* (lens of meaningful choices) | Is there a dominant option that removes the decision? | P6, K3 |
| C5 | **Cognitive load and learnability** | Sweller (1988), cognitive load theory; Cowan (2001), working memory ≈ 4 chunks; Koster, *A Theory of Fun* (2004) | Does new content arrive in chunks the player can learn, and is every rule usable when it is taught? | M2, complexity budget |
| C6 | **Framing of costs** | Kahneman and Tversky (1979), prospect theory; the *rested XP* reframing in World of Warcraft | Is a cost felt as a punishment or as a trade the player chose? | I1, P9 |
| C7 | **Goal gradient and visible progress** | Hull (1932); Kivetz, Urminsky and Zheng (2006); Nunes and Drèze (2006), endowed progress | Does the player see the meter or the goal approach, and does it pull them forward? | P7 |
| C8 | **Peak-end** | Kahneman et al. (1993); Redelmeier and Kahneman (1996) | Does the journey's peak actually happen in play? Do fights end on a high? | A2, level 12 |
| C9 | **Elegance** | Rosewater, *Lenticular Design* and *New World Order* (2011) | Does the core rule carry exceptions? Is complexity kept off the board? | M2 |
| C10 | **Feedback loops** | Adams and Dormans, *Game Mechanics: Advanced Game Design* (2012) | Is every positive loop damped? | B3, M6 |
| C11 | **Kit coherence** | The standard's gears (M3); Riot's champion design for clarity and mastery | Does each piece create, change or spend the state, and does the ultimate read it? | M3, K1, K3 |
| C12 | **A journey with a shape** | Kishōtenketsu as used by Koichi Hayashida (Nintendo, 2012): introduce, develop, twist, conclude | Do levels 1–12 tell a story the player can feel? | M4, §7.4 |
| C13 | **Skill versus chance** | Schell (lens of skill vs chance); the standard's trap "randomness in a mechanic built on planning" | Does randomness work against the axis? | I5, P10 |
| C14 | **Cost honesty** | Schreiber and Romero, *Game Balance* (2021); `22.06` | Are combos priced at the best case minus setup, and does nothing ship on "nerf later"? | B1–B4 |

---

## 3. Audit of the current design (Depth Model)

✅ yes · ⚠️ partly · ❌ no. Each line has its evidence; the suggestion that answers a ⚠️ or ❌ is named.

| # | Question | Mark | Evidence | Answered by |
|---|---|---|---|---|
| I1 | Fun to play | ⚠️ | The reaction turn is satisfying; the silenced turns at levels 1–4 and the solved release from level 5 are not | S1 |
| I2 | Striking trait | ✅ | "Pour a second emotion into a mood and it reacts" | — |
| I3 | Archetype in the abilities | ✅ | The empath who plays the room: every Surge reads what the creature already feels | — |
| I4 | Mechanic feels like the Aspect | ✅ | Reading a mood, then choosing the second emotion, *is* empathy | — |
| I5 | Unique question (axis) | ✅ | Combination; no other subclass asks "what goes with what?" | S14 protects it on PC |
| I6 | Names belong to the theme | ✅ | Plutchik, Temperance, Iris, Harmonia | S15 (one text) |
| S1–S6 | Sources | ✅ | Card, myth, science and fiction each lend a named piece (DESIGN §2) | — |
| W1–W2 | Mystra and the Weave | ✅ | Threads plucked, braided, snapped | — |
| M1 | New, exclusive mechanic | ✅ | Peaks, moods, feelings, Catharsis | — |
| M2 | One rule, explained once | ⚠️ | Intensify is an exception ("the mood is spent" — except here); Catharsis taught at 1, usable at 3 | S4, S5 |
| M3 | Gears that talk | ⚠️ | Create, change and spend exist; the ultimate and the cantrip barely read the state | S2, S10 |
| M4 | Grows every odd level | ⚠️ | Something every odd level, but levels 7 and 9 are mostly "more table"; states never grow | S6, S8, S9 |
| M5 | Both sides take part | ✅ | Every reaction exists on allies and enemies (R41) | — |
| M6 | Chains finite and ordered | ⚠️ | No chain between reactions (R7), but Intensify loops the same mood forever | S4 |
| K1 | Key features drive the mechanic | ✅ | The Surges are the mechanic | — |
| K2 | Exclusive | ✅ | Nothing vanilla does buff-or-debuff by combination | — |
| K3 | A feature ties it together | ⚠️ | Emotional Overload exists but ignores what it spends | S2 |
| K4 | Passives fit | ✅ | Each passive is a rule of the wheel | — |
| K5 | Passives drive the core | ⚠️ | They unlock rings; the player cannot see which pairs changed | S7 |
| K6 | Two plays early, a fallback | ⚠️ | Temper at 3 ✅; Heartstring is a weak fallback that barely touches the state | S10 |
| P1 | Combat style | ✅ | Back line, 18 m | — |
| P2 | Versatile, on purpose | ✅ | — | — |
| P3 | Something the party feels | ✅ | Love, Hope, Ecstasy, Admiration on allies | — |
| P4 | Mechanic from level 1 | ⚠️ | Yes, but with only two outcomes (Love, Submission) and a penalty-only meter | S1, S5 |
| P5 | Setup pays inside a fight | ✅ | A reaction on turn 2, refunded | — |
| P6 | Real decision most turns | ⚠️ | Yes for Surges; the Overload release is solved from level 5 | S1 |
| P7 | State readable in the UI | ⚠️ | Statuses are visible, but the wheel lives only in the player's head | S7 |
| P8 | Works when the AI ignores it | ✅ | Behaviour peaks use vanilla types | — |
| P9 | Weaknesses real and visible | ✅ | Setup turn, WIS saves, constructs | — |
| P10 | Console plays the same | ✅ | Stats, Osiris, Khonsu only | — |
| A1 | Goal counts the mechanic | ✅ | Reactions caused | — |
| A2 | Tiers push the theme | ⚠️ | Tier I is two numbers and a card; Tier III rarely shows | S9, S11 |
| A3 | Aspect card differs from the ultimate | ✅ | Field (The Two Cups) vs one target (Emotional Overload) | — |
| B1 | Close to the benchmark per band | ⚠️ | Emotional Overload ≈ 30–40 % of D since R31 (`22.05`) | S2, S3 |
| B2 | Combos at best case minus setup | ⚠️ | The ultimate needs no setup on its target | S2 |
| B3 | Every loop capped | ❌ | The Intensify loop (Appendix A) | S4 |
| B4 | Leans weak where unsure | ⚠️ | Harmony and the Overload are flagged "watch" but shipped strong | S3, S4 |
| T1–T4 | Technical | ✅ | Generator, proven patterns, glossary ids | — |
| D1 | Identity Sheet complete | ✅ | — | — |
| D2 | Sources agree | ❌ | Four contradictions (§5, S16) | S16 |

---

## 4. Diagnostic data

### 4.1 Reaction outcomes the player can make, per level

From the wheel order (Joy, Trust, Fear, Surprise, Sadness, Disgust, Anger, Anticipation) and the unlock levels in
`DESIGN.md` §4.3 and §10. Derivation in Appendix B.

| Level | Emotions known | Outcomes possible | New at this level | Rule taught but unusable |
|---|---|---|---|---|
| 1 | Joy, Trust, Fear | **2** (Love, Submission) | 2 | Catharsis (no opposite pair known) |
| 3 | + Anticipation, Surprise, Sadness | **7** | 5 | — |
| 5 | + Disgust, Anger | **20** | **13** | — |
| 7 | — | **28** | 8 (intense ring) | — |
| 9 | — | **36** | 8 (tertiary ring) | — |

Level 5 is a cognitive cliff: thirteen new outcomes, two new Surges and the ultimate in one level-up, against a
working memory of about four chunks (C5).

### 4.2 The Overload, today

| Level | Meter size | Turns *Overloaded* if full | What the Resonant can do while *Overloaded* |
|---|---|---|---|
| 1 | 5 | 1 | Weapon attacks (+Psychic rider). No spell, not even the cantrip |
| 3 | 8 | 3 | Same — three turns is most of a normal fight |
| 4 | 8 | 4 | Same |
| 5+ | 11+ | char. level | Emotional Overload as a Bonus Action ends it at once |

The chassis (STR 8, DEX 10, daggers and darts, no Extra Attack) makes a weapon turn worth roughly
0.5 × (1d4 + 1d6 Psychic) ≈ 3 points at tier 1 — about **0.75 A**, under the cantrip turn the Resonant could not cast.
Before level 5 the full meter is a loss; from level 5 it is a button pressed at once.

### 4.3 When the level-12 peak can happen

- Tier III wakes at 15 reactions ≈ **turn 5** (`22.05`, report §3).
- The meter fills ≈ **turn 4** (size 3 × slot level + 2).
- A player who releases Emotional Overload on turn 4 (before Tier III) refills it ≈ turn 8.
- So the area Emotional Overload — the journey's peak — needs a fight of ≈ 8 turns, or a player who *holds* a full
  meter (silenced) from turn 4 to turn 5. Boss fights run 6–8 turns (`_SUBCLASS_STANDARD` §4.2); most fights never
  show it.

### 4.4 Values that never grow

| State | Level 1 | Level 12 |
|---|---|---|
| Moods (e.g. Accepting +1 AC, Apprehensive −1d4 WIS saves) | flat | flat |
| Feeling dice (Remorse 1d6, Aggressiveness 1d4, Delight 1d6, Pessimism 1d6, Morbidness 1d6) | flat | flat |
| Catharsis | 2d8 | 4d8 (+1d8 Tier I) |
| Surge targets | 1 | 6 |

Only Catharsis and target count grow. At level 11 an Aggressiveness of 1d4 is noise next to a martial's damage.

### 4.5 Durations that rarely matter

Moods last 5 turns (7 with Tier I) and normal fights last 3–5. Two features extend moods by 2 more turns
(Heartstring, Tier I). In a typical fight the mood is spent by a reaction or the fight ends long before either
extension counts: the bonus exists on paper and almost never in play.

---

## 5. The suggestions in detail

Each suggestion follows the same order: **problem · evidence · why it matters · proposal · alternatives · impact ·
risks · how to verify**.

---

### S1 · The Overload ladder

**Problem.** The Overload is the subclass's identity cost ("the Resonant feels what they make others feel"), but it is
built as a penalty for levels 1–4 and as a free button from level 5.

**Evidence.**
- R29: a full meter makes the Resonant *Overloaded* for turns equal to the character level: silenced (no spells, the
  cantrip included), Psychic damage each turn, a Psychic rider on weapon attacks.
- §4.2 above: a weapon turn is ≈ 0.75 A on this chassis; at level 3–4 the silence covers most of a fight.
- R48: from level 5 Emotional Overload is a Bonus Action and not a spell, so it ends *Overloaded* immediately.
  Holding means staying silenced, which is never better than releasing; R11's intended choice ("release now, or hold
  for the right target") no longer exists.
- The meter carries over between fights (R31), so the silence can start in a fight the player did not prepare for.

**Why it matters.**
- *C6, loss aversion:* losses weigh about twice as much as equal gains. A mechanic that removes the player's turns
  is felt as punishment even when the math is fair. World of Warcraft's beta shipped a "fatigue" penalty for playing
  too long; the same math reframed as a *rested* bonus turned a hated rule into a loved one.
- *C4, interesting decisions:* from level 5 the release has a dominant answer.
- *C2 and C12, felt progression:* the signature button exists only from level 5 and changes once more at 12. A tool
  that visibly upgrades is the clearest progression a player feels (League of Legends ranks every ultimate at 6, 11
  and 16; the Resonant already borrows from Seraphine).

**Proposal.**
1. **One button, three ranks.**
   - **Level 1 — *Outburst*** *(working name)*: Bonus Action, only with a full meter, not a spell. A small release on
     one enemy within 18 m: Psychic damage per feeling it carries and a short, saveable control ‹Frightened 1 turn,
     Wisdom save›. Empties the meter.
   - **Level 5 — Emotional Overload** replaces it (S2 defines how it reads feelings).
   - **Level 12 — the area** (Tier III, as today; S11 makes sure it shows).
2. ***Overloaded* becomes a risky power state.** While the meter is full the Resonant is **not silenced**. Instead:
   - Psychic damage at the start of each of their turns (as today) — the pressure;
   - their Weave Surges hit harder ‹non-allies roll the save with Disadvantage› — the temptation;
   - the weapon rider stays for players who build for it.
   - If *Overloaded* runs out without a release, the Resonant **breaks down**: ‹silenced 1 turn›, and the meter
     empties. The duration stays short ‹2–3 turns›, not the character level.
3. The choice becomes *push your luck* (axis "risk" borrowed for one feature, without becoming the subclass's axis):
   ride the stronger Surges and take the damage, or release now on the best target.

**Alternatives considered.**
- *Meter and release both at level 5 (the original R13).* Simplest and removes the punishment, but loses the
  identity at levels 1–4 that R29 wanted. Kept as the fallback if S1 fails playtest.
- *Keep R29 with a 1-turn silence.* Softer, but still a pure loss and still a solved release from level 5.
- *Make the release a free action.* Removes even the Bonus Action cost; makes the decision weaker, not stronger.

**Impact.** Design §6, §8, §10 · master data `FEAT_Resonant_Overload` (new fields for the power state and the
breakdown, the Outburst values) · new spell `SPL_Resonant_Outburst` · Osiris `ARCANA_Resonant_Overload` (apply the
power state instead of the silence; break down on `TimeOut`) · texts (`32.01`) · test cases (`61.02`) · player guide.
Console: same, nothing needs SE.

**Risks.** The power state could make the Resonant *want* to stay Overloaded through a whole fight. The damage per
turn and the short duration are the brake; the playtest metric below checks it.

**How to verify.** Level 3 and level 7 fights: turns spent Overloaded, how often the player rides it vs releases at
once, HP lost to it. *Wrong if* the player always releases on the first turn (no tension) or always rides to the
breakdown (no cost).

---

### S2 · Emotional Overload reads the feelings it spends

**Problem.** The ultimate is the feature that should tie the mechanic together (K3), but its main effect ignores the
mechanic.

**Evidence.** `SPL_Resonant_EmotionalOverload`: Paralysed 2 turns, **no saving throw**, on any enemy; each feeling
spent adds 1d6 Psychic. The balance report says it plainly: "the target usually carries 1–2 feelings; the value is
the paralysis." Paralysed is worth ≈ 3.5 A per turn (`22.06` §8), so the paralysis is ≈ 7 A against a few points of
damage from the feelings.

**Why it matters.**
- *C11 and K3:* the ultimate should reward the play that leads to it. Today the best Emotional Overload target is
  simply the biggest enemy, braided or not.
- *C14, B2:* a strong effect with no setup on its target is a combo priced at its best case with no assembly cost.
- The Tier III area already reads feelings ("every enemy within 6 m carrying one of your feelings"). The base
  ultimate should follow the same rule, so rank 3 extends rank 2 instead of changing its logic.

**Proposal** (two options; the first is recommended).
- **Option A — duration per feeling.** Paralysed for ‹1 turn per feeling spent, at least 1, at most 3›. Feelings
  stack additively (R47) and coexist on a creature, so "how many feelings have I braided into it?" becomes the
  question that leads to the ultimate. The damage per feeling stays.
- **Option B — save gate.** No saving throw if the target carries at least one of the Resonant's feelings;
  otherwise a Wisdom save. The paralysis stays 2 turns.

**Alternatives considered.** Keep the paralysis and raise the damage per feeling: still a number, and the paralysis
still dominates the value.

**Impact.** Design §6.1 · master data `SPL_Resonant_EmotionalOverload` · Khonsu/Stats of the spell (the duration
per feeling needs Osiris to count the spent feelings — the spell already removes each `FEELING_*` with damage per
feeling, so the count exists) · texts · tests.

**Risks.** With Option A an unbraided target gets only 1 turn; the ultimate could feel weak if the player releases
early. That is the intent: it pushes the player to braid first. Option B keeps a safer floor.

**How to verify.** Feelings on the target at the moment of release (average and distribution); boss turns lost.
*Wrong if* the average is under 1.5 feelings (players can't build them — lower the bar) or the fight ends on the
release every time (still too strong).

---

### S3 · Overload frequency

**Problem.** Since R31 the meter carries over between fights. The studio's standard and the design's own edge-case
table say the opposite, and the balance verdict is "likely above band".

**Evidence.**
- `_SUBCLASS_STANDARD.md` §7.4: "A feature that uses a resource fills it by playing the mechanic, shows it on a
  status with a count, and **resets it when combat ends**."
- `DESIGN.md` §4.8: "Combat ends — the Overload meter resets" — contradicts §6 and R31 in the same file.
- `22.05/Resonant.md`: up to 3–4 Emotional Overloads per day ≈ **30–40 % of D**, against a target of 10–20 %.

**Why it matters.** *B1, C14:* a main feature at three times its budget. *C7:* carry-over also makes the meter's
pace unpredictable — the first fight of the day and the fourth play differently for no reason the player sees.

**Proposal.**
1. Decide the rule once and write it in both places (the standard and §4.8 of the design).
2. Recommended rule, one line in the tooltip: **"After a fight, the meter settles to half."** The Resonant still
   carries what they felt (R31's identity), but a day can't bank whole meters.
3. Together with S2 (each release needs braiding) the frequency matters less, because each use costs setup.

**Alternatives considered.**
- *Reset at combat end (the standard).* Predictable, but the meter fills ≈ turn 4 — too late in normal fights; the
  ultimate would show only in long ones.
- *Reset on Short Rest.* Thematic (rest heals compassion fatigue) but still allows several full meters between rests.
- *A bigger meter.* Pushes the release later in every fight, which hurts the fights that matter most.

**Impact.** Standard §7.4 (an exception clause, or a change of rule — Owner's call) · design §4.8, §6 · Osiris
`ARCANA_Resonant_Overload` (halve on combat end) · `26.01/Resonant.md` · `22.05/Resonant.md` · texts.

**How to verify.** A full adventure day at level 5–7 (four fights, no long rest): releases per day. *Right if* 1–2;
*wrong if* 3 or more.

---

### S4 · Intensify spends the mood

**Problem.** Intensify is the only reaction that gives its mood back, and with the refund it becomes an unbounded
loop.

**Evidence.**
- `DESIGN.md` §4.3, the core rule: "…reacts with it instead of landing alone, … **and the mood is spent**."
- `DESIGN.md` §4.2 and `STA_Resonant_States`: Intensify lasts 1 turn, "**then the mood returns**" (5 turns).
- §4.4: a reaction refunds the slot, once per turn. Tier II: once per turn a Surge costs no action.
- Result (Appendix A): Joy on a Serene ally → **Ecstasy (+1 action)**, slot refunded; Ecstasy ends → Serene returns;
  next turn, again. From level 7 an ally gains an extra action **every turn for 0 slots**; after Tier II, also for
  **0 actions**. Admiration (resistant to all damage, immune to Charmed and Frightened) loops the same way on the tank.

**Why it matters.**
- *C10, B3:* a positive loop with no damping. An extra action is "the most valuable resource in the game"
  (`_SUBCLASS_STANDARD` §4.1); free every turn it is Haste without Concentration or a slot.
- *C9, M2:* the exception makes the core rule false in one case. Removing it makes the rule true everywhere.

**Proposal.** Intensify **spends the mood**, like every reaction. To intensify again, the creature needs a new mood
(a peak that fades, Temper, Harmony's free Surge). The loop becomes a two-turn cycle that costs a slot each time.

**Alternatives considered.**
- *Intensify gives no refund.* Keeps the exception and still loops for one slot per turn.
- *Weaken Ecstasy (e.g. a bonus action instead of an action).* Fixes one state, not the loop; Admiration and
  Vigilance still repeat.

**Impact.** Generator table in `gen_emotion_alchemy.pl` (the intense statuses' `OnRemoveFunctors` no longer
re-apply the mood) · design §4.2, §4.3 · `STA_Resonant_States` note · texts of Overwhelm and the intense statuses
("then the mood returns" leaves the strings) · tests.

**Risks.** Intensify becomes less sticky; at level 7 this is the intent.

**How to verify.** Level 7–9 fights: extra actions granted per fight. *Wrong if* Ecstasy appears on the same ally on
consecutive turns.

---

### S5 · Teach Catharsis at level 3

**Problem.** Emotional Alchemy (level 1) explains Catharsis, but no pair of opposites exists until level 3.

**Evidence.** Level-1 Surges are Joy, Trust and Fear. Their opposites are Sadness, Disgust and Anger, none of which
is known before level 3. The first possible Catharsis is Joy ↔ Sadness (level 3).

**Why it matters.** *C5:* a rule taught before it can be used is pure load; by the time it becomes usable the player
has forgotten it. Teaching it when it arrives also gives level 3 a **new rule**, not just three more buttons (C2).

**Proposal.** Split the explanation: Emotional Alchemy at level 1 explains peaks, moods, distance 1 and the refund;
a short passive at level 3 *(working name: Opposites)* explains Catharsis. Level 3 then delivers the rule, the Surge
that makes it possible (Sadness) and the card that uses it on the whole field (The Two Cups) together.

**Impact.** Generator (passive texts; a new passive id per `33.03`) · progression (`Progressions.lsx`, level 3) ·
design §4.3, §8, §10 · texts · tests. No balance change.

---

### S6 · Option: Overwhelm at 5, Complex Feelings at 7

**Problem.** Level 5 adds 13 outcomes at once (§4.1).

**Proposal.** Swap the two rings:
- **Level 5 — Overwhelm (distance 0):** 8 intense emotions, all of them "more of the same" (Fear → Terror,
  Joy → Ecstasy, Surprise → Amazement). The easiest ring to learn: the player already knows the emotion.
- **Level 7 — Complex Feelings (distance 2):** 8 secondary dyads, new names to learn, when level 7 has room.

**Why.**
- *C5:* level 5 still adds 13 outcomes in count, but 8 of them are predictable from what the player already knows,
  so the *new knowledge* falls to about 5 (the outcomes the two new Surges open).
- *Science (S5 of the standard):* Plutchik's model is a cone — intensity is its vertical axis. Intensity before the
  wider dyads follows the model.
- *Theme:* level 5 becomes **Excess** — Temperance reversed — together with the Overload's release.
- *Power:* the intense ring on enemies (Terror, Amazement, Grief) needs two saves in a row (≈ 0.36 at tier 2) and
  sits inside the vanilla level-5 spike (Fear, Hypnotic Pattern, Haste). This holds **only with S4**, which removes
  the Ecstasy loop.

**Why it is only an option.** It moves a passive the Owner already placed (R13/R29 era) and needs a balance check of
Intensify two levels earlier. If S4 is not adopted, S6 must not be either.

**Impact.** Progression (levels 5 and 7) · design §4.3, §8, §10 · `21.03/Resonant.md` · tests · player guide.

---

### S7 · Each mood tells what it can become

**Problem.** The wheel lives only in the player's head. The UI shows "Mood: Serene", never "Trust here makes Love".

**Why it matters.** *P7, C2:* competence needs feedback the player can read at the moment of the decision. The core
question of the subclass — *which emotion on whom, on top of what?* — should be answerable by hovering the target.

**Proposal.** Each mood's description lists its reactions, marked by the level that unlocks them:

> *Mood: Serene* — "… Pour **Trust** → Love · **Anticipation** → Optimism · **Sadness** → Catharsis ·
> **Fear** → Guilt (level 5) · **Joy** → Ecstasy (level 7) · …"

Each Surge's description lists, in the same way, the moods it reacts with. The generator already writes every
string from one table, so this is a text column, not hand work.

**Impact.** Generator (`gen_emotion_alchemy.pl`, description builder) · `32.01/Resonant.md` (Narrative gate) ·
localisation size (longer strings) · no gameplay change.

**Risk.** Long tooltips. Mitigation: only the outcome names, no effects; the effect is one hover away on the
feeling's own status.

---

### S8 · States grow at the class's breakpoints

**Problem.** Moods and feelings are the same at level 12 as at level 1 (§4.4).

**Why it matters.** *C2:* "Is each level's power gain noticeable?" (`27.01`). The Resonant's power is in its states;
if the states never grow, the player feels the subclass plateau while vanilla spells keep scaling.

**Proposal.** Two steps, at **level 5 and level 10** — the same breakpoints as Catharsis and the cantrips, so the
player learns one rhythm:
- Moods: the penalty or bonus moves up one step ‹−1d4 → −1d6 → −1d8; +1 AC → +2 at 10›.
- Feeling dice: one die size per step ‹1d4 → 1d6 → 1d8›; Optimism already scales with Intelligence.
- The level-up text names it: *"Your moods and feelings grow stronger."*

**Alternatives.** Scale by slot level (the upcast pattern): smoother but invisible; the player never notices a step
they did not see announced.

**Impact.** Generator (statuses by level, the "one version per spell level" pattern of the standard §5) · master data
`STA_Resonant_Feelings` and moods (`by_level`) · balance pass · texts.

**How to verify.** Level 10 fights: share of the Resonant's turns spent on reactions vs on Heartstring. *Wrong if*
reactions stop being worth a turn at tier 3.

---

### S9 · Tier I becomes sympathetic resonance

**Problem.** Tier I *Resonance* is "Catharsis +1d8, moods last 2 turns longer, and The Two Cups". Two of the three
are numbers, and one of the numbers rarely counts (§4.5).

**Why it matters.** *A2:* the standard asks each tier to change *how the mechanic runs*. Tier II does (a free Surge
that leaves its mood at once); Tier III does (the area). Tier I mostly doesn't.

**Proposal.** Replace "moods +2 turns" with **sympathetic resonance**, the physics behind the tier's name — a string
that vibrates makes the strings tuned to it vibrate:

> **When one of your Weave Surges causes a reaction, the nearest creature of the same side within ‹3 m› catches the
> mood that was spent.**

- It is a mood from another source, so it **replaces, never reacts** (R7): no chain can form.
- It refills the field after a reaction, so the next Surge has something to pour into — the tier makes the mechanic
  *flow*.
- Catharsis +1d8 and The Two Cups stay.

**Overlap check.** Emotional Contagion (level 9) spreads moods to *every* ally of the target, *each turn*, with
Concentration. Resonance spreads to *one* neighbour, *once per reaction*. Contagion stays the mass tool.

**Alternative.** Keep Tier I as it is and only remove the mood extension (simpler, but leaves the tier flat).

**Impact.** Osiris (on a reaction status landing, find the nearest same-side creature and apply the spent mood — the
reaction is already detected for the refund in `ARCANA_Resonant_Overload`) · T2 test (nearest-creature selection must
be proven against a vanilla or mod pattern first) · design §9 · master data `FEAT_Resonant_AspectAwakening` · texts.

---

### S10 · Heartstring reads feelings

**Problem.** The fallback turn is weak (≈ 1.4 points at tier 1 against A = 4) and its rider — a mood lasts 2 turns
longer — rarely matters (§4.5).

**Why it matters.** *K6, M3:* the cantrip is the turn the player falls back on; it should belong to the mechanic, not
sit beside it.

**Proposal.** Heartstring deals **extra Psychic damage for each feeling the target carries** ‹+1d4 per feeling›.
The mood extension leaves.
- It reads the accumulation that S2 makes the ultimate read, so a turn without a reaction still advances the same plan.
- Late in a fight, on a creature braided two or three times, the cantrip becomes a real hit — a reason to keep
  feelings on enemies.

**Alternative.** A "pluck" Heartstring that ends a peak early so it fades into its mood now. It solves tempo, but it is
an action, so it can't pair with a Surge on the same turn before Harmony; the gain is small for a big rule.

**Impact.** Master data `SPL_Resonant_Heartstring` · the spell (a damage functor conditioned on feelings — needs a
vanilla example of damage scaled by status count, T2) · texts.

---

### S11 · Waking Tier III fills the Overload

**Problem.** The journey's peak (the area Emotional Overload) rarely happens in play (§4.3).

**Why it matters.** *C8, peak-end:* people judge an experience by its peak and its end. The level-12 promise ("the
overload spills over every enemy they have touched", DESIGN §1) is the end of the Resonant's journey; if it shows once
in ten fights, the journey ends flat.

**Proposal.** **When *Aspect of Empathy* wakes, the Overload fills at once** ("the dam breaks"). The awakening becomes
a moment the player sees every time — like The Two Cups at Tier I — and the area release is available right then.

**Alternatives.** Lower the Tier III goal (15 → ‹10›): it shows more often but still depends on two timers lining up.

**Impact.** Osiris `ARCANA_Aspect_Temperance` (on Tier III, set the meter to full through the same path that applies
`RESONANT_OVERLOAD_FULL`) · design §9 · texts · tests. Balance: one extra release per long fight at level 12, inside the
Tier III peak (`22.05` §2 estimates the area at ≈ 4.7 A per use).

**How to verify.** Level 12 long fights: the area release happens in *every* fight that wakes Tier III.

---

### S12 · Shared Heart: a payoff on cast, and only helpful feelings shared

**Problem.**
1. The capstone costs an Action and a level-5 card and does **nothing on the turn it is cast**.
2. It shares **any** feeling braided in a linked creature, including hindering ones.

**Evidence.** R46: "a feeling braided in one linked creature is braided in every linked creature". Hindering feelings
can land on allies: the player may do it on purpose (R41), and Ready: Compassion does it on its own (S13) — Trust on an
ally carrying *Apprehensive* braids **Submission** (Prone). With the link active, the whole party is knocked Prone.
Emotional Contagion had the same class of bug and was fixed by R35 ("a bright mood stays on its side").

**Why it matters.** *C8:* a capstone is remembered by its cast. Vanilla level-11 spells (Heal, Chain Lightning, Sunbeam,
Globe of Invulnerability) all change the board on the turn they are cast.

**Proposal.**
1. **On cast, every linked creature feels Joy** (the peak: Advantage on the next attack for it and its allies near it).
   When Joy fades it leaves *Serene* on the whole party — the setup for the first shared reaction next turn. It is a
   peak, not a reaction, so it doesn't count for the refund, the Overload or the Awakening (R7, R19).
2. **Only helpful feelings (A) are shared.** A hindering feeling stays on the creature it was braided in.

**Impact.** Osiris `ARCANA_Resonant_SharedHeart` (filter by the feeling's side — the generator table already marks A/I)
· the spell (apply the Joy peak on cast) · design §7.6 · texts · tests.

---

### S13 · Ready: Compassion moves to level 7 and stays kind

**Problem.**
1. Level 11 holds the capstone and a second card, which dilutes the capstone's moment; level 7 has no new action at all.
2. Compassion casts Trust automatically, so it can braid Submission on an ally (S12).

**Proposal.**
1. Move Ready: Compassion to **level 7**. Level 7 gains an action (a reaction card), level 11 is the capstone alone.
2. Compassion's Trust **does not react with a hindering mood**: on an ally carrying Apprehensive it lands as a plain
   peak. (Trust with every other mood gives Love, Hope, Curiosity, Admiration, Sentimentality, Dominance or a healing
   Catharsis — all good.)

**Balance.** A level-3 card at slot level 4 (level 7). It casts a level-1 Surge, once per round; at level 7 that is in
band. Re-check its value against Harmony, which also wakes at 7.

**Impact.** Progression (levels 7 and 11) · the interrupt's condition · design §7.4, §10 · `21.03/Resonant.md` ·
tests · player guide.

---

### S14 · PC edition: the right emotion in hand

**Problem.** In the PC edition every Surge is a separate card in a deck (3 copies each, hand 4, draw 1 per turn —
`_SUBCLASS_STANDARD` §5). The Resonant's skill is choosing the *exact* emotion that reacts with a mood. With eight
Surges in the deck, the chance of holding the one you need is low.

**Evidence.** Appendix C: with an assumed 30-card deck, the chance of holding a specific emotion is **≈ 43 % by
turn 2 and ≈ 50 % by turn 3**.

**Why it matters.** *C13:* the standard lists "randomness in a mechanic built on foresight or planning" as a trap. On
PC the deck turns the Combination axis into "what did I draw?". *Complexity budget:* eight Surge buttons plus seven
other actions is about fifteen hotbar entries by level 12, against the suggested three new actions per subclass.

**Proposal** (in order of cost).
1. **Measure first.** In the PC playtest, record the share of turns where the needed Surge was not in hand. If it is
   under ‹25 %›, stop here.
2. **One card, eight choices.** A single *Weave Surge* card that opens a choice of the emotions the Resonant knows
   (the mod already uses a container for Command, the Hemoplague pattern). On console it is also one hotbar button
   with a list — the list *is* the wheel, in wheel order, growing as the Resonant levels up (a visible progression of
   its own).
3. **A cheaper middle:** keep separate cards but give the Resonant a keyword the deck already has (*Choose*) on one
   card that fetches a Surge.

**Why it is "could".** It touches the deck rules — a **base-class change** (§6 of the standard): it needs an impact
matrix across every subclass and the Owner's approval. It also changes upcast variants and deck counts.

---

### S15 · Anger's intent, said plainly

**Problem.** Anger on an enemy "attacks the last creature that hurt it" — usually the party member who hit it, which
the enemy may have done anyway. Players will read it as a weak peak.

**Proposal.** Keep the rule; change the text and the intent sentence: *Anger is a taunt* — the tank hits first, then
Anger locks the enemy onto the tank and away from the back line. On an ally, Anger focuses it on whoever hurt it. The
"How it plays" section names the combo.

**Impact.** Texts (`32.01`), design §5.1, §11.2, player guide. No mechanic change.

---

### S16 · Documentation fixes

| Where | Says | Should say |
|---|---|---|
| `DESIGN.md` §4.8, row "Combat ends" | "The Overload meter resets" | The rule chosen in S3 (today: carries over, R31) |
| `DESIGN.md` §7.4 | "when an ally within 9 m takes damage" | "…takes damage from an enemy" (the 2026-10-12 bug fix) |
| `DESIGN.md` §8 | Overload (level 1) listed after Complex Feelings (level 5) | Ordered by level |
| `21.08_Subclass_Matrix.md`, "Level rhythm" | Every subclass gets cards at 1, 3, 5, 7, 9, 11 | The Resonant gets none at 7 (until S13) |
| `_SUBCLASS_STANDARD.md` §7.4 vs R31 | Meters reset at combat end | One rule, or a stated exception (S3) |

---

## 6. The proposed progression, levels 1–12

### 6.1 The arc

The current "Why this order" explains *what unlocks*; it doesn't tell a story. Using the kishōtenketsu shape (C12) and
the card's own two faces — Temperance upright (blending, balance) and reversed (excess) — the journey reads:

| Act | Levels | Name | What the player feels |
|---|---|---|---|
| Introduce | 1–3 | **Feeling** | "I can read what they feel and change it — and opposites snap." |
| Develop | 5 | **Excess** | "I can push an emotion to its extreme — and so can my own heart." |
| Twist | 7–9 | **Blending** | "Two emotions make a third; one reaction feeds the next." |
| Conclude | 11–12 | **Union** | "The whole party shares one heart; everything I felt spills over the field." |

The same arc can carry the level-up texts (Narrative gate). In the Thoth deck the card is *Art*, the alchemist's
union of opposites; the four acts mirror the alchemical work (dissolving, purifying, mixing, uniting) without needing
new names in game.

### 6.2 The table — current and proposed

| Level | Current | Proposed | Headline the player feels |
|---|---|---|---|
| **1** | Surges Joy, Trust, Fear · Heartstring · Emotional Alchemy (distance 1 + Catharsis + refund) · Empathic Sight · Overload (silence when full) | Same Surges · **Heartstring reads feelings** (S10) · Emotional Alchemy (distance 1 + refund) · Empathic Sight · **Overload with *Outburst*** and the power state (S1) | *Pour, braid, and let it out* |
| 2 | — | — | (base class) |
| **3** | Surges Anticipation, Surprise, Sadness · Temper · Tier I + The Two Cups | Same · **Catharsis taught here** (S5) · Tier I **sympathetic resonance** (S9) + The Two Cups | *Opposites snap — on one creature or the whole field* |
| 4 | — | — | (feat) |
| **5** | Surges Disgust, Anger · Complex Feelings (distance 2) · Emotional Overload | Surges Disgust, Anger · **Overwhelm (distance 0)** (S6, option) · **Emotional Overload, reads feelings** (S2) · **states grow** (S8) | *Excess: the extreme of every emotion, and the release of my own* |
| 6 | — | — | (base class) |
| **7** | Overwhelm (distance 0) · Tier II Harmony | **Complex Feelings (distance 2)** (S6) · **Ready: Compassion** (S13) · Tier II Harmony | *Blending deepens; I answer an ally's pain* |
| 8 | — | — | (feat) |
| **9** | Mixed Feelings (distance 3) · Emotional Contagion | Same | *The whole wheel; a mood spreads through a crowd* |
| 10 | — | **States grow** (S8) | *Every emotion I pour is stronger* |
| **11** | Shared Heart · Ready: Compassion | **Shared Heart alone, with Joy on cast** (S12) | *One heart for the party* |
| **12** | Tier III: Emotional Overload in an area | Tier III: area, and **waking it fills the Overload** (S11) | *The dam breaks* |

*Level 10 uses an even level for the subclass. The standard allows it "when it has a reason"; here the reason is to
keep the state growth on the class's own breakpoints (5 and 10).*

### 6.3 The complexity curve after the changes

| Level | Outcomes possible | New knowledge at the level-up |
|---|---|---|
| 1 | 2 | 2 (Love, Submission) |
| 3 | 7 | 5 + the Catharsis rule |
| 5 | 20 (with S6: 8 of the 13 new are "more of the same") | ≈ 5 truly new |
| 7 | 28 | 8 secondary dyads |
| 9 | 36 | 8 tertiary dyads |

With S6 the steps become 2 → 5 → 5 → 8 → 8 instead of 2 → 5 → 13 → 8 → 8. With S7 every step is also readable in the
UI.

### 6.4 The signature button, rank by rank

| Level | Rank | What it does |
|---|---|---|
| 1 | *Outburst* | A small release on one enemy (S1) |
| 5 | Emotional Overload | Paralysis that grows with the feelings spent (S2) |
| 12 | Aspect of Empathy | The release reaches every braided enemy nearby, and the awakening itself fills the meter (S11) |

---

## 7. Balance impact

Directional estimates for the balance pass, in the currency of `22.06`. None of these is a final number.

| Suggestion | Direction | Estimate | Band check |
|---|---|---|---|
| S1 Overload ladder | **Up** at 1–4, **flat** at 5+ | Levels 1–4: removes silenced turns (≈ −0.25 A each) and adds a small release (≈ 1 A) about once a day. From 5 the release already existed | Tier 1 is the weakest band today; the gain is welcome |
| S2 Ultimate reads feelings | **Down** (Option A) | Unbraided target: 1 turn (≈ 3.5 A) instead of 2 (≈ 7 A). Braided twice: unchanged | Brings Emotional Overload towards 10–20 % of D |
| S3 Settle to half | **Down** | ≈ 3–4 releases/day → ≈ 2 | Into band together with S2 |
| S4 Intensify spends the mood | **Down** (removes a loop) | Removes up to ≈ 1–1.5 A per turn after Tier II | Fixes B3 |
| S6 Swap the rings | **Up** at 5, **down** at 5–6 for distance 2 | Intense on enemies ≈ two saves (≈ 0.36), in the vanilla 5 spike | Only with S4 |
| S8 States grow | **Up** at 5 and 10 | Mood and feeling values ≈ +20–40 % at each step | Compensates the plateau of tier 3 |
| S9 Sympathetic resonance | **Up** (slight) | ≈ +0.2 reactions per turn later in a fight | Replaces a bonus worth ≈ 0 |
| S10 Heartstring | **Up** late | +1d4 per feeling; ≈ +2.5 per braided target | Fallback approaches A at tier 3 |
| S11 Tier III fills the meter | **Up** at 12 | +1 area release per long fight (≈ 4.7 A) | Inside the Tier III peak |
| S12 Joy on cast | **Up** (slight) | ≈ +0.3 A per ally on the cast turn | Capstone budget ≈ 20 % of D |
| S13 Compassion at 7 | **Up** at 7–10 | Its full value four levels earlier | Check together with Harmony |

**Net reading.** Power moves *out* of the two places the balance report flags (Emotional Overload frequency, the
Intensify/Harmony stack) and *into* the places that feel flat (levels 1–4, the states at tier 3, the end of the
journey). The total should land close to today's, spread more evenly — what the standard asks for (§8.3: no spikes,
no dead levels).

---

## 8. Technical feasibility

Grounding rule (AGENTS.md §4): nothing below names a function or field from memory. Where a piece is new, it is
marked **T2** and needs a real vanilla or mod example (`56`, `57`) before a spec is written.

| Suggestion | Where it lives | Proven pattern in the mod | New piece (T2) |
|---|---|---|---|
| S1 | Osiris `ARCANA_Resonant_Overload`; a new spell; statuses | The meter, `RESONANT_OVERLOAD_FULL`, Emotional Overload as a non-spell Bonus Action | The power state's save modifier on Surges; the breakdown on `TimeOut` (pattern: `OnRemoveFunctors` with `RemoveCause(StatusRemoveCause.TimeOut)`) |
| S2 | Emotional Overload; Osiris | The spell already removes each `FEELING_*` with damage per feeling | Paralysis duration from a count (Osiris applies the status with a computed duration) |
| S3 | Osiris | Combat-end handling of the meter (it reset before R31) | Halving instead of resetting |
| S4 | Generator table | `OnRemoveFunctors` on intense statuses | None (a removal) |
| S5 | Progression, generator texts | Passives per level | A new passive id (`33.03`, ADR-0002 prefixes) |
| S6 | Progression | Passives per level | None |
| S7 | Generator description builder | Every string comes from one table | None |
| S8 | Generator; statuses by level | "One version per spell level" (standard §5) | None |
| S9 | Osiris | Reaction detection for the refund | Nearest same-side creature selection |
| S10 | Heartstring stats | Damage functors on the cantrip | Damage scaled by the number of `FEELING_*` statuses |
| S11 | Osiris `ARCANA_Aspect_Temperance` | Applying `RESONANT_OVERLOAD_FULL` | None beyond calling the existing path |
| S12 | Osiris `ARCANA_Resonant_SharedHeart`; the spell | Copying feelings to linked creatures | Side filter (the generator already tags A/I) |
| S13 | Progression; the interrupt | Enemy-source condition (2026-10-12 fix) | A mood condition on Trust's reaction |
| S14 | Deck (Lua), Stats container | Command's container (Hemoplague pattern) | Deck counts, upcast variants per choice — base-class change |

Every gameplay effect stays in Stats, Osiris and Khonsu, so both editions keep the same mechanic (rule 4 of
`CLAUDE.md`). S14 touches the deck only on PC; on console the container is a hotbar list.

---

## 9. How to verify (playtest plan)

To be merged into ARC-0010 (the Resonant balance playtest). One rule per test, as the standard asks.

| # | Fight | Metric | Right if | Wrong if | Suggestion |
|---|---|---|---|---|---|
| V1 | Level 3, normal fight | Turns spent *Overloaded*; ride vs release | Player sometimes rides, sometimes releases | Always releases at once, or always breaks down | S1 |
| V2 | Level 3, normal fight | Turns where the Resonant had nothing useful to do | 0 | ≥ 1 per fight | S1 |
| V3 | Level 7–9, boss | Feelings on the ultimate's target at release | Average ≥ 1.5 | Under 1.5 | S2 |
| V4 | Level 5–7, full day | Releases per day | 1–2 | ≥ 3 | S2, S3 |
| V5 | Level 7–9 | Ecstasy/Admiration on the same ally on consecutive turns | Never | Ever | S4 |
| V6 | Level 3 | Catharsis caused in the first two fights after level-up | ≥ 1 | 0 (rule not learned) | S5 |
| V7 | Level 5 | Player can predict the outcome before casting (ask) | ≥ 80 % | < 60 % | S6, S7 |
| V8 | Level 10 | Share of turns on reactions vs Heartstring | Reactions ≥ 50 % | Reactions < 30 % | S8, S10 |
| V9 | Level 12, long fight | Area release in fights that wake Tier III | 100 % | < 100 % | S11 |
| V10 | Level 11 | Hindering feelings shared through the link | 0 | > 0 | S12, S13 |
| V11 | PC, levels 3–9 | Turns where the needed Surge was not in hand | < 25 % | ≥ 25 % → adopt S14 | S14 |

Qualitative questions for the Owner after each session (Schell Games' playtest guide style): *What did you want to do
that you couldn't? When did you feel strongest? When did you feel the Resonant level up?*

---

## 10. Rollout and propagation

### 10.1 Order of decisions

The suggestions depend on each other. The recommended order for the brainstorm (one question per message, standard
§1.2):

1. **S4** (removes the loop; S6 depends on it).
2. **S1 → S2 → S3** (the Overload as one design: ladder, then what the ultimate reads, then how often).
3. **S11** (the end of the journey; depends on S1's ladder).
4. **S5, S7, S16** (text and teaching; cheap, no balance risk).
5. **S8, S9, S10** (vertical growth; one balance pass together).
6. **S12, S13** (capstone and level rhythm).
7. **S6** (option; after S4 is in).
8. **S14** (base-class change; only if V11 says so).
9. **S15** (text).

### 10.2 Where each approved decision goes (00.08)

| Artifact | Owner | Touched by |
|---|---|---|
| `21.04/Resonant/DECISIONS.md` (R49+) | Lead Class Designer | every approved S |
| `21.04/Resonant/DESIGN.md` | Lead Class Designer | every approved S |
| `21.03/Resonant.md` | Lead Class Designer | S1, S5, S6, S8, S13 |
| `21.08_Subclass_Matrix.md` | Lead Class Designer | S13, S16 |
| `_SUBCLASS_STANDARD.md` §7.4 | Lead Class Designer (Owner approval) | S3 |
| `25_Master_Data` (`FEAT_Resonant_*`, `SPL_Resonant_*`, `STA_Resonant_*`) | Spell + Balance Designers | S1, S2, S3, S8, S9, S10, S11 |
| `22.05/Resonant.md` | Balance Designer | S1–S4, S6, S8–S13 |
| `26.01/Resonant.md` | Balance Designer | S1, S3, S4 |
| `23.02/Resonant/*` | Spell Designer | S1, S2, S4, S5, S9, S10, S12, S13 |
| `32.01/Resonant.md`, `33.03` | Lore Writer | S1, S4, S5, S7, S9, S10, S12, S15 |
| `55` (spec, Toolkit guide) | Mod Engineer | every approved S that reaches the game |
| `61.02/Resonant` | QA Lead | V1–V11 |
| `05.02/Resonant.md` | Context Keeper | after the build |
| Player guide (ARC-0006) | Community | after the build |
| `42.04/Resonant.md` | Icon Artist | S1 (*Outburst* icon), S5 (new passive) |

---

## 11. References

**Game design**
- Hunicke, R., LeBlanc, M. and Zubek, R. (2004). *MDA: A Formal Approach to Game Design and Game Research.* AAAI
  Workshop on Challenges in Game AI.
- Schell, J. (2019). *The Art of Game Design: A Book of Lenses* (3rd ed.). CRC Press.
- Koster, R. (2004). *A Theory of Fun for Game Design.* Paraglyph Press.
- Adams, E. and Dormans, J. (2012). *Game Mechanics: Advanced Game Design.* New Riders.
- Schreiber, I. and Romero, B. (2021). *Game Balance.* CRC Press.
- Meier, S. (2012). *Interesting Decisions.* Game Developers Conference.
- Rosewater, M. (2011). *Lenticular Design* and *New World Order.* Making Magic, Wizards of the Coast.
- Hayashida, K. (2012). Interview on kishōtenketsu in *Super Mario 3D Land*'s level design. Gamasutra.

**Psychology of play**
- Ryan, R. M., Rigby, C. S. and Przybylski, A. (2006). The Motivational Pull of Video Games: A Self-Determination
  Theory Approach. *Motivation and Emotion*, 30, 347–363.
- Kahneman, D. and Tversky, A. (1979). Prospect Theory: An Analysis of Decision under Risk. *Econometrica*, 47(2).
- Kahneman, D., Fredrickson, B. L., Schreiber, C. A. and Redelmeier, D. A. (1993). When More Pain Is Preferred to
  Less: Adding a Better End. *Psychological Science*, 4(6).
- Redelmeier, D. A. and Kahneman, D. (1996). Patients' memories of painful medical treatments. *Pain*, 66(1).
- Sweller, J. (1988). Cognitive Load During Problem Solving. *Cognitive Science*, 12(2).
- Cowan, N. (2001). The magical number 4 in short-term memory. *Behavioral and Brain Sciences*, 24(1).
- Hull, C. L. (1932). The goal-gradient hypothesis and maze learning. *Psychological Review*, 39(1).
- Kivetz, R., Urminsky, O. and Zheng, Y. (2006). The Goal-Gradient Hypothesis Resurrected. *Journal of Marketing
  Research*, 43(1).
- Nunes, J. C. and Drèze, X. (2006). The Endowed Progress Effect. *Journal of Consumer Research*, 32(4).

**The subclass's own sources**
- Plutchik, R. (1980). *Emotion: A Psychoevolutionary Synthesis.* Harper & Row.
- Hatfield, E., Cacioppo, J. T. and Rapson, R. L. (1994). *Emotional Contagion.* Cambridge University Press.

**Studio documents** — `_SUBCLASS_STANDARD.md`, `27.01` (Fundamentals), `27.07` (Sources), `22.06` (Power Budget),
`22.05/Resonant.md`, `26.01/Resonant.md`.

---

## Appendix A — the Intensify loop, turn by turn

Level 7, Overwhelm known, Tier II not yet awake. An ally (the Fighter) and the Resonant.

| Turn | Resonant does | Fighter carries | Slots | Fighter gains |
|---|---|---|---|---|
| 1 | Weave Surge: Joy on the Fighter (no save) | Peak Joy | −1 | Advantage aura |
| (Fighter's turn) | — | Joy fades (`TimeOut`) → **Serene** | | |
| 2 | Weave Surge: Joy on the Fighter → **Ecstasy** (distance 0); refund | Ecstasy | ±0 | **+1 action** |
| (Fighter's turn) | — | Ecstasy ends → **Serene returns** | | |
| 3 | Joy again → Ecstasy; refund | Ecstasy | ±0 | **+1 action** |
| … | every turn | | ±0 | **+1 action every turn** |

After Tier II wakes, Harmony's free Surge does turn 2 onwards **without the Resonant's action**, and the Resonant
still has their action for something else. With S4, turn 3 has no mood to intensify: the Fighter must be given a new
mood first, and each Ecstasy costs a slot.

## Appendix B — reaction outcomes per level

Wheel positions: Joy 0, Trust 1, Fear 2, Surprise 3, Sadness 4, Disgust 5, Anger 6, Anticipation 7. Distance =
the shorter way round (0–4).

- **Level 1** (0, 1, 2): pairs at distance 1 → 0–1 Love, 1–2 Submission. Distance 2 (0–2, Guilt) locked. No pair
  at distance 4. **2 outcomes.**
- **Level 3** (+3, 4, 7): distance 1 → Love, Submission, 2–3 Awe, 3–4 Disapproval, 7–0 Optimism = 5. Distance 4 →
  0–4 and 3–7 = 2 Catharses. **7 outcomes.**
- **Level 5** (+5, 6, full wheel): distance 1 → 8 feelings; distance 4 → 4 Catharses; distance 2 (Complex Feelings)
  → 8 feelings. **20 outcomes.**
- **Level 7**: + distance 0 (Overwhelm) → 8 intense. **28.**
- **Level 9**: + distance 3 (Mixed Feelings) → 8 feelings. **36.**

## Appendix C — the PC deck and the right emotion in hand

Assumption (to check against `26.01/2026-09-17-deck-core-design.md`): at level 5 the Resonant's deck holds the eight
Surges (3 copies each = 24), Heartstring (3) and Temper (3) = **30 cards**; opening hand 4, draw 1 per turn.

The chance of holding at least one copy of a specific Surge after seeing *n* cards is
1 − C(27, n) / C(30, n):

| Cards seen | Turn | Chance |
|---|---|---|
| 5 | 2 | 1 − (25·24·23)/(30·29·28) ≈ **0.43** |
| 6 | 3 | 1 − (24·23·22)/(30·29·28) ≈ **0.50** |

The Reweave mulligan and played cards change these numbers somewhat, but not their order of magnitude: about half the
time the emotion that would react is not in hand.

## Appendix D — the Overload timeline today

Level 3, normal fight (4 turns), meter size 8, two-target Surges.

| Turn | Fill | Meter | State |
|---|---|---|---|
| 1 | 2 peaks land (+2) | 2 / 8 | — |
| 2 | 1 reaction (+2), 1 peak (+1) | 5 / 8 | — |
| 3 | 1 reaction (+2), 1 peak (+1) | **8 / 8** | ***Overloaded* for 3 turns: silenced** |
| 4 | — | full | Weapon attack only (≈ 0.75 A) |
| next fight, turn 1 | (carried over) | full | Still silenced for 1 more turn |

With S1 the same turns 4–5 are a choice: ride the power state, or release *Outburst*.
