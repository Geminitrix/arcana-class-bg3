# 57.02 · Stats and LSX — the mod's data

*Condenses spec Part III §26. Readers: Stats and LSX Engineer, Mod Engineer. Types and subtypes found in
the base game: `55.00_Type_Catalog.md`.*

## Stats
`Public/<Mod>/Stats/Generated/Data/*.txt`. Each entry: unique name, a type, data fields; it may **inherit**
from another with `using` and override only what differs. The Toolkit also keeps an editor copy under
`Editor/Mods/<Mod>/Stats/` — the two must always match (both are in `51`).
- **Entry types:** `SpellData` (split by `SpellType`), `StatusData` (by `StatusType`), `PassiveData`,
  `InterruptData` (reactions), `Armor`, `Weapon`, `Character`, `Object` — counts in `55.00`.
- **Key fields:** `UseCosts` (action, bonus, slot, resource), `TargetConditions`, `SpellProperties`
  (effects), `Boosts` (`;`-separated), `StatsFunctorContext` / `StatsFunctorConditions` / `StatsFunctors`
  (passives and statuses: when, under what condition, what happens), `Level`, `SpellSchool`, `DamageType`,
  `Icon`, `DisplayName`, `Tooltip*`, `LevelMapValue(Name)`.
- **The official schema** is the game's `Modifiers.txt` (fields per type) and `ValueLists.txt` (allowed
  values) — in the local extraction under `Shared_Extracted/Public/Shared/Stats/Generated/Structure/`.
  Validators and agents use them instead of memory. Schema-valid still ≠ works (`AGENTS.md` §4).
- **`using` caveat:** if the parent belongs to another mod, its update changes yours.

## LSX — the class structure
| File | Role |
|---|---|
| `Mods/<Mod>/meta.lsx` | Mod identity: folder, name, UUID, version, dependencies |
| `ClassDescriptions` | Class and subclasses |
| `Progressions` | What each level grants (select / add spells and passives, resources) |
| `Lists/SpellLists`, `PassiveLists`, `SkillLists` | Lists the progressions point to |
| `ActionResourceDefinitions`, `ActionResourceGroupDefinitions` | Resources (`ArcanaSpellSlot`, `ArcanaThread`) |

**UUIDs:** overriding something requires the identical original UUID; adding requires a fresh one.
Progressions point to lists by UUID. New spell flow: Stats entry → spell list (new UUID) → progression
reference → loca text → icon. A passive goes into the progression's added passives, no list. Every UUID
created is recorded in `52.04_UUID_Registry` (validator refuses duplicates).

## Localization
Text shows through **handles** (`h…;N`, the `;N` is the version) in `DisplayName` and tooltips; text comes
from `33` through the Narrative gate. Recipe to resolve handles: `57.06/Environment_and_Workflows.md` §5.

## Common errors
| Symptom | Likely cause | Check |
|---|---|---|
| Overwrote something vanilla | Same entry name as the base game | Prefix; compare with `56` |
| Spell doesn't show | Missing list, progression reference or `meta.lsx` | Follow the flow above |
| Wrong status or none | Functor in the wrong field / wrong parameters | Compare with a vanilla example |
| Build fails | Folder or names differ from the game's layout | Compare with the build tool's index |
| Mysterious conflict | Another mod changes the same content | Test with other mods off (`64`) |
