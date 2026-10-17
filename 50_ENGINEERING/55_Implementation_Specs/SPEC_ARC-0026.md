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
| P2 | Two created cards (Task 0.3): the strike stays `Target_Arcana_Created_ZephyrStrike` (Wind Riposte inherits it; `stats_add` needs the `Rush_` prefix for a Rush) and the new `Rush_Arcana_Created_ZephyrRush` targets only unmarked enemies; both cost the bonus action and come with each unarmed attack or card (TC A2) | Today's `ZEPHYR_STRIKE`; vanilla `Rush_SpringAttack` | One Rush with a melee-or-unmarked target condition (needs a new parent for Wind Riposte) |
| P3 | The turn-start hook for the sweep while the wind status is on her (TC A3) | The per-round reset of `ARCANA_Aspect_Fool.txt` (ARC-0007) | The wind status ticks on her turn (`TickType StartTurn`, `TickingWithSource`) and Osiris sweeps on that tick |
| P4 | A pull of every enemy to a point (TC A4) | Vanilla `Projectile_VacuumBulb` / `Projectile_MAG_PullingShout_Explosion` (`Force(-6, TargetToEntity)`, radius 9) | Two explosions (6 m every enemy, 9 m Windswept only) |
| P5 | Leap of Faith on the `Rush_ForceTunnel` animation with wind VFX (TC A5) | Vanilla `Rush_ForceTunnel` (`Shared/.../Spell_Rush.txt`, `SpellAnimation`) | Keep `Rush_SpringAttack` |
| P6 | **The Open Path:** a Windswept enemy makes no opportunity attack. Vanilla `Interrupt_AttackOfOpportunity` (`Shared/.../Interrupt.txt`) blocks it only for a fixed list of statuses; the Mobile feat's pair is one of them: `MOBILE_NO_AOO` on the enemy and `MOBILE_NO_AOO_SOURCE` on the mover (`Status_BOOST.txt`, applied in `Passive.txt`). Test: Windswept also applies `MOBILE_NO_AOO`, and the party carries `MOBILE_NO_AOO_SOURCE` while the Windborn is in combat | Vanilla Mobile feat | Windswept blocks the enemy's reactions altogether (`IsAbleToReact` false — wider: no reaction of any kind; `22.06` §4 prices it the same, 0.1A) |
| P7 | Marks from a hit by her, by an ally (Tier II) and from a failed save on each card | The hit hook of `ARCANA_Aspect_Fool.txt` (counts different enemies hit today); `ApplyStatus` in each card's `SpellSuccess` | Apply the mark from each card's Stats only, and from a passive on her unarmed attacks |
| P8 | The bag reads X (standing Windswept enemies) and caps it by rank | Osiris counting of standing enemies (the Fool goal's fallback, ARC-0007) | A status stack per mark, read by the bag's variants |
| P9 | A status functor `Force(3)` pushes the bearer away from the status source (Tier III `ARCANA_INTO_THE_STORM`, applied by the goal with her as the source) | Vanilla statuses with `Force` in their functors (search in `56` in stage 1) | The goal casts a Shove-like spell from her on each swept enemy |

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

### Task 0.3 · the core — `10_core.patch` + `lua/CardDB.patch` (done 2026-10-17, dry run clean: 9 strings, 5 new entries, 8 fields)

`ARCANA_WINDSWEPT` (2 ticks on her turn ends, `TickingWithSource`), the Open Path as an `EnableCondition` on the
mod copy of `Interrupt_AttackOfOpportunity` (P6 plan B, WB49), `Arcana_Passive_Windswept_Touch` (marks on damage
dealt, P7, WB49), The Open Road
(texts, True Strike out of its condition, grants both Zephyr statuses), `Rush_Arcana_Created_ZephyrRush` +
`ARCANA_ZEPHYR_RUSH`, the strike's Gale push, Gale Burst and Wind Blast marking on a failed save (Gale Burst's free
strike out). Left for later tasks: the two hidden passives join level 1 in `50_structure.pl` (0.7); the Rush's card
family line (`DB_ARCANA_CardFamily`) goes in the goal draft (0.4); Weaver Hand save spells don't mark (shortcut, P7).

### Task 0.4 · the bag, the winds, The Calm, the Awakening — `20_bag_awakening.patch` + `22_goal_fool.txt` + `lua/CardDB.patch` (done 2026-10-17; dry run with 10 clean: 24 new entries, 10 fields, 2 removals, 42 strings)

- **Stats:** the bag as a container (`Shout_Arcana_Created_AeolusBag` + Boreas / Notus / Eurus and the three Hurricane
  pairs, gated by the rank passives), The Calm (action, once per combat, only with `ARCANA_BAG_OPEN`), `ARCANA_BAG_READY`
  / `ARCANA_BAG_OPEN`, three wind auras (vanilla `AURA_OF_PROTECTION` pattern, 30 m) with six Tailwind / Headwind
  statuses, five `ARCANA_CALM_GUST_<R>` (1d8 per gust to level 6, 2d6 from 7 via vanilla `CharacterLevelGreaterThan`),
  `ARCANA_INTO_THE_STORM` (P9); the Awakening texts, the old tier bonuses emptied, `FOOL_ZEPHYR_FREE` now frees the
  Rush, the Aspect card is The Calm; `WANDERLUST_HIT_TECH` and Fool's Luck removed.
- **Goal** (`22_goal_fool.txt`, replaces `ARCANA_Aspect_Fool.txt`): marks mirrored in `DB_ARCANA_Windswept`, the bag
  (X counted, capped 2/3/4/5 by rank, released, winds for X of her turns — `TurnStarted` sweep, `TurnEnded` countdown),
  The Calm (gusts = turns left, release, the bag reopens), Tier I free Rush, Tier II allies' hits mark (`AttackedBy`),
  Tier III push on release, cleanup on `PROC_ARCANA_Aspect_Reset`. Every released mark is one
  `PROC_ARCANA_Aspect_Step(_, "FOOL")` (the Common's simple counter).
- **With the goal (stage 3):** `ARCANA_Aspect_Common.txt` — the three `DB_ARCANA_AspectTier("FOOL", …)` goals 3 / 4 / 5 →
  **3 / 5 / 8**. The family row of the Rush comes from `gen_upcast_variants.pl` (it writes `ARCANA_CardFamilies.txt`).
- **Needs from Task 0.5:** the passives `Arcana_Passive_AeolusBag` (level 2), `Arcana_Passive_Zephyr_Gale` / `_Storm` /
  `_Hurricane` (4 / 8 / 12).
- shortcut: The Calm's tooltip shows 1d8 per gust at every level (the 2d6 band is in the functor only); a second
  DescriptionParams if V-feedback asks.
- To check when compiling (stage 3): `_Ally != _Born` on CHARACTER in Osiris; if the compiler refuses it, drop the
  line (an ally's own hit on an enemy never involves her as attacker).

### Task 0.5 · ranks, Weightless, the cards — `30_ranks_cards.patch` + `lua/CardDB.patch` (done 2026-10-17; dry run of 10 + 20 + 30 clean: 72 strings, 40 new entries, 52 fields, 34 removals)

- **Ranks:** `Arcana_Passive_AeolusBag` (hidden, level 2), `Arcana_Passive_Zephyr_Gale` / `_Storm` / `_Hurricane`
  (visible, 4 / 8 / 12); Storm grants `ARCANA_STORM_RUSH` on a Rush hit, which unlocks the free 9 m
  `Rush_Arcana_Created_ZephyrRush_Storm` (it removes the status when cast).
- **Weightless:** four hand-written ranks (`Arcana_Passive_Weightless_1/4/8/12`; `_12` replaced in place); 12 Twinkle
  Toes and 4 old Weightless entries removed. No generator: four rows.
- **Cards:** Flow State 3 turns at every slot (variants set one by one; `FLOW_STATE_3`–`_6` removed); Wind Whispers
  applies `EVASIVE_FLOW_OPENING` (kept and reused, not removed — inventory corrected); Storm Fists only vs unmarked,
  3 turns, variants set; Untethered +2 AC in `FLY_UNTETHERED` (Eye of the Storm removed); Evasive Flow, Thunderclap,
  Momentum removed; Leap of Faith once per Short Rest, no slot, Force Tunnel animation (VFX still the inherited
  ones — P5 picks wind effects); Gale Deflection reaches an ally within 3 m (vanilla Protection interrupt pattern);
  Be the Leaf with Intelligence. `Interrupt_Arcana_Aspect_FoolsLuck` went in 20, not here.
- **Patch 10 corrected:** Gale Burst `_3`–`_6` carry the mark too (the generator keeps their own `SpellSuccess`).
- **Apply order:** each patch repeats the `@loca` keys it borrows; 30 alone needs `Rush_Arcana_Created_ZephyrRush`
  from 10 (applied in stage 2) — dry run them in order.
- **Texts:** `00_texts.md` §H — the rank passives' texts and two small wordings, for the Owner to check (gate addendum).

### Task 0.6 · the capstone and the name — `40_capstone_names.patch` (done 2026-10-17; dry run of 10–40 clean: 82 strings, 43 new entries, 53 fields, 34 removals)

`Target_Arcana_Created_WhereTheWindsMeet` (WB50: a Target on vanilla `Target_Shatter`, a point on the ground; 18 m; action; `OncePerRest`;
only without `ARCANA_BAG_OPEN`; DEX save halves the 4d8 Thunder; pull, Off Balance, mark on both outcomes) — one
9 m area takes every enemy; a Windswept one is pulled 9 m, any other 6 m (P4 as the Owner rebuilt it, WB49). The subclass strings A1–A5 say *The
Windborn*. `INTERRUPT_GALE_DEFLECT_MISSILES_HIT` hidden. CardDB: the capstone as a 0-Thread card.

### Task 0.7 · the level map — `50_structure.pl` (done 2026-10-17)

Lists and progression rows of table `d75cb44d…`, both sides (lsx + tbl), model `../Deceiver/arc0020/20_structure.pl`.
Nine lists: six reused (`Unboung Level 7` renamed, Level 11 now holds the capstone, Level 9 loses Evasive Flow, Level 1
loses True Strike), three new (Levels 2, 6, 10 — UUIDs MD5 v3 of `arcana/unbound/list/levelN`). 53 row edits per side
at the end state (Gale Deflection's two resources move from 3 to 6; Twinkle Toes leaves 1–20; Weightless 1 → 4 → 8 → 12;
ranks at 4, 8, 12; the bag marker at 2; the two hidden core passives at 1). `--stage N` applies stages 2..N
cumulatively — **stage 2** the core passives at 1, **3** the bag at 2, **4** everything else but the capstone list,
**5** the Level 11 list. Tested on a copy (`BG3_DATA`): each stage applies, a second run prints `changed:` empty; the
end-state self-check (no Twinkle Toes, no retired passive, four Weightless ranks, no True Strike) holds from stage 4.

**Stage 0 is complete.** Apply chain per stage (`SPEC_ARC-0020` chain): stage 2 = `10_core.patch` + `lua/CardDB.patch`
(stage-2 lines) + `50_structure.pl --apply --stage 2`; stage 3 = `20_bag_awakening.patch` + goal + Common rows + CardDB
stage 3 + `--stage 3`; stage 4 = `30_ranks_cards.patch` + `gen_upcast_variants --apply` + CardDB stage 4 + `--stage 4`;
stage 5 = `40_capstone_names.patch` + CardDB stage 5 + `--stage 5`. Stage 1 (probes P1–P9) comes first.

## Stage 1 — probes P1–P9 (`[fechado] ARC-0026`) — prepared 2026-10-17

**Files:** `_wip/Unbound/arc0026/05_probes.patch` (22 strings, 15 entries, all in the DEBUG sections; Spell_Rush has none,
so its two at the end; dry run clean) and `_wip/Unbound/arc0026/ARCANA_Probe_ARC0026.txt` (new goal, ASCII — CRLF when
copied: grants the 7 probe spells and the Probe Touch passive to every player on SavegameLoaded; the marks' DB mirror,
the ally-hit mark (`AttackedBy`, `!=`), the count with `IntegerMin` shown as Probe Count's turns, the sweep on
`TurnStarted`, a marker on `TurnEnded`). **Test:** `61.02/Unbound/GUIDE_ARC-0026.json`, ticket `QA-0004`, on the
**console edition** (SE off: the PC deck locks Util spells in combat).

**Apply:** the chain of `SPEC_ARC-0020.md` steps 1–3, 6–7, 9–13 (no generator or sort: no card added) — `sync_data`,
backup, `stats_add 05_probes.patch --apply`, `check_cards`, `stats_add --selftest`, copy the goal into
`Story/RawFiles/Goals/` (CRLF), counts, `sync_data`, commit + push; the Owner compiles the Story and plays `QA-0004`.

**Cleanup (first task of stage 2):** `@remove` every `PROBE_ARC0026_*` status / passive and `*_PROBE_*` spell, delete the
goal, and a one-off `RemoveSpell` / `RemovePassive` on SavegameLoaded (AddSpell persists in the save).

### Stage 1 fix — castable spells (2026-10-17, after QA-0004 P1)

**Symptom:** Probe: Mark showed in the hotbar but clicking it never entered targeting. **Root cause:** of the mod's 77
standalone Target spells, 76 carry `CastTextEvent` and 74 `SpellAnimation`; the only player-cast spells with neither
were the four standalone probes. The same gap was in the build: Aeolus' Bag (and its six winds by `using`), The Calm,
and the capstone (its parent, the grenade `Projectile_VacuumBulb`, has no `CastTextEvent`). Probe: Rush passed in game
because `Rush_SpringAttack` gives both. **Fix:** each spell copies the cast block of a working one — Target from
`Target_Arcana_Card_Spell_Command`, Shout from `Shout_Arcana_Card_Spell_FlowState` (fields it already had are kept) —
and the two projectiles inherit vanilla `Projectile_Fireball` (a cast point projectile) instead of the grenade.
**Guard:** new `82_Automation/stats/check_castable.pl <patch…>` resolves each new spell's `using` chain (patch, mod,
vanilla) and fails when `SpellAnimation` or `CastTextEvent` is missing (explosions named `*Inner` / `*_Explosion` are
exempt). It is calibrated on the game: Probe: Rush and Probe: Leap pass, the broken probes fail. **It joins the apply
chain before every `stats_add --apply`.** A repeated-field scan of the patches is run with it (it caught a duplicate
`SpellSchool` the fix had added to the capstone). VFX are the templates' for now (Fireball's fire on the capstone,
Command's on the Mark): the wind effects are picked with P5.

### Stage 1 results (QA-0004, 2026-10-17) and the P8 fix

**Pass:** P1, P2, P4, P5, P6, P7, P9. **Fail:** P8 (Probe Count showed no turns); P3 waits on P8. The Owner changed the
game by hand while testing (captured in `51`; `05_probes.patch` is **never reapplied** from now on, or it would undo
them): P4 one 9 m area, marked enemies pulled 9 m and the others 6 m; P6 a mod copy of vanilla
`Interrupt_AttackOfOpportunity` with `not HasStatus('PROBE_ARC0026_MARK')` in `EnableCondition` (the Mobile pair
failed), the mark's `MOBILE_NO_AOO` functors and `PROBE_ARC0026_PATH` removed; P7 `OnDamage` with
`TotalDamageDoneGreaterThan(0)` (`OnAttack` caught only weapon attacks); the probe Rush costs nothing. All in WB49.
**P8 root cause (from the code; no osirislog, it was played in game):** Probe Count had `TickType EndTurn` and no
`FreezeDuration`. The mod's working variable-duration status, `RESONANT_OVERLOAD` (set from Osiris with
`IntegerProduct` and `IntegerToReal`), is frozen and has no tick type, so the number shown is the one the goal set.
**Fix:** `06_probe_count.patch` (Probe Count frozen, texts) and the probe goal shows exactly X, no cap (Owner). The
build keeps WB13's cap by rank (asked and kept, 2026-10-17); the build's bag is not hit by the P8 bug: `22_goal_fool.txt`
applies `ARCANA_BAG_OPEN` with -1 and counts the turns in a DB (to show turns left on it, use the same frozen pattern).
**Build carried over (WB49):** `10_core.patch` Open Path = `@set Interrupt_AttackOfOpportunity EnableCondition` on
`ARCANA_WINDSWEPT` (no aura, no `Arcana_Passive_OpenPath`, row dropped from `50_structure.pl`); Windswept Touch and
Storm's second Rush on `OnDamage`; `40_capstone_names.patch` one area, no inner explosion, no once-only status.
Apply: `[fechado] ARC-0026` → `06_probe_count.patch --apply`, the goal copied as CRLF, Story recompiled, P8 then P3.
**Stage 1 complete (2026-10-17):** after the fix P8 and P3 pass, so all nine probes pass. While testing, the Owner added two
probes (`Shout_` / `Target_Arcana_Util_PROBE_WhereTheWindsMeet`); the stage 2 cleanup removes them with the other
`*_PROBE_*` spells. The capstone is now a ground Target (WB50, `40_capstone_names.patch`).

## Stage 2 — applied 2026-10-17

`07_probe_cleanup.patch` (14 removals) → `10_core.patch` → CardDB.lua stage 2 lines → `50_structure.pl --apply --stage 2`.
The probe goal is now a cleanup goal (delete it at stage 6). Tests: `GUIDE_ARC-0026.json` session S2.
