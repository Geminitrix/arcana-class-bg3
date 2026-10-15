# AGENTS.md — rules for every agent

Applies to the main session and to every subagent in `.claude/agents/`. Agents have no memory between
sessions: **if it is not written in a file, it did not happen.**

## 1. Orientation protocol (spec §6)

1. Read `CLAUDE.md`, this file, and the `_AGENT.md` of your own folder.
2. Open the ticket (`ARC-####`) and check its header: `status`, `implementation`, `inputs`, `outputs`,
   `blocked_by`.
3. Read only the files the ticket lists by Johnny.Decimal ID (e.g. inputs `25`, `23.02`; output `55`).
   Do not sweep the repository.
4. Write only in your own folder and inside the ticket's scope.
5. Never copy balance numbers into another file — always read them from `25_Master_Data`.
6. When done: update the ticket (status, outputs), log the session in `10.02_Active_Sprint/daily_logs/`,
   run `update_board`.
7. Leads who spawn sub-agents for micro-tasks record the scope in the ticket, have them write in the
   lead's `_wip/`, and review before marking it ready.

## 2. Ownership

- **One owner per folder** — named in its `_AGENT.md`. Others read freely.
- To ask another department for something: create `HANDOFF_<from>_to_<to>.md` **in the destination
  folder**, set your ticket to `status: blocked` with `blocked_by: <department>`, and return a summary to
  the coordinator (the main session). Subagents never call each other; the main session chains them.
- `05_LIVE_CONTEXT` is written only by the Context Keeper. `00_GOVERNANCE` only by the Owners — agents
  write proposals in `00.04_Decisions_ADR/PROPOSALS/` (problem, evidence, proposal, impact, cost, risk).

## 3. IDs and names

- Cite files by ID (`22.04`, `ARC-0142`); the ID never changes even if the folder content does.
- Folders `ID_Name_In_Snake_Case`; tickets `ARC-####`; new entries and assets `SPL_`, `CLS_`, `FEAT_`,
  `STA_`, `ICO_`. Existing mod ids keep their prefixes (ADR-0002).
- No spaces or accents in any file that ships with the mod.

## 4. Grounding (spec §32.1)

Before using any function, event, field or value: find a real example in the extracted base game
(`56`) or in the tool's documentation, and cite the path. If you can't, say "I don't know" and open a
question — never invent. Schema-valid is not the same as working: prefer a proven vanilla pattern.

## 5. Gates

- **Definition of Ready / Done:** `00.03`. DoD includes `05` updated and the README checked.
- **Design gate** (spec §18.8) and **Narrative gate** (spec §9) before a ticket reaches "Spec Ready".
- **Code gate** (spec §30.5) before a merge of code.
- Always need a human: ADRs, publishing on any platform.

## 6. Cost discipline

The Owner pays for every token. Prefer the main session over subagents for small tasks; read indexes
before files; reports ≤ 10 lines; tests are one assertion per rule.

## 7. Propagation — every change reaches every department (00.08)

- Record a decision at its source (`21.04_Subclasses/<S>/DECISIONS.md`, or the source named in the map) the
  moment it is taken. `55/_wip/` is engineering scratch only — never the home of decisions or texts.
- **At the end of every work session**, each artifact downstream of a changed source is updated **by its
  owner's role** (the main session switches roles, following each `_AGENT.md`): `/propagar`.
- A handoff is executed in the same session and marked `status: done`; it is never left for "later".
- `check_propagation.pl` must print OK before a ticket closes; a Stop hook blocks the end of a session that
  changed decisions without propagating them.
