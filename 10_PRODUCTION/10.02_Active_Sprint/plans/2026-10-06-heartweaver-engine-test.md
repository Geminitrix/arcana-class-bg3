# Heartweaver — in-game engine test

Guide for the first test of Emotional Alchemy (spec `specs/2026-10-06-heartweaver-design.md`, plan
`plans/2026-10-06-heartweaver-1-engine.md`). The subclass does not exist yet: everything comes from the
**Arcana Deck DEBUG** list, which every Arcana has at level 1. Each row says what to do, what should happen
and which spec risk (§11) it answers. Note the row number and what you saw whenever something is off.

Test it the way the **console edition** plays: no Script Extender is needed for any of this.

## 0. Before playing

1. **Toolkit → Reload Stats.** Open one Surge in the Stats editor and check its `SpellSuccess` is not cut
   short (it is long: 11 functors). If the editor truncates it, note it — risk **R4**. Also check that
   `EMOTION_TERROR` shows under FEAR and `EMOTION_AMAZEMENT`, `EMOTION_GRIEF`, `FEELING_AWE` under
   INCAPACITATED.
2. The game (or the Toolkit's play mode — the engine does not use SE). An Arcana of any level, 2 allies and a
   group of humanoid enemies (Intelligence above 4). Use `DEBUG_INFINITE_SPELLS` if you need slots.
3. **Without** the `[DEBUG] Heartweaver Passives` yet: only primary feelings and Catharsis are unlocked.

## 1. Peaks and moods

| # | Do | Should happen | Risk |
|---|---|---|---|
| 1.1 | Weave Surge: **Fear** on an enemy; it fails the save | Log: it gains **Emotion: Fear**; it can't move on its turn | — |
| 1.2 | Let the enemy's turn end | **Emotion: Fear** ends and **Mood: Apprehensive** starts (5 turns), with no extra removed/applied lines | — |
| 1.3 | Surge: **Joy** on an ally | No save. **Emotion: Joy** (Advantage on attacks); at the end of its turn, **Mood: Serene** | — |
| 1.4 | Surge: **Joy** on an enemy with **no** mood | Can't target it | — |
| 1.5 | Surge: **Fear** on an ally with **no** mood | Can't target it | — |
| 1.6 | An enemy under **Emotion: Fear** → Surge: **Surprise** on it before its turn (it fails the save) | **Emotion: Surprise** replaces Fear, and Fear leaves **no** Apprehensive behind (only a peak that runs out leaves its mood) | D10 |

## 2. Reactions unlocked from the start

| # | Do | Should happen | Risk |
|---|---|---|---|
| 2.1 | **Apprehensive** enemy (from 1.2) → Surge: **Trust** on it; it **fails the Wisdom save** (an enemy rolls even against a bright Surge) | It becomes **Feeling: Submission** (2 turns): falls Prone and can't attack you. It does **not** also gain Emotion: Trust. Apprehensive ends. If it passes, nothing happens and Apprehensive stays - note whether it rolled at all | **R1**, R2 |
| 2.2 | **Distracted** enemy (Surprise, wait a turn) → Surge: **Fear**, it fails | **Feeling: Awe**: Incapacitated until it takes damage; hit it and Awe ends | R1 |
| 2.3 | **Annoyed** enemy (Anger, wait a turn) → Surge: **Fear**, it fails | **Catharsis**: 2d8 Psychic, Annoyed ends, it does **not** gain Emotion: Fear | R1 |
| 2.4 | **Serene** ally (from 1.3) → Surge: **Sadness** on it | You can target it. **No save** (ally). Catharsis: **regains 2d8**, Serene ends. Note any 'hostile act' warning or reaction from your companions (Sadness is flagged as harmful) | **R2** |
| 2.5 | **Serene** ally → Surge: **Trust** on it | **Feeling: Love**: +1 AC and saves, resistance; when it takes damage, so do you | — |
| 2.6 | **Apprehensive** enemy → Surge: **Sadness** (distance 2, locked) | Without the passive: only **Emotion: Sadness**, no Despair | gate |

## 3. Locked rings

Now cast **[DEBUG] Heartweaver Passives** on yourself (it grants the 5 passives until a long rest).

| # | Do | Should happen | Risk |
|---|---|---|---|
| 3.1 | Repeat 2.6 | Now it becomes **Feeling: Despair** (−1d4 to attacks and saves) | — |
| 3.2 | **Apprehensive** enemy → Surge: **Fear** | **Emotion: Terror** (1 turn): it **flees** like under the Fear spell, with no save to break it early. When it ends: back to **Apprehensive** | **R9** |
| 3.3 | **Distracted** enemy → Surge: **Surprise** | **Emotion: Amazement**: Stunned for 1 turn; its Concentration breaks | R9 |
| 3.4 | **Pensive** enemy → Surge: **Sadness** | **Emotion: Grief**: Incapacitated, can't move, 1 turn; then back to **Pensive** | R9 |
| 3.5 | An enemy under **Terror**, **Amazement** or **Grief** (or any peak) → a different Surge on it before its turn | One emotion at a time: the new one **replaces** the old (shared `StackId EMOTION`, D14), so only one mood comes out. If **both** show on the portrait, note it | **R9** |
| 3.6 | **Interested** ally (Anticipation) → Surge: **Anticipation** | **Emotion: Vigilance** (+2 reactions) | — |
| 3.7 | **Bored** enemy (Disgust) → Surge: **Fear** (distance 3) | **Feeling: Shame** | — |
| 3.8 | **Serene** ally → Surge: **Surprise** (Joy+Surprise, distance 3) | **Feeling: Delight**: heals 1d6 at the end of each turn | R2 |
| 3.9 | An enemy with **Disapproval** (Surprise on Pensive) next to 2 of its allies | Its allies within 3 m gain **Disapproved** (Disadvantage on attacks) | **R6** |
| 3.10 | An enemy with **Remorse** (Sadness on Bored) attacks and hits | It takes 1d6 Psychic **once** per turn; no endless loop | **R5** |
| 3.11 | **Serene** ally → Surge: **Disgust** on it (Joy+Disgust, distance 3) → **Feeling: Morbidness**; it hits with a weapon | Regains 1d6, once per turn | R5 |
| 3.12 | An enemy with **Contempt** (Disgust on Annoyed) → hit it with Psychic damage (e.g. Malicious Whispers) | Double damage (vulnerable to Psychic) | — |

## 4. Upcast and reading

| # | Do | Should happen |
|---|---|---|
| 4.1 | A Surge with a level-3 slot | Up to **3** targets |
| 4.2 | Read the tooltip of a Surge and of the **Emotional Alchemy** passive | The links (LSTag) to the mood, Catharsis and Love open; no stray `[1]` |
| 4.3 | Read the combat log of 2.1–2.4 | One line per thing that happened. Note any odd line |

## What to send back

For each row that failed: the number, what showed in the log and on the portrait. Above all:
**R1** (2.1–2.3: did the peak land together with the reaction?), **R2** (2.4: did the ally roll a save?),
**R4** (0.1), **R5** (3.10–3.11), **R6** (3.9) and **R9** (3.2–3.5). Plan 2 is written from these answers.
