# Environment and Workflows

*Moved from the pre-migration `CLAUDE.md` (§1, §3–§6) on 2026-10-11. Everything here was hit and confirmed
in this project.*

## 1. Paths

| What | Path |
|---|---|
| **Class data** (Progressions, ClassDescriptions, Lists, Stats, Levelmaps) | `C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\Data\Public\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\` |
| **Mod data** (meta, loca, Story/Osiris, Khonsu, GUI icons, ScriptExtender) | `…\Data\Mods\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\` |
| Osiris goals (source) | `…\Data\Mods\AspectClass_…\Story\RawFiles\Goals\*.txt` |
| Osiris API signatures (**authoritative**) | `…\Data\Mods\AspectClass_…\Story\RawFiles\story_header.div` |
| Osiris compile log | `…\Data\Mods\AspectClass_…\Story\log.txt` |
| Khonsu scripts | `…\Data\Mods\AspectClass_…\Scripts\thoth\helpers\*.khn` |
| English loca (handle → text) | `…\Data\Mods\AspectClass_…\Localization\English\english.xml` |
| Project root | `C:\Lumox Studios\Arcana Class\` |
| Synchronized copy of the mod | `50_ENGINEERING\51_Mod_Source\` |
| Vanilla extraction (local) | `C:\Projetos\BG3\Base Game BG3\` (Assets, Localization, Osiris) |
| Other mods for reference (local) | `C:\Projetos\BG3\References\` |
| LSLib / Divine.exe (pre-approved, no prompt) | `C:\Softwares\ExportTool\Packed\Tools\Divine.exe` |
| Toolkit crash + error logs | `C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3 Toolkit\` |

The folder name `AspectClass` is the mod's original internal name and **cannot be changed**; the in-game
name is **Arcana**. Vanilla data is **packed** — `Data\Mods\Shared`, `Gustav`, `GustavX` hold no loose
files; extract with Divine (§4) or read the extraction above.

## 2. Build and reload

There is no in-Toolkit script editor. Author files externally, then reload.

- **Stats / Khonsu** (`Passive.txt`, `Spell_*.txt`, `Status_*.txt`, `*.khn`) → Toolkit: *Main editor →
  Tools → Reload Stats* (or *Stats editor → File → Reload Stats Files*). All `.khn` files in `helpers/`
  share one Lua global environment — a function in one file can call one defined in another.
- **Osiris** (`Story\RawFiles\Goals\*.txt`) → compile with the **Story Editor**, which regenerates
  `story.div` / `story_ac.dat`. **Always read `Story\log.txt` afterwards** — it ends with
  `N error(s), M warning(s)` and the warnings catch real defects (e.g. *"Database defined but never
  checked"* revealed a 2-arity declaration that didn't match the 3-arity DB the rules used).
  `story_orphanqueries_found.txt` lists the same thing. Compiling needs the Toolkit open, so the cycle is:
  edit with `[fechado]` → the Owner compiles → next message `[aberto]` → read `log.txt`.
- **LSX data** (Progressions, ClassDescriptions, Lists, Levelmaps) → the Toolkit's **UUID Object Editor**.

## 3. Environment gotchas

- **No Python.** Use **Perl** (Git Bash) or PowerShell.
- **Stats and LSX files are CRLF.** Strip `\r` explicitly (`$l =~ s/[\r\n]+$//`).
- **`Divine.exe` requires absolute paths** (`Cannot proceed without absolute path [E2]`); use `C:/...`.
- **`Divine.exe -a convert-loca` takes no `-i` / `-o` flags.**
- Long heredocs through the Bash tool have failed here — create files with the Write tool.

## 4. Divine recipes

```bash
# list what's inside a pak
Divine.exe -g bg3 -a list-package -s "C:/…/Data/Shared.pak"
# pull one file out (never extract a whole multi-GB pak)
Divine.exe -g bg3 -a extract-single-file -s "C:/…/Data/Shared.pak" \
  -f "Public/SharedDev/Stats/Generated/Data/Passive.txt" -d "C:/…/scratch/Passive.txt"
# .lsf → readable .lsx
Divine.exe -g bg3 -a convert-resource -s "C:/…/Tags/<uuid>.lsf" -d "C:/…/scratch/tag.lsx"
# vanilla English loca → xml
Divine.exe -g bg3 -a convert-loca -s "C:/…/english.loca" -d "C:/…/scratch/english.xml"
```

Vanilla data by pak: `Shared.pak` → `Public/Shared` + `Public/SharedDev` (generic passives, Wizard/Monk
features) · `Gustav.pak` → `Public/Gustav`, `GustavDev`, `Honour` · `GustavX.pak` → `Public/GustavX`
(**Patch 8 content** — Circle of the Stars, Death Domain…).

## 5. Localisation handles

Stats and LSX never hold player-facing text, only **handles** like `h75b888d9gfb47g2bc1ge9b9gb7555ade89f3;2`
(the `;N` suffix is the version, not part of the id). Resolve them against `english.xml`:

```perl
my $loca = shift or die "usage: perl resolve.pl <english.xml> < input\n";
open(my $fh,'<:encoding(UTF-8)',$loca) or die $!;
my %m;
while(<$fh>){ $m{$1} = $2 if /contentuid="([^"]+)"[^>]*>(.*?)<\/content>/ }
while(<STDIN>){
  s{(h[0-9a-f]{8}(?:g[0-9a-f]{4}){3}g[0-9a-f]{12})(;\d+)?}{ $m{$1} // "[[MISSING]]" }ge;
  s/&quot;/"/g; s/&lt;/</g; s/&gt;/>/g; s/&amp;/&/g;
  print;
}
```

The mod ships **16 languages**; changing an English string puts the other 15 out of sync.

## 6. Mod conventions

- **Id prefixes decide what a spell is to the deck:** `<Type>_Arcana_Card_Spell_`, `_Card_Ability_`,
  `_Card_Passive_`, `_Created_`, `_Util_`, `_Reaction_`; passives `Arcana_Passive_`; Osiris and item stats
  `ARCANA_`. The literal prefix is in the id, so a rename touches the game files.
- **A card is marked, not listed:** `ARCANA_IS_CARD` in `TargetConditions` (`IsCardSpell()`); non-card
  class spells that must count carry `ARCANA_IS_SPELL`. Osiris triggers ask `DB_ARCANA_CardFamily`
  (upcast variants arrive as `<card>_N`), never compare a card name.
- **Statuses** are `SCREAMING_SNAKE_CASE`, no prefix. Technical ones end in `_TECH`, `_TECHNICAL` or
  `_HELPER` and carry `DisableOverhead;DisableCombatlog;DisablePortraitIndicator`.
- **Upcast variants** `<card>_N` come from `82_Automation/stats/gen_upcast_variants.pl` — re-run it after
  adding, renaming or relevelling a card, then `sort_stats.pl --apply` and `check_cards.pl`.
- **Resources:** `ArcanaSpellSlot` = Woven Spell Slots, `ArcanaThread` = Threads.
- The `[DEBUG]` cards (list "Arcana Deck DEBUG") stay in the build on purpose.
