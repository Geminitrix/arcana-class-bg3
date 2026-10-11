# Lumox Studios · Arcana Class

Custom class mod for Baldur's Gate 3 (final patch 8), published on mod.io (3.1.0.28) and Nexus Mods.
The Arcana is a seer chosen by **Mystra**; each subclass is a tarot Major Arcanum that **awakens its
Aspect** in combat. Casts with **Woven Spell Slots**; the PC edition (Script Extender) turns combat into a
**deck builder** paid with **Threads**. The current work is a **rework** — it ships as **4.0.0.x**.

**This file is a router.** Rules are short; details live in the files it points to (cite them by ID).

## Read first

1. `AGENTS.md` — universal rules for every agent (ownership, handoffs, tickets, grounding).
2. `05_LIVE_CONTEXT/05.00_READ_FIRST.md` — the mod as it is **today**.
3. The `_INDEX.md` and `_AGENT.md` of the folder you work in, then only the files your ticket lists.

## Hard rules

1. **The mod lives in the game's `Data` folder and never moves** (ADR-0003):
   `…\Baldurs Gate 3\Data\{Mods,Public}\AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7\`.
   `50_ENGINEERING/51_Mod_Source/` is a synchronized **copy**, filled only by `sync_data`.
   The folder name and the `ARCANA_` / `Arcana_` / `<Type>_Arcana_Card_*` prefixes are fixed (ADR-0002).
2. **Game/Toolkit gate.** Every task message starts with `[fechado]` (game and Toolkit closed) or
   `[aberto]`; no tag = open; the tag covers that message only. Without `[fechado]`, mod files are
   read-only — hand over copy-paste blocks. The `jt-gate` hook enforces it; never work around it.
3. **Implementation on demand** (00.07). The team delivers specs (`55`); code is written in `51`/Data
   only when the Owner asks and the ticket says `implementation: claude`.
4. **Two editions.** PC edition = Script Extender (Lua only manages the deck). Console edition = no SE.
   Every gameplay effect stays in Stats / LSX / Khonsu / Osiris so both share it.
5. **Numbers live once**, in `20_GAME_DESIGN/25_Master_Data` (ADR-0005). Never copy a number elsewhere.
6. **Game files are the truth; docs are a map.** Re-read the real `.txt` / `.lsx` before changing
   anything. Never name a function, event, field or value from memory — find a real vanilla example
   (`56`) first, or say "I don't know".
7. **Never hard-delete.** Dead material goes to `90_ARCHIVE` with date and reason. `_LEGACY/` is the
   pre-migration copy — read-only, never a source of current facts.
8. **Git:** commit + push to `main` after every change, without asking; ticket id first in the message
   (`ARC-0142: …`). After writing mod files: `sync_data` → commit + push → handoff to the Context Keeper.

## Language

The user writes in Portuguese — **reply in Portuguese**. Everything in the repository and everything
that ships is in **English** (the master spec in `00.01` stays in Portuguese).

## Where to look

| Task | Read |
|---|---|
| Any design work | `21.01_Vision_and_Pillars.md`, `21.04_Subclasses/_SUBCLASS_STANDARD.md`, cards in `27` |
| Numbers, balance | `25_Master_Data`, `22`, `26` |
| Player-facing text | `31.01_Lore_Bible.md`, `31.03_BG3_Style_Guide/`, `33.03_Term_Glossary/` |
| Stats, LSX, Khonsu, Lua, Osiris | `57_Engineering_Knowledge_Base` (one card per technology) |
| Paths, Toolkit workflows, environment gotchas, Divine recipes | `57.06_Workflow_and_Quality/Environment_and_Workflows.md` |
| Tickets, sprint, board | `10.01_Product_Backlog`, `10.02_Active_Sprint` |
| Decisions | `00.04_Decisions_ADR` |
| Migration status (until Stage E) | `00.04_Decisions_ADR/MIGRATION_PLAN.md` |
