---
id: 42.04/Starchild
owner: Icon Artist
source: 21.04/Starchild/DESIGN.md §2.1 (card readings), §2.5 (colour), §4.1 (containers), §5–§8; 31.02/Starchild.md; icons in game (Stats `Icon`, dossier_texts.pl --icons, 2026-10-16)
reviewed: 2026-10-17 ARC-0023 — created (propagation, 00.08); containers (SC22, SC24), names (SC32); 2026-10-17 ARC-0025 — R1–R4 sizes (SC33–SC36): no change; 2026-10-17 ARC-0025 — stage 1 probes (_wip): no change
---

# 42.04 · Icon briefs — The Starchild

**State today:** the subclass icon exists (`42.02/class_and_subclasses/`); every Starchild spell and passive borrows a
**vanilla** icon, and nine entries share one: `Spell_Evocation_DancingLights` (Lunar Wisp card and passive, Wish Upon a
Star, the Awakening passive and its three tiers, Beacon and Aspect of Hope). Stellar Anchor uses
`PassiveFeature_TwinklingConstellations`.

**Containers (SC22):** each card is a container with three children; the children use **the container's icon** (same
icon, a different name per light). So one icon per card covers four spells; the Hymn shows on the status, not the
icon. No per-child icon unless a playtest says the hotbar can't tell the lights apart.

**Family style:** starlight on deep night blue — the subclass blue `#79baf8` with white and pale gold; the Star card's
eight-pointed star, the figure's two jugs and the poured water; Sun pieces warm gold, Moon pieces silver, Stars white.
Pipeline: source `42.01` → PNG `42.02/features/the starchild/` → DDS BC7 `42.03`; origin in
`00.06/ASSET_ORIGIN_REGISTER.md`.

| Icon | For | Subject · symbol | Palette | Replaces (vanilla today) | Priority |
|---|---|---|---|---|---|
| ICO_Starchild_SingAHymn | Sing a Hymn and the three Hymn statuses | An open mouth of light beneath a star, a sun and a crescent in a row | Blue, gold, silver | Cosmic Omen (vanilla, leaves) | **1** |
| ICO_Starchild_Unsung | Unsung (status) | The same three lights, dimmed, a faint flicker | Grey-blue | — (new) | 2 |
| ICO_Starchild_Dusk | Dusk (status, portrait) | A star rising over a half-dark horizon | Blue fading to violet | — (new) | **1** |
| ICO_Starchild_Nightfall | Nightfall (status, portrait) | A single star over a black horizon | Deep violet, one white point | — (new) | **1** |
| ICO_Starchild_Outpouring | Outpouring (signature) and its three children | Two jugs pouring light into an open hand | Blue + white | Spell_Evocation_HealingWord | **1** |
| ICO_Starchild_Comet | Comet and its children | A comet with a long tail striking down | White + blue | Spell_Evocation_GuidingBolt | **1** |
| ICO_Starchild_Afterglow | Afterglow (status) | A fading comet trail curling round a figure | Pale blue | — (Rejuvenation has none of its own) | 3 |
| ICO_Starchild_Hesperus | Hesperus (card-passive) | The evening star over a dusk horizon, a small hand reaching | Violet + gold point | Spell_Evocation_DancingLights (shared) | **1** |
| ICO_Starchild_CleansingRain | Cleansing Rain | Rain of light falling from a tipped jug | Blue + silver | Spell_Conjuration_ProduceFlame_Hurl | 2 |
| ICO_Starchild_Rekindle | Rekindle | A spark relit in a cupped pair of hands, a dark ring around it | Gold on night blue | Spell_Necromancy_Revivify | 2 |
| ICO_Starchild_Halo | Halo | A ring of light above a bowed head | Blue + white | Spell_Abjuration_ShieldOfFaith | 2 |
| ICO_Starchild_GuidingLight | Guiding Light | A pole star with a beam pointing down at a marked figure | White + blue | Spell_Evocation_CrusadersMantle | 2 |
| ICO_Starchild_ElpisJar | Elpis' Jar (ultimate) | An open jar, one star rising out of it and light spilling over | Gold rim, blue light | Spell_Evocation_MassHealingWord | **1** |
| ICO_Starchild_Tether | Tether | A thread of the Weave pulling a small figure toward a hand | Blue + silver thread | Spell_Abjuration_FreedomOfMovement | 2 |
| ICO_Starchild_Stillness | Stillness | A night sky frozen mid-turn, a hush sign of light | Silver + blue | Spell_Illusion_Silence | 3 |
| ICO_Starchild_LongTwilight | Long Twilight | A horizon held at dusk, sun and stars both visible | Violet + gold | Spell_Abjuration_Aid | 2 |
| ICO_Starchild_Flare | Flare | A burst of stellar fire from above | Gold + white | Spell_Evocation_FlameStrike | 2 |
| ICO_Starchild_Dawnbringer | Dawnbringer (capstone) | A sunrise breaking a dark horizon, a star fading into it | Gold on night blue | Spell_Abjuration_BeaconOfHope | **1** |
| ICO_Starchild_Lantern | Lantern (cantrip) and its three statuses | A figure holding a lantern that holds a star | Blue + warm light | Spell_Evocation_Daylight | 3 |
| ICO_Starchild_TheGreatStar | The Great Star (Aspect card) | The Star card's eight-pointed star over a pool — card art style | Gold, white, blue | Spell_Evocation_DancingLights (shared) | **1** |
| ICO_Starchild_LightInTheDark | Light in the Dark (passive) | A figure in shadow, a star shining brighter in her chest | Violet + white | PassiveFeature_TwinklingConstellations | 2 |
| ICO_Starchild_UndyingHope | Undying Hope (Tier I) | A falling figure caught by a thread of starlight | Blue + gold | — (part of Tier III today) | 2 |
| ICO_Starchild_Awakening | 17 - The Star: Awakening, its tiers and Eclipse | The Star card glowing, one light per tier lit; Eclipse: sun and moon overlapping with stars around | Gold + blue | Spell_Evocation_DancingLights (shared) | **1** |

Statuses kept vanilla until a status-icon pass is decided: Dazzled (Bane), Burning, the Moon's slow, Tide, the hidden
first-heal gate (no icon). Retired with the build, no brief: Final Spark and its Recast, Lucent Singularity, Stellar
Anchor, Wish Upon a Star, Moonlit, Sunlit, Beacon, Sunrise, Aspect of Hope.

Priority 1 = shared icons today (readability bug in the hotbar), the signature, the marks on the portrait, the ultimate,
the capstone, the daily ritual and the Aspect card. All briefs: **not started**.
