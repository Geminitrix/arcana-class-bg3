---
id: QA-0005
title: Playtest — The Windborn — rework WB0–WB50 (levels 1–12)
type: playtest
kind: subclass
subclass: unbound
build: ARC-0026
guide: 61.02_Test_Cases/Unbound/GUIDE_ARC-0026.json
status: in_qa
owner: QA Lead
implementation: owner
blocked_by: []
created: 2026-10-17
---

# QA-0005 · Playtest — The Windborn — rework WB0–WB50 (levels 1–12)

**Goal:** play every test of `61.02_Test_Cases/Unbound/GUIDE_ARC-0026.json`, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E).
**Intent:** ARC-0026 is proven in the game, or each failure becomes a fix (a bug) or a decision (design feedback, OR-1).

Steps, expected results and plan B are on the test page and in the record `61.02_Test_Cases/Unbound/GUIDE_ARC-0026.md`. This list is rebuilt from the guide, with the results, at every test guides sync (`/sync-test-guides`).

## Before you start

- Type the level from its Toolkit guide (TOOLKIT_ARC-0026_L01.md … _L12.md), compile the Story (log.txt: 0 error(s), 0 warning(s)) and tell Claude; then play that level's session here.
- Console edition (Script Extender off) unless a test says PC edition.
- A Windborn (Unbound subclass) character with no armour and no shield, unless a test says otherwise.
- The stage 1 probes (P1–P9) all passed on 2026-10-17; they are recorded in QA-0004.

## Level 1 — The Open Road

**Setup:** A level-1 Windborn, no armour and no shield, in a fight with at least three enemies spread out and one ally in melee with an enemy.

- [ ] L1.1 · The class reads The Windborn; the preset and the AC are right (WB43 · TC B12 (names))
- [ ] L1.2 · After an unarmed attack, Zephyr Rush carries you to an unmarked enemy (WB5, WB18) — FAIL: Funcionou mais ou menos. Acertei o inimigo com o ataque desarmado e apareceu o Zephyr Strike e o Zephyr Rush, entretanto o Zephyr Rush pode selecionar o chão, e na verdade só poderia ser possível selecionar um inimigo. E na verdade o Zephyr Rush ta com o mesmo nome do Zephyr Strike. O Zephyr Rush não está podendo selecionar o inimigo com Windswept, mas está podendo selecionar qualquer lugar no chão.
- [ ] L1.3 · The Rush only reaches an unmarked enemy within 9 m (WB5 (range, target))
- [x] L1.4 · Damage marks Windswept; a miss doesn't (WB8, WB49 (P7)) — pass
- [ ] L1.5 · Gale Burst: a failed save marks; no free strike any more (WB8, WB28) — note: Ai temos uma incoerência. A passiva OpenRoad faz com que sempre que cause dano no inimigo, ele recebe o Windswept. Então mesmo o inimigo tendo sucesso no teste do GaleBurst, ele ainda toma dano, consequentemente recebendo o Windswept.
- [ ] L1.6 · A Windswept enemy makes no opportunity attack (WB10, WB49 (P6))
- [ ] L1.7 · Windswept lasts until the end of your next turn (WB9 · TC B3)
- [ ] L1.8 · Weightless: +3 m (WB39, WB47)
- [ ] L1.9 · Armour or a shield turns everything off (WB3 · TC B10)
- [ ] L1.10 · The Open Road and the cards read right (WB27)
- [ ] L1.11 · PC edition: the deck conjures Zephyr Rush (WB5 (PC edition)) [PC]

## Level 2 — Aeolus' Bag

**Setup:** Level 2, a fight with at least four enemies; mark several before opening the bag.

- [ ] L2.1 · The bag needs a Windswept enemy (WB11, WB13)
- [ ] L2.2 · Opening: X = marks, capped at 2; every mark is cleared (WB13, WB14 · TC B4)
- [ ] L2.3 · Boreas: allies +3 m, Windswept enemies −3 m (WB12 (Boreas))
- [ ] L2.4 · Notus: ranged attacks against allies at Disadvantage; Windswept enemies −1 to saves (WB12 (Notus))
- [ ] L2.5 · While the wind blows, your turn starts with a sweep (WB14 (the sweep) · TC B5)
- [ ] L2.6 · PC edition: the bag is conjured once you have a mark (WB11 (PC edition)) [PC]

## Level 3 — The First Step, The Calm, Wind Blast

**Setup:** Level 3, a fight with at least four enemies.

- [ ] L3.1 · Tier I wakes after 3 marks are released (WB22, WB23 · TC C5)
- [ ] L3.2 · The First Step: the first Rush each turn is free (WB22 (The First Step))
- [ ] L3.3 · The Calm: only while a wind blows; the turns left become gusts (WB25, WB48 · TC B6)
- [ ] L3.4 · Wind Blast marks those who fail (WB8 (Wind Blast))
- [ ] L3.5 · Flow State and Gale Deflection are no longer at level 3 (WB43 (level map))

## Level 4 — Gale

**Setup:** Level 4, a fight with at least four enemies.

- [ ] L4.1 · Zephyr pushes 3 m; the Rush reaches 12 m (WB16, WB17 (Gale))
- [ ] L4.2 · Eurus joins the bag; the cap is 3 (WB12 (Eurus), WB13)
- [ ] L4.3 · Weightless rank 2 (WB47 (Weightless 2))

## Level 5 — Flowing Assault, Wind Whispers

**Setup:** Level 5, any fight.

- [ ] L5.1 · Wind Whispers also gives the Advantage Evasive Flow gave (WB33 (Wind Whispers))
- [ ] L5.2 · Flowing Assault and the level-5 texts (WB43)

## Level 6 — Flow State, Ready: Gale Deflection

**Setup:** Level 6, a fight with a ranged enemy and an ally within 3 m of you.

- [ ] L6.1 · Flow State: 3 turns and one extra bonus action, at every slot (WB31 (Flow State))
- [ ] L6.2 · Gale Deflection also protects an ally within 3 m (WB32 (Gale Deflection))

## Level 7 — Fellow Travellers, Storm Fists

**Setup:** Level 7, a fight with allies attacking enemies.

- [ ] L7.1 · Fellow Travellers: an ally's hit marks the enemy in your name (WB22 (Tier II) · TC B9)
- [ ] L7.2 · Tier II needs 5 released marks (WB23 (goals 3/5/8))
- [ ] L7.3 · Storm Fists: extra damage only against enemies that aren't Windswept; 3 turns (WB34 (Storm Fists))

## Level 8 — Storm

**Setup:** Level 8, a fight with at least five enemies.

- [ ] L8.1 · Storm: after a Rush that deals damage, one more free Rush (WB16 (Storm) · TC C3)
- [ ] L8.2 · The cap is 4; Weightless rank 3 (WB13 (cap 4), WB47)

## Level 9 — Untethered, Empty State

**Setup:** Level 9, any fight.

- [ ] L9.1 · Untethered: flying gives +2 AC (WB35 (Untethered))
- [ ] L9.2 · Empty State arrives at 9; Evasive Flow is gone (WB43, WB36)

## Level 10 — Leap of Faith

**Setup:** Level 10, enemies standing in a line.

- [ ] L10.1 · Leap of Faith: a card, once per Short Rest, on the Force Tunnel dash (WB7, WB38 (P5))

## Level 11 — Where the Winds Meet

**Setup:** Level 11, a fight with several enemies, some Windswept.

- [ ] L11.1 · Aimed at the ground; refused while a wind blows (WB26, WB50)
- [ ] L11.2 · The pull: 9 m area, Windswept pulled 9 m, others 6 m — to the point (WB46, WB49 · TC B7)
- [ ] L11.3 · Thunderclap and Momentum are gone (WB37, WB34)

## Level 12 — Into the Storm, Hurricane

**Setup:** Level 12, a fight with at least five enemies.

- [ ] L12.1 · Into the Storm: each sweep pushes the swept enemies 3 m (WB22 (Tier III, P9) · TC B9)
- [ ] L12.2 · Hurricane: the bag offers two winds at once; the cap is 5 (WB15 (Hurricane), WB13)
- [ ] L12.3 · Weightless rank 4 (WB47 (Weightless 4))
- [ ] L12.4 · No old tier bonuses; no Fool's Luck; nothing after 12 (WB24, WB43)

## Any level — full run

**Setup:** A full fight at levels 3, 8 and 12 (TC part C), after all levels are typed.

- [ ] A.1 · How the fights play (C1 · TC C1, C2)
- [ ] A.2 · Power and tiers against the Monk (C2 · TC C4, C5)

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — created from `61.02_Test_Cases/Unbound/GUIDE_ARC-0026.json` (46 tests).
