# 82 · Automation

Pipeline scripts (sync_data, update_board, validators, generators).

**Owner:** Pipeline Tech Lead (Mod Engineer acts)

| Item | What it holds |
|---|---|
| `stats` | Stats helpers (sort, upcast variants, card checks) |

_Index maintained by the owner; generated in Stage A (2026-10-11)._

## Scripts

| Script | Job |
|---|---|
| `sync_data.sh` | Data → `51_Mod_Source` copy (ADR-0003); `--check` only reports differences |
| `gen_catalog.pl` | `51` → `05.03`, `05.04` catalogues and the `25.05_inventory` YAML (ADR-0005) |
| `dump_progression.pl` | Prints every progression level from the game files, names and texts resolved |
| `stats/*.pl` | Stats helpers: `stats_add` (patch files), `gen_upcast_variants`, `sort_stats`, `check_cards`, `subclass_texts`, `gen_emotion_alchemy` |
