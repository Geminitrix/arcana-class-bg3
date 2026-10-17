---
id: 61.02/Unbound/TC_ARC-0022
owner: QA Lead
source: 21.04/Unbound/DECISIONS.md WB0–WB48 · DESIGN.md §13, §15 · 22.05/Unbound.md (V1–V5)
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08)
status: planned — part A (probes) runs first in the build ticket; parts B and C after the build
---

# TC_ARC-0022 · The Windborn — the Open Road build

**Decision it informs:** close the Windborn build, or send a failing rule back to the Lead Class Designer.
**Scenario:** console edition (no SE), a Windborn built through the real progression, the standard saves of `83.02`;
the PC (SE) edition where marked. Compile the Story after any apply. Values: `25` (`*_Unbound_*`).

## A · Probes (one rule each — they decide the spec)

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| A1 | A Rush (`Rush_SpringAttack`) provokes no opportunity attack and paths around obstacles | She arrives and strikes; no OA on the way | Teleport + strike (Misty-Step pattern) |
| A2 | A target condition on Windswept splits Zephyr into Rush / plain strike | Unmarked → Rush; marked → plain strike | Two created cards, shown by the target state |
| A3 | The turn-start hook used by the sweep | The sweep runs at the start of her turn only while the wind status is on her | Tick the wind status on her turn and sweep on its tick |
| A4 | `Projectile_VacuumBulb` pull to a point | Enemies within 6 m pulled to the point; Windswept from 9 m | Two explosions (6 m all, 9 m Windswept only) |
| A5 | Leap of Faith on the `Rush_ForceTunnel` animation | The dash-through animation plays with wind VFX | Keep `Rush_SpringAttack` |

## B · Rules of the build (one rule per test)

| # | Rule | Expected |
|---|---|---|
| B1 | Windswept from a hit; from a failed save on each card; from Riposte and Gale Deflection | Each marks; a success on a save doesn't |
| B2 | The Open Path | A Windswept enemy makes no opportunity attack on an ally |
| B3 | Duration | A mark lasts until the end of her next turn, outside a wind |
| B4 | The bag: needs a mark; X = marks, capped by rank; opening clears; shut while the wind blows | As stated; the "bag is open" status shows the turns |
| B5 | The sweep | At her turn start, wind blowing: every mark cleared, each counted |
| B6 | The Calm | Only with a wind; gusts = remaining turns on each Windswept enemy; the bag can open the same turn |
| B7 | Where the Winds Meet | Refused while a wind blows; pull, Off Balance, mark, 4d8 Thunder (DEX half) |
| B8 | Ranks | Gale push 3 m and Eurus at 4; Storm second Rush at 8 (only after an unmarked target); Hurricane two winds at 12 |
| B9 | Tiers | I: first Rush each turn free · II: an ally's hit marks · III: each sweep pushes 3 m + Off Balance, the waking sweep included |
| B10 | Armour or a shield | Every Windborn passive, card and status stops |
| B11 | The level map | `dump_progression.pl` matches DESIGN §9.1 (ranks at 4 and 8, WB16) |
| B12 | Names (WB44) | Every name of `32.01/Unbound.md` "after the build"; no Twinkle Toes, Feather Fall, Thunderclap, Evasive Flow, Momentum, Eye of the Storm in a tooltip |

## C · Balance (from `22.05` V1–V5)

| # | Fight | Metric | Right if | Wrong if |
|---|---|---|---|---|
| C1 | Level 3, 4 enemies | Rushes; bag opening turn | A Rush most turns; bag by turn 2–3 | Every turn without choice, or no bag |
| C2 | Levels 5–8, a day | Wind chosen | Each wind in some fights | One wind > 60% |
| C3 | Level 8, 5+ enemies | Storm second Rushes | 1–2 per fight | Every turn |
| C4 | Level 12 | Damage per turn vs the Monk | Within ±15% | > 15% over |
| C5 | Levels 3, 7, 12 | Turn each tier wakes | Turn 2–3 | After turn 4 |

**Qualitative (after each session):** What did you want to do that you couldn't? When did you feel strongest? Which wind
did you open, and why? What would you call the Windborn's signature?
