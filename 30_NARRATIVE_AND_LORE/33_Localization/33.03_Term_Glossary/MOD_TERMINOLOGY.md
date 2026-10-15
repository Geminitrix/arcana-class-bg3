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

## The Resonant (reviewed 2026-10-15 ARC-0002 — propagation, 00.08)

English is final in game; the other 15 languages have no Resonant strings yet (Localization, pending).

| English | Meaning | Never |
|---|---|---|
| Weave Surge: <Emotion> | The 8 spells that pour one emotion (Joy, Trust, Fear, Surprise, Sadness, Disgust, Anger, Anticipation) | — |
| Emotion: <Emotion> (peak) | 1-turn state a Surge applies; changes what the creature does | — |
| Mood: <Mood> | 5-turn echo left by a peak (Serene, Accepting, Apprehensive, Distracted, Pensive, Bored, Annoyed, Interested) | — |
| Feeling: <Feeling> | Two emotions braided (24 dyads of Plutchik's wheel) | — |
| Catharsis | Opposite emotions snap: damage to enemies, healing to allies | — |
| Emotional Alchemy | The core rule (reaction by distance on the wheel) | — |
| Overload / Overloaded | The meter of what the Resonant feels / its full state | Overflow (base class: Arcane Overflow) |
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

> Note (Lore Writer, 2026-10-15): the sections above describe the **pre-rework** mod (Arcane Cards, Arcane Shards).
> The whole file needs a rework pass — proposed as its own ticket.

## Known unresolved terminology issue

**`Crippling Pinch`** (the [[Base Class#Arcane Familiar — L1 (pick 1 of 7)|Crab familiar]]'s attack) points at the LSTag of the vanilla Crab familiar's attack, which in vanilla is actually called **`Maiming Pinch`** (`Beliscão Mutilante` in PT-BR). This mismatch propagates to all 14 non-English languages until fixed — check `GLOSSARY.md` for current status before assuming it's resolved.

## How to add a new term

1. Check [[Vanilla Terms Glossary]] first — is this actually a vanilla D&D/BG3 concept? If so, use Larian's official translation, not a new one.
2. If mod-original: check whether the term (or a close variant) already exists in `GLOSSARY.md` §2 or in the target language's `.xml` file — grep for the English term's other occurrences before inventing a rendering.
3. Once translated, the term becomes canon — every future occurrence of that English string must use the same translation. Add it to `GLOSSARY.md` (or flag it for the next regeneration pass) so it doesn't drift.
4. Check prose conventions against [[English Writing Style]] before finalizing the English source string itself.
