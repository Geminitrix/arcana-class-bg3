---
id: SPEC_ARC-0025
ticket: ARC-0025
status: in_progress
implementation: claude
author: Mod Engineer
updated: 2026-10-17
---

# SPEC_ARC-0025 · Starchild refining build — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans. **One `[fechado] ARC-0025` message = one
> stage**; stage 0 writes only project files. Lean execution: no subagents, dry runs read as counts, reports ≤ 10 lines.

**Intent:** the game plays the Starchild as `21.04/Starchild/DESIGN.md` describes it (SC0–SC32), in both editions.

**Design:** `21.04/Starchild/DESIGN.md` · **Decisions:** `21.04/Starchild/DECISIONS.md` · **Numbers:** `25`
(`*_Starchild_*.yaml`, blocks `pending_build`) · **Prepared files:** `55/_wip/Starchild/arc0025/` · **Tests:**
`61.02/Starchild/`.

## Global constraints

The constraints and the apply chain of `SPEC_ARC-0020.md` apply unchanged (stats through `stats_add.pl` patches,
structure scripts with dry runs, English loca only, internal ids keep their names, lines ≤ 3900, no repeated field,
goals CRLF/ASCII and compiled by the Owner, every function anchored, probes before uncertain pieces).

## Stages (detailed tasks are written in stage 0, one stage at a time)

| Stage | What | Decisions | Writes the game? | Gate |
|---|---|---|---|---|
| **0** | Sizes (rounds R1–R4); patches, scripts and goal drafts | all | No | Owner approves each round; dry runs clean |
| **1** | Probes P1–P6 on a test entry | — | Yes (throwaway) | Each probe answered; plan B chosen where needed |
| **2** | The Hymns and the core: Sing a Hymn, Unsung, Hymn statuses, containers for Comet and Outpouring, Afterglow, Dusk (Osiris) | SC1–SC10, SC21–SC24, SC32 | Yes (+ goal) | A level-1 Starchild sings, answers Dusk |
| **3** | Levels 2–6: Lantern, Hesperus, Cleansing Rain, Rekindle, Halo, Guiding Light; Nightfall, Dawn, Outpouring II | SC10, SC20, SC25, SC27, SC28 | Yes (+ goal) | Nightfall replaces Dusk; Downed clears it |
| **4** | The Awakening (answered marks, Tier I Great Star + Undying Hope, Tier II conditions, first-heal gate) and Elpis' Jar | SC13, SC16–SC19 | Yes (+ goals) | Count Dusk 1 / Nightfall 2; one empowered heal per round |
| **5** | Levels 9–12: Tether, Stillness, Long Twilight, Flare, Dawnbringer, Light in the Dark, Eclipse; removals; the map | SC12, SC26, SC29, SC30 | Yes (+ goals, lsx) | Level-up shows `DESIGN.md` §9.1 |
| **6** | Close: `25`, `05.02`, catalogs, docs | — | No | `check_propagation` OK |

### Probes (stage 1)

| P# | Question | Anchor | Plan B |
|---|---|---|---|
| P1 | A container child greyed out by `HasStatus('<HYMN>', context.Source)` | Hemoplague container (mod) | One spell with `IF(HasStatus(...))` branches and a three-line tooltip |
| P2 | Osiris sees a downward crossing of ½ and ¼ (HitpointsChanged) | `ARCANA_Aspect_Star.txt` | A status `TickFunctors` check at turn start |
| P3 | The first-heal gate: duration 1 with `TickType StartTurn` lasts until her next turn | Wind Whispers (mod, 2026-09-30) | Osiris clears the gate on her TurnStarted |
| P4 | `Force(-3, OriginToEntity, …)` pulls an ally | Thorn Whip (vanilla) | Teleport the ally next to her |
| P5 | Lantern off in combat (status removed on combat start) | `RemoveEvents OnCombatEnded` (mod) | Boosts with an out-of-combat condition |
| P6 | Undying Hope leaves the ally at 1 HP and Osiris can apply Nightfall right after | current Undying Hope (Death Ward pattern) | Apply Nightfall from the status's `OnApplyFunctors` |

---

## Stage 0 — sizes (balance pass, `game-balance`)

Rounds, each approved by the Owner before the next: **R1** the heal core (Outpouring, the marks) · **R2** the
Awakening and the conditions · **R3** the cards · **R4** utilities (Lantern, Hesperus charges). Currency and
parameters: `22.06` §1–§2, §7 (1 HP healed in combat = 0.6; ×0.8 on a hurt ally, ×0.5 on a healthy one; healing over
time ×0.7). Vanilla anchors (Shared `Spell_Target.txt`): Healing Word `1d4+SpellCastingAbilityModifier` (+1d4 per
level), Cure Wounds `1d8+SpellCastingAbilityModifier` (+1d8 per level), Mass Healing Word `1d4+modifier` each.

### R1 · the heal core — proposal 2026-10-17

N = the slot level; mod = her spellcasting modifier.

| Knob | Proposal | Average at slot 3, mod +4 |
|---|---|---|
| Lodestar Balm (Stars) | N × 1d10 + mod | 20.5 on the target |
| Noonday Pour (Sun) | target N × 1d6 + mod; allies within ‹3› m N × 1d4; enemies next to the target 1d4 Fire (2d4 from level 7) | 14.5 + 7.5 per ally nearby |
| Rising Tide (Moon) | now N × 1d4 + mod; then N × 1d4 at the start of each of the next 2 turns; attackers of the ally −3 m movement, 1 turn | 11.5 now + 15 later |
| Dusk answer | + N × 1d4 | +7.5 |
| Dawn answer (Nightfall) | + N × 1d8, and the Hymn's part doubled (Sun spill N × 2d4; Moon pulses N × 2d4) | +13.5 |
| HP cost / minimum | 10% of her max HP unless Afterglow / not at ≤ 11% (unchanged) | — |
| Afterglow | 2 turns (+1 next to a marked ally); regain mod HP at each turn end (unchanged: WIS mod today → spellcasting mod) | — |

Value per cast (one ally nearby): Stars 9.8 · Sun 10.8 · Moon 10.8 points — within 10% (SC4). Stars has the largest
single heal (20.5 vs 14.5 vs 11.5), Sun the largest total with allies close, Moon the largest total over time.
Waiting check (B3), level 5: an ally at 40% of ~44 HP has ~18 HP; one enemy round on them is ~16 (`22.06`: 2A) — about
an even chance of being Downed; the payoff of waiting for Dawn over Dusk is +6 HP. Waiting stays a gamble, not the
default.

**Finding for the Owner:** with one ally nearby the Sun's total (22) passes the Stars' single heal (20.5); with two it
is 29.5. The SC6 brake as written ("the Sun total over several allies must not beat the Stars on one ally") would force
the Sun's heals down to ~1d4 per level and break SC4.
