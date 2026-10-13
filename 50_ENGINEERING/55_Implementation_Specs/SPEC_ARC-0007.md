---
id: SPEC_ARC-0007
ticket: ARC-0007
status: planned
implementation: claude
author: Mod Engineer
updated: 2026-10-12
---

# SPEC_ARC-0007 · Aspect Awakening counts down

**Intent** (Owner, 2026-10-12): the number on the Awakening status says **how much is left** to the next tier, so the
player never has to open the passive to know the goal. Same for every subclass, with one standard text.

**Decisions (Owner):** a fixed name, *Awakening*, and a one-line description "<what> left to <verb> to awaken <next
tier>."; the five "<N> - <Arcanum>: Awakening" passives rewritten in one shape.

## What changes, per Aspect

| Subclass · Aspect | Goals (tier I / II / III) | Counts down | Unit shown | Conversion in Osiris (`ARCANA_Aspect_Common`) |
|---|---|---|---|---|
| Unbound · 0 The Fool | 3 / 4 / 5 different enemies in one round | enemies left to hit **this round** | count | goal − value |
| Deceiver · 2 The High Priestess | 4 / 7 / 10 Doubt stacks | stacks left to apply | count | goal − value |
| Resonant · 14 Temperance | 3 / 6 / 15 reactions | reactions left to cause | count | goal − value |
| Starchild · 17 The Star | heal 5× / 8× / 12× your level | **hit points** left to heal | HP | ⌈(goal − value) × level ÷ 100⌉ (value is healing × 100 ÷ level) |
| Eternal · 13 Death | lose 30 / 50 / 70 % of max HP | **hit points** left to lose | HP | ⌈(goal − value) × max HP ÷ 1000⌉ (`GetMaxHitpoints`; value is loss × 1000 ÷ max HP) |

Tier names (from the tier passives): Fool — Wanderlust, Restless Wind, Aspect of Curiosity; High Priestess — Veiled,
Two Pillars, Aspect of Doubt; Temperance — Resonance, Harmony, Aspect of Empathy; Star — Beacon, Sunrise, Aspect of
Hope; Death — Sorrow, Mourning, Aspect of Sorrow.

## Tasks

| # | What | How | Test |
|---|---|---|---|
| 1 | **One progress status per tier** (the text names the next tier) | `ASPECT_PROGRESS_<X>_I/_II/_III` — 15, one StackId per Aspect (`ASPECT_PROGRESS_<X>`, `Overwrite`, so the next replaces the last), `FreezeDuration;IgnoreResting;ForceOverhead`, `RemoveEvents OnCombatEnded`, name *Awakening*, text e.g. "Reactions left to cause to awaken Resonance." / "Hit points left to heal to awaken Beacon." / "Enemies left to hit this round to awaken Wanderlust." The old `ASPECT_PROGRESS_<X>` stay as the StackId owners only if needed — else retired | a small generator `gen_awakening_progress.pl` + its `.t`: 15 entries, shared StackIds, one-line texts, ASCII |
| 2 | **Countdown in `ARCANA_Aspect_Common`** | `DB_ARCANA_AspectProgress(aspect, tier, status)` rows; `PROC_ARCANA_Aspect_Display` shows the **next tier's** status with: `COUNT` → goal − value; new `HEAL` (Star) and `LOSS` (Death) → the HP conversions above. `ShowNumber` loses its `< 100` cap (it was for percentages) — **probe**: does a frozen duration over 99 turns still show its number? Reset removes the 15 | Osiris compile 0 errors; the anchored script's dry run |
| 3 | **The five Awakening passives in one shape** | "<What you do> during a fight to awaken the Aspect of <X> until combat ends. Each goal you reach awakens one more tier.<br><br>Level 3: <goal> to gain <I>.<br><br>Level 7: <goal> to also gain <II>.<br><br>Level 12: <goal> to awaken as the Aspect of <X>." — the strings change in place (same handles, version +1); Temperance's comes from `gen_emotion_alchemy.pl` | the five texts follow the shape |
| 4 | **Fool's round** | the Fool already offers the round's count (`DB_ARCANA_WanderCount`); the countdown reads it the same way and resets each round | probe |

**Apply** (`[fechado] ARC-0007`): the new generator → `stats_add` → the Common script → `sort_stats` → `check_cards` →
`selftest` → line lengths / repeated fields → `sync_data` → commit. **Owner:** compile the Story.

## Probes

| # | Do | Proves it works |
|---|---|---|
| A1 | Each subclass, level 3, start a fight | *Awakening* shows the full first goal (3 reactions, 4 Doubt, 3 enemies, 5 × level HP, 30 % of max HP in HP) |
| A2 | Make progress | The number goes down; at 0 the tier awakens and the number shows what the next tier needs |
| A3 | Star at level 12 (60+ HP to heal) | The number over 99 still shows — else report it (plan B: show in tens) |
| A4 | Fool | The count resets at the start of each round |
| A5 | Tier III reached | *Awakening* disappears |
