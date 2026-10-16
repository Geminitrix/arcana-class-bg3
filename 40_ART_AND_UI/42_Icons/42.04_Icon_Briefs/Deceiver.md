---
id: 42.04/Deceiver
owner: Icon Artist
source: 21.04/Deceiver/DESIGN.md §2.1 (card readings), §2.5 (colour), §5–§8; 31.02/Deceiver.md; icons in game (Stats `Icon`, dossier_texts.pl --icons, 2026-10-16)
reviewed: 2026-10-16 ARC-0019 — created (propagation, 00.08); new names (DV29), Splinter on Command (DV24, DV31), Tier III burst (DV21); 2026-10-16 ARC-0019 — DV32 checked, no change; 2026-10-16 ARC-0020 — sizes approved (25), names patch drafted; no change; 2026-10-16 ARC-0021 — display name checked, no change; 2026-10-16 ARC-0020 — Task 0.5 prepared (Splinter on Command), no change; 2026-10-16 ARC-0020 — Tasks 0.6–0.7 prepared, no change
---

# 42.04 · Icon briefs — The Deceiver

**State today:** the subclass icon exists (`42.02/class_and_subclasses/`); every Deceiver spell and passive borrows a
**vanilla** icon, and four groups share one: `Spell_Illusion_MirrorImage` (Two Truths, Grand Deception, The Veil Lifts),
`Action_Cleric_InvokeDuplicity` (Mirror Image, The Veil), `Spell_Evocation_MagicMissile` (Sigil of Malice and its Mirror),
`Spell_Conjuration_Entangled` (Ethereal Chains and its Mirror). Twice-Told copies and Dismiss have no icon.

**Family style:** the veil and its pomegranates, the pillars B and J (black and white), mirrors and broken glass, in
the subclass pink `#f83fa5` on a dark-violet ground; Doubles drawn as a pale, half-transparent copy of a figure.
Pipeline: source `42.01` → PNG `42.02/features/the deceiver/` → DDS BC7 `42.03`; origin in `00.06/ASSET_ORIGIN_REGISTER.md`.

| Icon | For | Subject · symbol | Palette | Replaces (vanilla today) | Priority |
|---|---|---|---|---|---|
| ICO_Deceiver_Eidolon | Eidolon | A veiled figure and its pale twin stepping out of a cloud | Pink + pale grey | Action_Cleric_InvokeDuplicity (shared) | **1** |
| ICO_Deceiver_TheVeil | The Veil (core passive) | A veil embroidered with pomegranates, a figure's outline behind it | Pink, dark violet | Action_Cleric_InvokeDuplicity (shared) | **1** |
| ICO_Deceiver_SeedOfDoubt | Seed of Doubt | A pomegranate seed glowing, cracks spreading from it | Pink + crimson | Spell_Evocation_MagicMissile (shared) | **1** |
| ICO_Deceiver_ReflectedSeed | Reflected Seed (Double) | The same seed seen in a mirror, paler | Pale pink | Spell_Evocation_MagicMissile (shared) | 2 |
| ICO_Deceiver_BindingFalsehood | Binding Falsehood | Threads of woven script binding a figure | Pink + silver | Spell_Conjuration_Entangled (shared) | **1** |
| ICO_Deceiver_ReflectedFalsehood | Reflected Falsehood (Double) | The binding threads in a mirror, paler | Pale pink | Spell_Conjuration_Entangled (shared) | 2 |
| ICO_Deceiver_Splinter | Splinter (Double) | A figure bursting into shards of glass | Pink shards on violet | Spell_Evocation_Shatter (vanilla name clash) | **1** |
| ICO_Deceiver_SplinterOnCommand | Splinter on Command (new, DV24, DV31) | A hand closing, a distant twin splintering | Pink + white | — (new) | **1** |
| ICO_Deceiver_Veilstep | Veilstep | A figure passing through a veil, its outline left behind | Pink, violet | Spell_WildMagic_Teleport_Activate | 2 |
| ICO_Deceiver_Withdraw | Withdraw | Two outlines swapping across a veil | Pink | Spell_Transmutation_Blink_Teleport | 3 |
| ICO_Deceiver_TwiceTold | Twice-Told and Twice-Told: <Card> | Two overlapping mouths, or one rune drawn twice | Pink + gold | Spell_Illusion_Blur (copies: none) | 2 |
| ICO_Deceiver_GrandDeception | Grand Deception (ultimate) | A ring of identical figures around enemies' eyes | Full pink, gold rim | Spell_Illusion_MirrorImage (shared) | **1** |
| ICO_Deceiver_TheVeilLifts | The Veil Lifts (Aspect card) | The High Priestess card with the veil torn away — card art style | Gold, pink, black and white pillars | Spell_Illusion_MirrorImage (shared) | **1** |
| ICO_Deceiver_TwoTruths | Two Truths | Two pillars, black and white, each holding a small rune | Black, white, pink | Spell_Illusion_MirrorImage (shared) | **1** |
| ICO_Deceiver_Unveil | Unveil (passive and Double's spell) | A mirror frame with the figure stepping through it | Pink | Spell_Conjuration_MistyStep / Action_BenignTransposition | 3 |
| ICO_Deceiver_Dismiss | Dismiss (Double) | A twin fading to mist | Pale grey | — (none) | 3 |
| ICO_Deceiver_Awakening | 2 - The High Priestess: Awakening and its tiers (Veiled, Two Pillars, Aspect of Doubt) | The High Priestess card glowing, one pillar per tier lit | Gold + pink | Spell_Necromancy_BestowCurse | **1** |

Kept vanilla (they read well and match the rule): Malicious Whispers (`Spell_Enchantment_DissonantWhispers`), Faceless
(`Spell_Illusion_DisguiseSelf`), Friends (`Spell_Enchantment_Friends`), Veiled Prison (`Spell_Enchantment_HoldPerson`),
Marionette (`Spell_Enchantment_DominatePerson`), Mirrored Spell (`Spell_Abjuration_Counterspell`), Mirrored Self
(`PassiveFeature_SplitEnchantment`), Ready: Which One? (`PassiveFeature_IllusorySelf`). Statuses (Doubt, Deluded, Seed,
Paranoia) keep vanilla icons until a status-icon pass is decided.

Priority 1 = shared icons today (readability bug in the hotbar), the new card, the core passive and the Aspect card.
All briefs: **not started**.
