---
id: ARC-0008
title: Raise the Kingmaker (was the Spinner) to the subclass standard (design)
type: design
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Lead Class Designer
implementation: claude
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 55/_wip/Kingmaker/2026-10-13-spinner-three-proposals.md, 05.02/Spinner.md, 21.08_Subclass_Matrix.md]
outputs: [55/_wip/Kingmaker/decisions.md, 21.04/Kingmaker/2026-10-13-kingmaker-design.md, 55/SPEC_ARC-0008.md, 55/TOOLKIT_ARC-0008.md, 55/TOOLKIT_ARC-0008_stage2.md, 55/_wip/Kingmaker/texts.md, 25.01/SPL_Kingmaker_*, 25.02/FEAT_Kingmaker_*, 22.05/2026-10-13_ARC-0008_Kingmaker_Balance.md, 55/_TEMPLATE_TOOLKIT_GUIDE.md, 90/93/2026-10-13_ARC-0008_spinner_audit, 90/93/2026-10-13_ARC-0008_spinner_design]
blocked_by: []
sprint:
created: 2026-10-13
---

# ARC-0008 · Raise the Kingmaker (was the Spinner) to the subclass standard (design)

**Goal:** audit the Spinner against the evaluation questions of `_SUBCLASS_STANDARD.md` and close every
gap in a raising spec, so it reaches the level the Resonant reached in ARC-0002.
**Intent:** the Spinner plays its timed-fate mechanic — fates that count down, the Cascade, the wheel of
elements — with an ultimate that ties it together and a kit the player can hold in their head.

## Acceptance criteria

- [x] Every evaluative question of §3 answered for the Spinner (✅ / ⚠️ / ❌ with evidence).
- [x] The decisions of the 2026-10-08 design conversation recorded in `55/_wip/Spinner/decisions.md` (SP1–SP43).
- [x] Depth audit of the old Spinner handed to the Context Keeper, then archived (design replaced). The Kingmaker audit goes with its 05 handoff.
- [x] Handoffs for the Kingmaker: Context Keeper (`05.02` + Depth audit, `05.00`, `05.06`), Lore Writer (`31.01`), Localization (`33.03`); `21.08` Kingmaker column with Axis = Balance; `10.06` updated.
- [x] Every gap resolved by a decision in `55/_wip/Kingmaker/decisions.md` (SP47–SP103) or listed as open (spec §14).
- [x] Raising spec written: `21.04/Kingmaker/2026-10-13-kingmaker-design.md` (§1.5 sections, Identity Sheet complete, no audit inside).
- [x] Balance pass: numbers in `25.01`–`25.02` (11 SPL, 6 FEAT), arithmetic in `22.05/2026-10-13_ARC-0008_Kingmaker_Balance.md` (approved).

## Gates

- [x] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15) — answered 2026-10-13, passes with three notes (below)
- [ ] Narrative gate (`32.04`) — the class description's second sentence and every tooltip; handoff to the Lore Writer sent
- [ ] DoD (`00.03`)

### Design gate (2026-10-13)

Answered by the main session in the roles the standard names.

| # | Question | Answer |
|---|---|---|
| 1 | Pillar and fantasy (Lead Class Designer) | `21.01` (Vision and Pillars) **does not exist yet**; checked against the class pillars in `31.01` §1 — **Tarot**: the Rota Fortunae read literally; **Mystra and the Weave**: SP95's sentence, Atropos cuts the thread; **Destiny at level 1**: own chassis (CHA, Courtier, Sorcerer voice). Fantasy *"I don't win fights. I decide who does."* is what the kit does (SP97) |
| 2 | Role without duplication, `21.08` (Lead Class Designer) | Force multiplier, axis **Balance** (free). Note: the role sits close to the Resonant's (support through states); different axis (Balance vs Combination); the class's magical-DPR gap is a future ticket (`10.06`) |
| 3 | Resource and recharge, `26` (Spell Designer) | Woven Spell Slots / Threads for the cards (Long Rest / per turn); Turn the Spoke no slot (Bonus Action); Peripeteia, Usurp, Rota Fortunae once per combat; The Wheel Stops and the Master of Coin once per Long Rest; the Court is named once per Long Rest. The Wheel itself costs nothing |
| 4 | Power on the curve, `22` (Balance Designer) | ≈ 88 % of the budget per turn at T1 (no Court yet), ≈ 92 % at T2, ≈ 95–100 % at T3 counting the tiers and the capstone (`22.05` §6); leans weak early, on purpose |
| 5 | One tooltip read; complexity budget (Lead Class Designer) | The core rule fits one passive (The Rota); a new player can name the signature (the Wheel, the Crossing) after one fight. **11 combat actions** against the standard's suggested 3 (suggestion until an ADR); one main resource (positions) and one secondary (the Court, set before battle) |
| 6 | Interactions (Balance Designer) | No Concentration in the kit; Coronation and Turn the Spoke share the Bonus Action (a choice); one position per creature, Advantage sources don't stack (SP52); Crossing once per enemy per round; Hubris consumed; Nemesis moves only Falling enemies; Master of Coin once per Long Rest — no open loop |
| 7 | Core 1–12 without 13–20 (Validator) | Complete at 12 (capstone 11, Tier III 12); nothing depends on 13–20 |
| 8 | Intent in one sentence (Spell Designer) | *The Kingmaker makes the party stronger by keeping allies at the top of Fortune's Wheel while enemies hit the bottom — and every fall beside a reign hurts.* |

**Notes:** (1) `21.01` has to be written (pillars for the whole class) — proposal for the Owners; (2) the complexity
budget is above the suggestion until an ADR fixes it; (3) the T1/T3 percentages are rough and go to the playtest.

## Log

- 2026-10-08 — design conversation (before the project migration): `21.04/Spinner/2026-10-08-spinner-design.md`.
- 2026-10-13 — created; decisions SP1–SP43 recorded from that conversation; audit against the current
  §3 done and handed to the Context Keeper. Gaps to brainstorm, in order: **K3 ultimate** (and A3), the
  **complexity budget** (§15: ~25 combat actions), then I6 names, W1, D1/D2; balance pass after.
- 2026-10-13 — three alternative proposals for the raise (A Measured Thread · B Rise and Fall · C Fortuna's
  Wager) in `55/_wip/Spinner/2026-10-13-spinner-three-proposals.md`; awaiting the Owner's choice (SP47).
- 2026-10-13 — brainstorm with the Owner: direction B *Rise and Fall* chosen, subclass renamed **The Kingmaker**;
  decisions SP47–SP71 (Wheel positions, King/Regent, the Court/Small Council, verbs, Crossing, Cut, Peripeteia,
  The Wheel Stops, chassis, progression). Next: Hubris fix, Awakening, card details, edge cases, raising spec.
- 2026-10-13 — SP72 (Hubris: who reigned falls harder). The old Spinner audit handoff, never applied, archived in
  `90/93/2026-10-13_ARC-0008_spinner_audit` (design replaced by the Kingmaker); the Kingmaker gets its own audit
  with the raising spec. Owner's note: the Kingmaker's role sits close to the Resonant's (support through states)
  and the mod still lacks a magical burst/DPR subclass — a future tarot card will fill that gap (not this ticket).
- 2026-10-13 — brainstorm closed: SP72–SP103 (Hubris, Succession, Awakening Tyche/Nemesis/Aspect of Anticipation,
  Usurp, Foreseen, card details, edge cases, Identity Sheet, names, Osiris drives the Wheel). Before the spec, at the
  Owner's request: the Toolkit entry guide standard `55/_TEMPLATE_TOOLKIT_GUIDE.md` (one `TOOLKIT_ARC-####.md` per
  ticket beside its SPEC; icons as suggestions; generated families not typed) and the ADR-0005 amendment proposal
  `00.04/PROPOSALS/PROPOSAL_Toolkit_Guide_Derived_Numbers.md`. Next: the raising spec in `21.04/Kingmaker/`.
- 2026-10-13 — raising spec `21.04/Kingmaker/2026-10-13-kingmaker-design.md` written; the Spinner spec archived in
  `90/93/2026-10-13_ARC-0008_spinner_design`; `55/_wip/Spinner` renamed `55/_wip/Kingmaker`. Self-review found two
  open rules (Master of Healing "toward Reigning" and Master of Laws "one extra position" conflict with SP62 / can
  help the enemy) — listed in spec §14 for the Owner. Next: handoff to the Context Keeper, balance pass.
- 2026-10-13 — SP104 (Master of Healing forward only), SP105 (Master of Laws never past Fallen, never up to
  Reigning). Kingmaker Depth audit (✅ most; ⚠️ I1, W2, P7, T2, T4, D1, D2; ❌ B — balance pass) in
  `05/HANDOFF_LeadClassDesigner_to_ContextKeeper_ARC-0008.md`; handoffs to the Lore Writer (`31`) and Localization
  (`33`); `21.08` gains the Kingmaker column (Axis = Balance; Deceiver Aspect corrected to Doubt); `10.06` updated.
  Next: balance pass (`25`, `22.05`).
- 2026-10-13 — balance pass written (proposed): `22.05/2026-10-13_ARC-0008_Kingmaker_Balance.md` — Crossing 1d4/1d6/1d8
  Force, Hubris +1 die, Dethrone 3d6 (+1d6/slot), cantrip 1d6 (+1d4 vs Falling/Fallen), Cut 3d8/2d8/1d8 by position,
  Ixion 5d6, The Wheel Stops 2 turns, positions ±3 m (Longstrider / Ray of Frost patterns), goals 3/5/8; ≈ 92 % of the
  budget at T2. Six design changes for the Owner (§7) before the numbers go to `25`.
- 2026-10-13 — balance pass approved with SP106–SP111 (Coronation Bonus Action, Turn the Spoke no slot, Peripeteia
  level-3 card + once per combat, Master of Coin once per Long Rest, Crossing Force, lone enemy counts 2). Numbers in
  `25.01` (11 `SPL_Kingmaker_*`) and `25.02` (6 `FEAT_Kingmaker_*`); spec updated; validate.pl 0 errors. Next: Design
  gate (§15), then `SPEC_ARC-0008` and `TOOLKIT_ARC-0008`.
- 2026-10-13 — Design gate answered (passes with three notes: `21.01` pillars missing, complexity above the suggestion,
  T1/T3 percentages rough); `22.05` §6 gains T1 and T3 figures. Narrative gate pending (Lore Writer). Next:
  `SPEC_ARC-0008` and `TOOLKIT_ARC-0008`.
- 2026-10-13 — Owner approved the ADR-0005 amendment: `ADR-0008_Toolkit_Guides_Derived_Numbers.md`. Player-facing texts
  drafted in `55/_wip/Kingmaker/texts.md` (class, 9 passives, 15 statuses, 12 spells) against `31.03`; Narrative gate
  handed to the Lore Writer (`32.04/HANDOFF_LeadClassDesigner_to_LoreWriter_ARC-0008.md`). Next: `SPEC_ARC-0008`,
  `TOOLKIT_ARC-0008`.
- 2026-10-13 — `SPEC_ARC-0008` (stages 1–7 indexed, stage 1 in full: positions, crown, techs, The Rota, cantrip,
  Coronation, Dethrone, Turn the Spoke, Osiris goal `ARCANA_Kingmaker_Wheel`, chassis, level-1 list and progression,
  probes P1–P8) and the first Toolkit guide `TOOLKIT_ARC-0008` (stage 1, every field, goal ready to paste). Ticket
  `implementation: owner` — the Owner enters stage 1 in the Toolkit.
- 2026-10-14 — Owner's review of the Toolkit guide: the Stats Editor section is rewritten (one column per entry, at most 3
  per block, one row per field; every field listed, the `Using` parent's values resolved and marked *(parent)* so `Using`
  can be removed later; number origins under each block). Template updated the same way; `82_Automation/stats/
  resolve_stats.pl` resolves a parent's effective fields (using chain, Shared → SharedDev → Gustav → GustavDev → mod).
  Placeholder fix: an ExtraDescription reads `ExtraDescriptionParams` (vanilla, 115 spells) — Spoke of the Wheel and
  The Wheel Stops corrected in the guide and in `texts.md`.
- 2026-10-14 — Toolkit guide: `Using` written as the parent's name without the type prefix (search `ShieldOfFaith`, not
  `Target_ShieldOfFaith`); the Toolkit may show the fields in another order — match them by name. Template updated too.
- 2026-10-14 — Toolkit guide: texts with tags (`<LSTag …>`, `<br>`) wrapped in `code` inside the quotes so the
  Markdown preview (VS Code) shows them; template rule 8 + example A + heading placeholder updated.
- 2026-10-14 — Toolkit guide: every entry cell is exactly what is pasted (`code`, no quotes, no notes; `—` = empty) so a
  double-click in the preview copies it; origins (From the parent / Ours / Clears the parent) moved to Notes under
  each block. Template rules 3, 4, 6, 8, reading key and examples updated the same way.
- 2026-10-14 — Toolkit field order recorded from the Owner's Toolkit (Projectile, Rush, Shout, Target, Teleportation,
  Zone, Passive, Status_BOOST) in the template; guide rows reordered to it with Toolkit labels (Spell Animation, Intent,
  Spell Style Group); rows kept only for fields to fill, confirm or clear (7 empty no-op rows dropped; 191 values
  unchanged). MemoryCost isn't shown for Target spells: the parents' `1` stays, harmless (cards always prepared).
- 2026-10-14 — `82_Automation/stats/order_toolkit_guide.pl` (+ `t/order_toolkit_guide.t`, 7 tests): sorts a Toolkit guide's
  Stats tables and Notes in the Toolkit field order read from the template; replayed on the pre-reorder guide it
  reproduces the committed tables exactly. Template rule 3 and `82` index point to it.
- 2026-10-14 — Stage 1 entered by the Owner and reviewed against TOOLKIT_ARC-0008 (193 stats fields, goal, UUID editor,
  loca). Fixed: Spoke of the Wheel and Coronation names typed with the type prefix (Projectile_Projectile_…,
  Target_Target_… — the spell list could not find them); Coronation TargetEffect held its CastEffect; Turn the Spoke kept
  `Using` Temper and inherited its roll, effects and save (Using removed, Owner's choice); DefaultValues Skills still the
  Spinner's (now Persuasion;Intimidation;Insight;History). Spoke, Coronation and Dethrone entered without `Using` (all
  fields typed). Owner extras kept: EQP_CC_Kingmaker as ClassEquipment, class tag Sorcerer, tag THEKINGMAKER.
  Upcast variants generated (Coronation, Dethrone _2…_6), sort_stats learns the KINGMAKER group, check_cards OK,
  validate 0 errors (4 old vanilla-handle warnings). Next: Owner plays probes P1–P8.
- 2026-10-14 — Stage 2 written (Owner asked to go on before the stage-1 probes): `SPEC_ARC-0008` stage 2 (Crossing, Atropos'
  Cut, Awakening 10 - Wheel of Fortune with Tier I Tyche, Rota Fortunae; probes P9–P16) and `TOOLKIT_ARC-0008_stage2.md`
  (the whole Wheel goal replaced, 6 rows in ARCANA_Aspect_Common, LevelMap Kingmaker_Crossing, 13 entries). Found:
  upcast variants carried only the cost, so Dethrone _2…_6 dealt 3d6 — Owner chose to let the generator write the damage:
  `gen_upcast_variants.pl` reads `game_ids` + `upcast_die` from 25.01 (Dethrone 1d6, Atropos' Cut 1d8), tested on a copy
  of the mod (only Dethrone's variants change; a second run adds nothing). It also learns the Kingmaker progression.
  `gen_awakening_progress.pl` gets the WHEEL entry (enters @ORDER after stage 2 is typed). texts.md: final ids.
- 2026-10-15 — Owner: GUIDs can't be typed or found in the Toolkit. Stage-2 guide: Atropos' Cut and Rota Fortunae take
  `Using` (CloudOfDaggers, Arcana_Created_Aspect_TwoCups) only to copy Spell Animation and the effects, then drop it;
  TooltipUpcastDescription given by its list name (*Additional damage*). Template rule 12 (look fields via `Using`,
  list tooltips by name, read from vanilla TooltipExtras) for every next guide, ARC-0009 included.
- 2026-10-15 — implementation owner → **claude** (Owner, option 1): the Owner types each stage in the Toolkit; when the
  Owner asks, Claude fixes what the review finds and runs the generators in the game files. Stage 1's fixes and generator
  run were written before this change (the jt-gate heuristic didn't see the game path inside the scripts).
- 2026-10-15 — Stage 2 entered by the Owner; reviewed against TOOLKIT_ARC-0008_stage2 (105 stats fields, goal identical,
  Common rows, LevelMap, level-3 list and progression, look fields equal to their parents). Fixed: Rota Fortunae kept
  `Using` Two Cups and inherited its 18 m area, mood targets and Psychic damage (Using removed); the level-3 list was
  named "Kingmaker Level 2". Generated: Atropos' Cut _3…_6 (4d8…7d8 / 3d8…6d8 / 2d8…5d8) and Dethrone _2…_6 damage
  (4d6…8d6); WHEEL in gen_awakening_progress (ASPECT_PROGRESS_WHEEL_I–III, countdown rows in Common; Awakening text
  already identical). sort_stats: KINGMAKER walked from its progression + `KINGMAKER_`/`COURT_` by name (only Kingmaker
  entries changed group). check_cards OK, validate 0 errors. The Owner recompiles the Story (Common, CardFamilies
  changed), then plays P9–P16 (and P1–P8).
