# Custom class with Warlock-style spell slots — what decides which upcast variants get registered?

I'm building a custom class whose spell slots work like the Warlock's: one slot level at a time,
rising with character level, the previous level zeroed. Spells should just cast at that level, with no
upcast picker — the way a Warlock casts.

Everything works except the picker. It still shows up, offering two levels, with the correct one
preselected. The spell is castable; it's just an extra click the Warlock doesn't have.

## Setup

Resource, identical in every field to `WarlockSpellSlot`:

```
IsSpellResource             true
MaxLevel                    9
ReplenishType               Rest
ShowOnActionResourcePanel   true
UpdatesSpellPowerLevel      true
```

Progression, same shape as the Warlock's — grant the new total at the band change, then zero the
level below:

```
lv3   ActionResource(ArcanaSpellSlot,6,2);ActionResourceOverride(ArcanaSpellSlot,0,1)
lv5   ActionResource(ArcanaSpellSlot,9,3);ActionResourceOverride(ArcanaSpellSlot,0,2)
```

Upcast variants, one entry per level, same shape as the ones in the base game:

```
new entry "Projectile_MyClass_SigilofMalice_3"
type "SpellData"
data "SpellType" "Projectile"
using "Projectile_MyClass_SigilofMalice"
data "RootSpellID" "Projectile_MyClass_SigilofMalice"
data "PowerLevel" "3"
data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:3;MyHandCounter:1;"
```

Class description: `LearningStrategy 1`, no `MustPrepareSpells`, spells granted with
`AlwaysPrepared` — all the same as the Warlock.

## What I compared

At character level 5 my character's resource state is identical in shape to a Warlock 5's (read
through Script Extender, `ActionResources.Resources`, amount/max per level):

```
mine       level 1: 0/0    level 2: 0/0    level 3: 4/9
Warlock    level 1: 0/0    level 2: 0/0    level 3: 2/2
```

Both have exactly one usable level. But the spellbooks differ. For a **level 1** spell:

- **Warlock** (Gale, pact level 3): exactly **one** variant registered — `Target_Sleep_3`. Same for
  Faerie Fire, Hellish Rebuke, Witch Bolt, Enthrall, Shatter. Never a `_2`.
- **Mine**: **two** registered — `..._SigilofMalice_2` **and** `..._SigilofMalice_3`.

Two entries is what draws the box. The Warlock has one, so there is nothing to choose.

The count matches that rule exactly: my character has 5 level-1 spells and 4 level-2 spells, and the
spellbook holds 14 variants — `_2` and `_3` for each level-1 spell, `_3` for each level-2 spell. It
looks like the whole range from the spell's level up to my caster level gets registered, including
levels that are 0/0.

## What I have already tried for the cost

1. `ArcanaSpellSlot:1:N` (three parts) — wrong grammar; nothing in the base game uses a three-part
   cost.
2. A custom `ActionResourceGroup` holding only my resource: `MyGroup:1:1:N`.
3. The resource directly, four parts: `ArcanaSpellSlot:1:1:N`.
4. Adding my resource as a fourth member of the vanilla `SpellSlotsGroup` and charging
   `SpellSlotsGroup:1:1:N`.

All four register `_2` and `_3`. The fourth surprised me most, since that is the same group the
Warlock charges — as far as I can tell no spell in the game charges `WarlockSpellSlot` or
`ShadowSpellSlot` directly, they all go through that group.

## The question

**What decides how many upcast variants get registered in the spellbook?** The Warlock gets only the
level he can actually pay. I get the full range, including levels with 0 max.

Is there a flag on the class, the resource, or the spell that I'm missing? Or is the filtering tied to
something specific to Pact Magic that a custom class can't reproduce — in which case I'd rather know
and stop chasing it.
