# HANDOFF · Lead Class Designer → QA Lead · ARC-0002 (the Resonant)

**Ask:** turn this into `61.02_Test_Cases/TC_ARC-0002.md` (the TC_ARC-0001 format) and run what is still open.
**Decision it informs:** close ARC-0002, or send the failing rule back to the Lead Class Designer.
**Sources:** design `21.04_Subclasses/Resonant/2026-10-11-resonant-design.md`; decisions R1–R45
(`55_Implementation_Specs/_wip/Resonant/decisions.md`); probes P0–P33 and their results in `SPEC_ARC-0002.md`.
**Scenario:** console edition, a Resonant built through the real progression (no DEBUG — retired at stage 7); levels
1, 3, 5, 7, 9, 11, 12; the PC (SE) edition for P33 only. Compile the Story after any apply.

## Static checks (no game session)

| # | Step | Expected |
|---|---|---|
| S1 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/t/gen_emotion_alchemy.t` | all pass (244 at stage 7) |
| S2 | `lua 50_ENGINEERING/53_Build_and_Versioning/53.03_Validators/run_tests.lua "<Data>/Mods/<mod>/ScriptExtender/Lua"` | 0 failed (134 at stage 7) |
| S3 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/check_cards.pl` | `OK -- nenhum problema` |
| S4 | `perl .../stats_add.pl --selftest` | 0 different |
| S5 | no line over 4000 characters in the mod's `.txt` / `.stats` (Toolkit reads 4096) | none |
| S6 | `perl 80_TOOLS_AND_PIPELINE/82_Automation/dump_progression.pl`, the Resonant rows | L1 Joy, Trust, Fear, Heartstring + Emotional Alchemy, Empathic Sight, Overload · L3 Anticipation, Surprise, Sadness, Temper + Resonance, Awakening · L5 Disgust, Anger, Emotional Overload + Complex Feelings · L7 Overwhelm, Harmony · L9 Emotional Contagion + Mixed Feelings · L11 Ready: Compassion, Shared Heart · L12 Aspect of Empathy |
| S7 | Story `log.txt` after compiling | `0 error(s), 0 warning(s)` |

## In game — one assertion per rule

Already passed by the Owner (2026-10-11/12) — re-run as regression after any change to the engine:

| Rule | Probe | Expected |
|---|---|---|
| Peaks change behaviour | P1–P5, P24 | Joy contagious; Trust shares a blow; Anticipation guards until your turn; Fear freezes; Surprise off guard; Sadness lets go; Anger grudge or nearest; any Surge on any creature; allies never roll (AutoResolve) |
| A reaction refunds the slot once per turn | refund | a feeling gives the slot back; a failed save gives nothing; a second reaction that turn gives nothing |
| Overload | P6–P9 | +1 peak, +2 reaction; full → Overloaded (silenced, Psychic weapon hits, Psychic each turn, level-long); Emotional Overload greyed until then; it paralyses 2 turns with no save and empties the meter |
| Overload persists | P10 | carries over between combats (the 0% display does not show — accepted) |
| Signature spells | P11b, P12, P13b, P15 | Contagion copies the target's mood to its allies; Heartstring +2 turns on a mood; Temper replays the root emotion 1 turn then the mood 5; Compassion casts Trust on a hit ally once a round |
| Awakening | P16–P19, P21 | count 3 / 6 / 15; Tier I: Catharsis +1d8, moods 7 turns, The Two Cups (no Overload); Tier III: Emotional Overload paralyses enemies with feelings within 6 m for 1 turn |
| Tier II | P20b, P22, P23 | feelings 4 turns; first Surge each turn costs no action |

Still open:

| Rule | Probe | Expected |
|---|---|---|
| The free Surge leaves its mood at once (R42) | P25 | an upcast free Surge on 2–3 creatures: each has the Emotion and its mood (7 turns); a second Surge braids a feeling the same turn; the second Surge gives no echo |
| Shared Heart | P27–P31 | link in 18 m until the combat ends; a Surge's result reaches every linked creature, counted once; a Catharsis heals them all; a Surge on a linked ally is refunded once per cast; a Surge on an enemy is normal |
| Progression | P32 | a new Resonant 1 → 12 gets everything at S6's levels and nothing extra at 5 |
| PC edition | P33 | the deck: Surges, Heartstring, Temper (1 Thread), Contagion (3), Shared Heart (Unique); The Two Cups conjured at Awakened I; Compassion arms its reaction while in hand; Emotional Overload in hand while Overloaded |
| Toolkit (ARC-0005) | open / close / open ×3, one Story compile | which launches crash (helpers merged into one `.khn`) |

## Known, accepted
- The meter does not show at 0% (P10, Owner).
- Shared Heart copies have the linked target as their source: Love on a copy redirects to that ally; copied peaks fade into a 5-turn mood; two Resonants in a party are not handled.
- Toolkit first-launch crash is a Toolkit bug (ARC-0005) — reopen.

**Closed (2026-10-12):** the Owner reports every probe passes; ARC-0002 is done. `TC_ARC-0002` can record them all as PASS.
