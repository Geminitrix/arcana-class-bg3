# HANDOFF · Lead Class Designer → Context Keeper · ARC-0008

**What:** the Spinner was audited against the subclass standard (design only; nothing changed in the game
files). Add the Depth audit to `05.02_Subclasses/Spinner.md`.

**Sources:** `21.04_Subclasses/Spinner/2026-10-08-spinner-design.md` · `55_Implementation_Specs/_wip/Spinner/decisions.md`
(SP1–SP43) · `21.04_Subclasses/_SUBCLASS_STANDARD.md` §3, §15 · `05.03` catalogs (name checks).

## 1. Keep

The design pointer and "In the game today" (placeholder progression = a copy of the Resonant's level 1)
stay as they are.

## 2. Add the Depth audit (2026-10-13)

Audit of the 2026-10-08 design. "Resolved by" names the decision or the open step of ARC-0008.

| Question | State | Evidence | Resolved by |
|---|---|---|---|
| I1 fun | ⚠️ | Never played; the decisions came from worked turns of play, not a test | **Playtest** after the build |
| I2 striking trait | ✅ | "Fates that count down and cascade, on a wheel of elements" | — |
| I3 archetype | ✅ | The clockmaker of fate: abilities schedule, delay, cut and stop time | — |
| I4 Aspect | ✅ | Reading countdowns and the wheel, holding a card for its turn = Anticipation | — |
| I5 axis | ✅ | Timing (*when*); free among the subclasses | — |
| I6 vocabulary | ⚠️ | Most names are *working names*; **"Spark"** (Lightning) sits next to the Starchild's *Final Spark*; spec §13 still reserves "Turn the Wheel" for the Resonant, which renamed it Temper (Resonant R4) | **Text pass**; drop the §13 line in the raising spec |
| S1 card | ✅ | The Rota Fortunae: the wheel turns on the Spinner's turn, what falls pushes the next | — |
| S2 card elements | ✅ | Four positions → Past / Present / Future / locked; four winged creatures → Fortunes; sphinx → Radiant Ritual; Anubis → Angel | — |
| S3–S4 characters | ✅ | Zilean → Transfer; Faceless Void and Bard → The Wheel Stops; DIO → the time stop; Twisted Fate → the wheel of elements; *Final Destination* → Cascade; *Death Note* → Necrotic Ritual | — |
| S5 real source | ✅ | Nuclear chain reaction → Cascade and Critical Mass (SP26, SP27) | — |
| S6 myth | ✅ | Moirai (Clotho, Lachesis, Atropos' Shears), Ananke's Spindle of Necessity, Fortuna | — |
| W1 relation to Mystra | ⚠️ | The idea exists (the one who holds the spindle), the sentence is not written | **Text pass** |
| W2 the Weave in the features | ✅ | Spun fates, the spindle, threads cut by the Shears | — |
| M1 new and exclusive | ✅ | Fortune / Misfortune countdowns, read only by the Spinner's rules | — |
| M2 one rule, explained once | ⚠️ | Two core rules at level 1 (the fates, the wheel of elements), one passive each; the kit has a lot to read (see §15 budget) | **Brainstorm: complexity** |
| M3 gears | ✅ | Create (fate spells), change (Needle, Frozen Moment, Pull of Fate, Past/Future), spend (resolution, Shears, Rota Fortunae, The Wheel Stops) | — |
| M4 grows | ✅ | New rule at 3 (Cascade), 5 (Transfer), 7 (Spindle), 9 (Critical Mass), 12 (no limit) | — |
| M5 both sides | ✅ | Fortunes and Misfortunes push each other in the same Cascade; Lachesis | — |
| M6 bounded | ✅ | Waves, oldest first, remove before effect; Recurrence once and after the chain (SP18, SP28) | — |
| K1 key features drive it | ✅ | The mechanic is played through the fate spells and the tools | — |
| K2 exclusive | ⚠️ | Some fates read like vanilla damage over time (Fire, Poison) when taken alone; the countdown and Cascade make them exclusive | Check in the raise |
| K3 ultimate | ❌ | **No feature defined as the one that ties the mechanic together** (the Resonant's is Emotional Overload) | **Brainstorm: ultimate** |
| K4 passives fit | ✅ | Every passive is a rule of the mechanic | — |
| K5 passives drive | ✅ | Cascade, Transfer, Spindle, Critical Mass are new rules, not numbers | — |
| K6 two plays + fallback | ✅ | Spindle Needle (Bonus Action) and the cantrip at level 1 | — |
| P1 combat style | ✅ | Back line, ranged, high initiative; positions allies | — |
| P2 specialist / versatile | ⚠️ | Not stated in the design | **Raise** (Identity Sheet) |
| P3 party | ✅ | Timed Fortunes, Lachesis temporary HP, Pull of Fate groups enemies | — |
| P4 level 1 | ✅ | Fates, the wheel, Needle and three elements at level 1 | — |
| P5 fight length | ⚠️ | Countdowns up to 6 turns against normal fights of 3–5 rounds; Fast spells first, Burst, Crown strike mitigate | **Playtest** (fates resolved in a short and a long fight) |
| P6 decisions | ✅ | Bleed or pull down, spread or stack, which window position | — |
| P7 readable | ⚠️ | Countdowns on icons and the wheel status are readable; **who is inside the 9 m Cascade range is not shown**; ~25 combat actions on the hotbar | **Brainstorm: complexity** |
| P8 vs AI | ✅ | Nothing needs the enemy to cooperate | — |
| P9 weaknesses | ✅ | Slow start, cleanse, wheel frozen when downed, weak windows | — |
| P10 console | ⚠️ | The element lock is a status boost (no Lua) but untested on console | **Test** (spec §16) |
| A1 goal | ✅ | Fates resolved; fits the ARC-0007 countdown (COUNT) | Goals 3/6/10 in the balance pass |
| A2 tiers | ✅ | Clotho speeds the mechanic, Lachesis spreads protection, Recurrence the cycle; no ability bonus | — |
| A3 Aspect card | ⚠️ | Rota Fortunae plays the mechanic, but whether it differs from the ultimate can't be judged until K3 exists | **Brainstorm: ultimate** |
| B1–B4 | ❌ | No numbers; every value *TBD*; nothing in `25` | **Balance pass** (`25`, `22.05`) |
| T1 no SE | ✅ | Stats, Osiris, Khonsu only | — |
| T2 proven | ⚠️ | Patterns found in vanilla (TickingWithSource, Additive, GetStatusTurns, ApplyStatus `_Source`, ReactionActionPoint, ActionResourceBlock); untested: the freeze of The Wheel Stops, Action + Reaction cost, ticking while downed, the lock on console | **Tests** (spec §16) |
| T3 generated | ✅ | Generator planned (`82_Automation/stats/gen_spinner.pl`, to write) | — |
| T4 conventions | ⚠️ | No ids yet | **Spec** |
| D1 Identity Sheet | ⚠️ | Missing: specialist/versatile, emoji, Aspect VFX, voice lines | **Raise**, text pass |
| D2 sources agree | ❌ | No Depth audit in `05.02` (this handoff); the game holds a Resonant copy as the Spinner; `21.08` Axis row empty; spec §13 line on "Turn the Wheel" outdated | This handoff; the raising spec; the build |

**Complexity budget (§15, still a suggestion):** ~25 new combat actions by level 12 (15 elemental spells,
4 Fortunes, cantrip, Needle, Shears, The Wheel Stops, Rota Fortunae, Foreseen) against a suggested 3; two
resources to track (the fates, the wheel position), within the suggested one main + one secondary.

**Design gate (§15):** not recorded yet (pillars `21.01`, matrix `21.08`, resource `26`, curve `22`,
intent sentence).

## 3. Open items to list

The ultimate (K3) · the complexity budget · names and texts · the balance pass · the in-game tests of the
spec · the placeholder progression in the game.
