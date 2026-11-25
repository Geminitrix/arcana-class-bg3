# 2026-11-25 · ARC-0020 — Veilwalker level map v2 (DV35)

**Done:** the Owner reopened the Veilwalker's design (stage 3, OR-1): spread the kit over levels 1–12 like the Windborn
and the Kingmaker, then playtest 1–12. Audit: the game has levels 2, 4, 6, 8 and 10 empty; the approved map (DV28) still
left 4 and 8 empty and put ~8 new concepts on level 1, and Veilstep (5) created a Twice-Told card that only came at 6.
Three options for 4 and 8; the Owner chose **A** → DV35: no empty level, ranks of the Double at 4 (Splinter on Command)
and 8 (cap 4). Propagated to every department; `check_propagation.pl Deceiver` OK.

**Tool fix:** `check_propagation.pl` read the propagation map with CRLF line ends and skipped every dossier ("no decisions
recorded yet"). Fixed (strips `\r`); a full run now shows 21 pending artifacts for the Kingmaker and the Windborn.

**Next:** the Owner approves `21.04/Deceiver/DESIGN.md` (DV35) → stage 4: SPEC_ARC-0020 rewritten in today's format,
TOOLKIT_ARC-0020, QA_ARC-0020 level by level → `ready` → the Veilwalker tab on Arcana Test Guides.
