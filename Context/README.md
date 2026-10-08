# Arcana — Knowledge Base

The living description of the **Arcana** class mod as it is **now**. It exists so that knowledge
survives between sessions: agents read it before working, and the author reads and edits it to
correct or extend the design.

> **Present tense only.** These files describe the current state. No changelogs, no "used to be",
> no superseded numbers. When something changes, overwrite the line. History lives in git, the
> patch notes (`Docs/PATCH_NOTES.md`) and the dated specs in `Design/specs/`.

---

## Files

| File | What it answers |
|---|---|
| [01 Identity and Lore](01-identity-and-lore.md) | What the Arcana is, Mystra and the Weave, the tarot, inspirations, tone, colours, writing voice |
| [02 Systems](02-systems.md) | Resources, Woven Spell Slots, upcasting, cards, the deck (PC edition), keywords, piles, reactions, Aspect Awakening |
| [03 Base Class](03-base-class.md) | The Arcana chassis, level table, utilities, familiars, high-level passives |
| [Unbound](subclasses/unbound.md) | 0 · The Fool — wind, unarmed, mobility |
| [Deceiver](subclasses/deceiver.md) | III · The Empress — illusion, mind control, Sigils |
| [Starchild](subclasses/starchild.md) | XVII · The Star — healing, celestial support |
| [Eternal](subclasses/eternal.md) | XIII · Death — necromantic frontline |
| [04 Subclass Comparison](04-subclass-comparison.md) | Side-by-side: roles, strengths, weaknesses, what sets each apart |
| [05 Project](05-project.md) | Editions, repository, paths, workflow, tools, test status, roadmap |
| [06 Glossary](06-glossary.md) | In-game name ↔ code name ↔ meaning |
| [07 Open Questions](07-open-questions.md) | Undecided design, known gaps, things still to verify in game |
| [Rules · Subclass Design Criteria](Rules/class-creation-rules.md) | How a subclass or the base class is designed and **evaluated**: the evaluation questions (a game-design review, not a template), the process, Identity Sheet, BG3 facts, balance, feasibility, audits |

Start with **01** and **02** for any design conversation; open the subclass file before touching a
subclass; open **05** before touching files.

---

## Source of truth

1. **The game files** (`…\Data\Public\AspectClass_…`, `…\Data\Mods\AspectClass_…`) — always win.
2. **This knowledge base** — the design as understood today. Fix it when the files disagree.
3. Design documents in `Design/specs/` — the reasoning behind decisions (dated; the oldest are in Portuguese).
4. `_archive/` holds docs from **earlier versions** of the mod (Arcane Cards, Arcane Shards, EX abilities).
   Never use it for current facts.

Two kinds of statement appear here, and they are marked differently:

- Plain text — **fact read from the files** on the date in the file's header.
- `🎯 Design intent` — what the author wants, even where the files don't fully reflect it yet.
- `❓` — open, ask the author before assuming (collected in [07](07-open-questions.md)).

---

## How to maintain it

- **Every file starts with a `Last verified` date.** Update it when you re-check the file against
  the game data.
- **When a change lands in the game files, update the matching section in the same round of work.**
  If a number changes, overwrite it; don't append.
- **Checking a subclass or the base class against the files:** run the dump script and compare
  its output to the level tables here.

  ```bash
  perl "C:/Projetos/BG3 Modding/Arcana Class/Context/tools/dump_progression.pl" > progression_dump.txt
  ```

  It prints, per class and level: boosts, passives (with English name and text) and every spell the
  level grants (name, level, school, cost, cooldown, concentration, text).
- **Adding new content** (a spell list, a subclass, the Titan): add it to the relevant file, then
  add a row to the index above if it is a new file.
- **English only** in these files (project rule for reference docs). In-game names are written exactly
  as the player sees them; code identifiers in `backticks`.
- Keep each subclass file in the same section order so they can be compared at a glance.
