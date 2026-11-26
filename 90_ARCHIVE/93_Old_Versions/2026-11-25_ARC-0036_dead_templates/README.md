# 2026-11-25 · ARC-0036 — dead Veilwalker root templates

Removed from `Data/Public/AspectClass_…/RootTemplates/` on 2026-11-25 (ARC-0036, DV37). Nothing in the mod referenced
them — no GUID or name in Stats, lists, progressions, Osiris, Lua, Khonsu or the other templates (`grep -rla`).

| File | Template name | What it was |
|---|---|---|
| `4267f207-3e8b-4431-99e0-ba91eb29a836.lsf` | `ARCANA_CHAR_CreateClone_2` | The old second clone; listed three spells that no longer exist (`Projectile_Deceiver_Clone_MirrorSigilofMalice`, `Target_Deceiver_Clone_MirrorDistortion`, `Target_Deceiver_Clone_MirrorEtherealChains`) |
| `4441890b-a8c1-4c6d-8309-ec505adc7acc.lsf` | `ARCANA_ITEM_Spell_MirrorDistortionPosition` | Position marker of the old Mirror: Distortion |
| `c3c514b2-152d-4a01-9e7d-e49d1062d2f0.lsf` | `ARCANA_ITEM_Spell_DistortionPosition` | Position marker of the old Distortion (now Veilstep, placed by Osiris) |
| `d88fb323-5015-4949-a65a-eb417a924d5d.lsf` | `ARCANA_ITEM_Spell_MimicDistortionPosition` | Position marker of the old Mimic: Distortion |

To restore one, copy it back to `RootTemplates/` (the Toolkit loads it on the next open). The live Double template
`8807d230…` stays, renamed `ARCANA_CHAR_DoubleOfTheVeil` (was `ARCANA_CHAR_CreateClone_1`).
