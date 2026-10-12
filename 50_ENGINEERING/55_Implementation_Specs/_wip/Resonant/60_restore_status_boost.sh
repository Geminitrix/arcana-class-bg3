#!/usr/bin/env bash
# ARC-0002 incident 2026-10-12: RESONANT_OVERLOAD_SPENT_TECH was written with a duplicated StackId field; the
# Toolkit stopped loading Status_BOOST at that object and, on save, wrote the table without the 85 entries after it.
# This puts back the last complete Status_BOOST (256 entries):
#   - the Toolkit's .stats from git, commit 52a9d03;
#   - the game's .txt from the synchronized copy in 51 (Generated/ is not in git; 51 was last synced before the
#     incident -- do NOT run sync_data before this script).
# The truncated files are kept in 90_ARCHIVE/94_Safety_Backups first. Then re-apply the generator's patch: it
# replaces the broken entry with the fixed one.
#   bash 60_restore_status_boost.sh            # shows what it would do
#   bash 60_restore_status_boost.sh --apply    # writes (game and Toolkit closed, [fechado])
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
GAME="${BG3_DATA:-/c/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data}"
MOD="AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7"
TXT="Public/$MOD/Stats/Generated/Data/Status_BOOST.txt"
STATS="Editor/Mods/$MOD/Stats/StatusData/Status_BOOST.stats"
BACKUP="$ROOT/90_ARCHIVE/94_Safety_Backups/2026-10-12_status_boost_truncated"
count() { grep -c -e '^new entry' -e '<stat_object' || true; }

txt_good=$(count < "$ROOT/50_ENGINEERING/51_Mod_Source/$TXT")
stats_good=$(git -C "$ROOT" show "52a9d03:50_ENGINEERING/51_Mod_Source/$STATS" | count)
echo "Status_BOOST.txt:   game $(count < "$GAME/$TXT") -> 51 copy $txt_good"
echo "Status_BOOST.stats: game $(count < "$GAME/$STATS") -> git 52a9d03 $stats_good"
[ "$txt_good" -ge 256 ] && [ "$stats_good" -ge 257 ] || { echo "a source is not complete -- stop" >&2; exit 1; }

if [ "${1:-}" = "--apply" ]; then
    mkdir -p "$BACKUP"
    cp "$GAME/$TXT" "$BACKUP/Status_BOOST.txt"; cp "$GAME/$STATS" "$BACKUP/Status_BOOST.stats"
    cp "$ROOT/50_ENGINEERING/51_Mod_Source/$TXT" "$GAME/$TXT"
    git -C "$ROOT" show "52a9d03:50_ENGINEERING/51_Mod_Source/$STATS" > "$GAME/$STATS"
    echo "restored: txt $(count < "$GAME/$TXT"), stats $(count < "$GAME/$STATS"); truncated copies in $BACKUP"
fi
