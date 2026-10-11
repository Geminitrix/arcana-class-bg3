---
title: English Writing Style
tags:
  - arcana/localization
---

# English Writing Style — Measured Larian Voice

Conventions for authoring BG3 mod description text so it reads as vanilla Larian English, measured from the shipped game corpus (not impression). Check every new/edited description against this before anything else. See [[Localization Workflow]] for the sync process and [[Vanilla Terms Glossary]] for terminology matching.

## Voice by category

- **Spell `Description`** — imperative, second person, addressed to the player as actor. Median ~91 chars, ~1 sentence. Opens with a verb: *"Teleport to a nearby, unoccupied space, or swap places with an ally."* States what the player does and the visible consequence, not the numbers. Merely-likely effects get the hedge word **"possibly"** (Larian's signature tell for save-gated riders).
- **Spell `ExtraDescription`** — the fine print the main line omits: exceptions, scaling, edge cases, exact numbers. Neutral register, no imperative. Split into paragraphs with `<br><br>` when there's more than one rule. Never repeat the main Description.
- **Passive `Description`** — median ~139 chars. Two grammatical persons, meaningfully chosen:
  - **Second person ("You…")** for player-facing class/race/feat passives.
  - **Third person ("This creature…"/"This weapon…"/"The wearer…")** for monster traits and item-granted passives.
  Mixing these within one feature is the most common non-native tell.
- **Status `Description`** — median ~117 chars, written from **outside** the affected creature, subject often elided: *"Can move without provoking Opportunity Attacks."* Often a bare participial phrase, then mechanics in a second sentence or after `<br><br>`.
- **Item `Description` (flavour)** — median ~88 chars, ~1.28 sentences. Show **one concrete sensory detail**, don't summarise the item. Third person, present tense, item as subject (only ~9% address "you"). Dry wit is the house register on mundane items — never a wink at the player, the joke stays inside the world. Named/legendary items get a 250–400 char micro-story instead: past tense, a named person, a turn on *though*/*Of course*/*And then*.

## Hard conventions (measured, not guessed)

- **British spelling.** `armour`, `colour`, `honour`, `-ise`/`-ised`. American spelling (`armor`, `color`) appears **0 times** in the corpus.
- **Dashes: em dashes appear 0 times.** Use a **spaced hyphen ` - `** for every parenthetical/aside/attribution. Never `—`, never `–`.
- **Quotes: single, not double.** `'…'` for flavour quotations; double quotes are essentially absent from body text.
- **Capitalisation — the rule that catches everyone.** Rules-engine *proper nouns* are Title Case; *resources/stats you spend or have* are lowercase, **even inside an `<LSTag>`**:

  | Title Case | lowercase |
  |---|---|
  | Advantage / Disadvantage | hit points |
  | Saving Throw | spell slot |
  | Armour Class | movement speed |
  | Attack Roll | action |
  | Proficiency Bonus | bonus action |
  | Critical Hit | reaction |
  | Long Rest / Short Rest | temporary hit points |
  | Ability Check | cantrip |
  | Status names (Prone, Poisoned, Blinded, Frightened, Invisible) | |
  | Damage types: **Fire damage**, Poison damage (type capitalised, "damage" not) | |

  Phrasings to copy exactly: **"hit point maximum"** / **"maximum hit points"** (never "Maximum Hit Points"); **"Once per turn,"** sentence-initial; **"per turn"**; **"per Long Rest"**; **"succeed a Saving Throw"** (not "succeed on"); `can't` mid-sentence, `Cannot` sentence-initial.

- **`<LSTag>`.** ~29% of description strings carry one. `<LSTag Tooltip="X">text</LSTag>` for rules concepts (`SavingThrow`, `AttackRoll`, `Advantage`, `ArmourClass`, `SpellSlot`, `HitPoints`, `CriticalHit`, `Resistant`, `Immune`, `Vulnerable`…), `<LSTag Type="Status|Spell|ActionResource|Passive" Tooltip="UPPERCASE_ID">text</LSTag>` for concrete game entities. **Visible text inside the tag obeys the capitalisation table** — `<LSTag Tooltip="HitPoints">hit points</LSTag>`, not "Hit Points." Only the **first** mention in a string is typically tagged.
- **Paragraphing.** Only `<br><br>` (never single `<br>`), in ~3.4% of strings — reserve for genuinely separate rules. `<i>…</i>` only for flavour appended after mechanics.
- **Placeholders.** `[1]`, `[2]`, `[3]` resolved by the engine to a formatted chunk. Write the sentence so the placeholder is a **noun phrase**: *"deal an additional [1]"*, never *"deal [1] damage"* or *"[1] metres"* — the engine already supplies the unit.

## Anti-patterns (vanilla never does these)

- Em dashes, double quotes, exclamation marks in mechanical text, semicolons.
- Restating numbers already shown in the tooltip's stat block.
- Meta/fourth-wall voice, explaining the fantasy to the player ("you feel powerful as…").
- Multi-clause piled sentences — one sentence is the median; use `<br><br>` or push a second rule into `ExtraDescription`.
- Naming the mechanic instead of the fiction in a spell Description — put the mechanic in `ExtraDescription` instead.

## Where this mod currently deviates (measured 2026-08-17, 727 entries)

Already correct: British spelling, no em dashes, no double quotes, Advantage/Disadvantage/Saving Throw/Armour Class all Title Case, `<br><br>` only, `[1]` placeholders used correctly, no trailing/double spaces.

Real gaps to check for on every new pass:
1. **Title Case on lowercase terms** — `Movement Speed`, `Bonus Action`, `Action`, `Reaction`, `Maximum Hit Points` (should be lowercase / "maximum hit points"). Applies inside `LSTag` visible text too.
2. **`Wisdom Modifier`** should be `Wisdom <LSTag Tooltip="AbilityModifier">Modifier</LSTag>`.
3. **Zero use of the spaced hyphen ` - `** and **zero ellipses** — the mod is missing Larian's two main rhythm devices for asides.
4. **No "possibly"** hedge for save-gated riders.
5. **Descriptions run short** — mean 83 chars vs. vanilla's 104 (spells)/145 (passives)/100 (items). Passive text especially under-written.
6. Lore/aspect blurbs are abstract-noun stacks; vanilla lore anchors on a **concrete image or named person**.

**One flagged, not auto-fixed:** `contentuid` `h51ee83c2gbaaag66c0g8c19gf1213fd33652` boosts "Intelligence score" in a capstone passive (see [[Base Class#Arcane Avatar — L1 ⚠️|Arcane Avatar]]), but no subclass casts off Intelligence — reads as a copy-paste leftover. Needs the author's design call, not a mechanical text fix.

## Regenerating the measurement corpus (~3 min, `Divine.exe`)

1. `extract-package` `Data\Localization\English.pak` → `convert-loca` → `english.xml` (~33 MB, ~232,878 strings). Stream with `System.Xml.XmlReader` into a `Dictionary[string,string]` — never load as `[xml]` DOM.
2. Spells/passives/statuses: `extract-package` Shared.pak + Gustav.pak with `--expression "Public/*/Stats/Generated/Data/*.txt"`, parse `new entry "X"` / `type "Y"` / `data "DisplayName|Description|ExtraDescription" "hXXXX;N"`, resolve against the loca dict.
3. **Item flavour text lives in RootTemplates, not Stats `.txt`.** `--expression "*RootTemplates/_merged.lsf"` from Shared.pak + Gustav.pak, `convert-resource` lsf→lsx, stream for `node id="GameObjects"`, read `DisplayName`/`Description`/`TechnicalDescription` handles.

Delete the extracts afterwards (~150 MB) — regenerable in minutes any time a specific vanilla phrasing needs re-verifying rather than guessing.
