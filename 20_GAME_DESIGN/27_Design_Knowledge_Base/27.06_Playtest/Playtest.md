# 27.06 · Playtest and design validation

*Condenses spec Part II §22. Readers: QA Lead, Playtester Agent.*

## Principles
- Playtest is part of design, not final polish. Designers can't test their own game — they are blind to
  what feels obvious.
- **Every test starts with the decision it informs** ("cut the damage or keep it?"), not "is it good?".
- Watch behaviour: behaviour shows the problem, feedback shows the symptom. Don't explain the game first
  or defend decisions during.
- Mix quantitative (damage per turn and combat, resources spent, deaths, time to decide) and qualitative
  (observation, neutral questions). Repeated feedback is a signal; one comment is not.
- Separate **bug** (technical failure → `62`) from **design feedback** (didn't understand, didn't like).

## What agents can and can't do
Can: simulate in sheets, check rule consistency, fill checklists, write protocols, summarise feedback.
**Can't** replace play: how a feature feels is judged by people playing — the Owners, testers, the
community. The Playtester Agent prepares and analyses; it never plays.

## Test protocol (template in `61.02`)
Decision it informs · hypothesis · scenario (save from `83.02`, difficulty, party) · metrics · success
criterion (band from `27.03`) · result and observations (evidence in `65`) · decision (keep, adjust which
value in `25`, discard).

## Standard scenarios
Saves at levels 1, 5, 8, 12 × difficulty (Balanced and Tactician by default; Honour optional) × party
(the class alone, the class with companions).

## Community feedback and retrospective
Collect mod.io comments, sort by feature, split bugs from design feedback, prioritise repeats, turn into
tickets; ask neutral questions. After every release compare what each change's intent promised with what
tests and the community showed.
