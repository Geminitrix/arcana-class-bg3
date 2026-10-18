---
id: ARC-0028
title: Bring the existing SPEC, TOOLKIT_ARC and QA_ARC files to OR-5 (order) and OR-59 (names)
type: chore
epic: EPIC_Rework_Subclasses
subclass: none
status: backlog
owner: Mod Engineer
implementation: pending
priority: should
value: 4
effort: 4
inputs: [00.01/Operating_Rules.md OR-5 OR-59, 55/SPEC_ARC-0008.md, 55/SPEC_ARC-0017.md, 55/SPEC_ARC-0020.md, 55/SPEC_ARC-0025.md, 55/SPEC_ARC-0026.md, 55/TOOLKIT_ARC-0008.md, 55/TOOLKIT_ARC-0026.md, 61.02/*/QA_ARC-*.md]
outputs: []
blocked_by: []
sprint:
created: 2026-10-18
---

# ARC-0028 · Bring the existing SPEC, TOOLKIT_ARC and QA_ARC files to OR-5 (order) and OR-59 (names)

**Goal:** reorder the existing build kits feature by feature and fix every id that breaks the mod's patterns.
**Intent:** the Owner types each feature once, in a logical order, with names the code side reads correctly.

Owner, 2026-10-18: *"Level by level"* is for the tests only. The Toolkit file goes in the best order to implement —
level by level scatters a feature that grows (a passive split across levels, revisited at level 3). And many names in
the SPEC / TOOLKIT / QA files don't follow the project's patterns. **Not to be fixed in the session that wrote the
rules** — this ticket holds the work.

## Found (2026-10-18, not exhaustive)

- `TOOLKIT_ARC-0026.md` and `SPEC_ARC-0026.md` are organised level by level (12 parts); `TOOLKIT_ARC-0008.md` by stage.
- Statuses with an `ARCANA_` prefix in the Windborn kit (already partly in the game, unpublished): `ARCANA_WINDSWEPT`,
  `ARCANA_BAG_OPEN`, `ARCANA_BAG_READY`, `ARCANA_CALM_GUST_1…5`, `ARCANA_WIND_BOREAS/NOTUS/EURUS`,
  `ARCANA_TAILWIND_*`, `ARCANA_HEADWIND_*`, `ARCANA_ZEPHYR_RUSH`, `ARCANA_STORM_RUSH`, `ARCANA_INTO_THE_STORM`.
- Interrupts outside the taxonomy: `Interrupt_Arcana_Aspect_Foreseen` (Kingmaker, in the game) and
  `Interrupt_Arcana_Aspect_FoolsLuck` (Windborn) — the pattern is `Interrupt_Arcana_Reaction_X`.
- To check: `Projectile_Deceiver_Double_SplinterBurst`, `Shout_Deceiver_Double_Shatter` against the clone pattern;
  every id in SPEC_ARC-0017/0020/0025 and in the QA_ARC files; existing shipped statuses such as `ARCANA_WEAVING` and the
  `ARCANA_IS_CARD` marker stay (published, OR-10).

## Acceptance criteria
- [ ] `TOOLKIT_ARC-0026` and `TOOLKIT_ARC-0008` (and their SPECs) in implementation order, feature by feature; each
      feature complete in one entry; the level grants written once (lists, progressions) — nothing lost
- [ ] Every id in SPEC / TOOLKIT / QA files follows OR-59; each rename of an entry already in the game listed with its
      before → after, done in the Toolkit by the Owner or under OR-11, never on a published entry
- [ ] QA_ARC test ids unchanged where a result exists (results keyed `<ARC>_<test id>`)
- [ ] `playtests.pl check`, `validate.pl`, `check_cards.pl` pass

## Log

- 2026-10-18 — created by the Producer (ARC-0027 follow-up) after the Owner's rules OR-5 and OR-59.
