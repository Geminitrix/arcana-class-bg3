---
id: QA-0001
title: Playtest — The Resonant after the refining (R49-R68)
type: playtest
kind: subclass
subclass: resonant
build: ARC-0017
guide: 61.02_Test_Cases/Resonant/GUIDE_ARC-0017.json
status: ready
owner: QA
implementation: owner
blocked_by: []
created: 2026-10-16
---

# QA-0001 · Playtest — The Resonant after the refining (R49-R68)

**Goal:** play every test of `61.02_Test_Cases/Resonant/GUIDE_ARC-0017.json` and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E, tab Resonant).
**Intent:** ARC-0017 is proven in the game, or each failure becomes an ARC bug and a QA bug-retest.

Steps, expected results and plan B are on the test page and in the record `61.02_Test_Cases/Resonant/GUIDE_ARC-0017.md`. Results reach this ticket at the kanban sync.

## Before you start

- Compile the Story in the Toolkit once: the Overload, Temperance and Shared Heart goals changed during the build.
- Use a NEW Resonant. A character from an older save already learned the eight emotions as separate spells.
- Console edition unless a test says PC. Read results in the combat log and on the status tooltips.
- Some texts of growing dice still say 1d4 (text pass ARC-0006): judge the dice by the combat log, not the tooltip.

## Level 1

**Setup:** A new Resonant at level 1, one ally, a normal fight against two or three enemies. Tests marked PC: the PC edition with the deck on.

- [ ] B6a · Weave Surge opens with the emotions you know (R54)
- [ ] B3a · Emotional Overload is free (R66)
- [ ] R51a · Overloaded is a trade, not a silence (R51)
- [ ] R51b · The Surge rider, once per turn (R51)
- [ ] R51c · Emotional Overload, rank I (R51 R68)
- [ ] V13 · Charm-immune creatures don't dance (R68)
- [ ] R53 · When a fight ends, the meter settles to half (R53)
- [ ] R61 · Heartstring reads feelings (R61)
- [ ] R64 · Moods say what they react with (R64)
- [ ] V9 · Weave Surge in the deck (R55) [PC]
- [ ] B4 · Emotional Overload costs no Threads (R66) [PC]

## Level 2

**Setup:** The same Resonant at level 2.

- [ ] L2a · Temper and Anticipation at level 2 (R59)

## Level 3

**Setup:** The Resonant at level 3, one ally, fights long enough to wake Tier I.

- [ ] V4 · Nothing-to-do turns (levels 1-3) (R51)
- [ ] L3a · Opposites and Tier I at level 3 (R60 R63)

## Level 5

**Setup:** The Resonant at level 5, a fight with several enemies and one ally.

- [ ] B1 · Temper's replay leaves no mood (R49)
- [ ] V2 · No Temper lock (R49)
- [ ] R51d · Emotional Overload, rank II (R51 R66)
- [ ] R52 · Overloaded grows at 5 (R52 R67)
- [ ] R62a · Deeper Feelings at 5 (R62)
- [ ] B2 · Does the dance's save discharge Mental Fatigue? (R68)

## Level 6

**Setup:** The Resonant at level 6, one lower-level ally, a normal fight.

- [ ] L6a · Complex Feelings at 6, not 5 (R59)
- [ ] B7 · Growing dice read the Resonant's level (R62)

## Level 7

**Setup:** The Resonant at level 7 with Tier II reachable (6 reactions), one ally, a fight long enough to wake it.

- [ ] V1 · Excess once per fight (R49 R50)
- [ ] B6b · Tier II's free Surge through the container (R40 R54)
- [ ] V5 · Ride or release (levels 3 and 7) (R51)

## Level 9

**Setup:** The Resonant at level 9, a fight with a group of enemies close together and two allies.

- [ ] B5 · Emotional Overload, rank III (the area) (R51 R67)
- [ ] V3 · Contagion + Tier II: no mass action loop (R50)
- [ ] R62b · Growth at 9 (R62 R67)

## Level 10

**Setup:** The Resonant at level 10, one ally, a normal fight.

- [ ] V10a · Compassion is kind (R57)

## Level 11

**Setup:** The Resonant at level 11, a long fight with the whole party.

- [ ] R58 · Shared Heart acts on cast (R58)
- [ ] V10b · Shared Heart shares only helpful feelings (R57)

## Level 12

**Setup:** The Resonant at level 12, a long fight with the whole party.

- [ ] V11 · Tier III: the dam breaks (R56 R68)

## Any level / full run

**Setup:** Across the whole run: a new Resonant levelled from 1 to 12 in your usual fights.

- [ ] V8 · Every level-up has something (R59)

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail has an ARC bug and a QA bug-retest

## Log

- 2026-10-16 — created from `61.02_Test_Cases/Resonant/GUIDE_ARC-0017.json` (33 tests).
