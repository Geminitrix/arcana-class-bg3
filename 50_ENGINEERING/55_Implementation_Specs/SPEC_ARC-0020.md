---
id: SPEC_ARC-0020
ticket: ARC-0020
status: ready
implementation: owner
author: Mod Engineer
updated: 2026-11-25
replaces: the staged plan of 2026-10-16 (90_ARCHIVE/93_Old_Versions/2026-11-25_ARC-0020_SPEC_staged_plan/)
---

# SPEC_ARC-0020 · The Veilwalker (Deceiver) — the rework, as a delta on the Veil build

Intent (ARC-0020): the game plays the Veilwalker as `21.04/Deceiver/DESIGN.md` describes it (DV1–DV35), in both editions.

**Scope — only what changes** (the Owner's choice, 2026-11-25). The game holds the Veil build of 2026-10-07 with the
stage-1 names of 2026-10-16 (`05.02/Deceiver.md`). This SPEC lists what differs from the design; `TOOLKIT_ARC-0020` is how
to type it; `61.02/Deceiver/QA_ARC-0020.md` proves it level by level, together with the parts of the Veil build that were
never played. Design: `21.04/Deceiver/DESIGN.md` · decisions `DECISIONS.md` · numbers `25` (`*_Deceiver_*`, blocks
`pending_build`) · texts `32.04/ARC-0020_Deceiver.md` (Narrative gate passed for every text below).

| Decision | What the game does today | What the build makes it do | Item |
|---|---|---|---|
| DV19 | *The Veil* and a separate *Doubt* passive at level 1 | One visible passive (*The Veil*); *Doubt* leaves the progression | 16 |
| DV21 | Tier III gives +3 Charisma and Charisma to Arcane damage | Tier III: every Splinter is a 4 m burst; a Double an enemy destroys bursts by itself | 03–06, 22 |
| DV22 | Grand Deception: 2 flat Doubt on a failed save | 1 Doubt per Double that stood within 3 m of the enemy before the cast | 07, 22 |
| DV24, DV32, DV34 | — | *Splinter on Command*: a level-0 deck card, Bonus Action, one Double Splinters at once | 01, 02, 12, 18, 22, 23 |
| DV26 | *Telepathy* at level 1 | Leaves the progression | 16 |
| DV35 | Map of odd levels (02, 04, 06, 08, 10 empty) | Every level 1–12 carries something (DESIGN §9.1) | 08–21 |
| DV25 | *Mirrored Self*: one more target | **Deferred** — see the last section | — |

## Item index — implement top to bottom

The numbers are the steps of `TOOLKIT_ARC-0020` §0. Feature by feature (OR-5): each feature is complete in its items; what
each level grants is written once, in items 09–21.

| # | Type | Subtype | Internal entry | Where in the Toolkit | Depends on | Done |
|---|---|---|---|---|---|---|
| 01 | Status | `BOOST` | `SPLINTER_COMMAND_TECH` (new) | Stats → StatusData | — | ☐ |
| 02 | Spell | `Target` | `Target_Arcana_Card_Spell_SplinterOnCommand` (new) | Stats → SpellData | 01 | ☐ |
| 03 | Spell | `Projectile` | `Projectile_Arcana_SplinterBurst` (new) | Stats → SpellData | — | ☐ |
| 04 | Spell | `Shout` | `Shout_Deceiver_Double_Shatter` (change) | Stats → SpellData | — | ☐ |
| 05 | Passive | — | `Arcana_Passive_Aspect_Empress_Awakened_III`, `Arcana_Passive_Aspect_Empress_III` (change) | Stats → PassiveData | — | ☐ |
| 06 | Status | `BOOST` | `ASPECT_AWAKENED_EMPRESS_III` (change) | Stats → StatusData | 05 | ☐ |
| 07 | Spell | `Shout` | `Shout_Arcana_Card_Spell_GrandDeception` (change) | Stats → SpellData | — | ☐ |
| 08 | Passive | — | `Arcana_Passive_TheVeil` (change: text) | Stats → PassiveData | — | ☐ |
| 09–15 | Spell lists | — | "Deceiver Level 1/2/3/4/5/6/10" (2 new, 5 changed) | UUID Object Editor → Lists | 02 | ☐ |
| 16–21 | Progression | levels 1, 2, 4, 6, 7, 8, 10, 12 | table `8fe1f693-d8ff-4b02-a655-efd4acbc04cb` | UUID Object Editor → Progressions | 09–15 | ☐ |
| 22 | Osiris | goals | the Deceiver goals, one per feature (DV36) | Claude writes them; the Owner compiles | 01, 03 | ☐ |
| 23 | Generated / PC | — | `ARCANA_CardFamilies`, `CardDB.lua` | Claude, after the Owner saves | 02 | ☐ |

---

## Feature A · Splinter on Command (items 01, 02, 12, 18, 22, 23)

- **Card:** `Target_Arcana_Card_Spell_SplinterOnCommand`, level 0 (no slot), `BonusActionPoint:1`, 18 m
  (`SPL_Deceiver_SplinterOnCommand#range_next`), one target: `HasStatus('DOUBLE_OF_THE_VEIL') and not Dead()` + the card
  marker `not HasPassive('ARCANA_IS_CARD', context.Source)` (as every card, e.g. Malicious Whispers). Effect: only
  `ApplyStatus(SPLINTER_COMMAND_TECH,100,0)`.
- **Goal:** `StatusApplied(_Double, "SPLINTER_COMMAND_TECH", _Owner, _)` on one of her live Doubles →
  `UseSpell(_Double, "Shout_Deceiver_Double_Shatter", _Double, _Double, 1)` — the path The Veil Lifts already uses
  (`ARCANA_Aspect_Empress.txt`). The goal's `CastSpell` rules then mark the Double blameless and retire it 800 ms later,
  exactly as a Splinter cast on its own turn. Ownership is checked in the goal (`DB_ARCANA_Double(_Double, _Owner, _)`).
- **PC:** a deck card (DV32), 1 Thread (`#threads_next`) — `CardDB.lua` row + `CardDBTest.lua` (item 23).
- **Look parent:** `Target_Arcana_Card_Spell_MaliciousWhispers` (the mod's cantrip card: castable, `CastTextEvent`,
  `SpellAnimation`; memory *bg3-new-spell-castable*).
- **Verify:** QA_ARC-0020 L4.1–L4.5 (probe B1 = L4.3: the Splinter fires off the Double's turn).

## Feature B · Tier III, the lie explodes (items 03–06, 22)

- **One burst path at Tier III** (review focus: never two bursts). The Splinter shout's `SpellProperties` deal its damage
  and Doubt only `IF(not HasStatus('ASPECT_AWAKENED_EMPRESS_III',GetSummoner(context.Source)))` — `GetSummoner` is the
  mod's own pattern (the Doubles' `VEIL_LAYER_N` conditions). At Tier III the goal makes the burst:
  `CreateExplosionAtPosition(_X, _Y, _Z, "Projectile_Arcana_SplinterBurst", 1, _Owner)`.
- **Vanilla anchor:** Death Burst — `GLO_CombatNPCs.txt` explodes a dying creature with
  `CreateExplosionAtPosition(…, "Projectile_DeathBurst_*", 1, _Char)`; the projectile's `ExplodeRadius` sets the area
  (`Projectile_DeathBurst_Died_IceMephit`, `Spell_Projectile.txt`). Signature checked in `Story/RawFiles/story_header.div`.
- **`Projectile_Arcana_SplinterBurst`:** `using Projectile_Arcana_Distortion_Explosion` (the mod's proven explosion), 1d6
  Psychic + `DOUBT_ADD_TECH`, `AreaRadius` = `ExplodeRadius` = 4 (`SPL_Deceiver_Splinter#tier3_radius_next`), enemies only,
  no Arcana marker (a burst never bursts a Seed, like today's Splinter).
- **When it fires:** (a) every Splinter cast at Tier III (`CastSpell` of the shout: its own turn, Splinter on Command, The
  Veil Lifts), at the Double's position; (b) a Double an enemy destroyed, from the purge, at the spot where it was struck
  (`DB_ARCANA_DoubleStruckAt`, written on `AttackedBy`, or on `Died` if nothing struck it). Never on the blameless paths
  (`DB_ARCANA_DoubleNoBlame`: cap, Dismiss, cleanups, her death, Which One?, a Splinter's own vanishing).
- **Tier III status:** `Arcana_Passive_Aspect_Empress_Awakened_III` keeps only `UnlockSpell(Shout_Arcana_Card_Passive_WhichOne)`;
  `…_III_Damage` leaves `ASPECT_AWAKENED_EMPRESS_III` (retired). Texts: 32.04 stage 3 addendum.
- **Verify:** QA_ARC-0020 L12.2–L12.10 (probe B2 = L12.4: the burst's Doubt is hers; B3 = L12.5: a destroyed Double's position; B6 = L12.3: the shout deals nothing at Tier III; V3 = L12.10).

## Feature C · Grand Deception reads the Veil (items 07, 22)

- **Goal:** on `UsingSpell` of the card family (before its Summon functors resolve) her live Doubles are written to
  `DB_ARCANA_GDBefore(_Owner, _Double)`; each `GRAND_DECEPTION_TECH` (a failed save) calls `PROC_ARCANA_Doubt_Add` once
  per listed Double within 3.0 m (`GetDistanceTo`); the list is cleared 1.5 s after `CastedSpell`. The flat two calls
  leave. Numbers: `SPL_Deceiver_GrandDeception#doubles_range_next` (3 m), `#doubt_per_double_next` (1).
- **Stats:** `TooltipStatusApply` `DOUBT_1`, `ExtraDescriptionParams` `Distance(9);Distance(3)`, the two approved texts.
  The `_6` variant inherits through `using`.
- **Verify:** QA_ARC-0020 L11.1–L11.6 (probe B5 = L11.2: the count reads only the Doubles placed before the cast; V2 = L11.6).

## Feature D · The Veil's text (item 08)

"4 from level 7" → "4 from level 8" (DV35). Nothing else.

## Feature E · The map (items 09–21)

| Level | Today | After (DESIGN §9.1) |
|---|---|---|
| 1 | Telepathy, The Veil, Doubt · Seed of Doubt, Faceless, Malicious Whispers, Eidolon, Friends | The Veil · Malicious Whispers, Eidolon, Friends |
| 2 | — | Seed of Doubt, Faceless (new list) |
| 3 | Tier I, Awakening · Binding Falsehood, Veiled Prison | Tier I, Awakening · Veiled Prison |
| 4 | — | Splinter on Command (new list) |
| 5 | Two Truths · Veilstep | Two Truths · Binding Falsehood |
| 6 | — | Veilstep, Twice-Told (the level-7 list, renamed) |
| 7 | Tier II, cap 4 · Twice-Told | Tier II |
| 8 | — | cap 4 (`Arcana_Passive_VeilCap4`) |
| 10 | — | Mirrored Self, Mirrored Spell (the level-12 list, renamed) |
| 12 | Tier III, cap 5 · Mirrored Self, Mirrored Spell | Tier III, cap 5 |

Nodes 2, 4, 6, 8 and 10 exist and are empty today (`dump_progression.pl`, 2026-11-25). The cap reads the passives, not the
level (`QRY_ARCANA_Doubles_OverCap`, Grand Deception's Summon conditions), so moving `Arcana_Passive_VeilCap4` is enough.
The Doubles' kit by level (`DB_ARCANA_DoubleRuleTier`: Reflected spells from 5, Unveil from 9) does not change.
- **Verify:** QA_ARC-0020 A.1 (`dump_progression.pl` matches DESIGN §9.1, no empty level) and the "new at this level" test of
  each level.

## Feature F · The goals (item 22) — written by Claude (DV36)

At the Owner's request the Osiris side is Claude's: the rules of this build and the old Deceiver goals, one goal per feature
(the Kingmaker's pattern), *HighPriestess* instead of *Empress* in Osiris (`ARCANA_Aspect_HighPriestess`, `ARCANA_Deceiver_TheVeil`,
`_Doubt`, `_Splinter`, `_SplinterOnCommand`, `_SeedOfDoubt`, `_Veilstep`, `_TwiceTold`, `_GrandDeception`, `_MirroredSpell`,
`_Faceless`). The Tier III burst of a destroyed Double runs from The Veil's purge through the hook
`PROC_ARCANA_Doubles_OnPurge` (defined in the Aspect goal). Source in `55/_wip/Deceiver/arc0020/goals/`; every old rule is in
the new set (rule-by-rule diff), `check_osiris.pl` 0 errors and 0 warnings for the 11 goals. The published Stats ids and the
Awakening key `"EMPRESS"` stay (OR-10). The Owner compiles the Story (OR-15).

## Generated and PC edition (item 23)

After the Owner saves: `gen_upcast_variants.pl --apply` (writes the card family row of Splinter on Command), `sort_stats.pl
--apply`, `check_cards.pl`, the `CardDB.lua` row (1 Thread) and its test, `sync_data`, commit.

## Deferred — Mirrored Self from a Double (DV25)

The engine can't move a spell's origin; DV25 needs the Double to cast a copy itself (`UseSpell` of a spell it doesn't
know, at a target Osiris must pick) — probe B4, never run, and a target rule the design doesn't fix. Until then *Mirrored
Self* stays as in the game (one more target, `ModifyNumberOfTargets`) and only moves to level 10. After this playtest: the
probe, then either plan A (the Double casts it) or plan B (one more target while a Double stands within 9 m of her,
`SPL_Deceiver_MirroredSelf#plan_b_range_next`) — the Owner decides.

## Close (stage 6)

`25`: move every applied `*_next` into `values:` and drop `pending_build`; archive the retired entries (Telepathy, Doubt,
`…_Awakened_III_Damage`) with date and reason; `gen_catalog.pl`; `05.02/Deceiver.md` and `05.00`; `DESIGN.md` state →
built; QA_ARC-0020 results; `check_propagation` OK; patch-notes line; ticket done.

## Acceptance criteria

- [ ] Items 01–22 typed; Story compiled with `0 error(s)`; `check_cards.pl` OK after item 23
- [ ] The probes B1, B2, B3, B5, B6 (QA_ARC-0020 L4.3, L12.4, L12.5, L11.2, L12.3) pass, or their plan B applied
- [ ] QA_ARC-0020 levels 1–12 pass (V1–V3 read as design feedback, OR-1)
- [ ] No line over 3900 characters; no repeated field; entry counts as expected after `sort_stats`
