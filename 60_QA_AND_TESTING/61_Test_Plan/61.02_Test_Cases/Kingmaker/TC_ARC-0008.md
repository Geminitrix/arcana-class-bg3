---
id: 61.02/Kingmaker/TC_ARC-0008
owner: QA Lead
source: SPEC_ARC-0008.md (probes P1–P48, stages 1–6) · 21.04/Kingmaker/DESIGN.md · 21.03/Kingmaker.md · 22.05/Kingmaker.md §"What would prove it wrong"
reviewed: 2026-10-15 ARC-0008 — created (propagation, 00.08)
---

# TC_ARC-0008 · The Kingmaker — acceptance and regression suite

- **Decision it informs:** keep the Kingmaker as built (levels 1–12), or send a failing rule back to the Lead Class
  Designer / Mod Engineer. Re-run as regression after any change to the Wheel (goal `ARCANA_Kingmaker_Wheel`, statuses,
  cards).
- **Scenario:** console edition, a Kingmaker built through the real progression at levels 1, 3, 5, 7, 9, 11, 12, in a
  party of four; compile the Story after any apply. The PC deck is SPEC stage 7 (not built yet).
- **The Owner plays every probe at the end of the subclass** (Owner's choice, 2026-10-15): none has been played yet.
  The full step and fallback of each probe are in `SPEC_ARC-0008.md`; this file keeps one line per rule.

## Static (no game session) — last run 2026-10-15 by Claude

| # | Step | Expected | Result |
|---|---|---|---|
| S1 | `bash 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh` | 51 matches the game | ✅ 318 files, 0 changed |
| S2 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/check_cards.pl` | `OK -- nenhum problema` | ✅ 113 roots |
| S3 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/validate.pl` | 0 errors | ✅ 0 errors, 4 warnings |
| S4 | no line over 4000 characters in the mod's Stats `.txt` / `.stats` | none | ✅ 0 |
| S5 | `dump_progression.pl`, Kingmaker rows, vs `21.03/Kingmaker.md` | identical | ✅ levels 1, 3, 5, 7, 9, 11, 12 match |
| S6 | Story `log.txt` after compiling | `0 error(s), 0 warning(s)` | Owner, at the next compile |
| S7 | Subclass icon in character creation | the Kingmaker icon shows | ❌ expected to fail: the files are `Spinner.DDS`, the `Name` is `Kingmaker` — SPEC stage 7 (`42.04/Kingmaker.md`) |

## In game — one assertion per rule (Owner; all pending)

| Rule | Probes | Expected | Result |
|---|---|---|---|
| Binding | P1, P2, P8 | Coronation → Rising; Dethrone → Falling whatever the save, half damage on a save; the cantrip's extra die only on Falling / Fallen | pending |
| The Wheel turns | P3, P5, P6, P7 | At the Kingmaker's turn start every position moves on, shown before acting; Turn the Spoke moves one at once, no slot; turns while the Kingmaker is downed; death and combat end clear it | pending |
| The crown | P4, P18 | The longest-Reigning ally is King, others Regent; the King's Hand wears it while no ally reigns | pending |
| The Crossing | P9, P10, P11, P38, P43 | 1d4 Force within 9 m of a Reigning ally, never beyond; once per enemy per round; Master of Ships carries it; Fortune's Reach at any range | pending |
| Awakening | P12, P13, P14, P26, P44 | Goals 3 / 5 / 8, a lone enemy counts 2; Tyche enters one ahead; Rota Fortunae once per combat; Nemesis drops Falling neighbours; Tier III allies never Fallen | pending |
| Atropos' Cut | P15, P16 | 3d8 / 2d8 / 1d8 by position, off the Wheel; a Reigning ally keeps Reigning one turn; upcasts add dice | pending |
| The Court | P17, P19, P20, P21, P22, P29, P30, P31, P32, P37, P39, P40 | Offices up to CHA, locked by level, gone at Long Rest, empty seat on death; each office's rule as in the SPEC; Master of Coin once per Long Rest | pending |
| Peripeteia | P23, P24 | Within 18 m every position flips and Crossings pay; once per combat, upcasts included | pending |
| Hubris and Usurp | P25, P27, P28 | A Reigning enemy gains Hubris, its Crossing deals two dice; Usurp swaps one ally and one enemy, two allies do nothing | pending |
| Succession | P33, P34 | The nearest enemy off the Wheel within 9 m inherits the position; a Reigning heir gains Hubris | pending |
| Wheel of Ixion | P35, P36 | 5d6 (6d6 at slot 6), Falling whatever the save, allies take no wheel damage, the fire surface burns them | pending |
| The Wheel Stops | P41, P42 | Two turn starts without turning, Crossings each time; the Kingmaker's cards still move creatures (SP112) | pending |
| Ready: Foreseen | P45, P46, P47 | Bonus Action, once per combat (SP114); Reigning → Falling and Falling → Fallen before the roll; not offered on Rising / Fallen | pending |
| Two Kingmakers | P48 | Separate Wheels; a creature on one only (SP113) | pending |
| Progression | — | A new Kingmaker 1 → 12 gets exactly the `21.03` table | pending |

## Balance watch (playtest, `22.05/Kingmaker.md`)
At least 2 Crossings a fight and under 25 % of the party's damage · Tier I by turn 5 (normal) / turn 4 (lone boss) ·
The Wheel Stops under a quarter of a boss's HP alone · Master of Coin one slot a day.

## Next
The Owner plays P1–P48 in one session; failures become bugs in `62` (bug vs design feedback separated).
