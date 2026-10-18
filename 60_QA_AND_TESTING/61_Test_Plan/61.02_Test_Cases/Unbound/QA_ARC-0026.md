---
id: QA_ARC-0026
title: Playtest — The Windborn — rework WB0–WB50 (levels 1–12)
type: playtest
subclass: unbound
build: ARC-0026
status: in_qa
owner: QA Lead
sources: [QA-0004, QA-0005, GUIDE_ARC-0026_probes, GUIDE_ARC-0026, TC_ARC-0022]
created: 2026-10-17
---

# QA_ARC-0026 · The Windborn — rework WB0–WB50 (levels 1–12)

**Goal:** play every test, level by level, and mark it on Arcana Test Guides (https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E);
results come back here at `/sync-test-guides`. **Intent:** ARC-0026 is proven in the game, or each failure becomes a fix (bug) or
a decision (design feedback, OR-1). One file per ARC (OR-4): merged on 2026-10-17 from QA-0004, QA-0005, GUIDE_ARC-0026_probes, GUIDE_ARC-0026, TC_ARC-0022.

## Before you start

- Type the level from its part of TOOLKIT_ARC-0026.md (one file, a part per level), compile the Story (log.txt: 0 error(s), 0 warning(s)) and tell Claude; then play that level's session here.
- Console edition (Script Extender off) unless a test says PC edition.
- A Windborn (Unbound subclass) character with no armour and no shield, unless a test says otherwise.
- The stage 1 probes (P1–P9) all passed on 2026-10-17; they are recorded in QA-0004.

## Probes — stage 1 (closed: 9/9 pass, QA-0004)

Before (this section): Stage 1 of ARC-0026 is applied (a [fechado] ARC-0026 message), the Story is compiled and log.txt shows 0 error(s), 0 warning(s). · Console edition: Script Extender off (the PC deck locks the probe spells in combat). · Load a save with the party; the probe spells ("Probe: ...") and the passive Probe Touch are added to every player character on load. · Any class and level. Probes are throwaway: stage 2 removes them. · Write down what you see for each probe, even when it fails: every probe has a plan B.

**Setup:** A fight with at least four enemies, spread out, and one ally in melee with an enemy. One character runs the probes.

### P1 · A Rush: no opportunity attack, paths around obstacles

- **Rule:** SPEC_ARC-0026 P1 (the Rush carries her, WB5)
- **Steps:** Stand next to an enemy. Cast Probe: Rush on another enemy 6-9 m away, behind a table or a corner if you can
- **Expected:** The character runs to the target and strikes it; the enemy she leaves makes no opportunity attack; she goes around the obstacle
- **Fails if:** An opportunity attack on the way, or the Rush stops at the obstacle or refuses the target behind it
- **Result:** pass — Funcionou.

### P2 · Marked enemies can't be rushed

- **Rule:** SPEC_ARC-0026 P2 (Rush only to an unmarked enemy)
- **Steps:** Cast Probe: Mark on one enemy. Open Probe: Rush and hover the marked enemy, then an unmarked one
- **Expected:** The marked enemy can't be targeted (greyed or refused); the unmarked one can
- **Fails if:** The marked enemy can be targeted
- **Result:** pass — Funcionou.

### P6 · A marked enemy makes no opportunity attack

- **Rule:** SPEC_ARC-0026 P6 (the Open Path, WB10: the vanilla Mobile pair)
- **Steps:** Cast Probe: Open Path. Mark the enemy next to your melee ally with Probe: Mark. On the ally's turn, walk away from it. Then do the same next to an unmarked enemy
- **Expected:** Marked: no opportunity attack. Unmarked: the usual opportunity attack
- **Fails if:** The marked enemy still attacks (plan B: a mark that blocks every reaction)
- **Result:** pass — Não funcionou. Porém, fiz uma alteração, criei um Interrupt IDENTICO ao próprio Interrupt_AttackOfOpportunity do vanilla e adicionei no EnableConditions "and not HasStatus('PROBE_ARC0026_MARK')" e agora funcionou perfeitamente, sempre que o inimigo estiver com esse status, ele não vai fazer ataque de oportunidade.

### P7 · A hit marks; an ally's hit marks in her name

- **Rule:** SPEC_ARC-0026 P7 (marks from hits — hers and an ally's)
- **Steps:** Hit an unmarked enemy with any attack (Probe Touch marks it). With Probe Open Path on you, let an ally hit another enemy
- **Expected:** Both enemies show Probe Windswept; the mark ticks down on your turns (2 of your turns)
- **Fails if:** No mark, the ally's hit does not mark, or the mark counts down on the enemy's turns
- **Result:** pass — Funcionou apenas para o ataque básico! Entretanto, fiz uma alteração, ao invés de OnAttack que é o padrão para ataques básicos, coloquei OnDamage, que é o padrão para qualquer tipo de dano, e ai coloquei TotalDamageDoneGreatherThan(0) para que os miss não contem.

### P8 · The bag's X: marks counted, capped at 2

- **Rule:** SPEC_ARC-0026 P8 (X counted and capped)
- **Steps:** Mark 3 enemies. Cast Probe: Count
- **Expected:** Probe Count appears on you showing 2 turns (3 marks, capped at 2); with 1 mark it shows 1 turn
- **Fails if:** No status, or the turns don't match the marks
- **Result:** pass — Agora funcionou como você esperado.

### P3 · Turn start sweeps the marks; turn end is seen

- **Rule:** SPEC_ARC-0026 P3 (the sweep at her turn start; her turn end)
- **Steps:** After P8, end your turn, then start your next turn
- **Expected:** At your turn end Probe Turn Ended shows on you; at your next turn start every Probe Windswept is gone
- **Fails if:** The marks stay, or Probe Turn Ended never shows
- **Result:** pass — Funcionou como o esperado.

### P4 · The vortex pulls marked enemies from 9 m, the others from 6 m, once each

- **Rule:** SPEC_ARC-0026 P4 (Where the Winds Meet, two radii)
- **Steps:** Mark one enemy about 8 m from a point; leave another unmarked 5 m from it and a third unmarked 8 m from it. Throw Probe: Vortex at the point
- **Expected:** The marked enemy at 8 m and the unmarked one at 5 m are pulled to the point and Off Balance, once each; the unmarked one at 8 m is not
- **Fails if:** An enemy pulled twice, the marked one not pulled, or the unmarked one at 8 m pulled (plan B: one 9 m pull for every enemy)
- **Result:** pass — Funcionou, mas eu mudei o jeito que a spell funciona. Ao invés de mudar a área, a área será sempre 9 metros, porém, inimigos com a marca são puxados 9m, e inimigos sem a marca são puxados 6m.

### P5 · Leap of Faith with the Force Tunnel animation

- **Rule:** SPEC_ARC-0026 P5 (Leap of Faith on the Force Tunnel animation, WB7)
- **Steps:** Cast Probe: Leap through a line of two enemies
- **Expected:** A dash-through animation (the Force Tunnel tadpole power), striking each enemy in the path
- **Fails if:** No animation, a broken pose, or it stops at the first enemy (plan B: keep the Spring Attack animation)
- **Result:** pass — Funcionou.

### P9 · Into the Storm: the push from a status

- **Rule:** SPEC_ARC-0026 P9 (a status pushes away from its source)
- **Steps:** Cast Probe: Storm Push on an enemy 3-6 m away
- **Expected:** The enemy is pushed about 3 m away from you and is Off Balance
- **Fails if:** No push, or pushed toward you or sideways (plan B: the goal casts a shove-like spell)
- **Result:** pass — Funcionou.

## Level 1 — The Open Road

**Setup:** A level-1 Windborn, no armour and no shield, in a fight with at least three enemies spread out and one ally in melee with an enemy.

### L1.1 · The class reads The Windborn; the preset and the AC are right

- **Rule:** WB43 · TC B12 (names)
- **Steps:** Create a Windborn at level 1 (or respec one). Look at the subclass name, the default abilities and the character sheet
- **Expected:** The subclass is The Windborn. The preset is STR 8, DEX 15, CON 13, INT 15, WIS 10, CHA 10. Armour Class = 10 + DEX + INT (Be the Leaf). Level-1 spells: Gale Burst only (no True Strike)
- **Fails if:** The old name Unbound anywhere, another preset, Wisdom in the AC, or True Strike in the list
- **Kind:** observe
- **Result:** —

### L1.2 · After an unarmed attack, Zephyr Rush carries you to an unmarked enemy

- **Rule:** WB5, WB18
- **Steps:** Hit an enemy with an unarmed attack. In the bonus actions, cast Zephyr Rush on an unmarked enemy 6–9 m away, past another enemy
- **Expected:** Zephyr Strike and Zephyr Rush both appear after the attack (and after a card). The Rush runs to the target and strikes it with no opportunity attack on the way. It needs no weapon and has no Short Rest cooldown
- **Fails if:** No Zephyr after the attack, an opportunity attack on the way, a weapon requirement, or a cooldown
- **Result:** FAIL — Funcionou mais ou menos. Acertei o inimigo com o ataque desarmado e apareceu o Zephyr Strike e o Zephyr Rush, entretanto o Zephyr Rush pode selecionar o chão, e na verdade só poderia ser possível selecionar um inimigo. E na verdade o Zephyr Rush ta com o mesmo nome do Zephyr Strike. O Zephyr Rush não está podendo selecionar o inimigo com Windswept, mas está podendo selecionar qualquer lugar no chão.

### L1.3 · The Rush only reaches an unmarked enemy within 9 m

- **Rule:** WB5 (range, target)
- **Steps:** Hover Zephyr Rush over a Windswept enemy, then over an unmarked one about 11 m away
- **Expected:** The Windswept enemy can't be targeted. At level 1 the 11 m enemy is out of range (9 m); Zephyr Strike still works on the marked one
- **Fails if:** The Rush can target a Windswept enemy, or reaches beyond 9 m
- **Result:** —

### L1.4 · Damage marks Windswept; a miss doesn't

- **Rule:** WB8, WB49 (P7)
- **Steps:** Hit one enemy with an unarmed attack, another with a card that deals damage, and miss a third
- **Expected:** Both enemies you damaged show Windswept; the missed one doesn't
- **Fails if:** No mark on damage, or a mark on a miss
- **Result:** pass — Funcionou.

### L1.5 · Gale Burst: a failed save marks; no free strike any more

- **Rule:** WB8, WB28
- **Steps:** Cast Gale Burst on an enemy (try until one fails and one succeeds)
- **Expected:** The enemy that fails is pushed, Prone and Windswept; the one that succeeds isn't marked. Gale Burst no longer gives a free unarmed strike, and its tooltip no longer says "Afterwards…"
- **Fails if:** A success marks, a failure doesn't, or the free strike is still there
- **Result:** note — Ai temos uma incoerência. A passiva OpenRoad faz com que sempre que cause dano no inimigo, ele recebe o Windswept. Então mesmo o inimigo tendo sucesso no teste do GaleBurst, ele ainda toma dano, consequentemente recebendo o Windswept.

### L1.6 · A Windswept enemy makes no opportunity attack

- **Rule:** WB10, WB49 (P6)
- **Steps:** Mark the enemy next to your melee ally. On the ally's turn, walk away from it. Do the same next to an unmarked enemy
- **Expected:** The marked enemy doesn't attack; the unmarked one makes its usual opportunity attack
- **Fails if:** The marked enemy attacks, or the unmarked one doesn't
- **Result:** —

### L1.7 · Windswept lasts until the end of your next turn

- **Rule:** WB9 · TC B3
- **Steps:** Mark an enemy on your turn. End the turn; play your next turn and end it
- **Expected:** The mark counts down on your turns only and ends at the end of your next turn
- **Fails if:** It ends on the enemy's turn, after only one of your turns, or lasts longer
- **Result:** —

### L1.8 · Weightless: +3 m

- **Rule:** WB39, WB47
- **Steps:** Compare your movement with and without armour
- **Expected:** Weightless shows in the passives; movement +3 m without armour; no Twinkle Toes
- **Fails if:** No bonus, the wrong bonus, or Twinkle Toes still there
- **Result:** —

### L1.9 · Armour or a shield turns everything off

- **Rule:** WB3 · TC B10
- **Steps:** Put on armour (then a shield instead). Hit an enemy with an unarmed attack; look at AC and movement
- **Expected:** No mark, no Zephyr Strike or Rush, no Weightless bonus, no Be the Leaf. Take it off and they come back
- **Fails if:** Any of them works in armour or with a shield
- **Result:** —

### L1.10 · The Open Road and the cards read right

- **Rule:** WB27
- **Steps:** Read the tooltips of The Open Road, Windswept, Zephyr Strike, Zephyr Rush and Gale Burst
- **Expected:** The Open Road explains Windswept, the Open Path and Zephyr; no card says "Afterwards"; no id or raw handle shows
- **Fails if:** An old text, a raw handle or an id
- **Kind:** observe
- **Result:** —

### L1.11 · PC edition: the deck conjures Zephyr Rush

- **Rule:** WB5 (PC edition)
- **Steps:** On the PC edition (Script Extender on), make an unarmed attack in combat
- **Expected:** Zephyr Strike and Zephyr Rush are conjured to the hand for the turn
- **Fails if:** Only Zephyr Strike, or neither
- **Edition:** PC
- **Result:** —

## Level 2 — Aeolus' Bag

**Setup:** Level 2, a fight with at least four enemies; mark several before opening the bag.

### L2.1 · The bag needs a Windswept enemy

- **Rule:** WB11, WB13
- **Steps:** Look at Aeolus' Bag before marking anyone, then after marking one enemy
- **Expected:** Greyed out with no Windswept enemy; usable (bonus action) once one is marked. It offers Boreas and Notus
- **Fails if:** Usable with no mark, or still greyed with a mark
- **Result:** —

### L2.2 · Opening: X = marks, capped at 2; every mark is cleared

- **Rule:** WB13, WB14 · TC B4
- **Steps:** Mark 3 enemies. Open the bag with Boreas
- **Expected:** Every mark is cleared. "The bag is open" shows 2 turns (3 marks, capped at 2 at Breeze). The bag stays shut while the wind blows
- **Fails if:** The marks stay, the number isn't the capped count, or the bag can open again
- **Result:** —

### L2.3 · Boreas: allies +3 m, Windswept enemies −3 m

- **Rule:** WB12 (Boreas)
- **Steps:** With Boreas blowing, mark an enemy; compare an ally's and that enemy's movement
- **Expected:** Allies get a tailwind (+3 m); Windswept enemies a headwind (−3 m); unmarked enemies nothing
- **Fails if:** Wrong amounts, or unmarked enemies affected
- **Result:** —

### L2.4 · Notus: ranged attacks against allies at Disadvantage; Windswept enemies −1 to saves

- **Rule:** WB12 (Notus)
- **Steps:** Open the bag with Notus; let an enemy shoot an ally; make a Windswept enemy roll a save
- **Expected:** The ranged attack has Disadvantage; the Windswept enemy's save shows −1
- **Fails if:** No Disadvantage, or no penalty
- **Result:** —

### L2.5 · While the wind blows, your turn starts with a sweep

- **Rule:** WB14 (the sweep) · TC B5
- **Steps:** With a wind blowing, mark two enemies; end your turn; start the next one
- **Expected:** At your turn start every mark is cleared; the turns of "the bag is open" go down by one at each of your turn ends; at 0 the wind stops and the bag can open again
- **Fails if:** The marks stay, the count is wrong, or the wind never stops
- **Result:** —

### L2.6 · PC edition: the bag is conjured once you have a mark

- **Rule:** WB11 (PC edition)
- **Steps:** On the PC edition, mark an enemy in combat
- **Expected:** Aeolus' Bag appears in the hand (0 Threads) with its winds
- **Fails if:** No bag in the hand
- **Edition:** PC
- **Result:** —

## Level 3 — The First Step, The Calm, Wind Blast

**Setup:** Level 3, a fight with at least four enemies.

### L3.1 · Tier I wakes after 3 marks are released

- **Rule:** WB22, WB23 · TC C5
- **Steps:** Mark 3 enemies and release them (open the bag, or let a sweep take them). Watch the Awakening status
- **Expected:** The Awakening status counts "Windswept marks left to release to awaken The First Step" down from 3; at 0 The First Step wakes
- **Fails if:** Another count, the old Wanderlust text, or no tier
- **Result:** —

### L3.2 · The First Step: the first Rush each turn is free

- **Rule:** WB22 (The First Step)
- **Steps:** With The First Step awake, use Zephyr Rush twice on two turns (after an unarmed attack each time)
- **Expected:** The first Rush each turn costs no bonus action; a second Zephyr that turn costs it
- **Fails if:** Every Rush is free, or none
- **Result:** —

### L3.3 · The Calm: only while a wind blows; the turns left become gusts

- **Rule:** WB25, WB48 · TC B6
- **Steps:** Look at The Calm with no wind; open the bag (2+ turns), mark enemies, cast The Calm
- **Expected:** Greyed with no wind. Cast: the wind stops at once, each Windswept enemy takes 1d8 Thunder per turn left, every mark is swept, and the bag can open again the same turn
- **Fails if:** Usable without wind, wrong damage, or the bag stays shut
- **Result:** —

### L3.4 · Wind Blast marks those who fail

- **Rule:** WB8 (Wind Blast)
- **Steps:** Cast Wind Blast on a group
- **Expected:** Each creature that fails is pushed, Off Balance and Windswept; one that succeeds isn't marked; no "Afterwards…" in the text
- **Fails if:** A success marks, a failure doesn't
- **Result:** —

### L3.5 · Flow State and Gale Deflection are no longer at level 3

- **Rule:** WB43 (level map)
- **Steps:** Look at the level-3 spells and resources
- **Expected:** Level 3 adds Wind Blast and The Calm (Aspect card); Flow State, Gale Deflection and its resources come at level 6; no Twinkle Toes
- **Fails if:** Flow State or Gale Deflection still at 3
- **Kind:** observe
- **Result:** —

## Level 4 — Gale

**Setup:** Level 4, a fight with at least four enemies.

### L4.1 · Zephyr pushes 3 m; the Rush reaches 12 m

- **Rule:** WB16, WB17 (Gale)
- **Steps:** Zephyr Strike a Windswept enemy; Zephyr Rush an unmarked one about 11 m away
- **Expected:** Both push the target 3 m. The Rush now reaches 12 m. The Gale passive shows
- **Fails if:** No push, the wrong distance, or still 9 m
- **Result:** —

### L4.2 · Eurus joins the bag; the cap is 3

- **Rule:** WB12 (Eurus), WB13
- **Steps:** Mark 4 enemies; open the bag with Eurus; an ally attacks; a Windswept enemy attacks
- **Expected:** The bag offers Eurus. "The bag is open" shows 3 turns. Allies +1 to attack rolls; Windswept enemies −1
- **Fails if:** No Eurus, the wrong cap, or wrong bonuses
- **Result:** —

### L4.3 · Weightless rank 2

- **Rule:** WB47 (Weightless 2)
- **Steps:** Check movement, jump distance and falling damage
- **Expected:** +4.5 m movement, jump ×2, half falling damage (rank 1 gone)
- **Fails if:** Rank 1 still there, or wrong values
- **Result:** —

## Level 5 — Flowing Assault, Wind Whispers

**Setup:** Level 5, any fight.

### L5.1 · Wind Whispers also gives the Advantage Evasive Flow gave

- **Rule:** WB33 (Wind Whispers)
- **Steps:** Cast Wind Whispers, then attack
- **Expected:** Wind Whispers' own effect plus the opening Advantage (the status Evasive Flow used to give)
- **Fails if:** No Advantage
- **Result:** —

### L5.2 · Flowing Assault and the level-5 texts

- **Rule:** WB43
- **Steps:** Read Flowing Assault and Wind Whispers; check the passives
- **Expected:** Flowing Assault works as before; no Twinkle Toes or Feather Fall at level 5 (Weightless rank 2 stays)
- **Fails if:** Twinkle Toes or the old Weightless 5 present
- **Kind:** observe
- **Result:** —

## Level 6 — Flow State, Ready: Gale Deflection

**Setup:** Level 6, a fight with a ranged enemy and an ally within 3 m of you.

### L6.1 · Flow State: 3 turns and one extra bonus action, at every slot

- **Rule:** WB31 (Flow State)
- **Steps:** Cast Flow State at its base slot, then at a higher slot (another fight)
- **Expected:** 3 turns at every slot, one extra bonus action each turn
- **Fails if:** Duration grows with the slot, or no extra bonus action
- **Result:** —

### L6.2 · Gale Deflection also protects an ally within 3 m

- **Rule:** WB32 (Gale Deflection)
- **Steps:** Let a ranged enemy shoot you, then an ally 2 m from you, then one 5 m away
- **Expected:** You can react for yourself and for the ally within 3 m; not for the one 5 m away. Its id doesn't show in the combat log
- **Fails if:** No reaction for the near ally, a reaction for the far one, or an id in the log
- **Result:** —

## Level 7 — Fellow Travellers, Storm Fists

**Setup:** Level 7, a fight with allies attacking enemies.

### L7.1 · Fellow Travellers: an ally's hit marks the enemy in your name

- **Rule:** WB22 (Tier II) · TC B9
- **Steps:** With Tier II awake (goal 5), let an ally hit an unmarked enemy
- **Expected:** The enemy becomes Windswept (your mark: it counts for your bag and Awakening and lasts 2 of your turns)
- **Fails if:** No mark, or the mark doesn't count for you
- **Result:** —

### L7.2 · Tier II needs 5 released marks

- **Rule:** WB23 (goals 3/5/8)
- **Steps:** Release marks after Tier I and watch the Awakening status
- **Expected:** It counts down to Fellow Travellers from 5
- **Fails if:** Another number
- **Result:** —

### L7.3 · Storm Fists: extra damage only against enemies that aren't Windswept; 3 turns

- **Rule:** WB34 (Storm Fists)
- **Steps:** Cast Storm Fists; punch an unmarked enemy, then a Windswept one
- **Expected:** Extra Thunder damage on the unmarked enemy only; 3 turns at every slot
- **Fails if:** Extra damage on the Windswept enemy, or a different duration
- **Result:** —

## Level 8 — Storm

**Setup:** Level 8, a fight with at least five enemies.

### L8.1 · Storm: after a Rush that deals damage, one more free Rush

- **Rule:** WB16 (Storm) · TC C3
- **Steps:** Zephyr Rush an unmarked enemy and hit it; look at the bonus actions; Rush again to another unmarked enemy within 9 m
- **Expected:** A second Rush appears for this turn (free, 9 m, only an unmarked enemy) and goes once used; a missed Rush gives none
- **Fails if:** No second Rush, it costs an action, it stays, or a miss grants it
- **Result:** —

### L8.2 · The cap is 4; Weightless rank 3

- **Rule:** WB13 (cap 4), WB47
- **Steps:** Mark 5 enemies and open the bag; check movement and jump
- **Expected:** "The bag is open" shows 4 turns; +6 m movement, jump ×3, half falling damage
- **Fails if:** Another cap or wrong values
- **Result:** —

## Level 9 — Untethered, Empty State

**Setup:** Level 9, any fight.

### L9.1 · Untethered: flying gives +2 AC

- **Rule:** WB35 (Untethered)
- **Steps:** Cast Untethered; compare AC before and after
- **Expected:** +2 AC while flying; Eye of the Storm no longer shows anywhere
- **Fails if:** No AC, or Eye of the Storm still there
- **Result:** —

### L9.2 · Empty State arrives at 9; Evasive Flow is gone

- **Rule:** WB43, WB36
- **Steps:** Look at the level-9 passives and spells
- **Expected:** Empty State at level 9 (not 12); Untethered in the spells; no Evasive Flow
- **Fails if:** Empty State missing or Evasive Flow still in the list
- **Kind:** observe
- **Result:** —

## Level 10 — Leap of Faith

**Setup:** Level 10, enemies standing in a line.

### L10.1 · Leap of Faith: a card, once per Short Rest, on the Force Tunnel dash

- **Rule:** WB7, WB38 (P5)
- **Steps:** Cast Leap of Faith through a line of enemies; try it again before a Short Rest
- **Expected:** The Force Tunnel dash, striking each enemy in the path and marking them; no slot spent; once per Short Rest. After it (a card) you get Zephyr
- **Fails if:** No dash animation, a slot spent, usable again before a rest, or no Zephyr after it
- **Result:** —

## Level 11 — Where the Winds Meet

**Setup:** Level 11, a fight with several enemies, some Windswept.

### L11.1 · Aimed at the ground; refused while a wind blows

- **Rule:** WB26, WB50
- **Steps:** Open the bag, try the capstone; when the wind ends, aim it at an empty spot of ground within 18 m
- **Expected:** Greyed while a wind blows. Without wind it targets a point on the ground (no enemy under the cursor needed)
- **Fails if:** Usable with a wind, or it needs a creature as the target
- **Result:** —

### L11.2 · The pull: 9 m area, Windswept pulled 9 m, others 6 m — to the point

- **Rule:** WB46, WB49 · TC B7
- **Steps:** With one Windswept enemy and one unmarked enemy each about 8 m from the point, cast it
- **Expected:** Both are pulled toward the point (not toward you): the Windswept one reaches it, the other stops about 2 m short. Both take 4d8 Thunder (half on a DEX save), are Off Balance and become Windswept. Once per Long Rest
- **Fails if:** The pull goes toward you (plan B: a pulling explosion at the point), wrong distances, or no mark
- **Plan B:** GROUND:CreateExplosion of a pulling explosion at the point
- **Result:** —

### L11.3 · Thunderclap and Momentum are gone

- **Rule:** WB37, WB34
- **Steps:** Look at the level-11 spells and passives
- **Expected:** Where the Winds Meet replaces Thunderclap; no Momentum
- **Fails if:** Thunderclap or Momentum still there
- **Kind:** observe
- **Result:** —

## Level 12 — Into the Storm, Hurricane

**Setup:** Level 12, a fight with at least five enemies.

### L12.1 · Into the Storm: each sweep pushes the swept enemies 3 m

- **Rule:** WB22 (Tier III, P9) · TC B9
- **Steps:** Wake Tier III (goal 8); let a sweep release marks
- **Expected:** Every swept enemy is pushed 3 m away from you and is Off Balance — the sweep that wakes the tier included
- **Fails if:** No push, the wrong direction, or the waking sweep doesn't push
- **Result:** —

### L12.2 · Hurricane: the bag offers two winds at once; the cap is 5

- **Rule:** WB15 (Hurricane), WB13
- **Steps:** Mark 6 enemies and open the bag
- **Expected:** The bag offers the pairs (Boreas + Notus, Boreas + Eurus, Notus + Eurus) instead of single winds; both winds blow; "the bag is open" shows 5 turns
- **Fails if:** Single winds still offered, only one wind blows, or another cap
- **Result:** —

### L12.3 · Weightless rank 4

- **Rule:** WB47 (Weightless 4)
- **Steps:** Check movement, jump and a long fall
- **Expected:** +9 m movement, jump ×4, no falling damage
- **Fails if:** Wrong values
- **Result:** —

### L12.4 · No old tier bonuses; no Fool's Luck; nothing after 12

- **Rule:** WB24, WB43
- **Steps:** Look at the tier passives and resources; level to 13 if you can
- **Expected:** No ability bonus from the tiers, no Fool's Luck reaction or resource; levels 13–20 add no Twinkle Toes
- **Fails if:** An old tier bonus or Fool's Luck still there
- **Kind:** observe
- **Result:** —

## Any level — full run

**Setup:** A full fight at levels 3, 8 and 12 (TC part C), after all levels are typed.

### A.1 · How the fights play

- **Rule:** C1 · TC C1, C2
- **Steps:** Play a few fights at levels 3, 5–8 and 12 and note the turns
- **Expected:** A Rush most turns; the bag by turn 2–3; every wind chosen in some fights (none above about 60%)
- **Fails if:** A turn every time without a choice, no bag, or one wind always
- **Kind:** observe
- **Result:** —

### A.2 · Power and tiers against the Monk

- **Rule:** C2 · TC C4, C5
- **Steps:** At level 12 compare your damage per turn with a Monk's; note the turn each tier wakes at 3, 7 and 12
- **Expected:** Damage within about ±15% of the Monk; each tier wakes on turn 2–3
- **Fails if:** More than 15% over, or a tier after turn 4
- **Kind:** observe
- **Result:** —

## Appendix — TC_ARC-0022 (design-stage draft, verbatim)

Header of the original file:

```
id: 61.02/Unbound/TC_ARC-0022
owner: QA Lead
source: 21.04/Unbound/DECISIONS.md WB0–WB48 · DESIGN.md §13, §15 · 22.05/Unbound.md (V1–V5)
reviewed: 2026-10-17 ARC-0022 — created (propagation, 00.08); 2026-10-17 ARC-0026 — stage 1 probes applied (probes castable), no change; 2026-10-17 ARC-0026 — P8 fix applied, no change; 2026-10-17 ARC-0026 — stage 1 complete, WB50 checked, no change; 2026-10-17 ARC-0026 — the build tests are in GUIDE_ARC-0026.json level by level; this file stays the design test list; retired entries kept (OR-10); 2026-10-18 ARC-0026 — WB51 (rebuild from zero, OR-59 ids) checked, no change
status: planned — part A (probes) runs first in the build ticket; parts B and C after the build
```

> **Superseded by `GUIDE_ARC-0026.json (QA-0005)`** (OR-4, 2026-10-17): the in-game tests live in the guide; this file is kept as the design-stage record.

### TC_ARC-0022 · The Windborn — the Open Road build

**Decision it informs:** close the Windborn build, or send a failing rule back to the Lead Class Designer.
**Scenario:** console edition (no SE), a Windborn built through the real progression, the standard saves of `83.02`;
the PC (SE) edition where marked. Compile the Story after any apply. Values: `25` (`*_Unbound_*`).

#### A · Probes (one rule each — they decide the spec)

| # | Rule | Expected | Plan B if not |
|---|---|---|---|
| A1 | A Rush (`Rush_SpringAttack`) provokes no opportunity attack and paths around obstacles | She arrives and strikes; no OA on the way | Teleport + strike (Misty-Step pattern) |
| A2 | A target condition on Windswept splits Zephyr into Rush / plain strike | Unmarked → Rush; marked → plain strike | Two created cards, shown by the target state |
| A3 | The turn-start hook used by the sweep | The sweep runs at the start of her turn only while the wind status is on her | Tick the wind status on her turn and sweep on its tick |
| A4 | `Projectile_VacuumBulb` pull to a point | Enemies within 6 m pulled to the point; Windswept from 9 m | Two explosions (6 m all, 9 m Windswept only) |
| A5 | Leap of Faith on the `Rush_ForceTunnel` animation | The dash-through animation plays with wind VFX | Keep `Rush_SpringAttack` |

#### B · Rules of the build (one rule per test)

| # | Rule | Expected |
|---|---|---|
| B1 | Windswept from a hit; from a failed save on each card; from Riposte and Gale Deflection | Each marks; a success on a save doesn't |
| B2 | The Open Path | A Windswept enemy makes no opportunity attack on an ally |
| B3 | Duration | A mark lasts until the end of her next turn, outside a wind |
| B4 | The bag: needs a mark; X = marks, capped by rank; opening clears; shut while the wind blows | As stated; the "bag is open" status shows the turns |
| B5 | The sweep | At her turn start, wind blowing: every mark cleared, each counted |
| B6 | The Calm | Only with a wind; gusts = remaining turns on each Windswept enemy; the bag can open the same turn |
| B7 | Where the Winds Meet | Refused while a wind blows; pull, Off Balance, mark, 4d8 Thunder (DEX half) |
| B8 | Ranks | Gale push 3 m and Eurus at 4; Storm second Rush at 8 (only after an unmarked target); Hurricane two winds at 12 |
| B9 | Tiers | I: first Rush each turn free · II: an ally's hit marks · III: each sweep pushes 3 m + Off Balance, the waking sweep included |
| B10 | Armour or a shield | Every Windborn passive, card and status stops |
| B11 | The level map | `dump_progression.pl` matches DESIGN §9.1 (ranks at 4 and 8, WB16) |
| B12 | Names (WB44) | Every name of `32.01/Unbound.md` "after the build"; no Twinkle Toes, Feather Fall, Thunderclap, Evasive Flow, Momentum, Eye of the Storm in a tooltip |

#### C · Balance (from `22.05` V1–V5)

| # | Fight | Metric | Right if | Wrong if |
|---|---|---|---|---|
| C1 | Level 3, 4 enemies | Rushes; bag opening turn | A Rush most turns; bag by turn 2–3 | Every turn without choice, or no bag |
| C2 | Levels 5–8, a day | Wind chosen | Each wind in some fights | One wind > 60% |
| C3 | Level 8, 5+ enemies | Storm second Rushes | 1–2 per fight | Every turn |
| C4 | Level 12 | Damage per turn vs the Monk | Within ±15% | > 15% over |
| C5 | Levels 3, 7, 12 | Turn each tier wakes | Turn 2–3 | After turn 4 |

**Qualitative (after each session):** What did you want to do that you couldn't? When did you feel strongest? Which wind
did you open, and why? What would you call the Windborn's signature?

## Gates

- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)

## Log

- 2026-10-17 — QA_ARC created (ARC-0027, Owner: one QA file per playtest): sources QA-0004, QA-0005, GUIDE_ARC-0026_probes, GUIDE_ARC-0026, TC_ARC-0022 merged; nothing removed.
