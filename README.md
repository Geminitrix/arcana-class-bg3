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
| Unbound | 0 · The Fool | Existing — rework |
| Deceiver | II · The High Priestess | Existing — rework |
| Starchild | XVII · The Star | Existing — rework |
| Eternal | XIII · Death | Existing — rework |
| Resonant | XIV · Temperance | New — in design |
| Spinner | X · Wheel of Fortune | New — in design |
| Lionheart | — | New — in design |

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

Stages A (skeleton) and B (copy migration, first live-context load) done on 2026-10-11. Next: Stage C (standards) —
see `00_GOVERNANCE/00.04_Decisions_ADR/MIGRATION_PLAN.md`.

## Credits & disclaimer

- **Author:** Lumox ([Geminitrix](https://github.com/Geminitrix)) — Lumox Studios.
- Baldur's Gate 3 is © Larian Studios. This is an unofficial fan modification not affiliated with or
  endorsed by Larian Studios or Wizards of the Coast.
