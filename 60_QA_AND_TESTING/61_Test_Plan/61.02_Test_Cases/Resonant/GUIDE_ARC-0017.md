---
id: 61.02/Resonant/GUIDE_ARC-0017
owner: QA Lead
source: GUIDE_ARC-0017.json (the interactive page reads the same file) · TC_ARC-0014.md
reviewed: 2026-10-16 ARC-0017 — created
---

# Test guide — ARC-0017 · The Resonant after the refining (R49-R68)

Run it once the build is done. Results go on the interactive page (pass / fail / notes); this file is the record.

## Before you start

- Compile the Story in the Toolkit once: the Overload, Temperance and Shared Heart goals changed during the build.
- Use a NEW Resonant. A character from an older save already learned the eight emotions as separate spells.
- Console edition unless a test says PC. Read results in the combat log and on the status tooltips.
- Some texts of growing dice still say 1d4 (text pass ARC-0006): judge the dice by the combat log, not the tooltip.

## Level 1

**Setup:** A new Resonant at level 1, one ally, a normal fight against two or three enemies.

### B6a · Weave Surge opens with the emotions you know (R54)

- **Steps:** Open the Weave Surge button on the hotbar.
- **Expected:** One button. Joy, Trust and Fear can be cast; the other five are greyed out or missing.
- **Fails if:** Eight separate buttons, all eight castable, or the container opens empty.
- **Plan B:** Grant each emotion in the level lists again and keep the container for the hotbar only.

### B3a · Emotional Overload is free (R66)

- **Steps:** Cast Surges until the Overload meter reaches 100%. Open Emotional Overload.
- **Expected:** Castable as a Bonus Action while Overloaded, with no spell slot spent. Only one version of it shows.
- **Fails if:** It asks for a slot, cannot be cast while Overloaded, or several level versions show.

### R51a · Overloaded is a trade, not a silence (R51)

- **Steps:** With the meter full, check the Overloaded status, then cast spells and wait for your next turn.
- **Expected:** You can still cast spells. 1d4 Psychic at the start of your turn. -1 to Intelligence, Wisdom and Charisma saves.
- **Fails if:** You are silenced, take no damage, or the save penalty is missing.

### R51b · The Surge rider, once per turn (R51)

- **Steps:** While Overloaded, land a Surge on an enemy (it fails its save), then land a second Surge the same turn.
- **Expected:** The first deals an extra 1d4 Psychic; the second deals none. The next turn it works again.
- **Fails if:** No extra damage, or extra damage on both Surges.

### R51c · Emotional Overload, rank I (R51 R68)

- **Steps:** Braid a feeling on an enemy, then release Emotional Overload on it. Repeat on an enemy that makes the save.
- **Expected:** Failed save: Psychic damage per feeling, the enemy dances for 1 turn, Mental Fatigue shows. Made save: half damage, no dance, Mental Fatigue shows. Either way the feelings are gone, Overloaded ends and the meter empties.
- **Fails if:** Paralysis, no Mental Fatigue, or the meter stays full.

### V13 · Charm-immune creatures don't dance (R68)

- **Steps:** Release Emotional Overload on an enemy immune to Charmed that fails the save.
- **Expected:** No dance. The feelings' damage and Mental Fatigue still land.
- **Fails if:** It dances.

### R53 · When a fight ends, the meter settles to half (R53)

- **Steps:** End one fight with the meter partly full (note the %). End another fight while Overloaded.
- **Expected:** After the first: about half the %. After the second: Overloaded is gone and the meter shows about 50%.
- **Fails if:** The meter keeps its value, empties, or Overloaded keeps going after the fight.

### R61 · Heartstring reads feelings (R61)

- **Steps:** Cast Heartstring on an enemy carrying one or two feelings.
- **Expected:** The cantrip damage plus 1d4 Psychic per feeling (combat log). The target's mood does not get longer.
- **Fails if:** No extra damage per feeling.

### R64 · Moods say what they react with (R64)

- **Steps:** Hover a mood on any creature (for example Serene).
- **Expected:** The tooltip lists what each emotion would make of it, with the level that unlocks it.
- **Fails if:** No list.

### V4 · Nothing-to-do turns (levels 1-3) (R51) — observe

- **Steps:** Over your fights at levels 1 to 3, count turns where the Resonant had nothing useful to do.
- **Expected:** None.
- **Fails if:** One or more per fight.

## Levels 2-3

**Setup:** The same Resonant at level 2, then 3.

### L2a · Temper and Anticipation at level 2 (R59)

- **Steps:** Level up to 2.
- **Expected:** Temper is granted, and Anticipation opens inside Weave Surge.
- **Fails if:** Either arrives at level 3.

### L3a · Opposites and Tier I at level 3 (R60 R63)

- **Steps:** Level up to 3. Pour Joy into a Pensive enemy. Wake Tier I in a fight and let a peak fade.
- **Expected:** The Opposites passive shows and Catharsis happens. With Tier I awake, Catharsis gets +1d8 and moods still last 5 turns (not 7).
- **Fails if:** No Opposites passive, or moods last 7 turns with Tier I.

## Levels 5-6

**Setup:** The Resonant at level 5, then 6, a fight with several enemies and one ally.

### B1 · Temper's replay leaves no mood (R49)

- **Steps:** Land Disgust on an enemy and let it fade into Bored. Cast Temper on it (it fails the save). Wait until the replayed Disgust ends. Later, land a normal Disgust again and let it fade.
- **Expected:** After the Temper replay: no Bored. After the normal Disgust: Bored appears.
- **Fails if:** Bored comes back after the replay, or a normal Disgust stops leaving Bored.
- **Plan B:** The replay marker clears at the start of the Resonant's next turn instead.

### V2 · No Temper lock (R49)

- **Steps:** Right after B1, try to Temper the same enemy again on your next turn.
- **Expected:** Not possible: it has no mood until a new Disgust lands.
- **Fails if:** Temper locks it again with no new Surge.

### R51d · Emotional Overload, rank II (R51 R66)

- **Steps:** At level 5, fill the meter and release Emotional Overload.
- **Expected:** It takes two enemies.
- **Fails if:** Still one target.

### R52 · Overloaded grows at 5 (R52 R67)

- **Steps:** At level 5, get Overloaded.
- **Expected:** 2d4 Psychic per turn and -2 to Intelligence, Wisdom and Charisma saves; the rider deals 2d4.
- **Fails if:** Still 1d4 or -1.

### R62a · Deeper Feelings at 5 (R62)

- **Steps:** Level up to 5. Land Fear on an enemy and let it fade into Apprehensive; have it make a Wisdom save.
- **Expected:** The Deeper Feelings passive shows. Apprehensive subtracts 1d6 (combat log).
- **Fails if:** No passive, or still 1d4.

### B2 · Does the dance's save discharge Mental Fatigue? (R68) — observe

- **Steps:** At level 5+, release Emotional Overload on an enemy that fails: it dances and has Mental Fatigue (5+ turns). At its turn start it rolls a Wisdom save to stop dancing.
- **Expected:** Record what happens: if it fails that save, does it take 1d4 Psychic ('Psychic Discharge') and lose Mental Fatigue?
- **Fails if:** Nothing fails here: write down what you saw. The Owner decides.

### L6a · Complex Feelings at 6, not 5 (R59)

- **Steps:** At level 5, pour Joy into an Apprehensive enemy. Level up to 6 and repeat.
- **Expected:** Level 5: a plain Joy peak. Level 6: Guilt.
- **Fails if:** Guilt at level 5.

### B7 · Growing dice read the Resonant's level (R62)

- **Steps:** At level 6, braid Hope on a lower-level ally and watch its next attack roll.
- **Expected:** Hope adds 1d6.
- **Fails if:** It adds 1d4 (the map reads the ally's level).
- **Plan B:** One status version per level band, chosen in the Surge.

## Level 7

**Setup:** The Resonant at level 7 with Tier II reachable (6 reactions), one ally, a fight long enough to wake it.

### V1 · Excess once per fight (R49 R50)

- **Steps:** Joy on an ally, let it fade into Serene, Joy again: Ecstasy. Give it Serene again (a new Joy that fades) and pour Joy a third time. Do the same with Surprise on an enemy (Amazement).
- **Expected:** The second Ecstasy / Amazement on the same creature lands as a plain peak. When Ecstasy ends it leaves no mood.
- **Fails if:** The same creature gets Ecstasy or Amazement twice in one fight.

### B6b · Tier II's free Surge through the container (R40 R54)

- **Steps:** Wake Tier II. On your turn, cast an emotion through the Weave Surge container, then another one.
- **Expected:** The first costs no action and its mood shows at once; the second costs your action and can react with it.
- **Fails if:** The first Surge through the container costs an action.

### V5 · Ride or release (levels 3 and 7) (R51) — observe

- **Steps:** Over a few fights, note whether you held Overloaded for a turn or two or released it at once.
- **Expected:** Sometimes held, sometimes released.
- **Fails if:** Always released at once, or never released.

## Levels 9-10

**Setup:** The Resonant at level 9, then 10, a fight with a group of enemies close together and two allies.

### B5 · Emotional Overload, rank III (the area) (R51 R67)

- **Steps:** At level 9, release Emotional Overload on an enemy in a group.
- **Expected:** Every enemy within 9 m of the point rolls the save and takes its effect.
- **Fails if:** Only one or two targets.
- **Plan B:** A separate area spell for rank III, granted at level 9.

### V3 · Contagion + Tier II: no mass action loop (R50)

- **Steps:** Emotional Contagion on a Serene ally, wake Tier II, then pour Joy into the Serene allies each turn.
- **Expected:** Each ally gets at most one extra action (Ecstasy) per fight.
- **Fails if:** An ally gets Ecstasy on two turns.

### R62b · Growth at 9 (R62 R67)

- **Steps:** Level up to 9. Check Hope on an ally, Overloaded and Catharsis.
- **Expected:** Deeper Feelings shows again. Hope 1d8; Overloaded 3d4 and -3; Catharsis 4d8.
- **Fails if:** The old values.

### V10a · Compassion is kind (R57)

- **Steps:** At level 10, ready Compassion. Let an Apprehensive ally take damage from an enemy.
- **Expected:** Compassion casts Trust as a plain peak: no Submission, no Prone.
- **Fails if:** The ally is knocked Prone.

## Levels 11-12

**Setup:** The Resonant at level 11, then 12, a long fight with the whole party.

### R58 · Shared Heart acts on cast (R58)

- **Steps:** Cast Shared Heart with the party within 18 m.
- **Expected:** Every linked creature feels Joy now and is Serene when it fades. The meter does not rise from it.
- **Fails if:** Nothing on cast, or the Overload fills from the Joy.

### V10b · Shared Heart shares only helpful feelings (R57)

- **Steps:** With the link up, braid Love on one ally, then braid a hindering feeling on another ally by hand.
- **Expected:** Love reaches every linked ally; the hindering feeling stays on the one you targeted.
- **Fails if:** The hindering feeling spreads.

### V11 · Tier III: the dam breaks (R56 R68)

- **Steps:** At level 12, wake Tier III (15 reactions) with the meter not full. Release Emotional Overload on an enemy that fails.
- **Expected:** The meter fills at once and you are Overloaded. The enemy dances for 2 turns.
- **Fails if:** The meter stays as it was, or the dance lasts 1 turn.

### V8 · Every level-up has something (R59) — observe

- **Steps:** Level a Resonant from 1 to 12 and name what changed at each level.
- **Expected:** Every level except 4 and 8 brings something you can name.
- **Fails if:** A level you can't name.

## PC edition (Script Extender)

**Setup:** A Resonant at level 5 in the PC edition with the deck on.

### V9 · Weave Surge in the deck (R55)

- **Steps:** Check the deck list (!arcanapool). Play a few fights.
- **Expected:** One Weave Surge card with 24 copies at level 5 (9 at level 1); no separate emotion cards; it is often in hand.
- **Fails if:** Eight emotion cards, 3 copies, or rarely in hand.

### B4 · Emotional Overload costs no Threads (R66)

- **Steps:** While Overloaded in combat, look at Emotional Overload's cost and cast it.
- **Expected:** 0 Threads.
- **Fails if:** It costs Threads.
- **Plan B:** Exclude it from the ARCANA_WEAVING check.

## Not here

Releases per day (V7) and feelings at release on a boss (V6) are balance metrics: they run in ARC-0010.
