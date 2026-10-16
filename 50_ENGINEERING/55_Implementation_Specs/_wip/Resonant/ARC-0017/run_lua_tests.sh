#!/bin/sh
# ARC-0017: the deck's Lua tests on the game's Lua (51 copy) with this ticket's changes laid over it, in the scratch
# directory -- the game copy is untouched until stage 3 copies Lua/ into Data.
#   sh 50_ENGINEERING/55_Implementation_Specs/_wip/Resonant/ARC-0017/run_lua_tests.sh <scratch dir>
set -e
ROOT="$(cd "$(dirname "$0")/../../../../.." && pwd)"
OUT="${1:?scratch dir}"
SRC="$ROOT/50_ENGINEERING/51_Mod_Source/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/ScriptExtender/Lua"
rm -rf "$OUT/Lua"; mkdir -p "$OUT"; cp -r "$SRC" "$OUT/Lua"
cp -r "$ROOT/50_ENGINEERING/55_Implementation_Specs/_wip/Resonant/ARC-0017/Lua/." "$OUT/Lua/"
lua "$ROOT/50_ENGINEERING/53_Build_and_Versioning/53.03_Validators/run_tests.lua" "$OUT/Lua"
