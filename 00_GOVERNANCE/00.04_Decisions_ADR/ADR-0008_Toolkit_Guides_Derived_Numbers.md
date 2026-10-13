# ADR-0008 · Toolkit guides show numbers as a derived view

- **Status:** Accepted · 2026-10-13 · Owners (amends ADR-0005)
- **Origin:** `PROPOSALS/PROPOSAL_Toolkit_Guide_Derived_Numbers.md` (ARC-0008)

## Context
ADR-0005 makes `25_Master_Data` the single source of every number, and a number is never copied elsewhere. The
Owner enters features by hand in the Toolkit from a per-ticket guide (`55/TOOLKIT_ARC-####.md`, template
`55/_TEMPLATE_TOOLKIT_GUIDE.md`); a typing guide needs the values to type.

## Decision
- A Toolkit guide may show a number **only as a derived view**: the value next to its origin
  (`2d6 · SPL_Example#damage`), with `derived_from` (every `25` id used) and `generated_at` in its header.
- The guide is regenerated whenever a file in `derived_from` changes, and is never edited by hand.
- No other file may copy numbers; `25` stays the only source.

## Consequences
One documented exception to ADR-0005. A guide whose `generated_at` is older than the newest file in its
`derived_from` is stale; `validate.pl` may flag it.
