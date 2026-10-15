---
id: 26.01/Resonant
owner: Balance Designer
source: 21.04/Resonant/DECISIONS.md (R1–R48), DESIGN.md §4.4, §6, §7, §9
reviewed: 2026-10-15 ARC-0002 — created (propagation, 00.08)
---

# 26.01 · Resource audit — The Resonant

| Resource | Sources | Sinks | Recharge | Balance | Risk | Action |
|---|---|---|---|---|---|---|
| Woven Spell Slots (PC: Threads) | Class level; **refund** when a Surge causes a reaction (R16) | Weave Surges (level-1 cards, upcast for targets), Emotional Contagion and Ready: Compassion (level 3), Shared Heart (level 5) | Long rest (base class) | A reaction refunds one slot, **once per turn**; a reaction needs a mood, which needs an earlier Surge that paid → net cost ≥ 1 slot per reaction pair | No engine: the cap per turn and the paid setup prevent A → B → A | None |
| Threads (PC edition only) | Deck economy (base class) | Every card; Temper and Heartstring 1 Thread (level-0 cards, R45) | Per combat (deck) | As the base class | — | None |
| **Overload meter** | +1 per peak that lands, +2 per reaction (Shared Heart counts once, R19; The Two Cups adds nothing, R38) | *Overloaded* ending (character-level turns) or Emotional Overload (level 5+, Bonus Action) | **Never resets on its own** — carries over between combats (R31) | Fills in ≈ 4 turns at every level (size 3 × slot level + 2) | **Accumulates across a day** → Emotional Overload up to ≈ 3–4 times per day (see `22.05/Resonant.md`) | Watch in the day-long playtest |
| *Overloaded* (cost of a full meter) | Full meter | Time (character-level turns) or Emotional Overload | — | Silenced + Psychic each turn: a real cost before level 5; after 5 the release is instant | Before 5 a long silence can waste a fight — intended pressure (R29) | None |
| Shared Heart | Card | 1 cast | Once per long rest, Unique | Capstone budget | — | None |
| The Two Cups | Tier I Awakening | 1 cast | Once per combat | Field-wide Catharsis, no Overload | — | None |
| Ready: Compassion | Card (reaction resource `ArcanaReactCompassion`) | 1 trigger | Once per round, until combat ends | Reaction slot | Competes with vanilla reactions | None |
| Harmony's free Surge | Tier II | 1 Surge without action | Once per turn | +1 Surge per turn after it wakes | Strong (see `22.05`) | Watch |

## Action economy

| Slot | Users | Conflict |
|---|---|---|
| Action | Weave Surges, Heartstring, Emotional Contagion, Shared Heart, The Two Cups | Normal choice of the turn |
| **Bonus Action** | Temper (3+), Emotional Overload (5+, only while Overloaded) | Rarely on the same turn: Emotional Overload only when the meter is full. Acceptable |
| Reaction | Ready: Compassion; peaks Trust and Anticipation give reactions to **other** creatures | None for the Resonant |
| Concentration | Emotional Contagion only | None |
