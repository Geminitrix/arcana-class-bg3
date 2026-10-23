---
id: 26.01/Unbound
owner: Balance Designer
source: 21.04/Unbound/DECISIONS.md (WB0–WB61), DESIGN.md §4, §5, §8
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); the approved design, values in 25; 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — WB49 (QA-0004 probe outcomes) checked, no change; 2026-10-17 ARC-0026 — P8 fix applied, no change; 2026-10-17 ARC-0026 — stage 1 complete, WB50 checked, no change; 2026-10-17 ARC-0026 — stage 2 applied, no change; 2026-10-17 ARC-0026 — Toolkit guides per level (the Owner types), no change; retired entries kept (OR-10); 2026-10-18 ARC-0026 — WB51 (rebuild from zero, OR-59 ids) checked, no change; 2026-10-23 ARC-0026 — the Owner's Toolkit build (WB52–WB61): movement as a Rush cost, the Tempests, Unleashed Winds on a slot, Gale Deflection per turn
---

# 26.01 · Resource audit — The Windborn (internal: Unbound)

The design as the Owner built it in the Toolkit (ARC-0026, WB51–WB61).

| Resource | Sources | Sinks | Recharge | Balance | Risk | Action |
|---|---|---|---|---|---|---|
| Woven Spell Slots (PC: Threads) | Class level | Gale Burst, Wind Blast, Wind Whispers, Flow State, Ready: Gale Deflection (level 3), Zephyr: Tempest (level 4), Untethered, Zephyr: Ally Tempest (level 5), Unleashed Winds (level 6) | Long rest (base class) | No refund: nothing returns a slot | Level 11: the capstone and the level-5/6 cards compete for the top slots | None |
| Threads (PC edition only) | Deck economy (base class) | Every card; Zephyr Strike (1 Thread, created card) | Per combat (deck) | As the base class | — | None |
| **Movement** | Speed (Weightless +4 / +7 / +10 / +13 m) | Zephyr Rush (the distance it covers, WB52); Storm's second Rush (half of it, WB53) | Per turn | A Rush spends up to 9 m of the turn's movement; Weightless pays for it | A Rush after moving may be refused for lack of movement | Watch in the playtest (QA_ARC-0026) |
| **Windswept** (marks on enemies) | Any hit of yours; failed saves against your cards; Riposte; Gale Deflection; allies' hits (Tier II) | Opening the bag; the wind's sweep at your turn start; The Calm; the end of your next turn; death; combat end | Per fight | A counter, not a currency: it costs nothing of hers. It also splits the field: the Tempests and Empty State answer the marked, Wind Whispers and Gale Deflection the unmarked (WB57) | The Open Path lasts while marks do — capped by the duration and the sweeps | None |
| **Aeolus' Bag** (the wind) | Opening it (bonus action, ≥ 1 mark) | Blows X turns, X = marks when opened, capped 2 / 3 / 4 / 5 by rank | Reopens when the wind stops, or at once with The Calm | ≈ 2.5 of 4 turns of wind per fight | No loop: the sweep doesn't extend the wind and a blowing wind is never refreshed (WB60) | Watch uptime (`22.05` V1) |
| **Awakening progress** | Marks released (opening, sweeps, The Calm) | — (tiers at 3 / 5 / 8) | Combat end (D4) | Counter on a status | — | None |
| The Calm | Tier I | 1 cast | Once per combat | Needs a wind | — | None |
| Unleashed Winds | Level 11 | A level-6 slot per cast | Long rest (the slot) | Not while the bag is open | No longer once per Long Rest (WB56) | Watch in the playtest (`22.05`) |
| Gale Deflection uses | Ready: Gale Deflection | Reaction, one per turn | Until combat ends | Was a stock of 3 (WB57) | Competes with Riposte for the reaction | None |
| Storm's second Rush | Casting Zephyr Rush (level 8) | One more Rush, the same turn | Per Rush | One per Rush; any enemy | — | Watch (`22.05` V3) |

## Action economy

| Slot | Users | Conflict |
|---|---|---|
| Action | Unarmed attacks, cards, The Calm, Unleashed Winds | Normal choice of the turn |
| Bonus Action | **Zephyr Strike** and **Aeolus' Bag** (+ Wind Whispers, Zephyr: Tempest, Zephyr: Ally Tempest) | The designed tension until Tier I (the first Rush each turn becomes free) and Flow State (+1 bonus action); the Tempests add two more claimants at levels 7 and 10 |
| Reaction | Riposte (Wind Whispers), Gale Deflection | One per round; she chooses — the split helps: Riposte answers unmarked melee, Gale Deflection unmarked shooters |
