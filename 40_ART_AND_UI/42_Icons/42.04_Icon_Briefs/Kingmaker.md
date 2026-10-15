---
id: 42.04/Kingmaker
owner: Icon Artist
source: 21.04/Kingmaker/DESIGN.md §2, §4.2, §12; 31.02/Kingmaker.md; icons in game (Stats `Icon`, dossier_texts.pl --icons, 2026-10-15)
reviewed: 2026-10-15 ARC-0008 — created (propagation, 00.08)
---

# 42.04 · Icon briefs — The Kingmaker

**State today:**
- **Subclass icon — doesn't show in game.** The art exists as the Spinner (`42.02/class_and_subclasses/spinner.png`,
  `…_ready_to_convert/classicons_spinner.png`) and the game has `Spinner.DDS` in the four ClassIcons folders, but the
  ClassDescription `Name` is now `Kingmaker` and the file name must match it (`bg3_class_icon_folders`). Fix in SPEC
  stage 7 ("renames and icons"): `Kingmaker.DDS` in all four folders, then the Toolkit package regenerates
  `GUI/metadata.lsf`. Whether the Wheel-of-Fortune art still fits the Kingmaker is the Owner's call.
- Every Kingmaker spell, passive and status borrows a **vanilla** icon. **`Spell_Enchantment_CrownOfMadness` is shared by 6**
  visible entries (Coronation, King's Hand, King, Hubris ×2, Succession) and **`Spell_Divination_DetectThoughts` by 6**
  (the Awakening and its three tiers, Rota Fortunae, Master of Secrets) — the hotbar can't tell them apart.
- `42.02/features/the kingmaker/` is empty (renamed from *the spinner* 2026-10-15).

**Family style:** the Rota Fortunae — a wheel with four points, crowns, threads — in the subclass teal `#60d7d2` with
gold for crowns. The four positions read as a cycle: one point of the same wheel lit per position.
Pipeline: source `42.01` → PNG `42.02/features/the kingmaker/` → DDS BC7 `42.03`; origin in `00.06/ASSET_ORIGIN_REGISTER.md`.

| Icon | For | Subject · symbol | Palette | Replaces (vanilla today) | Priority |
|---|---|---|---|---|---|
| ICO_Kingmaker_Subclass | Subclass (4 ClassIcons sizes) | Rename/convert the existing art as `Kingmaker` | Teal + gold | `Spinner.DDS` (name mismatch) | **1** |
| ICO_Kingmaker_Coronation | Coronation | A crown lowered onto a figure at the wheel's rim | Gold + teal | CrownOfMadness (shared) | **1** |
| ICO_Kingmaker_Awakening | 10 - Wheel of Fortune: Awakening and its tiers (Tyche, Nemesis, Aspect of Anticipation) | The Wheel of Fortune card glowing, one spoke lit per tier | Gold + teal | DetectThoughts (shared) | **1** |
| ICO_Kingmaker_RotaFortunae | Rota Fortunae (Aspect card) | The four-figure wheel mid-turn — card art style | Gold, teal | DetectThoughts (shared) | **1** |
| ICO_Kingmaker_Hubris | Hubris (passive and status) | A crown tipping off a climbing figure | Teal + red | CrownOfMadness (shared) | **1** |
| ICO_Kingmaker_Succession | Succession | A fallen crown and a hand reaching for it | Gold, grey | CrownOfMadness (shared) | 2 |
| ICO_Kingmaker_King | King (status) and King's Hand | A crown on the wheel's top point (King's Hand: the crown held in a hand) | Gold | CrownOfMadness (shared) | 2 |
| ICO_Kingmaker_MasterOfSecrets | Master of Secrets (option and status) | An eye behind a half-drawn curtain | Teal + violet | DetectThoughts (shared) | 2 |
| ICO_Kingmaker_Positions | Rising · Reigning · Falling · Fallen | The same wheel, one of its four points lit | Teal; gold at Reigning | Longstrider · Bless · Bane · Status_Prone | 2 |
| ICO_Kingmaker_TheRota | The Rota and Convene the Court | A wheel turning (Court: a round table of seats) | Teal | Action_Mag_AuraOfLeadership (×2) | 2 |
| ICO_Kingmaker_Crossing | The Crossing (passive, tech statuses) | Two figures passing on the wheel, one up, one down | Teal + force violet | MagicMissile (×3) | 2 |
| ICO_Kingmaker_Foreseen | Ready: Foreseen, Foreseen, Foreseen ready | An eye in the wheel's hub | Teal | TrueStrike (×3) | 3 |
| ICO_Kingmaker_TheWheelStops | The Wheel Stops (card and status) | A wheel pinned by a nail | Teal + steel | Transmutation_Slow (×2) | 3 |
| ICO_Kingmaker_Dethrone · TurnTheSpoke · AtroposCut · Peripeteia · Usurp · WheelOfIxion · SpokeOfTheWheel · FortunesReach | The other cards and the level-12 passive | A crown cast down · a hand on one spoke · shears on a thread · the wheel turned upside down · two seats trading · a burning wheel · a spoke thrown · the wheel's shadow over the field | Teal (Ixion: fire orange) | Each has its own vanilla icon today | 3 |

Priority 1 = the subclass icon (missing in game) and the icons shared by several hotbar entries. Court office statuses and
technical statuses keep vanilla icons until a status-icon pass is decided.
