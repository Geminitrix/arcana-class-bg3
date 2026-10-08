# Arcana Class — BG3 mod

Custom playable class for Baldur's Gate 3 (Patch 8), published on mod.io and Nexus Mods as **Arcana Class**.
The Arcana is a seer chosen by **Mystra** and bound to the Weave; each subclass is a tarot Major Arcanum
that **awakens its Aspect** in combat. The class casts with **Woven Spell Slots**; in the PC edition
(Script Extender) combat becomes a **deck builder** paid with **Threads**. The base class is mostly
out-of-combat utility; the subclasses carry the combat.

| Subclass | Arcanum · Aspect | Role | Secondary |
|---|---|---|---|
| 🍃 Unbound | 0 · The Fool · Curiosity | Unarmoured unarmed striker, mobility | DEX |
| 🪞 Deceiver | II · The High Priestess · Doubt | Control, burst, illusion | CHA |
| 🌟 Starchild | XVII · The Star · Hope | Healer, celestial support | WIS |
| 💀 Eternal | XIII · Death · Sorrow | Necromantic frontline | CON |
| 🌈 Resonant | XIV · Temperance · Empathy | Control and support through emotions | WIS |
| Titan *(in development)* | VIII · Strength · ❓ | ❓ | ❓ |
| ⏳ Spinner *(designed)* | X · Wheel of Fortune · Anticipation | Ranged damage through timed fates | DEX |

Every subclass casts with **Intelligence**. Current details per subclass: `Context/subclasses/`.

## ★ The knowledge base — read it first

**`Context/README.md`** is the index of the project's living knowledge base: identity and lore,
systems (resources, deck, keywords, Aspect Awakening), base class, one file per subclass, comparison,
project state, glossary and open questions. It describes the **current** state only — when something
changes, update the matching `Context/` file in the same round of work. `Context/tools/dump_progression.pl`
prints every progression level from the game files to check it against.

---

## 0. Hard rules — never violate these

1. **Two editions — Script Extender only in the PC one (decided 2026-09-17).** The **Nexus/PC edition**
   uses Norbyte's Script Extender for the combat deck-building layer (Lua) — this is the current focus.
   The **console edition** must stay SE-free. Keep every gameplay effect in Stats / Osiris / LSX / Khonsu
   so both editions share it; Lua only manages the deck (hand, draw, discard, lock/glow boosts).
   Rework context: `Design/archive/REWORK_CONTEXT.md`. Newer and authoritative: deck core spec
   `Design/specs/2026-09-17-deck-core-design.md` and resource balance (hand, deck, Threads per
   level, reserve, card costs, Warlock-style `ArcanaSpellSlot`) `Design/specs/2026-09-17-resource-economy.md`.
2. **Do not write to mod files while the game or Toolkit is open.** Reading is always fine. The state
   comes from the tag at the start of each message — see §0.1.
3. **The game files are the source of truth; `Context/` and `Docs/` are a map.**
   When they disagree, the files win. Re-read the actual `.lsx` / `.txt` before changing anything —
   never act on a doc's summary alone.
4. **Schema-valid ≠ works.** LSLibDefinitions.xml validating a Boost/Functor does not mean the engine
   accepts it. Prefer copying a proven vanilla pattern over inventing one from the schema.
5. **Verify before asserting.** The user tests everything and pushes back hard on unverified theory.
   Propose one cheap, falsifiable diagnostic per round rather than a bundle of guesses. If you claim a
   function or field exists, grep for it in the vanilla files first.

## 0.1 Game/Toolkit gate (`[fechado]` / `[aberto]`)

Every message that carries a task starts with a tag saying whether the game **and** the Toolkit are closed:

| Tag | Meaning | What you may do |
|---|---|---|
| `[fechado]` | both closed | Full workflow (Explore → Plan → Code → Verify → Commit), including writes to mod files |
| `[aberto]` | at least one open | Read, investigate, plan; mod-file changes go to chat as copy-paste-ready blocks |
| *(no tag)* | unknown → treated as open | Same as `[aberto]` |

- The tag covers **that message only**. The next message without a tag is open again.
- "Mod files" = anything under the `AspectClass_9d734fbd…` folders in the game install (`Public\`,
  `Mods\`, `Editor\`). Files outside the game — this repo, `Context/`, `Design/`, `Docs/`, the
  scratchpad, memory — can be edited in any message.
- The **`jt-gate` hook** (`~/.claude/hooks/jt-gate.ps1`, wired in `~/.claude/settings.json`) enforces this:
  it denies Edit/Write to mod files, and Bash/PowerShell commands that write into them, when the message
  didn't start with `[fechado]`. If it blocks you, **don't work around it** — hand over the blocks or ask
  the user to resend with `[fechado]`. Never infer the state from running processes.
- After writing mod files: `bash tools/sync-mod.sh` → commit + push → update the matching `Context/` file.
  The hook reminds you after each edit.
- **Osiris cycle:** compiling needs the Story Editor (= Toolkit open). So: edit goals with `[fechado]` →
  the user opens the Toolkit and compiles → next message (`[aberto]`) → read `Story\log.txt` and report
  errors/warnings.

## 0.2 Language

The user writes in **Portuguese — reply in Portuguese**. Everything that ships or gets published is in
**English**: loca strings, in-game text, and every project document (`Context/`, `Design/`, `Docs/`).

---

## 1. Where everything lives

The mod is installed inside the game folder, and the game folders hold **only what the mod ships or the
Toolkit generates**. Everything else — documents, scripts, backups, glossaries — lives in the project
folder; its map is in **`Context/05-project.md` §3**.

| What | Path |
|---|---|
| **Class data** (Progressions, ClassDescriptions, Lists, Stats, Levelmaps) | `C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\Data\Public\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\` |
| **Mod data** (meta, loca, Story/Osiris, Khonsu, GUI icons) | `…\Data\Mods\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\` |
| Osiris goals (source) | `…\Data\Mods\AspectClass_…\Story\RawFiles\Goals\*.txt` |
| Osiris API signatures (**authoritative**) | `…\Data\Mods\AspectClass_…\Story\RawFiles\story_header.div` |
| Osiris compile log | `…\Data\Mods\AspectClass_…\Story\log.txt` |
| Khonsu scripts | `…\Data\Mods\AspectClass_…\Scripts\thoth\helpers\*.khn` |
| English loca (handle → text) | `…\Data\Mods\AspectClass_…\Localization\English\english.xml` |
| This project | `C:\Projetos\BG3 Modding\Arcana Class\` |
| **Other mods for reference** (non-vanilla patterns to compare against) | `C:\Projetos\BG3 Modding\References\` |
| LSLib / Divine.exe (pre-approved, no prompt) | `C:\Softwares\ExportTool\Packed\Tools\Divine.exe` |
| Toolkit crash + error logs | `C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3 Toolkit\` |

> The folder name `AspectClass` is the mod's original internal name and **cannot be changed**.
> The in-game name is **Arcana**. Both refer to the same thing.

Vanilla game data is **packed** — `Data\Mods\Shared`, `Gustav`, `GustavX` contain no loose files.
Don't glob them expecting extracted sources; extract what you need with `Divine.exe` (§4).

---

## 2. Read this before you touch that

| If the task involves… | Read first |
|---|---|
| Anything in `Story\` — writing, editing or debugging Osiris goals | **`Docs/OSIRIS.md`** |
| `.khn` files, or any `Conditions` / `BoostConditions` / `EnabledConditions` / `DescriptionParams` field | **`Docs/KHONSU.md`** |
| **Creating or changing a subclass, a card/passive/tier of one, or the base class** | **`Context/Rules/class-creation-rules.md`** — mandatory process and criteria (Depth Model) |
| Class design, lore, inspirations, resources, deck, keywords, Aspect Awakening | **`Context/01-identity-and-lore.md`**, **`Context/02-systems.md`** |
| Levels, cards, passives, chassis, strengths/weaknesses of a subclass | **`Context/03-base-class.md`**, **`Context/subclasses/<name>.md`**, `Context/04-subclass-comparison.md` |
| Project state, tools, test status, roadmap | **`Context/05-project.md`** |
| Undecided design, known gaps, things to verify in game | **`Context/07-open-questions.md`** |
| Writing player-facing English text (spell/passive/status/item descriptions) | **`Docs/localization/ENGLISH_WRITING_STYLE.md`** (also the `bg3-english-writing-style` memory) |
| Translating a string, matching vanilla/mod terminology | `Docs/localization/` — `VANILLA_TERMS_GLOSSARY.md`, `MOD_TERMINOLOGY.md`, `LOCALIZATION_WORKFLOW.md`, `TRANSLATION_GLOSSARY.md` |
| The player guides | `Wiki/` (HTML) is the source; `Codex/` (React) extracts from it |

Open the reference doc **before** editing, not after something breaks. Anything in `_archive/` is dead
material from earlier versions of the mod — never use it for current facts.

---

## 3. Build and reload workflows

There is no in-toolkit script editor. Author files externally, then reload.

- **Stats / Khonsu changes** (`Passive.txt`, `Spell_*.txt`, `Status_*.txt`, `*.khn`)
  → Toolkit: *Main editor → Tools → Reload Stats* (or *Stats editor → File → Reload Stats Files*).
  All `.khn` files in `helpers/` share one Lua global environment — a function in one file can call
  a function defined in another.
- **Osiris changes** (`Story\RawFiles\Goals\*.txt`)
  → compile with the Larian **Story Editor**, which regenerates `story.div` / `story_ac.dat`.
  → **Always read `Story\log.txt` afterwards.** It ends with `N error(s), M warning(s)`, and the warnings
  catch real defects. Worked example: *"Database defined but never checked: `DB_OriginalPlayerLevel`"*
  in `IND_Spell_MirrorImage.txt` — the INITSECTION declared a 2-arity `DB_OriginalPlayerLevel` while the
  rules actually used a 3-arity `DB_OriginalPlayer`, so the declaration was dead **and** the real DB had
  no type-pinning declaration. Fixed 2026-08-18 by renaming the declaration to match the usage.
  `story_orphanqueries_found.txt` lists the same thing.
- **LSX data** (Progressions, ClassDescriptions, Lists, Levelmaps) → the Toolkit's **UUID Object Editor**.

---

## 4. Environment gotchas (all hit and confirmed in this project)

- **No Python.** `python` / `python3` are not installed. Use **`perl`** (available in Git Bash) or
  PowerShell for scripted text processing.
- **Stats and LSX files are CRLF.** A naive `chomp`/regex leaves a trailing `\r` and silently fails to
  match. Strip `\r` explicitly (`$l =~ s/[\r\n]+$//`).
- **`Divine.exe` requires absolute paths** and rejects relative ones with
  `Cannot proceed without absolute path [E2]`. Use `C:/...` style forward-slash absolute paths.
- **`Divine.exe -a convert-loca` takes no `-i` / `-o` flags** — passing `-i loca` errors out.
- Shell heredocs (`<<'EOF'`) through the Bash tool have failed on long multi-line content here.
  Use the **Write** tool for file creation instead.

### Useful `Divine.exe` recipes

```bash
# list what's inside a pak
Divine.exe -g bg3 -a list-package -s "C:/…/Data/Shared.pak"

# pull one file out (never extract a whole multi-GB pak)
Divine.exe -g bg3 -a extract-single-file -s "C:/…/Data/Shared.pak" \
  -f "Public/SharedDev/Stats/Generated/Data/Passive.txt" -d "C:/…/scratch/Passive.txt"

# .lsf → readable .lsx
Divine.exe -g bg3 -a convert-resource -s "C:/…/Tags/<uuid>.lsf" -d "C:/…/scratch/tag.lsx"

# vanilla English loca → xml (for resolving vanilla handles)
Divine.exe -g bg3 -a convert-loca -s "C:/…/english.loca" -d "C:/…/scratch/english.xml"
```

Where vanilla data lives, by file: `Shared.pak` → `Public/Shared` + `Public/SharedDev` (generic passives,
Wizard/Monk features) · `Gustav.pak` → `Public/Gustav`, `GustavDev`, `Honour` · `GustavX.pak` →
`Public/GustavX` (**Patch 8 content** — Circle of the Stars, Death Domain, etc.).

---

## 5. Localisation

Stats and LSX files never contain player-facing text — only **handles** like
`h75b888d9gfb47g2bc1ge9b9gb7555ade89f3;2` (the `;N` suffix is the version, not part of the id).
Resolve them against `Localization/English/english.xml`.

Recipe — resolve every handle in a piped file. Save as `resolve.pl`; **tested and working**:

```perl
my $loca = shift or die "usage: perl resolve.pl <english.xml> < input\n";
open(my $fh,'<:encoding(UTF-8)',$loca) or die $!;
my %m;
while(<$fh>){ $m{$1} = $2 if /contentuid="([^"]+)"[^>]*>(.*?)<\/content>/ }
while(<STDIN>){
  s{(h[0-9a-f]{8}(?:g[0-9a-f]{4}){3}g[0-9a-f]{12})(;\d+)?}{ $m{$1} // "[[MISSING]]" }ge;
  s/&quot;/"/g; s/&lt;/</g; s/&gt;/>/g; s/&amp;/&/g;   # loca xml is entity-escaped
  print;
}
```

```bash
cat Stats/Generated/Data/Passive.txt | perl resolve.pl ".../Localization/English/english.xml"
```

Same trick works for **vanilla** handles — convert `Localization/English.pak → english.loca → xml`
first (§4), then point the script at that file instead.

The mod ships **16 languages**. When adding or changing an English string, the other 15 fall out of
sync — see the `aspectclass-localization-batch` memory for the state of that work.

---

## 6. Conventions used by this mod

- **Id prefixes decide what a spell is to the deck** (`<Type>_Arcana_Card_Spell_`, `_Card_Ability_`,
  `_Card_Passive_`, `_Created_`, `_Util_`, `_Reaction_`; passives `Arcana_Passive_`; Osiris and item stats
  `ARCANA_`). Full table: `Context/06-glossary.md`. The literal prefix is in the spell id, so a rename
  touches the game files.
- **A card is marked, not listed:** `ARCANA_IS_CARD` in `TargetConditions` (`IsCardSpell()`); non-card
  class spells that must count carry `ARCANA_IS_SPELL`. Osiris triggers never compare a card name —
  they ask `DB_ARCANA_CardFamily` (upcast variants arrive as `<card>_N`).
- **Statuses are `SCREAMING_SNAKE_CASE`**, no prefix. Technical/hidden ones end in `_TECH`, `_TECHNICAL`
  or `_HELPER` and carry `DisableOverhead;DisableCombatlog;DisablePortraitIndicator`.
- **Upcast variants** `<card>_N` are generated by `tools/stats/gen_upcast_variants.pl` — re-run it
  after adding, renaming or releveling a card, then `sort_stats.pl --apply` and `check_cards.pl`.
- **Resources:** `ArcanaSpellSlot` = **Woven Spell Slots**, `ArcanaThread` = **Threads**.

## 7. Current development state

What is undecided, what looks wrong in the files, and what still needs an in-game test is in
`Context/07-open-questions.md`; test status and roadmap in `Context/05-project.md`. The `[DEBUG]` cards
(list "Arcana Deck DEBUG") stay in the build on purpose. Levels 13–20 are reserved for future content.
