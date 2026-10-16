---
id: 21.04/Deceiver/REFINE_Deceiver
owner: Lead Class Designer
status: SG1–SG10 approved 2026-10-16 (DV18–DV27 in DECISIONS.md); SG11–SG12 and the revised map await the Owner. Kept as the record of why
ticket: ARC-0019
created: 2026-10-16
variant: subclass (full, compact record)
sources: 21.04/_SUBCLASS_STANDARD.md v2.1, 21.04/_SUBCLASS_REFINING.md, 21.04/Deceiver/2026-10-06-deceiver-veil-design.md (D1–D17), 05.02/Deceiver.md, 05.01/Arcana_Base_Class.md §3, 21.08, 10.06/Open_Questions.md, game files (ARCANA_Aspect_Common.txt, Spell_Shout.txt, Spell_Target.txt, ARCANA_Deceiver_Doubles.txt, ARCANA_Aspect_Empress.txt)
---

# The Deceiver — design review

> A proposal, now answered. The decisions it led to live in `DECISIONS.md` (DV18 on); the design in `DESIGN.md`.
> Numbers: placeholders only. Written compactly (the Owner's lean-execution rule): the audit lists only the marks
> that needed a suggestion.

## 1. Frame

- **Variant:** subclass, full. **Already decided:** the Veil design D1–D17 (now DV1–DV17), built in stages 1–4 and
  largely untested in game (`05.02` §8). DV16 (caps 3/4/5) reopens only with a playtest result.
- **Open before the review:** the Axis (`21.08` ❓), the Tier III ability bonus (`10.06`), the ultimate (K3).

## 2. Audit — findings

| DM | Mark | Evidence | SG |
|---|---|---|---|
| A2 | ❌ | Tier III gives +3 CHA and CHA to Arcane damage (`05.02` §6); §7 forbids ability bonuses | SG4 |
| K3 / K7 | ❌ | Grand Deception summons to the cap and gives a flat Doubt in an area: it creates the state but its effect never depends on what was built; only The Veil Lifts reads the state | SG5 |
| J4 | ❌ | Level 1 brings ~13 new concepts (Doubles, Shatter, Dismiss, AC layers, Doubt, Deluded, Sigil, detonation, Whispers, Paranoia, Telepathy, Faceless, Friends) on top of the base class's level 1 | SG6 |
| S6 / S7 | ❌ | No myth; card readings without a primary source | SG3 |
| D2 | ❌ | No `DESIGN.md`/`DECISIONS.md`; `21.08` says "Sigils detonated 3/5/7", the game counts Doubt 4/7/10 (`ARCANA_Aspect_Common.txt` 51–53) | SG10 |
| I5 | ⚠️ | Axis ❓ in `21.08`; Presence is free | SG1 |
| M2 | ⚠️ | The rule is split over two passives (The Veil, Doubt) and never said in one sentence | SG2 |
| J8 | ⚠️ | Levels 2, 6, 10 empty; level 12 dense (Tier III, cap 5, two cards) | SG6 |
| K6 | ⚠️ | First bonus action at 5 (Withdraw, `BonusActionPoint`); Mirror Image is an action (`Spell_Target.txt`) | SG7 |
| M3 | ⚠️ | Mirrored Self / Mirrored Spell touch no gear (Doubles, Doubt, Sigil) | SG8, SG6 |
| §8.5 | ⚠️ | Three utilities (Telepathy, Faceless, Friends) against "at most one" | SG9 |

## 3. Suggestions and outcome

| SG | Suggestion | Priority · effort | Outcome |
|---|---|---|---|
| SG1 | Axis **Presence** | should · XS | approved → DV18 |
| SG2 | One-sentence core rule on one passive | should · S | approved → DV19 |
| SG3 | Myth (eidolon of Helen, Nephele), real model (Ghost Army), primary card sources | must · XS | approved → DV20 |
| SG4 | Tier III *the lie explodes* (option A; B was Doubles mirroring every damage card — too risky) | must · M | approved with a wider Shatter → DV21 |
| SG5 | Grand Deception counts the Doubles already near each enemy | must · S | approved → DV22 |
| SG6 | Spread the map over every level, lighten level 1 | must · M | approved → DV23; final map revised after SG9 |
| SG7 | *Shatter on command* as her bonus action | should · S | approved → DV24 |
| SG8 | Mirrored Self cast from a Double (T2) | could · M | approved, to test → DV25 |
| SG9 | Keep one utility | could · XS | Owner: keep Faceless and Friends, drop Telepathy → DV26 |
| SG10 | Dossier files, archive the dated spec, fix `21.08` | must · XS | approved → DV27 |
| SG11 | Rename the five names taken from LeBlanc (League of Legends): Mirror Image, Sigil of Malice, Distortion, Ethereal Chains, Mimic (DM-I6; `31.01` §4 lists them) | should · S | proposed 2026-10-16, awaiting Owner |
| SG12 | Drop Nephele from DV20: Ixion is the Kingmaker's myth (*Wheel of Ixion*, `21.04/Kingmaker`); the eidolon of Helen carries the source alone (DM-I6) | should · XS | proposed 2026-10-16, awaiting Owner |

## 4. Feasibility notes

- **SG4:** vanilla Death Burst (mephits) is the pattern — `GLO_CombatNPCs.txt` explodes a dying creature with
  `CreateExplosionAtPosition`, the projectile's `ExplodeRadius` sets the area (`Projectile_DeathBurst_Died_IceMephit`).
  The Veil Lifts already makes a Double cast Shatter from Osiris (`UseSpell`, `ARCANA_Aspect_Empress.txt`).
- **SG8:** no known pattern for a spell's extra target originating from another creature — T2.
- **SG5, SG7:** Doubles near a creature and "shatter now" reuse the Doubles goal's tables — no new engine piece.

## 5. Verification (to merge into the playtest ticket)

| V# | Fight | Metric | Right if | Wrong if | SG |
|---|---|---|---|---|---|
| V1 | Level 2, any | Turns where *Shatter on command* is used | Used in most fights, not every turn | Never used, or used every turn (dominant) | SG7 |
| V2 | Level 11 | Doubt from Grand Deception with Doubles placed vs none | Placement changes the result clearly | Same result either way | SG5 |
| V3 | Level 12, Tier III | Turn Tier III wakes; bursts per fight | Wakes in a normal fight; bursts feel like the peak | Wakes after the fight is decided | SG4 |
| V4 | Level 10 | Mirrored Self's extra target from a Double's position | Works in the engine | Engine can't origin it (plan B needed) | SG8 |
