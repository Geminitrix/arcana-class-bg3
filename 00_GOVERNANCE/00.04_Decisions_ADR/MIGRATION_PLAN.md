# Migration Plan — Lumox Studios Repository Architecture

*Phase 0 output (audit, read-only) · 2026-10-11 · Source spec: "Arcana Class Studio — Arquitetura de
Repositório e Fluxo Ágil" v0.4 · Status: **awaiting Owner approval** — nothing has been moved yet.*

Decisions already given in chat: root = `C:\Lumox Studios\Arcana Class`; **full** structure (all
categories, all `_INDEX.md`/`_AGENT.md`); **English** folder and file names; Git = commit + push to
`main` without asking (ticket id first in the message when there is one).

---

## 1. Audit — what exists today

**Project root** (`C:\Lumox Studios\Arcana Class`, git `Geminitrix/arcana-class-bg3`, last commit 2026-10-08):

| Folder | Files | Size | Git state | Content |
|---|---|---|---|---|
| `.claude/` | 4 + `.superpowers` | — | untracked | `CLAUDE.md`, `README.md`, `.gitignore` (moved here by hand, **old paths**), `launch.json` |
| `Project Context/` | 33 | small | untracked | Hand reorg of `Context/` + `Docs/` by role (developer, game designer, project owner, tools developer, writer director) |
| `Art Design/` | 311 | **964 MB** | untracked | Icons, feature art per subclass, equipment art, raw assets (tarot, fonts, backgrounds…) |
| `Publishing/` | 139 | 173 MB | mixed | `Codex/` web app (moved from root), Mod.io, Nexus, thumbnail, TikTok |
| `specs/` `plans/` `work/` `archive/` | 5 / 2 / 31 / 40 | small | untracked | The old `Design/` split to the root |
| `tools/` | 9 | small | tracked | `stats/*.pl`, `sync-mod.sh`, `run_tests.lua` |
| `mod/` | 116 | 2.6 MB | tracked | Mirror of **deck files only** (Stats, Lists, Progressions, SE Lua, thoth) |
| `Backups/` | 234 | 88 MB | ignored | Dated safety copies |
| `_archive/` | 201 | 105 MB | ignored | 2026-10-08 cleanup (Gameplay, Obsidian, old patch, 3.1.0.28 patch notes txt) |

**Git working tree vs last commit:** `Context/` (14), `Docs/` (7), `Design/` (78), `Codex/` (134),
`Wiki/` (103), root `CLAUDE.md`/`README.md`/`.gitignore` show as **deleted**; most now live under the
new hand-made folders. **`Wiki/` (player-guide HTML, data source of the Codex) exists nowhere on disk** —
only in git history.

**Outside the root:**

| Where | What | Note |
|---|---|---|
| `…\Baldurs Gate 3\Data\Mods|Public\AspectClass_9d734fbd-…` | The real mod (what the Toolkit builds) | Folder name is fixed and cannot change |
| `…\Data\Backup\` (44 dirs) and `…\Data\Claude outputs\` (Power Budget md/xlsx) | Project material inside the game folder | Breaks the rule "nothing but the mod in the game folder" |
| `…\Data\CLAUDE.md` | Pointer + `@import` to the **old** path `C:\Projetos\BG3 Modding\…` | Import is now broken |
| `C:\Projetos\BG3\Base Game BG3\` | Vanilla extraction already done: Assets, Localization (16 langs), Osiris | = what the spec calls `56` and `31.04` |
| `C:\Projetos\BG3\References\` | Other mods (AMP, LeBlanc, Noesis Debugger) | = `56.04` |
| `~/.claude/` | `jt-gate` hook, global settings, memory | Hook and memory still point at `BG3 Modding\Arcana Class` |

**Subclasses found:** Deceiver, Starchild, Eternal, Unbound (existing); Resonant (internal tag
`THEHEARTWEAVER`, spec `heartweaver-design`), Spinner, Lionheart (new — Lionheart has a context file).
"Titan" from the old CLAUDE.md is gone. Matches the spec's list of 7.

## 2. Changes I propose to the spec (each becomes an ADR or proposal)

| # | Change | Why |
|---|---|---|
| M1 | **English tree** (§3 below). The master spec itself is kept in Portuguese under `00.01`. | Decided; project rule is English |
| M2 | `51` mirrors the real paths: `Mods/AspectClass_9d734fbd-…/` and `Public/AspectClass_9d734fbd-…/`, not `ArcanaClass_<UUID>`. Prefix stays the existing `ARCANA_` / `Arcana_` / `<Type>_Arcana_Card_*` convention, not `ARC_`. | Renaming the published mod folder or ids breaks saves and the mod.io entry (spec §31.4 agrees) |
| M3 | **One write gate, two conditions.** `jt-gate` stays: a write to mod files needs `[fechado]` **and**, from Sprint 0 on, a ticket id in the message whose header says `implementation: claude`. Writes to `56` are always blocked. | The spec's hook and the existing hook protect the same files; one hook, no drift |
| M4 | **Data ↔ 51 — DECIDED (Owner, 2026-10-11):** the mod **lives in `Data`** and is never moved. `51` is a **synchronized copy**: `sync_data` (today's `sync-mod.sh`, extended from deck files to the whole mod) copies Data → 51 before each commit and reports differences. No junction. Recorded as ADR-0003. | The Toolkit keeps working exactly as today; git and patch-note diffs read the copy |
| M4b | `jt-gate` gates only the **game copy** (paths under `Baldurs Gate 3\Data`). Writing the mirror in `51` is safe with the game open, because nothing reads it. | The hook today matches the folder name anywhere, so it would also block the sync into `51` |
| M5 | **Master data (`25`)** is the source for features **created or reworked from Sprint 0 on**. The existing mod gets an auto-generated, read-only YAML inventory (script from the Stats files) instead of a hand conversion of every entry. | Hand-converting hundreds of entries creates a second source that drifts from the Stats files; the rework will replace most of it anyway |
| M6 | `56_Vanilla_Code_Reference` and `31.04` are **junctions** to `C:\Projetos\BG3\Base Game BG3\…` and `C:\Projetos\BG3\References\`, gitignored. | The extraction already exists; copying GBs twice wastes disk |
| M7 | Add item **`75.02_Player_Guide_Codex`** for `Publishing/Codex` (+ the `Wiki/` source if you want it restored) and **`94_Safety_Backups`** (gitignored) for `Backups/` + `Data\Backup\`. | Two kinds of material the spec has no slot for |
| M8 | **LFS scope:** only final `.dds`, editable sources (`.psd`/`.svg`/`.afdesign`) and `.pak`. The 964 MB `Art Design` is reviewed before anything goes up; raw reference dumps stay local. Check the GitHub LFS quota first. | GitHub LFS storage/bandwidth is limited; most of the 964 MB is reference material |
| M9 | `_LEGACY/2026-10-11/` holds the **current folders, moved as-is** (one move of each top folder), then the new tree is filled **by copy** from there. `_LEGACY/` is gitignored (the same files are in git history). | Keeps the original intact as the spec requires, without doubling 1.3 GB on disk or in the repo |
| M10 | Part II/III knowledge cards (`27`, `57`) are written from the spec text + local game data; each web source is marked *not yet read* and read only when a card needs it. | Reading ~45 web sources up front is costly; the spec itself says to read primary sources before adopting a method as rule |
| M11 | Versioning: rework ships as **4.0.0.x** (spec §11) — needs your yes (ADR-0004). | Open question in the spec |

## 3. Mapping — old location → new ID

| Old | New |
|---|---|
| `.claude/CLAUDE.md`, `.claude/README.md`, `.claude/.gitignore` | rewritten at root: `CLAUDE.md`, `README.md`, `.gitignore` (+ `AGENTS.md`, `CODEOWNERS`, `.gitattributes`) |
| Spec document (Downloads) | `00_GOVERNANCE/00.01_Studio_Constitution/Studio_Architecture_v0.4.md` |
| `Project Context/README.md` | `05_LIVE_CONTEXT/05.00_READ_FIRST.md` |
| `Project Context/game designer/class and subclasses/arcana.md` | `05.01_Class/` + `21_GDD/21.02_Class_Identity/` |
| `…/class and subclasses/<subclass>.md` (7) | `05.02_Subclasses/<Subclass>.md` (mirror) + `21.04_Subclasses/<Subclass>/` (design) |
| `…/identity-and-lore.md` | `31_Lore/31.01_Lore_Bible.md` (+ short version in `05.05`) |
| `…/game-design-evaluation.md` (Subclass Design Criteria) | `21.04_Subclasses/_SUBCLASS_STANDARD.md` (draft) + `27.02_DnD5e_and_BG3/` |
| `…/subclass-comparison.md` | `21.08_Subclass_Matrix.md` |
| `…/new mechanics/arcana-spell-slot.md`, `deck-building-SE.md` | `26.01_Resource_Map_and_Audit/` + `21.05_Class_Features/` |
| `…/new mechanics/awakening.md` | `21.05_Class_Features/` |
| `…/new mechanics/resonant-emotions.md`, `spinner-wheel.md` | `21.04_Subclasses/Resonant/`, `…/Spinner/` |
| `…/new mechanics/quest-rewards-boons.md` | `24_Items_and_Equipment/` |
| `…/new mechanics/systems-REVISAR-E-ORGANIZAR.md` | `21.05_Class_Features/` flagged *to review* |
| `…/patch notes/patch-notes.md` | `76_Patch_Notes/76.05_Published/` + `76.03_Writing_Standard/` |
| `Project Context/glossary.md` | `33.03_Term_Glossary/` + `05.05_Current_Text_and_Lore/` |
| `Project Context/project.md` | `05.06_Technical_State/` + `10.05_Roadmap_and_Releases/` |
| `Project Context/project owner/open-questions.md` | `10.06_Impediments/` + backlog seeds in `10.01` |
| `Project Context/developer/OSIRIS.md`, `KHONSU.md` | `57.05_Osiris/`, `57.03_Khonsu_Thoth/` |
| `Project Context/writer director/ENGLISH_WRITING_STYLE.md` | `31.03_BG3_Style_Guide/` |
| `…/LOCALIZATION_WORKFLOW.md`, `MOD_TERMINOLOGY.md`, `VANILLA_TERMS_GLOSSARY.md` | `33_Localization/` (`33.01`, `33.03`) |
| `Project Context/tools developer/dump_progression.pl`, `tools/**` | `82_Automation/` (`sync-mod.sh` → `sync_data`) ; `run_tests.lua` → `53.03_Validators/` |
| `specs/*` | `21.04_Subclasses/<Subclass>/` (deceiver-veil, heartweaver→Resonant, spinner) ; deck-core + resource-economy → `21.05` / `26.01` |
| `plans/*` | `10.02_Active_Sprint/` (become the first tickets `ARC-0001…`) |
| `work/<subclass>/` (patches, goals) | `55_Implementation_Specs/_wip/<Subclass>/` until triaged (applied → `93`) |
| `archive/` | `90_ARCHIVE/93_Old_Versions/` |
| `_archive/` (incl. 3.1.0.28 patch notes) | `90_ARCHIVE/92_Discarded_Ideas/` ; 3.1.0.28 notes → `76.01_Published_Baseline/` |
| `mod/` (deck mirror) | replaced by the full synchronized copy in `51_Mod_Source/` (the mod itself stays in `Data`) |
| `Art Design/arcana icons/`, `arcana features/`, `arcana equipments/` | `42_Icons/` (`42.01` sources / `42.02` PNG / `42.03` DDS by format) ; equipment art → `45` |
| `Art Design/assets/` | `41_Art_Direction/references/` (local, not in git unless authored) |
| `Publishing/Mod.io`, `Nexus`, `thumbnail`, `Tiktok` | `73_mod_io/`, `72_Nexus_Mods/`, `75_Community_and_Support/` |
| `Publishing/Codex` | `75.02_Player_Guide_Codex/` |
| `Backups/`, `Data\Backup\` | `90_ARCHIVE/94_Safety_Backups/` (gitignored) |
| `Data\Claude outputs\Arcana_Power_Budget.*` | `22.06_Power_Budget/` |
| `C:\Projetos\BG3\Base Game BG3`, `…\References` | junctions under `56_Vanilla_Code_Reference/` and `31.04` (gitignored) |

## 4. Execution — one stage per message

| Stage | What | Needs `[fechado]`? |
|---|---|---|
| **A · Skeleton** | Move current folders to `_LEGACY/`; create the full English tree with `_INDEX.md` + `_AGENT.md`; root files; `.gitignore`/`.gitattributes` (diff shown first); fix paths in `Data\CLAUDE.md`, hook, settings, memory. Commit + push. | No |
| **B · Copy migration** | Copy per §3; `05` first load; `Data\Backup` and `Data\Claude outputs` (not mod files) out of the game folder; first `sync_data` run fills `51` (reads the mod, never writes it). | No |
| **C · Standards** | `_SUBCLASS_STANDARD`, style guide `31.03`, type catalog `55.00` (from game data), DoR/DoD, licenses `00.06` (official sources, dated), implementation policy `00.07`, cards `27` and `57`. | No |
| **D · Agents & automation** | `.claude/agents/` (Sprint 0 active roles), commands, hook extension (M3), scripts (board, validators, `extract_pak`, `compare_versions`), baseline 3.1.0.28 (you download the `.pak`). | No |
| **E · Sprint 0** | Pilot ticket end to end (you implement in the Toolkit; `sync_data` brings it into `51`). | Yes, if Claude writes mod files |

## 5. Decisions I need now

1. Approve M1–M11 (or strike any).
2. `Wiki/` — restore from git into `75.02` (Codex data source) or leave it in history only?
3. `Art Design/assets/` — is any of it authored by you, or is it all third-party/reference?
