---
id: 22.05/Unbound
owner: Balance Designer
source: 21.04/Unbound/DECISIONS.md (WB0–WB48), DESIGN.md §12, REFINE_Unbound.md ("Balance pass"), 25 (*_Unbound_*)
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); sizes approved by the Owner 2026-10-16 (WB45–WB48); 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — WB49 capstone area noted; 2026-10-17 ARC-0026 — P8 fix applied, no change; 2026-10-17 ARC-0026 — stage 1 complete, WB50 checked, no change; 2026-10-17 ARC-0026 — stage 2 applied, no change
---

# 22.05 · Balance — The Windborn (internal: Unbound) (current verdict)

The game still has the old Unbound build (`05.02/Unbound.md`); no balance arithmetic was ever recorded for it. This file
holds the verdict of the **approved design** (WB0–WB48), costed on 2026-10-16 in the currency of
`22.06/Arcana_Power_Budget.md`. Values: `25` (`*_Unbound_*`, `pending_build`).

**Assumptions** (`22.06` §1): T = 4 turns, E = 4 fights; A = 4 / 8 / 11 at T1 / T2 / T3; p(hit) 0.65 / 0.65 / 0.70;
the party = the Windborn + 3 allies; a wind blows ≈ 2.5 of 4 turns (opened on turn 2, reopened when it stops).
Benchmark (WB19): the Monk for the striker share, a support class for the rest.

## Today's game — verdict until rebuilt

| Feature | Verdict | Why |
|---|---|---|
| Twinkle Toes +38 m at 12 | ❌ dead bonus | Far beyond what a 4-turn fight uses (DM-B6); replaced by Weightless (WB47) |
| Flow State up to 6 turns, Storm Fists / Thunderclap up to 5 | ⚠️ over the reference fight | Trimmed to 3 (WB31, WB34, WB37) |
| Tier III +3 DEX | ❌ off-standard | An ability bonus (DM-A2); replaced (WB24) |
| Zephyr Strike after everything | ⚠️ dominant | Always yes (DM-B5); now a Rush only to unmarked enemies (WB5) |

## The approved design (ARC-0022)

| Feature | Size (`25`) | Arithmetic | Verdict |
|---|---|---|---|
| Zephyr Rush | 9 m (Breeze), 12 m (Gale+) | Built-in dash without opportunity attacks ≈ +0.3A per Rush; ~60% of Zephyrs find an unmarked target | ✅ in band |
| Gale push | 3 m | 0.1A (0.3A at an edge) | ✅ lean weak |
| Storm second Rush | 9 m, once per Zephyr | One more unarmed hit ≈ 0.55A × ~0.6 ≈ +0.35A/turn | ⚠️ watch (V3) |
| Aeolus' Bag | cap 2 / 3 / 4 / 5 | Each wind ≈ 0.55A/turn for the party; T1 ≈ 22/day gross, ≈ 6% of D after the bonus action; T3 ≈ 60/day ≈ 12% of D | ✅ main-feature band |
| Boreas · Notus · Eurus | ±3 m · Disadvantage on ranged vs allies / −1 saves · ±1 attack | 0.55A each; +2/−2 for Eurus would be 1.1A and dominant (DM-B5) | ✅ equal by design (V2) |
| Hurricane (two winds) | — | +0.55A/turn at 12 ≈ 12% of D | ⚠️ watch — the peak (V4) |
| The Calm | Action; 1d8 per gust (3–6), 2d6 (7–12) | vs once-per-combat ceiling: T1 0.9 · T2 0.88 · T3 1.12 | ✅ → strong at 12 (needs a wind and marks) |
| Where the Winds Meet | Action; 18 m; one 9 m area, pull 9 m Windswept / 6 m the others (WB49, 2026-10-17: unmarked enemies now caught from 9 m, not 6 m: more targets, same damage; recheck the band at stage 5); 4d8 Thunder, DEX half | Without damage 0.52 of the capstone band (trap); with 4d8 ≈ 81 / 86 → 0.94 | ✅ (WB46) |
| Awakening goals | 3 / 5 / 8 marks released | Tier I turn 2 at level 3; Tier II turn 3 at 7; Tier III turn 3 at 12 (the waking sweep pushes) | ✅ every tier in a normal fight (V5) |
| Tier III push | 3 m + Off Balance per swept enemy | ≈ 1.2A per turn of wind | ⚠️ watch (V4) |
| Weightless | +3 / +4.5 / +6 / +9 m; jump ×1–×4; falling full → immune | +3 m ≈ 0.15A/turn for a melee; the Rush carries the mobility | ✅ down from today |
| Flow State · Storm Fists | 3 turns | Within the reference fight | ✅ down |
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
