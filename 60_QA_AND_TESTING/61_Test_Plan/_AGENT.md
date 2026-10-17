# 61 · Test Plan — agent rules

- **Owner:** QA Lead (active)
- **Writes here:** the owner only. Others ask through `HANDOFF_<from>_to_<to>.md` placed in this folder and mark their ticket `blocked_by`.
- **Read before working:** `/CLAUDE.md`, `/AGENTS.md`, `05_LIVE_CONTEXT/05.00_READ_FIRST.md`, this file, then only the files the ticket lists by ID.

## Conventions

- File: `61.01_QA_Strategy.md`.
- Every test starts with the decision it informs.
- One assertion per rule.

## Test guides and playtests (Owner rule, ARC-0024)

Every build (subclass or loose feature) and every bug fix delivers a test guide `61.02_Test_Cases/<S>/GUIDE_<ARC>.json`
and its playtest ticket (`perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl new <guide> <subclass|feature|bug-retest>`).
The Owner plays a guide **level by level**, so a guide is built that way:

- **One session per level that unlocks something**, in ascending order: `{"id": "L5", "name": "Level 5", "level": 5,
  "setup": "<the character at level 5, party, fight>", "tests": [...]}`. A level with nothing new is left out; never
  group levels into ranges.
- A test goes to the level where **the last piece it needs** unlocks (levels from `21.03_Progression_Table/<S>.md`;
  slot levels from `05.01_Class`).
- **PC-edition tests** stay inside their level, marked `"edition": "PC"`; the setup says how to run them.
- Tests with no level (two of the subclass in a party, a full 1→12 run, observations over many levels) go in one last
  session `{"id": "ANY", "name": "Any level / full run"}`.
- Loose features and bug retests follow the same rule when they depend on level; otherwise only the ANY session.
- **Test ids never change** once published: results on Arcana Test Guides are keyed `<ARC>_<test id>`.
- Each test: `id`, `title`, `rule`, `steps`, `expected`, `fails`, optional `planb`, `kind: "observe"`, `edition`.
- Generated, never edited by hand: the `.md` record beside the guide, `TEST_GUIDES.json`, and the test list of the
  QA ticket — `playtests.pl sync` (run by `/sync-test-guides`) rewrites all three from the guides.

## Quality checklist

- [ ] Uses the standard saves of 83.02.
