# PROPOSAL · Point the router and the agent registry at the subclass standard v2 and the refining method

- **Raised by:** Lead Class Designer, ARC-0016 · 2026-10-15
- **Status:** proposed — awaiting the Owners (`CLAUDE.md` and `00_GOVERNANCE` are theirs; nothing was edited there)

## Problem
`_SUBCLASS_STANDARD.md` v2 and the new `_SUBCLASS_REFINING.md` were approved by the Owner on 2026-10-15 (ARC-0016).
Two files of the Owners still describe the old state:
- `CLAUDE.md`, "Where to look": the design row lists `21.01_Vision_and_Pillars.md` (not written yet) and does not
  mention the refining method or how to cite BG3 facts.
- `00.05_Agent_Registry/Agent_Registry.md`: the Lead Class Designer row lists `_SUBCLASS_STANDARD` only.

## Evidence
`CLAUDE.md` line 51; `Agent_Registry.md` line 10; the open question on the pillars in `10.06/Open_Questions.md` (D5);
the Owner's decision on BG3 sources (ARC-0016 log: bg3.wiki and the game file, the file wins).

## Proposal
1. `CLAUDE.md`, "Where to look", replace the design row with:

   | Any design work | `21.04_Subclasses/_SUBCLASS_STANDARD.md` (cite its questions as `DM-<id>`), cards in `27`; `21.01_Vision_and_Pillars.md` when written |
   | Reviewing or refining an existing design | `21.04_Subclasses/_SUBCLASS_REFINING.md` → `REFINE_<piece>.md` in the dossier |

2. `CLAUDE.md`, hard rule 6, add one sentence: *"For BG3 rules, cite the bg3.wiki page next to the game file; the
   file wins (`_SUBCLASS_STANDARD.md` §8)."*
3. `Agent_Registry.md`, Lead Class Designer row, reads column: `27.01, 27.02, 27.08, _SUBCLASS_STANDARD, _SUBCLASS_REFINING`.

## Impact
Every new session finds the refining method and the citing rule from the router. No ADR changes.

## Cost
Three edits by the Owners; nothing else depends on them.
