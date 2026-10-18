---
id: QA_ARC-0017
title: Playtest — The Heartsong — refining R49–R68 (levels 1–12)
type: playtest
subclass: resonant
build: ARC-0017
status: in_qa
owner: QA Lead
sources: [QA-0001, GUIDE_ARC-0017, TC_ARC-0014]
created: 2026-10-16
---

# QA_ARC-0017 · The Heartsong — refining R49–R68 (levels 1–12)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0017 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from QA-0001, GUIDE_ARC-0017, TC_ARC-0014.

## Before you start

- Compile the Story in the Toolkit once: the Overload, Temperance and Shared Heart goals changed during the build.
- Use a NEW Resonant. A character from an older save already learned the eight emotions as separate spells.
- Console edition unless a test says PC. Read results in the combat log and on the status tooltips.
- Some texts of growing dice still say 1d4 (text pass ARC-0006): judge the dice by the combat log, not the tooltip.
- Not tested here: Releases per day (V7) and feelings at release on a boss (V6) are balance metrics: they run in ARC-0010.

## Level 1 — Weave Surge, Heartstring, Emotional Overload

**Setup:** A new Resonant at level 1, one ally, a normal fight against two or three enemies. Tests marked PC: the PC edition with the deck on.

### L1.1 · Weave Surge opens with the emotions you know

- **Rule:** B6a · R54
- **Steps:** Open the Weave Surge button on the hotbar.
- **Expected:** One button. Joy, Trust and Fear can be cast; the other five are greyed out or missing.
- **Fails if:** Eight separate buttons, all eight castable, or the container opens empty.
- **Plan B:** Grant each emotion in the level lists again and keep the container for the hotbar only.
- **Result:** —

### L1.2 · Emotional Overload is free

- **Rule:** B3a · R66
- **Steps:** Cast Surges until the Overload meter reaches 100%. Open Emotional Overload.
- **Expected:** Castable as a Bonus Action while Overloaded, with no spell slot spent. Only one version of it shows.
- **Fails if:** It asks for a slot, cannot be cast while Overloaded, or several level versions show.
- **Result:** —

### L1.3 · Overloaded is a trade, not a silence

- **Rule:** R51a · R51
- **Steps:** With the meter full, check the Overloaded status, then cast spells and wait for your next turn.
- **Expected:** You can still cast spells. 1d4 Psychic at the start of your turn. -1 to Intelligence, Wisdom and Charisma saves.
- **Fails if:** You are silenced, take no damage, or the save penalty is missing.
- **Result:** —

### L1.4 · The Surge rider, once per turn

- **Rule:** R51b · R51
- **Steps:** While Overloaded, land a Surge on an enemy (it fails its save), then land a second Surge the same turn.
- **Expected:** The first deals an extra 1d4 Psychic; the second deals none. The next turn it works again.
- **Fails if:** No extra damage, or extra damage on both Surges.
- **Result:** —

### L1.5 · Emotional Overload, rank I

- **Rule:** R51c · R51 R68
- **Steps:** Braid a feeling on an enemy, then release Emotional Overload on it. Repeat on an enemy that makes the save.
- **Expected:** Failed save: Psychic damage per feeling, the enemy dances for 1 turn, Mental Fatigue shows. Made save: half damage, no dance, Mental Fatigue shows. Either way the feelings are gone, Overloaded ends and the meter empties.
- **Fails if:** Paralysis, no Mental Fatigue, or the meter stays full.
- **Result:** —

### L1.6 · Charm-immune creatures don't dance

- **Rule:** V13 · R68
- **Steps:** Release Emotional Overload on an enemy immune to Charmed that fails the save.
- **Expected:** No dance. The feelings' damage and Mental Fatigue still land.
- **Fails if:** It dances.
- **Result:** —

### L1.7 · When a fight ends, the meter settles to half

- **Rule:** R53 · R53
- **Steps:** End one fight with the meter partly full (note the %). End another fight while Overloaded.
- **Expected:** After the first: about half the %. After the second: Overloaded is gone and the meter shows about 50%.
- **Fails if:** The meter keeps its value, empties, or Overloaded keeps going after the fight.
- **Result:** —

### L1.8 · Heartstring reads feelings

- **Rule:** R61 · R61
- **Steps:** Cast Heartstring on an enemy carrying one or two feelings.
- **Expected:** The cantrip damage plus 1d4 Psychic per feeling (combat log). The target's mood does not get longer.
- **Fails if:** No extra damage per feeling.
- **Result:** —

### L1.9 · Moods say what they react with

- **Rule:** R64 · R64
- **Steps:** Hover a mood on any creature (for example Serene).
- **Expected:** The tooltip lists what each emotion would make of it, with the level that unlocks it.
- **Fails if:** No list.
- **Result:** —

### L1.10 · Weave Surge in the deck

- **Rule:** V9 · R55
- **Steps:** Check the deck list (!arcanapool). Play a few fights.
- **Expected:** One Weave Surge card with 24 copies at level 5 (9 at level 1); no separate emotion cards; it is often in hand.
- **Fails if:** Eight emotion cards, 3 copies, or rarely in hand.
- **Edition:** PC
- **Result:** —

### L1.11 · Emotional Overload costs no Threads

- **Rule:** B4 · R66
- **Steps:** While Overloaded in combat, look at Emotional Overload's cost and cast it.
- **Expected:** 0 Threads.
- **Fails if:** It costs Threads.
- **Plan B:** Exclude it from the ARCANA_WEAVING check.
- **Edition:** PC
- **Result:** —

## Level 2 — Temper

**Setup:** The same Resonant at level 2.

### L2.1 · Temper and Anticipation at level 2

- **Rule:** L2a · R59
- **Steps:** Level up to 2.
- **Expected:** Temper is granted, and Anticipation opens inside Weave Surge.
- **Fails if:** Either arrives at level 3.
- **Result:** —

## Level 3 — Opposites, Tier I Resonance

**Setup:** The Resonant at level 3, one ally, fights long enough to wake Tier I.

### L3.1 · Nothing-to-do turns (levels 1-3)

- **Rule:** V4 · R51
- **Steps:** Over your fights at levels 1 to 3, count turns where the Resonant had nothing useful to do.
- **Expected:** None.
- **Fails if:** One or more per fight.
- **Kind:** observe
- **Result:** —

### L3.2 · Opposites and Tier I at level 3

- **Rule:** L3a · R60 R63
- **Steps:** Level up to 3. Pour Joy into a Pensive enemy. Wake Tier I in a fight and let a peak fade.
- **Expected:** The Opposites passive shows and Catharsis happens. With Tier I awake, Catharsis gets +1d8 and moods still last 5 turns (not 7).
- **Fails if:** No Opposites passive, or moods last 7 turns with Tier I.
- **Result:** —

## Level 5 — Deeper Feelings

**Setup:** The Resonant at level 5, a fight with several enemies and one ally.

### L5.1 · Temper's replay leaves no mood

- **Rule:** B1 · R49
- **Steps:** Land Disgust on an enemy and let it fade into Bored. Cast Temper on it (it fails the save). Wait until the replayed Disgust ends. Later, land a normal Disgust again and let it fade.
- **Expected:** After the Temper replay: no Bored. After the normal Disgust: Bored appears.
- **Fails if:** Bored comes back after the replay, or a normal Disgust stops leaving Bored.
- **Plan B:** The replay marker clears at the start of the Resonant's next turn instead.
- **Result:** —

### L5.2 · No Temper lock

- **Rule:** V2 · R49
- **Steps:** Right after B1, try to Temper the same enemy again on your next turn.
- **Expected:** Not possible: it has no mood until a new Disgust lands.
- **Fails if:** Temper locks it again with no new Surge.
- **Result:** —

### L5.3 · Emotional Overload, rank II

- **Rule:** R51d · R51 R66
- **Steps:** At level 5, fill the meter and release Emotional Overload.
- **Expected:** It takes two enemies.
- **Fails if:** Still one target.
- **Result:** —

### L5.4 · Overloaded grows at 5

- **Rule:** R52 · R52 R67
- **Steps:** At level 5, get Overloaded.
- **Expected:** 2d4 Psychic per turn and -2 to Intelligence, Wisdom and Charisma saves; the rider deals 2d4.
- **Fails if:** Still 1d4 or -1.
- **Result:** —

### L5.5 · Deeper Feelings at 5

- **Rule:** R62a · R62
- **Steps:** Level up to 5. Land Fear on an enemy and let it fade into Apprehensive; have it make a Wisdom save.
- **Expected:** The Deeper Feelings passive shows. Apprehensive subtracts 1d6 (combat log).
- **Fails if:** No passive, or still 1d4.
- **Result:** —

### L5.6 · Does the dance's save discharge Mental Fatigue?

- **Rule:** B2 · R68
- **Steps:** At level 5+, release Emotional Overload on an enemy that fails: it dances and has Mental Fatigue (5+ turns). At its turn start it rolls a Wisdom save to stop dancing.
- **Expected:** Record what happens: if it fails that save, does it take 1d4 Psychic ('Psychic Discharge') and lose Mental Fatigue?
- **Fails if:** Nothing fails here: write down what you saw. The Owner decides.
- **Kind:** observe
- **Result:** —

## Level 6 — Complex Feelings

**Setup:** The Resonant at level 6, one lower-level ally, a normal fight.

### L6.1 · Complex Feelings at 6, not 5

- **Rule:** L6a · R59
- **Steps:** At level 5, pour Joy into an Apprehensive enemy. Level up to 6 and repeat.
- **Expected:** Level 5: a plain Joy peak. Level 6: Guilt.
- **Fails if:** Guilt at level 5.
- **Result:** —

### L6.2 · Growing dice read the Resonant's level

- **Rule:** B7 · R62
- **Steps:** At level 6, braid Hope on a lower-level ally and watch its next attack roll.
- **Expected:** Hope adds 1d6.
- **Fails if:** It adds 1d4 (the map reads the ally's level).
- **Plan B:** One status version per level band, chosen in the Surge.
- **Result:** —

## Level 7 — Overwhelm, Tier II Harmony

**Setup:** The Resonant at level 7 with Tier II reachable (6 reactions), one ally, a fight long enough to wake it.

### L7.1 · Excess once per fight

- **Rule:** V1 · R49 R50
- **Steps:** Joy on an ally, let it fade into Serene, Joy again: Ecstasy. Give it Serene again (a new Joy that fades) and pour Joy a third time. Do the same with Surprise on an enemy (Amazement).
- **Expected:** The second Ecstasy / Amazement on the same creature lands as a plain peak. When Ecstasy ends it leaves no mood.
- **Fails if:** The same creature gets Ecstasy or Amazement twice in one fight.
- **Result:** —

### L7.2 · Tier II's free Surge through the container

- **Rule:** B6b · R40 R54
- **Steps:** Wake Tier II. On your turn, cast an emotion through the Weave Surge container, then another one.
- **Expected:** The first costs no action and its mood shows at once; the second costs your action and can react with it.
- **Fails if:** The first Surge through the container costs an action.
- **Result:** —

### L7.3 · Ride or release (levels 3 and 7)

- **Rule:** V5 · R51
- **Steps:** Over a few fights, note whether you held Overloaded for a turn or two or released it at once.
- **Expected:** Sometimes held, sometimes released.
- **Fails if:** Always released at once, or never released.
- **Kind:** observe
- **Result:** —

## Level 9 — Deeper Feelings, Emotional Contagion, Mixed Feelings

**Setup:** The Resonant at level 9, a fight with a group of enemies close together and two allies.

### L9.1 · Emotional Overload, rank III (the area)

- **Rule:** B5 · R51 R67
- **Steps:** At level 9, release Emotional Overload on an enemy in a group.
- **Expected:** Every enemy within 9 m of the point rolls the save and takes its effect.
- **Fails if:** Only one or two targets.
- **Plan B:** A separate area spell for rank III, granted at level 9.
- **Result:** —

### L9.2 · Contagion + Tier II: no mass action loop

- **Rule:** V3 · R50
- **Steps:** Emotional Contagion on a Serene ally, wake Tier II, then pour Joy into the Serene allies each turn.
- **Expected:** Each ally gets at most one extra action (Ecstasy) per fight.
- **Fails if:** An ally gets Ecstasy on two turns.
- **Result:** —

### L9.3 · Growth at 9

- **Rule:** R62b · R62 R67
- **Steps:** Level up to 9. Check Hope on an ally, Overloaded and Catharsis.
- **Expected:** Deeper Feelings shows again. Hope 1d8; Overloaded 3d4 and -3; Catharsis 4d8.
- **Fails if:** The old values.
- **Result:** —

## Level 10 — Ready: Compassion

**Setup:** The Resonant at level 10, one ally, a normal fight.

### L10.1 · Compassion is kind

- **Rule:** V10a · R57
- **Steps:** At level 10, ready Compassion. Let an Apprehensive ally take damage from an enemy.
- **Expected:** Compassion casts Trust as a plain peak: no Submission, no Prone.
- **Fails if:** The ally is knocked Prone.
- **Result:** —

## Level 11 — Shared Heart

**Setup:** The Resonant at level 11, a long fight with the whole party.

### L11.1 · Shared Heart acts on cast

- **Rule:** R58 · R58
- **Steps:** Cast Shared Heart with the party within 18 m.
- **Expected:** Every linked creature feels Joy now and is Serene when it fades. The meter does not rise from it.
- **Fails if:** Nothing on cast, or the Overload fills from the Joy.
- **Result:** —

### L11.2 · Shared Heart shares only helpful feelings

- **Rule:** V10b · R57
- **Steps:** With the link up, braid Love on one ally, then braid a hindering feeling on another ally by hand.
- **Expected:** Love reaches every linked ally; the hindering feeling stays on the one you targeted.
- **Fails if:** The hindering feeling spreads.
- **Result:** —

## Level 12 — Tier III Aspect of Empathy

**Setup:** The Resonant at level 12, a long fight with the whole party.

### L12.1 · Tier III: the dam breaks

- **Rule:** V11 · R56 R68
- **Steps:** At level 12, wake Tier III (15 reactions) with the meter not full. Release Emotional Overload on an enemy that fails.
- **Expected:** The meter fills at once and you are Overloaded. The enemy dances for 2 turns.
- **Fails if:** The meter stays as it was, or the dance lasts 1 turn.
- **Result:** —

## Any level — full run

**Setup:** Across the whole run: a new Resonant levelled from 1 to 12 in your usual fights.

### A.1 · Every level-up has something

- **Rule:** V8 · R59
- **Steps:** Level a Resonant from 1 to 12 and name what changed at each level.
- **Expected:** Every level except 4 and 8 brings something you can name.
- **Fails if:** A level you can't name.
- **Kind:** observe
- **Result:** —

## Appendix — TC_ARC-0014 (design-stage draft, verbatim)

Header of the original file:

```
id: 61.02/Resonant/TC_ARC-0014
owner: QA Lead
source: 21.04/Resonant/DECISIONS.md R49–R68 · REFINE_Resonant_2026-10-15.md §11 · DESIGN.md §14
reviewed: 2026-10-16 ARC-0014 — created (propagation, 00.08); planned, runs after the build; 2026-10-16 ARC-0021 — display name checked, no change
status: planned — nothing to run until the R49–R68 build ships
```

> **Superseded by `GUIDE_ARC-0017.json (QA-0001)`** (OR-4, 2026-10-17): the in-game tests live in the guide; this file is kept as the design-stage record.

### TC_ARC-0014 · The Resonant after the refining (R49–R68)

**Decision it informs:** close the ARC-0014 build, or send a failing rule back to the Lead Class Designer.
**Scenario:** console edition, a Resonant built through the real progression; levels 1, 2, 3, 5, 6, 7, 9, 10, 11, 12;
the PC (SE) edition where marked. Compile the Story after any apply.

#### Probes for the build (one rule each — run first, they decide the spec)

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| B1 | Temper's replayed emotion leaves no mood (R49): its fade reads the replay marker before removing it | After Temper on Bored → Disgust 1 turn → **no** Bored afterwards; a natural Disgust peak later still leaves Bored | The marker clears at the start of the Resonant's next turn |
| B2 | Does the dance's failed turn-start save discharge Mental Fatigue? | Record what happens (1d4 Psychic + Mental Fatigue removed, or not) | If it discharges: the Owner decides (accept, or apply the fatigue after the dance) |
| B3 | Emotional Overload is free: only the current slot's variant shows (R66) | Levels 1, 5, 9: one variant, castable with no slot while Overloaded | — (Owner-tested pattern) |
| B4 | PC: `ARCANA_WEAVING` charges no Threads for Emotional Overload | 0 Threads | Exclude it from the Weaving check |
| B5 | Rank III's area (R51) | Every enemy within 9 m of a point within 18 m | A separate spell for rank III |
| B6 | The Weave Surge container (R54) | Opens with the emotions the Resonant knows (later ones greyed or hidden); Tier II's free Surge works when cast through it | Grant each emotion in the lists again and keep the container for the hotbar only |
| B7 | The growing dice read the Resonant's level (R62) | Hope from a level-5 Resonant on a level-1 ally adds 1d6 | One status version per band, chosen in the Surge |

#### Rules (verification rows of the review, §11)

| # | Fight | Metric | Right if | Wrong if | Decision |
|---|---|---|---|---|---|
| V1 | Level 7–9, any | Ecstasy / Admiration / Amazement on the same creature on consecutive turns | never | ever | R49, R50 |
| V2 | Level 5, an enemy with Bored | Temper on it on consecutive turns with a lost action each time | impossible without a new Disgust Surge | possible | R49 |
| V3 | Level 9, Contagion + Tier II | Extra actions granted per fight | ≤ one per creature | more | R50 |
| V4 | Levels 1–3, normal fights | Turns where the Resonant had nothing useful to do | 0 | ≥ 1 per fight | R51 |
| V5 | Levels 3 and 7 | Turns spent Overloaded; ride vs release | sometimes held, sometimes released | always at once, or never released | R51, R52 |
| V6 | Levels 7–9, boss | Feelings on the release's target | average ≥ 1.5 | under 1.5 | R51 |
| V7 | Levels 5–7, a full day | Releases per day | 1–2 | ≥ 3 | R53 |
| V8 | Level-ups 1 → 12 | The player names what changed at each level (ask) | every level with content | a level they can't name | R59, R60 |
| V9 | PC, levels 3–9 | Turns with no Weave Surge in hand | rare | often | R55 |
| V10 | Level 11 (and 10 for Compassion) | Hindering feelings on allies without the player's choice | 0 | > 0 | R57 |
| V11 | Level 12, long fight | Releases right after Tier III wakes | every fight that wakes it | any missed | R56 |
| V12 | Level 1 → 12 | `dump_progression.pl`, the Resonant rows | the map of DESIGN §10 (4 and 8 empty) | anything else | R59 |
| V13 | Any | The dance on a charm-immune enemy | no dance; damage and Mental Fatigue still land | dance applied | R68 |

**Qualitative questions** after each session (`27.06`): *What did you want to do that you couldn't? When did you feel
strongest? When did you feel the Resonant level up? What would you call its signature?*

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources QA-0001, GUIDE_ARC-0017, TC_ARC-0014 merged; nothing removed.
