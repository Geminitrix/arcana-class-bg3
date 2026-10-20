# ARC-0030 · The standardised Osiris goals (build scratch, OR-21)

`goals/` holds the final text of the 20 goals the game keeps (`ARCANA_Spell_MirrorWithdraw` is retired, `RISKS.md` B5).
`RISKS.md` is the audit: what can go wrong in each goal, what was fixed and what stays open.

Checks, from the repository root:

```
perl 80_TOOLS_AND_PIPELINE/82_Automation/check_osiris.pl --dir 50_ENGINEERING/55_Implementation_Specs/_wip/Osiris/ARC-0030/goals
perl 80_TOOLS_AND_PIPELINE/82_Automation/check_osiris.pl --compare <a copy of the game goals> 50_ENGINEERING/55_Implementation_Specs/_wip/Osiris/ARC-0030/goals
```

The first prints OK (20 goals, 0 errors, 0 warnings). The second lists only the code lines of `RISKS.md` A and B.
`ARCANA_Resonant_Overload`, `ARCANA_Aspect_Temperance` and `ARCANA_Resonant_SharedHeart` are the output of
`ARC17_STAGE=4 perl gen_emotion_alchemy.pl`; `ARCANA_CardFamilies` was built with the template of `gen_upcast_variants.pl`
and the rows the game has today.

## Apply (the Owner's `[fechado] ARC-0030`)

1. Back up the game's `Story/RawFiles/Goals/` in `90_ARCHIVE/94_Safety_Backups/ARC-0030_<date>/`.
2. Copy the 20 files of `goals/` over the game's goals; take `ARCANA_Spell_MirrorWithdraw.txt` out of the game folder
   (it is archived in `93_Old_Versions/2026-10-20_ARC-0030_mirrorwithdraw_goal/`).
3. `sync_data`, then `check_osiris.pl` on `51` prints OK, and `--compare` between `51` and `goals/` prints "same code" for all 20.
4. The Owner compiles in the Story Editor (if it still lists `ARCANA_Spell_MirrorWithdraw`, remove it there); Claude
   reads `Story/log.txt`: `0 error(s), 0 warning(s)`.
5. The Owner plays `61.02/Class/QA_ARC-0030.md`.
