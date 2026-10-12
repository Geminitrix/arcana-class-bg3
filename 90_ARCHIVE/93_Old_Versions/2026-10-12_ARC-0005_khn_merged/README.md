# ARC-0005 — Khonsu helpers merged — 2026-10-12

Moved here, not deleted. The nine one-function files of `Mods/<mod>/Scripts/thoth/helpers/` were merged into
`ArcanaHelpers.khn` (same function names, same bodies) by `55/_wip/ARC-0005/merge_khn.pl`. Reason: the Toolkit crashes
while Khonsu opens a script file from disk during the AI load; one file means one open instead of nine.
