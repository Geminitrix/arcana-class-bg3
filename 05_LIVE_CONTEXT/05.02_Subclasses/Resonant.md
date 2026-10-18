---
source: 51 (Progressions, Lists, Stats, Story goals; dump_progression.pl 2026-10-15) · 21.04/Resonant/DESIGN.md · HANDOFF ARC-0002 §9–§11
synced_at: 2026-10-17 (progression after ARC-0017 stages 1–4, ARC-0027)
state: synced
reviewed: 2026-10-16 ARC-0014 — no change in the game; R49–R68 are an approved design, build pending (21.04/Resonant/DESIGN.md); 2026-10-16 ARC-0021 — display name checked, no change
---

# 🌈 The Resonant — XIV · Temperance · Aspect of Empathy

**Built and tested in the game files (levels 1–12, ARC-0002 closed 2026-10-12); not in the published 3.1.0.28.**
> **Refining build ARC-0017, stages 1–4 in the game since 2026-10-16** (R49–R68: one *Weave Surge* card with a child per
> emotion, Temper at 2, Opposites, Deeper Feelings at 5 and 9, Emotional Overload at 1, Ready: Compassion at 10); its 33
> tests wait for the Owner (`QA_ARC-0017`). The progression below is the game today; the rules sections still describe
> R1–R48 where R49–R68 changed them — the design is `21.04/Resonant/DESIGN.md`.
Control and support through emotions; casts with INT, secondary WIS. Design: `21.04/Resonant/DESIGN.md`;
decisions R1–R48: `21.04/Resonant/DECISIONS.md`. Tag `THERESONANT` (`c3a59afe-c03e-4fe0-9c7c-dc45ee46e21e`).

## Chassis
Saves WIS, CHA · Light armour · Daggers, Quarterstaffs, Light Crossbows, Darts · skill list *The Empath* (4 + 2
Expertise) · preset STR 8 DEX 10 CON 10 INT 15 WIS 15 CHA 13 · starting gear `EQP_CC_Resonant` · sound set Cleric ·
colour coral.

## Progression in the game
| Level | Granted |
|---|---|
| 1 | Weave Surge (container, a child per emotion) · Heartstring (cantrip) · Emotional Overload · passives Emotional Alchemy, Empathic Sight, Overload |
| 2 | Temper |
| 3 | Opposites · Tier I Resonance · *14 - Temperance: Awakening* |
| 5 | Deeper Feelings |
| 6 | Complex Feelings |
| 7 | Overwhelm · Tier II Harmony |
| 9 | Deeper Feelings · Emotional Contagion · Mixed Feelings |
| 10 | Ready: Compassion |
| 11 | Shared Heart |
| 12 | Tier III Aspect of Empathy |

## How it works in the game
- **Weave Surges** target any creature (allies never roll, `SpellAutoResolveOnAlly`), never constructs. A peak (1 turn)
  changes behaviour and fades into a mood (5 turns); a Surge on a mood reacts by distance on the wheel — feeling,
  Intensify (7+), Catharsis — and refunds the slot once per turn (Osiris `ARCANA_Resonant_Overload`).
- **Overload** from level 1: +1 per peak, +2 per reaction; carries over between combats; shown as a percentage (not at
  0 %). Full → *Overloaded* (silenced, Psychic each turn and on weapon hits, character-level turns). **Emotional
  Overload** (5+, Bonus Action, not a spell) spends it: Paralysed 2 turns, Psychic per feeling.
- **Temper** (Bonus Action; PC 1 Thread) replays the mood's root emotion for 1 turn. **Emotional Contagion** copies the
  target's mood to its allies within 6 m (Concentration). **Ready: Compassion** casts Trust on an ally hit by an enemy,
  once per round. **Shared Heart** (Unique, once per long rest) links allies within 18 m: feelings are shared, a
  Catharsis heals them all.
- **Aspect Awakening 14 - Temperance:** goal = reactions caused, **counts down** what is left (3 / 6 / 15); I Resonance
  (Catharsis +1d8, moods 7 turns, The Two Cups) · II Harmony (feelings 4 turns, first Surge each turn costs no action
  and leaves its mood at once) · III Aspect of Empathy (Emotional Overload paralyses enemies with feelings within 6 m).
- Goals: `ARCANA_Resonant_Overload`, `ARCANA_Resonant_Grudge`, `ARCANA_Aspect_Temperance`, `ARCANA_Resonant_SharedHeart`.
  Generator `82_Automation/stats/gen_emotion_alchemy.pl`. Every id: `05.03`, `05.04`.

## Strengths · weaknesses
Control from level 1 · one spell buffs or debuffs · ally effects never roll · slots last through refunds —
needs a turn of setup · enemies resist with WIS saves · constructs feel nothing · the Overload hurts if held.

## Depth audit (2026-10-11, updated 2026-10-15)
Against `21.04/_SUBCLASS_STANDARD.md` §3; the gaps found before the raise were closed by R1–R48 (HANDOFF ARC-0002 §2).

| Question | State | Evidence / what is still due |
|---|---|---|
| I1 fun | ✅ | Probes P0–P33 played and passed (Owner, 2026-10-11/12); balance playtest still proposed (ARC-0010) |
| I3, S3–S6, I6 | ✅ | Archetype "the empath who plays the room"; Iris, Harmonia (R2); fiction R3; Heartweaver names retired (R20–R21, ARC-0003) |
| M3–M6, K2–K6 | ✅ | Emotional Alchemy at 1, converters, ultimate Emotional Overload, Temper and Heartstring at 1–3 |
| P5 fight length | ✅ | Slot refund on a reaction, once per turn (R16) |
| A2 tiers | ✅ | Tier III Aspect of Empathy (R14) |
| B1–B4 | ⚠️ | Numbers in `25`; Emotional Overload 3–4 uses a day since R31 and Harmony to watch (`22.05/Resonant.md`) |
| D2 sources agree | ⚠️ | Two descriptions behind the mechanic (ARC-0011); the player guide (`75.02`) still shows the old kit (ARC-0006) |

Every other question: ✅.

## Open
Balance watch (`22.05/Resonant.md`): Emotional Overload frequency, Harmony. Texts: two descriptions behind the mechanic
(`32.01/Resonant.md`). Icons all borrowed (`42.04/Resonant.md`). Player guide: ARC-0006 (after the rework).
