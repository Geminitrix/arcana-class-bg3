---
id: ARC-0023
title: "Starchild refining: rework to the subclass standard v2.1, with paths of light"
type: design
epic: EPIC_Rework_Subclasses
subclass: starchild
status: in_progress
owner: Lead Class Designer
implementation: pending
priority: must
value: 5
effort: 4
inputs: [21.04/_SUBCLASS_STANDARD.md, 21.04/_SUBCLASS_REFINING.md, 05.02/Starchild.md, 21.08, 31.01, 10.06/Open_Questions.md]
outputs: [21.04/Starchild/REFINE_Starchild.md, 21.04/Starchild/DECISIONS.md, 21.04/Starchild/DESIGN.md, 21.03/Starchild.md, 21.08]
blocked_by: []
sprint:
created: 2026-10-16
---

# ARC-0023 · Starchild refining

**Goal:** review the Starchild against the Depth Model of standard v2.1 with the refining method, design the paths of
light the Owner asked for, log the answers as decisions and write the dossier (`DESIGN.md` + `DECISIONS.md`).
**Intent:** a focused, high-output healer (Soraka) who specialises in a path of light — star (Radiant, healing), sun
(Fire), moon (Cold) — with healing and support as the focus on every path, an axis, an ultimate and a 1–12 journey the
player feels.

## Acceptance criteria

- [x] Review started: `21.04/Starchild/REFINE_Starchild.md` (frame, portrait, audit)
- [x] Owner chose how the paths work and a kit direction
- [x] Decisions logged in `21.04/Starchild/DECISIONS.md` (prefix `SC`, SC0–SC32)
- [x] `DESIGN.md` complete and `21.03/Starchild.md` written from the approved map
- [ ] Propagation (00.08) to every department; `check_propagation.pl Starchild` prints OK
- [ ] Build ticket opened (`implementation: claude`), spec in `55`

## Gates

- [ ] Design gate (`21.04/_SUBCLASS_STANDARD.md` §15)
- [ ] Narrative gate (`32.04`)
- [ ] DoD (`00.03`)

## Log

- 2026-10-16 — created. Game read with `dump_progression.pl` (matches `05.02/Starchild.md`). Depth audit recorded in
  `REFINE_Starchild.md`. Owner brief: healer first (Soraka), with paths of light — sun (Fire), moon (Cold), star
  (Radiant, healing) — either two paths on a star trunk or three paths. Nothing in the game changed.
- 2026-10-16 — Owner: one light (Star / Sun / Moon) changes every heal, ranked with the Awakening tiers (SC1, option C);
  chosen once per long rest, shown as a status until the next long rest (SC2). The term "path" is retired; name open.
- 2026-10-16 — Owner: names approved — Hymn, Sing a Hymn, Hymn of the Stars / Sun / Moon (SC3); the three Hymns must be
  equally viable (SC4). Open: the "no Hymn" reminder status.
- 2026-10-16 — Owner: no-Hymn status is **Unsung** ("Your light flickers, dim and waiting. Sing a Hymn to choose your
  light."), reminder only (SC5). Next: how the three Hymns differ.
- 2026-10-16 — Owner: the Hymns change the shape of the heal — focused / radiant / tidal (SC6). Next: the axis.
- 2026-10-16 — Owner: axis **Timing** (SC7); `21.08` Axis row updated. Next: the core rule of the darkest hour.
- 2026-10-16 — Owner: the darkest hour is an exclusive mark consumed by her next heal (SC8). Next: its name.
- 2026-10-16 — Owner: the mark is named **Dusk** (SC9). Next: how Dusk begins and ends.
- 2026-10-16 — Owner: Dusk below half, Nightfall below a quarter, never both; her heal consumes the mark (SC10). Next: Downed allies.
- 2026-10-16 — Owner: Downed clears the mark (SC11). Next: can the Starchild herself be marked.
- 2026-10-16 — Owner: only allies are marked early; later her own Dusk empowers the heals she gives (SC12). Next: the ultimate.
- 2026-10-16 — Owner: ultimate = the answered wish, a mass heal that answers every mark (SC13); Great Star and Eclipse kept for the progression (SC14); rename every Soraka/Lux name (SC15).
- 2026-10-16 — Owner: Aspect card = the Great Star (Stars only); Tier III = Eclipse (Sun + Moon) (SC16). Next: the Awakening goal.
- 2026-10-16 — Owner: the Awakening counts answered marks, Dusk 1 / Nightfall 2 (SC17). Next: Tier I and II bonuses.
- 2026-10-16 — Owner: Tier I = Great Star + Undying Hope (1 HP, Nightfall); Tier II = condition by Hymn — Dazzled / strong slow / Burning, no damage (SC18).
- 2026-10-16 — Owner: only the first single-target heal of each turn carries Tier II / Eclipse, gated by a hidden 1-turn status; Eclipse joins all three lights (SC19, amends SC16). Next: card review.
- 2026-10-16 — Owner: six vanilla twins replaced (SC20); Stars sharpen / Sun spreads / Moon lingers on every card (SC21); each card a container with a child per Hymn, locked by the Hymn (SC22).
- 2026-10-16 — Owner: while Unsung the cards are locked and Sing a Hymn works in combat as a bonus action (SC23, amends SC5); heal cards use the containers too (SC24). Card review part 2 proposed (SG7–SG11).
- 2026-10-16 — Owner: card review part 2 approved (SC25). Part 3 proposed (SG12–SG17).
- 2026-10-16 — Owner: part 3 approved except Point of Light (SC26): Equinox, Sunburst, Final Spark / Cosmic Omen / Stellar Anchor removed. Point of Light: Owner wants her to become a light source like vanilla Light.
- 2026-10-16 — Owner: Point of Light is an exploration cantrip — Stars Perception/Investigation, Sun Insight/Persuasion and the biggest light, Moon Sleight of Hand and dim light (SC27).
- 2026-10-16 — Owner: the Moon adds Deception (SC28). Level map 1–12 proposed (REFINE §8).
- 2026-10-16 — Owner: level map 1–12 approved (SC29); the flight passive is dropped (SC30). Next: the names pass.
- 2026-10-16 — Owner: child names = Starlit / Sunlit / Moonlit + neutral base (SC31). Base names proposed (REFINE §9).
- 2026-10-16 — Owner asked for option C (a unique name per child) to compare; written in REFINE §9.1.
- 2026-10-16 — Owner: unique child names with neutral container names (SC32, replaces SC31).
- 2026-10-16 — DESIGN.md and 21.03/Starchild.md written from SC0–SC32; 21.08 Starchild column updated. Design calls left open in DESIGN §14 (Sun spill and Moon tide do not answer marks; action types of Guiding Light / Tether). Propagation pending: 10 artifacts (check_propagation.pl Starchild).
