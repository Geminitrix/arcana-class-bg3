# 61 · Test Plan — agent rules

- **Owner:** QA Lead
- **Rules:** `00.01/Operating_Rules.md` — ownership OR-26, handoffs OR-27. Read `05.00`, this file, then the ticket's inputs.

## Conventions

- The one playtest file per ARC and its format: `QA_ARC_FORMAT.md` (OR-4) — checked by `playtests.pl check`.
- File: `61.01_QA_Strategy.md` — not written yet; the strategy is the work flow (`00.01` §1 stage 5, OR-1): one `QA_ARC` per build ticket, tests level by level.
- Every test starts with the decision it informs.
- One assertion per rule.

## QA_ARC — one playtest file per ARC (Owner, ARC-0024, ARC-0027)

Every build or rework (subclass or loose feature) and every bug fix has **one** `61.02_Test_Cases/<S>/QA_ARC-####.md`
(`perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl new <ARC-####> <Subclass> "<title>"`). Format: `QA_ARC_FORMAT.md`.
The Owner plays it **level by level**, so it is built that way:

- **One section per level that unlocks something**, in ascending order: `## Level 5 — <what level 5 adds>` with its
  `**Setup:**` (the character at level 5, party, fight). A level with nothing new is left out; never group levels into ranges.
- A test goes to the level where **the last piece it needs** unlocks (levels from `21.03_Progression_Table/<S>.md`;
  slot levels from `05.01_Class`).
- **PC-edition tests** stay inside their level, with `- **Edition:** PC`; the setup says how to run them.
- Tests with no level (two of the subclass in a party, a full 1→12 run, observations over many levels) go in the last
  section `## Any level — full run` (ids `A.<n>`).
- Probes and design-stage drafts stay inside the same file (a `## Probes — …` section, an `## Appendix — …`).
- **Test ids never change** once a result exists: results on Arcana Test Guides are keyed `<ARC>_<test id>`.
- Generated, never edited by hand: the Result lines, `TEST_GUIDES.json` and `test_guides/data/` — `playtests.pl sync`
  (run by `/sync-test-guides`) writes them.

## Quality checklist

- [ ] Uses the standard saves of 83.02.
