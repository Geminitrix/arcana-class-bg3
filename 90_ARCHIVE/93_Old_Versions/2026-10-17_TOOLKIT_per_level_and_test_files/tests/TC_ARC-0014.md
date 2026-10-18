---
id: 61.02/Resonant/TC_ARC-0014
owner: QA Lead
source: 21.04/Resonant/DECISIONS.md R49–R68 · REFINE_Resonant_2026-10-15.md §11 · DESIGN.md §14
reviewed: 2026-10-16 ARC-0014 — created (propagation, 00.08); planned, runs after the build; 2026-10-16 ARC-0021 — display name checked, no change
status: planned — nothing to run until the R49–R68 build ships
---

> **Superseded by `GUIDE_ARC-0017.json (QA-0001)`** (OR-4, 2026-10-17): the in-game tests live in the guide; this file is kept as the design-stage record.

# TC_ARC-0014 · The Resonant after the refining (R49–R68)

**Decision it informs:** close the ARC-0014 build, or send a failing rule back to the Lead Class Designer.
**Scenario:** console edition, a Resonant built through the real progression; levels 1, 2, 3, 5, 6, 7, 9, 10, 11, 12;
the PC (SE) edition where marked. Compile the Story after any apply.

## Probes for the build (one rule each — run first, they decide the spec)

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| B1 | Temper's replayed emotion leaves no mood (R49): its fade reads the replay marker before removing it | After Temper on Bored → Disgust 1 turn → **no** Bored afterwards; a natural Disgust peak later still leaves Bored | The marker clears at the start of the Resonant's next turn |
| B2 | Does the dance's failed turn-start save discharge Mental Fatigue? | Record what happens (1d4 Psychic + Mental Fatigue removed, or not) | If it discharges: the Owner decides (accept, or apply the fatigue after the dance) |
| B3 | Emotional Overload is free: only the current slot's variant shows (R66) | Levels 1, 5, 9: one variant, castable with no slot while Overloaded | — (Owner-tested pattern) |
| B4 | PC: `ARCANA_WEAVING` charges no Threads for Emotional Overload | 0 Threads | Exclude it from the Weaving check |
| B5 | Rank III's area (R51) | Every enemy within 9 m of a point within 18 m | A separate spell for rank III |
| B6 | The Weave Surge container (R54) | Opens with the emotions the Resonant knows (later ones greyed or hidden); Tier II's free Surge works when cast through it | Grant each emotion in the lists again and keep the container for the hotbar only |
| B7 | The growing dice read the Resonant's level (R62) | Hope from a level-5 Resonant on a level-1 ally adds 1d6 | One status version per band, chosen in the Surge |

## Rules (verification rows of the review, §11)

| # | Fight | Metric | Right if | Wrong if | Decision |
|---|---|---|---|---|---|
| V1 | Level 7–9, any | Ecstasy / Admiration / Amazement on the same creature on consecutive turns | never | ever | R49, R50 |
| V2 | Level 5, an enemy with Bored | Temper on it on consecutive turns with a lost action each time | impossible without a new Disgust Surge | possible | R49 |
| V3 | Level 9, Contagion + Tier II | Extra actions granted per fight | ≤ one per creature | more | R50 |
| V4 | Levels 1–3, normal fights | Turns where the Resonant had nothing useful to do | 0 | ≥ 1 per fight | R51 |
| V5 | Levels 3 and 7 | Turns spent Overloaded; ride vs release | sometimes held, sometimes released | always at once, or never released | R51, R52 |
| V6 | Levels 7–9, boss | Feelings on the release's target | average ≥ 1.5 | under 1.5 | R51 |
| V7 | Levels 5–7, a full day | Releases per day | 1–2 | ≥ 3 | R53 |
| V8 | Level-ups 1 → 12 | The player names what changed at each level (ask) | every level with content | a level they can't name | R59, R60 |
| V9 | PC, levels 3–9 | Turns with no Weave Surge in hand | rare | often | R55 |
| V10 | Level 11 (and 10 for Compassion) | Hindering feelings on allies without the player's choice | 0 | > 0 | R57 |
| V11 | Level 12, long fight | Releases right after Tier III wakes | every fight that wakes it | any missed | R56 |
| V12 | Level 1 → 12 | `dump_progression.pl`, the Resonant rows | the map of DESIGN §10 (4 and 8 empty) | anything else | R59 |
| V13 | Any | The dance on a charm-immune enemy | no dance; damage and Mental Fatigue still land | dance applied | R68 |

**Qualitative questions** after each session (`27.06`): *What did you want to do that you couldn't? When did you feel
strongest? When did you feel the Resonant level up? What would you call its signature?*
