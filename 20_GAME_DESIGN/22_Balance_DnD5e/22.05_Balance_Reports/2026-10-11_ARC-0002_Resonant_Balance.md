# Resonant · balance pass (ARC-0002, 2026-10-11)

The arithmetic behind the Resonant's numbers. **The values themselves live in `25_Master_Data`**
(`STA_Resonant_*`, `FEAT_Resonant_*`, `SPL_Resonant_*`); this report explains them and how to check them.
Design: `21.04/Resonant/2026-10-11-resonant-design.md`. Approved by the Owner on 2026-10-11.

## Assumptions

The currency and parameters of `22.06/Arcana_Power_Budget.md`: 1 point = 1 expected damage on one target;
E = 4 encounters, T = 4 turns; A (the reference action) = 4 / 8 / 11 in tiers 1 / 2 / 3. Enemy Wisdom save
fail chance against the Arcana DC (humanoids, −2): ≈ 0.55 (T1), 0.60 (T2), 0.65 (T3). Woven Spell Slot
level 1/2/3/4/5/6 at character levels 1/3/5/7/9/11; a Surge gains one target per slot level above 1.

## 1. Catharsis — `STA_Resonant_Catharsis`

With the refund on reaction (R16), the Surge that causes a reaction costs only its action, so it competes
with a cantrip turn (A).
- 2d8 fixed: 9 × 0.6 = 5.4 at T2 (A = 8) and 9 × 0.65 = 5.9 at T3 (A = 11) — **weak**.
- Scaling with the cantrip breakpoints: 3d8 at 5 → 13.5 × 0.6 ≈ 8.1 = A; 4d8 at 10 → 18 × 0.65 ≈ 11.7 ≈ A.
- Ally side: 2d8 healing × 0.48 (0.6 per HP × 0.8 efficiency) ≈ 4.3 ≈ A at T1; scales the same.
- Tier I bonus +1d8: ≈ +2.6 points per enemy Catharsis at level 3.

## 2. Overload — `FEAT_Resonant_Overload`, `SPL_Resonant_EmotionalOverload`

**Value of the ultimate.** Paralysed ≈ 3.5A per turn; two turns with no save ≈ 7A, ≈ 5.8A against bosses
(legendary resistance factor 0.83), or ≈ 4A once the turns left in a fight are counted. If it came every
fight (U = E = 4) it would be ≈ 40 % of the daily budget D — above a capstone (≈ 20 %).

**The fix is when it arrives, not what it does.** Fill per turn ≈ 0.8 per Surge target (peaks +1 that land
≈ 60 % on enemies, 100 % on allies; reactions +2). Targets grow with slot level, so the size grows with it:
**3 × slot level + 2** fills around **turn 4** at every level. Normal fights (3–5 rounds) rarely reach it;
long and boss fights reach it once → U ≈ 1–2 per day → ≈ 10–20 % of D, the range of a main feature.

**Holding it:** Psychic damage equal to the slot level per turn ≈ 13 % of the Resonant's hit points;
≈ 2 points per turn held — enough to weigh the choice, not to punish it.

**Damage per feeling** 1d6: the target usually carries 1–2 feelings; the value is the paralysis.

**Tier III area** (target 2 turns, others within 6 m with a feeling 1 turn): ≈ +1.5 targets × 3.5A × 0.9
≈ 4.7A per use at T3; with U ≈ 1.5 it adds ≈ 15 % of D, inside a Tier III peak.

## 3. Aspect Awakening — `FEAT_Resonant_AspectAwakening`

Reactions per turn from turn 2: ≈ 1.3 at level 3 (2 targets), ≈ 2.6 at level 7 (4), ≈ 4 at level 12 (6).
- Tier I = 3 → turn 3–4 at level 3 (reachable in a normal fight).
- Tier II = 6 → turn 3–4 at level 7.
- Tier III = 15 → about turn 5 at level 12 (a long fight). The old goal (7) arrived on turn 2.

## 4. Shared Heart — `SPL_Resonant_SharedHeart`

As first written (one Surge on a linked ally lands on all) it saved only targets the level-11 upcast
already gives (6 targets, party of 4): ≈ 5A per fight against ≈ 9A for a capstone. With **Surges on
linked allies costing no slot or Thread until combat ends** (R24): ≈ one free Surge per turn ≈ S(6) worth
of slots over a fight → ≈ 9A. On target.

## 5. Heartstring and feelings

- Heartstring 1d4 → 2d4 → 3d4 Psychic: below A (≈ 1.4 at T1), like Vicious Mockery; its value is keeping
  a mood alive (≈ 0.3A).
- Feelings keep the draft dice (Remorse, Aggressiveness, Delight, Pessimism, Morbidness 1d4–1d6); the
  arithmetic asked for no change. Optimism: temporary HP equal to the Intelligence modifier, as Heroism.

## 6. How to check (playtest)

| Fight | Metric | Proves it wrong |
|---|---|---|
| Normal fight, level 5, 3–4 humanoids | Turn the Overload fills | Full before turn 3 (too fast) or never by turn 5 |
| Boss fight, level 7–9 | Emotional Overload used once; boss turns lost | Used twice, or the fight ends on it |
| Any fight, level 3 | Turn Tier I awakens | After turn 5 |
| Level 12, long fight | Turn Tier III awakens | Before turn 4 |
| Level 5–10 | Catharsis damage vs. the Resonant's cantrip | Catharsis below the cantrip on average |
