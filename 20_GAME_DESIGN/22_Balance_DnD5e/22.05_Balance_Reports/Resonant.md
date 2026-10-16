---
id: 22.05/Resonant
owner: Balance Designer
source: 21.04/Resonant/DECISIONS.md (R1–R48) and R49–R68 (ARC-0014), 25 (*_Resonant_*), 2026-10-11_ARC-0002_Resonant_Balance.md
reviewed: 2026-10-16 ARC-0014 — directions of R49–R68 added (design, build pending)
---

# 22.05 · Balance — The Resonant (current verdict)

The arithmetic of 2026-10-11 (approved by the Owner) stays in `2026-10-11_ARC-0002_Resonant_Balance.md`. Decisions
taken after it (R22–R48, 2026-10-12) changed some of its premises; this file is the **current** verdict per feature.
Currency and parameters: `22.06/Arcana_Power_Budget.md` (A = 4 / 8 / 11 by tier; D = daily budget; E = 4 fights, T = 4 turns).
Every probe passed in game (functional); the balance playtest of the 10-11 report §6 has **not** been recorded yet.

| Feature | Verdict | Why |
|---|---|---|
| Catharsis (2d8 → 3d8 at 5 → 4d8 at 10; Tier I +1d8) | ✅ in band | ≈ A from tier 2, as in the 10-11 report §1; unchanged since |
| Weave Surges + refund (R16) | ✅ in band | Reaction turn ≈ cost of its action only; once per turn caps the slot economy (no engine, see `26.01`) |
| Heartstring, feeling dice | ✅ in band | Unchanged (report §5) |
| Aspect goals 3 / 6 / 15 | ✅ in band | Unchanged (report §3) |
| **Overload → Emotional Overload** | ⚠️ **watch — likely above band** | The 10-11 math assumed the meter from level 5 and a reset each combat, giving 1–2 uses per day (10–20 % of D). Since R29/R31 it exists from level 1 and **carries over between combats**: ≈ 16 turns of filling per day at ≈ 4 turns per fill → up to ≈ 3–4 Emotional Overloads per day at ≈ 4–7A each ≈ **30–40 % of D**, and R48 made it a Bonus Action (no action cost). The *Overloaded* silence (character-level turns) is the brake before level 5; from level 5 the release is immediate |
| **Tier II Harmony** (free Surge once per turn, R40/R42) | ⚠️ **watch** | +1 Surge per turn from about turn 3–4 at level 7 ≈ +1 control action per turn (≈ A) for the rest of the fight — strong for a Tier II; not priced in the 10-11 report |
| **Shared Heart** (R46: feelings are shared, no free Surges) | ⚠️ re-estimated, **on target if the party fights close** | The 10-11 value (≈ 9A) came from free Surges (R24), removed by R46. Now: a bright feeling braided once lands on ≈ 3 more linked allies; at ≈ 0.5A per ally-turn × 2 turns × 3 allies ≈ 3A per bright reaction; ≈ 1 per turn over the ≈ 3 turns left ≈ 9A — the capstone target, but only while allies stay within 18 m |
| Tier III area Emotional Overload | ✅ in band, depends on the Overload row | ≈ 4.7A per use (report §2); if uses per day rise (row above), so does this |

## What would prove it wrong (playtest)

| Fight | Metric | Proves the ⚠️ rows wrong / right |
|---|---|---|
| A full adventure day at level 5–7 (4 fights, no long rest) | Emotional Overload uses per day | **3 or more** → above band: slow the fill (e.g. reset between combats again, or a larger meter) |
| Level 7–9 fights after Tier II wakes | Surges per turn; enemies controlled per turn | Fights end on Harmony's turn 4 every time → Tier II too strong |
| Level 11, party within 18 m | Feelings braided per reaction; damage prevented | Under ≈ 2 extra allies per feeling on average → below target |

Proposed next step: a balance ticket to run these three fights (QA prepares, the Owner plays) before the 4.0 build.

## R49–R68 — approved design, not built yet (ARC-0014, 2026-10-16)

Directions from `21.04/Resonant/REFINE_Resonant_2026-10-15.md` §9, updated with the Owner's redesign. Final values in the
balance pass (`25`, blocks `pending_build`); the playtest is ARC-0010.

| Change | Direction | Estimate (`22.06`) | Verdict until tested |
|---|---|---|---|
| R49 a used mood is spent · R50 excess once per fight | **Down** | Removes the repeating loops: mass Ecstasy (≈ 3A a turn at tier 3, over the per-turn ceiling of 31), the Amazement stun-lock (≈ 1.8A a turn), the Temper action-lock (≈ 0.8A a Bonus Action) | Fixes the Harmony ⚠️ row's worst case |
| R51/R52/R67 *Overloaded* without silence; Surge rider once per turn | **Up** at 1–4, flat after | Silenced turns removed; rider ≈ 2.5 / 5 / 7.5 per turn on one landing Surge, against the same damage taken | ⚠️ watch the rider's target count at tier 3 |
| R51/R68 Emotional Overload: dance 1 turn on a failed save, half damage on a success, Mental Fatigue | **Down** from today | Dance ≈ 2–2.5A against Paralysed's 3.5A (×2 turns today, no save); a save now gates it; Mental Fatigue primes the next Surge | Toward 10–20 % of D, with R53 |
| R53 the meter settles to half after a fight | **Down** | ≈ 3–4 releases a day → ≈ ‹1–2› | Answers the Overload ⚠️ row; measure in ARC-0010 |
| R56 Tier III fills the meter · R68 dance ‹2› at Tier III | **Up** at 12 | +1 release per fight that wakes Tier III | Inside the Tier III peak |
| R61 Heartstring + per feeling · R62 dice states at 5/9 · R67 Catharsis at 5/9 | **Up** mid/late | ≈ +2.5 per feeling; dice ≈ +20–40 % per step; Catharsis one level earlier at its last step | Offsets the tier-3 plateau |
| R58 Shared Heart Joy on cast · R57 helpful feelings only | Up (slight) / flat | Advantage on one attack per ally | Capstone budget |
| R59 the spread map · R54/R55 the container and deck copies | Flat | Content earlier (Temper 2) or later (Complex Feelings 6, Compassion 10); same deck density | — |

**Net reading:** power leaves the loops and the free paralysis, and goes to levels 1–4, the dice states and the end of
the journey. The total should land near the intended budget; today's real power at tiers 2–3 is above it because of the
loops.
