---
id: 21.04/Unbound/DECISIONS
owner: Lead Class Designer
role: source of the Unbound (Windborn) dossier (00.08) — every decision is logged here the moment it is taken
---

# The Windborn (Unbound) — decision log

The display name is **The Windborn** (ARC-0021, Owner, 2026-10-16); ids, folders and this dossier keep the internal
name **Unbound** (ADR-0002). Decisions come from the refining of ARC-0022 (`REFINE_Unbound.md`). Where a later
decision replaces an earlier one, the later one says so; `DESIGN.md` shows only the result.

## Decision log

| # | Decision | Source |
|---|---|---|
| WB0 | Display name **The Windborn** (was The Unbound); internal ids unchanged | Owner, 2026-10-16 (ARC-0021) |
| WB1 | The Windborn is a **monk-like** martial, closest to the **Air Nomads** (*Avatar: The Last Airbender*). Its kit leans on **cards that enable passive states** (and on passives); this is by design, not a gap to fix | Owner, 2026-10-16 |
| WB2 | Axis (`_SUBCLASS_STANDARD.md` §2.3): **Position** — *where is everyone, and where do I go?* | Owner, 2026-10-16 (proposal accepted) |
| WB3 | Core mechanic: **The Open Road** (`REFINE_Unbound.md` §5, direction A) — the **Windswept** mark on each enemy struck; the wind rewards striking an enemy that isn't marked yet; an ultimate that releases every mark at once (working name *Aeolus' Bag*). Rules, reward and names still open | Owner, 2026-10-16 (direction A accepted) |
| WB4 | **Zephyr Strike is the signature button** and ranks up along the **Beaufort scale** bands (Breeze → Gale → Storm → Hurricane); levels and effects of each rank open | Owner, 2026-10-16 (direction B as ranks accepted) |
| WB5 | The wind's reward: **Zephyr Strike against an enemy that isn't Windswept is a Rush** — it carries you to that enemy (range ‹…›) and strikes, with the `Rush_SpringAttack` animation (the one vanilla `Rush_MAG_ZephyrFlash` uses). Against a Windswept enemy it is a plain strike | Owner, 2026-10-16 (option A accepted) |
| WB6 | The **push** (‹…› m) joins Zephyr Strike at the **Gale** rank, not before | Owner, 2026-10-16 |
| WB7 | **Leap of Faith** moves to the `Rush_ForceTunnel` animation (a dash through a line), so the Aspect card and the signature button look different; its VFX are swapped to wind | Owner, 2026-10-16 |
| WB8 | **What marks (the Touch of the Wind):** an enemy becomes **Windswept** when any attack of yours hits it, or when it fails a saving throw against any effect of yours (cards included). Duration, the ally rule and the Awakening alignment still open | Owner, 2026-10-16 (option 1 of 3 accepted) |
| WB9 | **Duration — inhale and exhale:** Windswept lasts **until the end of your next turn**. One turn builds marks, the next releases them (the ultimate) or moves on to enemies not yet marked; you can't Rush the same enemy two turns in a row. Marks from reactions count. Rule for small fights (every standing enemy marked) still open | Owner, 2026-10-16 (option 2 of 3; "the full circle" and its variants 3A–3C weighed and set aside) |
