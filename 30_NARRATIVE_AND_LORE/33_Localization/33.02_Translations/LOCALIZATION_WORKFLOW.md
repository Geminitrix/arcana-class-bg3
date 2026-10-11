---
title: Localization Workflow
tags:
  - arcana/localization
---

# Localization Workflow

## Where the files are

The mod's own loca — **NOT** the game's own `Data\Localization` folder (that only holds compiled `.pak` files; a past confusion point):

```
C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\Data\Mods\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\Localization\
```

Each of the 16 languages has its own subfolder with a loose, editable XML: `English\english.xml`, `French\french.xml`, `German\german.xml`, … Format is Larian's `contentList`/`content contentuid="..." version="N"` loca XML.

Official Larian reference paks (all languages, for checking canon terms): `C:\Projetos\BG3 Modding\Base Game BG3\Localization\<Language>\<Language>.pak` — see [[Vanilla Terms Glossary]]. **This path moved once already** (`BG3_Modding` → `BG3 Modding\Base Game BG3`); if it 404s, re-check `C:\Projetos\BG3 Modding\` fresh.

## File format — matches vanilla exactly (changed 2026-09-06)

All 15 language files now match Larian's own native `.loca` round-trip format byte-for-byte:

- **UTF-8 with BOM, CRLF line endings** (superseded an earlier no-BOM/LF convention — this is current).
- `<?xml version="1.0" encoding="utf-8"?>` — the `encoding="utf-8"` attribute is **mandatory**. Its absence was a real player-reported bug: Korean loca silently fell back to English in-game because the parser mis-detected encoding on non-ASCII text. English (pure ASCII) worked either way, masking the bug for every other language.
- Root `<contentList>` element's own attributes **don't matter functionally** — only the tag name and `<content contentuid="..." version="...">text</content>` children matter to the parser.
- **PowerShell write recipe:** `[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($true)))`, normalize line endings right before the final write.
- **Read recipe:** force UTF-8 explicitly on every read of non-ASCII content — plain `Get-Content` silently mojibakes accented characters. See [[Paths and Environment#Environment gotchas]].

## Sync workflow — English is the source of truth

1. Diff by **`contentuid` + `version`** (not by text) between `English\english.xml` and each other language file.
   - `version` on a `<content>` node is the sync signal: if English's version for a `contentuid` is higher than a language file's version for the same uid, that translation is **stale**. A uid present in English but absent elsewhere is **brand new**.
2. Back up each language file before editing: `<file>.xml.bak-YYYYMMDD` (existing convention — the `.bak-*` suffix isn't `.xml`, so it's safely ignored by the game).
3. Reuse established terminology already present in the target file for recurring terms — grep the file for other occurrences first. See [[Mod Terminology]] for the canonical per-term table.
4. Preserve exact `contentuid`/`version` byte-for-byte, exact entry count delta, `Type=`/`Tooltip=` LSTag attributes untouched (translate only the visible label), placeholders `[n]` preserved without renumbering.
5. After editing, re-diff to confirm 0 unexpected new/changed/orphan entries, and check placeholder/`Tooltip=` consistency between EN and the target per matching `contentuid`.
6. **Changes to loca XML aren't picked up without restarting the game/Editor, or running `reloadLoca` in the debug console.**

### Gendered text

The mod doesn't use Larian's optional gendered-line overrides (`Gender/Female/`, `Gender/Neutral/` subfolders; `_to_F`/`_to_X` filename suffixes) — this is the documented default (lines assumed male-speaker-to-male-listener). Any grammatically-gendered self-referential text always renders masculine. Not a bug — a design decision to revisit if full gender-accurate text is ever wanted.

### Declining languages (Russian, Polish, Ukrainian…)

How vanilla solves number/gender agreement with a placeholder:
- **Gender:** parallel files (`Gender/Female/`, `_to_F`, `_M_to_X`) — never inline in the string.
- **Number:** an invariable measure word + genitive noun (`[1] ед. урона`, `ед.` = единиц), works for any number. Alternative: noun before the number (`Тайные осколки: [1]`).
- **Rule: never let a placeholder directly govern a countable noun.**

## Confirming a string is real content before translating

A `contentuid` existing in `english.xml` does **not** mean it's shown to players — orphaned/leftover strings are common. Before treating a "new" string as real:

```bash
grep -arl "<contentuid>" Data\Public\AspectClass_.../   # binary-aware, excludes Localization\ itself
grep -arl "<contentuid>" Data\Mods\AspectClass_.../
```

Real game data referencing loca handles: `Data\Public\...\Stats\Generated\Data\*.txt` (`data "DisplayName" "h...;version"`) and `Data\Public\...\RootTemplates\*.lsf` (binary — convert with `Divine.exe` to read `handle="h..."` attributes). A RootTemplate's internal (non-localized) `Name` field is a strong hint at the intended DisplayName when the loca text looks like a dev placeholder.

## English content also needs periodic style audits

Not just translations — see [[English Writing Style]] for the measured Larian-voice reference used to judge correctness.

## Full grammar/history reference

`Data\Mods\AspectClass_…\GLOSSARY.md` (outside `Localization\` on purpose, never packed) — two tables: vanilla D&D/BG3 terms this mod's text name-drops (with Larian's own translation in all 14 non-English languages) and ~232 mod-original terms with per-language translation status. See [[Vanilla Terms Glossary]] for how it's built and how to regenerate it.

Official modding guide: `https://docs.baldursgate3.game/index.php?title=Adding_Localisation` — **fetch via the Browser tool**, WebFetch 403s this site.
