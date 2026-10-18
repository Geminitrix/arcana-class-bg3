---
id: 00.01/Operating_Rules
owner: Owner (changes need the Owner's OK)
updated: 2026-10-17
replaces: Studio_Architecture_and_Agile_Flow_v0.4_PT.md (archived 2026-10-17, 93), 00.07 Implementation_Policy, the rule sections of AGENTS.md
---

# 00.01 · Operating Rules — Lumox Studios · Arcana Class

**The single home of every studio rule.** Other files (CLAUDE.md, AGENTS.md, `_AGENT.md`, agents, commands) point here by
number — `OR-12` — and never restate a rule. To change a rule: edit it here first (with the Owner's OK), record the
reason in an ADR (`00.04`) when it is structural, then fix the pointers. Claude's private memory never holds project rules.

**The studio:** the **Owner** decides, types in the Toolkit and plays; **one Claude main session** does the rest, switching
between the 9 active roles of `00.05_Agent_Registry`.

---

## 1. The work flow

Every piece of work — a subclass, a rework, a card, a system, an item — is one ticket that walks these stages. The status
is the ticket's `status:` field; the board (`/sync-board`) shows it.

| # | Stage | Status | Who | Output | Gate to the next stage |
|---|---|---|---|---|---|
| 1 | **Intake** | `backlog` → `ready` | Producer | Ticket `ARC-####` (`/novo-ticket`): goal, intent, inputs | Definition of Ready (`00.03`); picked for the sprint |
| 2 | **Ideation** | `in_progress` | Lead Class Designer with the Owner | Brainstorm (OR-51); every answer logged at once in `21.04/<S>/DECISIONS.md` | The Owner says the ideas are complete |
| 3 | **Design doc** | `in_progress` → `in_review` | Lead Class Designer · Balance · Lore | `DESIGN.md` (the whole design, present tense, no history) · numbers in `25` · texts in `32.01` | **Design gate** (`_SUBCLASS_STANDARD` §15) + **Narrative gate** (`32.04`) + the Owner approves the design |
| 4 | **Build kit** | `spec_ready` | Mod Engineer · QA | `SPEC_ARC-####` (what; one stage per level) · `TOOLKIT_ARC-####_L<n>.md` (how to type it, `_TEMPLATE_TOOLKIT_GUIDE`) · `GUIDE_ARC-####.json` (the tests, written **before** the build) | The Owner starts typing |
| 5 | **Build & test**, one level at a time | `in_qa` | Owner types · Claude verifies · Owner plays | Level N typed → Claude: `sync_data`, validators, compare with the spec item by item, **fix every divergence** (OR-11) → Owner plays level N's tests → level N+1 | Every test passes |
| 6 | **Close** | `done` | Producer + every role | `/propagar`, `05` updated, a patch-notes line (`76.04`), `/fechar-ticket` | DoD (`00.03`), `check_propagation` OK |

- **OR-1** A failed test is either a **bug** (the build differs from the spec → fix it, stage 5) or **design feedback**
  (the spec is right but it doesn't play well → a new decision in `DECISIONS.md`, back to stage 3 for that part).
- **OR-2** Work that doesn't touch the game (a document, a tool, a page) skips stages 4–5.
- **OR-3** No stage is skipped silently: if the Owner wants to jump ahead, log it in the ticket.

## 2. The game and the write gate

- **OR-10** The mod lives in the game's `Data` folder and never moves (ADR-0003). `50_ENGINEERING/51_Mod_Source` is a
  copy filled only by `sync_data`. Nothing but the mod lives in `Data`: documents, backups and outputs go to the
  project. Vanilla data is packed there (no loose files) — read the local extraction or use `Divine.exe` with absolute
  paths (`57.06/Environment_and_Workflows.md`). The folder name and the `ARCANA_` / `Arcana_` / `<Type>_Arcana_*` prefixes are fixed
  (ADR-0002); a published entry is never renamed or deleted.
- **OR-11** **The Owner implements everything in the Toolkit.** Claude writes in the game copy only to fix a divergence
  found in verification (stage 5) or when the Owner asks for a specific change — and only when the message starts with
  **`[fechado]`** and names the ticket (`ARC-####`, `implementation: owner`). `[aberto]` or no tag = game or Toolkit open
  → read only; changes go as copy-paste blocks. The tag covers that message only. The `jt-gate` hook enforces it (ADR-0007);
  a script that writes to `Data` is a write too — check the gate yourself, never work around it.
- **OR-12** Outside the Toolkit every table has two copies (`Public/…/*.lsx` + `Editor/Mods/…/*.tbl`; Stats `.txt` +
  `.stats`): change both, back them up first in `94_Safety_Backups/ARC-####_<date>/`, then `sync_data`.
- **OR-13** Game files are the truth; documents are a map. Never name a function, event, field or value from memory: find
  a real vanilla example (`56`, the local extraction `C:\Projetos\BG3\Base Game BG3\`) or the tool's documentation, cite
  it, or say "I don't know". A BG3 fact = bg3.wiki page + game file; the file wins.
- **OR-14** Two editions: PC = Script Extender, Lua only manages the deck; console = no SE. Every gameplay effect lives in
  Stats / LSX / Khonsu / Osiris so both share it.
- **OR-15** Osiris: the Owner compiles in the Story Editor; Claude reads `Story/log.txt` afterwards.

## 3. Where each truth lives (write it once)

| What | The one place |
|---|---|
| Decisions | `21.04_Subclasses/<S>/DECISIONS.md`, logged the moment they are taken |
| The current design | `21.04_Subclasses/<S>/DESIGN.md` |
| Every number | `25_Master_Data` (ADR-0005) — never typed anywhere else |
| Player-facing text · terms | `32.01` · `33.03` |
| The mod as it is today | `05_LIVE_CONTEXT` |
| Tickets, sprint, board | `10_PRODUCTION` |
| Build kit · tests | `55` · `61.02/<S>/` |
| Rules | this file |

- **OR-20** A proposal waiting for the Owner (`status: proposal`, undated name) is not a decision; nothing downstream
  changes until it is logged in `DECISIONS.md`.
- **OR-21** `55/_wip/` is engineering scratch only — never the home of decisions or texts.

## 4. Roles and propagation

- **OR-25** The main session plays every role, following the role's file in `.claude/agents/` and the folder's
  `_AGENT.md`. **No subagents unless the Owner asks** (cost).
- **OR-26** Each folder has one owner role and each ticket one `owner:` — always one of the 9 active roles of `00.05`
  (the table "Folder owners" there is the source; `_AGENT.md` / `_INDEX.md` copy it). Anyone reads anything.
- **OR-27** A handoff (`HANDOFF_<from>_to_<to>.md` in the destination folder) is executed **in the same session** by
  switching to the destination role, then marked `status: done` (or `deferred` with reason and ticket). Nobody waits.
  Done handoffs move to `91_Closed_Sprints/<sprint>/handoffs/` when the sprint closes.
- **OR-28** **Propagation:** at the end of every session each artifact downstream of a changed source is updated, or its
  `reviewed:` line refreshed (`/propagar`, map `00.08`, ADR-0009). `check_propagation.pl` must print OK before a ticket
  closes; a Stop hook reminds you.

## 5. Production

- **OR-35** Every piece of work has a ticket; every commit message starts with its id (`ARC-0142: …`).
- **OR-36** One sprint at a time (`10.02/SPRINT_GOAL.md`). **WIP limit 3**: at most three tickets in `in_progress` or
  `in_qa` at once; finish before starting. `in_review` is the Owner's queue (work waiting for an approval) and doesn't
  count, but keep it short. A sprint lasts one week; at its end `/retro` archives it in `91_Closed_Sprints/`.
- **OR-37** A session that changes anything ends with a daily-log entry (`10.02/daily_logs/`) and `/sync-board`.
- **OR-38** The README is checked whenever a subclass state, the version or the structure changes (`check_readme.pl`).

## 6. Git

- **OR-40** Commit and push to `main` after every change, without asking. After changing `Data`: `sync_data` first.
- **OR-41** Several sessions share `main`: `git add` only the paths you wrote, check `git diff --cached --stat`,
  `git fetch` before picking a new `ARC-####` or ADR number, never rewrite pushed history.

## 7. Writing and conversation

- **OR-50** Talk to the Owner in Portuguese; everything in the repository and everything that ships is in English.
- **OR-51** Design questions: one per message, three options that are all genuinely good, compared on the same worked
  turn, then a separate recommendation. A rework or refining brings the audit **and** 2–3 alternative kits.
- **OR-52** Player text follows `31.03` and `33.03`; never copy a vanilla line; numbers come from `25` through `[n]`.
- **OR-53** Reports ≤ 10 lines; tests are one assertion per rule; read an `_INDEX.md` before opening files.

## 8. Names and ids

- **OR-56** Cite files by their Johnny.Decimal id (`22.04`, `ARC-0142`). Folders `ID_Name_In_Snake_Case`; tickets
  `ARC-####`, playtests `QA-####`; design ids `SPL_`, `FEAT_`, `STA_`, `ICO_`; shipped mod ids keep their prefixes (OR-10).
- **OR-57** No spaces or accents in any file that ships with the mod.

## 9. Only the Owner

- **OR-58** Only the Owner approves an ADR, a rule change, a design (stage 3), and any publishing on a platform.

## 10. Archive

- **OR-60** Never hard-delete. Retired material goes to `90_ARCHIVE` (`93_Old_Versions` with date and reason in its
  README and `_INDEX`). `_LEGACY/` is the pre-migration copy — read only, never a source of current facts.
