---
id: QA_ARC-0002
title: Playtest — The Resonant — first build R1–R48 (levels 1–12)
type: playtest
subclass: resonant
build: ARC-0002
status: done
owner: QA Lead
sources: [TC_ARC-0002]
created: 2026-10-17
---

# QA_ARC-0002 · The Resonant — first build R1–R48 (levels 1–12)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0002 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from TC_ARC-0002.

> Closed record: every rule passed in the game (Owner, 2026-10-11/12); the tests are in the appendix.

## Appendix — TC_ARC-0002 (design-stage draft, verbatim)

Header of the original file:

```
id: 61.02/Resonant/TC_ARC-0002
owner: QA Lead
source: HANDOFF_LeadClassDesigner_to_QALead_ARC-0002.md · SPEC_ARC-0002.md (probes P0–P33) · 21.04/Resonant/DESIGN.md §15
reviewed: 2026-10-15 ARC-0002 — created (propagation, 00.08); 2026-10-16 ARC-0021 — display name checked, no change
```

### TC_ARC-0002 · The Resonant — regression suite

- **Decision it informs:** keep the Resonant as built, or send a failing rule back to the Lead Class Designer.
  Re-run as regression after any change to the Resonant's engine (generator, goals, Khonsu helper).
- **Scenario:** console edition, a Resonant built through the real progression at levels 1, 3, 5, 7, 9, 11, 12; PC
  (SE) edition for the deck row only. Compile the Story after any apply.

#### Static (no game session) — last run 2026-10-15 by Claude

| # | Step | Expected | Result |
|---|---|---|---|
| S1 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/t/gen_emotion_alchemy.t` | all pass | ✅ 247 / 247 |
| S2 | `lua 50_ENGINEERING/53_Build_and_Versioning/53.03_Validators/run_tests.lua "<Data>/Mods/<mod>/ScriptExtender/Lua"` | 0 failed | ✅ 134 passed, 0 failed (the "boom" line is a deliberate test) |
| S3 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/check_cards.pl` | `OK -- nenhum problema` | ✅ |
| S4 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/stats_add.pl --selftest` | 0 different | not run this time |
| S5 | no line over 4000 characters in the mod's `.txt` / `.stats` | none | ✅ 0 |
| S6 | `dump_progression.pl`, Resonant rows, vs `21.03/Resonant.md` | identical | ✅ |
| S7 | Story `log.txt` after compiling | `0 error(s), 0 warning(s)` | Owner, at the next compile |

#### In game — one assertion per rule (Owner, 2026-10-11/12: all PASS)

| Rule | Probe | Expected | Result |
|---|---|---|---|
| Peaks change behaviour | P1–P5, P24 | Joy contagious; Trust shares a blow; Anticipation guards until your turn; Fear freezes; Surprise off guard; Sadness lets go; Anger grudge or nearest; any Surge on any creature; constructs immune | ✅ |
| A reaction refunds the slot once per turn | refund | a feeling gives the slot back; a failed save gives nothing; a second reaction that turn gives nothing | ✅ |
| Overload | P6–P9 | +1 peak, +2 reaction; full → Overloaded (silenced, Psychic on weapon hits and each turn, level-long); Emotional Overload greyed until then; paralyses 2 turns, no save, empties the meter | ✅ |
| Overload persists | P10 | carries over between combats (0 % not shown — accepted) | ✅ |
| Signature spells | P11b, P12, P13b, P15 | Contagion: the target's mood to its allies; Heartstring +2 turns; Temper replays the root emotion 1 turn then the mood 5; Compassion casts Trust on a hit ally once per round | ✅ |
| Awakening | P16–P19, P21 | 3 / 6 / 15; Tier I Catharsis +1d8, moods 7 turns, The Two Cups (no Overload); Tier III area paralysis | ✅ |
| Tier II | P20b, P22, P23, P25 | feelings 4 turns; first Surge each turn free and leaves its mood at once | ✅ |
| Shared Heart | P27b, P28b, P30 | link 18 m until combat ends; a feeling reaches every linked creature, counted once; Catharsis heals them all | ✅ |
| Progression | P32 | a new Resonant 1 → 12 gets exactly the `21.03` table | ✅ |
| PC edition | P33 | the deck: Surges, Heartstring, Temper (1 Thread), Contagion (3), Shared Heart (Unique); The Two Cups at Awakened I | ✅ |

#### Known, accepted
The meter does not show at 0 % (P10). Shared Heart copies have the linked target as source. Two Resonants in one party
are not handled.

#### Next
Balance playtest proposed in `22.05/Resonant.md` (Emotional Overload uses per day, Harmony, Shared Heart range).

## Gates

- [x] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources TC_ARC-0002 merged; nothing removed.
