# 2026-10-23 · The Owner's Windborn build, propagated (ARC-0026, Producer)

**Done:** the Owner changed the Windborn in the Toolkit while playing levels 1–8 (commit `60afc0e`, notes in
`QA_ARC-0026`). Read entry by entry (the diff of the Editor `.stats` and the loca) and recorded as decisions **WB52–WB61**:
the Rush stays 9 m and costs movement; Storm's second Rush on casting, 12 m, any enemy; **Zephyr: Tempest** (L7) replaces
Storm Fists; **Zephyr: Ally Tempest** (L10) replaces Leap of Faith; **Unleashed Winds** (L11) replaces Where the Winds
Meet; the Windswept split through Wind Whispers, Gale Deflection and Empty State; out of combat; Weightless +4 / +7 / +10 /
+13 m; winds don't refresh; the West Wind voice and the Owner's icons. The Owner confirmed two points: Leap of Faith leaves
the kit, and the capstone is named Unleashed Winds.

**Propagated (00.08):** DESIGN, 21.03, 21.08, 23.02 (17 sheets regenerated), 25 (Zephyr: Tempest, Ally Tempest,
Unleashed Winds new; The Open Road, Weightless, Gale Deflection to the game's values; Storm Fists, Leap of Faith and
Where the Winds Meet archived to `93/2026-10-23_ARC-0026_Windborn_retired`), 22.05, 26.01, 31.02, 32.01, 33.03, 42.04,
05.02 (rewritten from the game), QA_ARC-0026 (no tested id renumbered; new tests for every changed rule).

**Fixed (tools):** `check_cards.pl` flagged `ARCANA_Aspect_Fool.txt` for comparing The Calm by name. The Calm pays no
slot, so it has no variant and the name is exact: the check now skips cards without a slot cost. `check_cards`: OK.

**Waiting on the Owner (`[fechado] ARC-0026`):** SPEC_ARC-0026 "Fixes owed" F1–F22 — Zephyr Strike shows "Zephyr Rush"
(shared name handle), Unleashed Winds' `TargetConditions` miss an `and`, Gale Deflection's `Level`, the Ally Tempest
status icon, eleven text slips ("Weast", "Winswept", "Whind Whispers", "Unleash Winds", …), and the PC deck (still
conjures Leap of Faith). Four names to confirm (Q1–Q4): Twinkle Toes or Weightless, Agility or Flowing Strikes, Extra
Attack or Flowing Assault, Gale Deflection one use per turn or per cast.

**Later the same day — applied (`[fechado] ARC-0026`, commit `dbc714b`):** F1–F22 in the game and the Owner's answers as
**WB63**: Twinkle Toes, Agility, Precision and the vanilla Extra Attack keep their names; Ready: Gale Deflection is once a
turn (the reaction refills each turn; one Unique card on PC). Lua tests: 138 pass. Still open: Unleashed Winds is locked
in combat on PC (no conjure yet).
