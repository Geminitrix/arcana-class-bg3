# The Arcana — Custom Class for Baldur's Gate 3

*Lumox Studios · private repository · published version **3.1.0.28** (mod.io, Nexus Mods) · rework in
progress → **4.0.0.x***

> *"We were chosen by the Lady of Mysteries, and the Weave answers when we pull on its threads."*

**The Arcana** is a full custom class for *Baldur's Gate 3*. Bound to the Weave by Mystra's own hand, the
Arcana are a seer class: each subclass is a tarot Major Arcanum that **awakens its Aspect** in combat. The
class casts with **Woven Spell Slots**, which scale to the highest slot level; the PC edition (Script
Extender) turns combat into a **deck builder** paid with **Threads**.

## Scope

- **Core: levels 1–12** (the base game's cap). All class and subclass mechanics are complete inside it.
- **Expansion module: levels 13–20**, later. Nothing in the core depends on it.

## Subclasses

| Subclass | Arcanum | Status |
|---|---|---|
| Unbound (Windborn) | 0 · The Fool | Existing — rework in build (ARC-0026) |
| Deceiver (Veilwalker) | II · The High Priestess | Existing — refining designed, build ready (ARC-0020) |
| Starchild | XVII · The Star | Existing — rework designed, build ready (ARC-0025) |
| Eternal | XIII · Death | Existing — rework |
| Resonant (Heartsong) | XIV · Temperance | Implemented — refining built, tests pending (ARC-0017) |
| Kingmaker | X · Wheel of Fortune | Implemented — built 1–12 (ARC-0008), probes pending |
| Lionheart | VIII · Strength | New — designed (ARC-0009), build pending |

## Repository map

The repository follows a Johnny.Decimal index; cite any file by its ID (`22.04`, `ARC-0142`). Every
category has an `_INDEX.md` (what's here) and an `_AGENT.md` (owner, rules, checklist).

| Area | Department |
|---|---|
| `00_GOVERNANCE` | Studio rules, ADRs, agent registry, licences |
| `05_LIVE_CONTEXT` | The mod as it is today — **start here** (`05.00_READ_FIRST.md`) |
| `10_PRODUCTION` | Backlog, sprints, ceremonies, roadmap |
| `20_GAME_DESIGN` | GDD, balance, spells, master data (YAML), resource economy |
| `30_NARRATIVE_AND_LORE` | Lore, BG3 integration, localization |
| `40_ART_AND_UI` | Icons, UI, VFX |
| `50_ENGINEERING` | Synchronized copy of the mod, specs, build, knowledge base |
| `60_QA_AND_TESTING` | Test plan, bugs, evidence |
| `70_RELEASE_AND_DISTRIBUTION` | Packaging, mod pages, patch notes, player guide (Codex) |
| `80_TOOLS_AND_PIPELINE` | External tools, automation scripts, test environment |
| `90_ARCHIVE` | Closed sprints, discarded ideas, old versions |

New here? Read `CLAUDE.md`, `AGENTS.md`, then `05_LIVE_CONTEXT/05.00_READ_FIRST.md`.

## Migration status

The migration to this structure is complete (stages A–E, 2026-10-11; record in
`00_GOVERNANCE/00.04_Decisions_ADR/MIGRATION_PLAN.md`). Sprint 0 is running — board in `10.02_Active_Sprint`; the whole backlog as a kanban
board artifact in `80_TOOLS_AND_PIPELINE/82_Automation/kanban` (ARC-0018).

## Credits & disclaimer

- **Author:** Lumox ([Geminitrix](https://github.com/Geminitrix)) — Lumox Studios.
- Baldur's Gate 3 is © Larian Studios. This is an unofficial fan modification not affiliated with or
  endorsed by Larian Studios or Wizards of the Coast.
- Arcana Class is unofficial Fan Content permitted under the Fan Content Policy. Not approved/endorsed by
  Wizards. Portions of the materials used are property of Wizards of the Coast. ©Wizards of the Coast LLC.
