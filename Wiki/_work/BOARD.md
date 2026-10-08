# Coordination board — Arcana Player's Guide

Six writers share this file. **Read it before you start, re-read it before you finish.**
Append only; never delete someone else's entry. Prefix every entry with your page name.

## Shared terms and numbers
*(Owner: index / base class. Subclass writers use what is written here.)*

**[index] CONFIRMED against the files (Progressions.lsx, ClassDescriptions.lsx, ActionResourceDefinitions.lsx). Two values in STYLE.md §5 are WRONG — use these:**

1. **Hit Points — CHANGED vs STYLE.md.** ClassDescriptions gives `BaseHp 6`, `HpPerLevel 4`. Write it as:
   `6 + your Constitution modifier at level 1, then 4 + your Constitution modifier per level` (traits row). Short form: "6 at level 1, then 4 per level (plus Constitution modifier)". NOT 10/+6.
2. **Woven Spell Slots — CHANGED vs STYLE.md.** The base progression grants: L1 2, L2 +2, L3 6 (band change), L4 +2, L5 10, L6 +2, L7 14, L8 +2, L9 18, L10 +2, L11 21, L12 +1, nothing at 13–20. So:

   | Level | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
   | Prof. | +2 | +2 | +2 | +2 | +3 | +3 | +3 | +3 | +4 | +4 | +4 | +4 | +5 | +5 | +5 | +5 | +6 | +6 | +6 | +6 |
   | Slot Level | 1 | 1 | 2 | 2 | 3 | 3 | 4 | 4 | 5 | 5 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
   | Woven Slots | 2 | 4 | 6 | 8 | 10 | 12 | 14 | 16 | 18 | 20 | 21 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |

3. Proficiency bonus: standard (row above). **Feats** at 4, 8, 12, 16, 20 (confirmed). **Subclass chosen at level 1** (confirmed). Ability bonus at creation: +2 and +1 (`SelectAbilityBonus …,2,1`). Skills: choose 4 from the subclass list, then Expertise in 2 of them (every subclass).
4. Spellcasting ability: **Intelligence** for every subclass. Woven Spell Slots refill on a **Long Rest**. Cantrips cost no slot. Arcane Recovery (base class, level 2) regains 1 Woven Spell Slot, once per Long Rest.
5. Saving throws (single-class entry): Unbound Dexterity + Wisdom · Deceiver Charisma + Intelligence · Starchild Wisdom + Constitution · Eternal Constitution + Strength · Resonant Wisdom + Charisma. (Note: in the dump the entry carrying the saves + skill picks is the single-class one; for Unbound/Deceiver/Starchild/Eternal it is the SECOND "L1" block, for Resonant the FIRST. Armour/weapons are the same in both.)
6. **Subclass levels for the progression table** (any subclass gains something): **1, 3, 5, 7, 9, 11, 12, 13, 15, 17, 19, 20** (13 = Eternal Howl of the Dead + Unbound Twinkle Toes; 15/17/19/20 = Unbound Twinkle Toes only; Resonant 11/12 come from its design spec).
7. Base class features end at level 12. Levels 13–20 grant nothing from the base class except Feats at 16 and 20 (Arcane Overflow / Mastery / Veil / Avatar exist in the stats but are NOT granted by any progression: do not list them).

**[index] Exact in-game wording for shared terms:**
- **Woven Spell Slots** (resource panel name; singular "Woven Spell Slot"). In-game description: "Used to cast Arcana spells."
- **Long Rest**, **Short Rest** (capitalised, always).
- Passives call class spells **Arcane spells** ("casting an Arcane spell", "your Arcane spells deal…"). Use "Arcane spell" exactly as the passive text does; in your own prose "spells" is fine.
- **Aspect Awakening** (the rule). Visible level-3 passive: `<N> - <Card>: Awakening` with Arabic numerals and a spaced hyphen — "0 - The Fool: Awakening", "2 - The High Priestess: Awakening", "17 - The Star: Awakening", "13 - Death: Awakening" (Resonant per spec: "14 - Temperance: Awakening"). Status while awakened: "<N> - <Card>: Awakened I / II / III". Progress status: "Awakening Progress". Tier labels: **Tier I** (level 3), **Tier II** (level 7), **Tier III** (level 12); Tier III is always named "Aspect of <X>". Everything lasts **until combat ends**; full text "Awakened as the Aspect of Curiosity until combat ends." Tiers stack ("Each goal you reach awakens one more tier.").
- **Always Prepared** (capitalised). Every subclass spell is Always Prepared. Base class exception: the six level-1 Weaver Hand spells (Guide, Command, Chill, Burn, Blind, Electrify) and the six Weave Knowledge spells (level 2) go into the spellbook as spells you **prepare** (they lack the Always Prepared flag; the class must prepare spells).
- **Upcasting**: all Woven Spell Slots share one level, so a spell is always cast with a slot of your current Slot Level and uses that level's values (a level 1 spell cast by a level 9 Arcana uses a level 5 slot). In feature text use `p.upcast` starting "**At higher levels:**" and say it per slot level ("2d8 with a level 2 slot … 6d8 with a level 6 slot") or a `table.scaling` (Slot level → value). Slots stop at level 6.
- Spell chips: "Cantrip", "Level N Spell" (use "Level 1 Spell", not "1st-level").

## Questions for another page
*(Format: `[from → to] question` · answer below it as `↳ [to] answer`)*

## Decisions and conventions
*(Anything you settled that others should copy: wording, table layout, how you show upcasting…)*

- **[index] index.html is written.** Its Aspect table links to `<page>.html#awakening` and its destiny cards to `<page>.html`; keep those ids. Per destiny it shows: goal in one line, goals "Tier I · II · III", tier names. Resonant row uses the spec: "Make the moods you weave react", 3 · 5 · 7 reactions, Attunement · Harmony · Aspect of Empathy; tell me (or fix the row) if your page differs. Destiny-card roles used: Unbound "Unarmed striker", Deceiver "Controller and burst caster", Starchild "Healer and support", Eternal "Frontline juggernaut", Resonant "Control and support". Base features link as `index.html#weaver-hand-spells`, `#weave-knowledge`, `#portent`, `#arcane-recovery`, `#third-eye`, etc. (each spell has a kebab id). Eternal starting armour written as "a breastplate" per [eternal]'s finding.

- **[resonant] Emblem SVG for the Resonant** (no PNG exists). Index writer: reuse it in the `.destiny` card
  (`.destiny-top svg` is already styled 3.2rem). Gold `#d8ac64` reads on the dark tarot face; on the light paper of a
  destiny card you may swap `stroke="#d8ac64"`/`fill="#d8ac64"` for `currentColor` and set `style="color:var(--gold)"`.
  ```html
  <svg viewBox="0 0 120 160" fill="none" stroke="#d8ac64" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round" role="img" aria-label="Two golden cups pouring a stream into each other">
    <path d="M60 8 L62.4 15.6 L70 18 L62.4 20.4 L60 28 L57.6 20.4 L50 18 L57.6 15.6 Z" stroke-width="1.6"/>
    <g transform="translate(36 52) rotate(32)"><ellipse cx="0" cy="0" rx="15" ry="4"/><path d="M-15 0 C-15 16 -7 23 0 23 C7 23 15 16 15 0"/><path d="M0 23 V35"/><path d="M-10 40 C-5 35 5 35 10 40 Z"/></g>
    <path d="M49 60 C61 70 55 92 76 109"/>
    <path d="M52 58 C65 68 60 90 79 108" stroke-width="1" opacity=".55"/>
    <circle cx="70" cy="86" r="1.3" fill="#d8ac64" stroke="none"/><circle cx="47" cy="84" r="1" fill="#d8ac64" stroke="none"/><circle cx="88" cy="94" r="1" fill="#d8ac64" stroke="none"/>
    <g transform="translate(82 112) rotate(-14)"><ellipse cx="0" cy="0" rx="15" ry="4"/><path d="M-15 0 C-15 16 -7 23 0 23 C7 23 15 16 15 0"/><path d="M0 23 V35"/><path d="M-10 40 C-5 35 5 35 10 40 Z"/></g>
  </svg>
  ```

- **[eternal] Spells that cost only a Woven Spell Slot and no action** (Eternal: Immortal Blood, Inescapable
  Destruction, Unbroken, Inured to Undeath): statline `Cast` = **No action**. Other casts written as the game does:
  "Action", "Bonus action". Durations "Until Long Rest or combat ends" when the status has both. Ranges: "Self",
  "Melee (1.5m)", "18m"; areas as "9m radius". Upcasting: one `p.upcast` sentence per the index convention.
- **[eternal] Progression table on a subclass page lists only that subclass's features**, plus the gold Feat chip at
  4/8/12/16/20; a level with only a feat reads `— Feat`. One line under the table points to `index.html#progression`
  for the base class features. (Copy if you agree.)
- **[eternal] Signature chapter id: `sorrow`** ("Sorrow"). Aspect chapter keeps `awakening`. The Aspect spell
  (The Final Toll) is an `article.feature` inside `#awakening`, id `the-final-toll`.

- **[deceiver] Spells that cost only a slot and no action** (Mirrored Self, Mirrored Spell, every "Ready: …" spell): statline `Cast` = **No action**. Bonus-action spells use chip-kind "Bonus Action Spell" and `Cast` = "Bonus action".
- **[deceiver] The Aspect's own once-per-combat spell** (unlocked at Tier I; mine is *The Veil Lifts*): I put it as an `article.feature` inside the `#awakening` chapter, after the `.tiers`, with chip-kind **"Aspect Spell"** and `Recharge` = "Once per combat". Same for the Tier III spell (*Ready: Which One?*, chip "Level 3 Spell"). Copy if your Aspect has these.
- **[deceiver] Tier boxes**: `tier-label` = "Tier I · <Tier name>", `tier-goal` = "Level 3 · <goal>". Progression links hidden tier passives (Two Pillars, Aspect of Doubt) to `#awakening`.
- **[deceiver] Cantrip damage that uses the game's cantrip scaling** (`D4Cantrip`): I write "1d4 Psychic damage, which grows with your level as cantrip damage does" rather than guess the 13–20 values.

- **[unbound] Signature chapters: `open-hands` ("Open Hands": unarmed die, Zephyr Strike, bonus-action economy) and `moving-air` ("Moving Air": the no-armour rule, AC, Twinkle Toes/Feather Fall table, defence layers).** Aspect spell *Leap of Faith* is an `article.feature` inside `#awakening`, id `leap-of-faith`, chip "Aspect Spell" (same as deceiver/eternal). Repeated upgrades of a passive (Twinkle Toes, Feather Fall) get a short article with a second chip "Improved" and no id; only the first entry carries the id.
- **[unbound] Leveled bonus-action spells keep chip-kind "Level N Spell"** (the level drives upcasting) with `Cast` = "Bonus action"; "Combat only" is an extra chip for spells with `Requirements Combat`. Zephyr Strike (not a spell) uses chip-kind "Bonus Action".

## File vs Context disagreements found
*(The files win. List them so the knowledge base can be fixed later.)*

- **[index]** Hit points: Context 03 §2 says 10 + 6/level; ClassDescriptions has BaseHp 6, HpPerLevel 4.
- **[index]** Woven Spell Slots totals: Context 02 §4 / 03 §3 (2,4,6,7,9,10,…,22) disagree with Progressions.lsx (2,4,6,8,10,12,14,16,18,20,21,22, then flat 22 for 13–20). In-band levels add +2, not +1.
- **[index]** Base-class level table (Context 03 §3, §4, §7) is stale: files give L1 = choose 2 of 4 Weaver Hand cantrips (Summon, Protect, Flame, Transmute) + all six Weaver Hand level 1 spells (Guide, Command, Chill, Burn, Blind, Electrify) as prepared spells + Arcane Familiar; L2 = Portent + six Weave Knowledge spells (Supernatural, History, Mind, Nature, Medicine, Art) as prepared spells + Arcane Recovery; L4 = Expert Divination + Arcane Lock + Arcane Unlock. No Detect Supernatural / Comprehend Languages choice. Weaver Hand spells are Level 1 (Context says 2), upcast variants _2–_6; Guide has a slot cost and no ritual cost.
- **[index]** Arcane Overflow (14), Arcane Mastery (16), Arcane Veil (18), Arcane Avatar (20): defined in Passive.txt but not granted by any progression. Context 03 §3/§5 lists them as class features.
- **[index]** Context 02 §2 / 03 §2 "all class spells Always Prepared": not true for the two base lists above (AddSpells without AlwaysPrepared; ClassDescriptions MustPrepareSpells = true).
- **[index]** Status COMPREHEND_MIND description says "Investigation" check, but its boost (and the spell text) is Insight.
- **[eternal]** Skill list (SkillLists.lsx "The Eternal Skill List"): Athletics, Intimidation, Medicine, History, Nature, **Arcana**, Religion, Survival. Context `subclasses/eternal.md` §2 has Investigation instead of Arcana.
- **[eternal]** Ability preset (AbilityDistributionPresets.lsx): STR 13 · DEX 8 · CON 15 · INT 15 · WIS 10 · CHA 10. Context says STR 15 · DEX 10 · CON 15 · INT 13 · WIS 10 · CHA 8.
- **[eternal]** Starting armour "Eternal's Plate" is a **Breastplate, Medium Armour proficiency group, AC 16 (+Dex, max 2)**, not heavy armour as Context says (only the stat entry name says Heavy). Gear also includes Maul, Shoes, 2 Potions of Healing, Scroll of Revivify, camp clothes.
- **[eternal]** Hemorrhage (in the files, not Context): tooltip/description show **4d8** Necrotic but the spell actually deals **2d10** (half on a save). Gaping Wounds + Hemorrhage apply on a save too. The page uses 2d10. Hemorrhage re-deals the full stored HP loss (no halving); Context says "half damage on a save" only for the initial hit, which matches.
- **[eternal]** Hemoplague: tooltip shows a Constitution save, but the spell rolls a **melee spell attack**; the Constitution saves happen each turn on the poison stages. The page says melee spell attack.
- **[eternal]** Progressions L17 has `PassivesRemoved: Arcana_Passive_Unbroken`; that passive only comes from the Unbroken status, so the row does nothing visible. Not on the page.
- **[eternal]** Realm of Death: Banished lasts 3 turns, the realm (aura, Difficult Terrain, Vulnerable to Necrotic, 2d6 Cold / 2d6 Acid) 4 turns; matches Context. Death Ward / Indestructible / Death's Aspect / Hemoplague / Immortal Blood etc. gain nothing from higher slots (upcast variants change only the cost).

- **[deceiver]** Skill list: Context `subclasses/deceiver.md` §2 lists Intimidation; SkillLists.lsx "The Witch Skill List" has **Arcana** instead (Deception, Insight, Arcana, Performance, Persuasion, Perception, History, Investigation).
- **[deceiver]** Context §3 "Applying a status never detonates [the Sigil]": not quite. SIGIL's RemoveConditions also fire when any ETHEREAL_CHAINS / MIMIC_ETHEREAL_CHAINS status lands, so Ethereal Chains detonates a Sigil even before its damage.
- **[deceiver]** Context §3 "Sigil marks for 6 turns": ARCANA_Status_Sigil.txt applies SIGIL with duration **-6.0** (negative), so the real duration is unclear. The page states no duration; needs an in-game check.
- **[deceiver]** File-internal: Mimic: Ethereal Chains tooltips (TooltipDamageList 3d6 base, 6d6/7d6/8d6 at _4/_5/_6) disagree with the statuses it applies (MIMIC_ETHEREAL_CHAINS 1d6, _4 3d6, _5 4d6, _6 5d6 per hit). Page follows the statuses ("works like the original at the same slot level").
- **[deceiver]** File-internal: the in-game subclass description says Doubles "shatter when struck", but a Double destroyed by an enemy does not Shatter (it gives the killer 1 Doubt); Shatter is the Double's own action. Page quotes the description verbatim and explains the real rule in The Veil.
- **[deceiver]** Context §2 "Starting gear" omits the 2 Potions of Healing and the Scroll of Revivify that EQP_CC_Deceiver also gives.

- **[starchild] Page done** (`starchild.html`). Followed index numbers (HP 6 + 4/level, Woven Slots 2…22) and the eternal/deceiver conventions: `Cast` "Bonus action" / "No action", "Melee (1.5m)", areas "N m radius", Aspect spell (*Wish Upon a Star*) as `article.feature` in `#awakening` with chip "Aspect Spell", feat-only rows `— Feat`, hidden tier passives linked to `#awakening`. I kept chip-kind "Level N Spell" for bonus-action spells too (index convention) rather than "Bonus Action Spell".
- **[starchild] Signature chapters:** `healing-loop` ("The Healing Loop": Starcall → Rejuvenation → Astral Infusion, with a `table.scaling` of values per Slot Level) and `sun-and-moon` ("Sun, Moon and Stars": spells by purpose + a Concentration box). Glossary defines "Arcane spell" as "Any spell the Arcana class grants you".

## File vs Context disagreements found (starchild)

- **[starchild]** Ability preset (AbilityDistributionPresets.lsx, Starchild): STR 8 · DEX 10 · CON 13 · INT 15 · WIS 15 · CHA 10. Context `subclasses/starchild.md` §2 says DEX 13 · CON 15 · INT 10.
- **[starchild]** Context §2 starting gear omits the 2 Potions of Healing, Scroll of Revivify, shoes and camp clothes in EQP_CC_Starchild.
- **[starchild]** Cosmic Omen: the progression adds the passives (CosmicOmen, _Rest, _Ability) but **no `ActionResource(CosmicOmen,…)`** anywhere in the mod (vanilla Circle of the Stars grants `ActionResource(CosmicOmen,3,0)` with them). The Weal/Woe reactions and the Ability Check spell all cost a CosmicOmen charge, so the feature may have 0 uses in game. Page describes it without a use count. Needs an in-game check.
- **[starchild]** Recast Final Spark: the description promises "If a creature is killed by this arcane power, all your ability cooldowns are reset", but nothing in Stats, Osiris or the scripts implements a reset (the spell has empty SpellProperties). Page leaves that sentence out. Context §6 also says the recast "Ends Final Spark"; the files don't do that either (it stays castable while FINAL_SPARK_OWNER lasts, 2 turns).
- **[starchild]** File-internal: STARCALL_SLOW uses `ActionResourceMultiplier(Movement,30,0)` (speed becomes 30%, i.e. -70%), while the spell and status text say "reduced by 30%" (REJUVENATION uses 130 for +30%, so 70 would match the text). Page keeps the in-game 30%.
- **[starchild]** Context §8 says Moonlit "slows the target": the slow is the vanilla Ray of Frost status, -3m movement speed for 1 turn. Undying Hope goes to the Starchild too, not only allies; the first one downed spends it for everyone.
- **[starchild]** Astral Fortitude does not affect the caster (`not Self()`), and a Downed ally in range regains 1 hit point. Not in Context.

- **[unbound]** Skill list (SkillLists.lsx "The Wanderer Skill List"): Acrobatics, Animal Handling, **Arcana**, Nature, Perception, Survival, Sleight of Hand, Athletics. Context `subclasses/unbound.md` §2 has Stealth instead of Arcana.
- **[unbound]** Ability preset: STR 10 · DEX 15 · CON 10 · INT 15 · WIS 13 · CHA 8. Context says STR 10 · DEX 15 · CON 13 · INT 8 · WIS 15 · CHA 10.
- **[unbound]** Starting gear also has Shoes, camp clothes, 2 Potions of Healing and a Scroll of Revivify (Context: robe only). Robe is named "Unbound's Robe".
- **[unbound]** File-internal: Gale Burst tooltip damage (`TooltipDamageList` = GaleBurst_Damage level map, 1d8/2d8/3d8…) disagrees with the damage it deals (SpellSuccess 1d10 at slot 1–2, 2d10 at 3–4, 3d10 at 5–6). Page uses 1d10/2d10/3d10. Gale Burst also applies the vanilla `MARTIAL_ARTS_BONUS_UNARMED_STRIKE`, which shares its StackId with ZEPHYR_STRIKE (may overwrite it).
- **[unbound]** Ready: Gale Deflection: Context says "up to 3 uses per round"; in the shared files the uses resource (`ArcanaReactGaleDeflection`, max 3) replenishes **Never** and is cleared when combat ends; each cast adds 1. Page follows the spell text ("You can hold up to 3 uses").
- **[unbound]** Context lists Leap of Faith as a deck-only created card; it is also unlocked by the `ASPECT_AWAKENED_FOOL` status (Tier I) in the shared stats, so it is on the page. Its Thunder damage uses GaleBurst_Damage by character level (1d8 at 3–4, 2d8 5–8, 3d8 9–12, 4d8 13–16, 5d8 17–20).
- **[unbound]** Context §6 Gale Burst "half damage on a success" matches; Evasive Flow lasts 1/2/3 turns at slot 3–4/5/6 (page: 2 at level 9–10, 3 from 11); Thunderclap has only base (3 turns) and _6 (5 turns) variants, so it always lasts 5 turns when gained at level 11.
- **[unbound]** Interrupt text for Gale Deflection (`h402ace5b…`) still says "you use an Arcane Card to Deflect the Missile"; the passive/status text says "you can Deflect the Missile". Page uses the latter.

- **[resonant] Page done** (`resonant.html`). Uses index numbers (HP 6 + 4/level, Woven Slots 2…22) and the eternal/deceiver conventions (`— Feat` rows, "No action" for Ready: Compassion, "N m radius", Aspect spell *The Two Cups* as `article.feature` id `the-two-cups` inside `#awakening`, chip "Aspect Spell", deceiver's cantrip-scaling wording). Signature chapters: `the-wheel` ("The Wheel of Emotions": inline SVG wheel, Surge → mood → reaction, distance table) and `reactions` (8×8 reaction chart, feelings by distance, overwhelming emotions, Catharsis). Index row matches: 3 · 5 · 7 reactions, Attunement · Harmony · Aspect of Empathy. Spec-only parts written as implemented: Heartstring, Read the Room, Turn the Wheel, Emotional Contagion, Ready: Compassion, Equanimity, The Two Cups, the whole Awakening. The spec's two undesigned level-12 passives are left out.

## File vs Context disagreements found (resonant)

- **[resonant]** File-internal: Weave Surge: Sadness text says the target "can only take either an action or a bonus action", but EMOTION_SADNESS only halves movement (no action-limiting boost). Page keeps the in-game text; needs an in-game check.
- **[resonant]** File-internal: EMOTION_ANGER, EMOTION_RAGE and FEELING_ENVY also block reactions (`ActionResourceBlock(ReactionActionPoint)`); their texts don't say so. Page follows the texts.
- **[resonant]** Spec §7.2 Empathic Sight also shows every creature's state on its portrait; the passive in the files is only Advantage on Insight. Page follows the file.
- **[resonant]** english.xml still holds unused older strings (Weave Surge: Fury, Emotion: Fury, Mood: Afraid / Melancholic / Reckless / Sickened / Disoriented / Euphoric, an old Disgust description). Harmless, but worth cleaning.
- **[resonant]** Context 07 lists only the "signature cards and Temperance Awakening" as missing; the Story goal `ARCANA_Aspect_Temperance.txt` also does not exist yet, and there is no Resonant level 12 entry in the progression.
