---
id: 55/_wip/Osiris/ARC-0030/RISKS
ticket: ARC-0030
owner: Mod Engineer
created: 2026-10-20
---

# ARC-0030 · Osiris audit — what can go wrong, and what was done

The audit of the 21 goals in the game on 2026-10-20 (the copy in `51` was identical), against the house standard of
`57.05/OSIRIS.md` §13. Three classes:

- **A — applied:** no change in normal play (state hygiene, timers, types, structure, comments).
- **B — applied with the Owner's OK (2026-10-20):** changes play in an edge case.
- **C — open:** not changed; watch it, test it or decide it later.

Proof that nothing else changed: `check_osiris.pl --compare <old goals> goals/` lists only the code lines of A and B
(10 goals); the other 10 print "same code"; `ARCANA_Spell_MirrorWithdraw` is "only in OLD" (B5).

## A — applied

| # | Goal | What could go wrong | Fix |
|---|---|---|---|
| A1 | Kingmaker_Wheel | Five Nemesis rules sat outside any region and an `//END_REGION` closed nothing: the next edit lands in the wrong block | Region "Nemesis (Tier II)" around them |
| A2 | Spell_FacelessCopy | A real-time timer cancelled with `ObjectTimerCancel` (twice). If that cancel does not stop a real-time timer (vanilla does it both ways, unproven), Faceless: Copy cast twice inside 0.8 s transforms early | `RealtimeObjectTimerCancel` |
| A3 | Deceiver_Doubles, Aspect_Empress | Four timers launched without a cancel (`ARCANA_Double_Form`, `_Kit`, `_Shatter`, `ARCANA_VeilLifts`): relaunching a live timer is unspecified | Cancel of the same family before each launch |
| A4 | CardFamilies | The table was never cleared: a save keeps the rows of variants that left it (today `Shout_Arcana_Card_Spell_EvasiveFlow`, `_Thunderclap`, `Rush_Arcana_Created_Aspect_LeapOfFaith`). A variant that moves to another card would answer for both | Init clears before it fills; type pin |
| A5 | Deceiver_Doubles | `DB_ARCANA_DoubleRuleTier` was written in INITSECTION, which runs once per save: a save made before a change of the rule table would keep the old rules forever | Table moved to `PROC_ARCANA_Doubles_Init` (clear, fill) + `SavegameLoaded`; type pin |
| A6 | Resonant_Grudge | A dead creature's row stayed until some fight ended | Deleted on `Died` |
| A7 | Common, Overload, CardFamilies, Doubles | Shared DBs typed only by first use, in another goal's compile order | Type pins: `DB_ARCANA_Aspect_InCombat`, `DB_ARCANA_AspectReached`, `DB_ARCANA_Resonant_OverloadFull`, `DB_ARCANA_CardFamily`, `DB_ARCANA_DoubleRuleTier` |
| A8 | 9 goals | Mixed CRLF / LF line endings | CRLF everywhere |
| A9 | all | Comments in Portuguese (8 goals), task / stage / ticket history (8 goals), stale references: the Sigil goal cited a `DB_ARCANA_SigilOwner` in the Empress goal that no longer exists; the Doubles goal cited `Docs/OSIRIS.md`; the Common goal described a PERCENT mode that no longer exists; 5 goals had no header | Every goal has a header (what, why, DBs and who deletes them, shared contracts) and English comments without history |
| A10 | generators | `gen_emotion_alchemy.pl`, `gen_upcast_variants.pl`, `gen_awakening_progress.pl` would undo the standard on the next run; a test of `gen_emotion_alchemy.t` failed since 92d4635 (Harmony's `HasPassive` condition) | The generators emit the standard; the test matches the rule (340/340) |

## B — applied with the Owner's OK (2026-10-20)

| # | Goal | What could go wrong | Fix |
|---|---|---|---|
| B1 | Kingmaker_Wheel | 12 rules on `CombatEnded(_)`: the end of ANY fight on the map (NPCs fighting elsewhere) wiped every Wheel in the middle of a fight | `QRY_ARCANA_Kingmaker_FightOver`: a Wheel clears only when its owner is not still in another fight (`CombatGetGuidFor`, 13 vanilla goals use it) |
| B2 | Resonant_Grudge | The same pattern: another fight ending wiped every grudge | `QRY_ARCANA_Resonant_Grudge_FightOver` |
| B3 | Aspect_Common | A character that gets no `LeftCombat` (a death, for instance) kept its roster row, and its Aspect statuses were never reset | On `CombatEnded`, a character still listed in that fight is removed and reset (one that already left has no row: nothing runs twice) |
| B4 | Status_Hemorrhage | `DB_Hemorrhage_*`, `PROC_Hemorrhage_*` had no `ARCANA_` prefix: a clash with another mod's names | Renamed `DB_ARCANA_Hemorrhage_Total` / `_LastHP`, `PROC_ARCANA_Hemorrhage_*`. A save with a Hemorrhage active at the update loses that one burst |
| B5 | Spell_MirrorWithdraw | Dead goal: `Target_Deceiver_Clone_MirrorDistortion`, `Shout_Deceiver_Clone_MirrorWithdraw` and `MIRROR_DISTORTION_HELPER` no longer exist in the Stats (the Withdraw goal replaced it); its `EnteredLevel` rule still ran for every item that entered a level | Retired: archived in `93_Old_Versions/2026-10-20_ARC-0030_mirrorwithdraw_goal/`, removed from the game at the apply |

## C — open

| # | Goal | Risk | What to do |
|---|---|---|---|
| C1 | Status_Hemorrhage | Two Eternals on one target: both banks fill from the one `LastHP` row and both burst | Design question (one bank per target, the latest applier?) — only if two Eternals in a party is a case |
| C2 | Aspect_Fool | The Calm and the bag spells are matched by exact name (`CastedSpell(..., "Shout_Arcana_Created_TheCalm", ...)`, `DB_ARCANA_BagSpell`); `check_cards.pl` flags that pattern | Fine while they have no upcast variants. If they get some, switch to `DB_ARCANA_CardFamily` **after** C3 |
| C3 | CardFamilies | The table in the game is older than the Stats: 11 roots missing (the newest Windborn spells: AeolusBag ×7, TheCalm, ZephyrRush ×2, WhereTheWindsMeet), 3 obsolete. No rule reads the missing ones today | `gen_upcast_variants.pl --apply` with the game closed regenerates it whole (it also rewrites the variants — a build step of its own) |
| C4 | Aspect_Common | `DB_ARCANA_Aspect` still names one legacy progress status per Aspect (`ASPECT_PROGRESS_<X>`); `ASPECT_PROGRESS_WHEEL` does not exist in the Stats | Harmless (the reset removes a status nobody has); clean when the table is next touched |
| C5 | Aspect_Fool | `PROC_ARCANA_Fool_ReleaseClear` removes WINDSWEPT while it iterates `DB_ARCANA_Windswept`, whose rows the StatusRemoved rule deletes. Osiris behaviour on a DB changed mid-iteration is not proven (the Doubles goal avoids the pattern: pick first, act after) | Watch: QA_ARC-0029 "only those 3 take HEADWIND_NOTUS" and every release; if a mark survives a release, collect then remove |
| C6 | Death, Grudge, Fool | `AttackedBy` also fires for damage over time and the environment; no rule filters `_DamageCause` | Death's Sorrow counts every point by design; check that a DoT tick may set the Grudge's last attacker and a Fellow Traveller's mark |
| C7 | Aspect_Common | Two fights merged: a character with two roster rows is reset when the first ends (as before) | Only if it shows up in play |
| C8 | gen_awakening_progress.t | 1 of 46 fails: it expects the Fool goals 3/4/5 and the old Wanderlust texts (the Windborn rework made them 3/5/8) | Its patch output (passive texts) is stale: do not apply it without a review |
