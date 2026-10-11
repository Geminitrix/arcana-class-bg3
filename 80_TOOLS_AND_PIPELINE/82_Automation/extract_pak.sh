#!/usr/bin/env bash
# extract_pak — unpack a mod .pak and convert binary formats so two versions can be compared (spec §11).
#
#   bash 80_TOOLS_AND_PIPELINE/82_Automation/extract_pak.sh <file.pak> <output dir>
#
# Writes <output dir>/ (extracted tree, .lsf → .lsx next to the originals, .loca → .xml) and
# <output dir>.sha256 (hash of the .pak). Extractions are local only (gitignored under 76.01/**/extracted/).
# Uses Divine.exe (absolute paths only).
set -euo pipefail
DIVINE="${DIVINE:-C:/Softwares/ExportTool/Packed/Tools/Divine.exe}"
[ $# -eq 2 ] || { echo "usage: extract_pak.sh <file.pak> <output dir>" >&2; exit 1; }
PAK="$(cygpath -m "$(realpath "$1")")"
mkdir -p "$2"; OUT="$(cygpath -m "$(realpath "$2")")"

sha256sum "$1" | cut -d' ' -f1 > "${2%/}.sha256"
"$DIVINE" -g bg3 -a extract-package -s "$PAK" -d "$OUT" | tail -1
"$DIVINE" -g bg3 -a convert-resources -i lsf -o lsx -s "$OUT" -d "$OUT" | tail -1
find "$2" -name '*.loca' | while read -r f; do
  "$DIVINE" -g bg3 -a convert-loca -s "$(cygpath -m "$(realpath "$f")")" -d "$(cygpath -m "$(realpath "${f%.loca}").xml")" >/dev/null
done
echo "extracted: $(find "$2" -type f | wc -l) files, sha256 $(cat "${2%/}.sha256")"
