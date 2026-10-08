# The Deceiver: The Veil - Task 0 preflight inventory

Read-only inventory taken on 2026-10-06 before any change. Nothing under the game folder was written; the only file produced is this one.
Spec: `Design/specs/2026-10-06-deceiver-veil-design.md` (sections 3, 4, 9, and D14).
Paths: `$G` = `C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data`, `$M` = `AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7`, `$P` = `C:/Projetos/BG3 Modding/Arcana Class`.

Sections: A baselines, B every reference to a removed or replaced id, C current definitions, D Osiris goals, E vanilla facts, F risks.

---

## A. Baselines (before any change)

| Check | Command | Result |
|---|---|---|
| Lua suite | `lua.exe $P/tools/run_tests.lua $G/Mods/$M/ScriptExtender/Lua` | `[ArcanaDeck tests] 134 passed, 0 failed` |
| Card checker | `perl $P/tools/stats/check_cards.pl` | exit code **0**; `raizes marcadas: 101`; `OK -- nenhum problema` (0 problems) |
| stats_add self-test | `perl $P/tools/stats/stats_add.pl --selftest` | `selftest: 945 iguais, 0 diferentes, 0 sem objeto no .stats` |

Notes:
- The Lua run also prints `[ArcanaDeck] handler error in Test_Error_1: ...EventsTest.lua:19: boom`. That is an intentional case of the error-isolation test (the test passes); it is not a failure.
- Osiris compile log `$G/Mods/$M/Story/log.txt` ends with `0 error(s), 0 warning(s). Compilation ended.` The log file is dated 2026-10-03 01:17 while `Story/story.div` and the goals are dated 2026-10-04 15:59, so the log may not be the latest compile; re-read it after the next compile.
- `Design/work/deceiver/` did not exist; it was created for this file.

---

## B. Ids the plan removes or replaces: every reference

Scope of the search: the whole mod (`$G/Mods/$M`, `$G/Public/$M`, `$G/Editor/Mods/$M`), text files only (`.txt .stats .lsx .tbl .lua .khn .xml .div`), whole-word match on the id.

Layers: `Stats.txt` = game stats (`Public/.../Stats/Generated/Data`); `Stats.stats` = Toolkit XML (there a spell's `Name` field drops the type prefix, e.g. `Arcana_Card_Spell_MentalPrison`; the tables list it under the full id); `List` = SpellLists; `Progression`; `Other` = ActionResourceDefinitions; `Osiris` = Goals; `Lua` / `LuaTest`; `Khonsu`; `Loca` = english.xml.

Not searched (binary or generated): `RootTemplates/*.lsf`, `Tags/*.lsf`, the compiled Story (`Mods/$M/Story/story.div`, `goals.raw`, which also contain these ids and are rebuilt on compile), the 14 non-English locale files (same handles), `Backup/`.

Loca handles are resolved from each stat entry (DisplayName / Description / ExtraDescription -> english.xml line); the ids themselves almost never appear inside english.xml.

**Whole files that go away:** `Goals/ARCANA_Spell_MirrorImage.txt` (replaced), `Goals/ARCANA_Spell_MirrorWithdraw.txt` (removed with the Mirror spells), `Goals/ARCANA_Spell_FacelessCopy_EX.txt` (deleted).

### B1. Mental Prison (merged into Veiled Prison)

**`Target_Arcana_Card_Spell_MentalPrison`** (23 refs)

Loca: DisplayName=english.xml:143(v1) Description=english.xml:144(v2) (stat entry at Spell_Target.txt:1176)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1176` | `new entry "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3424` | `using "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3425` | `data "RootSpellID" "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3432` | `using "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3433` | `data "RootSpellID" "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3440` | `using "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3441` | `data "RootSpellID" "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3448` | `using "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3449` | `data "RootSpellID" "Target_Arcana_Card_Spell_MentalPrison"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1166` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_MentalPrison" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3879` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_MentalPrison" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3889` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_MentalPrison" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3899` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_MentalPrison" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3909` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_MentalPrison" />` |
| List | `Editor/Mods/$M/Lists/SpellLists.tbl:127` | `<field name="Spells" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_EtherealChains;Target_Arcana` |
| List | `Public/$M/Lists/SpellLists.lsx:94` | `<attribute id="Spells" type="LSString" value="Target_Arcana_Card_Spell_EtherealChains;Target_Arcana_Card_Spell_Ment` -> list "Deceiver Level 3" f5216d9b-4fed-49f0-b1ea-8a5e2b831b59 |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:267` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison", "Target_Arcana_Card_Spell_MentalPrison");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:268` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison_3", "Target_Arcana_Card_Spell_MentalPrison");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:269` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison_4", "Target_Arcana_Card_Spell_MentalPrison");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:270` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison_5", "Target_Arcana_Card_Spell_MentalPrison");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:271` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison_6", "Target_Arcana_Card_Spell_MentalPrison");` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:74` | `["Target_Arcana_Card_Spell_MentalPrison"] = { aspect = "Deceiver", keywords = { Unique = true } },` |
| LuaTest | `Mods/$M/ScriptExtender/Lua/Tests/DestinationTest.lua:69` | `"Target_Arcana_Card_Spell_MentalPrison", "Target_Arcana_Card_Spell_Marionette",` |

**`Target_Arcana_Card_Spell_MentalPrison_3`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3421)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3421` | `new entry "Target_Arcana_Card_Spell_MentalPrison_3"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3877` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_MentalPrison_3" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:268` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison_3", "Target_Arcana_Card_Spell_MentalPrison");` |

**`Target_Arcana_Card_Spell_MentalPrison_4`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3429)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3429` | `new entry "Target_Arcana_Card_Spell_MentalPrison_4"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3887` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_MentalPrison_4" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:269` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison_4", "Target_Arcana_Card_Spell_MentalPrison");` |

**`Target_Arcana_Card_Spell_MentalPrison_5`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3437)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3437` | `new entry "Target_Arcana_Card_Spell_MentalPrison_5"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3897` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_MentalPrison_5" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:270` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison_5", "Target_Arcana_Card_Spell_MentalPrison");` |

**`Target_Arcana_Card_Spell_MentalPrison_6`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3445)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3445` | `new entry "Target_Arcana_Card_Spell_MentalPrison_6"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3907` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_MentalPrison_6" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:271` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MentalPrison_6", "Target_Arcana_Card_Spell_MentalPrison");` |

### B2. Hypnotic Gaze (merged into Veiled Prison)

**`Target_Arcana_Card_Spell_HypnoticGaze`** (21 refs)

Loca: DisplayName=english.xml:197(v1) Description=english.xml:198(v1) (stat entry at Spell_Target.txt:1146)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1146` | `new entry "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3328` | `using "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3329` | `data "RootSpellID" "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3336` | `using "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3337` | `data "RootSpellID" "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3344` | `using "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3345` | `data "RootSpellID" "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3352` | `using "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3353` | `data "RootSpellID" "Target_Arcana_Card_Spell_HypnoticGaze"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1134` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_HypnoticGaze" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3759` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_HypnoticGaze" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3769` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_HypnoticGaze" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3779` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_HypnoticGaze" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3789` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_HypnoticGaze" />` |
| List | `Editor/Mods/$M/Lists/SpellLists.tbl:127` | `<field name="Spells" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_EtherealChains;Target_Arcana` |
| List | `Public/$M/Lists/SpellLists.lsx:94` | `<attribute id="Spells" type="LSString" value="Target_Arcana_Card_Spell_EtherealChains;Target_Arcana_Card_Spell_Ment` -> list "Deceiver Level 3" f5216d9b-4fed-49f0-b1ea-8a5e2b831b59 |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:250` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze", "Target_Arcana_Card_Spell_HypnoticGaze");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:251` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze_3", "Target_Arcana_Card_Spell_HypnoticGaze");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:252` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze_4", "Target_Arcana_Card_Spell_HypnoticGaze");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:253` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze_5", "Target_Arcana_Card_Spell_HypnoticGaze");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:254` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze_6", "Target_Arcana_Card_Spell_HypnoticGaze");` |

**`Target_Arcana_Card_Spell_HypnoticGaze_3`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3325)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3325` | `new entry "Target_Arcana_Card_Spell_HypnoticGaze_3"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3757` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_HypnoticGaze_3" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:251` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze_3", "Target_Arcana_Card_Spell_HypnoticGaze");` |

**`Target_Arcana_Card_Spell_HypnoticGaze_4`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3333)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3333` | `new entry "Target_Arcana_Card_Spell_HypnoticGaze_4"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3767` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_HypnoticGaze_4" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:252` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze_4", "Target_Arcana_Card_Spell_HypnoticGaze");` |

**`Target_Arcana_Card_Spell_HypnoticGaze_5`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3341)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3341` | `new entry "Target_Arcana_Card_Spell_HypnoticGaze_5"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3777` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_HypnoticGaze_5" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:253` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze_5", "Target_Arcana_Card_Spell_HypnoticGaze");` |

**`Target_Arcana_Card_Spell_HypnoticGaze_6`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3349)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3349` | `new entry "Target_Arcana_Card_Spell_HypnoticGaze_6"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3787` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_HypnoticGaze_6" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:254` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HypnoticGaze_6", "Target_Arcana_Card_Spell_HypnoticGaze");` |

### B3. Hostile Takeover (becomes Grand Deception)

**`Target_Arcana_Card_Spell_HostileTakeover`** (9 refs)

Loca: DisplayName=english.xml:139(v1) Description=english.xml:140(v7) (stat entry at Spell_Target.txt:1372)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1372` | `new entry "Target_Arcana_Card_Spell_HostileTakeover"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3320` | `using "Target_Arcana_Card_Spell_HostileTakeover"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3321` | `data "RootSpellID" "Target_Arcana_Card_Spell_HostileTakeover"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1378` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_HostileTakeover" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3749` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_HostileTakeover" />` |
| List | `Editor/Mods/$M/Lists/SpellLists.tbl:155` | `<field name="Spells" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_HostileTakeover;Shout_Arcana` |
| List | `Public/$M/Lists/SpellLists.lsx:114` | `<attribute id="Spells" type="LSString" value="Target_Arcana_Card_Spell_HostileTakeover;Shout_Arcana_Card_Passive_Ho` -> list "Deceiver Level 11" 7134712c-169c-4210-9b13-541e9660392c |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:248` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HostileTakeover", "Target_Arcana_Card_Spell_HostileTakeover");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:249` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HostileTakeover_6", "Target_Arcana_Card_Spell_HostileTakeover");` |

**`Target_Arcana_Card_Spell_HostileTakeover_6`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3317)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3317` | `new entry "Target_Arcana_Card_Spell_HostileTakeover_6"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3747` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_HostileTakeover_6" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:249` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_HostileTakeover_6", "Target_Arcana_Card_Spell_HostileTakeover");` |

### B4. Terrify (removed)

**`Target_Arcana_Card_Spell_Terrify`** (13 refs)

Loca: DisplayName=english.xml:137(v1) Description=english.xml:138(v5) ExtraDescription=english.xml:210(v1) (stat entry at Spell_Target.txt:1307)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1307` | `new entry "Target_Arcana_Card_Spell_Terrify"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3630` | `using "Target_Arcana_Card_Spell_Terrify"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3631` | `data "RootSpellID" "Target_Arcana_Card_Spell_Terrify"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3638` | `using "Target_Arcana_Card_Spell_Terrify"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3639` | `data "RootSpellID" "Target_Arcana_Card_Spell_Terrify"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1309` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_Terrify" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:4129` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_Terrify" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:4139` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_Terrify" />` |
| List | `Editor/Mods/$M/Lists/SpellLists.tbl:148` | `<field name="Spells" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_Marionette;Target_Arcana_Car` |
| List | `Public/$M/Lists/SpellLists.lsx:109` | `<attribute id="Spells" type="LSString" value="Target_Arcana_Card_Spell_Marionette;Target_Arcana_Card_Spell_Terrify"` -> list "Deceiver Level 9" 55ff77d4-6dd9-4cda-8e9b-84ba78cf5a54 |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:297` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_Terrify", "Target_Arcana_Card_Spell_Terrify");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:298` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_Terrify_5", "Target_Arcana_Card_Spell_Terrify");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:299` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_Terrify_6", "Target_Arcana_Card_Spell_Terrify");` |

**`Target_Arcana_Card_Spell_Terrify_5`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3627)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3627` | `new entry "Target_Arcana_Card_Spell_Terrify_5"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:4127` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_Terrify_5" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:298` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_Terrify_5", "Target_Arcana_Card_Spell_Terrify");` |

**`Target_Arcana_Card_Spell_Terrify_6`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3635)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3635` | `new entry "Target_Arcana_Card_Spell_Terrify_6"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:4137` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_Terrify_6" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:299` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_Terrify_6", "Target_Arcana_Card_Spell_Terrify");` |

### B5. Ready: Instinctive Charm (removed, with passive, interrupt, reaction spell, statuses, resource)

**`Shout_Arcana_Card_Passive_InstinctiveCharm`** (23 refs)

Loca: DisplayName=english.xml:861(v1) Description=english.xml:862(v3) (stat entry at Spell_Shout.txt:1353)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1353` | `new entry "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2212` | `using "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2213` | `data "RootSpellID" "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2220` | `using "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2221` | `data "RootSpellID" "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2228` | `using "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2229` | `data "RootSpellID" "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2236` | `using "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2237` | `data "RootSpellID" "Shout_Arcana_Card_Passive_InstinctiveCharm"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1530` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Passive_InstinctiveCharm" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2505` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Shout_Arcana_Card_Passive_InstinctiveCharm" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2515` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Shout_Arcana_Card_Passive_InstinctiveCharm" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2525` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Shout_Arcana_Card_Passive_InstinctiveCharm" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2535` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Shout_Arcana_Card_Passive_InstinctiveCharm" />` |
| List | `Editor/Mods/$M/Lists/SpellLists.tbl:134` | `<field name="Spells" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_Distortion;Shout_Arcana_Card` |
| List | `Public/$M/Lists/SpellLists.lsx:99` | `<attribute id="Spells" type="LSString" value="Target_Arcana_Card_Spell_Distortion;Shout_Arcana_Card_Passive_Instinc` -> list "Deceiver Level 5" 9aac7d55-57b7-4942-afb4-1751e506b172 |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:50` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:51` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm_3", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:52` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm_4", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:53` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm_5", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:54` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm_6", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:70` | `["Shout_Arcana_Card_Passive_InstinctiveCharm"] = { aspect = "Deceiver", cost = 2, keywords = { Unique = true } },` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:150` | `["Shout_Arcana_Card_Passive_InstinctiveCharm"] = {` |

**`Shout_Arcana_Card_Passive_InstinctiveCharm_3`** (3 refs)

Loca: - (stat entry at Spell_Shout.txt:2209)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2209` | `new entry "Shout_Arcana_Card_Passive_InstinctiveCharm_3"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2503` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Passive_InstinctiveCharm_3" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:51` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm_3", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |

**`Shout_Arcana_Card_Passive_InstinctiveCharm_4`** (3 refs)

Loca: - (stat entry at Spell_Shout.txt:2217)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2217` | `new entry "Shout_Arcana_Card_Passive_InstinctiveCharm_4"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2513` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Passive_InstinctiveCharm_4" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:52` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm_4", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |

**`Shout_Arcana_Card_Passive_InstinctiveCharm_5`** (3 refs)

Loca: - (stat entry at Spell_Shout.txt:2225)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2225` | `new entry "Shout_Arcana_Card_Passive_InstinctiveCharm_5"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2523` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Passive_InstinctiveCharm_5" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:53` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm_5", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |

**`Shout_Arcana_Card_Passive_InstinctiveCharm_6`** (3 refs)

Loca: - (stat entry at Spell_Shout.txt:2233)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2233` | `new entry "Shout_Arcana_Card_Passive_InstinctiveCharm_6"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2533` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Passive_InstinctiveCharm_6" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:54` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_InstinctiveCharm_6", "Shout_Arcana_Card_Passive_InstinctiveCharm");` |

**`Arcana_Passive_InstinctiveCharm`** (4 refs)

Loca: DisplayName=english.xml:206(v1) Description=english.xml:207(v3) (stat entry at Passive.txt:169)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:169` | `new entry "Arcana_Passive_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1096` | `data "Passives" "Arcana_Passive_InstinctiveCharm"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:172` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Passive_InstinctiveCharm" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:683` | `<field name="Passives" type="StringTableFieldDefinition" value="Arcana_Passive_InstinctiveCharm" />` |

**`Interrupt_Arcana_Reaction_InstinctiveCharm`** (4 refs)

Loca: DisplayName=english.xml:204(v1) Description=english.xml:205(v1) (stat entry at Interrupt.txt:4)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:4` | `new entry "Interrupt_Arcana_Reaction_InstinctiveCharm"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:177` | `data "Boosts" "UnlockInterrupt(Interrupt_Arcana_Reaction_InstinctiveCharm);"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:13` | `<field name="Name" type="NameTableFieldDefinition" value="Interrupt_Arcana_Reaction_InstinctiveCharm" />` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:178` | `<field name="Boosts" type="StringTableFieldDefinition" value="UnlockInterrupt(Interrupt_Arcana_Reaction_Instinctive` |

**`Target_Arcana_Reaction_InstinctiveCharm`** (4 refs)

Loca: DisplayName=english.xml:202(v1) Description=english.xml:203(v1) (stat entry at Spell_Target.txt:1211)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:14` | `data "Success" "Counterspell();UseSpell(OBSERVER_SOURCE,Target_Arcana_Reaction_InstinctiveCharm,true,true,true);IF(` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1211` | `new entry "Target_Arcana_Reaction_InstinctiveCharm"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1203` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Reaction_InstinctiveCharm" />` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:24` | `<field name="Success" type="StringTableFieldDefinition" value="Counterspell();UseSpell(OBSERVER_SOURCE,Target_Arcan` |

**`INSTINCTIVE_CHARM_READY`** (12 refs)

Loca: DisplayName=english.xml:206(v1) Description=english.xml:207(v3) (stat entry at Status_BOOST.txt:1088)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1358` | `data "SpellProperties" "ApplyStatus(SELF,INSTINCTIVE_CHARM_READY,100,-1);RestoreResource(SELF,ArcanaReactInstinctiv` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1363` | `data "TooltipStatusApply" "ApplyStatus(INSTINCTIVE_CHARM_READY,100,-1)"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1374` | `data "RequirementConditions" "not HasStatus('ARCANA_WEAVING',context.Source) and not (HasStatus('INSTINCTIVE_CHARM_` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1088` | `new entry "INSTINCTIVE_CHARM_READY"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1094` | `data "StackId" "INSTINCTIVE_CHARM_READY"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1533` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="ApplyStatus(SELF,INSTINCTIVE_CHARM_READY,100` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1538` | `<field name="TooltipStatusApply" type="StringTableFieldDefinition" value="ApplyStatus(INSTINCTIVE_CHARM_READY,100,-` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1549` | `<field name="RequirementConditions" type="StringTableFieldDefinition" value="not HasStatus('ARCANA_WEAVING',context` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:677` | `<field name="Name" type="NameTableFieldDefinition" value="INSTINCTIVE_CHARM_READY" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:681` | `<field name="StackId" type="StringTableFieldDefinition" value="INSTINCTIVE_CHARM_READY" />` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:151` | `ready = "INSTINCTIVE_CHARM_READY", resource = "ArcanaReactInstinctiveCharm",` |
| Loca | `Mods/$M/Localization/English/english.xml:862` | `<content contentuid="hfae5f193gdcc7g46e5g8ec7gbf766b704871" version="3">Let the Weave settle over you like a second` |

**`INSTINCTIVE_CHARM_USED_TECH`** (9 refs)

Loca: DisplayName=english.xml:910(v1) (stat entry at Status_BOOST.txt:1115)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:14` | `data "Success" "Counterspell();UseSpell(OBSERVER_SOURCE,Target_Arcana_Reaction_InstinctiveCharm,true,true,true);IF(` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:15` | `data "Failure" "ApplyStatus(OBSERVER_SOURCE,INSTINCTIVE_CHARM_UNTARGETABLE, 100, -1);ApplyStatus(OBSERVER_OBSERVER,` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1115` | `new entry "INSTINCTIVE_CHARM_USED_TECH"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1119` | `data "StackId" "INSTINCTIVE_CHARM_USED_TECH"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:24` | `<field name="Success" type="StringTableFieldDefinition" value="Counterspell();UseSpell(OBSERVER_SOURCE,Target_Arcan` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:25` | `<field name="Failure" type="StringTableFieldDefinition" value="ApplyStatus(OBSERVER_SOURCE,INSTINCTIVE_CHARM_UNTARG` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:708` | `<field name="Name" type="NameTableFieldDefinition" value="INSTINCTIVE_CHARM_USED_TECH" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:710` | `<field name="StackId" type="StringTableFieldDefinition" value="INSTINCTIVE_CHARM_USED_TECH" />` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:152` | `used = "INSTINCTIVE_CHARM_USED_TECH", perRound = 1,` |

**`INSTINCTIVE_CHARM_FERVOR`** (6 refs)

Loca: DisplayName=english.xml:945(v1) Description=english.xml:946(v1) (stat entry at Status_BOOST.txt:1101)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:14` | `data "Success" "Counterspell();UseSpell(OBSERVER_SOURCE,Target_Arcana_Reaction_InstinctiveCharm,true,true,true);IF(` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1101` | `new entry "INSTINCTIVE_CHARM_FERVOR"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1107` | `data "StackId" "INSTINCTIVE_CHARM_FERVOR"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:24` | `<field name="Success" type="StringTableFieldDefinition" value="Counterspell();UseSpell(OBSERVER_SOURCE,Target_Arcan` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:692` | `<field name="Name" type="NameTableFieldDefinition" value="INSTINCTIVE_CHARM_FERVOR" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:696` | `<field name="StackId" type="StringTableFieldDefinition" value="INSTINCTIVE_CHARM_FERVOR" />` |

**`ArcanaReactInstinctiveCharm`** (11 refs)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:16` | `data "Cost" "ReactionActionPoint:1;ArcanaReactInstinctiveCharm:1"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1358` | `data "SpellProperties" "ApplyStatus(SELF,INSTINCTIVE_CHARM_READY,100,-1);RestoreResource(SELF,ArcanaReactInstinctiv` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1374` | `data "RequirementConditions" "not HasStatus('ARCANA_WEAVING',context.Source) and not (HasStatus('INSTINCTIVE_CHARM_` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1533` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="ApplyStatus(SELF,INSTINCTIVE_CHARM_READY,100` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1549` | `<field name="RequirementConditions" type="StringTableFieldDefinition" value="not HasStatus('ARCANA_WEAVING',context` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:20` | `<field name="Cost" type="StringTableFieldDefinition" value="ReactionActionPoint:1;ArcanaReactInstinctiveCharm:1" />` |
| Progression | `Editor/Mods/$M/Progressions/Progressions.tbl:560` | `<field name="Boosts" type="StringTableFieldDefinition" value="ActionResource(ArcanaReactInstinctiveCharm,1,0)" />` |
| Progression | `Public/$M/Progressions/Progressions.lsx:420` | `<attribute id="Boosts" type="LSString" value="ActionResource(ArcanaReactInstinctiveCharm,1,0)"/>` -> progression Deceiver L5 ebf883a0-95be-41ea-a91c-792a45548e1c |
| Other | `Editor/Mods/$M/ActionResourceDefinitions/ActionResourceDefinitions.tbl:99` | `<field name="NameFS" type="FixedStringTableFieldDefinition" value="ArcanaReactInstinctiveCharm" />` |
| Other | `Public/$M/ActionResourceDefinitions/ActionResourceDefinitions.lsx:73` | `<attribute id="Name" type="FixedString" value="ArcanaReactInstinctiveCharm"/>` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:151` | `ready = "INSTINCTIVE_CHARM_READY", resource = "ArcanaReactInstinctiveCharm",` |

### B6. Ready: Hollow Image (removed, with passive, interrupt, statuses, resource)

**`Shout_Arcana_Card_Passive_HollowImage`** (12 refs)

Loca: DisplayName=english.xml:863(v1) Description=english.xml:864(v4) (stat entry at Spell_Shout.txt:1420)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1420` | `new entry "Shout_Arcana_Card_Passive_HollowImage"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2140` | `using "Shout_Arcana_Card_Passive_HollowImage"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2141` | `data "RootSpellID" "Shout_Arcana_Card_Passive_HollowImage"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1603` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Passive_HollowImage" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2415` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Shout_Arcana_Card_Passive_HollowImage" />` |
| List | `Editor/Mods/$M/Lists/SpellLists.tbl:155` | `<field name="Spells" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_HostileTakeover;Shout_Arcana` |
| List | `Public/$M/Lists/SpellLists.lsx:114` | `<attribute id="Spells" type="LSString" value="Target_Arcana_Card_Spell_HostileTakeover;Shout_Arcana_Card_Passive_Ho` -> list "Deceiver Level 11" 7134712c-169c-4210-9b13-541e9660392c |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:38` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_HollowImage", "Shout_Arcana_Card_Passive_HollowImage");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:39` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_HollowImage_6", "Shout_Arcana_Card_Passive_HollowImage");` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:71` | `["Shout_Arcana_Card_Passive_HollowImage"] = { aspect = "Deceiver", cost = 3, keywords = { Unique = true } },` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:146` | `["Shout_Arcana_Card_Passive_HollowImage"] = {` |
| LuaTest | `Mods/$M/ScriptExtender/Lua/Tests/ReactionsTest.lua:10` | `local HOLLOW = "Shout_Arcana_Card_Passive_HollowImage"` |

**`Shout_Arcana_Card_Passive_HollowImage_6`** (3 refs)

Loca: - (stat entry at Spell_Shout.txt:2137)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2137` | `new entry "Shout_Arcana_Card_Passive_HollowImage_6"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2413` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Passive_HollowImage_6" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:39` | `DB_ARCANA_CardFamily("Shout_Arcana_Card_Passive_HollowImage_6", "Shout_Arcana_Card_Passive_HollowImage");` |

**`Arcana_Passive_HollowImage`** (4 refs)

Loca: DisplayName=english.xml:726(v2) Description=english.xml:727(v1) (stat entry at Passive.txt:187)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:187` | `new entry "Arcana_Passive_HollowImage"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1161` | `data "Passives" "Arcana_Passive_HollowImage"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:196` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Passive_HollowImage" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:760` | `<field name="Passives" type="StringTableFieldDefinition" value="Arcana_Passive_HollowImage" />` |

**`Interrupt_Arcana_Reaction_HollowImage`** (4 refs)

Loca: DisplayName=english.xml:729(v3) Description=english.xml:789(v1) ExtraDescription=english.xml:790(v1) (stat entry at Interrupt.txt:21)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:21` | `new entry "Interrupt_Arcana_Reaction_HollowImage"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:194` | `data "Boosts" "UnlockInterrupt(Interrupt_Arcana_Reaction_HollowImage);ActionResource(ArcanaReactHollowImage,1,0)"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:33` | `<field name="Name" type="NameTableFieldDefinition" value="Interrupt_Arcana_Reaction_HollowImage" />` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:201` | `<field name="Boosts" type="StringTableFieldDefinition" value="UnlockInterrupt(Interrupt_Arcana_Reaction_HollowImage` |

**`INTERRUPT_HOLLOW_IMAGE`** (4 refs)

Loca: - (stat entry at Status_EFFECT.txt:20)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:31` | `data "Properties" "SetRoll(1);ApplyStatus(INTERRUPT_HOLLOW_IMAGE,100,0);ApplyStatus(OBSERVER_OBSERVER,HOLLOW_IMAGE_` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_EFFECT.txt:20` | `new entry "INTERRUPT_HOLLOW_IMAGE"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:42` | `<field name="Properties" type="StringTableFieldDefinition" value="SetRoll(1);ApplyStatus(INTERRUPT_HOLLOW_IMAGE,100` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_EFFECT.stats:30` | `<field name="Name" type="NameTableFieldDefinition" value="INTERRUPT_HOLLOW_IMAGE" />` |

**`HOLLOW_IMAGE_READY`** (12 refs)

Loca: DisplayName=english.xml:726(v2) Description=english.xml:727(v1) (stat entry at Status_BOOST.txt:1153)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1425` | `data "SpellProperties" "ApplyStatus(SELF,HOLLOW_IMAGE_READY,100,-1);RestoreResource(SELF,ArcanaReactHollowImage,1,0` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1430` | `data "TooltipStatusApply" "ApplyStatus(HOLLOW_IMAGE_READY,100,-1)"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1441` | `data "RequirementConditions" "not HasStatus('ARCANA_WEAVING',context.Source) and not (HasStatus('HOLLOW_IMAGE_READY` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1153` | `new entry "HOLLOW_IMAGE_READY"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1159` | `data "StackId" "HOLLOW_IMAGE_READY"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1606` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="ApplyStatus(SELF,HOLLOW_IMAGE_READY,100,-1);` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1611` | `<field name="TooltipStatusApply" type="StringTableFieldDefinition" value="ApplyStatus(HOLLOW_IMAGE_READY,100,-1)" /` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1622` | `<field name="RequirementConditions" type="StringTableFieldDefinition" value="not HasStatus('ARCANA_WEAVING',context` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:754` | `<field name="Name" type="NameTableFieldDefinition" value="HOLLOW_IMAGE_READY" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:758` | `<field name="StackId" type="StringTableFieldDefinition" value="HOLLOW_IMAGE_READY" />` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:147` | `ready = "HOLLOW_IMAGE_READY", resource = "ArcanaReactHollowImage",` |
| Loca | `Mods/$M/Localization/English/english.xml:864` | `<content contentuid="h5fcbba23g4ed9g4fc2g891eg4b6214a32e28" version="4">Hang an empty likeness at your shoulder. Un` |

**`HOLLOW_IMAGE_USED_TECH`** (7 refs)

Loca: DisplayName=english.xml:910(v1) (stat entry at Status_BOOST.txt:1166)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:31` | `data "Properties" "SetRoll(1);ApplyStatus(INTERRUPT_HOLLOW_IMAGE,100,0);ApplyStatus(OBSERVER_OBSERVER,HOLLOW_IMAGE_` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1166` | `new entry "HOLLOW_IMAGE_USED_TECH"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1170` | `data "StackId" "HOLLOW_IMAGE_USED_TECH"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:42` | `<field name="Properties" type="StringTableFieldDefinition" value="SetRoll(1);ApplyStatus(INTERRUPT_HOLLOW_IMAGE,100` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:769` | `<field name="Name" type="NameTableFieldDefinition" value="HOLLOW_IMAGE_USED_TECH" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:771` | `<field name="StackId" type="StringTableFieldDefinition" value="HOLLOW_IMAGE_USED_TECH" />` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:148` | `used = "HOLLOW_IMAGE_USED_TECH", perRound = 1,` |

**`HOLLOW_IMAGE_INVISIBLE`** (2 refs)

Loca: - (stat entry at Status_INVISIBLE.txt:5)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_INVISIBLE.txt:5` | `new entry "HOLLOW_IMAGE_INVISIBLE"` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_INVISIBLE.stats:13` | `<field name="Name" type="NameTableFieldDefinition" value="HOLLOW_IMAGE_INVISIBLE" />` |

**`ArcanaReactHollowImage`** (17 refs)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:32` | `data "Cost" "ReactionActionPoint:1;ArcanaReactHollowImage:1"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:34` | `data "EnableCondition" "HasActionResource('ArcanaReactHollowImage', 1, 0, false, false, context.Source);"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:194` | `data "Boosts" "UnlockInterrupt(Interrupt_Arcana_Reaction_HollowImage);ActionResource(ArcanaReactHollowImage,1,0)"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1425` | `data "SpellProperties" "ApplyStatus(SELF,HOLLOW_IMAGE_READY,100,-1);RestoreResource(SELF,ArcanaReactHollowImage,1,0` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1441` | `data "RequirementConditions" "not HasStatus('ARCANA_WEAVING',context.Source) and not (HasStatus('HOLLOW_IMAGE_READY` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1606` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="ApplyStatus(SELF,HOLLOW_IMAGE_READY,100,-1);` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1622` | `<field name="RequirementConditions" type="StringTableFieldDefinition" value="not HasStatus('ARCANA_WEAVING',context` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:43` | `<field name="Cost" type="StringTableFieldDefinition" value="ReactionActionPoint:1;ArcanaReactHollowImage:1" />` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:45` | `<field name="EnableCondition" type="StringTableFieldDefinition" value="HasActionResource('ArcanaReactHollowImage', ` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:201` | `<field name="Boosts" type="StringTableFieldDefinition" value="UnlockInterrupt(Interrupt_Arcana_Reaction_HollowImage` |
| Other | `Editor/Mods/$M/ActionResourceDefinitions/ActionResourceDefinitions.tbl:81` | `<field name="NameFS" type="FixedStringTableFieldDefinition" value="ArcanaReactHollowImage" />` |
| Other | `Public/$M/ActionResourceDefinitions/ActionResourceDefinitions.lsx:61` | `<attribute id="Name" type="FixedString" value="ArcanaReactHollowImage"/>` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:147` | `ready = "HOLLOW_IMAGE_READY", resource = "ArcanaReactHollowImage",` |
| LuaTest | `Mods/$M/ScriptExtender/Lua/Tests/ReactionsTest.lua:79` | `T.eq(world.res.ArcanaReactHollowImage, 1, "one a round")` |
| LuaTest | `Mods/$M/ScriptExtender/Lua/Tests/ReactionsTest.lua:81` | `T.eq(world.res.ArcanaReactHollowImage, 0, "spent")` |
| LuaTest | `Mods/$M/ScriptExtender/Lua/Tests/ReactionsTest.lua:83` | `T.eq(world.res.ArcanaReactHollowImage, 0, "still spent this round")` |
| LuaTest | `Mods/$M/ScriptExtender/Lua/Tests/ReactionsTest.lua:85` | `T.eq(world.res.ArcanaReactHollowImage, 1, "back on the owner's turn")` |

### B7. NEMESIS (retired statuses and their passives)

**`NEMESIS`** (11 refs)

Loca: DisplayName=english.xml:711(v1) Description=english.xml:714(v1) (stat entry at Status_BOOST.txt:1230)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:200` | `data "Boosts" "IF((IsCardSpell() or IsArcanaCantrip()) and HasStatus('NEMESIS',context.Target)):Advantage(AttackRol` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:206` | `data "Boosts" "IF((IsCardSpell() or IsArcanaCantrip()) and HasStatus('NEMESIS',context.Target)):Disadvantage(Saving` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:208` | `data "Conditions" "(IsCardSpell() or IsArcanaCantrip()) and HasStatus('NEMESIS',context.Target)"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1230` | `new entry "NEMESIS"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1236` | `data "StackId" "NEMESIS"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:209` | `<field name="Boosts" type="StringTableFieldDefinition" value="IF((IsCardSpell() or IsArcanaCantrip()) and HasStatus` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:218` | `<field name="Boosts" type="StringTableFieldDefinition" value="IF((IsCardSpell() or IsArcanaCantrip()) and HasStatus` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:221` | `<field name="Conditions" type="StringTableFieldDefinition" value="(IsCardSpell() or IsArcanaCantrip()) and HasStatu` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:847` | `<field name="Name" type="NameTableFieldDefinition" value="NEMESIS" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:851` | `<field name="StackId" type="StringTableFieldDefinition" value="NEMESIS" />` |
| Loca | `Mods/$M/Localization/English/english.xml:710` | `<content contentuid="h7ca1779bg251cgd7e9g169cga4bdce93b2c7" version="2">You also mark them as your &lt;LSTag Type="` |

**`NEMESIS_OWNER`** (6 refs)

Loca: DisplayName=english.xml:713(v1) (stat entry at Status_BOOST.txt:873)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:873` | `new entry "NEMESIS_OWNER"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:877` | `data "StackId" "NEMESIS_OWNER"` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:422` | `<field name="Name" type="NameTableFieldDefinition" value="NEMESIS_OWNER" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:424` | `<field name="StackId" type="StringTableFieldDefinition" value="NEMESIS_OWNER" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:50` | `//REGION Copy - acaba o NEMESIS_OWNER, volta ao normal` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:52` | `StatusRemoved((CHARACTER)_Caster, "NEMESIS_OWNER", _, _)` |

**`Arcana_Passive_Nemesis_Owner`** (4 refs)

Loca: DisplayName=english.xml:717(v1) (stat entry at Passive.txt:196)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:196` | `new entry "Arcana_Passive_Nemesis_Owner"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:879` | `data "Passives" "Arcana_Passive_Nemesis_Owner;"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:208` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Passive_Nemesis_Owner" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:426` | `<field name="Passives" type="StringTableFieldDefinition" value="Arcana_Passive_Nemesis_Owner;" />` |

**`Arcana_Passive_Nemesis_Target`** (4 refs)

Loca: DisplayName=english.xml:716(v1) (stat entry at Passive.txt:202)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:202` | `new entry "Arcana_Passive_Nemesis_Target"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1238` | `data "Passives" "Arcana_Passive_Nemesis_Target;"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:217` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Passive_Nemesis_Target" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:853` | `<field name="Passives" type="StringTableFieldDefinition" value="Arcana_Passive_Nemesis_Target;" />` |

### B8. Faceless: Copy EX (already dead data; goal + DB + procs)

**`FACELESS_COPY_EX`** (1 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:62` | `StatusRemoved((CHARACTER)_Caster, "FACELESS_COPY_EX", _, _)` |

**`Target_Arcana_Card_Spell_Faceless_Copy_EX`** (1 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:31` | `DB_ARCANA_CardFamily(_ArcanaSpell, "Target_Arcana_Card_Spell_Faceless_Copy_EX")` |

**`DB_ARCANA_CopyEX_Active`** (6 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:10` | `DB_ARCANA_CopyEX_Active(_Caster, _Old)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:12` | `NOT DB_ARCANA_CopyEX_Active(_Caster, _Old);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:38` | `DB_ARCANA_CopyEX_Active(_Caster, _Target);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:45` | `DB_ARCANA_CopyEX_Active(_Caster, _Target)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:54` | `DB_ARCANA_CopyEX_Active(_Caster, _)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:64` | `DB_ARCANA_CopyEX_Active(_Caster, _)` |

**`PROC_ARCANA_FacelessCopyEX_Clear`** (3 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:8` | `PROC_ARCANA_FacelessCopyEX_Clear((CHARACTER)_Caster)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:18` | `PROC_ARCANA_FacelessCopyEX_Clear(_Caster);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:37` | `PROC_ARCANA_FacelessCopyEX_Clear(_Caster);` |

**`PROC_ARCANA_FacelessCopyEX_End`** (3 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:15` | `PROC_ARCANA_FacelessCopyEX_End((CHARACTER)_Caster)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:56` | `PROC_ARCANA_FacelessCopyEX_End(_Caster);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:66` | `PROC_ARCANA_FacelessCopyEX_End(_Caster);` |

**`ARCANA_FacelessCopyEX_Timer`** (4 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:17` | `RealtimeObjectTimerCancel(_Caster, "ARCANA_FacelessCopyEX_Timer");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:39` | `RealtimeObjectTimerCancel(_Caster, "ARCANA_FacelessCopyEX_Timer");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:40` | `RealtimeObjectTimerLaunch(_Caster, "ARCANA_FacelessCopyEX_Timer", 800);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:43` | `ObjectTimerFinished((CHARACTER)_Caster, "ARCANA_FacelessCopyEX_Timer")` |

**`ARCANA_FacelessCopyEX_Timer2`** (2 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:19` | `RealtimeObjectTimerLaunch(_Caster, "ARCANA_FacelessCopyEX_Timer2", 800);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt:22` | `ObjectTimerFinished((CHARACTER)_Caster, "ARCANA_FacelessCopyEX_Timer2")` |

### B9. Friends: Faux Amis (Friends_EX)

**`Target_Arcana_Util_Friends_EX`** (5 refs)

Loca: DisplayName=english.xml:738(v1) Description=english.xml:744(v1) (stat entry at Spell_Target.txt:1450)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1450` | `new entry "Target_Arcana_Util_Friends_EX"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1462` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Util_Friends_EX" />` |
| List | `Editor/Mods/$M/Lists/SpellLists.tbl:169` | `<field name="Spells" type="StringTableFieldDefinition" value="Target_Arcana_Util_Friends_EX" />` |
| List | `Public/$M/Lists/SpellLists.lsx:124` | `<attribute id="Spells" type="LSString" value="Target_Arcana_Util_Friends_EX"/>` -> list "Deceiver Level 13" 4657a3f6-e7f5-4ac4-b5c4-c0665adcb36d |
| Loca | `Mods/$M/Localization/English/english.xml:734` | `<content contentuid="hfda61488g9163gb8a3ga2c2g4f7401c5be55" version="5">You've become the Aspect of Love.&lt;br&gt;` |

**`FRIENDS_EX`** (8 refs)

Loca: DisplayName=english.xml:736(v1) Description=english.xml:737(v1) (stat entry at Status_BOOST.txt:1212)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1455` | `data "SpellProperties" "ApplyStatus(FRIENDS_EX,100,-1);"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1458` | `data "TooltipStatusApply" "ApplyStatus(FRIENDS_EX,100,-1)"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1212` | `new entry "FRIENDS_EX"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1218` | `data "StackId" "FRIENDS_EX"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1465` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="ApplyStatus(FRIENDS_EX,100,-1);" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1467` | `<field name="TooltipStatusApply" type="StringTableFieldDefinition" value="ApplyStatus(FRIENDS_EX,100,-1)" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:825` | `<field name="Name" type="NameTableFieldDefinition" value="FRIENDS_EX" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:829` | `<field name="StackId" type="StringTableFieldDefinition" value="FRIENDS_EX" />` |

### B10. The clone's Mirror spells and their plumbing

**`Target_Deceiver_Clone_MirrorDistortion`** (9 refs)

Loca: DisplayName=english.xml:212(v1) Description=english.xml:587(v1) (stat entry at Spell_Target.txt:1269)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1489` | `data "FollowUpOriginalSpell" "Target_Deceiver_Clone_MirrorDistortion"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1269` | `new entry "Target_Deceiver_Clone_MirrorDistortion"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1677` | `<field name="FollowUpOriginalSpell" type="StringTableFieldDefinition" value="Target_Deceiver_Clone_MirrorDistortion` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1267` | `<field name="Name" type="NameTableFieldDefinition" value="Deceiver_Clone_MirrorDistortion" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:44` | `RemoveSpell(_Duplicity, "Target_Deceiver_Clone_MirrorDistortion", 0);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:46` | `AddSpell(_Duplicity, "Target_Deceiver_Clone_MirrorDistortion", 0, 0);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:33` | `UsingSpell((CHARACTER)_Caster, "Target_Deceiver_Clone_MirrorDistortion", _, _, _)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:43` | `UsingSpell((CHARACTER)_Caster, "Target_Deceiver_Clone_MirrorDistortion", _, _, _)` |
| LuaTest | `Mods/$M/ScriptExtender/Lua/Tests/UtilTest.lua:19` | `T.eq(U.Category("Target_Deceiver_Clone_MirrorDistortion"), nil)` |

**`Target_Deceiver_Clone_MirrorEtherealChains`** (4 refs)

Loca: DisplayName=english.xml:211(v1) Description=english.xml:542(v2) (stat entry at Spell_Target.txt:1131)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1131` | `new entry "Target_Deceiver_Clone_MirrorEtherealChains"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1117` | `<field name="Name" type="NameTableFieldDefinition" value="Deceiver_Clone_MirrorEtherealChains" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:43` | `RemoveSpell(_Duplicity, "Target_Deceiver_Clone_MirrorEtherealChains", 0);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:45` | `AddSpell(_Duplicity, "Target_Deceiver_Clone_MirrorEtherealChains", 0, 0);` |

**`Projectile_Deceiver_Clone_MirrorSigilofMalice`** (2 refs)

Loca: DisplayName=english.xml:213(v1) Description=english.xml:585(v2) (stat entry at Spell_Projectile.txt:70)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Projectile.txt:70` | `new entry "Projectile_Deceiver_Clone_MirrorSigilofMalice"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Projectile.stats:86` | `<field name="Name" type="NameTableFieldDefinition" value="Deceiver_Clone_MirrorSigilofMalice" />` |

**`Shout_Deceiver_Clone_MirrorWithdraw`** (6 refs)

Loca: DisplayName=english.xml:215(v1) (stat entry at Spell_Shout.txt:1480)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1480` | `new entry "Shout_Deceiver_Clone_MirrorWithdraw"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1671` | `<field name="Name" type="NameTableFieldDefinition" value="Deceiver_Clone_MirrorWithdraw" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:26` | `RemoveSpell(_Caster, "Shout_Deceiver_Clone_MirrorWithdraw", 0);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:38` | `AddSpell(_Caster, "Shout_Deceiver_Clone_MirrorWithdraw", 1, 0);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:70` | `CastSpell((CHARACTER)_Caster, "Shout_Deceiver_Clone_MirrorWithdraw", _, _, _)` |
| Loca | `Mods/$M/Localization/English/english.xml:587` | `<content contentuid="he4a289bcg086cg8355g75bcg04de11ade4d8" version="1">Dash through space with a weakened version ` |

**`Projectile_Arcana_MirrorDistortion_Explosion`** (4 refs)

Loca: - (stat entry at Spell_Projectile.txt:151)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Projectile.txt:151` | `new entry "Projectile_Arcana_MirrorDistortion_Explosion"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1274` | `data "SpellProperties" "GROUND:Summon(SELF,4441890b-a8c1-4c6d-8309-ec505adc7acc,2);GROUND:IF(CanStand('')):Teleport` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Projectile.stats:187` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_MirrorDistortion_Explosion" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1270` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="GROUND:Summon(SELF,4441890b-a8c1-4c6d-8309-e` |

**`MIRROR_DISTORTION_HELPER`** (9 refs)

Loca: DisplayName=english.xml:579(v1) (stat entry at Status_BOOST.txt:1222)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:1485` | `data "SpellProperties" "RemoveStatus(SELF,MIRROR_DISTORTION_HELPER);"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1275` | `data "RequirementConditions" "not HasStatus('MIRROR_DISTORTION_HELPER');"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1222` | `new entry "MIRROR_DISTORTION_HELPER"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1226` | `data "StackId" "MIRROR_DISTORTION_HELPER"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:1676` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="RemoveStatus(SELF,MIRROR_DISTORTION_HELPER);` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1275` | `<field name="RequirementConditions" type="StringTableFieldDefinition" value="not HasStatus('MIRROR_DISTORTION_HELPE` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:837` | `<field name="Name" type="NameTableFieldDefinition" value="MIRROR_DISTORTION_HELPER" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:839` | `<field name="StackId" type="StringTableFieldDefinition" value="MIRROR_DISTORTION_HELPER" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:45` | `ApplyStatus(_Caster, "MIRROR_DISTORTION_HELPER", 12.0, 1, _Caster);` |

**`MIRROR_ETHEREAL_CHAINS`** (12 refs)

Loca: DisplayName=english.xml:214(v1) (stat entry at Status_BOOST.txt:1039)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1137` | `data "SpellSuccess" "ApplyStatus(MIRROR_ETHEREAL_CHAINS,100,1);ApplyStatus(ETHEREAL_CHAINS_EFFECT,100,1);"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1142` | `data "TooltipStatusApply" "ApplyStatus(MIRROR_ETHEREAL_CHAINS,100,1)"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:910` | `data "RemoveConditions" "(IsArcanaSpell() or HasAnyStatus({'ETHEREAL_CHAINS','ETHEREAL_CHAINS_3','ETHEREAL_CHAINS_4` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1039` | `new entry "MIRROR_ETHEREAL_CHAINS"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1045` | `data "StackId" "MIRROR_ETHEREAL_CHAINS"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_EFFECT.txt:14` | `data "RemoveConditions" "not HasAnyStatus({'ETHEREAL_CHAINS','ETHEREAL_CHAINS_3','ETHEREAL_CHAINS_4','ETHEREAL_CHAI` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1120` | `<field name="SpellSuccess" type="StringTableFieldDefinition" value="ApplyStatus(MIRROR_ETHEREAL_CHAINS,100,1);Apply` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1123` | `<field name="TooltipStatusApply" type="StringTableFieldDefinition" value="ApplyStatus(MIRROR_ETHEREAL_CHAINS,100,1)` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:463` | `<field name="RemoveConditions" type="RollConditionsTableFieldDefinition" value="(IsArcanaSpell() or HasAnyStatus({'` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:618` | `<field name="Name" type="NameTableFieldDefinition" value="MIRROR_ETHEREAL_CHAINS" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:622` | `<field name="StackId" type="StringTableFieldDefinition" value="MIRROR_ETHEREAL_CHAINS" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_EFFECT.stats:20` | `<field name="RemoveConditions" type="RollConditionsTableFieldDefinition" value="not HasAnyStatus({'ETHEREAL_CHAINS'` |

**`DB_MirrorWithdraw_Position`** (5 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:10` | `DB_MirrorWithdraw_Position(_Caster, _X, _Y, _Z)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:12` | `NOT DB_MirrorWithdraw_Position(_Caster, _X, _Y, _Z);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:37` | `DB_MirrorWithdraw_Position(_Caster, _X, _Y, _Z);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:52` | `DB_MirrorWithdraw_Position(_Caster, _X, _Y, _Z)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:72` | `DB_MirrorWithdraw_Position(_Caster, _X, _Y, _Z)` |

**`DB_MirrorWithdraw_Marker`** (3 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:17` | `DB_MirrorWithdraw_Marker(_Caster, _Marker)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:20` | `NOT DB_MirrorWithdraw_Marker(_Caster, _Marker);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt:58` | `DB_MirrorWithdraw_Marker(_Caster, _Marker);` |

### B11. Mirror Image, the full clone (replaced by Doubles)

**`Target_Arcana_Card_Spell_MirrorImage`** (13 refs)

Loca: DisplayName=english.xml:55(v3) Description=english.xml:56(v11) (stat entry at Spell_Target.txt:1283)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1283` | `new entry "Target_Arcana_Card_Spell_MirrorImage"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3456` | `using "Target_Arcana_Card_Spell_MirrorImage"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3457` | `data "RootSpellID" "Target_Arcana_Card_Spell_MirrorImage"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3464` | `using "Target_Arcana_Card_Spell_MirrorImage"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3465` | `data "RootSpellID" "Target_Arcana_Card_Spell_MirrorImage"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1283` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_MirrorImage" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3919` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_MirrorImage" />` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3929` | `<field name="RootSpellID" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_MirrorImage" />` |
| List | `Editor/Mods/$M/Lists/SpellLists.tbl:141` | `<field name="Spells" type="StringTableFieldDefinition" value="Target_Arcana_Card_Spell_MirrorImage;Target_Arcana_Cr` |
| List | `Public/$M/Lists/SpellLists.lsx:104` | `<attribute id="Spells" type="LSString" value="Target_Arcana_Card_Spell_MirrorImage;Target_Arcana_Created_Mimic"/>` -> list "Deceiver Level 7" 8163075e-1c66-4173-a15c-2c78a9524021 |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:272` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MirrorImage", "Target_Arcana_Card_Spell_MirrorImage");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:273` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MirrorImage_5", "Target_Arcana_Card_Spell_MirrorImage");` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:274` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MirrorImage_6", "Target_Arcana_Card_Spell_MirrorImage");` |

**`Target_Arcana_Card_Spell_MirrorImage_5`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3453)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3453` | `new entry "Target_Arcana_Card_Spell_MirrorImage_5"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3917` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_MirrorImage_5" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:273` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MirrorImage_5", "Target_Arcana_Card_Spell_MirrorImage");` |

**`Target_Arcana_Card_Spell_MirrorImage_6`** (3 refs)

Loca: - (stat entry at Spell_Target.txt:3461)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:3461` | `new entry "Target_Arcana_Card_Spell_MirrorImage_6"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:3927` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Card_Spell_MirrorImage_6" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:274` | `DB_ARCANA_CardFamily("Target_Arcana_Card_Spell_MirrorImage_6", "Target_Arcana_Card_Spell_MirrorImage");` |

**`MIRROR_IMAGE_TECHNICAL`** (7 refs)

Loca: DisplayName=english.xml:658(v1) (stat entry at Status_INVISIBLE.txt:18)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1288` | `data "SpellProperties" "GROUND:Summon(8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8,-1,,,CreateCloneStack1,MIRROR_IMAGE_TECH` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_INVISIBLE.txt:18` | `new entry "MIRROR_IMAGE_TECHNICAL"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1284` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="GROUND:Summon(8807d230-d0f5-4aa5-b6e4-4b36e9` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_INVISIBLE.stats:28` | `<field name="Name" type="NameTableFieldDefinition" value="MIRROR_IMAGE_TECHNICAL" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:12` | `StatusApplied(_Duplicity, "MIRROR_IMAGE_TECHNICAL", _Player, _)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:51` | `RemoveStatus(_Duplicity, "MIRROR_IMAGE_TECHNICAL", _Player);` |
| Loca | `Mods/$M/Localization/English/english.xml:658` | `<content contentuid="h784131eeg4b49g41f3g2db9ge081041f4762" version="1">MIRROR_IMAGE_TECHNICAL</content>` |

**`MIRROR_IMAGE_CLONE_SCALING`** (4 refs)

Loca: - (stat entry at Status_BOOST.txt:1197)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Target.txt:1288` | `data "SpellProperties" "GROUND:Summon(8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8,-1,,,CreateCloneStack1,MIRROR_IMAGE_TECH` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:1197` | `new entry "MIRROR_IMAGE_CLONE_SCALING"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Target.stats:1284` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="GROUND:Summon(8807d230-d0f5-4aa5-b6e4-4b36e9` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:806` | `<field name="Name" type="NameTableFieldDefinition" value="MIRROR_IMAGE_CLONE_SCALING" />` |

**`Clone_1`** (2 refs)

Loca: - (stat entry at Character.txt:1)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Character.txt:1` | `new entry "Clone_1"` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Character.stats:7` | `<field name="Name" type="NameTableFieldDefinition" value="Clone_1" />` |

**`DB_MirrorImage`** (6 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:4` | `DB_MirrorImage((CHARACTER)00000000-0000-0000-0000-000000000000, (CHARACTER)00000000-0000-0000-0000-000000000000);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:5` | `NOT DB_MirrorImage((CHARACTER)00000000-0000-0000-0000-000000000000, (CHARACTER)00000000-0000-0000-0000-000000000000` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:17` | `DB_MirrorImage((CHARACTER)_Duplicity, (CHARACTER)_Player);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:24` | `DB_MirrorImage((CHARACTER)_Duplicity, (CHARACTER)_Player)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:35` | `DB_MirrorImage((CHARACTER)_Duplicity, (CHARACTER)_Player)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:52` | `NOT DB_MirrorImage((CHARACTER)_Duplicity, (CHARACTER)_Player);` |

**`DB_OriginalPlayerLevel`** (6 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:6` | `DB_OriginalPlayerLevel((CHARACTER)00000000-0000-0000-0000-000000000000, 0);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:7` | `NOT DB_OriginalPlayerLevel((CHARACTER)00000000-0000-0000-0000-000000000000, 0);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:16` | `DB_OriginalPlayerLevel((CHARACTER)_Duplicity, _Level);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:26` | `DB_OriginalPlayerLevel((CHARACTER)_Duplicity, _Level)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:37` | `DB_OriginalPlayerLevel((CHARACTER)_Duplicity, _Level)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:53` | `NOT DB_OriginalPlayerLevel((CHARACTER)_Duplicity, _Level);` |

**`DB_ARCANA_MirrorImageOf`** (11 refs)

| Layer | File:line | Text |
|---|---|---|
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:8` | `DB_ARCANA_MirrorImageOf((CHARACTER)00000000-0000-0000-0000-000000000000, (CHARACTER)00000000-0000-0000-0000-0000000` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:9` | `NOT DB_ARCANA_MirrorImageOf((CHARACTER)00000000-0000-0000-0000-000000000000, (CHARACTER)00000000-0000-0000-0000-000` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:18` | `DB_ARCANA_MirrorImageOf((CHARACTER)_Duplicity, (CHARACTER)_Player);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:58` | `DB_ARCANA_MirrorImageOf((CHARACTER)_Duplicity, (CHARACTER)_Player)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:60` | `NOT DB_ARCANA_MirrorImageOf((CHARACTER)_Duplicity, (CHARACTER)_Player);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:65` | `DB_ARCANA_MirrorImageOf((CHARACTER)_Duplicity, (CHARACTER)_Player)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:67` | `NOT DB_ARCANA_MirrorImageOf((CHARACTER)_Duplicity, (CHARACTER)_Player);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:72` | `DB_ARCANA_MirrorImageOf((CHARACTER)_Duplicity, (CHARACTER)_Player)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt:74` | `NOT DB_ARCANA_MirrorImageOf((CHARACTER)_Duplicity, (CHARACTER)_Player);` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Status_Sigil.txt:13` | `DB_ARCANA_MirrorImageOf((CHARACTER)_Caster, _Owner)` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Status_Sigil.txt:22` | `NOT DB_ARCANA_MirrorImageOf((CHARACTER)_Caster, _)` |

### B12. Heartbreak and Beloved (Aspect card and Tier III interrupt; Beloved is NOT in the plan list)

**`Shout_Arcana_Created_Aspect_Heartbreak`** (8 refs)

Loca: DisplayName=english.xml:941(v1) Description=english.xml:942(v2) (stat entry at Spell_Shout.txt:2044)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2044` | `new entry "Shout_Arcana_Created_Aspect_Heartbreak"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:2311` | `data "Boosts" "UnlockSpell(Shout_Arcana_Created_Aspect_Heartbreak);"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2287` | `<field name="Name" type="NameTableFieldDefinition" value="Arcana_Created_Aspect_Heartbreak" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:2094` | `<field name="Boosts" type="StringTableFieldDefinition" value="UnlockSpell(Shout_Arcana_Created_Aspect_Heartbreak);"` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt:134` | `DB_ARCANA_CardFamily("Shout_Arcana_Created_Aspect_Heartbreak", "Shout_Arcana_Created_Aspect_Heartbreak");` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:113` | `["Shout_Arcana_Created_Aspect_Heartbreak"] = { aspect = "Deceiver" },` |
| Lua | `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua:128` | `ASPECT_AWAKENED_EMPRESS = { id = "Shout_Arcana_Created_Aspect_Heartbreak", lasts = 99 },` |
| LuaTest | `Mods/$M/ScriptExtender/Lua/Tests/KeywordsTest.lua:108` | `ASPECT_AWAKENED_EMPRESS = "Shout_Arcana_Created_Aspect_Heartbreak",` |

**`HEARTBREAK_TECH`** (7 refs)

Loca: DisplayName=english.xml:910(v1) (stat entry at Status_BOOST.txt:2360)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Spell_Shout.txt:2050` | `data "SpellProperties" "ApplyStatus(HEARTBREAK_TECH,100,1);DealDamage(LevelMapValue(D4Cantrip),Psychic,Magical);IF(` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:2360` | `new entry "HEARTBREAK_TECH"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Status_BOOST.txt:2364` | `data "StackId" "HEARTBREAK_TECH"` |
| Stats.stats | `Editor/Mods/$M/Stats/SpellData/Shout.stats:2291` | `<field name="SpellProperties" type="StringTableFieldDefinition" value="ApplyStatus(HEARTBREAK_TECH,100,1);DealDamag` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:2153` | `<field name="Name" type="NameTableFieldDefinition" value="HEARTBREAK_TECH" />` |
| Stats.stats | `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats:2155` | `<field name="StackId" type="StringTableFieldDefinition" value="HEARTBREAK_TECH" />` |
| Osiris | `Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Empress.txt:49` | `HasActiveStatus(_From, "HEARTBREAK_TECH", 0)` |

**`Interrupt_Arcana_Aspect_Beloved`** (4 refs)

Loca: DisplayName=english.xml:939(v1) Description=english.xml:940(v2) (stat entry at Interrupt.txt:87)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:87` | `new entry "Interrupt_Arcana_Aspect_Beloved"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:523` | `data "Boosts" "Ability(Charisma,3);UnlockInterrupt(Interrupt_Arcana_Aspect_Beloved);ActionResource(ArcanaBeloved,1,` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:117` | `<field name="Name" type="NameTableFieldDefinition" value="Interrupt_Arcana_Aspect_Beloved" />` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:657` | `<field name="Boosts" type="StringTableFieldDefinition" value="Ability(Charisma,3);UnlockInterrupt(Interrupt_Arcana_` |

**`ArcanaBeloved`** (9 refs)

| Layer | File:line | Text |
|---|---|---|
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:98` | `data "Cost" "ArcanaBeloved:1"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Interrupt.txt:100` | `data "EnableCondition" "HasActionResource('ArcanaBeloved', 1, 0, false, false, context.Source);"` |
| Stats.txt | `Public/$M/Stats/Generated/Data/Passive.txt:523` | `data "Boosts" "Ability(Charisma,3);UnlockInterrupt(Interrupt_Arcana_Aspect_Beloved);ActionResource(ArcanaBeloved,1,` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:127` | `<field name="Cost" type="StringTableFieldDefinition" value="ArcanaBeloved:1" />` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Interrupt.stats:129` | `<field name="EnableCondition" type="StringTableFieldDefinition" value="HasActionResource('ArcanaBeloved', 1, 0, fal` |
| Stats.stats | `Editor/Mods/$M/Stats/Stats/Passive.stats:657` | `<field name="Boosts" type="StringTableFieldDefinition" value="Ability(Charisma,3);UnlockInterrupt(Interrupt_Arcana_` |
| Other | `Editor/Mods/$M/ActionResourceDefinitions/ActionResourceDefinitions.tbl:115` | `<field name="Name" type="NameTableFieldDefinition" value="ArcanaBeloved" />` |
| Other | `Editor/Mods/$M/ActionResourceDefinitions/ActionResourceDefinitions.tbl:117` | `<field name="NameFS" type="FixedStringTableFieldDefinition" value="ArcanaBeloved" />` |
| Other | `Public/$M/ActionResourceDefinitions/ActionResourceDefinitions.lsx:85` | `<attribute id="Name" type="FixedString" value="ArcanaBeloved"/>` |

### B13. Summary by file (removed set)

| File | refs |
|---|---|
| `Public/$M/Stats/Generated/Data/Spell_Target.txt` | 56 |
| `Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt` | 44 |
| `Editor/Mods/$M/Stats/SpellData/Target.stats` | 43 |
| `Public/$M/Stats/Generated/Data/Spell_Shout.txt` | 32 |
| `Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats` | 29 |
| `Public/$M/Stats/Generated/Data/Status_BOOST.txt` | 29 |
| `Editor/Mods/$M/Stats/SpellData/Shout.stats` | 27 |
| `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorImage.txt` | 27 |
| `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_FacelessCopy_EX.txt` | 22 |
| `Editor/Mods/$M/Stats/Stats/Interrupt.stats` | 14 |
| `Mods/$M/Story/RawFiles/Goals/ARCANA_Spell_MirrorWithdraw.txt` | 14 |
| `Public/$M/Stats/Generated/Data/Interrupt.txt` | 14 |
| `Mods/$M/ScriptExtender/Lua/Server/Cards/CardDB.lua` | 13 |
| `Editor/Mods/$M/Stats/Stats/Passive.stats` | 12 |
| `Public/$M/Stats/Generated/Data/Passive.txt` | 12 |
| `Editor/Mods/$M/Lists/SpellLists.tbl` | 8 |
| `Public/$M/Lists/SpellLists.lsx` | 8 |
| `Mods/$M/Localization/English/english.xml` | 6 |
| `Mods/$M/ScriptExtender/Lua/Tests/ReactionsTest.lua` | 5 |
| `Editor/Mods/$M/ActionResourceDefinitions/ActionResourceDefinitions.tbl` | 4 |
| `Public/$M/ActionResourceDefinitions/ActionResourceDefinitions.lsx` | 3 |
| `Editor/Mods/$M/Stats/SpellData/Projectile.stats` | 2 |
| `Editor/Mods/$M/Stats/StatusData/Status_EFFECT.stats` | 2 |
| `Editor/Mods/$M/Stats/StatusData/Status_INVISIBLE.stats` | 2 |
| `Mods/$M/Story/RawFiles/Goals/ARCANA_Status_Sigil.txt` | 2 |
| `Public/$M/Stats/Generated/Data/Spell_Projectile.txt` | 2 |
| `Public/$M/Stats/Generated/Data/Status_EFFECT.txt` | 2 |
| `Public/$M/Stats/Generated/Data/Status_INVISIBLE.txt` | 2 |
| `Editor/Mods/$M/Progressions/Progressions.tbl` | 1 |
| `Editor/Mods/$M/Stats/Stats/Character.stats` | 1 |
| `Mods/$M/ScriptExtender/Lua/Tests/DestinationTest.lua` | 1 |
| `Mods/$M/ScriptExtender/Lua/Tests/KeywordsTest.lua` | 1 |
| `Mods/$M/ScriptExtender/Lua/Tests/UtilTest.lua` | 1 |
| `Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Empress.txt` | 1 |
| `Public/$M/Progressions/Progressions.lsx` | 1 |
| `Public/$M/Stats/Generated/Data/Character.txt` | 1 |

Total: **71 ids with at least one hit, 444 id-to-line references** across 36 files (a line naming two removed ids counts twice).

### B14. english.xml: strings that name the removed ids, orphans, and the Empress/Love text

`Mods/$M/Localization/English/english.xml` (line numbers). "Orphan" = the handle is not used by any text file of the mod (stats, lists, progressions, lsx); it may still be used by a binary `.lsf` (RootTemplates), so check before deleting.

| Line | Text (start) | Status |
|---|---|---|
| 57 | `Clone` (handle h7ce24c2b...) | orphan in text; it is the DisplayName of RootTemplate 8807d230 (ARCANA_CHAR_CreateClone_1), read from the converted LSF (version 39) |
| 732 | `Clone` (h091e2391..., v4) | orphan in text; DisplayName of the unused RootTemplate 4267f207 (CreateClone_2) |
| 199-201 | `Maintain Hypnotic Gaze` strings (LSTag `Target_HypnoticGaze_Maintain`, `Target_HypnoticGaze`) | orphan; old Hypnotic Gaze design |
| 575-577 | `Mirror Withdraw Timer`, `Mimic Withdraw Timer`, `Withdraw Timer` | orphan |
| 587 | `Dash through space with a weakened version of ...Distortion...` (LSTag to Target_Arcana_Card_Spell_Distortion and to Shout_Deceiver_Clone_MirrorWithdraw) | live; the Description of `Target_Deceiver_Clone_MirrorDistortion`, removed with it |
| 579, 211-215, 542, 585 | `Mirror: Distortion` helper status, `Mirror: Ethereal Chains / Sigil of Malice / Withdraw` names and descriptions | live; clone Mirror spells and MIRROR_* statuses |
| 658 | MIRROR_IMAGE_TECHNICAL DisplayName | live; removed with the status |
| 710-717 | `Nemesis` strings (Deceiver's Nemesis, Nemesis Helper, Nemesis Owner, Nemesis Target x2, "You also mark them as your Nemesis") | 711, 713, 714, 716, 717 live (NEMESIS, NEMESIS_OWNER, the two passives); 710, 712 orphan |
| 718-719 | `Hostile Takeover: Coup d'Etat` + "They are also marked with Sigil" | orphan (old EX) |
| 721-722, 725, 728 | `Hollow Image: Final Veil` x2 and "also mark them with Sigil, and become Invisible" | orphan (old EX) |
| 726-727, 729 | `Hollow Image` (+ description) | live: Arcana_Passive_HollowImage / HOLLOW_IMAGE_READY / Interrupt (726, 727 = passive+status; 729 = interrupt DisplayName) |
| 730-731 | `Mirror Image: Hall of Mirrors`, "Create another duplicate." | orphan (old EX) |
| 733, 798, 799, 803 | `3 - The Empress` | orphan copies |
| 734 | `You've become the Aspect of Love...` with LSTag `Target_Arcana_Util_Friends_EX` | orphan, but it names the Friends_EX id (old Tier III text) |
| 736-738, 744 | `Friends: Faux Amis` (status + spell), their descriptions | live: FRIENDS_EX / Target_Arcana_Util_Friends_EX |
| 741 | `The Empress Tech` | orphan |
| 861-864 | `Ready: Instinctive Charm` / `Ready: Hollow Image` + descriptions (cards) | live; removed |
| 941-942 | `Heartbreak` + description (LSTag SIGIL) | live; replaced by The Veil Lifts |
| 939-940 | Beloved interrupt DisplayName/Description ("Once per round, when an enemy attacks you, it must succeed a Wisdom Saving Throw ... Charmed") | live; replaced by Which One? |
| 945-946 | `Infatuated` (INSTINCTIVE_CHARM_FERVOR) + description | live; removed |

Live Empress / Love text that has to be re-worded for High Priestess / Doubt (stay, but text changes):

| Line | Text | Used by |
|---|---|---|
| 929-930 | `Obsession` + description | Arcana_Passive_Aspect_Empress_I |
| 931-932 | Tier II name + description | Arcana_Passive_Aspect_Empress_II (`Devotion`, handle h3c52bd83) |
| 933-934 | `Aspect of Love` + description | Arcana_Passive_Aspect_Empress_III (+ _Awakened_III, _Damage) |
| 935-936 | `3 - The Empress` / `Awakened as the Aspect of Love until combat ends.` | ASPECT_AWAKENED_EMPRESS |
| 937-938 | progress status name + description | ASPECT_PROGRESS_EMPRESS |
| 993-994 | `3 - The Empress: Awakening` + "Detonate your Sigils during a fight to awaken the Aspect of Love..." | Arcana_Passive_Aspect_Empress_Awakening |
| 1011-1016 | `3 - The Empress: Awakened I/II/III` + Obsession/Devotion/Aspect texts | ASPECT_AWAKENED_EMPRESS_I/II/III |
| 52 | SIGIL description (v10) | SIGIL |
| 359, 368, 454, 182, 32 | `The Deceiver`, class description, subclass flavour | ClassDescriptions / Progressions |
| 842 | "One marked by the Lady of Mysteries, and bound to the secrets she keeps." | already mentions the Lady of Mysteries (base-class text) |


### B15. Ids that STAY but whose references must change (compact map)

Same search. Cells are `file:line,line`. The `Stats.txt` and `Stats.stats` rows describe the same entries (game side / Toolkit side). `DB_ARCANA_CardFamily` lines in `ARCANA_CardFamilies.txt` are generated (see F) and shown only as a count.

| id | refs by layer (file:lines) |
|---|---|
| `Target_Arcana_Card_Spell_Distortion` | Stats.txt Spell_Shout.txt:1418 Spell_Target.txt:1227,1258,2704,2705,2714,2715,2724,2725 ; Stats.stats Shout.stats:1596 Target.stats:1221,2999,3011,3023 ; List SpellLists.lsx:99 SpellLists.tbl:134 ; Osiris ARCANA_Spell_Withdraw.txt:35,47 ; Lua CardDB.lua:15 ; LuaTest CardDBTest.lua:23,32,55 KeywordsTest.lua:15 UtilTest.lua:9,13 ; Loca english.xml:586,587 ; CardFamilies x4 |
| `Target_Arcana_Card_Spell_Distortion_4` | Stats.txt Spell_Target.txt:2701 ; Stats.stats Target.stats:2997 ; CardFamilies x1 |
| `Target_Arcana_Card_Spell_Distortion_5` | Stats.txt Spell_Target.txt:2711 ; Stats.stats Target.stats:3009 ; LuaTest UtilTest.lua:8 ; CardFamilies x1 |
| `Target_Arcana_Card_Spell_Distortion_6` | Stats.txt Spell_Target.txt:2721 ; Stats.stats Target.stats:3021 ; CardFamilies x1 |
| `Projectile_Arcana_Distortion_Explosion` | Stats.txt Spell_Projectile.txt:86,106,112,118,124 Spell_Target.txt:1232 ; Stats.stats Projectile.stats:104 Target.stats:1222 ; LuaTest UtilTest.lua:20 |
| `Projectile_Arcana_Distortion_Explosion_4` | Stats.txt Spell_Projectile.txt:103 Spell_Target.txt:2708 ; Stats.stats Projectile.stats:123 Target.stats:3003 |
| `Projectile_Arcana_Distortion_Explosion_5` | Stats.txt Spell_Projectile.txt:109 Spell_Target.txt:2718 ; Stats.stats Projectile.stats:131 Target.stats:3015 |
| `Projectile_Arcana_Distortion_Explosion_6` | Stats.txt Spell_Projectile.txt:115 Spell_Target.txt:2728 ; Stats.stats Projectile.stats:139 Target.stats:3027 |
| `DISTORTION_HELPER` | Stats.txt Spell_Shout.txt:1402 Spell_Target.txt:1235 Status_BOOST.txt:1134,1138 ; Stats.stats Shout.stats:1595 Status_BOOST.stats:731,733 Target.stats:1245 ; Osiris ARCANA_Spell_Withdraw.txt:49 |
| `DISTORTION_LAST_CASTED` | Stats.txt Spell_Target.txt:1232,1262,2708,2718,2728 Status_BOOST.txt:1142 ; Stats.stats Status_BOOST.stats:741 Target.stats:1222,1260,3003,3015,3027 |
| `Shout_Arcana_Created_Withdraw` | Stats.txt Spell_Shout.txt:1398,1475,2735,2736,2743,2744,2751,2752,2759,2760 ; Stats.stats Shout.stats:1579,3150,3160,3170,3180 ; Osiris ARCANA_Spell_Withdraw.txt:26,40,76 ; Lua CardDB.lua:19,55 ; LuaTest CardDBTest.lua:25,57 KeywordsTest.lua:16 UtilTest.lua:14 ; Loca english.xml:66 ; CardFamilies x5 |
| `Shout_Arcana_Created_Withdraw_3` | Stats.txt Spell_Shout.txt:2732 ; Stats.stats Shout.stats:3148 ; CardFamilies x1 |
| `Shout_Arcana_Created_Withdraw_4` | Stats.txt Spell_Shout.txt:2740 ; Stats.stats Shout.stats:3158 ; CardFamilies x1 |
| `Shout_Arcana_Created_Withdraw_5` | Stats.txt Spell_Shout.txt:2748 ; Stats.stats Shout.stats:3168 ; CardFamilies x1 |
| `Shout_Arcana_Created_Withdraw_6` | Stats.txt Spell_Shout.txt:2756 ; Stats.stats Shout.stats:3178 ; CardFamilies x1 |
| `Shout_Arcana_Created_MimicWithdraw` | Stats.txt Spell_Shout.txt:1472,1483 ; Stats.stats Shout.stats:1661 ; Osiris ARCANA_Spell_MimicWithdraw.txt:26,40,76 ; Lua CardDB.lua:26,56 ; Loca english.xml:586 ; CardFamilies x1 |
| `Target_Arcana_Created_MimicDistortion` | Stats.txt Spell_Shout.txt:1478 Spell_Target.txt:1255,1272,1410,3701,3702,3711,3712,3721,3722 ; Stats.stats Shout.stats:1665 Target.stats:1251,1414,4214,4226,4238 ; Osiris ARCANA_Spell_MimicWithdraw.txt:35,47 ; Lua CardDB.lua:20,23,164 ; LuaTest CardDBTest.lua:26 KeywordsTest.lua:17 SyncTest.lua:6 ; CardFamilies x4 |
| `Target_Arcana_Created_MimicDistortion_4` | Stats.txt Spell_Target.txt:3698 ; Stats.stats Target.stats:4212 ; CardFamilies x1 |
| `Target_Arcana_Created_MimicDistortion_5` | Stats.txt Spell_Target.txt:3708 ; Stats.stats Target.stats:4224 ; CardFamilies x1 |
| `Target_Arcana_Created_MimicDistortion_6` | Stats.txt Spell_Target.txt:3718 ; Stats.stats Target.stats:4236 ; CardFamilies x1 |
| `MIMIC_DISTORTION_HELPER` | Stats.txt Spell_Shout.txt:1476 Spell_Target.txt:1262 Status_BOOST.txt:1204,1208 ; Stats.stats Shout.stats:1664 Status_BOOST.stats:815,817 Target.stats:1260 ; Osiris ARCANA_Spell_MimicWithdraw.txt:49 |
| `MIMIC_ETHEREAL_CHAINS` | Stats.txt Spell_Target.txt:1123,1127 Status_BOOST.txt:910,982,989,997,1006,1015,1024,1033,1042 Status_EFFECT.txt:14 ; Stats.stats Status_BOOST.stats:463,549,553 Status_EFFECT.stats:20 Target.stats:1104,1107 |
| `Target_Arcana_Created_Mimic` | Stats.txt Spell_Projectile.txt:59 Spell_Target.txt:1121,1260,1405 ; Stats.stats Projectile.stats:71 Target.stats:1103,1254,1413 ; List SpellLists.lsx:104 SpellLists.tbl:141 ; Lua CardDB.lua:52,161 ; LuaTest SyncTest.lua:6 ; CardFamilies x1 |
| `Projectile_Arcana_Card_Spell_SigilofMalice` | Stats.txt Spell_Projectile.txt:10,48,57,263,264,274,275,285,286,296,297,307,308 ; Stats.stats Projectile.stats:20,316,329,342,355,368 ; List SpellLists.lsx:89 SpellLists.tbl:120 ; Lua CardDB.lua:28 Overhead.lua:17 ; LuaTest CardDBTest.lua:13,21 OverheadTest.lua:7 ; Loca english.xml:189,585 ; CardFamilies x6 |
| `Projectile_Arcana_Card_Spell_SigilofMalice_2` | Stats.txt Spell_Projectile.txt:260 ; Stats.stats Projectile.stats:314 ; CardFamilies x1 |
| `Projectile_Arcana_Card_Spell_SigilofMalice_3` | Stats.txt Spell_Projectile.txt:271 ; Stats.stats Projectile.stats:327 ; CardFamilies x1 |
| `Projectile_Arcana_Card_Spell_SigilofMalice_4` | Stats.txt Spell_Projectile.txt:282 ; Stats.stats Projectile.stats:340 ; CardFamilies x1 |
| `Projectile_Arcana_Card_Spell_SigilofMalice_5` | Stats.txt Spell_Projectile.txt:293 ; Stats.stats Projectile.stats:353 ; CardFamilies x1 |
| `Projectile_Arcana_Card_Spell_SigilofMalice_6` | Stats.txt Spell_Projectile.txt:304 ; Stats.stats Projectile.stats:366 ; CardFamilies x1 |
| `Projectile_Arcana_Created_MimicSigilofMalice` | Stats.txt Spell_Projectile.txt:54,73,368,369,379,380,390,391 Spell_Target.txt:1410 ; Stats.stats Projectile.stats:68,441,454,467 Target.stats:1414 ; Lua CardDB.lua:31,53,162 ; CardFamilies x4 |
| `SIGIL` | Stats.txt Spell_Shout.txt:2052 Spell_Target.txt:1052 Status_BOOST.txt:900,907,909,910 ; Stats.stats Shout.stats:2293 Status_BOOST.stats:453,457,463,465 Target.stats:1030 ; Osiris ARCANA_Aspect_Empress.txt:7,11,13,75,107 ARCANA_Status_Sigil.txt:6,7,15,17,24,26 ; Khonsu IsArcanaSpell.khn:7 ; Loca english.xml:54,189,552,585,714,719,722,930,932,942,994,1012,1014,1016 |
| `SIGIL_TECH` | Stats.txt Passive.txt:209 Spell_Projectile.txt:15,49,60,75,267,278,289,300,311,372,383,394 Status_BOOST.txt:1068,1073 ; Stats.stats Passive.stats:222 Projectile.stats:21,59,72,89,320,333,346,359,372,445,458,471 Status_BOOST.stats:653,656 ; Osiris ARCANA_Status_Sigil.txt:11,20 |
| `SIGIL_DETONATED_TECH` | Stats.txt Status_BOOST.txt:912,1049,1053 ; Stats.stats Status_BOOST.stats:464,630,632 ; Osiris ARCANA_Aspect_Empress.txt:7,32 |
| `SIGIL_OF_MALICE_LAST_CASTED` | Stats.txt Spell_Projectile.txt:15,49,67,267,278,289,300,311 Status_BOOST.txt:1057 ; Stats.stats Projectile.stats:21,59,80,320,333,346,359,372 Status_BOOST.stats:640 |
| `Target_Arcana_Card_Spell_MaliciousWhispers` | Stats.txt Spell_Target.txt:1045 ; Stats.stats Target.stats:1025 ; List SpellLists.lsx:89 SpellLists.tbl:120 ; Lua CardDB.lua:64 ; LuaTest CardDBTest.lua:35 ; Khonsu IsArcanaCantrip.khn:6 ; CardFamilies x1 |
| `Target_Arcana_Card_Spell_Marionette` | Stats.txt Spell_Target.txt:1339,3416,3417 ; Stats.stats Target.stats:1343,3869 ; List SpellLists.lsx:109 SpellLists.tbl:148 ; Lua CardDB.lua:75 ; LuaTest DestinationTest.lua:69 ; CardFamilies x2 |
| `Target_Arcana_Card_Spell_Marionette_6` | Stats.txt Spell_Target.txt:3413 ; Stats.stats Target.stats:3867 ; CardFamilies x1 |
| `Target_Arcana_Util_Friends` | Stats.txt Passive.txt:167 Spell_Target.txt:1421,1453,1461 ; Stats.stats Passive.stats:165 Target.stats:1431,1470 ; Khonsu IsArcanaCantrip.khn:5 |
| `Arcana_Passive_UnlockFriends` | Stats.txt Passive.txt:162 ; Stats.stats Passive.stats:162 ; Progression Progressions.lsx:536 Progressions.tbl:718 |
| `Shout_Arcana_Util_Faceless` | Stats.txt Spell_Shout.txt:767,797,814,831,848,865,882,899,916,933,950,967,984,1001,1018,1035,1052,1069,1086,1103,1120,1137,1154,1171,1188,1205,1222,1239,1256,1273,1290,1307,1324,1351 Spell_Target.txt:1021 ; Stats.stats Shout.stats:876,906,925,944,963,982,1001,1020,1039,1058,1077,1096,1115,1134,1153,1172,1191,1210,1229,1248,1267,1286,1305,1324,1343,1362,1381,1400,1419,1438,1457,1476,1495,1517 Target.stats:1014 ; List SpellLists.lsx:89 SpellLists.tbl:120 ; LuaTest CardDBTest.lua:31 UtilTest.lua:15 ; Khonsu IsArcanaCantrip.khn:4 |
| `Shout_Arcana_Util_Faceless_Cancel` | Stats.txt Spell_Shout.txt:1336 Status_POLYMORPHED.txt:12,20,27,34,41,48,55,62,69,76,83,90,97,104,111,118,125,132,139,146,153,160,167,174,181,188,195,202,209,216,223,230,237 ; Stats.stats Shout.stats:1511 Status_POLYMORPHED.stats:17,28,37,46,55,64,73,82,91,100,109,118,127,136,145,154,163,172,181,190,199,208,217,226,235,244,253,262,271,280,289,298,307 ; Osiris ARCANA_Spell_FacelessCopy_EX.txt:57 |
| `Target_Arcana_Util_Faceless_Copy` | Stats.txt Spell_Shout.txt:772 Spell_Target.txt:1016 ; Stats.stats Shout.stats:877 Target.stats:994 ; Osiris ARCANA_Spell_FacelessCopy.txt:24 ; LuaTest CardDBTest.lua:30 |
| `FACELESS_COPY` | Stats.txt Spell_Shout.txt:777 Spell_Target.txt:1022 Status_POLYMORPHED.txt:6 ; Stats.stats Shout.stats:897 Status_POLYMORPHED.stats:14 Target.stats:1018 ; Osiris ARCANA_Spell_FacelessCopy.txt:45 |
| `Shout_Deceiver_Clone_Dismiss` | Stats.txt Spell_Shout.txt:1466 ; Stats.stats Shout.stats:1653 ; Osiris ARCANA_Spell_MirrorImage.txt:50,70 |
| `Arcana_Passive_Telepathy` | Stats.txt Passive.txt:153 ; Stats.stats Passive.stats:150 ; Progression Progressions.lsx:379,390 Progressions.tbl:500,515 |
| `ASPECT_AWAKENED_EMPRESS` | Stats.txt Status_BOOST.txt:909,2303,2309 ; Stats.stats Status_BOOST.stats:465,2088,2092 ; Osiris ARCANA_Aspect_Common.txt:43 ; Lua CardDB.lua:128 ; LuaTest KeywordsTest.lua:108 |
| `ASPECT_AWAKENED_EMPRESS_I` | Stats.txt Status_BOOST.txt:2314,2318 ; Stats.stats Status_BOOST.stats:2099,2105 ; Osiris ARCANA_Aspect_Common.txt:51 |
| `ASPECT_AWAKENED_EMPRESS_II` | Stats.txt Status_BOOST.txt:2314,2331 ; Stats.stats Status_BOOST.stats:2099,2120 ; Osiris ARCANA_Aspect_Common.txt:52 |
| `ASPECT_AWAKENED_EMPRESS_III` | Stats.txt Status_BOOST.txt:2314,2345 ; Stats.stats Status_BOOST.stats:2099,2136 ; Osiris ARCANA_Aspect_Common.txt:53 |
| `ASPECT_PROGRESS_EMPRESS` | Stats.txt Status_BOOST.txt:2561,2567 ; Stats.stats Status_BOOST.stats:2386,2390 ; Osiris ARCANA_Aspect_Common.txt:43 |
| `Arcana_Passive_Aspect_Empress_I` | Stats.txt Passive.txt:647 ; Stats.stats Passive.stats:830 ; Progression Progressions.lsx:406 Progressions.tbl:537 ; Osiris ARCANA_Aspect_Common.txt:43,51 ; Loca english.xml:994 |
| `Arcana_Passive_Aspect_Empress_II` | Stats.txt Passive.txt:654 ; Stats.stats Passive.stats:840 ; Progression Progressions.lsx:438 Progressions.tbl:581 ; Osiris ARCANA_Aspect_Common.txt:52 ; Loca english.xml:994 |
| `Arcana_Passive_Aspect_Empress_III` | Stats.txt Passive.txt:662 ; Stats.stats Passive.stats:851 ; Progression Progressions.lsx:477 Progressions.tbl:636 ; Osiris ARCANA_Aspect_Common.txt:53 ; Loca english.xml:994 |
| `Arcana_Passive_Aspect_Empress_Awakened_III` | Stats.txt Passive.txt:518 Status_BOOST.txt:2355 ; Stats.stats Passive.stats:653 Status_BOOST.stats:2144 |
| `Arcana_Passive_Aspect_Empress_Awakened_III_Damage` | Stats.txt Passive.txt:525 Status_BOOST.txt:2355 ; Stats.stats Passive.stats:663 Status_BOOST.stats:2144 |
| `Arcana_Passive_Aspect_Empress_Awakening` | Stats.txt Passive.txt:640 ; Stats.stats Passive.stats:820 ; Progression Progressions.lsx:406 Progressions.tbl:537 |
| `DB_ARCANA_SigilOwner` | Osiris ARCANA_Aspect_Empress.txt:20,22,27,34,36,128,130,135,137 |
| `DB_ARCANA_EmpressChained` | Osiris ARCANA_Aspect_Empress.txt:47,106,112,114,121,123 |
| `DB_ARCANA_EmpressBest` | Osiris ARCANA_Aspect_Empress.txt:60,62,86,90,91,96,98,103,105 |
| `DB_ARCANA_Copy_Active` | Osiris ARCANA_Spell_FacelessCopy.txt:10,12,31,38,47 |
| `DB_Withdraw_Position` | Osiris ARCANA_Spell_Withdraw.txt:10,12,39,56,78 |
| `DB_Withdraw_Marker` | Osiris ARCANA_Spell_Withdraw.txt:17,20,62 |
| `DB_MimicWithdraw_Position` | Osiris ARCANA_Spell_MimicWithdraw.txt:10,12,39,56,78 |
| `DB_MimicWithdraw_Marker` | Osiris ARCANA_Spell_MimicWithdraw.txt:17,20,62 |

(64 ids.)


---

## C. Current definitions (verbatim from `Public/$M/Stats/Generated/Data`)

Each block is the full entry as it stands today; the header gives file:line of `new entry`. Interrupt entries are in `Interrupt.txt`. A variant that `using` its root shows only the fields it adds.

### C1. Mirror Image (the card, its variants, the clone plumbing)

`Spell_Target.txt:1283`
```
new entry "Target_Arcana_Card_Spell_MirrorImage"
type "SpellData"
data "SpellType" "Target"
data "Level" "4"
data "SpellSchool" "Conjuration"
data "SpellProperties" "GROUND:Summon(8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8,-1,,,CreateCloneStack1,MIRROR_IMAGE_TECHNICAL,MIRROR_IMAGE_CLONE_SCALING);"
data "TargetRadius" "18"
data "TargetConditions" "CanStand('8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8') and not Character() and not Self() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Action_Cleric_InvokeDuplicity"
data "DisplayName" "hfdec3a47gb1c5g5c51g6b2eg00757ffc4aef;3"
data "Description" "h805db51fg1ce6g5aa9g3a26g99b6279b2218;11"
data "CastSound" "Spell_Cast_Summon_InvokeDuplicity_L1to3"
data "TargetSound" "Spell_Impact_Summon_InvokeDuplicity_L1to3"
data "CastTextEvent" "Cast"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:4;"
data "SpellAnimation" "2f0d97b9-4a1f-4bf3-a3c2-32efb563d601,,;,,;4acb9350-ba51-40c0-8b72-32dc3d50d4a2,,;58711808-db75-47e7-ba95-31e73dcdf9cd,,;57e449b3-b712-4508-afcf-f2e91dc473f6,,;,,;84f3727f-aabc-4e34-bf31-c6cd0160bec9,,;,,;,,"
data "VerbalIntent" "Summon"
data "SpellStyleGroup" "Class"
data "SpellFlags" "CannotTargetItems;CannotTargetCharacter;HasSomaticComponent;HasVerbalComponent;IsSpell"
data "PrepareEffect" "d71f28ac-e1b7-4169-9670-a3cc1e338dc3"
data "CastEffect" "5215e8c4-dab6-49c5-8d5f-c1bd806c1938"
data "PositionEffect" "e51ca7f4-8947-43a1-a95f-a0a0e9d8156e"
data "DamageType" "Radiant"
```

`Spell_Target.txt:3453`
```
new entry "Target_Arcana_Card_Spell_MirrorImage_5"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_MirrorImage"
data "RootSpellID" "Target_Arcana_Card_Spell_MirrorImage"
data "PowerLevel" "5"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:5;"
```

`Spell_Target.txt:3461`
```
new entry "Target_Arcana_Card_Spell_MirrorImage_6"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_MirrorImage"
data "RootSpellID" "Target_Arcana_Card_Spell_MirrorImage"
data "PowerLevel" "6"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:6;"
```

`Status_INVISIBLE.txt:18`
```
new entry "MIRROR_IMAGE_TECHNICAL"
type "StatusData"
data "StatusType" "INVISIBLE"
using "INVOKE_DUPLICITY_TECHNICAL"
data "DisplayName" "h784131eeg4b49g41f3g2db9ge081041f4762;1"
data "Boosts" ""
data "RemoveEvents" ""
data "RemoveConditions" ""
data "OnRemoveFunctors" ""
data "StatusGroups" ""
data "StatusEffect" ""
```

`Status_BOOST.txt:1197`
```
new entry "MIRROR_IMAGE_CLONE_SCALING"
type "StatusData"
data "StatusType" "BOOST"
data "StackType" "Ignore"
data "Boosts" "IncreaseMaxHP(Owner.Level*6);ProficiencyBonusOverride(Owner.LevelMapValue(StandardProficiencyBonusScale));RollBonus(Attack,Owner.SpellCastingAbilityModifier);"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
```

`Character.txt:1`
```
new entry "Clone_1"
type "Character"
data "Level" "1"
data "Strength" "8"
data "Dexterity" "12"
data "Constitution" "10"
data "Intelligence" "16"
data "Wisdom" "14"
data "Charisma" "18"
data "Armor" "10"
data "Vitality" "8"
data "XPReward" "40806669-8c6b-4068-8bc4-07e4981bb020"
data "Sight" "1600"
data "Hearing" "1100"
data "FOV" "90"
data "Weight" "75"
data "StepsType" "Bare"
data "DefaultBoosts" "ProficiencyBonus(Skill,Insight);ProficiencyBonus(Skill,Stealth);ProficiencyBonus(Skill,Perception);ProficiencyBonus(Skill,Deception);ProficiencyBonus(Skill,Investigation);BlockRegainHP(Undead;Construct);"
data "PathInfluence" "BloodElectrified,100;BloodFrozen,30;Lava,700;Fire,40;HolyFir... [rest of the PathInfluence line omitted: very long, unrelated]"
data "ProficiencyBonusScaling" "265d62c4-9b82-4ed6-9a86-da675b4ef8fe"
data "SpellCastingAbility" "Charisma"
data "UnarmedAttackAbility" "Strength"
data "UnarmedRangedAttackAbility" "Strength"
data "ActionResources" "ActionPoint:1;BonusActionPoint:1;Movement:9;ReactionActionPoint:1"
data "Passives" "AttackOfOpportunity;DarknessRules"
data "MinimumDetectionRange" "2"
data "DarkvisionRange" "0"
data "FallingHitEffect" "VFX_Combat_Bludgeoning_Damage_Blood_01"
data "FallingLandEffect" "VFX_Combat_Force_Land_01"
data "ArmorType" "Cloth"
data "Proficiency Group" "SimpleWeapons;MusicalInstrument;LightArmor;MartialWeapons"
data "DifficultyStatuses" "STATUS_EASY: HEALTHREDUCTION_EASYMODE; STATUS_HARD: HEALTHBOOST_HARDCORE"
```

`Spell_Shout.txt:1466`
```
new entry "Shout_Deceiver_Clone_Dismiss"
type "SpellData"
data "SpellType" "Shout"
using "Shout_Dismiss_Self"
data "Sheathing" "DontChange"
```

`Spell_Target.txt:1269`
```
new entry "Target_Deceiver_Clone_MirrorDistortion"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Created_MimicDistortion"
data "SpellContainerID" ""
data "SpellProperties" "GROUND:Summon(SELF,4441890b-a8c1-4c6d-8309-ec505adc7acc,2);GROUND:IF(CanStand('')):TeleportSource();GROUND:CreateExplosion(Projectile_Arcana_MirrorDistortion_Explosion);"
data "RequirementConditions" "not HasStatus('MIRROR_DISTORTION_HELPER');"
data "TargetConditions" ""
data "DisplayName" "h1027bccfgc6dag3c46gce95gdd7702261e05;1"
data "Description" "he4a289bcg086cg8355g75bcg04de11ade4d8;1"
data "TooltipDamageList" "DealDamage(LevelMapValue(MirrorDistortion_Damage),Force)"
data "UseCosts" "ActionPoint:1"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful;IsSpell"
```

`Spell_Target.txt:1131`
```
new entry "Target_Deceiver_Clone_MirrorEtherealChains"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Created_MimicEtherealChains"
data "SpellContainerID" ""
data "RequirementConditions" ""
data "SpellSuccess" "ApplyStatus(MIRROR_ETHEREAL_CHAINS,100,1);ApplyStatus(ETHEREAL_CHAINS_EFFECT,100,1);"
data "TargetConditions" ""
data "DisplayName" "he00a1f96g87f9g4f9dg87b3ga147297a6d7d;1"
data "Description" "h19148393g43edg142eg8af8gc41f2c6b60f9;2"
data "TooltipDamageList" "DealDamage(LevelMapValue(MirrorEtherealChains_Damage),Force);DealDamage(LevelMapValue(MirrorEtherealChains_Damage),Force)"
data "TooltipStatusApply" "ApplyStatus(MIRROR_ETHEREAL_CHAINS,100,1)"
data "UseCosts" "ActionPoint:1;"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsHarmful;IsSpell"
```

`Spell_Projectile.txt:70`
```
new entry "Projectile_Deceiver_Clone_MirrorSigilofMalice"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Created_MimicSigilofMalice"
data "SpellContainerID" ""
data "SpellProperties" "DealDamage(LevelMapValue(MirrorSigilofMalice_Damage),Force,Magical);ApplyStatus(SIGIL_TECH,100,0);"
data "TargetConditions" "not Self() and not Dead() and not HasPassive('ARCANA_IS_SPELL', context.Source)"
data "DisplayName" "hd66f5137g5a56g8f90g2a7eg143cdc0b770e;1"
data "Description" "hf22a0eedgbc8dgc316g2434g51c6f4982dc4;2"
data "DescriptionParams" "DealDamage(LevelMapValue(MirrorSigilofMalice_Damage),Force)"
data "TooltipDamageList" "DealDamage(LevelMapValue(MirrorSigilofMalice_Damage),Force)"
data "UseCosts" "ActionPoint:1;"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful;IsSpell"
data "RequirementConditions" ""
data "CombatAIOverrideSpell" "Projectile_MagicMissile_AI"
```

`Spell_Shout.txt:1480`
```
new entry "Shout_Deceiver_Clone_MirrorWithdraw"
type "SpellData"
data "SpellType" "Shout"
using "Shout_Arcana_Created_MimicWithdraw"
data "Level" ""
data "SpellProperties" "RemoveStatus(SELF,MIRROR_DISTORTION_HELPER);"
data "TargetConditions" ""
data "DisplayName" "h292adcdcg8358g8b9dg271dg4d5c824f1d62;1"
data "UseCosts" "BonusActionPoint:1;"
data "FollowUpOriginalSpell" "Target_Deceiver_Clone_MirrorDistortion"
```

`Spell_Projectile.txt:151`
```
new entry "Projectile_Arcana_MirrorDistortion_Explosion"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_MimicDistortion_Explosion"
data "SpellProperties" "DealDamage(LevelMapValue(MirrorDistortion_Damage),Force,Magical);"
```

`Status_BOOST.txt:1222`
```
new entry "MIRROR_DISTORTION_HELPER"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hc29abaf5g0ec7g9f06g32b9g0b00b68c067a;1"
data "StackId" "MIRROR_DISTORTION_HELPER"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
```

`Status_BOOST.txt:1039`
```
new entry "MIRROR_ETHEREAL_CHAINS"
type "StatusData"
data "StatusType" "BOOST"
using "MIMIC_ETHEREAL_CHAINS"
data "DisplayName" "h36fb11fdg724egf61eg596fgcfb255c3c4c0;1"
data "DescriptionParams" "DealDamage(Cause.LevelMapValue(MirrorEtherealChains_Damage),Force)"
data "StackId" "MIRROR_ETHEREAL_CHAINS"
data "TickFunctors" "DealDamage(Cause.LevelMapValue(MirrorEtherealChains_Damage),Force,Magical)"
data "OnApplyFunctors" "DealDamage(Cause.LevelMapValue(MirrorEtherealChains_Damage),Force,Magical)"
```

### C2. Distortion (card, variants, explosion, helpers) and Withdraw

`Spell_Target.txt:1227`
```
new entry "Target_Arcana_Card_Spell_Distortion"
type "SpellData"
data "SpellType" "Target"
data "Level" "3"
data "SpellSchool" "Evocation"
data "SpellProperties" "GROUND:Summon(SELF,c3c514b2-152d-4a01-9e7d-e49d1062d2f0,2);GROUND:IF(CanStand('')):TeleportSource();GROUND:CreateExplosion(Projectile_Arcana_Distortion_Explosion);GROUND:ApplyStatus(SELF,DISTORTION_LAST_CASTED,100,-1)"
data "TargetRadius" "18"
data "AreaRadius" "3"
data "RequirementConditions" "not HasStatus('DISTORTION_HELPER');"
data "TargetConditions" "CanStand('') and not Self() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Spell_WildMagic_Teleport_Activate"
data "DisplayName" "h2bfb3759ga241g9495g65ddg9e2d6f843aab;1"
data "Description" "ha600849fgd60bg0304g0ae8gd0576ef7fa29;8"
data "TooltipDamageList" "DealDamage(3d8,Force)"
data "CastSound" "Spell_Cast_Wizard_BenignTranspositionTeleport_L1to3"
data "TargetSound" "Spell_Impact_Wizard_BenignTranspositionTeleport_L1to3"
data "CastTextEvent" "Cast"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:3;"
data "SpellAnimation" "b94b9184-9bd0-4840-be7d-003700173b37,,;,,;5df11e35-f081-44f7-bd6f-7049d0e533cd,,;8dccb0f6-24e3-44b7-a60b-1f217b7db523,,;066f8e0e-b3e1-4b76-a473-d1e23a3b7230,,;,,;7a28f440-1b0b-4a18-96a8-3767959b601a,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellStyleGroup" "Class"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful;IsSpell"
data "MaximumTargets" "1"
data "LineOfSightFlags" "AddSourceHeight"
data "PrepareEffect" "7121a488-7c9a-4ba1-a585-f79aaa77e97c"
data "CastEffect" "7849600d-0650-4c46-9f51-2bb3d15ed92a"
data "PositionEffect" "4226c755-e28f-4050-849c-e34c97552058"
```

`Spell_Target.txt:2701`
```
new entry "Target_Arcana_Card_Spell_Distortion_4"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_Distortion"
data "RootSpellID" "Target_Arcana_Card_Spell_Distortion"
data "PowerLevel" "4"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:4;"
data "SpellProperties" "GROUND:Summon(SELF,c3c514b2-152d-4a01-9e7d-e49d1062d2f0,2);GROUND:IF(CanStand('')):TeleportSource();GROUND:CreateExplosion(Projectile_Arcana_Distortion_Explosion_4);GROUND:ApplyStatus(SELF,DISTORTION_LAST_CASTED,100,-1)"
data "TooltipDamageList" "DealDamage(4d8,Force)"
```

`Spell_Target.txt:2711`
```
new entry "Target_Arcana_Card_Spell_Distortion_5"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_Distortion"
data "RootSpellID" "Target_Arcana_Card_Spell_Distortion"
data "PowerLevel" "5"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:5;"
data "SpellProperties" "GROUND:Summon(SELF,c3c514b2-152d-4a01-9e7d-e49d1062d2f0,2);GROUND:IF(CanStand('')):TeleportSource();GROUND:CreateExplosion(Projectile_Arcana_Distortion_Explosion_5);GROUND:ApplyStatus(SELF,DISTORTION_LAST_CASTED,100,-1)"
data "TooltipDamageList" "DealDamage(5d8,Force)"
```

`Spell_Target.txt:2721`
```
new entry "Target_Arcana_Card_Spell_Distortion_6"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_Distortion"
data "RootSpellID" "Target_Arcana_Card_Spell_Distortion"
data "PowerLevel" "6"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:6;"
data "SpellProperties" "GROUND:Summon(SELF,c3c514b2-152d-4a01-9e7d-e49d1062d2f0,2);GROUND:IF(CanStand('')):TeleportSource();GROUND:CreateExplosion(Projectile_Arcana_Distortion_Explosion_6);GROUND:ApplyStatus(SELF,DISTORTION_LAST_CASTED,100,-1)"
data "TooltipDamageList" "DealDamage(6d8,Force)"
```

`Spell_Projectile.txt:86`
```
new entry "Projectile_Arcana_Distortion_Explosion"
type "SpellData"
data "SpellType" "Projectile"
data "Level" "3"
data "SpellSchool" "Evocation"
data "SpellProperties" "DealDamage(3d8,Force,Magical);"
data "AreaRadius" "3"
data "ExplodeRadius" "3"
data "TargetConditions" "not Dead() and Character() and not Ally() and not HasPassive('ARCANA_IS_SPELL', context.Source)"
data "ProjectileCount" "1"
data "Trajectories" "0be6e4d7-55fe-4ee0-8acc-94fc3b474817,78f998fb-2bb4-c8bd-c170-fcd899abc905,a62c27e3-86c0-db69-8f04-0ea3074cae7a"
data "Icon" "PassiveFeature_Generic_Explosion"
data "SpellAnimation" "3ff87abf-1ea1-4c32-aadf-c822d74c7dc0,,;,,;38cdb41c-2eec-4e03-bb31-83cff0346c35,,;85414f5f-b448-4dda-9370-1b6c4b38b561,,;d8925ce4-d6d9-400c-92f5-ad772ef7f178,,;,,;eadedcce-d01b-4fbb-a1ae-d218f13aa5d6,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellFlags" "IsHarmful;IsSpell"
data "DamageType" "Force"
```

`Spell_Projectile.txt:103`
```
new entry "Projectile_Arcana_Distortion_Explosion_4"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Distortion_Explosion"
data "SpellProperties" "DealDamage(4d8,Force,Magical);"
```

`Spell_Projectile.txt:109`
```
new entry "Projectile_Arcana_Distortion_Explosion_5"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Distortion_Explosion"
data "SpellProperties" "DealDamage(5d8,Force,Magical);"
```

`Spell_Projectile.txt:115`
```
new entry "Projectile_Arcana_Distortion_Explosion_6"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Distortion_Explosion"
data "SpellProperties" "DealDamage(6d8,Force,Magical);"
```

`Status_BOOST.txt:1134`
```
new entry "DISTORTION_HELPER"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hbbe87a54g9882ga869g13a3g51d491fb409e;1"
data "StackId" "DISTORTION_HELPER"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
```

`Status_BOOST.txt:1142`
```
new entry "DISTORTION_LAST_CASTED"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h3c4edb12g2741g4fd0g7808g1b880efe0603;1"
data "Icon" "Spell_WildMagic_Teleport_Activate"
data "StackId" "MIMIC_LAST_CAST"
data "StackPriority" "1"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "ForceOverhead"
data "StatusGroups" "SG_RemoveOnRespec"
```

`Spell_Shout.txt:1398`
```
new entry "Shout_Arcana_Created_Withdraw"
type "SpellData"
data "SpellType" "Shout"
data "Level" "1"
data "SpellProperties" "RemoveStatus(SELF,DISTORTION_HELPER);"
data "TargetConditions" "not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Spell_Transmutation_Blink_Teleport"
data "DisplayName" "hb680e413ga782gddaag9097gbeaa9b35c6a9;2"
data "Description" "h62eccccagdbe3g230bg3715g97e90882e0c1;4"
data "CastSound" "Spell_Cast_Wizard_BenignTranspositionTeleport_L1to3"
data "TargetSound" "Spell_Impact_Wizard_BenignTranspositionTeleport_L1to3"
data "CastTextEvent" "Cast"
data "UseCosts" "BonusActionPoint:1;SpellSlotsGroup:1:1:1;"
data "SpellAnimation" "b94b9184-9bd0-4840-be7d-003700173b37,,;,,;5df11e35-f081-44f7-bd6f-7049d0e533cd,,;8dccb0f6-24e3-44b7-a60b-1f217b7db523,,;066f8e0e-b3e1-4b76-a473-d1e23a3b7230,,;,,;7a28f440-1b0b-4a18-96a8-3767959b601a,,;,,;,,"
data "VerbalIntent" "Utility"
data "SpellStyleGroup" "Class"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;Temporary"
data "PrepareEffect" "7121a488-7c9a-4ba1-a585-f79aaa77e97c"
data "CastEffect" "7849600d-0650-4c46-9f51-2bb3d15ed92a"
data "PositionEffect" "4226c755-e28f-4050-849c-e34c97552058"
data "FollowUpOriginalSpell" "Target_Arcana_Card_Spell_Distortion"
```

`Spell_Shout.txt:2732`
```
new entry "Shout_Arcana_Created_Withdraw_3"
type "SpellData"
data "SpellType" "Shout"
using "Shout_Arcana_Created_Withdraw"
data "RootSpellID" "Shout_Arcana_Created_Withdraw"
data "PowerLevel" "3"
data "UseCosts" "BonusActionPoint:1;SpellSlotsGroup:1:1:3;"
```

`Spell_Shout.txt:2740`
```
new entry "Shout_Arcana_Created_Withdraw_4"
type "SpellData"
data "SpellType" "Shout"
using "Shout_Arcana_Created_Withdraw"
data "RootSpellID" "Shout_Arcana_Created_Withdraw"
data "PowerLevel" "4"
data "UseCosts" "BonusActionPoint:1;SpellSlotsGroup:1:1:4;"
```

`Spell_Shout.txt:2748`
```
new entry "Shout_Arcana_Created_Withdraw_5"
type "SpellData"
data "SpellType" "Shout"
using "Shout_Arcana_Created_Withdraw"
data "RootSpellID" "Shout_Arcana_Created_Withdraw"
data "PowerLevel" "5"
data "UseCosts" "BonusActionPoint:1;SpellSlotsGroup:1:1:5;"
```

`Spell_Shout.txt:2756`
```
new entry "Shout_Arcana_Created_Withdraw_6"
type "SpellData"
data "SpellType" "Shout"
using "Shout_Arcana_Created_Withdraw"
data "RootSpellID" "Shout_Arcana_Created_Withdraw"
data "PowerLevel" "6"
data "UseCosts" "BonusActionPoint:1;SpellSlotsGroup:1:1:6;"
```

### C3. Sigil of Malice, Sigil statuses, Malicious Whispers

`Spell_Projectile.txt:10`
```
new entry "Projectile_Arcana_Card_Spell_SigilofMalice"
type "SpellData"
data "SpellType" "Projectile"
data "Level" "1"
data "SpellSchool" "Evocation"
data "SpellProperties" "DealDamage(1d6,Force,Magical);ApplyStatus(SIGIL_TECH,100,0);ApplyStatus(SELF,SIGIL_OF_MALICE_LAST_CASTED,100,-1)"
data "TargetFloor" "-1"
data "TargetRadius" "18"
data "AmountOfTargets" "1"
data "TargetConditions" "not Self() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "ProjectileCount" "1"
data "CastTargetHitDelay" "100"
data "Angle" "120"
data "Trajectories" "348013df-7958-4ca9-ac9f-80337e054bee,7bff57fa-fd21-4ab3-9384-83fb14237690"
data "Icon" "Spell_Evocation_MagicMissile"
data "DisplayName" "h629833b0gfc8dg4921g4f7fged5030c535cf;2"
data "Description" "hf8d9df66gdf2fgddd2gdc5cg87074e8257d4;5"
data "DescriptionParams" "DealDamage(1d6,Force)"
data "TooltipDamageList" "DealDamage(1d6,Force)"
data "PrepareSound" "Spell_Prepare_Damage_Force_Gen_L1to3"
data "PrepareLoopSound" "Spell_Prepare_Damage_Force_Gen_L1to3_Loop"
data "CastSound" "Spell_Cast_Damage_Force_MagicMissile_L1to3"
data "PreviewCursor" "Cast"
data "CastTextEvent" "Cast"
data "CycleConditions" "Enemy() and not Dead()"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:1;"
data "SpellAnimation" "3ff87abf-1ea1-4c32-aadf-c822d74c7dc0,,;,,;38cdb41c-2eec-4e03-bb31-83cff0346c35,,;85414f5f-b448-4dda-9370-1b6c4b38b561,,;d8925ce4-d6d9-400c-92f5-ad772ef7f178,,;,,;eadedcce-d01b-4fbb-a1ae-d218f13aa5d6,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;HasHighGroundRangeExtension;RangeIgnoreVerticalThreshold;IsHarmful;IsSpell"
data "RechargeValues" "4-6"
data "PrepareEffect" "f9785481-e126-4499-b00e-f36fa02cd196"
data "CastEffect" "655f8b6b-f392-4c5d-8d74-d2a9df5f8f9d"
data "DamageType" "Force"
data "CombatAIOverrideSpell" "Projectile_MagicMissile_AI"
```

`Spell_Projectile.txt:260`
```
new entry "Projectile_Arcana_Card_Spell_SigilofMalice_2"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Card_Spell_SigilofMalice"
data "RootSpellID" "Projectile_Arcana_Card_Spell_SigilofMalice"
data "PowerLevel" "2"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:2;"
data "SpellProperties" "DealDamage(2d6,Force,Magical);ApplyStatus(SIGIL_TECH,100,0);ApplyStatus(SELF,SIGIL_OF_MALICE_LAST_CASTED,100,-1)"
data "DescriptionParams" "DealDamage(2d6,Force)"
data "TooltipDamageList" "DealDamage(2d6,Force)"
```

`Spell_Projectile.txt:271`
```
new entry "Projectile_Arcana_Card_Spell_SigilofMalice_3"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Card_Spell_SigilofMalice"
data "RootSpellID" "Projectile_Arcana_Card_Spell_SigilofMalice"
data "PowerLevel" "3"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:3;"
data "SpellProperties" "DealDamage(3d6,Force,Magical);ApplyStatus(SIGIL_TECH,100,0);ApplyStatus(SELF,SIGIL_OF_MALICE_LAST_CASTED,100,-1)"
data "DescriptionParams" "DealDamage(3d6,Force)"
data "TooltipDamageList" "DealDamage(3d6,Force)"
```

`Spell_Projectile.txt:282`
```
new entry "Projectile_Arcana_Card_Spell_SigilofMalice_4"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Card_Spell_SigilofMalice"
data "RootSpellID" "Projectile_Arcana_Card_Spell_SigilofMalice"
data "PowerLevel" "4"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:4;"
data "SpellProperties" "DealDamage(4d6,Force,Magical);ApplyStatus(SIGIL_TECH,100,0);ApplyStatus(SELF,SIGIL_OF_MALICE_LAST_CASTED,100,-1)"
data "DescriptionParams" "DealDamage(4d6,Force)"
data "TooltipDamageList" "DealDamage(4d6,Force)"
```

`Spell_Projectile.txt:293`
```
new entry "Projectile_Arcana_Card_Spell_SigilofMalice_5"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Card_Spell_SigilofMalice"
data "RootSpellID" "Projectile_Arcana_Card_Spell_SigilofMalice"
data "PowerLevel" "5"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:5;"
data "SpellProperties" "DealDamage(5d6,Force,Magical);ApplyStatus(SIGIL_TECH,100,0);ApplyStatus(SELF,SIGIL_OF_MALICE_LAST_CASTED,100,-1)"
data "DescriptionParams" "DealDamage(5d6,Force)"
data "TooltipDamageList" "DealDamage(5d6,Force)"
```

`Spell_Projectile.txt:304`
```
new entry "Projectile_Arcana_Card_Spell_SigilofMalice_6"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_Arcana_Card_Spell_SigilofMalice"
data "RootSpellID" "Projectile_Arcana_Card_Spell_SigilofMalice"
data "PowerLevel" "6"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:6;"
data "SpellProperties" "DealDamage(6d6,Force,Magical);ApplyStatus(SIGIL_TECH,100,0);ApplyStatus(SELF,SIGIL_OF_MALICE_LAST_CASTED,100,-1)"
data "DescriptionParams" "DealDamage(6d6,Force)"
data "TooltipDamageList" "DealDamage(6d6,Force)"
```

`Status_BOOST.txt:900`
```
new entry "SIGIL"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h5a9834b3g29bfg7f21g71c4ga9b6a3271088;4"
data "Description" "h28e6ebc5g3632g32ddgd3d7ge688706a5796;10"
data "DescriptionParams" "DealDamage(Cause.LevelMapValue(Sigil_MarkDamage),Psychic)"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "SIGIL"
data "StackType" "Ignore"
data "Boosts" "IF(HasStatus('ASPECT_AWAKENED_EMPRESS', context.Target) and HasStatus('SIGIL', context.Source, context.Target)):Disadvantage(AttackRoll);"
data "RemoveConditions" "(IsArcanaSpell() or HasAnyStatus({'ETHEREAL_CHAINS','ETHEREAL_CHAINS_3','ETHEREAL_CHAINS_4','ETHEREAL_CHAINS_5','ETHEREAL_CHAINS_6','MIMIC_ETHEREAL_CHAINS','MIMIC_ETHEREAL_CHAINS_2','MIMIC_ETHEREAL_CHAINS_3','MIMIC_ETHEREAL_CHAINS_4','MIMIC_ETHEREAL_CHAINS_5','MIMIC_ETHEREAL_CHAINS_6','MIRROR_ETHEREAL_CHAINS'})) and (HasStatus('SIGIL', context.Target, context.Source) or HasStatus('SIGIL', context.Target, GetSummoner(context.Source)))"
data "RemoveEvents" "OnDamage;OnStatusApplied"
data "OnRemoveFunctors" "IF(RemoveCause(StatusRemoveCause.Condition)):ApplyStatus(SIGIL_DETONATED_TECH,100,0);IF(RemoveCause(StatusRemoveCause.Condition) and not IsKillingBlow()):DealDamage(Cause.LevelMapValue(Sigil_MarkDamage),Psychic,Magical)"
data "ApplyEffect" "54d3e1a2-7513-4f46-bb46-53dec4e83b8d"
data "StatusEffect" "372f12fd-d95c-43ca-9cc6-096ecf421704"
```

`Status_BOOST.txt:1068`
```
new entry "SIGIL_TECH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hdb9aca65g1d8ag0b4fg4907g7797d5506932;2"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "SIGIL_TECH"
data "StackType" "Ignore"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
```

`Status_BOOST.txt:1049`
```
new entry "SIGIL_DETONATED_TECH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hbde3b28fgfb7fg967cgfb95g98b5d38881cf;1"
data "StackId" "SIGIL_DETONATED_TECH"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
```

`Status_BOOST.txt:1057`
```
new entry "SIGIL_OF_MALICE_LAST_CASTED"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h2a283036g31f4ga58bgc5d4g83b36478a82e;1"
data "Icon" "Spell_Evocation_MagicMissile"
data "StackId" "MIMIC_LAST_CAST"
data "StackPriority" "1"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "ForceOverhead"
data "StatusGroups" "SG_RemoveOnRespec"
```

`Spell_Target.txt:1045`
```
new entry "Target_Arcana_Card_Spell_MaliciousWhispers"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Enchantment"
data "TargetRadius" "18"
data "SpellRoll" "not SavingThrow(Ability.Wisdom, SourceSpellDC())"
data "SpellSuccess" "IF(HasStatus('SIGIL',context.Target,context.Source)):ApplyStatus(WHISPERED_PARANOIA,100,1);ApplyStatus(MALICIOUS_WHISPERS,100,1);DealDamage(LevelMapValue(D4Cantrip),Psychic,Magical);"
data "SpellFail" "IF(HasPassive('PotentCantrip',context.Source)):DealDamage((LevelMapValue(D4Cantrip))/2,Psychic,Magical), IF(not HasPassive('PotentCantrip',context.Source)):ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL,100,0)"
data "TargetConditions" "Character() and not Self() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "AmountOfTargets" "1"
data "Icon" "Spell_Enchantment_DissonantWhispers"
data "DisplayName" "h075eaf74ge607g11a5ga164gc44b5e3b6ea8;1"
data "Description" "h358611e4gab01gee5dg782ag87ac7ba30c60;2"
data "TooltipDamageList" "DealDamage(LevelMapValue(D4Cantrip),Psychic)"
data "TooltipAttackSave" "Wisdom"
data "TooltipStatusApply" "ApplyStatus(MALICIOUS_WHISPERS,100,1)"
data "PrepareSound" "Vocal_Component_PrepareViciousMockery"
data "CastSound" "Spell_Cast_Damage_Psychic_ViciousMockery_L1to3"
data "TargetSound" "Spell_Impact_Damage_Psychic_ViciousMockery_L1to3"
data "VocalComponentSound" "Vocal_Component_ViciousMockery"
data "CastTextEvent" "Cast"
data "CycleConditions" "Enemy() and not Dead()"
data "UseCosts" "ActionPoint:1;"
data "SpellAnimation" "ff78157b-f004-4813-b6d7-83744a7a56e4,,;,,;ebc9253d-d2b2-4657-b8c1-df334c6047b1,,;3aa138db-f6d7-495b-a34f-281b1d71fbc9,,;34da5af5-71b6-4278-9cc0-d5266ca98876,,;,,;32eb3c27-cd2c-49c1-a6c6-b21b2cccf050,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellStyleGroup" "Class"
data "SpellFlags" "IsSpell;HasVerbalComponent;IsHarmful"
data "HitAnimationType" "MagicalDamage_Psychic"
data "PrepareEffect" "15f05cf9-02e4-45df-83ce-fd82b04a7fa1"
data "CastEffect" "77e698a6-412f-43db-be9e-68e9a6f3afa7"
data "TargetEffect" "4fb18d5c-33c6-4ee9-b8ea-22f0923a32f7"
data "BeamEffect" "2c70ac69-71bf-4fef-b82d-caea934e102e"
data "DamageType" "Psychic"
data "Sheathing" "Sheathed"
```

### C4. Control cards: Mental Prison, Hypnotic Gaze, Marionette, Hostile Takeover (and variants)

`Spell_Target.txt:1176`
```
new entry "Target_Arcana_Card_Spell_MentalPrison"
type "SpellData"
data "SpellType" "Target"
data "Level" "2"
data "SpellSchool" "Enchantment"
data "Cooldown" "OncePerShortRest"
data "TargetRadius" "18"
data "SpellRoll" "not SavingThrow(Ability.Wisdom,SourceSpellDC())"
data "SpellSuccess" "ApplyStatus(HOLD_PERSON,100,10)"
data "SpellFail" "ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL,100,0)"
data "TargetConditions" "not Tagged('UNDEAD') and not Self() and not Dead() and not (not Player(context.Source) and IsCrowdControlled(context.Target)) and Character() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "AmountOfTargets" "1"
data "Icon" "Spell_Enchantment_HoldPerson"
data "DisplayName" "h2cddbd53g59aeg3642g6db2gb667dd1e7189;1"
data "Description" "h15b306a6g6eafg1010g3258gaf7e0c413309;2"
data "DescriptionParams" "Distance(3)"
data "TooltipAttackSave" "Wisdom"
data "TooltipStatusApply" "ApplyStatus(HOLD_PERSON,100,10)"
data "PrepareSound" "Spell_Prepare_Control_Gen_L1to3_01"
data "PrepareLoopSound" "Spell_Prepare_Control_Gen_L1to3_01_Loop"
data "CastSound" "Spell_Cast_Control_HoldPerson_L1to3"
data "TargetSound" "Spell_Impact_Control_HoldPerson_L1to3"
data "VocalComponentSound" "Vocal_Component_Paralyze"
data "CastTextEvent" "Cast"
data "CycleConditions" "Enemy() and not Dead()"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:2;"
data "SpellAnimation" "554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;3e441d3f-11f9-432d-877c-c0ba4d92c74a,,;8b7ae969-2a04-4720-9685-3bde54c18ffe,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,"
data "VerbalIntent" "Control"
data "SpellStyleGroup" "Class"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsSpell;HasHighGroundRangeExtension;IsConcentration;IsHarmful;IgnorePreviouslyPickedEntities"
data "HitAnimationType" "None"
data "PrepareEffect" "bcdca947-b1ba-475f-8e3b-9ac850da90fa"
data "CastEffect" "d2ef6b50-243f-478d-85c6-892086a1477e"
data "TargetEffect" "e1b340b6-78a9-413a-bb7e-8299848238ae"
```

`Spell_Target.txt:3421`
```
new entry "Target_Arcana_Card_Spell_MentalPrison_3"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_MentalPrison"
data "RootSpellID" "Target_Arcana_Card_Spell_MentalPrison"
data "PowerLevel" "3"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:3;"
```

`Spell_Target.txt:3429`
```
new entry "Target_Arcana_Card_Spell_MentalPrison_4"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_MentalPrison"
data "RootSpellID" "Target_Arcana_Card_Spell_MentalPrison"
data "PowerLevel" "4"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:4;"
```

`Spell_Target.txt:3437`
```
new entry "Target_Arcana_Card_Spell_MentalPrison_5"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_MentalPrison"
data "RootSpellID" "Target_Arcana_Card_Spell_MentalPrison"
data "PowerLevel" "5"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:5;"
```

`Spell_Target.txt:3445`
```
new entry "Target_Arcana_Card_Spell_MentalPrison_6"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_MentalPrison"
data "RootSpellID" "Target_Arcana_Card_Spell_MentalPrison"
data "PowerLevel" "6"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:6;"
```

`Spell_Target.txt:1146`
```
new entry "Target_Arcana_Card_Spell_HypnoticGaze"
type "SpellData"
data "SpellType" "Target"
data "Level" "2"
data "SpellSchool" "Enchantment"
data "Cooldown" "OncePerShortRest"
data "TargetRadius" "3"
data "SpellRoll" "not SavingThrow(Ability.Wisdom, SourceSpellDC())"
data "SpellSuccess" "ApplyStatus(HYPNOTIC_GAZE,100,2);ApplyStatus(SELF,HYPNOTIC_GAZE_OWNER,100,2)"
data "SpellFail" "ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL_CHARM, 100, 0)"
data "TargetConditions" "Character() and not Ally() and not IsImmuneToStatus('SG_Charmed')  and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Action_HypnoticGaze"
data "DisplayName" "h09b13723g7984g46cegba46g4bbcb1b452e9;1"
data "Description" "h42c6b1f9g8aa8g549cg7422g2025f4fe4fa9;1"
data "TooltipAttackSave" "Wisdom"
data "TooltipStatusApply" "ApplyStatus(HYPNOTIC_GAZE,100,2)"
data "TooltipPermanentWarnings" "a71e9779-ab72-47d8-b8d7-e0f16e1d0d9b"
data "CastSound" "Action_Cast_Wizard_HypnoticGaze"
data "TargetSound" "Action_Impact_Wizard_HypnoticGaze"
data "VocalComponentSound" "Vocal_Component_Hypnotize"
data "CastTextEvent" "Cast"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:2;"
data "SpellAnimation" "554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;54ae8856-36b2-4f70-8bd3-c2a760f93fd5,,;8ce3e582-e8bb-4d2f-9c5c-46c70c9b87c0,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,"
data "VerbalIntent" "Control"
data "SpellStyleGroup" "Class"
data "SpellFlags" "IsSpell;HasSomaticComponent"
data "HitAnimationType" "MagicalDamage_Psychic"
data "PrepareEffect" "2fa6b127-6f8a-4150-8be6-6f62b7a85911"
data "CastEffect" "238adc5b-64e5-474a-b5fa-c4c5d032a21b"
```

`Spell_Target.txt:3325`
```
new entry "Target_Arcana_Card_Spell_HypnoticGaze_3"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_HypnoticGaze"
data "RootSpellID" "Target_Arcana_Card_Spell_HypnoticGaze"
data "PowerLevel" "3"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:3;"
```

`Spell_Target.txt:3333`
```
new entry "Target_Arcana_Card_Spell_HypnoticGaze_4"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_HypnoticGaze"
data "RootSpellID" "Target_Arcana_Card_Spell_HypnoticGaze"
data "PowerLevel" "4"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:4;"
```

`Spell_Target.txt:3341`
```
new entry "Target_Arcana_Card_Spell_HypnoticGaze_5"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_HypnoticGaze"
data "RootSpellID" "Target_Arcana_Card_Spell_HypnoticGaze"
data "PowerLevel" "5"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:5;"
```

`Spell_Target.txt:3349`
```
new entry "Target_Arcana_Card_Spell_HypnoticGaze_6"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_HypnoticGaze"
data "RootSpellID" "Target_Arcana_Card_Spell_HypnoticGaze"
data "PowerLevel" "6"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:6;"
```

`Spell_Target.txt:1339`
```
new entry "Target_Arcana_Card_Spell_Marionette"
type "SpellData"
data "SpellType" "Target"
data "Level" "5"
data "SpellSchool" "Enchantment"
data "Cooldown" "OncePerRest"
data "TargetRadius" "18"
data "SpellRoll" "not SavingThrow(Ability.Wisdom,SourceSpellDC(),AdvantageOnCharmed())"
data "SpellSuccess" "ApplyStatus(DOMINATE_PERSON,100,10);"
data "SpellFail" "ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL_DOMINATED,100,0);"
data "TargetConditions" "not Ally() and not Dead() and Tagged('HUMANOID') and not Tagged('UNDEAD') and not (Party(context.Target) and Party(context.Source)) and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "AmountOfTargets" "1"
data "Icon" "Spell_Enchantment_DominatePerson"
data "DisplayName" "he7c6e77eg2128g88a9g53a1g2876bc575722;2"
data "Description" "h34b65968g7b65g1e09g641egcc03c51bd254;6"
data "TooltipAttackSave" "Wisdom"
data "TooltipStatusApply" "ApplyStatus(DOMINATE_PERSON,100,10)"
data "PrepareSound" "Spell_Prepare_Control_Gen_L1to3_01"
data "PrepareLoopSound" "Spell_Prepare_Control_Gen_L1to3_01_Loop"
data "CastSound" "Spell_Cast_Control_DominatePerson_L4to5"
data "TargetSound" "Spell_Impact_Control_DominatePerson_L4to5"
data "PreviewCursor" "Cast"
data "CastTextEvent" "Cast"
data "CycleConditions" "Enemy() and not Dead()"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:5;"
data "SpellAnimation" "554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;af94aac1-d8eb-4ccb-9520-694ade11b61c,,;f5db4001-b136-4c48-9aa4-026c4a7dd3b7,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,"
data "VerbalIntent" "Control"
data "SpellStyleGroup" "Class"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;HasHighGroundRangeExtension;IsHarmful;IsSpell;IsConcentration"
data "PrepareEffect" "2fa6b127-6f8a-4150-8be6-6f62b7a85911"
data "CastEffect" "a7ffe334-15bc-4515-976c-932e6d45b9d9"
data "TargetEffect" "fdf323a9-8912-4dcd-b55e-e268f7f45170"
```

`Spell_Target.txt:3413`
```
new entry "Target_Arcana_Card_Spell_Marionette_6"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_Marionette"
data "RootSpellID" "Target_Arcana_Card_Spell_Marionette"
data "PowerLevel" "6"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:6;"
```

`Spell_Target.txt:1372`
```
new entry "Target_Arcana_Card_Spell_HostileTakeover"
type "SpellData"
data "SpellType" "Target"
data "Level" "5"
data "SpellSchool" "Enchantment"
data "Cooldown" "OncePerRest"
data "TargetRadius" "18"
data "AreaRadius" "6"
data "SpellRoll" "not SavingThrow(Ability.Wisdom,SourceSpellDC())"
data "SpellSuccess" "AI_IGNORE:ApplyStatus(CONFUSION,100,5);AI_ONLY:ApplyStatus(PARALYZED,100,5);"
data "SpellFail" "ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL, 100, 0)"
data "TargetConditions" "not Item() and not Dead() and not Ally() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Spell_Enchantment_Confusion"
data "DisplayName" "h3320cae1gc648g97cdgf903gbbdbdd71a8a5;1"
data "Description" "h6809fe1cg2229g79ceg8136g208f4ac6cce6;7"
data "TooltipAttackSave" "Wisdom"
data "TooltipStatusApply" "ApplyStatus(CONFUSION,100,5)"
data "PrepareSound" "Spell_Prepare_Debuff_Gen_L1to3_01"
data "CastSound" "Spell_Cast_Debuff_Confusion_L4to5"
data "TargetSound" "Spell_Impact_Debuff_Confusion_L4to5"
data "VocalComponentSound" "Vocal_Component_Confuse"
data "PreviewCursor" "Cast"
data "CastTextEvent" "Cast"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:5;"
data "SpellAnimation" "554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;54ae8856-36b2-4f70-8bd3-c2a760f93fd5,,;8ce3e582-e8bb-4d2f-9c5c-46c70c9b87c0,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,"
data "VerbalIntent" "Control"
data "SpellStyleGroup" "Class"
data "SpellFlags" "HasVerbalComponent;HasSomaticComponent;IsConcentration;IsSpell"
data "PrepareEffect" "b090825a-0728-4566-a02b-056a188cc347"
data "CastEffect" "38776222-db33-4b53-9e23-ca3b47ab58cb"
data "TargetEffect" "c6846cf3-6ea3-4551-b867-3554eaa6aeae"
data "PositionEffect" "16d200bc-14f7-416d-ab7a-913bb450734c"
```

`Spell_Target.txt:3317`
```
new entry "Target_Arcana_Card_Spell_HostileTakeover_6"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Card_Spell_HostileTakeover"
data "RootSpellID" "Target_Arcana_Card_Spell_HostileTakeover"
data "PowerLevel" "6"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:6;"
```

### C5. Friends

`Spell_Target.txt:1421`
```
new entry "Target_Arcana_Util_Friends"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Enchantment"
data "SpellProperties" "ApplyStatus(FRIENDS,100,10)"
data "TargetRadius" "9"
data "TargetConditions" "Character() and not Enemy() and not Self() and not HasPassive('ARCANA_IS_SPELL', context.Source)"
data "AmountOfTargets" "1"
data "Icon" "Spell_Enchantment_Friends"
data "DisplayName" "hba7df2c8gc7c1gedf4g6be8g6d60752f43fd;3"
data "Description" "h5d0c74dag8bfbgd0fege79bgbd32c751cb1a;5"
data "ExtraDescription" "h9dd95e32gd1f4g9b57g9df7g7706c0b3938e;3"
data "TooltipStatusApply" "ApplyStatus(FRIENDS,100,10)"
data "TooltipPermanentWarnings" "676ef361-c11d-4e5a-bcae-3b0332cbebf5"
data "PrepareSound" "Spell_Prepare_Control_Gen_L1to3_01"
data "PrepareLoopSound" "Spell_Prepare_Control_Gen_L1to3_01_Loop"
data "CastSound" "Spell_Cast_Control_Friends_L0"
data "TargetSound" "Spell_Impact_Control_Friends_L0"
data "CastTextEvent" "Cast"
data "UseCosts" "ActionPoint:1;"
data "SpellAnimation" "554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;af94aac1-d8eb-4ccb-9520-694ade11b61c,,;f5db4001-b136-4c48-9aa4-026c4a7dd3b7,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,"
data "VerbalIntent" "Control"
data "SpellStyleGroup" "Class"
data "SpellFlags" "IsSpell;HasSomaticComponent;IsConcentration"
data "PrepareEffect" "2fa6b127-6f8a-4150-8be6-6f62b7a85911"
data "CastEffect" "d2ef6b50-243f-478d-85c6-892086a1477e"
data "TargetEffect" "e1b340b6-78a9-413a-bb7e-8299848238ae"
```

`Spell_Target.txt:1450`
```
new entry "Target_Arcana_Util_Friends_EX"
type "SpellData"
data "SpellType" "Target"
using "Target_Arcana_Util_Friends"
data "Level" "10"
data "SpellProperties" "ApplyStatus(FRIENDS_EX,100,-1);"
data "DisplayName" "h4111be6egc09dgecd7g156eg3d695beb346d;1"
data "Description" "h74b1ce07gffdbgf84fgf853gddb733fa8f51;1"
data "TooltipStatusApply" "ApplyStatus(FRIENDS_EX,100,-1)"
data "TooltipPermanentWarnings" ""
data "SpellFlags" "IsSpell;HasSomaticComponent;Temporary"
data "FollowUpOriginalSpell" "Target_Arcana_Util_Friends"
```

`Passive.txt:162`
```
new entry "Arcana_Passive_UnlockFriends"
type "PassiveData"
data "DisplayName" "h8709ef7ag7a77ge454g2615g595ec90f59ad;2"
data "Properties" "IsHidden"
data "BoostContext" "OnCreate"
data "Boosts" "UnlockSpell(Target_Arcana_Util_Friends);"
```

`Status_BOOST.txt:1212`
```
new entry "FRIENDS_EX"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hef9df044g0f98g86c7gf05dg844b7e9823fb;1"
data "Description" "he6c82a0fg9891gb564g6c3cgd0e2b8669f44;1"
data "Icon" "Spell_Enchantment_Friends"
data "StackId" "FRIENDS_EX"
data "StackType" "Ignore"
data "Boosts" "Advantage(SourceDialogue,Charisma)"
```

### C6. Heartbreak and the Beloved interrupt (Aspect card, Tier III)

`Spell_Shout.txt:2044`
```
new entry "Shout_Arcana_Created_Aspect_Heartbreak"
type "SpellData"
data "SpellType" "Shout"
data "Level" "0"
data "SpellSchool" "Enchantment"
data "Cooldown" "OncePerCombat"
data "SpellProperties" "ApplyStatus(HEARTBREAK_TECH,100,1);DealDamage(LevelMapValue(D4Cantrip),Psychic,Magical);IF(not Dead()):ApplyStatus(CHARMED,100,1)"
data "AreaRadius" "18"
data "TargetConditions" "Character() and Enemy() and not Dead() and HasStatus('SIGIL', context.Target, context.Source) and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Spell_Necromancy_BestowCurse"
data "DisplayName" "h9ed9041dge71bgd725g7979g8d0a8ec029f8;1"
data "Description" "hde429439g6dcdg1161gde8fg0a5d1e53ee68;2"
data "DescriptionParams" "DealDamage(LevelMapValue(D4Cantrip),Psychic)"
data "TooltipDamageList" "DealDamage(LevelMapValue(D4Cantrip),Psychic)"
data "TooltipStatusApply" "ApplyStatus(CHARMED,100,1)"
data "CastSound" "Spell_Cast_Monk_WholenessOfBody_L1to3"
data "PreviewCursor" "Cast"
data "CastTextEvent" "Cast"
data "UseCosts" "ActionPoint:1;"
data "SpellAnimation" "355a5479-07c9-4a34-9ab6-3b2669fdd248,,;,,;2ac8ee64-6d74-4cad-a74c-660ef3fc3d06,,;5bf6f6e6-353e-40f9-9a6f-0d6d16e19496,,;1c5627cb-6352-454b-9b84-c5b10ef2d201,,;,,;1cc6ba3b-fa78-48f8-858c-ac4c78fdb8fc,,;,,;,,"
data "VerbalIntent" "Control"
data "SpellStyleGroup" "Class"
data "SpellFlags" "IsSpell;IsHarmful;HasVerbalComponent"
data "HitAnimationType" "None"
data "Requirements" "Combat"
data "DamageType" "Psychic"
```

`Status_BOOST.txt:2360`
```
new entry "HEARTBREAK_TECH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hbde3b28fgfb7fg967cgfb95g98b5d38881cf;1"
data "StackId" "HEARTBREAK_TECH"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
```

`Interrupt.txt:87`
```
new entry "Interrupt_Arcana_Aspect_Beloved"
type "InterruptData"
data "DisplayName" "haa80f497g54c5g9a00gecd3g60c6ac209ae2;1"
data "Description" "h05dd7086ge061g41a7gcec7gf949f1cee924;2"
data "Icon" "PassiveFeature_InstinctiveCharm"
data "InterruptContext" "OnSpellCast"
data "InterruptContextScope" "Self"
data "Container" "YesNoDecision"
data "Conditions" "Self(context.Target,context.Observer) and HasStringInSpellRoll('Attack') and not AnyEntityIsItem()"
data "Roll" "not SavingThrow(Ability.Wisdom, SourceSpellDC(14,context.Observer,Ability.Intelligence),AdvantageOnCharmPerson(),false,context.Source)"
data "Success" "Counterspell();ApplyStatus(OBSERVER_SOURCE,CHARMED,100,1);IF(HasAnyExtraAttack(context.Source)):ApplyStatus(SELF,EXTRA_ATTACK_Q,100,1);IF(not HasAnyExtraAttack(context.Source)):ApplyStatus(SELF,EXTRA_ATTACK,100,1);"
data "Cost" "ArcanaBeloved:1"
data "InterruptDefaultValue" "Ask;Enabled"
data "EnableCondition" "HasActionResource('ArcanaBeloved', 1, 0, false, false, context.Source);"
data "EnableContext" "OnActionResourcesChanged"
```

### C7. Empress tier passives and statuses

`Passive.txt:640`
```
new entry "Arcana_Passive_Aspect_Empress_Awakening"
type "PassiveData"
data "DisplayName" "h62f64796g34edg43a1g847fg57470a1fe8b0;1"
data "Description" "h8881b09bgce68g9efbg5381g5c6b0980ad97;2"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "Highlighted"
```

`Passive.txt:647`
```
new entry "Arcana_Passive_Aspect_Empress_I"
type "PassiveData"
data "DisplayName" "h90c35527gc161g2f05ge3f0g79299d1337ce;2"
data "Description" "h2378df51g4857ga0feg5195g0b9b91142b92;3"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "IsHidden"
```

`Passive.txt:654`
```
new entry "Arcana_Passive_Aspect_Empress_II"
type "PassiveData"
data "DisplayName" "h3c52bd83g3771gf057g15c4g02fc3ee37643;2"
data "Description" "h4fcbc57eg47fbga22dg3dc5g95429133cbb9;2"
data "DescriptionParams" "Distance(6)"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "IsHidden"
```

`Passive.txt:662`
```
new entry "Arcana_Passive_Aspect_Empress_III"
type "PassiveData"
data "DisplayName" "h77a96793gb7edg0637g7edagadeac5101250;2"
data "Description" "hc6233dddg7b75g1f90g74acgcae8cb86d424;3"
data "DescriptionParams" "3"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "IsHidden"
```

`Passive.txt:518`
```
new entry "Arcana_Passive_Aspect_Empress_Awakened_III"
type "PassiveData"
data "DisplayName" "h77a96793gb7edg0637g7edagadeac5101250;2"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "IsHidden"
data "Boosts" "Ability(Charisma,3);UnlockInterrupt(Interrupt_Arcana_Aspect_Beloved);ActionResource(ArcanaBeloved,1,0);"
```

`Passive.txt:525`
```
new entry "Arcana_Passive_Aspect_Empress_Awakened_III_Damage"
type "PassiveData"
data "DisplayName" "h77a96793gb7edg0637g7edagadeac5101250;2"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "IsHidden"
data "Boosts" "IF(IsCardSpell() or IsArcanaCantrip()):DamageBonus(max(0, CharismaModifier));"
```

`Status_BOOST.txt:2561`
```
new entry "ASPECT_PROGRESS_EMPRESS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "he5459358gdc89g382dgf2ffg85449e100f4f;2"
data "Description" "h0040093bg3775ga996ge868g666094354c8f;2"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "ASPECT_PROGRESS_EMPRESS"
data "StackType" "Overwrite"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "FreezeDuration;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"
```

`Status_BOOST.txt:2303`
```
new entry "ASPECT_AWAKENED_EMPRESS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h7a713daagf15cg1f59g4ffag2ad246135a37;1"
data "Description" "h78acc58bg1d8eg4074gd475gae351fed52c8;1"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "ASPECT_AWAKENED_EMPRESS"
data "StackType" "Ignore"
data "Boosts" "UnlockSpell(Shout_Arcana_Created_Aspect_Heartbreak);"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "IgnoreResting;DisableOverhead;DisableCombatlog;DisablePortraitIndicator"
data "OnRemoveFunctors" "RemoveStatus(ASPECT_AWAKENED_EMPRESS_I);RemoveStatus(ASPECT_AWAKENED_EMPRESS_II);RemoveStatus(ASPECT_AWAKENED_EMPRESS_III)"
data "StatusGroups" "SG_RemoveOnRespec"
data "StatusEffect" "d37fab67-6932-44c4-995e-f051d7027fc5"
```

`Status_BOOST.txt:2318`
```
new entry "ASPECT_AWAKENED_EMPRESS_I"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h0e72ec1cg3cafgba92g7726gaefdcef7004c;1"
data "Description" "h178a7e2fg4d20g3495g70abg09b858d8310f;1"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "ASPECT_AWAKENED_EMPRESS_TIER"
data "StackPriority" "1"
data "StackType" "Overwrite"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "ForceOverhead;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"
```

`Status_BOOST.txt:2331`
```
new entry "ASPECT_AWAKENED_EMPRESS_II"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "hcbf532ceged1bg0decg2931g0e280f16ffa0;1"
data "Description" "h276f6c80g8b5dgf22agcc4fgc1770431d3e4;1"
data "DescriptionParams" "Distance(6)"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "ASPECT_AWAKENED_EMPRESS_TIER"
data "StackPriority" "2"
data "StackType" "Overwrite"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "ForceOverhead;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"
```

`Status_BOOST.txt:2345`
```
new entry "ASPECT_AWAKENED_EMPRESS_III"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "ha70e3c76g0e2eg35e6g2b4bg508090c7e688;1"
data "Description" "hb4946910g6b9agab74g91b3g4fd86b62a6b0;1"
data "DescriptionParams" "Distance(6);3"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "ASPECT_AWAKENED_EMPRESS_TIER"
data "StackPriority" "3"
data "StackType" "Overwrite"
data "Passives" "Arcana_Passive_Aspect_Empress_Awakened_III;Arcana_Passive_Aspect_Empress_Awakened_III_Damage"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "ForceOverhead;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"
```

### C8. Telepathy (kept)

`Passive.txt:153`
```
new entry "Arcana_Passive_Telepathy"
type "PassiveData"
data "DisplayName" "h87105db1gb18ag4156gf9abgd43725d9eb27;1"
data "Description" "h7842e27dg8735g34a2g4b1eg277ee1e249ea;3"
data "Icon" "Action_ReadThoughts"
data "Properties" "Highlighted"
data "BoostContext" "OnCreate"
data "Boosts" "Tag(DETECTTHOUGHTS)"
```

---

## D. Osiris: structural summary of the Deceiver goals

Goal files: `$G/Mods/$M/Story/RawFiles/Goals/`. Line numbers refer to those files. All use `Version 1 / SubGoalCombiner SGC_AND`. Comments are in Portuguese in the files; this summary is in English.

### D1. `ARCANA_Spell_MirrorImage.txt` (77 lines) - the full clone

- **DBs** (INITSECTION, declare-then-NOT idiom): `DB_MirrorImage(CHARACTER duplicity, CHARACTER player)` (transient setup), `DB_OriginalPlayerLevel(CHARACTER, INTEGER)` (transient), `DB_ARCANA_MirrorImageOf(CHARACTER duplicity, CHARACTER owner)` (lives as long as the clone).
- **Events and flow:**
  1. `StatusApplied(_Duplicity, "MIRROR_IMAGE_TECHNICAL", _Player, _)` + `GetLevel(_Player,_Level)` -> inserts the three DBs, `RealtimeObjectTimerLaunch(_Duplicity, "SummonCloneTimer", 300)`.
  2. `ObjectTimerFinished(_Duplicity, "SummonCloneTimer")` -> `Transform(_Duplicity, _Player, MirrorImage_cb43e6d5-462d-4a3a-83c2-0108115e71f0)`, `SetLevel(_Duplicity,_Level)`, timer `"Delay_Timer_Clone"` 200 ms.
  3. `ObjectTimerFinished(_Duplicity, "Delay_Timer_Clone")` -> `CopyCharacterEquipment`; `RemoveSpell` + `AddSpell` (so they reach the hotbar) of `Target_Deceiver_Clone_MirrorEtherealChains` and `Target_Deceiver_Clone_MirrorDistortion`; `RemoveSpell(Shout_Dismiss_Self)` + `AddSpell(Shout_Deceiver_Clone_Dismiss)`; `RemoveStatus(MIRROR_IMAGE_TECHNICAL)`; deletes `DB_MirrorImage` and `DB_OriginalPlayerLevel`.
  4. Cleanup of `DB_ARCANA_MirrorImageOf` on `Died((CHARACTER)_Duplicity)`, `CastSpell(_Duplicity, "Shout_Dismiss_Self", ...)`, `CastSpell(_Duplicity, "Shout_Deceiver_Clone_Dismiss", ...)`.
- **Calls used:** `Transform`, `SetLevel`, `GetLevel`, `CopyCharacterEquipment`, `AddSpell`, `RemoveSpell`, `RemoveStatus`, `RealtimeObjectTimerLaunch`.
- **Not handled today:** no cap, no end-of-combat / long-rest cleanup (the summon is permanent, lifetime -1), no AC layers, no killer detection. Timer names are not `ARCANA_`-prefixed (`SummonCloneTimer`, `Delay_Timer_Clone`).
- **Cross-goal:** `DB_ARCANA_MirrorImageOf` is read by `ARCANA_Status_Sigil.txt` (lines 13 and 22). No other goal reads `DB_MirrorImage` or `DB_OriginalPlayerLevel`.

### D2. `ARCANA_Spell_Withdraw.txt` (85 lines) - Withdraw for Distortion

- **DBs** (not declared in INITSECTION): `DB_Withdraw_Position(CHARACTER, X, Y, Z)`, `DB_Withdraw_Marker(CHARACTER, ITEM)`.
- **PROCs:** `PROC_ARCANA_Withdraw_ClearPosition`, `_ClearMarker` (`RequestDelete((ITEM)_Marker)`), `_Clear` (`ObjectTimerCancel(_Caster,"ARCANA_Withdraw_Timer")`, `RemoveSpell(_Caster,"Shout_Arcana_Created_Withdraw",0)`).
- **Events:**
  - `UsingSpell(_Caster, _ArcanaSpell, ...)` + `DB_ARCANA_CardFamily(_ArcanaSpell, "Target_Arcana_Card_Spell_Distortion")` + `GetPosition` -> stores the origin, `AddSpell(_Caster,"Shout_Arcana_Created_Withdraw",1,0)`, `ObjectTimerLaunch(_Caster,"ARCANA_Withdraw_Timer",12000,1)` (2 turns).
  - second `UsingSpell` rule -> `ApplyStatus(_Caster,"DISTORTION_HELPER",12.0,1,_Caster)`.
  - `EnteredLevel((ITEM)_Marker, c3c514b2-152d-4a01-9e7d-e49d1062d2f0, _)` + `GetPosition` + `GetDistanceToPosition` < 1.0 from the stored origin -> `DB_Withdraw_Marker`. The item is the 2-turn marker that `Target_Arcana_Card_Spell_Distortion` summons at the origin (`Summon(SELF,c3c514b2-...,2)`); template `ARCANA_ITEM_Spell_DistortionPosition` (type item).
  - `ObjectTimerFinished` -> `_Clear`.
  - `CastSpell(_Caster, _ArcanaSpell, ...)` + family `"Shout_Arcana_Created_Withdraw"` + stored position -> `AppearAtPosition(_Caster,X,Y,Z,0,CUST_MizoraTeleIn_01_99069369-88a0-4580-84ab-aa34788cb509,"Created0",1)`, `_Clear`.
- **Calls used:** `GetPosition`, `AppearAtPosition` (not `TeleportTo`), `AddSpell`, `RemoveSpell`, `ApplyStatus`, `ObjectTimerLaunch/Cancel`, `RequestDelete`.
- **Cross-goal:** reads `DB_ARCANA_CardFamily` (generated by `ARCANA_CardFamilies.txt`). Nothing reads the Withdraw DBs outside this goal.

### D3. `ARCANA_Spell_MimicWithdraw.txt` (85 lines)

Same as D2 with: `DB_MimicWithdraw_Position/_Marker`, family `"Target_Arcana_Created_MimicDistortion"`, spell `Shout_Arcana_Created_MimicWithdraw`, status `MIMIC_DISTORTION_HELPER`, marker template `d88fb323-5015-4949-a65a-eb417a924d5d`, timer `ARCANA_MimicWithdraw_Timer`, `AppearAtPosition(..., "Created1", 1)`.

### D4. `ARCANA_Spell_MirrorWithdraw.txt` (79 lines) - the clone's Withdraw (goes away with the Mirror spells)

Same as D2 but not through `DB_ARCANA_CardFamily`: it matches the literal `UsingSpell((CHARACTER)_Caster, "Target_Deceiver_Clone_MirrorDistortion", ...)` and `CastSpell(..., "Shout_Deceiver_Clone_MirrorWithdraw", ...)`. DBs `DB_MirrorWithdraw_Position/_Marker`, status `MIRROR_DISTORTION_HELPER`, marker template `4441890b-a8c1-4c6d-8309-ec505adc7acc`, timer `ARCANA_MirrorWithdraw_Timer`, `AppearAtPosition(..., "Created1", 1)`.

### D5. `ARCANA_Status_Sigil.txt` (29 lines)

- No DBs of its own. Two rules on `StatusApplied(_Target, "SIGIL_TECH", _Caster, _)`:
  - when `DB_ARCANA_MirrorImageOf((CHARACTER)_Caster, _Owner)` holds and the target has no `SIGIL` (`HasActiveStatus(_Target,"SIGIL",0)`): `ApplyStatus(_Target,"SIGIL",-6.0,1,_Owner)` (mark in the owner's name);
  - otherwise (`NOT DB_ARCANA_MirrorImageOf(_Caster,_)`): `ApplyStatus(_Target,"SIGIL",-6.0,1,_Caster)`.
- The comment says the mark is held in the Deceiver's name so that the Deceiver detonates by origin and the clone by `GetSummoner` (see the `SIGIL` RemoveConditions in C3).
- **Cross-goal:** reads `DB_ARCANA_MirrorImageOf` from D1. The spec's "detonation also adds 1 Doubt" belongs on the `SIGIL_DETONATED_TECH` event, which today is handled in D6.

### D6. `ARCANA_Aspect_Empress.txt` (141 lines) - Obsession objective and Tier II

- **DBs** (not declared in INITSECTION): `DB_ARCANA_SigilOwner(Foe, Owner)`, `DB_ARCANA_EmpressChained(Deceiver)`, `DB_ARCANA_EmpressBest(Deceiver, Cand, REAL Dist)`.
- **Events:**
  - `StatusApplied((CHARACTER)_Foe, "SIGIL", (CHARACTER)_Owner, _)` -> `PROC_ARCANA_Empress_SetOwner` (replaces the row).
  - `StatusApplied((CHARACTER)_Foe, "SIGIL_DETONATED_TECH", _, _)` + `DB_ARCANA_SigilOwner(_Foe,_Deceiver)` -> removes the row, `PROC_ARCANA_Aspect_Step(_Deceiver, "EMPRESS")` (the counter in Common) and `PROC_ARCANA_Empress_Chain(_Deceiver,_Foe)`.
  - `PROC_ARCANA_Empress_Chain` (Tier II): needs `DB_ARCANA_AspectReached(_Deceiver, 2)`, not already chained this turn, `HasActiveStatus(_From,"HEARTBREAK_TECH",0)` (never from a Heartbreak detonation), and `DB_ARCANA_Aspect_InCombat(_Deceiver,_Combat)`; picks the nearest enemy without `SIGIL` within 6.0 (`IsEnemy`, `IsDead`, `HasActiveStatus`, `GetDistanceTo`) through `PROC_ARCANA_Empress_ClearBest/_Consider/_Offer/_Mark`, then `ApplyStatus(_Cand,"SIGIL",-6.0,1,_Deceiver)`.
  - `TurnStarted((CHARACTER)_Deceiver)` + `DB_ARCANA_EmpressChained` -> clears it (once per turn).
  - Extends `PROC_ARCANA_Aspect_Reset` (defined in Common) to clear the three DBs.
- **No** `PROC_ARCANA_Aspect_OnAwakened` / `_OnTier` hook for EMPRESS exists (Death, Fool and Star define them; Empress does not).
- **Cross-goal:** uses from `ARCANA_Aspect_Common.txt`: `PROC_ARCANA_Aspect_Step`, `PROC_ARCANA_Aspect_Reset`, `DB_ARCANA_AspectReached`, `DB_ARCANA_Aspect_InCombat`. Common holds the tier table `DB_ARCANA_AspectTier("EMPRESS", 1|2|3, passive, status, goal)` with goals **3 / 5 / 7** at `ARCANA_Aspect_Common.txt:51-53` (spec: 4 / 7 / 10), plus `DB_ARCANA_Aspect("EMPRESS", "ASPECT_PROGRESS_EMPRESS", "ASPECT_AWAKENED_EMPRESS", "Arcana_Passive_Aspect_Empress_I")` (line 43) and `DB_ARCANA_AspectShow("EMPRESS","COUNT")` (line 62). Common re-fills these tables on `SavegameLoaded()`.

### D7. `ARCANA_Spell_FacelessCopy.txt` (53 lines)

- **DB:** `DB_ARCANA_Copy_Active(Caster, Target)`.
- **Events:** `UsingSpellOnTarget((CHARACTER)_Caster,_Target,"Target_Arcana_Util_Faceless_Copy",_,_,_)` + `IsCharacter(_Target,1)` + `_Target != _Caster` -> clear, store, `ObjectTimerCancel(_Caster,"ARCANA_FacelessCopy_Timer")`, `RealtimeObjectTimerLaunch(_Caster,"ARCANA_FacelessCopy_Timer",800)`. `ObjectTimerFinished` -> `Transform(_Caster,_Target,(SHAPESHIFTRULE)FacelessCopy_3eb3fee7-67b4-46b5-a81a-2ac2da66bff7)`. `StatusRemoved((CHARACTER)_Caster,"FACELESS_COPY",_,_)` + DB -> `PROC_ARCANA_FacelessCopy_End` (`ObjectTimerCancel`, clear, `RemoveTransforms`).
- **Observed:** it launches a Realtime timer but cancels with `ObjectTimerCancel` (the EX goal uses `RealtimeObjectTimerCancel` for the same pattern). `FACELESS_COPY` is the POLYMORPHED status in `Status_POLYMORPHED.txt:6`.
- The "Rulebook" the spec asks about: the rule `FacelessCopy` (`3eb3fee7-...`) lives in `$G/Public/$M/Shapeshift/Rulebook.lsx` (Toolkit: `Editor/Mods/$M/Shapeshift/Rulebook.tbl`). See E6 and F.

### D8. `ARCANA_Spell_FacelessCopy_EX.txt` (70 lines) - already dead

- **DB:** `DB_ARCANA_CopyEX_Active`. Procs `PROC_ARCANA_FacelessCopyEX_Clear/_End`. Timers `ARCANA_FacelessCopyEX_Timer`, `_Timer2`.
- Triggers on `DB_ARCANA_CardFamily(_ArcanaSpell, "Target_Arcana_Card_Spell_Faceless_Copy_EX")` (that spell is **not** in the stats any more), on `StatusRemoved(..., "NEMESIS_OWNER", ...)` (calls `UseSpell(_Caster, "Shout_Arcana_Util_Faceless_Cancel", _Caster)` with 3 arguments, while the header declares 5) and on `StatusRemoved(..., "FACELESS_COPY_EX", ...)` (status also absent from the stats). Reuses the same `Transform` rule `FacelessCopy_3eb3fee7-...`.
- Nothing else reads `DB_ARCANA_CopyEX_Active`.

### D9. `ARCANA_Passive_MirroredSpell.txt` (95 lines) - Mirrored Spell (Deceiver card, kept)

- **DBs** (INITSECTION): `DB_ARCANA_MirroredSpellHolder(CHARACTER)`, `DB_ARCANA_MirroredSpell(CHARACTER holder, STRING spell)`.
- **QRY** `QRY_ARCANA_MirroredSpell_CanCopy(_Caster,_Spell,_Holder)`: `SpellHasSpellFlag(_Spell,"IsSpell",1)`, `_Caster != _Holder`, `HasSpell(_Holder,_Spell,0)`, `GetDistanceTo(_Caster,_Holder) <= 18.0`.
- **Events:** `StatusApplied/Removed(_Holder,"MIRRORED_SPELL_ON",...)` keeps `DB_ARCANA_MirroredSpellHolder`; `CastedSpell((CHARACTER)_Caster,_Spell,...)` + holder DB + the query -> returns the pending spell, `AddSpell(_Holder,_Spell,1,0)`, stores it, `ApplyStatus(_Holder,"MIRRORED_SPELL_HELPER",-1.0,1,_Holder)`, `ObjectTimerLaunch(_Holder,"ARCANA_MirroredSpell_Timer",18000,1)`; `CastedSpell((CHARACTER)_Holder,_Spell,...)` using the copy -> removes it; `ObjectTimerFinished` -> returns it.
- The `_Caster` is **any** character (no summon or ally filter). A Double casting an `IsSpell` spell within 18 m will trigger a copy into the holder's spellbook if the holder does not already have that spell (see F).

### D10. Common goal pieces the Deceiver depends on (`ARCANA_Aspect_Common.txt`, 314 lines) and `ARCANA_CardFamilies.txt`

- Common: `DB_ARCANA_Aspect`, `DB_ARCANA_AspectTier`, `DB_ARCANA_AspectShow` (tables), `DB_ARCANA_Aspect_InCombat` (fed by `EnteredCombat` / `LeftCombat`), `DB_ARCANA_AspectReached`, `DB_ARCANA_AspectNext`, `DB_ARCANA_Aspect_Steps`; procs `PROC_ARCANA_Aspect_Step` (counter, only `IsInCombat(_Char,1)`), `_Progress`, `_Offer`, `_Awaken` (Tier I also applies the technical `ASPECT_AWAKENED_<X>`, then `_OnAwakened`; every tier applies its tier status then `_OnTier`), `_FindNext`, `_Display` / `_ShowNumber` (progress as a status whose duration encodes the count, 6 s per unit), `_Reset`.
- CardFamilies: **generated** by `tools/stats/gen_upcast_variants.pl` ("nao edite a mao"); one `DB_ARCANA_CardFamily(variant, root)` row per upcast variant, rebuilt wholesale on every run. Of the 386 lines that mention `DB_ARCANA_CardFamily` in the Goals, 376 are in this file; the rest are rules in Withdraw, MimicWithdraw, FacelessCopy_EX, Death, Fool and Star.

### Cross-goal DB map (Deceiver)

| DB / PROC | Written by | Read by |
|---|---|---|
| `DB_ARCANA_MirrorImageOf` | MirrorImage (D1) | Status_Sigil (D5) |
| `DB_ARCANA_SigilOwner` | Empress (D6) | Empress only |
| `DB_ARCANA_CardFamily` | CardFamilies (generated) | Withdraw, MimicWithdraw, FacelessCopy_EX; also Death/Fool/Star goals |
| `DB_ARCANA_AspectReached`, `DB_ARCANA_Aspect_InCombat`, `PROC_ARCANA_Aspect_Step/_Reset` | Common | Empress |
| `DB_ARCANA_Copy_Active` | FacelessCopy | FacelessCopy only |
| `DB_Withdraw_*`, `DB_MimicWithdraw_*`, `DB_MirrorWithdraw_*` | their own goal | their own goal |

---

## E. Vanilla facts and the mod's own plumbing

Vanilla sources are the extracted trees in `C:/Projetos/BG3 Modding/Base Game BG3/Assets/` (`Shared_Extracted/Public/Shared` and `.../SharedDev`, `Gustav_Extracted`). Osiris signatures are copied from `$G/Mods/$M/Story/RawFiles/story_header.div`.

### E1. INVOKE_DUPLICITY (what the spec calls "the Invoke Duplicity shimmer")

The visual effect is **not** on `INVOKE_DUPLICITY` itself.

| Status | Where | Facts |
|---|---|---|
| `INVOKE_DUPLICITY` | `Shared_Extracted/Public/Shared/Stats/Generated/Data/Status_BOOST.txt:3363` | `StatusType BOOST`; `StackId INVOKE_DUPLICITY`; `Boosts IF(HasStatus('INVOKE_DUPLICITY',context.Source)):SourceAllyAdvantageOnAttack()`; `StatusGroups SG_RemoveOnRespec`; `ManagedStatusEffectType Positive`, `ManagedStatusEffectGroup 6435c10a-c67d-4f79-8813-b84b0762f92b`. **No `StatusEffect`, no `ApplyEffect`.** It is the buff the aura gives to allies. |
| `INVOKE_DUPLICITY_AURA` | same file, line 3376 | `BOOST`; `AuraRadius 3`; `AuraStatuses TARGET:IF(Character() and not SummonOwner()):ApplyStatus(INVOKE_DUPLICITY)`; **`StatusEffect d798b3cf-15ab-4911-9884-82799e6fd3ef`** (the shimmer); `SoundLoop Spell_Status_InvokeDuplicity_Aura_MO`, `SoundStop ..._Stop`; flags `DisableOverhead;DisableCombatlog;DisablePortraitIndicator`. So reusing the aura also gives nearby allies the vanilla Invoke Duplicity advantage. |
| `INVOKE_DUPLICITY_TECHNICAL` | `Shared_Extracted/Public/SharedDev/Stats/Generated/Data/Status_INVISIBLE.txt:128` | `INVISIBLE` type, `using INVISIBLE` (so it inherits that status's `StatusEffect d26436d4-d019-4dfc-b2f1-da0ac195575f` and material replacement); `Boosts ""`, `RemoveEvents ""`, `RemoveConditions` inherited; **`OnRemoveFunctors ApplyStatus(INVOKE_DUPLICITY_AURA,100,-1)`** (this is what attaches the shimmer after setup). |

Vanilla flow (`Gustav_Extracted/Mods/GustavDev/Story/RawFiles/Goals/GLO_Spells_PostEA.txt:736-751`): `StatusApplied(_Duplicity,"INVOKE_DUPLICITY_TECHNICAL",_Player,_)` -> `CopyCharacterEquipment` + `RealtimeObjectTimerLaunch(_Duplicity,"InvokeDuplicity",100)`; on the timer `Transform(_Duplicity,_Player,INVOKEDUPLICITY_296bcfb3-9dab-4a93-8ab1-f1c53c6674c9)` then `RemoveStatus(...TECHNICAL...)`.
Vanilla spell `Target_InvokeDuplicity` (`Shared_Extracted/.../Spell_Target.txt:5490`): `GROUND:...Summon(<race/gender template>, 10,,,InvokeDuplicityStack,INVOKE_DUPLICITY_TECHNICAL)` per race tag, `TargetRadius 9`, `UseCosts ActionPoint:1;ChannelDivinity:1`, `SpellFlags IsConcentration;CannotTargetItems;CannotTargetCharacter`, `PrepareEffect d71f28ac-e1b7-4169-9670-a3cc1e338dc3`, `CastEffect 5215e8c4-dab6-49c5-8d5f-c1bd806c1938`, `PositionEffect e51ca7f4-8947-43a1-a95f-a0a0e9d8156e`, sounds `Spell_Cast_Summon_InvokeDuplicity_L1to3` / `Spell_Impact_Summon_InvokeDuplicity_L1to3`, icon `Action_Cleric_InvokeDuplicity`. The mod's Mirror Image card reuses those effect ids, sounds and icon.

What the mod does today with the technical status (`Status_INVISIBLE.txt`, see C1): `MIRROR_IMAGE_TECHNICAL` is `using INVOKE_DUPLICITY_TECHNICAL` with `Boosts`, `RemoveEvents`, `RemoveConditions`, `OnRemoveFunctors`, `StatusGroups` and `StatusEffect` all set to `""`. So today the clone has **no shimmer and no aura**; it is only a marker for Osiris.

### E2. Template 8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8 (the Summon template)

It is **not a vanilla template**: it is a RootTemplate owned by the mod, `$G/Public/$M/RootTemplates/8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8.lsf` (4653 bytes, dated 2026-09-24). The LSF was converted to LSX with Divine into the scratchpad only to read it (no vanilla extract contains the GUID in text; LSF is binary so this is not proof of absence, but the mod-side file is).

| Field | Value |
|---|---|
| `Name` | `ARCANA_CHAR_CreateClone_1` |
| `Type` | `character` |
| `ParentTemplateId` | `f0930afd-8be6-410e-bae3-b0253262f861` (not in the mod; not found in the project docs) |
| `Stats` | `Clone_1` (Character entry, see C1: Level 1, STR 8 DEX 12 CON 10 INT 16 WIS 14 CHA 18, `Armor 10`, `Vitality 8`, `ActionResources ActionPoint:1;BonusActionPoint:1;Movement:9;ReactionActionPoint:1`, `Passives AttackOfOpportunity;DarknessRules`) |
| `SpellSet` | `CommonPlayerActions` |
| `DisplayName` | handle `h7ce24c2bg5830g1f25gda97gc927f6e8e6b1` (english.xml:57, text `Clone`) |
| Visual / icon | `CharacterVisualResourceID 015bd884-82d1-cc15-2a0f-0cb8524028f4`, `PortraitVisualResourceID f7af9f10-cd33-3b88-e96a-d52952e81f5b`, icon `EQP_InvokeDuplicity_(Icon_Elf_Male)` |
| Other | `ForceLifetimeDeath True`, `DeathEffect 75329f47-87fc-4498-9612-833503daa22c`, `IsPlayer False`, `CanFight True`, `CanBePickedUp True`, `IsLootable False`, tag `25bf5042-5bf6-4360-8df8-ab107ccb0d37`, two speaker groups |
| `SkillList` (AI skills) | `Shout_Dismiss_Self`, `Target_Deceiver_Clone_MirrorDistortion`, `Target_Deceiver_Clone_MirrorEtherealChains`, `Projectile_Deceiver_Clone_MirrorSigilofMalice`, `Target_Arcana_Card_Spell_MaliciousWhispers` |

Sibling `RootTemplates/4267f207-3e8b-4431-99e0-ba91eb29a836.lsf` = `ARCANA_CHAR_CreateClone_2`: identical except `Name` and a different `DisplayName` handle (`h091e2391...`, english.xml:732, `Clone`). Nothing in the mod text references 4267f207.

Where the mod uses 8807d230 (`Spell_Target.txt`, Target_Arcana_Card_Spell_MirrorImage, line 1288, and its `TargetConditions` line):
`GROUND:Summon(8807d230-d0f5-4aa5-b6e4-4b36e9da2ec8,-1,,,CreateCloneStack1,MIRROR_IMAGE_TECHNICAL,MIRROR_IMAGE_CLONE_SCALING);` with `TargetConditions CanStand('8807d230-...') and not Character() and not Self() and not HasPassive('ARCANA_IS_CARD', context.Source)`.
Observed shape of `Summon(template, lifetime, <spell>, <>, '<StackId>', <status>, <status>...)`: lifetime `-1` / `Permanent` = no expiry; the stack id is what vanilla uses to limit one summon per stack (for example `'CombatSummonStack'`, `InvokeDuplicityStack`); the trailing items are statuses applied to the new summon. The clone gets `MIRROR_IMAGE_TECHNICAL` (marker) and `MIRROR_IMAGE_CLONE_SCALING` (`IncreaseMaxHP(Owner.Level*6);ProficiencyBonusOverride(Owner.LevelMapValue(StandardProficiencyBonusScale));RollBonus(Attack,Owner.SpellCastingAbilityModifier)`).
The Distortion cards summon item markers the same way: `Summon(SELF,c3c514b2-...,2)` (item `ARCANA_ITEM_Spell_DistortionPosition`); the Mimic and Mirror variants use `d88fb323-...` and `4441890b-...`.

### E3. CONFUSION

`Shared_Extracted/Public/SharedDev/Stats/Generated/Data/Status_BOOST.txt:693`:

```
new entry "CONFUSION"
type "StatusData"
data "StatusType" "BOOST"
using "MADNESS"
data "DisplayName" "h565dc60cg50f9g4b42g9cfeg9719eb41dbc9;2"
data "Description" "hda18ccb3g91b7g4511g95b4g228dd5254e9b;2"
data "Icon" "Spell_Enchantment_Confusion"
data "StackPriority" "2"
data "RemoveConditions" "SavingThrow(Ability.Wisdom, SourceSpellDC())"
data "RemoveEvents" "OnTurn"
data "TooltipSave" "Wisdom"
data "OnRemoveFunctors" "RemoveStatus(CONFUSION_SKIP)"
data "OnTickRoll" "RollDieAgainstDC(DiceType.d20, 11)"
data "OnTickFail" "IF(HasStatus('CONFUSION')):ApplyStatus(CONFUSION_SKIP,100,1,,,,,true)"
data "StatusGroups" "SG_Confused"
```

- It is a **BOOST** status (no BOOST copy is needed for R5). It inherits from `MADNESS` (`Shared_Extracted/Public/Shared/Stats/Generated/Data/Status_BOOST.txt:2097`): `StackId MADNESS`, `Boosts AiArchetypeOverride(madness,99)` (the "confusion archetype"), `StatusPropertyFlags LoseControl;OverheadOnTurn;InitiateCombat;BringIntoCombat`, `StatusEffect 127d9e0b-b235-4e98-8037-f1353b554b47`, sounds, `StillAnimationType Mental`.
- Its `StatusGroups` is overridden to `SG_Confused` only, so it is **not** in `SG_Mad` (`SG_Mad` = CROWN_OF_MADNESS, HAG_INSANITYS_KISS, MADNESS, MAG_DEATH_DO_SHADOW_POSSESION, MAG_ZHENTARIM_DEMONSPIRIT_MADNESS, SHA_NECROMANCER_FLESH_BERSERK).
- `CONFUSION_SKIP`: `INCAPACITATED` type, `using CONFUSION_RAY`, icon `statIcons_Confusion_SkipTurn`.
- Behaviour: each turn start (`RemoveEvents OnTurn`) a Wisdom save against `SourceSpellDC()` ends it; each tick rolls d20 vs 11 and on a fail applies `CONFUSION_SKIP` for 1 turn.
- The mod already applies it: `Target_Arcana_Card_Spell_HostileTakeover` (`SpellSuccess AI_IGNORE:ApplyStatus(CONFUSION,100,5);AI_ONLY:ApplyStatus(PARALYZED,100,5)`).

### E4. Exact status group names

Verified by collecting every `StatusGroups` value of every `Status_*.txt` in the four extracted trees (`Shared`, `SharedDev`, `Gustav`, `GustavDev`):

| Concept | Group | Statuses in it (vanilla) |
|---|---|---|
| Charm (any kind, incl. Dominate, Friends) | `SG_Charmed` (17) | CHARMED, CHARM_ANIMALS_AND_PLANTS, CROWN_OF_MADNESS, DOMINATE_BEAST, DOMINATE_PERSON, FRIENDS, **HYPNOTIC_GAZE**, HYPNOTIC_PATTERN, INCUBUS_CHARM, IRRESISTIBLE_DANCE, LURING_SONG, MIND_MASTERY, PLANAR_BINDING, ... |
| Subtle charm (what CHARMED / FRIENDS carry) | `SG_Charmed_Subtle` | CHARMED, CHARM_ANIMALS_AND_PLANTS, FRIENDS, LOW_CAZADORSPALACE_CHARM_VFX |
| Madness | `SG_Mad` (6) | CROWN_OF_MADNESS, HAG_INSANITYS_KISS, MADNESS, MAG_DEATH_DO_SHADOW_POSSESION, MAG_ZHENTARIM_DEMONSPIRIT_MADNESS, SHA_NECROMANCER_FLESH_BERSERK |
| Possession | `SG_Possessed` (7) | HAG_MASK_CONTROLLED, HAG_MASK_CONTROLLED_NPC, INCUBUS_CHARM, LOW_GHOST_POSSESSED, LOW_OSKARSBELOVED_OSKARPOSSESSED, LOW_OSKARSBELOVED_POSSESSEDPORTRAIT, MAG_DEATH_DO_SHADOW_POSSESION |
| Domination | `SG_Dominated` (6) | CONTROL_UNDEAD, DOMINATE_BEAST, **DOMINATE_PERSON** (also `SG_Charmed`), INCUBUS_CHARM, LOW_FATHERCARRION_FATHEROFTHEDEAD, PLANAR_BINDING |
| Fleeing fear | `SG_Fleeing` (3) | COMMAND_FLEE, **FEARED**, TURNED (FEARED also carries `SG_Frightened;SG_Condition`) |
| Frightened (not the same group) | `SG_Frightened` (7) | FEARED, FRIGHTENED, MEENLOCK_FEAR, TURN_THE_UNHOLY, ... |
| Confusion | `SG_Confused` (2) | CONFUSION, TIMMASK_SPORES |

The mod already tests a group this way: `IsImmuneToStatus('SG_Charmed')` in `Target_Arcana_Card_Spell_HypnoticGaze`.
Spec D6 lists `SG_Charmed`, `SG_Mad`, `SG_Possessed`, `SG_Fleeing` and Dominate; `SG_Dominated` exists as a group, and `DOMINATE_PERSON` is in both `SG_Charmed` and `SG_Dominated` (so `SG_Charmed` already covers Marionette's status).

### E5. Osiris signatures (copied from `story_header.div`)

Trailing internal numbers `(n,n,n,n)` removed. The mod has no `GetSummoner` query for Osiris; `CharacterGetOwner` is the owner query. In Stats/Khonsu `GetSummoner(context.Source)` does exist (used in `SIGIL.RemoveConditions`).

```
call UseSpell((GUIDSTRING)_Caster, (STRING)_SpellID, (GUIDSTRING)_Target, (GUIDSTRING)_Target2, (INTEGER)_WithoutMove)
call UseSpellAtPosition((GUIDSTRING)_Caster, (STRING)_SpellID, (REAL)_X, (REAL)_Y, (REAL)_Z, (INTEGER)_WithoutMove)
call TeleportTo((GUIDSTRING)_SourceObject, (GUIDSTRING)_TargetObject, (STRING)_Event, (INTEGER)_TeleportLinkedCharacters, (INTEGER)_TeleportPartyFollowers, (INTEGER)_TeleportSummons, (INTEGER)_LeaveCombat, (INTEGER)_SnapToGround)
call TeleportToPosition((GUIDSTRING)_SourceObject, (REAL)_X, (REAL)_Y, (REAL)_Z, (STRING)_Event, (INTEGER)_TeleportLinkedCharacters, (INTEGER)_TeleportPartyFollowers, (INTEGER)_TeleportSummons, (INTEGER)_LeaveCombat, (INTEGER)_SnapToGround)
call Transform((GUIDSTRING)_Object, (GUIDSTRING)_TargetTemplate, (SHAPESHIFTRULE)_ShapeshiftRules)
call RemoveTransforms((GUIDSTRING)_Object)
event AttackedBy((GUIDSTRING)_Defender, (GUIDSTRING)_AttackerOwner, (GUIDSTRING)_Attacker, (STRING)_DamageType, (INTEGER)_DamageAmount, (STRING)_DamageCause, (INTEGER)_StoryActionID)
event KilledBy((CHARACTER)_Defender, (GUIDSTRING)_AttackOwner, (GUIDSTRING)_Attacker, (INTEGER)_StoryActionID)
event Died((CHARACTER)_Character)
event Dying((CHARACTER)_Character)
event StatusApplied((GUIDSTRING)_Object, (STRING)_Status, (GUIDSTRING)_Causee, (INTEGER)_StoryActionID)
event StatusRemoved((GUIDSTRING)_Object, (STRING)_Status, (GUIDSTRING)_Causee, (INTEGER)_ApplyStoryActionID)
event CastSpell((GUIDSTRING)_Caster, (STRING)_Spell, (STRING)_SpellType, (STRING)_SpellElement, (INTEGER)_StoryActionID)
event CastedSpell((GUIDSTRING)_Caster, (STRING)_Spell, (STRING)_SpellType, (STRING)_SpellElement, (INTEGER)_StoryActionID)
event UsingSpell((GUIDSTRING)_Caster, (STRING)_Spell, (STRING)_SpellType, (STRING)_SpellElement, (INTEGER)_StoryActionID)
event UsingSpellOnTarget((GUIDSTRING)_Caster, (GUIDSTRING)_Target, (STRING)_Spell, (STRING)_SpellType, (STRING)_SpellElement, (INTEGER)_StoryActionID)
event UsingSpellAtPosition((GUIDSTRING)_Caster, (REAL)_X, (REAL)_Y, (REAL)_Z, (STRING)_Spell, (STRING)_SpellType, (STRING)_SpellElement, (INTEGER)_StoryActionID)
event EnteredCombat((GUIDSTRING)_Object, (GUIDSTRING)_CombatGuid)
event LeftCombat((GUIDSTRING)_Object, (GUIDSTRING)_CombatGuid)
event CombatEnded((GUIDSTRING)_CombatGuid)
event CombatStarted((GUIDSTRING)_CombatGuid)
event TurnStarted((GUIDSTRING)_Object)
event TurnEnded((GUIDSTRING)_Object)
event LongRestFinished()
event UserCharacterLongRested((CHARACTER)_Character, (INTEGER)_IsFullRest)
query GetPosition([in](GUIDSTRING)_Target, [out](REAL)_X, [out](REAL)_Y, [out](REAL)_Z)
query CreateAt([in](GUIDSTRING)_TemplateId, [in](REAL)_X, [in](REAL)_Y, [in](REAL)_Z, [in](INTEGER)_Temporary, [in](INTEGER)_PlaySpawn, [in](STRING)_SpawnFinishEvent, [out](GUIDSTRING)_CreatedObject)
query CreateAtObject([in](GUIDSTRING)_TemplateId, [in](GUIDSTRING)_Anchor, [in](INTEGER)_Temporary, [in](INTEGER)_PlaySpawn, [in](STRING)_SpawnFinishEvent, [in](INTEGER)_MatchOrientation, [out](GUIDSTRING)_CreatedObject)
call AppearAtPosition((CHARACTER)_Character, (REAL)_X, (REAL)_Y, (REAL)_Z, (INTEGER)_PlaySpawn, (ANIMATION)_CustomSpawnAnimation, (STRING)_AppearedEvent, (INTEGER)_PreventTeleportOnFailure)
query CharacterGetOwner([in](CHARACTER)_Character, [out](CHARACTER)_Owner)
query IsSummon([in](GUIDSTRING)_PotentialSummon, [out](INTEGER)_Bool)
call RemoveSummons((CHARACTER)_Character, (INTEGER)_Die)
call Die((GUIDSTRING)_Target, (DEATHTYPE)_DeathType, (GUIDSTRING)_Source, (INTEGER)_GenerateTreasure, (INTEGER)_Immediate, (REAL)_ImpactForce)
call SetLevel((GUIDSTRING)_Object, (INTEGER)_Level)
query GetLevel([in](GUIDSTRING)_Object, [out](INTEGER)_Level)
call SetHitpoints((GUIDSTRING)_Entity, (INTEGER)_HP, (STRING)_HealTypes)
query GetHitpoints([in](GUIDSTRING)_Entity, [out](INTEGER)_HP)
event SavegameLoaded()
```


Notes:
- `Died` carries only the character; `KilledBy(_Defender, _AttackOwner, _Attacker, _StoryActionID)` carries the killer, and `AttackedBy` also fires for DoT and environment (`_DamageCause` tells them apart; `Docs/OSIRIS.md` section 11).
- `LongRestFinished()` has **no arguments**; the per-character variant is `UserCharacterLongRested(_Character, _IsFullRest)`.
- `DEATHTYPE` enum includes `Lifetime = 9` (used by vanilla `Die(_Summon, DEATHTYPE.Lifetime, _Summon, 0, 0)` to retire a summon, `GLO_Spells_PostEA.txt`).
- `UseSpell` has 5 parameters; the dead EX goal calls it with 3 (and the last compile log, dated 2026-10-03, shows 0 errors), so verify on a real compile before relying on omitting trailing arguments.

### E6. The "Rulebook" (spec section 10 open question)

`$G/Public/$M/Shapeshift/Rulebook.lsx` (Toolkit copy `Editor/Mods/$M/Shapeshift/Rulebook.tbl`) is the mod's shapeshift rulebook, the target of the `(SHAPESHIFTRULE)` argument of `Transform`. It holds the two rules the goals use:

| Rule | UUID | Key settings |
|---|---|---|
| `MirrorImage` | `cb43e6d5-462d-4a3a-83c2-0108115e71f0` | `ApplySpellsFromTemplate false`, `RemovePrevSpells false`, `ApplyTagsFromTemplate true`, `ApplyVisual true`, `BlockLevelUp true`, `ChangeBodyType/ChangeIcon/ChangeRace true`, **`DefaultBoostsInheritanceType ReplaceOriginal`**, `PassivesInheritanceType Merge`, `ProficiencyGroupsInheritanceType Merge`, `SpellCastingAbilityInheritanceType ReplaceOriginal`, `RetainDisplayName true`, `UseShapeshiftIdentity false`, `DisableEquipmentSlots true`, `RemoveOldTags true`, `TagsAdd 26c78224-a4c1-43e4-b943-75e7fa1bfa41` |
| `FacelessCopy` | `3eb3fee7-67b4-46b5-a81a-2ac2da66bff7` | `ApplySpellsFromTemplate false`, `ApplyVisual true`, `ChangeBodyType false`, `ChangeRace false`, `ChangeIcon true`, `BlockLevelUp false`, `DefaultBoosts/Passives/ProficiencyGroups/Resistances/DifficultyStatuses/Flags/PersonalStatusImmunities/SpellCastingAbility InheritanceType KeepOriginal`, `RetainCanSeeThrough true`, `RetainDisplayName false`, `UseShapeshiftIdentity true`, `Weight type 4` |

Consequence for Doubles: the `MirrorImage` rule makes the Double take the **player's** default boosts (replacing the template's) and merge her passives, which is the concrete form of risk R1.

---

## F. Risks and contradictions found for the plan

Ranked by how much they can break a later task. Evidence points to sections above.

| # | Risk | Evidence | What to do |
|---|---|---|---|
| F1 | **The "vanilla Duplicity template" is a mod-owned binary template.** Spec 3.1 and the plan treat `8807d230-...` as vanilla; it is `RootTemplates/8807d230-....lsf` (`ARCANA_CHAR_CreateClone_1`, stats `Clone_1`, parent `f0930afd-...`). Its AI `SkillList` names the spells the plan deletes (`Target_Deceiver_Clone_MirrorDistortion`, `...MirrorEtherealChains`, `Projectile_Deceiver_Clone_MirrorSigilofMalice`, plus Dismiss and Malicious Whispers); its stats are HP 8, AC 10, Level 1, 1 reaction, Attack of Opportunity; its name is "Clone". | E2, C1 | A stats patch cannot change it. Decide in the apply session: edit the LSF in the Toolkit (`[fechado]`), or create a new template (`Double of the Veil`) and leave 8807d230 unused. `4267f207` (`CreateClone_2`) is an unused sibling. |
| F2 | **The shimmer is not on INVOKE_DUPLICITY.** `INVOKE_DUPLICITY` has no effect fields; the visual is `StatusEffect d798b3cf-15ab-4911-9884-82799e6fd3ef` on `INVOKE_DUPLICITY_AURA`, which also gives allies within 3 m the vanilla Advantage buff. Today `MIRROR_IMAGE_TECHNICAL` blanks `StatusEffect` and `OnRemoveFunctors`, so the clone has no shimmer at all. | E1 | Use a mod BOOST status carrying `StatusEffect d798b3cf-...` only (no aura), applied by Osiris to each Double. |
| F3 | **`Transform` with the `MirrorImage` rule copies the player.** `DefaultBoostsInheritanceType ReplaceOriginal` and `PassivesInheritanceType Merge`: the Double ends up with her default boosts and merged passives, not the template's. Spec R1 is real. The goal's 300 ms / 200 ms delays are empirical (OSIRIS.md section 10). Fixed 1 HP / AC 12 must be applied by statuses after the Transform, and any passive that counts Doubles (The Veil) would also be merged into each Double. | E6, D1 | Keep the post-Transform status step; test 1 HP, AC and the passive merge in game before building on it. |
| F4 | **The plan's removal list is incomplete.** Not listed but wired to removed content: `Interrupt_Arcana_Aspect_Beloved` + resource `ArcanaBeloved` (granted by `Arcana_Passive_Aspect_Empress_Awakened_III`, which the new Tier III replaces); resources `ArcanaReactHollowImage` / `ArcanaReactInstinctiveCharm` (`ActionResourceDefinitions` lsx+tbl, `Progressions.lsx:420` boost `ActionResource(ArcanaReactInstinctiveCharm,1,0)` on Deceiver L5); `Clone_1` stats entry; statuses `HOLLOW_IMAGE_INVISIBLE`, `INTERRUPT_HOLLOW_IMAGE`, `INSTINCTIVE_CHARM_FERVOR`, `HEARTBREAK_TECH`; `Target_Arcana_Reaction_InstinctiveCharm`; the Lua `D.reactions` entries; and the **`SIGIL` status itself names `MIRROR_ETHEREAL_CHAINS`** in its `RemoveConditions` (and its `Boosts` use `ASPECT_AWAKENED_EMPRESS`). Deleting a status that another condition still names risks a load error or a silently dead condition. | B5, B6, B11, B12, C3 | Treat B1-B12 as the list. Edit `SIGIL` (RemoveConditions and Boosts) in the same patch that removes `MIRROR_ETHEREAL_CHAINS`; decide the new Chains status name for the Doubles first. |
| F5 | **Tools that re-create removed data.** `aspect_structure.pl` (copies in `tools/stats/` and `tools/stats/`) is idempotent and still: grants `Target_Arcana_Util_Friends_EX` into list `4657a3f6-e7f5-4ac4-b5c4-c0665adcb36d` (Deceiver Level 13), creates resource `ArcanaBeloved`, and mentions `Arcana_Passive_HollowImage_EX` and `Target_Arcana_Card_Spell_Faceless_Copy_EX`. Re-running it after the removal would bring them back. `ARCANA_CardFamilies.txt` is **generated** by `gen_upcast_variants.pl` ("nao edite a mao"): the rows of every removed card disappear only by re-running it, and the new card levels change which variants exist. The generator only sees `Card_Spell`, `Card_Ability`, `Card_Passive`, `Created`. | D10, B15 | Update `aspect_structure.pl` in the same change; run `gen_upcast_variants.pl` (dry-run first) after the stats are patched. Empty list `4657a3f6` must also be detached from the Deceiver L13 progression `Selectors`, as `aspect_structure.pl` does for `%dropLists`. |
| F6 | **Friends has no grant path today.** `Arcana_Passive_UnlockFriends` is only `PassivesRemoved` at Deceiver L20 (`Progressions.lsx:536`, `.tbl:718`); no progression adds it, and `Target_Arcana_Util_Friends` is in no list. The spec's "(hidden) Friends unlock" at level 1 has to be created, not kept. `Target_Arcana_Util_Friends` is Level 0 (`UseCosts ActionPoint:1`, flag `IsConcentration`), so "level-1 spell" needs a slot cost; `Target_Arcana_Util_Friends_6` is not produced by the generator (Util is outside its regex) and Lua `U.IsUpcast` treats any `_N` tail as an upcast variant; `IsArcanaCantrip.khn:5` lists Friends as a cantrip. | C5, B9 | Hand-write `Friends_6` (`RootSpellID`, `PowerLevel 6`, slot cost) or extend the generator; remove Friends from `IsArcanaCantrip.khn` once it is level 1. |
| F7 | **Mirrored Spell copies any caster's spell, Doubles included.** `CastedSpell((CHARACTER)_Caster,...)` + `SpellHasSpellFlag(_Spell,"IsSpell",1)` + `_Caster != _Holder` + `HasSpell(_Holder,_Spell,0)` + within 18 m: a Double casting `Shatter` / `MirrorSigil` / `MirrorChains` will put that spell in the Deceiver's book. Spec section 10 says "default: no". | D9 | Filter out summons (`IsSummon`) or the Double ids in `QRY_ARCANA_MirroredSpell_CanCopy`. |
| F8 | **Sigil coupling is through a DB and a Khonsu marker.** `ARCANA_Status_Sigil.txt` reads `DB_ARCANA_MirrorImageOf` to put the mark in the owner's name; the goal that writes it is replaced. Detonation needs `IsArcanaSpell()` = the `ARCANA_IS_CARD` / `ARCANA_IS_SPELL` marker in `TargetConditions`. So the Doubles' Mirror spells need `ARCANA_IS_SPELL` to detonate, and `Shatter` (1d6 Psychic burst) must **not** carry it or it will detonate every mark it touches. | D5, C3, E5 | Keep a Doubles-to-owner DB (or `GetSummoner`) under the same contract before deleting `DB_ARCANA_MirrorImageOf`; choose the marker per spell. |
| F9 | **Cap and "oldest dies" are new Osiris, and the summon is stack-limited today.** The card summons with `-1` lifetime and a single stack id `CreateCloneStack1` (presumably one clone at a time, by vanilla stack-id semantics; not tested here). Osiris has no ordered list; a DB with a counter is needed, and retiring the oldest uses `Die(_Double, DEATHTYPE.Lifetime, ...)` (so it is not an enemy kill). `Died` carries no killer: use `KilledBy(_Defender,_AttackOwner,_Attacker,_)` for R4; Shatter's own death must not give Doubt. | E5, D1 | Design the DB (`DB_ARCANA_Double(Owner, Double, Seq)`) and the stack id before writing the goal. |
| F10 | **End-of-combat and Long Rest cleanup do not exist today.** The clone is permanent. `CombatEnded` has only the combat guid (use `LeftCombat(_Char,_Combat)`), `LongRestFinished()` has no arguments, and `RemoveSummons((CHARACTER)_Character,(INTEGER)_Die)` would also kill her other summons (Third Eye `ARCANA_CHAR_ThirdEye`, Arcane Familiar, Weaver Hand). | E5 | Remove only ids registered in the Doubles DB. |
| F11 | **Withdraw swap is a different mechanism from today's.** Today: item marker `ARCANA_ITEM_Spell_DistortionPosition` (`Summon(SELF,c3c514b2-...,2)`), captured by `EnteredLevel((ITEM)...)`, and `AppearAtPosition` to the stored origin. A Double is a character; swapping needs both positions read before the first move, and `TeleportTo(source,target,event,5 flags)` has no swap semantics (R6). | D2, E5 | Read both `GetPosition` results first, then `TeleportToPosition` for each; keep the marker for the "origin" only if the Double is not placed. |
| F12 | **CONFUSION for Deluded is a BOOST already, but its save uses `SourceSpellDC()`.** `RemoveConditions SavingThrow(Ability.Wisdom, SourceSpellDC())` has no spell context when Osiris applies it with `ApplyStatus`; `OnTurn` removal and `OnTickRoll d20 vs 11` also run. Spec R5's "BOOST copy" is unnecessary, but the DC and the 1-turn duration must be tested. It inherits `LoseControl;InitiateCombat;BringIntoCombat` and `AiArchetypeOverride(madness,99)`. | E3 | Test with Osiris-applied duration 1 and compare with `Hostile Takeover`'s spell-applied version. |
| F13 | **The Lua suite is coupled to removed ids** (baseline 134 passed). `ReactionsTest.lua:10,76-85` (`HOLLOW`, `ArcanaReactHollowImage`), `DestinationTest.lua:69` (`MentalPrison`), `KeywordsTest.lua:108` (`ASPECT_AWAKENED_EMPRESS -> Heartbreak`), `UtilTest.lua:19` (a Clone Mirror id used as the "ignored" example), plus `CardDB.lua:70,71,74,113,128,146-153`. | B refs | Change CardDB and the tests together; re-run the suite and `check_cards.pl`. |
| F14 | **Aspect counter and tier table.** `ARCANA_Aspect_Common.txt:51-53` has goals 3 / 5 / 7 (spec 4 / 7 / 10). `PROC_ARCANA_Aspect_Step(_Deceiver,"EMPRESS")` is called only from the Sigil-detonation rule; the Empress goal has no `_OnAwakened` / `_OnTier` hook (Death/Fool/Star do). The Aspect card is conjured through `CardDB.statusConjures.ASPECT_AWAKENED_EMPRESS` and the status `Boosts UnlockSpell(Shout_Arcana_Created_Aspect_Heartbreak)`. | D6, C6, C7 | New counting rules in the Doubt goal; add `_OnTier` for Veiled / Two Pillars / Which One?. |
| F15 | **Spec inconsistencies to settle.** (a) 3.1 says the Doubles' spells are `_Deceiver_Clone_` spells, 4.3 names them `_Deceiver_Double_`; both are ignored by `U.Category`, fine, but pick one. (b) Mirror Image is Level 4 today (`UseCosts SpellSlotsGroup:1:1:4`, variants `_5`, `_6`, granted at class level 7); the spec makes it a level-1 card with variants `_2.._6`. (c) Mental Prison applies `HOLD_PERSON` (not Incapacitated, spec 4.2). (d) Faceless: Copy has the Realtime-timer / `ObjectTimerCancel` mismatch (D7) and its EX goal is already dead (D8). (e) The "Rulebook" of spec section 10 is `Shapeshift/Rulebook.lsx` (E6). | various | Resolve with the user in the apply session; (e) can be closed now. |
| F16 | **Naming is free.** No id in the stats starts with `VEIL_`, `DOUBT`, `DELUDED` or contains `Double`; one near-clash: `Arcana_Passive_ArcaneVeil` (base-class passive "Arcane Veil", `Passive.txt:85`). Docs lag the code: `Docs/OSIRIS.md` says timers are `IND_`-prefixed, the goals use `ARCANA_` (and two unprefixed timers in the MirrorImage goal). | scan | Use `ARCANA_`-prefixed timers; mind the passive name. |

Good news (no action): `Po.IsDeckUser` already excludes summons (`IsSummon ~= 1`), so Doubles will not become deck users; `Util.Category` ignores non-`Arcana_` spell names; `Context/subclasses/deceiver.md` (last verified 2026-10-02) matches the current progression dump.
