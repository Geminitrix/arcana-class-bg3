---
id: 22.05/Starchild
owner: Balance Designer
source: 21.04/Starchild/DECISIONS.md (SC0–SC32), DESIGN.md §12, REFINE_Starchild.md, 25 (*_Starchild_*)
reviewed: 2026-10-16 ARC-0023 — created (propagation, 00.08); directions only, values in the balance pass
---

# 22.05 · Balance — The Starchild (current verdict)

No balance arithmetic has been recorded for the Starchild: the 3.1 kit in the game (`05.02`, numbers re-checked
2026-10-02) shipped without a balance report. ARC-0023 (SC0–SC32, 2026-10-16) replaces almost the whole kit; this file
holds the **direction** of each change and what would prove it wrong. Values: `25` (`*_Starchild_*`); new sizes are
‹placeholders› in the `pending_build` blocks until the balance pass (ADR-0005). Currency and parameters:
`22.06/Arcana_Power_Budget.md`.

## Today's game (3.1 kit) — verdict until the build replaces it

| Feature | Verdict | Why |
|---|---|---|
| Starcall → Rejuvenation → free Astral Infusion | ✅ in band (estimate) | A bonus-action heal every turn paid by an action spent on damage; the loop is the subclass |
| Astral Infusion 1d10 per slot level | ⚠️ **watch** | A bonus action above vanilla Healing Word (1d4 + modifier per level); paid by her HP or by Rejuvenation, which Starcall gives every turn |
| Solar Purge (21 conditions, one cast) | ⚠️ **watch** | Wider than any vanilla cleanse; short-rest cooldown is the only brake |
| Solar Flare 8d6 + Stun 1 turn, 3 copies, no cooldown | ❌ **high** | Damage plus Stun on an area at level 11 with no cooldown; the Stun leaves in SC26 |
| Final Spark + Recast (kill resets every cooldown) | ❌ **high** | A cooldown reset on a kill; removed by SC26 |
| Awakening goals 5× / 8× / 12× level of healing | ❓ untested | Depends on allies being hurt first; replaced by SC17 |
| Tier III +3 Wisdom | ❌ off-standard | An ability bonus (DM-A2); removed by SC16 |

## SC0–SC32 — approved design, not built yet (ARC-0023, 2026-10-16)

| Change | Direction | Knob (`25`, `pending_build`) | Verdict until tested |
|---|---|---|---|
| SC6 Hymns shape every heal: Stars focused, Sun radiant spill, Moon tidal | **Flat** in total, different shape | `SPL_Starchild_Outpouring` `stars_focus`, `sun_spill_share`, `moon_now_share`, `moon_tide_turns` | ⚠️ the Sun's spill total over several allies must stay **below** the Stars on one ally (SC6 brake, B1) |
| SC10 Dusk / Nightfall marks; her heal answers them (Dawn on Nightfall) | **Up** on marked allies | `FEAT_Starchild_DuskAndNightfall` `dusk_answer`, `dawn_answer`, thresholds ‹½› / ‹¼› | ⚠️ waiting for Nightfall must stay a gamble: the Dawn bonus below the expected cost of an ally's exposure (B3) |
| SC11 Downed clears the mark | **Down** for yo-yo reviving | — (rule) | ✅ stops the BG3 Downed-then-heal loop from paying Dawn |
| SC12 Light in the Dark (level 10) | **Up** at 10 | `FEAT_Starchild_LightInTheDark` `self_bonus` | ⚠️ her bonus + the target's mark ≤ Dawn (cap in `25`) |
| SC13 Elpis' Jar answers every mark at once | **Up** with the field's danger | `SPL_Starchild_ElpisJar` `plain_heal`, `dusk_heal`, `dawn_heal` | ⚠️ the strongest heal of the class at level 7; once per combat is the brake |
| SC16–SC19 Awakening: answered marks; Tier I Great Star + Undying Hope, Tier II conditions, Tier III Eclipse | **Up** at 7 and 12; +3 Wisdom and damage riders **leave** | `FEAT_Starchild_AspectAwakening` `goals_next` ‹3 / 5 / 8›, `STA_Starchild_TierConditions` `duration_next` | ⚠️ price the best case (B2); check Great Star vs Eclipse evens out across singers (B4) |
| SC19 First heal of the turn gate | **Down** (one empowered heal per round) | `first_heal_gate` (1 turn, StartTurn) | ✅ caps Tier II / III to one trigger per round |
| SC20, SC25, SC26 card rework (Halo no Concentration, Guiding Light an enemy mark, Flare without Stun, Final Spark removed) | **Down** on damage and control, **up** on support | `SPL_Starchild_*` | ⚠️ Halo without Concentration stacks with other Concentration buffs — the Dusk / Nightfall condition is the brake |
| SC27–SC28 Lantern skill bonus | Flat (exploration) | `SPL_Starchild_Lantern` `skill_bonus` | Must stay below Weaver Hand: Guide |
| SC23 Unsung costs a bonus action | **Down** (small) | — | ✅ |

**Net reading:** power moves from damage (Solar Flare's Stun, Final Spark, Moonlit / Sunlit dice) and a flat Tier III
stat into **healing that rewards timing**. The Timing axis (SC7) is the brake: the strongest heals need an ally already
in danger, and a fallen ally loses the mark.

## Checks for the balance pass (DESIGN §12)

| B# | Check | Pass if |
|---|---|---|
| B1 | Sun spill total vs Stars single heal, at levels 1, 5, 10 | Sun total < Stars single, in every band |
| B2 | Best case: first heal on a Nightfall ally under Eclipse (Dawn + three shapes + three conditions) | Within the level-12 budget of `22.06` |
| B3 | Dawn bonus vs the expected damage an ally takes between Dusk and Nightfall | Waiting is a gamble, not the default |
| B4 | Great Star (Tier I) vs Eclipse (Tier III) per Hymn | No Hymn gains clearly more from the Awakening |
| B5 | The three Hymns equally viable (SC4) | Each Hymn wins a recognisable fight (Stars boss, Sun spread damage, Moon long fights) |
| B6 | PC deck (DM-P12): Comet and Outpouring in the same hand | Probability computed and acceptable |

## What would prove it wrong (playtest — merge into the playtest ticket)

| V# | Fight | Metric | Right if | Wrong if |
|---|---|---|---|---|
| V1 | Level 5, any | Turns she waits for Nightfall vs answers Dusk | Both happen; waiting sometimes costs an ally | Always one or the other |
| V2 | Level 3–7 | Turn the Awakening tiers wake | Wakes in a fight with real danger | Wakes in easy fights, or never |
| V3 | Level 7, Sun day | Total Sun healing vs a Stars day on the same fight | Each wins its own fight | One Hymn always wins |
| V4 | Level 12, Tier III | Eclipse first heal per round | Feels like the peak, not a wipe of the fight | Decides the fight alone |
