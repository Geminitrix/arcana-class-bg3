---
id: ARC-0009
title: Create the Lionheart (was the Titan) to the subclass standard (design)
type: design
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Lead Class Designer
implementation: owner
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 05.02/Lionheart.md, 21.08_Subclass_Matrix.md, 10.06_Impediments/Open_Questions.md]
outputs: [55/_wip/Lionheart/decisions.md, 21.04/Lionheart/YYYY-MM-DD-lionheart-design.md, 55/_wip/Lionheart/texts.md, 25.01/SPL_Lionheart_*, 25.02/FEAT_Lionheart_*, 22.05/YYYY-MM-DD_ARC-0009_Lionheart_Balance.md, 55/SPEC_ARC-0009.md, 55/TOOLKIT_ARC-0009.md]
blocked_by: []
sprint:
created: 2026-10-14
---

# ARC-0009 · Create the Lionheart (was the Titan) to the subclass standard (design)

**Goal:** design the Lionheart — tarot **VIII · Strength**, the slot the game still calls *Titan* — from the
evaluation questions of `_SUBCLASS_STANDARD.md` to a raising spec, the same path the Resonant (ARC-0002) and
the Kingmaker (ARC-0008) took.
**Intent:** the Lionheart replaces the placeholder copy of the Resonant level-1 kit with a kit of its own, so
the subclass plays its own fantasy from level 1.

## Where the work goes

The design runs in a separate cloud session (Owner, 2026-10-14). When it is finished, that session commits and
pushes with this ticket's id first in every commit message, and updates:

| What | Where |
|---|---|
| Brainstorm decisions (one id per answer, `LH1`…) | `50_ENGINEERING/55_Implementation_Specs/_wip/Lionheart/decisions.md` |
| Raising spec (§1–15 of the standard) | `20_GAME_DESIGN/21_GDD_Arcana_Class/21.04_Subclasses/Lionheart/` (folder exists, empty) |
| Player-facing texts (draft until the Narrative gate) | `50_ENGINEERING/55_Implementation_Specs/_wip/Lionheart/texts.md` |
| Numbers (ADR-0005: only here) | `20_GAME_DESIGN/25_Master_Data/25.01…` (`SPL_Lionheart_*`), `25.02…` (`FEAT_Lionheart_*`) |
| Balance pass | `20_GAME_DESIGN/22_Balance_DnD5e/22.05_Balance_Reports/` |
| Role and axis column | `20_GAME_DESIGN/21_GDD_Arcana_Class/21.08_Subclass_Matrix.md` |
| Handoffs (Context Keeper, Lore Writer, Localization) | the receiving department's folder, `HANDOFF_LeadClassDesigner_to_<Role>_ARC-0009.md` |
| Implementation spec and Toolkit entry guide | `55/SPEC_ARC-0009.md`, `55/TOOLKIT_ARC-0009.md` (from `_TEMPLATE_TOOLKIT_GUIDE.md`) |
| Ticket progress | this file (criteria, gates, log); then `perl 80_TOOLS_AND_PIPELINE/82_Automation/update_board.pl` |

**Already in the game, not committed yet (Owner, Toolkit, 2026-10-14):** tag `2a90eb1d…` renamed THETITAN →
THELIONHEART, `EQP_CC_Lionheart` in `Equipment.stats`, the class name handle `ha017a8f9…` = "The Lionheart". The
ProgressionDescription still reads *Titan*. They are synced to `51` and wait for this ticket's first commit.

## Acceptance criteria

- [ ] Every evaluative question of §3 answered for the Lionheart.
- [ ] Every Owner decision recorded in `55/_wip/Lionheart/decisions.md`; open points listed in the spec.
- [ ] Raising spec written in `21.04/Lionheart/` (§1.5 sections, Identity Sheet complete).
- [ ] Role and axis in `21.08` without duplicating another subclass (note: the class lacks a magical burst/DPR subclass — `10.06`, ARC-0008).
- [ ] Balance pass: numbers in `25.01`–`25.02`, arithmetic in `22.05`.
- [ ] Handoffs sent (Context Keeper `05.02/Lionheart.md`, Lore Writer, Localization).
- [ ] `SPEC_ARC-0009` and `TOOLKIT_ARC-0009` written for the Owner's Toolkit entry.

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-14 — created (Owner request during ARC-0008). Design in a separate cloud session; the Toolkit changes
  above stay out of the ARC-0008 commit.
- 2026-10-14 — brainstorm (cloud session): direction **D · Two Hands, One Foe** chosen over A–C and E–F;
  decisions LH1–LH19 in `55/_wip/Lionheart/decisions.md` (Aspect of Courage, the Villain by highest maximum HP,
  One Labour at a Time, Stand Before the Beast, cards as Lion / Maiden containers, Finisher, Fang and Shield,
  Strength secondary). Next: chassis (saves, armour, weapons, skills), progression, Awakening, pool.
