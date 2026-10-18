---
id: QA_ARC-0001
title: Playtest — The Deceiver — level-20 cleanup (static checks)
type: playtest
subclass: deceiver
build: ARC-0001
status: done
owner: QA Lead
sources: [TC_ARC-0001]
created: 2026-10-17
---

# QA_ARC-0001 · The Deceiver — level-20 cleanup (static checks)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0001 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from TC_ARC-0001.

> Closed record: static checks, PASS 5/5 (2026-10-11); details in the appendix.

## Appendix — TC_ARC-0001 (design-stage draft, verbatim)

### TC_ARC-0001 · Deceiver level 20 has no dead PassivesRemoved

- **Decision it informs:** close ARC-0001 or send it back to the Owner.
- **Hypothesis:** after the Toolkit edit, only the Deceiver level-20 row differs, and it has no
  `PassivesRemoved`.
- **Scenario:** static — no game session needed (level 20 is beyond the 1–12 core).
- **Steps and expected results (one assertion each):**
  1. `bash 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh` → 51 refreshed.
  2. `perl 80_TOOLS_AND_PIPELINE/82_Automation/validate.pl` → `OK: 0 errors`.
  3. Same output, check 3 → no line `Deceiver level 20`.
  4. `git diff --stat 50_ENGINEERING/51_Mod_Source` → only the Deceiver progression file(s) changed.
  5. `grep -c 'new entry "Arcana_Passive_UnlockFriends"'` in `Passive.txt` → `1`.
- **Result (2026-10-11): PASS 5/5** — 0 validator errors; no "Deceiver level 20" in the expansion list; diff = 1 line removed in `Progressions.lsx` and 1 in `Progressions.tbl`; `Arcana_Passive_UnlockFriends` still defined; both files parse as XML.

## Gates

- [x] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources TC_ARC-0001 merged; nothing removed.
