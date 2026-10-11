# 27.02 · D&D 5e and BG3 — rules base, chassis, subclass method

*Condenses spec Part II §18. Readers: Lead Class Designer. The full criteria are in
`21.04_Subclasses/_SUBCLASS_STANDARD.md`; this card is the background.*

## Rules base
BG3 adapts 5e, and **the game data (Toolkit, `56`) beats any rulebook**. Newer D&D rules don't apply
automatically. For rules text, the SRD 5.1 is the open source (CC BY 4.0 — see `00.06`).

## Bounded accuracy
5e keeps attack and defence from growing just by levelling: one small proficiency bonus, small item
bonuses, low ability caps, **advantage instead of flat bonuses**. Low-level creatures stay relevant.
For the Arcana: avoid stackable flat bonuses to attack, spell DC or AC; prefer dice, advantage,
resources and conditional effects. A flat bonus must justify its effect on the hit curve.
*(Exact figures: confirm in the SRD and the game data, not wikis.)*

## BG3 limits
Level cap 12, spells up to 6th level (higher slots only upcast). Larian capped it for balance. So the
**1–12 core must be complete on its own**; the 13–20 module is optional, cannot need 7th+ level spells
without an explicit decision, and must say how it handles encounters that don't scale past 12 (ADR).

## Class chassis — filled and approved before any feature
Hit die and survivability · proficiencies (follow vanilla convention or justify) · spellcasting (type,
ability, max level, cantrips, known vs prepared) · own resources and recharge (`27.04`) · subclass level
and feature cadence · ASI / feat levels (check vanilla) · multiclass · equipment and spell list (and what
it leaves out on purpose). Vanilla conventions are read from the game data; breaking one needs an ADR.

## Designing a subclass — priority order (Jeremy Crawford, as summarised in the spec)
1. Does the option do what it promises?  2. Does it tell its class's story and fantasy?
3. Only then balance: is the whole subclass in the same power range as its siblings in damage, healing,
defence and control? Non-damage effects are priced with **virtual damage** (`27.03`).

## Reworking an existing subclass
Keep what players love most, change the structure when the problem is structural, accept a big change
(it won't be revisited soon). Steps: diagnose (fantasy, what works, what fails — mod.io feedback, tests,
role matrix) → keep/change/remove table per feature with reason → prototype in `25` → validate against the
standard and the curve → write the intent in one sentence.

## Community compatibility
The BG3 Community Library maintains a Subclass Compatibility Framework. Adopting it is an open ADR.
