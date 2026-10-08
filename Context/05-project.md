# 05 · Project

> Last verified: **2026-10-02**. Working rules and environment gotchas also live in the project
> `CLAUDE.md` — this file is the project's state and map; `CLAUDE.md` wins on rules.

---

## 1. The mod

| Field | Value |
|---|---|
| Name | **Arcana Class** (in game: *Arcana*) |
| Author | **Lumox** — solo project, made in free time; supported through Ko-fi / PayPal |
| Mod UUID / folder | `9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7` / `AspectClass_…` (legacy name, unchangeable) |
| Published on | **mod.io** (PublishHandle `6006029`) and **Nexus Mods** |
| Game | Baldur's Gate 3, Patch 8 |
| Languages | English base + 15 translations (16 total) |
| Dependencies | Gustav, GustavDev, GustavX, DiceSets, MainUI, ModBrowser, PhotoMode, CrossplayUI, AnimationUnlocker; **Script Extender** for the PC edition only |
| Add-ons | *Arcana — Feat Every Level* and *Feat Every 2 Levels* (mod.io) |

## 2. Editions

| Edition | Ships | Notes |
|---|---|---|
| **PC / Nexus** | Stats + Osiris + Khonsu + **Lua deck layer** (SE) | Current focus |
| **Console** | Stats + Osiris + Khonsu only | Must never depend on SE |

The Toolkit's play mode runs without SE: a test there behaves like the console edition. To know whether
SE ran, check `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Script Extender Logs\`.

---

## 3. Where things live

| What | Path |
|---|---|
| Class data (progressions, lists, stats, levelmaps) | `…\Data\Public\AspectClass_…\` |
| Mod data (meta, loca, Story, Khonsu, GUI, ScriptExtender) | `…\Data\Mods\AspectClass_…\` |
| Toolkit side of the stats (`.stats`, `.tbl`) | `…\Data\Editor\Mods\AspectClass_…\` |
| Lua deck (SE) | `…\Mods\AspectClass_…\ScriptExtender\Lua\` (own local git, no remote) |
| Osiris goals | `…\Mods\AspectClass_…\Story\RawFiles\Goals\` (`ARCANA_*.txt`) |
| Khonsu helpers | `…\Mods\AspectClass_…\Scripts\thoth\helpers\*.khn` |
| English loca | `…\Mods\AspectClass_…\Localization\English\english.xml` |
| Project folder | `C:\Projetos\BG3 Modding\Arcana Class\` (map below) |

The game folders hold **only what the mod ships or the Toolkit generates**. Everything else — notes,
backups, glossaries, scripts — lives in the project folder.

### Project folder

| Folder | What it holds |
|---|---|
| `CLAUDE.md` | Entry point for every Claude session |
| `Context\` | **This knowledge base** (current state) · `Rules\class-creation-rules.md` (the design process) · `subclasses\` · `tools\` |
| `Design\specs\` | Design documents, dated (`YYYY-MM-DD-<topic>-design.md`) |
| `Design\plans\` | Active implementation plans |
| `Design\work\<subclass>\` | Patches, goals and scripts of work in progress |
| `Design\archive\` | Finished specs, plans, patches and one-off scripts (history) |
| `Design\art\` | Icons, fonts, tarot art, Illustrator sources (not in git) |
| `Docs\` | Engine references (`OSIRIS.md`, `KHONSU.md`) and `PATCH_NOTES.md` |
| `tools\` | Every script: `stats\` (generators, patcher, lint), `sync-mod.sh`, `run_tests.lua` |
| `mod\` | Mirror of the deck system's files from the game folder (`tools/sync-mod.sh`); never edited by hand |
| `Wiki\` | Player guide (HTML); also the data source of the Codex |
| `Codex\` | Interactive player guide (React + Vite); its extract script reads `Wiki\` |
| `Publishing\` | Mod pages (`nexus\`, `modio\`) and their images and posters |
| `Backups\` | Safety copies taken before bulk edits, dated (not in git) |
| `_archive\` | Dead material kept until the author deletes it (not in git) |

**GitHub:** `Geminitrix/arcana-class-bg3` (private), branch `main`. It tracks everything above except
art, publishing images, backups and the archive (`.gitignore`).

---

## 4. Working rules (summary — full text in `CLAUDE.md`)

1. **Never write to mod files while the game or the Toolkit is open.** Ask "game and Toolkit closed?"
   right before every write. The Toolkit (`Glasses.exe`) overwrites files from memory on save.
2. **Game files are the truth.** Re-read the `.lsx` / `.txt` before changing anything.
3. **Schema-valid ≠ works.** Copy proven vanilla patterns.
4. **One cheap, falsifiable test per round.** The author tests everything in game.
5. **Every stats change is two files**: `Public/…/*.txt` (game) and `Editor/…/*.stats` (Toolkit). Use the tools below so they agree.
6. **Every change is committed and pushed** without asking (after mod-file changes, run `tools/sync-mod.sh` first).
7. **Loca:** edit only English; the other 15 languages are updated in a separate localisation round.
8. Conversation in Portuguese; everything shipped and every reference doc in English.
9. When in doubt about design, **ask** — the author changes direction and wants inconsistencies pointed out, not resolved silently.

---

## 5. Build and reload

| Change | How it reaches the game |
|---|---|
| Stats / Khonsu | Toolkit → *Reload Stats* |
| Osiris goals | Larian **Story Editor** compile → **read `Story\log.txt`** (warnings catch real bugs) |
| LSX (progressions, lists, levelmaps) | Toolkit UUID Object Editor |
| Lua | Reload the save (SE) |

## 6. Tools

| Tool | Purpose |
|---|---|
| `tools/sync-mod.sh` | Mirror the deck system from the game folder into `mod/` |
| `tools/run_tests.lua` | Offline Lua test suite (Lua 5.4 at `C:\Users\victr\AppData\Local\Programs\Lua\bin\lua.exe`) |
| `tools/stats/gen_upcast_variants.pl` | Generates every `<card>_N` upcast variant and `ARCANA_CardFamilies.txt`. **Re-run after adding, renaming or releveling a card.** Keeps hand edits to variant fields |
| `tools/stats/sort_stats.pl --apply` | Keeps stats grouped (DEBUG / ARCANA / DECEIVER / STARCHILD / UNBOUND / ETERNAL) and every child after its parent |
| `tools/stats/check_cards.pl` | Lint: card markers, costs, `GROUND:` on ground spells, child-before-parent, literal card names in Osiris triggers. Run after every Toolkit publish |
| `tools/stats/stats_add.pl` | Applies `*.patch` files (Public `.txt` + Editor `.stats` + `english.xml` together) |
| `Design/archive/tools/aspect_structure.pl` | (archived, one-off) Aspect tier passives in the progressions. Do not rerun: it would undo the Veil rework |
| `Context/tools/dump_progression.pl` | Read-only dump of every progression level, to check this knowledge base |

SE console (PC): `!arcanatest`, `!arcanahand`, `!arcanapool`, `!arcanathreads`, `!arcanadeck`,
`!arcanaset` (copies), `!arcanastates`.

---

## 7. Test status in game

| Area | State |
|---|---|
| Threads refill, Spare Thread, opening hand, Reweave | ✅ Verified |
| Aspect Awakening, per-tier goals (all four Aspects: tiers, Awakened I/II/III, progress) | ✅ Verified 2026-10-03 |
| Harvest only for the Eternal (Unbound, Deceiver, Starchild at Tier III no longer get it) | ✅ Verified 2026-10-03 |
| Blood Offering feeding the Sorrow ledger | ✅ Verified 2026-10-03 (cast credits MaxHP/10) |
| Mirror Image clone hotbar | ✅ Verified |
| Mimic descriptions and the repointed spell links | ✅ Verified 2026-10-03 |
| Slot → Thread conversion, hand resource, reaction gates, Hemoplague container | ⏳ Written and tested offline, not confirmed in game |
| Toolkit play mode freezes in combat | ❌ Cause unknown |
| Dismissing the clone after it has cast | ⏳ The vanilla Dismiss changed weapon stance first (~2 s, only after the clone had cast). The clone now gets `Shout_Deceiver_Clone_Dismiss` (Sheathing `DontChange`) from `ARCANA_Spell_MirrorImage.txt` (2026-10-03); compile and test pending |

---

## 8. Roadmap (current intent)

1. **Ship the unreleased patch** (Woven Spell Slots, the deck, upcasting, Aspect Awakening, reactions) —
   checklist at the top of `Docs/PATCH_NOTES.md`.
2. **Base class rework "Closer to Mystra"**: themed spell lists the player picks from, many more
   Mystra/Weave spells (see [07](07-open-questions.md) §1).
3. **Content for levels 13–20** (reserved; the core must fit a game that ends at 12).
4. Keyword framework: Echo, Invoke, Foresee, Landmark, Mantle, Refine; in-game deck editor; card UI.
5. **Boons** (Greek deities as quest rewards) and **equipment** (4 items already defined, not granted).
6. **The Titan** and **The Spinner** subclasses.
7. Localisation round for the 15 non-English languages.
