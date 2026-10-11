# 57.01 · Mod architecture and choosing the right tool

*Condenses spec Part III §25. Readers: Mod Engineer and every specialist.*

## The layers in plain words
| Technology | What it is | Needs Script Extender? |
|---|---|---|
| Stats (`.txt`) | Data sheets for spells, passives, statuses — almost no code | No |
| LSX (`.lsx`) | XML tables that tie class, levels and lists together | No |
| Khonsu (`.khn`) | Small functions that answer "can I use this now? is this target valid?" (Lua-like) | No |
| Thoth | The library of condition functions the game ships, called inside conditions | No |
| Osiris | Story scripts: IF something happens THEN do something | No |
| Lua (Script Extender) | Powerful scripts reaching engine data and events | **Yes** |

## The least power that solves it
| I want to… | Use |
|---|---|
| Create or change a spell, passive or status | Stats |
| Tie it to the class, levels and lists | LSX |
| A complex or reusable condition (valid target, use requirement) | Khonsu with Thoth functions |
| React to a game event the Stats can't cover | Osiris (or a Lua listener) |
| Change data at runtime, UI, entities, saved variables | Lua (SE) — PC edition only |

## Principles
- **Data before code.** If a Stats field solves it, don't script.
- **Unique prefix on everything global** (Stats entries, Osiris DBs, Lua `ModTable`, SE variables). This
  mod's prefixes are fixed (ADR-0002): `ARCANA_`, `Arcana_Passive_`, `<Type>_Arcana_Card_*`; Lua
  `ModTable` = `ArcanaDeck`.
- **Never edit or overwrite the base game.** Create new entries and inherit with `using`.
- One responsibility per file, with a header citing the ticket and spec.
- **The game is always "multiplayer"** — server and client exist even solo (`57.04`).
- Performance: the server ticks ~30×/s — nothing heavy per tick. No network access from the SE.

## Script Extender is a product decision
Every Lua feature restricts who can play. In this project: **the PC edition uses SE only for the deck
layer** (hand, draw, discard, lock/glow boosts); the **console edition is SE-free**; every gameplay effect
stays in Stats / LSX / Khonsu / Osiris so both editions share it. A new Lua dependency is recorded in
`00.06` and stated on the mod page.
