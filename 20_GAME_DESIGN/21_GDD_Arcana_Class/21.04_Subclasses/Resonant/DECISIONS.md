---
id: 21.04/Resonant/DECISIONS
owner: Lead Class Designer
role: source of the Resonant dossier (00.08) — every decision is logged here the moment it is taken
---

# The Resonant — decision log

Decisions R1–R48 (2026-10-08 → 2026-10-12, ticket ARC-0002); R49+ from the refining review `REFINE_Resonant_2026-10-15.md` (ARC-0014). Moved here on 2026-10-15 from
`55_Implementation_Specs/_wip/Resonant/decisions.md` (ADR-0009: decisions live in the dossier). The current
design that results from them is `DESIGN.md`; when a decision replaces an earlier one, both stay here and
`DESIGN.md` shows only the result.

Sources read: `93_Old_Versions/2026-10-15_Resonant_first_design/2026-10-06-heartweaver-design.md`, the wiki (`Codex/src/data/resonant.json`,
`Wiki/resonant.html`), the game files (progression dump), and the original design conversation.

## Decision log

| # | Decision | Source |
|---|---|---|
| R1 | The name **Resonant** comes from **Temperance**: tuning in to what another creature feels, so closely that the Resonant can change it. That tuning is the Aspect, **Empathy** | author |
| R2 | **Myth: Iris and Harmonia.** Iris: the irises on the card, the rainbow (the wheel of emotions), the golden ewer she pours from. Harmonia, daughter of Ares and Aphrodite: concord born of opposites | author (proposal accepted) |
| R3 | **Fiction and what each lends:** *Inside Out* (two emotions mixing into one memory → braiding a feeling) · **Mantis** (the empath who touches and says "Sleep!" → Awe) · **Seraphine** (hears others' souls; *Encore* spreads through every champion → Emotional Contagion; it also roots the charmed → Overflow) · **Jean Grey** (the telepath who holds every mind at once; the author's reference scene of her freezing everyone for kilometres → Tier III Overflow in an area) · **Deanna Troi** (*Star Trek: TNG*, the counsellor who feels the room → Empathic Sight, Read the Room) · **the Emotional Spectrum** (DC Lanterns, a colour per emotion; the Indigo Tribe of Compassion → Surge VFX colours, Ready: Compassion). Science: Plutchik, and **emotional contagion** (Hatfield, Cacioppo and Rapson, 1994) | author (Troi and the Spectrum proposed, open to removal) |
| R4 | **Turn the Wheel is renamed Temper**: the card's verb, and *temper* also means mood. The Spinner spec §13 must drop the line reserving "Turn the Wheel" for the Resonant | author |
| R5 | **Overflow** — a card that spends every feeling on a creature (later merged into R10) | author |
| R6 | **Temper moves to level 3** as a Bonus Action: the early bonus-action option, and level 3's new verb (Surge + Temper in one turn) | author |
| R7 | **Only Weave Surges cause reactions.** A mood applied by Temper, Emotional Contagion or Harmony **replaces** the current mood; no chains | author |
| R8 | **Tier names stay Attunement and Harmony**, now sourced: the card's reading (R1) and Harmonia (R2) | author |
| R9 | **Overload meter and ultimate.** The Resonant feels what she makes others feel. A meter fills; when full it unlocks the ultimate on one enemy: **Paralysed for 2 turns, no saving throw** (final number in the balance pass) | author |
| R10 | **Overflow is the ultimate.** Castable only with the meter full: spends the enemy's feelings (Psychic damage per feeling), Paralysed 2 turns with no save, empties the meter. Replaces R5's separate card | author |
| R11 | **While the meter is full** she takes Psychic damage at the start of each of her turns until she releases Overflow (value in the balance pass). The decision: release now, or hold for the right target | author |
| R12 | **The meter fills** +1 for each peak that lands and +2 for each reaction (feeling, Intensify, Catharsis). A failed save adds nothing. Resets when combat ends | author |
| R13 | **Meter and Overflow arrive at level 5**, with Complex Feelings | author |
| R14 | **Tier III (Aspect of Empathy): Overflow in an area.** The target and every enemy within 6 m carrying one of her feelings lose their feelings and are Paralysed (target 2 turns, others 1). No ability bonus; the +1 Surge target and temporary hit points leave | author |
| R15 | **A peak changes what the creature *does*; a mood changes a *number*; a feeling mixes both.** The 8 peaks are rewritten as behaviour; the mechanic and the reaction matrix stay the same (fixes K2) | author, 2026-10-11 |
| R16 | **A reaction refunds its cost:** when a Weave Surge causes a reaction, the Resonant regains the Woven Spell Slot (PC: the Thread) it spent. Once per turn, from level 1. Pattern: `Arcana_Passive_ArcaneOverflow` (`RestoreResource(SELF,ArcanaSpellSlot,1,<level>)` + a used-this-turn status) (fixes P5) | author, 2026-10-11 |
| R17 | **The 8 peaks as behaviour** — Joy (ally): contagious, allies near it gain Advantage on their next attack · Trust (ally): follows your lead, can use its reaction to attack the target you or an ally attacked · Anticipation (ally): on guard, attacks first when an enemy enters its reach · Fear (enemy): frozen with fear (vanilla Frightened); fleeing belongs to Terror · Surprise (enemy): caught off guard, loses its reaction and the first attack against it has Advantage · Sadness (enemy): lets go, loses Concentration and its Bonus Action · Disgust (enemy): recoils, moves away from the nearest creature and makes no melee attacks · Anger (enemy): grudge, attacks the last creature that hurt it. To test (T2): Trust, Anticipation and Anger (interrupts, last-attacker tracking in Osiris), Disgust's melee block; each gets a plan B if the test fails | author, 2026-10-11 |
| R18 | **Shared Heart replaces Equanimity** as the capstone (level 11, Long Rest, Unique): you and every ally within 18 m are linked for a few turns; a Weave Surge on one linked ally lands on all of them, and they share the same mood (duration in the balance pass) (fixes K2 for the capstone) | author, 2026-10-11 |
| R19 | **Shared Heart counts once per Surge:** however many linked allies react, the Surge counts one reaction (+2 overload, +1 Awakening, one refund) | author, 2026-10-11 |
| R20 | **The ultimate is named Emotional Overload; the meter is named Overload.** "Overflow" leaves the Resonant's vocabulary; the base class's Arcane Overflow keeps its name (I6) | author, 2026-10-11 |
| R21 | **Tier I is renamed Resonance** (replaces Attunement from R8): the same tuning idea (R1), named after the subclass, and no clash with the deck keyword Attuned. Tier II stays Harmony | author, 2026-10-11 |
| R22 | **Emotional Overload costs an Action and no slot or Thread:** the full meter is its cost | author, 2026-10-11 |
| R23 | **Rage follows Anger's grudge:** the intense ring attacks the last creature that hurt it, with Advantage | author, 2026-10-11 |
| R24 | **Shared Heart lasts until combat ends, and a Surge whose main target is a linked ally spends no slot and no Thread** (balance pass: the first version only saved targets the level-11 upcast already gives) | author, 2026-10-11 |
| R25 | **Surges reach every creature that is not a construct** (`not Tagged('CONSTRUCT')`, vanilla pattern, 40 uses) instead of `IntelligenceGreaterThan(4)`; the weakness becomes "constructs feel nothing". Found in probe P4 (the Owner had already removed the INT gate from Anger in the game as a stop-gap) | author, 2026-10-11 |
| R26 | **Anger and Rage: grudge with a fallback.** Osiris remembers, through the fight, who last hurt each creature; while angry it attacks that one (`RESONANT_GRUDGE`, TAUNTED-like, source = last attacker); if nobody has, a fallback status makes it attack the nearest. Never both — the "attack the nearest" boosts leave the peak. Reference: the Adamantine Forge golem (`UND_AdamantineGolem_Aggro`), whose AI-preferred-target tag was rejected because it would steer every enemy | author, 2026-10-11 |
| R27 | **Trust: shoulder to shoulder** (replaces "follows your lead", which failed P2): when an ally within 3 m would be hit by an attack, it can use its reaction to take the hit instead. Anchors to probe: `Interrupt_ProjectedWard` (OnPreDamage, Nearby, Ally(context.Target,context.Observer)), `Interrupt_DampenElements` | author, 2026-10-11 |
| R28 | **Fixes from the probes:** Joy's contagion also reaches the Joyful creature (P1); Anticipation's peak lasts until the Resonant's next turn (`TickingWithSource` + `StartTurn`) so the guard covers the round (P3) | author request / bug fix, 2026-10-11 |
| R29 | **Overload from level 1** (replaces R13 for the meter and R11's hold-or-release): a full meter makes the Resonant ***Overloaded*** for turns equal to the **character level** — silenced (no spells), Psychic damage at the start of each turn, and **weapon attacks deal extra Psychic**. At level 5 **Emotional Overload** arrives and is **not a spell** (usable while silenced): it ends *Overloaded*, empties the meter and does its effect on the enemy. The long duration is the pressure to release it | author, 2026-10-12 |
| R30 | **Overloaded weapon rider:** +1d6 Psychic (levels 1–4), 2d6 (5–9), 3d6 (10+) | author, 2026-10-12 |
| R31 | **The meter belongs to the character:** it counts in and out of combat and **carries over between combats**, emptying only when *Overloaded* ends or Emotional Overload is used; it shows as a **percentage (1–99%)** of its maximum. Texts name *Overloaded*, its damage (spell slot level) and that Emotional Overload needs level 5. Visible passives are `Highlighted`, visible statuses `ForceOverhead` (Owner rules) | author, 2026-10-12 |
| R32 | **The meter is always shown**, at 0% too, in and out of combat; *Overloaded* never ends with the combat (P10) | author, 2026-10-12 |
| R33 | **Emotional Contagion is a mood aura:** while the Resonant concentrates, every creature within 6 m of the target catches the **mood** it carries, renewed each turn; no saving throw. Stats only (an aura that reads the bearer's mood, like Joy's contagion). Mass setup for reactions, weak on its own | author, 2026-10-12 |
| R34 | **Costs of the spells outside the Surges:** Temper costs **only the Bonus Action** (no slot, no Thread: it never creates a mood, so it can't loop the refund); Emotional Contagion and Ready: Compassion are **level 3 cards** (3 Threads) | author, 2026-10-12 |
| R35 | **Emotional Contagion spreads only to the target's allies** (P11: it reached both sides, so an ally's bright mood landed on enemies and the reverse) | author, 2026-10-12 |
| R36 | **Temper pulls the mood back to its root emotion for 1 turn** (replaces the one-step turn, which failed P13 and was often a bad option): the creature replays the peak's behaviour, and when it fades the mood returns at full length. Still a Bonus Action with no slot (R34); still never a reaction (R7) | author, 2026-10-12 |
| R37 | **Read the Room is removed:** Empathic Sight already gives Advantage on Insight | author, 2026-10-12 |
| R38 | **The Two Cups does not fill the Overload** (each of its Catharses still counts for the Awakening): one card on 5–6 creatures would fill the meter at once | author, 2026-10-12 |
| R39 | **Harmony's mood follows the side:** the nearest creature gets the mood of the feeling's emotion that suits it — the bright one (Joy, Trust, Anticipation) if it is your ally, the dark one if not; when both emotions are on the same side, the emotion of the Surge you cast | author, 2026-10-12 |
| R40 | **Tier II Harmony redesigned** (replaces R8/R39 — the nearest creature gaining a mood failed P20 and read as complex): feelings you braid **last 2 turns longer**, and **once per turn a Weave Surge costs no action** (two Surges a turn, more feelings on the field). Surges are recognised by a Khonsu helper (`IsWeaveSurge()`) | author, 2026-10-12 |
| R41 | **Weave Surges target any creature** (replaces the bright arc on allies / dark arc on non-allies when there is no mood): a dark peak on an ally can set up a bright feeling; the player decides | author, 2026-10-12 |
| R42 | **The free Surge leaves its mood at once** (Tier II): the first Weave Surge of the turn applies its emotion and, at the same time, that emotion's mood (7 turns), so the second Surge of the turn can react with it. Fixes the gap the Owner found: two Surges in a turn could never react, since a peak becomes a mood only when it fades | author, 2026-10-12 |
| R43 | **Shared Heart is a level 5 card** (Unique, once per long rest), as the Deceiver's capstone Grand Deception | author, 2026-10-12 |
| R44 | **A Catharsis on a linked ally heals every linked ally** (same healing, their moods spent); peaks, intense emotions and feelings are copied as they are | author, 2026-10-12 |
| R45 | **In the PC (SE) edition Temper costs 1 Thread**, as every level-0 card does (Heartstring, Malicious Whispers); the console edition keeps it at the Bonus Action only (R34) | author, 2026-10-12 |
| R46 | **Shared Heart shares feelings** (replaces R18's "a Surge lands on all" and R24's free Surges): a feeling braided in one linked creature is braided in every linked creature (counted once); a Catharsis on one still heals them all (R44). Peaks and intense emotions are not copied; Surges on linked allies cost as usual | author, 2026-10-12 |
| R47 | **Feelings stack additively** (`StackType Additive`): a feeling braided again in the same fight adds its turns | author, 2026-10-12 |
| R48 | **Emotional Overload is a Bonus Action** | author, 2026-10-12 |
| R49 | **A used mood is spent; only an emotion that fades on its own leaves a mood** (written once in Emotional Alchemy). Intensify: the intense emotion leaves nothing when it ends (was: the mood returns). **Temper** (replaces R36): spend a creature's mood to make it relive the emotion it came from for 1 turn; the replayed emotion leaves nothing when it fades. Closes the Intensify and Temper loops (`REFINE_Resonant_2026-10-15.md` §6.1 L1, L4, L5) | Owner, from SG1 (ARC-0014), 2026-10-15 |
| — | Bug: Ready: Compassion triggered on the Resonant's own Surge on an ally (the Surge has a damage functor and "hits"). Now only an enemy source triggers it, as vanilla Hellish Rebuke | 2026-10-12 |
| — | P10: the meter does not show at 0%; the Owner accepts it as is (it persists between combats; across a save still to be seen in game) | author, 2026-10-12 |

## Audit state before the rules rewrite

- Passing: I1, I2, I4, I5, E1, E2, E5, E6 (R7), P1, P3, P4, P5, P6 (strengths and weaknesses are on the
  wiki), P7, T1, T2, T3.
- Fixed by the decisions above: I3 (R2, R3), I6 (R4), E3 and F2 at level 3 (R6), E4 (R10), E7 (R8, R14),
  P2 bonus action (R6).
- Still open: level 12 (the spec planned two passive cards, never designed); T4 (Heartweaver ids left:
  tag `THEHEARTWEAVER`, ClassDescription Name, ProgressionDescription Type/Name, `ARCANA_Aspect_Temperance`);
  F3 (no `05.02_Subclasses/resonant.md`; the spec says the chassis is open and the colour iris violet
  while the game and the wiki have WIS + CHA saves and coral `#bd4f2b` / `#f39a78`); balance B1–B4.

## Diagnosis that led to R9–R14

Against enemies, a reaction needs two saves in a row (≈ 0.6 × 0.6 = 36 % at level 5, DC 15 vs +2 WIS);
every state lasts 1–2 turns; Catharsis (≈ 9 damage for two actions and two slots) loses to Magic Missile
(10.5 for one); and there was no big moment. The ally side (no saves, multi-target upcast) was the
strong part.
