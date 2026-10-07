# Arcana Player's Guide — shared standard

Six static HTML pages, one per class/subclass, sharing `assets/css/guide.css` and `assets/js/guide.js`.
Readers are **players** of the mod, not developers. Every page must read as one book.

| Page | File | `data-arcanum` | Card on the hero | Emblem |
|---|---|---|---|---|
| The Arcana (base class, also the home page) | `index.html` | `arcana` | *Chosen of Mystra* (no number: use ✦) | `emblems/arcana.png` |
| The Unbound | `unbound.html` | `unbound` | 0 · THE FOOL | `emblems/unbound.png` |
| The Deceiver | `deceiver.html` | `deceiver` | II · THE HIGH PRIESTESS | `emblems/deceiver.png` |
| The Starchild | `starchild.html` | `starchild` | XVII · THE STAR | `emblems/starchild.png` |
| The Eternal | `eternal.html` | `eternal` | XIII · DEATH | `emblems/eternal.png` |
| The Heartweaver | `heartweaver.html` | `heartweaver` | XIV · TEMPERANCE | none: draw an inline SVG (two cups pouring into each other, gold strokes) |

Start from `Wiki/_work/template.html`. Use **only** the classes in `guide.css`. If you truly need a new
component, post it on `BOARD.md` first; page-local `<style>` is allowed only for a diagram (e.g. the wheel).

---

## 1. Content rules (non-negotiable)

1. **English**, present tense, written for players.
2. **Current state only.** No "previously", "now", "changed", "reworked", "new in", patch talk, version numbers.
3. **Authorial work.** Never name inspirations or references: no other games, champions, films, books,
   psychologists, card decks by name ("Thoth", "Rider-Waite"), "inspired by", "based on". Tarot and
   Mystra/the Weave are the mod's own world, so they are fine. The wheel of emotions is explained as the
   Heartweaver's own lore, without naming who drew it.
4. **No development talk.** No code ids (`Target_…`, `ARCANA_…`, UUIDs), no "Script Extender", "Osiris",
   "Lua", "stats", "Toolkit", no editions, no "PC/console". **No deck building**: no Threads, hand, draw,
   discard, piles, Cards in Hand, Fated/Fleeting keywords. Spells are cast with **Woven Spell Slots**.
5. Call them **spells** (and **cantrips** for level 0), never "cards". "Card" means only the tarot card.
6. **The game files are the source of truth.** Every number, name, range, duration, save and damage die
   comes from the mod files (see §4). `Context/` is a map, never the final word. When a file and Context
   disagree, the file wins; post the disagreement on the board.
7. Names exactly as the player sees them in game (English loca), including capitals: *Woven Spell Slots*,
   *Long Rest*, *Saving Throw*, *Advantage*, *Bludgeoning*. Distances in metres (`9m`, as BG3 writes them).
8. Voice: Larian's dry, compact register. Rules: memory file
   `C:\Users\victr\.claude\projects\C--Program-Files--x86--Steam-steamapps-common-Baldurs-Gate-3-Data\memory\bg3_english_writing_style.md`.
   Feature text addresses the player as **you** (as the 2024 Player's Handbook does). No marketing fluff,
   no em-dash asides, no "not X but Y".
9. No emoji anywhere.

## 2. Page structure (same order, same ids)

**Subclass pages**

| # | Section | id | Content |
|---|---|---|---|
| — | Hero | — | Tarot card (numeral, emblem, card name) · eyebrow `Arcana Subclass · <num> · <Card> · Aspect of <X>` · h1 `The <Name>` · **epigraph** = the in-game tag line, cited `A <Name>` · lede = the in-game subclass description in *italics* + 2–3 plain sentences |
| 1 | The Card | `the-card` | What the Arcanum depicts and means, for a player who never held a tarot deck; why it is this destiny. Then `.reading`: Upright / Reversed keyword chips + one line each on how the subclass lives them |
| 2 | Playing a <Name> | `overview` | One short paragraph on role and the rhythm of a turn + `.aside` "At a Glance" (Role, Strengths, Weaknesses, a tip) |
| 3 | Core <Name> Traits | `traits` | `table.traits`: Hit Points · Spellcasting Ability · Secondary Ability · Saving Throws · Armour · Weapons · Skills · Suggested Abilities (preset) · Starting Equipment |
| 4 | <Name> Progression | `progression` | `table.progression`, levels **1–20, every row**: Level · Prof. · Features (links to `#lvl-N`, `—` with class `none` if nothing) · Slot Level · Woven Slots. Rows with a feature get `class="is-subclass"`. Feat levels show a `tag-sub tag-feat` "Feat" chip |
| 5 | Signature mechanic(s) | own id(s), kebab-case | The subclass's engine explained once, plainly, with numbers, boxes, small tables, a diagram if it helps |
| 6 | Features by Level | `features` | One `.level` per level that grants something (`id="lvl-N"`), in order. Each spell/passive is an `article.feature` |
| 7 | Aspect of <X> | `awakening` | The Aspect Awakening of this card: what is counted, the three tiers (`.tiers`), what each grants |
| 8 | Conditions & Terms | `glossary` | `dl.glossary` of every status/condition/term the page introduces |
| — | Footer | — | Identical on every page (from the template) |

**Base class page (`index.html`)**

| # | Section | id | Content |
|---|---|---|---|
| — | Hero | — | Card shows ✦ / emblem / "CHOSEN OF MYSTRA" · eyebrow `Class · Chosen of Mystra` · h1 `The Arcana` · epigraph = the class tag line, cited `An Arcana` · lede = in-game class description in italics + 2–3 sentences |
| 1 | Chosen of Mystra | `chosen` | Mystra, the Weave, what it means to be chosen; the Major Arcana as destinies (why the Arcana itself has no single card) |
| 2 | Playing an Arcana | `overview` | The seer: utility and divination at the core, combat from the destiny. `.aside` At a Glance |
| 3 | Core Arcana Traits | `traits` | Same rows; where a value depends on the subclass, say "Set by your subclass" and give a compact per-subclass line |
| 4 | Arcana Progression | `progression` | Levels 1–20: Level · Prof. · Features · Slot Level · Woven Slots. **Subclass levels** get `class="is-subclass"` and a `tag-sub` "Subclass feature" chip (levels where any subclass gains something) |
| 5 | Spellcasting | `spellcasting` | Woven Spell Slots (all share one level, rising every 2 levels; full table), Always Prepared, cantrips, upcasting, Intelligence, restoring slots |
| 6 | Features by Level | `features` | Base class features only |
| 7 | The Aspect Awakening | `awakening` | The shared rule in general terms (each destiny awakens its card's Aspect in combat over three tiers); a compact table linking each subclass's Aspect page section |
| 8 | Destinies | `destinies` | `.destinies` grid of `a.destiny` cards, one per subclass (numeral, name, Aspect, role, tag line, secondary ability), linking to each page |
| 9 | Conditions & Terms | `glossary` | Shared terms (Woven Spell Slots, Long/Short Rest restores, Aspect, Tier…) |

## 3. Components cheat sheet

- Spell entry: `article.feature` → `.feature-icon` (img or `.blank`) · `.feature-head` (`h4.feature-name` + `ul.chips` with first chip `chip-kind` = "Cantrip" / "Level N Spell" / "Passive" / "Reaction" / "Bonus Action Spell"…; next chips: school, Concentration, Ritual) · `dl.statline` (Cast · Range · Area · Duration · Save/Attack · Recharge — only those that apply) · `.feature-body` (`p.flavour` if the game has one, effect text, `p.upcast`).
- Damage and healing: `<span class="dmg">2d6 Force</span>`. Upcasting goes in `p.upcast` or a small `table.scaling` inside `.feature-body` (Slot level → value), only when the scaling isn't one simple sentence.
- Choices (pick N of M): wrap the options in `.feature-group` with a `p.choice-note`.
- Icons: `assets/img/icons/<page>/<slug>.webp`. Use one **only if the file name matches the spell's current in-game name**; otherwise `.feature-icon blank`.
- In-text keywords the game underlines: `<span class="kw">Doubt</span>` (first use in a section is enough).
- Anchors: features get `id="<kebab-name>"` so other pages can link (`deceiver.html#sigil-of-malice`).

## 4. Sources (read-only)

| What | Where |
|---|---|
| Progression per level (boosts, spells with level/school/cost/description, passives) | `Wiki/_work/progression_dump.txt` (output of `Context/tools/dump_progression.pl`) |
| Class & subclass data | `C:\Program Files (x86)\Steam\steamapps\common\Baldurs Gate 3\Data\Public\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\` — `ClassDescriptions/ClassDescriptions.lsx`, `Progressions/`, `Lists/`, `Stats/Generated/Data/*.txt` (Spell_*.txt, Passive.txt, Status_*.txt), equipment, ability presets |
| Player-facing text (handle → English) | `…\Data\Mods\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\Localization\English\english.xml` |
| Aspect Awakening logic | `…\Data\Mods\AspectClass_…\Story\RawFiles\Goals\ARCANA_Aspect_*.txt` + statuses in `Status_*.txt` |
| Map (verify everything) | `C:\Projetos\BG3 Modding\Arcana Class\Context\` (01–07 + `subclasses/*.md`) |
| Heartweaver design for parts not yet in the files | `Design\Rework\specs\2026-10-06-heartweaver-design.md` (use it as if implemented; files win wherever they exist) |

**Never write** to anything under the game install. Write only your own page in `Wiki/` and the board.

Notes for reading the dump: some classes print level 1 twice (the second is the multiclass entry; use
the first). Description placeholders `[1]`, `[2]` are filled from the `{…}` params printed after the text.
Upcast values live in the `<spell>_N` variants in the stats files.

## 5. Shared numbers (verify, then use the same everywhere)

| Character level | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Prof. | +2 | +2 | +2 | +2 | +3 | +3 | +3 | +3 | +4 | +4 | +4 | +4 | +5 | +5 | +5 | +5 | +6 | +6 | +6 | +6 |
| Slot level | 1 | 1 | 2 | 2 | 3 | 3 | 4 | 4 | 5 | 5 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| Woven Slots | 2 | 4 | 6 | 7 | 9 | 10 | 11 | 12 | 14 | 15 | 16 | 16 | 17 | 17 | 18 | 18 | 19 | 20 | 21 | 22 |

Feats at 4, 8, 12, 16, 20. Subclass chosen at level 1. HP 10 + 6 per level. (Base-class agent: confirm
these against the files and post the result on the board; subclass agents use what the board says.)

## 6. Colours

Set by `data-arcanum`; never hard-code colours in a page. Heartweaver uses coral (`#bd4f2b` light /
`#f39a78` dark). The gold thread (`--gold`) is shared by all pages.
