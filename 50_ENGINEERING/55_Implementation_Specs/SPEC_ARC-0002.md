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
| 3 | Heartstring, Temper, Read the Room, Emotional Contagion, Ready: Compassion | Yes | Written in full after stage 2 |
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
