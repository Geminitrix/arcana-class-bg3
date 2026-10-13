# The Spinner — design decisions (ARC-0008)

Working note. SP1–SP43 are the decisions of the design conversation of 2026-10-08 (before the project
migration), recorded here so they live in a file; they are what `21.04/Spinner/2026-10-08-spinner-design.md`
describes. Decisions of the raise (ARC-0008) continue from SP44.

Sources: the 2026-10-08 design conversation; `21.04/Spinner/2026-10-08-spinner-design.md`.

## Decision log

| # | Decision | Source |
|---|---|---|
| SP1 | **Fully deterministic.** No rule, fate or start position uses chance beyond the ordinary damage dice and saves | author |
| SP2 | **The mechanic: fates.** A **Misfortune** on an enemy, a **Fortune** on an ally or the Spinner; each is a countdown that **resolves** at 0 | proposal accepted |
| SP3 | **The Cascade:** when a fate resolves, every other fate of the Spinner advances 1 step; a fate brought to 0 resolves and cascades in turn. Unlocked at **level 3** | author (rule), proposal accepted (level) |
| SP4 | **Cascade range grows:** 9 m at level 3, unlimited once the chain goes critical at level 9 (SP27), global at level 12 | proposal accepted |
| SP5 | **The wheel of fate turns on the Spinner's turn:** fates count down at the start of the Spinner's turn (`TickingWithSource` + `TickType "StartTurn"`, vanilla CHILL_TOUCH / BESTOW_CURSE) | author (the flag), proposal accepted |
| SP6 | **One fate per card per creature; the same card again adds turns** (`StackType "Additive"`) | proposal accepted |
| SP7 | **Waiting is in the card:** each card has a fixed length and a fixed effect; long cards are the strong ones. (Woven Spell Slots always cast at the highest level, so no "choose N") | author |
| SP8 | **Role:** ranged magical damage — Misfortune is the main style (sustained + burst); Fortune the secondary (timed support, allies as pieces of the Cascade) | author |
| SP9 | **Bleed and resolution:** a Misfortune may bleed each turn and/or resolve; **advancing a fate skips its bleed** for that turn (bleed or pull it down) | author (bleed), proposal accepted (skip) |
| SP10 | **Advancing goes through a tech status:** `ApplyStatus(…_TECH,100,0)` → Osiris PROC → `GetStatusTurns` → reapply N−1 **with the Spinner as `_Source`**; at 0 the script fires the resolution. Negative durations don't subtract | author (tech trigger), proposal accepted |
| SP11 | **Secondary ability Dexterity** — initiative: the wheel turns on the Spinner's turn, so acting first matters | proposal accepted |
| SP12 | **Chassis:** saves INT + DEX; light armour; Daggers, Darts, Hand Crossbows, Light Crossbows; skill list *The Fortune-Teller* (Arcana, History, Insight, Investigation, Perception, Sleight of Hand, Acrobatics, Deception); preset STR 8 DEX 15 CON 13 INT 15 WIS 10 CHA 10; sound set Wizard; starting gear built later in the Toolkit | author |
| SP13 | **Colour teal `#60d7d2`**, the emblem's colour | author |
| SP14 | **Rules by level:** 1 fates + advancing · 3 Cascade · 5 Transfer · 7 Spindle of Necessity · 9 Critical Mass · 12 Cascade without limit | proposal accepted |
| SP15 | **Awakening goal: fates resolved** (Fortune or Misfortune, by the wheel or any advance). Goals 3 / 6 / 10 provisional — the author finds them low | proposal accepted |
| SP16 | **Aspect card *Rota Fortunae*:** every fate of the Spinner advances 1 step; once per combat | proposal accepted |
| SP17 | **Capstone *The Wheel Stops* (level 11, Long Rest, Unique):** every creature in combat, **allies included**, is frozen; each action of the Spinner advances all their fates 1 | author |
| SP18 | **Each resolution is one push.** Simultaneous resolutions resolve in **waves**, oldest first, each removed before its effect. Turn start order: wheel of elements steps → fates count down → resolutions in waves | author (per resolution), proposal accepted (waves, order) |
| SP19 | **Level 7 passive named *Spindle of Necessity*** (Plato's Myth of Er); "Momentum" rejected as a wind word | author |
| SP20 | **Tier names Clotho / Lachesis / Aspect of Anticipation** (the Latin Rota names belong to the window, SP32) | proposal accepted |
| SP21 | **Tier I Clotho:** once per turn, the first fate spun starts 1 step closer (minimum 1) | author |
| SP22 | **Tier II Lachesis:** when a Misfortune resolves, the Spinner and allies within 3 m of its target gain temporary hit points (replaces +2 AC: too strong when stacked and not the theme) | author |
| SP23 | **Tier III Aspect of Anticipation:** **Recurrence** (a resolved fate returns once, after the chain ends) + **Ready: Foreseen**; no ability bonus | author |
| SP24 | **Ready: Foreseen:** once per round, when an enemy carrying a Misfortune attacks or casts, advance that Misfortune 1; at 0 it resolves before the attack | author |
| SP25 | **Anticipation stays the Aspect** although Plutchik's Anticipation is a Resonant Surge: every Aspect is an emotion | author |
| SP26 | **Science: the nuclear chain reaction** (multiplication factor *k*, subcritical / critical / supercritical) structures the Cascade | author |
| SP27 | **Critical Mass (level 9):** once a chain has resolved 3 fates, its Cascades have no range limit | author |
| SP28 | **Edge cases:** combat end removes every fate unresolved · Misfortune starts combat, Fortune only in combat · Spinner downed = wheel frozen · bearer dies → Transfer (Misfortune) or lost (Fortune, except the Angel) · cleanse = nothing · two Spinners move only their own fates · frozen fates neither count nor are pushed · Recurrence after the chain; transfer keeps the right to return; a returned fate never returns again · Transfer to the nearest enemy within 9 m (Additive if same card) | proposal accepted |
| SP29 | **Speeds** (adapted from Legends of Runeterra): Ready (reaction) · Burst (0, bonus or free) · Fast (1–2) · Measured (2–3, action) · Slow (3–4, **Action + Reaction**) · Ritual (5–6, **Action + no movement for the turn**, `ActionResourceBlock(Movement)`) | author |
| SP30 | **Each element has spells only in the speeds that fit it**; each spell follows its element's theme; damage first, extra effects as riders, not crowd control | author |
| SP31 | **The wheel of elements:** the 10 magical damage types on a fixed wheel, one step at the start of each Spinner turn | author |
| SP32 | **The window — Past / Present / Future** (Regnavi / Regno / Regnabo): Past = fate 1 turn shorter, Present = Crown strike, Future = 1 turn longer; the other 7 elements locked. Burst and Ready unchanged; minimum length 1; the Future has no power bonus | author (Past/Future), proposal accepted |
| SP33 | **The wheel never stops, it pauses:** the next combat starts on the next element; a status shows the position at all times | proposal accepted |
| SP34 | **The first combat ever starts on Lightning** | author |
| SP35 | **Order:** Radiant (top) → Fire → Lightning → Thunder → Force → Necrotic (bottom) → Cold → Acid → Poison → Psychic; each element faces its opposite | proposal accepted |
| SP36 | **15 elemental spells:** one per element, two Rituals at the poles (Radiant, Necrotic), four wildcards (Pull of Fate, Frozen Moment, Dissolve, Déjà Vu) | author (wildcards), proposal accepted |
| SP37 | **Physical types are the tools:** Piercing = *Spindle Needle* (Burst, Bonus Action, advances every fate on one creature), Slashing = *Atropos' Shears*, Bludgeoning = *Rota Fortunae* | proposal accepted |
| SP38 | **Atropos' Shears cuts only fates with 2 turns or fewer** (cutting a 6-turn Ritual the next turn skipped the wait) | author (problem), proposal accepted |
| SP39 | **Crown strike:** a spell cast with its element in the Present also hits the target at once; no extra status | proposal accepted |
| SP40 | **Fortunes are the card's four winged creatures:** Bull (Fast 1, temp HP, can't be moved), Eagle (Measured 2, crits on 19–20, sees invisible), Lion (Measured 3, extra action), Angel (Slow 4, large heal, lifts a downed ally). Effect lasts until the end of the bearer's next turn; not on the wheel; part of the Cascade | proposal accepted |
| SP41 | **Cantrip *Spoke of the Wheel*:** a ranged spell attack of the Present element | proposal accepted |
| SP42 | **Utility *Nudge the Wheel* (level 1):** outside combat, turns the wheel one step; no slot; once per Long Rest | author |
| SP43 | **Spell progression:** L1 cantrip, Needle, Fire, Force, Acid, Bull, utility · L3 Lightning, Cold, Radiant, Eagle · L5 Thunder, Poison, Psychic (Ready), Shears · L7 Pull of Fate, Frozen Moment, Dissolve, Lion · L9 Necrotic Ritual, Déjà Vu, Angel · L11 The Wheel Stops, Radiant Ritual | proposal accepted |
| SP44 | **The ultimate (K3) is *Alignment*:** every fate of the Spinner whose element is in the window (Past, Present or Future) resolves now, each with its own Cascade. It ties the wheel of elements to the fates, which otherwise meet only at cast time. Fortunes have no element: Alignment never resolves them directly, but Cascades push them as usual | author (2026-10-13) |
| SP45 | ***Convergence* replaces *Pull of Fate*** (level 7) and becomes a tool outside the wheel: every Misfortune of the Spinner on the field moves to one enemy, each keeping its count. Force keeps one spell. Same-card merges need their own rule (open) | author (2026-10-13) |
| SP46 | **Alignment: level 5, Action, once per combat, no slot and no Thread** (the once-per-combat limit is the real cost; no second limiter) | author (2026-10-13) |
| SP47 | **Working direction: Proposal B, *Rise and Fall*** (`2026-10-13-spinner-three-proposals.md` §2): creatures on the Rota's four positions — Rising (*Regnabo*), Reigning (*Regno*), Falling (*Regnavi*), Fallen (*Sum sine regno*) — moving one step at the start of the Spinner's turn. Supersedes the fates of SP2 and the role of SP8 for the raise; SP44–SP46 belong to the old direction | author (2026-10-13) |
| SP48 | **The term is "on the Wheel"** (not "bound"): a creature is on the Wheel while it carries one of the four position statuses; it is a position in the cycle, never a physical condition (no Restrained-like effect) | author (2026-10-13) |
| SP49 | **Once on the Wheel, a creature stays on it**: it cycles through all four positions, allies included (they fall after they reign). It leaves only through ***Atropos' Cut***; death and the end of combat also end it | author (2026-10-13) |
| SP50 | **Atropos' Cut moves to level 3**, so the player has the way out from the start of the Wheel's payoffs | author (2026-10-13) |
| SP51 | **The subclass is renamed *The Kingmaker*** (was *The Spinner*): the archetype of direction B, the one who crowns and uncrowns. To do when the spec is written: icons, ClassDescription, progression name, texts, wiki; the folder `21.04/Spinner` and this file keep their names until the raising spec | author (2026-10-13) |
| SP52 | **Two peaks, two transitions; the peaks pay in different currencies** so the Crossing pair multiplies instead of overlapping (two sources of Advantage don't stack): **Reigning** — critical hits on 19–20, Advantage on saving throws · **Fallen** — attacks against it have Advantage, no reactions | author (2026-10-13) |
| SP53 | **Falling** — Disadvantage on attack rolls and reduced movement speed (mirror of Rising's extra movement) | author (2026-10-13) |
| SP54 | **Rising** — increased movement speed; can't be knocked Prone | author (2026-10-13) |
| SP55 | **Falling is lighter** (replaces SP53's Disadvantage): reduced movement speed and **−1d4 to attack rolls** (vanilla Bane-like penalty) | author (2026-10-13) |
| SP56 | **The Court, format (b):** a card (Bonus Action, *Choose*) appoints an ally to a court office; each office changes how that ally plays with the Wheel and with the King (the ally currently Reigning). One system, one new verb (*appoint*). Office names: D&D / medieval offices, not *Game of Thrones* terms (open: final list, level, limits) | author (2026-10-13) |
| SP57 | **The King is a visible title:** the ally currently Reigning carries a **King** status (crown on the portrait, named in the combat log); it moves with the Reigning position. The Court's offices read it | author (2026-10-13) |
| SP58 | **One King at a time:** when several allies are Reigning, one is the **King** and the others are **Regent** (status *Regent*: same Reigning effects, no crown; offices that read "the King" ignore Regents). Which one is King: open | author (2026-10-13) |
| SP59 | **The Court is the Small Council** (*A Song of Ice and Fire* / *Game of Thrones* as a fiction reference, S3–S4): Hand of the King, Master of Coin, Master of Whisperers, Master of Laws, Master of Ships, Grand Maester, Lord Commander of the Kingsguard. The names may be used (non-profit public mod) or replaced in the text pass by our own names that evoke the same office | author (2026-10-13) |
| SP60 | **The seven offices (draft effects) and when they open.** One card *Appoint* (Bonus Action, *Choose*); each ally holds at most one office until combat ends; the options grow with level. **Level 3:** *Hand of the King* — while there is no King, the Hand is the King (crown and Reigning's 19–20) · *Lord Commander of the Kingsguard* — within 3 m of the King, attacks against the King have Disadvantage (not "take the hit": that is the Resonant's Trust, R27) · *Grand Maester* — healing an ally on the Wheel moves it one position up. **Level 7:** *Master of Laws* — an enemy that attacks the King moves one extra position down at the next turn of the Wheel · *Master of Whisperers* — enemies on the Wheel within 9 m can't be invisible or hide; Advantage against Falling enemies. **Level 9:** *Master of Coin* — the first time each turn it hits a Fallen enemy, the Kingmaker regains a Woven Spell Slot (PC: a Thread) (economy card: price with care) · *Master of Ships* — a Crossing also pays when the Fallen enemy is within 9 m of the Master of Ships | author (2026-10-13) |
| SP61 | **Who wears the crown:** among allies Reigning, the King is the one that has been on the Wheel the longest (the same "oldest first" order that resolves Crossings); the crown stays with it while it Reigns, then passes to the next Regent in the same order | author (2026-10-13) |
| SP62 | **Nudge moves forward only** (hastens fate, never undoes it): no "Reign forever" or "Fallen forever" loop (B3). Going back belongs only to *Peripeteia*; holding a position only to *The Sphinx* (level 9) | author (2026-10-13) |
| SP63 | **Nemesis' Exchange:** always one ally with one enemy (both on the Wheel), they swap positions; **level 7**, once per combat. Moves out of the crowded level 3 and fills level 7 | author (2026-10-13) |
