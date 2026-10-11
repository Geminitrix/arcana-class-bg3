# 27.03 · Balance — method

*Condenses spec Part II §19. Readers: Balance Designer, Spell Designer, Patch Notes Lead (intent only).
The `game-balance` skill holds the deeper course material.*

**Order matters:** fantasy and story first, numbers second. A perfect number on a feature without
identity is a design failure.

## Kinds of balance
Transitive (more power costs more) · intransitive (rock-paper-scissors: damage types vs resistances,
control vs immunity) · situational (strong vs groups, weak vs a boss) · between strategies (several viable
builds, none dominant — the 7 subclasses).

## Cost curve
Price every ability in one common currency of power and compare price with benefit. Price parts: effect
(in virtual damage), range and area, action used, resource spent, duration and concentration, save vs
auto-hit, conditions of use. Start from **anchors**: vanilla spells and features of the same level, read
in the game data. Community point systems are inspiration, never canon.

## Virtual damage (effects without damage)
1. Name the effect. 2. Find the vanilla spell that does something equivalent; note its level. 3. Find a
damage spell of that level. 4. Use its average damage as the value. 5. Adjust for range, duration, save.
An estimate — playtest decides.

## Two damage measures (per level 1–12)
- **Sustained DPR:** only what repeats at will — the class's floor.
- **Nova DPR:** spending everything to maximise — the ceiling.
Include hit chance and advantage. Compare with the aggregate average of reference classes of the same
role, not one class. Tolerance band (suggested ±15 %) is fixed only by ADR.

## Flow of a balance change
Intent in one sentence → role and pillar → anchors → price on the curve → simulate in `22.02` (both DPRs
per level) → check interactions (concentration, bonus action, stacking, loops) → playtest with standard
saves → adjust **in `25`**, never in copies → record result and intent in the ticket.

## Warning signs
| Sign | Action |
|---|---|
| Always the best choice | Raise the cost or cut the benefit |
| Nobody picks it | Revisit cost and fantasy |
| Only works inside one combo | Give it a minimum standalone value |
| Resource loop (A → B → A) | Cap per turn or per rest |
| Stacks flat bonuses | Swap for advantage, dice or a condition |
| Takes the bonus action with no alternative | Check the action economy (`27.04`) |
| Complexity without payoff | Simplify or cut |

## Living mod
No telemetry, so four lenses: intent, the curve, mod.io feedback, own tests. **Every change has a one-
sentence intent** (it feeds the patch notes) and **every release gets a balance retrospective**
(expected vs observed). Reference difficulty to fix by the Owners (suggested: Balanced and Tactician).
