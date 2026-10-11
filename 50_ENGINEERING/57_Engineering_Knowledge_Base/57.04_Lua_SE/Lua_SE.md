# 57.04 · Lua and the Script Extender

*Condenses spec Part III §28, grounded in this mod's own SE code (`51/Mods/AspectClass_…/ScriptExtender/`).
PC edition only — the console edition never depends on it.*

## Setup in this mod
`ScriptExtender/Config.json`: `RequiredVersion` **32**, `ModTable` **`ArcanaDeck`**, `FeatureFlags`
`["Lua"]`. Entry point `Lua/BootstrapServer.lua` (no client bootstrap yet); code in `Lua/Server/`, tests
in `Lua/Tests/` (runner `53.03_Validators/run_tests.lua`). Other files load from the bootstrap with
`Ext.Require(...)`, only during module initialisation.

## Server and client
Even solo, the game is one server plus clients. Osiris always runs on the server. Lua has separate states
per side that can't see each other's variables. **Game state changes run on the server; UI on the client;
they talk through NetChannel** (NetMessage is obsolete).

## Lifecycle events (used here: `SessionLoaded`, `ResetCompleted`)
| Event | When | Typical use |
|---|---|---|
| `ModuleLoadStarted` | Engine starts loading mods | Redirect files |
| `StatsLoaded` | Stats (re)loaded | Session-wide Stats edits (no sync needed here) |
| `SessionLoading` / `SessionLoaded` | Session being built / ready | Prepare state / read saved vars, start logic |
| `ResetCompleted` | Lua reloaded (`reset`) | Re-init without restarting |
| `GameStateChanged` | Menu, loading, pause… | React to transitions |
| `Tick` | After every engine tick (~33 ms) | Only light, rare work |
Shape: `Ext.Events.SessionLoaded:Subscribe(function(e) ... end)`.

## APIs this mod uses (counts from its code)
`Ext.Osiris.RegisterListener` (9) · `Ext.Entity.Get` (4) · `Ext.Timer.WaitFor` (3) · `Ext.Stats.Get` (3) ·
`Ext.Vars.RegisterModVariable` / `GetModVariables` · `Ext.StaticData.Get(All)` · `Ext.Loca.GetTranslatedString`.

## Rules
- **Osiris from Lua:** server-side global `Osi`; `Ext.Osiris.RegisterListener(name, arity, "before"|"after", fn)`;
  DBs read with `:Get`, removed with `:Delete`, `nil` = any value. **Never duplicate the same logic in
  Osiris and Lua.**
- **Stats from Lua:** `Ext.Stats.Get(name)`; edits after load need `:Sync()`; table fields
  (`Requirements`, `SpellProperties`) must be **reassigned** after change or the change is ignored.
- **Persistence:** Lua state resets on every load. Use mod variables (`RegisterModVariable`) or user
  variables, registered during bootstrap before the save is read; reassign tables to trigger sync.
  `PersistentVars` is obsolete.
- **Object scope:** engine objects are valid only inside the listener that got them — store UUIDs, not
  objects (an "expired object" error otherwise).
- Reading or writing a missing property throws — good, it fails loudly. UI code (Noesis) inside
  `Ext.UI.Defer`. Debug helpers `_P`, `_D`, `_C` never ship. Nothing heavy in `Tick`.

## Quality tools
`ExtIdeHelpers.lua` (type definitions for autocomplete) · `luacheck` with a `.luacheckrc` declaring `Ext`,
`Osi`, `Mods`, `_P`, `_D`, `_C` · `busted` for pure-logic unit tests. Confirm the Lua version and globals
against the installed SE (`C:\Projetos\BG3\Script Extender`).
