---
id: 32.01/Starchild
owner: Lore Writer
source: game loca (51 Mods/…/Localization/English/english.xml) + Stats ids, extracted 2026-10-16 with dossier_texts.pl; 21.04/Starchild/DESIGN.md §5, §11; DECISIONS.md SC5, SC9, SC15, SC32; REFINE_Starchild.md §9
reviewed: 2026-10-16 ARC-0023 — created (propagation, 00.08); names of the build (SC32) at the end; 2026-10-17 ARC-0025 — R1–R4 sizes (SC33–SC36): no change
---

# 32.01 · Player-facing text — The Starchild

Every name and description the player reads, **as it is in the game today** (the 3.1 kit; English; `[n]` are the
game's parameters, numbers come from `25`). The 15 other languages carry the old strings of this kit (Localization).
Polishing the English waits for the end of the rework (ARC-0006); voice and style: `31.03`.

## Review notes (Lore Writer, 2026-10-16)

| Text | Issue | Fix (with the ARC-0023 build — game text) |
|---|---|---|
| Starcall, Astral Infusion, Rejuvenation, Equinox, Wish, Lucent Singularity, Final Spark | Borrowed Soraka / Lux names (SC15) | Rename as in the table at the end; Final Spark and its Recast leave |
| Every card | One spell today; the build makes each a container with a child per Hymn (SC22) | The container carries the neutral name, each child its own name and a tooltip for its light only |
| *Solar Purge* | Lists the conditions in prose; "Fright" and "Burn" are not BG3 condition names | Cleansing Rain: name the rule (one condition; on a marked ally, every condition and a little healing) and point to the list once |
| *Solar Flare* | "may Stun" — SC26 removes the Stun | Flare: Fire and Burning; allies in the area in Dusk or Nightfall are answered |
| *Astral Fortitude*, *Stellar Grace*, *Star Radiance*, *Lunar Aegis*, *Moon Gravity*, *Lunar Wisp* | Replaced by Long Twilight, Dawnbringer, Guiding Light, Halo, Tether, Hesperus (SC20, SC25) | New descriptions from `23.02/Starchild/` at the build |
| Beacon, Sunrise, Aspect of Hope, Moonlit, Sunlit, Eclipse (today's) | Damage riders and +Wisdom; SC16–SC19 replace them | The Awakening teaches *answer the marks*; Tier II and Eclipse texts from DESIGN §8 |
| `Arcana_Passive_Aspect_Star_Awakened_Heal`, `…_Awakened_III`, Moonlit / Sunlit passives | No description | Leave with the build |
| Narrative gate | No approval recorded in `32.04` for these texts | Record it when the build's texts are written |


## Spells and cards

| Internal id | Name | Description |
|---|---|---|
| `Projectile_Arcana_Card_Spell_Starcall` | Starcall | Hurl a radiant star at a target. The target's movement speed is reduced by 30% for 1 turn. You gain Rejuvenation. |
| `Shout_Arcana_Card_Passive_LunarWisp` | Lunar Wisp | Call a sliver of moonlight to follow your healing. Until your next Long Rest or until combat ends, you gain Lunar Wisp. |
| `Shout_Arcana_Card_Spell_StarRadiance` | Star Radiance | Emit a brilliant aura of starlight that empowers you and nearby allies. Your weapon attacks and those of your allies deal an additional [1]. |
| `Shout_Arcana_Card_Spell_Wish` | Wish | Call upon the stars to heal yourself and nearby allies. |
| `Shout_Arcana_Card_Spell_AstralFortitude` | Astral Fortitude | Bolster your allies within [1] with celestial energy to increase their hit point maximum by an amount equal to your Arcana level. |
| `Shout_Arcana_Card_Spell_StellarGrace` | Stellar Grace | Bind your companions' fates to the enduring light of the cosmos. Your allies will regain the maximum hit points possible when healed. They also gain Advantage on Wisdom Saving Throws and Death Saving Throws. |
| `Shout_Arcana_Created_Aspect_WishUponAStar` | Wish Upon a Star | Grant your allies within [1] Advantage on their next Attack Roll. |
| `Target_Arcana_Card_Spell_AstralInfusion` | Astral Infusion | Transfuse a portion of your own life force through an astral bond. If you don't have Rejuvenation, sacrifice 10% of your own maximum hit points to heal an ally. |
| `Target_Arcana_Card_Spell_LunarAegis` | Lunar Aegis | Manifest a resilient lunar aura around an ally, increasing their Armour Class by 2. |
| `Target_Arcana_Card_Spell_SolarPurge` | Solar Purge | Channel the purifying heat of the sun to purge negative effects and conditions including Charm, Fear, Fright, Sleep, Confusion, Petrification, Paralysis, Stun, Burn, Poison, Chill, Frozen, Shock, Bleeding, Blindness, Restraint, Polymorph, Daze, Disease or Curse. |
| `Target_Arcana_Card_Spell_LucentSingularity` | Lucent Singularity | Condense radiant light into a gravitational point that dispels magical darkness. The singularity's pull creates Difficult Terrain, while its brilliance encases enemies in Faerie Fire. |
| `Target_Arcana_Card_Spell_MoonGravity` | Moon Gravity | Manipulate gravity to grant an ally total freedom of movement. Instantly remove Stun. The target is unaffected by Difficult Terrain and cannot be magically Paralysed or Restrained. |
| `Target_Arcana_Card_Spell_Equinox` | Equinox | Manifest a zone of celestial equilibrium. Enemies within the area are Silenced. When the field dissipates after 1 turn, any enemies still inside become Restrained. |
| `Target_Arcana_Card_Spell_SolarFlare` | Solar Flare | Call down a pillar of solar fire that may Stun and Burn enemies in the area. |
| `Teleportation_Arcana_Card_Spell_Starbreath` | Starbreath | Channel a spark of stellar power into a fallen ally. They return to life with [1]% of their maximum hit points. |
| `Zone_Arcana_Card_Spell_FinalSpark` | Final Spark | Release a concentrated beam of pure radiant energy. All creatures caught in its path are Blinded and encased in Faerie Fire. |
| `Zone_Arcana_Created_FinalSpark_Recreate` | Recast Final Spark | Release another concentrated beam of pure radiant energy. All creatures caught in its path are Blinded and encased in Faerie Fire. If a creature is killed by this arcane power, all your ability cooldowns are reset. |

## Passives

| Internal id | Name | Description |
|---|---|---|
| `Arcana_Passive_StellarAnchor` | Stellar Anchor | Your consciousness is anchored to the unchanging positions of the stars. You have Advantage on Saving Throws to maintain Concentration on a spell. |
| `Arcana_Passive_LunarWisp` | Lunar Wisp | Infuse your healing with a protective lunar glow. When you heal an ally, they also gain [1]. |
| `Arcana_Passive_Aspect_Star_Awakened_Heal` | Beacon |  |
| `Arcana_Passive_Aspect_Star_Awakened_III` | Aspect of Hope |  |
| `Arcana_Passive_Star_Moonlit` | Moonlit |  |
| `Arcana_Passive_Star_Moonlit_II` | Moonlit |  |
| `Arcana_Passive_Star_Sunlit` | Sunlit |  |
| `Arcana_Passive_Star_Sunlit_II` | Sunlit |  |
| `Arcana_Passive_Aspect_Star_Awakening` | 17 - The Star: Awakening | Heal your allies during a fight to awaken the Aspect of Hope until combat ends. Healing beyond an ally's maximum hit points doesn't count. Each goal you reach awakens one more tier.Level 3: heal hit points equal to 5 times your level to gain Beacon.Level 7: heal hit points equal to 8 times your level to also gain Sunrise.Level 12: heal hit points equal to 12 times your level to awaken as the Aspect of Hope.The Awakening status shows how much is left to the next tier. |
| `Arcana_Passive_Aspect_Star_I` | Beacon | Allies you heal or target with an Arcane spell become Moonlit: their next attack that hits deals an additional [1] and reduces the target's movement speed. |
| `Arcana_Passive_Aspect_Star_II` | Sunrise | Moonlit deals [1] instead, and allies you heal or target with an Arcane spell also become Sunlit: their next attack that hits deals an additional [2] and sets the target Burning. |
| `Arcana_Passive_Aspect_Star_III` | Aspect of Hope | Your Wisdom increases by [1], Sunlit deals [2] instead, and allies you heal or target with an Arcane spell gain Eclipse, becoming Resistant to Cold and Fire damage. The first ally who would be downed during the fight instead regains half their hit points. |

## Statuses

| Internal id | Name | Description |
|---|---|---|
| `REJUVENATION` | Rejuvenation | Your movement speed is increased by 30%, and you regain [1] at the end of each turn. |
| `STARCALL_SLOW` | Slowed | The affected entity's movement speed is decreased by 30%. |
| `STAR_RADIANCE` | Star Radiance Aura | Emitting a brilliant starlight aura. Your weapon attacks and those of nearby allies deal an additional [1]. |
| `STAR_RADIANCE_AURA` | Star Radiance | You are bathed in the Starchild's brilliant starlight aura. Your weapon attacks deal an additional [1]. |
| `EQUINOX` | Silenced | You can't speak or cast spells with a verbal component, and are Immune to [1]. |
| `EQUINOX_AURA` | Equinox Aura | While it remains in the zone, the affected enemy is Silenced. |
| `ASPECT_AWAKENED_STAR` | 17 - The Star | Awakened as the Aspect of Hope until combat ends. |
| `ASPECT_AWAKENED_STAR_I` | 17 - The Star: Awakened I | Beacon: Allies you heal or target with an Arcane spell become Moonlit: their next attack that hits deals an additional [1] and reduces the target's movement speed. |
| `ASPECT_AWAKENED_STAR_II` | 17 - The Star: Awakened II | Beacon: Allies you heal or target with an Arcane spell become Moonlit: their next attack that hits deals an additional [1] and reduces the target's movement speed.Sunrise: Moonlit deals [2] instead, and allies you heal or target with an Arcane spell also become Sunlit: their next attack that hits deals an additional [3] and sets the target Burning. |
| `ASPECT_AWAKENED_STAR_III` | 17 - The Star: Awakened III | Beacon: Allies you heal or target with an Arcane spell become Moonlit: their next attack that hits deals an additional [1] and reduces the target's movement speed.Sunrise: Moonlit deals [2] instead, and allies you heal or target with an Arcane spell also become Sunlit: their next attack that hits deals an additional [3] and sets the target Burning.Aspect of Hope: Your Wisdom increases by [4], Sunlit deals [5] instead, and allies you heal or target with an Arcane spell gain Eclipse, becoming Resistant to Cold and Fire damage. The first ally who would be downed during the fight instead regains half their hit points. |
| `STAR_ECLIPSE` | Eclipse | Resistant to Cold and Fire damage. |
| `STAR_MOONLIT` | Moonlit | The next attack that hits deals an additional [1] and reduces the target's movement speed. |
| `STAR_SUNLIT` | Sunlit | The next attack that hits deals an additional [1] and sets the target Burning. |
| `WISH_UPON_A_STAR` | Wish Upon a Star | Has Advantage on the next Attack Roll. |
| `ASPECT_PROGRESS_STAR` | Awakening Progress | Progress towards your next Awakening tier, in percent. |
| `ASPECT_PROGRESS_STAR_I` | Awakening | Hit points left to heal to awaken Beacon. |
| `ASPECT_PROGRESS_STAR_II` | Awakening | Hit points left to heal to awaken Sunrise. |
| `ASPECT_PROGRESS_STAR_III` | Awakening | Hit points left to heal to awaken the Aspect of Hope. |

## Names after the ARC-0023 build (SC32, approved 2026-10-16)

Internal ids keep their names until the build decides. Each card becomes a container (neutral name) with three
children (Stars · Sun · Moon); only the child of the Hymn sung is unlocked. Vanilla-corpus check still due before the
Narrative gate (`bg3_english_writing_style`).

| Internal id today | Name today | Container after the build | Stars · Sun · Moon children |
|---|---|---|---|
| `Projectile_Arcana_Card_Spell_Starcall` | Starcall | **Comet** | Shooting Star · Sunspark · Crescent Dart |
| `REJUVENATION` | Rejuvenation | **Afterglow** (status) | — |
| `Target_Arcana_Card_Spell_AstralInfusion` | Astral Infusion | **Outpouring** | Lodestar Balm · Noonday Pour · Rising Tide |
| `Shout_Arcana_Card_Passive_LunarWisp` | Lunar Wisp | **Hesperus** | Hesperus · Last Ray · Moonrise |
| `Target_Arcana_Card_Spell_SolarPurge` | Solar Purge | **Cleansing Rain** | Starwater · Sunshower · Moondew |
| `Teleportation_Arcana_Card_Spell_Starbreath` | Starbreath | **Rekindle** | Nova · Phoenix Light · New Moon |
| `Target_Arcana_Card_Spell_LunarAegis` | Lunar Aegis | **Halo** | Starshield · Corona · Moon Ring |
| `Shout_Arcana_Card_Spell_StarRadiance` | Star Radiance | **Guiding Light** | Polaris · Sun Dog · Moonpath |
| `Shout_Arcana_Card_Spell_Wish` | Wish | **Elpis' Jar** | Wishing Star · Midsummer · Harvest Moon |
| `Target_Arcana_Card_Spell_MoonGravity` | Moon Gravity | **Tether** | Starline · Solar Wake · Undertow |
| `Target_Arcana_Card_Spell_Equinox` | Equinox | **Stillness** | Fixed Stars · High Noon · Midnight |
| `Shout_Arcana_Card_Spell_AstralFortitude` | Astral Fortitude | **Long Twilight** | Blue Hour · Golden Hour · Long Night |
| `Target_Arcana_Card_Spell_SolarFlare` | Solar Flare | **Flare** | Supernova · Solar Flare · Moonburn |
| `Shout_Arcana_Card_Spell_StellarGrace` | Stellar Grace | **Dawnbringer** | Daystar · Sunrise · Moonset |
| `Target_Arcana_Card_Spell_LucentSingularity` (+ vanilla Light) | Lucent Singularity | **Lantern** (cantrip) | Wayfinder · Noonlight · Moonshadow |
| `Shout_Arcana_Created_Aspect_WishUponAStar` | Wish Upon a Star | **The Great Star** (Aspect card, no children) | — |
| `Arcana_Passive_StellarAnchor` | Stellar Anchor | **Light in the Dark** (passive, level 10) | — |
| — (new) | — | **Sing a Hymn** | Hymn of the Stars · Hymn of the Sun · Hymn of the Moon |
| — (new) | — | **Unsung**, **Dusk**, **Nightfall**, **Dawn**, **Dazzled**, **Tide**, **Eclipse** (Tier III), **Undying Hope** (Tier I) | — |
| `Zone_Arcana_Card_Spell_FinalSpark` · `…_FinalSpark_Recreate` | Final Spark · Recast Final Spark | leave (SC26) | — |
| Cosmic Omen (vanilla) | Cosmic Omen | leaves; Sing a Hymn takes level 1 (SC26) | — |
| Beacon · Sunrise · Aspect of Hope · Moonlit · Sunlit | — | leave (SC16–SC19) | — |

## Approved lines for the build

| For | Text | Decision |
|---|---|---|
| Unsung (status) | *Your light flickers, dim and waiting. Sing a Hymn to choose your light.* | SC5 |
| Dusk (status) | *Dusk falls on this ally. The Starchild's next heal answers it.* — draft | SC9 |
