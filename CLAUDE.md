# Lumox Studios · Arcana Class

Custom class mod for Baldur's Gate 3 (final patch 8), published on mod.io (3.1.0.28) and Nexus Mods.
The Arcana is a seer chosen by **Mystra**; each subclass is a tarot Major Arcanum that **awakens its
Aspect** in combat. Casts with **Woven Spell Slots**; the PC edition (Script Extender) turns combat into a
**deck builder** paid with **Threads**. The current work is a **rework** — it ships as **4.0.0.x**.

**This file is a router.** Every rule lives once, numbered, in the rulebook imported below; cite rules as `OR-n`.

@00_GOVERNANCE/00.01_Studio_Constitution/Operating_Rules.md

## Read first

1. The rulebook above — above all the work flow (§1) and the write gate (OR-11).
2. `05_LIVE_CONTEXT/05.00_READ_FIRST.md` — the mod as it is **today**.
3. The ticket you work on, then the `_INDEX.md` and `_AGENT.md` of the folder, then only the files the ticket lists.

## Where to look

| Task | Read |
|---|---|
| Any design work | `21.04_Subclasses/_SUBCLASS_STANDARD.md`, `_SUBCLASS_REFINING.md`, cards in `27` |
| Numbers, balance | `25_Master_Data`, `22`, `26` |
| Player-facing text | `31.01_Lore_Bible.md`, `31.03_BG3_Style_Guide/`, `33.03_Term_Glossary/` |
| Build kit (SPEC, Toolkit guide) | `55` templates `_TEMPLATE_SPEC.md`, `_TEMPLATE_TOOLKIT_GUIDE.md` |
| Stats, LSX, Khonsu, Lua, Osiris | `57_Engineering_Knowledge_Base` (one card per technology) |
| Paths, Toolkit workflows, environment gotchas, Divine recipes | `57.06_Workflow_and_Quality/Environment_and_Workflows.md` |
| Tests | `61.02_Test_Cases/<S>/`, `61_Test_Plan/TEST_GUIDES.json` |
| Tickets, sprint, board | `10.01_Product_Backlog`, `10.02_Active_Sprint` |
| Decisions | `00.04_Decisions_ADR` |
| Roles, slash commands, hook | `.claude/` — registry in `00.05_Agent_Registry`; commands: `/novo-ticket` `/iniciar-sprint` `/handoff` `/propagar` `/fechar-ticket` `/retro` `/sync-contexto` `/patch-notes` `/commit-e-push` `/sync-board` `/sync-test-guides` `/auditoria` |
| Migration record (complete) | `00.04_Decisions_ADR/MIGRATION_PLAN.md`, `MIGRATION_MANIFEST.md` |
