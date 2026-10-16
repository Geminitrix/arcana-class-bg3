---
id: 21.04/Deceiver/DECISIONS
owner: Lead Class Designer
role: source of the Deceiver dossier (00.08) — every decision is logged here the moment it is taken
---

# The Deceiver — decision log

**DV1–DV17** are decisions D1–D17 of the Veil design (2026-10-06/07, built in stages 1–4), moved here on
2026-10-16 (ADR-0009) with the dossier prefix `DV`; their spec (`2026-10-06-deceiver-veil-design.md`) moves to
`90_ARCHIVE/93_Old_Versions/` once `DESIGN.md` replaces it. **DV18 on** come from the refining review of
ARC-0019 (`REFINE_Deceiver.md`, suggestions SG1–SG10). Where a later decision replaces an earlier one, the later one
says so; `DESIGN.md` shows only the result.

## Decision log

| # | Decision | Source |
|---|---|---|
| DV1 | Arcanum changes from III · The Empress to **II · The High Priestess** — secrets, the veil, the two pillars of truth and lie; Mystra is the **Lady of Mysteries** | Owner, 2026-10-06 |
| DV2 | Aspect of Love becomes **Aspect of Doubt**. The subclass keeps the name **Deceiver** | Owner, 2026-10-06 |
| DV3 | Engine **The Veil**: **Doubles** (illusory copies of her) on the field and **Doubt** on enemies | Owner, 2026-10-06 |
| DV4 | Doubles are summoned entities with **1 HP** that copy her look, carry the Duplicity shimmer and have **fixed** stats and damage (no level scaling — what grows is how many), up to **3 → 4 → 5** | Owner, 2026-10-06 |
| DV5 | Each Double has **its own turn, player-controlled**, with a minimal kit: movement + 1 action; no bonus action, no reaction, no weapon attacks | Owner, 2026-10-06 |
| DV6 | Doubles are **immune to loss of control** (Charmed, Madness, Possessed/Dominated, fleeing Fear) | Owner, 2026-10-06 |
| DV7 | She gains **+1 AC per Double** on the field | Owner, 2026-10-06 |
| DV8 | **Mirror Image** stops being the full clone and becomes the card that summons Doubles | Owner, 2026-10-06 |
| DV9 | **Distortion** leaves a Double where she stood; **Withdraw** swaps places with it | Owner, 2026-10-06 |
| DV10 | Mental Prison + Hypnotic Gaze merge into **Veiled Prison**, stronger against Doubt. Terrify leaves. Hostile Takeover becomes **Grand Deception**. Ready: Instinctive Charm and Ready: Hollow Image leave. Telepathy, Faceless and Friends stay *(Telepathy replaced by DV26)* | Owner, 2026-10-06 |
| DV11 | Faceless: Copy gets a cleaner script | Owner, 2026-10-06 |
| DV12 | Internal ids of the Awakening plumbing keep the word *Empress* (`ASPECT_AWAKENED_EMPRESS`, `ARCANA_Aspect_Empress.txt`…); only player-facing text changes | proposal accepted, 2026-10-06 |
| DV13 | Colour stays pink `#f83fa5`; the emoji stays 🪞 | proposal accepted, 2026-10-06 |
| DV14 | **Friends** is a level-1 spell; its level-6 upcast carries what Faux Amis did (no Concentration, the target never notices). Faux Amis stops being a separate grant | Owner, 2026-10-06 |
| DV15 | **Malicious Whispers** keeps its own Doubt rider: on a Sigil-marked target it gives 2 Doubt (its rider + the detonation) | Owner, 2026-10-07 |
| DV16 | **No lower caps:** Doubles stay 3 / 4 / 5 and +1 AC each. Keeping five alive costs slots and survival. Reopened only by a playtest result | Owner, 2026-10-07 |
| DV17 | **Mirror spells deal half of her own spell** (her card's dice at her highest slot, halved); Shatter stays a fixed die | Owner + proposal, 2026-10-07 |
| DV18 | **Axis: Presence** — *how many bodies do I hold on the field, and when do I spend them?* No other subclass owns it (`21.08`) | Owner, from SG1, 2026-10-16 |
| DV19 | **One core rule, taught once on one visible passive (The Veil):** *every lie an enemy believes plants Doubt; at the third, it is Deluded.* A Double destroyed by an enemy, a Shatter, her Sigil detonating and Malicious Whispers on a marked target are all "a lie believed"; no feature carries its own exception | Owner, from SG2, 2026-10-16 |
| DV20 | **Sources.** Myth: the **eidolon of Helen** — the cloud-Helen Hera made, for whom Greeks and Trojans fought while the real one was elsewhere (Euripides, *Helen*; Stesichorus' palinode) — and **Nephele**, the cloud-Hera that deceived Ixion (Pindar, *Pythian* 2). Real model: the **Ghost Army** (WWII deception unit: inflatable tanks, false radio and sound — decoys that draw fire). Card: the veil of pomegranates, the pillars B and J, the half-hidden scroll (Waite, 1910; Pollack, 1980). Every citation is checked in the primary text (Perseus, the deck key) before it reaches a player-facing text (DM-S7) | Owner, from SG3, 2026-10-16 |
| DV21 | **Tier III — *the lie explodes*** (replaces the +3 Charisma and Charisma to Arcane damage, DM-A2): a Double destroyed by an enemy shatters by itself, and **Shatter's area grows** to ‹wide radius›. Which One? stays. Pattern: vanilla **Death Burst** (mephits; bg3.wiki *Death Burst*) — an active burst plus the same burst on death. Files: `GLO_CombatNPCs.txt` (`Dying` → timer → `CreateExplosionAtPosition(…, "Projectile_DeathBurst_*", 1, _Char)`), `Spell_Projectile.txt` `Projectile_DeathBurst_Died_IceMephit` (`ExplodeRadius` sets the area). The Deceiver runs it from her own Doubles goal, only on the "destroyed by an enemy" path (never on Dismiss, the cap or a cleanup), with her as the caster so the Doubt is hers; the wider area is the Tier III projectile's `ExplodeRadius`. The name stays the Veil's, not the mephits' (DM-I6). Untested in the mod — T2 | Owner, from SG4 (option A + wider area), 2026-10-16 |
| DV22 | **Grand Deception reads the Veil** (DM-K7): before the new Doubles appear, each enemy in range that fails its save gains Doubt for each Double already within ‹x› m of it; then the Doubles fill the cap. Where she placed her Doubles is what the ultimate reads. The Veil Lifts stays the "spend everything" card (DM-A3) | Owner, from SG5, 2026-10-16 |
| DV23 | **The level map is spread over every level** (standard v2.1, D9 of ARC-0016): something at every level 1–12 except 4 and 8; level 1 lightened (DM-J4). Final rows: see the map decision that follows | Owner, from SG6, 2026-10-16 |
| DV24 | **Shatter on command:** a bonus action of hers — one of her Doubles shatters now. Her first bonus-action option, early (DM-K6); the Presence decision in one button: spend a body now, or keep its AC and its turn | Owner, from SG7, 2026-10-16 |
| DV25 | **Mirrored Self is cast from a Double:** the extra target of the duplicated spell comes from the position of one of her Doubles (LeBlanc). Engine support unknown — T2, test before the spec | Owner, from SG8, 2026-10-16 |
| DV26 | **Utilities: Faceless and Friends stay; Telepathy leaves the Deceiver** (amends DV10). Two utilities instead of the standard's one (§8.5), argued: both are the Veil out of combat — Faceless is the false face, Friends the false word | Owner, from SG9, 2026-10-16 |
| DV27 | **Dossier:** `DESIGN.md` + `DECISIONS.md` (ADR-0009); the dated Veil spec goes to the archive; the matrix `21.08` follows the game (the Awakening counts Doubt) | Owner, from SG10, 2026-10-16 |
