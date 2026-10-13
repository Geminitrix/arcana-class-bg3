# Kingmaker · balance pass (ARC-0008, 2026-10-13)

The arithmetic behind the Kingmaker's numbers. **Approved by the Owner on 2026-10-13**, with the six design changes of §7
(SP106–SP111). The values live in `25_Master_Data` (`FEAT_Kingmaker_*`, `SPL_Kingmaker_*`).
Design: `21.04/Kingmaker/2026-10-13-kingmaker-design.md`. First educated guesses: every number has a playtest
check in §8.

## Assumptions

The currency and parameters of `22.06/Arcana_Power_Budget.md`: 1 point = 1 expected damage on one target;
E = 4 encounters, T = 4 turns; **A** (the reference action, Fire Bolt) = 4 / 8 / 11 and the daily budget
**D** = 132 / 304 / 504 in tiers 1 / 2 / 3 (levels 1–4 / 5–8 / 9–12); slot value S(N) = 8 / 12 / 20 / 24 /
28 / 32 for slot levels 1–6. Woven Spell Slot level 1 / 2 / 3 / 4 / 5 / 6 at character levels 1 / 3 / 5 / 7
/ 9 / 11. Enemy Charisma save fail chance against the Arcana DC: 0.55 (T1), 0.60 (T2), 0.65 (T3) (base
fail chance + the budget's −1 CHA adjustment; to verify against vanilla stat blocks, SP84). Party of 4;
≈ 3 allied attacks per round on a chosen target.

**Crossings per round (steady state, from turn 2):** ≈ 0.75 at levels 3–4 (one pair kept in anti-phase,
Turn the Spoke to hasten), ≈ 1.0 at levels 5–8, ≈ 1.3 at levels 9–12 (Ixion, Succession, Nemesis, the
field-wide range at 12). A normal fight therefore gives ≈ 2.25 / 3 / 4 Crossings.

## 1. The four positions — `FEAT_Kingmaker_TheRota`

| Position | Effect (vanilla pattern) | Value per turn, for the party |
|---|---|---|
| Rising | +3 m movement (`ActionResource(Movement,3,0)`, Longstrider); can't be Prone | ally +0.05A · enemy −0.05A |
| Reigning | crit 19–20; Advantage on saves | ally +0.3A · enemy −0.4A |
| Falling | −3 m movement (`ActionResource(Movement,-3,0)`, Ray of Frost); −1d4 attacks (Bane) | enemy +0.3A · ally −0.3A |
| Fallen | Advantage against it (≈ 3 attacks × 0.3A × 0.8); no reactions (0.1A) | enemy +0.8A · ally −0.8A |

**Over a full cycle the positions cancel out** (a creature spends one turn in each), for allies and for
enemies alike. That is the design: the Wheel itself gives nothing for free. The Kingmaker's value is
(1) the Crossing, (2) the tools that keep allies up and enemies down longer than the cycle would
(Turn the Spoke, Cut, Usurp, Peripeteia, the Court, Tier III), (3) its own spells. Turn the Spoke used every
turn converts about one bad position-turn into a good one: ≈ +0.5A per turn.

## 2. The Crossing and Hubris — `FEAT_Kingmaker_Crossing`, `FEAT_Kingmaker_Hubris`

The Crossing is the subclass's main payoff; target ≈ 15 % of D per day (a main feature is ≈ 10 %; the
Kingmaker's own damage is low on purpose, so its core payoff sits a little higher).

| Tier | 15 % of D | Crossings per day (4 × per fight) | Per Crossing | Dice |
|---|---|---|---|---|
| T1 (3–4) | 20 | 9 | 2.2 | **1d4** |
| T2 (5–8) | 46 | 12 | 3.8 | **1d6** |
| T3 (9–12) | 76 | 16 | 4.8 | **1d8** |

No attack roll and no save (the fall is certain). **Damage type: Force** (proposed, §7) — the least resisted
type, so the core payoff never meets an immunity. **Hubris:** the amplified Crossing deals **one extra die**
(once per cycle per enemy: +≈ 2.5 % of D).

The Crossing feels small on its own on purpose: it lands together with the Fallen enemy's Advantage for the
whole party and the King's 19–20 crits — that round is the payoff.

## 3. Spells

| Spell | Proposed | Arithmetic | R |
|---|---|---|---|
| ***Spoke of the Wheel*** (cantrip) | **1d6** Bludgeoning (2d6 at 5, 3d6 at 10); **+1d4** against a Falling or Fallen enemy | Normal target T1: 0.65 × 3.5 = 2.3 (0.6A). Against a Fallen enemy (Advantage): 0.88 × 6 = 5.3 (1.3A). The Kingmaker will pick the Fallen target, so the average sits ≈ 1A. Below Fire Bolt on a normal target (specialist) | ≈ 1.0 |
| ***Dethrone*** (card 1) | **3d6** Bludgeoning, CHA save half, **+1d6 per slot level above 1**; binding always | Dissonant Whispers' dice (3d6, +1d6 per level), the binding in place of Frightened. L1: 10.5 × 0.775 = 8.1 + Falling 1.2 + a share of the Crossing it sets up 1.3 = 10.6 vs A + S(1) = 12 | 0.88 |
| ***Coronation*** (card 1) | No numbers. Cost: see §7 (Bonus Action) | Its value is the Reigning turn and the Crossing it enables | — |
| ***Turn the Spoke*** | No numbers. Cost: see §7 (no slot) | ≈ +0.5A per use, worth a Bonus Action | ≈ 1.0 |
| ***Atropos' Cut*** (card 2) | Enemy, Slashing, no save: **Fallen 3d8 · Falling 2d8 · Rising 1d8 · Reigning 1d8**, **+1d8 per slot level above 2**. Ally: no damage | L3 against a Fallen enemy: 13.5 + taking it off the Wheel before it reigns (≈ 1.6) = 15 vs A + S(2) = 16. Against a Reigning enemy the value is the removal, not the damage | 0.94 (best case) |
| ***Peripeteia*** (ultimate) | Cost: see §7 (card level 3 + once per combat) | Best case at T2 (two enemies Reigning flip to Fallen and cross, positions swing): ≈ 37; typical ≈ 25. With no slot it would be worth 100–148 points a day (33–49 % of D) — too much. With a slot: cost A + S(3) = 28 | 0.9–1.3 |
| ***Usurp*** (card 4, once per combat) | No numbers | Ally Fallen ↔ enemy Reigning: +2.3A + a Crossing with Hubris ≈ 25 vs A + S(4) = 32. Two limiters (slot + once per combat) keep it on the weak side, which suits an event card | 0.8 |
| ***Wheel of Ixion*** (card 5) | **5d6** Fire, line 18 × 2 m, CHA save half, **+1d6 at slot 6**; binding always (enemies); **burning surface 2 turns** (vanilla fire surface) | 2 targets × 17.5 × 0.825 = 28.9 + 2 bindings (≈ 7.7) + surface (≈ 3) = 39.6 vs A + S(5) = 39 (6d6 would give R 1.16) | 1.0 |
| ***The Wheel Stops*** (card 6, Long Rest, Unique) | **2 turns** (Kingmaker's turns) | Two Fallen enemies near a Reigning ally: 4 pressing Crossings (≈ 18 at 1d8) + positions held (0.8A + 0.3A per turn ≈ 48) + the next big round ≈ 89 vs a capstone ≈ 20 % of D = 100 | ≈ 0.9 |
| ***Rota Fortunae*** (Aspect card, free) | No numbers | One extra turn of the Wheel: ≈ 1.5 Crossings + a round in phase ≈ 1.3A per fight (≈ 15 % of D at T1, less later) | in range |
| ***Ready: Foreseen*** | No numbers | ≈ 0.3A per use, ≈ 2 uses per fight at T3: a minor feature | in range |

## 4. The Court — `FEAT_Kingmaker_Court`

Ranges: Lord Commander **3 m**, Master of Secrets **9 m**, Master of Ships **9 m**. Each office ≈ a minor
feature (≈ 5 % of D); with a CHA modifier of 3, the Court ≈ 15 % of D.

**Master of Coin.** As drafted (a Woven Spell Slot back the first time each turn the holder hits a Fallen
enemy) it would return ≈ 8 slots a day — ≈ 224 points at T3, **44 % of D**. Proposed: **once per Long Rest**
(one slot ≈ 28 points ≈ 5.5 % of D, a minor feature). See §7.

## 5. Aspect Awakening — `FEAT_Kingmaker_AspectAwakening`

Goals **3 / 5 / 8** Crossings (the Owner's figures, SP74):
- Tier I = 3 → turn 4–5 at level 3 (0.75 per round from turn 2; turn 4 if Turn the Spoke hastens a pair).
- Tier II = 5 → turn 4 at level 7 (≈ 1 per round, Tyche crosses on cast).
- Tier III = 8 → turn 4–5 at level 12 (≈ 1.3–2 per round).

**A lone enemy** reaches Fallen once per cycle (every 2 rounds with Turn the Spoke every turn): Tier I would
come on round 6. Proposed, like the Fool's rule: **while only one enemy is on the Wheel, each Crossing counts
2** → round 3–4. See §7.

## 6. Totals

Per turn at T2 the Kingmaker brings ≈ 1A from its action (cantrip or a card at R ≈ 1), ≈ 0.5A from Turn the
Spoke, ≈ 0.4A from Crossings and ≈ 0.3A from the Court — ≈ 2.2A against the budget's 2.4A per turn
(D / 16): **≈ 92 %**, inside the standard's 90–100 % band, with most of it felt on the allies' turns.

Rough figures for the other tiers: **T1 ≈ 88 %** (≈ 1A action + 0.5A Turn the Spoke + 0.3A Crossings against 2.06A; no Court before level 5 — weak early, on purpose); **T3 ≈ 83 %** before the tiers and the capstone, **≈ 95–100 %** with them (The Wheel Stops ≈ 0.57A per turn averaged over the day; Tier III keeps allies off Fallen, ≈ +0.2A per ally on the Wheel). To confirm in playtest.

## 7. Design changes the numbers ask for (Owner)

| # | Change | Why |
|---|---|---|
| 1 | ***Coronation* costs a Bonus Action** (was an Action) | Coronation and Dethrone were both Actions, so the turn-1 setup in spec §5 could not happen in one turn; Crossings would start on turn 3 (P5) |
| 2 | ***Turn the Spoke* costs no slot** (Bonus Action only; PC 1 Thread, the level-0 card rule) | ≈ 0.5A per use cannot pay for a slot; with one it would almost never be played |
| 3 | ***Peripeteia* is a level-3 card (slot or 3 Threads) and once per combat** | With no slot it is worth 33–49 % of D a day |
| 4 | ***Master of Coin* once per Long Rest** | 44 % of D as drafted |
| 5 | **Crossing damage type: Force** | Least resisted; the core payoff should not meet immunities |
| 6 | **A lone enemy: each Crossing counts 2 for the Awakening** | Tier I on round 6 against a boss otherwise |

## 8. How to check (playtest)

| Number | Fight | Metric | Wrong if |
|---|---|---|---|
| Crossing 1d4/1d6/1d8 | Normal fight, level 3 / 5 / 9 | Crossings per fight; share of the party's damage | Fewer than 2 Crossings a fight, or the Crossing above 25 % of the party's damage |
| Positions | Any | Does the party feel the Fallen / King round? | The players stop putting allies on the Wheel (the fall costs more than it gives) |
| Dethrone, Cut, Ixion | Normal fight | Chosen over the cantrip about half of the turns with a slot | Never cast, or cast every turn |
| Peripeteia | Fight where the Wheel turned against the party | Swing in the round it is cast | It decides every fight on its own |
| The Wheel Stops | Boss fight, level 11 | Damage in its 2 turns | More than a quarter of the boss's HP alone |
| Awakening | Normal fight level 3; lone boss level 5 | Turn of Tier I | Later than turn 5 (normal) or 4 (boss, with the rule) |
| Master of Coin | A day of 4 fights | Slots regained | More than one |
