---
id: SPEC_ARC-0026
ticket: ARC-0026
status: draft
implementation: claude
author: Mod Engineer
updated: 2026-10-17
---

# SPEC_ARC-0026 · Windborn refining build — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans. **One `[fechado] ARC-0026` message = one
> stage**; stage 0 writes only project files. Lean execution: no subagents, dry runs read as counts, reports ≤ 10 lines.

**Intent:** the game plays the Windborn as `21.04/Unbound/DESIGN.md` describes it (WB0–WB48), in both editions.

**Design:** `21.04/Unbound/DESIGN.md` · **Decisions:** `21.04/Unbound/DECISIONS.md` · **Numbers:** `25`
(`*_Unbound_*.yaml`, blocks `pending_build`) · **Texts:** `32.01/Unbound.md` (names WB44) · **Prepared files:**
`55/_wip/Unbound/arc0026/` · **Tests:** `61.02/Unbound/TC_ARC-0022.md`.

## Global constraints

The constraints and the apply chain of `SPEC_ARC-0020.md` apply unchanged (stats through `stats_add.pl` patches,
structure scripts with dry runs, English loca only, **internal ids keep their names** — `Unbound`, `Fool`,
`TwinkleToes`, `Weightless`, `FlowingStrikeZephyr` stay — lines ≤ 3900, no repeated field, goals CRLF/ASCII and
compiled by the Owner, every function anchored, probes before uncertain pieces). Every Windborn passive, card and status
keeps the armour rule (`not WearingArmor() and not HasShieldEquipped()`).

## Stages (detailed tasks are written in stage 0, one stage at a time)

| Stage | What | Decisions | Writes the game? | Gate |
|---|---|---|---|---|
| **0** | Patches, structure script, goal drafts; the build's texts through `32.04` | all | No | Dry runs clean; Narrative gate |
| **1** | Probes P1–P8 on test entries | — | Yes (throwaway) | Each probe answered; plan B chosen where needed |
| **2** | The Open Road: *Windswept* (status), the core passive (rewrite of `Arcana_Passive_FlowingStrikeZephyr`), the Open Path, Zephyr's Rush (Breeze), marks from hits and failed saves (Osiris + each card's Stats); card tooltips lose "Afterwards…"; Gale Burst loses its free strike | WB3, WB5, WB8–WB10, WB18, WB27, WB28 | Yes (+ goal) | A level-1 Windborn marks, rushes to the unmarked, and marked enemies make no opportunity attack |
| **3** | Aeolus' Bag (Boreas, Notus), the wind statuses, the sweep at her turn start, the "bag is open" lock; the Awakening rewrite (marks released 3/5/8, tiers The First Step / Fellow Travellers / Into the Storm); The Calm; old tier bonuses removed | WB11–WB15, WB22–WB25, WB48 | Yes (+ goal) | A level-3 Windborn opens the bag, the wind sweeps, Tier I wakes |
| **4** | Ranks Gale (push, Eurus) and Storm (second Rush) at 4 and 8; Weightless (generator, ranks 1/4/8/12) replacing Twinkle Toes and Feather Fall; the cards moved or merged (Flow State and Gale Deflection to 6, Storm Fists absorbs Thunderclap, Untethered absorbs Eye of the Storm, Leap of Faith as a card at 10 on the Force Tunnel animation, Empty State to 9); retirements (True Strike, Evasive Flow, Thunderclap, Momentum, Eye of the Storm) | WB6, WB7, WB16, WB17, WB29–WB43, WB47 | Yes (lsx + stats) | Level-up shows `DESIGN.md` §9.1 |
| **5** | Where the Winds Meet (capstone, 11); Hurricane (two winds, 12); Be the Leaf with INT; the preset; the display name *The Windborn* | WB0, WB15, WB21, WB26, WB46 | Yes | Level 12 plays the storm; the class panel says The Windborn |
| **6** | Close: `25` (`pending_build` → `values`), `05.02`, catalogs, docs; the test guide (`GUIDE_ARC-0026.json`, `TEST_GUIDES.json`, the Arcana Test Guides page) | — | No | `check_propagation` OK |

### Probes (stage 1)

| P# | Question | Anchor | Plan B |
|---|---|---|---|
| P1 | A Rush (`Rush_SpringAttack`) carries her to the target without provoking opportunity attacks, and paths around obstacles (TC A1) | Today's Leap of Faith (`Rush_Arcana_Created_Aspect_LeapOfFaith`, mod `Spell_Rush.txt`); vanilla `Rush_MAG_ZephyrFlash` | A teleport next to the target, then the strike |
| P2 | One Zephyr Strike that is a Rush against an unmarked enemy and a plain strike against a marked one (TC A2) | Today's `ZEPHYR_STRIKE` granting `Target_Arcana_Created_ZephyrStrike` | Two created cards: the Rush (target condition `not HasStatus('<WINDSWEPT>')`) and the plain strike |
| P3 | The turn-start hook for the sweep while the wind status is on her (TC A3) | The per-round reset of `ARCANA_Aspect_Fool.txt` (ARC-0007) | The wind status ticks on her turn (`TickType StartTurn`, `TickingWithSource`) and Osiris sweeps on that tick |
| P4 | A pull of every enemy to a point (TC A4) | Vanilla `Projectile_VacuumBulb` / `Projectile_MAG_PullingShout_Explosion` (`Force(-6, TargetToEntity)`, radius 9) | Two explosions (6 m every enemy, 9 m Windswept only) |
| P5 | Leap of Faith on the `Rush_ForceTunnel` animation with wind VFX (TC A5) | Vanilla `Rush_ForceTunnel` (`Shared/.../Spell_Rush.txt`, `SpellAnimation`) | Keep `Rush_SpringAttack` |
| P6 | **The Open Path:** a Windswept enemy makes no opportunity attack. Vanilla `Interrupt_AttackOfOpportunity` (`Shared/.../Interrupt.txt`) blocks it only for a fixed list of statuses; the Mobile feat's pair is one of them: `MOBILE_NO_AOO` on the enemy and `MOBILE_NO_AOO_SOURCE` on the mover (`Status_BOOST.txt`, applied in `Passive.txt`). Test: Windswept also applies `MOBILE_NO_AOO`, and the party carries `MOBILE_NO_AOO_SOURCE` while the Windborn is in combat | Vanilla Mobile feat | Windswept blocks the enemy's reactions altogether (`IsAbleToReact` false — wider: no reaction of any kind; `22.06` §4 prices it the same, 0.1A) |
| P7 | Marks from a hit by her, by an ally (Tier II) and from a failed save on each card | The hit hook of `ARCANA_Aspect_Fool.txt` (counts different enemies hit today); `ApplyStatus` in each card's `SpellSuccess` | Apply the mark from each card's Stats only, and from a passive on her unarmed attacks |
| P8 | The bag reads X (standing Windswept enemies) and caps it by rank | Osiris counting of standing enemies (the Fool goal's fallback, ARC-0007) | A status stack per mark, read by the bag's variants |

---

## Stage 0 — preparation (project files only)

Files in `_wip/Unbound/arc0026/`: `00_texts.md` (Task 0.2), `10_core.patch` (0.3), `20_bag_awakening.patch` +
`22_goal_fool.txt` (0.4), `30_ranks_cards.patch` + the Weightless generator table (0.5), `40_capstone_names.patch` (0.6),
`50_structure.pl` (0.7 — lists and progression, the map of `DESIGN.md` §9.1). Values come from `25` (`pending_build`)
only; texts from `00_texts.md` once the Narrative gate passes.

### Task 0.1 · inventory — what happens to each entry (read from `51`, 2026-10-17: 106 Stats entries)

| Fate | Entries | Where |
|---|---|---|
| **Kept, text only** | Gale Burst (+ `_2`–`_6`), Wind Blast (+ `_3`–`_6`), `Projectile_Arcana_Reaction_GaleDeflection`, `Interrupt_Arcana_Reaction_GaleDeflection(_Return)`, `GALE_DEFLECT_MISSILES`, `GALE_DEFLECTION_READY`, `Arcana_Passive_GaleDeflection`, Flowing Strikes: Agility / Precision, Flowing Assault, Magic Strikes | 10, 30 |
| **Kept, changed** | `Arcana_Passive_FlowingStrikeZephyr` → The Open Road; `ZEPHYR_STRIKE` + `Target_Arcana_Created_ZephyrStrike` (plain strike) — Gale Burst loses its free strike; Be the Leaf (INT); Flow State (+ variants, `FLOW_STATE*`: 3 turns, level 6); Ready: Gale Deflection (level 6, ally); Wind Whispers + `WIND_WHISPERS` (Advantage absorbed); `Interrupt_Arcana_WindWhispers_Riposte`; Storm Fists (+ variants, `STORM_FISTS*`: vs unmarked, 3 turns); Untethered (+ `_6`, `FLY_UNTETHERED`, `Projectile_Arcana_Card_Ability_Fly_Untethered`: AC folded in); `Rush_Arcana_Created_Aspect_LeapOfFaith` → a card at 10, once per Short Rest, `Rush_ForceTunnel` animation; Empty State (level 9); the Awakening: `Arcana_Passive_Aspect_Fool_Awakening`, `_I`–`_III`, `_Awakened_I`–`_III`, `ASPECT_AWAKENED_FOOL(_I–_III)`, `ASPECT_PROGRESS_FOOL_I–III` (goals 3/5/8), `FOOL_ZEPHYR_FREE` (reused by Tier I) | 10, 20, 30 |
| **Removed** | Evasive Flow (+ `_5`, `_6`), `EVASIVE_FLOW`, `EVASIVE_FLOW_OPENING`; Thunderclap (+ `_6`), `THUNDERCLAP`, `Arcana_Passive_Thunderclap`; `Arcana_Passive_Momentum(_UI)`; `Arcana_Passive_EyeOfTheStorm(_UI)`; `Interrupt_Arcana_Aspect_FoolsLuck`; `Arcana_Passive_TwinkleToes_1`–`_20`; `Arcana_Passive_Weightless_5`–`_12` (regenerated as the four ranks); True Strike leaves the level-1 list | 30, 50 |
| **New** | Windswept status (+ the Open Path pair of P6); the Rush twin of Zephyr Strike (P2); Storm's second-Rush status and card; Gale / Storm / Hurricane rank passives; Aeolus' Bag (container, Boreas, Notus, Eurus; Hurricane two-wind variants); six Tailwind / Headwind statuses; the bag-open status; The Calm; Where the Winds Meet (+ its explosion); Weightless ranks 1 / 4 / 8 / 12 (generator) | 10, 20, 30, 40 |
| **Untouched** | `MAG_THUNDER_REVERBERATION` (a vanilla-named entry; only Thunderclap used it — checked in stage 4 that nothing else does), `GALE_DEFLECTION_USED_TECH`, `INTERRUPT_GALE_DEFLECT_MISSILES_HIT` (technical; names hidden in 40) | — |
| **Osiris** | `ARCANA_Aspect_Fool.txt` rewritten: marks from hits (hers; allies' at Tier II), the count of marks released (opening, sweeps, The Calm), the sweep at her turn start, X for the bag, The Calm's gusts, the capstone's no-wind check | 20 (`22_goal_fool.txt`) |
| **Lists and progression** | The map of `DESIGN.md` §9.1: new rows at 2, 4, 6, 8, 10; True Strike, Evasive Flow, Thunderclap out; Twinkle Toes rows 13–20 out (the 13–20 module, `21.07`, gives the Windborn nothing until it is designed) | 50 |

### Task 0.2 · the build's texts — `00_texts.md` (DRAFT)

Every name and description of the build, 5 subclass strings (A), the core rule (B), the bag and winds (C), The Calm and
the capstone (D), the Awakening (E), the kept cards (F). The Owner approves them as the Narrative gate
(`32.04/ARC-0026_Windborn.md`) before Tasks 0.3–0.6 write them into the patches.

## Acceptance criteria

- [ ] Every value traceable to `25` (`*_Unbound_*`)
- [ ] Probes P1–P8 answered, plan B recorded where used
- [ ] `61.02/Unbound/TC_ARC-0022.md` parts B and C pass in game
- [ ] Narrative and Design gates passed
