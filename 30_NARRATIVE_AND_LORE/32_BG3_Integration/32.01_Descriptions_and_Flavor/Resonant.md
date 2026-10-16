---
id: 32.01/Resonant
owner: Lore Writer
source: game loca (51 Mods/…/Localization/English/english.xml) + Stats ids, extracted 2026-10-15; 21.04/Resonant/DESIGN.md §12
reviewed: 2026-10-16 ARC-0014 — texts the R49–R68 build needs (drafts) added at the end; 2026-10-16 ARC-0021 — display name *Heartsong* (R69)
---

# 32.01 · Player-facing text — The Heartsong (internal: Resonant)

Every name and description the player reads, **as it is in the game today** (English; `[n]` are the game's
parameters, numbers come from `25`). The 15 other languages do not have these strings yet (Localization).
Polishing the English waits for the end of the rework (Owner, ARC-0006); the moulds are in `DESIGN.md` §12.

## Review notes (Lore Writer, 2026-10-15)

| Text | Issue | Fix (needs a ticket — game text) |
|---|---|---|
| Emotional Contagion — description | Says *every creature* within range catches the mood; since R35 only **the target's allies** do | "…every ally of it within [1] catches the same mood…" |
| Emotional Overload — description | Says *everything you have felt this fight*; the meter carries over between fights (R31) | "Pour everything you have felt into one creature…" |
| Narrative gate | No approval recorded in `32.04` for these texts (they shipped with ARC-0002 before the gate existed) | Record the approval when the English pass runs |

## Spells and cards

| Internal id | Name | Description |
|---|---|---|
| `Shout_Arcana_Card_Passive_Compassion` | Ready: Compassion | Until the end of the fight, when an ally within [1] takes damage, you can use your reaction to cast Weave Surge: Trust on it. |
| `Shout_Arcana_Card_Spell_SharedHeart` | Shared Heart | Bind your heart to your allies' until the end of the fight. You and every ally within [1] are linked: a feeling braided in one linked creature is braided in all of them, and a Catharsis on one heals them all. |
| `Shout_Arcana_Created_Aspect_TwoCups` | The Two Cups | Pour one cup into the other. Every creature within [3] that carries a mood undergoes Catharsis at once: an enemy takes [1] and 1d8 more, an ally regains [2] and 1d8 more. Their moods are spent. |
| `Target_Arcana_Card_Spell_EmotionalContagion` | Emotional Contagion | Let the mood of a creature spill over: every creature within [1] of it catches the same mood, and catches it again each turn. No saving throw. |
| `Target_Arcana_Card_Spell_Heartstring` | Heartstring | Pluck the string a creature's heart hangs from. It takes [1], and a mood it carries lasts 2 turns longer. |
| `Target_Arcana_Card_Spell_Temper` | Temper | Pull a creature's mood back to the emotion it came from. It feels that emotion again for 1 turn, and when it fades the mood returns for 5 turns. A creature that is not your ally can resist with a Wisdom Saving Throw. |
| `Target_Arcana_Created_EmotionalOverload` | Emotional Overload | Pour everything you have felt this fight into one creature. Every feeling it carries tears at it for [1] Psychic damage and is spent, and it is Paralysed for 2 turns. No saving throw. |
| `Target_Arcana_Card_Spell_EmotionFear` | Weave Surge: Fear | Wrap a creature in a cold thread of fear. The target can't move and has Disadvantage on Ability Checks and Attack Rolls.When the surge fades, it leaves the target Apprehensive for 5 turns, subtracting 1d4 from its Wisdom Saving Throws. |
| `Target_Arcana_Card_Spell_EmotionJoy` | Weave Surge: Joy | Pluck a bright thread of joy in an ally's Weave. The target's joy is contagious: it and allies near it have Advantage on their next attack.When the surge fades, it leaves the target Serene for 5 turns, with Advantage on Wisdom Saving Throws. |
| `Target_Arcana_Card_Spell_EmotionTrust` | Weave Surge: Trust | Steady an ally with a thread of trust. The target stands shoulder to shoulder with its allies, sharing the blows meant for them.When the surge fades, it leaves the target Accepting for 5 turns, with a +1 bonus to Armour Class. |
| `Target_Arcana_Card_Spell_EmotionAnticipation` | Weave Surge: Anticipation | Pull a taut thread of anticipation through an ally's Weave. The target stands on guard and strikes the first enemy that comes within reach.When the surge fades, it leaves the target Interested for 5 turns, with its movement speed increased by [1]. |
| `Target_Arcana_Card_Spell_EmotionSadness` | Weave Surge: Sadness | Weigh a creature down with a grey thread of sorrow. The target lets go of what it holds: it loses Concentration and its bonus action.When the surge fades, it leaves the target Pensive for 5 turns, with its movement speed reduced by [1]. |
| `Target_Arcana_Card_Spell_EmotionSurprise` | Weave Surge: Surprise | Snap a thread of surprise before a creature's eyes. The target is caught off guard: it loses its reaction, and the next attack against it has Advantage.When the surge fades, it leaves the target Distracted for 5 turns, with Disadvantage on Saving Throws to maintain Concentration. |
| `Target_Arcana_Card_Spell_EmotionAnger` | Weave Surge: Anger | Set a red thread of fury alight in a creature's mind. The target bears a grudge: it attacks the last creature that hurt it, or the nearest one if nobody has.When the surge fades, it leaves the target Annoyed for 5 turns, with its Armour Class reduced by 1. |
| `Target_Arcana_Card_Spell_EmotionDisgust` | Weave Surge: Disgust | Twist a creature's Weave into revulsion. The target can't take actions and has Disadvantage on Constitution Saving Throws.When the surge fades, it leaves the target Bored for 5 turns, unable to take reactions. |

## Passives

| Internal id | Name | Description |
|---|---|---|
| `Arcana_Passive_EmotionalAlchemy` | Emotional Alchemy | When your Weave Surge touches a creature that already carries a mood, the threads react instead of surging, and the mood is spent.Neighbouring emotions braid into a feeling, such as Love, that lasts 2 turns.Opposing emotions snap into Catharsis: an enemy takes [1] and an ally regains [2].When your Weave Surge causes a reaction, you regain the spell slot it used. Once per turn. |
| `Arcana_Passive_EmpathicSight` | Empathic Sight | You read the threads of feeling in others. You have Advantage on Insight checks. |
| `Arcana_Passive_Overload` | Overload | You feel what you make others feel. Each emotion that takes hold fills your Overload a little, and each reaction fills it more; it carries over from one fight to the next. At 100% you become Overloaded: you can't cast spells, your weapon attacks deal extra Psychic damage, and you take Psychic damage each turn, for a number of turns equal to your level. From level 5, Emotional Overload ends it at once. |
| `Arcana_Passive_ComplexFeelings` | Complex Feelings | Emotions two steps apart on the wheel now braid into complex feelings, such as Hope or Despair. |
| `Arcana_Passive_Overwhelm` | Overwhelm | A Weave Surge on a creature whose mood echoes the same emotion pulls the thread tight into its overwhelming form, such as Ecstasy or Terror. |
| `Arcana_Passive_MixedFeelings` | Mixed Feelings | Emotions three steps apart on the wheel now braid into mixed feelings, such as Delight or Shame. |
| `Arcana_Passive_Aspect_Temperance_Awakening` | 14 - Temperance: Awakening | Cause reactions during a fight to awaken the Aspect of Empathy until combat ends. Every feeling you braid, every emotion you intensify and every Catharsis counts. Each goal you reach awakens one more tier.Level 3: cause 3 reactions to gain Resonance.Level 7: cause 6 reactions to also gain Harmony.Level 12: cause 15 reactions to awaken as the Aspect of Empathy.The Awakening status shows how much is left to the next tier. |
| `Arcana_Passive_Aspect_Temperance_I` | Resonance | Catharsis deals or restores an extra 1d8, and the moods you create last 2 turns longer. |
| `Arcana_Passive_Aspect_Temperance_II` | Harmony | Feelings you braid last 2 turns longer. Once per turn, a Weave Surge costs no action, and the emotion it leaves brings its mood at once. |
| `Arcana_Passive_Aspect_Temperance_III` | Aspect of Empathy | Emotional Overload also reaches every enemy within [1] of the target that carries a feeling: it loses its feelings and is Paralysed for 1 turn. |

## Statuses

| Internal id | Name | Description |
|---|---|---|
| `RESONANT_CONTAGION` | Emotional Contagion | Its mood spills over: every creature within [1] catches it, again each turn. |
| `RESONANT_JOY_CONTAGION` | Contagious Joy | Has Advantage on the next attack. |
| `RESONANT_SURGE_FREE` | Harmony | Your next Weave Surge this turn costs no action, and the emotion it leaves brings its mood at once. |
| `RESONANT_SURPRISE_OPENING` | Off Guard | The next attack against it has Advantage. |
| `RESONANT_TIER2` | Harmony |  |
| `RESONANT_TRUST_SHOULDERED` | Shouldered | Resistant to the blow an ally is sharing with it. |
| `CATHARSIS` | Catharsis | Opposing emotions, snapped at once. Every mood is spent. |
| `EMOTION_FEAR` | Emotion: Fear | Surging with Fear. Frozen with fear: can't move. Has Disadvantage on Ability Checks and Attack Rolls. |
| `FEELING_ANXIETY` | Feeling: Anxiety | Fear and Anticipation, braided together. Loses Concentration. Can't take reactions and has Disadvantage on Saving Throws to maintain Concentration. |
| `FEELING_DESPAIR` | Feeling: Despair | Fear and Sadness, braided together. Subtracts 1d4 from Attack Rolls and Saving Throws. |
| `FEELING_GUILT` | Feeling: Guilt | Joy and Fear, braided together. Can't take bonus actions. Has Disadvantage on Wisdom Saving Throws. |
| `FEELING_SHAME` | Feeling: Shame | Fear and Disgust, braided together. Can't take reactions. Has Disadvantage on Attack Rolls. |
| `FEELING_SUBMISSION` | Feeling: Submission | Trust and Fear, braided together. Knocked Prone and can't harm the spellcaster. |
| `MOOD_ACCEPTING` | Mood: Accepting | The fading echo of Trust. Armour Class increased by 1. |
| `MOOD_ANNOYED` | Mood: Annoyed | The fading echo of Anger. Armour Class reduced by 1. |
| `MOOD_APPREHENSIVE` | Mood: Apprehensive | The fading echo of Fear. Subtracts 1d4 from Wisdom Saving Throws. |
| `MOOD_BORED` | Mood: Bored | The fading echo of Disgust. Can't take reactions. |
| `MOOD_DISTRACTED` | Mood: Distracted | The fading echo of Surprise. Has Disadvantage on Saving Throws to maintain Concentration. |
| `MOOD_INTERESTED` | Mood: Interested | The fading echo of Anticipation. Movement speed increased by [1]. |
| `MOOD_PENSIVE` | Mood: Pensive | The fading echo of Sadness. Movement speed reduced by [1]. |
| `MOOD_SERENE` | Mood: Serene | The fading echo of Joy. Has Advantage on Wisdom Saving Throws. |
| `EMOTION_ECSTASY` | Emotion: Ecstasy | Joy surged again on its own echo. Has an additional action. |
| `EMOTION_JOY` | Emotion: Joy | Surging with Joy. Its joy is contagious: it and its allies within [1] have Advantage on their next attack. |
| `RESONANT_OVERLOAD` | Overload | Everything you made others feel, felt again. It carries over from one fight to the next. The number shows how full it is: at 100% you become Overloaded. From level 5, Emotional Overload releases it. |
| `RESONANT_OVERLOAD_FULL` | Overloaded | Overwhelmed by everything you made others feel. You can't cast spells, your weapon attacks deal an additional [1], and you take Psychic damage equal to your spell slot level at the start of each of your turns. It lasts a number of turns equal to your level; from level 5, Emotional Overload ends it at once. |
| `RESONANT_OVERLOAD_SPENT_TECH` | Overload spent |  |
| `RESONANT_REFUND_TECH` | Refund |  |
| `FEELING_DELIGHT` | Feeling: Delight | Joy and Surprise, braided together. Regains [1] at the end of each turn. |
| `RESONANT_REFUND_USED` | Refund used |  |
| `FEELING_LOVE` | Feeling: Love | Joy and Trust, braided together. Armour Class and Saving Throws increased by 1, and Resistant to all damage. The spellcaster takes the same damage. |
| `FEELING_MORBIDNESS` | Feeling: Morbidness | Joy and Disgust, braided together. The first time it deals damage with a weapon each turn, it regains [1]. |
| `FEELING_OPTIMISM` | Feeling: Optimism | Joy and Anticipation, braided together. Cannot be Frightened. Gains temporary hit points each turn. |
| `FEELING_PRIDE` | Feeling: Pride | Joy and Anger, braided together. Scores a Critical Hit on a roll of 19 or 20. |
| `FEELING_MORBIDNESS_TECH` | Morbidness |  |
| `EMOTION_ADMIRATION` | Emotion: Admiration | Trust surged again on its own echo. Resistant to all damage. Cannot be Charmed or Frightened. |
| `EMOTION_TRUST` | Emotion: Trust | Surging with Trust. Shoulder to shoulder: when an ally within [1] is hit by an attack, it can use its reaction to share the blow. The ally is Resistant to it, and it takes the same damage. |
| `FEELING_CURIOSITY` | Feeling: Curiosity | Trust and Surprise, braided together. Has Advantage on Ability Checks, movement speed increased by [1], and can see Invisible creatures. |
| `FEELING_DOMINANCE` | Feeling: Dominance | Trust and Anger, braided together. Has Advantage on Athletics and Intimidation checks. Armour Class increased by 1. |
| `FEELING_HOPE` | Feeling: Hope | Trust and Anticipation, braided together. Adds 1d4 to Attack Rolls and Saving Throws. |
| `FEELING_SENTIMENTALITY` | Feeling: Sentimentality | Trust and Sadness, braided together. Resistant to Psychic damage. Cannot be Charmed. |
| `EMOTION_ANTICIPATION` | Emotion: Anticipation | Surging with Anticipation. On guard: when an enemy enters its reach, it can use its reaction to attack first. |
| `EMOTION_VIGILANCE` | Emotion: Vigilance | Anticipation surged again on its own echo. Has 2 additional reactions and Advantage on Dexterity Saving Throws. |
| `FEELING_AGGRESSIVENESS` | Feeling: Aggressiveness | Anger and Anticipation, braided together. Weapon attacks deal an additional [1]. Has an additional reaction. |
| `RESONANT_SHARED_CATHARSIS` | Catharsis | Opposing emotions, snapped through a Shared Heart. Heals, and every mood is spent. |
| `FEELING_CYNICISM` | Feeling: Cynicism | Disgust and Anticipation, braided together. Can't regain hit points. |
| `FEELING_PESSIMISM` | Feeling: Pessimism | Sadness and Anticipation, braided together. Subtracts 1d6 from Saving Throws and Ability Checks. |
| `EMOTION_SADNESS` | Emotion: Sadness | Surging with Sadness. Lets go of what it holds: loses Concentration and can't take bonus actions. |
| `FEELING_DISAPPROVAL` | Feeling: Disapproval | Surprise and Sadness, braided together. Its allies within [1] have Disadvantage on Attack Rolls. |
| `FEELING_ENVY` | Feeling: Envy | Sadness and Anger, braided together. Will attack the nearest creature, other than the spellcaster. |
| `FEELING_REMORSE` | Feeling: Remorse | Sadness and Disgust, braided together. The first time it deals damage each turn, it takes [1]. |
| `FEELING_DISAPPROVED` | Disapproved | Shaken by an ally's Disapproval. Has Disadvantage on Attack Rolls. |
| `FEELING_REMORSE_TECH` | Remorse |  |
| `EMOTION_SURPRISE` | Emotion: Surprise | Surging with Surprise. Caught off guard: can't take reactions, and the next attack against it has Advantage. |
| `FEELING_OUTRAGE` | Feeling: Outrage | Surprise and Anger, braided together. Has Disadvantage on Attack Rolls, and attacks against it have Advantage. |
| `FEELING_UNBELIEF` | Feeling: Unbelief | Surprise and Disgust, braided together. Can't cast spells. |
| `EMOTION_ANGER` | Emotion: Anger | Surging with Anger. Bears a grudge: attacks the last creature that hurt it, or the nearest one if nobody has. |
| `RESONANT_GRUDGE` | Grudge | Bears a grudge against whoever hurt it last and attacks them. |
| `EMOTION_RAGE` | Emotion: Rage | Anger surged again on its own echo. Bears a grudge: attacks the last creature that hurt it, or the nearest one if nobody has, with Advantage. Attacks against it also have Advantage. |
| `FEELING_CONTEMPT` | Feeling: Contempt | Disgust and Anger, braided together. Vulnerable to Psychic damage. |
| `EMOTION_DISGUST` | Emotion: Disgust | Surging with Disgust. Can't take actions. Has Disadvantage on Constitution Saving Throws. |
| `EMOTION_LOATHING` | Emotion: Loathing | Disgust surged again on its own echo. Can't take actions or bonus actions. Has Disadvantage on Attack Rolls and Ability Checks. |
| `RESONANT_ANGER_FALLBACK` | Lashing Out | Angry with no one to blame: attacks the nearest creature, other than the spellcaster. |
| `RESONANT_TWO_CUPS_CATHARSIS` | Catharsis | Opposing emotions, snapped at once by The Two Cups. Every mood is spent. |
| `EMOTION_TERROR` | Emotion: Terror | Fear surged again on its own echo. Flees in terror. Has Disadvantage on Ability Checks and Attack Rolls. |
| `FEELING_AWE` | Feeling: Awe | Fear and Surprise, braided together. Incapacitated: can't move or take actions, bonus actions or reactions. Taking damage ends the effect. |
| `EMOTION_GRIEF` | Emotion: Grief | Sadness surged again on its own echo. Incapacitated: can't move or take actions, bonus actions or reactions. |
| `EMOTION_AMAZEMENT` | Emotion: Amazement | Surprise surged again on its own echo. Stunned: can't move or take actions or reactions. Automatically fails Strength and Dexterity Saving Throws, and attacks against it have Advantage. |

## Texts the ARC-0014 build needs (R49–R68) — drafts

**Drafts, not in the game yet.** They replace or add to the rows above when the build ships; the Narrative gate
(`32.04`) records the approval, and the polish waits for ARC-0006. `[n]` parameters come from `25` (`pending_build`).

| Piece | Name | Draft description | Decision |
|---|---|---|---|
| New container | Weave Surge | Pour an emotion into a creature's Weave. Choose the emotion. | R54 |
| The eight emotions | Joy · Trust · Fear · Surprise · Sadness · Disgust · Anger · Anticipation | Today's descriptions, without the "Weave Surge:" prefix in the name; each lists the moods it reacts with | R54, R64 |
| Anger (emotion) | Anger | Set a red thread of fury alight in a creature's mind. It attacks the last creature that hurt it, or the nearest one if nobody has. Strike it first to draw its rage. | R65 |
| Every mood | Mood: <Mood> | Today's text, then one line of reactions — e.g. *Mood: Serene*: "…Trust: Love. Anticipation: Optimism. Sadness: Catharsis. Fear: Guilt (level 6). Joy: Ecstasy (level 7)…" | R64 |
| Emotional Alchemy | Emotional Alchemy | When your Weave Surge touches a creature that already carries a mood, the threads react instead of landing alone, and the mood is spent. Only an emotion that fades on its own leaves a mood. Your Weave Surges cast for you never braid a hindering feeling into an ally. | R49, R57 |
| New passive (level 3) | Opposites *(working name)* | A Weave Surge poured into the mood of its opposite emotion snaps into Catharsis: an enemy takes [1], an ally regains [2]. | R60 |
| Overload | Overload | You feel what you make others feel. Each emotion that takes hold fills your Overload a little, and each reaction fills it more. When it is full you are Overloaded. After a fight it settles to half. | R51, R53 |
| *Overloaded* (status) | Overloaded | Your own feelings overwhelm you. Subtracts [1] from Intelligence, Wisdom and Charisma Saving Throws, and you take [2] at the start of each turn. Once per turn, a Weave Surge that takes hold of an enemy also deals it [2]. | R51, R52 |
| Emotional Overload | Emotional Overload | Pour everything you feel into a creature's mind. Every feeling it carries is spent. If it fails a Wisdom Saving Throw, each feeling deals [1] and it dances helplessly for 1 turn; if it succeeds, each feeling deals half. Either way it suffers Mental Fatigue. Ends Overloaded. | R51, R68 |
| Temper | Temper | Spend a creature's mood to make it relive the emotion it came from for 1 turn. That emotion leaves nothing behind when it fades. A creature that is not your ally can resist with a Wisdom Saving Throw. | R49 |
| Heartstring | Heartstring | Pluck the string a creature's heart hangs from. It takes [1], and [2] more for each feeling it carries. | R61 |
| Ready: Compassion | Ready: Compassion | Today's text, with "takes damage **from an enemy**", and: "If Trust would braid a hindering feeling, it lands alone." | R57 (and the 2026-10-12 fix) |
| Shared Heart | Shared Heart | Today's text, plus: "When you cast it, every linked creature feels Joy." and "helpful feelings" in place of "feelings". | R57, R58 |
| Overwhelm | Overwhelm | Today's text, plus: "A creature can be overwhelmed only once per fight, and the overwhelming emotion leaves nothing behind." | R49, R50 |
| Resonance (Tier I) | Resonance | Catharsis deals or restores an extra 1d8. | R63 |
| Aspect of Empathy (Tier III) | Aspect of Empathy | When it awakens, your Overload fills at once, and creatures dancing from your Emotional Overload dance for [1] turns. | R56, R68 |
| Level-up text (5, 9) | — | Your moods and feelings grow stronger. | R62, R67 |

The two review notes above (Emotional Contagion's "every creature"; Emotional Overload's "this fight") are fixed by the
build's texts.
