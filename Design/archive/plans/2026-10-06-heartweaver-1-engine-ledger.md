# SDD ledger — plan: C:/Projetos/BG3 Modding/Arcana Class/Design/Rework/plans/2026-10-06-heartweaver-1-engine.md

Spec: Design/Rework/specs/2026-10-06-heartweaver-design.md (read).

## Pre-flight scan

| Tasks | Shared file / interface | Finding |
|---|---|---|
| 1 → 3 | `gen_emotion_alchemy.pl`, `heartweaver/10_engine.patch`, `20_upcast_targets.patch` | T1 produces, T3 regenerates and applies. Consistent (T3 Step 3 re-runs the generator before applying). |
| 2 → 3 | `heartweaver_debug_list.pl` | T2 dry-runs, T3 applies. Consistent. |
| 1 → 4 | guide text references the ids T1 generates | Consistent (guide rows checked against the wheel). |
| 3 → 4 | Context update after apply | Consistent. |
| 0 | self | Read-only; its expected counts are a 2026-10-06 snapshot. |
| 1 | self | Tests (1094) and code are the versions verified together in the controller's scratchpad; Step 5 counts (69/37/141) match that run. |
| 2 | self | Code + dry-run expectations match the scratchpad run. |
| 3 | self | Needs `[fechado]`; not executable in this session yet. |
| 4 | self | Depends on 3. |

Ruling: Tasks 0–2 run now; Task 3 waits for a `[fechado]` message and Task 4 follows it — the jt-gate rule (CLAUDE.md §0.1) forbids mod writes otherwise — costs nothing if wrong, only delay.
Ruling: no git diff for Tasks 0–2 (`Design/` is git-ignored and nothing is committed until Task 3), so the review package is the created files themselves plus the report — costs a less precise review surface if wrong.
Ruling: workspace lives in the session scratchpad, not `<repo>/.superpowers/sdd/`, because the plan's working files are outside the repo — costs nothing.

## Progress
Task 0: complete (read only, no artifact; verified by controller: 34 = 29 removed + 5 replaced, matches the generator's 37 removals = 29 spells + 8 statuses)
Ruling: Task 0's "30 spells" expectation was a plan error; corrected to 34 in the plan — the generator reads the real files, so nothing else changes — costs nothing if wrong.
Ruling: lint baseline is exit 1 with 14 pre-existing unmarked cards, not exit 0; Task 3 Step 8 now compares against that baseline — if wrong, Task 3 could miss a new lint failure hidden in the count; mitigated by "none mentioning Emotion".
Ruling: no task review for Task 0 — it created nothing; the controller checked its numbers against the generator — costs nothing.
Task 1: review 1 — spec ❌ (2 Important): bright Surges lack the §4.3 Wisdom save vs non-allies; DescriptionParams DealDamage(1d4,Weapon) invalid type.
Ruling: bright Surges get SpellRoll/SpellFail/TooltipAttackSave like the dark ones, but keep NO IsHarmful flag — they are buffs on allies and the save comes from SpellRoll; IsHarmful would mark ally casts hostile — costs a missing "hostile" AI/UI cue on enemy casts if wrong.
Ruling: reviewer Minor "Awe overrides the parent's TickType (HYPNOTIC_PATTERN is TickingWithSource)" promoted into the fix round — it breaks the global constraint's intent of keeping the parent's behaviour and changes when the duration counts down — costs one extra line of change if wrong.
Task 1: minor (deferred): matrix test is circular (asserts reaction() against %GATE; only 4 of 64 names pinned) — add a spec-derived 24-blend table.
Task 1: minor (deferred): "Concentration" has no LSTag (english.xml tags it elsewhere).
Task 1: minor (deferred): Emotional Alchemy passive text omits the same-thread → overwhelm line (Overwhelm has its own passive).
Task 1: minor (deferred): header should say regenerating after --apply yields a smaller patch (reads the live game).
Task 1: fix round 1/5 (3 addressed, 0 open — bright Surge save; Weapon damage type; using-statuses inherit TickType; tests 1094 -> 1150)
Task 1: minor (deferred): implementer's report wrongly says Grief uses `using`; the output is correct (Grief keeps TickType EndTurn).
Task 1: complete (files in Design/Rework/tools + heartweaver/, review clean after fix round 1)
Task 2: review — spec ✅, quality Approved (0 Critical/Important). ⚠️ idempotency with Surges present is untested until Task 3 Step 7 (its second run must print "=").
Task 2: minor (deferred): --apply writes the two files non-atomically (a locked .tbl would leave lsx/tbl out of sync).
Task 2: minor (deferred): prints "written" even when nothing changed; drops empty list segments; header calls the Shout "Passives".
Task 2: complete (file Design/Rework/tools/heartweaver_debug_list.pl, review clean)
Ruling: the plan file's embedded generator/test code was replaced with the post-fix-round versions and Step 4 now expects 1..1150 — the plan must match what Task 3 regenerates from — costs nothing if wrong.
PAUSED before Task 3: needs a user message starting with [fechado].
User decision (2026-10-06, [fechado] message): R9 — peaks, intense and feelings each get their OWN StackId (= their status id) so combinations coexist; moods keep the shared StackId MOOD (one mood per creature, at most one reaction per Surge).
Task 1: reopened — fix round 2/5 for the StackId decision (base copy in base2/).
Task 1: fix round 2/5 (1 addressed, 0 open — own StackId per peak/intense/feeling, MOOD shared; tests 1150 -> 1202)
Task 1: minor (deferred): when two peaks fade in the same tick, which mood survives depends on engine ordering.
Task 1: complete (re-closed after round 2, review clean)
Ruling: plan's embedded code re-synced with round-2 versions, Step 4 expects 1..1202, summary table updated — costs nothing.
PAUSED before Task 3: the [fechado] tag covered only the user's previous message; this turn is open again.
User decision (2026-10-06, [fechado]): D14 revised — peaks AND intense share StackId EMOTION (one emotion at a time, so one mood comes out); moods share MOOD; feelings keep their OWN StackIds.
Task 1: reopened — fix round 3/5 for the revised D14 (base copy in base3/).
Task 1: fix round 3/5 (1 addressed, 0 open — peaks+intense StackId EMOTION, moods MOOD, feelings own; tests 1202 -> 1203)
Task 1: complete (re-closed after round 3, review clean). Plan code re-synced, Step 4 expects 1..1203.
Ruling: Task 3 will run in a FOREGROUND subagent inside the next [fechado] turn — background fix rounds report in a new, un-tagged turn where mod writes are forbidden (happened twice) — costs nothing.
PAUSED before Task 3 (second time): the [fechado] window closed while the round-3 subagent ran in the background.
R9 investigated (user request): vanilla shares StackIds across status types (COMMAND, KNOCKED_OUT_SURRENDER, TWN_DISTILLERY_DRUNK_STATUS); parents FEARED/STUNNED/HYPNOTIC_PATTERN have no StackPriority/StackType; no StackId condition exists. Risk downgraded to low, no code change. Spec R9 updated.
Task 3: dispatched in the foreground ([fechado] turn); BASE 68dcce5
Task 3: implementer DONE_WITH_CONCERNS — commit 8750cd2 pushed (68dcce5..8750cd2); lint now exit 0 (the 14 baseline warnings were the old Emotion/Feeling cards); 40 variants with AmountOfTargets; Status_FEAR/INCAPACITATED created; Status_KNOCKED_DOWN.txt now empty.
Task 3 concern → Task 1 defect: re-running the generator after variants exist lists the 40 new _N variants as removals (removals() matches every Emotion* name not in the new base set). Must be fixed before anyone re-applies a regenerated patch.
Ruling: commit footer says "Claude Sonnet 5.5" (the subagent's own attribution) instead of Opus; pushed history is not rewritten — costs a slightly wrong co-author line.
Ruling: the commit also carries earlier unsynced mirror drift (Progressions, ActionResourceDefinitions, SkillLists, other stats) — sync-mod.sh mirrors the whole game state by design — costs a noisier commit.
Task 3: review — spec ✅, quality Approved (0 Critical/Important); lint exit 0 explained (old cards were the 14 baseline warnings).
Task 3: complete (commit 8750cd2, pushed, review clean)
Task 1: reopened — fix round 4/5 (fresh implementer, opus): removals() deletes our own _N upcast variants when re-run after apply.
Task 1: fix round 4/5 (1 addressed, 0 open — removals() keeps the current Surges' _2.._6 variants; tests 1203 -> 1212; regenerated patch now 0 removals, 69 in-place replacements)
Task 1: minor (deferred): the 2..6 variant range is duplicated in removals() and build_upcast_patch().
Task 1: complete (re-closed after round 4, review clean; generator fix pushed)
Task 4: complete (guide Design/Rework/plans/2026-10-06-heartweaver-engine-test.md identical to the plan block, revised row 3.5 present; Context/07 Heartweaver item updated)
Ruling: Task 4 reviewed by the controller instead of a reviewer subagent — a verbatim copy plus a two-phrase doc edit, both checked directly — costs a missed wording issue in the Context line at worst.
Final review (opus): engine approved; 2 Important in the test guide (2.1 said "no save" — stale since fix round 1; 1.6 used Lesser Restoration, which can't touch these statuses) + Minor spec §7.2 gate wording + 2.4 IsHarmful note. One fix wave applied (guide + plan block + spec), controller-verified.
Ruling: spec §7.2 now says distances 1 and 4 need no passive (matches %GATE, the guide and the level-1 grant) instead of making Emotional Alchemy a gate — costs a spec rewording if plan 2 wants the passive to gate them.
Ruling: the fix wave's scoped re-review was done by the controller (three table rows and one spec line, checked by grep) — costs a missed typo at worst.
Plan 1: COMPLETE.
