---
id: 61/GUIDE_FORMAT
owner: QA Lead
rule: 00.01 Operating Rules OR-4 · work flow §1 stages 3–5
updated: 2026-10-17 (ARC-0027)
checked by: perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl check
---

# 61 · The test documents and their format

## The three documents of a piece of work

| Stage | Document | Where | What it is |
|---|---|---|---|
| 3 · Design doc | `TC_ARC-<design ticket>.md` | `61.02_Test_Cases/<S>/` | Draft: what must be proven, one line per rule (propagation, 00.08). Not played |
| 4 · Build kit | **`GUIDE_ARC-<build ticket>.json`** (+ `.md` generated) | `61.02_Test_Cases/<S>/` | **The playtest document** (the Owner's "QA_ARC"): every test, level by level, written **before** the build |
| 4 → 6 | **`QA-####`** ticket | `10.01_Product_Backlog/playtests/` | Its card on the board's Playtests tab: `backlog` (guide not playable yet) → `ready` → `in_qa` (stage 5) → `done` (every test pass or skipped) |

One open QA ticket per guide. When a guide exists, its TC draft says *superseded by GUIDE_ARC-…* and stops being updated.
A guide for probes (tests of a technical risk before the build) is named `GUIDE_ARC-<ticket>_probes.json`; it keeps its
`P<n>` ids and closes with its QA ticket.

## The guide (`GUIDE_ARC-####.json`)

```
{ "ticket": "ARC-0026",
  "title":  "The Windborn — rework WB0–WB50 (levels 1–12)",      // The <display name> — <what> (<levels>)
  "before": ["Compile the Story once…", "Not tested here: …"],     // setup for the whole guide; no other top-level key
  "sessions": [
    { "id": "L1", "level": 1, "name": "Level 1 — The Open Road",  // "Level N — <what the level adds>"
      "setup": "A new Windborn at level 1 …",
      "tests": [ { "id": "L1.2",                                   // L<level>.<n>; "A.<n>" in the "Any level — full run" session
                   "title": "After an unarmed attack, Zephyr Rush carries you to an unmarked enemy",
                   "rule": "WB5, WB18",                             // the decisions or spec items it proves
                   "steps": "…", "expected": "…", "fails": "…",
                   "planb": "…",                                    // optional: what to try if it fails
                   "kind": "observe",                               // optional: a test that only watches
                   "edition": "PC" } ] },                           // optional: PC edition only
    { "id": "ANY", "name": "Any level — full run", "setup": "…", "tests": [ … ] } ] }
```

- Display names on titles (Windborn, Veilwalker, Palerider, Heartsong — ARC-0021); folders keep the internal names.
- A test id is the key of its result on Arcana Test Guides (`<ARC>_<id>`): **never renumber a test that has a result.**
  When a guide must change under existing results, copy each result to its new id with `migrated_from: <old key>`
  (ArtifactData) — `playtests.pl sync` reports any other result that matches no test as ORPHAN.
- English, one assertion per test (OR-53).

## The pages
- **Arcana Test Guides** shows the guides of the QA tickets in `ready` or `in_qa`, one tab per subclass (display name).
- **Arcana Board → Playtests** shows every QA ticket with its passed / failed / left count.
- `/sync-test-guides` reads the results, rebuilds the QA tickets and `TEST_GUIDES.json`, runs `playtests.pl check`.
