# 02 · Systems

> Last verified: **2026-10-02** · Sources: `Progressions.lsx`, `ActionResourceDefinitions.lsx`,
> `ActionResourceGroupDefinitions.lsx`, `Status_BOOST.txt` (`ARCANA_WEAVING`), `Passive.txt`,
> `ScriptExtender/Lua/Server/Core/Const.lua`, `Cards/CardDB.lua`, Osiris `ARCANA_Aspect_*.txt`.

How the Arcana pays for, plays and grows its magic. Everything here applies to **all four subclasses**.

---

## 1. Two editions, one set of data

| | **PC / Nexus edition** | **Console edition** |
|---|---|---|
| Script Extender | Yes (Norbyte's SE, Lua) | **No** — nothing it ships may depend on SE |
| Out of combat | Spells cast with Woven Spell Slots | Same |
| In combat | **Deck building**: hand, Threads, piles | Spells cast with Woven Spell Slots, no deck |
| Where effects live | Stats / Osiris / Khonsu (shared) | Same files |
| What Lua does | Only manages the deck: pool, hand, piles, lock/glow, Threads | — |

Rule: **every gameplay effect lives in Stats, Osiris or Khonsu**. A rule that exists only in Lua is a
rule console players don't get. The Toolkit's play mode runs **without** SE, so it behaves like the
console edition.

---

## 2. Spellcasting

- **Spellcasting ability: Intelligence** for the whole class (`ClassDescriptions`: `PrimaryAbility` and
  `SpellCastingAbility` = 4). Subclasses don't override it.
- **Each subclass has a secondary ability**, the one its own kit leans on:

  | Subclass | Secondary ability | Where it shows |
  |---|---|---|
  | Unbound | **Dexterity** | Unarmed attacks (Flowing Strikes), Storm Fists, Gale Deflection, Fool Tier III |
  | Deceiver | **Charisma** | Social skills, Aspect of Doubt (CHA to spell damage), High Priestess Tier III |
  | Starchild | **Wisdom** | Rejuvenation, Lunar Wisp, Cosmic Omen, Star Tier III |
  | Eternal | **Constitution** | Hit points (the Sorrow ledger, Darkness Rise, Final Toll scale with max HP), Death Tier III |

  Each Tier III Aspect gives +3 to the secondary ability. 🎯 Design intent: no tier gives an ability bonus any more (`Rules/class-creation-rules.md` §9); each subclass replaces it with a mechanic of its engine.
- All class spells are **Always Prepared**; nothing is prepared or swapped on rest.
- The base class has picks at levels 1, 2 and 4 (the Weaver Hand list and two utility choices, see
  `03-base-class.md`); every other spell arrives through the progression.

---

## 3. Resources

| Resource | Shown as | Where it comes from | Refills | Used for |
|---|---|---|---|---|
| `ArcanaSpellSlot` | **Woven Spell Slots** | Class progression (both editions) | Long Rest | Every card, outside combat (and always on console) |
| `ArcanaThread` | **Threads** | Lua, as a boost at combat start (PC only) | Each of your turns (Lua) | Every card in combat |
| `ArcanaHandCard` | **Cards in Hand** | Lua, at combat start (PC only) | — | Counter of the hand (display) |
| `ArcanaNotInHand` | **Not in Hand** | Never granted | — | The lock: a card not in hand costs 1 of it, so it can't be cast |
| `ArcanaReactGaleDeflection` | hidden | Ready: Gale Deflection card | Never (only the card) | Gale Deflection charges (max 3) |
| `ArcanaGaleDeflectReturn` | hidden | Unbound level 3 | Short Rest | The ricochet token after a full deflect |
| `ArcanaFoolsLuck` | hidden | Aspect Tier III | Each turn | Once-per-round gate of Fool's Luck |
| `ArcanaReactWhichOne` | hidden | WHICH_ONE_READY (Ready: Which One?, High Priestess Tier III) | Each turn | Which One? once per round |

Loca descriptions:
- **Woven Spell Slots** — *"Lengths of the Weave you hold ready. Each card you cast spends one, whatever its level."*
- **Threads** — *"Threads of the Weave, spent to play cards in combat. They refill at the start of your turn."*
- **Cards in Hand** — *"The cards you are holding. Every card you play spends one; every card you draw gives one back."*
- **Not in Hand** — *"The Arcane card isn't in your hand."*

---

## 4. Woven Spell Slots

A mix of Warlock and Wizard: **all slots share one level, which rises every two character levels**
(Warlock), but there are **many** of them (Wizard).

| Character level | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| **Slot level** | 1 | 1 | 2 | 2 | 3 | 3 | 4 | 4 | 5 | 5 |
| **Slots** | 2 | 4 | 6 | 7 | 9 | 10 | 11 | 12 | 14 | 15 |

| Character level | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
|---|---|---|---|---|---|---|---|---|---|---|
| **Slot level** | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| **Slots** | 16 | 16 | 17 | 17 | 18 | 18 | 19 | 20 | 21 | 22 |

- Granted on the **base class** table: a band change grants the new total at the new level followed by
  `ActionResourceOverride(ArcanaSpellSlot,0,<previous level>)`; levels inside a band add +1.
- `ArcanaSpellSlot` is a member of the vanilla `SpellSlotsGroup` (the mod's
  `ActionResourceGroupDefinitions.lsx` lists it in the group, UUID `03b17647-…`). Card costs read
  `SpellSlotsGroup:1:1:N` (four parts: group, min, max, slot level).
- **Cantrips cost no slot.** Utilities (`Arcana_Util_`) cost only their action.
- Restored by **Arcane Recovery** (1 slot) and **Arcane Overflow** (level 14).

### Upcasting

- Every card scales with the **level of the slot spent**, like base-game spells. A level-1 card cast by
  a level-9 Arcana uses a level-5 slot and deals its Spell Level 5 values.
- Each card has generated upcast variants `<card>_N` (226 for 60 cards), produced by
  `82_Automation/stats/gen_upcast_variants.pl`. The engine picks the variant matching the slot the character has.
  Variants start at the first slot a card can ever see (`FIRST_SLOT` in the generator): a card granted at
  character level G never meets a slot below ceil(G/2), so the Mimic options start at `_4`, Hollow Image at
  `_6` and so on. The card keeps its `Level`, which is also its Thread price; its own base values go unused.
  G is read from the files: the progression's direct grant if there is one; otherwise the lowest grant
  that reaches the card through stats references or `CardDB` `conjures`; a container child takes its
  container's G (the Mimic options are conjured by level-1 cards but live in the level-7 Mimic).
  The same G drives the `ARCANA_CardFamilies` rows. Utilities with upcast (Guidance) are hand-made.
- Damage and healing usually grow **one die per spell level** above the card's own level; some cards
  step every two levels (Gale Burst). Each variant can be hand-tuned (the generator keeps hand edits),
  so the per-level values live in each subclass file.
- Effects that are a status (Ethereal Chains, Blood Offering, Storm Fists, Flow State…) have one status
  version per spell level; a higher one replaces a lower one.
- Slots stop at level 6 (character level 11): every card's ceiling is its Spell Level 6 value.
- **Cantrips** (Malicious Whispers) and the Sigil mark scale with
  **character level** (`LevelMapValue`), as cantrips do in the base game.

---

## 5. Spell taxonomy (what kind of spell is this?)

The prefix in the spell's id decides how the deck treats it.

| Kind | Id format | In the deck? | Cost | Examples |
|---|---|---|---|---|
| **Spell card** | `<Type>_Arcana_Card_Spell_X` | Yes | Slot of its level / X Threads | Sigil of Malice, Starcall |
| **Ability card** | `<Type>_Arcana_Card_Ability_X` | No (pays Threads, stays out of the deck) | Slot / Threads | Untethered |
| **Passive card** | `<Type>_Arcana_Card_Passive_X` | Yes | Slot / Threads | Mirrored Spell, Lunar Wisp, Ready: Gale Deflection |
| **Created card** | `<Type>_Arcana_Created_X` | Never — made during combat | Usually slot / Threads | Withdraw, Mimic, Zephyr Strike, Aspect cards, Reweave |
| **Utility** | `<Type>_Arcana_Util_X` | Never; locked in combat | Action only (Guidance: slot + ritual, see base class) | Arcane Hand, Third Eye, Faceless, familiars |
| **Reaction** | `Interrupt_Arcana_Reaction_X` + helper spells | Never | Its charge resource + reaction | Gale Deflection, Which One? |
| **Helper** | `<Type>_Arcana_X` | No | — | Distortion explosion, Wind Riposte |
| **Clone spell** | `<Type>_Deceiver_Clone_X` | No | — | Mirror: Sigil of Malice |
| **Vanilla granted** | (vanilla id) | No; locked in combat | — | Light (Starchild), True Strike (Unbound) — listed in `CardDB.vanillaGranted` |

Markers read by Khonsu (`Scripts/thoth/helpers/`):
- **`ARCANA_IS_CARD`** in a spell's `TargetConditions` → `IsCardSpell()`. This is what makes a spell a card.
- **`ARCANA_IS_SPELL`** → non-card Arcana spells that must still count (Distortion explosions, clone
  Sigil, Gale Deflection ricochet, Friends, Dispel Magic, Dead Whispers, Arcane Lock/Unlock).
- `IsArcanaSpell()` = either marker. Detonates the **Sigil**, feeds **Mirrored Self**.

**Weapon actions are cards too** (PC edition): any spell with `IsDefaultWeaponAction` (Cleave, Piercing
Shot…). Unique, 0 Threads, keep their own cooldown, exiled when played. **The basic attack is never a
card** — a bad hand can always swing.

---

## 6. The deck (PC edition)

Outside combat nothing changes: spells are spells. When a fight starts, they become cards.

| Rule | Value |
|---|---|
| Deck source | Every card in the spellbook, automatically; new cards join by being learned |
| Copies | **3** per card; **1** for Unique cards (can be set to 0) |
| Minimum deck | **10** cards (levels 1–8), **15** (level 9+) |
| Editing copies | Outside combat only; for now through the SE console (`!arcanaset`) — no in-game editor |
| Opening hand | **4** |
| Draw | **1** at the start of each of your turns |
| Hand limit | **10**; a card drawn past it is **Unravelled** |
| Hand between turns | Kept |
| What you can cast in combat | Only cards in hand. Utilities and vanilla-granted spells are locked until the fight ends |

### Threads per turn

`Threads(turn) = min(ceiling, turn + start)`, then bonuses on top.

| Character level | Turn 1 | Turn 2 | Turn 3+ (ceiling) |
|---|---|---|---|
| 1–4 | 1 | 1 | 2 |
| 5–6 | 1 | 2 | 3 |
| 7–8 | 2 | 3 | 4 |
| 9–10 | 3 | 4 | 5 |
| 11–20 | 4 | 5 | 6 |

- **Card cost = its spell level** in Threads (`X = N`). **Cantrips cost 1 Thread.**
- **Spare Thread:** up to **2** unspent Threads carry to the next turn.
- **Cap:** never more than **6** Threads. Permanent gains (*Bind a Thread*) and temporary gains stack
  above the band ceiling, limited only by the cap.
- In combat the status **`ARCANA_WEAVING`** (applied by Lua, never on console) zeroes the slot cost of
  every card and adds X Threads — one boost per spell level, read through `IsCardSpell() and IsSpellLevel(n)`.

### Piles

| Pile (in game) | Code name | What goes there |
|---|---|---|
| **Deck** | deck | Cards not yet drawn |
| **Frayed** | `frayed` (Thrash) | Most played cards. Shuffled back into the deck when the deck runs out |
| **Unravel** | `unravel` (Exile) | Gone for the fight: created cards, weapon actions, hand overflow, cards whose effect lasts all day |

**The card decides its pile.** A `destination` in `CardDB` beats every keyword and default. Two moves
stay outside that rule: hand overflow always goes to Unravel, and Reweave returns the hand to the deck.

### How the lock works (why the deck is safe)

The deck **never adds or removes spells**. Every card stays in the spellbook and on the hotbar.
- A card **not in hand** gets `UnlockSpellVariant(…ModifyUseCosts(Add,ArcanaNotInHand,1,0)…)` — an
  unpayable cost — and the game greys it out on every route (hotbar, sheet, shortcut).
- A card **in hand** gets a glow boost.
- Worst case of any bug: a card wrongly greyed out, never a spell lost.

---

## 7. Keywords

| Keyword | Meaning | Status |
|---|---|---|
| **Unique** | Max 1 copy. Rule of thumb: a card with its own cooldown is Unique | In use |
| **Fated** | Always in the opening hand; always also Unique | Implemented (debug card only) |
| **Fleeting** | Leaves the hand at the end of the turn if not played | Implemented (debug card only) |
| **Created** | Made during combat by another card or status; lasts a set number of your turns | In use |
| **Choose** | Pick 1 of several options when played (Hemoplague: 6 diseases, a native spell container) | In use |
| **Tangle** | A strong card shuffles an unplayable knot into the deck | Implemented (debug card only) |
| **Reweave** | Mulligan: on your first combat turn only, return the hand, shuffle, draw the same number. Free | In use |
| **Echo, Invoke, Foresee, Landmark, Mantle, Refine, Bind a Thread** | Approved vocabulary, not implemented | ❓ [07](07-open-questions.md) |

---

## 8. Reaction cards

Every reaction has a **per-round limit**, which is also the maximum of its charge resource, and every
use costs one charge plus the reaction.

| Reaction | Card | Limit per round | Subclass |
|---|---|---|---|
| Gale Deflection | Ready: Gale Deflection (L2) | 3 | Unbound |
| Which One? | Ready: Which One? (L3, Unique, conjured at High Priestess Tier III) | 1 | Deceiver |

- **Console:** the card is cast; it applies `<X>_READY` (until combat ends) and adds one charge.
- **PC:** the card is never cast. **Holding it in hand is the charge**; when the trigger happens the
  game asks, and using it discards one copy.

---

## 9. Passive cards

A card that switches on a passive applies a status with duration −1, `RemoveOnLongRest` and
`RemoveEvents OnCombatEnded`; the status's `Passives` grants a hidden passive. Text: *"Until your next
Long Rest or until combat ends, you gain X."* These cards are Unique and go to Unravel when played.
Used by: Mirrored Spell, Lunar Wisp, Immortal Blood, Inescapable Destruction, Unbroken, Inured to Undeath.
(Mirrored Self lasts only until the end of your turn.)

---

## 10. Aspect Awakening

Each subclass **awakens its tarot Aspect in the middle of a fight** by meeting an objective. Inspired by
Legends of Runeterra's champion level-up; the subclass is the champion.

- **Three tiers, cumulative**, unlocked by level: **Tier I at 3, Tier II at 7, Tier III at 12** (the
  core of the class must fit a game that ends at 12).
- **Each tier has its own goal.** Reach a goal and that tier awakens; tiers stack and last **until
  combat ends**. Progress is counted in **Osiris**, so it works in both editions.
- **Tier I also gives the Aspect card** (Created, 0 Threads, 0 slots, costs the action, once per combat)
  and the Aspect VFX.
- At level 3 every subclass gets a visible **"N - Arcanum: Awakening"** passive that explains the goals;
  the tier passives themselves are hidden. While awakened, a status **"N - Arcanum: Awakened I/II/III"**
  lists every active bonus. **Awakening Progress** shows the way to the next tier (count for Fool and
  Empress, percent for Star and Death).

| Aspect | Objective | Goals (L3 / L7 / L12) | Aspect card |
|---|---|---|---|
| **0 - The Fool** (Unbound) | Strike different enemies within one round (reactions count). If fewer enemies stand at turn start than the goal, any hit counts | **3 / 4 / 5** enemies | Leap of Faith |
| **2 - The High Priestess** (Deceiver) | Apply Doubt during the fight | **4 / 7 / 10** stacks | The Veil Lifts |
| **17 - The Star** (Starchild) | Heal allies (overhealing doesn't count) | **5× / 8× / 12×** your level in HP | Wish Upon a Star |
| **13 - Death** (Eternal) | Lose HP during the fight; healing doesn't undo it | **30% / 50% / 70%** of max HP | The Final Toll |

Tier contents are in each subclass file. Technical pieces: Osiris `ARCANA_Aspect_Common.txt`
(`DB_ARCANA_AspectTier`, `DB_ARCANA_AspectReached`, `PROC_ARCANA_Aspect_*`) plus one goal per Aspect;
statuses `ASPECT_AWAKENED_<X>` (hidden, Tier I reached) and `ASPECT_AWAKENED_<X>_I/II/III` (visible, same
StackId, each carries all bonuses up to it); stats patches in `93_Old_Versions/2026-10-11_design_archive/aspect/*.patch` (applied). The goal tables
(`DB_ARCANA_Aspect`, `AspectTier`, `AspectShow`) are cleared and refilled on every save load, so changing a
goal value reaches existing saves.