# 57.06 · Programming workflow, quality and debugging

*Condenses spec Part III §30–31. Paths, Toolkit reloads, gotchas and Divine recipes:
`Environment_and_Workflows.md` in this folder.*

## Steps (life-cycle stages 8–13 from the coder's side)
| # | Step | Output |
|---|---|---|
| 1 | Read `SPEC_ARC-####`, split by layer | Work items |
| 2 | Explore the base game in `56` (read-only) | Anchors cited by path |
| 3 | Short plan: files, order, risks | Plan approved (by the Owner if `implementation: owner`) |
| 4 | Implement by layer: Stats → LSX → Khonsu → Lua / Osiris → loca → icons | Files in Data, then `sync_data` → `51` |
| 5 | Self-check: validators (`53.03`), linters, stats reload clean | Report with no open items |
| 6 | In-game test: standard save (`83.02`) + the spec's "how to verify" | Evidence in `65` |
| 7 | Code gate (below) | Approval or fixes |
| 8 | Commit (one per layer, ticket id first) and test build | Build in `53.04` |
| 9 | QA: test cases from `61.02` | Pass or bugs in `62` |

## Who implements (OR-11, work flow stage 5)
The Owner types the one `TOOLKIT_ARC-####.md` in its order — feature by feature, not level by level (OR-4, OR-5). Then Engineering runs `sync_data`, the
validators and compares the result with the spec item by item; every divergence is fixed by Claude in a message that
starts with `[fechado]` and names the ticket (`implementation: owner`), shown with its verification command and result.

## Code gate
1 Prefix on every name, no collision with vanilla or mods · 2 no vanilla file changed or overridden ·
3 stats reload with no errors, validators pass (schema, UUIDs, handles) · 4 Khonsu: `errors.txt` clean,
player-facing error text where it fits · 5 Lua: `luacheck` clean, no stored engine objects, nothing heavy
in `Tick` · 6 Osiris: prefixed goals, `EXITSECTION` cleans DBs, no game queries in init · 7 works on server
and client (and multiplayer when it applies) · 8 behaviour matches the spec item by item · 9 every API used
appears in a vanilla example or the docs.

## Four layers of verification
Static (schema, duplicate UUIDs, XML/LSX validity, handles, luacheck, core 1–12 never depends on 13–20) ·
logic (`busted` / `run_tests.lua`, one assertion per rule) · in game (standard saves) · regression and
compatibility (`64`).

## Checklist per layer
- **Stats:** shows in spellbook and hotbar? cost, range, area, save right? applies the expected status?
  readable tooltip? arrives through level-up?
- **Khonsu:** true and false in the right cases? error text in the tooltip?
- **Lua:** works after `reset` and after reloading a save? multiplayer? no expired objects? no slowdown?
- **Osiris:** goal starts and ends as expected? DBs cleaned? logs show the rules firing?
- **LSX:** each level 1–12 grants what the table says (`82_Automation/dump_progression.pl`)? multiclass works?

## Save compatibility
**Never rename or delete a published entry** (Stats, lists, UUIDs). To retire something keep the old
entry working or as an alias of the new one, and say so in the changelog and patch notes.

## Quick diagnosis
| Symptom | Look at |
|---|---|
| Mod missing in game | `meta.lsx`, folder layout vs vanilla, UUIDs |
| Spell/passive never reaches the character | List, progression reference, duplicate UUID, wrong field |
| Toolkit crashes on stats reload | `errors.txt` (Khonsu) |
| Lua "expired object" | Engine object kept outside its listener |
| Stats table change ignored | Table not reassigned |
| Data lost after loading a save | Variable not registered in bootstrap, or table not reassigned |
| Effect happens only once | Repeated Osiris fact doesn't fire again |

## Debugging tools
SE console (`reset`, `!commands`, `_P`, `_D`) · `ScriptExtenderSettings.json` (logging, console, Osiris and
Lua debuggers) · `Ext.IO.SaveFile` + `Ext.DumpExport` for big objects · Toolkit `errors.txt` · Story Editor ·
Larian's debug mod.

## Git for code
Commit per layer, ticket id first; nothing from the base game in the repository; the Code Reviewer reads
the diff before it counts as done (main-only workflow, ADR-0001).
