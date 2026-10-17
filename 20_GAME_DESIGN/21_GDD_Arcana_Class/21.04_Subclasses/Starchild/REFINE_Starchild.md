---
id: 21.04/Starchild/REFINE_Starchild
owner: Lead Class Designer (with the Balance Designer)
status: proposal — in progress (steps 1–4 and the paths question); nothing here is a decision until it is logged in DECISIONS.md
ticket: ARC-0023
created: 2026-10-16
variant: subclass (full)
sources: 21.04/_SUBCLASS_STANDARD.md v2.1, 21.04/_SUBCLASS_REFINING.md, 05.00, 05.02/Starchild.md, game files via dump_progression.pl (2026-10-16), 21.08, 31.01 §3–§5, 10.06/Open_Questions.md
---

# The Starchild — design review

> A **proposal**. It audits the subclass as it is in the game today and frames the Owner's request (Sun / Moon / Star
> paths); the Owner decides, and each answer becomes an `SC#` line in `DECISIONS.md`. Numbers: placeholders `‹…›`
> only (ADR-0005). There is no `21.03`, `22.05`, `26.01` or `25` entry for the Starchild yet.

## 1. Frame

- **Variant:** subclass, full review.
- **Owner's brief (2026-10-16):** the Starchild is a **healer first** — high, focused healing, like Soraka — with some
  support. She should be able to **specialise in a path of light**: starlight (Radiant, healing) as the trunk or as one
  of three paths; sunlight (Fire); moonlight (Cold). Healing and support stay the focus on every path.
- **Already decided:** Tier III ability bonus (+3 WIS) goes away (`10.06`, 2026-10-08) · the subclass needs an ultimate
  (`10.06`, K3) · Cosmic Omen is intended (`10.06`, 2026-10-11) · flight is to come back as its own passive (`10.06`) ·
  Awakening goal "heal 5×/8×/12× level" (2026-10-02, in game).
- **Open:** how the paths work, the axis, the mechanic (state + one rule), the ultimate, Awakening tiers, level map,
  which cards stay, names, numbers.

## 2. The current state (game, 2026-10-16)

`dump_progression.pl` matches `05.02/Starchild.md` §5–§8. No defect found in the progression.

- **Core rule today:** *Starcall an enemy to gain Rejuvenation; while you have it, Astral Infusion heals an ally for
  free, otherwise it costs ‹10%› of your own max HP.* Taught on the two card tooltips, not on a passive.
- **Kit:** 15 cards (1: Starcall, Astral Infusion · 3: Solar Purge, Lunar Aegis, Lunar Wisp · 5: Starbreath, Lucent
  Singularity, Star Radiance · 7: Wish, Moon Gravity · 9: Equinox, Astral Fortitude · 11: Solar Flare, Final Spark ·
  12: Stellar Grace), passives Cosmic Omen (1) and Stellar Anchor (3), Awakening tiers 3 / 7 / 12.
- **Sun / Moon / Star already in the kit, unsorted:** solar — Solar Purge, Solar Flare, Sunlit (Tier II); lunar —
  Lunar Aegis, Lunar Wisp, Moon Gravity, Moonlit (Tier I); stellar — Starcall, Starbreath, Star Radiance, Stellar
  Grace, Astral Infusion, Astral Fortitude. The Awakening already speaks Cold (Moonlit) and Fire (Sunlit).
- **Gears:**

| Creates | Changes | Spends | Reads |
|---|---|---|---|
| Starcall → Rejuvenation | — (empty) | Astral Infusion (free while Rejuvenated) | Awakening (healing done), Lunar Wisp (heals give THP) |

10 of 15 cards touch none of the four columns (Solar Purge, Lunar Aegis, Lucent Singularity, Star Radiance, Moon
Gravity, Equinox, Astral Fortitude, Solar Flare, Final Spark, Stellar Grace).

## 3. Audit (Depth Model)

| DM | Mark | Evidence |
|---|---|---|
| I1 | 🧪 | Owner tested the Awakening and closed it (2026-09-29); no playtest of the kit as a whole |
| I2 | ⚠️ | "The healer" — describable, but nothing a Life Cleric doesn't also say |
| I3 | ✅ | Celestial healer shows in what the cards do (heal, revive, cleanse, wards) |
| I4 | ⚠️ | Aspect is Hope; the core rule is self-sustain (HP cost vs Rejuvenation). Hope shows only in Undying Hope (Tier III) |
| I5 | ❌ | `21.08` Axis row `❓ audit` |
| I6 | ⚠️ | *Wish* is a D&D 9th-level spell name and sits beside *Wish Upon a Star*; *Light* is vanilla |
| I7 | ⚠️ | The arc ends in Lux damage (Solar Flare, Final Spark at 11); the healer fantasy peaks in a nuke |
| I8 | ➖ | Texts not reviewed in this pass (the text review comes after the rework) |
| S1 | ✅ | XVII The Star — hope and healing after disaster → healer (`31.01` §3) |
| S2 | ⚠️ | Used: the star, hope, healing. Unused: the two jugs poured on land and water, the great star and seven small ones, the bird on the tree, the dawn after the Tower. The cards that follow are **XVIII The Moon** and **XIX The Sun** — the paths the Owner asks for are the next two Arcana |
| S3 | ✅ | Soraka, Lux |
| S4 | ⚠️ | Soraka lends five names; Lux lends two damage spells that pull away from the healer (I7) |
| S5 | ❌ | No real model (candidates: moon phases, the solar day, stellar magnitude) |
| S6 | ❌ | No myth (candidates: Elpis, Hope left in the jar — Hesiod, *Works and Days*; Helios, Selene and Eos, children of Hyperion and Theia — Hesiod, *Theogony*; Astraea) |
| S7 | ❌ | No reading cited to a primary source |
| W1 | ✅ | `31.01` §5: "the light that remains after disaster, a thread of hope that never stops shining" |
| W2 | ⚠️ | Weave only in the class text ("pour it into the wounded"); no card uses Weave vocabulary |
| M1 | ⚠️ | Rejuvenation is exclusive but is a permission token (free Infusion); nothing builds or reads it |
| M2 | ⚠️ | The rule lives on two card tooltips, not on a passive |
| M3 | ❌ | Changes column empty; 10 of 15 cards outside the gears (§2) |
| M4 | ⚠️ | Level 9 plays like level 3 with more buttons |
| M5 | ✅ | Starcall hits enemies, Infusion heals allies — both sides by design |
| M6 | ✅ | No self-feeding loop: Starcall and Infusion each cost a slot / Threads |
| M7 | ✅ | Every Infusion obeys the Rejuvenation rule |
| K1 | ⚠️ | Only Starcall and Infusion drive the mechanic |
| K2 | ❌ | Many cards are vanilla in a new coat: Lunar Aegis ≈ Shield of Faith, Moon Gravity ≈ Freedom of Movement, Solar Purge ≈ Greater Restoration, Starbreath ≈ Revivify, Astral Fortitude ≈ Aid, Wish ≈ Mass Healing Word, Star Radiance ≈ a weapon-damage aura |
| K3 | ❌ | No ultimate |
| K4 | ⚠️ | Cosmic Omen (vanilla Circle of the Stars) and Stellar Anchor (Concentration advantage) belong to no mechanic |
| K5 | ⚠️ | One rule passive (Lunar Wisp, via card); the rest are numbers |
| K6 | ✅ | Infusion is a bonus action from level 1; base-class cantrips are the fallback |
| K7 | ❌ | No ultimate |
| P1 | ✅ | Ranged support, 9–18 m |
| P2 | ⚠️ | The Owner wants a specialist healer; levels 5–11 add control and damage (Lucent Singularity, Equinox, Solar Flare, Final Spark) |
| P3 | ✅ | Heals, wards and buffs act on allies |
| P4 · P5 | ✅ | Starcall → Infusion at level 1; payoff the same turn |
| P6 | ⚠️ | With a hurt ally, Starcall → Infusion is the solved turn; the decision is only *who* |
| P7 | ✅ | Rejuvenation status; Awakening countdown (ARC-0007) |
| P8 | ✅ | Nothing needs enemy cooperation |
| P9 | ✅ | Low damage and "needs hurt allies" show in normal play |
| P10 | ✅ | Stats + Osiris only |
| P11 | ✅ | HP for a heal is a chosen trade |
| P12 | ⚠️ | The loop needs Starcall **and** Infusion in the same hand; not computed yet (tool §4.12) |
| J1 | ⚠️ | Even levels 2, 6, 10 bring nothing |
| J2 | ⚠️ | Growth is upcast dice; Moonlit grows at Tier II; no announced breakpoints on the core cards |
| J3 | ❌ | Starcall / Infusion never rank up |
| J4 | ❌ | Level 3 brings ~6 concepts (3 cards, Stellar Anchor, the Awakening, Moonlit) |
| J5 | ✅ | The Awakening (3) is usable — heals exist from 1 |
| J6 | ⚠️ | Opinion: Tier III needs ‹12 × 12› effective healing in one fight; may need a long fight (`22.06` §1 not applied yet) |
| J7 | ⚠️ | Introduce (1–3) and develop (5–9) are there; no turn; the conclusion is damage (11), not healing |
| J8 | ⚠️ | Odd-only map; level 3 carries most of its stretch |
| A1 | ✅ | Effective healing is the mechanic |
| A2 | ❌ | Tiers add damage riders (Cold, Fire) and +3 WIS (an ability bonus, already slated to go) |
| A3 | ⚠️ | Wish Upon a Star (Advantage on next attack) doesn't play healing |
| B1 | 🧪 | No `22.05/Starchild.md` |
| B5 | ⚠️ | Starcall → Infusion dominant whenever an ally is hurt |
| B6 | ⚠️ | Star Radiance lasts 10 turns (beyond the fight); Astral Fortitude is flat Arcana level |
| B2 · B3 · B4 · B7 | ➖ | No combo pricing, loop or carried resource to check yet |
| X1 | ⚠️ | 15 cards; Lunar Aegis, Moon Gravity, Astral Fortitude and Stellar Grace are narrow buttons |
| X2 | ✅ | Rejuvenation and the Awakening are visible |
| X3 | 🧪 | No playtest |
| T1 | ✅ | No SE in any effect |
| T3 | ➖ | No large family yet |
| T4 | ⚠️ | `Target_Light` vanilla id in the list |

### 3.1 What the audit says, in short

1. **The healer is there; the subclass isn't yet.** The core loop is two cards; ten cards are generic support or damage
   (M3, K1, K2). Nothing is hers alone except Rejuvenation.
2. **No axis, no ultimate, no ranks** (I5, K3, K7, J3).
3. **The Awakening rewards damage, not healing** (A2) — and its Cold / Fire riders are the seed of the paths the Owner
   wants.
4. **The paths fit the card perfectly:** The Star (XVII) is followed by The Moon (XVIII) and The Sun (XIX) — the three
   luminaries in tarot order (S2, to be cited to Waite 1910 in S7).

## 4. How the lights work (answered 2026-10-16)

Three options compared on the same turn (level 7; a Fighter at 40% HP between two goblins; Starcall, then Astral
Infusion): **A** a fork Sun or Moon on a Star trunk, each with its own cards; **B** three lights chosen card by card;
**C** one light that changes every heal, ranked with the Awakening tiers. Owner chose **C** (`SC1`) and made the choice
**once per long rest** (`SC2`).

Notes on SC2 for the design and the build:
- **Proven patterns in the mod:** a chooser with `Cooldown OncePerRest` (Starbreath, Stellar Grace) and a status that
  ends on long rest (`StatusPropertyFlags RemoveOnLongRest`, the card-passive rule — `LUNAR_WISP_BLESSING`). The
  chooser is a utility (`Arcana_Util_`), outside the PC deck; both editions share it (DM-P10, DM-T1).
- **Risk — the forgotten choice:** with no light her heals are plain. Brake to decide: a visible "no light" reminder, or
  a default light. Open.
- **Watch — a dominant light (DM-B5):** a daily choice lets the player pick by the day ahead, which is a real decision
  only if each light wins some days. Test in `61.02`.
- **Seed for the axis / ultimate (not decided):** changing light *inside* a fight is the Transformation axis' question
  ("which form am I in, and when do I switch?"); an ultimate or the Aspect card that shifts or joins lights for a turn
  would read the state (DM-K7).
- **Cosmic Omen** (vanilla, rolled on long rest) becomes a second morning ritual; K4 already marks it ⚠️.

Names approved (SC3): Hymn · Sing a Hymn · Hymn of the Stars / Sun / Moon. No-Hymn status: Unsung (SC5). Shape of the heal per Hymn: SC6. Axis: Timing (SC7; `HasHPPercentageLessThan` confirmed in vanilla). Darkest hour = exclusive mark (SC8), named Dusk (SC9). Dusk (below half) and Nightfall (below a quarter), mutually exclusive, consumed by her heal (SC10). Downed clears the mark (SC11). The Starchild herself: allies only early, her own Dusk empowers her heals later (SC12). Ultimate: the answered wish (SC13); Great Star and Eclipse kept as candidates (SC14); every Soraka/Lux name to be replaced (SC15). Aspect card = the Great Star (Stars only); Tier III = Eclipse (Sun and Moon) (SC16). Awakening goal: answered marks, Dusk 1 / Nightfall 2 (SC17). Tier I: Great Star + Undying Hope into Nightfall; Tier II: a condition by Hymn (SC18). Only the first single-target heal of the turn carries Tier II / Eclipse; Eclipse joins all three (SC19, amends SC16). Card review part 1 approved (SC20–SC22). Unsung: sing in combat as a bonus action (SC23); heal cards are containers too (SC24). Card review part 2 proposed (§6).

## 5. Card review, part 1 — the vanilla cards in a new coat (DM-K2)

Proposals, 2026-10-16; nothing here is decided until logged. Each keeps the **support role** the old card had and moves
the mechanic (Dusk / Nightfall, the Hymns). Names are working names (the names pass, SC15). Shared scenario: level 7,
the Fighter at 40% (in Dusk) between two goblins, the Rogue at 60%.

| SG | Old card (vanilla twin) | Role kept | Proposal | Gear |
|---|---|---|---|---|
| SG1 | Solar Purge (Greater Restoration) | Cleanse | **Sunwash:** remove ‹one› condition from an ally; on an ally in Dusk / Nightfall it **consumes the mark** and removes **every** condition of the current list, plus a small heal | Spends, reads |
| SG2 | Lunar Aegis (Shield of Faith) | Defence | **Moon Halo:** bonus action, ‹3› turns, **no Concentration**; the ally gains ‹+AC› **only while in Dusk or Nightfall** — the moon shines at night. A tool to dare waiting for Nightfall | Reads |
| SG3 | Moon Gravity (Freedom of Movement) | Anti-control, mobility | **Moonpull:** pull an ally ‹X› m toward you without opportunity attacks (vanilla `Force(-3, OriginToEntity, …)`, Thorn Whip); on a marked ally it also ends Stun / Restrained / Paralysed. The rescue out of melee | Reads |
| SG4 | Starbreath (Revivify) | Revive | **Rekindle:** revive a dead ally (long-rest cooldown kept) at ‹low› HP **in Nightfall**, so the next answer is Dawn — a two-step comeback. Spends less HP on the revive itself, more on her answer | Creates |
| SG5 | Astral Fortitude (Aid) | Party durability | **Long Twilight:** allies within ‹6› m for ‹N› turns: **Dusk begins at ‹⅔›** of max HP instead of ½ — dusk comes earlier, more allies can be caught, the Awakening fills faster | Changes |
| SG6 | Star Radiance (weapon-damage aura, Concentration) | Party offence | **Guiding Star:** mark an enemy for ‹N› turns; allies **in Dusk or Nightfall** who hit it regain ‹X› HP — the guiding light lets the wounded save themselves. Adds the enemy side (DM-M5); Tier II already gives allies their riders, so the old aura would repeat it | Reads |

- **Gears after part 1:** Creates — damage, Undying Hope, Rekindle · Changes — Long Twilight · Spends — every heal,
  Sunwash · Reads — Moon Halo, Moonpull, Guiding Star, the ultimate, the Awakening. No empty column (DM-M3).
- **Concentration:** Moon Halo, Long Twilight and Guiding Star are proposed without it (the old kit leaned on it — §4 of
  `05.02`); the balance pass may give it back to one of them.
- **Names material (for SC15):** Hesperus, the evening star that rises at dusk, and Eosphorus, the dawn-bringer, son of
  Eos and Astraeus (Hesiod, *Theogony*) — candidates for Dusk-side and Dawn-side cards.
- **Feasibility (T2):** a pull on an ally (Thorn Whip's `Force` on a friendly target); an AC boost conditioned on a
  status the target holds; a status that moves the Dusk threshold (the Osiris rule reads it).

### 5.1 The Hymn on every card (Owner's request, 2026-10-16)

The Owner asked that the day's Hymn shows on the cards too, not only on the heals. Proposal: **one rule for every
card — the Stars sharpen, the Sun spreads, the Moon lingers** — the same way each Hymn shapes a heal (SC6: focused,
radiant, tidal). Stars: more on the one target. Sun: more targets or area, fire. Moon: longer, over time, slow / cold.
Learned once, predictable on every card (DM-M2, J4); the value of "more / wider / longer" depends on the fight, which
keeps the three Hymns situational (SC4).

| SG | Card | Stars — sharpen | Sun — spread | Moon — linger |
|---|---|---|---|---|
| SG1 | Sunwash | the small heal is ‹bigger› | also removes ‹one› condition from allies within ‹3› m | the ally can't regain the removed conditions for ‹2› turns |
| SG2 | Moon Halo | ‹+1› more AC | an enemy that hits the haloed ally is set Burning | lasts ‹2› turns longer |
| SG3 | Moonpull | the ally gains ‹+AC› until their next turn | enemies next to where the ally stood are set Burning | those enemies are slowed (half movement), so they can't follow |
| SG4 | Rekindle | revives with ‹more› HP | a burst heals allies within ‹3› m for ‹small› | the revived ally gets a tide (‹2› turns of healing) |
| SG5 | Long Twilight | Nightfall also begins earlier (‹⅓›) | radius ‹larger› | lasts ‹longer› |
| SG6 | Guiding Star | the heal on a hit is ‹bigger› | when the enemy dies the star jumps to the nearest enemy | lasts ‹2› turns longer and the enemy is slowed |

- **Alternative weighed:** a bespoke effect per card and Hymn (18 unrelated effects) — richer, but 18 rules to learn
  and to balance; the shared rule is preferred.
- **Feasibility (T2):** `IF(HasStatus('<HYMN>', context.Source)):` branches in one spell (tooltip lists three lines),
  or one variant per Hymn swapped by the Hymn status (the mod's `UnlockSpellVariant` boost pattern) so the tooltip
  shows only the active Hymn — whether a variant can change the effect and text needs a probe.

## 6. Card review, part 2 — the core and the remaining support cards

Proposals, 2026-10-16. Containers with a child per Hymn (SC22, SC24); Hymn variants follow SC21 (Stars sharpen, Sun
spreads, Moon lingers). Working names.

| SG | Card today | Proposal | Stars | Sun | Moon | Gear |
|---|---|---|---|---|---|---|
| SG7 | Starcall (L1 ranged Radiant attack, slows, gives Rejuvenation) | **Kept as her strike and fallback**: radiant spell attack; on a hit she gains Rejuvenation (regain HP each turn end; her next Astral Infusion is free). On an enemy next to an ally in Dusk / Nightfall, Rejuvenation lasts ‹1› turn longer | ‹more› damage | a small radiant splash on enemies within ‹2› m | the slow becomes half movement for ‹2› turns | Creates (Rejuvenation), reads |
| SG8 | Astral Infusion (bonus-action heal; free with Rejuvenation, else ‹10%› of her max HP) | **The signature button, in ranks (DM-J3)**: rank I (level 1) heals and consumes Dusk; rank II (‹5–7›) answers Nightfall with Dawn — the level Nightfall arrives (SC10); rank III (‹9–11›) her own Dusk empowers it (SC12). The HP cost stays (the Soraka trade) | focused (SC6) | radiant (SC6) | tidal (SC6) | Spends |
| SG9 | Lunar Wisp (card-passive: heals give THP) — overlaps the Moon's tide | **Hesperus** (the evening star; card-passive, Unique, the card-passive rule): when an ally within ‹18› m falls into Dusk or Nightfall, use your **reaction** to answer at once with a ‹small› heal that consumes the mark. Answer now and small, or wait and answer big — the axis on enemy turns (DM-P3). Reaction charge refilled by the card (Instinctive Charm / Gale pattern) | the reaction heal is ‹bigger› | it also heals ‹a little› allies within ‹3› m | it comes as a tide | Spends, on others' turns |
| SG10 | Stellar Grace (L12; healing maximised, Advantage on WIS and Death saves; Concentration) ≈ Beacon of Hope | **Dawnbringer** (Eosphorus): for ‹N› turns, every heal she casts on an ally in **Dusk** answers as if it were **Nightfall** — the dawn comes early. Long-rest cooldown, Unique | Dawn heals ‹bigger› | radius of the Sun's spill ‹larger› | lasts ‹longer› | Changes |
| SG11 | Wish → the ultimate (SC13) | Hymn variants only | marked allies' heals ‹bigger› | radius ‹larger› | every ally healed keeps a tide | Spends, reads |

- **Rejuvenation** stays the Soraka loop (Starcall → free Infusion); with SG8 rank III, paying HP instead becomes a
  choice that can push her into her own Dusk.
- **Part 3, next:** the control and damage cards (Lucent Singularity, Equinox, Solar Flare, Final Spark) and the
  passives (Cosmic Omen, Stellar Anchor).
