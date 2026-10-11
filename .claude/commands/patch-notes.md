---
description: Draft player patch notes from the real diff between the published baseline and a new build
argument-hint: <baseline version> <new build .pak or "current">
---

Patch notes for $ARGUMENTS (spec §11; Patch Notes Lead is dormant — do it in the main session).

1. Baseline: `70_RELEASE_AND_DISTRIBUTION/76_Patch_Notes/76.01_Published_Baseline/v<X>/` must hold the
   published `.pak` + hash and its extraction (`82_Automation/extract_pak.sh`). If missing, ask the Owner
   for the `.pak` and stop.
2. New build: extract it the same way, or use `50_ENGINEERING/51_Mod_Source` for "current".
3. `perl 80_TOOLS_AND_PIPELINE/82_Automation/compare_versions.pl <baseline dir> <new dir>` →
   `76.02_Version_Diffs/DIFF_v<A>_to_v<B>.md`.
4. Cross-check with tickets: a diff change with no ticket = alert; a done ticket with no diff = alert.
5. Draft in `76.04_Drafts/PATCH_v<X.Y.Z>.md` following `76.03_Writing_Standard`: opening + highlights, one
   section per subclass (and the base class), one-sentence intent per entry, lines
   `Attribute: before ⇒ **after**`, labels NEW / REMOVED, then Bug fixes ("Fixed a bug where…") and Text
   and localization. Official in-game names (`33.03`).
6. The Owner reviews and publishes; then move the final text to `76.05_Published/`.
