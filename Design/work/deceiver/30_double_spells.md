# Task 3 - Doubles' spells (prepared, not applied)

Files (all under `Design/work/deceiver/`; nothing under the game folder was touched):

| File | What |
|---|---|
| `30_double_spells.patch` | Stats + English loca (`stats_add.pl` format): 4 new spells, 1 round-marker status, 7 removals, 2 `@set` on the lists that named a removed status |
| `goals/ARCANA_Deceiver_Doubles.txt` | **Edited (fix round 1):** one new region "Task 3, fix round 1" (2 rules, no new DB) that retires a Double 800 ms after it casts Shatter |
| this note | |

Apply order: `10_doubt.patch`, `20_doubles.patch`, `30_double_spells.patch` in one session (30 names `DOUBT_1`,
`DOUBT_ADD_TECH`, `DOUBLE_OF_THE_VEIL` and `VEIL_LAYER_N` in strings and conditions, which `stats_add.pl` does not check).

## The spells

All four: `IsSpell` flag, `UseCosts ActionPoint:1`, no `SpellSlotsGroup`, no `ARCANA_IS_CARD` mark, fixed numbers (no
`LevelMapValue`), `RequirementConditions HasStatus('DOUBLE_OF_THE_VEIL',context.Source)` (only a Double can cast them).
Written as full entries, **no `using`**: nothing inherits from a card or from the entries being removed.

| Id | Type | What it does | Notes |
|---|---|---|---|
| `Shout_Deceiver_Double_Shatter` | Shout, `AreaRadius 3` | `DealDamage(1d6,Psychic,Magical);ApplyStatus(DOUBT_ADD_TECH,100,0)` on enemy characters in 3 m; the Double vanishes ~0.8 s later (Osiris, below) | The spell itself does not kill. No save, no Sigil mark (it does not detonate Sigils). Icon `Spell_Evocation_Shatter` |
| `Projectile_Deceiver_Double_MirrorSigil` | Projectile, 18 m | `DealDamage(1d4,Force,Magical);ApplyStatus(SIGIL_TECH,100,0)` | Copy of the clone's Mirror Sigil with the LevelMap swapped for 1d4. `ARCANA_IS_SPELL` in `TargetConditions` as before |
| `Target_Deceiver_Double_MirrorChains` | Target, 18 m | `SpellRoll not SavingThrow(Ability.Wisdom,13)`; `SpellSuccess DealDamage(1d4,Force,Magical);ApplyStatus(RESTRAINED,100,1)` | One hit. Fixed DC 13 (draft). `ARCANA_IS_SPELL` mark so the damage detonates her Sigil |
| `Target_Deceiver_Double_Unveil` | Target, 18 m | `SwapPlaces();ApplyStatus(UNVEIL_USED_TECH,100,1)` | Target = her only; once per round across all Doubles (below) |
| `UNVEIL_USED_TECH` (status) | Status_BOOST, hidden | `TickType EndRound`, `RemoveConditions not Combat()`, `RemoveEvents OnApply;OnCombatEnded` | On her. Gone at the end of the round, when combat ends, and at once if applied outside combat |

## Decisions

1. **Shatter's Double is retired by Osiris, 800 ms after the cast.** A first draft ended the spell with `CAST:Kill()` (vanilla `Shout_GOB_DetonateSelf`), but `CAST:` is its own
   context, so list order does not order it against the area hits, and vanilla only pairs it with item-only hits: a Kill that resolved first would leave Shatter doing
   nothing. Instead the spell is the burst only (the area shape follows `Shout_LOW_HoH_DebtorExplosion`), and the Doubles goal, on `CastSpell(Double, Shatter)`,
   starts an `ObjectTimer` of 800 ms and then calls `PROC_ARCANA_Doubles_Retire` - the existing no-blame path used by the cap and the cleanups (marks no blame,
   unregisters, `Die(..., DEATHTYPE.Lifetime, ...)`), so no enemy gains Doubt for it and the count, `VEIL_LAYER_N` and the registry update as usual. 800 ms is longer
   than the 300 ms / 200 ms setup delays (the only empirical timings in that goal), so the damage and Doubt hits have resolved, and short enough that the Double is
   gone before the next click; the purge keeps the registry row ~1 s after the retire, so even a late Doubt still finds the owner. The Double stays on the field
   (and could be hit, or Dismissed) for that 0.8 s; an enemy that kills it in that window is not credited (the goal skips the retire if it is already dead, and the
   `CastSpell` rule has already marked it blameless).
2. **Unveil's swap is the vanilla `SwapPlaces()` functor** (`Target_LOW_BhaalCultist_BenignTransposition`: `SwapPlaces()` on an ally; Benign
   Transposition itself uses `IF(Ally()):SwapPlaces()`), so no Osiris `CastSpell` rule and no position DBs. The Withdraw work (Task 4) is the
   one that needs Osiris positions.
3. **Once per round across all Doubles = a marker on her, checked in `TargetConditions`.** The spell applies `UNVEIL_USED_TECH` to its target
   (her); `TargetConditions` refuses a target that has it, so no other Double can pick her until the round ends. Vanilla shape: the
   `BENIGN_TRANSPORT_USED` marker (there on the caster) and `SURPRISED` (`TickType EndRound`, lasts the round). The status removes itself
   outside combat and at combat end (`RemoveConditions not Combat()` with `OnApply` as vanilla `HOSTILE`, `OnCombatEnded` as vanilla `RAGE`),
   so the goal needs no cleanup line.
4. **Her as the only target.** `HasStatus('VEIL_LAYER_k', context.Target, GetSummoner(context.Source))` for k = 1..5: she carries one of
   them whenever she has a Double, with herself as the cause (the goal applies it with her as source), and the Double's summoner is her. Same
   shape as vanilla Hunter's Mark (`HasStatus('HUNTERS_MARK',context.Target,GetSummoner(context.Source))`, also in a spell `TargetConditions`)
   and as the `SIGIL` removal check. Another Deceiver's Doubles cannot pick her. Plan B if V12 shows no target: `HasPassive('Arcana_Passive_TheVeil', context.Target)`.
5. **Only a Double can cast them** (`RequirementConditions` on the shimmer status). Reason: `ARCANA_Passive_MirroredSpell` copies any `IsSpell`
   spell cast within 18 m of its holder into her spellbook (no summon filter, inventory D9). Without the guard, Shatter would be copied and the Deceiver could burst for free (a free Shatter with no Double lost); Mirror: Sigil would give her a slot-free Sigil. Correction 5 still needs the goal fix (Task 5); this
   makes the stats safe on their own.
6. **Sigil laying and detonation are unchanged.** Mirror: Sigil applies `SIGIL_TECH` with the Double as cause; `ARCANA_Status_Sigil.txt` turns it into
   her Sigil because the Double is in `DB_ARCANA_MirrorImageOf`. Detonation: `ARCANA_IS_SPELL` in `TargetConditions` makes `IsArcanaSpell()` true for
   the Double's damage, and `HasStatus('SIGIL', context.Target, GetSummoner(context.Source))` matches her Sigil. Shatter has no mark on purpose.
7. **Chains need no status in the `SIGIL` list.** The old Mirror Chains had `TargetConditions ""` and detonated through the status
   `MIRROR_ETHEREAL_CHAINS` (damage came from the status). The new spell deals its damage itself and carries the mark, so the list loses
   `MIRROR_ETHEREAL_CHAINS` and gains nothing.
8. **Names kept.** "Mirror: Sigil of Malice" and "Mirror: Ethereal Chains" keep their existing loca handles (descriptions rewritten, handle version +1, one user each). New keys carry a `DBL_` prefix.
9. **Fixed save DC 13** instead of `SourceSpellDC()` (which reads the Double's own sheet: CHA 18, level 1 = 14 only if the summon keeps level 1). The mod already uses a literal DC (Howl of the Dead, 14).
10. **One small goal edit** (Shatter's retire, Decision 1). The swap is a functor and the marker cleans itself, so nothing else needs Osiris.

## Removals (references checked on 2026-10-06 across `Public`, `Editor`, `Mods` of the mod: stats, lists, progressions, Osiris, Lua, loca)

| Removed | Other references found | Where handled |
|---|---|---|
| `Target_Deceiver_Clone_MirrorDistortion` | `Shout_Deceiver_Clone_MirrorWithdraw.FollowUpOriginalSpell` (removed together); `ARCANA_Spell_MirrorImage.txt` L44/46 (goal replaced by Task 2); `ARCANA_Spell_MirrorWithdraw.txt` L33/43; `Lua/Tests/UtilTest.lua` L19 (a string passed to `U.Category`, no lookup) | goal files: see below |
| `Projectile_Deceiver_Clone_MirrorSigilofMalice` | none besides its own entry | - |
| `Target_Deceiver_Clone_MirrorEtherealChains` | `ARCANA_Spell_MirrorImage.txt` L43/45 (replaced goal) | - |
| `Shout_Deceiver_Clone_MirrorWithdraw` | `ARCANA_Spell_MirrorWithdraw.txt` L26/38/70 | Task 4 |
| `Projectile_Arcana_MirrorDistortion_Explosion` | named only in `Target_Deceiver_Clone_MirrorDistortion.SpellProperties` (removed together) | - |
| `MIRROR_ETHEREAL_CHAINS` (status) | `SIGIL.RemoveConditions` and `ETHEREAL_CHAINS_EFFECT.RemoveConditions` (**both** name it; correction 3 listed only SIGIL); the old Mirror Chains `SpellSuccess` / `TooltipStatusApply` | both `@set` in the same patch |
| `MIRROR_DISTORTION_HELPER` (status) | the two Mirror Distortion / Withdraw spells; `ARCANA_Spell_MirrorWithdraw.txt` L45 | Task 4 |

No spell list, progression, CardDB entry, Khonsu file or other Lua file mentioned any of them (the clone got its spells from Osiris).

### References outside stats that a later task must fix

| What | Where | Task |
|---|---|---|
| Delete the whole goal: it only reacts to the removed spells (dead after this patch, compiles fine) and owns `DB_MirrorWithdraw_Position/_Marker`, timer `ARCANA_MirrorWithdraw_Timer`, the marker template `4441890b-...` | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt` | Task 4 (plan: "`MirrorWithdraw` if still referenced") |
| `ARCANA_Spell_MirrorImage.txt` names three of the removed spells | deleted by the Task 2 apply step | Task 2 apply |
| `ARCANA_Passive_MirroredSpell.txt`: must ignore casters in `DB_ARCANA_MirrorImageOf` (the stats guard above covers the lethal case, not the principle) | Goals | Task 5 (correction 5) |
| Three orphan LevelMap series: `MirrorSigilofMalice_Damage`, `MirrorEtherealChains_Damage`, `MirrorDistortion_Damage` | `Public/$M/Levelmaps/LevelMapValues.lsx` (3 lines), `Editor/Mods/$M/Levelmaps/LevelMapValues.tbl` (3 lines); documented in `Obsidian/ArcanaClass/Class/Damage Tables.md` | Task 6 (structure script) / Task 10 (docs) |
| Orphan loca handles (no tool deletes them): `h1027bccf...` Mirror: Distortion, `he4a289bc...` its description, `h292adcdc...` Mirror: Withdraw, `hc29abaf5...` Mirror Distortion Helper, `h36fb11fd...` Mirror: Ethereal Chains (status); same handles in the 14 other locale files | `english.xml` | cleanup task |
| `U.Category("Target_Deceiver_Clone_MirrorDistortion")` in a test is only a string; swap it for `Target_Deceiver_Double_MirrorChains` for tidiness (it still must give `nil`) | `Lua/Tests/UtilTest.lua` L19 | Task 6 or 10, optional |
| `check_cards.pl` demands the `ARCANA_IS_SPELL` mark only for `Projectile_/Target_/Zone_Deceiver_Clone_` and rejects the card mark on `_Deceiver_Clone_`; the Doubles' spells are `_Deceiver_Double_`, so they are outside both checks. Widen the two patterns to `Deceiver_(?:Clone\|Double)` (Shatter is a Shout and needs no mark, so keep the `Shout` prefix out of the damage rule) | `tools/stats/check_cards.pl` lines 56 and 64 | Task 6 / 10 |
| The Double's binary template (8807d230) has an AI skill list naming the removed Mirror spells (correction 1, not editable here); unknown ids are expected to be ignored (unverified, see below) | `RootTemplates` | Task 2 (V3) |
| Later edits of `SIGIL.RemoveConditions` (e.g. Task 9) must start from the value in this patch (no `MIRROR_ETHEREAL_CHAINS`) | patches | Task 9 |
| Prose that still mentions the old ids (history, not behaviour): `Docs/OSIRIS.md` L261 (timer names), `Obsidian/.../Osiris Reference.md` L112, `Gameplay/*` | docs | Task 10 |

`tools/stats/gen_upcast_damage.pl` lines 78/81 also name `MIRROR_ETHEREAL_CHAINS`, but it is a run-once generator that already ran
(its own header says it dies once nothing is left to replace): not a dependency.

## Apply steps (a `[fechado]` session, after the backup; together with Tasks 1 and 2)

1. `perl tools/stats_add.pl deceiver/10_doubt.patch deceiver/20_doubles.patch deceiver/30_double_spells.patch` (read it), then `--apply`.
2. `perl tools/sort_stats.pl --apply`, `perl tools/check_cards.pl`, `perl tools/stats_add.pl --selftest`.
3. Goals: copy the updated `goals/ARCANA_Deceiver_Doubles.txt` (it carries the Shatter retire; same file as Task 2). Delete `ARCANA_Spell_MirrorWithdraw.txt` in this session or in Task 4 (it is dead from here on).
4. The user compiles in the Toolkit and publishes; read `Story\log.txt` (0 errors).
5. In game, on a fresh save: guide rows V9-V14 below (with the Task 6 passives, or `AddSpell`/`AddPassive` by hand on the Double: the spells only cast from a Double).

## Dry runs (`timeout 300 perl tools/stats_add.pl ...`, never `--apply`)

- `30_double_spells.patch` alone: exit 0. 6 new loca strings + 2 existing handles bumped (`hf22a0eed...` -> v3, `h19148393...` -> v3); 7 `@remove`;
  2 `@set` (`SIGIL.RemoveConditions`, `ETHEREAL_CHAINS_EFFECT.RemoveConditions`); 5 new entries (1 status in `DECEIVER STATUS`, Shatter in
  `Shout_DECEIVER SPELLS`, Mirror: Sigil in `Projectile_DECEIVER SPELLS`, Mirror: Chains and Unveil in `Target_DECEIVER SPELLS`); no warning.
  (`build_obj` ran for every new entry: every field name has a known type in the Toolkit tables.)
- `10_doubt.patch` + `20_doubles.patch` + `30_double_spells.patch`: exit 0, same lines, no warning, no collision.
- Kit check: every id the Doubles goal `AddSpell`s now has a definition: `Shout_Deceiver_Double_Shatter`, `Projectile_Deceiver_Double_MirrorSigil`,
  `Target_Deceiver_Double_MirrorChains`, `Target_Deceiver_Double_Unveil` (this patch), `Shout_Deceiver_Clone_Dismiss` (existing; Task 2 makes it free);
  `Shout_Dash` / `Shout_Disengage` are vanilla (rule `DoubleOfTheVeil`).

## Guide rows (in-game, fresh save)

| Row | Do | Expect | Risk |
|---|---|---|---|
| V9 | With 2 Doubles and 3 enemies (two within 3 m of one Double, one beyond), cast Shatter from that Double. Repeat with no enemy in range | Both near enemies take 1d6 Psychic (no save) and show "Doubt (1)" **at once**; the far one is untouched; about 1 s later the Double vanishes (no corpse left, "The Veil (N)" and her AC drop by 1); exactly **one** Doubt per enemy hit, none from the Double's own disappearance; her Awakening steps (after Task 9) rise by one per enemy. A Sigil on a hit enemy is **not** detonated. With nobody in range the Double still vanishes after the same delay. Also: kill a Shattering Double with an ally spell inside the 0.8 s (no Doubt for anyone, no error) | R4 |
| V10 | A Double casts Mirror: Sigil of Malice at an enemy; then the Deceiver deals damage with a card; then a Double casts it on an enemy that already holds her Sigil | 1d4 Force (no scaling) and a Sigil whose source is the **Deceiver**; her card damage detonates it (Psychic from the Sigil, plus 1 Doubt after Task 9); a second cast detonates the old mark and lays a new one (the card does the same) | - |
| V11 | A Double casts Mirror: Ethereal Chains at enemies with low and high Wisdom, once on a Sigil-marked target and once on a target with Doubt (2) | Failed save: 1d4 Force **once** (no second hit at the end of its turn) and Restrained for 1 turn; passed save: nothing. Doubt (2) makes the save easier to fail (-2). The marked target's Sigil detonates on the damage | - |
| V12 | A Double with Unveil: open the spell | Only the Deceiver is a valid target (allies, other Doubles and enemies are not). Casting swaps their positions exactly, costs only that Double's action and none of hers, works up to 18 m with line of sight | R6 |
| V13 | Two Doubles: Unveil with the first, then try the second in the same round; end the round; try again; then leave combat and cast out of combat | The second Double has **no valid target** until the round ends; the next round it works again; after combat (or out of combat) there is no limit and no leftover marker (check `Osi.HasActiveStatus(deceiver, "UNVEIL_USED_TECH")` from the SE console on the PC edition, or watch the spell become available) | - |
| V14 | Check costs and ownership: a Double casts Shatter, Mirror: Sigil and Mirror: Chains; look at the Deceiver's spell slots, bonus action and hotbar; with Mirrored Spell on (level 12) let a Double cast near her; try to cast any of the four from the Deceiver (console `AddSpell`) | Each costs only 1 action of the Double; her slots and resources do not move; none of them is a card (not in the deck or the hand on the PC edition); Mirrored Spell copies none of them, and the Deceiver cannot cast them ("requirement not met"); Shatter never kills her | - |

## Not verified (no compile, no game)

- **Shatter's 800 ms retire.** The number is a guess from the goal's own 300/200 ms delays, not measured: if V9 shows the hits missing (too short) or the Double lingering visibly (too long), change the timer in the goal. `CastSpell` for a shout is assumed to fire for the Double (the existing `NoBlame` rule already depends on it); if it does not, neither rule fires and the Double stays (V9 shows it).
- The retire's `Die(..., DEATHTYPE.Lifetime, ...)` as the visual of a Shatter (no explosion; cosmetic).
- `SwapPlaces()` with a **summon** as the source (vanilla only swaps ally characters), and with her as the target of a Transformed Double.
- `HasStatus('VEIL_LAYER_k', context.Target, GetSummoner(context.Source))`: that her `VEIL_LAYER_N` keeps "her" as its cause after the goal's
  overwrite, and that `GetSummoner` of a Transformed Double is her. If V12 shows no target, use plan B in Decision 4.
- `TickType EndRound` with duration 1 ending at the end of **the current** round (inferred from vanilla `SURPRISED`; no vanilla `ApplyStatus` of an
  EndRound status found in the stats to confirm the count). Fallback: `TickType StartTurn` (ends at the start of her next turn: one Unveil per her turn cycle).
- `OnApply` + `RemoveConditions not Combat()` removing the marker the moment it lands out of combat (shape copied from vanilla `HOSTILE`).
- `RequirementConditions HasStatus('DOUBLE_OF_THE_VEIL', context.Source)`: the shimmer is applied right after the kit in the same timer, so the spells could
  look unavailable for a frame. If a Double's spells stay greyed after the setup (V1 shows no shimmer), the cause is the shimmer, not the spells.
- The Doubles' Mirror spells keep `Level 1` with no slot cost, as the old Mirror spells did; Shatter and Unveil carry no level.
- Visuals, sounds and animations are placeholders borrowed from Shatter (the vanilla spell), Howl of the Dead's shout animation, Benign Transposition and
  the cards' own effects; not seen in game.
- The Toolkit `.stats` text generated for the new entries was not inspected (the dry run builds it in memory and would stop on an unknown field; a sandbox copy
  to print it was blocked by the `jt-gate` hook). Run `perl tools/stats_add.pl --selftest` after applying.
- Balance: 18 m range for all three ranged spells and DC 13 are drafts for the balance pass; spec 3.2 gives her *control cards* Disadvantage against 2+ Doubt, which is
  not applied to the Doubles' Chains (Doubt already lowers the save by its stacks).
- That a Double with Doubt-inflicted enemies in a Shatter gets the Awakening credit once per enemy (Task 9 reads `DB_ARCANA_DoubtStep`).
- Old clones from an existing save keep stale spells until they die; use a fresh save.
