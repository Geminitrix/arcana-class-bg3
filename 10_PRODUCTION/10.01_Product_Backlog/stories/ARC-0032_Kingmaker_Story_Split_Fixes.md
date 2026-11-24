---
id: ARC-0032
title: "Kingmaker Story split: restore the rules lost and the Master of Laws order"
type: bug
epic: EPIC_Rework_Subclasses
subclass: kingmaker
status: ready
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

**Goal:** put back in the Kingmaker's split goals every rule the single goal had and the split dropped, and give the
Master of Laws its old place after the Wheel turns.
**Intent:** at Tier I Coronation and Dethrone bind again (one position ahead), and Rota Fortunae, Swift Shears,
Severance, the King's Hand and the Master of Coin play as `21.04/Kingmaker/DESIGN.md` describes.

Found 2026-11-24 from the Owner's report: "at Tier I the Kingmaker can no longer put anyone on the Wheel". On 2026-11-19
the Owner split `ARCANA_Kingmaker_Wheel` (1597 lines) into ten goals, one per feature. The Story compiled with 0 errors
(`Story/log.txt`, 2026-11-19 21:40), so nothing is a syntax error: the split lost rules. Method: every rule of the old
goal (the 51 copy) compared, normalised, with every rule of the ten new goals. Stats were checked: they still apply
every status listed below, so only the Osiris half is missing. The game was open: every change below is a copy-paste
block (OR-11). WIP is over the limit (OR-36), but this blocks the Kingmaker's playtest (ARC-0008), so it is `must`.

## The changes

### F1 · Tier I *Tyche* — Coronation and Dethrone bind one position ahead (the reported bug)

The old goal had four bind rules: two with `NOT DB_ARCANA_AspectReached(_Owner, 1)` (Rising / Falling) and two with
`DB_ARCANA_AspectReached(_Owner, 1)` (Reigning / Fallen). The split kept only the first two, so once Tier I awakens
**no rule answers** `KINGMAKER_BIND_ALLY_TECH` / `KINGMAKER_BIND_ENEMY_TECH` — and Wheel of Ixion binds through the
same status, so it stops too. Add to `ARCANA_Aspect_WheelOfFortune.txt`, a new region right after `Tables`:

```
//REGION Tier I - Tyche: Coronation and Dethrone bind one position ahead
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ALLY_TECH", (CHARACTER)_Owner, _)
AND
DB_ARCANA_AspectReached(_Owner, 1)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "REIGNING", 1);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_BIND_ENEMY_TECH", (CHARACTER)_Owner, _)
AND
DB_ARCANA_AspectReached(_Owner, 1)
THEN
PROC_ARCANA_Kingmaker_Bind(_Owner, _Creature, "FALLEN", 0);
//END_REGION
```

### F2 · *Rota Fortunae* (Tier I card) — the Wheel turns once more, now

All three `KINGMAKER_TURN_TECH` rules are gone; the card (`Spell_Shout.txt` applies `KINGMAKER_TURN_TECH`) does
nothing. Add to `ARCANA_Aspect_WheelOfFortune.txt`, after F1 (the three rules stay together and in this order):

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

### F3 · *Swift Shears* (level 3) and *Severance* (level 4)

Nothing gives `KINGMAKER_SHEARS_FREE` any more (only Osiris did), and nothing spends `KINGMAKER_SEVERANCE` (the passive
in Stats still gives it, so after one Cut every Dethrone stays a Bonus Action). Add to `ARCANA_Kingmaker_AtroposCut.txt`,
after the Atropos' Cut region:

```
//REGION Swift Shears (level 3) - the first Atropos' Cut of each of the Kingmaker's turns costs no action
IF
TurnStarted((CHARACTER)_Kingmaker)
AND
HasPassive(_Kingmaker, "Arcana_Passive_SwiftShears", 1)
THEN
ApplyStatus(_Kingmaker, "KINGMAKER_SHEARS_FREE", 6.0, 1, _Kingmaker);

IF
CastedSpell((CHARACTER)_Kingmaker, _Spell, _, _, _)
AND
DB_ARCANA_CardFamily(_Spell, "Target_Arcana_Card_Spell_AtroposCut")
AND
HasActiveStatus(_Kingmaker, "KINGMAKER_SHEARS_FREE", 1)
THEN
RemoveStatus(_Kingmaker, "KINGMAKER_SHEARS_FREE", _Kingmaker);
//END_REGION

//REGION Severance (level 4) - the first Dethrone after an Atropos' Cut spends KINGMAKER_SEVERANCE
IF
CastedSpell((CHARACTER)_Kingmaker, _Spell, _, _, _)
AND
DB_ARCANA_CardFamily(_Spell, "Target_Arcana_Card_Spell_Dethrone")
AND
HasActiveStatus(_Kingmaker, "KINGMAKER_SEVERANCE", 1)
THEN
RemoveStatus(_Kingmaker, "KINGMAKER_SEVERANCE", _Kingmaker);
//END_REGION
```

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

### F5 · Master of Coin (level 9) — once per Long Rest

Two divergences from DESIGN ("**Once per Long Rest**"): `KINGMAKER_COIN_SPENT` is now applied for `6.0` (one round, so
once per round), and the Long Rest rule that removed it is gone. **Owner decision needed:** back to once per Long Rest
(recommended, as designed) or keep once per round (then it is a design change: log it in `DECISIONS.md`). If once per
Long Rest: in `ARCANA_Kingmaker_KingsCourt.txt`, region *Master of Coin*, change `6.0` back to `-1.0`, and add this rule
in region *The Court*, **before** the rule `LongRestFinished() AND DB_ARCANA_Kingmaker_Seats(...)` that deletes the
seats (it reads them):

```
IF
LongRestFinished()
AND
DB_ARCANA_Kingmaker_Seats(_Owner, _N)
THEN
RemoveStatus(_Owner, "KINGMAKER_COIN_SPENT", _Owner);
```

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

## Acceptance criteria

- [ ] F1–F6 in the game (F5 as the Owner decides); the Story compiles with 0 errors (`Story/log.txt`).
- [ ] A rule-by-rule comparison of the 51 copy's old goal with the new goals shows only the intended differences.
- [ ] `check_osiris.pl --dir` on the game goals: no errors on the Kingmaker goals (F7).
- [ ] In game, Tier I awakened: Coronation puts an ally at **Reigning**, Dethrone and Wheel of Ixion put an enemy at
      **Fallen**; before Tier I, Rising and Falling as before.
- [ ] Rota Fortunae turns every creature on the Wheel one step at once, and the Crossing follows.
- [ ] Swift Shears: the first Atropos' Cut of a turn costs no action, the second does. Severance: after a Cut, only
      the next Dethrone costs a Bonus Action.
- [ ] King's Hand: never King; crits on 19–20 while there is no King or the King is not Reigning.
- [ ] Master of Coin: one slot back per Long Rest (or per round, if the Owner decides so in F5).
- [ ] Master of Laws: a condemned enemy at Rising goes Reigning → Falling at the turn start; at Falling it goes only to
      Fallen, never past it.
- [ ] `sync_data`, then commit and push (OR-40).

## Gates

- [ ] DoD (`00.03`)

## Log

- 2026-11-24 — created from the Owner's Tier I report; the cause (F1) and five more losses of the split found by
  comparing the old single goal with the ten new ones.
