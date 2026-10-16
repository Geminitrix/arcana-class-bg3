---
id: 26.01/Deceiver
owner: Balance Designer
source: 21.04/Deceiver/DECISIONS.md (DV1–DV30), DESIGN.md §4, §5, §10
reviewed: 2026-10-16 ARC-0019 — created (propagation, 00.08); the build's changes (DV18–DV30) below, values in 25
---

# 26.01 · Resource audit — The Deceiver

| Resource | Sources | Sinks | Recharge | Balance | Risk | Action |
|---|---|---|---|---|---|---|
| Woven Spell Slots (PC: Threads) | Class level | Eidolon, Seed of Doubt (level 1); Binding Falsehood, Veiled Prison (2); Veilstep, Withdraw, Mirrored Spell, Ready: Which One? (3); Marionette, Grand Deception (5) | Long rest (base class) | No refund loop: nothing returns a slot | — | None |
| Threads (PC edition only) | Deck economy (base class) | Every card; Malicious Whispers is a level-0 card | Per combat (deck) | As the base class | — | None |
| **Doubles** (the Presence resource) | Eidolon (1 / 2 / 3 by slot), Veilstep (1), Grand Deception (to the cap) | Splinter, an enemy hit or area, Dismiss, the cap (oldest goes), Ready: Which One?, The Veil Lifts | Combat end, Long Rest or her death clears them | Each Double costs part of a card and gives +1 AC and one action a turn while it lives | Five Doubles = five extra actions a turn; the brake is that any hit ends one | Watch (`22.05`) |
| **Doubt** (on enemies) | Every lie believed: a Double destroyed by an enemy, a Splinter, a Seed bursting, Malicious Whispers on a Seeded target; Grand Deception; Which One? | Deluded at the third stack (stacks reset); time | Expires after a few turns, refreshed by each stack | A counter, not a currency: nothing of hers is spent on Doubt | Chains end: Doubles are finite, Deluded resets, Two Pillars once per turn (DESIGN §4.6) | None |
| **Seed** (on enemies) | Seed of Doubt, Reflected Seed, Two Pillars (Tier II) | Her next Arcane spell damage on the target; The Veil Lifts | 6 turns | One burst per Seed | Twice-Told on Seed of Doubt lays a second Seed in the same turn | Watch |
| Veiled Prison | Card | 1 cast | Once per Short Rest, Unique | — | — | None |
| Marionette · Grand Deception | Cards | 1 cast each | Once per Long Rest, Unique | Capstone budget | — | None |
| The Veil Lifts | Tier I Awakening | 1 cast | Once per combat | Spends every Double and Seed at once | — | None |
| Ready: Which One? | Tier III (reaction resource `ArcanaReactWhichOne`) | 1 trigger | Once per round | Spends a Double for a miss | Competes with vanilla reactions | None |
| Unveil | Two Truths → Unveil passive (level 9) | A Double's action | Once per round across all Doubles | — | — | None |

## Action economy (today's game)

| Slot | Users | Conflict |
|---|---|---|
| Action | Her cards; each Double's own action on its own turn | Normal choice of the turn |
| Bonus Action | Withdraw (5+), Mimic (7+) | Rarely the same turn; acceptable |
| Reaction | Ready: Which One? (Tier III) | Competes with vanilla reactions |
| Concentration | Friends (below slot 6), Veiled Prison, Marionette | Two control cards share Concentration — a real choice |

## After the ARC-0019 build (DV18–DV30, approved 2026-10-16)

| Resource | Change |
|---|---|
| **Doubles** | New sink at level 2: *Shatter on command* (bonus action, DV24) — spend a body now or keep its AC and its turn. At Tier III a Double destroyed by an enemy also splinters, wider (DV21): every loss becomes a burst |
| **Doubt** | Grand Deception gives Doubt per Double already near each enemy instead of a flat amount (DV22): the Doubles placed before the ultimate are its fuel |
| **Tier III** | No ability bonus; the power is the Tier III burst (DV21) |
| **Utility** | Telepathy leaves (DV26); Faceless and Friends move to level 2 |

| Slot (after the build) | Users | Conflict |
|---|---|---|
| Bonus Action | Shatter on command (2+), Withdraw (5+), Twice-Told (6+) | Three options from level 6 — a real choice each turn; watch that Shatter on command is not always the answer (V1) |
| Reaction | Ready: Which One? (Tier III) | As today |
