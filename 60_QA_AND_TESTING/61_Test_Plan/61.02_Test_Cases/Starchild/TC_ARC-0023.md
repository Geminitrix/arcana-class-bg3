---
id: 61.02/Starchild/TC_ARC-0023
owner: QA Lead
source: 21.04/Starchild/DECISIONS.md SC0–SC32 · REFINE_Starchild.md · DESIGN.md §4, §13, §15 · 05.02/Starchild.md · 22.05/Starchild.md
reviewed: 2026-10-17 ARC-0023 — created (propagation, 00.08); 2026-10-17 ARC-0025 — R1–R4 sizes (SC33–SC36): no change
status: planned — part A probes run first in the build ticket (they decide the spec); parts B and C after the ARC-0023 build ships
---

# TC_ARC-0023 · The Starchild — the Hymns, Dusk and Nightfall (SC0–SC32)

**Decision it informs:** close the Starchild build, or send a failing rule back to the Lead Class Designer; part A
decides the technical pattern of DESIGN §13 before the build writes the cards.
**Scenario:** console edition (no SE), a Starchild built through the real progression, the standard saves of `83.02`;
the PC (SE) edition where marked. Compile the Story after any apply. Values: `25` (`*_Starchild_*`). One rule per
test (DESIGN §15).

## A · Probes (one rule each — run first, they decide the spec)

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| A1 | A container child locked by the Hymn (SC22) | With Hymn of the Sun only the Sun child is usable; the other two greyed out by `HasStatus('<HYMN>', context.Source)`; cost on the children | One spell per Hymn in three lists, swapped on Sing a Hymn |
| A2 | Unsung locks every child (SC23) | After a long rest, every child greyed out; Sing a Hymn usable in combat as a bonus action, once per long rest | — |
| A3 | Dusk on a downward crossing (SC10) | Ally from 60% to 40% → Dusk on the portrait; healed to 45% (still below half) → no new mark; dropped again after an answer → Dusk again only on a new crossing | Osiris reads the previous HP on HitpointsChanged |
| A4 | Nightfall replaces Dusk, one StackId (SC10) | 40% → 20%: Nightfall, no Dusk; healed to 30% by a potion → Dusk; to 55% → no mark | — |
| A5 | Downed clears the mark (SC11) | An ally in Nightfall drops to 0 → no mark; raised by her heal → a plain heal, no Dawn | — |
| A6 | The first-heal gate (SC19) | Two single-ally heals in one turn at Tier II: only the first passes the condition; the gate lasts until her next turn starts (`TickType StartTurn`) | A turn counter in Osiris |
| A7 | Undying Hope into Nightfall (SC18) | A blow that would drop an ally to 0 leaves them at 1 HP in Nightfall; once per fight | Death Ward then apply Nightfall from Osiris |
| A8 | Tether on an ally (DESIGN §13) | `Force(-3, OriginToEntity, …)` pulls the ally toward her; no opportunity attacks | A short teleport of the ally toward her |
| A9 | Lantern off in combat (SC27) | The Lantern status leaves when combat starts, or its bonus is inert in combat | An out-of-combat condition on the boosts |
| A10 | `gen_upcast_variants.pl` on containers | Upcast variants of each child generated, cost on the children, CardDB maps child → parent | Hand-written variants |

## B · Rules after the build

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| B1 | Her heal answers the mark | Outpouring on Dusk: stronger than unmarked; the mark is consumed; rank II on Nightfall: Dawn | — |
| B2 | Another healer never answers (DESIGN §4.8) | A potion or another caster's heal on a marked ally moves the thresholds only | — |
| B3 | The Sun's spill answers no mark (DESIGN §14 call) | Noonday Pour on the Fighter in Nightfall, the Rogue in Dusk nearby gets the spill and keeps Dusk | — |
| B4 | The Moon's tide pulses (DESIGN §4.3) | Pulses never answer a mark and never count as the first heal | — |
| B5 | Elpis' Jar answers every mark at once | Every Nightfall → Dawn, Dusk → strong, unmarked → plain; the Awakening counts each | — |
| B6 | Hesperus on the enemy's turn | An ally falls into Dusk → reaction heal answers it; the Awakening counts it | — |
| B7 | The Awakening count (SC17) | Answering Dusk counts 1, Nightfall 2; goals ‹3 / 5 / 8› count down on the COUNT status | — |
| B8 | Tier II condition by Hymn (SC18) | Stars: the enemy hit by the ally is Dazzled (−1d4 attack); Moon: half movement; Sun: Burning; no damage | — |
| B9 | Eclipse (SC19) | Tier III first heal joins all three shapes and passes all three conditions | — |
| B10 | Light in the Dark (SC12) | At level 10 she gets Dusk below half; her heals are stronger; her own mark is not consumed by heals; bonus + mark ≤ Dawn | — |
| B11 | Rekindle into Nightfall | The revived ally stands in Nightfall; the next heal brings Dawn | — |
| B12 | Long Twilight moves Dusk to ‹⅔› (Blue Hour: Nightfall to ‹⅓›) | An ally inside at 60% has Dusk | — |
| B13 | The level map (SC29) | `dump_progression.pl`: the rows of DESIGN §9.1; levels 4 and 8 empty; no Cosmic Omen, Stellar Anchor, Final Spark, Lucent Singularity | — |
| B14 | Names (SC32) | Every name in `32.01/Starchild.md` "after the build"; no Starcall, Astral Infusion, Rejuvenation, Equinox, Wish, Lucent Singularity, Final Spark in a tooltip | — |

## C · Verification rows (`22.05/Starchild.md`)

| # | Fight | Metric | Right if | Wrong if | Decision |
|---|---|---|---|---|---|
| V1 | Level 5, any | Turns she waits for Nightfall vs answers Dusk | Both happen; waiting sometimes costs an ally | Always one or the other | SC10, SC11 |
| V2 | Level 3–7 | Turn the Awakening tiers wake | Wakes in a fight with real danger | Wakes in easy fights, or never | SC17 |
| V3 | Level 7, Sun day vs Stars day | Total healing in the same fight | Each Hymn wins its own fight | One Hymn always wins | SC4, SC6 |
| V4 | Level 12, Tier III | Eclipse first heal per round | Feels like the peak | Decides the fight alone | SC19 |

**Qualitative questions** after each session (`27.06`): *Which Hymn did you sing, and why that day? When did you wait
for Nightfall instead of answering Dusk? Did a fallen ally ever cost you the mark? What would you call its signature?*
