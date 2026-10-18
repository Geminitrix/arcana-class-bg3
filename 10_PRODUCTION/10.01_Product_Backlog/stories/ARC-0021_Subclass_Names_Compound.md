---
id: ARC-0021
title: "Subclass names in one style: rename Deceiver, Unbound, Eternal and Resonant"
type: design
epic: EPIC_Rework_Subclasses
subclass: none
status: ready
owner: Lore Writer
implementation: pending
priority: should
value: 3
effort: 3
inputs: [31.01_Lore_Bible.md, 21.08_Subclass_Matrix.md, 33.03/MOD_TERMINOLOGY.md, 21.04/<S>/DESIGN.md (all six)]
outputs: [21.04/<S>/DECISIONS.md (one line per renamed subclass), 31.01, 21.08, 33.03, 32.01/<S>.md, 32.04]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0021 · Subclass names in one style

**Goal:** give the Deceiver, the Unbound, the Eternal and the Resonant names in the style of Starchild, Kingmaker and
Lionheart, chosen by the Owner, and record them in each dossier.
**Intent:** the seven subclass names read as one family — one closed English compound each, an image of its card or
theme plus a word for the person — so the class panel looks designed as a whole.

## Acceptance criteria

- [x] Style written down (`31.01` §5 or `33.03`): what the three current names share, so later names follow it
- [x] Owner picks a name for each of the four: Veilwalker, Windborn, Palerider, Heartsong
- [ ] Each choice logged in its dossier's `DECISIONS.md` — Deceiver DV33 ✓, Resonant R69 ✓; Unbound and Eternal when their dossiers open (names held in `31.01` §3, `33.03`)
- [ ] Collisions checked: other subclasses' words (DM-I6), vanilla BG3 names, well-known game names
- [ ] Player-facing text changed through a build ticket per subclass; internal ids and the folder name stay (ADR-0002)
- [ ] Mod pages, lore bible, matrix, glossary and wiki follow (propagation, 00.08)

## Gates

- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created at the Owner's request, separate from ARC-0019/ARC-0020. Owner's lead for the Resonant:
  *Heartsong*. Nothing changed in the game or the design.
- 2026-10-16 — Owner chose: Deceiver → **Veilwalker** (DV33), Unbound → **Windborn**, Eternal → **Palerider**, Resonant → **Heartsong** (R69). Unbound and Eternal have no dossier yet: their names live here, in `31.01` §3 and `33.03` until their refining opens `DECISIONS.md`. Written: style rule (`31.01` §5), `33.03`, `21.08` header, Deceiver and Resonant dossier titles and text sections, `32.04/ARC-0020_Deceiver.md` addendum; the Veilwalker strings joined `ARC-0020` `10_names.patch` (54 strings, dry run clean). Pending: game text of Windborn, Palerider, Heartsong (their build tickets; Heartsong can ride ARC-0017), translations (ARC-0013), mod pages.
- 2026-10-17 — ARC-0027 (Producer, phase D): the names are chosen; what is left happens inside each subclass build (Unbound, Eternal) — not work in progress.
