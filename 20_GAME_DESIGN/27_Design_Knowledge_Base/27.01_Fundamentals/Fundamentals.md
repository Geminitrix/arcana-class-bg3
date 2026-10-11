# 27.01 · Fundamentals — MDA, pillars, motivation, complexity

*Condenses spec Part II §17. Readers: Lead Class Designer, Spell Designer.*

## MDA — design from the experience backwards
- **Mechanics** are the rules (the YAML in `25`, the spec in `55`). **Dynamics** are what players do because
  of them. **Aesthetics** are what players feel. The designer only touches mechanics; the player meets
  them in reverse — feeling first, rules last.
- Studio rule: **every feature starts with one sentence of target aesthetic** ("it should feel…"); numbers
  come after. Dynamics are only confirmed by playing (`27.06`). Each added rule must pay for the extra
  complexity it brings to the dynamics.

## Pillars
- 3–5 short sentences about the **experience** promised (not features, not plot, not selling points).
  They filter every idea: does it serve a pillar or contradict one? Few, stable, memorable.
- Format: pillar · experience · yes/no filter question · anti-example. Approved pillars live in
  `21.01_Vision_and_Pillars.md` and, condensed, in `CLAUDE.md`. *(Not yet written — proposal pending.)*

## Motivation — autonomy, competence, relatedness (self-determination theory)
| Need | In class design | Check |
|---|---|---|
| Autonomy | Meaningful choices: subclass, spells, when to spend | Does every resource have at least two reasonable uses? Is any option a trap or a no-brainer? |
| Competence | Clear feedback (text, numbers, icon, VFX); easy to use, hard to master | Can a new player read it once and get it? Is each level's power gain noticeable? |
| Relatedness | BG3 is about the party and the story | Does it interact with companions? Does the text acknowledge the choice? |
The PENS questionnaire measures this but needs permission for commercial use — don't adopt it unchecked.

## Complexity budget
Adding is cheap, removing is expensive. Each subclass has one clear **signature**; every feature fits a
short tooltip — a paragraph of exceptions means it is too complex. Limits are asked as questions in
`21.04/_SUBCLASS_STANDARD.md` §15 (fixed numbers only by ADR).

## Iteration loop
Design → sheet prototype (`25` YAML + `22.02` sheet) → playtest → adjust. Go to the game only after the
sheet stops showing problems.
