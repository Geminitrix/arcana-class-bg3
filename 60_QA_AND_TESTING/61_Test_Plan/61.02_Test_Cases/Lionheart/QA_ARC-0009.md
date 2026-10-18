---
id: QA_ARC-0009
title: Playtest — The Lionheart — new subclass (levels 1–12)
type: playtest
subclass: lionheart
build: ARC-0009
status: draft
owner: QA Lead
sources: [TC_ARC-0009]
created: 2026-10-17
---

# QA_ARC-0009 · The Lionheart — new subclass (levels 1–12)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0009 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from TC_ARC-0009.

> The level-by-level tests are written at the build kit (stage 4), from the draft in the appendix.

## Appendix — TC_ARC-0009 (design-stage draft, verbatim)

Header of the original file:

```
id: 61.02/Lionheart/TC_ARC-0009
owner: QA Lead
source: 21.04/Lionheart/DESIGN.md §14 (To test in game), §4.5 (edge cases)
reviewed: 2026-10-17 ARC-0027 — created (propagation, 00.08)
```

### TC_ARC-0009 · The Lionheart — acceptance suite (draft, before the build)

- **Decision it informs:** keep each rule as designed, or send it back to the Lead Class Designer.
- **State:** not built. At the build kit (work flow stage 4) this suite becomes `GUIDE_ARC-####.json`, level by level,
  with the steps and the numbers of the balance pass.
- **Scenario:** console edition, a Lionheart built through the real progression at 1, 3, 5, 7, 9, 11, 12; a fight with an
  ogre and goblins (one clear Villain) and one with two brutes (Tier II).

| Rule | Level | Expected | Result |
|---|---|---|---|
| Villain choice | 1 | The highest max HP gets *Villain* on the first turn; a summon never does | pending |
| Villain lifecycle | 1 | Death → next Villain, Courage halved (rounded down); a reinforcement never takes the title from a living Villain | pending |
| Approach gain | 1 | Ending the turn in reach gives 1 (a Glaive's reach too); one step beyond gives 0 | pending |
| Threat gain | 1 | The Villain misses the Lionheart: +1; a saving-throw area: decide from the result (§4.5) | pending |
| Cap | 1 / 7 / 12 | A gain at the cap is lost; caps 3 / 5 / 7 | pending |
| Drawing Steel | 1 | A basic weapon attack, an opportunity attack and a Lion side enter the Lion; a Maiden side never does; the weapon stays sheathed in the Maiden | pending |
| Maiden penalty and AC | 1 | The Villain attacking an ally rolls the penalty, the Lionheart normally; unarmoured AC = 10 + DEX + STR; light armour: armour + flat bonus | pending |
| Lion reduction | 1 / 7 | Weapon hits reduced; spells only from level 7 | pending |
| Card prices | 1 | Rend with 1 Courage: no Bleeding, nothing spent; with 2: Bleeding, 0 left | pending |
| The Garland I | 3 | The Lion can't be shoved or knocked Prone; Turn the Blow shoves an enemy that attacks an ally | pending |
| Second Edge | 5 | 0 Courage: no extra attack; 1: offered, spends 1 when used | pending |
| Strangle the Lion | 5 | Not castable with 1 Courage; with 3 spends 3; extra attack free that turn; once per combat | pending |
| Wear the Hide | 3 | A dead Villain at Tier I: Courage whole, resistance 1 turn; a fleeing Villain still halves | pending |
| Many Heads | 7 | Two Villains; each gives one gain per trigger per turn | pending |
| The Ordeal | 9 | An ally downed within 9 m: the killer becomes the Villain, Courage fills | pending |
| Lion's Judgement | 11 | A weak enemy under 25% dies; a boss under 25% above the cap takes heavy damage; then the Maiden and +12 m | pending |
| The Twelfth Labour | 12 | Lethal damage with a Villain standing: rise at full HP and Courage, once per combat; no Villain: down | pending |
| Infinity | 3 | 2 turns of both forms; a weapon attack doesn't end the Maiden | pending |
| Console edition | all | Every rule above without Script Extender | pending |

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources TC_ARC-0009 merged; nothing removed.
