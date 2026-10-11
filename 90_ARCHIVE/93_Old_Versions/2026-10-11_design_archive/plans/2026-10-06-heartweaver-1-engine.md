# Heartweaver, plan 1 of 2 — the Emotional Alchemy engine

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** put the whole Emotional Alchemy engine in the game, testable — 8 Weave Surges, 8 moods, 8 intense emotions, 24 feelings, Catharsis and the 5 passives that unlock each ring — before the Heartweaver subclass exists.

**Architecture:** a Perl generator (`gen_emotion_alchemy.pl`) keeps Plutchik's wheel and every state in one table and writes two patches in the `stats_add.pl` format, which writes the `.txt` (game), the `.stats` (Toolkit) and `english.xml` in one go. Each status goes to the file of its vanilla type (BOOST, FEAR, INCAPACITATED). The Surges and a `[DEBUG] Heartweaver Passives` utility (which grants the 5 passives through a status) join the "Arcana Deck DEBUG" list, so any level-1 Arcana can test the engine. The subclass itself (ClassDescription, progression, signature cards, Awakening) is **plan 2**.

**Tech Stack:** BG3 Stats (`.txt` + `.stats`), LSX/TBL (lists), Perl 5.42 with Test::More (Git Bash; **no `prove`** — run `perl t/x.t`).

**Spec:** `Design/Rework/specs/2026-10-06-heartweaver-design.md` (§4 engine, §5 states, §9 technical pattern, §11 risks).

## Global Constraints

- **Console edition first:** nothing here may depend on the Script Extender. The whole engine is Stats.
- **English everywhere** in the project: specs, plans, script comments, commits, in-game text. Only the 15 other languages wait for the localisation round.
- The game **and** the Toolkit must be closed before any write to a mod file: only on a message that starts with `[fechado]`. The `jt-gate` hook blocks the rest. Tasks 0, 1, 2 and 4 write nothing in the mod; Task 3 does.
- Status types matter: a status that is not a plain BOOST goes in `Status_<TYPE>.txt`, declares `StatusType` **before** `using`, and keeps the parent's `OnApplyFunctors` when it adds its own.
- English text follows the `bg3-english-writing-style` memory: British spelling, no dashes (use ` - `), no double quotes in body text, Title Case for Advantage / Saving Throw / Attack Roll / Armour Class, lowercase for hit points / movement speed / reaction / bonus action; LSTag on the first mention only.
- Exact card mark: `not HasPassive('ARCANA_IS_CARD', context.Source)` in `TargetConditions` (what `check_cards.pl` looks for).
- Never a custom Khonsu function in `BoostConditions`.
- The patches are **generated**: never edit `heartweaver/*.patch` by hand; change the generator's table and run it again.
- End of every block that touches the mod: `bash tools/sync-mod.sh`, commit and push to `Geminitrix/bg3-arcana-deckbuilder` (footer `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`), then update `Context/`.
- Backups in `Data\Backup\heartweaver_engine_20261006\`.

## File map

| File | Role |
|---|---|
| `Design/Rework/tools/gen_emotion_alchemy.pl` (new) | the wheel's table + the two patch generators |
| `Design/Rework/tools/t/gen_emotion_alchemy.t` (new) | generator tests (geometry, 24 dyads, 8×8 matrix, SpellSuccess, closure, status types, text) |
| `Design/Rework/tools/heartweaver_debug_list.pl` (new) | Surges + DEBUG utility on the "Arcana Deck DEBUG" list (lsx + tbl) |
| `Design/Rework/heartweaver/10_engine.patch` (generated) | 69 new entries, removal of the old versions, 141 strings |
| `Design/Rework/heartweaver/20_upcast_targets.patch` (generated) | `AmountOfTargets` = level on the `_N` variants |
| `Design/Rework/plans/2026-10-06-heartweaver-engine-test.md` (new) | in-game test guide |
| `tools/sync-mod.sh` | mirror the two new scripts and the test into `tools/stats/` |
| `Public/…/Stats/Generated/Data/Spell_Target.txt`, `Spell_Shout.txt`, `Status_BOOST.txt`, `Status_KNOCKED_DOWN.txt`, `Passive.txt`, **`Status_FEAR.txt` (new)**, **`Status_INCAPACITATED.txt` (new)** + the Toolkit `.stats` | written by `stats_add.pl` |
| `Public/…/Lists/SpellLists.lsx`, `Editor/Mods/…/Lists/SpellLists.tbl` | written by `heartweaver_debug_list.pl` |
| `Mods/…/Localization/English/english.xml` | written by `stats_add.pl` |
| `Context/07-open-questions.md` | the Heartweaver's state |

Short paths: `$G` = `C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data`, `$M` = `AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7`, `$P` = `C:/Projetos/BG3 Modding/Arcana Class`, `$T` = `$P/Design/Rework/tools`.

### What the generator produces (summary)

| Piece | Ids | File |
|---|---|---|
| 8 Surges (level-1 cards) | `Target_Arcana_Card_Spell_Emotion{Joy,Trust,Fear,Surprise,Sadness,Disgust,Anger,Anticipation}` | Spell_Target |
| 8 peaks + 8 intense (shared `StackId EMOTION`) | `EMOTION_{JOY,…,ANTICIPATION}`, `EMOTION_{ECSTASY,ADMIRATION,TERROR,AMAZEMENT,GRIEF,LOATHING,RAGE,VIGILANCE}` | BOOST, except **Terror → Status_FEAR** (`using FEARED`), **Amazement → Status_INCAPACITATED** (`using STUNNED`), **Grief → Status_INCAPACITATED** |
| 8 moods (`StackId MOOD`) | `MOOD_{SERENE,ACCEPTING,APPREHENSIVE,DISTRACTED,PENSIVE,BORED,ANNOYED,INTERESTED}` | BOOST |
| 24 feelings (each its own StackId) | `FEELING_<name>` | BOOST, except **Awe → Status_INCAPACITATED** (`using HYPNOTIC_PATTERN`) |
| helpers | `CATHARSIS`, `FEELING_DISAPPROVED` (Disapproval's aura), `FEELING_REMORSE_TECH`, `FEELING_MORBIDNESS_TECH`, `HEARTWEAVER_DEBUG` | BOOST |
| passives | `Arcana_Passive_{EmotionalAlchemy,EmpathicSight,ComplexFeelings,Overwhelm,MixedFeelings,FeelingRemorse,FeelingMorbidness}` | Passive |
| DEBUG | `Shout_Arcana_Util_DEBUG_Heartweaver` | Spell_Shout |
| removed | `EmotionFury` and the old variants, the 8 old `Feeling*` spells, `EMOTION_FURY`, the 6 old `MOOD_*`, `EMOTION_JOY` from `Status_KNOCKED_DOWN` | — |

The count: 48 emotional states (8 + 8 + 8 + 24, even) plus Catharsis, plus 4 helpers.

---

### Task 0: Preflight (read only)

**Files:** nothing changes.

- [ ] **Step 1:** check the current entries and the list match what the generator expects.

```bash
D="$G/Public/$M/Stats/Generated/Data"
grep -c '^new entry "Target_Arcana_Card_Spell_\(Emotion\|Feeling\)' "$D/Spell_Target.txt"
grep -n '^new entry "\(EMOTION\|MOOD\|FEELING\)_' "$D"/Status_*.txt
ls "$D" | grep -c 'Status_FEAR\|Status_INCAPACITATED'
ls "$G/Editor/Mods/$M/Stats/StatusData/" | grep 'FEAR\|INCAPACITATED'
grep -n 'f2e5e2e9-42c8-4f0e-88de-830ef0224290' "$G/Public/$M/Lists/SpellLists.lsx" "$G/Editor/Mods/$M/Lists/SpellLists.tbl"
```

Expected (2026-10-06): 34 Emotion/Feeling spells (29 the patch removes + 5 it replaces in place); statuses `EMOTION_{SADNESS,FURY,FEAR,DISGUST,SURPRISE}` and `MOOD_{MELANCHOLIC,RECKLESS,AFRAID,SICKENED,DISORIENTED,EUPHORIC}` in `Status_BOOST.txt`, `EMOTION_JOY` in `Status_KNOCKED_DOWN.txt`; **0** Public `Status_FEAR/INCAPACITATED.txt` but both Toolkit `.stats` present (empty); the DEBUG list in both files. A leftover `EMOTION_FEAR_DAMAGE` or `_TECH` is fine: the generator removes any `EMOTION_/MOOD_/FEELING_` status outside the new set.

- [ ] **Step 2:** lint baseline: `perl "$T/check_cards.pl"; echo "exit $?"`. Note the warning count; Task 3 compares against it.

---

### Task 1: The generator and its tests (TDD) — writes nothing in the mod

**Files:**
- Create: `$T/t/gen_emotion_alchemy.t`
- Create: `$T/gen_emotion_alchemy.pl`
- Generated: `$P/Design/Rework/heartweaver/10_engine.patch`, `20_upcast_targets.patch`

**Interfaces:**
- Produces (package `Alchemy`, loaded with `require`): `distance($a,$b)` → 0..4; `pair($a,$b)` → key `"X+Y"` in wheel order; `reaction($surge,$moodEmotion)` → `{kind=>'intensify'|'feeling'|'catharsis', status, gate, mood, distance}`; `spell_success($e)`, `target_conditions($e)`, `tag_terms($text)` → strings; `build_engine_patch()` → patch text; `build_upcast_patch()` → `($text, $n)`. Data: `@WHEEL`, `%GATE`, `%EMO`, `%FEELING`, `@STATUS_FILES`.
- `main()` writes both patches to `--out DIR` (default `../heartweaver` next to the script) and only **reads** the game.

- [ ] **Step 1: write the tests**

Create `$T/t/gen_emotion_alchemy.t` with:

```perl
#!/usr/bin/perl
# Tests for the Emotional Alchemy generator.   perl t/gen_emotion_alchemy.t   (`prove` does not run on this Perl)
use strict; use warnings; no warnings 'once';
use Test::More;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
require(abs_path(dirname(__FILE__)) . '/../gen_emotion_alchemy.pl');

my @W = @Alchemy::WHEEL;

# ---- the wheel
is(Alchemy::distance('Joy', 'Joy'), 0, 'same emotion: 0');
is(Alchemy::distance('Joy', 'Trust'), 1, 'neighbours: 1');
is(Alchemy::distance('Joy', 'Anticipation'), 1, 'the wheel wraps: Anticipation neighbours Joy');
is(Alchemy::distance('Joy', 'Fear'), 2, 'two steps: 2');
is(Alchemy::distance('Joy', 'Surprise'), 3, 'three steps: 3');
is(Alchemy::distance('Joy', 'Sadness'), 4, 'opposites: 4');
for my $x (@W) { for my $y (@W) {
    is(Alchemy::distance($x, $y), Alchemy::distance($y, $x), "symmetric $x/$y") if $x lt $y } }
my %opp = (Joy => 'Sadness', Trust => 'Disgust', Fear => 'Anger', Surprise => 'Anticipation');
is(Alchemy::distance($_, $opp{$_}), 4, "Plutchik: $_ opposes $opp{$_}") for sort keys %opp;

# ---- Plutchik's 24 dyads, each at the right distance
my %plutchik = (
    1 => [qw(Love Submission Awe Disapproval Remorse Contempt Aggressiveness Optimism)],
    2 => [qw(Hope Guilt Curiosity Despair Unbelief Envy Cynicism Pride)],
    3 => [qw(Delight Sentimentality Shame Outrage Pessimism Morbidness Dominance Anxiety)],
);
my %have;
for my $k (sort keys %Alchemy::FEELING) {
    my ($x, $y) = split /\+/, $k;
    push @{ $have{ Alchemy::distance($x, $y) } }, $Alchemy::FEELING{$k}{name};
    is($k, Alchemy::pair($x, $y), "key $k in wheel order");
}
is_deeply([sort @{ $have{$_} }], [sort @{ $plutchik{$_} }], "dyads at distance $_") for 1 .. 3;
is(scalar keys %Alchemy::FEELING, 24, '24 dyads');
for my $x (@W) { for my $y (@W) { next unless $x lt $y; my $d = Alchemy::distance($x, $y);
    next if $d == 0 || $d == 4;
    ok(Alchemy::feeling_of($x, $y), "a Feeling exists for $x+$y") } }

# ---- the 8x8 reaction matrix
for my $s (@W) { for my $m (@W) {
    my $r = Alchemy::reaction($s, $m); my $d = Alchemy::distance($s, $m);
    my $want = $d == 0 ? 'intensify' : $d == 4 ? 'catharsis' : 'feeling';
    is($r->{kind}, $want, "$s on a $m mood: $want");
    is($r->{gate}, $Alchemy::GATE{$d}, "$s/$m: right gate");
} }
is(Alchemy::reaction('Fear', 'Trust')->{status}, 'FEELING_SUBMISSION', 'Fear + Accepting = Submission');
is(Alchemy::reaction('Trust', 'Fear')->{status}, 'FEELING_SUBMISSION', 'Trust + Apprehensive = Submission');
is(Alchemy::reaction('Fear', 'Fear')->{status}, 'EMOTION_TERROR', 'Fear + Apprehensive = Terror');
is(Alchemy::reaction('Fear', 'Anger')->{status}, 'CATHARSIS', 'Fear + Annoyed = Catharsis');

# ---- SpellSuccess
my $ss = Alchemy::spell_success('Fear');
my @f = split /;(?=IF\()/, $ss;
like($f[0], qr/^IF\(not \(/, 'first functor: the no-reaction case (risk R1)');
like($f[0], qr/:ApplyStatus\(EMOTION_FEAR,100,1\)$/, 'the no-reaction case applies the peak');
is(scalar(() = $f[0] =~ /HasStatus\('MOOD_/g), 8, 'the no-reaction case checks all 8 moods');
like($ss, qr/IF\(HasStatus\('MOOD_ACCEPTING'\)\):ApplyStatus\(FEELING_SUBMISSION,100,2\)/, 'primary: no gate, 2 turns');
like($ss, qr/IF\(HasStatus\('MOOD_SERENE'\) and HasPassive\('Arcana_Passive_ComplexFeelings', context\.Source\)\):ApplyStatus\(FEELING_GUILT,100,2\)/, 'secondary: gated');
like($ss, qr/IF\(HasStatus\('MOOD_INTERESTED'\) and HasPassive\('Arcana_Passive_MixedFeelings', context\.Source\)\):ApplyStatus\(FEELING_ANXIETY,100,2\)/, 'tertiary: gated');
like($ss, qr/IF\(HasStatus\('MOOD_APPREHENSIVE'\) and HasPassive\('Arcana_Passive_Overwhelm', context\.Source\)\):ApplyStatus\(EMOTION_TERROR,100,1\)/, 'intense: gated, 1 turn');
like($ss, qr/IF\(HasStatus\('MOOD_ANNOYED'\) and not Ally\(\) and not Self\(\)\):DealDamage\(2d8,Psychic,Magical\)/, 'Catharsis harms a non-ally');
like($ss, qr/IF\(HasStatus\('MOOD_ANNOYED'\) and \(Ally\(\) or Self\(\)\)\):RegainHitPoints\(2d8\)/, 'Catharsis heals an ally');
like($ss, qr/ApplyStatus\(CATHARSIS,100,0\)$/, 'the CATHARSIS status (which clears the moods) comes last');
for my $s (@W) {
    my $x = Alchemy::spell_success($s);
    is(scalar(() = $x =~ /IF\(/g), 1 + 7 + 3, "$s: 1 base case + 7 reactions + 3 Catharsis functors");
}

# ---- targeting
like(Alchemy::target_conditions('Fear'), qr/not HasPassive\('ARCANA_IS_CARD', context\.Source\)/, 'exact card mark (check_cards)');
like(Alchemy::target_conditions('Fear'), qr/\(not Ally\(\) and not Self\(\)\) or HasStatus/, 'dark: a non-ally, or anyone with a mood');
like(Alchemy::target_conditions('Joy'), qr/\(Ally\(\) or Self\(\)\) or HasStatus/, 'bright: an ally, or anyone with a mood');

# ---- text
is(Alchemy::tag_terms('Has Advantage on Attack Rolls. Advantage again.'),
   'Has <LSTag Tooltip="Advantage">Advantage</LSTag> on <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag>. Advantage again.',
   'only the first mention becomes an LSTag');
is(Alchemy::tag_terms('Has Disadvantage.'), 'Has <LSTag Tooltip="Disadvantage">Disadvantage</LSTag>.', 'Disadvantage does not become Advantage');
unlike(Alchemy::tag_terms('Has Disadvantage and Advantage.'), qr/<LSTag[^>]*><LSTag/, 'no nested LSTag');

# ---- the whole patch
my $p = Alchemy::build_engine_patch();
my @entries = $p =~ /^new entry "([^"]+)"/mg;
my %defined = map { $_ => 1 } @entries;
is(scalar(grep { /^Target_Arcana_Card_Spell_Emotion/ } @entries), 8, '8 Weave Surges');
is(scalar(grep { /^MOOD_/ } @entries), 8, '8 moods');
is(scalar(grep { /^FEELING_/ && !/_TECH$|_DISAPPROVED$/ } @entries), 24, '24 feelings');
is(scalar(grep { /^EMOTION_/ } @entries), 16, '8 peaks + 8 intense');
ok($defined{$_}, "defined: $_") for qw(CATHARSIS FEELING_DISAPPROVED FEELING_REMORSE_TECH FEELING_MORBIDNESS_TECH HEARTWEAVER_DEBUG
    Shout_Arcana_Util_DEBUG_Heartweaver Arcana_Passive_EmotionalAlchemy Arcana_Passive_EmpathicSight Arcana_Passive_ComplexFeelings
    Arcana_Passive_Overwhelm Arcana_Passive_MixedFeelings Arcana_Passive_FeelingRemorse Arcana_Passive_FeelingMorbidness);
my %dup; $dup{$_}++ for @entries; is_deeply([grep { $dup{$_} > 1 } sort keys %dup], [], 'no duplicate entry');
# closure: every status/passive of ours that is cited exists
my %cited; $cited{$1}++ while $p =~ /(?:ApplyStatus\((?:SELF,)?|RemoveStatus\(|HasStatus\(')((?:EMOTION|MOOD|FEELING|CATHARSIS|HEARTWEAVER)\w*)/g;
$cited{$1}++ while $p =~ /(Arcana_Passive_(?:EmotionalAlchemy|EmpathicSight|ComplexFeelings|Overwhelm|MixedFeelings|Feeling\w+))/g;
ok($defined{$_}, "cited and defined: $_") for sort keys %cited;

# ---- status types: each status sits in the file of its type, `using` right after StatusType
my %file_of; my $cur = '';
for my $l (split /\n/, $p) { $cur = $1 if $l =~ /^\@file (\S+)/; $file_of{$1} = $cur if $l =~ /^new entry "([^"]+)"/ }
my %type_of; $type_of{$1} = $2 while $p =~ /^new entry "([^"]+)"\ntype "StatusData"\ndata "StatusType" "(\w+)"/mg;
is($file_of{$_}, "Status_$type_of{$_}", "$_ ($type_of{$_}) in Status_$type_of{$_}") for sort keys %type_of;
is($type_of{EMOTION_TERROR}, 'FEAR', 'Terror is FEAR: the creature flees');
is($type_of{$_}, 'INCAPACITATED', "$_ is INCAPACITATED") for qw(EMOTION_AMAZEMENT EMOTION_GRIEF FEELING_AWE);
like($p, qr/^new entry "EMOTION_TERROR"\ntype "StatusData"\ndata "StatusType" "FEAR"\nusing "FEARED"\n/m, 'Terror: using FEARED after StatusType');
like($p, qr/^new entry "EMOTION_AMAZEMENT"\ntype "StatusData"\ndata "StatusType" "INCAPACITATED"\nusing "STUNNED"\n/m, 'Amazement: using STUNNED');
like($p, qr/^new entry "FEELING_AWE"\ntype "StatusData"\ndata "StatusType" "INCAPACITATED"\nusing "HYPNOTIC_PATTERN"\n/m, 'Awe: using HYPNOTIC_PATTERN');
my ($terror) = $p =~ /(^new entry "EMOTION_TERROR".*?)\n\n/ms;
like($terror, qr/data "RemoveConditions" ""/, 'Terror clears the inherited per-turn save (1 turn only)');
unlike($terror, qr/data "StatusGroups"/, 'Terror inherits the Fleeing groups');
my ($amaze) = $p =~ /(^new entry "EMOTION_AMAZEMENT".*?)\n\n/ms;
like($amaze, qr/data "OnApplyFunctors" "RemoveStatus\(MOOD_DISTRACTED\);BreakConcentration\(\)"/, 'Amazement keeps STUNNED\'s BreakConcentration');
unlike($amaze, qr/data "Boosts"/, 'Amazement inherits STUNNED\'s boosts');

# ---- text rules
my @loca = $p =~ /^\@loca (\S+) (.*)$/mg;
my %lt = @loca;
my @refs = $p =~ /\{\{(\w+)\}\}/g;
ok($lt{$_}, "string exists: $_") for @refs;
is(scalar(keys %lt), scalar(@loca) / 2, 'unique loca keys');
for my $k (sort keys %lt) {
    my $t = $lt{$k};
    unlike($t, qr/\x{2014}|\x{2013}|\xE2\x80[\x93\x94]/, "$k: no dash");
    (my $bare = $t) =~ s/<LSTag[^>]*>//g;
    unlike($bare, qr/"/, "$k: no double quotes outside LSTag");
    unlike($t, qr/<LSTag[^>]*>[^<]*<LSTag/, "$k: no nested LSTag");
    unlike($t, qr/\{\{|\}\}/, "$k: no raw key");
}

# ---- review fixes (round 1)
# every Surge carries the same Wisdom save, bright or dark (spec 4.3: a save only when the target is a non-ally)
for my $e (@W) {
    my ($sp) = $p =~ /(^new entry "Target_Arcana_Card_Spell_Emotion$e"\n.*?)\n\n/ms;
    ok($sp, "$e: Surge entry found");
    like($sp, qr/^data "SpellRoll" "Ally\(\) or Self\(\) or not SavingThrow\(Ability\.Wisdom, SourceSpellDC\(\)\)"$/m, "$e: SpellRoll is the Wisdom save for non-allies");
    like($sp, qr/^data "SpellFail" "ApplyStatus\(SAVED_AGAINST_HOSTILE_SPELL,100,0\)"$/m, "$e: SpellFail");
    like($sp, qr/^data "TooltipAttackSave" "Wisdom"$/m, "$e: TooltipAttackSave");
    my ($flags) = $sp =~ /^data "SpellFlags" "([^"]*)"$/m;
    if ($Alchemy::EMO{$e}{side} eq 'I') { like($flags, qr/\bIsHarmful\b/, "$e (dark): IsHarmful") }
    else { unlike($flags, qr/IsHarmful/, "$e (bright): no IsHarmful") }
}
like($p, qr/^new entry "Target_Arcana_Card_Spell_EmotionJoy"\n(?:.*\n)*?data "SpellRoll" /m, 'Joy has a SpellRoll');
# damage types in DescriptionParams must be real ones
my @dparams = $p =~ /^data "DescriptionParams" "([^"]*)"$/mg;
ok(scalar(@dparams), 'there are DescriptionParams');
unlike($_, qr/,\s*Weapon\)/, "no bogus Weapon damage type: $_") for @dparams;
like($p, qr/DealDamage\(1d4, MainMeleeWeaponDamageType\)/, 'Aggressiveness uses MainMeleeWeaponDamageType');
# a status that inherits through `using` keeps the parent's TickType
for my $id (qw(FEELING_AWE EMOTION_TERROR EMOTION_AMAZEMENT)) {
    my ($se) = $p =~ /(^new entry "$id"\n.*?)\n\n/ms;
    unlike($se, qr/^data "TickType"/m, "$id: no TickType (inherits)");
}
my ($serene) = $p =~ /(^new entry "MOOD_SERENE"\n.*?)\n\n/ms;
like($serene, qr/^data "TickType" "EndTurn"$/m, 'a plain BOOST (MOOD_SERENE) keeps TickType EndTurn');

# ---- review fixes (round 3): StackIds. The 16 peaks and intense emotions share EMOTION (one emotion at a time), the moods
# share MOOD, each feeling stacks by its own id.
my %stack_of; my $cs = '';
for my $l (split /\n/, $p) {
    $cs = $1 if $l =~ /^new entry "([^"]+)"/;
    $stack_of{$cs} = $1 if $l =~ /^data "StackId" "([^"]*)"$/;
}
my @emo = ((map { 'EMOTION_' . uc $_ } @W), (map { 'EMOTION_' . uc $Alchemy::EMO{$_}{intense}{name} } @W));
is(scalar(@emo), 16, '8 peaks + 8 intense');
is($stack_of{$_}, 'EMOTION', "$_ stacks as EMOTION") for @emo;
is($stack_of{'MOOD_' . uc $_}, 'MOOD', 'MOOD_' . uc($_) . ' stacks as MOOD') for map { $Alchemy::EMO{$_}{mood}{name} } @W;
my @fe = map { 'FEELING_' . uc $Alchemy::FEELING{$_}{name} } sort keys %Alchemy::FEELING;
is(scalar(@fe), 24, '24 feelings');
is($stack_of{$_}, $_, "$_ has its own StackId") for @fe;
is_deeply([grep { $stack_of{$_} =~ /^(?:EMOTION|MOOD|FEELING)$/ } @fe], [], 'no feeling uses EMOTION, MOOD or FEELING');
is($stack_of{FEELING_AWE}, 'FEELING_AWE', 'Awe keeps its own StackId');
is($stack_of{EMOTION_TERROR}, 'EMOTION', 'Terror sets EMOTION, not the StackId of FEARED');

# ---- review fixes (round 4): removals() keeps the upcast variants of the current Surges (synthetic data, no game files)
{
    my $have = {
        Target_Arcana_Card_Spell_EmotionFear   => 'Spell_Target',
        Target_Arcana_Card_Spell_EmotionFear_4 => 'Spell_Target',
        Target_Arcana_Card_Spell_EmotionFury_3 => 'Spell_Target',
        Target_Arcana_Card_Spell_FeelingLove   => 'Spell_Target',
        MOOD_AFRAID                            => 'Status_BOOST',
        EMOTION_MOVED                          => 'Status_KNOCKED_DOWN',
        MOOD_SERENE                            => 'Status_BOOST',
    };
    my $new = {
        Target_Arcana_Card_Spell_EmotionFear => 'Spell_Target',
        EMOTION_MOVED                        => 'Status_BOOST',
        MOOD_SERENE                          => 'Status_BOOST',
    };
    my %rm = map { ("$_->[0]|$_->[1]" => 1) } Alchemy::removals($have, $new);
    ok(!$rm{'Spell_Target|Target_Arcana_Card_Spell_EmotionFear_4'}, 'removals: a variant of a current Surge (EmotionFear_4) stays');
    ok($rm{'Spell_Target|Target_Arcana_Card_Spell_EmotionFury_3'}, 'removals: a variant of an old spell (EmotionFury_3) goes');
    ok($rm{'Spell_Target|Target_Arcana_Card_Spell_FeelingLove'}, 'removals: an old Feeling spell goes');
    ok($rm{'Status_BOOST|MOOD_AFRAID'}, 'removals: an old status (MOOD_AFRAID) goes');
    ok($rm{'Status_KNOCKED_DOWN|EMOTION_MOVED'}, 'removals: a status that moved files goes from its old file');
    ok(!$rm{'Spell_Target|Target_Arcana_Card_Spell_EmotionFear'}, 'removals: a current Surge in the same file stays');
    ok(!$rm{'Status_BOOST|MOOD_SERENE'}, 'removals: a current status in the same file stays');
    is(scalar(keys %rm), 4, 'removals: exactly the 4 old entries');
    my %all = map { my $e = $_; map { (Alchemy::spell_id($e) . "_$_" => 'Spell_Target') } 2 .. 6 } @W;
    is_deeply([Alchemy::removals(\%all, {})], [], 'removals: none of the 40 current variants is ever removed');
}
done_testing();
```

- [ ] **Step 2: run them and watch them fail**

Run: `cd "$T" && perl t/gen_emotion_alchemy.t`
Expected: FAIL — `Can't locate …/gen_emotion_alchemy.pl` (the generator does not exist yet).

- [ ] **Step 3: write the generator**

Create `$T/gen_emotion_alchemy.pl` with:

```perl
#!/usr/bin/perl
# Heartweaver: generates the Emotional Alchemy engine (spec Design/Rework/specs/2026-10-06-heartweaver-design.md).
#
# One table -- Plutchik's wheel and its states -- becomes two patches for stats_add.pl:
#   ../heartweaver/10_engine.patch          8 Weave Surges, the statuses, the passives, the DEBUG util and the text
#   ../heartweaver/20_upcast_targets.patch  +1 target per level on the _N variants (only after gen_upcast_variants)
#
#   perl gen_emotion_alchemy.pl               # (re)writes the patches; only READS the game
#   perl gen_emotion_alchemy.pl --out DIR     # writes somewhere else
#   perl t/gen_emotion_alchemy.t              # tests (`prove` does not run on this Perl)
#
# The patches are generated: never edit them by hand. To change a number or a line of text, change the table
# here and run again. Everything is Stats, so it works in the console edition (no Script Extender).
package Alchemy;
use strict; use warnings;
use File::Basename qw(dirname);
use File::Path qw(make_path);

our $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
our $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';

# ---------------------------------------------------------------- the wheel
# Plutchik's clockwise order. The distance between two emotions decides the reaction (spec §4.2).
our @WHEEL = qw(Joy Trust Fear Surprise Sadness Disgust Anger Anticipation);
our %IDX; @IDX{@WHEEL} = 0 .. $#WHEEL;

sub distance { my ($x, $y) = @_; my $d = abs($IDX{$x} - $IDX{$y}); $d > 4 ? 8 - $d : $d }
sub pair     { my ($x, $y) = @_; join '+', sort { $IDX{$a} <=> $IDX{$b} } $x, $y }

# distance => passive that unlocks the reaction (undef = always unlocked)
our %GATE = (0 => 'Arcana_Passive_Overwhelm', 1 => undef, 2 => 'Arcana_Passive_ComplexFeelings',
             3 => 'Arcana_Passive_MixedFeelings', 4 => undef);
our $FEELING_TURNS  = 2;
our $MOOD_TURNS     = 5;
our $CATHARSIS_DICE = '2d8';

# ---------------------------------------------------------------- the states
# side: A = goes on an ally when the target has no mood (bright arc); I = on a non-ally (dark arc).
# peak/mood/intense: boosts + the mechanics sentence (the engine puts the image sentence first).
# type/using: status type and vanilla parent when it is not a plain BOOST -- the type decides the FILE
#   (Status_<TYPE>.txt) and the engine behaviour (FEAR flees, INCAPACITATED can't act). With `using`, leave
#   boosts undef to inherit the parent's.
# extra: more fields for the entry. params: DescriptionParams. onapply: added to OnApplyFunctors.
our %EMO = (
    Joy => { side => 'A', word => 'joy', icon => 'Spell_Enchantment_Heroism',
        spell => "Pluck the bright thread of joy in an ally's Weave, so that every blow and every effort lands truer.",
        peak    => { boosts => 'Advantage(AttackRoll);Advantage(AllAbilities)',
                     text => 'Has Advantage on Attack Rolls and Ability Checks.' },
        mood    => { name => 'Serene', image => 'Calmed', boosts => 'Advantage(SavingThrow,Wisdom)',
                     text => 'Has Advantage on Wisdom Saving Throws.' },
        intense => { name => 'Ecstasy', boosts => 'ActionResource(ActionPoint,1,0)',
                     text => 'Has an additional action.' } },
    Trust => { side => 'A', word => 'trust', icon => 'Spell_Abjuration_ShieldOfFaith',
        spell => "Steady an ally with a thread of trust drawn from the Weave, letting harm glance off their resolve.",
        peak    => { boosts => 'AC(2);Advantage(AllSavingThrows)',
                     text => 'Armour Class increased by 2. Has Advantage on Saving Throws.' },
        mood    => { name => 'Accepting', image => 'Settled', boosts => 'AC(1)',
                     text => 'Armour Class increased by 1.' },
        intense => { name => 'Admiration', boosts => 'Resistance(All, Resistant);StatusImmunity(SG_Charmed);StatusImmunity(SG_Frightened)',
                     text => 'Resistant to all damage. Cannot be Charmed or Frightened.' } },
    Fear => { side => 'I', word => 'fear', icon => 'Spell_Illusion_PhantasmalKiller',
        spell => "Wrap a creature in a cold thread of fear, rooting it in place and shaking its every move.",
        peak    => { boosts => 'Disadvantage(AllAbilities);Disadvantage(AttackRoll);ActionResourceBlock(Movement)',
                     text => "Can't move. Has Disadvantage on Ability Checks and Attack Rolls." },
        mood    => { name => 'Apprehensive', image => 'Shaken', boosts => 'RollBonus(SavingThrow,-1d4,Wisdom)',
                     text => 'Subtracts 1d4 from Wisdom Saving Throws.' },
        # FEAR type (the Fear spell's FEARED): the creature flees. Its per-turn save is switched off -- 1 turn.
        intense => { name => 'Terror', type => 'FEAR', using => 'FEARED',
                     text => 'Flees in terror. Has Disadvantage on Ability Checks and Attack Rolls.',
                     extra => { RemoveConditions => '', RemoveEvents => '', TooltipSave => '' } } },
    Surprise => { side => 'I', word => 'surprise', icon => 'Spell_Enchantment_Enthrall',
        spell => "Snap a thread of surprise before a creature's eyes, leaving it too startled to react.",
        peak    => { boosts => 'ActionResourceBlock(ReactionActionPoint);ActionResourceBlock(BonusActionPoint);Disadvantage(SavingThrow,Dexterity)',
                     text => "Can't take reactions or bonus actions. Has Disadvantage on Dexterity Saving Throws." },
        mood    => { name => 'Distracted', image => 'Still reeling from', boosts => 'Disadvantage(Concentration)',
                     text => 'Has Disadvantage on Saving Throws to maintain Concentration.' },
        intense => { name => 'Amazement', type => 'INCAPACITATED', using => 'STUNNED', onapply => 'BreakConcentration()',
                     text => "Stunned: can't move or take actions or reactions. Automatically fails Strength and Dexterity Saving Throws, and attacks against it have Advantage." } },
    Sadness => { side => 'I', word => 'sorrow', icon => 'Spell_Necromancy_RayOfInfeeblement',
        spell => "Weigh a creature down with a grey thread of sorrow, slowing both its steps and its will.",
        peak    => { boosts => 'ActionResourceMultiplier(Movement,50,0)',
                     text => 'Movement speed is halved, and it can only take either an action or a bonus action.',
                     extra => { Passives => 'Slow_ActionPoint' } },
        mood    => { name => 'Pensive', image => 'Weighed down by', boosts => 'ActionResource(Movement,-3,0)',
                     text => 'Movement speed reduced by [1].', params => 'Distance(3)' },
        intense => { name => 'Grief', type => 'INCAPACITATED', boosts => 'ActionResourceBlock(Movement)', onapply => 'BreakConcentration()',
                     text => "Incapacitated: can't move or take actions, bonus actions or reactions.",
                     extra => { StatusGroups => 'SG_Incapacitated;SG_Condition' } } },
    Disgust => { side => 'I', word => 'disgust', icon => 'Spell_Conjuration_StinkingCloud',
        spell => "Twist a creature's Weave into revulsion, leaving it retching and unable to act.",
        peak    => { boosts => 'ActionResourceBlock(ActionPoint);Disadvantage(SavingThrow,Constitution)',
                     text => "Can't take actions. Has Disadvantage on Constitution Saving Throws." },
        mood    => { name => 'Bored', image => 'Dulled', boosts => 'ActionResourceBlock(ReactionActionPoint)',
                     text => "Can't take reactions." },
        intense => { name => 'Loathing', boosts => 'ActionResourceBlock(ActionPoint);ActionResourceBlock(BonusActionPoint);Disadvantage(AttackRoll);Disadvantage(AllAbilities)',
                     text => "Can't take actions or bonus actions. Has Disadvantage on Attack Rolls and Ability Checks." } },
    Anger => { side => 'I', word => 'fury', icon => 'Spell_Enchantment_CrownOfMadness',
        spell => "Set a red thread of fury alight in a creature's mind, driving it to strike whoever stands nearest.",
        peak    => { boosts => 'CannotHarmCauseEntity(CannotHarmMadness);ActionResourceBlock(ReactionActionPoint);AiArchetypeOverride(madness,99);Tag(AI_UNPREFERRED_TARGET);DetectDisturbancesBlock(true)',
                     text => 'Will attack the nearest creature, other than the spellcaster.',
                     extra => { StatusPropertyFlags => 'InitiateCombat;BringIntoCombat;LoseControl', StatusGroups => 'SG_Condition;SG_Mad' } },
        mood    => { name => 'Annoyed', image => 'Prickling with', boosts => 'AC(-1)',
                     text => 'Armour Class reduced by 1.' },
        intense => { name => 'Rage', boosts => 'CannotHarmCauseEntity(CannotHarmMadness);ActionResourceBlock(ReactionActionPoint);AiArchetypeOverride(madness,99);Tag(AI_UNPREFERRED_TARGET);DetectDisturbancesBlock(true);Advantage(AttackRoll);Advantage(AttackTarget)',
                     text => 'Will attack the nearest creature, other than the spellcaster, with Advantage. Attacks against it also have Advantage.',
                     extra => { StatusPropertyFlags => 'InitiateCombat;BringIntoCombat;LoseControl', StatusGroups => 'SG_Condition;SG_Mad' } } },
    Anticipation => { side => 'A', word => 'anticipation', icon => 'Spell_Transmutation_Longstrider',
        spell => "Pull a taut thread of anticipation through an ally's Weave, leaving them poised to move and react.",
        peak    => { boosts => 'ActionResource(ReactionActionPoint,1,0);ActionResourceMultiplier(Movement,200,0)',
                     text => 'Has an additional reaction, and movement speed is doubled.' },
        mood    => { name => 'Interested', image => 'Kept alert by', boosts => 'ActionResource(Movement,3,0)',
                     text => 'Movement speed increased by [1].', params => 'Distance(3)' },
        intense => { name => 'Vigilance', boosts => 'ActionResource(ReactionActionPoint,2,0);Advantage(SavingThrow,Dexterity)',
                     text => 'Has 2 additional reactions and Advantage on Dexterity Saving Throws.' } },
);

# The 24 dyads. Key = pair() (wheel order). kind: A = helps whoever carries it, I = hinders.
our %FEELING = (
    # primary (distance 1)
    'Joy+Trust'          => { name => 'Love', kind => 'A', icon => 'Spell_Abjuration_WardingBond',
        boosts => 'AC(1);RollBonus(SavingThrow,1);Resistance(All, Resistant);RedirectDamage(1)',
        text => 'Armour Class and Saving Throws increased by 1, and Resistant to all damage. The spellcaster takes the same damage.',
        extra => { RemoveEvents => 'OnSourceDeath' } },
    'Trust+Fear'         => { name => 'Submission', kind => 'I', icon => 'Spell_Enchantment_DominatePerson',
        boosts => 'CannotHarmCauseEntity(CannotHarmCharmer)',
        text => "Knocked Prone and can't harm the spellcaster.", onapply => 'ApplyStatus(PRONE,100,1)' },
    # INCAPACITATED type (Hypnotic Pattern): can't act until it takes damage.
    'Fear+Surprise'      => { name => 'Awe', kind => 'I', icon => 'Spell_Illusion_HypnoticPattern',
        type => 'INCAPACITATED', using => 'HYPNOTIC_PATTERN', onapply => 'BreakConcentration()',
        text => "Incapacitated: can't move or take actions, bonus actions or reactions. Taking damage ends the effect." },
    'Surprise+Sadness'   => { name => 'Disapproval', kind => 'I', icon => 'Spell_Enchantment_Bane',
        text => 'Its allies within [1] have Disadvantage on Attack Rolls.', params => 'Distance(3)',
        extra => { AuraRadius => '3', AuraStatuses => 'TARGET:IF(Ally() and not Self()):ApplyStatus(FEELING_DISAPPROVED)' } },
    'Sadness+Disgust'    => { name => 'Remorse', kind => 'I', icon => 'Spell_Illusion_PhantasmalKiller',
        text => 'The first time it deals damage each turn, it takes [1].', params => 'DealDamage(1d6,Psychic)',
        extra => { Passives => 'Arcana_Passive_FeelingRemorse' } },
    'Disgust+Anger'      => { name => 'Contempt', kind => 'I', icon => 'Spell_Conjuration_StinkingCloud',
        boosts => 'Resistance(Psychic, Vulnerable)', text => 'Vulnerable to Psychic damage.' },
    'Anger+Anticipation' => { name => 'Aggressiveness', kind => 'A', icon => 'Action_Barbarian_Rage',
        boosts => 'CharacterWeaponDamage(1d4);ActionResource(ReactionActionPoint,1,0)',
        text => 'Weapon attacks deal an additional [1]. Has an additional reaction.', params => 'DealDamage(1d4, MainMeleeWeaponDamageType)' },
    'Joy+Anticipation'   => { name => 'Optimism', kind => 'A', icon => 'Spell_Enchantment_Heroism',
        boosts => 'StatusImmunity(SG_Frightened)', text => 'Cannot be Frightened. Gains temporary hit points each turn.',
        onapply => 'ApplyStatus(HEROISM_TEMP_HP,100,1)', extra => { TickFunctors => 'ApplyStatus(HEROISM_TEMP_HP,100,1)' } },
    # secondary (distance 2)
    'Trust+Anticipation' => { name => 'Hope', kind => 'A', icon => 'Spell_Enchantment_Bless',
        boosts => 'RollBonus(Attack,1d4);RollBonus(SavingThrow,1d4);RollBonus(DeathSavingThrow,1d4)',
        text => 'Adds 1d4 to Attack Rolls and Saving Throws.' },
    'Joy+Fear'           => { name => 'Guilt', kind => 'I', icon => 'Spell_Illusion_PhantasmalKiller',
        boosts => 'ActionResourceBlock(BonusActionPoint);Disadvantage(SavingThrow,Wisdom)',
        text => "Can't take bonus actions. Has Disadvantage on Wisdom Saving Throws." },
    'Trust+Surprise'     => { name => 'Curiosity', kind => 'A', icon => 'Spell_Divination_SeeInvisibility',
        boosts => 'Advantage(AllAbilities);ActionResource(Movement,3,0)',
        text => 'Has Advantage on Ability Checks, movement speed increased by [1], and can see Invisible creatures.', params => 'Distance(3)',
        onapply => 'ApplyStatus(SEE_INVISIBILITY,100,2)' },
    'Fear+Sadness'       => { name => 'Despair', kind => 'I', icon => 'Spell_Enchantment_Bane',
        boosts => 'RollBonus(Attack,-1d4);RollBonus(SavingThrow,-1d4);RollBonus(DeathSavingThrow,-1d4)',
        text => 'Subtracts 1d4 from Attack Rolls and Saving Throws.' },
    'Surprise+Disgust'   => { name => 'Unbelief', kind => 'I', icon => 'Spell_Abjuration_Counterspell',
        boosts => 'BlockSpellCast()', text => "Can't cast spells." },
    'Sadness+Anger'      => { name => 'Envy', kind => 'I', icon => 'Spell_Enchantment_Confusion',
        boosts => 'CannotHarmCauseEntity(CannotHarmMadness);ActionResourceBlock(ReactionActionPoint);AiArchetypeOverride(madness,99);Tag(AI_UNPREFERRED_TARGET);DetectDisturbancesBlock(true)',
        text => 'Will attack the nearest creature, other than the spellcaster.',
        extra => { StatusPropertyFlags => 'InitiateCombat;BringIntoCombat;LoseControl', StatusGroups => 'SG_Condition;SG_Mad' } },
    'Disgust+Anticipation' => { name => 'Cynicism', kind => 'I', icon => 'Spell_Conjuration_StinkingCloud',
        boosts => 'BlockRegainHP()', text => "Can't regain hit points." },
    'Joy+Anger'          => { name => 'Pride', kind => 'A', icon => 'Action_Barbarian_Rage',
        boosts => 'ReduceCriticalAttackThreshold(1)', text => 'Scores a Critical Hit on a roll of 19 or 20.' },
    # tertiary (distance 3)
    'Joy+Surprise'       => { name => 'Delight', kind => 'A', icon => 'Spell_Enchantment_Heroism',
        text => 'Regains [1] at the end of each turn.', params => 'RegainHitPoints(1d6)',
        extra => { TickFunctors => 'RegainHitPoints(1d6)' } },
    'Trust+Sadness'      => { name => 'Sentimentality', kind => 'A', icon => 'Spell_Enchantment_CalmEmotions',
        boosts => 'Resistance(Psychic, Resistant);StatusImmunity(SG_Charmed)', text => 'Resistant to Psychic damage. Cannot be Charmed.' },
    'Fear+Disgust'       => { name => 'Shame', kind => 'I', icon => 'Spell_Illusion_PhantasmalKiller',
        boosts => 'ActionResourceBlock(ReactionActionPoint);Disadvantage(AttackRoll)',
        text => "Can't take reactions. Has Disadvantage on Attack Rolls." },
    'Surprise+Anger'     => { name => 'Outrage', kind => 'I', icon => 'Spell_Enchantment_CompelledDuel',
        boosts => 'Disadvantage(AttackRoll);Advantage(AttackTarget)',
        text => 'Has Disadvantage on Attack Rolls, and attacks against it have Advantage.' },
    'Sadness+Anticipation' => { name => 'Pessimism', kind => 'I', icon => 'Spell_Necromancy_RayOfInfeeblement',
        boosts => 'RollBonus(SavingThrow,-1d6);RollBonus(SkillCheck,-1d6);RollBonus(RawAbility,-1d6)',
        text => 'Subtracts 1d6 from Saving Throws and Ability Checks.' },
    'Joy+Disgust'        => { name => 'Morbidness', kind => 'A', icon => 'Spell_Conjuration_StinkingCloud',
        text => 'The first time it deals damage with a weapon each turn, it regains [1].', params => 'RegainHitPoints(1d6)',
        extra => { Passives => 'Arcana_Passive_FeelingMorbidness' } },
    'Trust+Anger'        => { name => 'Dominance', kind => 'A', icon => 'Spell_Enchantment_DominatePerson',
        boosts => 'Advantage(Skill,Athletics);Advantage(Skill,Intimidation);AC(1)',
        text => 'Has Advantage on Athletics and Intimidation checks. Armour Class increased by 1.' },
    'Fear+Anticipation'  => { name => 'Anxiety', kind => 'I', icon => 'Spell_Enchantment_Confusion',
        boosts => 'ActionResourceBlock(ReactionActionPoint);Disadvantage(Concentration)',
        text => "Loses Concentration. Can't take reactions and has Disadvantage on Saving Throws to maintain Concentration.",
        onapply => 'BreakConcentration()' },
);

# ---------------------------------------------------------------- names
sub peak_id    { 'EMOTION_' . uc $_[0] }
sub mood_id    { 'MOOD_' . uc $EMO{$_[0]}{mood}{name} }
sub intense_id { 'EMOTION_' . uc $EMO{$_[0]}{intense}{name} }
sub feeling_of { $FEELING{ pair(@_) } }
sub feeling_id { 'FEELING_' . uc feeling_of(@_)->{name} }
sub spell_id   { 'Target_Arcana_Card_Spell_Emotion' . $_[0] }
sub key        { my $k = uc join '_', @_; $k =~ s/[^A-Z0-9_]/_/g; "HW_$k" }   # loca key

# The reaction of Surge `$s` on a creature carrying the mood of emotion `$m`.
sub reaction {
    my ($s, $m) = @_;
    my $d = distance($s, $m);
    my %r = (distance => $d, gate => $GATE{$d}, mood => mood_id($m));
    if    ($d == 0) { $r{kind} = 'intensify'; $r{status} = intense_id($s) }
    elsif ($d == 4) { $r{kind} = 'catharsis'; $r{status} = 'CATHARSIS' }
    else            { $r{kind} = 'feeling';   $r{status} = feeling_id($s, $m) }
    \%r;
}

sub cond_of { my $r = shift; my $c = "HasStatus('$r->{mood}')";
    $r->{gate} ? "$c and HasPassive('$r->{gate}', context.Source)" : $c }

# SpellSuccess: the "no reaction" case comes FIRST, before any functor spends a mood (risk R1).
sub spell_success {
    my $s = shift;
    my @r = map { reaction($s, $_) } @WHEEL;
    my @f = ('IF(' . join(' and ', map { 'not (' . cond_of($_) . ')' } @r) . '):ApplyStatus(' . peak_id($s) . ',100,1)');
    for my $r (grep { $_->{kind} ne 'catharsis' } @r) {
        my $turns = $r->{kind} eq 'intensify' ? 1 : $FEELING_TURNS;
        push @f, 'IF(' . cond_of($r) . "):ApplyStatus($r->{status},100,$turns)";
    }
    for my $r (grep { $_->{kind} eq 'catharsis' } @r) {
        my $c = cond_of($r);
        push @f, "IF($c and not Ally() and not Self()):DealDamage($CATHARSIS_DICE,Psychic,Magical)",
                 "IF($c and (Ally() or Self())):RegainHitPoints($CATHARSIS_DICE)",
                 "IF($c):ApplyStatus(CATHARSIS,100,0)";
    }
    join ';', @f;
}

sub any_mood { join ' or ', map { "HasStatus('" . mood_id($_) . "')" } @WHEEL }

sub target_conditions {
    my $s = shift;
    my $base = "Character() and not Dead() and IntelligenceGreaterThan(4) and not HasPassive('ARCANA_IS_CARD', context.Source)";
    my $side = $EMO{$s}{side} eq 'A' ? '(Ally() or Self())' : '(not Ally() and not Self())';
    "$base and ($side or " . any_mood() . ')';
}

# ---------------------------------------------------------------- text
# The first mention of each rules term becomes an LSTag (style memory: only the first).
our @TAGS = (
    [qr/\bAttack Rolls?\b/,     'Tooltip="AttackRoll"'],
    [qr/\bAbility Checks?\b/,   'Tooltip="AbilityCheck"'],
    [qr/\bSaving Throws?\b/,    'Tooltip="SavingThrow"'],
    [qr/\bArmour Class\b/,      'Tooltip="ArmourClass"'],
    [qr/\b[Mm]ovement speed\b/, 'Tooltip="MovementSpeed"'],
    [qr/\bDisadvantage\b/,      'Tooltip="Disadvantage"'],
    [qr/\bAdvantage\b/,         'Tooltip="Advantage"'],
    [qr/\bResistant\b/,         'Tooltip="Resistant"'],
    [qr/\bVulnerable\b/,        'Tooltip="Vulnerable"'],
    [qr/\bCritical Hit\b/,      'Tooltip="CriticalHit"'],
    [qr/\bProne\b/,             'Type="Status" Tooltip="PRONE"'],
    [qr/\bFrightened\b/,        'Type="Status" Tooltip="FRIGHTENED"'],
    [qr/\bCharmed\b/,           'Type="Status" Tooltip="CHARMED"'],
    [qr/\bInvisible\b/,         'Type="Status" Tooltip="INVISIBLE"'],
    [qr/\bStunned\b/,           'Type="Status" Tooltip="STUNNED"'],
);
sub tag_terms {
    my $t = shift; my @hold;
    for my $tg (@TAGS) {
        my ($re, $attr) = @$tg;
        # tags already inserted are parked as \x01N\x01, so nothing is ever tagged twice or nested
        $t =~ s/$re/push @hold, "<LSTag $attr>$&<\/LSTag>"; "\x01" . $#hold . "\x01"/e;
    }
    $t =~ s/\x01(\d+)\x01/$hold[$1]/g;
    $t;
}
sub st_tag { my ($id, $text) = @_; qq{<LSTag Type="Status" Tooltip="$id">$text</LSTag>} }

# ---------------------------------------------------------------- entries
sub nz { my $v = shift; defined $v && length $v ? $v : undef }   # '' -> undef (field left out)

# A field set to '' is written as "" on purpose: it clears the value inherited through `using`.
sub entry {
    my ($name, $type, @kv) = @_;
    my $s = qq{new entry "$name"\ntype "$type"\n};
    while (my ($k, $v) = splice @kv, 0, 2) {
        next unless defined $v;
        $s .= $k eq 'using' ? qq{using "$v"\n} : qq{data "$k" "$v"\n};
    }
    "$s\n";
}

my @LOCA;   # [key, text]
sub loca { my ($k, $t) = @_; push @LOCA, [$k, $t]; "{{$k}}" }

# Returns [file, text]. $kind A/I sets combat flags and groups (unless inherited through `using`);
# $o = { type, using, boosts, extra, params, onapply, onremove, stack, tick }
# Stacking: all 8 peaks and all 8 intense emotions share StackId EMOTION (a creature carries one emotion at a time, so only
# one mood comes out), `using` statuses included (set explicitly so a parent's StackId is not inherited). The 8 moods
# share StackId MOOD (one mood at a time). Every feeling has its own StackId (its own id), so feelings combine.
# Helpers use their own ids.
sub status_entry {
    my ($id, $name, $desc, $icon, $kind, $o) = @_;
    my %x = %{ $o->{extra} || {} };
    my $type = $o->{type} // 'BOOST';
    my $inherit = defined $o->{using};
    my $onapply = join ';', grep { defined && length } $o->{onapply}, delete $x{OnApplyFunctors};
    my @f = (StatusType => $type, using => $o->{using},
        DisplayName => loca(key($id, 'NAME'), $name), Description => loca(key($id, 'DESC'), $desc),
        DescriptionParams => delete $x{DescriptionParams} // $o->{params}, Icon => $icon,
        StackId => $o->{stack}, TickType => $o->{tick} // ($inherit ? undef : 'EndTurn'), Boosts => nz($o->{boosts}),
        Passives => delete $x{Passives},
        StatusPropertyFlags => delete $x{StatusPropertyFlags} // ($kind eq 'I' && !$inherit ? 'InitiateCombat;BringIntoCombat' : undef),
        StatusGroups => delete $x{StatusGroups} // ($kind eq 'I' && !$inherit ? 'SG_Condition' : undef),
        map({ $_ => $x{$_} } sort keys %x),
        OnApplyFunctors => nz($onapply), OnRemoveFunctors => $o->{onremove});
    ["Status_$type", entry($id, 'StatusData', @f)];
}

sub mood_image { my $e = shift; my $img = $EMO{$e}{mood}{image};
    # some images already end in their preposition
    $img =~ /\b(by|from|with)$/ ? "$img the last echo of $EMO{$e}{word} in the Weave." : "$img by the last echo of $EMO{$e}{word} in the Weave." }

sub build_statuses {
    my @out;
    for my $e (@WHEEL) {
        my $E = $EMO{$e};
        my $side = $E->{side};
        my $fade = 'IF(RemoveCause(StatusRemoveCause.TimeOut)):ApplyStatus(' . mood_id($e) . ",100,$MOOD_TURNS)";
        push @out, status_entry(peak_id($e), "Emotion: $e",
            tag_terms("Gripped by a thread of $E->{word} in the Weave.<br><br>$E->{peak}{text}"),
            $E->{icon}, $side, { %{ $E->{peak} }, stack => 'EMOTION', onremove => $fade });
        push @out, status_entry(mood_id($e), "Mood: $E->{mood}{name}",
            tag_terms(mood_image($e) . "<br><br>$E->{mood}{text}"),
            $E->{icon}, 'mood', { %{ $E->{mood} }, stack => 'MOOD' });
        my $I = $E->{intense};
        push @out, status_entry(intense_id($e), "Emotion: $I->{name}",
            tag_terms(ucfirst($E->{word}) . " pulled so tight in the Weave that it overwhelms.<br><br>$I->{text}"),
            $E->{icon}, $side, { %$I, stack => 'EMOTION', onremove => $fade,
            onapply => join(';', grep { defined } 'RemoveStatus(' . mood_id($e) . ')', $I->{onapply}) });
    }
    for my $k (sort { $FEELING{$a}{name} cmp $FEELING{$b}{name} } keys %FEELING) {
        my $F = $FEELING{$k}; my ($x, $y) = split /\+/, $k;
        my $consume = join ';', map { 'RemoveStatus(' . mood_id($_) . ')' } $x, $y;
        push @out, status_entry('FEELING_' . uc $F->{name}, "Feeling: $F->{name}",
            tag_terms("Threads of $EMO{$x}{word} and $EMO{$y}{word}, braided into one.<br><br>$F->{text}"),
            $F->{icon}, $F->{kind}, { %$F, stack => 'FEELING_' . uc $F->{name},
            onapply => join(';', grep { defined } $consume, $F->{onapply}) });
    }
    # helpers
    push @out, status_entry('FEELING_DISAPPROVED', 'Disapproved',
        tag_terms('Weighed down by the disapproval of an ally.<br><br>Has Disadvantage on Attack Rolls.'),
        'Spell_Enchantment_Bane', 'I', { boosts => 'Disadvantage(AttackRoll)', stack => 'FEELING_DISAPPROVED' });
    push @out, hidden_status('FEELING_REMORSE_TECH', 'Remorse', 'OnApplyFunctors', 'DealDamage(1d6,Psychic,Magical)');
    push @out, hidden_status('FEELING_MORBIDNESS_TECH', 'Morbidness', 'OnApplyFunctors', 'RegainHitPoints(1d6)');
    push @out, status_entry('CATHARSIS', 'Catharsis',
        'Opposing threads of the Weave snapped at once, releasing everything they held.',
        'Spell_Enchantment_CalmEmotions', 'mood', { stack => 'CATHARSIS',
        onapply => join(';', map { 'RemoveStatus(' . mood_id($_) . ')' } @WHEEL) });
    @out;
}

sub hidden_status {
    my ($id, $name, $field, $functors) = @_;
    ['Status_BOOST', entry($id, 'StatusData', StatusType => 'BOOST', DisplayName => loca(key($id, 'NAME'), $name),
        StackId => $id, StatusPropertyFlags => 'DisableOverhead;DisableCombatlog;DisablePortraitIndicator', $field => $functors)];
}

sub build_passives {
    my $love = st_tag('FEELING_LOVE', 'Love'); my $catharsis = st_tag('CATHARSIS', 'Catharsis');
    my $out = '';
    $out .= passive('Arcana_Passive_EmotionalAlchemy', 'Emotional Alchemy',
        "When your Weave Surge touches a creature that already carries a mood, the threads react instead of surging, and the mood is spent.<br><br>Neighbouring emotions braid into a feeling, such as $love, that lasts $FEELING_TURNS turns.<br><br>Opposing emotions snap into $catharsis: an enemy takes [1] and an ally regains [2].",
        'Spell_Enchantment_CalmEmotions', DescriptionParams => "DealDamage($CATHARSIS_DICE,Psychic);RegainHitPoints($CATHARSIS_DICE)");
    $out .= passive('Arcana_Passive_EmpathicSight', 'Empathic Sight',
        tag_terms('You read the threads of feeling in others. You have Advantage on Insight checks.'),
        'Spell_Divination_SeeInvisibility', Boosts => 'Advantage(Skill,Insight)');
    $out .= passive('Arcana_Passive_ComplexFeelings', 'Complex Feelings',
        'Emotions two steps apart on the wheel now braid into complex feelings, such as ' . st_tag('FEELING_HOPE', 'Hope') . ' or ' . st_tag('FEELING_DESPAIR', 'Despair') . '.',
        'Spell_Enchantment_Bless');
    $out .= passive('Arcana_Passive_Overwhelm', 'Overwhelm',
        'A Weave Surge on a creature whose mood echoes the same emotion pulls the thread tight into its overwhelming form, such as ' . st_tag('EMOTION_ECSTASY', 'Ecstasy') . ' or ' . st_tag('EMOTION_TERROR', 'Terror') . '.',
        'Spell_Illusion_PhantasmalKiller');
    $out .= passive('Arcana_Passive_MixedFeelings', 'Mixed Feelings',
        'Emotions three steps apart on the wheel now braid into mixed feelings, such as ' . st_tag('FEELING_DELIGHT', 'Delight') . ' or ' . st_tag('FEELING_SHAME', 'Shame') . '.',
        'Spell_Enchantment_Confusion');
    # Hidden passives that Remorse and Morbidness grant. The 1-turn technical status is the once-per-turn lock
    # and also stops the loop of the creature's own damage triggering the passive again.
    for my $p (['Remorse', 'FEELING_REMORSE_TECH', ''], ['Morbidness', 'FEELING_MORBIDNESS_TECH', 'IsWeaponAttack() and ']) {
        my ($n, $tech, $cond) = @$p;
        $out .= entry("Arcana_Passive_Feeling$n", 'PassiveData', DisplayName => loca(key("Arcana_Passive_Feeling$n", 'NAME'), $n),
            Properties => 'IsHidden', StatsFunctorContext => 'OnDamage',
            Conditions => "${cond}not HasStatus('$tech', context.Source)",
            StatsFunctors => "ApplyStatus(SELF,$tech,100,1)");
    }
    $out;
}

sub passive {
    my ($id, $name, $desc, $icon, %x) = @_;
    entry($id, 'PassiveData', DisplayName => loca(key($id, 'NAME'), $name), Description => loca(key($id, 'DESC'), $desc),
        DescriptionParams => $x{DescriptionParams}, Icon => $icon, Boosts => $x{Boosts});
}

# Animation, sounds and effects: Crown of Madness (what Fury already used), the same on all 8.
our @CAST = (
    PrepareSound => 'Spell_Prepare_Control_Gen_L1to3_01', PrepareLoopSound => 'Spell_Prepare_Control_Gen_L1to3_01_Loop',
    CastSound => 'Spell_Cast_Control_CrownOfMadness_L1to3', TargetSound => 'Spell_Impact_Control_CrownOfMadness_L1to3',
    VocalComponentSound => 'Vocal_Component_Confuse',
    SpellAnimation => '554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;0149cfd3-d80f-4ce8-8cf7-234e0864ba46,,;1c58959b-8cb1-491d-89b7-2a7d0a593215,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,',
    PrepareEffect => '2fa6b127-6f8a-4150-8be6-6f62b7a85911', CastEffect => '4ca6a918-a46b-4269-b11b-d98fb6694677',
    TargetEffect => '4b5dc428-d623-4203-a7f0-a86c47bf9aa8',
);

sub build_spells {
    my $out = '';
    my $alchemy = qq{<LSTag Type="Passive" Tooltip="Arcana_Passive_EmotionalAlchemy">Emotional Alchemy</LSTag>};
    for my $e (@WHEEL) {
        my $E = $EMO{$e}; my $dark = $E->{side} eq 'I';
        my $extra = 'When the surge fades, it leaves the target ' . st_tag(mood_id($e), $E->{mood}{name})
                  . ".<br><br>If the target already carries a mood, the threads react instead - see $alchemy.";
        $out .= entry(spell_id($e), 'SpellData',
            SpellType => 'Target', Level => 1, SpellSchool => 'Enchantment', TargetRadius => 18, AmountOfTargets => 1,
            SpellRoll => 'Ally() or Self() or not SavingThrow(Ability.Wisdom, SourceSpellDC())',
            SpellSuccess => spell_success($e),
            SpellFail => 'ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL,100,0)',
            TargetConditions => target_conditions($e),
            Icon => $E->{icon},
            DisplayName => loca(key(spell_id($e), 'NAME'), "Weave Surge: $e"),
            Description => loca(key(spell_id($e), 'DESC'), $E->{spell}),
            ExtraDescription => loca(key(spell_id($e), 'EXTRA'), $extra),
            TooltipAttackSave => 'Wisdom',
            TooltipStatusApply => 'ApplyStatus(' . peak_id($e) . ',100,1)',
            @CAST,
            PreviewCursor => 'Cast', CastTextEvent => 'Cast',
            CycleConditions => $dark ? 'Enemy() and not Dead()' : 'Ally() and not Dead()',
            UseCosts => 'ActionPoint:1;SpellSlotsGroup:1:1:1',
            VerbalIntent => $dark ? 'Control' : 'Buff', SpellStyleGroup => 'Class',
            SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent;HasHighGroundRangeExtension' . ($dark ? ';IsHarmful' : ''),
            HitAnimationType => $dark ? 'None' : 'MagicalNonDamage', MemoryCost => 1);
    }
    $out;
}

sub build_debug {
    my $passives = 'Arcana_Passive_EmotionalAlchemy;Arcana_Passive_EmpathicSight;Arcana_Passive_ComplexFeelings;Arcana_Passive_Overwhelm;Arcana_Passive_MixedFeelings';
    my $shout = entry('Shout_Arcana_Util_DEBUG_Heartweaver', 'SpellData',
        SpellType => 'Shout', Level => 0, SpellSchool => 'Divination', TargetConditions => 'Self()',
        SpellProperties => 'ApplyStatus(HEARTWEAVER_DEBUG,100,-1)', Icon => 'GenericIcon_Intent_Buff',
        DisplayName => loca('HW_DEBUG_SHOUT_NAME', '[DEBUG] Heartweaver Passives'),
        Description => loca('HW_DEBUG_SHOUT_DESC', 'Grants every Heartweaver passive until you rest, to test Emotional Alchemy.'),
        PreviewCursor => 'Cast', CastTextEvent => 'Cast',
        SpellAnimation => '355a5479-07c9-4a34-9ab6-3b2669fdd248,,;,,;2ac8ee64-6d74-4cad-a74c-660ef3fc3d06,,;5bf6f6e6-353e-40f9-9a6f-0d6d16e19496,,;1c5627cb-6352-454b-9b84-c5b10ef2d201,,;,,;1cc6ba3b-fa78-48f8-858c-ac4c78fdb8fc,,;,,;,,',
        VerbalIntent => 'Utility', SpellStyleGroup => 'Class', SpellFlags => 'IsSpell');
    my $status = entry('HEARTWEAVER_DEBUG', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca('HW_DEBUG_STATUS_NAME', '[DEBUG] Heartweaver'), Icon => 'Spell_Divination_DetectEvilAndGood',
        StackId => 'HEARTWEAVER_DEBUG', Passives => $passives, RemoveEvents => 'OnLongRest');
    ($shout, $status);
}

# ---------------------------------------------------------------- what the game already has (read only)
sub slurp { my $p = shift; open my $h, '<:raw', $p or return ''; local $/; my $s = <$h>; close $h; $s =~ s/\r\n/\n/g; $s }
sub data_dir { "$G/Public/$M/Stats/Generated/Data" }
# name => file (no .txt) for every entry in the mod
sub existing_entries {
    my %where;
    opendir my $d, data_dir() or return {};
    for my $f (grep { /\.txt$/ } readdir $d) {
        (my $base = $f) =~ s/\.txt$//;
        my $s = slurp(data_dir() . "/$f");   # read once: a fresh string in the loop condition would never end
        $where{$1} = $base while $s =~ /^new entry "([^"]+)"/mg;
    }
    \%where;
}

# What goes: every old Emotion*/Feeling* spell (and its upcast variants) and every EMOTION_/MOOD_/FEELING_ status
# that is not in the new set or that moved to another file. Never removed: the upcast variants of the current
# Surges (spell_id($e) . "_2" .. "_6" for every $e in @WHEEL); gen_upcast_variants.pl owns those.
sub removals {
    my ($have, $new) = @_;   # $new: name => file
    my %ours = map { my $e = $_; map { (spell_id($e) . "_$_" => 1) } 2 .. 6 } @WHEEL;
    my @rm;
    for my $n (sort keys %$have) {
        next if $ours{$n};
        next unless $n =~ /^Target_Arcana_Card_Spell_(?:Emotion|Feeling)\w*$/ || $n =~ /^(?:EMOTION|MOOD|FEELING)_\w+$/;
        push @rm, [$have->{$n}, $n] unless ($new->{$n} // '') eq $have->{$n};
    }
    @rm;
}

sub names_in { my $s = shift; my @n = $s =~ /^new entry "([^"]+)"/mg; @n }

# Status files in output order, and the divider new entries go under ("-" = end of file).
our @STATUS_FILES = (['Status_BOOST', 'ARCANA STATUS'], ['Status_FEAR', '-'], ['Status_INCAPACITATED', '-']);

sub build_engine_patch {
    @LOCA = ();
    my $spells   = build_spells();
    my @statuses = build_statuses();
    my $passives = build_passives();
    my ($shout, $debugst) = build_debug();
    my %new;
    $new{$_} = 'Spell_Target' for names_in($spells);
    for my $st (@statuses) { $new{$_} = $st->[0] for names_in($st->[1]) }
    $new{$_} = 'Status_BOOST' for names_in($debugst);
    $new{$_} = 'Passive' for names_in($passives);
    $new{$_} = 'Spell_Shout' for names_in($shout);
    my %known = map { $_->[0] => 1 } @STATUS_FILES;
    $known{$_->[0]} or die "status file $_->[0] has no place in \@STATUS_FILES\n" for @statuses;
    my @rm = removals(existing_entries(), \%new);

    my $p = "# GENERATED by Design/Rework/tools/gen_emotion_alchemy.pl -- do not edit by hand.\n"
          . "# Spec: Design/Rework/specs/2026-10-06-heartweaver-design.md\n\n";
    $p .= "\@loca $_->[0] $_->[1]\n" for @LOCA;
    my %byfile; push @{ $byfile{$_->[0]} }, $_->[1] for @rm;
    for my $f (sort keys %byfile) { $p .= "\n\@file $f\n"; $p .= "\@remove $_\n" for @{ $byfile{$f} } }
    $p .= "\n\@file Spell_Target\n\@section Target_ARCANA SPELLS\n\n$spells";
    $p .= "\@file Spell_Shout\n\@section Shout_DEBUG SPELLS\n\n$shout";
    for my $sf (@STATUS_FILES) {
        my ($file, $section) = @$sf;
        my $body = join '', map { $_->[1] } grep { $_->[0] eq $file } @statuses;
        $p .= "\@file $file\n\@section $section\n\n$body";
        $p .= "\@section DEBUG STATUS\n\n$debugst" if $file eq 'Status_BOOST';
    }
    $p .= "\@file Passive\n\@section ARCANA PASSIVES\n\n$passives";
    $p;
}

# +1 target per variant level, only for variants that already exist (gen_upcast_variants makes them).
sub build_upcast_patch {
    my $have = existing_entries();
    my $p = "# GENERATED by Design/Rework/tools/gen_emotion_alchemy.pl -- do not edit by hand.\n"
          . "# Run AFTER gen_upcast_variants.pl --apply: +1 target per slot level.\n\n\@file Spell_Target\n";
    my $n = 0;
    for my $e (@WHEEL) { for my $L (2 .. 6) {
        my $v = spell_id($e) . "_$L";
        next unless ($have->{$v} // '') eq 'Spell_Target';
        $p .= "\@set $v AmountOfTargets $L\n"; $n++ } }
    ($p, $n);
}

sub write_file { my ($path, $s) = @_; make_path(dirname($path)); open my $h, '>:raw', $path or die "$path: $!"; print $h $s; close $h }

sub main {
    my ($out) = grep { defined } map { $ARGV[$_ + 1] if $ARGV[$_] eq '--out' } 0 .. $#ARGV;
    $out //= dirname(__FILE__) . '/../heartweaver';
    my $engine = build_engine_patch();
    write_file("$out/10_engine.patch", $engine);
    my ($up, $n) = build_upcast_patch();
    write_file("$out/20_upcast_targets.patch", $up);
    printf "10_engine.patch: %d new entries, %d removals, %d strings\n",
        scalar(() = $engine =~ /^new entry /mg), scalar(() = $engine =~ /^\@remove /mg), scalar(() = $engine =~ /^\@loca /mg);
    printf "20_upcast_targets.patch: %d variants%s\n", $n, $n ? '' : ' (none yet: run gen_upcast_variants.pl --apply, then generate again)';
}

main() unless caller;
1;
```

- [ ] **Step 4: run the tests and watch them pass**

Run: `cd "$T" && perl t/gen_emotion_alchemy.t 2>&1 | grep -v '^ok ' ; perl t/gen_emotion_alchemy.t | tail -1`
Expected: no `not ok` line; the last line is `1..1212`.

- [ ] **Step 5: generate the patches**

Run: `cd "$T" && perl gen_emotion_alchemy.pl`
Expected:
```
10_engine.patch: 69 new entries, 37 removals, 141 strings
20_upcast_targets.patch: 16 variants
```
(The 16 variants in patch 20 belong to the **old** cards and do not matter now: patch 20 is generated again in Task 3, after `gen_upcast_variants.pl`.)

- [ ] **Step 6: generate twice and compare (determinism)**

Run: `cd "$T" && perl gen_emotion_alchemy.pl --out /tmp/hw1 >/dev/null && perl gen_emotion_alchemy.pl --out /tmp/hw2 >/dev/null && cmp /tmp/hw1/10_engine.patch /tmp/hw2/10_engine.patch && echo same`
Expected: `same`.

- [ ] **Step 7: dry run through `stats_add.pl` (writes nothing)**

Run: `perl "$T/stats_add.pl" "$P/Design/Rework/heartweaver/10_engine.patch" > /tmp/hw_sim.txt; echo "exit $?"; grep -v '^txt \|^remove \|^loca + ' /tmp/hw_sim.txt; grep 'Status_FEAR\|Status_INCAPACITATED' /tmp/hw_sim.txt`
Expected: `exit 0`; only the final dry-run line is left by the first grep (`stats_add.pl` prints it in Portuguese: `(simulacao -- rode com --apply para gravar)`); the second grep shows `txt + Status_FEAR EMOTION_TERROR (fim)` and three `txt + Status_INCAPACITATED …` lines (Amazement, Grief, Awe). 37 `remove` lines, 141 `loca +`.

- [ ] **Step 8: read the patch with human eyes**

Open `10_engine.patch` and check in `Target_Arcana_Card_Spell_EmotionFear`: `SpellSuccess` starts with `IF(not (…)…):ApplyStatus(EMOTION_FEAR,100,1)` and ends with `ApplyStatus(CATHARSIS,100,0)`; `TargetConditions` carries the card mark. Check `EMOTION_TERROR` reads `data "StatusType" "FEAR"` then `using "FEARED"`. Read 3 `@loca` strings aloud (Larian voice, British).

(Nothing to commit: `Design/` is outside git. The scripts reach the repo in Task 3, through `sync-mod.sh`.)

---

### Task 2: DEBUG list script — writes nothing in the mod

**Files:**
- Create: `$T/heartweaver_debug_list.pl`

**Interfaces:**
- Consumes: the `Target_Arcana_Card_Spell_Emotion*` and `Shout_Arcana_Util_DEBUG_Heartweaver` ids from Task 1.
- Produces: `perl heartweaver_debug_list.pl [--apply]` adds; `--remove-surges [--apply]` takes the Surges off and keeps the utility (plan 2 uses it).

- [ ] **Step 1: write the script**

Create `$T/heartweaver_debug_list.pl` with:

```perl
#!/usr/bin/perl
# Heartweaver, before the subclass exists: puts the 8 Weave Surges and [DEBUG] Heartweaver Passives on the
# "Arcana Deck DEBUG" list (class level 1), on both sides -- SpellLists.lsx (game) and SpellLists.tbl (Toolkit).
# Idempotent. Plan 2 (the subclass) takes the Surges off again and keeps only the DEBUG utility.
#
#   perl heartweaver_debug_list.pl            # shows what it would do
#   perl heartweaver_debug_list.pl --apply    # writes (game and Toolkit closed)
#   perl heartweaver_debug_list.pl --remove-surges [--apply]   # (plan 2) takes the Surges off, keeps the utility
use strict; use warnings;
my $apply  = grep { $_ eq '--apply' } @ARGV;
my $remove = grep { $_ eq '--remove-surges' } @ARGV;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $LIST = 'f2e5e2e9-42c8-4f0e-88de-830ef0224290';   # Arcana Deck DEBUG
my %F = (lsx => "$G/Public/$M/Lists/SpellLists.lsx", tbl => "$G/Editor/Mods/$M/Lists/SpellLists.tbl");
my @SURGES = map { "Target_Arcana_Card_Spell_Emotion$_" } qw(Joy Trust Fear Surprise Sadness Disgust Anger Anticipation);
my @ADD = $remove ? () : (@SURGES, 'Shout_Arcana_Util_DEBUG_Heartweaver');
my @DEL = $remove ? @SURGES : ();

sub merge { my $cur = shift; my @s = grep { length } split /;/, $cur; my %del = map { $_ => 1 } @DEL;
    @s = grep { !$del{$_} } @s; my %have = map { $_ => 1 } @s; push @s, grep { !$have{$_} } @ADD; join ';', @s }

my %txt; my %orig;
for my $k (keys %F) { open my $h, '<:raw', $F{$k} or die "$F{$k}: $!"; local $/; $txt{$k} = <$h>; close $h; $orig{$k} = $txt{$k} }
my $n = 0;
$n += $txt{lsx} =~ s{(<attribute id="Spells" type="LSString" value=")([^"]*)("/>\s*<attribute id="UUID" type="guid" value="\Q$LIST\E"/>)}{ "$1" . merge($2) . "$3" }e;
$n += $txt{tbl} =~ s{(value="\Q$LIST\E" />(?:(?!</stat_object>).)*?<field name="Spells" type="StringTableFieldDefinition" value=")([^"]*)}{ "$1" . merge($2) }se;
die "list $LIST not found in both files ($n of 2)\n" unless $n == 2;
for my $k (sort keys %F) {
    my ($v) = $k eq 'lsx' ? $txt{$k} =~ /value="([^"]*)"\/>\s*<attribute id="UUID" type="guid" value="\Q$LIST\E"/
                          : $txt{$k} =~ /value="\Q$LIST\E" \/>(?:(?!<\/stat_object>).)*?<field name="Spells" type="StringTableFieldDefinition" value="([^"]*)"/s;
    printf "%s %s: %s\n", ($txt{$k} eq $orig{$k} ? '=' : '~'), $k, $v;
}
if ($apply) { for my $k (keys %F) { next if $txt{$k} eq $orig{$k}; open my $h, '>:raw', $F{$k} or die "$F{$k}: $!"; print $h $txt{$k}; close $h } print "written\n" }
else { print "(dry run -- use --apply to write)\n" }
```

- [ ] **Step 2: dry run**

Run: `perl "$T/heartweaver_debug_list.pl"`
Expected: two lines starting `~ lsx:` and `~ tbl:`, both ending in `…;Target_Arcana_Card_Spell_EmotionAnticipation;Shout_Arcana_Util_DEBUG_Heartweaver`, then `(dry run -- use --apply to write)`.

- [ ] **Step 3: dry run of the removal (plan 2's path)**

Run: `perl "$T/heartweaver_debug_list.pl" --remove-surges`
Expected: `= lsx:` and `= tbl:` (nothing changes: there are no Surges on the list yet).

---

### Task 3: Apply to the game — **only on `[fechado]`**

**Files:** the stats, lists and loca files from the map; `tools/sync-mod.sh`.

- [ ] **Step 1:** does the user's message start with `[fechado]`? If not, stop and ask for it.

- [ ] **Step 2: backup**

```bash
B="$G/Backup/heartweaver_engine_20261006"
for d in "Public/$M/Stats" "Public/$M/Lists" "Editor/Mods/$M/Stats" "Editor/Mods/$M/Lists" "Mods/$M/Localization/English"; do
  mkdir -p "$B/$(dirname "$d")"; cp -r "$G/$d" "$B/$d"; done
ls "$B/Public/$M" "$B/Editor/Mods/$M" "$B/Mods/$M/Localization"
```

- [ ] **Step 3: regenerate and apply the engine**

```bash
cd "$T" && perl gen_emotion_alchemy.pl
perl "$T/stats_add.pl" "$P/Design/Rework/heartweaver/10_engine.patch" --apply
ls "$G/Public/$M/Stats/Generated/Data/" | grep 'Status_FEAR\|Status_INCAPACITATED'
```
Expected: the same lines as the Task 1 Step 7 dry run, no error; `Status_FEAR.txt` and `Status_INCAPACITATED.txt` now exist.

- [ ] **Step 4: check the Toolkit side**

Run: `perl "$T/stats_add.pl" --selftest; echo "exit $?"`
Expected: `exit 0` (each entry's regenerated `.stats` matches its `.txt`, the two new type files included).

- [ ] **Step 5: upcast variants**

```bash
perl "$T/gen_upcast_variants.pl"            # dry run
perl "$T/gen_upcast_variants.pl" --apply
grep -c '^new entry "Target_Arcana_Card_Spell_Emotion[A-Za-z]*_[2-6]"' "$G/Public/$M/Stats/Generated/Data/Spell_Target.txt"
```
Expected: 40 variants (8 Surges × `_2`…`_6`; a level-1 card granted at level 1 starts at `_2`).

- [ ] **Step 6: +1 target per level**

```bash
cd "$T" && perl gen_emotion_alchemy.pl
```
Expected: `20_upcast_targets.patch: 40 variants`.

```bash
perl "$T/stats_add.pl" "$P/Design/Rework/heartweaver/20_upcast_targets.patch" --apply
grep -A8 '^new entry "Target_Arcana_Card_Spell_EmotionFear_4"' "$G/Public/$M/Stats/Generated/Data/Spell_Target.txt" | grep AmountOfTargets
```
Expected: `data "AmountOfTargets" "4"`.

- [ ] **Step 7: DEBUG list**

```bash
perl "$T/heartweaver_debug_list.pl" --apply && perl "$T/heartweaver_debug_list.pl"
```
Expected: on the second run, `= lsx:` and `= tbl:` (idempotent).

- [ ] **Step 8: lint**

Run: `perl "$T/check_cards.pl"; echo "exit $?"`
Expected: the same exit code and warnings as the baseline (Task 0 Step 2: `exit 1`, 14 pre-existing cards without the mark on 2026-10-06), none mentioning `Emotion`.

- [ ] **Step 9: ordering — report only**

Run: `perl "$T/sort_stats.pl" | grep -i "emotion\|mood\|feeling\|catharsis\|heartweaver\|FEAR\|INCAPACITATED" | head -20`
Do **not** run `--apply`: the HEARTWEAVER group only exists in plan 2. Copy the report into the test guide's notes if it wants to move anything.

- [ ] **Step 10: mirror the new scripts in the repo**

In `$P/tools/sync-mod.sh`, on the `for t in …` line, add the two names:

```bash
for t in gen_upcast_variants.pl sort_stats.pl check_cards.pl stats_add.pl aspect_structure.pl gen_emotion_alchemy.pl heartweaver_debug_list.pl; do
```

and right after that loop, copy the test:

```bash
mkdir -p "$HERE/tools/stats/t"
[ -f "$TOOLS_SRC/t/gen_emotion_alchemy.t" ] && cp "$TOOLS_SRC/t/gen_emotion_alchemy.t" "$HERE/tools/stats/t/"
```

- [ ] **Step 11: sync, commit and push**

```bash
cd "$P" && bash tools/sync-mod.sh && git add -A && git status --short | head -30
git commit -m "Heartweaver engine: Plutchik's wheel as Emotional Alchemy, testable from the DEBUG list

Eight Weave Surges (level-1 cards) react with the mood a creature already
carries, by distance on the wheel: intensify, primary/secondary/tertiary
feeling, or Catharsis. Terror is a FEAR status (it flees); Amazement, Grief
and Awe are INCAPACITATED. Generated by tools/stats/gen_emotion_alchemy.pl.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push
```
Expected: `git status` lists `mod/Public/Stats/...` (with the two new status files), `mod/Editor/Stats/...`, `mod/Public/Lists/...`, `mod/Editor/Lists/...` and `tools/stats/*` (+ `t/`). Push succeeds.

---

### Task 4: In-game test guide + Context

**Files:**
- Create: `$P/Design/Rework/plans/2026-10-06-heartweaver-engine-test.md`
- Modify: `$P/Context/07-open-questions.md` (the Heartweaver item)

- [ ] **Step 1: write the guide**

Create `2026-10-06-heartweaver-engine-test.md` with:

```markdown
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
```

- [ ] **Step 2: update Context**

In `Context/07-open-questions.md`, in the **The Heartweaver** item, replace "design in review 2026-10-06" with "engine in the game since <date>, on the DEBUG list for testing (plan 1); the subclass skeleton is plan 2", and add: "Engine generated by `tools/stats/gen_emotion_alchemy.pl` — change its table, never the patches."

- [ ] **Step 3: hand over to the user**

Tell the user (in Portuguese): what was applied (the Task 3 numbers), where the guide is, and that the next step is running the guide with the game open and sending back the answers for R1, R2, R4, R5, R6 and R9. Plan 2 is written **after** that test, because each risk's plan B changes the subclass design.

---

## Later: plan 2 (the subclass) — written after the engine test

Scope, for reference only (do not execute from here):
1. `sort_stats.pl`: a `HEARTWEAVER` group (dividers `Target_HEARTWEAVER SPELLS`, `HEARTWEAVER STATUS`, `HEARTWEAVER PASSIVES`, and the FEAR / INCAPACITATED ones) with roots in the subclass lists.
2. Skeleton in the Toolkit (UUID Object Editor): the subclass ClassDescription, Progression 1–12, lists "Heartweaver Level N" (Surges at 1/3/5), passives at 1/5/7/9. Chassis: decide with the user (spec §12).
3. `heartweaver_debug_list.pl --remove-surges --apply`.
4. Signature cards: Heartstring, Turn the Wheel, Emotional Contagion, Ready: Compassion, Equanimity, The Two Cups (+ CardDB if one conjures or is Unique).
5. Awakening: `ARCANA_Aspect_Temperance.txt` (Osiris), tier passives, `ASPECT_AWAKENED_TEMPERANCE`, VFX.
6. Localisation into the other 15 languages (when the user asks), `Context/subclasses/heartweaver.md`, `04-subclass-comparison`.