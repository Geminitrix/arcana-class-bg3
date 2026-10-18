# 2026-10-11 · Migration stages A–E, Sprint 0 start

**Done:** repository migrated (stages A–D); baseline 3.1.0.28 registered and diffed against 3.1.0.44;
Owner answers recorded (Titan = Lionheart; Cosmic Omen intended; Spinner/Lionheart still being defined);
verifier false positive on vanilla ids fixed; Sprint 0 opened with ARC-0001 (spec ready, implementation: owner).

**Blocked:** nothing.

**Next:** Owner implements ARC-0001 in the Toolkit → sync_data, validate, compare, TC_ARC-0001, close.

**Later the same day:** the Owner asked Claude to implement ARC-0001 (`[fechado]` + ticket). Done and verified
(TC 5/5). The hook blocked one combined command (ticket edit + Data read in one call) — correct behaviour;
split into separate steps. Lesson: change the ticket field in its own step before touching the game.
