---
id: ARC-0034
title: "Windborn Riposte: restore the tested conditions (IsMiss, INVISIBILITY)"
type: bug
epic: EPIC_Rework_Subclasses
subclass: unbound
status: done
owner: Mod Engineer
implementation: claude
priority: must
value: 4
effort: 1
inputs: [game Stats Interrupt.txt + Interrupt.stats (Interrupt_Arcana_WindWhispers_Riposte, 2026-11-25), 51 copy before 0f30eac, 21.04/Unbound/DECISIONS.md (WB33, WB57), 61.02/Unbound/QA_ARC-0026.md (L5.3)]
outputs: [game Stats (Interrupt_Arcana_WindWhispers_Riposte, both copies), 51 copy (sync_data)]
blocked_by: []
sprint: S01
created: 2026-11-25
---

# ARC-0034 · Windborn Riposte: restore the tested conditions

**Goal:** put the Wind Whispers Riposte's `Conditions` back to the text that was tested and approved in ARC-0026.
**Intent:** the Riposte answers only a melee attack that misses, by an enemy that isn't Windswept (WB57), as before.

Found at the close of ARC-0033 (`sync_data`, `0f30eac`): an Owner edit removed `IsMiss()` and gave the invisibility test
the attacker (`context.Source`). On 2026-11-25 the Owner chose to restore both: `IsMiss()` is the design (WB57: "Riposte
when one of them misses") and the vanilla Riposte's own condition (`Interrupt_Riposte`: `OnCastHit`, `IsMeleeAttack()
and IsMiss()`). No design change. Claude applies it when the Owner sends `[fechado] ARC-0034` (OR-11).

## The change

`Interrupt_Arcana_WindWhispers_Riposte` → `Conditions`, in both copies (OR-12): `Public/.../Stats/Generated/Data/Interrupt.txt`
and `Editor/Mods/.../Stats/Stats/Interrupt.stats`.

Now (game, 2026-11-25):

```
IsAbleToReact(context.Observer) and Enemy(context.Source,context.Observer) and IsMeleeAttack() and not HasStatus('WINDSWEPT',context.Source) and not HasStatus('INVISIBILITY',context.Source) and not AnyEntityIsItem() and not DistanceToEntityGreaterThan(2, context.ObserverPosition, context.Source) and HasLastAttackTriggered();
```

Restored (the 51 copy before `0f30eac`, tested in ARC-0026 L5.3):

```
IsAbleToReact(context.Observer) and Enemy(context.Source,context.Observer) and IsMeleeAttack() and IsMiss() and not HasStatus('WINDSWEPT',context.Source) and not HasStatus('INVISIBILITY') and not AnyEntityIsItem() and not DistanceToEntityGreaterThan(2, context.ObserverPosition, context.Source) and HasLastAttackTriggered();
```

Nothing else in the entry changes.

## Acceptance criteria

- [x] Both copies carry the restored `Conditions`; the rest of the entry is unchanged (one line each against the backup; the `.stats` entry is identical to the 51 copy before `0f30eac`).
- [x] In game (ARC-0026 L5.3): with Wind Whispers up, an unmarked enemy's melee attack that misses offers the Riposte;
      one that hits does not (the Owner's playtest, 2026-11-25).
- [x] `sync_data`, commit and push (OR-40).

## Gates

- [x] DoD (`00.03`)

## Log

- 2026-11-25 — created on the Owner's request: restore `IsMiss()` and `HasStatus('INVISIBILITY')` as tested and approved.
- 2026-11-25 — built by Claude on the Owner's `[fechado]` (backup `94_Safety_Backups/ARC-0034_2026-11-25/`); waiting for
  the Owner's L5.3 check in game.
- 2026-11-25 — done. The Owner played L5.3 and it passes. DoD: criteria met; outputs listed; no numbers outside 25;
  05 unchanged (the game matches 05.02 again); README matches 05.00; daily log; `check_propagation` OK; `sync_data` run.
