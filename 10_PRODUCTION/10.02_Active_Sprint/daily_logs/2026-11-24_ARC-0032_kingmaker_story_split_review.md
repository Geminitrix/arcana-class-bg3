# 2026-11-24 · Kingmaker Story split reviewed (ARC-0032, Mod Engineer)

**Asked:** the Owner split `ARCANA_Kingmaker_Wheel` into ten goals (2026-11-19) and reported that at Tier I Coronation
and Dethrone no longer put anyone on the Wheel; review the new goals and open a ticket for the fixes.

**Found:** the Story compiles clean; the split lost rules. Compared rule by rule with the old goal (51 copy):
- Cause of the report: the two Tier I *Tyche* bind rules (Reigning / Fallen) are gone; only the pre-Tier I ones remain.
- Also gone: Rota Fortunae, Swift Shears, Severance (spending it), the King's Hand crown, Master of Coin's Long Rest reset.
- Master of Coin's spent status now lasts one round (`6.0`): once per round. The Owner kept it (SP121), knowing the balance estimate; propagated.
- Master of Laws moved to another goal now runs before the Wheel turns (alphabetical goal order) and steps one too far.
- Tidy-up: the new goals have no headers (`check_osiris` errors), one Crossing rule sits in the Court goal, and
  `ARCANA_Kingmaker_Succesion` is misspelt.

**Done:** ticket ARC-0032 with every fix as a copy-paste block (game open, OR-11). Nothing in `Data` was changed.

**Open:** the Owner pastes F1-F4 and F6, recompiles, and types the two F8 texts; then playtest the ticket's criteria.

**Later the same day (`[fechado]`):** SP121 propagated; then the ticket built in the game by Claude - F1-F4, F6, F7, F8
(backup `94_Safety_Backups/ARC-0032_2026-11-24/`). `check_osiris` 0 errors on the Kingmaker goals; the old-vs-new rule
comparison shows only the intended differences. `sync_data` also picked up the Owner's uncommitted game edits
(Kingmaker Stats, Progressions, loca; the Fool goal), committed apart under ARC-0008. The Fool goal lost its header in
those edits: `check_osiris` reports it. Next: the Owner compiles the Story, Claude reads `log.txt`, then the playtest.

**Then:** the Owner said Tyche must not bind ahead (first Turn the Spoke of each turn free instead). The Owner's Stats
(`d28ee51`) already did it, and also reworked Swift Shears and Severance and made The Wheel Stops once per combat; the
Owner confirmed all four: SP122-SP125 (Severance frees the whole action). The first build's F1 (Tyche binds) and F3
(old Swift Shears / Severance rules) were the old design: ARC-0032 now undoes them (F1 removes the Tier I guard from the
binds, F3 removes the rules) and adds F9 (Tyche and Severance texts). Propagated to DESIGN, 05.02, 21.03, 22.05, 23.02,
25, 26.01, 32.01, SPEC, QA (L3.5 retired with its pass, L3.11 rewritten, L3.12-L3.13 and L11.4 added). Lesson: before
restoring a rule a refactor dropped, compare the owner's Stats edits too, not only the status names.
