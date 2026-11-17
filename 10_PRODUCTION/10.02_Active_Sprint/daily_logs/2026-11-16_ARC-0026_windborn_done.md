# 2026-11-16 · The Windborn is done (ARC-0026, Producer)

**Done:** the Owner played QA_ARC-0026 to level 12 and asked to mark the subclass ready. Results synced from Arcana
Test Guides: 65 done - 63 pass, 2 skipped (L1.11 and L2.6, the PC edition deck; the Owner does not play them). The
Owner's notes that say "changed" were read against the game files.

**Found in the review and settled the same day:**
- Eight game files the Owner changed in the Toolkit were never committed: committed by ticket (`b071443` Windborn,
  `443a1eb` Kingmaker).
- Fellow Travellers now marks only on a damaging hit (`ARCANA_Aspect_Fool`, `AttackedBy` damage above 0); the Owner
  recompiled the Story at 23:34, 0 errors. Recorded as **WB67**.
- Zephyr: Ally Tempest is cast on herself and gives every ally its rider through `ZEPHYR_TEMPEST_ALLY_AURA`, melee only
  (QA note L10.1). Recorded as **WB66**. The Owner fixed the aura's text ("Your allies'").
- Empty State: the L9.3 note "Não existe mais" was a mix-up (Owner); the passive is unchanged.
- Stage 6: the six Windborn `pending_build` blocks in `25` moved into values, each checked against the game. The game
  rolls **1d4** for Notus (saves) and Eurus (attacks), not the planned flat 1, as `05.02` already said.

**Propagated (00.08):** DECISIONS (WB66-WB67), 05.00, 05.02, DESIGN, 21.03, 22.05, 23.02 (Ally Tempest, Awakening),
25 (Ally Tempest + six stage 6 files), 32.01, README. `check_propagation` OK, `check_readme` OK, `validate` 0 errors.

**Open, not blocking:**
- 22.05: Zephyr: Ally Tempest was estimated for one ally with weapon hits; WB66 gives it to every melee ally - re-estimate.
- The PC deck tests (L1.11, L2.6) were not played.
- The new texts (Earthly Ties, Ally Tempest Aura) exist only in English; the other 14 languages wait for a translation sync.
- The Story Editor writes one LF line at the end of `ARCANA_Aspect_Fool`; `check_osiris` reports it, the game compiles clean.
