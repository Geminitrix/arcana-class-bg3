---
id: 22.05/Unbound
owner: Balance Designer
source: 21.04/Unbound/DECISIONS.md (WB0–WB61), DESIGN.md §12, REFINE_Unbound.md ("Balance pass"), 25 (*_Unbound_*)
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); sizes approved by the Owner 2026-10-16 (WB45–WB48); 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — WB49 capstone area noted; 2026-10-17 ARC-0026 — P8 fix applied, no change; 2026-10-17 ARC-0026 — stage 1 complete, WB50 checked, no change; 2026-10-17 ARC-0026 — stage 2 applied, no change; 2026-10-17 ARC-0026 — Toolkit guides per level (the Owner types), no change; retired entries kept (OR-10); 2026-10-18 ARC-0026 — WB51 (rebuild from zero, OR-59 ids) checked, no change; 2026-10-23 ARC-0026 — the Owner's Toolkit build (WB52–WB61): Rush, Storm, Tempests, Unleashed Winds, Gale Deflection and Weightless re-read against the game; 2026-10-23 ARC-0026 — WB63 (Twinkle Toes keeps its name; Gale Deflection once a turn) checked
---

# 22.05 · Balance — The Windborn (internal: Unbound) (current verdict)

The Owner built the Windborn in the Toolkit (ARC-0026, WB51–WB61; playtested to level 8 in `QA_ARC-0026`). This file
holds the verdict of the design costed on 2026-10-16 in the currency of `22.06/Arcana_Power_Budget.md`, with the
Owner's build changes (WB52–WB61) read on 2026-10-23. Values: `25` (`*_Unbound_*`).

**Assumptions** (`22.06` §1): T = 4 turns, E = 4 fights; A = 4 / 8 / 11 at T1 / T2 / T3; p(hit) 0.65 / 0.65 / 0.70;
the party = the Windborn + 3 allies; a wind blows ≈ 2.5 of 4 turns (opened on turn 2, reopened when it stops).
Benchmark (WB19): the Monk for the striker share, a support class for the rest.

## The old build — verdict that led to the rebuild

| Feature | Verdict | Why |
|---|---|---|
| Twinkle Toes +38 m at 12 | ❌ dead bonus | Far beyond what a 4-turn fight uses (DM-B6); replaced by Weightless (WB47) |
| Flow State up to 6 turns, Storm Fists / Thunderclap up to 5 | ⚠️ over the reference fight | Trimmed to 3 (WB31, WB34, WB37); Storm Fists and Thunderclap later left the game (WB54) |
| Tier III +3 DEX | ❌ off-standard | An ability bonus (DM-A2); replaced (WB24) |
| Zephyr Strike after everything | ⚠️ dominant | Always yes (DM-B5); now a Rush only to unmarked enemies (WB5) |

## The design as built (ARC-0022, ARC-0026)

| Feature | Size (`25`) | Arithmetic | Verdict |
|---|---|---|---|
| Zephyr Rush | 9 m at every rank; costs the movement it covers (WB52) | Built-in dash without opportunity attacks ≈ +0.3A per Rush, now paid with movement; ~60% of Zephyrs find an unmarked target | ✅ in band (leaner than costed: no 12 m at Gale) |
| Gale push | 3 m | 0.1A (0.3A at an edge) | ✅ lean weak |
| Storm second Rush | 12 m, granted on casting the Rush, any enemy, half the movement (WB53) | One more unarmed + DEX Thunder hit ≈ 0.55A × ~0.9 (any target now) ≈ +0.5A/turn | ⚠️ watch (V3) — stronger than costed |
| Aeolus' Bag | cap 2 / 3 / 4 / 5 | Each wind ≈ 0.55A/turn for the party; T1 ≈ 22/day gross, ≈ 6% of D after the bonus action; T3 ≈ 60/day ≈ 12% of D | ✅ main-feature band |
| Boreas · Notus · Eurus | ±3 m · Disadvantage on ranged vs allies / −1 saves · ±1 attack | 0.55A each; +2/−2 for Eurus would be 1.1A and dominant (DM-B5) | ✅ equal by design (V2) |
| Hurricane (two winds) | — | +0.55A/turn at 12 ≈ 12% of D | ⚠️ watch — the peak (V4) |
| The Calm | Action; 1d8 per gust (3–6), 2d6 (7–12) | vs once-per-combat ceiling: T1 0.9 · T2 0.88 · T3 1.12 | ✅ → strong at 12 (needs a wind and marks) |
| Unleashed Winds (replaces Where the Winds Meet, WB56) | Action + level-6 slot; 18 m; one 9 m area; STR save; 4d8 Thunder, half on a success; Windswept pulled 6 m in, the others pushed 6 m out; Off Balance 1 turn | Same damage as the costed capstone (4d8 ≈ 0.94 of the band); the save moves from DEX to STR and it now spends a level-6 slot instead of a once-per-Long-Rest use — more casts per day, each one costs a top slot | ✅ (recheck at level 11 in the playtest) |
| Awakening goals | 3 / 5 / 8 marks released | Tier I turn 2 at level 3; Tier II turn 3 at 7; Tier III turn 3 at 12 (the waking sweep pushes) | ✅ every tier in a normal fight (V5) |
| Tier III push | 3 m + Off Balance per swept enemy | ≈ 1.2A per turn of wind | ⚠️ watch (V4) |
| Twinkle Toes (Weightless, WB63) | +4 / +7 / +10 / +13 m; jump ×1–×4; falling full → immune (WB59) | +4 m ≈ 0.2A/turn for a melee; the Rush now spends movement, so speed feeds it | ✅ down from the old +38 m; above the costed +3 / +9 m |
| Flow State | 3 turns | Within the reference fight | ✅ down |
| Zephyr: Tempest (L7, WB54) | Level-4 slot, 3 turns; +1d6 / 2d6 / 3d6 + DEX Thunder on unarmed hits vs Windswept, 2 turns of Reverberation | ≈ 3.5 + 3 per hit × ~2 hits × ~0.6 marked ≈ +8/turn at level 7 for a level-4 slot — in the band of a level-4 self-buff; Reverberation adds control | ⚠️ watch (V6) |
| Zephyr: Ally Tempest (L10, WB55) | Level-5 slot, 5 turns, on an ally; +1d4 Thunder on weapon hits vs Windswept, 1 turn of Reverberation | ≈ 2.5 × ~2 hits × ~0.6 ≈ +3/turn for 5 turns ≈ 15 per cast — lean for a level-5 slot; its worth is Tier II (the ally marks) | ✅ lean weak |
| Ready: Gale Deflection (WB57) | Level-3 slot; one use per turn until combat ends; self or an ally nearby; only vs enemies that aren't Windswept | Uses per fight up from 3 to one per enemy turn, but only on unmarked shooters | ✅ |
| Wind Whispers · Empty State (WB57) | Disadvantage / Riposte only vs unmarked melee; half damage only from marked attackers | The Windswept split: the two defences cover the two halves of the field | ✅ by design |
| Preset | STR 8 · DEX 15 · CON 13 · INT 15 · WIS 10 · CHA 10 | AC 16, DC 13 at level 1 (WB21) | ✅ |

**Net reading:** power leaves today's flat speed (+38 m), the Tier III ability bonus and the always-on Zephyr, and goes
into the party (the winds, the Open Path, Tier II), into reach (the Rush) and into one peak (Hurricane + Tier III).
The bonus action shared by Zephyr and the bag is the brake until Tier I.

## What would prove it wrong (playtest — merge into the playtest ticket)

| V# | Fight | Metric | Right if | Wrong if |
|---|---|---|---|---|
| V1 | Level 3, 4 enemies | Turns with a Rush; opening turn of the bag | A Rush most turns; bag opened by turn 2–3 | Rush every turn without choice, or the bag never opened |
| V2 | Level 5–8, a day of 4 fights | Which wind is chosen | Each wind picked in some fights | One wind > 60% |
| V3 | Level 8, 5+ enemies | Storm second Rushes per fight | 1–2 | Every turn |
| V4 | Level 12 | Damage per turn vs the Monk benchmark | Within ±15% of the tier's ceiling | Over by more than 15% with Hurricane + Tier III |
| V5 | Levels 3, 7, 12 | Turn each tier wakes | Turn 2–3 | After turn 4 |
| V6 | Level 7–10 | Damage per turn with Zephyr: Tempest vs without | +15–30% | Over +40%, or the card never cast |
