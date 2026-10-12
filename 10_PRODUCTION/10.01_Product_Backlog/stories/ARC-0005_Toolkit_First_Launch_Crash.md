---
id: ARC-0005
title: Toolkit crashes on the first launch, works on the second
type: bug
epic: EPIC_Rework_Subclasses
status: in_progress
owner: Tools
implementation: claude
priority: should
value: 3
effort: 1
inputs: [Status_BOOST.txt, Status_BOOST.stats, Toolkit crash logs]
outputs: [Status_BOOST.txt, Status_BOOST.stats]
blocked_by: []
sprint:
created: 2026-10-12
---

# ARC-0005 · Toolkit crashes on the first launch, works on the second

**Goal:** the Toolkit opens the Arcana project on the first try.
**Intent:** the Owner stops paying a crash per launch after every update.

## Acceptance criteria

- [ ] The one data error the engine reports for the mod is fixed: `COMPREHEND_SUPERNATURAL` `AuraStatuses` has
      `ApplyStatus(DETECT_SUPERNATURAL_ABERRATION,100,_1)` — `_1` must be `-1` (log: `failed to parse stats expression
      string "_1"`), in the game `.txt` and the Toolkit `.stats`.
- [ ] Owner test: open the Toolkit, close it normally, open it again — three times. Crash or not, each time.

## Findings (2026-10-12)

- Every crash today (12:26, 12:54, 13:15, 14:51, 15:30, 15:48 local) has the same stack: `ls::anubis::System::LoadFramework`
  → `TreeRef::UpdateExpressions` → `ls::khonsu::Machine::FindScript` → read access violation. It is preceded in
  `log.*.txt` by four `!CRITICAL! Double delete detected` (`BlocksAllocator<64>::Free`, Noesis UI teardown) at the
  client state swap to `LoadSession`: memory is freed twice, then the AI framework load reads it.
- The crashing and the working session load exactly the same data up to that point (normalised logs identical,
  same 22 design asserts). So the data is not what differs between them.
- Not every update is followed by a crash (14:02, the first launch after stage 3, opened fine), and 15:48 crashed
  with no change to the mod since the last good session. Every crash was followed by a working launch within a
  minute; launches after a normal close usually crashed.
- Toolkit binaries unchanged since 2026-07-31; the mod's Khonsu helpers unchanged since 2026-10-07.
- The `_1` typo predates the project migration (2026-10-11), so it cannot be what made the crash frequent; it is
  fixed because it is the only data error the engine reports for the mod, and a failed parse is a plausible source
  of a bad pointer.

## Log

- 2026-10-12 — investigated (read only): crash dumps, `errors.*`, `log.*`, Story, editor settings. Ticket created.
