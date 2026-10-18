---
id: QA-0001
title: Playtest — The Heartsong — refining R49–R68 (levels 1–12)
type: playtest
kind: subclass
subclass: resonant
build: ARC-0017
guide: 61.02_Test_Cases/Resonant/GUIDE_ARC-0017.json
status: in_qa
owner: QA Lead
implementation: owner
blocked_by: []
created: 2026-10-16
---

# QA-0001 · Playtest — The Heartsong — refining R49–R68 (levels 1–12)

**Goal:** play every test of `61.02_Test_Cases/Resonant/GUIDE_ARC-0017.json` and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E, tab Resonant).
**Intent:** ARC-0017 is proven in the game, or each failure becomes an ARC bug and a QA bug-retest.

Steps, expected results and plan B are on the test page and in the record `61.02_Test_Cases/Resonant/GUIDE_ARC-0017.md`. Results reach this ticket at the kanban sync.

## Before you start

- Compile the Story in the Toolkit once: the Overload, Temperance and Shared Heart goals changed during the build.
- Use a NEW Resonant. A character from an older save already learned the eight emotions as separate spells.
- Console edition unless a test says PC. Read results in the combat log and on the status tooltips.
- Some texts of growing dice still say 1d4 (text pass ARC-0006): judge the dice by the combat log, not the tooltip.
- Not tested here: Releases per day (V7) and feelings at release on a boss (V6) are balance metrics: they run in ARC-0010.

## Level 1 — Weave Surge, Heartstring, Emotional Overload

**Setup:** A new Resonant at level 1, one ally, a normal fight against two or three enemies. Tests marked PC: the PC edition with the deck on.

- [ ] L1.1 · Weave Surge opens with the emotions you know (B6a · R54)
- [ ] L1.2 · Emotional Overload is free (B3a · R66)
- [ ] L1.3 · Overloaded is a trade, not a silence (R51a · R51)
- [ ] L1.4 · The Surge rider, once per turn (R51b · R51)
- [ ] L1.5 · Emotional Overload, rank I (R51c · R51 R68)
- [ ] L1.6 · Charm-immune creatures don't dance (V13 · R68)
- [ ] L1.7 · When a fight ends, the meter settles to half (R53 · R53)
- [ ] L1.8 · Heartstring reads feelings (R61 · R61)
- [ ] L1.9 · Moods say what they react with (R64 · R64)
- [ ] L1.10 · Weave Surge in the deck (V9 · R55) [PC]
- [ ] L1.11 · Emotional Overload costs no Threads (B4 · R66) [PC]

## Level 2 — Temper

**Setup:** The same Resonant at level 2.

- [ ] L2.1 · Temper and Anticipation at level 2 (L2a · R59)

## Level 3 — Opposites, Tier I Resonance

**Setup:** The Resonant at level 3, one ally, fights long enough to wake Tier I.

- [ ] L3.1 · Nothing-to-do turns (levels 1-3) (V4 · R51)
- [ ] L3.2 · Opposites and Tier I at level 3 (L3a · R60 R63)

## Level 5 — Deeper Feelings

**Setup:** The Resonant at level 5, a fight with several enemies and one ally.

- [ ] L5.1 · Temper's replay leaves no mood (B1 · R49)
- [ ] L5.2 · No Temper lock (V2 · R49)
- [ ] L5.3 · Emotional Overload, rank II (R51d · R51 R66)
- [ ] L5.4 · Overloaded grows at 5 (R52 · R52 R67)
- [ ] L5.5 · Deeper Feelings at 5 (R62a · R62)
- [ ] L5.6 · Does the dance's save discharge Mental Fatigue? (B2 · R68)

## Level 6 — Complex Feelings

**Setup:** The Resonant at level 6, one lower-level ally, a normal fight.

- [ ] L6.1 · Complex Feelings at 6, not 5 (L6a · R59)
- [ ] L6.2 · Growing dice read the Resonant's level (B7 · R62)

## Level 7 — Overwhelm, Tier II Harmony

**Setup:** The Resonant at level 7 with Tier II reachable (6 reactions), one ally, a fight long enough to wake it.

- [ ] L7.1 · Excess once per fight (V1 · R49 R50)
- [ ] L7.2 · Tier II's free Surge through the container (B6b · R40 R54)
- [ ] L7.3 · Ride or release (levels 3 and 7) (V5 · R51)

## Level 9 — Deeper Feelings, Emotional Contagion, Mixed Feelings

**Setup:** The Resonant at level 9, a fight with a group of enemies close together and two allies.

- [ ] L9.1 · Emotional Overload, rank III (the area) (B5 · R51 R67)
- [ ] L9.2 · Contagion + Tier II: no mass action loop (V3 · R50)
- [ ] L9.3 · Growth at 9 (R62b · R62 R67)

## Level 10 — Ready: Compassion

**Setup:** The Resonant at level 10, one ally, a normal fight.

- [ ] L10.1 · Compassion is kind (V10a · R57)

## Level 11 — Shared Heart

**Setup:** The Resonant at level 11, a long fight with the whole party.

- [ ] L11.1 · Shared Heart acts on cast (R58 · R58)
- [ ] L11.2 · Shared Heart shares only helpful feelings (V10b · R57)

## Level 12 — Tier III Aspect of Empathy

**Setup:** The Resonant at level 12, a long fight with the whole party.

- [ ] L12.1 · Tier III: the dam breaks (V11 · R56 R68)

## Any level — full run

**Setup:** Across the whole run: a new Resonant levelled from 1 to 12 in your usual fights.

- [ ] A.1 · Every level-up has something (V8 · R59)

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail has an ARC bug and a QA bug-retest

## Log

- 2026-10-16 — created from `61.02_Test_Cases/Resonant/GUIDE_ARC-0017.json` (33 tests).
- 2026-10-17 — ARC-0027: in QA — its build ticket is in sprint S01; test ids renamed to L<level>.<n> / A.<n> (the old id stays at the front of each rule).
