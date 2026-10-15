---
id: 42.04/Resonant
owner: Icon Artist
source: 21.04/Resonant/DESIGN.md §2.7 (colours, spectrum), §5; 31.02/Resonant.md; icons in game (Stats `Icon`, 2026-10-15)
reviewed: 2026-10-15 ARC-0002 — created (propagation, 00.08)
---

# 42.04 · Icon briefs — The Resonant

**State today:** the subclass icon exists (`42.02/class_and_subclasses/resonant.png`); every one of the 25 Resonant
spells, passives and tiers borrows a **vanilla** icon, and **9 share `Spell_Enchantment_CalmEmotions`** — the
hotbar can't tell Temper, Emotional Overload, The Two Cups and the passives apart. `42.02/features/the resonant/` is empty.

**Family style:** a pouring motif (cup, ewer, stream) in the subclass coral `#bd4f2b` / `#f39a78`; each Weave Surge in
its emotion's colour on Plutchik's wheel (the spectrum, DESIGN §2.7): Joy yellow · Trust light green · Fear dark green ·
Surprise cyan · Sadness blue · Disgust violet · Anger red · Anticipation orange.
Pipeline: source `42.01` → PNG `42.02/features/the resonant/` → DDS BC7 `42.03`; origin in `00.06/ASSET_ORIGIN_REGISTER.md`.

| Icon | For | Subject · symbol | Palette | Replaces (vanilla today) | Priority |
|---|---|---|---|---|---|
| ICO_Resonant_Surge_Joy | Weave Surge: Joy | A burst of light spilling from a cup | Yellow + coral | Spell_Enchantment_Heroism | 2 |
| ICO_Resonant_Surge_Trust | Weave Surge: Trust | Two hands clasped over one stream | Light green | Spell_Abjuration_ShieldOfFaith | 2 |
| ICO_Resonant_Surge_Fear | Weave Surge: Fear | A thread pulled taut around a shrinking figure | Dark green | Spell_Illusion_PhantasmalKiller | 2 |
| ICO_Resonant_Surge_Surprise | Weave Surge: Surprise | A cup knocked mid-pour, droplets frozen in air | Cyan | Spell_Enchantment_Enthrall | 2 |
| ICO_Resonant_Surge_Sadness | Weave Surge: Sadness | A single falling drop, threads going slack | Blue | Spell_Necromancy_RayOfInfeeblement | 2 |
| ICO_Resonant_Surge_Disgust | Weave Surge: Disgust | A cup turned away, stream recoiling | Violet | Spell_Conjuration_StinkingCloud | 2 |
| ICO_Resonant_Surge_Anger | Weave Surge: Anger | A boiling stream, threads snapping red | Red | Spell_Enchantment_CrownOfMadness | 2 |
| ICO_Resonant_Surge_Anticipation | Weave Surge: Anticipation | An open eye in the stream, poised | Orange | Spell_Transmutation_Longstrider | 2 |
| ICO_Resonant_Heartstring | Heartstring (cantrip) | A heart hanging from one plucked thread | Coral | Spell_Enchantment_ViciousMockery | 3 |
| ICO_Resonant_Temper | Temper | A stream flowing back up into its cup | Coral + the spectrum | Spell_Enchantment_CalmEmotions (shared) | **1** |
| ICO_Resonant_EmotionalOverload | Emotional Overload (ultimate) | A cup overflowing with every colour into one figure | Full spectrum, dark ground | Spell_Enchantment_CalmEmotions (shared) | **1** |
| ICO_Resonant_EmotionalContagion | Emotional Contagion | One figure's colour rippling to the figures around it | Coral | Spell_Enchantment_Friends | 3 |
| ICO_Resonant_ReadyCompassion | Ready: Compassion | A hand catching a falling drop | Indigo (Compassion, DESIGN §2.6) | Spell_Abjuration_Sanctuary | 3 |
| ICO_Resonant_SharedHeart | Shared Heart (capstone) | Several hearts joined by one braided thread | Coral + gold | Spell_Abjuration_WardingBond | 2 |
| ICO_Resonant_TheTwoCups | The Two Cups (Aspect card) | The Temperance figure pouring between two cups — card art style | Gold, coral, the spectrum | Spell_Enchantment_CalmEmotions (shared) | **1** |
| ICO_Resonant_EmotionalAlchemy | Emotional Alchemy | Two coloured streams braiding into a third | Two spectrum colours | Spell_Enchantment_CalmEmotions (shared) | **1** |
| ICO_Resonant_EmpathicSight | Empathic Sight | An eye with threads of colour in the iris | Coral | Spell_Divination_SeeInvisibility | 3 |
| ICO_Resonant_Overload | Overload (meter) | A cup filling to the brim, cracking | Coral → red | Spell_Enchantment_CalmEmotions (shared) | **1** |
| ICO_Resonant_ComplexFeelings | Complex Feelings | Second ring of a wheel lighting up | Spectrum | Spell_Enchantment_Bless | 3 |
| ICO_Resonant_Overwhelm | Overwhelm | One colour flooding the whole wheel | Spectrum, one dominant | Spell_Illusion_PhantasmalKiller | 3 |
| ICO_Resonant_MixedFeelings | Mixed Feelings | Outer ring of the wheel, opposite colours touching | Spectrum | Spell_Enchantment_Confusion | 3 |
| ICO_Resonant_Awakening | 14 - Temperance: Awakening and its tiers (Resonance, Harmony, Aspect of Empathy) | The Temperance card glowing, one cup per tier | Gold + coral | Spell_Enchantment_CalmEmotions (shared) | **1** |

Priority 1 = the six that today share one icon (readability bug in the hotbar). Statuses (peaks, moods, feelings)
keep vanilla icons until a status-icon pass is decided.
