# The Deceiver: The Veil — implementation in stages

Spec: `Design/specs/2026-10-06-deceiver-veil-design.md` (decisions D1–D17). Replaces the 11-task plan
(archived in `_archive/plans/`). Prepared files: `Design/work/deceiver/` (patches, goals, rulebook fragments).

## How each stage runs (cheap by design)

- **One `[fechado]` message = one stage.** Claude applies in the foreground: backup → `stats_add.pl` patch → goals
  → structure edits → `check_cards.pl` + `stats_add.pl --selftest` → sync, commit, push → patch notes for what changed.
- **No subagents, no review rounds.** Dry runs are read as counts (`grep -c`), not full output. Reports ≤ 10 lines.
- **Osiris:** after a stage that touches goals, the user compiles in the Story Editor; the next message Claude
  reads only `grep -i "error\|warning" Story/log.txt`.
- **In-game checks** are one short list per stage (below), run by the user whenever convenient.

## Done

| What | State |
|---|---|
| Doubt, Deluded, `DOUBT_ADD_TECH` (Task 1) | stats + goal in the game |
| Doubles: Mirror Image summons, The Veil, AC layers, Rulebook rule (Task 2) | stats + goal in the game |
| Doubles' spells: Shatter, Mirror: Sigil/Chains (1d4), Unveil (Task 3) | stats in the game |
| Texts: class, panel, tag (High Priestess voice) | in the game (2026-10-07) |
| Withdraw goals + the Doubles goal's Task 4 region (Double goes Home) | live; Story compiled 2026-10-07, 0 errors, 0 warnings expected after the fix |
| **Stages 2, 3 and 5 (2026-10-07):** Mirror damage `_SlotN` (35), Distortion/Withdraw (40), kit (50), lists/progression/resources (`60_structure.pl`), upcasts (25, 55), passive texts (65), CardDB + tests (133 green); goals Doubles (Task 5 region + tiers) and Sigil live | applied; compile pending |
| Fix after the in-game test: the Double's spells come from 7 shapeshift rules (`75_double_rules.pl`, the goal picks one by tier) because Transform hides AddSpell; Doubt passive at level 1 (`70_doubt_passive.patch`) | applied; compile pending |
| **Stage 4 (2026-10-07):** Awakening High Priestess (`80_awakening.patch`, goal rewritten, goals 4/7/10), Two Pillars on Deluded, Ready: Which One? (Tier III, resource `ArcanaReactWhichOne`), The Veil Lifts; Faceless `_EX` goal and the old MirrorImage rule deleted; CardDB + tests (133) | applied; compile pending |
| **Stage 6 (2026-10-07):** 42 orphan strings removed in all 15 languages (`90_loca_orphans.pl`), GLOSSARY (15 rows out, 17 PENDING in), Context and the wiki artifact updated | done; only the in-game tests remain |

## Stage 1 — compile what is in (user, no `[fechado]` needed)

The user compiles in the Story Editor; Claude reads the log and fixes errors in the next `[fechado]`.
In game: D1–D4 (`deceiver/10_doubt.md`), V1–V14 (`20_doubles.md`, `30_double_spells.md`).

## Stage 2 — Doubles' damage, Distortion, kit `[fechado]`

Goals: only the Doubles goal's **Task 5 region** (Grand Deception) and `ARCANA_Status_Sigil.txt` are still to copy; the Withdraw goals and the Task 4 region are live.

| Step | File |
|---|---|
| Mirror spells deal half her spell (D17): `_3`…`_6` variants, `DealDamage((Nd6)/2,Force)`; Osiris gives the variant for her level | new `35_double_damage.patch` + region in `goals/ARCANA_Deceiver_Doubles.txt` |
| Distortion leaves a Double; Withdraw swaps (Task 4) | `40_distortion.patch`, `goals/ARCANA_Spell_Withdraw.txt`, `ARCANA_Spell_MimicWithdraw.txt` |
| Kit (Task 5): Sigil detonation + Malicious Whispers give Doubt (2 on a marked target, D15); Veiled Prison; Marionette vs Doubt; Grand Deception; Friends level 1; removals (Mental Prison, Hypnotic Gaze, Terrify, Hostile Takeover, Instinctive Charm, Hollow Image, `NEMESIS*`, `ArcanaBeloved`, the two reaction resources) | `50_kit.patch`, `goals/ARCANA_Status_Sigil.txt` |

Then the user compiles. In game: W1–W4, K1–K6.

## Stage 3 — lists, progression, upcasts `[fechado]`

| Step | Notes |
|---|---|
| Lists Deceiver Level 1…13 and progression rows (spec §4.1) | small structure script, lsx + tbl; level 13 list goes |
| Passives: The Veil (1), Two Truths (5), VeilCap4 (7), Unveil (9), VeilCap5 (12); drop the level-5 InstinctiveCharm boost | same script |
| Action resources `ArcanaReactHollowImage`, `ArcanaReactInstinctiveCharm` out (both sides) | same script |
| `gen_upcast_variants.pl --apply` → `25_mirror_image_upcast.patch` → `55_friends_upcast.patch` → `sort_stats.pl --apply` | order matters |
| `IsArcanaCantrip.khn`: drop the removed spell's line | 1 line |

No Osiris. In game: the level table in character creation and at level-up.

## Stage 4 — Awakening and Faceless `[fechado]`

| Step | File |
|---|---|
| 2 · The High Priestess: goal = Doubt applied (4 / 7 / 10); Veiled, Two Pillars, Aspect of Doubt (Which One?); The Veil Lifts replaces Heartbreak; internal `Empress` ids stay | `60_awakening.patch`, `ARCANA_Aspect_Empress.txt` |
| Faceless: Copy, one clean path; delete `ARCANA_Spell_FacelessCopy_EX.txt`; delete the Rulebook's old `MirrorImage` rule | goal + `Shapeshift/Rulebook.lsx` (+ Toolkit) |

Then the user compiles. In game: A1–A5, F1–F3.

## Stage 5 — PC deck layer `[fechado]` (the Lua lives in `Mods/`)

`CardDB.lua`: remove the deleted cards, Unique on Veiled Prison / Marionette / Grand Deception, Aspect card
`Shout_Arcana_Created_Aspect_VeilLifts`; fix the 2 tests that name removed ids; suite green (baseline 134).

## Stage 6 — wrap-up (docs only, any message)

Orphan strings out of `english.xml` (needs `[fechado]`), glossary, `Context/subclasses/deceiver.md` and the
systems/comparison tables, patch notes, one in-game test list for everything left, the wiki artifact's status pills.

## Corrections that still apply (from the archived Task 0 inventory)

- The Double's template is the mod's own (`8807d230…`, stats `Clone_1`): never edit the binary; set spells in Osiris.
- Doubles register in `DB_ARCANA_MirrorImageOf` so the Sigil goal works unchanged; Mirrored Spell ignores spells cast by Doubles.
- `Arcana_Passive_UnlockFriends` is never granted: the level-1 list must give Friends explicitly.
- `ARCANA_CardFamilies.txt` is generated: rerun `gen_upcast_variants.pl` after any card change.
- `aspect_structure.pl` is archived on purpose: rerunning it would undo the rework.
