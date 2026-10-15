---
id: 23.02/Resonant/STA_Moods
owner: Spell Designer
game_id: MOOD_SERENE … MOOD_ANNOYED
design: 21.04/Resonant/DESIGN.md §5.2
reviewed: 2026-10-15 ARC-0002 — created (propagation, 00.08)
---

# Moods (MOOD_*) — status family

**Intent:** A mood changes a number and waits for the next Surge.

**Rules in words:** 5 turns, shared StackId MOOD (one mood at a time, so one reaction per Surge). Fades; never rebounds.

| | |
|---|---|
| Gained at | level 1 |
| Cost / resource | — |
| Numbers | `25.03_statuses/STA_Resonant_States.yaml` |
| In game | built; passed in game (ARC-0002, closed 2026-10-12) |
