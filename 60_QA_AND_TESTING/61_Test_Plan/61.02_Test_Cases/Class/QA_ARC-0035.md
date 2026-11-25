---
id: QA_ARC-0035
title: Playtest — The Arcana — Osiris standard: Kingmaker casts and pins (any level)
type: playtest
subclass: class
build: ARC-0035
status: ready
owner: QA Lead
created: 2026-11-25
---

# QA_ARC-0035 · The Arcana — Osiris standard: Kingmaker casts and pins (any level)

**Goal:** play every test and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E); results come
back here at `/sync-test-guides`. **Intent:** ARC-0035 changed no rule — only fixed line endings, restored a header, pinned
the Kingmaker's shared DBs and cast `_Owner` to CHARACTER in 27 event patterns. These tests prove each changed event still
fires, or each failure becomes a fix (OR-1).

## Before you start

- ARC-0035 is applied (a `[fechado] ARC-0035` message) and the Story is compiled: `log.txt` ends with `0 error(s)`.
- A Kingmaker at level 12 (every card and Tier III), a party of three, a fight with four or more enemies. Values and
  expected results are those of QA_ARC-0008, which passed on 2026-11-25: the same result means the cast changed nothing.
- Console edition.

## Any level — full run

**Setup:** The Kingmaker at level 12 with allies and enemies bound to the Wheel.

### A.1 · The Story compiles clean

- **Rule:** ARC-0035 (pins and casts)
- **Steps:** Compile in the Story Editor; open `Mods/AspectClass_…/Story/log.txt`
- **Expected:** It ends with `0 error(s), 0 warning(s)` and has no "type mismatch" line
- **Fails if:** Any error, warning or type mismatch
- **Result:** —

### A.2 · The Wheel turns at her turn start

- **Rule:** `TurnStarted((CHARACTER)_Owner)` in ARCANA_Kingmaker_Wheel
- **Steps:** End her turn with an ally Rising and an enemy Falling on the Wheel; watch her next turn start
- **Expected:** The ally steps to Reigning, the enemy to Fallen, before she acts (as QA_ARC-0008 L1.4)
- **Fails if:** Nothing moves at her turn start
- **Result:** —

### A.3 · A Crossing at her turn start

- **Rule:** `TurnStarted((CHARACTER)_Owner)` in ARCANA_Kingmaker_Crossing
- **Steps:** Arrange a Fallen enemy within reach of a Reigning ally at her turn start
- **Expected:** The enemy crosses (the Crossing statuses show) as before
- **Fails if:** No Crossing where QA_ARC-0008 had one
- **Result:** —

### A.4 · Rota Fortunae moves every creature one step

- **Rule:** `StatusApplied((CHARACTER)_Owner, "KINGMAKER_TURN_TECH", _, _)` in ARCANA_Aspect_WheelOfFortune
- **Steps:** At Tier I, cast Rota Fortunae
- **Expected:** Every creature on the Wheel moves one step (as QA_ARC-0008 L3.6)
- **Fails if:** Nothing moves
- **Result:** —

### A.5 · Turn the Spoke drops the Falling enemy

- **Rule:** the causee cast in ARCANA_Kingmaker_TurnTheSpoke
- **Steps:** Cast Turn the Spoke on a Falling enemy
- **Expected:** It drops to Fallen at once (as QA_ARC-0008 L1.5)
- **Fails if:** It doesn't move
- **Result:** —

### A.6 · Atropos' Cut takes an enemy off the Wheel

- **Rule:** the causee cast in ARCANA_Kingmaker_AtroposCut
- **Steps:** Cast Atropos' Cut on a Falling enemy
- **Expected:** The damage lands, the enemy loses its position status and the Wheel ignores it (as QA_ARC-0008 L3.7)
- **Fails if:** It keeps its position
- **Result:** —

### A.7 · Peripeteia inverts the Wheel

- **Rule:** `StatusApplied((CHARACTER)_Owner, "KINGMAKER_INVERT_TECH", _, _)` in ARCANA_Kingmaker_Peripeteia
- **Steps:** Cast Peripeteia with allies and enemies on the Wheel within 18 m
- **Expected:** Reigning and Fallen swap, Rising and Falling swap (as QA_ARC-0008 L5.8)
- **Fails if:** Nothing inverts
- **Result:** —

### A.8 · Usurp trades two positions

- **Rule:** the causee cast in ARCANA_Kingmaker_Usurp
- **Steps:** Cast Usurp on a Reigning ally, then on a Fallen enemy
- **Expected:** The ally becomes Fallen and the enemy Reigning (as QA_ARC-0008 L7.7)
- **Fails if:** No trade, or the second target is never asked
- **Result:** —

### A.9 · The Court's offices land

- **Rule:** the causee cast in ARCANA_Kingmaker_KingsCourt
- **Steps:** Convene the Court and appoint the King's Hand and the Master of Laws
- **Expected:** Each holder shows its office and its effect works (the Hand's crits, the Master of Laws' sentence, as QA_ARC-0008 L5.1, L7.2)
- **Fails if:** An office is shown but does nothing
- **Result:** —

### A.10 · The Wheel Stops holds the Wheel for two turn starts

- **Rule:** `StatusApplied((CHARACTER)_Owner, "KINGMAKER_STOP_TECH", _, _)` in ARCANA_Kingmaker_Wheel
- **Steps:** Cast The Wheel Stops with an ally Reigning and an enemy Fallen
- **Expected:** For her next two turn starts nothing moves; at the third the Wheel turns again (as QA_ARC-0008 L11.2)
- **Fails if:** The Wheel keeps turning, or never turns again
- **Result:** —

### A.11 · Ready: Foreseen still answers

- **Rule:** the causee cast in ARCANA_Aspect_WheelOfFortune (Foreseen)
- **Steps:** At Tier III, let a Reigning enemy on the Wheel attack an ally; take Foreseen
- **Expected:** The attacker becomes Falling and the roll loses 1d4 (as QA_ARC-0008 L12.4)
- **Fails if:** The reaction does nothing
- **Result:** —

### A.12 · The Windborn's bag and The Calm still work

- **Rule:** ARCANA_Unbound_AeolusBag, ARCANA_Aspect_Fool (line endings and header only)
- **Steps:** With a Windborn, open Aeolus' Bag with two marked enemies; later cast The Calm
- **Expected:** The bag releases the marks and the wind blows; The Calm turns the turns left into gusts and reopens the bag
- **Fails if:** Either does nothing
- **Kind:** observe
- **Result:** —

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-11-25 — created with the fix (55/_wip/Osiris/ARC-0035/): one test per changed event, against QA_ARC-0008's results.
  Draft until the apply.
- 2026-11-25 — ARC-0035 applied (`[fechado] ARC-0035`): ready to play after the Owner's compile.
- 2026-11-25 — Compiled clean (16:58): ready to play.
