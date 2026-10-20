# 57.05 · Osiris — card, pattern catalogue, agent evaluation

*Spec Part III §29 and §32.3. **The authority is `OSIRIS.md` in this folder** (501 lines, BG3 Patch 8,
tested): layers, file anatomy, DBs, rule kinds, types, calls vs queries, timers, signature index and a
pattern cookbook from this mod. The Larian wiki describes DOS2 — its concepts hold, its API does not.*

## In one minute
- Declarative, rule-based (Prolog-like). Rules react to **events**, ask the game through **queries**,
  change it through **calls**. All goals of the mod and its dependencies form the **Story**. Source:
  `Mods/<Mod>/Story/RawFiles/Goals/*.txt`; authoritative signatures: `story_header.div`.
- Goal = `INITSECTION` · `KBSECTION` · `EXITSECTION`. DBs start with `DB_` and are global to every mod;
  `QRY_` and `PROC_` likewise — always use the `ARCANA_` prefix.
- **Bug sources:** no `main`, rules fire only on events or fact changes · rules evaluate top to bottom
  across the whole Story, goals sorted **alphabetically** · `INITSECTION` must not query the game or rely on
  other goals · a repeated fact doesn't fire again (`NOT DB_…` first) · first use pins column types ·
  everything an event triggers happens in one frame · clean unused DBs in `EXITSECTION`.
- Compile in the Story Editor (Toolkit open) and **always read `Story/log.txt`** — warnings catch real
  defects (`57.06/Environment_and_Workflows.md` §2).
- **House standard** for every goal: `OSIRIS.md` §13 (header, regions, English comments without history, `ARCANA_`
  names, timers cancelled before launch, tables in an Init PROC), checked by `82_Automation/check_osiris.pl`.

## Building the Osiris specialist agent (spec §32.3) — status
1. Locate `story.div.osi` of Gustav, GustavDev, Honour. 2. Extract the goals with LSLib → `56.01` (local,
gitignored). 3. Index (`82_Automation/indexar_vanilla`, planned) → `56.05`: parent goal, first trigger of
each rule, DBs defined / read, PROCs and QRYs, native calls. 4. Pattern catalogue here: 2–3 real examples
per common task, with file path and own-words explanation (seed: `OSIRIS.md` §10). 5. Agent definition
`.claude/agents/osiris-engineer.md` (Stage D). 6. **Evaluation before activation:** ~10 tasks (explain a
goal, find where an event is handled, write a rule equivalent to an existing one); the agent is activated
only if it answers right and cites sources; results recorded here. 7. Extraction is done once (final game
version) and repeated only if the game or SE version changes.

Local material today: `C:\Projetos\BG3\Base Game BG3\Osiris\osiris-guide.md`; the goals extraction is
still to do.
