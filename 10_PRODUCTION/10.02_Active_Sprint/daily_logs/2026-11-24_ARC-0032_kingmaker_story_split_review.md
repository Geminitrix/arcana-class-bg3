# 2026-11-24 · Kingmaker Story split reviewed (ARC-0032, Mod Engineer)

**Asked:** the Owner split `ARCANA_Kingmaker_Wheel` into ten goals (2026-11-19) and reported that at Tier I Coronation
and Dethrone no longer put anyone on the Wheel; review the new goals and open a ticket for the fixes.

**Found:** the Story compiles clean; the split lost rules. Compared rule by rule with the old goal (51 copy):
- Cause of the report: the two Tier I *Tyche* bind rules (Reigning / Fallen) are gone; only the pre-Tier I ones remain.
- Also gone: Rota Fortunae, Swift Shears, Severance (spending it), the King's Hand crown, Master of Coin's Long Rest reset.
- Master of Coin's spent status now lasts one round (`6.0`): once per round instead of once per Long Rest - Owner to decide.
- Master of Laws moved to another goal now runs before the Wheel turns (alphabetical goal order) and steps one too far.
- Tidy-up: the new goals have no headers (`check_osiris` errors), one Crossing rule sits in the Court goal, and
  `ARCANA_Kingmaker_Succesion` is misspelt.

**Done:** ticket ARC-0032 with every fix as a copy-paste block (game open, OR-11). Nothing in `Data` was changed.

**Open:** the Owner pastes F1-F6 and recompiles; decision on Master of Coin (F5); then playtest the ticket's criteria.
