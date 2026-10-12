---
id: SPEC_ARC-0002
ticket: ARC-0002
status: implemented
implementation: claude
author: Mod Engineer
updated: 2026-10-11
---

# SPEC_ARC-0002 · The Resonant raise — implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans (or subagent-driven-development).
> Steps use checkboxes. **One `[fechado]` message = one stage**; a stage that writes the game needs the
> ticket with `implementation: claude`.

**Intent** (from ARC-0002): the Resonant plays its emotion mechanic with impact from level 1 —
behaviour-changing Surges, an overload meter and its Emotional Overload — without running out of slots.

**Spec (design):** `21.04/Resonant/2026-10-11-resonant-design.md` · **Numbers:** `25.01`–`25.03`
(`*_Resonant_*.yaml`) · **Generator:** `82_Automation/stats/gen_emotion_alchemy.pl` + `t/gen_emotion_alchemy.t`
(`perl t/gen_emotion_alchemy.t`; `prove` does not run on this Perl) · **Applier:** `stats_add.pl`.

## Global constraints

- Everything in Stats / LSX / Osiris; **no Script Extender** (console edition).
- Ids keep the fixed prefixes (ADR-0002); new helper statuses use `RESONANT_`; interrupts `Interrupt_Arcana_`.
- **Numbers are read from `25`**, never typed in the generator (ADR-0005). The generator reads them with
  `master()` (Task 0.2).
- Change the generator's table, never the generated patch.
- Every function, event and field below has a vanilla or mod anchor (cited); where none exists the item is a
  **probe** with a plan B.
- Player text comes from the generator table and is **pending the Narrative gate** (`32.04`) before release.

## Stages

| Stage | What | Writes the game? | Gate |
|---|---|---|---|
| **0** | Generator: paths, master-data reader, behaviour peaks, refund, Catharsis level map, interrupts — test first | No | Tests pass; patch generated |
| **1** | Apply the engine patch, the Catharsis level map and the Grudge goal; probes P0–P5 in game | Yes | Owner's probe results; plan B applied where a probe fails |
| 2 | Overload meter (statuses, passive, Osiris count) + Emotional Overload | Yes | **Written in full below** |
| 3 | Heartstring, Temper, Read the Room, Emotional Contagion, Ready: Compassion | Yes | **Written below** |
| 4 | Awakening *14 · Temperance* (Osiris goal, tier statuses), The Two Cups, Tier III area Overload | Yes | Written in full after stage 3 |
| 5 | Shared Heart (link status, Osiris copy, free Surges) | Yes | Written in full after stage 4 |
| 6 | Lists, progression levels 1–12, loca handles, icons | Yes | Written in full after stage 5 |
| 7 | Test cases in `60`, full in-game pass (spec §15), `05` handoff, player guide ticket | No | DoD |

Stages 2–7 are indexed here and written in full (items with field → value → origin) before their own
`[fechado]`: their shape depends on what the stage-1 probes prove (scope check of the plan skill).

## Review focus

1. **A multi-target Surge where several targets react** must refund **once** — Task 0.4 test.
2. **A Surge whose save fails** runs `SpellFail`, not `SpellSuccess`: no reaction, no refund — probe P5.
3. **Upcast variants** (`_2`…`_6`) are regenerated from the base Surge: they must carry the refund and the
   level map — Stage 1 step 4 check.
4. **Catharsis at the level boundaries** (4→5, 9→10) — Task 0.3 test.
5. **Joy's aura on enemies**: the contagion must reach only the Joyful creature's allies — probe P1.

---

## Stage 0 — generator (project files only)

### Task 0.1 · Output path and spec path

**Files:** modify `82_Automation/stats/gen_emotion_alchemy.pl` (header, `main`), test `t/gen_emotion_alchemy.t`.

- [ ] **Step 1 — failing test.** Append before `done_testing();`:

```perl
# ---- paths after the Lumox migration
like(Alchemy::default_out(), qr{/50_ENGINEERING/55_Implementation_Specs/_wip/Resonant$}, 'patches go to 55/_wip/Resonant');
```

- [ ] **Step 2 — run, expect FAIL** (`Undefined subroutine &Alchemy::default_out`): `perl t/gen_emotion_alchemy.t`
- [ ] **Step 3 — implement.** Under the `use` lines add `use Cwd qw(abs_path);` and:

```perl
our $ROOT = abs_path(dirname(__FILE__) . '/../../..');            # repository root
sub default_out { "$ROOT/50_ENGINEERING/55_Implementation_Specs/_wip/Resonant" }
```

In `main`, replace `$out //= dirname(__FILE__) . '/../../Design/work/resonant';` with `$out //= default_out();`.
In the header and in `build_engine_patch`, replace the spec path with
`20_GAME_DESIGN/21_GDD_Arcana_Class/21.04_Subclasses/Resonant/2026-10-11-resonant-design.md`.
- [ ] **Step 4 — run, expect all PASS.**
- [ ] **Step 5 — commit** `ARC-0002: generator writes to 55/_wip/Resonant`.

### Task 0.2 · Read numbers from `25`

**Files:** generator, test; create `20_GAME_DESIGN/25_Master_Data/25.03_statuses/STA_Resonant_Peaks.yaml`.

- [ ] **Step 1 — create the master-data file** (value **proposed**: 3 m, the same reach as Disapproval —
  the Owner confirms it with this plan):

```yaml
id: STA_Resonant_Peaks
kind: status
subclass: Resonant
ticket: ARC-0002
design: "21.04/Resonant/2026-10-11-resonant-design.md §5.1"
balance_report: "22.05/2026-10-11_ARC-0002_Resonant_Balance.md"
game_ids: [EMOTION_JOY, RESONANT_JOY_CONTAGION]
values:
  joy_aura_radius: { value: 3, unit: metres, note: "allies of the Joyful creature within this range" }
```

- [ ] **Step 2 — failing tests:**

```perl
# ---- master data (25) is the only source of numbers
is(Alchemy::master('STA_Resonant_Peaks', 'joy_aura_radius')->{value}, 3, 'reads a plain value from 25');
is_deeply(Alchemy::master('STA_Resonant_Catharsis', 'damage')->{by_level}, { 1 => '2d8', 5 => '3d8', 10 => '4d8' }, 'reads by_level from 25');
like(Alchemy::master('STA_Resonant_States', 'mood_duration')->{value}, qr/^\d+$/, 'mood duration is a number read from 25');
```

- [ ] **Step 3 — run, expect FAIL** (`Undefined subroutine &Alchemy::master`).
- [ ] **Step 4 — implement:**

```perl
our $MASTER = "$ROOT/20_GAME_DESIGN/25_Master_Data";
# One value entry of a 25 file: { value => ..., unit => ..., by_level => { level => value } }.
# The files use one-line flow maps (schema 25.00/master_data.schema.yaml), so a line parser is enough.
sub master {
    my ($file, $key) = @_;
    my ($dir) = grep { -e "$MASTER/$_/$file.yaml" } qw(25.01_spells 25.02_features 25.03_statuses);
    die "master data $file not found\n" unless $dir;
    open my $h, '<', "$MASTER/$dir/$file.yaml" or die "$file: $!";
    while (my $l = <$h>) {
        next unless $l =~ /^\s+\Q$key\E:\s*\{(.*)\}\s*$/;
        my $body = $1; my %v;
        $v{by_level} = { $1 =~ /(\d+):\s*([^,\s}]+)/g } if $body =~ s/by_level:\s*\{([^}]*)\},?//;
        while ($body =~ /(\w+):\s*("[^"]*"|[^,]+)/g) { my ($k, $x) = ($1, $2); $x =~ s/^\s+|\s+$//g; $x =~ s/^"(.*)"$/$1/; $v{$k} = $x }
        return \%v;
    }
    die "master data $file has no $key\n";
}
```

Replace the constants with reads: `our $FEELING_TURNS = master('STA_Resonant_States','feeling_duration')->{value};`
and `our $MOOD_TURNS = master('STA_Resonant_States','mood_duration')->{value};` (declare `master` above them).
- [ ] **Step 5 — run, expect all PASS.** Commit `ARC-0002: generator reads numbers from 25`.

### Task 0.3 · Catharsis scales through a level map

**Anchors:** `DealDamage(LevelMapValue(D10Cantrip),Fire,Magical)` (vanilla `Spell_Projectile.txt`); the mod's
own map `Starcall_Damage` (`Public/…/Levelmaps/LevelMapValues.lsx`, Level1…Level20 `LSString`, `Name`, `UUID`).
`RegainHitPoints(LevelMapValue(…))` has **no anchor** → probe P0.

- [ ] **Step 1 — failing tests:**

```perl
# ---- Catharsis by level
my $lm = Alchemy::catharsis_levelmap();
like($lm, qr/<attribute id="Level4" type="LSString" value="2d8"\/>/, 'level 4: 2d8');
like($lm, qr/<attribute id="Level5" type="LSString" value="3d8"\/>/, 'level 5: 3d8');
like($lm, qr/<attribute id="Level9" type="LSString" value="3d8"\/>/, 'level 9: 3d8');
like($lm, qr/<attribute id="Level10" type="LSString" value="4d8"\/>/, 'level 10: 4d8');
like($lm, qr/value="Catharsis_Damage".*value="$Alchemy::CATHARSIS_MAP_UUID"/s, 'name and fixed UUID');
like(Alchemy::spell_success('Fear'), qr/DealDamage\(LevelMapValue\(Catharsis_Damage\),Psychic,Magical\)/, 'Catharsis damage reads the map');
```

Change the existing test `'Catharsis harms, heals, then clears the moods last'` to
`qr/DealDamage\(LevelMapValue\(Catharsis_Damage\),Psychic,Magical\).*RegainHitPoints\(LevelMapValue\(Catharsis_Damage\)\).*ApplyStatus\(CATHARSIS,100,0\)$/`.
- [ ] **Step 2 — run, expect FAIL.**
- [ ] **Step 3 — implement** (replace `$CATHARSIS_DICE` everywhere):

```perl
our $CATHARSIS_MAP      = 'Catharsis_Damage';
our $CATHARSIS_MAP_UUID = '11006542-a7b5-4599-938a-2840982c4bb1';   # fixed: generated once for this map
sub catharsis_levelmap {
    my $by = master('STA_Resonant_Catharsis', 'damage')->{by_level};
    my @th = sort { $a <=> $b } keys %$by;
    my %lv; for my $L (1 .. 20) { my ($t) = grep { $_ <= $L } reverse @th; $lv{$L} = $by->{$t} }
    my $s = qq{                <node id="LevelMapSeries">\n};
    $s .= qq{                    <attribute id="Level$_" type="LSString" value="$lv{$_}"/>\n} for sort { "$a" cmp "$b" } 1 .. 20;
    $s .= qq{                    <attribute id="Name" type="FixedString" value="$CATHARSIS_MAP"/>\n};
    $s .= qq{                    <attribute id="UUID" type="guid" value="$CATHARSIS_MAP_UUID"/>\n                </node>\n};
}
```

In `spell_success` the Catharsis functors become `DealDamage(LevelMapValue($CATHARSIS_MAP),Psychic,Magical)` and
`RegainHitPoints(LevelMapValue($CATHARSIS_MAP))`; the passive's `DescriptionParams` the same. `main` also writes
`"$out/30_catharsis_levelmap.lsx-fragment"` with `catharsis_levelmap()`.
- [ ] **Step 4 — run, expect PASS.** Commit `ARC-0002: Catharsis scales with level (level map)`.

### Task 0.4 · The refund on reaction (R16)

**Anchors:** `Arcana_Passive_ArcaneOverflow` (mod `Passive.txt`: `RestoreResource(SELF,ArcanaSpellSlot,1,N)` per
class-level bracket, `RestoreResource(SELF,ArcanaThread,1,0)`, a used status); `ApplyStatus(SELF, …)` inside a
Target spell's `SpellSuccess` (vanilla `Spell_Target.txt`, `CURSE_EXTRA_DAMAGE_OWNER`).

- [ ] **Step 1 — failing tests:**

```perl
# ---- refund (R16): the second functor fires on any reaction, before a reaction spends the mood
my @ff = split /;(?=IF\()/, Alchemy::spell_success('Joy');
like($ff[1], qr/^IF\(\(HasStatus\('MOOD_.*\)\):ApplyStatus\(SELF,RESONANT_REFUND_TECH,100,0\)$/, 'refund comes right after the base case');
is(scalar(() = $ff[1] =~ /HasStatus\('MOOD_/g), 8, 'refund condition covers the 8 moods');
my $rf = block($p, 'RESONANT_REFUND_TECH');
is(scalar(() = $rf =~ /RestoreResource\(SELF,ArcanaSpellSlot,1,\d\)/g), 6, 'one slot refund per slot level 1-6');
like($rf, qr/ApplyStatus\(SELF,RESONANT_REFUND_USED,100,1\)"$/m, 'the used flag is set last');
none('every slot refund is guarded by the used flag', grep { !/not HasStatus\('RESONANT_REFUND_USED'\)/ } $rf =~ /(IF\([^)]*\)\):RestoreResource)/g);
```

(`$p` is built earlier in the test file; move these lines below `my $p = Alchemy::build_engine_patch();`.)
Change `'each Surge: 1 base case + 7 reactions + 3 Catharsis functors'` to expect **12** `IF(`.
- [ ] **Step 2 — run, expect FAIL.**
- [ ] **Step 3 — implement:**

```perl
sub refund_functors {   # the slot level per class level, as Arcana_Passive_ArcaneOverflow
    my @br = ([1, undef, 3], [2, 3, 5], [3, 5, 7], [4, 7, 9], [5, 9, 11], [6, 11, undef]);
    my @f = map { my ($slot, $lo, $hi) = @$_;
        my @c = ("not HasStatus('RESONANT_REFUND_USED')");
        push @c, "ClassLevelHigherOrEqualThan($lo,'Arcana')" if $lo;
        push @c, "not ClassLevelHigherOrEqualThan($hi,'Arcana')" if $hi;
        'IF(' . join(' and ', @c) . "):RestoreResource(SELF,ArcanaSpellSlot,1,$slot)" } @br;
    join ';', @f, "IF(not HasStatus('RESONANT_REFUND_USED')):RestoreResource(SELF,ArcanaThread,1,0)",
              'ApplyStatus(SELF,RESONANT_REFUND_USED,100,1)';
}
```

In `spell_success`, right after the base-case functor:
`push @f, 'IF(' . join(' or ', map { '(' . cond_of($_) . ')' } @r) . '):ApplyStatus(SELF,RESONANT_REFUND_TECH,100,0)';`
In `build_statuses` helpers:
`push @out, hidden_status('RESONANT_REFUND_TECH', 'Refund', 'OnApplyFunctors', refund_functors());`
`push @out, hidden_status('RESONANT_REFUND_USED', 'Refund used', 'TickType', 'StartTurn');`
Emotional Alchemy text gains: *"When your Weave Surge causes a reaction, you regain the spell slot it used.
Once per turn."*
- [ ] **Step 4 — run, expect PASS.** Commit `ARC-0002: a reaction refunds its slot (R16)`.

### Task 0.5 · The behaviour peaks (R15, R17)

**Anchors:** aura — `AuraRadius` + `AuraStatuses "IF(...):ApplyStatus(CLOUD_OF_DAGGERS,100,1)"` (vanilla
`Status_*.txt`); next attack — `Advantage(AttackRoll)` + `RemoveEvents "OnAttack"` (`MAG_MONK_SWIFT_AS_THE_WIND`);
opening — `Advantage(AttackTarget)` + `RemoveEvents "OnAttacked"` (`GUIDING_BOLT`); Frightened —
`FRIGHTENED`, `StatusGroups "SG_Frightened;SG_Condition"`; `BreakConcentration()` (already in this generator);
`UnlockInterrupt(Interrupt_X)` (vanilla passives); grudge — `TAUNTED` (`StatusPropertyFlags
"LoseControl;OverheadOnTurn;LoseControlFriendly"`, `StatusGroups "SG_Taunted"`, applied by
`Shout_GoadingRoar_Bear_Summon`). **Disgust:** no vanilla anchor for "makes no melee attacks" → it keeps its
plan B (no action), unchanged.

- [ ] **Step 1 — failing tests:**

```perl
# ---- behaviour peaks (R17)
my $pk = sub { block($p, 'EMOTION_' . uc shift) };
like($pk->('Joy'), qr/data "AuraRadius" "3"\n.*data "AuraStatuses" "IF\(Ally\(\) and not Self\(\)\):ApplyStatus\(RESONANT_JOY_CONTAGION,100,1\)"/s, 'Joy: contagious aura');
like(block($p, 'RESONANT_JOY_CONTAGION'), qr/Advantage\(AttackRoll\).*"RemoveEvents" "OnAttack"/s, 'contagion: next attack only');
like($pk->('Trust'), qr/UnlockInterrupt\(Interrupt_Arcana_TrustFollowUp\)/, 'Trust: follow-up interrupt');
like($pk->('Anticipation'), qr/UnlockInterrupt\(Interrupt_Arcana_AnticipationGuard\)/, 'Anticipation: guard interrupt');
like($pk->('Fear'), qr/"StatusGroups" "SG_Frightened;SG_Condition"/, 'Fear: Frightened group');
like($pk->('Surprise'), qr/"Boosts" "ActionResourceBlock\(ReactionActionPoint\)".*ApplyStatus\(RESONANT_SURPRISE_OPENING,100,1\)/s, 'Surprise: no reaction, opening');
like(block($p, 'RESONANT_SURPRISE_OPENING'), qr/Advantage\(AttackTarget\).*"RemoveEvents" "OnAttacked"/s, 'opening: first attack only');
like($pk->('Sadness'), qr/"Boosts" "ActionResourceBlock\(BonusActionPoint\)".*BreakConcentration\(\)/s, 'Sadness: lets go');
like(block($p, 'RESONANT_GRUDGE'), qr/"StatusGroups" "SG_Taunted"/, 'grudge: taunted group');
like($p, qr/^new entry "Interrupt_Arcana_AnticipationGuard"\ntype "InterruptData"\n(?:.*\n)*?data "InterruptContext" "OnEnterAttackRange"/m, 'guard: enters reach');
like($p, qr/^new entry "Interrupt_Arcana_TrustFollowUp"\ntype "InterruptData"\n(?:.*\n)*?data "InterruptContextScope" "Nearby"/m, 'follow-up: watches allies');
```

- [ ] **Step 2 — run, expect FAIL.**
- [ ] **Step 3 — implement** in `%EMO` (peaks only; moods and intense unchanged):

```perl
# Joy
peak => { boosts => undef, params => 'Distance(' . master('STA_Resonant_Peaks','joy_aura_radius')->{value} . ')',
          text => 'Its joy is contagious: allies within [1] have Advantage on their next attack.',
          extra => { AuraRadius => master('STA_Resonant_Peaks','joy_aura_radius')->{value},
                     AuraStatuses => 'IF(Ally() and not Self()):ApplyStatus(RESONANT_JOY_CONTAGION,100,1)' } },
effect => "Its joy is contagious: allies near it have Advantage on their next attack.",
# Trust
peak => { boosts => 'UnlockInterrupt(Interrupt_Arcana_TrustFollowUp)',
          text => 'Follows your lead: when you or an ally hits an enemy, it can use its reaction to attack the same target.' },
effect => "It follows your lead, attacking the enemies you and its allies hit.",
# Anticipation
peak => { boosts => 'UnlockInterrupt(Interrupt_Arcana_AnticipationGuard)',
          text => 'On guard: when an enemy enters its reach, it can use its reaction to attack first.' },
effect => "It stands on guard and strikes the first enemy that comes within reach.",
# Fear
peak => { boosts => 'Disadvantage(AllAbilities);Disadvantage(AttackRoll);ActionResourceBlock(Movement)',
          text => "Frozen with fear: can't move. Has Disadvantage on Ability Checks and Attack Rolls.",
          extra => { StatusGroups => 'SG_Frightened;SG_Condition' } },
# Surprise
peak => { boosts => 'ActionResourceBlock(ReactionActionPoint)', onapply => 'ApplyStatus(RESONANT_SURPRISE_OPENING,100,1)',
          text => "Caught off guard: can't take reactions, and the next attack against it has Advantage." },
effect => "The target is caught off guard: it loses its reaction, and the next attack against it has Advantage.",
# Sadness
peak => { boosts => 'ActionResourceBlock(BonusActionPoint)', onapply => 'BreakConcentration()',
          text => "Lets go of what it holds: loses Concentration and can't take bonus actions." },
effect => "The target lets go of what it holds: it loses Concentration and its bonus action.",
```

Helpers in `build_statuses` (kind `A` = no hostile flags, `I` = hostile):

```perl
push @out, status_entry('RESONANT_JOY_CONTAGION', 'Contagious Joy', tag_terms('Has Advantage on the next attack.'),
    $EMO{Joy}{icon}, 'A', { boosts => 'Advantage(AttackRoll)', stack => 'RESONANT_JOY_CONTAGION', tick => 'EndTurn',
    extra => { RemoveEvents => 'OnAttack' } });
push @out, status_entry('RESONANT_SURPRISE_OPENING', 'Off Guard', tag_terms('The next attack against it has Advantage.'),
    $EMO{Surprise}{icon}, 'I', { boosts => 'Advantage(AttackTarget)', stack => 'RESONANT_SURPRISE_OPENING',
    extra => { RemoveEvents => 'OnAttacked' } });
push @out, status_entry('RESONANT_GRUDGE', 'Grudge', 'Bears a grudge against whoever hurt it last and attacks them.',
    $EMO{Anger}{icon}, 'I', { stack => 'RESONANT_GRUDGE',
    extra => { StatusPropertyFlags => 'LoseControl;OverheadOnTurn;LoseControlFriendly', StatusGroups => 'SG_Taunted' } });
```

Interrupts — new `build_interrupts`, written to `@file Interrupt` / `@section -` (end of file, per
`stats_add.pl`), and `$new{$_} = 'Interrupt'` in `build_engine_patch`:

```perl
sub build_interrupts {
    entry('Interrupt_Arcana_TrustFollowUp', 'InterruptData',
        DisplayName => loca(key('Interrupt_Arcana_TrustFollowUp', 'NAME'), 'Follow Your Lead'),
        Description => loca(key('Interrupt_Arcana_TrustFollowUp', 'DESC'), 'When you or an ally hits an enemy, attack the same target.'),
        Icon => $EMO{Trust}{icon}, InterruptContext => 'OnCastHit', InterruptContextScope => 'Nearby', Container => 'YesNoDecision',
        Conditions => 'IsAbleToReact(context.Observer) and Ally(context.Source,context.Observer) and not Self(context.Source,context.Observer) and Enemy(context.Target,context.Observer) and IsHit() and not AnyEntityIsItem()',
        Properties => 'UseAttack()', Cost => 'ReactionActionPoint:1', InterruptDefaultValue => 'Ask;Enabled')
  . entry('Interrupt_Arcana_AnticipationGuard', 'InterruptData',
        DisplayName => loca(key('Interrupt_Arcana_AnticipationGuard', 'NAME'), 'On Guard'),
        Description => loca(key('Interrupt_Arcana_AnticipationGuard', 'DESC'), 'When an enemy enters your reach, attack it first.'),
        Icon => $EMO{Anticipation}{icon}, InterruptContext => 'OnEnterAttackRange', InterruptContextScope => 'Self', Container => 'YesNoDecision',
        Conditions => 'Self(context.Source,context.Observer) and IsAbleToReact(context.Observer) and Enemy() and not AnyEntityIsItem()',
        Properties => 'UseAttack()', Cost => 'ReactionActionPoint:1', Stack => 'AttackOfOpportunity', InterruptDefaultValue => 'Ask;Enabled');
}
```

(Anchors: `Interrupt_FOR_SpiderQueen_SilkTomb` — `OnCastHit`, `Nearby`, `Ally(context.Target,context.Observer)`,
`Enemy(context.Source,context.Observer)`; `Interrupt_PolearmMaster` — `OnEnterAttackRange`, `Self`, `UseAttack()`,
`Stack "AttackOfOpportunity"`.)
- [ ] **Step 4 — run, expect PASS** (all old tests too: the `'every cited status/passive is defined'` regex
  already covers `RESONANT_*`). Run `perl gen_emotion_alchemy.pl` → `10_engine.patch` and
  `30_catharsis_levelmap.lsx-fragment` in `55/_wip/Resonant/`.
- [ ] **Step 5 — commit** `ARC-0002: behaviour peaks, interrupts, grudge status (R15, R17)`.

---

## Stage 1 — apply and probe (`[fechado] ARC-0002`, ticket `implementation: claude`)

### Item index — implement top to bottom

| # | Type | Subtype | Internal entry | Where in the Toolkit | Depends on | Done |
|---|---|---|---|---|---|---|
| 01 | Level map | — | `Catharsis_Damage` (`11006542-a7b5-4599-938a-2840982c4bb1`) | Level Maps | — | ☑ |
| 02 | Statuses | `BOOST` | peaks changed; `RESONANT_*` helpers | Stats → StatusData | 01 | ☑ |
| 03 | Interrupts | — | `Interrupt_Arcana_TrustFollowUp`, `Interrupt_Arcana_AnticipationGuard` | Stats → InterruptData | 02 | ☑ |
| 04 | Spells | `Target` | the 8 Surges + upcast variants | Stats → SpellData | 01–03 | ☑ |
| 05 | Osiris | goal | `ARCANA_Resonant_Grudge` | Story Editor | 02 | ☑ |
| 06 | Localization | — | `@loca` lines of the patch | Localization | 02–04 | ☑ |

### 01 · Level map `Catharsis_Damage`

- **Files:** `Public/AspectClass_…/Levelmaps/LevelMapValues.lsx` + editor twin `Editor/Mods/AspectClass_…/Levelmaps/LevelMapValues.tbl`.
- **Vanilla/mod anchor:** `Starcall_Damage` in the same file.

| Field | Value | Origin |
|---|---|---|
| Level1–4 / 5–9 / 10–20 | `2d8` / `3d8` / `4d8` | `STA_Resonant_Catharsis#damage.by_level` |
| `Name` | `Catharsis_Damage` | — |
| `UUID` | `11006542-a7b5-4599-938a-2840982c4bb1` | generator constant |

- **How:** paste `30_catharsis_levelmap.lsx-fragment` as a new `LevelMapSeries` node next to `Starcall_Damage`;
  add the matching row to the `.tbl` (copy the `Starcall_Damage` row, change Name, UUID and the 20 levels).

### 02–04, 06 · The engine patch

- [ ] **Step 1:** `perl 82_Automation/stats/stats_add.pl 55/_wip/Resonant/10_engine.patch` (dry run), read the report.
- [ ] **Step 2:** apply (`--apply`), then `perl gen_upcast_variants.pl --apply`, then `perl gen_emotion_alchemy.pl`
  again and apply `20_upcast_targets.patch`; `perl sort_stats.pl --apply`; `perl check_cards.pl`.
- [ ] **Step 3:** grep — every `Target_Arcana_Card_Spell_Emotion*_N` contains `RESONANT_REFUND_TECH` and
  `LevelMapValue(Catharsis_Damage)` (review focus 3).
- [ ] **Step 4:** `sync_data`, commit + push `ARC-0002: stage 1 engine patch`.

### 05 · Osiris goal `ARCANA_Resonant_Grudge`

- **File:** `Mods/AspectClass_…/Story/RawFiles/Goals/ARCANA_Resonant_Grudge.txt` (format of `ARCANA_Status_Hemorrhage.txt`).
- **Anchors** (`story_header.div`): `event AttackedBy(_Defender,_AttackerOwner,_Attacker,_DamageType,_DamageAmount,_DamageCause,_StoryActionID)`,
  `query HasActiveStatus(_Target,_Status,_Bool)`, `call ApplyStatus(_Object,_Status,_Duration,_Force,_Source)`,
  `event StatusRemoved(_Object,_Status,_Causee,_ApplyStoryActionID)`, `call RemoveStatus(_Target,_Status,_Cause)`.

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION

KBSECTION
//REGION Resonant - Anger and Rage attack whoever hurt them last (spec 5.1, R17, R23)
IF
AttackedBy(_Defender, _AttackerOwner, _, _, _, _, _)
AND
HasActiveStatus(_Defender, "EMOTION_ANGER", 1)
THEN
ApplyStatus(_Defender, "RESONANT_GRUDGE", -1.0, 1, _AttackerOwner);

IF
AttackedBy(_Defender, _AttackerOwner, _, _, _, _, _)
AND
HasActiveStatus(_Defender, "EMOTION_RAGE", 1)
THEN
ApplyStatus(_Defender, "RESONANT_GRUDGE", -1.0, 1, _AttackerOwner);

IF
StatusRemoved(_Defender, "EMOTION_ANGER", _, _)
AND
HasActiveStatus(_Defender, "EMOTION_RAGE", 0)
THEN
RemoveStatus(_Defender, "RESONANT_GRUDGE", _Defender);

IF
StatusRemoved(_Defender, "EMOTION_RAGE", _, _)
THEN
RemoveStatus(_Defender, "RESONANT_GRUDGE", _Defender);
//END_REGION
EXITSECTION

ENDEXITSECTION
```

- **Owner step:** compile the Story in the Story Editor (the goal does nothing until compiled).

### Probes — the Owner plays these after stage 1 (one rule each)

| # | Do | Proves it works | Plan B if it fails |
|---|---|---|---|
| P0 | Catharsis on an ally at level 5 | Heals 3d8 (not 2d8, not 0) | Heal stays `2d8` fixed; the Owner decides |
| P1 | Joy on an ally beside another ally and an enemy | Only the ally gets *Contagious Joy*; it disappears after one attack | Joy back to Advantage on its own rolls |
| P2 | Trust on an ally; you hit an enemy | The Trusting ally is asked to react and attacks **that** enemy | Trust back to +2 AC, Advantage on saves |
| P3 | Anticipation on an ally; an enemy walks into its reach | It is asked to react and attacks before the enemy acts | +1 reaction, doubled movement |
| P4 | Anger on an enemy; hit it with ally A, then ally B | It attacks B on its turn (the last one), even its own ally if that was the last | Anger keeps "attacks the nearest" |
| P5 | Two Surges in one turn that both cause reactions; one more that is saved against | One slot back in total; nothing for the saved one | — (a failure here is a bug) |

---

## Stage 1b — probe fixes (done 2026-10-12, `[fechado]`)

From the stage-1 probes (P0 ✅, P1 ✅, P2 ❌, P3 ❌, P4 ❌, P5 not run): decisions R25–R28.

| Fix | Generator / file | Verified |
|---|---|---|
| R25 — Surges skip constructs, no INT gate | `target_conditions` | 0 `IntelligenceGreaterThan` left in `Spell_Target.txt` |
| R26 — Anger/Rage: grudge or fallback, never both | peaks lose the madness boosts; `RESONANT_ANGER_FALLBACK`; goal `ARCANA_Resonant_Grudge` rewritten (last attacker remembered during the fight, cleared on `CombatEnded`) | patch dry run; Story compile pending |
| R27 — Trust shoulder to shoulder (shares the blow: Warding Bond boosts on the ally, `OnPreDamage` interrupt) | `Interrupt_Arcana_TrustShoulder`, `RESONANT_TRUST_SHOULDERED`; `Interrupt_Arcana_TrustFollowUp` removed (never published) | 1 removal in the patch |
| R28 — Joy shares its contagion; Anticipation lasts until the Resonant's next turn | aura `IF(Ally() or Self())`; `TickingWithSource` + `StartTurn` | in game files |

Generator tests 68/68; `check_cards` OK; `stats_add --selftest` 970/0.

**Re-test (Owner):** compile the Story; then P2 (Trust shoulder), P3 (Anticipation on the enemies' turns), P4 (hit with A then B → it attacks B; a fresh enemy → attacks the nearest), P5 (refund: Joy on an Accepting ally → Love, one slot back).

## Stage 2 — Overload and Emotional Overload

**Spec:** `21.04/Resonant/2026-10-11-resonant-design.md` §6 (R9–R13, R19, R20, R22). **Numbers:**
`FEAT_Resonant_Overload` (size by level, +1 peak, +2 reaction, full damage = slot level),
`SPL_Resonant_EmotionalOverload` (18 m, 1d6 Psychic per feeling, Paralysed 2 turns). Shared Heart's "once per
Surge" (R19) belongs to stage 5.

**Anchors:** count display — `PROC_ARCANA_Aspect_ShowNumber` + `ASPECT_PROGRESS_*` (`StackType "Overwrite"`,
`RemoveEvents "OnCombatEnded"`, `StatusPropertyFlags "FreezeDuration;IgnoreResting"`, duration = value × 6 s)
in `ARCANA_Aspect_Common.txt`; counter in Osiris — `PROC_ARCANA_Aspect_Step` (`IntegerSum`, `IsInCombat`);
`HasPassive(_Entity,_Passive,_Bool)`, `GetLevel(_Object,_Level)`, `IntegerProduct`, `IntegerToReal`
(`story_header.div`); flat damage per turn — `TickFunctors "DealDamage(N,Type)"` (vanilla `ORI_GALE_AURANECROSIS`);
paralysis without a save — vanilla `PARALYZED` (INCAPACITATED, no `RemoveConditions`); class-level brackets —
`Arcana_Passive_ArcaneOverflow`. Naming: the ultimate never enters the deck and appears only when the meter is
full → `Target_Arcana_Created_EmotionalOverload` (Created, `arcana-naming-convention`); Osiris internals use
`ARCANA_` (`DB_ARCANA_…`, `PROC_ARCANA_…`).

### Task 2.0 · Osiris names follow the convention (T4)

The stage-1 grudge goal uses `DB_Resonant_*` / `PROC_Resonant_*`. Rename to `DB_ARCANA_Resonant_LastAttacker`,
`PROC_ARCANA_Resonant_Grudge_Start / _Refresh / _Clear` (same rules, names only). Check: `grep -c "Resonant_" `
finds only `ARCANA_`-prefixed internals.

### Task 2.1 · Overload statuses and passive (generator, test first)

- [ ] **Failing tests** (append to `t/gen_emotion_alchemy.t`):

```perl
# ---- stage 2: Overload
like(block($p, 'RESONANT_OVERLOAD'), qr/"StackType" "Overwrite".*"RemoveEvents" "OnCombatEnded".*"StatusPropertyFlags" "FreezeDuration;IgnoreResting"/s, 'the meter shows a frozen count, gone after combat');
my $full = block($p, 'RESONANT_OVERLOAD_FULL');
like($full, qr/"TickType" "StartTurn"/, 'full: hurts at the start of your turn');
is(scalar(() = $full =~ /DealDamage\(\d,Psychic,Magical\)/g), 4, 'full: one damage per slot-level bracket (5-6, 7-8, 9-10, 11+)');
like($full, qr/ClassLevelHigherOrEqualThan\(11,'Arcana'\)\):DealDamage\(6,Psychic,Magical\)/, 'full at level 11+: 6 Psychic');
like(block($p, 'Arcana_Passive_Overload'), qr/"DisplayName"/, 'the Overload passive exists');
like($lt{'HW_ARCANA_PASSIVE_OVERLOAD_DESC'} // '', qr/Emotional Overload/, 'the passive names the ultimate');
```

- [ ] **Run → FAIL** (`RESONANT_OVERLOAD` not generated).
- [ ] **Implement** in `build_statuses`:

```perl
# Stage 2: the meter -- a count shown as a frozen duration, like ASPECT_PROGRESS_* (ARCANA_Aspect_Common.txt)
push @out, ['Status_BOOST', entry('RESONANT_OVERLOAD', 'StatusData', StatusType => 'BOOST',
    DisplayName => loca(key('RESONANT_OVERLOAD', 'NAME'), 'Overload'),
    Description => loca(key('RESONANT_OVERLOAD', 'DESC'), 'Everything you made others feel this fight, felt again. When it is full, you suffer at the start of each turn until you release it with Emotional Overload.'),
    Icon => 'Spell_Enchantment_CalmEmotions', StackId => 'RESONANT_OVERLOAD', StackType => 'Overwrite',
    RemoveEvents => 'OnCombatEnded', StatusPropertyFlags => 'FreezeDuration;IgnoreResting', StatusGroups => 'SG_RemoveOnRespec')];
# full: Psychic damage equal to the slot level at the start of each turn (25: FEAT_Resonant_Overload#full_damage)
my @br = ([3, 5, 7], [4, 7, 9], [5, 9, 11], [6, 11, undef]);
my $tick = join ';', map { my ($dmg, $lo, $hi) = @$_; my @c = ("ClassLevelHigherOrEqualThan($lo,'Arcana')");
    push @c, "not ClassLevelHigherOrEqualThan($hi,'Arcana')" if $hi; 'IF(' . join(' and ', @c) . "):DealDamage($dmg,Psychic,Magical)" } @br;
push @out, ['Status_BOOST', entry('RESONANT_OVERLOAD_FULL', 'StatusData', StatusType => 'BOOST',
    DisplayName => loca(key('RESONANT_OVERLOAD_FULL', 'NAME'), 'Overloaded'),
    Description => loca(key('RESONANT_OVERLOAD_FULL', 'DESC'), 'You can release Emotional Overload. Until you do, you take Psychic damage at the start of each of your turns.'),
    Icon => 'Spell_Enchantment_CalmEmotions', StackId => 'RESONANT_OVERLOAD_FULL', TickType => 'StartTurn',
    TickFunctors => $tick, RemoveEvents => 'OnCombatEnded', StatusPropertyFlags => 'IgnoreResting')];
```

In `build_passives`: `passive('Arcana_Passive_Overload', 'Overload', <text>, 'Spell_Enchantment_CalmEmotions')` with the
text *"You feel what you make others feel. Each emotion that takes hold adds 1 to your Overload, and each reaction adds 2.
When it is full, you take Psychic damage at the start of each turn until you release it with Emotional Overload."*
Add it to the DEBUG passives list (`build_debug`) so it can be tested before stage 6.
- [ ] **Run → PASS**; commit `ARC-0002: Overload statuses and passive`.

### Task 2.2 · Emotional Overload (generator, test first)

- [ ] **Failing tests:**

```perl
my $eo = block($p, 'Target_Arcana_Created_EmotionalOverload');
like($eo, qr/"UseCosts" "ActionPoint:1"\n/, 'Emotional Overload: an action, no slot or Thread (R22)');
like($eo, qr/HasStatus\('RESONANT_OVERLOAD_FULL', ?context\.Source\)/, 'only with the meter full');
unlike($eo, qr/"SpellRoll"/, 'no saving throw');
is(scalar(() = $eo =~ /IF\(HasStatus\('FEELING_\w+'\)\):DealDamage\(1d6,Psychic,Magical\)/g), 24, '1d6 Psychic per feeling, all 24');
like($eo, qr/ApplyStatus\(PARALYZED,100,2\)/, 'Paralysed 2 turns (vanilla PARALYZED)');
like($eo, qr/ApplyStatus\(SELF,RESONANT_OVERLOAD_SPENT_TECH,100,0\)/, 'tells Osiris to empty the meter');
```

- [ ] **Run → FAIL.**
- [ ] **Implement** `build_overload_spell` (written to `@file Spell_Target`, after the Surges):
  `SpellType Target`, `Level 0`, `TargetRadius` from `SPL_Resonant_EmotionalOverload#range`, `AmountOfTargets 1`,
  `TargetConditions "Character() and not Dead() and not Ally() and not Self() and not Tagged('CONSTRUCT') and HasStatus('RESONANT_OVERLOAD_FULL', context.Source)"`,
  `SpellSuccess` = for each of the 24 feelings (sorted) `IF(HasStatus('FEELING_X')):DealDamage(1d6,Psychic,Magical);IF(HasStatus('FEELING_X')):RemoveStatus(FEELING_X)`,
  then `ApplyStatus(PARALYZED,100,2);ApplyStatus(SELF,RESONANT_OVERLOAD_SPENT_TECH,100,0)`; `UseCosts "ActionPoint:1"`;
  `SpellFlags "IsSpell;HasVerbalComponent;HasSomaticComponent;IsHarmful"`; `VerbalIntent "Control"`; icon of Catharsis.
  Description: *"Pour everything you have felt this fight into one creature. Every feeling it carries tears at it, and it
  is Paralysed."* Plus `hidden_status('RESONANT_OVERLOAD_SPENT_TECH', 'Overload spent', 'StackId', 'RESONANT_OVERLOAD_SPENT_TECH')`.
- [ ] **Run → PASS**; commit `ARC-0002: Emotional Overload`.

### Task 2.3 · The counter goal (generated)

The generator writes `40_overload_goal.txt` (CRLF, ASCII) from the wheel table, so the status lists never drift.
- [ ] **Failing tests:**

```perl
my $g = Alchemy::overload_goal();
is(scalar(() = $g =~ /DB_ARCANA_Resonant_OverloadPoints\("EMOTION_\w+", 1\)/g), 8, '+1 for each of the 8 peaks');
is(scalar(() = $g =~ /DB_ARCANA_Resonant_OverloadPoints\("(?:FEELING_\w+|EMOTION_\w+|CATHARSIS)", 2\)/g), 33, '+2 for 24 feelings, 8 intense, Catharsis');
like($g, qr/DB_ARCANA_Resonant_OverloadMax\(5, 11\).*DB_ARCANA_Resonant_OverloadMax\(20, 20\)/s, 'size by level from 25');
like($g, qr/HasPassive\(_Resonant, "Arcana_Passive_Overload", 1\)/, 'counts only for a Resonant with the passive');
unlike($g, /[^\x00-\x7F]/, 'ASCII only');
```

- [ ] **Implement** `overload_goal()`: tables in `PROC_ARCANA_Resonant_Overload_Init` (called from `INITSECTION` and
  `SavegameLoaded`, as `ARCANA_Aspect_Common`); rules:
  1. `StatusApplied(_Target, _Status, _Resonant, _)` AND `DB_ARCANA_Resonant_OverloadPoints(_Status, _Pts)` AND
     `HasPassive(_Resonant, "Arcana_Passive_Overload", 1)` AND `IsInCombat(_Resonant, 1)` AND
     `NOT DB_ARCANA_Resonant_OverloadFull(_Resonant)` → `PROC_ARCANA_Resonant_Overload_Add(_Resonant, _Pts)`.
  2. `_Add`: old value (0 when none) + points (`IntegerSum`); `GetLevel` → `DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max)`;
     below max → store and show (`IntegerProduct(_N, 6)`, `IntegerToReal`, `ApplyStatus(_R, "RESONANT_OVERLOAD", _Dur, 1, _R)`);
     at or above max → store max, show it, `DB_ARCANA_Resonant_OverloadFull(_R)`, `ApplyStatus(_R, "RESONANT_OVERLOAD_FULL", -1.0, 1, _R)`.
  3. `StatusApplied(_R, "RESONANT_OVERLOAD_SPENT_TECH", _, _)` and `LeftCombat(_R, _)` → `PROC_ARCANA_Resonant_Overload_Reset(_R)`:
     clear the value and the full flag, `RemoveStatus` both statuses.
- [ ] **Run → PASS**; commit `ARC-0002: Overload counter goal (generated)`.

### Stage 2 apply (`[fechado] ARC-0002`)

| # | Type | Internal entry | Depends on | Done |
|---|---|---|---|---|
| 01 | Statuses | `RESONANT_OVERLOAD`, `RESONANT_OVERLOAD_FULL`, `RESONANT_OVERLOAD_SPENT_TECH` | — | ☑ |
| 02 | Passive | `Arcana_Passive_Overload` (also on the DEBUG list) | 01 | ☑ |
| 03 | Spell | `Target_Arcana_Created_EmotionalOverload` (Resonant level 5, list "Resonant Level 5"; passive in level 5 PassivesAdded) | 01 | ☑ |
| 04 | Osiris | `ARCANA_Resonant_Overload.txt` (from `40_overload_goal.txt`); grudge goal renamed (Task 2.0) | 01–03 | ☑ |
| 05 | Localization | the patch's `@loca` lines | 01–03 | ☑ |

Steps: generator → `stats_add --apply` → `gen_upcast_variants --apply` → regenerate → `20_upcast_targets.patch` →
`sort_stats --apply` → `check_cards` → `stats_add --selftest` → copy the goals (CRLF) → `sync_data` → commit + push.
**Owner:** compile the Story.

### Probes (one rule each)

| # | Do | Proves it works |
|---|---|---|
| P6 | Level 5 Resonant with the DEBUG passives; Surge a peak, then a reaction | Overload shows 1, then 3; a failed save adds nothing |
| P7 | Keep going to 11 | *Overloaded* appears; at the start of your next turn you take 3 Psychic |
| P8 | Before it is full | Emotional Overload can't be cast (greyed) |
| P9 | Full; an enemy with 2 feelings → Emotional Overload | 2d6 Psychic in total, its feelings gone, Paralysed 2 turns with no save; the meter empties; no slot spent |
| P10 | End the combat with some Overload | The meter and *Overloaded* are gone |

## Stage 2b — Overload from level 1 (R29, R30)

Changes the stage-2 design: the meter exists from level 1; a full meter makes the Resonant *Overloaded* for
turns equal to the character level (silenced, Psychic damage per turn, Psychic on weapon hits); Emotional
Overload (level 5) is **not a spell** and ends it. Numbers: `FEAT_Resonant_Overload` (size from level 1,
`overloaded_duration`, `weapon_psychic`).

**Anchors:** silence — `BlockSpellCast()` (already used by the generator's Unbelief), vanilla `SILENCED`
(`BlockVerbalComponent()`); weapon rider by level — `CharacterWeaponDamage(LevelMapValue(RageDamage))` (vanilla
rage) and `CharacterWeaponDamage(1d4,Radiant)` (`DIVINE_FAVOR`), with a new level map `Overload_WeaponPsychic`
(the stage-1 level-map pattern); duration in Osiris — `GetLevel` × 6.0 s (`ApplyStatus` duration is in seconds).

| Task | Change | Test (RED first) |
|---|---|---|
| 2b.1 | `RESONANT_OVERLOAD_FULL` → *Overloaded*: `BlockSpellCast()`, `CharacterWeaponDamage(LevelMapValue(Overload_WeaponPsychic),Psychic)`, TickFunctors Psychic = slot level with brackets **from level 1** (1–2: 1, 3–4: 2, 5–6: 3 … 11+: 6); no `RemoveEvents OnCombatEnded` change | boosts present; 6 brackets; level map 1d6/2d6/3d6 at 1/5/10 |
| 2b.2 | Emotional Overload not a spell: `SpellFlags` without `IsSpell` / `HasVerbalComponent`; requires `RESONANT_OVERLOAD_FULL` | flags; condition |
| 2b.3 | Counter goal: `DB_ARCANA_Resonant_OverloadMax` rows from level 1 (5, 8, 11…); at full apply *Overloaded* for `GetLevel × 6.0` s; `StatusRemoved(… "RESONANT_OVERLOAD_FULL" …)` resets the meter | rows 1–20; duration rule; reset on removal |
| 2b.4 | Progression: `Arcana_Passive_Overload` moves to Resonant **level 1** (PassivesAdded of the level-1 rows); Emotional Overload stays in "Resonant Level 5" | dump shows it at L1, not L5 |

Apply with `[fechado] ARC-0002`. Probes then: P6–P10 updated — P7 becomes "full → *Overloaded*: no spells,
weapon hit +Psychic, Psychic at turn start, lasts your level in turns"; P9 adds "usable while silenced".

## Stage 3 — signature spells and the probe fixes

**Spec:** `21.04/Resonant/2026-10-11-resonant-design.md` §7. Each spell is a generator entry with a RED test first,
as in stages 0–2. Numbers: `SPL_Resonant_Heartstring`, the rest TBD in `25` when the spell is written (range 6 m
for Contagion, 9 m for Compassion — design values already in the spec).

| Task | What | Anchor | Notes |
|---|---|---|---|
| **3.0** | **P8 fix:** Emotional Overload is greyed out until *Overloaded* | `RequirementConditions "HasStatus('…')"` on the caster (vanilla spells, e.g. `not HasStatus('SG_Polymorph')`) | Move the check from `TargetConditions` |
| **3.0b** | **R32:** the meter always shows — at 0% a permanent `RESONANT_OVERLOAD` (duration −1, no number) | `ApplyStatus(…, -1.0, …)` (mod goals); on `SavegameLoaded` and on reset, for every character with `Arcana_Passive_Overload` | Reset re-applies the empty meter instead of removing it |
| **3.1** | **Heartstring** — cantrip, Action, 18 m, Wisdom save: `DealDamage(LevelMapValue(D4Cantrip),Psychic,Magical)`; a mood on the target lasts 2 turns longer | `D4Cantrip` (mod uses it); +2 turns: Osiris `GetStatusTurns` → re-apply with `(turns + 2) × 6.0` | Hand-off: `HEARTSTRING_TECH` on the target, Osiris finds its mood |
| **3.2** | **Temper** — Bonus Action, container with **Temper: Left** / **Temper: Right**; turns the target's mood one step on the wheel, keeping its remaining turns; non-allies roll Wisdom | `ContainerSpells` / `SpellContainerID` (vanilla `Shout_MAG_Harpers_SingingSword`); Osiris `GetStatusTurns` | Generated: 8 moods × 2 directions; replaces, never reacts (R7) |
| **3.3** | **Read the Room** — utility: Advantage on Insight and Persuasion, Concentration 10 turns | `Advantage(Skill, X)` (vanilla); `Shout_Arcana_Util_` family (locked in combat by the class) | Out of combat only |
| **3.4** | **Ready: Compassion** — Unique reaction card, once per round: when an ally within 9 m takes damage, cast Weave Surge: Trust on it | The mod's **Ready: Gale Deflection** (card + READY status + `Interrupt_Arcana_Reaction_GaleDeflection`); `UseSpell(…)` in an interrupt (vanilla Riposte) | Can trigger Alchemy and the refund |
| **3.5** | **Emotional Contagion** (R33) — Action, Concentration, level 9: the target radiates its **mood** to every creature within 6 m, renewed each turn, no save | Aura statuses (`AuraRadius` + `AuraStatuses`, as Joy's contagion, passed P1); the aura reads the bearer's mood with `HasStatus('MOOD_X', context.Source)` — **probe P11** | Generated: 8 branches, one per mood; the copied mood replaces (R7) |

Apply with `[fechado] ARC-0002`; the spells reach the progression in stage 6 (until then the DEBUG-free path: a
level-appropriate Resonant gets them through the lists of their level, added with the same per-node script).

### Stage 3 apply (`[fechado] ARC-0002`, 2026-10-12) — done

Costs fixed by the Owner as **R34** (Temper: Bonus Action only; Contagion and Compassion: level 3 cards; numbers in
`SPL_Resonant_{Temper,EmotionalContagion,Compassion,ReadTheRoom}`).

| # | Type | Internal entry | Done |
|---|---|---|---|
| 01 | Spell (P8) | `Target_Arcana_Created_EmotionalOverload`: `RequirementConditions "HasStatus('RESONANT_OVERLOAD_FULL')"` | ☑ |
| 02 | Osiris (R32) | `ARCANA_Resonant_Overload`: `PROC_ARCANA_Resonant_Overload_ShowEmpty` (permanent empty meter) on reset, load (`DB_Players`), `LeveledUp`, `CharacterJoinedParty`, `EnteredCombat` | ☑ |
| 03 | Spells | `Target_Arcana_Card_Spell_Heartstring`; `Target_Arcana_Card_Spell_Temper` (+ `_Left`, `_Right`); `Target_Arcana_Card_Spell_EmotionalContagion` (+ `_4`–`_6`); `Shout_Arcana_Util_ReadTheRoom`; `Shout_Arcana_Card_Passive_Compassion` (+ `_4`–`_6`) | ☑ |
| 04 | Statuses | `RESONANT_READ_THE_ROOM`, `COMPASSION_READY`, `RESONANT_CONTAGION`, `RESONANT_TEMPER_LEFT_TECH`, `RESONANT_TEMPER_RIGHT_TECH` | ☑ |
| 05 | Interrupt | `Interrupt_Arcana_Reaction_Compassion` | ☑ |
| 06 | Osiris | `ARCANA_Resonant_Temper.txt` (from `41_temper_goal.txt`) | ☑ |
| 07 | Lists | `52_progression_stage3.pl`: Level 1 + Heartstring, Read the Room; Level 3 + Temper; **Level 5 + Contagion, Compassion — temporary, stage 6 moves them to the level 9 and 11 lists** | ☑ |

Rulings taken while building (cheaper than the plan, same behaviour):
- Heartstring's +2 turns is pure Stats — vanilla `SetStatusDuration(<status>,<turns>,Add)` (`MAG_ZOC_FORCE_CONDUIT`) — so
  no Osiris and no `HEARTSTRING_TECH`.
- Ready: Compassion follows the mod's **Which One** (card → READY status → interrupt), not Gale Deflection: no new
  action resource. The reaction is vanilla **Hellish Rebuke**'s (`OnCastHit` + `UseSpell(…,true,true,true)`; only the
  reaction is paid).
- `removals()` now keeps the upcast variants of every generated card (Emotional Contagion matched the old `Emotion*`
  pattern and would have lost its `_4`–`_6` on every apply).

Checks: tests 162/162, check_cards OK, `stats_add --selftest` 994/0, entry counts `.txt`/`.stats` +1 Interrupt, +5
Shout, +8 Target, +5 Status_BOOST, no repeated field in any table. **Owner:** compile the Story (two goals changed).

### Probes (one rule each)

| # | Do | Proves it works |
|---|---|---|
| P8 | Before *Overloaded* | Emotional Overload is greyed out |
| P10 | Load a save; end a combat with some Overload; reach 0 | The meter shows at 0% (no number) and between combats; *Overloaded* survives the end of a combat |
| P11 | Emotional Contagion on an enemy with a mood, enemies around it | Every creature within 6 m gets the same mood, again next turn; nobody saves. **If nobody gets it:** the aura reads the caster, not the bearer — say so |
| P12 | Heartstring an enemy with a mood (hover the mood before and after) | Psychic damage on a failed save; the mood gains 2 turns |
| P13 | Temper: Left / Right on a creature with a mood | The mood becomes its neighbour (see the tooltip list) with the same turns left; an enemy can save; no feeling or Catharsis appears |
| P14 | Read the Room out of combat | Advantage on Insight and Persuasion; the spell is greyed out in combat |
| P15 | Ready: Compassion, then an enemy hits an ally within 9 m | You are asked to react; the ally gets Weave Surge: Trust (or its reaction, if it had a mood); once per round |

Results (Owner, 2026-10-12): P8 ✅ P11 ✅ (but both sides) P12 ✅ P15 ✅; P10 meter not shown at 0% — **accepted as
is**, persistence across a save still to be seen in game; P13 ❌ (no change); P14 redundant with Empathic Sight.

## Stage 3b — probe fixes (R35–R37)

| Task | Change | Test (RED first) |
|---|---|---|
| 3b.1 | **R35** Emotional Contagion: `AuraStatuses` gain `Ally()` (aura context: relative to the bearer, as Joy's `IF(Ally() or Self())`, passed P1) | 8 branches with `Ally()` |
| 3b.2 | **R36** Temper: one Bonus Action spell, no container; `SpellSuccess` = 8 × `IF(HasStatus('MOOD_X')):ApplyStatus(EMOTION_X,100,1)` then 8 × `IF(HasStatus('MOOD_X')):RemoveStatus(MOOD_X)`. The peak's own `OnRemoveFunctors` leave the mood again. No Osiris: goal and the two sides retired | peaks before removals; no reaction ids; `temper_goal` gone; sides retired |
| 3b.3 | **R37** Read the Room removed (spell, status, DEBUG unlock, level 1 list, `SPL_` file) | not generated; retired |

Moved, not deleted, to `90_ARCHIVE/93_Old_Versions/2026-10-12_ARC-0002_stage3b/` (README): `41_temper_goal.txt`, the game goal
`ARCANA_Resonant_Temper.txt` (by `53_stage3b_apply.pl --apply`), `SPL_Resonant_ReadTheRoom.yaml`.

Note: Temper's peak counts **+1 Overload** (the counter adds every peak that lands, R12).

**Apply** (`[fechado] ARC-0002`): `stats_add 10_engine.patch --apply` (6 removals) → `gen_upcast_variants --apply` →
regenerate → `20_upcast_targets.patch` → `sort_stats --apply` → `check_cards` → `selftest` → `53_stage3b_apply.pl
--apply` → `sync_data` → commit + push. **Owner:** compile the Story (one goal less).

| # | Do | Proves it works |
|---|---|---|
| P11b | Emotional Contagion on an enemy with a mood, its allies and yours around it | Only its allies catch the mood |
| P13b | Temper on an enemy that is Annoyed; on an ally that is Serene | The enemy is angry again for 1 turn (grudge), then Annoyed for 5 turns; the ally is Joyful (contagious) for 1 turn, then Serene for 5 |

Results (Owner, 2026-10-12): P11b ✅ P13b ✅ — stage 3 closed.

## Stage 4 — Aspect Awakening: 14 · Temperance

**Spec:** `21.04/Resonant/2026-10-11-resonant-design.md` §9, §9.1. **Decisions:** R21 (Tier I Resonance), R8 (Tier II
Harmony), R14 (Tier III), R38 (The Two Cups does not fill the Overload), R39 (Harmony's mood follows the side).
**Numbers:** `FEAT_Resonant_AspectAwakening` (goals 3 / 6 / 15, Harmony 6 m) + new rows `tier1_mood_extend` (2 turns),
`tier3_radius` (6 m), `tier3_paralysed_others` (1 turn); `STA_Resonant_Catharsis#tier1_bonus` (1d8); new
`SPL_Resonant_TwoCups` (radius 18 m, once per combat).

**Pattern — the four existing Aspects, nothing new in the frame:**
- `ARCANA_Aspect_Common.txt` owns the tiers: `DB_ARCANA_Aspect`, `DB_ARCANA_AspectTier`, `DB_ARCANA_AspectShow` rows;
  `PROC_ARCANA_Aspect_Step` (+1, the Empress counter); the reached tiers in `DB_ARCANA_AspectReached(char, tier)` —
  **Osiris effects check that DB, never the level**; `PROC_ARCANA_Aspect_Reset` on leaving combat.
- Stats as the Empress (High Priestess): hidden `ASPECT_AWAKENED_<X>` (Tier I reached: `UnlockSpell` of the Aspect
  card, removes the tier statuses), visible `ASPECT_AWAKENED_<X>_I/II/III` (one StackId `…_TIER`, StackPriority 1/2/3,
  each lists every bonus so far, `ForceOverhead;IgnoreResting`), `ASPECT_PROGRESS_<X>` (count, `FreezeDuration`);
  hidden tier passives `Arcana_Passive_Aspect_<X>_I/II/III` and the visible `Arcana_Passive_Aspect_<X>_Awakening`
  ("14 - Temperance: Awakening", the goals per level). Progression: level 3 → `_I` + `_Awakening`, 7 → `_II`, 12 → `_III`.
- Aspect card as `Shout_Arcana_Created_Aspect_VeilLifts`: Shout, `AreaRadius`, `Cooldown OncePerCombat`,
  `Requirements Combat`, card mark, no slot.
- Tier II as the Empress's Two Pillars: nearest candidate from `DB_ARCANA_Aspect_InCombat`, `GetDistanceTo`, best kept
  in a DB, once per turn cleared on `TurnStarted`.
- Which Surge was cast: `UsingSpellOnTarget` + `DB_ARCANA_CardFamily(_Spell, _Root)` (variant → card, written by
  `gen_upcast_variants`; the Fool's Zephyr Strike uses it).

| Task | What | How | Test (RED first) |
|---|---|---|---|
| **4.1** | **Goal — cause reactions** | Generated goal `ARCANA_Aspect_Temperance.txt` (`42_temperance_goal.txt`): table `DB_ARCANA_Resonant_AwakeningStatus` = the 24 feelings, 8 intense, `CATHARSIS`, `RESONANT_TWO_CUPS_CATHARSIS`; `StatusApplied(_, _S, (CHARACTER)_R, _)` + row → `PROC_ARCANA_Aspect_Step(_R, "TEMPERANCE")`. `ARCANA_Aspect_Common.txt` gains the TEMPERANCE rows (1 aspect, 3 tiers 3/6/15, `COUNT`) through an anchored edit script | 34 rows; Step call; Common rows in the script's output |
| **4.2** | **Tier statuses and passives** | `ASPECT_AWAKENED_TEMPERANCE` (+ `_I/_II/_III`), `ASPECT_PROGRESS_TEMPERANCE`, `Arcana_Passive_Aspect_Temperance_I/II/III` (Resonance / Harmony / Aspect of Empathy, hidden), `…_Awakening` (Highlighted). Texts in the Empress's format | entries, StackId/priorities, flags; texts name the goals 3/6/15 |
| **4.3** | **Tier I — Resonance: Catharsis +1d8** | Surge `SpellSuccess`, Catharsis branch: two more functors gated on `HasStatus('ASPECT_AWAKENED_TEMPERANCE', context.Source)` — `DealDamage(1d8,Psychic,Magical)` on a non-ally, `RegainHitPoints(1d8)` on an ally | 14 functors per Surge; gate |
| **4.4** | **Tier I — moods last 2 turns longer** | Each peak's `OnRemoveFunctors` splits: `IF(RemoveCause(TimeOut) and not HasStatus('ASPECT_AWAKENED_TEMPERANCE', context.Source))` → mood 5 turns; `… and HasStatus(…)` → 7. **Probe P17**: `context.Source` in a remove functor is the status's source (the Resonant). Plan B: Osiris on `StatusApplied(MOOD_*)` by a Resonant with tier 1 → re-apply for (turns + 2) × 6 s | both branches on 16 peaks/intense |
| **4.5** | **The Two Cups** (Tier I card) | `Shout_Arcana_Created_Aspect_TwoCups`: Action, 18 m, once per combat; every creature with a mood: non-ally `DealDamage(LevelMapValue(Catharsis_Damage))` + 1d8 Psychic, ally `RegainHitPoints` same; then `RESONANT_TWO_CUPS_CATHARSIS` (shown as Catharsis, spends the moods). **Not** `CATHARSIS`, so the Overload ignores it (R38) and the Awakening counts each one | card fields; not in the Overload table; in the Awakening table |
| **4.6** | **Tier II — Harmony** | Goal: `StatusApplied` of a feeling by `_R` with `DB_ARCANA_AspectReached(_R, 2)`, once per turn → nearest other creature within 6 m of the feeling's bearer gets a mood for 5 turns (source `_R`; it replaces, R7). Which mood (R39): table `DB_ARCANA_Resonant_HarmonyMood(feeling, surge emotion, mood for an ally, mood for a non-ally)` — 24 × 2 rows, generated; the Surge from `DB_ARCANA_Resonant_LastSurge(_R, emotion)`, set on `UsingSpellOnTarget` | 48 rows; Love cast as Joy → ally Serene / enemy Serene; Awe (Fear+Surprise) cast as Fear → ally Apprehensive; Hope … |
| **4.7** | **Tier III — Emotional Overload reaches an area** | Goal: `UsingSpellOnTarget(_R, _T, "Target_Arcana_Created_EmotionalOverload", …)` with `DB_ARCANA_AspectReached(_R, 3)` → every enemy of `_R` in the combat, other than `_T`, within 6 m of `_T`, carrying a feeling: its feelings removed, `PARALYZED` 6 s (1 turn). Collect first, then apply (the Temper lesson). The target keeps the spell's own 2 turns | rule present; 1 turn; feelings table reused |
| **4.8** | **Progression** | Anchored script: Resonant L3 `PassivesAdded` += `Arcana_Passive_Aspect_Temperance_I;Arcana_Passive_Aspect_Temperance_Awakening`; L7 += `_II`; L12 += `_III` (rows a3489148…, 8935e1fd…, 3cdd83e0…) | dump shows them |

**Apply** (`[fechado] ARC-0002`): generator → `stats_add 10_engine.patch --apply` → `gen_upcast_variants --apply` →
regenerate → `20_upcast_targets.patch` → `sort_stats --apply` → `check_cards` → `selftest` → copy the goals (CRLF) →
the Common + progression script `--apply` → counts and repeated-field scan → `sync_data` → commit + push.
**Owner:** compile the Story.

### Stage 4 apply (`[fechado] ARC-0002`, 2026-10-12) — done

New: `ASPECT_AWAKENED_TEMPERANCE` (+ `_I/_II/_III`), `ASPECT_PROGRESS_TEMPERANCE`, `RESONANT_TWO_CUPS_CATHARSIS`,
`Arcana_Passive_Aspect_Temperance_I/II/III/_Awakening`, `Shout_Arcana_Created_Aspect_TwoCups`; Surges and peaks
regenerated (Catharsis +1d8, the 7-turn mood); goal `ARCANA_Aspect_Temperance.txt` (from `42_temperance_goal.txt`);
`54_stage4_apply.pl`: progression L3 / L7 / L12 (LSX + TBL) and the TEMPERANCE rows in `ARCANA_Aspect_Common.txt`
(from `43_common_rows.txt`). Numbers: `FEAT_Resonant_AspectAwakening` (+3 rows), new `SPL_Resonant_TwoCups`.
Checks: tests 199/199, check_cards OK, selftest 1003/0, counts +4 Passive, +1 Shout, +6 Status_BOOST on both sides,
no repeated field. **Owner:** compile the Story (one goal new, Common changed).

### Probes (one rule each)

| # | Do | Proves it works |
|---|---|---|
| P16 | Level 3+ Resonant: cause 3 reactions in one fight | *Awakening Progress* counts 1, 2; at 3 *14 - Temperance: Awakened I* appears, The Two Cups unlocks; all gone when the combat ends |
| P17 | Awakened I: let a peak fade | The mood lasts 7 turns (5 before awakening) |
| P18 | Awakened I: a Catharsis on an enemy | Catharsis damage + 1d8 more |
| P19 | The Two Cups with moods on allies and enemies | Enemies hurt, allies healed, their moods gone; Overload unchanged; Awakening counts each one; once per combat |
| P20 | Level 7: 6 reactions, then braid a feeling | The nearest creature within 6 m gets the mood of R39; only once per turn |
| P21 | Level 12: 15 reactions, then Emotional Overload with enemies with feelings near the target | They lose their feelings and are Paralysed 1 turn; the target 2 turns |

Results (Owner, 2026-10-12): P16 ✅ P17 ✅ P18 ✅ P19 ✅ P21 ✅; P20 ❌ (and the mechanic read as complex) → R40.

## Stage 4b — Tier II redesign (R40) and Surges on any creature (R41)

| Task | Change | Test (RED first) |
|---|---|---|
| 4b.1 | **Feelings +2 at Tier II:** each feeling branch of a Surge splits — `… and not <T2>` → 2 turns, `… and <T2>` → 4, `<T2>` = `HasStatus('ASPECT_AWAKENED_TEMPERANCE_II'` or `_III`, `context.Source)` (one StackId, III replaces II). Number: `FEAT_Resonant_AspectAwakening#tier2_feeling_extend` | both branches on every feeling of every Surge; 20 functors per Surge |
| 4b.2 | **Free Surge once per turn:** `RESONANT_SURGE_FREE` (1 turn) with vanilla Extra Attack's `UnlockSpellVariant(<check>,ModifyUseCosts(Replace,ActionPoint,0,0,ActionPoint),ModifyIconGlow(),ModifyTooltipDescription())`; Osiris as the Fool's `FOOL_ZEPHYR_FREE`: `PROC_ARCANA_Aspect_OnTier(…, "TEMPERANCE", 2)` and `TurnStarted` + `DB_ARCANA_AspectReached(_, 2)` apply it, `CastedSpell` of a Surge (`DB_ARCANA_CardFamily` → `DB_ARCANA_Resonant_SurgeRoot`) removes it, `PROC_ARCANA_Aspect_Reset` cleans it | status fields; the three rules |
| 4b.3 | **Khonsu `IsWeaveSurge()`** (`44_IsWeaveSurge.khn` → `Scripts/thoth/helpers/IsWeaveSurge.khn`): `HasStringInSpellConditions('ARCANA_IS_SURGE')`, the IsCardSpell pattern; the 8 Surges carry the always-true marker `not HasPassive('ARCANA_IS_SURGE', context.Source)` (variants inherit it) | the marker on the 8, nowhere else |
| 4b.4 | **Old Harmony removed** from the goal (HarmonyMood, LastSurge, nearest creature) | none of its tables left |
| 4b.5 | **R41:** Surge `TargetConditions` lose the side/mood filter (any creature, not a construct); allies still never save | no `Ally()` / mood in the conditions |

**Apply** (`[fechado] ARC-0002`): generator → `stats_add 10_engine.patch --apply` → `gen_upcast_variants --apply` →
regenerate → `20_upcast_targets.patch` → `sort_stats --apply` → `check_cards` → `selftest` → copy
`42_temperance_goal.txt` → `Goals/ARCANA_Aspect_Temperance.txt` and `44_IsWeaveSurge.khn` → (since ARC-0005: replace the `-- ===== IsWeaveSurge =====` section of `Scripts/thoth/helpers/ArcanaHelpers.khn`; never a separate file) →`Scripts/thoth/helpers/IsWeaveSurge.khn` → counts and repeated-field scan → `sync_data` → commit + push.
**Owner:** compile the Story. Toolkit note (memory): custom Khonsu is safe in `UnlockSpellVariant` (the mod's
`IsCardSpell()` already runs there), unsafe in `BoostConditions` — not used.

| # | Do | Proves it works |
|---|---|---|
| P20b | Level 7, Awakened II: braid a feeling | It lasts 4 turns |
| P22 | Awakened II: cast two Weave Surges in one turn | The first costs no action (icon glows), the second costs the action; next turn the free one is back; upcast Surges too |
| P23 | Out of combat or before Tier II | Surges cost the action as usual |
| P24 | Weave Surge: Fear on an ally without a mood; Surge: Trust on an enemy without a mood | Both can be cast; the ally gets the peak with no save, the enemy saves |

Fix after 4b (2026-10-12): the Toolkit warned "Destination buffer too small to read line! Buffer size 4096, needed 4833" —
the 8 Surge `SpellSuccess` lines had grown to 4832–4880 characters (the Tier II branches). Built (not applied): the R16
refund moves to Osiris (`ARCANA_Resonant_Overload`: `StatusApplied` of a reaction status → `RESONANT_REFUND_TECH`, table
`DB_ARCANA_Resonant_Reaction`), and the Tier II condition reads a short hidden marker `RESONANT_TIER2` (Osiris applies it
with the tier, removes it on reset). Longest line now 3301; test 213/213 includes "no line over 3900". Apply with the
4b steps (also copy `40_overload_goal.txt` → `Goals/ARCANA_Resonant_Overload.txt`). Re-check the refund (P1-style: a
reaction gives the slot back, once per turn) with P20b–P24.

Results (Owner, 2026-10-12): P20b ✅ P22 ✅ P23 ✅ P24 ✅ — but two Surges in one turn can never react (the first leaves a
peak; a peak becomes a mood only when it fades) → R42.

## Stage 4c — the free Surge leaves its mood at once (R42) + the Owner's Toolkit edits

| Task | Change | Test (RED first) |
|---|---|---|
| 4c.1 | **Owner's Toolkit edits into the generator:** Surge `SpellRoll` = `SpellAutoResolveOnAlly(Ability.Wisdom,SourceSpellDC(),true)` (vanilla `Spell_Target` pattern; allies never roll); the reaction list one per line in the Owner's order (Intense, Primary, Secondary, Tertiary, Catharsis), no refund line (Emotional Alchemy tells it) | SpellRoll; line order; Fear's text identical to the Owner's |
| 4c.2 | **R42 in `ARCANA_Aspect_Temperance`:** `UsingSpellOnTarget` of a Surge while `RESONANT_SURGE_FREE` is on → `DB_ARCANA_Resonant_Echo(_R)`; `StatusApplied` of a peak by `_R` with the mark → the peak's mood for 7 turns (`DB_ARCANA_Resonant_PeakMood`, 8 rows), mark spent; `TurnStarted` and `PROC_ARCANA_Aspect_Reset` clear an unused mark | rules and rows |
| 4c.3 | Tier II and free-Surge texts say it | text |
| 4c.4 | Temper uses the same `SpellAutoResolveOnAlly` (Owner, 2026-10-12) | SpellRoll |

Known edge: if the free Surge reacts instead of leaving a peak, the mark waits for the next peak *this turn* (a Temper
or a second Surge's peak) and gives it its mood at once — the turn ends it otherwise.

**Apply** (`[fechado] ARC-0002`): the 4b steps; copy `42_temperance_goal.txt` → `Goals/ARCANA_Aspect_Temperance.txt`.
**Owner:** compile the Story.

| # | Do | Proves it works |
|---|---|---|
| P25 | Awakened II: Weave Surge: Fear on an enemy (free), then Weave Surge: Trust on it (action) | After the first, it has both Emotion: Fear and Mood: Apprehensive; the second braids Submission the same turn (refund, Overload +2, Awakening +1) |
| P26 | An ally, any Surge | No roll at all; the ally always gets it |

Results (Owner, 2026-10-12): P26 ✅; P25 worked only on ONE target of an upcast (multi-target) Surge — the single Osiris mark
was spent by the first peak. Rebuilt (not applied): the echo moves into each peak's `OnApplyFunctors`,
`IF(HasStatus('RESONANT_SURGE_FREE', context.Source)):ApplyStatus(<mood>,100,7)` — the free Surge is still on the caster
while the spell resolves on all its targets (Osiris removes it after `CastedSpell`); the Osiris mark (`DB_ARCANA_Resonant_Echo`,
`DB_ARCANA_Resonant_PeakMood`) is gone. Re-test P25 with several targets.

## Stage 5 — Shared Heart, the capstone (level 11)

**Spec:** §7.6. **Decisions:** R18 (link the party), R19 (counts once), R24 (free Surges on linked allies), R43 (level 5
card, Unique, once per long rest), R44 (a Catharsis heals every linked ally). **Numbers:** `SPL_Resonant_SharedHeart`
(range 18 m, until combat ends) + `card_level: 5`.

**Anchors:** the card as the Deceiver's capstone `Shout_Arcana_Card_Spell_GrandDeception` (Shout, `AreaRadius`, Level 5,
`Cooldown OncePerRest`, `SpellSlotsGroup:1:1:5`; Unique in `CardDB.lua` — stage 6); copying in Osiris as the Empress
goal walks `DB_ARCANA_Aspect_InCombat`; `GetStatusTurns` (story header) for the copy's duration; the refund status
pattern of `RESONANT_REFUND_TECH`.

| Task | What | How | Test (RED first) |
|---|---|---|---|
| **5.1** | **The card** `Shout_Arcana_Card_Spell_SharedHeart` | Action, 18 m, `Requirements Combat`, card mark; you and every ally in range get `SHARED_HEART` (shown, `RemoveEvents OnCombatEnded`, source = the Resonant) | card fields; status fields |
| **5.2** | **A Surge's result reaches every linked ally** | Generated goal `ARCANA_Resonant_SharedHeart.txt`: `StatusApplied(_T, _S, (CHARACTER)_R, _)` with `_R` a Resonant (Emotional Alchemy), `_S` a peak, intense emotion or feeling (table), `_T` linked → every other linked creature in the combat gets `_S` for the same turns (`GetStatusTurns` × 6 s). **The copies' source is the linked ally `_T`, not the Resonant:** the Overload, Awakening and refund rules ask for a Resonant source, so the Surge counts **once** (R19), and a copy never copies again | table; the copy rule; source `_T` |
| **5.3** | **Catharsis heals them all (R44)** | `StatusApplied(_T, "CATHARSIS", _R)` on a linked ally → the others get `RESONANT_SHARED_CATHARSIS` (OnApply: `RegainHitPoints(LevelMapValue(Catharsis_Damage))`, + the Tier I 1d8 when the Resonant is awakened… source is the ally, so **no Tier I bonus on copies**; spends their moods) | status; rule |
| **5.4** | **Free Surges on linked allies (R24)** | `UsingSpellOnTarget` of a Surge (`DB_ARCANA_CardFamily` → `DB_ARCANA_Resonant_SurgeRoot`) on a linked creature → `RESONANT_SHARED_REFUND_TECH` on the Resonant: the slot back by level + the Thread, **no once-per-turn guard**. The reaction refund (`ARCANA_Resonant_Overload`) skips a linked target, so nothing is refunded twice. A slot must still be in hand to cast (the game checks the cost first) | status; rule; the reaction refund's new condition |
| **5.5** | **Progression** | Stage 6 places the card at level 11; until then, add it to the level 5 list as Contagion and Compassion were | dump |

Known side effects of the copies' source being an ally (accepted, cheaper than tracking copies):
- Love on a copy redirects its damage to the linked ally who was the Surge's target, not to the Resonant.
- Copied peaks fade into a 5-turn mood (the Tier I +2 reads the Resonant as source).
- Trust and Anticipation copies count their turn on that ally's turn.
- Two Resonants in one party: only the first link's source is a Resonant — not handled.

**Apply** (`[fechado] ARC-0002`): generator → `stats_add` → `gen_upcast_variants` → `20_upcast_targets` → `sort_stats` →
`check_cards` → `selftest` → copy `ARCANA_Resonant_SharedHeart.txt` and `40_overload_goal.txt` → list script → counts,
repeated fields and line lengths → `sync_data` → commit. **Owner:** compile the Story.

| # | Do | Proves it works |
|---|---|---|
| P27 | Level 5+ (list), in combat: Shared Heart with 3 allies near | Everyone in 18 m (you too) shows *Shared Heart*; it ends with the combat; once per long rest |
| P28 | Weave Surge: Joy on one linked ally | Every linked creature gets Emotion: Joy; Overload +1 only; the slot comes back |
| P29 | Linked allies with Accepting; Weave Surge: Joy on one | All get Love; Overload +2 once; Awakening +1 once |
| P30 | One linked ally Pensive, Weave Surge: Joy on it (Catharsis) | It heals (+1d8 if awakened); every other linked ally heals the base amount and loses its mood |
| P31 | Weave Surge on an enemy while linked | Normal: costs the slot, no copy |

## Stages 2–7 — index (written in full before each stage)

| Stage | Items | Anchors already found |
|---|---|---|
| 2 · Overload | `OVERLOAD` (count), `OVERLOAD_FULL` (`TickFunctors` Psychic = slot level), passive *Overload*, Osiris count (+1 peak, +2 reaction, once per Surge under Shared Heart, reset on `CombatEnded`), spell *Emotional Overload* (requires `OVERLOAD_FULL`; removes `FEELING_*` with 1d6 each; Paralysed 2 turns) | `PROC_ARCANA_Aspect_Progress` in `ARCANA_Aspect_Common.txt`; `StatusApplied`; `FEAT_Resonant_Overload`, `SPL_Resonant_EmotionalOverload` |
| 3 · Signature spells | Heartstring (cantrip, `LevelMapValue(D4Cantrip)`), Temper (Bonus Action; Osiris `GetStatusTurns` + re-apply), Read the Room, Emotional Contagion, Ready: Compassion | `D4Cantrip` (mod uses it 6×), `GetStatusTurns` (`story_header.div`) |
| 4 · Awakening | `ARCANA_Aspect_Temperance` goal, tier statuses, Tier I Catharsis +1d8, Tier II Harmony, The Two Cups, Tier III area Overload | the four existing `ARCANA_Aspect_*.txt` goals |
| 5 · Shared Heart | link status, Osiris copy of a Surge's result to linked allies (count once), free Surges on linked allies | `StatusApplied`; `SPL_Resonant_SharedHeart` |
| 6 · Progression | lists Resonant Level 1/3/5/7/9/11, progression rows, loca handles, icons | `Progressions.lsx`, `Lists/SpellLists.lsx` |
| 7 · Close | test cases in `60`, spec §15 pass, `05` handoff, player-guide ticket | — |

## Acceptance criteria

See ARC-0002; stage gates above.
