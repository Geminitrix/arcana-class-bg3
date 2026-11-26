---
id: QA_ARC-0036
title: Playtest — The Veilwalker — ids renamed, the Double's rules restored (any level)
type: playtest
subclass: deceiver
build: ARC-0036
status: ready
owner: QA Lead
created: 2026-11-25
---

# QA_ARC-0036 · The Veilwalker — ids renamed, the Double's rules restored (any level)

**Goal:** play every test and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E); results come
back here at `/sync-test-guides`. **Intent:** ARC-0036 renamed the Veilwalker's ids in place (DV37), put back the Double's
six slot rules and pointed Osiris at the Splinter and burst the Stats really have. Nothing should play differently from
the design: every test proves an id still resolves, or its failure becomes a fix (OR-1).

## Before you start

- ARC-0036 is applied and the Story is compiled: `log.txt` ends with `0 error(s)`.
- A new Veilwalker at level 12 (or levelled 1 → 12 as you go), a fight with three or more enemies. Console edition.

## Any level — full run

**Setup:** The Veilwalker at level 12 in a fight with three or more enemies.

### A.1 · The Story compiles clean

- **Rule:** ARC-0036 (Osiris ids renamed)
- **Steps:** Compile in the Story Editor; open `Mods/AspectClass_…/Story/log.txt`
- **Expected:** It ends with `0 error(s), 0 warning(s)`
- **Fails if:** Any error or warning
- **Result:** —

### A.2 · The Toolkit shows the new names in their old places

- **Rule:** DV37 (renamed in place); OR-12 (both Rulebook copies)
- **Steps:** Open the Toolkit; look at the Veilwalker spells in the Stats Editor and at Shapeshift / Rulebook
- **Expected:** Each card sits where it was, with the new id (`…_SeedOfDoubt`, `…_Eidolon`, `…_Veilstep`, `…_BindingFalsehood`, `…_TwiceTold_…`, `…_Arcana_Double_…`); the Rulebook lists 8 rules: FacelessCopy, DoubleOfTheVeil, DoubleOfTheVeil_3, _4, _5_NoUnveil, _5, _6_NoUnveil, _6 — no `New_Stat`
- **Fails if:** An entry moved, an old id is left, or a rule is missing
- **Result:** —

### A.3 · Every card casts and every tooltip link opens

- **Rule:** DV37 (ids in lists, progressions and LSTags)
- **Steps:** Cast each Veilwalker card once; hover each underlined word in their tooltips
- **Expected:** Every card is in her spellbook and casts; every linked word opens its tooltip (Seed, Doubt, Splinter, Binding Falsehood, Twice-Told…)
- **Fails if:** A card is missing, does not cast, or a link shows an empty tooltip
- **Result:** —

### A.4 · The Doubles cast her spells from level 5 and swap from level 9

- **Rule:** DESIGN §4.2, Two Truths, Unveil (the restored rules)
- **Steps:** Summon a Double with Eidolon; open its hotbar at level 5, then at level 9 or later
- **Expected:** Level 5+: Reflected Seed and Reflected Falsehood beside Splinter, Dash, Disengage and Dismiss; level 9+: Unveil too
- **Fails if:** The Double has Splinter only
- **Result:** —

### A.5 · Splinter on Command and the Splinter cleanup

- **Rule:** Splinter on Command (DV31); `ARCANA_Deceiver_Splinter`
- **Steps:** With a Double near two enemies, cast Splinter on Command
- **Expected:** That Double splinters at once, the enemies take the burst and 1 Doubt each, and the Double is gone
- **Fails if:** Nothing happens, or the Double stays after its Splinter
- **Result:** —

### A.6 · The Veil Lifts and the Tier III burst

- **Rule:** Aspect card The Veil Lifts; Tier III, the lie explodes
- **Steps:** Reach Tier III; let an enemy strike a Double; later use The Veil Lifts with Doubles and Seeds on the field
- **Expected:** The struck Double bursts by itself (4 m, Doubt); The Veil Lifts splinters every Double and bursts every Seed
- **Fails if:** A struck Double dies without a burst, or The Veil Lifts leaves Doubles standing
- **Result:** —

### A.7 · The Seed, Twice-Told and the Awakening

- **Rule:** Seed of Doubt (`SEED`), Twice-Told, Awakening (*HighPriestess* key)
- **Steps:** Cast Seed of Doubt, then a damaging card on the same enemy; use Twice-Told; fight until Tier I
- **Expected:** The Seed bursts with its Doubt; Twice-Told offers the last card; the Awakening progress counts Doubt down and Tier I arrives
- **Fails if:** The Seed never bursts, Twice-Told is empty, or the Awakening never counts
- **Result:** —

## Log

- 2026-11-25 — written with the ARC-0036 apply. Status ready.
