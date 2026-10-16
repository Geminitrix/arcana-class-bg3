---
id: 23.02/Resonant/SPL_WeaveSurge
owner: Spell Designer
game_id: (new container — id per 33.03 at the build)
design: 21.04/Resonant/DESIGN.md §7.1
reviewed: 2026-10-16 ARC-0014 — created (R54, R55); 2026-10-16 ARC-0021 — display name checked, no change
---

# Weave Surge — container (the eight emotions)

**Intent:** One button for the Resonant's whole verb: open the wheel, choose the emotion.

**Rules in words:** A spell container whose spells are the emotions the Resonant knows — Joy, Trust, Fear (1), Anticipation (2), Surprise, Sadness (3), Disgust, Anger (5). Each emotion keeps its own sheet (`SPL_WeaveSurge_<Emotion>`). Upcast: the container's variants list its children's variants (`gen_upcast_variants.pl` §1b, the Hemoplague pattern).

| | |
|---|---|
| Gained at | level 1 (grows at 2, 3, 5) |
| Cost / resource | Each emotion: Action · level-1 slot (PC: 1 Thread) · +1 target per slot level. PC deck: the container and its emotions are one card, **3 copies per emotion known** (an exception to 3 per card, R55) |
| Numbers | `25.03_statuses/STA_Resonant_Peaks.yaml`, `25.03_statuses/STA_Resonant_States.yaml` |
| In game | approved 2026-10-16 (ARC-0014) — build pending; today the eight emotions are separate cards |
