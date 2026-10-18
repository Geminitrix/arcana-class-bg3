---
id: 61/QA_ARC_FORMAT
owner: QA Lead
rule: 00.01 Operating Rules OR-4 · work flow §1 stages 3–6
updated: 2026-10-17 (ARC-0027 — Owner: one TOOLKIT_ARC and one QA_ARC per ARC)
checked by: perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl check
---

# 61 · QA_ARC — the one playtest file per ARC

## One file per ARC, two jobs

| File | Where | What the Owner does with it |
|---|---|---|
| `TOOLKIT_ARC-####.md` | `55_Implementation_Specs/` | Reads it in the Toolkit: a part per level, typed in order (`_TEMPLATE_TOOLKIT_GUIDE.md`) |
| **`QA_ARC-####.md`** | `61.02_Test_Cases/<Subclass>/` | Plays it: the tests **separated by level**, with each result — and it is the card on the board's Playtests tab |

`####` is the build ticket. Nothing else holds tests: probes, design-stage drafts and closed results live **inside** the
QA_ARC. The JSON the Arcana Test Guides page loads (`test_guides/data/…`) is an export written by `playtests.pl sync`.

## Life of a QA_ARC

| Status | When | What is in it |
|---|---|---|
| `draft` | Stage 3 (design doc) and 4 (build kit) | What must be proven; may be free text or an appendix until the build kit structures it |
| `ready` | Build kit done (stage 4) | Every test, level by level, **before** the build |
| `in_qa` | Stage 5 — the Owner types level N, Claude verifies, the Owner plays level N | Results come back at `/sync-test-guides` |
| `done` | Every test pass or skipped; each fail fixed or decided (OR-1) | The record |

## The file

```
---
id: QA_ARC-0026
title: Playtest — The Windborn — rework WB0–WB50 (levels 1–12)     # Playtest — The <display name> — <what> (<levels>)
type: playtest
subclass: unbound                                                 # the board's lowercase key
build: ARC-0026
status: in_qa                                                     # draft | ready | in_qa | done
owner: QA Lead
sources: [...]                                                    # files merged into it, when any
created: 2026-10-17
---

# QA_ARC-0026 · The Windborn — rework WB0–WB50 (levels 1–12)

**Goal:** … **Intent:** …

## Before you start
- Compile the Story once …

## Probes — stage 1 (closed: 9/9 pass)          # optional; "(closed …)" or "(… never applied)" keeps it off the page
**Setup:** …
### P1 · A Rush: no opportunity attack, paths around obstacles
- **Rule:** …
- **Steps:** …
- **Expected:** …
- **Fails if:** …
- **Result:** pass

## Level 1 — The Open Road                        # "Level N — <what the level adds>", one section per level
**Setup:** A new Windborn at level 1 …
### L1.2 · After an unarmed attack, Zephyr Rush carries you to an unmarked enemy
- **Rule:** WB5, WB18                             # the decisions or spec items it proves
- **Steps:** …
- **Expected:** …
- **Fails if:** …
- **Plan B:** …                                   # optional
- **Kind:** observe                               # optional: a test that only watches
- **Edition:** PC                                 # optional: PC edition only
- **Result:** FAIL — <the Owner's notes>          # pass | skipped | FAIL — notes | note — notes | — (not played)

## Any level — full run
### A.1 · …

## Appendix — <source> (design-stage draft, verbatim)   # optional; never parsed
## Gates
- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)
## Log
```

- Test ids: `L<level>.<n>`, `A.<n>` in "Any level", `P<n>` in a probes section. **A test with a result is never renumbered**: the
  result's key on the page is `<ARC>_<test id>`. If a test must move, copy its result to the new id with `migrated_from`
  (ArtifactData) — `playtests.pl sync` reports any other result that matches no test as ORPHAN.
- Each field on one line; English; one assertion per test (OR-53). The Result lines are written by `/sync-test-guides`.
- New file: `perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl new <ARC-####> <Subclass> "<title>"`.

## The pages
- **Arcana Test Guides** — the QA_ARC files in `ready` or `in_qa`, one tab per subclass (display name), level by level.
- **Arcana Board → Playtests** — every QA_ARC with its passed / failed / left count (Draft · Ready · In QA · Done).
- `/sync-test-guides` reads the page's results, writes them into the QA_ARC files, exports the page data, runs `check`.
