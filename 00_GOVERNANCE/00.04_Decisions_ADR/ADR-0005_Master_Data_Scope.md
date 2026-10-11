# ADR-0005 · Scope of the master data (25)

- **Status:** Accepted · 2026-10-11 · Owners

## Context
The spec makes YAML in `25_Master_Data` the single source of every number. The existing mod has hundreds
of Stats entries; converting them by hand would create a second source that drifts from the Stats files,
and the rework will replace most of them.

## Decision
- YAML in `25` is the source for every feature **created or reworked from Sprint 0 on**.
- The current mod gets `25.05_inventory/`: read-only YAML **generated** from the Stats files by a script,
  regenerated after each sync. Never edited by hand.
- When a feature enters a rework ticket, its YAML moves from the inventory to the proper folder
  (`25.01`–`25.04`) and becomes the source.

## Consequences
One source per number at any time; no bulk hand conversion.
