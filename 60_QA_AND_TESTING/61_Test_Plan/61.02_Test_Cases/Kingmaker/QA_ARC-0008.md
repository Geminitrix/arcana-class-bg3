---
id: QA_ARC-0008
title: Playtest — The Kingmaker — new subclass (levels 1–12)
type: playtest
subclass: kingmaker
build: ARC-0008
status: in_qa
owner: QA Lead
sources: [QA-0002, GUIDE_ARC-0008, TC_ARC-0008]
created: 2026-10-16
---

# QA_ARC-0008 · The Kingmaker — new subclass (levels 1–12)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0008 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from QA-0002, GUIDE_ARC-0008, TC_ARC-0008.

## Before you start

- Compile the Story in the Toolkit and check log.txt: 0 error(s), 0 warning(s).
- Use a new Kingmaker built through the real progression, in a party of four.
- Console edition. The PC deck is not built yet (SPEC stage 7).
- Known, not a test: the subclass icon in character creation is still the Spinner one (SPEC stage 7).

## Level 1 — The Wheel: Coronation, Dethrone, Turn the Spoke, the cantrip

**Setup:** A Kingmaker at level 1, in a party of four, a normal fight.

### L1.1 · Coronation on an ally

- **Rule:** P1 · SPEC_ARC-0008
- **Steps:** Coronation on an ally
- **Expected:** It shows Rising (+3 m, can't be Prone)
- **Fails if:** It does not happen as expected.
- **Result:** —

### L1.2 · Dethrone on an enemy, then a save success on another

- **Rule:** P2 · SPEC_ARC-0008
- **Steps:** Dethrone on an enemy, then a save success on another
- **Expected:** Damage (half on the save) and Falling on both
- **Fails if:** It does not happen as expected.
- **Result:** —

### L1.3 · Spoke of the Wheel on a Fallen enemy vs a normal one

- **Rule:** P8 · SPEC_ARC-0008
- **Steps:** Spoke of the Wheel on a Fallen enemy vs a normal one
- **Expected:** The extra 1d4 shows only on the Falling / Fallen target
- **Fails if:** It does not happen as expected.
- **Result:** —

### L1.4 · End the turn; at your next turn start

- **Rule:** P3 · SPEC_ARC-0008
- **Steps:** End the turn; at your next turn start
- **Expected:** Ally → Reigning and King; enemy → Fallen; the change shows before you act, with you as the source (tooltip)
- **Fails if:** It does not happen as expected.
- **Result:** —

### L1.5 · Turn the Spoke on the Falling enemy

- **Rule:** P5 · SPEC_ARC-0008
- **Steps:** Turn the Spoke on the Falling enemy
- **Expected:** It drops to Fallen at once; no slot spent
- **Fails if:** It does not happen as expected.
- **Result:** —

### L1.6 · Be downed with creatures on the Wheel

- **Rule:** P6 · SPEC_ARC-0008
- **Steps:** Be downed with creatures on the Wheel
- **Expected:** The Wheel still turns at your turn start (SP90); plan B: Osiris drives the turn from the next creature's `TurnStarted`
- **Fails if:** It does not happen as expected.
- **Result:** —

### L1.7 · Kill a creature on the Wheel; end combat

- **Rule:** P7 · SPEC_ARC-0008
- **Steps:** Kill a creature on the Wheel; end combat
- **Expected:** The dead one leaves the Wheel; at combat end every position status is gone
- **Fails if:** It does not happen as expected.
- **Result:** —

### L1.8 · Crown two allies on different turns

- **Rule:** P4 · SPEC_ARC-0008
- **Steps:** Crown two allies on different turns
- **Expected:** When both Reign, the older one is King, the other Regent
- **Fails if:** It does not happen as expected.
- **Result:** —

## Level 3 — The Crossing, Awakening Tier I Tyche, Atropos' Cut

**Setup:** A Kingmaker at level 3, in a party of four, a normal fight.

### L3.1 · Level 3: Coronation on an ally, Dethrone on an enemy within 9 m of ...

- **Rule:** P9 · SPEC_ARC-0008
- **Steps:** Level 3: Coronation on an ally, Dethrone on an enemy within 9 m of it; end the turn
- **Expected:** At your turn start the ally Reigns and the enemy, Fallen, shows The Crossing and takes 1d4 Force from you (combat log) | No damage: `Cause.` not resolved from Osiris → three statuses with fixed dice, chosen by `GetLevel`
- **Fails if:** It does not happen as expected.
- **Result:** —

### L3.2 · Same, with the enemy more than 9 m from the ally

- **Rule:** P10 · SPEC_ARC-0008
- **Steps:** Same, with the enemy more than 9 m from the ally
- **Expected:** Fallen, no Crossing | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L3.3 · Two Reigning allies next to one enemy entering Fallen; then Turn th...

- **Rule:** P11 · SPEC_ARC-0008
- **Steps:** Two Reigning allies next to one enemy entering Fallen; then Turn the Spoke it round to Fallen again in the same round
- **Expected:** One Crossing only, both times | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L3.4 · Fight with one enemy on the Wheel, then two

- **Rule:** P12 · SPEC_ARC-0008
- **Steps:** Fight with one enemy on the Wheel, then two
- **Expected:** The Awakening counts 2 per Crossing with one enemy, 1 with two; 3 Crossings awaken Tyche (status, card *Rota Fortunae* in the hotbar) | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L3.5 · With Tyche: Coronation, then Dethrone next to the Reigning ally

- **Rule:** P13 · SPEC_ARC-0008
- **Steps:** With Tyche: Coronation, then Dethrone next to the Reigning ally
- **Expected:** The ally enters Reigning (King at once); the enemy enters Fallen and crosses at once | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L3.6 · Rota Fortunae

- **Rule:** P14 · SPEC_ARC-0008
- **Steps:** Rota Fortunae
- **Expected:** Every creature on the Wheel moves one step; a Falling enemy near a Reigning ally crosses; it can't be cast again this combat | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L3.7 · Atropos' Cut on a Fallen, a Falling and a Rising enemy (one each)

- **Rule:** P15 · SPEC_ARC-0008
- **Steps:** Atropos' Cut on a Fallen, a Falling and a Rising enemy (one each)
- **Expected:** 3d8 / 2d8 / 1d8 Slashing; the enemy loses its position status and the Wheel ignores it | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L3.8 · Atropos' Cut on the Reigning King; then cast Dethrone and Atropos' ...

- **Rule:** P16 · SPEC_ARC-0008
- **Steps:** Atropos' Cut on the Reigning King; then cast Dethrone and Atropos' Cut with a higher slot
- **Expected:** The ally leaves the Wheel, keeps *Reigning* until the end of its next turn, loses the crown; Dethrone at slot 2 shows 4d6, the Cut at slot 3 shows 4d8 / 3d8 / 2d8 | —
- **Fails if:** It does not happen as expected.
- **Result:** —

## Level 5 — Peripeteia, the Court

**Setup:** A Kingmaker at level 5 with CHA 15, in a party of four, a normal fight.

### L5.1 · Appoint the King's Hand; start a fight with nobody on the Wheel

- **Rule:** P18 · SPEC_ARC-0008
- **Steps:** Appoint the King's Hand; start a fight with nobody on the Wheel
- **Expected:** At your turn start the Hand wears King and crits on 19–20; when an ally reigns, the crown moves to it | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L5.2 · Level 5, CHA 15 (+2): Convene the Court twice out of combat, then t...

- **Rule:** P17 · SPEC_ARC-0008
- **Steps:** Level 5, CHA 15 (+2): Convene the Court twice out of combat, then try a third
- **Expected:** Two offices land; the third option can't be cast (`COURT_FULL`); in combat the container can't be cast | `GetAbility` key not `"Charisma"` → read the modifier from a boost-free stat
- **Fails if:** It does not happen as expected.
- **Result:** —

### L5.3 · Appoint the Lord Commander next to the King

- **Rule:** P19 · SPEC_ARC-0008
- **Steps:** Appoint the Lord Commander next to the King
- **Expected:** Attacks against the King show Disadvantage while the King is within 3 m of the Commander | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L5.4 · Master of Healing heals a Fallen ally, then a Falling one

- **Rule:** P20 · SPEC_ARC-0008
- **Steps:** Master of Healing heals a Fallen ally, then a Falling one
- **Expected:** Fallen → Rising at once; the Falling ally doesn't move | `OnHeal` doesn't fire from potions/items → note it
- **Fails if:** It does not happen as expected.
- **Result:** —

### L5.5 · Long Rest

- **Rule:** P21 · SPEC_ARC-0008
- **Steps:** Long Rest
- **Expected:** Every office and `COURT_FULL` are gone; the options can be cast again | Statuses survive the rest → Osiris removes them at `LongRestFinished` (already written)
- **Fails if:** It does not happen as expected.
- **Result:** —

### L5.6 · A holder dies

- **Rule:** P22 · SPEC_ARC-0008
- **Steps:** A holder dies
- **Expected:** Its office ends; the seat isn't given back until the Long Rest | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L5.7 · Level 5 character: open Convene the Court

- **Rule:** P32 · SPEC_ARC-0008
- **Steps:** Level 5 character: open Convene the Court
- **Expected:** Master of Laws and Master of Secrets are shown but can't be cast before level 7 | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L5.8 · Peripeteia with allies and enemies on the Wheel, some beyond 18 m

- **Rule:** P23 · SPEC_ARC-0008
- **Steps:** Peripeteia with allies and enemies on the Wheel, some beyond 18 m
- **Expected:** Within 18 m: Reigning ↔ Fallen, Rising ↔ Falling; an enemy turned Fallen next to a Reigning ally crosses at once; beyond 18 m nothing moves | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L5.9 · Cast Peripeteia again in the same fight, with a higher slot

- **Rule:** P24 · SPEC_ARC-0008
- **Steps:** Cast Peripeteia again in the same fight, with a higher slot
- **Expected:** It can't (once per combat, variants included) | Variants don't share the cooldown → a `PERIPETEIA_USED` status like `ARCANE_MASTERY_USED`
- **Fails if:** It does not happen as expected.
- **Result:** —

## Level 7 — Hubris, Usurp, Tier II Nemesis, two offices

**Setup:** A Kingmaker at level 7, in a party of four, a normal fight.

### L7.1 · With Nemesis (5 Crossings): a Hubris enemy crosses with a Falling e...

- **Rule:** P26 · SPEC_ARC-0008
- **Steps:** With Nemesis (5 Crossings): a Hubris enemy crosses with a Falling enemy within 3 m
- **Expected:** The Falling one drops to Fallen and crosses too if an ally Reigns near; nothing loops | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L7.2 · Master of Laws held; a Rising enemy attacks the King

- **Rule:** P29 · SPEC_ARC-0008
- **Steps:** Master of Laws held; a Rising enemy attacks the King
- **Expected:** At the next turn it skips Reigning and lands on Falling (no Hubris) | `AttackedBy` doesn't fire on misses → note it
- **Fails if:** It does not happen as expected.
- **Result:** —

### L7.3 · Same with a Reigning enemy; with a Falling one

- **Rule:** P30 · SPEC_ARC-0008
- **Steps:** Same with a Reigning enemy; with a Falling one
- **Expected:** Reigning → Fallen (and may cross); Falling → Fallen only | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L7.4 · Master of Secrets; an enemy on the Wheel within 9 m tries to hide o...

- **Rule:** P31 · SPEC_ARC-0008
- **Steps:** Master of Secrets; an enemy on the Wheel within 9 m tries to hide or turn invisible
- **Expected:** It can't; an invisible one becomes visible; the holder's attacks against a Falling enemy have Advantage | `SNEAKING` immunity doesn't stop hiding → look for the vanilla anti-hide status
- **Fails if:** It does not happen as expected.
- **Result:** —

### L7.5 · Level 7 character: open Convene the Court

- **Rule:** P39 · SPEC_ARC-0008
- **Steps:** Level 7 character: open Convene the Court
- **Expected:** Coin and Ships are shown but locked; at 9 they open | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L7.6 · Level 7: let an enemy reach Reigning; next turn it falls to Fallen ...

- **Rule:** P25 · SPEC_ARC-0008
- **Steps:** Level 7: let an enemy reach Reigning; next turn it falls to Fallen next to a Reigning ally
- **Expected:** It shows Hubris while Reigning; its Crossing deals two dice and Hubris goes | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L7.7 · Usurp on a Reigning ally and a Fallen enemy; then on a Fallen ally ...

- **Rule:** P27 · SPEC_ARC-0008
- **Steps:** Usurp on a Reigning ally and a Fallen enemy; then on a Fallen ally and a Reigning enemy with Hubris
- **Expected:** First: the ally becomes Fallen and the enemy Reigning (it gains Hubris). Second: the enemy drops to Fallen and crosses at once if an ally Reigns near, with its Hubris die | Two targets not offered → one target that trades with the King
- **Fails if:** It does not happen as expected.
- **Result:** —

### L7.8 · Usurp on two allies

- **Rule:** P28 · SPEC_ARC-0008
- **Steps:** Usurp on two allies
- **Expected:** Nothing moves; the card is spent (once per combat) | —
- **Fails if:** It does not happen as expected.
- **Result:** —

## Level 9 — Succession, Wheel of Ixion, two offices

**Setup:** A Kingmaker at level 9 with CHA 20 (for the seven offices), in a party of four, a normal fight.

### L9.1 · Master of Ships 5 m from an enemy entering Fallen, no Reigning ally...

- **Rule:** P38 · SPEC_ARC-0008
- **Steps:** Master of Ships 5 m from an enemy entering Fallen, no Reigning ally near
- **Expected:** The enemy crosses | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L9.2 · Master of Coin hits a Fallen enemy, then another

- **Rule:** P37 · SPEC_ARC-0008
- **Steps:** Master of Coin hits a Fallen enemy, then another
- **Expected:** One spell slot (of your slot level) comes back the first time only; after a Long Rest it works again | `RestoreResource` without `SELF` doesn't reach the Kingmaker → `SELF`
- **Fails if:** It does not happen as expected.
- **Result:** —

### L9.3 · Seven offices with CHA 20 (+5)

- **Rule:** P40 · SPEC_ARC-0008
- **Steps:** Seven offices with CHA 20 (+5)
- **Expected:** Five appointed, then the rest are locked (`COURT_FULL`) | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L9.4 · Level 9: kill a Falling enemy with another enemy off the Wheel 5 m ...

- **Rule:** P33 · SPEC_ARC-0008
- **Steps:** Level 9: kill a Falling enemy with another enemy off the Wheel 5 m from it and a third 8 m away
- **Expected:** The 5 m one becomes Falling (Succession); the third doesn't | Roster empty (enemies not in `DB_ARCANA_Aspect_InCombat`) → collect candidates from `EnteredCombat` in this goal
- **Fails if:** It does not happen as expected.
- **Result:** —

### L9.5 · Kill a Reigning enemy with an heir in range

- **Rule:** P34 · SPEC_ARC-0008
- **Steps:** Kill a Reigning enemy with an heir in range
- **Expected:** The heir enters Reigning with Hubris | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L9.6 · Wheel of Ixion through two enemies and an ally

- **Rule:** P35 · SPEC_ARC-0008
- **Steps:** Wheel of Ixion through two enemies and an ally
- **Expected:** Enemies take 5d6 (half on a CHA save) and enter Falling; the ally takes no damage from the wheel; the line burns for 2 turns and the ally standing in it burns | The Kingmaker's own square catches fire → `FrontOffset 0`
- **Fails if:** It does not happen as expected.
- **Result:** —

## Level 11 — The Wheel Stops

**Setup:** A Kingmaker at level 11, in a party of four, a normal fight.

### L11.1 · Ixion with a level-6 slot

- **Rule:** P36 · SPEC_ARC-0008
- **Steps:** Ixion with a level-6 slot
- **Expected:** 6d6 | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L11.2 · Level 11: The Wheel Stops with an ally Reigning and an enemy Fallen...

- **Rule:** P41 · SPEC_ARC-0008
- **Steps:** Level 11: The Wheel Stops with an ally Reigning and an enemy Fallen 5 m away
- **Expected:** For your next 2 turn starts nothing moves and the enemy crosses each time (not twice in a round); at the third the Wheel turns again and the marks go | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L11.3 · During the stop: Turn the Spoke, Rota Fortunae, Dethrone a new enemy

- **Rule:** P42 · SPEC_ARC-0008
- **Steps:** During the stop: Turn the Spoke, Rota Fortunae, Dethrone a new enemy
- **Expected:** They still move / bind; the new enemy is marked stopped | —
- **Fails if:** It does not happen as expected.
- **Result:** —

## Level 12 — Fortune's Reach, Tier III, Ready: Foreseen

**Setup:** A Kingmaker at level 12, in a party of four, a normal fight.

### L12.1 · Level 12: an enemy enters Fallen 20 m from the only Reigning ally

- **Rule:** P43 · SPEC_ARC-0008
- **Steps:** Level 12: an enemy enters Fallen 20 m from the only Reigning ally
- **Expected:** It crosses (Fortune's Reach) | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L12.2 · Tier III (8 Crossings): follow an ally around the Wheel; Peripeteia...

- **Rule:** P44 · SPEC_ARC-0008
- **Steps:** Tier III (8 Crossings): follow an ally around the Wheel; Peripeteia an ally from Reigning
- **Expected:** Rising → Reigning → Falling → Falling → Rising, never Fallen; Peripeteia leaves it Falling | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L12.3 · Tier III: cast Ready: Foreseen

- **Rule:** P45 · SPEC_ARC-0008
- **Steps:** Tier III: cast Ready: Foreseen
- **Expected:** It costs a Bonus Action, can't be cast twice in the fight, and *Foreseen* shows as a reaction | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### L12.4 · A Reigning enemy on the Wheel attacks an ally; take Foreseen

- **Rule:** P46 · SPEC_ARC-0008
- **Steps:** A Reigning enemy on the Wheel attacks an ally; take Foreseen
- **Expected:** Before the roll it becomes Falling (no 19–20 crit, −1d4); a Falling attacker becomes Fallen and may cross | The step lands after the roll → swap the position statuses in the interrupt's own Properties
- **Fails if:** It does not happen as expected.
- **Result:** —

### L12.5 · A Rising or Fallen enemy attacks

- **Rule:** P47 · SPEC_ARC-0008
- **Steps:** A Rising or Fallen enemy attacks
- **Expected:** Foreseen isn't offered | `IsAttack()` false in `OnSpellCast` → drop it and keep the target condition
- **Fails if:** It does not happen as expected.
- **Result:** —

## Any level — full run

**Setup:** Any level: a party with two Kingmakers; and a new Kingmaker levelled from 1 to 12.

### A.1 · Two Kingmakers in the party

- **Rule:** P48 · SPEC_ARC-0008
- **Steps:** Two Kingmakers in the party
- **Expected:** Each crowns and turns their own Wheel; one creature can't be on both | —
- **Fails if:** It does not happen as expected.
- **Result:** —

### A.2 · A new Kingmaker gets exactly the 21.03 table

- **Rule:** PR1 · 21.03
- **Steps:** Level a new Kingmaker from 1 to 12 and compare each level with 21.03/Kingmaker.md.
- **Expected:** Every level grants exactly what the table lists.
- **Fails if:** Anything missing or extra.
- **Result:** —

## Appendix — TC_ARC-0008 (design-stage draft, verbatim)

Header of the original file:

```
id: 61.02/Kingmaker/TC_ARC-0008
owner: QA Lead
source: SPEC_ARC-0008.md (probes P1–P48, stages 1–6) · 21.04/Kingmaker/DESIGN.md · 21.03/Kingmaker.md · 22.05/Kingmaker.md §"What would prove it wrong"
reviewed: 2026-10-15 ARC-0008 — created (propagation, 00.08)
```

> **Superseded by `GUIDE_ARC-0008.json (QA-0002)`** (OR-4, 2026-10-17): the in-game tests live in the guide; this file is kept as the design-stage record.

### TC_ARC-0008 · The Kingmaker — acceptance and regression suite

- **Decision it informs:** keep the Kingmaker as built (levels 1–12), or send a failing rule back to the Lead Class
  Designer / Mod Engineer. Re-run as regression after any change to the Wheel (goal `ARCANA_Kingmaker_Wheel`, statuses,
  cards).
- **Scenario:** console edition, a Kingmaker built through the real progression at levels 1, 3, 5, 7, 9, 11, 12, in a
  party of four; compile the Story after any apply. The PC deck is SPEC stage 7 (not built yet).
- **The Owner plays every probe at the end of the subclass** (Owner's choice, 2026-10-15): none has been played yet.
  The full step and fallback of each probe are in `SPEC_ARC-0008.md`; this file keeps one line per rule.

#### Static (no game session) — last run 2026-10-15 by Claude

| # | Step | Expected | Result |
|---|---|---|---|
| S1 | `bash 80_TOOLS_AND_PIPELINE/82_Automation/sync_data.sh` | 51 matches the game | ✅ 318 files, 0 changed |
| S2 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/check_cards.pl` | `OK -- nenhum problema` | ✅ 113 roots |
| S3 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/validate.pl` | 0 errors | ✅ 0 errors, 4 warnings |
| S4 | no line over 4000 characters in the mod's Stats `.txt` / `.stats` | none | ✅ 0 |
| S5 | `dump_progression.pl`, Kingmaker rows, vs `21.03/Kingmaker.md` | identical | ✅ levels 1, 3, 5, 7, 9, 11, 12 match |
| S6 | Story `log.txt` after compiling | `0 error(s), 0 warning(s)` | Owner, at the next compile |
| S7 | Subclass icon in character creation | the Kingmaker icon shows | ❌ expected to fail: the files are `Spinner.DDS`, the `Name` is `Kingmaker` — SPEC stage 7 (`42.04/Kingmaker.md`) |

#### In game — one assertion per rule (Owner; all pending)

| Rule | Probes | Expected | Result |
|---|---|---|---|
| Binding | P1, P2, P8 | Coronation → Rising; Dethrone → Falling whatever the save, half damage on a save; the cantrip's extra die only on Falling / Fallen | pending |
| The Wheel turns | P3, P5, P6, P7 | At the Kingmaker's turn start every position moves on, shown before acting; Turn the Spoke moves one at once, no slot; turns while the Kingmaker is downed; death and combat end clear it | pending |
| The crown | P4, P18 | The longest-Reigning ally is King, others Regent; the King's Hand wears it while no ally reigns | pending |
| The Crossing | P9, P10, P11, P38, P43 | 1d4 Force within 9 m of a Reigning ally, never beyond; once per enemy per round; Master of Ships carries it; Fortune's Reach at any range | pending |
| Awakening | P12, P13, P14, P26, P44 | Goals 3 / 5 / 8, a lone enemy counts 2; Tyche enters one ahead; Rota Fortunae once per combat; Nemesis drops Falling neighbours; Tier III allies never Fallen | pending |
| Atropos' Cut | P15, P16 | 3d8 / 2d8 / 1d8 by position, off the Wheel; a Reigning ally keeps Reigning one turn; upcasts add dice | pending |
| The Court | P17, P19, P20, P21, P22, P29, P30, P31, P32, P37, P39, P40 | Offices up to CHA, locked by level, gone at Long Rest, empty seat on death; each office's rule as in the SPEC; Master of Coin once per Long Rest | pending |
| Peripeteia | P23, P24 | Within 18 m every position flips and Crossings pay; once per combat, upcasts included | pending |
| Hubris and Usurp | P25, P27, P28 | A Reigning enemy gains Hubris, its Crossing deals two dice; Usurp swaps one ally and one enemy, two allies do nothing | pending |
| Succession | P33, P34 | The nearest enemy off the Wheel within 9 m inherits the position; a Reigning heir gains Hubris | pending |
| Wheel of Ixion | P35, P36 | 5d6 (6d6 at slot 6), Falling whatever the save, allies take no wheel damage, the fire surface burns them | pending |
| The Wheel Stops | P41, P42 | Two turn starts without turning, Crossings each time; the Kingmaker's cards still move creatures (SP112) | pending |
| Ready: Foreseen | P45, P46, P47 | Bonus Action, once per combat (SP114); Reigning → Falling and Falling → Fallen before the roll; not offered on Rising / Fallen | pending |
| Two Kingmakers | P48 | Separate Wheels; a creature on one only (SP113) | pending |
| Progression | — | A new Kingmaker 1 → 12 gets exactly the `21.03` table | pending |

#### Balance watch (playtest, `22.05/Kingmaker.md`)
At least 2 Crossings a fight and under 25 % of the party's damage · Tier I by turn 5 (normal) / turn 4 (lone boss) ·
The Wheel Stops under a quarter of a boss's HP alone · Master of Coin one slot a day.

#### Next
The Owner plays P1–P48 in one session; failures become bugs in `62` (bug vs design feedback separated).

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources QA-0002, GUIDE_ARC-0008, TC_ARC-0008 merged; nothing removed.
