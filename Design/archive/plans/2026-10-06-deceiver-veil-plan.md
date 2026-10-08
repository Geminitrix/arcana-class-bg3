# The Deceiver: The Veil — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** rework the Deceiver into *The Veil* — II · The High Priestess, Aspect of Doubt — with Doubles on the field and Doubt on enemies, keeping LeBlanc's five core abilities.

**Architecture:** the engine lives in two new Osiris goals (Doubles, Doubt) plus Stats entries written as `stats_add.pl` patches (game `.txt` + Toolkit `.stats` + `english.xml`). Lists and progression change through a structure script (lsx + tbl, like `aspect_structure.pl`). The deck layer (PC only) changes only in `CardDB.lua` and its tests. The Awakening plumbing keeps its internal *Empress* ids; only text changes.

**Tech Stack:** BG3 Stats, Osiris (Story Editor compile), LSX/TBL, Lua 5.4 (offline tests), Perl tools.

**Spec:** `Design/Rework/specs/2026-10-06-deceiver-veil-design.md`

**How code is specified here:** unlike the Heartweaver engine (a pure generator, fully written in its plan), most of this work edits live Osiris goals and stats that must be read before they are changed. Each task therefore names the exact files, ids, behaviour and acceptance checks; the implementer writes the code against the current files and the reviewer checks it against the spec. Osiris cannot run offline: its test is the Story Editor compile log, then the in-game guide (Task 11).

## Global Constraints

- **Console edition first:** nothing in the engine may depend on the Script Extender. Lua touches only the deck (CardDB).
- **English everywhere** in the project; only the 15 other languages wait for the localisation round.
- Mod files are written only on a `[fechado]` message, and **in the foreground** in that turn (memory: background work escapes the window).
- **Osiris cycle:** goals are edited on `[fechado]` → the user opens the Toolkit and compiles → the next message reads `Story\log.txt` (`N error(s), M warning(s)`); 0 errors required, `DB_ARCANA_*` "defined but never checked" warnings are defects. Read `Docs/OSIRIS.md` before any goal edit; signatures from `story_header.div`.
- Status types matter: non-BOOST statuses go in `Status_<TYPE>.txt`, `StatusType` before `using`, keep the parent's `OnApplyFunctors`.
- Never a custom Khonsu function in `BoostConditions`; only native ones (e.g. `HasPassive`, `HasStatus`).
- Card mark: `not HasPassive('ARCANA_IS_CARD', context.Source)` in `TargetConditions`. Doubles' spells are `_Deceiver_Clone_`/`_Deceiver_Double_` spells, never cards.
- Every stats change goes through `stats_add.pl` patches in `Design/Rework/deceiver/`; then `gen_upcast_variants.pl --apply`, `sort_stats.pl --apply`, `check_cards.pl`, `stats_add.pl --selftest`.
- Internal Awakening ids keep *Empress* (spec D12).
- End of every applied task: `bash tools/sync-mod.sh`, commit and push (`Geminitrix/bg3-arcana-deckbuilder`), Lua repo commit when Lua changed (identity victr / lumox.gemini@gmail.com), update `Context/`.
- Backups in `Data\Backup\deceiver_veil_<date>\` before the first write of each `[fechado]` session.
- **Patch notes record what HAS changed, never what will:** after a task is applied in the game, add its player-facing changes to `Docs/PATCH_NOTES.md` (Deceiver block, in that file's own format: `**REWORKED**` / `**NEW**` / `**REMOVED**`, old ⇒ new). Nothing goes there for a task that is only prepared.

## File map

| File | Role |
|---|---|
| `Design/Rework/deceiver/10_doubt.patch` … `60_text.patch` (new) | Stats + strings, one patch per task |
| `Design/Rework/tools/deceiver_veil_structure.pl` (new) | Lists, progression rows, passives per level (lsx + tbl) |
| `Mods/…/Story/RawFiles/Goals/ARCANA_Deceiver_Doubt.txt` (new) | Doubt counter, Deluded, Awakening steps |
| `…/Goals/ARCANA_Deceiver_Doubles.txt` (new) | Doubles: summon, transform, kit by level, cap, AC layers, Doubt on destruction, cleanup |
| `…/Goals/ARCANA_Spell_MirrorImage.txt` (deleted) | Replaced by `ARCANA_Deceiver_Doubles.txt` |
| `…/Goals/ARCANA_Spell_Withdraw.txt`, `ARCANA_Spell_MimicWithdraw.txt`, `ARCANA_Spell_MirrorWithdraw.txt` | Double at the origin, swap |
| `…/Goals/ARCANA_Status_Sigil.txt` | Detonation adds Doubt |
| `…/Goals/ARCANA_Aspect_Empress.txt` | Doubt objective, tiers, The Veil Lifts |
| `…/Goals/ARCANA_Spell_FacelessCopy.txt` / `_EX.txt` | Cleaner copy / deleted |
| `Mods/…/ScriptExtender/Lua/Server/Cards/CardDB.lua` + `Lua/Tests/*` | Unique flags, removed cards, Aspect card |
| `Context/subclasses/deceiver.md`, `01-identity-and-lore.md`, `02-systems.md`, `04-subclass-comparison.md`, `07-open-questions.md` | Docs |
| `Design/Rework/plans/2026-10-06-deceiver-veil-test.md` (new) | In-game test guide |

Short paths: `$G` game Data, `$M` the mod folder name, `$P` the project, `$T` = `$P/Design/Rework/tools`, `$GOALS` = `$G/Mods/$M/Story/RawFiles/Goals`.

## Corrections from the Task 0 inventory (`Design/Rework/deceiver/00_inventory.md`, 2026-10-06)

These override the task text below where they conflict.

1. **The Double's template is the mod's own** (`RootTemplates/8807d230-….lsf`, `ARCANA_CHAR_CreateClone_1`, stats `Clone_1`), not vanilla. Its AI skill list names the Mirror spells this plan deletes. Do **not** edit the binary template: keep using it, set the Double's spells at runtime in Osiris (as the current goal already does with `RemoveSpell`/`AddSpell`), and give the Double fixed stats through the `Clone_1` character entry (`Character.txt`, through a patch).
2. **"Rulebook" = `Public/$M/Shapeshift/Rulebook.lsx`.** Its `MirrorImage` rule copies her default boosts and merges her passives (risk R1 confirmed). Task 2 adds a new rule (`DoubleOfTheVeil`) that copies **appearance only**, and Task 8 reviews the `FacelessCopy` rule there.
3. **More to remove (Task 5):** the `Interrupt_Arcana_Aspect_Beloved` interrupt and its `ArcanaBeloved` resource (Tier III now gives *Which One?*), the `ArcanaReactHollowImage` and `ArcanaReactInstinctiveCharm` resources (and the level-5 progression boost that grants one). `SIGIL`'s `RemoveConditions` names `MIRROR_ETHEREAL_CHAINS`: edit `SIGIL` in the same patch that removes it.
4. **`aspect_structure.pl` would undo the rework** (it re-grants `Target_Arcana_Util_Friends_EX` and re-creates `ArcanaBeloved`): update it in Task 6 before anything reruns it.
5. **Cross-goal coupling:** `ARCANA_Status_Sigil` lets a clone detonate marks through `DB_ARCANA_MirrorImageOf` — Doubles register in that same DB (keeps the Sigil goal unchanged). `ARCANA_Passive_MirroredSpell` must ignore spells cast by Doubles.
6. **Friends:** `Arcana_Passive_UnlockFriends` is never granted by a progression (only removed at level 20). Task 6 must grant the level-1 Friends explicitly (list "Deceiver Level 1").
7. `ARCANA_CardFamilies.txt` is generated by `gen_upcast_variants.pl`; rerun it after any card change.

---

### Task 0: Preflight (read only)

- [ ] Run the Lua suite and note the baseline: `"$LUAEXE" "$P/tools/run_tests.lua" "$G/Mods/$M/ScriptExtender/Lua"`.
- [ ] `perl "$T/check_cards.pl"` (baseline: exit 0 since the Heartweaver engine), `perl "$T/stats_add.pl" --selftest`.
- [ ] Read `Docs/OSIRIS.md`, the six Deceiver goals and `Context/subclasses/deceiver.md`; list every id this plan removes and grep the whole mod (Stats, Lists, Progressions, Goals, Lua, loca) for each, so later tasks know every reference. Write the list into the task report.
- [ ] Confirm the vanilla ids the spec relies on: `INVOKE_DUPLICITY` (shimmer effect), template `8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8`, `CONFUSION` (type and boosts), `SG_Possessed`/`SG_Fleeing`/`SG_Mad`/`SG_Charmed` names; Osiris `UseSpell`, `TeleportTo`, `Transform`, `AttackedBy`, `Died` signatures.

### Task 1: Doubt — statuses and counter

**Files:** `Design/Rework/deceiver/10_doubt.patch`, `$GOALS/ARCANA_Deceiver_Doubt.txt`.

- [ ] Stats: `DOUBT_1`, `DOUBT_2`, `DOUBT_3` (BOOST, StackId `DOUBT`, 3 turns, `RollBonus(SavingThrow,-N,Wisdom)` and `IF(HasPassive('Arcana_Passive_TheVeil',context.Target) or HasPassive('Arcana_Passive_DoubleOfTheVeil',context.Target)):RollBonus(Attack,-N)`); `DELUDED` (CONFUSION behaviour, 1 turn, its correct status type and file per Task 0); `DOUBT_ADD_TECH` (hidden, duration 0) — the single entry point every source applies.
- [ ] Osiris: on `DOUBT_ADD_TECH` applied → raise the stack (none→1→2→3); on reaching 3 → apply `DELUDED`, remove the stacks; each raise adds one Awakening step for the source's owner (Task 9 consumes the step DB).
- [ ] `[DEBUG] Add Doubt` target spell on the DEBUG list (applies `DOUBT_ADD_TECH`), so Tasks 1–3 can be tested before the cards exist. **Its list entry ("Arcana Deck DEBUG", lsx + tbl) is added in Task 1's apply step**, not in Task 6.
- [ ] Acceptance: dry run clean; compile log 0 errors; guide rows D1–D4 (Task 11).

### Task 2: Doubles — summon, form, cap, layers

**Files:** `20_doubles.patch`, `$GOALS/ARCANA_Deceiver_Doubles.txt` (new), delete `$GOALS/ARCANA_Spell_MirrorImage.txt`.

- [ ] Stats: `Target_Arcana_Card_Spell_MirrorImage` becomes level 1, summons one Double (`Summon(8807d230-…,-1,,,…,DOUBLE_OF_THE_VEIL_TECH)`), upcast 2 Doubles at slot 3+, 3 at slot 5+ (via the variants' `SpellProperties`); passive `Arcana_Passive_DoubleOfTheVeil` on the Double (immunities, no weapon actions); statuses `VEIL_LAYER_1`…`_5` (`AC(N)`, one StackId); passive `Arcana_Passive_TheVeil` (text + cap 3); the Double's fixed stats (1 HP, AC 12) per R1.
- [ ] Osiris: on the tech status → `Transform` to her look (no `SetLevel`, no `CopyCharacterEquipment` unless Task 0 shows the look needs it, then strip weapon actions), apply the Invoke Duplicity effect, give the level kit (Shatter always; Mirror spells if she has *Two Truths*; Unveil if *Unveil*), register in `DB_ARCANA_Double(_Double, _Owner, _Order)`; enforce the cap (3/4/5 by her passives) by destroying the oldest; keep `VEIL_LAYER_N` equal to the count; on a Double's death with an enemy killer → `DOUBT_ADD_TECH` on that enemy; clear all Doubles at combat end, Long Rest and her death.
- [ ] Acceptance: compile 0 errors; guide rows V1–V8.

### Task 3: Doubles' spells

**Files:** `30_double_spells.patch`, `ARCANA_Deceiver_Doubles.txt` (kit by level).

- [ ] `Shout_Deceiver_Double_Shatter` (3 m, 1d6 Psychic fixed, applies `DOUBT_ADD_TECH`, kills the caster), `Projectile_Deceiver_Double_MirrorSigil` (1d4 Force, lays her `SIGIL` through the existing Sigil path), `Target_Deceiver_Double_MirrorChains` (1d4 Force, WIS save or Restrained 1 turn), `Target_Deceiver_Double_Unveil` (swap with her, once per round across all Doubles via a round-scoped tech status on her). All `IsSpell` without card marks; no `SpellSlotsGroup` costs (ActionPoint only).
- [ ] Remove the clone's old Mirror spells that no longer exist in the kit (`Target_Deceiver_Clone_MirrorDistortion`, `Projectile_Deceiver_Clone_MirrorSigilofMalice`, `Target_Deceiver_Clone_MirrorEtherealChains`, `Shout_Deceiver_Clone_MirrorWithdraw`, `Projectile_Arcana_MirrorDistortion_Explosion`) after grepping every reference.
- [ ] Acceptance: guide rows V9–V14.

### Task 4: Distortion's Double and Withdraw's swap

**Files:** `40_distortion.patch` (descriptions), `ARCANA_Spell_Withdraw.txt` (+ `MimicWithdraw`, `MirrorWithdraw` if still referenced).

- [ ] On Distortion cast: summon a Double at her origin (through the same tech status, so it counts toward the cap). Withdraw: swap with that Double (`TeleportTo` both ways or the R6 fallback); no Double → Withdraw ends.
- [ ] Acceptance: guide rows W1–W4.

### Task 5: Kit changes

**Files:** `50_kit.patch`, `ARCANA_Status_Sigil.txt`.

- [ ] Sigil detonation also applies `DOUBT_ADD_TECH`; Malicious Whispers on a marked target too.
- [ ] New `Target_Arcana_Card_Spell_VeiledPrison` (spec §4.2; Unique, Short Rest, Concentration); delete `Target_Arcana_Card_Spell_MentalPrison` and `Target_Arcana_Card_Spell_HypnoticGaze` (+ variants, statuses only they use).
- [ ] Marionette: Disadvantage on the save with 2+ Doubt (replacing the Charmed Advantage).
- [ ] New `Shout_Arcana_Card_Spell_GrandDeception` (spec §4.2; Unique, Long Rest); delete `Target_Arcana_Card_Spell_HostileTakeover` and `Target_Arcana_Card_Spell_Terrify`.
- [ ] Friends (spec D14): `Target_Arcana_Util_Friends` becomes a level-1 spell paid with a slot; after `gen_upcast_variants.pl` makes `_2`…`_6` (Task 6), the `_6` variant gets the Faux Amis fields from `Target_Arcana_Util_Friends_EX` (no Concentration, unnoticed, difficulty-proof); then `Friends_EX` and its level-13 grant are deleted. Check `Arcana_Passive_UnlockFriends` still grants the base spell.
- [ ] Delete Ready: Instinctive Charm and Ready: Hollow Image: `Shout_Arcana_Card_Passive_InstinctiveCharm`, `_HollowImage`, `Arcana_Passive_InstinctiveCharm`, `_HollowImage`, `Interrupt_Arcana_Reaction_InstinctiveCharm`, `_HollowImage`, `Target_Arcana_Reaction_InstinctiveCharm`; the `NEMESIS*` leftovers. Keep `MirroredCharm` (Mirrored Self).
- [ ] Acceptance: `check_cards.pl` exit 0; grep shows no reference to any removed id.

### Task 6: Lists, progression and passives

**Files:** `$T/deceiver_veil_structure.pl` (new, dry run by default, `--apply`), lists `Deceiver Level 1…13`, the Deceiver progression rows.

- [ ] Lists per spec §4.1 (Mirror Image to level 1; Veiled Prison at 3; Distortion at 5; Mimic at 7; Marionette at 9; Grand Deception at 11; Mirrored Self/Spell at 12; level 13 loses Faux Amis). Passives: The Veil (1), Two Truths (5), Unveil (9); cap passives at 7 and 12 (`Arcana_Passive_VeilCap4`, `_VeilCap5`, hidden, read by Osiris).
- [ ] Right after `gen_upcast_variants.pl --apply`, apply `Design/Rework/deceiver/25_mirror_image_upcast.patch` (Mirror Image _3/_4 summon 2 Doubles, _5/_6 summon 3; prepared in Task 2).
- [ ] Then `gen_upcast_variants.pl --apply` (Mirror Image now level 1; Veiled Prison and Grand Deception new), `sort_stats.pl --apply`, `check_cards.pl`, `stats_add.pl --selftest`.
- [ ] Acceptance: `Context/tools/dump_progression.pl` shows the new table; lsx and tbl agree.

### Task 7: Deck layer (PC edition)

**Files:** `CardDB.lua`, `Lua/Tests/*`.

- [ ] Remove the deleted cards; Unique on Veiled Prison, Marionette, Grand Deception; Distortion's `conjures` unchanged (Withdraw, Mimic: Distortion); the Aspect card id (Task 9).
- [ ] TDD: add failing tests (removed ids absent, Unique flags, Aspect card conjured by the Awakening status), then make them pass; full suite green against the Task 0 baseline.

### Task 8: Faceless: Copy

**Files:** `ARCANA_Spell_FacelessCopy.txt`, delete `ARCANA_Spell_FacelessCopy_EX.txt`.

- [ ] Re-read both goals; keep one clean path (apply look, cancel, out-of-combat only); remove dead `_EX` rules and their DBs; apply what the user means by "Rulebook" (open question, spec §10) once answered.
- [ ] Acceptance: compile 0 errors, no orphan DB warnings; guide rows F1–F3.

### Task 9: Aspect Awakening — 2 · The High Priestess

**Files:** `60_awakening.patch`, `ARCANA_Aspect_Empress.txt`.

- [ ] Objective: Doubt steps (from Task 1's DB) instead of Sigil detonations; goals 4 / 7 / 10.
- [ ] Tier passives' text and effects: Veiled, Two Pillars, Aspect of Doubt (spec §5), keeping the internal ids.
- [ ] Aspect card `Shout_Arcana_Created_Aspect_VeilLifts` replaces `Shout_Arcana_Created_Aspect_Heartbreak` (status conjures, CardDB, Osiris).
- [ ] Acceptance: guide rows A1–A5.

### Task 10: Identity and text

**Files:** `70_text.patch`, `Context/01-identity-and-lore.md`, `02-systems.md`, `04-subclass-comparison.md`, `subclasses/deceiver.md`, `07-open-questions.md`; the Heartweaver wiki's mention of Love/Empress if any.

- [ ] Player-facing names: "2 - The High Priestess", Aspect of Doubt, class line (spec §6), every changed card description, Doubles and Doubt statuses; English style memory.
- [ ] Context rewritten to the new state (current state only); the Awakening table in `02-systems.md`.

### Task 11: In-game test guide + balance pass

**Files:** `Design/Rework/plans/2026-10-06-deceiver-veil-test.md`.

- [ ] Guide rows: D1–D4 Doubt, V1–V14 Doubles and their spells, W1–W4 Distortion/Withdraw, K1–K6 kit changes, A1–A5 Awakening, F1–F3 Faceless; each with risk R1–R6.
- [ ] `game-balance` pass on spec §7 once the user's test results are in; numbers changed only in the patches/goals, never by hand in game files.

---

## Execution order and `[fechado]` sessions

| Session | Tasks | Needs |
|---|---|---|
| now (`[aberto]`) | 0, and the patches/scripts of 1–6 written and dry-run | nothing |
| `[fechado]` #1 | apply 1–3 (Doubt, Doubles, their spells) | then the user compiles; next message reads the log |
| `[fechado]` #2 | apply 4–6 (Distortion/Withdraw, kit, lists) | compile + log |
| `[fechado]` #3 | apply 7–9 (Lua, Faceless, Awakening) | compile + log |
| any | 10, 11 | — |
