---
id: 26.01/Unbound
owner: Balance Designer
source: 21.04/Unbound/DECISIONS.md (WB0–WB48), DESIGN.md §4, §5, §8
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); the approved design, values in 25; 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — WB49 (QA-0004 probe outcomes) checked, no change
---

# 26.01 · Resource audit — The Windborn (internal: Unbound)

The approved design (ARC-0022); the game still has the old build (`05.02/Unbound.md`).

| Resource | Sources | Sinks | Recharge | Balance | Risk | Action |
|---|---|---|---|---|---|---|
| Woven Spell Slots (PC: Threads) | Class level | Gale Burst, Wind Blast, Wind Whispers, Flow State, Ready: Gale Deflection, Storm Fists, Untethered, Leap of Faith | Long rest (base class) | No refund: nothing returns a slot | — | None |
| Threads (PC edition only) | Deck economy (base class) | Every card; Zephyr Strike (1 Thread, created card) | Per combat (deck) | As the base class | — | None |
| **Windswept** (marks on enemies) | Any hit of yours; failed saves against your cards; Leap of Faith; Riposte; Gale Deflection; allies' hits (Tier II); Where the Winds Meet | Opening the bag; the wind's sweep at your turn start; The Calm; the end of your next turn; death; combat end | Per fight | A counter, not a currency: it costs nothing of hers | The Open Path lasts while marks do — capped by the duration and the sweeps | None |
| **Aeolus' Bag** (the wind) | Opening it (bonus action, ≥ 1 mark) | Blows X turns, X = marks when opened, capped 2 / 3 / 4 / 5 by rank | Reopens when the wind stops, or at once with The Calm | ≈ 2.5 of 4 turns of wind per fight | No loop: the sweep doesn't extend the wind (DESIGN §4.9) | Watch uptime (`22.05` V1) |
| **Awakening progress** | Marks released (opening, sweeps, The Calm) | — (tiers at 3 / 5 / 8) | Combat end (D4) | Counter on a status | — | None |
| The Calm | Tier I | 1 cast | Once per combat | Needs a wind | — | None |
| Where the Winds Meet | Level 11 | 1 cast | Once per Long Rest, only while no wind blows | Capstone budget | — | None |
| Leap of Faith | Level 10 card | 1 cast | Once per Short Rest | — | — | None |
| Gale Deflection uses | Ready: Gale Deflection | Reaction (up to 3 per round) | Until combat ends | As today | Competes with Riposte for the reaction | None |
| Storm's second Rush | Zephyr against an unmarked enemy (level 8) | The created card, one turn | Per Zephyr | One per Zephyr | — | Watch (`22.05` V3) |

## Action economy

| Slot | Users | Conflict |
|---|---|---|
| Action | Unarmed attacks, cards, The Calm, Where the Winds Meet | Normal choice of the turn |
| Bonus Action | **Zephyr Strike** and **Aeolus' Bag** (+ Wind Whispers, Storm Fists) | The designed tension until Tier I (the first Rush each turn becomes free) and Flow State (+1 bonus action) |
| Reaction | Riposte (Wind Whispers), Gale Deflection | One per round; she chooses |
