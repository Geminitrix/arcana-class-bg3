---
id: ARC-0033
title: "Kingmaker bugs: Ready: Foreseen never prompts, Anticipation lets allies fall, allies bound by Dethrone play as enemies"
type: bug
epic: EPIC_Rework_Subclasses
subclass: kingmaker
status: in_progress
owner: Mod Engineer
implementation: owner
priority: must
value: 5
effort: 2
inputs: [game Stats Interrupt.txt (Interrupt_Arcana_Aspect_Foreseen), game Story ARCANA_Kingmaker_Wheel + ARCANA_Aspect_WheelOfFortune (2026-11-24), 21.04/Kingmaker/DECISIONS.md (SP80, SP82, SP92, SP126), 57.05/OSIRIS.md]
outputs: [game Stats (Interrupt_Arcana_Aspect_Foreseen), game Story (ARCANA_Kingmaker_Wheel, ARCANA_Aspect_WheelOfFortune), 61.02/Kingmaker/QA_ARC-0008.md]
blocked_by: []
sprint: S01
created: 2026-11-24
---

# ARC-0033 · Kingmaker bugs: Ready: Foreseen, Anticipation, and allies bound by Dethrone

**Goal:** fix the three Kingmaker bugs the Owner found at level 12 and with cross-side bindings.
**Intent:** Ready: Foreseen offers its reaction, an ally at Tier III stays Falling two turns and then rises, and a
creature's side on the Wheel follows who it is, not which card bound it (SP126).

Reported by the Owner on 2026-11-24, after ARC-0032 compiled with 0 errors. The game was open: every change is a
copy-paste block or a Toolkit field (OR-11). Nothing here is verified in the game yet; each cause below says how sure
it is.

## The bugs and the changes

### B1 · Ready: Foreseen — the reaction never shows

**What happens:** at level 12, after casting Ready: Foreseen, no reaction prompt appears when a Reigning or Falling
enemy on the Wheel attacks an ally.

**Cause (likely, not proven in game):** `Interrupt_Arcana_Aspect_Foreseen` has no `InterruptDefaultValue`. Every other
interrupt of the mod has it (`Ask;Enabled` on the seven Arcana reactions, `Enabled` on the attack of opportunity);
without it the reaction is never set to ask. The rest of the chain is in place: `Shout_Arcana_Created_Foreseen` applies
`KINGMAKER_FORESEEN_READY`, which carries `UnlockInterrupt(Interrupt_Arcana_Aspect_Foreseen)`, and the Story answers
`KINGMAKER_FORESEEN_TECH` (`ARCANA_Aspect_WheelOfFortune`, region Tier III).

**Change (Toolkit, Stats → Interrupt → `Interrupt_Arcana_Aspect_Foreseen`):** add the field
`InterruptDefaultValue` = `Ask;Enabled`. If the prompt still does not show, the next suspect is the context
(`OnSpellCast` + `IsAttack()`): report it and it gets its own probe.

**Second round (2026-11-25):** with `InterruptDefaultValue` added the prompt still never shows (L12.4 failed). The
context is the cause: vanilla uses `OnSpellCast` only with `IsSpell()` (Counterspell, Mage Slayer, Controlled Chaos,
Psionic Backlash: 9 interrupts, none with `IsAttack()`), while every reaction to an attack on an ally uses
`OnPostRoll` + `HasInterruptedAttack()` (`Interrupt_FightingStyle_Protection`, `Interrupt_CuttingWords`,
`Interrupt_BendLuck_Bonus`; 25 interrupts use `OnPostRoll`). Source: `Shared.pak` / `Gustav.pak`
`Public/Shared*`, `GustavDev` `Stats/Generated/Data/Interrupt.txt`, extracted with Divine on 2026-11-25.

**Change (Toolkit, Stats → Interrupt → `Interrupt_Arcana_Aspect_Foreseen`)**, keeping `InterruptDefaultValue`
`Ask;Enabled`, `Properties` and `Cost` as they are:

| Field | Value |
|---|---|
| `InterruptContext` | `OnPostRoll` |
| `InterruptContextScope` | `Self;Nearby` (the Kingmaker may be the target too; `Interrupt_Arcana_Reaction_GaleDeflection` uses it) |
| `Conditions` | `IsAbleToReact(context.Observer) and HasInterruptedAttack() and Enemy(context.Source, context.Observer) and (Self(context.Target, context.Observer) or Ally(context.Target, context.Observer)) and (HasStatus('KINGMAKER_REIGNING', context.Source) or HasStatus('KINGMAKER_FALLING', context.Source)) and not AnyEntityIsItem()` |

`OnPostRoll` fires after the attack roll and before the hit resolves: the enemy steps on before the blow lands, but
its d20 is already rolled. Whether the step should also weigh on that roll (an `AdjustRoll` of the Falling penalty)
is an Owner decision, asked separately; without it the step counts from the next attack on.

### B2 · Aspect of Anticipation (Tier III) — an ally still drops to Fallen

**What happens:** at Tier III an ally on the Wheel goes Falling → Fallen instead of Falling → Falling → Rising (SP80).

**Cause (likely):** the hold is done after the fact. The turn moves the ally Falling → Fallen
(`PROC_ARCANA_Kingmaker_Move_Default`: removes `KINGMAKER_FALLING`, applies `KINGMAKER_FALLEN`), then the Tier III rule of
`PROC_ARCANA_Kingmaker_Fell` puts it back (removes `KINGMAKER_FALLEN`, applies `KINGMAKER_FALLING`). That removes and
gives back the same status in the same moment, the pattern the goals avoid on purpose (`ARCANA_Kingmaker_CrownTheKing`
header: "never removed and given back in the same moment"); the four positions also share one StackId
(`KINGMAKER_POSITION`, Overwrite). The ledger may say Falling while the ally shows Fallen.

**Change (`ARCANA_Aspect_WheelOfFortune.txt`, region `Tier III - Foreseen and Hold Ally Position instead of Fallen`):**
decide the hold **before** the step, so the ally never leaves Falling. Add this rule right after the existing
`PROC_ARCANA_Kingmaker_Move_Override` rule (the one that sends a held ally to Rising):

```
// Tier III: an ally that would step from Falling to Fallen stays Falling one more turn (SP80); the next step,
// held, takes it to Rising (the rule above). Its position status never changes, so nothing is removed and given back.
PROC
PROC_ARCANA_Kingmaker_Move_Override((GUIDSTRING)_Owner, (CHARACTER)_Creature)
AND
DB_ARCANA_Kingmaker_Moving(_Owner, _Creature, "FALLING", 1, _Order)
AND
NOT DB_ARCANA_Kingmaker_Held(_Owner, _Creature)
AND
HasActiveStatus(_Owner, "ASPECT_AWAKENED_WHEEL_III", 1)
THEN
NOT DB_ARCANA_Kingmaker_Moving(_Owner, _Creature, "FALLING", 1, _Order);
DB_ARCANA_Kingmaker_Held(_Owner, _Creature);
```

The order of the two Override rules does not matter: each consumes `DB_ARCANA_Kingmaker_Moving`, so only one acts. The
`PROC_ARCANA_Kingmaker_Fell` Tier III rule stays for the other ways an ally lands on Fallen at once (Peripeteia,
Usurp); test those apart (QA below), since they still go through the remove-and-give-back path.

### B3 · An ally bound by Dethrone plays as an enemy (Hubris, Crossings)

**What happens:** Coronation and Dethrone can target anyone (their `TargetConditions` only exclude the dead, creatures
already on the Wheel and cards), which the Owner wants for strategy. But the card decides the side: Dethrone binds at
side 0 (enemy), Coronation at side 1 (ally). An ally hit by Dethrone becomes an enemy on the Wheel: it gets Hubris when
it Reigns and takes the Crossing when it is Fallen; an enemy crowned would be Regent or King and cross its own allies.

**Decision SP126 (Owner, 2026-11-24):** the card sets the **position** (Coronation: Rising, Dethrone and Wheel of Ixion:
Falling); the **side** follows who the creature is to the Kingmaker when it enters, as SP92 already says ("whoever
entered as an ally counts as an ally").

**Change (`ARCANA_Kingmaker_Wheel.txt`, region `Coronation and Dethrone`):** replace the two `IF` rules with these four
(the comment above them stays):

```
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ALLY_TECH", (CHARACTER)_Owner, _)
AND
IsEnemy(_Owner, _Creature, 0)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "RISING", 1);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ALLY_TECH", (CHARACTER)_Owner, _)
AND
IsEnemy(_Owner, _Creature, 1)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "RISING", 0);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ENEMY_TECH", (CHARACTER)_Owner, _)
AND
IsEnemy(_Owner, _Creature, 1)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "FALLING", 0);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ENEMY_TECH", (CHARACTER)_Owner, _)
AND
IsEnemy(_Owner, _Creature, 0)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "FALLING", 1);
```

`IsEnemy(_Owner, _Candidate, 1)` is the form `ARCANA_Kingmaker_Succession` already uses. A creature that is not an
enemy (an ally, the Kingmaker, a neutral) enters on the allies' side. Succession and Wheel of Ixion only bind enemies,
so nothing changes for them. Creatures already on the Wheel keep the side they had until they leave or the fight ends.

## Acceptance criteria

- [x] B1 (both copies: `Interrupt.txt`, `Interrupt.stats`), B2 and B3 in the game (Claude, 2026-11-24, `[fechado]`).
- [x] The Story compiles with 0 errors (`Story/log.txt`, 2026-11-25 00:04).
- [ ] Ready: Foreseen readied; a Reigning enemy on the Wheel attacks an ally: the reaction is offered; taken, the enemy
      drops to Falling before the blow (L12.4).
- [x] Tier III: an ally Falling at the turn start stays Falling (status and position), the next turn it goes to Rising.
- [x] Tier III: Peripeteia on a Reigning ally leaves it Falling, not Fallen (part of L12.2).
- [x] Dethrone on an ally: it enters Falling, never gets Hubris, never takes a Crossing, and can still be crowned King.
- [x] Coronation on an enemy: it enters Rising, gets Hubris when it Reigns, never becomes Regent or King, and crosses
      when Fallen.
- [ ] `sync_data`, commit and push (OR-40).

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-11-24 — created from the Owner's report (Foreseen, Anticipation, allies with Hubris and Crossings after
  Dethrone). Causes traced in the game files; SP126 logged (the side follows the creature, not the card).
- 2026-11-24 — built by Claude on the Owner's `[fechado]` (backup `94_Safety_Backups/ARC-0033_2026-11-24/`): B1
  `InterruptDefaultValue` `Ask;Enabled` in `Interrupt.txt` and `Interrupt.stats`; B2 the hold rule in
  `ARCANA_Aspect_WheelOfFortune`; B3 the four bind rules in `ARCANA_Kingmaker_Wheel`. `check_osiris`: no errors from
  these edits (two LF lines in `CrownTheKing` come from the Story Editor). Waiting for the Owner: compile, then play.
- 2026-11-25 — the Owner compiled: 0 errors, 0 warnings. Next: the playtest criteria.
- 2026-11-25 — Owner's playtest: L12.2 (Anticipation), A.3 and A.4 (the side follows the creature) pass; L12.4
  (Foreseen) fails again: no prompt. Cause: the `OnSpellCast` context (vanilla uses it only for spells); B1 now
  moves it to `OnPostRoll` + `HasInterruptedAttack()` like `Interrupt_FightingStyle_Protection`. L12.2 includes Peripeteia
  on a Reigning ally, which passed too.
