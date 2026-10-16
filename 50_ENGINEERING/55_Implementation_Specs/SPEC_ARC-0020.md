---
id: SPEC_ARC-0020
ticket: ARC-0020
status: in_progress
implementation: claude
author: Mod Engineer
updated: 2026-10-16
---

# SPEC_ARC-0020 · Deceiver refining build — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans. **One `[fechado] ARC-0020` message = one
> stage**; stage 0 writes only project files. Lean execution: no subagents, dry runs read as counts, reports ≤ 10 lines.

**Intent** (from ARC-0020): the game plays the Deceiver as `21.04/Deceiver/DESIGN.md` describes it after the ARC-0019
refining (DV18–DV31), in both editions.

**Design:** `21.04/Deceiver/DESIGN.md` · **Decisions:** `21.04/Deceiver/DECISIONS.md` · **Numbers:** `25`
(`*_Deceiver_*.yaml`, blocks `pending_build`) · **Prepared files:** `55/_wip/Deceiver/arc0020/` (new; the Veil
build's patches and scripts in `55/_wip/Deceiver/` are the models) · **Test case:** `61.02/Deceiver/TC_ARC-0019.md`.

## Global constraints

- Everything in Stats / LSX / Osiris / Khonsu; the PC deck (Lua) only counts and locks cards (two editions).
- Stats through `stats_add.pl` patches (`.txt` + `.stats` + English loca together); lists and progression through a
  structure script (lsx + tbl), dry run first, idempotent. Loca: English only (the other languages in a later round).
- **Internal ids keep their names** (ruling for DV12/DV29): only player-facing text changes. Card families, Osiris
  triggers (`DB_ARCANA_CardFamily`), the generator and CardDB all key on ids; renaming them is cost without a player
  gain. A later ticket may rename them under ADR-0002 if the Owner wants.
- Lines ≤ 3900 characters; no field repeated in an entry (the Toolkit truncates on save); entry counts checked.
- Goals: CRLF, ASCII; the Owner compiles the Story after any goal change; the next message reads only
  `grep -i "error\|warning"` of the log.
- Every function and field below has an anchor (file in the mod, vanilla or a reference mod). Where the engine
  behaviour is unknown the stage starts with a **probe** and has a plan B.

## The apply chain (every stage that writes the game)

1. `sync_data.sh` (captures the Owner's Toolkit edits) · 2. backup · 3. `stats_add <patch> --apply` ·
4. `gen_upcast_variants --apply` (when a card is added or relevelled) · 5. `sort_stats --apply` · 6. `check_cards` ·
7. `stats_add --selftest` · 8. structure script `--apply` · 9. copy the goals · 10. counts, line length, repeated-field
scan · 11. `sync_data.sh` · 12. commit + push · 13. tell the Owner to compile (when goals changed) and what to test.

## Stages

| Stage | What | Decisions | Writes the game? | Gate |
|---|---|---|---|---|
| **0** | Sizes decided; patches, scripts and goal drafts prepared | all | No | Owner approves the sizes; every dry run clean |
| **1** | Names and the one-rule passive | DV19, DV29, DV31 | Yes (stats, loca) | Tooltips read the new names; one passive explains the rule |
| **2** | The map and *Splinter on Command* | DV23, DV24, DV26, DV28, DV31, DV32 | Yes (+ goal) | B1; level-up shows `DESIGN.md` §9.1 |
| **3** | Grand Deception reads the Veil; Tier III *the lie explodes* | DV21, DV22 | Yes (+ goals) | B2, B3; V2, V3 |
| **4** | Mirrored Self from a Double | DV25 | Yes (+ goal) | B4; V4 |
| **5** | Close: `25`, `05.02`, catalogs, docs | — | No (project) | `check_propagation` OK |

## Review focus

1. **The Tier III burst fires only on the "destroyed by an enemy" path** — never on Dismiss, the cap, cleanup, her
   death or a Splinter's own vanishing (the goal's `DB_ARCANA_DoubleNoBlame` already marks those, `ARCANA_Deceiver_Doubles.txt`).
2. **Doubt from an explosion is hers**: the Doubt technical status must carry her as source, or the Awakening never
   counts it (B2).
3. **Grand Deception counts before it summons**: the count reads the Doubles on the field when the spell is cast,
   not the ones it creates.
4. **No double damage at Tier III**: a Splinter is one burst, whichever path made it.

---

## Stage 0 — sizes and preparation (project files only)

### Task 0.1 · the open sizes (balance pass, `game-balance`)

Every `‹…›` in `25` `pending_build` gets a value, shown to the Owner as arithmetic in the `22.06` currency before it
is written: `SPL_Deceiver_Splinter.tier3_radius_next` · `SPL_Deceiver_GrandDeception.doubt_per_double_next` and
`doubles_range_next` · `SPL_Deceiver_SplinterOnCommand.range_next` and `threads_next` · `SPL_Deceiver_MirroredSelf.plan_b_range_next`.
Anchors: vanilla Death Burst radii 2–3 m (`Projectile_DeathBurst_*`, `Spell_Projectile.txt`); Grand Deception's
area 9 m today.

### Task 0.2 · names (DV29, DV31) — `arc0020/10_names.patch`

**Prepared 2026-10-16:** 52 strings replaced + 2 new (9 of them the subclass name Veilwalker, DV33) (The Veil's ExtraDescription, the Double status's Description); dry run clean. Narrative gate passed (`32.04/ARC-0020_Deceiver.md`). Tier III and Grand Deception texts move to stage 3 with their rules.

`@loca` rows for every English string that shows an old name. The game holds them today: *Sigil* 21 strings,
*Ethereal Chains* 11, *Mimic* 9, *Distortion* 7, *Shatter* 4, *Mirror Image* 3 (counted 2026-10-16 in
`Localization/English`). Each row replaced, never added; the handle and its version bumped. Covers DisplayNames,
Descriptions, the Seed status, *Reflected Seed* / *Reflected Falsehood*, *Twice-Told: X*, *Splinter*, Two Pillars'
text, the Aspect card's text.
- **Test:** dry run prints 0 strings still holding *Sigil of Malice*, *Ethereal Chains*, *Distortion*, *Mirror Image*,
  *Mimic*, *Shatter* in Deceiver handles (the generic word *sigil* elsewhere in the mod is listed, not changed).

### Task 0.3 · the one-rule passive (DV19) — same patch

*The Veil*'s Description carries the core rule and the Doubles; `Arcana_Passive_Doubt` leaves the progression
(Task 0.4) and moves to `90_ARCHIVE` in stage 5 (entry and its strings). Text from `32.01/Deceiver.md`.

### Task 0.4 · the map (DV28) — `arc0020/20_structure.pl` (model: `60_structure.pl`)

| Level | Change |
|---|---|
| 1 | Remove `Arcana_Passive_Telepathy` and `Arcana_Passive_Doubt` (both L1 rows: class and multiclass); list "Deceiver Level 1" keeps Seed of Doubt, Malicious Whispers, Eidolon |
| 2 | New list "Deceiver Level 2": Faceless, Friends, *Splinter on Command*; `AddSpells` on the L2 node |
| 6 | New list "Deceiver Level 6": Twice-Told (`Target_Arcana_Created_Mimic`), Mirrored Spell |
| 7 | List "Deceiver Level 7" loses Twice-Told (the cap-4 passive and Tier II stay) |
| 10 | New list "Deceiver Level 10": Mirrored Self (`Shout_Arcana_Card_Passive_MirroredCharm`) |
| 12 | List "Deceiver Level 12" loses Mirrored Self and Mirrored Spell; becomes empty → `AddSpells` row removed |

Prepared: `_wip/Deceiver/arc0020/20_structure.pl` (dry run 2026-10-16 matches §9.1). Only one list is new ("Deceiver Level 2", UUID from MD5, re-runs identical); "Deceiver Level 7" is renamed to Level 6 and "Deceiver Level 12" to Level 10, their selectors moved. Apply it **after** `30_splinter_command.patch`, so the new card exists. Nodes 2, 6, 10 exist and are
empty today (`dump_progression.pl`).
- **Test:** dry run, then `dump_progression.pl` after apply matches `DESIGN.md` §9.1 (4 and 8 empty).

### Task 0.5 · *Splinter on Command* (DV24, DV31, DV32) — `arc0020/30_splinter_command.patch` + goal region

**Prepared 2026-10-16:** `30_splinter_command.patch` (the card + `SPLINTER_COMMAND_TECH`, 4 strings; dry run clean) · `32_goal_splinter_command.pl` (inserts the 18-line region into `ARCANA_Deceiver_Doubles.txt`, before Task 4; checked on a copy of 51) · `lua/` (CardDB row cost 1 + test row; 138 tests pass on a copy). The Lua files are copies of 51 of 2026-10-16: diff them against the Data folder before copying. Ownership is checked in the goal only — the vanilla `SummonOwner(context.Source,context.Target)` (`Target_FlamingSphere_Move`) has an unproven argument order. In-game name: *Splinter on Command* (title case, Larian style).

- **Entry:** `Target_Arcana_Card_Spell_SplinterOnCommand` — a **deck card** (DV32), level 0 like *Malicious
  Whispers* (no slot; Threads on PC from `threads_next`, CardDB entry like the cantrip's). `BonusActionPoint:1`. Target: one of her own Doubles within `range_next` (`HasStatus('DOUBLE_OF_THE_VEIL')` — the status the Doubles'
  spells check — and summoned by the caster; the "summoned by me" condition needs a vanilla anchor found in stage 0,
  otherwise the goal ignores a Double that isn't hers).
- **Effect:** applies a technical status to the Double; `ARCANA_Deceiver_Doubles.txt` reacts and makes the Double
  cast its Splinter with `UseSpell(_Double, "Shout_Deceiver_Double_Shatter", _Double, _Double, 1)` — the pattern The
  Veil Lifts already uses (`ARCANA_Aspect_Empress.txt`, its Veil Lifts region). The Double's own turn is not spent.
- **Test:** goal draft compiles in the Story Editor (stage 2); CardDB entry + `CardDBTest.lua` row (Thread cost, enters the deck).

### Task 0.6 · Tier III (DV21) — `arc0020/40_tier3.patch` + goal region

**Prepared 2026-10-16** (changes the plan below, smaller and safer): below Tier III the Splinter keeps its own 3 m damage; at Tier III the shout's damage is switched off by a condition on her `ASPECT_AWAKENED_EMPRESS_III` (`GetSummoner(context.Source)`, the mod's Doubt-boost pattern) and the goal makes every burst with `CreateExplosionAtPosition` of `Projectile_Deceiver_Double_SplinterBurst` (4 m, `using` the mod's proven `Projectile_Arcana_Distortion_Explosion`). The Charisma boost leaves `Arcana_Passive_Aspect_Empress_Awakened_III` (it keeps the Which One? unlock); `…_III_Damage` leaves the status. Files: `40_tier3.patch` (dry run clean, 4 strings), `42_goal_tier3_grand.pl` (with Task 0.7; on a copy of 51: +98 lines, the old 2-Doubt rule out, idempotent).

- `ASPECT_AWAKENED_EMPRESS_III`: drop `Arcana_Passive_Aspect_Empress_Awakened_III` (Charisma) and `…_III_Damage`
  from `Passives` (`Status_BOOST.txt`); both entries to the archive in stage 5. *Which One?* is untouched.
- New `Projectile_Deceiver_Double_SplinterBurst` and `…_SplinterBurst_Wide` (model: vanilla
  `Projectile_DeathBurst_Died_IceMephit` — `ExplodeRadius` sets the area; damage and Doubt as today's Splinter).
- **One burst path:** the Splinter shout keeps its cost and animation but loses its own damage; every Splinter
  (manual, on command, The Veil Lifts, the Tier III burst) resolves as
  `CreateExplosionAtPosition(_X,_Y,_Z, <burst>, 1, _Owner)`, `<burst>` = the wide one when
  `DB_ARCANA_AspectReached(_Owner, 3)` (vanilla anchor: `GLO_CombatNPCs.txt`, Death Burst region; mod anchor: LeBlanc
  `GLO_LeBlanc_Passives_GRT.txt` `CreateExplosion`).
- **The lie explodes:** in the "who destroyed it" region, when the destroyer is an enemy and she has Tier III, the
  same PROC fires at the Double's last position (`GetPosition` before the purge timer).
- **Plan B (if B2 fails — Doubt not hers):** the burst applies `DOUBT_ADD_TECH` from Osiris on each enemy within the
  radius instead of from the projectile.

### Task 0.7 · Grand Deception (DV22) — goal region (the Doubles goal's Task 5)

**Prepared 2026-10-16** in `42_goal_tier3_grand.pl`: the Doubles are listed at `UsingSpell` (before the Summon functors), `GRAND_DECEPTION_TECH` adds one Doubt per listed Double within 3.0 m through `PROC_ARCANA_Doubt_Add`, the list clears 1.5 s after `CastedSpell`. Texts and the tooltip in `40_tier3.patch`.

On cast: for each enemy within 9 m that fails the save (the spell applies a technical "failed" status), count her
Doubles within `doubles_range_next` (`GetDistanceTo`, as `ARCANA_Passive_MirroredSpell.txt` uses it) and add that
many × `doubt_per_double_next` Doubt; **then** the Summon functor fills the cap. The spell's flat 2 Doubt is removed.

### Task 0.8 · Mirrored Self from a Double (DV25) — after B4

Drafted only after probe B4 (stage 4).

---

## Stage 1 — names and the rule (`[fechado] ARC-0020`)

**Applied 2026-10-16** (`10_names.patch --apply`: 52 strings replaced, 2 new, 2 fields set). Checks: `check_cards` OK (115 roots), `stats_add --selftest` 1151/1151, no line over 3900, loca 1563 strings well formed; the old *Doubt* passive leaves with stage 2 (`20_structure.pl`), not here.

Apply Tasks 0.2–0.3. No goals. **In game:** every Deceiver tooltip reads the new names; *The Veil* states the rule;
the old *Doubt* passive is gone from the sheet.

## Stage 2 — map and Splinter on Command (`[fechado] ARC-0020`)

Apply Tasks 0.4–0.5; Owner compiles.

| Probe | One rule | Expected | Plan B |
|---|---|---|---|
| **B1** | A Double told to splinter off its own turn | `UseSpell` on a technical status fires the Splinter now | Make *Splinter on Command* a ground-targeted spell that kills the Double and runs the burst PROC (stage 3's path) |
| V1 | *Splinter on Command* use | As `TC_ARC-0019` V1 | — |

## Stage 3 — Grand Deception and Tier III (`[fechado] ARC-0020`)

Apply Tasks 0.6–0.7; Owner compiles.

| Probe | One rule | Expected | Plan B |
|---|---|---|---|
| **B2** | Explosion's Doubt is hers | `CreateExplosionAtPosition(…, _Owner)` → the Doubt counts toward her Awakening | Task 0.6 plan B |
| **B3** | Burst from a dead Double's position | The position read before the purge is valid; the burst lands there | Read the position on the hit (`AttackedBy`), not on `Died` |
| **B5** | Grand Deception lists the Doubles before it summons | `UsingSpell` fires before the new Doubles register: the count reads only the old ones | List them at `CastSpell` of the previous rule set; or snapshot on the card's technical status |
| **B6** | The Splinter's Tier III condition | `HasStatus(..., GetSummoner(context.Source))` reads her Tier III in a shout's SpellProperties | Give the Doubles a Tier III shapeshift rule with a damage-free Splinter |
| V2, V3 | As `TC_ARC-0019` | | |

## Stage 4 — Mirrored Self from a Double (`[fechado] ARC-0020`)

| Probe | One rule | Expected | Plan B |
|---|---|---|---|
| **B4** | A Double casts a spell it doesn't know | `UseSpell(_Double, <her card variant>, _Target, …)` resolves | Plan B of DV25: keep `ModifyNumberOfTargets` and require a Double within `plan_b_range_next` of her (Owner decides) |

If B4 passes: *Mirrored Self* no longer adds a target to her spell; while it is on her, her next eligible spell is
also cast by her nearest Double at the enemy nearest to that Double (not the first target). Test V4.

## Stage 5 — close (project)

Move every applied `*_next` into `values:` and delete `pending_build` (`25`); `validate.pl`; `gen_catalog.pl`;
archive the retired entries (Telepathy and Doubt passives from the Deceiver, the Tier III Charisma passives) with date
and reason; `05.02/Deceiver.md` (Context Keeper); `DESIGN.md` state line → built; `TC_ARC-0019` results; ticket done;
`check_propagation` OK.

## Acceptance criteria

- [ ] Stage 0 dry runs clean and the sizes approved before any `[fechado]`
- [ ] Probes B1–B4 recorded, plan B applied where one failed
- [ ] `TC_ARC-0019` V1–V4 pass in game
- [ ] No line over 3900 characters; no repeated field; entry counts as expected after `sort_stats`
- [ ] `25` holds no `pending_build` block for the Deceiver
