---
id: QA-0002
title: Playtest — The Kingmaker — new subclass (levels 1–12)
type: playtest
kind: subclass
subclass: kingmaker
build: ARC-0008
guide: 61.02_Test_Cases/Kingmaker/GUIDE_ARC-0008.json
status: in_qa
owner: QA Lead
implementation: owner
blocked_by: []
created: 2026-10-16
---

# QA-0002 · Playtest — The Kingmaker — new subclass (levels 1–12)

**Goal:** play every test of `61.02_Test_Cases/Kingmaker/GUIDE_ARC-0008.json` and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E, tab Kingmaker).
**Intent:** ARC-0008 is proven in the game, or each failure becomes an ARC bug and a QA bug-retest.

Steps, expected results and plan B are on the test page and in the record `61.02_Test_Cases/Kingmaker/GUIDE_ARC-0008.md`. Results reach this ticket at the kanban sync.

## Before you start

- Compile the Story in the Toolkit and check log.txt: 0 error(s), 0 warning(s).
- Use a new Kingmaker built through the real progression, in a party of four.
- Console edition. The PC deck is not built yet (SPEC stage 7).
- Known, not a test: the subclass icon in character creation is still the Spinner one (SPEC stage 7).

## Level 1 — The Wheel: Coronation, Dethrone, Turn the Spoke, the cantrip

**Setup:** A Kingmaker at level 1, in a party of four, a normal fight.

- [ ] L1.1 · Coronation on an ally (P1 · SPEC_ARC-0008)
- [ ] L1.2 · Dethrone on an enemy, then a save success on another (P2 · SPEC_ARC-0008)
- [ ] L1.3 · Spoke of the Wheel on a Fallen enemy vs a normal one (P8 · SPEC_ARC-0008)
- [ ] L1.4 · End the turn; at your next turn start (P3 · SPEC_ARC-0008)
- [ ] L1.5 · Turn the Spoke on the Falling enemy (P5 · SPEC_ARC-0008)
- [ ] L1.6 · Be downed with creatures on the Wheel (P6 · SPEC_ARC-0008)
- [ ] L1.7 · Kill a creature on the Wheel; end combat (P7 · SPEC_ARC-0008)
- [ ] L1.8 · Crown two allies on different turns (P4 · SPEC_ARC-0008)

## Level 3 — The Crossing, Awakening Tier I Tyche, Atropos' Cut

**Setup:** A Kingmaker at level 3, in a party of four, a normal fight.

- [ ] L3.1 · Level 3: Coronation on an ally, Dethrone on an enemy within 9 m of ... (P9 · SPEC_ARC-0008)
- [ ] L3.2 · Same, with the enemy more than 9 m from the ally (P10 · SPEC_ARC-0008)
- [ ] L3.3 · Two Reigning allies next to one enemy entering Fallen; then Turn th... (P11 · SPEC_ARC-0008)
- [ ] L3.4 · Fight with one enemy on the Wheel, then two (P12 · SPEC_ARC-0008)
- [ ] L3.5 · With Tyche: Coronation, then Dethrone next to the Reigning ally (P13 · SPEC_ARC-0008)
- [ ] L3.6 · Rota Fortunae (P14 · SPEC_ARC-0008)
- [ ] L3.7 · Atropos' Cut on a Fallen, a Falling and a Rising enemy (one each) (P15 · SPEC_ARC-0008)
- [ ] L3.8 · Atropos' Cut on the Reigning King; then cast Dethrone and Atropos' ... (P16 · SPEC_ARC-0008)

## Level 5 — Peripeteia, the Court

**Setup:** A Kingmaker at level 5 with CHA 15, in a party of four, a normal fight.

- [ ] L5.1 · Appoint the King's Hand; start a fight with nobody on the Wheel (P18 · SPEC_ARC-0008)
- [ ] L5.2 · Level 5, CHA 15 (+2): Convene the Court twice out of combat, then t... (P17 · SPEC_ARC-0008)
- [ ] L5.3 · Appoint the Lord Commander next to the King (P19 · SPEC_ARC-0008)
- [ ] L5.4 · Master of Healing heals a Fallen ally, then a Falling one (P20 · SPEC_ARC-0008)
- [ ] L5.5 · Long Rest (P21 · SPEC_ARC-0008)
- [ ] L5.6 · A holder dies (P22 · SPEC_ARC-0008)
- [ ] L5.7 · Level 5 character: open Convene the Court (P32 · SPEC_ARC-0008)
- [ ] L5.8 · Peripeteia with allies and enemies on the Wheel, some beyond 18 m (P23 · SPEC_ARC-0008)
- [ ] L5.9 · Cast Peripeteia again in the same fight, with a higher slot (P24 · SPEC_ARC-0008)

## Level 7 — Hubris, Usurp, Tier II Nemesis, two offices

**Setup:** A Kingmaker at level 7, in a party of four, a normal fight.

- [ ] L7.1 · With Nemesis (5 Crossings): a Hubris enemy crosses with a Falling e... (P26 · SPEC_ARC-0008)
- [ ] L7.2 · Master of Laws held; a Rising enemy attacks the King (P29 · SPEC_ARC-0008)
- [ ] L7.3 · Same with a Reigning enemy; with a Falling one (P30 · SPEC_ARC-0008)
- [ ] L7.4 · Master of Secrets; an enemy on the Wheel within 9 m tries to hide o... (P31 · SPEC_ARC-0008)
- [ ] L7.5 · Level 7 character: open Convene the Court (P39 · SPEC_ARC-0008)
- [ ] L7.6 · Level 7: let an enemy reach Reigning; next turn it falls to Fallen ... (P25 · SPEC_ARC-0008)
- [ ] L7.7 · Usurp on a Reigning ally and a Fallen enemy; then on a Fallen ally ... (P27 · SPEC_ARC-0008)
- [ ] L7.8 · Usurp on two allies (P28 · SPEC_ARC-0008)

## Level 9 — Succession, Wheel of Ixion, two offices

**Setup:** A Kingmaker at level 9 with CHA 20 (for the seven offices), in a party of four, a normal fight.

- [ ] L9.1 · Master of Ships 5 m from an enemy entering Fallen, no Reigning ally... (P38 · SPEC_ARC-0008)
- [ ] L9.2 · Master of Coin hits a Fallen enemy, then another (P37 · SPEC_ARC-0008)
- [ ] L9.3 · Seven offices with CHA 20 (+5) (P40 · SPEC_ARC-0008)
- [ ] L9.4 · Level 9: kill a Falling enemy with another enemy off the Wheel 5 m ... (P33 · SPEC_ARC-0008)
- [ ] L9.5 · Kill a Reigning enemy with an heir in range (P34 · SPEC_ARC-0008)
- [ ] L9.6 · Wheel of Ixion through two enemies and an ally (P35 · SPEC_ARC-0008)

## Level 11 — The Wheel Stops

**Setup:** A Kingmaker at level 11, in a party of four, a normal fight.

- [ ] L11.1 · Ixion with a level-6 slot (P36 · SPEC_ARC-0008)
- [ ] L11.2 · Level 11: The Wheel Stops with an ally Reigning and an enemy Fallen... (P41 · SPEC_ARC-0008)
- [ ] L11.3 · During the stop: Turn the Spoke, Rota Fortunae, Dethrone a new enemy (P42 · SPEC_ARC-0008)

## Level 12 — Fortune's Reach, Tier III, Ready: Foreseen

**Setup:** A Kingmaker at level 12, in a party of four, a normal fight.

- [ ] L12.1 · Level 12: an enemy enters Fallen 20 m from the only Reigning ally (P43 · SPEC_ARC-0008)
- [ ] L12.2 · Tier III (8 Crossings): follow an ally around the Wheel; Peripeteia... (P44 · SPEC_ARC-0008)
- [ ] L12.3 · Tier III: cast Ready: Foreseen (P45 · SPEC_ARC-0008)
- [ ] L12.4 · A Reigning enemy on the Wheel attacks an ally; take Foreseen (P46 · SPEC_ARC-0008)
- [ ] L12.5 · A Rising or Fallen enemy attacks (P47 · SPEC_ARC-0008)

## Any level — full run

**Setup:** Any level: a party with two Kingmakers; and a new Kingmaker levelled from 1 to 12.

- [ ] A.1 · Two Kingmakers in the party (P48 · SPEC_ARC-0008)
- [ ] A.2 · A new Kingmaker gets exactly the 21.03 table (PR1 · 21.03)

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail has an ARC bug and a QA bug-retest

## Log

- 2026-10-16 — created from `61.02_Test_Cases/Kingmaker/GUIDE_ARC-0008.json` (49 tests).
- 2026-10-17 — ARC-0027: in QA — its build ticket is in sprint S01; test ids renamed to L<level>.<n> / A.<n> (the old id stays at the front of each rule).
