# PROPOSAL · Toolkit guides may show numbers as a derived view (amends ADR-0005)

- **Raised by:** Lead Mod Engineer, ARC-0008 · 2026-10-13
- **Status:** proposed — awaiting the Owners

## Problem
ADR-0005 makes `25_Master_Data` the single source of every number, and the project rule says a number is
never copied elsewhere. The Owner now enters features by hand in the Toolkit from a per-ticket guide
(`55/TOOLKIT_ARC-####.md`, template `55/_TEMPLATE_TOOLKIT_GUIDE.md`). A typing guide is useless without the
values to type.

## Evidence
The Owner finds the SPEC hard to read while entering data (2026-10-13); the guide was requested so the
Toolkit work can be done point by point. A guide that says "see `SPL_X#damage`" for every field forces a
second lookup per field.

## Proposal
A Toolkit guide may show a number **only as a derived view**: the value next to its origin
(`2d6 · SPL_Example#damage`), with `derived_from` (every 25 id used) and `generated_at` in its header. The
guide is regenerated whenever one of those 25 files changes and is never edited by hand. `25` stays the
only source; the guide is a printout of it.

## Impact
ADR-0005 gains one exception: derived, regenerated views that list their sources (the Toolkit guides).
No other file may copy numbers.

## Cost
A small script (or a manual step in the Mod Engineer's checklist) that refreshes the numbers of open guides
when `25` changes.

## Risk
A stale guide if the regeneration is skipped. Mitigation: `generated_at` older than the newest file in
`derived_from` means stale; `validate.pl` can flag it.
