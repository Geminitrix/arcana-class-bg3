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

**Build kit (later, 2026-11-25):** the Owner approved the design and chose a delta kit ("só o que muda"). Written:
SPEC_ARC-0020 (rewritten for the Owner to type; the staged plan archived), TOOLKIT_ARC-0020 (23 steps: 3 new Stats entries,
6 changed, 7 lists, 9 progression rows, the Doubles goal replaced whole), QA_ARC-0020 level by level (74 tests) → `ready`;
Arcana Test Guides now has the Veilwalker tab (the Kingmaker tab left it: QA_ARC-0008 is done). ARC-0020 → `spec_ready`.
Deferred: Mirrored Self from a Double (DV25), after its probe. **Next:** the Owner types the TOOLKIT, then `[fechado] ARC-0020`.

**Build verified (later, 2026-11-25, `[fechado] ARC-0020`):** the Owner typed the Stats, lists and progression. Three Stats
divergences and one dangling list reference fixed; the Deceiver's Osiris split one goal per feature with *HighPriestess*
(DV36, 6 goals retired, 11 written, every old rule kept); generators and the PC deck row done. ARC-0020 → `in_qa`. **Next:**
the Owner compiles the Story (log.txt: 0 errors) and plays QA_ARC-0020. Pre-existing, not ours: `check_osiris` shows 6
errors / 23 warnings in the Fool, Kingmaker and Windborn goals.

**ARC-0035 created (Owner):** the 6 errors and 23 warnings of `check_osiris` outside the Deceiver investigated — LF lines
and a deleted header from Story Editor saves (Fool, CrownTheKing, AeolusBag) and 23 shared Kingmaker DBs without type
pins. None breaks the game (last compile 0 errors). Plan and pin table in the ticket; `implementation: claude`, backlog.
