# The Lionheart — VIII · Strength · Aspect of Courage

> Design document for the Arcana's subclass **The Lionheart** (internal name *Titan*). It describes everything
> the subclass is and does: identity, the Villain and Courage, the two forms, every spell and passive, the
> Aspect Awakening, the progression, the edge cases and the technical pattern that builds it.
>
> Designed 2026-10-11 → 2026-10-15 through the process in `21.04_Subclasses/_SUBCLASS_STANDARD.md` (ticket
> ARC-0009; decisions LH1–LH76 in `55_Implementation_Specs/_wip/Lionheart/decisions.md`, texts in
> `_wip/Lionheart/texts.md`). Every gameplay effect lives in Stats, Osiris and Khonsu, so the subclass runs in
> **both editions** (PC with the deck, console without Script Extender).
>
> **Numbers live in `25_Master_Data`** (ADR-0005). Where a value is needed this spec says *(25)*; values
> already proposed in the brainstorm are shown as *(25, draft N)* and are inputs to the balance pass, not
> final. Ranges in metres, action types and level placement are design and are final unless a test proves
> them wrong; a duration in turns is design too, except where it is marked *(25)*.

---

## 1. The subclass in one page

The Lionheart is the Arcana who **stands before the beast**. In every fight one enemy is the **Villain** —
the biggest beast on the field, the enemy with the highest maximum HP. The Lionheart walks up to it and
stays there: ending the turn within its reach and being attacked by it builds **Courage**, the subclass's
resource. Courage is never earned by killing; it is earned by approaching what is dangerous.

The Lionheart fights with **two hands**, the two figures of the card. The **Lion** draws steel: weapon
strikes that deal more damage to the Villain while the Lionheart shrugs off blows. The **Maiden** keeps the
hands open: she closes the beast's jaw, grips its legs, throws it, takes its claws — and while she holds
it, the Villain is worse at attacking anyone but her. Every card has a Lion side and a Maiden side; playing
a side puts the Lionheart in that form, and any weapon attack draws steel. The turn's question is always
the same: **slay the beast faster, or tame it so it can't hurt the party?**

Courage is spent by cards with a price — a bleeding strike, a throw that sends the beast flying, the extra
attack — and, all at once, by the ultimate ***Strangle the Lion***, Heracles' hands closing on the Nemean
lion.

**Fantasy:** *"Every fight has a beast. You are the one who walks up to it."*
**Role:** frontline duellist — locks down and brings down the single most dangerous enemy.

---

## 2. Identity

### 2.1 The card — VIII · Strength

The card shows a woman closing the jaws of a lion **with her bare hands, without effort**; a garland of
flowers runs between them, and the lemniscate (∞) floats over her head. It is the strength of mastery, not
of force: courage is fear tamed, not fear absent. In the Rider–Waite deck Strength took number VIII from
**Justice**, which moved to XI. The Lionheart reads the card **literally** — the woman and the lion are the
two forms.

| Reading of the card | Where it lives in the Lionheart |
|---|---|
| The Maiden and the Lion | The two forms (§5): open hands and drawn steel |
| Closing the lion's jaw | The Maiden's control, one weapon of the beast per card (§6): legs, footing, claws, jaw, the whole beast |
| Strength as courage, fear mastered | Courage, built by standing before the beast (§4.3) |
| The garland that binds woman and lion | *The Garland I / II*, the rules that bind the forms closer (§7.3) |
| The lemniscate (∞) | The Aspect card *Infinity* — both forms at once (§6.9); the thread that never ends (§2.3, §8.4) |
| Strength holds Justice's old number | The capstone *Lion's Judgement* — the Justice the card carries (§6.8) |

### 2.2 The Aspect — Courage

Every Arcana Aspect is an emotion. **Courage** is the Lionheart's: the mechanic only pays the player who
walks up to the most dangerous enemy and stays in its reach. A cautious Lionheart has no Courage; a brave
one spends it every turn. The Awakening counts **Courage spent** (§8), so the subclass awakens by acting on
its courage, not by hoarding it.

### 2.3 Mystra and the Weave

*"Mystra wove the Lionheart from the moment fear is faced instead of fled, a thread looped back on itself
that never comes to an end."* The lemniscate over the Maiden's head is that thread: a strand of the Weave
looped on itself, with no end to cut. The Weave shows in the features: ***Maiden's Seal*** seals the beast's
Weave so it can't cast; ***The Garland*** is the thread binding the two forms; ***Infinity*** is the loop
itself; ***The Twelfth Labour*** is the thread that won't end when the Lionheart should fall.

### 2.4 References

| Source | Kind | What it lends |
|---|---|---|
| **VIII · Strength** (Rider–Waite; *La Force* in Marseille) | Card | The two forms, the closed jaw, the garland, the lemniscate, Justice's number |
| **Heracles** and the **Nemean lion** — strangled with bare hands, its hide worn as armour | Myth | *Strangle the Lion*; Tier I *The Nemean Lion* (*Wear the Hide*); the Maiden's AC from Strength while unarmoured |
| The **Labours of Heracles**, in story order — the Hydra, the descent to Hades | Myth | Tier names; Tier II *The Hydra* (*Many Heads*); Tier III *The Twelfth Labour* |
| **Stanley Rachman, *Fear and Courage*** (1978) — courage is approaching despite fear | Psychology | The Courage rule: gained by approach (ending the turn in the Villain's reach) and threat (being attacked by it), never by killing |
| **Garen** (League of Legends) — *Villain*, *Courage*, *Decisive Strike*, *Demacian Justice* | Fiction | The Villain chosen by the game; the Aspect's name; *Maiden's Seal* (a strike that silences); *Lion's Judgement* (an execute) |
| **Jarvan IV** (League of Legends) — *Dragon Strike*, *Cataclysm*, *Martial Cadence* | Fiction | *Lion's Pounce* (leap onto the target); the duel against one foe |
| **Seiya** (*Saint Seiya*), **Naruto** — the hero who gets up again | Fiction | *The Twelfth Labour* |
| **Aikido** — redirecting the attacker's own momentum | Real practice | *Maiden's Throw* |

### 2.5 Identity Sheet

| Field | Answer |
|---|---|
| **Card and why** | VIII · Strength — the woman and the lion are the two forms (§2.1) |
| **Aspect and why** | Courage — the mechanic pays only for approaching the beast (§2.2) |
| **Mystra and the Weave** | The thread with no end (§2.3) |
| **Myth** | Heracles: the Nemean lion, the Hydra, the twelfth Labour |
| **Science / real source** | Rachman's definition of courage (approach despite fear) |
| **Fiction and powers** | Garen → Villain, Courage, Seal, Judgement · Jarvan IV → Pounce · Seiya, Naruto → The Twelfth Labour |
| **Archetype** | *The champion who stands before the beast* |
| **Fantasy line** | *"Every fight has a beast. You are the one who walks up to it."* |
| **Axis** | **Courage** — *which beast do I face, and do I slay it or tame it this turn?* |
| **Role** | Frontline duellist: damage and control on one enemy; the party is shielded from that enemy |
| **Specialist or versatile** | **Specialist** in one target — strong against a boss or a brute, weaker against a swarm of equals |
| **Play style** | Reach the Villain, stay in its reach, choose each turn between the Lion (damage, damage reduction) and the Maiden (control, the Villain's penalty against others), spend Courage on the right card |
| **Combat style** | Melee, in the Villain's reach; light armour or none. Turn 1: *Pounce* onto the Villain, *Grip* it. Turn 2: Courage 1–2 — *Rend* or *Throw*. Turn 3+: *Second Edge*, then the ultimate with a full bar |
| **Strengths** | (1) Takes the biggest enemy out of the fight — damage or lock-down · (2) shields the party from it (the Maiden's penalty) · (3) durable without heavy armour (Strength to AC, damage reduction) · (4) a full reset in the worst moment (*The Twelfth Labour*) |
| **Weaknesses** | (1) Little against many equal enemies — one Villain (two from Tier II) · (2) must stay in melee; a Villain that keeps away starves Courage · (3) no Extra Attack without Courage · (4) light armour only; Strength saves are rare in BG3 · (5) little for allies (*Shelter*, *The Garland II*) |
| **Chassis** | §3 |
| **Colour** | Heart Crimson `#d7263d` (light) / `#ff5a6e` (dark) |
| **Emoji / Aspect VFX** | 🦁 / to choose (§13) |
| **Voice** | §11 |

---

## 3. Chassis

| Field | Value |
|---|---|
| Spellcasting ability | **Intelligence** (the whole class) |
| Secondary ability | **Strength** — the card's own name; weapon attacks, the Maiden's AC, the Maiden's saving throws, Athletics |
| Saving throws | Strength, Wisdom (Wisdom resists fear) |
| Armour | **Light** — no medium, heavy or shield. The defence comes from the forms (§5) |
| Weapons | **Bladed only:** Shortswords, Scimitars, Longswords, Greatswords, Rapiers, Spears, Javelins, Glaives, Halberds, Pikes |
| Skills (choose 4, then 2 Expertise) | Skill list ***The Lion Tamer***: Animal Handling, Insight, Persuasion, Medicine (the Maiden) · Athletics, Intimidation, Perception, Survival (the Lion) |
| Ability preset *Heart and Hand* | STR 15 · DEX 10 · CON 13 · INT 15 · WIS 10 · CHA 8 (27 points) |
| Starting gear | `EQP_CC_Lionheart` (in the game): light clothing, Shortsword, potions, Revivify scroll |
| Sound set | Fighter (used by no other subclass) |

> The game holds the progression **Titan** (`7643bf5a-62fa-44c4-ab73-572e655554d2`), levels 1–12, whose level
> 1 copies the Resonant's kit as a placeholder; the internal name stays *Titan* (LH1). The build replaces its
> content with this chassis and §9. The player-facing name is already *The Lionheart*.

---

## 4. The Villain and Courage

### 4.1 The core rule — *Stand Before the Beast* (level 1)

> **The enemy with the highest maximum HP is your Villain. Ending your turn within its reach, or being
> attacked by it, gives you 1 Courage.**

That passive explains the whole engine once; no card restates it.

### 4.2 The Villain

- **Who:** among the enemies of the Lionheart in the combat, the one with the **highest maximum HP**; ties go
  to the **higher level**, then to the enemy **nearest** the Lionheart. No range limit. **Summons never
  count.**
- **When:** chosen at the start of the Lionheart's **first turn** in the combat (every combatant has entered
  by then).
- **How long — *One Labour at a Time*:** the Villain stays the Villain until it **dies or leaves the combat**.
  Then the next enemy by the same rule becomes the Villain — reinforcements that joined meanwhile count from
  that moment, but never take the title from a living Villain.
- **A new beast is a new fear:** when the Villain changes, the Lionheart's Courage is **halved, rounding down**
  (Tier I keeps it whole when the Villain dies, §8.2).
- **Visible:** the Villain carries the status **Villain** over its head; the Lionheart's tooltip and the combat
  log name it.

### 4.3 Courage

| Rule | Value |
|---|---|
| **Gain: approach** | +1 when the Lionheart **ends their turn within reach** of the Villain. Reach is a distance *(25)* that covers reach weapons (Glaive, Halberd, Pike) |
| **Gain: threat** | +1 whenever the Villain **attacks the Lionheart**, hit or miss |
| **Cap** | **3** at levels 1–6 · **5** at 7–11 · **7** from 12 *(25, drafts)*. A gain at the cap is lost |
| **Spend** | A card with a **price** pays it automatically when the Lionheart has that much Courage and adds its rider; with less, it plays its base effect and spends nothing. **Only the ultimate spends all.** *Second Edge* spends 1 when the extra attack is used |
| **Reset** | Courage is 0 at the start of each combat and is cleared when it ends |
| **Visible** | The status **Courage** on the Lionheart shows the count (1 to the cap) |

**Prices:** *Second Edge* 1 · *Rend / Throw* 2 · *Fang / Palm* 3 · *Lion's Judgement* 5 (required) ·
*Strangle the Lion* all (at least 2) *(25, drafts)*. The cantrip, *Pounce / Shelter* and *Roar / Seal* never
spend Courage.

### 4.4 Resolution order

1. A card **spends** its price before its effects resolve (the Awakening counts the spend at that moment).
2. If the card **kills the Villain**, the new Villain is chosen at once and Courage is halved (or kept whole at
   Tier I); what was spent stays spent.
3. At the **end of the Lionheart's turn**, the approach gain is checked against the Villain(s) standing at that
   moment.
4. The threat gain resolves when the attack resolves, before the Lionheart's reaction (if any).
5. Several gains in the same moment add up to the cap; nothing above it is stored.

### 4.5 Edge cases

| Case | Result |
|---|---|
| No enemy qualifies (all summons, or all gone) | No Villain; Courage gains stop; the forms still work, their Villain effects simply have no target |
| The Villain is charmed or becomes neutral | It stops being an enemy: treated as leaving the combat (§4.2) |
| The Lionheart is downed | The Villain stays; Courage stays (gains need the Lionheart to act or be attacked) |
| Two Lionhearts in the party | Each has their own Villain and Courage; the same enemy may be both Villains |
| The Villain attacks the Lionheart several times in one turn | +1 per attack, capped by Tier II's rule only when there are two Villains (§8.3) |
| An area attack by the Villain that includes the Lionheart | Counts as an attack on the Lionheart if it uses an attack roll; a saving-throw area does not (T2, §14) |

### 4.6 Worked example (level 5, cap 3)

Turn 1: the ogre (highest max HP) is the Villain. *Lion's Pounce* onto it, *Maiden's Grip* (it fails the save:
movement 0). The Lionheart ends the turn in reach: **Courage 1**. The ogre swings at the Lionheart and misses:
**Courage 2**. Turn 2: *Lion's Rend* pays 2 — the ogre bleeds; Courage 0. *Second Edge* isn't offered (0
Courage). End of turn in reach: **1**. The ogre hits the Lionheart: **2**. Turn 3: *Strangle the Lion* spends 2 —
the ogre is Restrained and takes Bludgeoning damage for 2; the extra attack is free this turn.

---

## 5. The two forms

### 5.1 The Lion and the Maiden

The Lionheart is always in **one** form (both only under *Infinity*). **Combat starts in the Maiden** — the calm
hand before the beast. Each form has an offence and a defence; nothing else in the kit grants them again
(*one owner per effect*: cards may only scale or extend them).

| | **Lion** — steel in hand | **Maiden** — open hands |
|---|---|---|
| **Offence** | The Lionheart's weapon attacks deal **+1d4** damage to the Villain | The Villain takes **−1d4** on attack rolls (weapon and spell attacks) against every creature that is not the Lionheart |
| **Defence** | Damage from **weapon attacks** reduced by **2** *(25, draft)* | **Unarmoured:** AC = 10 + DEX + **Strength** (the Nemean hide; no cap) · **in light armour:** a small flat AC bonus *(25)* |
| **Grows** | 1d4 → 1d6 (level 3) → 1d8 (level 7); reduction 2 → 3 → 5 *(25, drafts)* | −1d4 → −1d6 (level 3) → −1d8 (level 7); light-armour bonus per level band *(25)* |

### 5.2 *Drawing Steel* (level 1)

> **Open hands are the Maiden; steel in hand is the Lion. Any weapon attack puts you in the Lion.**

- In the **Maiden** the Lionheart's weapons are **sheathed** while still equipped; every Maiden side is an
  open-hand gesture (grip, throw, palm, seal).
- **Any weapon attack** — a card's Lion side, a basic attack, an opportunity attack — puts the Lionheart in the
  **Lion** at once.
- **Playing a card's side** puts the Lionheart in that side's form, which lasts until the other form is
  entered. There is no separate switch action.
- The Maiden's sides are saving-throw spells, never weapon attacks, so they don't draw steel.

### 5.3 Cards as two hands

Every Lionheart card except the ultimate, the capstone and the Aspect card is a **spell container** with two
sides (*Choose: Lion / Maiden*): similar in weight, each in its form's focus. The deck counts the container as
one card (the pattern `CardDB.lua` already uses for *Choose* cards); on console the engine shows the container.

**The Maiden's focus is the fight against the enemy** — control and offensive defence. She has small touches of
support (*Shelter*, *The Garland II*), never healing or buffs as a focus.

---

## 6. Spells

The Maiden's sides follow one axis each: she closes **the legs** (Grip), **the footing** (Throw), **the claws**
(Palm), **the jaw** (Seal) and finally **the whole beast** (Strangle). The Lion's sides strike, wound and hunt.
Maiden saving throws use the Lionheart's spell save DC.

### 6.1 *Claw / Grip* — cantrip, Action (level 1)

- ***Lion's Claw*** — a weapon attack; on a hit the target is **shoved 1.5 m**.
- ***Maiden's Grip*** — the target makes a **Strength** saving throw; on a failure its **movement is 0** until the
  start of the Lionheart's next turn.
- The baseline turn. **Never spends Courage.**

### 6.2 *Pounce / Shelter* — level 1, Bonus Action

- ***Lion's Pounce*** — leap to an enemy within **9 m** without provoking opportunity attacks; the next weapon attack
  this turn deals a small extra damage that grows with level like a cantrip *(25)*. Once per turn.
- ***Maiden's Shelter*** — gain **9 m** of movement and **throw an adjacent ally up to 5 m** back, out of an
  enemy's reach (no Prone, no fall damage).
- No Courage price.

### 6.3 *Rend / Throw* — level 1, Action, price 2

- ***Lion's Rend*** — a heavy weapon strike *(25)*. **With 2 Courage:** the target is **Bleeding** (vanilla `BLEEDING`).
- ***Maiden's Throw*** — with an open hand the Lionheart turns the enemy's own momentum against it: **Strength**
  save; on a failure the enemy is thrown a few metres *(25)* and lands **Prone**. Creatures larger than **Large**
  can't be thrown. **With 2 Courage:** greater distance and fall damage *(25)*.

### 6.4 *Roar / Seal* — level 5, Action

- ***Lion's Roar*** — enemies in an area *(25)* make a **Wisdom** save or are **Frightened** *(25 turns)*.
- ***Maiden's Seal*** — the target makes a save *(ability: 25)*; on a failure it is **Silenced**, its
  **Concentration breaks** and it **loses its reaction** until the start of the Lionheart's next turn. She seals
  the beast's Weave.
- No Courage price.

### 6.5 *Strangle the Lion* — the ultimate, level 5, Action

Heracles and the Nemean lion: the card's hand closing the beast's jaw.

- **Target: the Villain only.** **Once per combat.** Costs a slot / Threads like any card and needs **at least 2
  Courage**; it **spends all** of it.
- The Villain is **Restrained** *(25 turns)* and takes **Bludgeoning** damage that grows with the Courage spent
  *(25)*.
- Then the Lionheart switches to the **Lion** for free, and ***Second Edge* costs no Courage for the rest of this
  turn.**
- It plays both hands in sequence — Maiden, then Lion — instead of offering a choice; it is not a container.
- Bosses: Restrained works on any enemy that isn't immune to it; the rule needs no boss detection.

### 6.6 *Fang / Palm* — level 9, Action, price 3

- ***Lion's Fang*** — a heavy weapon strike *(25)*; if the target is **Bleeding**, the bleeding becomes a **Gaping
  Wound** (vanilla `GAPING_WOUND`). **With 3 Courage:** the target is **Hamstrung** (vanilla `HAMSTRING`, movement
  halved) — the hunter cuts the tendon so the prey can't run.
- ***Maiden's Palm*** — an open-hand strike at the weapon hand: save *(ability: 25)*; on a failure the target is
  **Disarmed**. **With 3 Courage:** the Disarmed lasts longer *(25)*.

### 6.7 *Second Edge* — passive, level 5

The Lionheart's **Extra Attack, paid with Courage**: after a weapon attack with the Action, while the Lionheart
has **1 Courage or more**, they may make one more weapon attack; **using it spends 1 Courage.** Not used, nothing
is spent. It's the only extra attack the subclass has — the second blade is earned by the mechanic.

### 6.8 *Lion's Judgement* — capstone, level 11, Action, Long Rest, Unique

Garen's *Demacian Justice*; the Justice whose number Strength carries.

- **Requires 5 Courage** *(25, draft)* and spends it. A Lion strike on one enemy (any enemy, not only the Villain).
- If the target is below **25% HP** *and* below a **fixed HP cap** *(25)*, it **dies**. Otherwise it takes **heavy
  damage** *(25)*. One rule for every enemy — no boss detection is needed (the Power Word Kill pattern).
- After a kill the Lionheart **sheathes** — enters the **Maiden** — and gains **12 m** of movement.

### 6.9 *Infinity* — the Aspect card (Tier I)

Created, 0 Threads, 0 slots, **once per combat**, Bonus Action.

- For **2 turns** the Lionheart is in **both forms**: the Lion's and the Maiden's effects apply together; a weapon
  attack doesn't end the Maiden; playing a side doesn't leave the other form.
- The lemniscate of the card. It plays the forms, not Courage — the ultimate plays Courage.
- The one exception to *Drawing Steel*'s look: steel in hand while the Maiden is up.

---

## 7. Passives

### 7.1 *Stand Before the Beast* (level 1)

The Villain and Courage — §4.1 to §4.3.

### 7.2 *Drawing Steel* (level 1)

The two forms and how they switch — §5.1 and §5.2.

### 7.3 *The Garland I* (level 3) and *The Garland II* (level 7)

The garland that binds the woman and the lion: at each, both forms gain a new rule (and their dice grow, §5.1).

| | **Lion** | **Maiden** |
|---|---|---|
| ***The Garland I*** (level 3) | **Unbowed:** can't be knocked Prone or shoved | **Turn the Blow** — reaction: when an enemy within 1.5 m of the Lionheart attacks an ally, shove that enemy 1.5 m (it doesn't interrupt the attack) |
| ***The Garland II*** (level 7) | The damage reduction also covers **spells** | Allies within **3 m** of the Lionheart gain a **fixed AC bonus** *(25)* |

### 7.4 *Second Edge* (level 5)

§6.7.

### 7.5 *The Ordeal* (level 9)

When an ally within **9 m** of the Lionheart **drops to 0 HP**, the enemy that downed them **becomes the Villain**
— replacing the current one (at Tier II, the head with the lower maximum HP) — and the Lionheart's **Courage
fills to the cap**. If that enemy already is a Villain, only the Courage fills. The replaced Villain's change
does not halve Courage (the fill happens after it).

---

## 8. Aspect Awakening — 8 · Strength

### 8.1 The goal — Courage spent

**Each point of Courage spent counts 1** — card prices, *Second Edge*, the ultimate (all it spends) and *Lion's
Judgement*. Cumulative within the fight. The goal shows as the ARC-0007 countdown (COUNT type) on the
*Awakening* status. Goals *(25: `FEAT_Lionheart_AspectAwakening`)*. Holding Courage for the ultimate delays the
Awakening; spending it on the way speeds it — the tension is deliberate.

| Tier | Level | Name | Source |
|---|---|---|---|
| I | 3 | **The Nemean Lion** | Heracles' first Labour |
| II | 7 | **The Hydra** | the many-headed beast |
| III | 12 | **Aspect of Courage** | the twelfth Labour |

### 8.2 Tier I — The Nemean Lion: *Wear the Hide*

When a Villain **dies**, the Lionheart wears its hide: **resistance to all damage for 1 turn**, and Courage passes
**whole** to the next Villain (no halving). A Villain that flees or leaves the combat still halves Courage. Tier I
also creates the Aspect card ***Infinity*** (§6.9).

### 8.3 Tier II — The Hydra: *Many Heads*

From Tier II there are **two Villains** — the two enemies with the highest maximum HP, by the same tie rules; each
head follows *One Labour at a Time* on its own (a fallen head is replaced by the next). Both feed Courage and both
receive the forms' effects. *Strangle the Lion* still takes one target. **Cap:** each Villain gives Courage at most
**once per trigger** (approach, threat) **per turn**.

### 8.4 Tier III — Aspect of Courage: *The Twelfth Labour*

**Once per combat**, when the Lionheart would drop to **0 HP while a Villain still stands**, they rise instead —
with **HP and Courage at their maximum**. Heracles' last Labour, down to Hades and back; the thread that doesn't end.
It chains into the ultimate. No ability score bonus.

---

## 9. Progression

| Level | Rules (passives) | Spells |
|---|---|---|
| **1** | ***Stand Before the Beast*** (the Villain, Courage, cap 3) · ***Drawing Steel*** (the two forms) | Cantrip *Claw / Grip* · *Pounce / Shelter* (Bonus Action) · *Rend / Throw* |
| 2 | — (base class) | — |
| **3** | ***The Garland I*** (Unbowed / Turn the Blow; dice 1d6) · **8 - Strength: Awakening** · Tier I ***The Nemean Lion*** → *Infinity* | — |
| 4 | — | — |
| **5** | ***Second Edge*** | ***Strangle the Lion*** (ultimate) · *Roar / Seal* |
| 6 | — | — |
| **7** | ***The Garland II*** (reduction vs spells / allies' AC; dice 1d8) · Courage cap 5 · Tier II ***The Hydra*** | — |
| 8 | — | — |
| **9** | ***The Ordeal*** | *Fang / Palm* |
| 10 | — | — |
| **11** | — | ***Lion's Judgement*** (capstone) |
| **12** | Courage cap 7 · Tier III ***Aspect of Courage*** (*The Twelfth Labour*) | — |
| 13–20 | Reserved, like the rest of the class | |

**The journey:** learn the duel (1–3): find the Villain, stand in its reach, choose a hand each turn. Level 3 binds
the forms closer and starts the Awakening. Level 5 is the turn the subclass becomes itself: the second blade paid
with Courage, the ultimate, the roar and the seal. Level 7 fights two beasts at once. Level 9 answers a fallen ally
by taking the killer as the Villain. Level 11 executes. Level 12 refuses to fall.

---

## 10. How it plays

### 10.1 A turn

1. **Find the beast:** where is the Villain, and is the Lionheart in its reach?
2. **Choose the hand:** the Lion if the Villain can be brought down or the Lionheart needs the damage reduction;
   the Maiden if the Villain threatens the party or must be held.
3. **Spend or hold:** pay a card's price now, or keep Courage for *Strangle the Lion*.
4. **End in reach** — the approach gain.

### 10.2 A fight

- **Turn 1:** *Pounce* onto the Villain (Bonus Action) and *Grip* or *Claw* (Action). Courage 1–2 by the next turn.
- **Turn 2:** *Rend* (Bleeding) or *Throw* (Prone) with 2 Courage; or the cantrip to keep Courage.
- **Turns 3–4:** *Second Edge* every turn Courage allows; the ultimate with a full bar; the Villain dies, the next
  becomes the Villain (Tier I keeps the Courage).
- **Long fights:** *The Ordeal* turns a downed ally into a full bar; *The Twelfth Labour* refuses the last fall.

### 10.3 Party

The Lionheart takes the biggest enemy off the party's hands — in the Maiden its attacks against anyone else are
worse; in the Lion it dies faster. It pairs with ranged allies and casters who want the brute held, and with a
healer, since the Lionheart stands in melee in light armour. With many equal enemies it does less: one Villain,
two from Tier II.

---

## 11. Text

English, Larian voice (`31.03`), following the formulas of `31.01` §5. Narrative gate: `32.04`. Texts approved
in `_wip/Lionheart/texts.md` (LH74).

- **Class description:** *"Mystra wove the Lionheart from the moment fear is faced instead of fled, a thread looped
  back on itself that never comes to an end. They mark the greatest beast on the field and stand before it,
  closing its jaw with open hands or drawing steel to bring it down."*
- **Panel line:** *"The Lionheart loops the Weave into a thread that never breaks, standing before the greatest
  beast in every fight until it is tamed or slain."*
- **Tag line:** *"We stand before the beast so no one else has to, and the Weave never lets our thread break."*
- **Names:** cantrip *Claw / Grip* (*Lion's Claw*, *Maiden's Grip*); *Pounce / Shelter*; *Rend / Throw*; *Roar /
  Seal*; *Fang / Palm*; *Strangle the Lion*; *Lion's Judgement*; *Infinity*; passives *Stand Before the Beast*,
  *Drawing Steel*, *The Garland I / II*, *Second Edge*, *The Ordeal*; tiers *The Nemean Lion* (*Wear the Hide*),
  *The Hydra* (*Many Heads*), *Aspect of Courage* (*The Twelfth Labour*); statuses **Villain**, **Courage**,
  **Lion**, **Maiden**.
- Card sides are written *Lion's X* / *Maiden's X*; tooltips of each side name the form it enters.
- Final polish after every subclass's rework (ARC-0006).

---

## 12. Technical pattern

Everything is Stats, Osiris and Khonsu; nothing needs Script Extender. Signatures from `story_header.div`
(line numbers in brackets); vanilla evidence from the extraction in `C:\Projetos\BG3\Base Game BG3`.

### 12.1 Osiris drives the Villain and Courage (`ARCANA_Aspect_Strength.txt`)

- **Candidates** — `EnteredCombat(_Object, _CombatGuid)` (:1194) records the combatants; `IsEnemy` (:1026) against the
  Lionheart and `IsSummon` (:911) filter them.
- **Choice** — on the Lionheart's first `TurnStarted` (:1205) in the combat, compare `GetMaxHitpoints` (:697), then
  `GetLevel` (:599), then `GetDistanceTo` (:626); apply the Villain status with `ApplyStatus` (:850), the Lionheart as
  `_Source`.
- **Lifecycle** — `Died` (:312) and `LeftCombat` (:1201) of a Villain pick the next one and halve Courage (Tier I
  checks the death); `CombatEnded` (:1199) clears everything.
- **Approach gain** — `TurnEnded` (:1206) of the Lionheart: `GetDistanceTo` to each Villain ≤ reach *(25)* → +1.
- **Courage count** — a ledger `DB_ARCANA_Courage(Char, N)` mirrored by the statuses `LIONHEART_COURAGE_1…7` (the
  Doubt pattern: `DOUBT_1…N` + `DOUBT_ADD_TECH`); cards and passives apply `_TECH` statuses that Osiris turns into
  +1 / −N / −all / fill.
- **Awakening** — each point spent feeds `PROC_ARCANA_Aspect_Progress` (ARC-0007, COUNT).
- **The Ordeal** — an ally downed within 9 m: who downed them is read from `AttackedBy` (:1184) when the ally's HP
  reaches 0 (T2).

### 12.2 Stats — vanilla patterns

| Effect | Pattern | Vanilla evidence |
|---|---|---|
| Threat gain (hit or miss) | Passive, `StatsFunctorContext "OnAttacked"`, condition on the attacker carrying the Villain status → `_TECH` | `OnAttacked` passives whose conditions use `IsMiss()` (they fire on misses) |
| Weapon attack → Lion | Passive, `"OnAttack"` + `IsWeaponAttack()` → `ApplyStatus(SELF,LIONHEART_LION,…)` | `IsWeaponAttack()` 75× |
| One form at a time | Lion and Maiden share one `StackId` | standard StackId behaviour |
| Lion: +1d4 vs the Villain | `IF(HasStatus('LIONHEART_VILLAIN',context.Target) and IsWeaponAttack()):DamageBonus(1d4)` | `IF(HasObscuredState(…, context.Target)):DamageBonus(2, Radiant)` |
| Lion: damage reduction | `DamageReduction(All, Flat, N)`, under `IF(IsWeaponAttack())` until *The Garland II* | `DamageReduction(All, Flat, 1000)` |
| Maiden: penalty vs others | On a status the Villain carries while the Lionheart is in the Maiden: `IF(not HasStatus('LIONHEART_MAIDEN',context.Target)):RollBonus(Attack,-1d4)` | `IF(HasStatus('BLEEDING',context.Target)):Advantage(AttackRoll)`; `RollBonus(Attack,-1d4)` / `-1d6` |
| Maiden: AC unarmoured | `ACOverrideFormula(10,true,Dexterity,Strength)` | Barbarian `(10,true,Dexterity,Constitution)`, Monk `(…,Wisdom)` |
| Maiden: AC in light armour | `AC(N)` (flat) | no AC boost takes an expression |
| Maiden: sheathed | `Sheathing "Sheathed"` on the Maiden status | BOOST statuses hold `Instrument` while active (`PERFORM_POSITIVE`) — T2 |
| Seal: Concentration | `BreakConcentration()` in the status's `OnApplyFunctors` | 48× |
| Seal: no reaction | `ActionResourceBlock(ReactionActionPoint)` | 52× |
| Throw: size limit | `SizeEqualOrSmaller(Size.Large)` | 12× |
| Judgement: execute | `HasHPPercentageLessThan(25, context.Target)` and `HasHPLessThan(<literal>)` | `HasHPLessThan(101)` (Power Word Kill) |
| The Twelfth Labour | A BOOST status with `DownedStatus(<X>_DOWNED,…)`; the DOWNED status's `OnApplyFunctors` heal to full, fill Courage and remove the boost. Osiris keeps the boost only while a Villain stands | `RELENTLESS_ENDURANCE` / `RELENTLESS_ENDURANCE_DOWNED` |
| Conditions | Vanilla `BLEEDING`, `GAPING_WOUND`, `HAMSTRING`, `FRIGHTENED`, `SILENCED`, `DISARMED`, `RESTRAINED`, `PRONE` | all present |

### 12.3 Generator

The Courage family (`LIONHEART_COURAGE_1…7`, the `_TECH` statuses for +1, −1, −2, −3, −5, −all, fill) and the
per-level form statuses (dice and reduction steps at 1 / 3 / 7) come from a generator in
`80_TOOLS_AND_PIPELINE/82_Automation/stats/`, like `gen_emotion_alchemy.pl`. Cards' upcast variants come from
`gen_upcast_variants.pl`.

### 12.4 Master data (25) — to be written in the balance pass

`FEAT_Lionheart_Courage` (reach, cap per level, prices) · `FEAT_Lionheart_Forms` (dice, reduction, light-armour AC,
*The Garland II* bonus) · `FEAT_Lionheart_AspectAwakening` (goals) · `SPL_Lionheart_ClawGrip` · `SPL_Lionheart_PounceShelter` ·
`SPL_Lionheart_RendThrow` · `SPL_Lionheart_RoarSeal` · `SPL_Lionheart_FangPalm` · `SPL_Lionheart_StrangleTheLion` ·
`SPL_Lionheart_LionsJudgement` (HP cap, damage) — the names follow `25.00/master_data.schema.yaml`.

### 12.5 Ids

Final ids are fixed in `SPEC_ARC-0009` against `33.03` (glossary) and ADR-0002: cards
`<Type>_Arcana_Card_Spell_*` (containers and their two children), the Aspect card `<Type>_Arcana_Created_Infinity`,
the reaction `Interrupt_Arcana_Reaction_TurnTheBlow`, passives `Arcana_Passive_*`, statuses in
`SCREAMING_SNAKE_CASE` with the `LIONHEART_` prefix (vanilla already has courage-named statuses for the Paladin's
aura), technical ones ending in `_TECH`.

---

## 13. Open

| Item | Decided in |
|---|---|
| Every value marked *(25)*: set in `25_Master_Data` from the balance pass (report in `22.05`) | Balance pass |
| Saving throws: which ability *Maiden's Seal* and *Maiden's Palm* use; whether *Strangle the Lion* allows a save | Balance pass |
| Emoji confirmed 🦁; Aspect VFX | Owner, Icon Artist |
| Content of the *Titan* progression (`7643bf5a`) replaced by §9; ClassDescription and ProgressionDescription texts from §11 | Build |
| The Eternal's rework: Bleeding, Gaping Wound and Hamstring now belong to the Lionheart's vocabulary | Eternal rework (future ticket) |

## 14. To test in game

| Test | What proves it |
|---|---|
| Villain choice | In a fight with an ogre and goblins, the ogre gets *Villain* on the Lionheart's first turn; a summon with more HP never does |
| Villain lifecycle | The Villain dies → the next highest max HP becomes the Villain, Courage halved (rounded down); a reinforcement with more HP doesn't take the title from a living Villain |
| Approach gain | Ending the turn next to the Villain gives 1; at reach distance with a Glaive gives 1; one step beyond gives 0 |
| Threat gain on a miss | The Villain misses the Lionheart: +1 |
| Threat gain from a saving-throw area | Decide from the result whether it counts (§4.5) |
| Cap | At the cap, a gain is lost; at level 7 the cap is 5 |
| Drawing Steel | A basic weapon attack, an opportunity attack and a Lion side each switch to the Lion; a Maiden side never does |
| Maiden sheathed | The weapon stays sheathed through the Maiden's turns while equipped |
| Maiden penalty | The Villain attacking an ally rolls −1d4; attacking the Lionheart rolls normally; the penalty ends when the Lionheart enters the Lion |
| Maiden AC | Unarmoured: AC = 10 + DEX + STR; in light armour: armour AC + the flat bonus, no Strength |
| Lion reduction | A weapon hit is reduced; a spell isn't until level 7 |
| Unbowed | The Lion can't be shoved or knocked Prone |
| Turn the Blow | An enemy next to the Lionheart attacks an ally: it is shoved 1.5 m after the attack |
| Second Edge | With 0 Courage no extra attack is offered; with 1 it is, and using it spends 1; not using it spends nothing |
| Card prices | *Rend* with 1 Courage: no Bleeding, nothing spent; with 2: Bleeding, 0 left |
| Strangle the Lion | Can't be cast with 1 Courage; with 3 spends 3; the extra attack is free that turn; once per combat |
| Lion's Judgement | A weak enemy under 25%: dies; a boss under 25% above the HP cap: heavy damage only; afterwards the Maiden and +12 m |
| Wear the Hide | The Villain dies at Tier I: Courage kept whole, resistance for 1 turn; a Villain that flees still halves |
| Many Heads | At Tier II two enemies carry *Villain*; each gives at most one gain per trigger per turn |
| The Ordeal | An ally downed within 9 m: the killer becomes the Villain and Courage fills |
| The Twelfth Labour | Lethal damage with a Villain standing: the Lionheart rises at full HP and full Courage, once per combat; with no Villain standing, they go down |
| Infinity | For 2 turns both forms' effects apply and a weapon attack doesn't end the Maiden |
| Console edition | Without Script Extender, every rule above behaves the same |
