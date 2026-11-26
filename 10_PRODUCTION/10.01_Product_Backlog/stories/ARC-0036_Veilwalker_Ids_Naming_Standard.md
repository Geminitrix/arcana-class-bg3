---
id: ARC-0036
title: "Veilwalker ids: one naming standard for the Stats, statuses and their references (Sigil, Mirror, Mimic, Distortion, Empress, _SlotN out)"
type: chore
epic: EPIC_Rework_Subclasses
subclass: deceiver
status: in_qa
owner: Mod Engineer
implementation: claude
priority: should
value: 4
effort: 4
inputs: [00.01/Operating_Rules.md OR-10 OR-59, 33.03/MOD_TERMINOLOGY.md (The Deceiver), 33.03/Glossary_Game_and_Code_Names.md, 21.04/Deceiver/DECISIONS.md DV12 DV29 DV36, game Stats/Lists/Progressions/RootTemplates/Lua/Osiris/loca]
outputs: [game files (Public + Editor/Mods copies, Lua, Osiris goals, the 15 loca files), 21.04/Deceiver/DECISIONS.md (DV37), 21.04/Deceiver/DESIGN.md §13–14, 33.03 glossaries, 00.01 OR-59 (a Double row), 55/SPEC_ARC-0020.md, 55/TOOLKIT_ARC-0020.md, 61.02/Deceiver/QA_ARC-0020.md, 05.02/Deceiver.md]
blocked_by: []
sprint:
created: 2026-11-25
---

# ARC-0036 · Veilwalker ids: one naming standard

**Goal:** every Veilwalker id in the Stats and statuses (and every file that references them) uses the current names of
`33.03/MOD_TERMINOLOGY.md`, in the patterns of OR-59; no id says Sigil, Mirror (for the Double), Mimic, Distortion,
EtherealChains, Empress or `_SlotN`.
**Intent:** nothing changes in play; the Owner reads one vocabulary in the Toolkit, the tooltips and the documents.

## Owner's answers (2026-11-25)

- The mess is in the **Stats ids seen in the Toolkit**, not in the playtest. Example: `_Slot3` — the mod uses `_3`.
- **Rename the main messy and obsolete ids.** Nothing of the Arcana has been published yet: no save or respec concern,
  so OR-10's "a published entry is never renamed" does not apply (OR-59: an unpublished wrong name is renamed before release).
- **Keep the position:** each entry is renamed in place, in the same order in every file, so it keeps its place in the Toolkit.
- The Double's spells follow **`<Type>_Arcana_Double_X`** (like `Shout_Arcana_Double_Splinter`) — a new OR-59 row.
- **Mirrored Self** and **Mirrored Spell** keep the *Mirrored* name (the level-10 mirror is its own idea); only their ids are fixed.
- Documents call the subclass **Veilwalker** in prose; *Deceiver* only as an internal id or folder, in `code`.
- Layers in scope: spells, passives, **statuses**, **dead loca strings**. Not in scope: translating the other 14
  languages (their LSTag ids are still updated, or their tooltips break), the header entries (`DECEIVER STATUS`…).

## Rename table (approved by the Owner 2026-11-25 → DV37)

Variants (`_2`…`_6`) follow their root. Proposed names come from `MOD_TERMINOLOGY.md` (the card's in-game name in PascalCase).

| Now | Proposed |
|---|---|
| `Projectile_Arcana_Card_Spell_SigilofMalice` | `Projectile_Arcana_Card_Spell_SeedOfDoubt` |
| `Projectile_DEBUG_SigilofMalice` | `Projectile_Arcana_Util_DEBUG_SeedOfDoubt` (like `Target_Arcana_Util_DEBUG_AddDoubt`) |
| `Target_Arcana_Card_Spell_MirrorImage` | `Target_Arcana_Card_Spell_Eidolon` |
| `Target_Arcana_Card_Spell_EtherealChains` | `Target_Arcana_Card_Spell_BindingFalsehood` |
| `Target_Arcana_Card_Spell_Distortion` · `Projectile_Arcana_Distortion_Explosion` | `…_Card_Spell_Veilstep` · `Projectile_Arcana_Veilstep_Explosion` |
| `Target_Arcana_Created_Mimic` | `Target_Arcana_Created_TwiceTold` |
| `…_Created_MimicSigilofMalice` · `…_MimicEtherealChains` · `…_MimicDistortion` · `…_MimicWithdraw` | `…_Created_TwiceTold_SeedOfDoubt` · `_BindingFalsehood` · `_Veilstep` · `_Withdraw` |
| `Projectile_Arcana_MimicDistortion_Explosion` | `Projectile_Arcana_TwiceTold_Veilstep_Explosion` |
| `Projectile_Deceiver_Double_MirrorSigil` + `_Slot3`…`_Slot6` | `Projectile_Arcana_Double_ReflectedSeed` + `_3`…`_6` |
| `Target_Deceiver_Double_MirrorChains` + `_Slot3`…`_Slot6` | `Target_Arcana_Double_ReflectedFalsehood` + `_3`…`_6` |
| `Target_Deceiver_Double_Unveil` | `Target_Arcana_Double_Unveil` |
| `Shout_Arcana_Card_Passive_MirroredCharm` · `Arcana_Passive_MirroredCharm` | `…_Card_Passive_MirroredSelf` · `Arcana_Passive_MirroredSelf` |
| `Interrupt_Arcana_Aspect_WhichOne` | `Interrupt_Arcana_Reaction_WhichOne` (OR-59 reaction row) |
| `Arcana_Passive_Aspect_Empress_*` | `Arcana_Passive_Aspect_HighPriestess_*` |
| Status `SIGIL` · `SIGIL_TECH` · `SIGIL_DETONATED_TECH` | `SEED` · `SEED_TECH` · `SEED_BURST_TECH` (`SEED_OF_DOUBT…` if `SEED` clashes with vanilla) |
| Status `SIGIL_OF_MALICE_LAST_CASTED` | `SEED_OF_DOUBT_LAST_CASTED` |
| Status `DISTORTION_HELPER` · `DISTORTION_LAST_CASTED` | `VEILSTEP_HELPER` · `VEILSTEP_LAST_CASTED` |
| Status `MIMIC_DISTORTION_HELPER` · `MIMIC_ETHEREAL_CHAINS(_2…_6)` | `TWICE_TOLD_VEILSTEP_HELPER` · `TWICE_TOLD_BINDING_FALSEHOOD(_2…_6)` |
| Status `ASPECT_AWAKENED_EMPRESS*` · `ASPECT_PROGRESS_EMPRESS*` · Awakening key `"EMPRESS"` | `…_HIGHPRIESTESS*` · key `"HIGHPRIESTESS"` |

Loca: the ~12 unreferenced strings (Hollow Image, Mirror Image: Hall of Mirrors, Mirrored Deck/Cards, Clone, the
*Sigil* sentences, `Arcane Spells: The Deceiver`, `The Deceiver`) go to `90` and leave the file; `SIGIL_DETONATED_TECH`
shows *Gale Deflection* (copied from the Windborn) and gets its own name.

## Addendum — found by the dry run (same rule, DV37; Owner's answers 2026-11-25)

| Now | New / action |
|---|---|
| Statuses `ETHEREAL_CHAINS(_3…_6, _EFFECT, _LAST_CASTED)` · `MIMIC_LAST_CAST` | `BINDING_FALSEHOOD…` · `TWICE_TOLD_LAST_CAST` (no vanilla clash, checked in `Editor/Mods/Shared, Gustav, GustavX`) |
| Level map `Sigil_MarkDamage` (read by the Seed) | `Seed_BurstDamage` |
| Osiris `DB_ARCANA_MirrorImageOf` · `DB_ARCANA_SigilDoubtOwner` · `PROC_ARCANA_Sigil_*` · `ARCANA_MimicWithdraw_*` | `DB_ARCANA_DoubleOf` · `DB_ARCANA_SeedDoubtOwner` · `PROC_ARCANA_Seed_*` · `ARCANA_TwiceToldWithdraw_*` |
| Osiris calls `Shout_Deceiver_Double_Shatter` — **a spell that no longer exists** (the Stats and the Rulebook say `Shout_Arcana_Double_Splinter`): Splinter on Command, the Splinter cleanup, The Veil Lifts and Tier III never see the Splinter | `Shout_Arcana_Double_Splinter` (**ARC-0020 bug, fixed here**) |
| Shapeshift rules `DoubleOfTheVeil_Slot3…6` (+ `_NoUnveil`) | `DoubleOfTheVeil_3…6`. **Five of them were lost:** they lived only in `Rulebook.lsx`; the Toolkit reads `Rulebook.tbl`, so the Owner's save of 18:41 kept `_Slot3` alone, with Splinter only — today no Double gets Reflected Seed/Falsehood or Unveil (**ARC-0020 bug**). `restore_double_rules.pl` puts the six slot rules back in **both** copies, with the UUIDs Osiris uses and the Owner's current base kit |
| Rulebook `.tbl` names `New_Stat_1` / `New_Stat_2` | `FacelessCopy` / `DoubleOfTheVeil` |
| 9 level maps nothing reads (`SigilofMalice_Damage`, `Mirror*_Damage`, `Mimic*_Damage`, `Distortion_Damage`, `EtherealChains_Damage`) | removed from `.lsx` + `.tbl` (Owner: remove with backup) |
| Root templates nothing references: `ARCANA_CHAR_CreateClone_2` (old clone, 3 dead spells), `ARCANA_ITEM_Spell_DistortionPosition`, `_MimicDistortionPosition`, `_MirrorDistortionPosition` | removed, archived in `93` (unused, so the Owner's "dead → remove" answer wins over "rename to Veilstep") |
| Root template of the Double `ARCANA_CHAR_CreateClone_1` (`8807d230`, used by the cards) | `ARCANA_CHAR_DoubleOfTheVeil` (name only, GUID kept; Divine at the apply) |
| Kept on purpose | the vanilla icon `Spell_Illusion_MirrorImage`; *Mirrored Self* / *Mirrored Spell* |

Comments and test names that still say Distortion / Mimic / Sigil (Lua tests, `Overhead.lua`, `ArcanaHelpers.khn`, two goals)
and `Mods/…/GLOSSARY.md` are polished by hand at the apply. Generators that would write the old names back:
`gen_awakening_progress.pl` (key `EMPRESS`), `gen_upcast_variants.pl`, `gen_emotion_alchemy.pl`, `check_cards.pl`,
`sort_stats.pl`, `subclass_texts.pl` — updated in the same commit.

## Dry run (2026-11-25, `55/_wip/Deceiver/ARC-0036/`)

`rename_ids.pl --out` → `restore_double_rules.pl` → `cleanup_dead.pl`, all on copies: **1095 replacements in 55 files**;
every Stats file keeps its entries, count and sequence; the only "new name already in use" is the intended
`Shout_Arcana_Double_Splinter`; 30 XML copies parse; `check_osiris.pl` on the 34 goals 0/0; rules lsx 8 = tbl 8, the
seven names Osiris applies all exist.

## Apply (one `[fechado] ARC-0036` message, Toolkit closed)

1. Backup every touched file in `94_Safety_Backups/ARC-0036_<date>/`.
2. Run the dry run again on the game as it is then (the Owner may have saved since), check the report, `--apply`.
3. Divine: rename the Double's template; move the four dead templates to `93` with a README.
4. Generators, comments, glossaries; `sync_data`; validators (`check_osiris`, `check_castable`, `check_cards`).
5. The Owner compiles the Story (`0 error(s)`), opens the Toolkit (the Rulebook shows 8 rules, no `New_Stat`), and plays the smoke test.

## Where the ids live (2026-11-25 sweep, `grep -rla` over Public, Mods and Editor/Mods)

Stats `.txt` + `.stats` (Passive, Projectile, Shout, Target, Interrupt, Status_BOOST) · `SpellLists` · `Progressions` ·
`LevelMapValues` (`.lsx` + `.tbl`) · 4 RootTemplates `.lsf` (Doubles/clone, through Divine) · Lua `CardDB`,
`Overhead` and 5 tests · `ArcanaHelpers.khn` · 9 Osiris goals (`ARCANA_Aspect_Common`, `_HighPriestess`,
`ARCANA_CardFamilies`, `ARCANA_Deceiver_*`) and the Awakening generator · LSTag `Tooltip=` in the 15 loca files ·
`ARCANA_VFX_Status_DarknessRise.lsefx` · `Mods/…/GLOSSARY.md`. `story.div` / `goals.raw` are compiled: the Owner recompiles.

## Acceptance criteria

- [x] The rename table approved by the Owner and logged as **DV37** (amends DV12, DV29 and the Stats half of DV36)
- [x] OR-59 gains the summon-spell row (`<Type>_Arcana_Double_X`) and `_N` variants (never `_SlotN`)
- [x] The `<Type>_Deceiver_Clone_` row of the code glossary goes; `33.03` maps each new id to its in-game name
- [x] Vanilla clash checked for every new status — none (`Editor/Mods/Shared, Gustav, GustavX` `.stats`; the extraction
      path of `57.06` is missing on this machine, the editor corpus stands in)
- [x] The Double's six slot rules exist in both Rulebook copies; Reflected Seed/Falsehood from level 5, Unveil from 9 (ARC-0020 L5/L9)
- [x] Backup in `94_Safety_Backups/ARC-0036_<date>/`, then a script renames in place, one `[fechado] ARC-0036` message
- [x] **Order kept:** the list of entry names of every Stats `.txt` / `.stats` file, with the table applied, equals the
      list after the rename (same count, same sequence); each file's entry count unchanged (Toolkit truncation trap)
- [x] `grep -rlaP` over the mod tree finds none of the old ids (patterns exclude the new names); `check_castable.pl`,
      `check_osiris.pl` 0/0, the Lua tests pass; the Owner compiles the Story with `0 error(s)`
- [ ] Every Deceiver tooltip (EN) renders its LSTag links; no dead string left; no tooltip says *Gale Deflection* on the Seed
- [x] Documents: `DESIGN` §13–14, `SPEC_ARC-0020`, `TOOLKIT_ARC-0020`, `QA_ARC-0020` (appendix still says Mirror: Sigil,
      Shatter), `05.02/Deceiver.md`, the code glossary — new ids, *Veilwalker* in prose
- [ ] Smoke test in game: level 1–12 Veilwalker loads, every card casts, the Awakening counts (QA_ARC-0036, short)

## Gates

- [x] Design gate — n/a (no design change; DV37 records the names)
- [x] Narrative gate (`32.04`) — only the hidden `SEED_BURST_TECH` name (*Seed Burst*); n/a otherwise
- [ ] DoD (`00.03`)

## Log

- 2026-11-25 — created from the Owner's report during the ARC-0020 playtest and four answers (above).
- 2026-11-25 — table approved → DV37; OR-59 rows. Dry run clean; it found the Shatter call and the lost Double rules
  (ARC-0020 bugs, fixed in this apply) and dead level maps / templates (Owner: remove with backup). → `spec_ready`,
  waits `[fechado] ARC-0036`.
- 2026-11-25 — `[fechado] ARC-0036` applied. Backup of 63 files in `94/ARC-0036_2026-11-25/` (+ `removed_loca.xml`,
  `REMOVED_levelmaps.txt`, the dry-run `REPORT.md`). Rename in place: 1095 replacements in 55 files, entry order kept;
  the six Double slot rules back in `Rulebook.lsx` **and** `.tbl` (8 = 8, `New_Stat_1/2` named); 9 dead level maps out;
  the Double template renamed `ARCANA_CHAR_DoubleOfTheVeil` (Divine, round trip = the Name only); 4 dead templates to
  `93/2026-11-25_ARC-0036_dead_templates/`; 18 dead English strings (12 in each other language) out; `SEED_BURST_TECH`
  gets its own name *Seed Burst* (the *Gale Deflection* handle is a placeholder shared by 6 other hidden statuses of
  other subclasses — left to their tickets). Also found and fixed: Osiris exploded `Projectile_Arcana_SplinterBurst`, but
  the Owner typed `Projectile_Arcana_Splinter_Explosion` (Tier III burst never fired) — aligned to the Owner's name.
  Generators (`gen_awakening_progress` key, `subclass_texts` class line, `check_cards` exception), comments, Lua tests,
  documents (ids + *Veilwalker* in prose; Toolkit row names stay `Deceiver` in code), master data, catalogs, propagation.
  Checks: `check_osiris` 0/0 (34 goals), `validate` 0 errors (4 Eternal handle warnings, not ours), `verify_context`
  Deceiver 0 misses, `playtests check` OK, `check_propagation Deceiver` OK. Left by design: `check_cards` flags the
  Owner's Splinter (`ApplyStatus(SELF,UNSUMMON_ACTIVE…)` without GROUND — ARC-0020 verification) and the DEBUG Seed spell
  before its parent (an old order, kept: no entry moves). `Mods/…/GLOSSARY.md` (translation memory) is localization work.
  → `in_qa`: the Owner compiles the Story and plays `QA_ARC-0036`.
- 2026-11-25 — The Owner compiled the Story (21:41): `log.txt` ends with `0 error(s), 0 warning(s)` — the renamed goals and the L1.4 fix are live. QA_ARC-0036 A.1 marked pass on Arcana Test Guides.
