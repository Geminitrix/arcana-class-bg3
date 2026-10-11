# 27.04 · Resource and action economy

*Condenses spec Part II §20. Readers: Balance Designer, Spell Designer, Mod Engineer.*

**Every resource enters through a source and leaves through a sink.** More sources than sinks → inflation
(the resource stops mattering); more sinks than sources → scarcity and frustration. A resource's price
should match the power it buys.

## Resource map of a class
| Resource | Source | Sink | Recharge | Decision it creates |
|---|---|---|---|---|
| Spell slots (Arcana: Woven Spell Slots) | Level, class | Casting, upcasting | Long rest (short rest for Warlock-style) | Spend now or save |
| Class resource (PC edition: Threads) | Level | Features / cards | Per feature | Which feature deserves it |
| Uses per rest | Feature | Each use | Short or long | When to use the only one |
| Per turn / combat | Feature | Each use | Values in `55.00` `CooldownType` | When to trigger |
| Hit points | Healing, rest | Damage | Rests, healing | Risk vs safety |
| Action, bonus, reaction, movement | Every turn | Each action | Per turn / round | What to do this turn |
| Concentration | One effect at a time | Keeping it | Until broken | Which effect to keep |
| Camp supplies (global) | Exploration | Long rest | Gathering | When to rest |

## BG3 rest rhythm *(community source — verify in game)*
Two short rests per long rest, free. Long rest costs camp supplies (more on harder difficulties). Without
supplies, a partial rest restores resources only to half and gives no short rests back.
Design consequences: short-rest resources get up to three windows a day, so each use must be worth less
than a long-rest use; long rest is the base rhythm; the Balance Designer fixes a **reference adventure
day** (combats, short rests) by ADR from real tests.

## Action economy
| Turn resource | Rule |
|---|---|
| Action | The main cost. Features that don't spend it need another limit |
| Bonus action | Contested by every class — avoid several competing features in one subclass |
| Reaction | One per round; competes with vanilla reactions |
| Movement | Beware free extra movement or displacement |
| Concentration | Strong lasting effects need concentration or an equivalent cost |
**Every feature answers: which resource pays for this?**

## Loops and traps
Positive feedback (success buys more success) snowballs; negative feedback stalls. **Engine:** spend A to
get B, B gives back A — cap per turn or rest, or require a net cost. **Deadlock:** sinks and sources that
block each other — review cross-dependencies.

## Audit table (`26.01`)
Resource · sources per rest · sinks · balance · risk (piles up / runs out) · action. Fewer distinct
resources = less to track; each one needs a visible counter.
