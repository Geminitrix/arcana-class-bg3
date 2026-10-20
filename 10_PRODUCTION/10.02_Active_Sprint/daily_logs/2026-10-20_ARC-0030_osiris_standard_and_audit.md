# 2026-10-20 · The Osiris goals: one standard and an audit (ARC-0030, Mod Engineer)

**Done:** created ARC-0030 (`/novo-ticket`) and worked it the same day at the Owner's request. The house standard is
`57.05/OSIRIS.md` §13 (layout, header, regions, English comments without history, `ARCANA_` names, timers, tables in an
Init PROC, generated goals); `82_Automation/check_osiris.pl` checks it and, with `--compare`, proves a tidy-up changed no
rule. The 21 goals in the game had 166 errors of it. The 20 goals the game keeps are rewritten in
`55/_wip/Osiris/ARC-0030/goals/` (check OK; 10 goals "same code", 10 differ only by the fixes). The audit is
`55/_wip/Osiris/ARC-0030/RISKS.md`: 10 fixes with no change in play, 5 approved by the Owner (the Kingmaker's Wheel and
the grudges no longer wiped when another fight ends; the roster reset when a fight ends; Hemorrhage renamed; the dead
MirrorWithdraw goal retired to `93`), 8 left open. The three generators emit the standard; `gen_emotion_alchemy.t`
passes again (340/340). `61.02/Class/QA_ARC-0030.md` holds the 11 play tests.

**Not done:** nothing written in the game (open all session, OR-11); `gen_upcast_variants.pl --apply` not run (it writes
the game).

**Waiting on the Owner:** review `goals/` and send `[fechado] ARC-0030` (the apply is in `55/_wip/Osiris/ARC-0030/README.md`),
compile, play QA_ARC-0030.

**Applied (`[fechado] ARC-0030`):** backup in `94_Safety_Backups/ARC-0030_2026-10-20/`; the 20 goals copied into the
game, `ARCANA_Spell_MirrorWithdraw` taken out; `sync_data` changed only those files; `check_osiris.pl` OK on `51`, same
code as `goals/`. Waiting: the Owner compiles the Story, then plays QA_ARC-0030 (now `ready`).
