# ADR-0008 · Every change propagates to every department, every session

- **Status:** Accepted · 2026-10-15 · Owner

## Context
From 2026-10-12 to 10-15 the design of the Resonant, Kingmaker (was Spinner) and Lionheart produced ~160 files
in `55/_wip/` (decisions, texts, stage scripts) while the department folders stayed almost untouched: no
spell sheets (23), no economy audits (26), no art briefs (42), one file each in 31/32/33, the subclass mirror
(05.02) frozen at 2026-10-11, seven handoffs never executed. Causes: no map of what each change must update,
handoffs were passive files, the main session did all the work in one folder, and closing a ticket did not
check the departments.

## Decision (Owner answers, 2026-10-15)
1. **Who:** the main session plays each department's role, following its `_AGENT.md` — no subagents unless the
   Owner asks (keeps the cost rule of 2026-10-07).
2. **When:** at the end of every work session, and before any ticket closes.
3. **Scope:** every kind of change — subclass, base class, system, card, item, implementation in the game.
4. **Backlog:** the Resonant, the Kingmaker and the Lionheart are propagated now, one subclass per message.

Mechanism: `00.08_Propagation_Map` (what each change updates and who owns it) · `check_propagation.pl`
(MISSING / STALE artifacts, open handoffs) · `/propagar` · a Stop hook that blocks ending a session that
changed decisions in it without propagating · `/fechar-ticket` requires the check to pass · decisions live in
`21.04_Subclasses/<S>/DECISIONS.md`, never in `55/_wip`.

## Consequences
Each design session costs a little more at its end; in exchange every department folder stays true and any
agent can start from its own folder.
