# 2026-10-20 · Windborn build review and the Harmony leak (ARC-0026, Mod Engineer)

**Done:** reviewed the Owner's Windborn typing against the spec (orphans, references, Story); every finding went to the
Owner as copy-paste blocks (the game stayed open, OR-11). The Owner applied most of them in the Toolkit. The goal
`ARCANA_Aspect_Fool` was rewritten for him: the pair `EurusBoreas`, headwinds given by the goal to the enemies Windswept
when the bag opens (and to those marked while a wind blows) until the wind stops, The Calm's gusts on every enemy under
a headwind, `BAG_OPEN` applied once and counting its own turns, the dead Tier I rules gone (Tier I and III live in Stats).

**Fixed:** a Windborn at Tier II received the Resonant's Harmony (`RESONANT_SURGE_FREE`). The turn-start rule of
`ARCANA_Aspect_Temperance` read `DB_ARCANA_AspectReached`, which keeps no Aspect. `gen_emotion_alchemy.pl` now adds
`HasPassive(_Resonant, "Arcana_Passive_Aspect_Temperance_II", 1)` (the Death goal's fix); the Owner pastes the same rule
in the Story Editor.

**Waiting on the Owner:** paste the goals and compile; `[fechado] ARC-0026` for the PC deck (`CardDB.lua` still names Leap
of Faith, Evasive Flow and Thunderclap, which he deleted), `ARCANA_CardFamilies`, the vanilla handles of
`Interrupt_AttackOfOpportunity`, `sync_data`, and the spec, QA and `25` brought to his choices.
