---
id: QA_ARC-0030
title: Playtest — The Arcana — Osiris goals: standard and preventive fixes (any level)
type: playtest
subclass: class
build: ARC-0030
status: draft
owner: QA Lead
created: 2026-10-20
---

# QA_ARC-0030 · The Arcana — Osiris goals: standard and preventive fixes (any level)

**Goal:** play every test and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E); results
come back here at `/sync-test-guides`. **Intent:** the tidied goals play exactly as before, and the fixes of
`55/_wip/Osiris/ARC-0030/RISKS.md` (A and B) hold in the game, or each failure becomes a fix (bug) or a decision (OR-1).

## Before you start

- The 20 goals of `55/_wip/Osiris/ARC-0030/goals/` are in the game, `ARCANA_Spell_MirrorWithdraw` is out, and the
  Story compiled with `0 error(s), 0 warning(s)` (Claude reads `Story/log.txt`).
- Play A.1–A.6 on a save made BEFORE the update (the tables must rebuild on load), the rest on any save.

## Any level — full run

**Setup:** a party with the subclass each test names, at the level it names; a fight you can start and finish.

### A.1 · A save made before the update loads with every Aspect working
- **Rule:** RISKS A4, A5, A7 (tables rebuilt on load, type pins)
- **Steps:** Load a save made before the update; start a fight; reach Tier I with any Arcana.
- **Expected:** Tier I awakens and its countdown shows, as before.
- **Fails if:** the Aspect never awakens or the countdown never shows.
- **Result:** —

### A.2 · An upcast Distortion still offers Withdraw
- **Rule:** RISKS A4 (the card table is cleared and refilled)
- **Steps:** Deceiver; cast Distortion with a higher slot than its own level.
- **Expected:** a Double appears where she stood and Withdraw is offered.
- **Fails if:** Withdraw is not offered.
- **Result:** —

### A.3 · A Double at level 5 or more keeps the Mirror spells of its tier
- **Rule:** RISKS A5 (the shapeshift rule table moved to an Init)
- **Steps:** Deceiver level 5+ with Two Truths, on the old save; summon a Double with Mirror Image.
- **Expected:** the Double has the Mirror spells of her level's slot tier.
- **Fails if:** the Double only has Shatter, Dismiss, Dash and Disengage.
- **Result:** —

### A.4 · Shatter still removes its Double
- **Rule:** RISKS A3 (the Shatter timer is cancelled before its launch)
- **Steps:** Order a Double to cast Shatter.
- **Expected:** the burst lands and the Double is gone a moment later; nobody gains Doubt for its death.
- **Fails if:** the Double stays after its burst.
- **Result:** —

### A.5 · The Veil Lifts still deludes the survivors with Doubt
- **Rule:** RISKS A3 (the 900 ms timer is cancelled before its launch)
- **Steps:** Deceiver at Tier III with an enemy at 1 Doubt near a Double; cast The Veil Lifts.
- **Expected:** that enemy becomes Deluded.
- **Fails if:** the enemy keeps its Doubt and is not Deluded.
- **Result:** —

### A.6 · Faceless: Copy cast twice ends in the second look
- **Rule:** RISKS A2 (the real-time timer's own cancel)
- **Steps:** Out of combat, cast Faceless: Copy on character A, then at once on character B.
- **Expected:** she ends with B's look.
- **Fails if:** she ends with A's look, or flickers between them.
- **Result:** —

### A.7 · The Kingmaker's Wheel clears when its fight ends
- **Rule:** RISKS B1
- **Steps:** Kingmaker; bind an ally and an enemy; finish the fight.
- **Expected:** after the fight no creature keeps a Wheel position status, the crown or the Hand's crown.
- **Fails if:** a Rising / Reigning / Falling / Fallen status or the crown stays after the fight.
- **Result:** —

### A.8 · Another fight ending does not wipe the Wheel
- **Rule:** RISKS B1
- **Steps:** Start a fight with the Kingmaker and bind two creatures; make a second, separate fight end elsewhere (a
  companion left far away in a fight of its own, or NPCs fighting each other) while the first goes on.
- **Expected:** the Wheel keeps its creatures and turns at her next turn start.
- **Fails if:** the positions vanish when the other fight ends.
- **Plan B:** if no second fight can be arranged, skip it; the osirislog of a normal fight end must show the clearing
  rules firing once.
- **Kind:** observe
- **Result:** —

### A.9 · An angered enemy holds its grudge only for the fight it is in
- **Rule:** RISKS B2, A6
- **Steps:** Resonant; let an enemy hit an ally, then give that enemy Anger; finish the fight; in a new fight, give Anger
  to an enemy nobody has hit yet.
- **Expected:** in the first fight the grudge points at the ally it hit; in the second, the enemy takes the fallback
  (the Resonant), not a grudge from the old fight.
- **Fails if:** the second enemy holds a grudge on someone from the first fight.
- **Result:** —

### A.10 · A character who dies with the Aspect awakened is clean after the fight
- **Rule:** RISKS B3
- **Steps:** Awaken Tier I with any Arcana; let her die in the fight; win the fight; revive her.
- **Expected:** she has no ASPECT_AWAKENED status, no tier status and no countdown.
- **Fails if:** any Aspect status is still on her.
- **Result:** —

### A.11 · Hemorrhage still bursts
- **Rule:** RISKS B4 (renamed DB and PROCs)
- **Steps:** Eternal; apply Hemorrhage to an enemy, hit it twice, let the status end.
- **Expected:** the enemy takes necrotic damage equal to the hit points it lost while it had the status.
- **Fails if:** no burst, or a burst of another amount.
- **Result:** —

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-20 — created with the audit (`55/_wip/Osiris/ARC-0030/RISKS.md`); `draft` until the goals are in the game.
