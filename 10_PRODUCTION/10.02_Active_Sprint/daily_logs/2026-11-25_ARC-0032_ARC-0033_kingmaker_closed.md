# 2026-11-25 · Kingmaker fixes closed (ARC-0032, ARC-0033, Producer)

**Done:** the Owner played every criterion of both tickets and they pass. ARC-0033's Foreseen took three rounds: the
`OnSpellCast` context (vanilla uses it only for spells) became `OnPostRoll` + `HasInterruptedAttack()`, and the extra
`HasLastAttackTriggered()` the game copy carried was removed (it only exists after a hit, vanilla `CommonConditions.khn`).
The Owner chose SP127 (a Reigning attacker loses 1d4 on the interrupted roll) and wrote the Foreseen Ready text
(Attack Roll capitalised, the mod's "subtracts 1d4").

**Found at the close (`sync_data`):** the Owner's Stats make Dethrone damage only enemies - logged as SP128 and
propagated (DESIGN §7.3, 23.02, 32.01, 05.02). Usurp's text lost "Once per combat." (the cooldown still shows it).

**Open, not blocking:**
- Windborn: `Interrupt_Arcana_WindWhispers_Riposte` lost `IsMiss()` in the Owner's edits, so the Riposte now fires on
  any melee attack, not only a miss (WB33/WB57 design). Asked the Owner; not propagated.
- The Kingmaker's own build ticket ARC-0008 stays `in_qa` until the QA_ARC-0008 results are synced (`/sync-test-guides`).
- The other 14 languages still carry the old Kingmaker texts (translation sync).

**Windborn Riposte (2026-11-25):** the Owner removed `IsMiss()` thinking it was wrong; told it is the design (WB57) and the
vanilla Riposte's own condition, the Owner chose to put it back. Block given (Toolkit, game open): the Conditions as
before the edit, `IsMiss()` back and `HasStatus('INVISIBILITY')` without `context.Source`, as in vanilla. No design change.
ARC-0034 opened for it (implementation: claude; applied on the Owner's `[fechado] ARC-0034`), INVISIBILITY restored too.

**ARC-0034 done (2026-11-25):** the Owner played the Windborn's L5.3 with the restored Riposte conditions: pass.
