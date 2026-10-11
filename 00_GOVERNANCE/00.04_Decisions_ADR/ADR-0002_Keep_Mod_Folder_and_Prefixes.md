# ADR-0002 · Keep the mod folder name and the id prefixes

- **Status:** Accepted · 2026-10-11 · Owners

## Context
The spec suggests `ArcanaClass_<UUID>` and an `ARC_` prefix. The published mod uses the folder
`AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7` and the prefixes `ARCANA_` (Osiris, items),
`Arcana_Passive_`, `<Type>_Arcana_Card_Spell_|Card_Ability_|Card_Passive_|Created_|Util_|Reaction_`.

## Decision
Keep both. New studio-level entries (master data, assets) use `SPL_`, `FEAT_`, `STA_`, `CLS_`, `ICO_` as
**document** ids; ids that ship in the game keep the mod's existing prefixes.

## Consequences
No save breakage and the mod.io entry stays the same (spec §31.4: never rename or delete published
entries). `51` mirrors the real folder names.
