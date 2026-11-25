---
id: ARC-0036
title: "Veilwalker ids: one naming standard for the Stats, statuses and their references (Sigil, Mirror, Mimic, Distortion, Empress, _SlotN out)"
type: chore
epic: EPIC_Rework_Subclasses
subclass: deceiver
status: backlog
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

## Rename table (proposal — the Owner approves it before the apply)

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

## Where the ids live (2026-11-25 sweep, `grep -rla` over Public, Mods and Editor/Mods)

Stats `.txt` + `.stats` (Passive, Projectile, Shout, Target, Interrupt, Status_BOOST) · `SpellLists` · `Progressions` ·
`LevelMapValues` (`.lsx` + `.tbl`) · 4 RootTemplates `.lsf` (Doubles/clone, through Divine) · Lua `CardDB`,
`Overhead` and 5 tests · `ArcanaHelpers.khn` · 9 Osiris goals (`ARCANA_Aspect_Common`, `_HighPriestess`,
`ARCANA_CardFamilies`, `ARCANA_Deceiver_*`) and the Awakening generator · LSTag `Tooltip=` in the 15 loca files ·
`ARCANA_VFX_Status_DarknessRise.lsefx` · `Mods/…/GLOSSARY.md`. `story.div` / `goals.raw` are compiled: the Owner recompiles.

## Acceptance criteria

- [ ] The rename table approved by the Owner and logged as **DV37** (amends DV12, DV29 and the Stats half of DV36)
- [ ] OR-59 gains the row `<Type>_Arcana_Double_X` (the Double's own spells); the `<Type>_Deceiver_Clone_` row of the
      code glossary goes; `33.03` maps each new id to its in-game name
- [ ] Vanilla clash checked for every new status (`SEED`…) — the extraction path of `57.06` is missing on this machine
- [ ] Backup in `94_Safety_Backups/ARC-0036_<date>/`, then a script renames in place, one `[fechado] ARC-0036` message
- [ ] **Order kept:** the list of entry names of every Stats `.txt` / `.stats` file, with the table applied, equals the
      list after the rename (same count, same sequence); each file's entry count unchanged (Toolkit truncation trap)
- [ ] `grep -rlaP` over the mod tree finds none of the old ids (patterns exclude the new names); `check_castable.pl`,
      `check_osiris.pl` 0/0, the Lua tests pass; the Owner compiles the Story with `0 error(s)`
- [ ] Every Deceiver tooltip (EN) renders its LSTag links; no dead string left; no tooltip says *Gale Deflection* on the Seed
- [ ] Documents: `DESIGN` §13–14, `SPEC_ARC-0020`, `TOOLKIT_ARC-0020`, `QA_ARC-0020` (appendix still says Mirror: Sigil,
      Shatter), `05.02/Deceiver.md`, the code glossary — new ids, *Veilwalker* in prose
- [ ] Smoke test in game: level 1–12 Veilwalker loads, every card casts, the Awakening counts (QA_ARC-0036, short)

## Gates

- [ ] Design gate — n/a (no design change; DV37 records the names)
- [ ] Narrative gate (`32.04`) — only for the *Gale Deflection* fix
- [ ] DoD (`00.03`)

## Log

- 2026-11-25 — created from the Owner's report during the ARC-0020 playtest and four answers (above).
