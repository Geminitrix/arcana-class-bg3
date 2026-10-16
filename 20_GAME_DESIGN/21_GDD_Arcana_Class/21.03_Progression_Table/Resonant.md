---
id: 21.03/Resonant
owner: Lead Class Designer
source: 21.04_Subclasses/Resonant/DESIGN.md §10 (R59, R67)
reviewed: 2026-10-16 ARC-0014 — rewritten with the spread map (R59) and the 1/5/9 growth (R67); build pending; 2026-10-16 ARC-0021 — display name *Heartsong* (R69)
---

# 21.03 · Progression — The Heartsong (internal: Resonant) (levels 1–12)

What each level grants **on top of the base class** (`21.03/Arcana.md`). **Approved design (R1–R68); the game still
has the R1–R48 map** (odd levels only — `05.02/Resonant.md`) until the ARC-0014 build ships. Numbers:
`25_Master_Data` (`*_Resonant_*`). Cards are listed by in-game name; ids in `23.02_Spell_Sheets/Resonant/`.

| Level | Passives | Cards and features | Why here |
|---|---|---|---|
| **1** | Emotional Alchemy (refund, R49, kindness rule) · Empathic Sight · Overload · *(hidden)* Emotional Overload's free cast | *Weave Surge* (container): Joy, Trust, Fear · Heartstring · Emotional Overload I | The mechanic plays from level 1: two primary feelings, and the meter's release |
| **2** | — | *Weave Surge*: Anticipation · Temper (Bonus Action) | A second play each turn; Optimism |
| **3** | Opposites *(working name)* · Tier I Resonance · 14 - Temperance: Awakening | *Weave Surge*: Surprise, Sadness · Aspect card The Two Cups (conjured when Tier I wakes) | The first opposite pairs: Catharsis is taught when it is usable |
| 4 | — (feat) | — | — |
| **5** | — | *Weave Surge*: Disgust, Anger (the full wheel) · Emotional Overload II (two targets) · first growth step | The full wheel and a stronger release at vanilla's level-5 spike |
| **6** | Complex Feelings | — | Distance 2 alone, one level after the wheel completes |
| **7** | Overwhelm · Tier II Harmony | — | Distance 0, once per creature per fight |
| 8 | — (feat) | — | — |
| **9** | Mixed Feelings | Emotional Contagion · Emotional Overload III (the area) · second growth step | Distance 3; feelings spread through a crowd |
| **10** | — | Ready: Compassion (reaction card) | Answers an ally's pain |
| **11** | — | Shared Heart (capstone, level 5 card) | Links the party; Joy on cast |
| **12** | Tier III Aspect of Empathy | — | The dam breaks: the meter fills, the dance lasts longer |
| 13–20 | Reserved (expansion module, `21.07`) | | |

Emotions are level-1 cards and gain one extra target per slot level above 1 (generated upcast variants). Emotional
Overload's ranks follow its slot variants (1–2, 3–4, 5–6). Growth steps (the dice states, *Overloaded*, Catharsis) at
levels 5 and 9; Heartstring's base damage keeps the vanilla cantrip map.
