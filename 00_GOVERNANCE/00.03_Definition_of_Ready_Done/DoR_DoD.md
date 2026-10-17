# 00.03 · Definition of Ready and Definition of Done

*Status: proposed by the migration (2026-10-11) — Owners approve or edit.*

## Definition of Ready (a ticket may enter a sprint)

- [ ] Header complete: `id`, `type`, `status`, `owner`, `implementation`, `inputs`, `outputs`, `blocked_by`
      (template `10.01_Product_Backlog/_TEMPLATE_TICKET.md`).
- [ ] Goal in one sentence and the **intent** in one sentence (what it should change in play).
- [ ] Acceptance criteria that can be checked (in game, by a validator, or by reading a file).
- [ ] Inputs exist and are cited by ID; no input is "to be decided".
- [ ] Owner department named; handoffs it will need are listed.
- [ ] Size fits one sprint (1 week); otherwise split.

## Definition of Done — global

- [ ] Every acceptance criterion met, with evidence (file, validator output, or `65_Evidence`).
- [ ] Outputs written in the owner's folder; ticket header updated (`status`, `outputs`).
- [ ] No number typed outside `25_Master_Data`.
- [ ] `05_LIVE_CONTEXT` updated by the Context Keeper (or a handoff sent to it).
- [ ] README checked when structure, subclass state, version or scope changed.
- [ ] Session logged in `10.02_Active_Sprint/daily_logs/`; board regenerated.
- [ ] Committed and pushed to `main`, ticket id first in the message.
- [ ] `check_propagation.pl` OK (OR-28); for a build, every test of its `GUIDE_ARC-####` passes (work flow stage 5).

## Definition of Done — per department (adds to the global one)

| Department | Also required |
|---|---|
| Game Design (20) | Design gate answered (`21.04/_SUBCLASS_STANDARD.md` §15); YAML validates against `25.00_schemas` |
| Narrative (30) | Narrative gate: approval recorded in `32.04`; terms match `33.03` |
| Art (40) | Asset origin registered in `00.06`; DDS in the four ClassIcons sizes when it is a class/subclass icon |
| Engineering (50) | Spec in `55` follows `_TEMPLATE_SPEC.md`; code gate (`57.06`) passed when code was written; `sync_data` run after any change in Data; a build or rework (subclass or feature) also delivers its test guide (`61.02/<S>/GUIDE_<ARC>.json`, listed in `TEST_GUIDES.json`) and its QA-#### playtest ticket (`playtests.pl new`); the guide is built level by level (`61_Test_Plan/_AGENT.md`) |
| QA (60) | Test case states the decision it informs; result and evidence linked. A QA-#### playtest reaches Done only when every test is pass or skipped on Arcana Test Guides (synced into the ticket); each failed test opens an ARC bug ticket and a QA bug-retest ticket blocked by it |
| Release (70) | `00.06` checklist approved; patch notes come from the version diff |
