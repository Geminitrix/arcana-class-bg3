# 06 · Glossary

> Last verified: **2026-10-02**. In-game name ↔ code name ↔ meaning. Code names in `backticks`.

## Class and lore

| Term | Meaning |
|---|---|
| **Arcana** | The class (in-game name). Mod folder name `AspectClass` is legacy and can't change |
| **Aspect** | A tarot Arcanum embodied by a subclass (Curiosity, Love, Hope, Sorrow); the base class is the Aspect of Mystra |
| **Aspect Awakening** | In-combat transformation of a subclass into its Aspect, in three tiers |
| **Awakening Progress** | Status showing progress to the next tier (`ASPECT_PROGRESS_<X>`) |
| **Awakened I/II/III** | Visible status listing active tier bonuses (`ASPECT_AWAKENED_<X>_I/II/III`) |
| **Aspect card** | The Created card unlocked at Tier I (Leap of Faith, The Veil Lifts, Wish Upon a Star, The Final Toll) |
| **Mystra / the Weave** | Goddess of magic / the fabric of magic; the class's patron and theme |
| **Titan** | Subclass in development (red), based on the tarot's **Strength** (VIII); has a ClassDescription, progression table and icons, and is selectable at level 1 |
| **Spinner** | Subclass in development, based on the tarot's **Wheel of Fortune** (X), **Aspect of Anticipation**; time, cycles and cascading effects. Has a ClassDescription, progression table and icons, and is selectable at level 1 |
| **Secondary ability** | The subclass's own stat beside Intelligence: Unbound DEX, Deceiver CHA, Starchild WIS, Eternal CON |

## Resources

| In game | Code | Meaning |
|---|---|---|
| **Woven Spell Slots** | `ArcanaSpellSlot` (in `SpellSlotsGroup`) | Leveled slots, Long Rest; pay every card out of combat |
| **Threads** | `ArcanaThread` | Per-turn combat energy (PC edition) |
| **Spare Thread** | — | Up to 2 unspent Threads carried to next turn |
| **Bind a Thread** | — | A permanent Thread gain for the combat (vocabulary; no card uses it yet) |
| **Cards in Hand** | `ArcanaHandCard` | Hand counter |
| **Not in Hand** | `ArcanaNotInHand` | Never-granted resource used to lock cards not in hand |
| **Weaving** | `ARCANA_WEAVING` | Combat status that converts slot costs into Threads |
| **SL N** | spell level / slot level | The level a card is cast at; upcast variants are `<card>_N` |

## Deck

| In game | Code | Meaning |
|---|---|---|
| **Deck** | `deck` | Undrawn cards |
| **Frayed** | `frayed` / Thrash | Discard pile; reshuffled when the deck empties |
| **Unravel / Unravelled** | `unravel` / Exile | Gone for the rest of the fight |
| **Reweave** | `Shout_Arcana_Created_Reweave` | First-turn mulligan |
| **Tangle** | `Tangle` | Unplayable junk card shuffled in by strong cards |
| **Unique · Fated · Fleeting · Created · Choose** | `CardDB` keywords | See [02](02-systems.md) §7 |
| **Ready: X** | `Shout_Arcana_Card_Passive_X` | Reaction card that arms a reaction until combat ends |
| **Card marker** | `ARCANA_IS_CARD` in `TargetConditions` | Makes a spell a card (`IsCardSpell()`) |
| **Arcana spell marker** | `ARCANA_IS_SPELL` | Non-card class spell that still counts (`IsArcanaSpell()`) |

## Id prefixes

| Prefix | Kind |
|---|---|
| `<Type>_Arcana_Card_Spell_` | Spell card |
| `<Type>_Arcana_Card_Ability_` | Ability card (pays Threads, outside the deck) |
| `<Type>_Arcana_Card_Passive_` | Passive / reaction card |
| `<Type>_Arcana_Created_` | Created card |
| `<Type>_Arcana_Util_` | Utility |
| `Interrupt_Arcana_Reaction_` / `<Type>_Arcana_Reaction_` | Reaction and its helpers |
| `<Type>_Arcana_` | Helper / sub-projectile |
| `<Type>_Deceiver_Clone_` | Clone-only spell |
| `<Type>_Arcana_Equip_` | Equipment spell |
| `Arcana_Passive_` | Passive (`Arcana_Passive_Equip_` for items) |
| `ARCANA_` | Item stats; Osiris goals, `DB_ARCANA_*`, `PROC_ARCANA_*` |
| UPPERCASE, no prefix | Statuses (`SIGIL`, `STAR_MOONLIT`); hidden ones end `_TECH` / `_HELPER` |

## Subclass terms

| Term | Subclass | Meaning |
|---|---|---|
| **Zephyr Strike** | Unbound | Bonus-action unarmed attack granted after unarmed attacks and Arcane cards |
| **Wind Riposte** | Unbound | Automatic unarmed counter while Wind Whispers is up |
| **Fool's Luck** | Unbound | Tier III: first attack against you each round misses |
| **Sigil / detonation** | Deceiver | Mark that deals stored Psychic when your Arcana spell damages it |
| **Mimic / Mirror** | Deceiver | Bonus-action recast of her last card / the Doubles' half-damage copies |
| **Doubles / Doubt / Deluded** | Deceiver | 1-HP illusions of her (The Veil) / stacking debuff on enemies / the 3rd stack: Confused 1 turn |
| **Which One?** | Deceiver | Tier III reaction card: swap with the nearest Double when an attack would hit |
| **Rejuvenation** | Starchild | Starcall self-buff; makes Astral Infusion free |
| **Moonlit / Sunlit / Eclipse** | Starchild | Awakening riders on allies (Cold / Fire / resistances) |
| **Undying Hope** | Starchild | Tier III: first ally downed regains half HP |
| **Darkness Rise** | Eternal | Tier I aura of decay |
| **Mourning** | Eternal | Tier II: drop to 1 HP once; isolated enemy has Disadvantage |
| **Harvest** | Eternal | Tier III: extra action when a hostile dies within 9 m |
| **Sorrow ledger** | Eternal | Running total of HP lost this fight (goal + Final Toll) |
