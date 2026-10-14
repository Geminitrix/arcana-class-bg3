# The Lionheart (was the Titan) — design decisions (ARC-0009)

Working note for the design of **VIII · Strength**. Decisions LH1 on, from the design conversation of
2026-10-14 (process: `21.04_Subclasses/_SUBCLASS_STANDARD.md` §1.2). No numbers here (ADR-0005).

## Directions considered

- Round 1: **A · The Challenge** (Risk — face the strongest), **B · The Hero's Journey** (Arc — chapters per
  fight), **C · The Maiden and the Lion** (Transformation — two forms). Author preferred C, with A's flavour.
- Round 2 (C + A): **D · Two Hands, One Foe** (chosen), **E · The Lion's Jaw** (the Challenged foe is the lion:
  open it to slay, close it to tame), **F · The Nemean Mantle** (fight as the Maiden, bravery fills the Roar,
  put on the Nemean lion's skin to become the Lion). Parts that may travel into D: the Nemean Mantle (ultimate
  or Aspect card), taming/surrender from E, Rebirth from B (capstone).

## Decision log

| # | Decision | Source |
|---|---|---|
| LH1 | Name **The Lionheart**; the progression keeps the internal name *Titan* (`7643bf5a`) | author (2026-10-11) |
| LH2 | Card **VIII · Strength** | author |
| LH3 | Aspect (provisional): **Courage / Bravery** | author |
| LH4 | References: Garen, Jarvan IV (LoL), Seiya (Saint Seiya), Naruto, protagonists of the hero's journey | author |
| LH5 | Role: melee weapon fighter | author |
| LH6 | Armour light, maybe medium; no heavy | author |
| LH7 | Colour red (planned in the Lore Bible) | earlier record |
| LH8 | Base direction: **C · The Maiden and the Lion** (the card read literally), with flavour from **A · The Challenge** | author |
| LH9 | **Direction D · Two Hands, One Foe**: the Lionheart Challenges one foe; facing it (ending the turn in its reach, being hit by it) builds **one** resource; the **Lion** form spends it on strikes, the **Maiden** form on protection (closing the jaw, guarding, taunting); switching form is the turn's decision; working ultimate *Infinity (∞)* — both forms at once for a turn | author (proposal accepted) |
| LH10 | **Aspect of Courage** — courage as fear mastered (acting while afraid). The resource that facing the foe builds is also named **Courage** | author (proposal accepted) |
| LH11 | **The Villain**: the Challenged foe is chosen automatically, not by a card — the enemy with the highest level and the highest maximum HP (Garen's *Villain*, adapted). Osiris has `GetLevel` and `GetMaxHitpoints` (KB 57.05); enumerating combatants via `EnteredCombat` is **T2** | author |
| LH12 | **HP first:** the Villain is the enemy with the **highest maximum HP**; level breaks ties; a full tie goes to the enemy nearest the Lionheart. Scope: every enemy in combat, no range limit. The biggest beast on the field — the Nemean lion read literally | author (option 2 of 3) |
| LH13 | **One Labour at a Time:** the Villain is chosen when combat starts and stays until it dies or leaves combat; then the next highest maximum HP becomes the Villain. Summons never count. Reinforcements wait (a later passive may let the Lionheart accept a greater challenge) | author (proposal accepted) |
| LH14 | **Stand Before the Beast:** +1 Courage when the Lionheart ends their turn within melee reach of the Villain; +1 whenever the Villain attacks the Lionheart (hit or miss). Courage has a cap (balance pass), resets when combat ends, shows on a status with a count | author (proposal accepted) |
| LH15 | **The Hand That Acts, as containers:** every Lionheart card is a spell container (*Choose: Lion / Maiden*) with two sides — similar effects, each focused on its form. Playing a side puts the Lionheart in that form until a side of the other form is played; the form's lingering effect stays meanwhile. No separate switch action. Proven pattern: the deck already treats a container and its children as one card (`CardDB.lua` `D.containers`, the Choose keyword); on console the engine shows the container | author |
| LH16 | **Finisher:** every card works with no Courage; if the Lionheart has Courage, the card **consumes all of it** and grows stronger per point spent (Lion side: damage, knock down; Maiden side: bigger ward, longer closed jaw). Per-point statuses come from a generator (T3) | author (proposal accepted) |
| LH17 | **Fang and Shield** (the forms' lingering effects): **Lion** — the Lionheart's weapon attacks deal extra damage against the Villain; **Maiden** — the Villain has Disadvantage on attacks against any creature other than the Lionheart. The turn's question: slay the beast faster or shield the party from it. Parked for later levels: double Courage gain (Roar), "the Villain can't move away from you" (Hold) | author (proposal accepted) |
| LH18 | **Combat starts in the Maiden form** (the calm hand before the beast; the party is shielded while the Lionheart closes in) | proposal (stated, not contested) |
| LH19 | **Secondary ability Strength** — the card's own name; no other Arcana uses it; the Lion side shoves, knocks down and leaps (Athletics, jump). Weapon attacks use Strength. Suggested saves STR + WIS (WIS resists fear) — to confirm in the chassis rung | author (proposal accepted) |
| LH20 | **Armour: unarmoured or light** — proficiency in light armour only; no medium, no heavy, no shield. The defence comes from the forms (the Nemean lion's hide read as the Lionheart's own strength): **Maiden** adds AC based on **Strength** (the author confirms an AC boost can use any ability; `T2` only to note the exact boost when building); **Lion** reduces the damage taken. Applies unarmoured or in light armour. Each form now has an offence and a defence: Lion = extra damage vs the Villain + damage reduction (endures the blow); Maiden = the Villain has Disadvantage vs others + STR to AC (turns the blow aside). Revises LH6 and extends LH17. How the forms improve with level: open | author |
| LH21 | **Mastery of the Two Hands:** the forms' base effects stay fixed (LH17, LH20); at odd levels each form gains **one new rule** (K5, M4), e.g. Maiden *Guarding Hand* (reaction: Disadvantage on an attack against an adjacent ally), Lion *Unbowed* (can't be knocked Prone or shoved), later Maiden STR-to-AC shared with adjacent allies, Lion damage reduction also against spells. Examples are drafts; each is settled in the Progression rung. May be paired with a small number step (the STR cap on AC) | author (proposal accepted) |
| LH22 | **Weapons: bladed only** — swords (Shortswords, Scimitars, Longswords, Greatswords, Rapiers) and bladed polearms (Spears, Javelins, Glaives, Halberds, Pikes); no other simple weapons, no hammers, maces, axes or bows. Rapier, Javelin in and Dagger out are the working reading, open to the author's correction | author (option 2, narrowed) |
