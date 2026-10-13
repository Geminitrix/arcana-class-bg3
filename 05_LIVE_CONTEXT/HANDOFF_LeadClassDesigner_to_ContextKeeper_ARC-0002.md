# HANDOFF · Lead Class Designer → Context Keeper · ARC-0002

**What:** the Resonant was raised to the subclass standard (design only; nothing changed in the game
files). Update `05.02_Subclasses/Resonant.md`.

**Sources:** `21.04_Subclasses/Resonant/2026-10-11-resonant-design.md` (the new design, replaces the
2026-10-06 one as the design pointer) · `55_Implementation_Specs/_wip/Resonant/decisions.md` (R1–R21).

## 1. Change the design pointer

Design: `21.04_Subclasses/Resonant/2026-10-11-resonant-design.md`. The progression table "in the game
today" stays as it is — the game files did not change.

## 2. Add the Depth audit (2026-10-11)

Audit of the state **before** the raise (spec 2026-10-06 + wiki + game), and what resolves each gap.

| Question | Before | Resolved by |
|---|---|---|
| I1 fun | ⚠️ enemy side needs two saves (~36 %), states last 1–2 turns, no big moment | R9–R16; **playtest still due** |
| I3 archetype | ⚠️ not written | Spec §2.7 ("the empath who plays the room") |
| I6 vocabulary | ⚠️ "Turn the Wheel" belongs to a wheel theme | R4 (Temper), R20 (Emotional Overload), R21 (Resonance) |
| S3–S4 characters | ⚠️ / ❌ names only | R3 |
| S6 myth | ❌ none | R2 (Iris, Harmonia) |
| M3 gears | ⚠️ feelings read by nothing, converters late | R6, R10, R12 |
| M4 grows | ⚠️ no new rule at level 3 | R6 |
| M6 bounded | ⚠️ who causes reactions undefined | R7 |
| K2 exclusive | ⚠️ peaks read like vanilla numbers; Equanimity a generic cleanse | R15, R17, R18 |
| K3 ties it together | ❌ none | R10, R20 (Emotional Overload) |
| K6 two plays + fallback | ❌ no Bonus Action before 7; cantrip not built | R6; cantrip still to build |
| P1–P2 style, versatility | ⚠️ not written | Spec §2.7 |
| P5 fight length | ⚠️ slots run out (2 at level 1) | R16 (refund on reaction) |
| A2 tiers | ⚠️ Tier III generic | R14 |
| B1, B2, B4 | ⚠️ / — no numbers | **Balance pass** (`25_Master_Data`) |
| T2 tests | ⚠️ engine test results not recorded; new peaks untested | **Tests** (spec §15) |
| T4 conventions | ⚠️ Heartweaver names left | **Owner, in the Toolkit** |
| D1 Identity Sheet | ❌ | Spec §2–§3 |
| D2 sources agree | ❌ | This handoff; the wiki (`75.02`) still shows the old kit |

Every other question: ✅.

## 3. Open items to list

Tests of §15 (balance pass done: numbers in `25.01`–`25.03`; renames done in ARC-0003) · the player guide (`75.02/src/data/resonant.json`) still
describes Turn the Wheel, Attunement, Equanimity and the old Tier III.

## 4. ARC-0003 (game files changed)

The last "Heartweaver" leftover is gone: the ProgressionDescription row Name is `New_Stat_Resonant`. The
Resonant's tag is `THERESONANT` (`c3a59afe-c03e-4fe0-9c7c-dc45ee46e21e`) — `05.02/Resonant.md` still says
"internal tag `THEHEARTWEAVER`"; replace it.

## 5. ARC-0002 stage 1 (game files changed, 2026-10-11)

In the game now: Surges with behaviour peaks (Joy contagious aura, Trust follow-up interrupt, Anticipation
guard interrupt, Fear in SG_Frightened, Surprise off guard, Sadness lets go); a reaction refunds the slot
once per turn (`RESONANT_REFUND_TECH` / `_USED`); Catharsis reads the level map `Catharsis_Damage`;
new statuses `RESONANT_JOY_CONTAGION`, `RESONANT_SURPRISE_OPENING`, `RESONANT_GRUDGE`; interrupts
`Interrupt_Arcana_TrustFollowUp`, `Interrupt_Arcana_AnticipationGuard`; Osiris goal `ARCANA_Resonant_Grudge`
(not compiled yet). Untested in game — probes P0–P5 pending.

## 6. ARC-0002 stage 1b (game files changed, 2026-10-12)

Weave Surges now skip constructs instead of creatures with Intelligence 4 or lower (R25) — the weakness
in `05.02` changes to "constructs feel nothing". Trust: shoulder to shoulder (`Interrupt_Arcana_TrustShoulder`,
`RESONANT_TRUST_SHOULDERED`); `Interrupt_Arcana_TrustFollowUp` removed. Anger/Rage: grudge or
`RESONANT_ANGER_FALLBACK` via the rewritten `ARCANA_Resonant_Grudge` goal. Joy's contagion includes the
Joyful creature; Anticipation lasts until the Resonant's next turn. Re-tests pending.

## 7. ARC-0002 stage 2 (game files changed, 2026-10-12)

New: passive `Arcana_Passive_Overload`, statuses `RESONANT_OVERLOAD` (count), `RESONANT_OVERLOAD_FULL`,
`RESONANT_OVERLOAD_SPENT_TECH`; spell `Target_Arcana_Created_EmotionalOverload`; Osiris goal
`ARCANA_Resonant_Overload` (generated). Not in the progression yet — only on the `[DEBUG] Resonant Passives` list.
Probes P6–P10 pending.

## 8. Stale fact found (2026-10-12)

`05.01/Arcana_Base_Class.md` says the list **"Arcana Deck DEBUG"** (`f2e5e2e9-42c8-4f0e-88de-830ef0224290`) is granted
at level 1. No progression grants it (it was in the Arcana level-1 row in the 2026-09-17 backup; gone before the
migration). The list still exists in `SpellLists.lsx`. Fix the line in `05.01`.

## 9. ARC-0002 — final state after stages 2b–7 (2026-10-12) — supersedes the game notes of §5 and §7

Update `05.02_Subclasses/Resonant.md` (and `05.03` / `05.04` for the ids) from this section; the design pointer of §1 stays.
Decisions R22–R45 are in `55_Implementation_Specs/_wip/Resonant/decisions.md`.

**Progression (in the game):** L1 Weave Surge Joy / Trust / Fear, Heartstring; passives Emotional Alchemy, Empathic
Sight, Overload · L3 Surge Anticipation / Surprise / Sadness, Temper; Resonance (Tier I), 14 - Temperance: Awakening ·
L5 Surge Disgust / Anger, Emotional Overload; Complex Feelings · L7 Overwhelm, Harmony (Tier II) · L9 Emotional
Contagion; Mixed Feelings · L11 Ready: Compassion, Shared Heart · L12 Aspect of Empathy (Tier III). Read the Room was
removed (R37). The DEBUG shout/status is retired (applied 2026-10-12; archived in `90_ARCHIVE/93_Old_Versions/2026-10-12_ARC-0002_resonant_debug`).

**Mechanics now:**
- Weave Surges target any creature (R41); allies never roll (`SpellAutoResolveOnAlly`); not constructs (R25).
- A reaction refunds the slot once per turn — applied by Osiris (`ARCANA_Resonant_Overload`), not the Surge.
- Overload from level 1, carries over between combats, shows a percentage; full = *Overloaded* (silenced, Psychic on
  weapon hits and each turn, level-long) (R29–R32). Emotional Overload (L5) is not a spell, greyed until Overloaded.
- Heartstring (cantrip, mood +2 turns); Temper (Bonus Action: the mood replays its root emotion for 1 turn, R36);
  Emotional Contagion (level 3 card, the target's mood to its allies within 6 m, R33/R35); Ready: Compassion (level 3
  reaction card, Trust on a hit ally, resource `ArcanaReactCompassion`).
- Aspect Awakening 14 - Temperance (goals 3 / 6 / 15 reactions): I Resonance — Catharsis +1d8, moods 7 turns, The Two
  Cups (no Overload, R38); II Harmony — feelings 4 turns, first Surge each turn costs no action and leaves its mood at
  once (R40, R42; Khonsu `IsWeaveSurge()`); III Aspect of Empathy — Emotional Overload also paralyses enemies with
  feelings within 6 m.
- Shared Heart (level 5 card, Unique, once per long rest, R43): links you and allies within 18 m; a Surge's result
  reaches every linked creature (counted once), a Catharsis heals them all (R44), Surges on linked allies are free (R24).

**Technical:** generator `80_TOOLS_AND_PIPELINE/82_Automation/stats/gen_emotion_alchemy.pl` (tests 244); Osiris goals
`ARCANA_Resonant_Overload`, `ARCANA_Resonant_Grudge`, `ARCANA_Aspect_Temperance`, `ARCANA_Resonant_SharedHeart`
(the first three and the last generated), Temperance rows in `ARCANA_Aspect_Common`; all Khonsu helpers in one file
`Scripts/thoth/helpers/ArcanaHelpers.khn` (ARC-0005); PC deck entries in `CardDB.lua` (Lua tests 134). Generated
lines stay under the Toolkit's 4096-character read limit (tested).

**Open:** probes P25, P27–P33 (`60_QA_AND_TESTING/61_Test_Plan/HANDOFF_LeadClassDesigner_to_QALead_ARC-0002.md`);
the player guide (ticket ARC-0006); ARC-0005 (Toolkit first-launch crash).

## 10. ARC-0002 closed (2026-10-12)

Every probe passes (Owner). Also since §9: Shared Heart shares **feelings** only (+ the Catharsis heal), no free
Surges (R46); feelings stack additively (R47); Emotional Overload is a bonus action (R48); Compassion triggers only on an
enemy's hit; the DEBUG scaffold is retired. And ARC-0007: every Aspect's *Awakening* counts down (what is left, in the
goal's unit — hit points for Star and Death), one status per tier; the five Awakening passives share one shape. Update
`05.02` for all five subclasses (Awakening display).

## 11. ARC-0005 closed (2026-10-12)

For `05.06_Technical_State`: all Khonsu helpers live in ONE file, `Mods/<mod>/Scripts/thoth/helpers/ArcanaHelpers.khn`
(one section per function). The nine loose one-function files made the Toolkit crash on most launches (a double free
while Khonsu opened them during the AI load); merged, 4 clean launches. New helpers go in as sections, never as new files.
