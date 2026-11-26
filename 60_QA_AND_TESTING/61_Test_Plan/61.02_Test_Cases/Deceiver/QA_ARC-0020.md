---
id: QA_ARC-0020
title: Playtest — The Veilwalker — rework DV1–DV35 (levels 1–12)
type: playtest
subclass: deceiver
build: ARC-0020
status: in_qa
owner: QA Lead
sources: [TC_ARC-0019]
created: 2026-10-17
---

# QA_ARC-0020 · The Veilwalker — rework DV1–DV35 (levels 1–12)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0020 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from TC_ARC-0019; the level-by-level tests
written on 2026-11-25 from it (the appendix keeps the draft verbatim).

## Before you start

- Type the whole of `TOOLKIT_ARC-0020.md` (only what changes: 9 Stats entries, the lists, the progression and one goal),
  compile the Story (log.txt: 0 error(s)), save and tell Claude `[fechado] ARC-0020`: Claude checks every step, runs the
  generators and the PC deck row (step 23), then you play here.
- 2026-11-25: the Stats, lists and progression are typed and checked; the Osiris goals were split one per feature by Claude
  (DV36). Compile the Story once before playing (log.txt: 0 error(s)).
- Console edition (Script Extender off) unless a test says PC edition.
- A new Veilwalker (Arcana, subclass The Veilwalker) at level 1, levelled up only after the level's tests pass. Keep a save
  at the start of each level.
- Values come from `25` (`*_Deceiver_*`): Splinter 1d6 Psychic in 3 m (4 m at Tier III), Doubt −1 per stack, Deluded at the
  third, cap 3 / 4 at level 8 / 5 at level 12, Awakening goals 4 / 7 / 10 Doubt.
- *Mirrored Self* from a Double (DV25) is not in this build (SPEC_ARC-0020, Deferred): level 10 tests it as it is today.

## Level 1 — The Veil: Doubles on the field, Doubt on enemies

**Setup:** A new Veilwalker at level 1 in a fight with three or more enemies (goblins work), one ally in the party.

### L1.1 · The level-1 kit is the map of DV35

- **Rule:** DV35, DV19, DV26
- **Steps:** Open the character sheet and the spellbook at level 1
- **Expected:** Passives: The Veil only (no Telepathy, no Doubt). Spells: Malicious Whispers, Eidolon, Friends. No Seed of Doubt, no Faceless
- **Fails if:** Telepathy or Doubt is listed, or Seed of Doubt / Faceless is already there
- **Result:** —

### L1.2 · The Veil states the one rule

- **Rule:** DV19
- **Steps:** Hover The Veil on the character sheet
- **Expected:** "Every lie an enemy believes plants Doubt in it. At the third, it becomes Deluded", the Doubles explained, and "4 from level 8 and 5 from level 12"
- **Fails if:** The text is missing, names Sigil or Shatter, or says level 7
- **Result:** —

### L1.3 · Eidolon summons one Double that looks like her

- **Rule:** DV4, DV8
- **Steps:** Cast Eidolon on a spot within 9 m
- **Expected:** One Double appears with her look and the Duplicity shimmer, 1 hit point
- **Fails if:** No Double, more than one, or a Double with more than 1 hit point
- **Result:** —

### L1.4 · Each Double gives her +1 AC

- **Rule:** DV7
- **Steps:** Note her AC with no Double, then with one Double on the field
- **Expected:** AC rises by 1 (Veil layer status on her)
- **Fails if:** AC doesn't change
- **Result:** —

### L1.5 · A Double has its own turn with Splinter and Dismiss only

- **Rule:** DV5 (A1: levels 1–4)
- **Steps:** On the Double's turn, open its hotbar
- **Expected:** Movement, Dash, Disengage, Splinter, Dismiss; no weapon attack, no bonus action, no reaction
- **Fails if:** It can attack, or Reflected Seed / Unveil are already there
- **Result:** —

### L1.6 · A Splinter bursts around the Double

- **Rule:** DESIGN §4.2 Splinter
- **Steps:** Walk the Double next to two enemies and cast Splinter
- **Expected:** Each enemy within 3 m takes 1d6 Psychic and gains 1 Doubt; the Double is gone
- **Fails if:** No damage, no Doubt, or the Double stays
- **Result:** —

### L1.7 · An enemy that destroys a Double gains Doubt

- **Rule:** DV19 (a lie believed)
- **Steps:** Leave a Double next to an enemy and end the turn; let the enemy destroy it
- **Expected:** That enemy gains 1 Doubt
- **Fails if:** No Doubt on the destroyer
- **Result:** —

### L1.8 · The third Doubt makes an enemy Deluded

- **Rule:** DESIGN §4.3
- **Steps:** Bring one enemy to 3 Doubt (Splinters, a Double it destroys)
- **Expected:** It becomes Deluded (Confused, 1 turn) and its Doubt stacks reset
- **Fails if:** No Deluded, or the stacks stay
- **Result:** —

### L1.9 · Doubt lowers its Wisdom saves and its attacks against her

- **Rule:** DESIGN §4.3
- **Steps:** Hover an enemy with 2 Doubt; let it attack her or a Double
- **Expected:** The status reads −1 per stack to Wisdom Saving Throws and to Attack Rolls against her and her Doubles; the roll shows −2
- **Fails if:** No penalty shown or applied
- **Result:** —

### L1.10 · Dismiss: no Splinter, no Doubt

- **Rule:** DESIGN §4.8
- **Steps:** Put a Double next to an enemy and cast its Dismiss
- **Expected:** The Double goes; no damage and no Doubt to anyone
- **Fails if:** It bursts or someone gains Doubt
- **Result:** —

### L1.11 · An ally's hit on a Double plants no Doubt

- **Rule:** DESIGN §4.8
- **Steps:** Let an ally destroy one of her Doubles (an area spell, or an attack)
- **Expected:** No one gains Doubt
- **Fails if:** The ally or an enemy gains Doubt
- **Result:** —

### L1.12 · Malicious Whispers: the fallback turn

- **Rule:** DESIGN §5
- **Steps:** Cast Malicious Whispers on an enemy without a Seed
- **Expected:** Wisdom save; on a failure Psychic damage and Disadvantage on its next attack; no Doubt (it carries no Seed)
- **Fails if:** No save, no Disadvantage, or Doubt without a Seed
- **Result:** —

### L1.13 · Doubles vanish when combat ends

- **Rule:** DESIGN §4.2
- **Steps:** End a fight with a Double on the field
- **Expected:** The Double is gone and her AC is back to normal
- **Fails if:** A Double stays after combat, or the AC bonus stays
- **Result:** —

### L1.14 · Friends gives Advantage on Charisma checks

- **Rule:** DV14
- **Steps:** Cast Friends on a non-hostile creature and start a dialogue with a Charisma check
- **Expected:** The check has Advantage
- **Fails if:** No Advantage
- **Kind:** observe
- **Result:** —

## Level 2 — Seed of Doubt: a lie that bursts later

**Setup:** Level up to 2. A fight with three or more enemies.

### L2.1 · Level 2 grants Seed of Doubt and Faceless

- **Rule:** DV35
- **Steps:** Look at the level-up screen and the spellbook
- **Expected:** Seed of Doubt and Faceless are new at level 2
- **Fails if:** Either is missing, or something else arrives
- **Result:** —

### L2.2 · Seed of Doubt never misses and plants a Seed

- **Rule:** DESIGN §4.4
- **Steps:** Cast Seed of Doubt on an enemy
- **Expected:** Force damage with no roll to hit, and a Seed on it for 6 turns
- **Fails if:** It can miss, or no Seed status
- **Result:** —

### L2.3 · Her next Arcane damage bursts the Seed

- **Rule:** DESIGN §4.4
- **Steps:** Hit the Seeded enemy with Malicious Whispers (fails its save)
- **Expected:** The Seed bursts: Psychic damage and 1 Doubt; the Seed is gone
- **Fails if:** The Seed stays, or no Doubt
- **Result:** —

### L2.4 · A Splinter does not burst a Seed

- **Rule:** DESIGN §4.4 (a Splinter is not her Arcane spell)
- **Steps:** Splinter a Double next to a Seeded enemy
- **Expected:** The Splinter's damage and Doubt land; the Seed stays
- **Fails if:** The Seed bursts
- **Result:** —

### L2.5 · Malicious Whispers on a Seeded target: Paranoia and its own Doubt

- **Rule:** DV15
- **Steps:** Seed an enemy, then cast Malicious Whispers on it (it fails)
- **Expected:** Paranoia (no reactions) and 2 Doubt in total: the rider's and the Seed's burst
- **Fails if:** No Paranoia, or only 1 Doubt
- **Result:** —

### L2.6 · Faceless takes another face

- **Rule:** DV26
- **Steps:** Out of combat, cast Faceless on a humanoid
- **Expected:** She takes its appearance
- **Fails if:** Nothing changes
- **Kind:** observe
- **Result:** —

## Level 3 — Tier I: Doubt pays

**Setup:** Level up to 3. A fight with four or more enemies.

### L3.1 · Level 3 grants Veiled Prison and the Awakening, not Binding Falsehood

- **Rule:** DV35
- **Steps:** Look at the level-up screen and the spellbook
- **Expected:** Veiled Prison and *2 - The High Priestess: Awakening* are new; Binding Falsehood is not there yet
- **Fails if:** Binding Falsehood is already granted, or Veiled Prison is missing
- **Result:** —

### L3.2 · The Awakening counts Doubt: 4 stacks wake Tier I

- **Rule:** DESIGN §8 (A5)
- **Steps:** Apply Doubt in a fight and watch the progress status
- **Expected:** It counts down from 4; at the fourth stack *Veiled* (Tier I) wakes
- **Fails if:** The count doesn't move, or the tier wakes at another number
- **Result:** —

### L3.3 · Veiled: doubting enemies attack her and her Doubles with Disadvantage

- **Rule:** DESIGN §8 Tier I
- **Steps:** At Tier I, let an enemy with Doubt attack her, then a Double
- **Expected:** Both attacks roll with Disadvantage; an enemy without Doubt rolls normally
- **Fails if:** No Disadvantage, or Disadvantage without Doubt
- **Result:** —

### L3.4 · The Veil Lifts: every lie bursts at once

- **Rule:** DESIGN §5 Aspect card (A8)
- **Steps:** At Tier I, with two Doubles near enemies and one Seeded enemy, cast The Veil Lifts
- **Expected:** Every Double Splinters, every Seed of hers bursts, and each surviving enemy with Doubt becomes Deluded
- **Fails if:** A Double stays, a Seed stays, or an enemy with Doubt is not Deluded
- **Plan B:** Explode at each Double's position from Osiris
- **Result:** —

### L3.5 · Veiled Prison: Disadvantage on the save at 2 Doubt, not at 1

- **Rule:** DV10 (A3)
- **Steps:** Cast Veiled Prison on an enemy with 1 Doubt, then (another fight or rest) on one with 2
- **Expected:** 1 Doubt: a normal save. 2 Doubt: the save has Disadvantage
- **Fails if:** Disadvantage at 1, or none at 2
- **Result:** —

### L3.6 · Veiled Prison: Incapacitated, critical hits from 3 m

- **Rule:** DESIGN §5
- **Steps:** Let a Veiled Prison land; attack the target from within 3 m
- **Expected:** It can't move, act or react; the hit is a Critical Hit
- **Fails if:** It acts, or the hit is not critical
- **Result:** —

## Level 4 — Splinter on Command: spend a body when she chooses

**Setup:** Level up to 4 (take the feat). A fight with three or more enemies.

### L4.1 · Level 4 grants Splinter on Command

- **Rule:** DV35, DV24
- **Steps:** Look at the level-up screen and the hotbar
- **Expected:** Splinter on Command is new: a Bonus Action, no spell slot
- **Fails if:** Missing, it costs a slot, or it is an Action
- **Result:** —

### L4.2 · It targets only her Doubles

- **Rule:** DV24
- **Steps:** Open Splinter on Command and hover an enemy, an ally, then one of her Doubles
- **Expected:** Only the Double can be targeted, within 18 m
- **Fails if:** An enemy or an ally can be targeted
- **Result:** —

### L4.3 · The Double Splinters at once, off its own turn

- **Rule:** DV24, DV31 (SPEC probe B1)
- **Steps:** Let a Double take its turn (move, Dash). On her turn, put it next to two enemies with Splinter on Command
- **Expected:** The Double bursts at once: 1d6 Psychic and 1 Doubt to each enemy within 3 m; the Double is gone; her Bonus Action is spent
- **Fails if:** Nothing happens, it waits for the Double's turn, or it fails because the Double already acted
- **Plan B:** Make Splinter on Command a ground-targeted spell that removes the Double and runs the burst from Osiris
- **Result:** —

### L4.4 · On PC it costs 1 Thread and is drawn from the deck

- **Rule:** DV32
- **Steps:** PC edition. Build a deck with Splinter on Command; play a fight
- **Expected:** It comes into the hand like the other cards and costs 1 Thread
- **Fails if:** Always in hand, free, or never drawn
- **Edition:** PC
- **Result:** —

### L4.5 · How often Splinter on Command is used

- **Rule:** DV24 (V1)
- **Steps:** Over two fights, note the turns you used it and why
- **Expected:** Used in most fights, not every turn
- **Fails if:** Never used, or every turn (dominant) — design feedback
- **Kind:** observe
- **Result:** —

## Level 5 — Two Truths and Binding Falsehood: the Doubles cast her spells

**Setup:** Level up to 5. A fight with four or more enemies.

### L5.1 · Level 5 grants Binding Falsehood and Two Truths, not Veilstep

- **Rule:** DV35
- **Steps:** Look at the level-up screen and the spellbook
- **Expected:** Binding Falsehood and Two Truths are new; Veilstep is not there yet
- **Fails if:** Veilstep is granted here, or either of the two is missing
- **Result:** —

### L5.2 · Binding Falsehood: Force now and at turn end, then Restrained

- **Rule:** DESIGN §5
- **Steps:** Cast Binding Falsehood on an enemy (it fails the Wisdom save)
- **Expected:** Force damage now and at the end of its turn, then Restrained for 1 turn
- **Fails if:** No second damage, or no Restrained
- **Result:** —

### L5.3 · The Doubles learn Reflected Seed and Reflected Falsehood

- **Rule:** DESIGN §4.2 (A1: level 5)
- **Steps:** Summon a Double and open its hotbar
- **Expected:** Splinter, Dismiss, Reflected Seed, Reflected Falsehood (no Unveil yet)
- **Fails if:** The two Reflected spells are missing
- **Result:** —

### L5.4 · Reflected Seed: half her Seed at her highest slot, and her Seed

- **Rule:** DV17 (A2)
- **Steps:** A Double casts Reflected Seed on an enemy
- **Expected:** Half of 3d6 Force (her slot 3) and her Seed on the target
- **Fails if:** Full damage, a fixed die, or no Seed
- **Result:** —

### L5.5 · Reflected Falsehood: half her Falsehood, save or Restrained

- **Rule:** DESIGN §4.2
- **Steps:** A Double casts Reflected Falsehood on an enemy
- **Expected:** Half of Binding Falsehood's damage; on a failed Wisdom save Restrained 1 turn
- **Fails if:** No save, or full damage
- **Result:** —

### L5.6 · Eidolon at slot 3 summons two Doubles

- **Rule:** DESIGN §5
- **Steps:** Cast Eidolon with a level-3 slot
- **Expected:** Two Doubles appear
- **Fails if:** One, or three
- **Result:** —

### L5.7 · Cap 3: a fourth Double retires the oldest, quietly

- **Rule:** DV16
- **Steps:** With three Doubles, summon one more
- **Expected:** The oldest Double goes without bursting and nobody gains Doubt; three remain
- **Fails if:** Four stay, or the retired Double bursts
- **Result:** —

## Level 6 — Veilstep and Twice-Told: leave yourself behind, tell it twice

**Setup:** Level up to 6. A fight with three or more enemies.

### L6.1 · Level 6 grants Veilstep and Twice-Told

- **Rule:** DV35
- **Steps:** Look at the level-up screen and the hotbar
- **Expected:** Veilstep and Twice-Told are new at level 6
- **Fails if:** Either is missing
- **Result:** —

### L6.2 · Veilstep: teleport, burst on landing, a Double where she stood

- **Rule:** DV9
- **Steps:** Cast Veilstep to a spot within 18 m near enemies
- **Expected:** She teleports, enemies around the landing take Force damage, a Double stands where she was
- **Fails if:** No Double, or it appears at the landing
- **Result:** —

### L6.3 · Withdraw swaps her with that Double

- **Rule:** DV9
- **Steps:** Within 2 turns of Veilstep, cast Withdraw
- **Expected:** She and the Veilstep Double trade places
- **Fails if:** No Withdraw, or no swap
- **Result:** —

### L6.4 · Twice-Told: Veilstep appears after Veilstep

- **Rule:** DV35 (Veilstep and Twice-Told arrive together)
- **Steps:** Cast Veilstep, then look at the hotbar
- **Expected:** *Twice-Told: Veilstep* is offered
- **Fails if:** It is missing
- **Result:** —

### L6.5 · Twice-Told recasts the last damaging card, once per turn

- **Rule:** DESIGN §5
- **Steps:** Cast Seed of Doubt, then Twice-Told as a Bonus Action; try a second Twice-Told the same turn
- **Expected:** Seed of Doubt again; the second use that turn is refused
- **Fails if:** It recasts something else, costs an Action, or works twice in a turn
- **Result:** —

## Level 7 — Tier II: every Deluded enemy seeds the next

**Setup:** Level up to 7. A fight with five or more enemies close together.

### L7.1 · Level 7 grants Two Pillars and no fourth Double

- **Rule:** DV35
- **Steps:** Look at the level-up screen; then with three Doubles summon one more
- **Expected:** Two Pillars is new; the cap is still 3 (the oldest Double retires)
- **Fails if:** Four Doubles stay at level 7
- **Result:** —

### L7.2 · Seven Doubt wake Tier II

- **Rule:** DESIGN §8 (A5)
- **Steps:** After Tier I, keep applying Doubt and watch the progress status
- **Expected:** Tier II *Two Pillars* wakes at the seventh stack
- **Fails if:** It wakes at another count
- **Result:** —

### L7.3 · Two Pillars: a Deluded enemy seeds its nearest un-Seeded neighbour

- **Rule:** DESIGN §8 Tier II (A6)
- **Steps:** At Tier II, make an enemy Deluded with another enemy within 6 m of it that has no Seed
- **Expected:** That nearest enemy gains her Seed
- **Fails if:** No Seed, or it goes to an enemy farther than 6 m
- **Result:** —

### L7.4 · Two Pillars fires once per turn

- **Rule:** DESIGN §4.6
- **Steps:** At Tier II, make two enemies Deluded in the same turn
- **Expected:** Only the first one seeds a neighbour
- **Fails if:** Both seed a neighbour
- **Result:** —

## Level 8 — Cap 4: a fourth body on the field

**Setup:** Level up to 8 (take the feat). A fight.

### L8.1 · Level 8 raises the cap to 4

- **Rule:** DV35, DV16
- **Steps:** Summon four Doubles (Eidolon twice at slot 3, or Veilstep and Eidolon)
- **Expected:** Four Doubles stay; a fifth retires the oldest, quietly
- **Fails if:** Only three stay, or five
- **Result:** —

### L8.2 · Four Doubles give her +4 AC

- **Rule:** DV7
- **Steps:** With four Doubles, read her AC
- **Expected:** Base AC + 4
- **Fails if:** The layer stops at +3
- **Result:** —

## Level 9 — Unveil and Marionette

**Setup:** Level up to 9. A fight with three or more enemies.

### L9.1 · The Doubles learn Unveil: swap with her, once per round

- **Rule:** DESIGN §4.2 (A1: level 9)
- **Steps:** On a Double's turn, cast Unveil; then try Unveil with a second Double in the same round
- **Expected:** She and the Double trade places; the second Unveil that round is refused
- **Fails if:** No Unveil, no swap, or two swaps in a round
- **Result:** —

### L9.2 · Eidolon at slot 5 summons three Doubles

- **Rule:** DESIGN §5
- **Steps:** Cast Eidolon with a level-5 slot (with no Double on the field)
- **Expected:** Three Doubles appear
- **Fails if:** Two, or four
- **Result:** —

### L9.3 · Marionette: Disadvantage on the save at 2 Doubt

- **Rule:** DESIGN §5
- **Steps:** Cast Marionette on an enemy with 2 Doubt
- **Expected:** The save has Disadvantage; on a failure the enemy fights for her
- **Fails if:** No Disadvantage, or no control
- **Result:** —

## Level 10 — The mirror: Mirrored Self and Mirrored Spell

**Setup:** Level up to 10. A fight with a spellcaster enemy and at least two other enemies.

### L10.1 · Level 10 grants Mirrored Self and Mirrored Spell

- **Rule:** DV35
- **Steps:** Look at the level-up screen
- **Expected:** Both cards are new at level 10
- **Fails if:** Either is missing
- **Result:** —

### L10.2 · Mirrored Self: her next single-target spell gains a second target

- **Rule:** DESIGN §5 (as built today; DV25 deferred)
- **Steps:** Use Mirrored Self, then cast Binding Falsehood
- **Expected:** The spell takes two targets
- **Fails if:** Only one target
- **Result:** —

### L10.3 · Mirrored Spell copies a spell cast near her

- **Rule:** DESIGN §5
- **Steps:** Use Mirrored Spell; let an enemy caster cast a spell within 18 m
- **Expected:** She gains a copy of that spell she can cast
- **Fails if:** No copy
- **Result:** —

## Level 11 — Grand Deception: the whole field is a lie she placed

**Setup:** Level up to 11. A fight with four or more enemies. Before casting, place two Doubles next to one enemy (within
3 m) and none near the others.

### L11.1 · Grand Deception fills the cap

- **Rule:** DESIGN §5, DV22
- **Steps:** With two Doubles on the field, cast Grand Deception
- **Expected:** Two new Doubles appear (cap 4 at this level)
- **Fails if:** More or fewer than the cap
- **Result:** —

### L11.2 · An enemy beside two Doubles gains 2 Doubt on a failed save

- **Rule:** DV22 (SPEC probe B5: the count reads the Doubles before the cast)
- **Steps:** Cast Grand Deception with two Doubles within 3 m of one enemy that fails its save
- **Expected:** That enemy gains 2 Doubt
- **Fails if:** It gains 0, 1 or the old flat 2 regardless of the Doubles (see L11.3)
- **Plan B:** Snapshot the Doubles on the card's technical status instead of UsingSpell
- **Result:** —

### L11.3 · An enemy with no Double near it gains no Doubt

- **Rule:** DV22
- **Steps:** Same cast: look at an enemy within 9 m that failed but had no Double within 3 m
- **Expected:** No Doubt
- **Fails if:** It gains Doubt
- **Result:** —

### L11.4 · The new Doubles don't count

- **Rule:** DV22
- **Steps:** Cast Grand Deception with no Double on the field, enemies close around her
- **Expected:** The new Doubles appear; no enemy gains Doubt from them
- **Fails if:** Enemies gain Doubt from the Doubles the spell just made
- **Result:** —

### L11.5 · The tooltip states the rule

- **Rule:** DV22, Narrative gate
- **Steps:** Hover Grand Deception
- **Expected:** "…gain 1 stack of Doubt for each of your Doubles that stood within 3m of them before the cast"
- **Fails if:** It still says 2 stacks
- **Result:** —

### L11.6 · Placement changes the result

- **Rule:** DV22 (V2)
- **Steps:** Compare a cast with Doubles placed beside enemies and one without
- **Expected:** Placement changes the Doubt clearly
- **Fails if:** Same result either way — design feedback
- **Kind:** observe
- **Result:** —

## Level 12 — Tier III: strike her and the lie explodes

**Setup:** Level up to 12. A long fight with five or more enemies; reach Tier III (10 Doubt).

### L12.1 · Level 12 grants Tier III and cap 5, and nothing moves away from it

- **Rule:** DV35, DV21
- **Steps:** Look at the level-up screen; summon five Doubles
- **Expected:** Aspect of Doubt and cap 5; Mirrored Self and Mirrored Spell are not granted again; five Doubles stay
- **Fails if:** Cap 4, or the cards arrive again
- **Result:** —

### L12.2 · Ten Doubt wake Tier III without a Charisma bonus

- **Rule:** DV21 (A5)
- **Steps:** Note her Charisma; reach Tier III; read it again and hover the tier status
- **Expected:** Tier III wakes at the tenth stack; Charisma unchanged; the status reads the new Aspect of Doubt line ("splinters by itself… reach 4m")
- **Fails if:** Charisma rises, or the old text
- **Result:** —

### L12.3 · At Tier III a Splinter is one burst of 4 m

- **Rule:** DV21 (SPEC probe B6)
- **Steps:** At Tier III, Splinter a Double with one enemy 2 m away and another 3.5 m away
- **Expected:** Both enemies take one 1d6 Psychic hit and 1 Doubt each; one damage number per enemy
- **Fails if:** The enemy at 3.5 m is missed, or an enemy takes two hits
- **Plan B:** A Tier III shapeshift rule with a damage-free Splinter
- **Result:** —

### L12.4 · The burst's Doubt is hers

- **Rule:** DV21 (SPEC probe B2)
- **Steps:** At Tier III, make an enemy Deluded with a Splinter's burst, with an un-Seeded enemy within 6 m
- **Expected:** Two Pillars seeds the neighbour (the Deluded counts as hers); the Doubt counted on her progress status
- **Fails if:** No Seed for the neighbour — the Doubt is not credited to her
- **Plan B:** The burst applies Doubt from Osiris on each enemy within 4 m
- **Result:** —

### L12.5 · A Double destroyed by an enemy bursts by itself

- **Rule:** DV21 (SPEC probe B3)
- **Steps:** At Tier III, leave a Double next to two enemies; let one destroy it
- **Expected:** About a second later a 4 m burst where the Double stood: 1d6 Psychic and 1 Doubt to each enemy in it; the destroyer also gains its own Doubt for believing the lie
- **Fails if:** No burst, or it lands elsewhere
- **Plan B:** Read the position on the hit (AttackedBy), not on the death
- **Result:** —

### L12.6 · No burst when no enemy destroyed it

- **Rule:** DESIGN §4.8 (review focus 1)
- **Steps:** At Tier III: Dismiss a Double; retire one with the cap; let an ally destroy one
- **Expected:** None of them bursts
- **Fails if:** Any of them bursts
- **Result:** —

### L12.7 · Her death ends the Doubles without bursting

- **Rule:** DESIGN §4.8
- **Steps:** At Tier III with Doubles next to enemies, let her go down
- **Expected:** Every Double vanishes; no burst
- **Fails if:** A Double stays or bursts
- **Result:** —

### L12.8 · Ready: Which One? swaps her with the nearest Double

- **Rule:** DESIGN §5 (A7)
- **Steps:** At Tier III, let an attack that would hit her land
- **Expected:** The reaction asks; she swaps with the nearest Double, the attack misses, that Double is destroyed without bursting, the attacker gains Doubt in her name
- **Fails if:** No swap, a burst, or the attacker gains no Doubt
- **Plan B:** Raise the Doubt through the Doubt goal with her as the cause
- **Result:** —

### L12.9 · Her Arcane spells no longer add Charisma to damage

- **Rule:** DV21
- **Steps:** At Tier III, cast Seed of Doubt and read the damage breakdown
- **Expected:** No Charisma modifier added
- **Fails if:** The Charisma bonus is still there
- **Result:** —

### L12.10 · The peak happens in a normal fight

- **Rule:** DV21 (V3)
- **Steps:** Note the turn Tier III wakes and how many bursts the fight has
- **Expected:** Tier III wakes before the fight is decided; the bursts feel like the peak
- **Fails if:** It wakes after the fight is decided — design feedback
- **Kind:** observe
- **Result:** —

## Any level — full run

### A.1 · The level map matches the design

- **Rule:** DV35 (SPEC probe B5 of the draft)
- **Steps:** Claude runs `dump_progression.pl` after the sync
- **Expected:** The rows of DESIGN §9.1: something at every level 1–12, no Telepathy, no Doubt passive
- **Fails if:** Any level differs
- **Kind:** observe
- **Result:** —

### A.2 · No old name in any Veilwalker tooltip

- **Rule:** DV29 (B7 of the draft)
- **Steps:** Hover every Veilwalker card, passive and status as you play
- **Expected:** No *Sigil*, *Shatter*, *Mirror Image*, *Distortion*, *Ethereal Chains* or *Mimic*
- **Fails if:** Any of them shows
- **Result:** —

### A.3 · Doubles ignore loss of control

- **Rule:** DV6
- **Steps:** When an enemy casts a charm or fear effect on a Double
- **Expected:** The Double is immune (Charmed, Madness, Dominated, Frightened)
- **Fails if:** A Double is charmed or flees
- **Kind:** observe
- **Result:** —

**Qualitative questions** after each session (`27.06`): *What did you want to do that you couldn't? When did you feel
strongest? When did you keep a Double instead of spending it, and why? What would you call its signature?*

## Appendix — TC_ARC-0019 (design-stage draft, verbatim)

Header of the original file:

```
id: 61.02/Deceiver/TC_ARC-0019
owner: QA Lead
source: 21.04/Deceiver/DECISIONS.md DV1–DV30 · REFINE_Deceiver.md §5 · DESIGN.md §13, §15 · 05.02/Deceiver.md §8
reviewed: 2026-10-16 ARC-0019 — created (propagation, 00.08); 2026-10-16 ARC-0020 — sizes approved (25), names patch drafted; no change; 2026-10-16 ARC-0021 — display name checked, no change; 2026-10-16 ARC-0020 — Task 0.5 prepared (Splinter on Command), no change; 2026-10-16 ARC-0020 — Tasks 0.6–0.7 prepared, no change; 2026-10-16 ARC-0020 — stage 1 applied (names in game), no change
status: part A runnable now on the Veil build; parts B and C planned — run after the ARC-0019 build ships
```

### TC_ARC-0019 · The Veilwalker — the Veil build and the refining (DV18–DV30)

**Decision it informs:** close the ARC-0019 build, or send a failing rule back to the Lead Class Designer; part A also
decides whether the Veil build (DV1–DV17) is sound enough to build on.
**Scenario:** console edition (no SE), a Veilwalker built through the real progression, the standard saves of `83.02`;
the PC (SE) edition where marked. Compile the Story after any apply. Values: `25` (`*_Deceiver_*`).

#### A · The Veil build, untested since 2026-10-07 (`05.02` §8) — runnable today

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| A1 | The Doubles' spells follow her tier (the shapeshift rule switch) | Level 1–4: Splinter + Dismiss only · 5: + Reflected Seed and Reflected Falsehood · 9: + Unveil | The goal re-applies the rule on level-up |
| A2 | Reflected damage is half her card at her highest slot (DV17) | Level 5 (slot 3): Reflected Seed deals (3d6)/2 Force and lays her Seed | Fixed variants per slot band |
| A3 | Veiled Prison saves with Disadvantage at 2+ Doubt | Doubt 2 → the save shows Disadvantage; Doubt 1 → normal | — |
| A4 | Grand Deception fills the cap and gives Doubt on a failed save | Doubles up to the cap; each failing enemy within 9 m gains 2 Doubt (1 → Deluded at 3) | — |
| A5 | Awakening steps count Doubt stacks | Goals 4 / 7 / 10 count down on the progress status; each tier wakes at its goal | — |
| A6 | Two Pillars (Tier II) | Once per turn, a Deluded enemy in her name seeds the nearest unmarked enemy within 6 m | — |
| A7 | Which One? (Tier III): whose Doubt | The attacker gains Doubt **in her name** (counts for her Awakening) | Raise it through the Doubt goal with her as the cause |
| A8 | The Veil Lifts makes every Double cast Splinter off its turn | Every Double bursts; every Seed of hers bursts; survivors with Doubt become Deluded | Explode at each Double's position from Osiris |

#### B · Probes for the ARC-0019 build (one rule each — run first, they decide the spec)

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| B1 | The Tier III burst on death (DV21, vanilla Death Burst pattern) | A Double destroyed by an enemy explodes at its last position with the wider radius; the Doubt is hers | A Splinter cast by Osiris at the Double's position before it is removed |
| B2 | Only the "destroyed by an enemy" path bursts (DESIGN §4.8) | Dismiss, the cap, combat end, an ally's spell, her death: **no** burst, no Doubt | Tag the cleanup paths before the Double dies |
| B3 | Splinter on Command (DV24, DV31) picks one Double | The chosen Double splinters now; bonus action spent; no slot; on PC it costs Threads and is drawn from the deck (DV32) | Target the Double with the spell |
| B4 | Grand Deception counts Doubles near each enemy **before** the new ones appear (DV22) (SPEC_ARC-0020 probe B5) | Doubt per enemy = Doubles within 3 m of it before the cast (`25` `doubles_range_next`) | Snapshot the Doubles' positions on cast |
| B8 | At Tier III the Splinter shout deals nothing itself; the 4 m burst does (SPEC_ARC-0020 probe B6) | One damage number per enemy per Splinter, 4 m reach | A Tier III shapeshift rule with a damage-free Splinter |
| B5 | The level map (DV28) | `dump_progression.pl`: the rows of DESIGN §9.1, levels 4 and 8 empty, no Telepathy | — |
| B6 | One visible passive (DV19) | The Veil states the core rule; no *Doubt* passive in the list | — |
| B7 | Names (DV29) | Every name in `32.01/Deceiver.md` "after the build"; no Sigil, Shatter, Mirror Image, Distortion, Ethereal Chains or Mimic in a tooltip | — |

#### C · Rules (verification rows of the review, `REFINE_Deceiver.md` §5)

| # | Fight | Metric | Right if | Wrong if | Decision |
|---|---|---|---|---|---|
| V1 | Level 2, any | Turns where Splinter on Command is used | Used in most fights, not every turn | Never used, or used every turn (dominant) | DV24 |
| V1b | Level 2, PC | Share of turns Splinter on Command is in hand when a Double is on the field | Often enough to plan around (DM-P12) | Rarely in hand when it matters | DV32 |
| V2 | Level 11 | Doubt from Grand Deception with Doubles placed vs none | Placement changes the result clearly | Same result either way | DV22 |
| V3 | Level 12, Tier III | Turn Tier III wakes; bursts per fight | Wakes in a normal fight; bursts feel like the peak | Wakes after the fight is decided | DV21 |
| V4 | Level 10 | Mirrored Self's extra target from a Double's position | Works in the engine | Engine can't origin it (plan B: a Double within 9 m (`25` `plan_b_range_next`)) | DV25 |

**Qualitative questions** after each session (`27.06`): *What did you want to do that you couldn't? When did you feel
strongest? When did you keep a Double instead of spending it, and why? What would you call its signature?*

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources TC_ARC-0019 merged; nothing removed.
- 2026-11-25 — DV35 (level map v2): note added above the appendix (B5, V1 read with the new map); the appendix stays verbatim.
- 2026-11-25 — Build kit (ARC-0020 stage 4): the tests written level by level (L1–L12, A.1–A.3) from the appendix, on the level map v2 (DV35) and the delta build of TOOLKIT_ARC-0020; Mirrored Self from a Double (DV25) deferred. Status ready.
- 2026-11-25 — Build in the game (the Owner's Stats, lists and progression; Claude's fixes and goals, DV36): status in_qa.
