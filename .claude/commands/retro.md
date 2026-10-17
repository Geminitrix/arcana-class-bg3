---
description: Sprint review and retrospective, then archive the sprint
argument-hint: <S##>
---

Review and retrospective for $ARGUMENTS.

1. Review (`10.04_Ceremonies/review/REVIEW_S##.md`): each sprint ticket — done or not, acceptance criteria
   checked. **The Owner validates the deliveries** — present the list and wait.
2. Retro (`10.04_Ceremonies/retrospectives/RETRO_S##.md`): keep / stop / start, from the daily logs and the
   Owner's comments. For a release sprint add the balance retrospective (intent vs observed, `27.03`).
3. Velocity: append done effort points to `10.05_Roadmap_and_Releases/velocity_metrics.md` (create it at the first retro).
4. Copy `10.02_Active_Sprint/` to `90_ARCHIVE/91_Closed_Sprints/S##/`; unfinished tickets go back to the
   backlog (`sprint:` cleared); empty the daily logs folder.
5. `update_board.pl`, commit + push (`S##: review and retro`).
