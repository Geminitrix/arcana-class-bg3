---
id: 26.01/Starchild
owner: Balance Designer
source: 21.04/Starchild/DECISIONS.md (SC0–SC32), DESIGN.md §4, §5, §8, §10
reviewed: 2026-10-16 ARC-0023 — created (propagation, 00.08); the build's changes (SC0–SC32) below, values in 25
---

# 26.01 · Resource audit — The Starchild

## Today's game (3.1 kit, `05.02`)

| Resource | Sources | Sinks | Recharge | Balance | Risk | Action |
|---|---|---|---|---|---|---|
| Woven Spell Slots (PC: Threads) | Class level | Every card: Starcall, Astral Infusion, Lunar Wisp (1); Solar Purge, Lunar Aegis (2); Starbreath, Lucent Singularity, Star Radiance (3); Wish, Moon Gravity (4); Equinox, Astral Fortitude (5); Solar Flare, Final Spark, Stellar Grace (6) | Long rest (base class) | No refund loop, except Recast Final Spark resetting cooldowns on a kill | Final Spark's reset | Removed by SC26 |
| Her own hit points | Rejuvenation regain; heals on herself | Astral Infusion (10% of her max HP without Rejuvenation; not at ≤ 11%) | — | Starcall → Rejuvenation makes Infusion free | — | None |
| Rejuvenation | Starcall (2 turns) | — | Each Starcall | The fuel of the core loop | — | None |
| Cooldowns | — | Solar Purge (short rest), Starbreath, Stellar Grace (long rest), Wish (once per combat) | Rest / combat | Capstone budget | — | None |
| Concentration | — | Lunar Aegis, Star Radiance, Lucent Singularity, Final Spark, Stellar Grace | — | Five cards share it | Stellar Anchor (Advantage on Concentration saves) papers over it | Most leave Concentration in SC20 |
| Awakening progress | Effective healing | Tiers at 5× / 8× / 12× level | Combat end | Needs allies hurt first | — | Replaced by SC17 |

## After the ARC-0023 build (SC0–SC32, approved 2026-10-16)

| Resource | Sources | Sinks | Recharge | Balance | Risk | Action |
|---|---|---|---|---|---|---|
| Woven Spell Slots (PC: Threads) | Class level | Comet, Outpouring, Hesperus (1); Cleansing Rain, Halo (2); Rekindle, Guiding Light (3); Elpis' Jar, Tether (4); Stillness, Long Twilight (5); Flare, Dawnbringer (6). Lantern and Sing a Hymn cost none | Long rest | No refund loop: Final Spark's reset leaves | — | None |
| **The Hymn** (daily choice) | Sing a Hymn, once per long rest | Locks two of three children of every card for the day | Long rest | A daily commitment, no spend | Unsung: every child locked until she sings (a bonus action in combat, SC23) | None |
| Her own hit points | Afterglow regain; heals on herself | Outpouring (‹10%› of max HP unless Afterglow; not at ≤ ‹11%›) | — | From level 10 the cost can push her into Dusk, which empowers her heals (Light in the Dark) | Self-harm loop at 10+: brake = her bonus + the target's mark ≤ Dawn | Watch (`22.05`) |
| **Afterglow** | Comet on a hit (‹2› turns, ‹+1› next to a marked ally) | Her next Outpouring is free | Each Comet hit | The fuel of the core loop, now tied to a hit and to the marks | — | None |
| **Dusk / Nightfall** (on allies; on her from 10) | Damage crossing ‹½› / ‹¼› downward; Rekindle; Undying Hope; Long Twilight moves the thresholds | Her heal answers and consumes one; Elpis' Jar, Flare and The Great Star answer several; Downed clears it; rising above the threshold steps it back | Each new downward crossing | A state, not a currency: she spends nothing to create it | Letting allies sink to farm marks — braked by SC11 (Downed clears) | Watch (V1 in `22.05`) |
| **Awakening progress** | Answered marks: Dusk 1, Nightfall 2 (Hesperus counts) | Tiers at ‹3 / 5 / 8› | Combat end | Wakes only when the party is in danger | — | Values in the balance pass |
| First heal of the turn | Her first single-ally heal each turn | Tier II condition / Tier III Eclipse | Hidden status, 1 turn (StartTurn) | One empowered heal per round | — | None |
| Cooldowns | — | Cleansing Rain (short rest); Rekindle, Dawnbringer (long rest); Elpis' Jar, The Great Star (once per combat) | Rest / combat | Capstone budget | — | None |
| Hesperus reaction | The card (charge refilled by it) | A heal on a new mark, on the enemy's turn | Until long rest or combat ends | Competes with vanilla reactions | — | None |
| Undying Hope | Tier I | The first ally who would drop to 0 | Once per fight | Puts the ally in Nightfall: feeds Dawn | — | None |

## Action economy (after the build)

| Slot | Users | Conflict |
|---|---|---|
| Action | Comet, Cleansing Rain, Rekindle, Guiding Light, Tether, Stillness, Long Twilight, Flare, Dawnbringer | Comet for Afterglow vs a support card — the turn's choice |
| Bonus Action | Outpouring (every turn), Halo (6+), Elpis' Jar (7+), Sing a Hymn while Unsung | Outpouring competes with Halo and the jar from level 6; forgetting the Hymn costs turn 1's Outpouring |
| Reaction | Hesperus | Competes with vanilla reactions |
| Concentration | Dawnbringer (open, DESIGN §14) | Almost free: Halo, Guiding Light and Lantern no longer use it |
