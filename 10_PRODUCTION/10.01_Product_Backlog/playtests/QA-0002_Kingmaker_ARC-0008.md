---
id: QA-0002
title: Playtest — The Kingmaker (levels 1-12)
type: playtest
kind: subclass
subclass: kingmaker
build: ARC-0008
guide: 61.02_Test_Cases/Kingmaker/GUIDE_ARC-0008.json
status: ready
owner: QA Lead
implementation: owner
blocked_by: []
created: 2026-10-16
---

# QA-0002 · Playtest — The Kingmaker (levels 1-12)

**Goal:** play every test of `61.02_Test_Cases/Kingmaker/GUIDE_ARC-0008.json` and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E, tab Kingmaker).
**Intent:** ARC-0008 is proven in the game, or each failure becomes an ARC bug and a QA bug-retest.

Steps, expected results and plan B are on the test page and in the record `61.02_Test_Cases/Kingmaker/GUIDE_ARC-0008.md`. Results reach this ticket at the kanban sync.

## Before you start

- Compile the Story in the Toolkit and check log.txt: 0 error(s), 0 warning(s).
- Use a new Kingmaker built through the real progression, in a party of four.
- Console edition. The PC deck is not built yet (SPEC stage 7).
- Known, not a test: the subclass icon in character creation is still the Spinner one (SPEC stage 7).

## Level 1

**Setup:** A Kingmaker at level 1, in a party of four, a normal fight.

- [ ] P1 · Coronation on an ally (SPEC_ARC-0008)
- [ ] P2 · Dethrone on an enemy, then a save success on another (SPEC_ARC-0008)
- [ ] P8 · Spoke of the Wheel on a Fallen enemy vs a normal one (SPEC_ARC-0008)
- [ ] P3 · End the turn; at your next turn start (SPEC_ARC-0008)
- [ ] P5 · Turn the Spoke on the Falling enemy (SPEC_ARC-0008)
- [ ] P6 · Be downed with creatures on the Wheel (SPEC_ARC-0008)
- [ ] P7 · Kill a creature on the Wheel; end combat (SPEC_ARC-0008)
- [ ] P4 · Crown two allies on different turns (SPEC_ARC-0008)

## Level 3

**Setup:** A Kingmaker at level 3, in a party of four, a normal fight.

- [ ] P9 · Level 3: Coronation on an ally, Dethrone on an enemy within 9 m of ... (SPEC_ARC-0008)
- [ ] P10 · Same, with the enemy more than 9 m from the ally (SPEC_ARC-0008)
- [ ] P11 · Two Reigning allies next to one enemy entering Fallen; then Turn th... (SPEC_ARC-0008)
- [ ] P12 · Fight with one enemy on the Wheel, then two (SPEC_ARC-0008)
- [ ] P13 · With Tyche: Coronation, then Dethrone next to the Reigning ally (SPEC_ARC-0008)
- [ ] P14 · Rota Fortunae (SPEC_ARC-0008)
- [ ] P15 · Atropos' Cut on a Fallen, a Falling and a Rising enemy (one each) (SPEC_ARC-0008)
- [ ] P16 · Atropos' Cut on the Reigning King; then cast Dethrone and Atropos' ... (SPEC_ARC-0008)

## Level 5

**Setup:** A Kingmaker at level 5 with CHA 15, in a party of four, a normal fight.

- [ ] P18 · Appoint the King's Hand; start a fight with nobody on the Wheel (SPEC_ARC-0008)
- [ ] P17 · Level 5, CHA 15 (+2): Convene the Court twice out of combat, then t... (SPEC_ARC-0008)
- [ ] P19 · Appoint the Lord Commander next to the King (SPEC_ARC-0008)
- [ ] P20 · Master of Healing heals a Fallen ally, then a Falling one (SPEC_ARC-0008)
- [ ] P21 · Long Rest (SPEC_ARC-0008)
- [ ] P22 · A holder dies (SPEC_ARC-0008)
- [ ] P32 · Level 5 character: open Convene the Court (SPEC_ARC-0008)
- [ ] P23 · Peripeteia with allies and enemies on the Wheel, some beyond 18 m (SPEC_ARC-0008)
- [ ] P24 · Cast Peripeteia again in the same fight, with a higher slot (SPEC_ARC-0008)

## Level 7

**Setup:** A Kingmaker at level 7, in a party of four, a normal fight.

- [ ] P26 · With Nemesis (5 Crossings): a Hubris enemy crosses with a Falling e... (SPEC_ARC-0008)
- [ ] P29 · Master of Laws held; a Rising enemy attacks the King (SPEC_ARC-0008)
- [ ] P30 · Same with a Reigning enemy; with a Falling one (SPEC_ARC-0008)
- [ ] P31 · Master of Secrets; an enemy on the Wheel within 9 m tries to hide o... (SPEC_ARC-0008)
- [ ] P39 · Level 7 character: open Convene the Court (SPEC_ARC-0008)
- [ ] P25 · Level 7: let an enemy reach Reigning; next turn it falls to Fallen ... (SPEC_ARC-0008)
- [ ] P27 · Usurp on a Reigning ally and a Fallen enemy; then on a Fallen ally ... (SPEC_ARC-0008)
- [ ] P28 · Usurp on two allies (SPEC_ARC-0008)

## Level 9

**Setup:** A Kingmaker at level 9 with CHA 20 (for the seven offices), in a party of four, a normal fight.

- [ ] P38 · Master of Ships 5 m from an enemy entering Fallen, no Reigning ally... (SPEC_ARC-0008)
- [ ] P37 · Master of Coin hits a Fallen enemy, then another (SPEC_ARC-0008)
- [ ] P40 · Seven offices with CHA 20 (+5) (SPEC_ARC-0008)
- [ ] P33 · Level 9: kill a Falling enemy with another enemy off the Wheel 5 m ... (SPEC_ARC-0008)
- [ ] P34 · Kill a Reigning enemy with an heir in range (SPEC_ARC-0008)
- [ ] P35 · Wheel of Ixion through two enemies and an ally (SPEC_ARC-0008)

## Level 11

**Setup:** A Kingmaker at level 11, in a party of four, a normal fight.

- [ ] P36 · Ixion with a level-6 slot (SPEC_ARC-0008)
- [ ] P41 · Level 11: The Wheel Stops with an ally Reigning and an enemy Fallen... (SPEC_ARC-0008)
- [ ] P42 · During the stop: Turn the Spoke, Rota Fortunae, Dethrone a new enemy (SPEC_ARC-0008)

## Level 12

**Setup:** A Kingmaker at level 12, in a party of four, a normal fight.

- [ ] P43 · Level 12: an enemy enters Fallen 20 m from the only Reigning ally (SPEC_ARC-0008)
- [ ] P44 · Tier III (8 Crossings): follow an ally around the Wheel; Peripeteia... (SPEC_ARC-0008)
- [ ] P45 · Tier III: cast Ready: Foreseen (SPEC_ARC-0008)
- [ ] P46 · A Reigning enemy on the Wheel attacks an ally; take Foreseen (SPEC_ARC-0008)
- [ ] P47 · A Rising or Fallen enemy attacks (SPEC_ARC-0008)

## Any level / full run

**Setup:** Any level: a party with two Kingmakers; and a new Kingmaker levelled from 1 to 12.

- [ ] P48 · Two Kingmakers in the party (SPEC_ARC-0008)
- [ ] PR1 · A new Kingmaker gets exactly the 21.03 table (21.03)

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail has an ARC bug and a QA bug-retest

## Log

- 2026-10-16 — created from `61.02_Test_Cases/Kingmaker/GUIDE_ARC-0008.json` (49 tests).
