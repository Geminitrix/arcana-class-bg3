---
id: SPEC_ARC-0017
ticket: ARC-0017
status: ready
implementation: claude
author: Mod Engineer
updated: 2026-10-16
---

# SPEC_ARC-0017 · Resonant refining build — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans. Steps use checkboxes. **One
> `[fechado] ARC-0017` message = one stage**; stage 0 writes only project files.

**Intent** (from ARC-0017): the game plays the Resonant as `21.04/Resonant/DESIGN.md` describes it after the ARC-0014
refining (R49–R68), in both editions.

**Design:** `21.04/Resonant/DESIGN.md` (R1–R68) · **Decisions:** `21.04/Resonant/DECISIONS.md` · **Numbers:** `25`
(`*_Resonant_*.yaml`, blocks `pending_build`) · **Generator:** `82_Automation/stats/gen_emotion_alchemy.pl` + `t/gen_emotion_alchemy.t`
(`perl t/gen_emotion_alchemy.t`) · **Lua tests:** `lua 50_ENGINEERING/53_Build_and_Versioning/53.03_Validators/run_tests.lua "<Data>/Mods/<mod>/ScriptExtender/Lua"`
· **Test case:** `61.02/Resonant/TC_ARC-0014.md` (probes B1–B5, rows V1–V13).

## Global constraints

- Everything in Stats / LSX / Osiris / Khonsu; the PC deck (Lua) only counts and locks cards (two editions).
- Numbers are read from `25` with `master()`; this build moves each `*_next` value of `pending_build` into `values:`
  (renaming it) and deletes the matching `retires` keys **in the same stage that stops reading them**, so the
  generator never reads a missing key.
- Change the generator's table, never a generated patch. Lines ≤ 3900 characters (the Toolkit reads 4096); no field
  repeated in an entry (it truncates the table on save).
- Goals: CRLF, ASCII; compile the Story after any goal change (tell the Owner every time).
- Khonsu helpers live in **one** file, `Scripts/thoth/helpers/ArcanaHelpers.khn` (ARC-0005).
- Every function, event and field below has a cited anchor; where none exists the item starts with a **probe** and
  has a plan B.

## The apply chain (every stage that writes the game)

1. `sync_data.sh` first (captures the Owner's Toolkit edits) · 2. generator → `stats_add 10_engine.patch --apply` ·
3. `gen_upcast_variants --apply` · 4. regenerate → `stats_add 20_upcast_targets.patch --apply` · 5. `sort_stats --apply` ·
6. `check_cards` · 7. `stats_add --selftest` · 8. copy the goals · 9. stage scripts (`55/_wip/Resonant/6x_*.pl`) ·
10. entry counts, line length, repeated-field scan · 11. `sync_data.sh` · 12. commit + push.

## Stages

| Stage | What | Decisions | Writes the game? | Gate |
|---|---|---|---|---|
| **0** | Generator + Lua: tests first, then code; patches generated | all | No | `t/gen_emotion_alchemy.t` and `run_tests.lua` green; patches in `55/_wip/Resonant/` |
| **1** | Moods and loops | R49, R50, R57 | Yes | B1, V1, V2, V10 (Compassion part) |
| **2** | The Overload | R51–R53, R56, R66–R68 | Yes | B2–B5, V4–V7, V11, V13 |
| **3** | *Weave Surge* container and the PC deck | R54, R55, R64 | Yes | V9, Lua tests in game (P33-style deck check) |
| **4** | Progression, passives, growth, cantrip, capstone, texts | R58–R63, R65, R67 | Yes | V3, V8, V10, V12 |
| **5** | Close: `25` cleaned, `05.02` synced, catalogs | — | No (project) | `check_propagation` 0 pending; ARC-0010 can run |

## Review focus

1. **Temper's replay marker** must block only the replayed emotion's mood, never a natural peak's (B1, Task 1.2).
2. **Combat end** must halve the meter **and** end *Overloaded* without the `StatusRemoved` reset emptying it again
   (Task 2.3: order of the two rules).
3. **Emotional Overload variants:** each variant carries its own `AmountOfTargets` and the area only on 5–6; the free
   passive must not change any other Arcana spell (Task 2.4 test: the check names the spell).
4. **The container's upcast variants** list the children's variants at the same level (Hemoplague, 2026-09-27 bug:
   the container opened empty).
5. **R50's marker** must clear at combat end even if the creature leaves combat dead or out of range (`RemoveEvents
   OnCombatEnded`, the ASPECT_PROGRESS_* pattern).

---

## Stage 0 — generator and Lua (project files only)

Each task: write the test, run it RED, change the code, run GREEN, commit.

### Task 0.1 · R49 — intense emotions leave nothing
- **Where:** `build_statuses` — the intense entry passes `onremove => $fade` today (`gen_emotion_alchemy.pl`, the
  `intense_id` block). Drop it.
- **Test:** no `EMOTION_<intense>` entry has `ApplyStatus(MOOD_` in its `OnRemoveFunctors`; every peak still has it.

### Task 0.2 · R49 — Temper spends the mood
- **Where:** `build_temper` and the peaks' `$fade`.
- **Change:** Temper's `SpellSuccess` adds `ApplyStatus(RESONANT_REPLAY,100,1)` before each peak it applies; every
  peak's fade becomes `IF(RemoveCause(StatusRemoveCause.TimeOut) and not HasStatus('RESONANT_REPLAY')):ApplyStatus(<mood>…)`
  followed by `RemoveStatus(RESONANT_REPLAY)`. New hidden status `RESONANT_REPLAY` (`hidden_status`, duration from Temper).
- **Anchor:** the fade's `RemoveCause(StatusRemoveCause.TimeOut)` (mod, passed P17); `HasStatus` in remove functors
  (mod, the Tier I branch reads `$AW_COND`).
- **Test:** each peak's fade carries the replay guard and the removal, in that order; Temper's description says the
  emotion leaves nothing.
- **Plan B (if B1 fails):** `RESONANT_REPLAY` gets `TickType StartTurn` with `TickingWithSource` and lasts until the
  Resonant's next turn instead of being removed by the fade.

### Task 0.3 · R50 — excess once per fight
- **Where:** the distance-0 branch of `spell_success` / `cond_of` and the intense statuses.
- **Change:** each intense status applies `RESONANT_EXCESS_SPENT` (hidden, `RemoveEvents OnCombatEnded`); the
  distance-0 reaction condition adds `not HasStatus('RESONANT_EXCESS_SPENT')`, else the Surge lands as a peak.
- **Anchor:** `ASPECT_PROGRESS_*` (`gen_awakening_progress.pl`: `RemoveEvents OnCombatEnded`).
- **Test:** every distance-0 condition carries the guard; the marker has `OnCombatEnded`.

### Task 0.4 · R57 — the kindness rule
- **Compassion** (`build_compassion`): the Trust it casts lands as a plain peak when the target is an ally carrying a
  mood whose reaction with Trust is kind `I` (from the table: today only Apprehensive → Submission). Generated from
  `%FEELING` so it stays true if the table changes.
- **Shared Heart** (`shared_heart_goal`): the copy rows only for feelings of kind `A`.
- **Test:** the Compassion condition lists exactly the moods whose Trust reaction is `I`; no `I` feeling in the copy rows.

### Task 0.5 · R51/R52/R67 — *Overloaded* as a Mental Fatigue variant
- **Where:** `RESONANT_OVERLOAD_FULL` in `build_statuses`.
- **Change:** `Boosts` → `RollBonus(SavingThrow,-N,Intelligence);RollBonus(SavingThrow,-N,Wisdom);RollBonus(SavingThrow,-N,Charisma)`
  by band (1–4 / 5–8 / 9–12, `IF(ClassLevelHigherOrEqualThan(…))` as the existing `$tick`); **no** `BlockSpellCast()`,
  **no** `CharacterWeaponDamage`; `TickFunctors` → Psychic `overloaded_tick_next` by band. Retire the weapon level map
  (`$WEAPON_MAP`) and `full_damage`.
- **Anchor:** vanilla `MAG_PSYCHIC_MENTAL_FATIGUE` (`Status_BOOST.txt`: `RollBonus(SavingThrow, -1, Intelligence)` …);
  the band brackets of today's `$tick`.
- **Test:** no `BlockSpellCast` in the entry; three save penalties per band; tick dice per band from `25`.

### Task 0.6 · R51 — the Surge rider, once per turn
- **Where:** `overload_goal` (Osiris).
- **Change:** `IF StatusApplied(_Target, _Status, (CHARACTER)_Resonant, _) AND DB_ARCANA_Resonant_Landed(_Status) AND
  HasActiveStatus(_Resonant, "RESONANT_OVERLOAD_FULL", 1) AND IsEnemy(_Resonant, _Target, 1) AND
  HasActiveStatus(_Resonant, "RESONANT_RIDER_USED", 0)` → apply `RESONANT_RIDER_TECH` to the target (hidden,
  `OnApplyFunctors` DealDamage by band) and `RESONANT_RIDER_USED` to the Resonant (`TickType StartTurn`, as
  `RESONANT_REFUND_USED`). `DB_ARCANA_Resonant_Landed` = every peak, intense and feeling status (a status applied means
  the save failed).
- **Anchors:** `IsEnemy(_Resonant, _Cand, 1)` (mod Resonant goal, line 175); `HasActiveStatus(_Unbound,
  "FOOL_ZEPHYR_FREE", 1)` / `HasActiveStatus(_Eternal, "HARVEST_SPENT", 0)` (mod goals); `RESONANT_REFUND_TECH` /
  `RESONANT_REFUND_USED`; `FEELING_REMORSE_TECH` (damage from a tech status).
- **Test:** the rule exists once; the guard status ticks `StartTurn`.

### Task 0.7 · R53 — the end of a fight
- **Where:** `overload_goal`.
- **Change:** `IF LeftCombat((CHARACTER)_Resonant, _) AND DB_ARCANA_Resonant_Overload(_Resonant, _N)` → set the count
  to `_N / 2` (`IntegerDivide`) and show it; if `DB_ARCANA_Resonant_OverloadFull`, first mark
  `DB_ARCANA_Resonant_Settling(_Resonant)` so the `StatusRemoved … RESONANT_OVERLOAD_FULL` reset rule does **not**
  empty the meter, then set it to half the maximum.
- **Anchor:** `LeftCombat((CHARACTER)_Char, _Combat)` (`ARCANA_Aspect_Common.txt` line 92); `IntegerDivide` (same file).
- **Test:** the settling flag guards the reset rule; half of the maximum when full, half of the count otherwise.

### Task 0.8 · R56 — waking Tier III fills the meter
- **Where:** `temperance_goal` (`PROC_ARCANA_Aspect_OnTier` for tier 3).
- **Change:** call `PROC_ARCANA_Resonant_Overload_Add(_Char, <max>)` (fills and triggers *Overloaded* through the
  existing path) unless `DB_ARCANA_Resonant_OverloadFull`.
- **Test:** the tier-3 rule calls the existing add path.

### Task 0.9 · R51/R66/R67/R68 — Emotional Overload
- **Where:** `build_overload_spell`.
- **Change:** `Level 1`, `UseCosts BonusActionPoint:1;SpellSlotsGroup:1:1:1` (the Surges' slot cost, `build_spells`);
  keep `RequirementConditions HasStatus('RESONANT_OVERLOAD_FULL')`; `SpellRoll` Wisdom save (`SourceSpellDC()`);
  `SpellSuccess` (failed save): damage per feeling + remove each feeling, `ApplyStatus(IRRESISTIBLE_DANCE,100,1)`
  (2 when the Resonant has Tier III — `IF(HasStatus('ASPECT_AWAKENED_TEMPERANCE_III', context.Source))`, the tier
  status `build_aspect` makes), Mental Fatigue; `SpellFail` (save made): half damage per feeling + remove each feeling, Mental
  Fatigue. Mental Fatigue = `ApplyStatus(MAG_PSYCHIC_MENTAL_FATIGUE,100,<level>);ApplyStatus(MAG_PSYCHIC_MENTAL_FATIGUE_DURATION_TECHNICAL,100,1)`.
  Icon `Spell_IntellectDevourer_SynapticDischarge`. Variants: `20_upcast_targets.patch` sets `AmountOfTargets` 1 (1–2),
  2 (3–4); variants 5–6 become the area (rank III, T2 — Task 2.5).
- **Free cast:** new hidden passive at level 1, `Boosts UnlockSpellVariant(SpellId('Target_Arcana_Created_EmotionalOverload'),ModifyUseCosts(Replace,ArcanaSpellSlot,0,-1,ArcanaSpellSlot),ModifyUseCosts(Replace,SpellSlotsGroup,0,-1,SpellSlotsGroup))`
  — both replacements, exactly as the Owner-tested `DEBUG_INFINITE_SPELLS`; no `ModifyTooltipDescription` (R66). The variants keep their own ids: the check must match them too (`SpellId` of
  each variant, or the variant's root — choose by B3).
- **Anchors:** `IRRESISTIBLE_DANCE` (`SharedDev/Status_BOOST.txt`); vanilla Mental Fatigue items
  (`GustavDev/Passive.txt`, `MAG_Psychic_MentalFatigue_*_Passive`); `UnlockSpellVariant(SpellId('Projectile_EldritchBlast'),…)`
  (vanilla Passive.txt); `DEBUG_INFINITE_SPELLS` (mod `Status_BOOST.txt`); Owner test 2026-10-16 (only the current
  slot's variant shows).
- **Mental Fatigue's duration:** the character level — the spell can't read it; use one `IF(ClassLevel…)` branch per
  level band or a `LevelMapValue` map like `Catharsis_Damage` (proven: `catharsis_levelmap`).
- **Test:** no `PARALYZED`; dance in `SpellSuccess` only; fatigue in both; slot level 1; the passive's check names only
  this spell.

### Task 0.10 · R54 — the *Weave Surge* container
- **Where:** `build_spells` + a new container entry.
- **Change:** a `Target` container `Target_Arcana_Card_Spell_WeaveSurge` (id per `33.03`) with `ContainerSpells` = the
  eight emotion spells; each emotion gets `SpellContainerID` = the container; display names become the emotion alone.
  `gen_upcast_variants.pl` §1b already builds container variants that list the children's variants.
- **Anchor:** `Target_Arcana_Card_Spell_Hemoplague` (mod) and vanilla `Target_EnhanceAbility`.
- **Test:** the container lists eight children; each child points back; names have no "Weave Surge:" prefix.
- **Note:** `IsWeaveSurge()` (Khonsu) reads the children's ids, which keep their names — it needs no change; the Tier II
  free Surge applies to the child cast through the container.

### Task 0.11 · R55 — PC deck copies (Lua)
- **Where:** `Deck/List.lua` `L.MaxCopies(id)` (today `C.MAX_COPIES` = 3, `C.UNIQUE_COPIES` = 1) and `CardDB.lua`
  (`D.containers` gets the Weave Surge container and its eight children).
- **Change:** a `copiesPerChild` field on the container's CardDB entry; `MaxCopies` for that id = 3 × the children the
  character knows. `MaxCopies` takes only the id today — it needs the character: thread it through its two callers
  (`List.lua` lines 32, 42, 58).
- **Test (`CardDBTest.lua` / run_tests):** a character with 3 emotions gets 9 copies, with 8 gets 24; every other card
  still 3 (Unique 1).

### Task 0.12 · R59/R60/R62/R63/R67 — the rest of the table
- **R60:** new passive `Arcana_Passive_Opposites` (`build_passives`) with the Catharsis text; Emotional Alchemy's text
  loses Catharsis and gains R49 and R57.
- **R62/R67:** the dice states read `*_next` by band: one status version per band where the dice are in `Boosts`
  (Hope, Despair, Aggressiveness, Apprehensive), swapped by level through `IF(ClassLevelHigherOrEqualThan(…))` in the
  applying functor, or `LevelMapValue` maps (Catharsis's proven pattern) where the value is a `DealDamage`/`RegainHitPoints`
  (Remorse, Delight, Morbidness, Pessimism) — choose per state, test each. Catharsis map → 1 / 5 / 9.
- **R63:** the Tier I mood extension leaves (`$fade`'s `$AW_COND` branch → one branch).
- **R61:** Heartstring adds `IF(HasStatus('FEELING_<X>')):DealDamage(<per_feeling>,Psychic,Magical)` per feeling (the
  Emotional Overload pattern) and loses the mood extension — check the line length.
- **R58:** Shared Heart's `SpellSuccess` applies `EMOTION_JOY` to every linked creature.
- **R64:** the description builder lists each mood's reactions (names only, level of unlock) and each emotion's moods.
- **R65:** Anger's text (table).
- **Tests:** one per rule; line length ≤ 3900 everywhere.

### Task 0.13 · R59 — the progression
- **Where:** a stage script `55/_wip/Resonant/64_progression_arc0017.pl`, modelled on `55_stage6_apply.pl`
  (lists 9 / 11 UUIDs there): Temper and Anticipation to level 2; Opposites to 3; Complex Feelings to 6; Emotional
  Contagion and rank III stay/arrive at 9; Ready: Compassion to 10; Shared Heart alone at 11; the free-cast passive at 1.
  The Resonant's nodes exist at every level (`dump_progression.pl`).
- **Test:** a dry run prints the 1–12 rows of `DESIGN.md` §10 (4 and 8 empty).

---

## Stage 1 — moods and loops (`[fechado] ARC-0017`)

Apply Tasks 0.1–0.4 (engine patch, Compassion, Shared Heart goal). Compile the Story.

| Probe | One rule | Expected | Plan B |
|---|---|---|---|
| **B1** | Temper's replayed emotion leaves no mood | Temper on Bored → Disgust 1 turn → no Bored; a natural Disgust later leaves Bored | Task 0.2 plan B |
| V1 | No repeated intense | Ecstasy / Amazement never on the same creature twice in a fight | — |
| V2 | No Temper lock | Temper on the same enemy two turns running needs a new Disgust Surge | — |
| V10a | Compassion is kind | Trust on a hit ally carrying Apprehensive lands as a plain peak (no Submission) | — |

## Stage 2 — the Overload (`[fechado] ARC-0017`)

Apply Tasks 0.5–0.9 (statuses, Overload goal, Temperance goal, Emotional Overload, free passive, variants). Compile.

| Probe | One rule | Expected | Plan B |
|---|---|---|---|
| **B2** | Dance's failed save vs Mental Fatigue | Record whether the fatigue discharges | Owner decides |
| **B3** | Free variants | Levels 1, 5, 9: one variant, castable with no slot while Overloaded | The check by root id |
| **B4** | PC: no Threads for Emotional Overload | 0 Threads | Exclude it from the `ARCANA_WEAVING` check |
| **B5** | Rank III's area | Every enemy within 9 m of a point within 18 m | Task 2.5: a separate `Zone`/`Target` spell for slots 5–6 granted at 9 |
| V4–V7, V11, V13 | as `TC_ARC-0014` | | |

**Task 2.5 (only if B5 fails):** a rank-III spell with `AreaRadius` 9 granted at level 9 and the variants 5–6 of the
single-target spell removed — written after B5.

## Stage 3 — the container and the deck (`[fechado] ARC-0017`)

Apply Tasks 0.10–0.11; Lua copied with the mod; `run_tests.lua` in the Data path. Check in game: one *Weave Surge* button
with the known emotions; PC deck holds 3 copies per emotion; Compassion still casts Trust (the child spell).

## Stage 4 — progression, passives, growth, texts (`[fechado] ARC-0017`)

Apply Tasks 0.12–0.13; loca strings from `32.01` (drafts) through the generator; `dump_progression.pl` against
`DESIGN.md` §10. Rows V3, V8, V10, V12.

## Stage 5 — close (project)

Move every applied `*_next` value into `values:` and delete `pending_build` and the retired keys (`25`); `validate.pl`;
`gen_catalog.pl`; `05.02/Resonant.md` (Context Keeper); `DESIGN.md` state line → built; `32.01` rows replaced; ticket
done; `check_propagation` 0 pending.

## Acceptance criteria

- [ ] Stage 0 green (generator and Lua) before any `[fechado]`
- [ ] Probes B1–B5 recorded, plan B applied where one failed
- [ ] `TC_ARC-0014` rows V1–V13 pass in game
- [ ] No line over 3900 characters; no repeated field; entry counts as expected after `sort_stats`
- [ ] `25` holds no `pending_build` block for the Resonant

---

## Stage 0 — done 2026-10-16 (rulings made while building)

Generator `gen_emotion_alchemy.pl` behind `ARC17_STAGE` (unset = 0 = today's game, byte-identical to the applied
patches): 340 tests pass (`t/gen_emotion_alchemy.t`; the ARC-0002 assertions the refining changed now run against
stage 0 or 3 as a regression). Lua (prepared in `_wip/Resonant/ARC-0017/Lua/`, copied into Data at stage 3): 138
pass with `_wip/Resonant/ARC-0017/run_lua_tests.sh`. Progression: `_wip/Resonant/64_progression_arc0017.pl`, 74 pass
with `_wip/Resonant/ARC-0017/t_progression.t` on a scratch copy. `dump_progression.pl` reads `BG3_DATA`.

| # | Ruling | Why | Cost if wrong |
|---|---|---|---|
| 1 | The generator reads the `*_next` keys of `pending_build` until stage 5 renames them | `25` keeps describing the game until each stage ships | None: stage 5 renames |
| 2 | The Surge rider's once-per-turn guard is an Osiris DB (`DB_ARCANA_Resonant_RiderUsed`, cleared on `TurnStarted`), not a status | A multi-target Surge raises several `StatusApplied` at once; a DB is set immediately | One more DB |
| 3 | Emotional Overload's free cast rides on `Arcana_Passive_Overload` (visible), its check names the base spell and variants 2–6 | No new progression row at stage 2; variants have their own ids (probe B3) | Rename to a hidden passive if the Owner prefers |
| 4 | Mental Fatigue comes from Osiris (`RESONANT_FATIGUE_TECH` marker → `MAG_PSYCHIC_MENTAL_FATIGUE` for the level + its technical status) | The spell can't read the level for a duration; the marker keeps the save first, the fatigue after | — |
| 5 | The progression moves at stages 2 (Emotional Overload to 1) and 3 (the container in the lists) as well as 4 | Each stage's feature must be granted to be tested | — |
| 6 | The emotions keep their `Card_Spell` ids as the container's children; `Po.Cards` skips every container child; the CardDB test allows Card children of a Card container | Osiris, Khonsu (`IsWeaveSurge`), Compassion and the upcast variants read those ids | If the engine also lists children in the spellbook, they stay out of the deck anyway |
| 7 | The dice states grow through level maps (`Resonant_Die4`, `Resonant_Die6` and negative twins) — vanilla `RollBonus(Attack,LevelMapValue(SuperiorityDie))` | One status per state, no extra functors | **Probe B7**: whose level a map reads on another creature; plan B = one status per band |
| 8 | Shared Heart's Joy is `RESONANT_SHARED_JOY` (`using EMOTION_JOY`) | The Overload counts `EMOTION_JOY` by name; R58 says the capstone's Joy counts for nothing | — |
| 9 | Rank III is `AreaRadius 9` on variants 5–6 | Vanilla Target spells carry `AreaRadius` | **Probe B5**; plan B Task 2.5 |
| 10 | The emotions open inside the container by `RequirementConditions ClassLevelHigherOrEqualThan(L,'Arcana')`; the container has no Surge marker | Only the emotions are cast; `IsWeaveSurge()` must not see the container | **Probe B6**: the container shows or greys them by level; Tier II's free Surge through it |
| 11 | Status texts still print the flat dice ("1d4") of the growing states | The values grow; the words wait for the text pass (ARC-0006) | A tooltip that understates the die at 5+ |
