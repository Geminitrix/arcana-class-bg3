---
id: QA_ARC-0025
title: Playtest — The Starchild — rework SC0–SC36 (levels 1–12)
type: playtest
subclass: starchild
build: ARC-0025
status: draft
owner: QA Lead
sources: [QA-0003, GUIDE_ARC-0025_probes, TC_ARC-0023]
created: 2026-10-17
---

# QA_ARC-0025 · The Starchild — rework SC0–SC36 (levels 1–12)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0025 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from QA-0003, GUIDE_ARC-0025_probes, TC_ARC-0023.

> The level-by-level tests are written at the build kit of ARC-0025 (stage 4), from the draft in the appendix.

## Probes — stage 1 (prepared, never applied)

Before (this section): Stage 1 of ARC-0025 is applied (a [fechado] ARC-0025 message), the Story is compiled and log.txt shows 0 error(s), 0 warning(s). · Load a save with the party; the probe spells ("Probe: …") are added to every player character on load. · Any class and level. Probes are throwaway: stage 2 removes them. · Write down what you see for each probe, even when it fails: every probe has a plan B.

**Setup:** The party out of combat, then a small fight for P2, P3, P5 and P6.

### P1 · A container child locked by a status

- **Rule:** SPEC_ARC-0025 P1 (containers locked by the Hymn, SC22)
- **Steps:** Cast Probe: Sing A, open Probe: Container; cast Probe: Sing B, open it again
- **Expected:** With Probe Hymn A on, Child A is castable and Child B is greyed out; with Hymn B the opposite. Casting Sing B replaces Hymn A (one icon only)
- **Fails if:** Both children are castable, or both greyed, or the container does not open, or both Hymn icons show.
- **Result:** —

### P2 · Marks on a downward crossing

- **Rule:** SPEC_ARC-0025 P2 (Dusk and Nightfall, SC10, SC11)
- **Steps:** In a fight, let an ally take damage past 50% and 25%, then heal them up step by step; also let one be Downed
- **Expected:** Below 50% HP the character shows Probe Dusk; below 25% Probe Nightfall replaces it; healed to 25-49% it is Probe Dusk again; above 50% the mark is gone; when Downed the mark is gone
- **Fails if:** No mark, both marks at once, a mark that stays above 50%, or a mark on a Downed character.
- **Result:** —

### P3 · A one-turn gate with TickType StartTurn

- **Rule:** SPEC_ARC-0025 P3 (the first-heal gate, SC19)
- **Steps:** In a fight, cast Probe: Gated on your turn, try again, end the turn, watch it through the round
- **Expected:** After one cast Probe Gate shows and Probe: Gated is greyed out for the rest of your turn and through the enemies' turns; at the start of your next turn the gate is gone and the spell works again
- **Fails if:** The gate disappears at the end of your own turn, or never disappears.
- **Result:** —

### P4 · Pull an ally

- **Rule:** SPEC_ARC-0025 P4 (Tether, SC20)
- **Steps:** Cast Probe: Pull on an ally standing next to an enemy, 10-15 m from you
- **Expected:** The ally slides about 9 m toward you and takes no opportunity attack
- **Fails if:** The ally doesn't move, is pushed away, or is hit by an opportunity attack.
- **Result:** —

### P5 · A light that switches its bonus off in combat

- **Rule:** SPEC_ARC-0025 P5 (Lantern, SC27)
- **Steps:** Cast Probe: Lantern, check the sheet, then start a fight and check again
- **Expected:** You give off light about 12 m around you; out of combat the character sheet shows Perception +1; in combat the +1 is gone and the light stays
- **Fails if:** No light, the +1 stays in combat, or the light goes out in combat.
- **Result:** —

### P6 · Undying Hope leaves Nightfall

- **Rule:** SPEC_ARC-0025 P6 (Undying Hope into Nightfall, SC18)
- **Steps:** Cast Probe: Undying on an ally, then let an enemy bring them to 0
- **Expected:** When the ally would be Downed they stay up at 1 HP with Probe Nightfall on, and the mark stays
- **Fails if:** The ally goes Downed, gets more than 1 HP, or ends without Probe Nightfall.
- **Result:** —

## Appendix — TC_ARC-0023 (design-stage draft, verbatim)

Header of the original file:

```
id: 61.02/Starchild/TC_ARC-0023
owner: QA Lead
source: 21.04/Starchild/DECISIONS.md SC0–SC32 · REFINE_Starchild.md · DESIGN.md §4, §13, §15 · 05.02/Starchild.md · 22.05/Starchild.md
reviewed: 2026-10-17 ARC-0023 — created (propagation, 00.08); 2026-10-17 ARC-0025 — R1–R4 sizes (SC33–SC36): no change
status: planned — part A probes run first in the build ticket (they decide the spec); parts B and C after the ARC-0023 build ships
```

### TC_ARC-0023 · The Starchild — the Hymns, Dusk and Nightfall (SC0–SC32)

**Decision it informs:** close the Starchild build, or send a failing rule back to the Lead Class Designer; part A
decides the technical pattern of DESIGN §13 before the build writes the cards.
**Scenario:** console edition (no SE), a Starchild built through the real progression, the standard saves of `83.02`;
the PC (SE) edition where marked. Compile the Story after any apply. Values: `25` (`*_Starchild_*`). One rule per
test (DESIGN §15).

#### A · Probes (one rule each — run first, they decide the spec)

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

#### B · Rules after the build

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

#### C · Verification rows (`22.05/Starchild.md`)

| # | Fight | Metric | Right if | Wrong if | Decision |
|---|---|---|---|---|---|
| V1 | Level 5, any | Turns she waits for Nightfall vs answers Dusk | Both happen; waiting sometimes costs an ally | Always one or the other | SC10, SC11 |
| V2 | Level 3–7 | Turn the Awakening tiers wake | Wakes in a fight with real danger | Wakes in easy fights, or never | SC17 |
| V3 | Level 7, Sun day vs Stars day | Total healing in the same fight | Each Hymn wins its own fight | One Hymn always wins | SC4, SC6 |
| V4 | Level 12, Tier III | Eclipse first heal per round | Feels like the peak | Decides the fight alone | SC19 |

**Qualitative questions** after each session (`27.06`): *Which Hymn did you sing, and why that day? When did you wait
for Nightfall instead of answering Dusk? Did a fallen ally ever cost you the mark? What would you call its signature?*

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources QA-0003, GUIDE_ARC-0025_probes, TC_ARC-0023 merged; nothing removed.
