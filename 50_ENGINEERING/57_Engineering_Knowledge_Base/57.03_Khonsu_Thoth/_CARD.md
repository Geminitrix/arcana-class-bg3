# 57.03 · Khonsu and Thoth — card

*Spec Part III §27, checked against this project's tested reference. **The authority is `KHONSU.md` in this
folder** (383 lines, every claim tested in the game). Read it before writing any `.khn` or any
`Conditions` / `BoostConditions` / `EnabledConditions` / `DescriptionParams` field.*

## In one minute
- Khonsu is the engine's Lua-like language for conditions and functors; files are `.khn` in
  `Mods/<Mod>/Scripts/thoth/helpers/`, loaded when stats are reloaded in the Toolkit. All files share one
  global environment. **Thoth** = the condition functions the game ships (mostly return `ConditionResult`).
- **Two grammars:** Stats condition fields use `and` / `or` / `not`; inside `.khn` boolean combination of
  conditions uses `&` / `|` / `~` (see `KHONSU.md` §1 for the exception with plain Lua values).
- Errors can crash the Toolkit on reload; details land in `errors.txt` in the Toolkit folder. Change one
  small thing at a time.
- A condition can return a `ConditionError` tied to a loca handle — the player sees *why* a feature can't be
  used. Plan that text in the spec and the loca.
- **Read `KHONSU.md` §6 (the BoostConditions crash) before writing any passive.**

## Rules (spec §27.5)
One function, one purpose, project prefix in the name. Never redefine shared vanilla functions (a later
mod can override yours). Handle `nil`; test the true and the false case. Community libraries
(Bg3-Khn-Libs) are unfinished — the vanilla `.khn` in the local extraction stays the reference (Patch 8
has functions older patches don't).

## Khonsu, Osiris or Lua?
A true/false question about target, context or state → Khonsu. A reaction to a game event → Osiris. Engine
access → Lua (PC edition only).
