---
id: SPEC_ARC-####
ticket: ARC-####
status: draft            # draft | ready | implemented | verified
implementation: pending  # pending (design only) | owner (the Owner types it; Claude verifies and fixes)  (OR-11)
author: Mod Engineer
updated: YYYY-MM-DD
---

# SPEC_ARC-#### · <feature name>

Intent (one sentence, from the ticket): …

## Item index — implement top to bottom

| # | Type | Subtype | Internal entry | Where in the Toolkit | Depends on | Done |
|---|---|---|---|---|---|---|
| 01 | Status | `BOOST` | `EXAMPLE_STATUS` | Stats → StatusData | — | ☐ |
| 02 | Passive | — | `Arcana_Passive_Example` | Stats → PassiveData | 01 | ☐ |
| 03 | Spell | `Target` | `Target_Arcana_Card_Spell_Example` | Stats → SpellData | 01 | ☐ |
| 04 | Spell list | — | list "…" (UUID) | UUID Object Editor → Lists | 03 | ☐ |
| 05 | Progression | level N | table UUID | UUID Object Editor → Progressions | 03, 04 | ☐ |
| 06 | Localization | — | handles | Localization | — | ☐ |
| 07 | Icon | — | `ICO_…` | GUI / atlas | — | ☐ |

Types and subtypes come from `55.00_Type_Catalog.md`. Order: status → passive → spell → list →
progression → class/subclass → localization → icon. **Feature by feature, never level by level (OR-5):** each
item carries every level form of its feature (growth, upcasts, status steps); what each level grants appears once,
in the list and progression items. Every id follows OR-59 (statuses UPPER_SNAKE_CASE without `ARCANA_`).

---

## 01 · <Type> `<internal entry>`

- **Files:** `Public/AspectClass_…/Stats/Generated/Data/<file>.txt` + its editor twin `Editor/Mods/AspectClass_…/Stats/…/<file>.stats`
  (LSX tables: `Public/…/*.lsx` + `Editor/Mods/…/*.tbl`) — both change together
- **Inherits (`using`):** — / `<parent entry>`
- **Vanilla anchor:** `<entry>` in `<vanilla file>` (grounding, OR-13)

| Field | Value | Origin (25 id) |
|---|---|---|
| `…` | `…` | `SPL_…#field` |

- **Depends on:** item NN
- **Approved text** (from `32.04`): DisplayName `h…;1` = "…"; Description `h…;1` = "…"
- **How to verify in game** (save from `83.02`):
  1. …
  2. …

---

## Acceptance criteria

- [ ] …
