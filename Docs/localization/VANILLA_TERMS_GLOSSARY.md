---
title: Vanilla Terms Glossary
tags:
  - arcana/localization
---

# Vanilla Terms Glossary

**Goal:** when the mod's English text names or reuses a real D&D/BG3 concept (a monster type, a vanilla spell, a status), use **Larian's own official translation** for it — never invent one. Prior localization audits found invented-but-wrong terms replacing the real in-game name, which breaks the link between visible text and what an `<LSTag Tooltip="...">` reference actually points to.

## Canonical file

```
Data\Mods\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\GLOSSARY.md
```

Kept **outside** `Localization\` on purpose so it never gets packed into the shipped mod — it's a dev tool, not player-facing content. Two tables inside:

1. **~42 real vanilla D&D/BG3 terms** this mod's flavour text name-drops — English + all 14 non-English official Larian translations, sourced by exact `contentuid` cross-reference against the real game paks.
2. **~232 mod-original terms** (proper nouns this mod invented — subclass names, spell names, resource names) with whatever translation already exists per language, marked `PENDING` where a language hasn't caught up. See [[Mod Terminology]] for the highest-value subset of this table reproduced inline.

Always read the live file for a full lookup — this note only carries a representative sample so Claude Code doesn't have to open it for the common cases.

## Sample — vanilla terms (read the file for the full ~42-row table)

| English | PT-BR | FR | DE | RU |
|---|---|---|---|---|
| Arcane Gate | Portão Arcano | Portail arcanique | Arkanes Tor | Волшебные врата |
| Arcane Recovery | Recuperação Arcana | Restauration magique | Arkane Erholung | Магическое восстановление |
| Comprehend Languages | Compreender Idiomas | Compréhension des langues | Sprachen verstehen | Понимание языков |
| Death Ward | Proteção contra Morte | Protection contre la mort | Todesschutz | Защита от смерти |
| Dispel Magic | Dissipar Magia | Dissipation de la magie | Magie bannen | Рассеивание магии |
| Feather Fall | Queda Suave | Feuille morte | Federfall | Плавное падение |
| Hypnotic Gaze | Olhar Hipnótico | Regard hypnotique | Hypnotischer Blick | Гипнотический взгляд |
| Instinctive Charm | Encantamento Instintivo | Détournement d'hostilité | Instinktive Bezauberung | Инстинктивные чары |
| Mirror Image | Reflexos | Image miroir | Spiegelbilder | Зеркальное отражение |
| Thunderclap | Palma do Trovão | Coup de tonnerre | Donnerschlag | Раскат грома |

### ⚠️ `[WARN]` entries — coincidental matches, verify before reuse

Short/generic English words in the mod happen to exact-match unrelated vanilla content. **Check context before trusting the match:**

| English | Why it's flagged |
|---|---|
| **Arcana** | Matches the skill "Arcana," not necessarily this class's own name in every context |
| **Fly** | Generic movement-type term, not spell-specific |
| **Freecast** | Matches a different mechanic's internal term |
| **Friends** | Matches the vanilla cantrip *Friends* — correct here, but verify it's the same spell concept |
| **Mimic** | Matches the **Mimic monster**, not this mod's "Mimic:" spell-copy prefix — do **not** reuse that translation |
| **Momentum** / **Reverberation** / **Sigil** | Generic nouns, unrelated vanilla flavour text may share the exact string |

## Regeneration recipe (when new name-like English terms appear)

1. Extract content entries from `Localization/English/english.xml`. Treat short (≤45 chars), sentence-less strings (no terminal period, no `[N]` placeholder, no `LSTag`) as name-like — spell/ability/status names rather than descriptions.
2. Extract the official `English.pak` (`Data/Localization/English.pak` in the Steam install) via `Divine.exe` (`extract-package` then `convert-loca`), stream with `System.Xml.XmlReader` (never load the ~230k-entry file as a DOM), exact-text-match each name-like string against it. A match = the mod names real vanilla content.
3. For matches, pull the same `contentuid`'s text from each official language pak under `C:\Projetos\BG3 Modding\Base Game BG3\Localization\<Lang>\<Lang>.pak` with the same extract/convert/stream approach.
4. Full detail and the exact matching thresholds: see the bottom of `GLOSSARY.md` itself.

See [[Localization Workflow]] for the sync process this glossary feeds into, and [[English Writing Style]] for prose-level conventions (capitalisation, punctuation) that apply on top of correct terminology.
