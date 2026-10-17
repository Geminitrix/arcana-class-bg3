---
id: 21.04/Starchild/DESIGN
owner: Lead Class Designer
state: approved design (SC0–SC32, 2026-10-16). The game still has the 3.1 kit (`05.02/Starchild.md`) until the build ticket ships
reviewed: 2026-10-16 ARC-0023 — written from DECISIONS.md (SC0–SC32) and REFINE_Starchild.md; 2026-10-17 ARC-0025 — R1–R4 sizes (SC33–SC36): the Sun brake (SC33); sizes in 25
---

# The Starchild — XVII · The Star · Aspect of Hope

> Design document for the Arcana's subclass **The Starchild**: identity, the Hymns, Dusk and Nightfall and every one
> of their rules, every card and passive, the Aspect Awakening, the progression and the technical pattern. Decisions
> are in `DECISIONS.md` (SC0–SC32); the review behind them is `REFINE_Starchild.md` (ARC-0023). Every gameplay effect
> lives in Stats, Osiris and Khonsu, so the subclass runs in **both editions**.
>
> **Numbers live in `25_Master_Data`** (ADR-0005). Where a value is needed this document says ‹…› or *(25)*; the
> Starchild's YAML files are written in the balance pass (§12). Thresholds, level placement and rules are design.

---

## 1. The subclass in one page

The Starchild is the Arcana who **heals** — high, focused healing first, support second (SC0). Each dawn she sings a
**Hymn** to one light — the **Stars**, the **Sun** or the **Moon** — and that light shapes everything she does that
day: the Stars heal one ally hard, the Sun's healing spills over the party, the Moon's comes in a tide.

When an ally drops below half their hit points, **Dusk** falls on them; below a quarter, **Nightfall**. Her next heal
on that ally **answers** the mark and is stronger for it — answering Nightfall brings the **Dawn**, her greatest heal.
Wait too long and the ally falls, and a fallen ally carries no mark.

Her question every turn is the axis **Timing**: *when do I heal, and whom?* (SC7). Hope shines brightest in the
darkest hour.

**Fantasy:** *"A healer whose magic is starlight given purpose."*
**Role:** healer and support; exploration utility out of combat.

---

## 2. Identity

### 2.1 The card — XVII · The Star

Hope and healing after disaster; the light that guides. A figure pours water from two jugs, onto the land and into
the pool, under one great star and seven small ones. In the tarot sequence **The Star (XVII)** is followed by
**The Moon (XVIII)** and **The Sun (XIX)** — the three lights of her Hymns. *To cite to Waite (1910) for DM-S7.*

| Reading / image | Becomes |
|---|---|
| Hope after disaster | Dusk → Nightfall → Dawn; the Awakening wakes only when the party is in danger (SC17) |
| The figure pouring her jugs | **Outpouring**, the signature heal; the ultimate **Elpis' Jar** |
| The great star | **The Great Star**, the Aspect card |
| The light that guides | **Guiding Light** (Polaris) |
| Star, Moon, Sun in sequence | the three **Hymns** |

### 2.2 The Aspect — Hope

Playing the mechanic *is* hope: catching an ally in their darkest hour and bringing the dawn. The rule rewards the
moment things look worst, and its cost — waiting — is the tension of a healer.

### 2.3 Mystra and the Weave

*"Mystra wove the Starchild from the light that remains after disaster, a thread of hope that never stops shining."*
(`31.01` §5). Weave in the mechanic: **Tether** pulls an ally by a thread of the Weave.

### 2.4 References

| Source | Lends |
|---|---|
| **Soraka** (League of Legends) | a healer who pays with her own life (Outpouring's HP cost), a global wish (the ultimate). Her ability names are not used (SC15) |
| **Lux** (League of Legends) | nothing any more — Lucent Singularity and Final Spark left the kit (SC26, SC27) |
| **Hesiod**, *Works and Days* | **Elpis**, Hope left in the jar → Elpis' Jar |
| **Hesiod**, *Theogony* | **Hesperus**, the evening star, and **Eosphorus**, the dawn-bringer → Hesperus, Dawnbringer, Daystar |
| **Orphic Hymns** to the Stars, to Helios, to Selene | the three **Hymns** (to verify for DM-S7) |
| Real sky | eclipse (the stars come out by day), sun dog, moon ring, blue and golden hour, nova → names and Eclipse (§5, §8) |

### 2.5 Identity Sheet

| Field | Answer |
|---|---|
| Archetype | A celestial healer who sings to the sky each dawn |
| Specialist or versatile | Specialist: healer; support and exploration utility around it |
| Play style | Reads the party's hit points; chooses whom to answer and when to wait |
| Combat style | Back line, 9–18 m; bonus-action heal every turn; turn 1 sings (if Unsung) or strikes with Comet |
| Strengths | The strongest healing of the class; revival; cleansing; defence for the wounded; exploration skills |
| Weaknesses | Low damage; needs allies in danger to awaken; a fallen ally loses the mark; Fire-resistant days hurt the Sun |
| Colour, emoji, VFX | Blue `#79baf8` · 🌟 · Bless |
| Is not | an oracle (divination is the base class's), a damage caster, a frontliner |

---

## 3. Chassis

Unchanged from the game (`05.02/Starchild.md` §2): Intelligence spellcasting, Wisdom secondary; saves Wisdom and
Constitution; Light and Medium armour, Shields; simple weapons of the current list; skills *The Shaman*; Druid sound
set. Open: the ability preset still gives INT 10 (`10.06` row 12).

---

## 4. The mechanic

### 4.1 The Hymns (level 1)

- **Sing a Hymn** (utility, once per long rest): she chooses **Hymn of the Stars**, **Hymn of the Sun** or **Hymn of
  the Moon** and gains its visible status until the next long rest (SC2, SC3).
- **Unsung:** after a long rest, until she sings — *"Your light flickers, dim and waiting. Sing a Hymn to choose your
  light."* While Unsung every card's children are locked; Sing a Hymn works in combat as a **bonus action** (SC5, SC23).
- **Every card is a container** with three children — Stars, Sun, Moon — locked by the Hymn sung; same icon, the
  container on a neutral base name, each child its own name (SC22, SC24, SC32).
- **The Stars sharpen, the Sun spreads, the Moon lingers** (SC21). On heals (SC6): **Stars — focused** (the largest
  heal on one ally); **Sun — radiant** (a share ‹…› spills to allies nearby; the light burns enemies next to the
  target); **Moon — tidal** (part now, the rest at the start of the next ‹2› turns; whoever attacks the ally is chilled
  and slowed). The Sun's heal on its main target stays well below the Stars' (SC33); its total over the party may be higher.

### 4.2 Dusk, Nightfall and Dawn (Dusk at 1, Nightfall at 5)

| Ally's HP | Mark |
|---|---|
| above ‹½› | none |
| ‹¼›–‹½› | **Dusk** |
| below ‹¼› | **Nightfall** (replaces Dusk; one StackId) |
| 0 (Downed) | none |

- A mark appears on each **downward crossing** of a threshold. Rising above ‹¼› turns Nightfall into Dusk; rising
  above ‹½› removes it, whatever the healing source (SC10).
- **Her heal answers the mark** and consumes it: a heal on Dusk is ‹stronger›; on Nightfall it brings **Dawn** — the
  strongest heal and the Hymn's effect at its peak (SC8, SC10). After an answer, no new mark until the next downward
  crossing.
- **Downed clears the mark** (SC11). Raising a Downed ally is a plain heal; reviving the dead is Rekindle's job.
- **Only allies** carry marks until level 10. From level 10 (**Light in the Dark**) she can fall into Dusk / Nightfall
  herself: her own mark is **not** consumed by heals, and while she carries it **the heals she gives are ‹stronger›**.
  Her bonus plus the target's mark never exceed Dawn (SC12).

### 4.3 The first heal of the turn

The Awakening's Tier II condition and Tier III Eclipse ride only on **the first heal she casts on a single ally** each
turn (SC19). Area heals (Elpis' Jar, the Sun's spill, Flare) and the Moon's tide pulses never count. Gate: the
empowered heal gives her a hidden status for 1 turn (`TickType StartTurn`), and the effect requires its absence.

### 4.4 Gears

| Creates marks | Changes the rule | Spends marks | Reads marks |
|---|---|---|---|
| damage · Undying Hope · Rekindle | Long Twilight · Dawnbringer | every heal · Hesperus · Cleansing Rain · Flare · Elpis' Jar | Halo · Tether · Guiding Light · Stillness · Comet · the Awakening |

### 4.5 Both sides of the field

Allies carry the marks and receive every heal. Enemies are struck by Comet and Flare, marked by Guiding Light, held by
Stillness, and receive the Tier II conditions through her allies' hits. No rule puts a harmful state on an ally.

### 4.6 Resolution order

1. Damage lands → the ally's HP is read: Undying Hope (Tier I, once per fight) catches a blow that would bring them to
   0 — they stay at 1 HP in Nightfall; otherwise Downed clears any mark.
2. A downward crossing applies Dusk or Nightfall.
3. Her heal resolves: the mark's bonus → the Hymn's shape → the first-heal gate (Tier II condition / Eclipse) → the
   mark is consumed → the Awakening counts it (Dusk 1, Nightfall 2).
4. The healed HP never re-applies a mark (marks come only from downward crossings).

### 4.7 Worked example (level 7, Hymn of the Sun, Tier II awake)

The Fighter takes a hit and drops to 20% — **Nightfall**. The Rogue is at 40% — **Dusk**. On her turn the Starchild
casts **Noonday Pour** (Outpouring, Sun) on the Fighter: Dawn, the strongest heal; a share spills to the Rogue (no
answer — a spill doesn't consume marks); the goblins next to the Fighter burn; it is her first heal of the turn, so the
Fighter's next hit sets **Burning** (Tier II). The Awakening counts 2. She keeps her action for Comet, or for
**Cleansing Rain** on the Rogue to answer the Dusk too (+1).

### 4.8 Edge cases

- A heal from someone else (potion, another healer) never answers a mark; it only moves the ally across thresholds.
- Long Twilight moves the Dusk threshold to ‹⅔› for allies in its area; Blue Hour also moves Nightfall to ‹⅓›.
- Rekindle and Undying Hope put an ally straight into Nightfall.
- Hesperus answers on the enemy's turn with its reaction; it counts for the Awakening.

---

## 5. Cards

All cards are containers (§4.1). Levels are card levels (slot level). Ranges and values *(25)*.

| Card (container) | Lvl · gained | Cost | Effect | Stars | Sun | Moon |
|---|---|---|---|---|---|---|
| **Comet** | 1 · 1 | Action | 18 m radiant spell attack; target slowed ‹…› 1 turn; on a hit she gains **Afterglow** (regain HP each turn end; her next Outpouring is free) for ‹2› turns, ‹+1› turn if the target stands next to a marked ally | **Shooting Star** — ‹more› damage | **Sunspark** — radiant splash on enemies within ‹2› m | **Crescent Dart** — half movement for ‹2› turns |
| **Outpouring** (signature) | 1 · 1 | Bonus Action | 9 m heal on an ally; costs ‹10%› of her max HP unless she has Afterglow; not castable at ≤ ‹11%› HP. Rank I (1) answers Dusk · rank II (5) answers Nightfall with Dawn · rank III (10) her own Dusk empowers it | **Lodestar Balm** — focused | **Noonday Pour** — radiant | **Rising Tide** — tidal |
| **Hesperus** | 1 · 2 | card-passive, Unique, Unravel | Until long rest or combat ends: when an ally within ‹18› m falls into Dusk or Nightfall, **reaction**: a ‹small› heal that answers the mark. Reaction charge refilled by the card | **Hesperus** — ‹bigger› | **Last Ray** — also heals ‹a little› allies within ‹3› m | **Moonrise** — comes as a tide |
| **Cleansing Rain** | 2 · 3 | Action, short-rest cooldown, Unique | Remove ‹one› condition from an ally; on a marked ally answer the mark, remove every condition of the current Solar Purge list and heal ‹a little› | **Starwater** — the heal ‹bigger› | **Sunshower** — also ‹one› condition off allies within ‹3› m | **Moondew** — the removed conditions can't return for ‹2› turns |
| **Rekindle** | 3 · 5 | Action, long-rest cooldown, Unique | Revive a dead ally at ‹low› HP **in Nightfall** | **Nova** — ‹more› HP | **Phoenix Light** — a burst heals allies within ‹3› m ‹a little› | **New Moon** — a tide for ‹2› turns |
| **Halo** | 2 · 6 | Bonus Action | 18 m, ‹3› turns, no Concentration: ‹+AC› to an ally **while in Dusk or Nightfall** | **Starshield** — ‹+1› more | **Corona** — an enemy that hits the ally is set Burning | **Moon Ring** — ‹2› turns longer |
| **Guiding Light** | 3 · 6 | Action | Mark an enemy for ‹N› turns, no Concentration; allies in Dusk / Nightfall who hit it regain ‹X› HP | **Polaris** — ‹bigger› | **Sun Dog** — jumps to the nearest enemy when it dies | **Moonpath** — ‹2› turns longer, the enemy is slowed |
| **Elpis' Jar** (ultimate) | 4 · 7 | Bonus Action, once per combat, Unique | Heals every ally within ‹18› m and **answers every mark at once** (Nightfall → Dawn, Dusk → strong, unmarked → plain) | **Wishing Star** — marked allies' heals ‹bigger› | **Midsummer** — radius ‹larger› | **Harvest Moon** — every ally healed keeps a tide |
| **Tether** | 4 · 9 | Action | Pull an ally ‹X› m toward her, no opportunity attacks; a marked ally also ends Stun / Restrained / Paralysed | **Starline** — the ally ‹+AC› until their turn | **Solar Wake** — enemies next to the ally's start are set Burning | **Undertow** — those enemies get half movement |
| **Stillness** | 5 · 9 | Action | 18 m, ‹6› m zone for 1 turn: enemies inside Silenced; still inside at the end, Restrained; an enemy inside attacking a marked ally has Disadvantage | **Fixed Stars** — Restrain save ‹harder› | **High Noon** — zone ‹larger› | **Midnight** — Silence ‹1› turn longer |
| **Long Twilight** | 5 · 10 | Action | Allies within ‹6› m for ‹N› turns: Dusk begins at ‹⅔› | **Blue Hour** — Nightfall begins at ‹⅓› | **Golden Hour** — radius ‹larger› | **Long Night** — ‹longer› |
| **Flare** | 6 · 11 | Action, no cooldown (3 copies) | 18 m, ‹3› m radius, DEX save: Fire and Burning; allies in the area in Dusk / Nightfall are answered | **Supernova** — ‹more› damage on the centre target | **Solar Flare** — radius ‹larger› | **Moonburn** — Burning ‹longer›, the burnt slowed |
| **Dawnbringer** | 6 · 12 | Action, long-rest cooldown, Unique | For ‹N› turns, every heal she casts on an ally in Dusk answers as if it were Nightfall | **Daystar** — Dawn ‹bigger› | **Sunrise** — the Sun's spill ‹wider› | **Moonset** — ‹longer› |

### 5.1 Utilities (outside the PC deck)

| Utility | Lvl | Effect | Stars | Sun | Moon |
|---|---|---|---|---|---|
| **Sing a Hymn** | 1 | §4.1 | Hymn of the Stars | Hymn of the Sun | Hymn of the Moon |
| **Lantern** (cantrip) | 2 | She becomes the light until a long rest; **no effect in combat**; a ‹bonus› below Weaver Hand: Guide, for her and allies within ‹6› m | **Wayfinder** — medium light; Perception, Investigation | **Noonlight** — the largest bright light; Insight, Persuasion | **Moonshadow** — dim small light; Deception, Sleight of Hand |

### 5.2 Aspect card

**The Great Star** (Created at Tier I, 0 Threads, once per combat; Stars only, no children): a star over the field for
‹N› turns answers the marks with the Stars' focused heal (SC16). It answers over time; the ultimate answers at once.

---

## 6. Passives

| Passive | Lvl | Effect |
|---|---|---|
| **17 - The Star: Awakening** | 3 | Teaches the goal (§8) |
| **Nightfall** (taught with Outpouring rank II) | 5 | §4.2 |
| **Light in the Dark** | 10 | Her own Dusk / Nightfall empowers the heals she gives (§4.2) |
| **Undying Hope** | Tier I | Once per fight, the first ally who would drop to 0 stays at 1 HP in Nightfall (vanilla Death Ward pattern) |

---

## 7. Statuses

| Status | On | Visible | Notes |
|---|---|---|---|
| Hymn of the Stars / Sun / Moon | her | yes | until long rest; locks / unlocks children |
| Unsung | her | yes | until she sings |
| Dusk / Nightfall | ally (her from 10) | yes, on the portrait | one StackId; Osiris applies on downward crossings |
| Afterglow | her | yes | from Comet |
| Dazzled | enemy | yes | `RollBonus(Attack,-1d4)` (vanilla Bane without the saves) |
| First-heal gate | her | hidden | 1 turn, `TickType StartTurn` |
| Tide (per card) | ally | yes | Moon's healing over ‹2› turns |
| Halo, Guiding Light, Long Twilight, Hesperus ready | as the card | yes | the card-passive rule for Hesperus |
| Lantern (three) | her | yes | until long rest; off in combat |
| Awakened I / II / III, Eclipse | her | yes | `ASPECT_AWAKENED_STAR_*` family |

---

## 8. Aspect Awakening — 17 · The Star

**Goal — answer the marks.** Answering Dusk counts 1, Nightfall 2 (SC17); tier goals ‹3 / 5 / 8› *(25)*. Countdown
status COUNT type (ARC-0007). Hope wakes only when the party is in danger.

| Tier | Level | Gives (until combat ends) |
|---|---|---|
| I | 3 | **The Great Star** card · **Undying Hope** |
| II | 7 | The first heal of the turn passes the Hymn's condition to the ally's next hit on an enemy: **Dazzled** (Stars), **half movement** (Moon), **Burning** (Sun) — no damage; ‹1–2› turns |
| III | 12 | **Eclipse** — the first heal of the turn joins **all three** shapes and passes **all three** conditions. In an eclipse the stars come out by day |

---

## 9. Progression

### 9.1 Level table

`21.03/Starchild.md` (SC29).

| Lvl | Arrives |
|---|---|
| 1 | Sing a Hymn · Dusk · Comet · Outpouring I |
| 2 | Lantern · Hesperus |
| 3 | Awakening Tier I (The Great Star, Undying Hope) · Cleansing Rain |
| 4 | — (feat) |
| 5 | Outpouring II (Nightfall, Dawn) · Rekindle |
| 6 | Halo · Guiding Light |
| 7 | Tier II · Elpis' Jar |
| 8 | — (feat) |
| 9 | Tether · Stillness |
| 10 | Outpouring III (Light in the Dark) · Long Twilight |
| 11 | Flare |
| 12 | Tier III Eclipse · Dawnbringer |

### 9.2 The signature button in ranks — Outpouring

| Rank | Level | Does |
|---|---|---|
| I | 1 | heals; answers Dusk |
| II | 5 | answers Nightfall with Dawn |
| III | 10 | her own Dusk empowers it |

### 9.3 The arc

Introduce 1–3 (the Hymn, Dusk, Hope awakens) · develop 5–7 (Nightfall and Dawn, shelter, the jar) · **turn 9–10**
(she steps into the dark herself) · conclude 11–12 (Flare, Eclipse, Dawnbringer — the dawn).

---

## 10. How it plays

Morning: sing the Hymn for the day ahead (seek, talk or deceive with Lantern; the light for the fights). In a fight:
Comet for Afterglow, Outpouring every turn, and the choice — answer the Dusk now, or hold for Nightfall and Dawn,
knowing a fallen ally loses the mark. The first heal of each turn goes to the ally who will make it count.

---

## 11. Text

Names: §5 (SC32). Voice: the class description of `31.01` §5 still fits; the Narrative gate may add the Hymns. Every
description follows the BG3 writing style (British spelling). Vanilla-name check before the gate.

---

## 12. Balance notes (for the balance pass)

- The three Hymns must be equally viable (SC4): situational niches — Stars one ally under focus, Sun spread damage,
  Moon long fights.
- Price the best case: the first heal on a Nightfall ally under Eclipse = Dawn + three shapes + three conditions (B2).
- The Sun's heal on its main target stays well below the Stars' (SC33); its party total may be higher. Fire resistance is the Sun's weakness by design.
- Waiting for Nightfall must stay a gamble: the Dawn bonus below the expected cost of an ally's exposure.
- Great Star vs Eclipse: each favours different singers — check it evens out.
- Light in the Dark: her bonus + the target's mark ≤ Dawn.
- Lantern's bonus below Weaver Hand: Guide.
- PC deck (DM-P12): the chance of holding Comet and Outpouring in the same hand — not computed yet.
- Tier goals ‹3 / 5 / 8›.

---

## 13. Technical pattern

- **Dusk / Nightfall:** Osiris on HitpointsChanged (the pattern of `ARCANA_Aspect_Star.txt`) applies the mark on a
  downward crossing; `HasHPPercentageLessThan(n)` is vanilla (Gustav `Status_BOOST.txt:1903`).
- **Containers:** the Hemoplague pattern (cost on the children; CardDB maps child → parent);
  `gen_upcast_variants.pl` handles containers. Probe: a child locked by `HasStatus('<HYMN>', context.Source)`.
- **First-heal gate:** a hidden status, `TickType StartTurn`, duration 1.
- **Undying Hope:** the vanilla Death Ward mechanism (already used by the current Undying Hope).
- **Tether:** `Force(-3, OriginToEntity, …)` (vanilla Thorn Whip) on an ally — probe.
- **Dazzled:** `RollBonus(Attack,-1d4)` (vanilla BANE).
- **Hesperus:** the card-passive rule and the reaction-charge pattern of Instinctive Charm / Gale Deflection.
- **Lantern off in combat:** remove the status on combat start, or an out-of-combat condition — probe.
- **Removed from the game:** Final Spark and Recast, Cosmic Omen (3 passives), Stellar Anchor, Lucent Singularity,
  `Target_Light`, Wish Upon a Star, Lunar Wisp, Star Radiance, Astral Fortitude, Moon Gravity, Lunar Aegis, Solar
  Purge, Starbreath, Stellar Grace, Moonlit / Sunlit / the old Eclipse, the +3 WIS of Tier III.

---

## 14. Open

- Does the Sun's spill answer the marks of the allies it reaches? *Design call in §4.7: no — only the main target and
  the area cards (Elpis' Jar, Flare) answer.*
- Do the Moon's tide pulses answer marks? *Design call: no (§4.3).*
- Card details not set in the review: Guiding Light and Tether action types; Dawnbringer's Concentration.
- The ability preset (INT) — `10.06` row 12.

## 15. To test in game

One rule per test, in `61.02`: a mark on each downward crossing; Downed clears it; one empowered heal per round; a
locked child; Undying Hope into Nightfall; Tether on an ally; Lantern off in combat; the Awakening count (Dusk 1,
Nightfall 2).
