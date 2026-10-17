# 00.07 · Implementation policy

*Accepted with the architecture (ADR-0001, ADR-0007) · 2026-10-11.*

Writing mod code is the most expensive work and the Owner often prefers to do it in the Toolkit. So the
team **always delivers a spec**, and code is written only on request. Every ticket carries the field
`implementation`:

| Value | Who writes the mod files | What the team does |
|---|---|---|
| `pending` (default) | Nobody | Engineering writes `SPEC_ARC-####.md` in `55`; the ticket stops at **Spec Ready** |
| `owner` | The Owner, in the Toolkit | Same spec. Afterwards Engineering runs `sync_data`, the validators, compares the result item by item with the spec and opens a bug in `62` for any divergence — it never fixes on its own |
| `claude` | Mod Engineer / specialists | Only after the Owner asks explicitly ("implementa o ARC-0142"). The field changes to `claude`; the work goes layer by layer, each with the verification command and its result |

## Rules

1. The spec covers everything needed to implement without guessing; it contains **no code**.
2. Writing to the game copy of the mod needs **both** a message starting with `[fechado]` **and** a ticket
   with `implementation: claude` (ADR-0007, enforced by `jt-gate`).
3. The mod lives in Data; after any change there, `sync_data` refreshes `51` before the commit (ADR-0003).
4. Design, Narrative, Art, QA and Release work normally in all three modes.
5. Optional shortcut: a script can draft Stats text from `25` for the Owner to paste in the Toolkit
   (`82_Automation/gen_stats_from_yaml`, planned).
