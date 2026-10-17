---
id: 42.04/Unbound
owner: Icon Artist
source: 21.04/Unbound/DESIGN.md §2.1 (card readings), §2.5 (colour), §4–§8; 31.02/Unbound.md; icons in game (Stats `Icon`, dossier_texts.pl --icons, 2026-10-17)
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — WB49 (QA-0004 probe outcomes) checked, no change; 2026-10-17 ARC-0026 — P8 fix applied, no change; 2026-10-17 ARC-0026 — stage 1 complete, WB50 checked, no change
---

# 42.04 · Icon briefs — The Windborn (internal: Unbound)

**State today:** the subclass icon exists (`42.02/class_and_subclasses/unbound.png`); every Windborn spell and passive
borrows a **vanilla** icon, mostly Monk ones, and one is shared by fifteen entries: `Action_Monk_StepOfTheWind_Dash`
(Leap of Faith, every Awakening passive and tier status, Fool's Luck, Evasive Flow). Others shared:
`PassiveFeature_DeflectMissiles` / `Action_Monk_DeflectMissile` (Gale Deflection family), `PassiveFeature_DangerSense`
(Wind Whispers), `Action_TempestuousMagic` (Untethered), `Spell_Evocation_Shatter` (Storm Fists).

**Family style:** moving air drawn as pale ribbons and leaf shapes, an open hand, the road and the cliff edge of the
Fool, in the subclass yellow `#f2c939` on a warm-grey ground; winds as faces or banners in the Greek manner for the
bag. Pipeline: source `42.01` → PNG `42.02/features/the windborn/` → DDS BC7 `42.03`; origin in
`00.06/ASSET_ORIGIN_REGISTER.md`.

| Icon | For | Subject · symbol | Palette | Replaces (vanilla today) | Priority |
|---|---|---|---|---|---|
| ICO_Unbound_TheOpenRoad | The Open Road (core passive) | A road running to the horizon, a ribbon of wind along it | Yellow + pale sky | PassiveFeature_MartialArts_BonusUnarmedStrike (shared) | **1** |
| ICO_Unbound_Windswept | Windswept (status on enemies) | A figure with wind streaks passing through it | Yellow streaks on grey | — (new) | **1** |
| ICO_Unbound_ZephyrStrike | Zephyr Strike | An open palm riding a gust forward | Yellow + white | Action_Monk_FreeUnarmedStrike | **1** |
| ICO_Unbound_AeolusBag | Aeolus' Bag | A tied leather bag, winds leaking from the knot | Yellow, brown, pale blue | — (new) | **1** |
| ICO_Unbound_Boreas | Boreas (North Wind) | A bearded wind face blowing cold air | Pale blue + yellow rim | — (new) | 2 |
| ICO_Unbound_Notus | Notus (South Wind) | A wind face blowing rain and fog | Grey-blue + yellow rim | — (new) | 2 |
| ICO_Unbound_Eurus | Eurus (East Wind) | A wind face with a rising sun behind | Amber + yellow | — (new) | 2 |
| ICO_Unbound_TheCalm | The Calm (Aspect card) | A still horizon, a single leaf hanging in the air | Yellow on pale grey | — (new; Leap of Faith's slot) | **1** |
| ICO_Unbound_WhereTheWindsMeet | Where the Winds Meet (capstone) | Four gusts spiralling into one point | Yellow + four wind tints | — (new) | **1** |
| ICO_Unbound_Weightless | Weightless | A foot leaving the ground, a feather beneath it | Yellow + white | (Twinkle Toes / Feather Fall) | 2 |
| ICO_Unbound_Awakening | 0 - The Fool: Awakening and its tiers | The Fool at the cliff edge, looking up | Yellow, sun gold | Action_Monk_StepOfTheWind_Dash (shared by 15) | **1** |
| ICO_Unbound_LeapOfFaith | Leap of Faith | A figure diving through a line of silhouettes | Yellow + grey | Action_Monk_StepOfTheWind_Dash (shared by 15) | 2 |
| ICO_Unbound_StormFists | Storm Fists | A fist wrapped in a small thundercloud | Yellow + storm grey | Spell_Evocation_Shatter (vanilla name clash) | 2 |
| ICO_Unbound_Untethered | Untethered | A figure on a glider of wind | Yellow + sky | Action_TempestuousMagic | 3 |

Kept on vanilla until a later pass: Gale Burst, Wind Blast, Wind Whispers, Flow State, Gale Deflection, Be the Leaf,
Flowing Strikes, Flowing Assault, Magic Strikes, Empty State.
