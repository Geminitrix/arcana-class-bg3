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

## ARC-0025 Stage 0 · R1 the heal core — approved 2026-10-17 (SC33)

Vanilla anchors (Shared `Spell_Target.txt`): Healing Word `1d4+SpellCastingAbilityModifier` (+1d4 per level), Cure
Wounds `1d8+modifier` (+1d8 per level). N = slot level; example slot 3, modifier +4 (level 5). Currency `22.06` §2, §7:
1 HP healed = 0.6; ×0.8 on a hurt ally, ×0.5 spill on allies who may be healthy, healing over time ×0.7.

| Hymn | Heal | Average | Points |
|---|---|---|---|
| Stars — Lodestar Balm | N×1d10 + mod | 20.5 | 20.5×0.6×0.8 = **9.8** |
| Sun — Noonday Pour | target N×1d6 + mod; 1 ally within 3 m N×1d4; 1 enemy next to the target 1d4 Fire | 14.5 + 7.5 + 2.5 dmg | 6.96 + 2.25 + 1.6 = **10.8** |
| Moon — Rising Tide | N×1d4 + mod now; N×1d4 at each of 2 turn starts; attacker −3 m | 11.5 + 15 | 5.5 + 5.0 + ~0.3 = **10.8** |

Marks: Dusk +N×1d4 (+7.5), Dawn +N×1d8 (+13.5), the Hymn part doubled. Waiting (B3): at level 5 an ally at 40% of
~44 HP has ~18 HP, one enemy round on them ~16 (2A) — about an even chance of Downed for +6 HP over Dusk → a gamble.
Against vanilla: a slot-3 Healing Word heals 11.5 as a bonus action; Outpouring heals 11.5–20.5 and pays HP without
Afterglow — **watch** at the band check (B1 of the playtest), as the specialist healer it is meant to lead.

## ARC-0025 Stage 0 · R2 the Awakening — approved 2026-10-17 (SC34)

Goals 3 / 5 / 8 (cumulative): ~1 answer a turn in a hard fight + Hesperus + Elpis' Jar (several at once) → Tier I by
turn 2, II by 3, III by 4 of a T = 4 fight (`22.06` §1); same steps as the Kingmaker. Conditions on one enemy turn
(2A): Dazzled −1d4 (≈12.5% fewer hits) 1 turn ≈ 3 · half movement 2 turns ≈ 3.5 · Burning 1d4 × 2 turns ≈ 4 (less vs
fire resistance) — within a point (SC4). Great Star: 2 answers of Lodestar Balm — level 5 ≈ 2 × 20.5 HP ≈ 20 points,
level 12 ≈ 2 × 38 HP ≈ 36 points (≈ 3A) for a once-per-combat 0-Thread card. **Watch:** the answers count for the
Awakening; if Tier III comes before turn 3, answer once only.

## ARC-0025 Stage 0 · R3 the cards — approved 2026-10-17 (SC35)

Values per card in `25` (`SPL_Starchild_*`). Checks: **Elpis' Jar** level 7 (slot 4, +4), one Nightfall + one Dusk +
two unmarked = 32 + 24 + 14 + 14 = 84 HP ≈ 40 points ≈ 5A once per combat — the kit's strongest turn. **Flare** 6d6
(21) on ~3 targets + Burning ≈ a slot-3 Fireball, below the slot-6 band on purpose (SC26). **Halo** +3 AC on a focused
ally for 3 turns ≈ 0.7A — **watch** (weak by the formula; a level-2 bonus action, no Concentration). **Rekindle** ≈ 3A
(`22.06` §7) plus the Dawn it sets up. Durations ≤ 5 turns; the Moon's "longer" variants stay within T + 1.
