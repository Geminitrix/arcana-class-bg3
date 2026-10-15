---
status: done
closed: 2026-10-15 — executed by the Context Keeper role during propagation (00.08): 05.02/Spinner.md renamed Kingmaker.md and rewritten from the game (built 1–12) with the Depth audit updated after the build; 05.00 row, 05/_INDEX, 05.06 roadmap line; verify_context maps Kingmaker
---
# HANDOFF · Lead Class Designer → Context Keeper · ARC-0008

**What:** the subclass designed as *The Spinner* was redesigned and renamed **The Kingmaker** (design only;
nothing changed in the game files). Replace the Spinner's entry in `05` with the Kingmaker's and add its
Depth audit.

**Sources:** `21.04_Subclasses/Kingmaker/DESIGN.md` (the design) ·
`21.04_Subclasses/Kingmaker/DECISIONS.md` (SP47–SP105) · `21.04_Subclasses/_SUBCLASS_STANDARD.md` §3.
The old Spinner design and its audit are archived (`90/93/2026-10-13_ARC-0008_spinner_design`, `…_spinner_audit`).

## 1. `05.02_Subclasses/Spinner.md` → the Kingmaker

- Title: **⏳ Kingmaker — X · Wheel of Fortune · Aspect of Anticipation** (emoji still to confirm).
- One line: *Designed, not built. Force multiplier: creatures ride the Wheel of Fortune's four positions;
  an enemy that falls while an ally reigns suffers a Crossing. Secondary ability CHA.*
- Design pointer: `21.04_Subclasses/Kingmaker/DESIGN.md`.
- "In the game today" stays true: the progression named *Spinner* (`a688d11f-…`) is a placeholder copying
  the Resonant's level 1. Add: the build will rename ClassDescription, progression and ProgressionDescription
  to the Kingmaker.
- Whether the file is renamed `Kingmaker.md` is your call; if so, update `05/_INDEX.md` (the list names
  Spinner) and `05.07` source map.

## 2. Add the Depth audit (2026-10-13)

Audit of the Kingmaker design against §3.

| Question | State | Evidence / what is still due |
|---|---|---|
| I1 fun | ⚠️ | Not played yet; **playtest** after the build |
| I2 striking trait | ✅ | "Creatures ride the Wheel; one rises as another falls" |
| I3 archetype | ✅ | The kingmaker: crowns (Coronation), uncrowns (Dethrone, Usurp), names a Court |
| I4 Aspect | ✅ | The next position is always known; the round is played in a known state; Ready: Foreseen |
| I5 axis | ✅ | **Balance** — *who rises, who falls, and when do they cross?* — free among the subclasses |
| I6 vocabulary | ✅ | Names from the card (Rota, Spoke), its myth (Tyche, Nemesis, Atropos, Ixion), history (Succession) and the Small Council |
| S1–S6 | ✅ | Card read literally; Small Council and DIO/Faceless Void/Bard lend named pieces; science: phase in a cycle; myth: Fortuna, Nemesis, Atropos, Ixion |
| W1 relation to Mystra | ✅ | *"Mystra wove the Kingmaker from the crowns that rise and fall on Fortune's wheel, a thread that decides who reigns."* |
| W2 the Weave in the features | ⚠️ | Only *Atropos' Cut* speaks of threads; the text pass can weave more in |
| M1–M6 | ✅ | Exclusive positions; one rule (The Rota); create/change/spend; a new rule or verb at 3, 5, 7, 9, 11, 12; both sides on one table; Crossings once per enemy per round and move nothing |
| K1–K6 | ✅ | Key features drive the Wheel; ultimate **Peripeteia** (K3); passives are rules; Turn the Spoke (Bonus Action) and the cantrip at level 1 |
| P1–P6 | ✅ | Mid range, specialist in party amplification, felt on the allies' turns, plays from level 1, first payoff on turn 2 (turn 1 with Tyche), real decisions |
| P7 readable | ⚠️ | Positions and the King are on the portrait; the 9 m Crossing range is invisible until level 12 |
| P8–P10 | ✅ | Nothing needs the AI; weaknesses visible; Osiris + Stats, no SE |
| A1–A3 | ✅ | Goal = Crossings; Tyche / Nemesis / Aspect of Anticipation push the Wheel; Rota Fortunae advances, Peripeteia inverts |
| B1–B4 | ❌ | No numbers yet (**balance pass**, `25`, `22.05`); watch the Master of Coin economy and the lone-boss Awakening |
| T1 no SE | ✅ | Osiris drives the Wheel |
| T2 proven | ⚠️ | Every position effect has a vanilla pattern; probes pending (spec §15) |
| T3 generated | ✅ | No large family of its own; upcasts through the existing generator |
| T4 conventions | ⚠️ | Ids proposed; fixed in `SPEC_ARC-0008` |
| D1 Identity Sheet | ⚠️ | Emoji and Aspect VFX still open |
| D2 sources agree | ⚠️ | The game holds the Spinner placeholder until the build; this handoff and the Lore/Localization handoffs align the documents |

**Complexity budget (§15, a suggestion):** 11 combat actions by level 12 and one utility; one main resource
(positions) and one secondary (the Court, set before battle).

## 3. Elsewhere in `05`

- `05.00_READ_FIRST.md`: the row *Spinner · X · Wheel of Fortune · Anticipation · New — designed;
  placeholder progression* becomes **Kingmaker** (same arcanum and Aspect; "New — designed (ARC-0008);
  placeholder progression named Spinner in the game").
- `05.06_Technical_State/Project_State.md` roadmap line "The Titan and The Spinner subclasses": the Kingmaker.

## 4. Open items to list

Balance pass · probes of spec §15 · emoji and Aspect VFX · renames in the game files · the role sits close
to the Resonant's; a future magical burst/DPR subclass is planned (Owner, 2026-10-13).
