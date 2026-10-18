---
id: SPEC_ARC-0025
ticket: ARC-0025
status: in_progress
implementation: claude
author: Mod Engineer
updated: 2026-10-17
---

# SPEC_ARC-0025 · Starchild refining build — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans. **One `[fechado] ARC-0025` message = one
> stage**; stage 0 writes only project files. Lean execution: no subagents, dry runs read as counts, reports ≤ 10 lines.

**Intent:** the game plays the Starchild as `21.04/Starchild/DESIGN.md` describes it (SC0–SC32), in both editions.

**Design:** `21.04/Starchild/DESIGN.md` · **Decisions:** `21.04/Starchild/DECISIONS.md` · **Numbers:** `25`
(`*_Starchild_*.yaml`, blocks `pending_build`) · **Prepared files:** `55/_wip/Starchild/arc0025/` · **Tests:**
`61.02/Starchild/`.

## Global constraints

The constraints and the apply chain of `SPEC_ARC-0020.md` apply unchanged (stats through `stats_add.pl` patches,
structure scripts with dry runs, English loca only, internal ids keep their names, lines ≤ 3900, no repeated field,
goals CRLF/ASCII and compiled by the Owner, every function anchored, probes before uncertain pieces).

## Stages (detailed tasks are written in stage 0, one stage at a time)

| Stage | What | Decisions | Writes the game? | Gate |
|---|---|---|---|---|
| **0** | Sizes (rounds R1–R4); patches, scripts and goal drafts | all | No | Owner approves each round; dry runs clean |
| **1** | Probes P1–P6 on a test entry | — | Yes (throwaway) | Each probe answered; plan B chosen where needed |
| **2** | The Hymns and the core: Sing a Hymn, Unsung, Hymn statuses, containers for Comet and Outpouring, Afterglow, Dusk (Osiris) | SC1–SC10, SC21–SC24, SC32 | Yes (+ goal) | A level-1 Starchild sings, answers Dusk |
| **3** | Levels 2–6: Lantern, Hesperus, Cleansing Rain, Rekindle, Halo, Guiding Light; Nightfall, Dawn, Outpouring II | SC10, SC20, SC25, SC27, SC28 | Yes (+ goal) | Nightfall replaces Dusk; Downed clears it |
| **4** | The Awakening (answered marks, Tier I Great Star + Undying Hope, Tier II conditions, first-heal gate) and Elpis' Jar | SC13, SC16–SC19 | Yes (+ goals) | Count Dusk 1 / Nightfall 2; one empowered heal per round |
| **5** | Levels 9–12: Tether, Stillness, Long Twilight, Flare, Dawnbringer, Light in the Dark, Eclipse; removals; the map | SC12, SC26, SC29, SC30 | Yes (+ goals, lsx) | Level-up shows `DESIGN.md` §9.1 |
| **6** | Close: `25`, `05.02`, catalogs, docs | — | No | `check_propagation` OK |

### Probes (stage 1)

| P# | Question | Anchor | Plan B |
|---|---|---|---|
| P1 | A container child greyed out by `HasStatus('<HYMN>', context.Source)` | Hemoplague container (mod) | One spell with `IF(HasStatus(...))` branches and a three-line tooltip |
| P2 | Osiris sees a downward crossing of ½ and ¼ (HitpointsChanged) | `ARCANA_Aspect_Star.txt` | A status `TickFunctors` check at turn start |
| P3 | The first-heal gate: duration 1 with `TickType StartTurn` lasts until her next turn | Wind Whispers (mod, 2026-09-30) | Osiris clears the gate on her TurnStarted |
| P4 | `Force(-3, OriginToEntity, …)` pulls an ally | Thorn Whip (vanilla) | Teleport the ally next to her |
| P5 | Lantern off in combat (status removed on combat start) | `RemoveEvents OnCombatEnded` (mod) | Boosts with an out-of-combat condition |
| P6 | Undying Hope leaves the ally at 1 HP and Osiris can apply Nightfall right after | current Undying Hope (Death Ward pattern) | Apply Nightfall from the status's `OnApplyFunctors` |

---

## Stage 0 — sizes (balance pass, `game-balance`)

Rounds, each approved by the Owner before the next: **R1** the heal core (Outpouring, the marks) · **R2** the
Awakening and the conditions · **R3** the cards · **R4** utilities (Lantern, Hesperus charges). Currency and
parameters: `22.06` §1–§2, §7 (1 HP healed in combat = 0.6; ×0.8 on a hurt ally, ×0.5 on a healthy one; healing over
time ×0.7). Vanilla anchors (Shared `Spell_Target.txt`): Healing Word `1d4+SpellCastingAbilityModifier` (+1d4 per
level), Cure Wounds `1d8+SpellCastingAbilityModifier` (+1d8 per level), Mass Healing Word `1d4+modifier` each.

### R1 · the heal core — approved 2026-10-17 (SC33)

N = the slot level; mod = her spellcasting modifier.

| Knob | Proposal | Average at slot 3, mod +4 |
|---|---|---|
| Lodestar Balm (Stars) | N × 1d10 + mod | 20.5 on the target |
| Noonday Pour (Sun) | target N × 1d6 + mod; allies within ‹3› m N × 1d4; enemies next to the target 1d4 Fire (2d4 from level 7) | 14.5 + 7.5 per ally nearby |
| Rising Tide (Moon) | now N × 1d4 + mod; then N × 1d4 at the start of each of the next 2 turns; attackers of the ally −3 m movement, 1 turn | 11.5 now + 15 later |
| Dusk answer | + N × 1d4 | +7.5 |
| Dawn answer (Nightfall) | + N × 1d8, and the Hymn's part doubled (Sun spill N × 2d4; Moon pulses N × 2d4) | +13.5 |
| HP cost / minimum | 10% of her max HP unless Afterglow / not at ≤ 11% (unchanged) | — |
| Afterglow | 2 turns (+1 next to a marked ally); regain mod HP at each turn end (unchanged: WIS mod today → spellcasting mod) | — |

Value per cast (one ally nearby): Stars 9.8 · Sun 10.8 · Moon 10.8 points — within 10% (SC4). Stars has the largest
single heal (20.5 vs 14.5 vs 11.5), Sun the largest total with allies close, Moon the largest total over time.
Waiting check (B3), level 5: an ally at 40% of ~44 HP has ~18 HP; one enemy round on them is ~16 (`22.06`: 2A) — about
an even chance of being Downed; the payoff of waiting for Dawn over Dusk is +6 HP. Waiting stays a gamble, not the
default.

**Finding for the Owner:** with one ally nearby the Sun's total (22) passes the Stars' single heal (20.5); with two it
is 29.5. The SC6 brake as written ("the Sun total over several allies must not beat the Stars on one ally") would force
the Sun's heals down to ~1d4 per level and break SC4.

### R2 · the Awakening and the conditions — approved 2026-10-17 (SC34)

Reference fight `22.06` §1: T = 4 turns. Goals are cumulative (as today).

| Knob | Proposal | Why |
|---|---|---|
| Goals (Dusk 1, Nightfall 2) | **3 / 5 / 8** (Tier I / II / III) | In a hard fight she answers about one mark a turn, plus Hesperus on enemy turns; Elpis' Jar (7) answers several at once — Tier I by turn 2, II by turn 3, III by turn 4. Same steps as the Kingmaker's Crossings (3/5/8). Easy fights don't awaken, by design (SC17) |
| Tier II Dazzled (Stars) | −1d4 to attack rolls, **1 turn** | −2.5 on the d20 ≈ 12.5% fewer hits on one enemy turn (2A) ≈ **3** points |
| Tier II half movement (Moon) | **2 turns** | weaker per turn than Dazzled; two turns ≈ **3.5** |
| Tier II Burning (Sun) | vanilla Burning (1d4 Fire a turn), **2 turns** | ≈ 5 damage, less vs fire resistance ≈ **4** |
| The ally's window | the condition rides the ally's next hit within **2 turns** (as Moonlit / Sunlit did) | |
| Growth (DM-B6) | at level 12 each condition lasts **+1 turn** | the late game keeps the bonus alive |
| The Great Star (Aspect card) | **2 turns**; at the start of each of her turns it answers **one** marked ally (the lowest HP) with Lodestar Balm at her highest slot level, no slot spent; counts for the Awakening | answers over time, unlike the jar; level 5 ≈ 2 × 20.5 HP ≈ 20 points; level 12 ≈ 2 × 38 HP ≈ 36 points (≈ 3A) for a once-per-combat 0-Thread card |
| Undying Hope | once per fight, 1 HP, Nightfall | (rule) |
| First-heal gate | 1 turn, `TickType StartTurn` | (rule) |

### R3 · the cards — approved 2026-10-17 (SC35)

N = slot level, mod = spellcasting modifier. "Answer" = the Dusk / Dawn bonus of R1 (+N×1d4 / +N×1d8) unless the
row says otherwise. Durations kept at or below the reference fight (T = 4, DM-B6).

| Card | Base | Stars | Sun | Moon |
|---|---|---|---|---|
| **Comet** (L1) | spell attack **N×1d8** Radiant (was 1d6); −30% speed 1 turn; Afterglow 2 turns (+1 next to a marked ally) | Shooting Star: **+1d8** | Sunspark: **N×1d4** Radiant to enemies within 2 m | Crescent Dart: half movement **2 turns** |
| **Hesperus** (L1 card-passive) | **2 reaction charges** per play; the reaction heal is **1d6 + mod** (2d6 from 5, 3d6 from 9) and answers the mark (no answer bonus — it is the quick, small answer) | Hesperus: **+1d6** | Last Ray: allies within 3 m **1d4** | Moonrise: the same heal, half now, half at the ally's next turn start |
| **Cleansing Rain** (L2) | unmarked: **1** condition; marked: the whole list + **N×1d4 + mod** | Starwater: **N×1d8 + mod** | Sunshower: **1** condition off allies within 3 m | Moondew: the removed conditions can't return for **2 turns** |
| **Rekindle** (L3) | revive at **10%** of max HP (slot 3), 15% / 20% / 24% at slots 4 / 5 / 6 — always below ¼, so in Nightfall | Nova: **+5%** (capped at 24%) | Phoenix Light: allies within 3 m **N×1d4** | New Moon: a tide **N×1d4** for 2 turns |
| **Halo** (L2, bonus action) | **+3 AC** while in Dusk / Nightfall, **3 turns** | Starshield: **+4** | Corona: an attacker that hits is set Burning (2 turns) | Moon Ring: **5 turns** |
| **Guiding Light** (L3, action) | mark **3 turns**; an ally in Dusk / Nightfall who hits it regains **1d6 + mod** per hit | Polaris: **2d6 + mod** | Sun Dog: jumps on death (keeps the turns left) | Moonpath: **5 turns**, the enemy −3 m |
| **Elpis' Jar** (L4, ultimate) | every ally within 18 m: **N×1d4 + mod**, plus the answer bonus on each marked ally | Wishing Star: **+N×1d4** more on marked allies | Midsummer: radius **30 m**, unmarked heal **N×1d6 + mod** | Harvest Moon: every ally healed gets a tide **1d6** for 2 turns |
| **Tether** (L4, action) | range **18 m**, pull **9 m**; a marked ally ends Stun / Restrained / Paralysed | Starline: **+2 AC** until their turn | Solar Wake: Burning **2 turns** on enemies next to the start | Undertow: half movement **2 turns** |
| **Stillness** (L5) | as Equinox today (18 m, 6 m zone, 1 turn; Silence, then Restrained 1 turn) + Disadvantage on attacks at marked allies | Fixed Stars: **Disadvantage** on the Restrain save | High Noon: zone **9 m** | Midnight: Silence **+1 turn** |
| **Long Twilight** (L5) | allies within **6 m**, **3 turns**: Dusk at **⅔** | Blue Hour: Nightfall at **⅓** | Golden Hour: **9 m** | Long Night: **4 turns** |
| **Flare** (L6, 3 copies) | DEX save, **6d6** Fire (half on a save; was 8d6 + Stun), Burning 2 turns; marked allies in the area are answered with **6d4 + mod** | Supernova: **+3d6** on the centre target | Solar Flare: radius **5 m** | Moonburn: Burning **3 turns** and half movement 1 turn |
| **Dawnbringer** (L6) | **3 turns**, no Concentration: a heal on Dusk answers as Nightfall | Daystar: Dawn **+N×1d4** | Sunrise: the Sun's spill **6 m** | Moonset: **4 turns** |

Checks. **Elpis' Jar** at level 7 (slot 4, mod +4), four allies — one Nightfall, one Dusk, two unmarked: 32 + 24 + 14 +
14 = 84 HP ≈ 40 points ≈ 5A once per combat: the strongest single turn of the kit, as an ultimate should be.
**Flare** 6d6 (21) on ~3 targets with Burning ≈ vanilla Fireball at slot 3 — below the band at slot 6, on purpose
(a healer; SC26). **Halo**: +3 AC on an ally being focused for 3 turns ≈ 0.7A — weak by the `22.06` formula, but a
level-2 bonus action with no Concentration; watch. **Rekindle**: a revive ≈ 3A (`22.06` §7) plus the Dawn it sets up.

### R4 · the last sizes — approved 2026-10-17 (SC36)

| Knob | Proposal | Why |
|---|---|---|
| Lantern skill bonus | **+1** to its two skills, for her and allies within 6 m | below Weaver Hand: Guide (+1d4 ≈ 2.5 on one check of one target, Concentration) — broader, smaller |
| Light in the Dark (level 10) | the heals she gives are **+ spellcasting modifier** while she is in Dusk / Nightfall; **not added to a Dawn** | cap ≤ Dawn (SC12): at slot 5, Dusk +12.5 + 5 = 17.5 < Dawn +22.5 |

## Stage 1 — probes P1–P6 (`[fechado] ARC-0025`) — prepared 2026-10-17

**Files:** `_wip/Starchild/arc0025/00_probes.patch` (27 strings, 18 entries, all in the DEBUG sections; dry run clean)
and `_wip/Starchild/arc0025/ARCANA_Probe_ARC0025.txt` (new goal, CRLF, ASCII: grants the 7 probe spells to every
player on SavegameLoaded; P2's marks on HitpointsChanged). **Test:** `61.02/Starchild/QA_ARC-0025.md` (probes), ticket
`QA_ARC-0025`.

**Apply:** the chain of `SPEC_ARC-0020.md` steps 1–3, 6–7, 9–13 (no generator or sort: no card added) — `sync_data`,
backup, `stats_add 00_probes.patch --apply`, `check_cards`, `stats_add --selftest`, copy the goal into
`Story/RawFiles/Goals/`, counts, `sync_data`, commit + push; the Owner compiles the Story and plays `QA_ARC-0025`.

**Cleanup (first task of stage 2):** `@remove` every `PROBE_ARC0025_*` status and `*_PROBE_*` spell, delete the goal,
and a one-off `RemoveSpell` on SavegameLoaded for the 7 spells (AddSpell persists in the save).
