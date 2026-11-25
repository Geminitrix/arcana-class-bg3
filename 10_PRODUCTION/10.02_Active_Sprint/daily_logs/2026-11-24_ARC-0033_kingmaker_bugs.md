# 2026-11-24 · Kingmaker bugs traced (ARC-0033, Mod Engineer)

**Asked:** three bugs from the Owner's level-12 play: Ready: Foreseen offers no reaction; Aspect of Anticipation lets an
ally drop to Fallen; an ally sometimes gets Hubris and takes Crossings (after Dethrone on it).

**Found (game files, nothing changed in `Data`):**
- Foreseen: `Interrupt_Arcana_Aspect_Foreseen` has no `InterruptDefaultValue`; every other interrupt of the mod has it.
- Anticipation: the ally is moved to Fallen and then put back to Falling in the same moment (remove and give back the
  same status); the fix holds it before the step, in `PROC_ARCANA_Kingmaker_Move_Override`.
- Side: the card decides the side (Dethrone = enemy side). SP126 (Owner): the card sets the position, the creature
  sets the side - four bind rules with `IsEnemy`.

**Done:** ticket ARC-0033 with the Toolkit field and the Story blocks; SP126 in DECISIONS and DESIGN §4.4; QA_ARC-0008
A.3-A.4 added (L12.2 and L12.4 already cover the other two).

**Open:** the Owner applies B1-B3 (or sends `[fechado] ARC-0033`), compiles, plays the criteria.
