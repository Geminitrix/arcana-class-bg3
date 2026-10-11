---
id: SPEC_ARC-0001
ticket: ARC-0001
status: ready
implementation: owner
author: Mod Engineer
updated: 2026-10-11
---

# SPEC_ARC-0001 · Remove the dead PassivesRemoved at Deceiver level 20

Intent: leave no dead instructions in the Deceiver progression; no change in play.

## Item index — implement top to bottom

| # | Type | Subtype | Internal entry | Where in the Toolkit | Depends on | Done |
|---|---|---|---|---|---|---|
| 01 | Progression | level 20 | Deceiver · row `2c4887f9-d4f8-4a95-974c-519643440029` | UUID Object Editor → Progressions | — | ☐ |

---

## 01 · Progression — Deceiver level 20

- **File:** `Public/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Progressions/Progressions.lsx`
  (the Toolkit keeps the editor copy in step).
- **Find it:** table `TableUUID` = `8fe1f693-d8ff-4b02-a655-efd4acbc04cb` (Deceiver), `Level` = 20,
  `UUID` = `2c4887f9-d4f8-4a95-974c-519643440029`.

| Field | Value now | Value after | Origin |
|---|---|---|---|
| `PassivesRemoved` | `Arcana_Passive_UnlockFriends` | *(empty — clear the field)* | `10.06/Open_Questions.md` item 7 |
| every other field | — | unchanged | — |

- **Do not touch:** the Stats entry `Arcana_Passive_UnlockFriends` in `Passive.txt` (published entries are
  never deleted, `57.06`).
- **Approved text:** none.
- **How to verify:**
  1. Save in the Toolkit; close it.
  2. Tell Claude "ARC-0001 feito" — it runs `sync_data`, `validate.pl`, `compare_versions.pl` and
     `dump_progression.pl`: Deceiver L20 must list nothing.
  3. In game: nothing to see (level 20 is beyond the core); no test save needed.

## Acceptance criteria
See the ticket.
