---
title: Mod Terminology
tags:
  - arcana/localization
---

# Mod Terminology and Naming Conventions

This mod's own invented proper nouns — no official Larian translation exists, so **consistency across this mod's own files** is what matters. Reuse the exact same rendering every time an English term recurs. Full ~232-row table (with `PENDING` gap-tracking per language): `GLOSSARY.md` §2, see [[Vanilla Terms Glossary]]. Debug/internal-only labels (`DEBUG STATUS`, `_TECHNICAL` suffixes) are excluded — players never see them.

## Internal IDs vs. display names — don't confuse these

Internal identifiers (`ArcaneEssence`, `Target_IND_MageHand`, `ARCANE_SHARDS`) are **never translated or shown to players** — only the `DisplayName` handle resolved from loca is. When adding a new term, translate the **display string**, never the code identifier. See [[Class Overview#Naming conventions (mod-wide)]] for the full identifier convention (`IND_` prefix, `SCREAMING_SNAKE_CASE` statuses, `_EX` suffix).

**Two different resources, two different names — don't merge them:**
- `ArcaneEssence` → displayed **"Arcane Cards"**
- `ArcaneShards` → displayed **"Arcane Shards"**

## Core proper nouns (translated, high-frequency — reuse exactly)

| English | PT-BR | FR | DE | RU |
|---|---|---|---|---|
| Arcane Cards | Cartas Arcanas | Cartes arcaniques | Arkane Karten | Тайные карты |
| Arcane Shards | Fragmentos Arcanos | Fragments arcaniques | Arkane Scherben | Тайные осколки |
| Arcane Familiar | Familiar Arcano | Familier arcanique | Arkaner Vertrauter | Тайный фамильяр |
| Arcane Mastery | Maestria Arcana | Maîtrise arcanique | Arkane Meisterschaft | Тайное мастерство |
| Arcane Overflow | Transbordamento Arcano | Débordement arcanique | Arkaner Überlauf | Тайный избыток |
| Arcane Veil | Véu Arcano | Voile arcanique | Arkaner Schleier | Тайный покров |
| Arcane Avatar | Avatar Arcano | Avatar arcanique | Arkaner Avatar | Тайный аватар |
| Bastionbreaker | Quebra-Bastiões | Briseur de bastion | Bastionsbrecher | Крушитель бастионов |
| Untethered | Livre | Libéré de toute attache | Ungebunden | Без оков |
| Unbroken | Inquebrável | Inébranlable | Ungebrochen | Несломленный |
| Wish | Desejo | Souhait | Wunsch | Желание |
| Withdraw | Retirada | Retrait | Rückzug | Отступление |

## Subclass display names (see [[Subclasses Comparison]] for mechanics)

**From ARC-0021 (Owner, 2026-10-16), English:** The Windborn (internal Unbound) · The Veilwalker (Deceiver) · The
Palerider (Eternal) · The Heartsong (Resonant); Starchild, Kingmaker and Lionheart unchanged. The table below is the
game today; each subclass's row changes with its build, and the translations in the localization round (ARC-0013).

| English | PT-BR | FR | DE | RU |
|---|---|---|---|---|
| Arcane Spells: The Unbound | Magias Arcanas: O Desprendido | Sorts arcaniques : L'Affranchi | Arkane Zauber: Der Ungebundene | Заклинания Арканы: Освобождённый |
| Arcane Spells: The Deceiver | Magias Arcanas: O Enganador | Sorts arcaniques : Le Trompeur | Arkane Zauber: Der Täuscher | Заклинания Арканы: Обманщик |
| Arcane Spells: The Starchild | Magias Arcanas: A Criança das Estrelas | Sorts arcaniques : L'Enfant des étoiles | Arkane Zauber: Das Sternenkind | Заклинания Арканы: Дитя звёзд |
| Arcane Spells: The Eternal | Magias Arcanas: O Eterno | Sorts arcaniques : L'Éternel | Arkane Zauber: Der Ewige | Заклинания Арканы: Вечный |

## Numbered/tarot-style feature names

Some capstone features use a `N - Name` tarot-card pattern — keep the number, translate the name, keep the punctuation style (the mod uses a spaced hyphen or em-dash inconsistently per language; PT-BR/RU/PL use `—`, most others use `-`):

| English | PT-BR |
|---|---|
| 0 - The Fool | 0 — O Louco |
| 3 - The Empress | 3 — A Imperatriz |
| 13 - Death | 13 — A Morte |
| 17 - The Star | 17 — A Estrela |

## The Resonant (reviewed 2026-10-16 ARC-0014 — R49–R68 terms; rows marked ★ reach the game with the build)

English is final in game; the other 15 languages have no Resonant strings yet (Localization, pending).

| English | Meaning | Never |
|---|---|---|
| Weave Surge: <Emotion> | The 8 spells that pour one emotion (Joy, Trust, Fear, Surprise, Sadness, Disgust, Anger, Anticipation) — the game today | — |
| ★ Weave Surge | The container that holds the eight emotions, each named by its emotion alone (R54) | "Weave Surge: <Emotion>" after the build |
| ★ Opposites *(working name)* | The level-3 passive that teaches Catharsis (R60) | — |
| ★ Mental Fatigue · Irresistible Dance | Vanilla conditions that Emotional Overload applies; names kept as in the game (R51, R68) | — |
| Emotion: <Emotion> (peak) | 1-turn state a Surge applies; changes what the creature does | — |
| Mood: <Mood> | 5-turn echo left by a peak (Serene, Accepting, Apprehensive, Distracted, Pensive, Bored, Annoyed, Interested) | — |
| Feeling: <Feeling> | Two emotions braided (24 dyads of Plutchik's wheel) | — |
| Catharsis | Opposite emotions snap: damage to enemies, healing to allies | — |
| Emotional Alchemy | The core rule (reaction by distance on the wheel) | — |
| Overload / Overloaded | The meter of what the Resonant feels / its full state (★ a Mental Fatigue variant on the Resonant, R51) | Overflow (base class: Arcane Overflow) |
| Emotional Overload | The ultimate that spends the full meter | Overflow |
| Temper · Heartstring · Emotional Contagion · Ready: Compassion · Shared Heart · The Two Cups | The Resonant's other cards | Turn the Wheel (retired, R4) |
| Resonance · Harmony · Aspect of Empathy | Awakening tiers I · II · III | Attunement (deck keyword Attuned) |
| The Resonant | The subclass | Heartweaver (retired working name) |

## The Kingmaker (reviewed 2026-10-15 ARC-0008 — propagation, 00.08)

English is final in game (`32.01/Kingmaker.md`); the other 15 languages have no Kingmaker strings yet (Localization, pending).

| English | Meaning | Never |
|---|---|---|
| the Wheel · on the Wheel | The Kingmaker's mechanic; *Fortune's wheel* (lowercase) only in flavour | — |
| Rising · Reigning · Falling · Fallen | The four positions; tooltips open with *Regnabo · Regno · Regnavi · Sum sine regno* (keep the Latin untranslated) | — |
| King · Regent | The ally wearing the crown · other Reigning allies | — |
| Crossing · Hubris | Damage to an enemy entering Fallen beside a Reigning ally · an enemy that reigned | — |
| The Court · Convene the Court · office · appoint | Offices named before battle | — |
| King's Hand, Lord Commander, Master of Healing, Master of Laws, Master of Secrets, Master of Coin, Master of Ships | The seven offices (SP101) | Hand of the King |
| Spoke of the Wheel, Coronation, Dethrone, Turn the Spoke, Atropos' Cut, Peripeteia, Usurp, Wheel of Ixion, The Wheel Stops, Rota Fortunae, Ready: Foreseen | The cards | Crown, Cast Down, Nudge (renamed SP102) |
| The Rota, The Crossing, Hubris, Succession, Fortune's Reach | The passives | — |
| Tyche · Nemesis · Aspect of Anticipation | Awakening tiers I · II · III | — |
| The Kingmaker | The subclass | Spinner (retired working name) |

## The Deceiver (reviewed 2026-10-16 ARC-0019 — DV18–DV32 terms; ARC-0020 checked, no change; rows marked ★ reach the game with the build)

English is final in game for the unmarked rows (`32.01/Deceiver.md`); the other 15 languages have no Deceiver strings
yet (Localization, pending). Internal ids keep the old names (`MirrorImage`, `SigilofMalice`, `SIGIL`, `Distortion`,
`EtherealChains`, `Mimic`, `Shatter`, `Empress`) — never translate or show them.

| English | Meaning | Never |
|---|---|---|
| The Veil | The core rule: every lie an enemy believes plants Doubt; at the third, it is Deluded (DV19) | — |
| Double · Double of the Veil | A 1-HP illusion of the Deceiver with its own turn | clone, Mirror Image (as a creature) |
| Doubt · Deluded | The stacks on an enemy · the Confused state at the third stack | — |
| ★ Eidolon | The card that summons Doubles (the cloud-Helen) | Mirror Image |
| ★ Seed of Doubt · ★ Seed | The card · the status it lays, which bursts on her next Arcane damage | Sigil of Malice, Sigil, mark |
| ★ Veilstep | The teleport that leaves a Double behind | Distortion |
| ★ Binding Falsehood | The binding card (Restrained) | Ethereal Chains |
| ★ Twice-Told · ★ Twice-Told: <Card> | The bonus-action recast · its per-card copies | Mimic, Mimic: <Card> |
| ★ Splinter | A Double's burst (3 m, Doubt) | Shatter (vanilla spell name) |
| ★ Reflected Seed · ★ Reflected Falsehood | The Doubles' half-strength copies of her cards (Two Truths) | Mirror: Sigil of Malice, Mirror: Ethereal Chains |
| ★ Splinter on Command (DV31) | Her bonus action, a deck card: one Double splinters now (DV24, DV32) | — |
| Withdraw · Unveil · Dismiss | Swap with Veilstep's Double · a Double swaps with her · a Double ends without a burst | — |
| Malicious Whispers · Paranoia | The cantrip · its no-reactions status on a Seeded target | — |
| Faceless · Friends | The two utilities (DV26) | Faux Amis (retired), Telepathy (leaves, DV26) |
| Veiled Prison · Marionette · Grand Deception · Mirrored Spell · Mirrored Self · Ready: Which One? · The Veil Lifts | Her other cards | Hostile Takeover, Mental Prison, Hypnotic Gaze (retired) |
| Two Truths · Unveil | Passives at 5 and 9 | — |
| 2 - The High Priestess · Veiled · Two Pillars · Aspect of Doubt | Awakening and tiers I · II · III | Empress, Aspect of Love |
| The Deceiver | The subclass | — |

## The Windborn (reviewed 2026-10-17 ARC-0022 — WB0–WB48 terms; rows marked ★ reach the game with the build)

English is final in game for the unmarked rows (`32.01/Unbound.md`). Internal ids keep the old names (`Unbound`, `Fool`,
`TwinkleToes`, `Weightless`, `FlowingStrikeZephyr`) — never translate or show them.

| English | Meaning | Never |
|---|---|---|
| ★ The Windborn | The subclass (WB0) | The Unbound (old display name) |
| ★ The Open Road | The core rule: the wind marks every enemy you touch and carries you to the ones it hasn't touched (WB27) | Flowing Strikes: Zephyr |
| ★ Windswept | The mark on an enemy; it can't make opportunity attacks | marked, swept (as a status name) |
| Zephyr Strike · ★ Rush | The signature bonus-action strike · its carry to an unmarked enemy | — |
| ★ Breeze · Gale · Storm · Hurricane | Zephyr's ranks (Beaufort) at 1 / 4 / 8 / 12 | Force 1–12 as numbers |
| ★ Aeolus' Bag · ★ Boreas · ★ Notus · ★ Eurus | The ultimate · the North, South and East Winds | Bag of Winds, Aeolus's Bag |
| ★ The Calm | The Aspect card | Dead Calm |
| ★ Where the Winds Meet | The capstone | Vortex, Tornado |
| ★ Weightless | The movement passive by rank | Twinkle Toes, Feather Fall (vanilla spell name) |
| ★ The First Step · ★ Fellow Travellers · ★ Into the Storm | Awakening tiers I · II · III | Wanderlust, Restless Wind, Aspect of Curiosity (as a tier) |
| 0 - The Fool | The Arcanum and its Awakening passive | — |
| Gale Burst · Wind Blast · Wind Whispers · Flow State · Ready: Gale Deflection · Storm Fists · Untethered · Leap of Faith | Her cards | Thunderclap, Evasive Flow (retired) |
| Be the Leaf · Flowing Strikes · Flowing Assault · Magic Strikes · Empty State | Her passives | Momentum, Eye of the Storm (retired) |

## The Starchild (reviewed 2026-10-16 ARC-0023 — SC0–SC32 terms; 2026-10-17 ARC-0025 — SC33–SC36 sizes, no new term; stage 1 probes, no change; rows marked ★ reach the game with the build)

English is final in game for the unmarked rows (`32.01/Starchild.md`); the other 15 languages carry the 3.1 kit's old
strings. Internal ids keep the old names (`Starcall`, `AstralInfusion`, `LunarWisp`, `SolarPurge`, `Starbreath`,
`LunarAegis`, `StarRadiance`, `Wish`, `MoonGravity`, `Equinox`, `AstralFortitude`, `SolarFlare`, `StellarGrace`,
`LucentSingularity`, `WishUponAStar`, `StellarAnchor`, `REJUVENATION`) — never translate or show them. Each card is a
container with three children (Stars · Sun · Moon): translate the container and every child name.

| English | Meaning | Never |
|---|---|---|
| ★ Hymn · ★ Sing a Hymn · ★ Hymn of the Stars / of the Sun / of the Moon | The daily choice of one light, once per long rest · the utility that makes it · the three lights (SC3) | path, Prayer, Oath, Vow, Invoke |
| ★ Unsung | Her state after a long rest until she sings (SC5) | Dim Light, Silent Sky |
| ★ Dusk · ★ Nightfall · ★ Dawn | The mark on an ally below half · below a quarter of their hit points · her heal that answers Nightfall (SC9, SC10) | Darkest Hour, Falling Star |
| ★ answer (a mark) | Her heal consumes the mark and is stronger for it | cure, cleanse (for a mark) |
| ★ Comet (Shooting Star · Sunspark · Crescent Dart) · ★ Afterglow | The strike · its status | Starcall, Rejuvenation |
| ★ Outpouring (Lodestar Balm · Noonday Pour · Rising Tide) | The signature heal, ranks I–III | Astral Infusion |
| ★ Hesperus (Hesperus · Last Ray · Moonrise) | The reaction card-passive | Lunar Wisp |
| ★ Cleansing Rain (Starwater · Sunshower · Moondew) | The cleanse | Solar Purge |
| ★ Rekindle (Nova · Phoenix Light · New Moon) | The revive (into Nightfall) | Starbreath |
| ★ Halo (Starshield · Corona · Moon Ring) | The defence for the wounded | Lunar Aegis |
| ★ Guiding Light (Polaris · Sun Dog · Moonpath) | The enemy mark | Star Radiance |
| ★ Elpis' Jar (Wishing Star · Midsummer · Harvest Moon) | The ultimate: answers every mark at once | Wish |
| ★ Tether (Starline · Solar Wake · Undertow) | The pull of an ally | Moon Gravity |
| ★ Stillness (Fixed Stars · High Noon · Midnight) | The control card (Silenced, then Restrained) | Equinox |
| ★ Long Twilight (Blue Hour · Golden Hour · Long Night) | The zone that moves Dusk to two thirds | Astral Fortitude |
| ★ Flare (Supernova · Solar Flare · Moonburn) | The fire card | Final Spark (leaves) |
| ★ Dawnbringer (Daystar · Sunrise · Moonset) | The capstone card | Stellar Grace |
| ★ Lantern (Wayfinder · Noonlight · Moonshadow) | The exploration cantrip | Lucent Singularity, Point of Light (working name) |
| ★ The Great Star | The Aspect card (Stars only) | Wish Upon a Star |
| ★ Light in the Dark | Passive at 10: her own Dusk empowers her heals | Stellar Anchor (leaves) |
| ★ Undying Hope · ★ Dazzled · ★ Tide · ★ Eclipse | Tier I passive · Stars condition (−1d4 attack) · the Moon's heal over time · Tier III | Moonlit, Sunlit, Beacon, Sunrise, Aspect of Hope (as Awakening words, they leave) |
| 17 - The Star | Awakening | — |
| The Starchild | The subclass (display name unchanged, ARC-0021) | — |

> Note (Lore Writer, 2026-10-15): the sections above describe the **pre-rework** mod (Arcane Cards, Arcane Shards).
> The whole file needs a rework pass — proposed as its own ticket.

## Known unresolved terminology issue

**`Crippling Pinch`** (the [[Base Class#Arcane Familiar — L1 (pick 1 of 7)|Crab familiar]]'s attack) points at the LSTag of the vanilla Crab familiar's attack, which in vanilla is actually called **`Maiming Pinch`** (`Beliscão Mutilante` in PT-BR). This mismatch propagates to all 14 non-English languages until fixed — check `GLOSSARY.md` for current status before assuming it's resolved.

## How to add a new term

1. Check [[Vanilla Terms Glossary]] first — is this actually a vanilla D&D/BG3 concept? If so, use Larian's official translation, not a new one.
2. If mod-original: check whether the term (or a close variant) already exists in `GLOSSARY.md` §2 or in the target language's `.xml` file — grep for the English term's other occurrences before inventing a rendering.
3. Once translated, the term becomes canon — every future occurrence of that English string must use the same translation. Add it to `GLOSSARY.md` (or flag it for the next regeneration pass) so it doesn't drift.
4. Check prose conventions against [[English Writing Style]] before finalizing the English source string itself.
