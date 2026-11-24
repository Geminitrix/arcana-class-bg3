---
id: ARC-0032
title: "Kingmaker Story split: restore the rules lost and the Master of Laws order"
type: bug
epic: EPIC_Rework_Subclasses
subclass: kingmaker
status: in_progress
owner: Mod Engineer
implementation: owner
priority: must
value: 5
effort: 2
inputs: [game Story ARCANA_Kingmaker_* + ARCANA_Aspect_WheelOfFortune (2026-11-19), 51 copy ARCANA_Kingmaker_Wheel.txt (single goal, last sync 443a1eb), 21.04/Kingmaker/DESIGN.md, 57.05/OSIRIS.md §13.2]
outputs: [game Story (ARCANA_Aspect_WheelOfFortune, ARCANA_Kingmaker_AtroposCut, ARCANA_Kingmaker_CrownTheKing, ARCANA_Kingmaker_KingsCourt, ARCANA_Kingmaker_Wheel, ARCANA_Kingmaker_Crossing), 51 copy (sync_data)]
blocked_by: []
sprint: S01
created: 2026-11-24
---

# ARC-0032 · Kingmaker Story split: restore the rules lost and the Master of Laws order

**Goal:** put back in the Kingmaker's split goals the rules the Owner's Stats still need, drop the ones the Stats
rework replaced, and give the Master of Laws its old place after the Wheel turns.
**Intent:** Coronation and Dethrone bind at every tier, and Rota Fortunae, the King's Hand, the Master of Laws and the
texts play as `21.04/Kingmaker/DESIGN.md` describes after SP121–SP125.

Found 2026-11-24 from the Owner's report: "at Tier I the Kingmaker can no longer put anyone on the Wheel". On 2026-11-19
the Owner split `ARCANA_Kingmaker_Wheel` (1597 lines) into ten goals, one per feature, and reworked Tyche, Swift
Shears, Severance and The Wheel Stops in Stats. The Story compiled with 0 errors (`Story/log.txt`, 2026-11-19 21:40),
so nothing is a syntax error. Method: every rule of the old goal (the 51 copy) compared, normalised, with every rule of
the ten new goals; then the Owner's Stats edits compared entry by entry (`d28ee51`), which showed that the Tyche binds,
Swift Shears and Severance rules were dropped on purpose (SP122–SP124). WIP is over the limit (OR-36), but this blocks
the Kingmaker's playtest (ARC-0008), so it is `must`.

**First version of this ticket (built in the game 2026-11-24, `f3f292b`) is wrong on F1 and F3:** it restored the Tyche
binds and the old Swift Shears / Severance rules before the Owner's Stats rework was known. F1 and F3 below now undo
that; the rest stands.

## The changes

### F1 · Coronation, Dethrone and Wheel of Ixion bind at Rising / Falling at every tier (the reported bug, SP122)

The two bind rules left in `ARCANA_Kingmaker_Wheel.txt` still carry `NOT DB_ARCANA_AspectReached(_Owner, 1)` from the
old goal, where two other rules handled Tier I. With those gone (SP122), once Tier I awakens **no rule answers**
`KINGMAKER_BIND_ALLY_TECH` / `KINGMAKER_BIND_ENEMY_TECH` (Wheel of Ixion binds through the same status).

**1a** — `ARCANA_Kingmaker_Wheel.txt`, region *Coronation and Dethrone*: replace the comment and the two `IF` rules
with:

```
// Every tier binds here: an ally enters at Rising, an enemy at Falling (SP122). Tyche (Tier I) frees the first
// Turn the Spoke of each turn instead, in Stats (KINGMAKER_TYCHE).
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ALLY_TECH", (CHARACTER)_Owner, _)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "RISING", 1);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ENEMY_TECH", (CHARACTER)_Owner, _)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "FALLING", 0);
```

**1b** — `ARCANA_Aspect_WheelOfFortune.txt`: delete the whole region `Tier I - Tyche: Coronation, Dethrone and Wheel of
Ixion bind one position ahead` (its comment and two rules). In the header, the line "Tier I Tyche binds one position
ahead and brings Rota Fortunae" becomes "Tier I Tyche (the free Turn the Spoke is in Stats) brings Rota Fortunae", and
`PROC_ARCANA_Kingmaker_Bind` leaves the "Calls" list.

### F2 · *Rota Fortunae* (Tier I card) — the Wheel turns once more, now

All three `KINGMAKER_TURN_TECH` rules are gone; the card (`Shout_Arcana_Created_RotaFortunae`, Action, once per combat,
applies `KINGMAKER_TURN_TECH`) does nothing. Add to `ARCANA_Aspect_WheelOfFortune.txt`, right after `Tables` (the three
rules stay together and in this order):

```
//REGION Tier I - Rota Fortunae: the Wheel turns once more, now
IF
StatusApplied(_Owner, "KINGMAKER_TURN_TECH", _, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
DB_ARCANA_Kingmaker_Pending(_Owner, _Creature);

IF
StatusApplied(_Owner, "KINGMAKER_TURN_TECH", _, _)
AND
DB_ARCANA_Kingmaker_Pending(_Owner, _Creature)
THEN
NOT DB_ARCANA_Kingmaker_Pending(_Owner, _Creature);
PROC_ARCANA_Kingmaker_Move(_Owner, _Creature);

IF
StatusApplied(_Owner, "KINGMAKER_TURN_TECH", _, _)
AND
DB_ARCANA_Kingmaker_Counter(_Owner, _)
THEN
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION
```

### F3 · *Swift Shears* and *Severance* live in Stats — no Osiris (SP123, SP124)

The Owner's Stats do both whole: `Arcana_Passive_SwiftShears` (once per turn, on Turn the Spoke) gives
`KINGMAKER_SWIFT_SHEARS`, `Arcana_Passive_Severance` (once per turn, on Atropos' Cut) gives `KINGMAKER_SEVERANCE`; each
status frees the next card and ends on that cast or at the end of the turn. `KINGMAKER_SHEARS_FREE` no longer exists
(it is now only a StackId). In `ARCANA_Kingmaker_AtroposCut.txt` delete the regions *Swift Shears (level 3)* and
*Severance (level 4)*, and in the header keep only the Cut: "Swift Shears and Severance are whole in Stats
(KINGMAKER_SWIFT_SHEARS, KINGMAKER_SEVERANCE)"; `DB_ARCANA_CardFamily` leaves the "Reads" list.

### F4 · King's Hand (level 5) — never crowned; crits on 19–20 while there is no Reigning King

The four `KINGS_HAND` rules of `PROC_ARCANA_Kingmaker_Crown` are gone: `KINGMAKER_HAND_CROWN` is never given, and only
removed. They must stay **inside `ARCANA_Kingmaker_CrownTheKing.txt`**: they read `DB_ARCANA_Kingmaker_Best`, which the
last rule of that PROC deletes, and another goal's rules for the same PROC would run after it (goals answer in
alphabetical order, `57.05` §13.2).

**4a** — between the second rule (`... DB_ARCANA_Kingmaker_Court(_, _Creature, _) ... RemoveStatus(... "KINGMAKER_REGENT" ...)`)
and the rule that starts `DB_ARCANA_Kingmaker_Best((CHARACTER)_Owner, (CHARACTER)_Creature, (INTEGER)_Rounds)`:

```
PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Hand, "KINGS_HAND")
AND
HasActiveStatus(_Hand, "KINGMAKER_KING", 1)
THEN
RemoveStatus(_Hand, "KINGMAKER_KING", _Owner);
```

**4b** — between the rule that gives `KINGMAKER_REGENT` and the last rule (`NOT DB_ARCANA_Kingmaker_Best(_Owner, _King, _Rounds)`):

```
PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
NOT DB_ARCANA_Kingmaker_Best(_Owner, _, _)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Hand, "KINGS_HAND")
AND
IsDead(_Hand, 0)
AND
IsInCombat(_Hand, 1)
THEN
ApplyStatus(_Hand, "KINGMAKER_HAND_CROWN", -1.0, 1, _Owner);

PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_Best(_Owner, _King, _)
AND
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _King, "REIGNING", 1, _)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Hand, "KINGS_HAND")
AND
IsDead(_Hand, 0)
AND
IsInCombat(_Hand, 1)
THEN
ApplyStatus(_Hand, "KINGMAKER_HAND_CROWN", -1.0, 1, _Owner);

PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_Best(_Owner, _King, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _King, "REIGNING", 1, _)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Hand, "KINGS_HAND")
THEN
RemoveStatus(_Hand, "KINGMAKER_HAND_CROWN", _Owner);
```

### F5 · Master of Coin (level 9) — once per round (SP121)

**Decided by the Owner (2026-11-24, SP121): once per round**, knowing the balance pass's estimate (≈ 8 slots a day,
≈ 44 % of D). The Story already does it (`KINGMAKER_COIN_SPENT` for `6.0`), so **no Osiris change**: the old Long Rest
rule is not restored. Only the texts change (F8). Propagated: DECISIONS (SP121), DESIGN, 05.02, 22.05, 25
(`FEAT_Kingmaker_Court`), 26.01, 32.01, SPEC_ARC-0008 (row and P37), QA_ARC-0008 (L9.2 and the Court row).

### F6 · Master of Laws (level 7) — the extra step after the Wheel turns, not before

In the old goal the Law rules ran after the Wheel's turn-start moves and read the enemy's **new** position ("now Reigns
→ skips its reign; now Falls → drops to Fallen"). Moved to `KingsCourt`, they answer `TurnStarted` **before** `Wheel`
(alphabetical goal order, `57.05` §13.2), read the old position and push the enemy one step too far: a condemned enemy
at Falling ends at Rising (past Fallen, against SP105), one at Rising no longer skips its reign. Fix with a hook, the
pattern the split already uses (`Move_Override`, `Settle_*`):

**6a** — `ARCANA_Kingmaker_Wheel.txt`, region *The Wheel Turns*, right after the rule `TurnStarted(_Owner) AND
DB_ARCANA_Kingmaker_Pending(...) THEN ... PROC_ARCANA_Kingmaker_Move(_Owner, _Creature);`:

```
IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_Counter(_Owner, _)
THEN
PROC_ARCANA_Kingmaker_AfterTurn(_Owner);
```

**6b** — `ARCANA_Kingmaker_KingsCourt.txt`, region *Master of Laws*: replace its three `TurnStarted` rules (keep the
`AttackedBy` rule) with:

```
PROC
PROC_ARCANA_Kingmaker_AfterTurn((GUIDSTRING)_Owner)
AND
NOT DB_ARCANA_Kingmaker_Stopped(_Owner, _)
AND
DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, _Position, 0, _)
AND
DB_ARCANA_Kingmaker_LawStep(_Position)
THEN
DB_ARCANA_Kingmaker_LawPending(_Owner, _Enemy);

PROC
PROC_ARCANA_Kingmaker_AfterTurn((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_LawPending(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_LawPending(_Owner, _Enemy);
PROC_ARCANA_Kingmaker_Move(_Owner, _Enemy);

PROC
PROC_ARCANA_Kingmaker_AfterTurn((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy);
```

(`Counter` exists whenever a creature is on the Wheel, and `Condemned` only names a creature on the Wheel, so the
condition loses nothing.)

### F7 · Tidy-up, no behaviour change

- The base Crossing rule "an ally that entered Reigning: one Crossing with each Fallen enemy within 9 m" sits in
  `KingsCourt`, region *Master of Ships*. Move it to `ARCANA_Kingmaker_Crossing.txt`, region *The Crossing*, before the
  Fortune's Reach `NewRuler` rule (all `Settle_Pairs` rules only fill `CrossPair`, so the order does not matter).
- `check_osiris --dir <game Goals>` fails every new goal: no header (`//` block naming the DBs each goal writes, `57.05`
  §13.2) and LF line endings. The old goal's header (51 copy, lines 7–43) is the source for the new ones.
- Goal name `ARCANA_Kingmaker_Succesion` → `ARCANA_Kingmaker_Succession` (unpublished, so it may be renamed, OR-59).

### F8 · Master of Coin texts (English, `Localization/English/english.xml`)

The passive and the status already say "Once per turn", but the slot tag opens as `LStag` (it closes as `LSTag`) and
reads "an Woeven spell slot"; the office's option still says "Once per Long Rest". "Once per turn" is the mod's usual
wording (13 lines in the game). Replace the two contents:

`h26ba79dbg7e32g654cgfd1dg6b12172ae32d` (`Arcana_Passive_Court_MasterOfCoin`, `COURT_MASTER_OF_COIN`):

```
Once per turn, hitting a &lt;LSTag Type="Status" Tooltip="KINGMAKER_FALLEN"&gt;Fallen&lt;/LSTag&gt; enemy returns a &lt;LSTag Tooltip="ArcanaSpellSlot"&gt;Woven Spell Slot&lt;/LSTag&gt; to the Kingmaker.
```

`h727fe14dga5d2g7e31g063agd262d1723893` (`Target_Arcana_Util_Court_MasterOfCoin`):

```
Appoint an ally as Master of Coin. Once per turn, when it hits a &lt;LSTag Type="Status" Tooltip="KINGMAKER_FALLEN"&gt;Fallen&lt;/LSTag&gt; enemy, you regain a spell slot.
```

The other 14 languages still say "Long Rest": they catch up in the next translation sync (as ARC-0031 for the Windborn).

### F9 · Tyche and Severance texts (English, `Localization/English/english.xml`)

Tyche's texts disagree (one says "cast it again", two still describe the binds ahead) and two read "doensn't";
Severance says "bonus action" while the Stats free the whole action (SP124, Owner). Replace these contents:

`h7d8aeb38gcef3ga5dag1da2gab3006c2cda3` (`KINGMAKER_TYCHE`):

```
The next &lt;LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_TurnTheSpoke"&gt;Turn the Spoke&lt;/LSTag&gt; this turn doesn't cost a &lt;LSTag Type="ActionResource" Tooltip="BonusActionPoint"&gt;bonus action&lt;/LSTag&gt;.
```

`h5ef1fcf4gc897gfbeegfb34g3977e816a895` (`Arcana_Passive_Aspect_WheelOfFortune_I`):

```
Your first &lt;LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_TurnTheSpoke"&gt;Turn the Spoke&lt;/LSTag&gt; each turn doesn't cost a &lt;LSTag Type="ActionResource" Tooltip="BonusActionPoint"&gt;bonus action&lt;/LSTag&gt;.
```

`hdb57b761g4bccg9dc0gc0bbga4b8608b80c0` (`ASPECT_AWAKENED_WHEEL_I`):

```
Tyche: your first &lt;LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_TurnTheSpoke"&gt;Turn the Spoke&lt;/LSTag&gt; each turn doesn't cost a &lt;LSTag Type="ActionResource" Tooltip="BonusActionPoint"&gt;bonus action&lt;/LSTag&gt;.
```

`hca6c0fb0g05f5g90efg3166g67d75daf320e` (`ASPECT_AWAKENED_WHEEL_II`):

```
Tyche: your first &lt;LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_TurnTheSpoke"&gt;Turn the Spoke&lt;/LSTag&gt; each turn doesn't cost a &lt;LSTag Type="ActionResource" Tooltip="BonusActionPoint"&gt;bonus action&lt;/LSTag&gt;.&lt;br&gt;&lt;br&gt;Nemesis: when an enemy with Hubris suffers its Crossing, every enemy within [1] of it that is Falling drops to Fallen.
```

`hf988d590gcd2fg4d99g9955ge9d1b74382a2` (`ASPECT_AWAKENED_WHEEL_III`):

```
Tyche: your first &lt;LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_TurnTheSpoke"&gt;Turn the Spoke&lt;/LSTag&gt; each turn doesn't cost a &lt;LSTag Type="ActionResource" Tooltip="BonusActionPoint"&gt;bonus action&lt;/LSTag&gt;.&lt;br&gt;&lt;br&gt;Nemesis: when an enemy with Hubris suffers its Crossing, every enemy within [1] of it that is Falling drops to Fallen.&lt;br&gt;&lt;br&gt;Aspect of Anticipation: your allies never touch the bottom of the Wheel; they stay Falling for one more turn instead of becoming Fallen.
```

`h59f96b3dg664dg739dg9888g10653038fb83` (`Arcana_Passive_Severance`):

```
When you cast &lt;LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_AtroposCut"&gt;Atropos' Cut&lt;/LSTag&gt;, your next &lt;LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_Dethrone"&gt;Dethrone&lt;/LSTag&gt; this turn doesn't cost an &lt;LSTag Type="ActionResource" Tooltip="ActionPoint"&gt;action&lt;/LSTag&gt;.
```

## Acceptance criteria

- [x] F2, F4, F6, F7, F8 in the game (Claude, 2026-11-24, `[fechado]`).
- [ ] F1 and F3 as rewritten (undoing the first build) and F9's texts in the game.
- [ ] The Story compiles with 0 errors (`Story/log.txt`).
- [x] A rule-by-rule comparison of the 51 copy's old goal with the new goals shows only the intended differences.
- [x] `check_osiris.pl --dir` on the game goals: no errors on the Kingmaker goals (F7).
- [ ] In game, before and after Tier I: Coronation puts an ally at **Rising**, Dethrone and Wheel of Ixion put an enemy at
      **Falling**. With Tier I, the first Turn the Spoke of each turn costs no Bonus Action, the second does (SP122).
- [ ] Rota Fortunae turns every creature on the Wheel one step at once, and the Crossing follows.
- [ ] Swift Shears: after Turn the Spoke, the next Atropos' Cut that turn costs no action (once per turn). Severance:
      after a Cut, the next Dethrone that turn costs no action (once per turn). The chain Spoke - Cut - Dethrone works.
- [ ] King's Hand: never King; crits on 19–20 while there is no King or the King is not Reigning.
- [ ] Master of Coin: one slot back the first hit on a Fallen enemy each round, none on the second; again the next
      round. Count the slots regained in a day of 4 fights (the balance alarm of SP121).
- [ ] Master of Laws: a condemned enemy at Rising goes Reigning → Falling at the turn start; at Falling it goes only to
      Fallen, never past it.
- [x] `sync_data`, then commit and push (OR-40).

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-11-24 — created from the Owner's Tier I report; the cause (F1) and five more losses of the split found by
  comparing the old single goal with the ten new ones.
- 2026-11-24 — the Owner chose Master of Coin once per round (SP121, over the balance pass's warning); F5 needs no
  Osiris change; propagated to every department; F8 (texts) added.
- 2026-11-24 — built by Claude on the Owner's `[fechado]` request: F1, F2 (`ARCANA_Aspect_WheelOfFortune`), F3
  (`ARCANA_Kingmaker_AtroposCut`), F4 (`ARCANA_Kingmaker_CrownTheKing`), F6 (hook `PROC_ARCANA_Kingmaker_AfterTurn`:
  `Wheel` calls it, `KingsCourt` answers it), F7 (headers in all ten goals, CRLF, the NewRuler Crossing rule moved to
  `Crossing`, the goal renamed `ARCANA_Kingmaker_Succession`), F8 (two English texts). Backup in
  `94_Safety_Backups/ARC-0032_2026-11-24/`. `check_osiris`: 0 errors in the Kingmaker goals (type-pin warnings only);
  the rule comparison with the old goal shows only the intended differences. 25 `game_ids`, 57.05 §13.8, DESIGN and
  05.02 now name the split goals. Waiting for the Owner: compile in the Story Editor, then play the criteria.
- 2026-11-24 — the Owner: Tyche must not bind ahead; from Tier I the first Turn the Spoke of each turn is free. The
  Owner's Stats (`d28ee51`) already did it, and also reworked Swift Shears and Severance and made The Wheel Stops once
  per combat; the Owner confirmed all four (SP122–SP125; Severance frees the whole action). The first build's F1 and F3
  were wrong (old design): F1 now removes the Tier I guard from the binds, F3 removes the old rules; F9 fixes the texts.
