---
source: 00.04 ADR-0003, ADR-0005
synced_at: 2026-10-11 (Stage B first load)
state: synced
---

# 05.07 · Source map — where each fact comes from

| Fact | Source of truth | Mirror in 05 |
|---|---|---|
| Spells, passives, statuses, costs, levels (shipped) | Game files → `51_Mod_Source/Public/…/Stats/Generated/Data/*.txt` | `05.03`, `05.04` (generated) |
| Numbers of new / reworked features | `25_Master_Data/25.01`–`25.04` (YAML) | `05.03`, `05.04` once shipped |
| Read-only inventory of the current Stats | `25_Master_Data/25.05_inventory/` (generated) | — |
| Class chassis, progression per level, lists | `51_Mod_Source/Public/…/{ClassDescriptions,Progressions,Lists}` | `05.01`, `05.02` |
| Deck logic (PC edition) | `51_Mod_Source/Mods/…/ScriptExtender/Lua` | `05.02`, `05.06` |
| Osiris behaviour | `51_Mod_Source/Mods/…/Story/RawFiles/Goals/*.txt` | `05.02` |
| Player-facing text | `51_Mod_Source/Mods/…/Localization/English/english.xml`; approved text in `32.04` | `05.05` |
| Design intent | `21_GDD_Arcana_Class` | — |
| Decisions | `00.04_Decisions_ADR` | — |

`51` is a copy of the game's Data folder (ADR-0003): refresh it with `82_Automation/sync_data.sh`, then
regenerate `05.03`/`05.04`/`25.05` with `82_Automation/gen_catalog.pl`.
