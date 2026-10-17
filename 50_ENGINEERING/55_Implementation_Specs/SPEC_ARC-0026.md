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

Written at the start of stage 0: the patches (`10_core.patch`, `20_bag_awakening.patch`, `30_ranks_cards.patch`,
`40_capstone_names.patch`), the structure script (`50_structure.pl` — lists and progression, the map of `DESIGN.md`
§9.1), the goal drafts (`ARCANA_Aspect_Fool.txt` rewritten), the Weightless generator table, and the build's texts for
`32.04`. Values come from `25` (`pending_build`) only.

## Acceptance criteria

- [ ] Every value traceable to `25` (`*_Unbound_*`)
- [ ] Probes P1–P8 answered, plan B recorded where used
- [ ] `61.02/Unbound/TC_ARC-0022.md` parts B and C pass in game
- [ ] Narrative and Design gates passed
