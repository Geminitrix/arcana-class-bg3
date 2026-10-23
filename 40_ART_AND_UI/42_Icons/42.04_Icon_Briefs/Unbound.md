---
id: 42.04/Unbound
owner: Icon Artist
source: 21.04/Unbound/DESIGN.md §2.1 (card readings), §2.5 (colour), §4–§8; 31.02/Unbound.md; icons in game (Stats `Icon`, dossier_texts.pl --icons, 2026-10-23, after the Owner's Toolkit build)
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — WB49 (QA-0004 probe outcomes) checked, no change; 2026-10-17 ARC-0026 — P8 fix applied, no change; 2026-10-17 ARC-0026 — stage 1 complete, WB50 checked, no change; 2026-10-17 ARC-0026 — stage 2 applied, no change; 2026-10-17 ARC-0026 — Toolkit guides per level (the Owner types), no change; retired entries kept (OR-10); 2026-10-18 ARC-0026 — WB51 (rebuild from zero, OR-59 ids) checked, no change; 2026-10-23 ARC-0026 — the Owner chose the in-game icons in the Toolkit (WB61): recorded; briefs for Leap of Faith, Storm Fists and Where the Winds Meet retired, Zephyr: Tempest, Zephyr: Ally Tempest and Unleashed Winds added
---

# 42.04 · Icon briefs — The Windborn (internal: Unbound)

**State today:** the subclass icon exists (`42.02/class_and_subclasses/unbound.png`). In the Toolkit build (ARC-0026,
WB61) the Owner gave every visible Windborn piece its own **vanilla** icon — the old fifteen-way share of
`Action_Monk_StepOfTheWind_Dash` is gone (only the retired Fool's Luck keeps it). Custom icons below stay briefs for a
later art pass; the Owner's choice is the in-game reference until then.

## In the game (the Owner's choice, 2026-10-23)

| Piece | Icon |
|---|---|
| The Open Road | `PassiveFeature_Land_Coast` |
| Zephyr · Gale · Storm · Hurricane | `Action_KiResonation_Punch` · `Action_MightyImpel` · `PassiveFeature_RelentlessEndurance` · `PassiveFeature_WrathOfTheStorm_Thunder` |
| Zephyr Strike · Zephyr Rush | `Action_Monk_FlurryOfBlows` · `Action_Monk_FistOfUnbrokenAir` |
| Windswept | `Spell_Transmutation_WindWalk` |
| Aeolus' Bag (spell, passive, `BAG_OPEN`) | `Skill_Sorcerer_Passive_TidesOfChaos` |
| Tailwind / Headwind (all six) | `Action_Monster_ElementalWater_WintersBreath` |
| The Calm | `Skill_Druid_NaturalRecovery` |
| Unleashed Winds | `Action_Monster_ElementalAir_Whirlwind` |
| Gale Burst · Wind Blast | `Spell_Evocation_Thunderwave` · `Spell_Evocation_GustOfWind` |
| Wind Whispers (card, status, Riposte) | `PassiveFeature_DangerSense` |
| Flow State | `Action_Monk_StillnessOfMind` |
| Ready: Gale Deflection · its reaction and passive | `Action_Monk_DeflectMissile` · `PassiveFeature_DeflectMissiles` |
| Zephyr: Tempest (card, status, passive) | `PassiveFeature_HeartOfTheStorm_Thunder` |
| Zephyr: Ally Tempest (card) | `PassiveFeature_HeartOfTheStorm_Resistance` |
| Untethered | `Action_TempestuousMagic` |
| Weightless (ranks 1 · 4–8 · 12) | `PassiveFeature_UnarmoredMovement` · `_2` · `_3` |
| Be the Leaf · Empty State | `PassiveFeature_PurityOfBody` · `PassiveFeature_MistyEscape` |
| Awakening and tiers I–III (passives and statuses) | `Action_Mag_SpellSlotRestoration`, `_1`, `_2`, `_3` |

**Gaps:** `ZEPHYR_TEMPEST_ALLY` — a visible status on an ally (5 turns, DESIGN §7) — has **no icon**; `Rush_Arcana_Created_ZephyrRush_Storm`
and the six bag variants have none either (they show inside the bag's container, so the container icon covers them).
Fix with the WB62 batch (`[fechado] ARC-0026`).

## Briefs for custom icons (later art pass)

**Family style:** moving air drawn as pale ribbons and leaf shapes, an open hand, the road and the cliff edge of the
Fool, in the subclass yellow `#f2c939` on a warm-grey ground; winds as faces or banners in the Greek manner for the
bag. Pipeline: source `42.01` → PNG `42.02/features/the windborn/` → DDS BC7 `42.03`; origin in
`00.06/ASSET_ORIGIN_REGISTER.md`.

| Icon | For | Subject · symbol | Palette | Vanilla today | Priority |
|---|---|---|---|---|---|
| ICO_Unbound_TheOpenRoad | The Open Road (core passive) | A road running to the horizon, a ribbon of wind along it | Yellow + pale sky | PassiveFeature_Land_Coast | **1** |
| ICO_Unbound_Windswept | Windswept (status on enemies) | A figure with wind streaks passing through it | Yellow streaks on grey | Spell_Transmutation_WindWalk | **1** |
| ICO_Unbound_ZephyrStrike | Zephyr Strike · Zephyr Rush | An open palm riding a gust forward | Yellow + white | Action_Monk_FlurryOfBlows · Action_Monk_FistOfUnbrokenAir | **1** |
| ICO_Unbound_AeolusBag | Aeolus' Bag | A tied leather bag, winds leaking from the knot | Yellow, brown, pale blue | Skill_Sorcerer_Passive_TidesOfChaos | **1** |
| ICO_Unbound_Boreas | Boreas (North Wind) | A bearded wind face blowing cold air | Pale blue + yellow rim | (none; tailwind/headwind share WintersBreath) | 2 |
| ICO_Unbound_Notus | Notus (South Wind) | A wind face blowing rain and fog | Grey-blue + yellow rim | (none; as above) | 2 |
| ICO_Unbound_Eurus | Eurus (East Wind) | A wind face with a rising sun behind | Amber + yellow | (none; as above) | 2 |
| ICO_Unbound_TheCalm | The Calm (Aspect card) | A still horizon, a single leaf hanging in the air | Yellow on pale grey | Skill_Druid_NaturalRecovery | **1** |
| ICO_Unbound_UnleashedWinds | Unleashed Winds (capstone) | Four gusts bursting from one point, two of them curling back in | Yellow + four wind tints | Action_Monster_ElementalAir_Whirlwind | **1** |
| ICO_Unbound_Weightless | Weightless | A foot leaving the ground, a feather beneath it | Yellow + white | PassiveFeature_UnarmoredMovement (_2, _3) | 2 |
| ICO_Unbound_Awakening | 0 - The Fool: Awakening and its tiers | The Fool at the cliff edge, looking up | Yellow, sun gold | Action_Mag_SpellSlotRestoration (_1–_3) | **1** |
| ICO_Unbound_ZephyrTempest | Zephyr: Tempest | A fist wrapped in a small thundercloud | Yellow + storm grey | PassiveFeature_HeartOfTheStorm_Thunder | 2 |
| ICO_Unbound_ZephyrTempestAlly | Zephyr: Ally Tempest | A blade with a ribbon of wind and a spark of thunder | Yellow + storm grey | PassiveFeature_HeartOfTheStorm_Resistance (the status has none) | 2 |
| ICO_Unbound_Untethered | Untethered | A figure on a glider of wind | Yellow + sky | Action_TempestuousMagic | 3 |

**Retired briefs:** ICO_Unbound_LeapOfFaith (WB55), ICO_Unbound_StormFists (its subject moved to Zephyr: Tempest, WB54),
ICO_Unbound_WhereTheWindsMeet (Unleashed Winds, WB56).

Kept on vanilla until a later pass: Gale Burst, Wind Blast, Wind Whispers, Flow State, Gale Deflection, Be the Leaf,
Flowing Strikes, Flowing Assault, Magic Strikes, Empty State.
