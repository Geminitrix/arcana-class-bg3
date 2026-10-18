# 82 · Automation

Pipeline scripts (sync_data, update_board, validators, generators).

**Owner:** Mod Engineer

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
| `stats/*.pl` | Stats helpers: `stats_add` (patch files), `gen_upcast_variants`, `sort_stats`, `check_cards`, `subclass_texts`, `gen_emotion_alchemy`, `resolve_stats` (a parent's effective fields), `order_toolkit_guide` (Toolkit guide tables in the Toolkit's field order; `--apply` rewrites) |
| `gen_type_catalog.pl` | Vanilla extraction + schema → `55.00_Type_Catalog.md` (spell / status subtypes with vanilla examples) |
| `verify_context.pl` | Every spell / passive a progression grants must appear in its `05` file; every id in a `05` file must exist. Matches by id or in-game name — features described under another name show up as false positives, so read the list |
| `update_board.pl` | Tickets → `10.01/BACKLOG.md`, `10.02/SPRINT_BOARD.md` and `kanban/board.json` (the kanban artifact's data) |
| `kanban/` | The Owner's kanban board artifact (ARC-0018): `index.html`, `board.json`, `emblems/`. Sync below |
| `playtests.pl` | `new <guide.json> <subclass\|feature\|bug-retest>` writes the next QA-#### playtest ticket in `10.01/playtests`; `sync [dir]` rebuilds the QA test lists from the guides (by level) with the Arcana Test Guides results, plus `TEST_GUIDES.json` and the `.md` records (ARC-0024) |

## Kanban sync (ARC-0018)

Board: https://claude.ai/artifact/Fwq9XqzgZNt5KmKRC4k15E — the ticket `.md` files are the truth. The Owner drags
cards and writes comments on the board; they wait in the artifact's store (`moves/<ticket id>` = `{to, from, at}`,
`comments/<auto>` = `{ticket, text, at}`) until the Owner runs `/sync-board` (moves, comments: steps 1–3, 4–6) or `/sync-test-guides` (results, guides: step 3b, 4–5). Then:

1. `ArtifactData list` of `moves` and `comments`.
2. Each move → the ticket's `status:` becomes `to`, plus a log line `- <date> — moved to <to> on the board (Owner).`
   If the ticket's status is no longer `from`, the move still wins; say so to the Owner.
3. Each comment → a log line `- <date> — Owner comment: <text>` (kept in Portuguese).
3b. Playtests (ARC-0024): `ArtifactData list` of `results` on Arcana Test Guides
   (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E) with `out_dir` = a scratch folder, then
   `perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl sync <out_dir>/results` (rebuilds each QA ticket's test
   list from its guide, `61_Test_Plan/TEST_GUIDES.json` and the guides' `.md` records). Each new fail → an ARC bug ticket
   (`/novo-ticket`) and a QA bug-retest (`playtests.pl new <its guide> bug-retest`, `blocked_by` the bug).
   Those results stay in the test page; nothing there is deleted.
4. `update_board.pl`, commit + push (`ARC-0018: kanban sync …` or the ticket's own id).
5. Republish `kanban/index.html` with `files: ["board.json"]` (same file path keeps the URL), and Arcana Test Guides:
   `61_Test_Plan/test_guides/index.html` with its `url`, `root` = `60_QA_AND_TESTING/61_Test_Plan`, `files` =
   `TEST_GUIDES.json` plus every guide it lists.
6. Delete the synced `moves` / `comments` documents (one `batch`).

Any other change to tickets or guides reaches the board at the next `/sync-board` and the test page at the next `/sync-test-guides`.
| `check_readme.pl` | README version and subclass states vs `05.00` (run by `/commit-e-push`) |
| `audit.pl` | Organisation checks: dead citations, owners, ticket fields and WIP, open handoffs, daily logs (run by `/auditoria`, ARC-0027) |
| `validate.pl` | 51: duplicate UUIDs in data tables (error), handles missing from mod loca (warning), expansion inventory 13–20 (info), schemas (when they exist) |
| `extract_pak.sh` | `.pak` → extracted tree, `.lsf` → `.lsx`, `.loca` → `.xml`, sha256 (Divine) |
| `compare_versions.pl` | Two versions → markdown diff: Stats entries (field `old ⇒ new`), English texts, other files (feeds `76.02`) |
| `check_propagation.pl` | 00.08: per subclass dossier, artifacts MISSING / STALE vs the last decision, plus open handoffs; `--hook` = Stop hook (blocks ending a session that changed decisions without propagating) |
