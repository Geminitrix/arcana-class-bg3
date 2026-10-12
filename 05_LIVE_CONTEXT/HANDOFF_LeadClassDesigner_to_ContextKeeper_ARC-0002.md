# HANDOFF · Lead Class Designer → Context Keeper · ARC-0002

**What:** the Resonant was raised to the subclass standard (design only; nothing changed in the game
files). Update `05.02_Subclasses/Resonant.md`.

**Sources:** `21.04_Subclasses/Resonant/2026-10-11-resonant-design.md` (the new design, replaces the
2026-10-06 one as the design pointer) · `55_Implementation_Specs/_wip/Resonant/decisions.md` (R1–R21).

## 1. Change the design pointer

Design: `21.04_Subclasses/Resonant/2026-10-11-resonant-design.md`. The progression table "in the game
today" stays as it is — the game files did not change.

## 2. Add the Depth audit (2026-10-11)

Audit of the state **before** the raise (spec 2026-10-06 + wiki + game), and what resolves each gap.

| Question | Before | Resolved by |
|---|---|---|
| I1 fun | ⚠️ enemy side needs two saves (~36 %), states last 1–2 turns, no big moment | R9–R16; **playtest still due** |
| I3 archetype | ⚠️ not written | Spec §2.7 ("the empath who plays the room") |
| I6 vocabulary | ⚠️ "Turn the Wheel" belongs to a wheel theme | R4 (Temper), R20 (Emotional Overload), R21 (Resonance) |
| S3–S4 characters | ⚠️ / ❌ names only | R3 |
| S6 myth | ❌ none | R2 (Iris, Harmonia) |
| M3 gears | ⚠️ feelings read by nothing, converters late | R6, R10, R12 |
| M4 grows | ⚠️ no new rule at level 3 | R6 |
| M6 bounded | ⚠️ who causes reactions undefined | R7 |
| K2 exclusive | ⚠️ peaks read like vanilla numbers; Equanimity a generic cleanse | R15, R17, R18 |
| K3 ties it together | ❌ none | R10, R20 (Emotional Overload) |
| K6 two plays + fallback | ❌ no Bonus Action before 7; cantrip not built | R6; cantrip still to build |
| P1–P2 style, versatility | ⚠️ not written | Spec §2.7 |
| P5 fight length | ⚠️ slots run out (2 at level 1) | R16 (refund on reaction) |
| A2 tiers | ⚠️ Tier III generic | R14 |
| B1, B2, B4 | ⚠️ / — no numbers | **Balance pass** (`25_Master_Data`) |
| T2 tests | ⚠️ engine test results not recorded; new peaks untested | **Tests** (spec §15) |
| T4 conventions | ⚠️ Heartweaver names left | **Owner, in the Toolkit** |
| D1 Identity Sheet | ❌ | Spec §2–§3 |
| D2 sources agree | ❌ | This handoff; the wiki (`75.02`) still shows the old kit |

Every other question: ✅.

## 3. Open items to list

Tests of §15 (balance pass done: numbers in `25.01`–`25.03`; renames done in ARC-0003) · the player guide (`75.02/src/data/resonant.json`) still
describes Turn the Wheel, Attunement, Equanimity and the old Tier III.

## 4. ARC-0003 (game files changed)

The last "Heartweaver" leftover is gone: the ProgressionDescription row Name is `New_Stat_Resonant`. The
Resonant's tag is `THERESONANT` (`c3a59afe-c03e-4fe0-9c7c-dc45ee46e21e`) — `05.02/Resonant.md` still says
"internal tag `THEHEARTWEAVER`"; replace it.
