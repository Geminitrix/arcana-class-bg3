#!/usr/bin/perl
# Tests for the Emotional Alchemy generator.   perl t/gen_emotion_alchemy.t   (`prove` does not run on this Perl)
# One assertion per rule: each collects what breaks it, so a failure names the entries and a pass prints one line.
use strict; use warnings; no warnings 'once';
use Test::More;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
require(abs_path(dirname(__FILE__)) . '/../gen_emotion_alchemy.pl');

my @W = @Alchemy::WHEEL;
sub none { my ($name, @bad) = @_; is_deeply(\@bad, [], $name) }
sub block { my ($p, $id) = @_; my ($b) = $p =~ /(^new entry "\Q$id\E"\n.*?)\n\n/ms; $b // '' }

# ---- the wheel and Plutchik's dyads
none('distance is symmetric, wraps, and opposites are 4',
    (grep { my $x = $_; grep { Alchemy::distance($x, $_) != Alchemy::distance($_, $x) } @W } @W),
    (grep { Alchemy::distance($_->[0], $_->[1]) != 4 } [qw(Joy Sadness)], [qw(Trust Disgust)], [qw(Fear Anger)], [qw(Surprise Anticipation)]),
    (Alchemy::distance('Joy', 'Anticipation') == 1 ? () : 'wrap'));
my %plutchik = (1 => [qw(Love Submission Awe Disapproval Remorse Contempt Aggressiveness Optimism)],
                2 => [qw(Hope Guilt Curiosity Despair Unbelief Envy Cynicism Pride)],
                3 => [qw(Delight Sentimentality Shame Outrage Pessimism Morbidness Dominance Anxiety)]);
my %have;
for my $k (keys %Alchemy::FEELING) { my ($x, $y) = split /\+/, $k; push @{ $have{ Alchemy::distance($x, $y) } }, $Alchemy::FEELING{$k}{name} }
is_deeply({ map { $_ => [sort @{ $have{$_} }] } 1 .. 3 }, { map { $_ => [sort @{ $plutchik{$_} }] } 1 .. 3 }, "the 24 dyads, each at Plutchik's distance");
none('feeling keys in wheel order', grep { my ($x, $y) = split /\+/; $_ ne Alchemy::pair($x, $y) } keys %Alchemy::FEELING);

# ---- the 8x8 reaction matrix
none('every Surge/mood pair: right kind and gate', map { my $s = $_; map {
    my $r = Alchemy::reaction($s, $_); my $d = Alchemy::distance($s, $_);
    my $want = $d == 0 ? 'intensify' : $d == 4 ? 'catharsis' : 'feeling';
    ($r->{kind} ne $want || ($r->{gate} // '') ne ($Alchemy::GATE{$d} // '')) ? "$s/$_" : () } @W } @W);
is(Alchemy::reaction('Fear', 'Trust')->{status}, 'FEELING_SUBMISSION', 'Fear on Accepting = Submission');
is(Alchemy::reaction('Fear', 'Fear')->{status}, 'EMOTION_TERROR', 'Fear on Apprehensive = Terror');

# ---- SpellSuccess
my $ss = Alchemy::spell_success('Fear');
my @f = split /;(?=IF\()/, $ss;
like($f[0], qr/^IF\(not \(.*:ApplyStatus\(EMOTION_FEAR,100,1\)$/, 'first functor: the no-reaction case applies the peak (risk R1)');
is(scalar(() = $f[0] =~ /HasStatus\('MOOD_/g), 8, 'the no-reaction case checks all 8 moods');
like($ss, qr/IF\(HasStatus\('MOOD_SERENE'\) and HasPassive\('Arcana_Passive_ComplexFeelings', context\.Source\) and not HasStatus\('RESONANT_TIER2', context\.Source\)\):ApplyStatus\(FEELING_GUILT,100,2\)/, 'a gated reaction');
like($ss, qr/DealDamage\(LevelMapValue\(Catharsis_Damage\),Psychic,Magical\).*RegainHitPoints\(LevelMapValue\(Catharsis_Damage\)\).*ApplyStatus\(CATHARSIS,100,0\)$/, 'Catharsis harms, heals, then clears the moods last');
none('each Surge: 1 base case + intensify + 6 feelings x 2 (Tier II) + 5 Catharsis functors (2 for Tier I); the refund is in Osiris', grep { (() = Alchemy::spell_success($_) =~ /IF\(/g) != 19 } @W);

# ---- the whole patch
$Alchemy::STAGE = 4;   # ARC-0017: test the whole refined build (R49-R68); the apply sets ARC17_STAGE per stage
my $p = Alchemy::build_engine_patch();
# today's game (ARC17_STAGE=0): the ARC-0002 assertions below that the refining changed run against it, as a regression
my ($p0, $g0, $ag0); { local $Alchemy::STAGE = 0; $p0 = Alchemy::build_engine_patch(); $g0 = Alchemy::overload_goal(); $ag0 = Alchemy::temperance_goal(); }
my %lt0 = $p0 =~ /^\@loca (\S+) (.*)$/mg;
my @entries = $p =~ /^new entry "([^"]+)"/mg;
my %defined = map { $_ => 1 } @entries;
my $surge_re = '^Target_Arcana_Card_Spell_Emotion(?:' . join('|', @W) . ')$';
is_deeply([map { my $re = $_; scalar grep { /$re/ } @entries } qr/$surge_re/, qr/^MOOD_/, qr/^FEELING_(?!.*_TECH$|DISAPPROVED$)/, qr/^EMOTION_/],
    [8, 8, 24, 16], '8 Surges, 8 moods, 24 feelings, 16 emotions');
my %dup; $dup{$_}++ for @entries;
none('no duplicate entry', grep { $dup{$_} > 1 } sort keys %dup);
my %cited; $cited{$1}++ while $p =~ /(?:ApplyStatus\((?:SELF,)?|RemoveStatus\(|HasStatus\(')((?:EMOTION|MOOD|FEELING|CATHARSIS|RESONANT)\w*)/g;
$cited{$1}++ while $p =~ /(Arcana_Passive_(?:EmotionalAlchemy|EmpathicSight|ComplexFeelings|Overwhelm|MixedFeelings|Feeling\w+))/g;
none('every cited status/passive is defined', grep { !$defined{$_} } sort keys %cited);

# ---- status types: each in the file of its type, `using` right after StatusType
my %file_of; my $cur = '';
for my $l (split /\n/, $p) { $cur = $1 if $l =~ /^\@file (\S+)/; $file_of{$1} = $cur if $l =~ /^new entry "([^"]+)"/ }
my %type_of; $type_of{$1} = $2 while $p =~ /^new entry "([^"]+)"\ntype "StatusData"\ndata "StatusType" "(\w+)"/mg;
none('each status sits in Status_<its type>', grep { $file_of{$_} ne "Status_$type_of{$_}" } sort keys %type_of);
like($p, qr/^new entry "EMOTION_TERROR"\ntype "StatusData"\ndata "StatusType" "FEAR"\nusing "FEARED"\n/m, 'Terror: FEAR, using FEARED');
like($p, qr/^new entry "EMOTION_AMAZEMENT"\ntype "StatusData"\ndata "StatusType" "INCAPACITATED"\nusing "STUNNED"\n/m, 'Amazement: INCAPACITATED, using STUNNED');
like($p, qr/^new entry "FEELING_AWE"\ntype "StatusData"\ndata "StatusType" "INCAPACITATED"\nusing "HYPNOTIC_PATTERN"\n/m, 'Awe: INCAPACITATED, using HYPNOTIC_PATTERN');
like(block($p, 'EMOTION_TERROR'), qr/data "RemoveConditions" ""/, 'Terror clears the inherited per-turn save');
like(block($p, 'EMOTION_AMAZEMENT'), qr/data "OnApplyFunctors" "RemoveStatus\(MOOD_DISTRACTED\);BreakConcentration\(\);ApplyStatus\(RESONANT_EXCESS_SPENT,100,-1\)"/, 'Amazement keeps BreakConcentration (and marks its excess, R50)');
none('statuses with `using` inherit TickType', grep { block($p, $_) =~ /^data "TickType"/m } qw(FEELING_AWE EMOTION_TERROR EMOTION_AMAZEMENT));

# ---- StackIds: peaks and intense share EMOTION, moods share MOOD, each feeling its own
my %stack_of; my $cs = '';
for my $l (split /\n/, $p) { $cs = $1 if $l =~ /^new entry "([^"]+)"/; $stack_of{$cs} = $1 if $l =~ /^data "StackId" "([^"]*)"$/ }
none('StackIds', (grep { $stack_of{$_} ne 'EMOTION' } map { ('EMOTION_' . uc $_, 'EMOTION_' . uc $Alchemy::EMO{$_}{intense}{name}) } @W),
    (grep { $stack_of{$_} ne 'MOOD' } map { 'MOOD_' . uc $Alchemy::EMO{$_}{mood}{name} } @W),
    (grep { $stack_of{$_} ne $_ } map { 'FEELING_' . uc $Alchemy::FEELING{$_}{name} } keys %Alchemy::FEELING));

# ---- the Surges
none('Surges: Wisdom save for non-allies, allies auto-resolve (vanilla SpellAutoResolveOnAlly), SpellFail, IsHarmful only on the dark arc, standard warning', map {
    my $sp = block($p, Alchemy::spell_id($_)); my $dark = $Alchemy::EMO{$_}{side} eq 'I';
    ($sp =~ /^data "SpellRoll" "SpellAutoResolveOnAlly\(Ability\.Wisdom,SourceSpellDC\(\),true\)"$/m
     && $sp =~ /^data "SpellFail" "ApplyStatus\(SAVED_AGAINST_HOSTILE_SPELL,100,0\)"$/m
     && $sp =~ /^data "TooltipAttackSave" "Wisdom"$/m
     && $sp =~ /^data "TooltipPermanentWarnings" "$Alchemy::SURGE_WARNING"$/m
     && (($sp =~ /IsHarmful/ ? 1 : 0) == ($dark ? 1 : 0))) ? () : $_ } @W);
none('DescriptionParams use real damage types', grep { /,\s*Weapon\)/ } $p =~ /^data "DescriptionParams" "([^"]*)"$/mg);

# ---- text
is(Alchemy::tag_terms('Has Advantage on Attack Rolls. Advantage again.'),
   'Has <LSTag Tooltip="Advantage">Advantage</LSTag> on <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag>. Advantage again.',
   'only the first mention becomes an LSTag');
my @loca = $p =~ /^\@loca (\S+) (.*)$/mg; my %lt = @loca;
is(scalar(keys %lt), @loca / 2, 'unique loca keys');
none('every {{key}} has a string', grep { !$lt{$_} } $p =~ /\{\{(\w+)\}\}/g);
none('strings: no dash, no double quotes outside LSTag, no nested LSTag, no raw key', grep { my $t = $lt{$_}; (my $bare = $t) =~ s/<LSTag[^>]*>//g;
    $t =~ /\x{2014}|\x{2013}|\xE2\x80[\x93\x94]/ || $bare =~ /"/ || $t =~ /<LSTag[^>]*>[^<]*<LSTag/ || $t =~ /\{\{|\}\}/ } sort keys %lt);
none('status text on one line', grep { $lt{$_} =~ /<br>/ } grep { /^HW_(?:EMOTION|MOOD|FEELING)_\w+_DESC$|^HW_CATHARSIS_DESC$/ } keys %lt);
none('Surge text: flavour, effect, then the mood; one line per reaction (the Owner format, 2026-10-12), 8 reactions', map {
    my $id = uc Alchemy::spell_id($_); my $mood = $Alchemy::EMO{$_}{mood}{name}; my $x = $lt{"HW_${id}_EXTRA"};
    ($lt{"HW_${id}_DESC"} =~ /^[^.]+\. The target\b.*<br><br>When the surge fades, it leaves the target <LSTag[^>]*>$mood<\/LSTag> for 5 turns, /
     && join(',', map { /^(\w+)/ } split /<br>/, $x) eq 'Intense,Primary,Primary,Secondary,Secondary,Tertiary,Tertiary,Catharsis' && $x =~ /<br>$/ && $x !~ /<br><br>/
     && (() = $x =~ / into /g) == 8) ? () : $_ } @W);

# ---- removals() keeps the upcast variants of the current Surges (synthetic data, no game files)
my $have = { Target_Arcana_Card_Spell_EmotionFear => 'Spell_Target', Target_Arcana_Card_Spell_EmotionFear_4 => 'Spell_Target',
    Target_Arcana_Card_Spell_EmotionFury_3 => 'Spell_Target', Target_Arcana_Card_Spell_FeelingLove => 'Spell_Target',
    MOOD_AFRAID => 'Status_BOOST', EMOTION_MOVED => 'Status_KNOCKED_DOWN', MOOD_SERENE => 'Status_BOOST' };
my $new = { Target_Arcana_Card_Spell_EmotionFear => 'Spell_Target', EMOTION_MOVED => 'Status_BOOST', MOOD_SERENE => 'Status_BOOST' };
is_deeply([sort map { "$_->[0]|$_->[1]" } Alchemy::removals($have, $new)],
    [sort qw(Spell_Target|Target_Arcana_Card_Spell_EmotionFury_3 Spell_Target|Target_Arcana_Card_Spell_FeelingLove Status_BOOST|MOOD_AFRAID Status_KNOCKED_DOWN|EMOTION_MOVED)],
    'removals: old entries and moved statuses go; current Surges, their variants and statuses stay');
my %all = map { my $e = $_; map { (Alchemy::spell_id($e) . "_$_" => 'Spell_Target') } 2 .. 6 } @W;
none('removals: no current variant is ever removed', map { $_->[1] } Alchemy::removals(\%all, {}));
is_deeply([map { $_->[1] } Alchemy::removals({ Target_Arcana_Card_Spell_EmotionalContagion => 'Spell_Target', Target_Arcana_Card_Spell_EmotionalContagion_5 => 'Spell_Target' },
    { Target_Arcana_Card_Spell_EmotionalContagion => 'Spell_Target' })], [], 'removals: the upcast variants of a generated card stay (Emotional Contagion)');

# ---- paths after the Lumox migration
like(Alchemy::default_out(), qr{/50_ENGINEERING/55_Implementation_Specs/_wip/Resonant$}, 'patches go to 55/_wip/Resonant');

# ---- master data (25) is the only source of numbers
is(Alchemy::master('STA_Resonant_Peaks', 'joy_aura_radius')->{value}, 3, 'reads a plain value from 25');
is_deeply(Alchemy::master('STA_Resonant_Catharsis', 'damage')->{by_level}, { 1 => '2d8', 5 => '3d8', 10 => '4d8' }, 'reads by_level from 25');
like(Alchemy::master('STA_Resonant_States', 'mood_duration')->{value}, qr/^\d+$/, 'mood duration is a number read from 25');

# ---- Catharsis by level
my $lm = Alchemy::catharsis_levelmap();
like($lm, qr/<attribute id="Level4" type="LSString" value="2d8"\/>/, 'level 4: 2d8');
like($lm, qr/<attribute id="Level5" type="LSString" value="3d8"\/>/, 'level 5: 3d8');
like($lm, qr/<attribute id="Level9" type="LSString" value="3d8"\/>/, 'level 9: 3d8');
like($lm, qr/<attribute id="Level10" type="LSString" value="4d8"\/>/, 'level 10: 4d8');
like($lm, qr/value="Catharsis_Damage".*value="$Alchemy::CATHARSIS_MAP_UUID"/s, 'name and fixed UUID');
like(Alchemy::spell_success('Fear'), qr/DealDamage\(LevelMapValue\(Catharsis_Damage\),Psychic,Magical\)/, 'Catharsis damage reads the map');

# ---- refund (R16): Osiris applies it when a reaction status lands (the Surge's line had grown past the
#      Toolkit's 4096-character read limit, 2026-10-12)
unlike(Alchemy::spell_success($_), qr/RESONANT_REFUND_TECH/, "refund is not in $_\'s SpellSuccess") for qw(Joy Fear);
my $og = Alchemy::overload_goal();
is(scalar(() = $og =~ /DB_ARCANA_Resonant_Reaction\("(?:FEELING_\w+|EMOTION_\w+|CATHARSIS)"\);/g), 33, 'refund: the 33 reaction statuses (24 feelings, 8 intense, Catharsis)');
like($og, qr/StatusApplied\(_Target, _Status, \(CHARACTER\)_Resonant, _\)\r?\nAND\r?\nDB_ARCANA_Resonant_Reaction\(_Status\)\r?\nAND\r?\nHasPassive\(_Resonant, "Arcana_Passive_EmotionalAlchemy", 1\)\r?\nTHEN\r?\nApplyStatus\(_Resonant, "RESONANT_REFUND_TECH", 0\.0, 1, _Resonant\);/, 'refund: any reaction a Resonant causes');
unlike($og, qr/DB_ARCANA_Resonant_Reaction\("RESONANT_TWO_CUPS_CATHARSIS"\)/, 'refund: The Two Cups is not a Surge');
none('no stats line comes near the 4096-character read limit (the .stats twin adds ~100)', map { /^new entry "([^"]+)"/ ? () : length($_) > 3900 ? substr($_, 0, 40) : () } split /\n/, $p);
my $rf = block($p, 'RESONANT_REFUND_TECH');
is(scalar(() = $rf =~ /RestoreResource\(SELF,ArcanaSpellSlot,1,\d\)/g), 6, 'one slot refund per slot level 1-6');
like($rf, qr/ApplyStatus\(SELF,RESONANT_REFUND_USED,100,1\)"$/m, 'the used flag is set last');
none('every slot refund is guarded by the used flag', grep { !/not HasStatus\('RESONANT_REFUND_USED'\)/ } $rf =~ /(IF\([^:]*\):RestoreResource)/g);

like(join(' ', map { $lt{$_} } grep { /EMOTIONALALCHEMY_DESC$/ } keys %lt), qr/you regain the spell slot it used\. Once per turn\./, 'Emotional Alchemy explains the refund');

# ---- behaviour peaks (R15, R17)
my $pk = sub { block($p, 'EMOTION_' . uc shift) };
like($pk->('Joy'), qr/data "AuraRadius" "3"\n/, 'Joy: contagious aura of 3 m');
like(block($p, 'RESONANT_JOY_CONTAGION'), qr/Advantage\(AttackRoll\).*"RemoveEvents" "OnAttack"/s, 'contagion: next attack only');
like($pk->('Anticipation'), qr/UnlockInterrupt\(Interrupt_Arcana_AnticipationGuard\)/, 'Anticipation: guard interrupt');
like($pk->('Fear'), qr/"StatusGroups" "SG_Frightened;SG_Condition"/, 'Fear: Frightened group');
like($pk->('Surprise'), qr/"Boosts" "ActionResourceBlock\(ReactionActionPoint\)".*ApplyStatus\(RESONANT_SURPRISE_OPENING,100,1\)/s, 'Surprise: no reaction, opening');
like(block($p, 'RESONANT_SURPRISE_OPENING'), qr/Advantage\(AttackTarget\).*"RemoveEvents" "OnAttacked"/s, 'opening: first attack only');
like($pk->('Sadness'), qr/"Boosts" "ActionResourceBlock\(BonusActionPoint\)".*BreakConcentration\(\)/s, 'Sadness: lets go');
like(block($p, 'RESONANT_GRUDGE'), qr/"StatusGroups" "SG_Taunted"/, 'grudge: taunted group');
like($p, qr/^new entry "Interrupt_Arcana_AnticipationGuard"\ntype "InterruptData"\n(?:.*\n)*?data "InterruptContext" "OnEnterAttackRange"/m, 'guard: enters reach');

# ---- stage 1b: probe fixes (R25-R28)
none('no Surge keeps the INT gate', grep { block($p, Alchemy::spell_id($_)) =~ /IntelligenceGreaterThan/ } @W);
none('every Surge skips constructs', grep { block($p, Alchemy::spell_id($_)) !~ /not Tagged\('CONSTRUCT'\)/ } @W);
like($pk->('Joy'), qr/"AuraStatuses" "IF\(Ally\(\) or Self\(\)\):ApplyStatus\(RESONANT_JOY_CONTAGION,100,1\)"/, 'Joy: the Joyful creature shares it');
like($pk->('Anticipation'), qr/"TickType" "StartTurn".*"StatusPropertyFlags" "[^"]*TickingWithSource/s, 'Anticipation lasts until your next turn');
none('Anger and Rage do not attack the nearest by themselves', grep { $pk->($_) =~ /AiArchetypeOverride/ } qw(Anger Rage));
like(block($p, 'RESONANT_ANGER_FALLBACK'), qr/AiArchetypeOverride\(madness,99\)/, 'the fallback attacks the nearest');
like($pk->('Trust'), qr/UnlockInterrupt\(Interrupt_Arcana_TrustShoulder\)/, 'Trust: shoulder to shoulder');
like($p, qr/^new entry "Interrupt_Arcana_TrustShoulder"\ntype "InterruptData"\n(?:.*\n)*?data "InterruptContext" "OnPreDamage"/m, 'shoulder: before the damage');
like(block($p, 'RESONANT_TRUST_SHOULDERED'), qr/Resistance\(All, Resistant\);RedirectDamage\(1\)/, 'shouldered: Warding Bond boosts');
unlike($p, qr/^new entry "Interrupt_Arcana_TrustFollowUp"/m, 'the follow-up interrupt is no longer generated');
is_deeply([map { "$_->[0]|$_->[1]" } Alchemy::removals({ Interrupt_Arcana_TrustFollowUp => 'Interrupt', Interrupt_Arcana_Other => 'Interrupt' }, {})],
    ['Interrupt|Interrupt_Arcana_TrustFollowUp'], 'removals: the retired follow-up goes, other interrupts stay');

# ---- stage 1c: re-test fixes
like($pk->('Trust'), qr/"TickType" "StartTurn".*"StatusPropertyFlags" "[^"]*TickingWithSource/s, 'Trust lasts until your next turn (P2)');
none('Anger and Rage keep their reaction (opportunity attacks, P4)', grep { $pk->($_) =~ /ActionResourceBlock\(ReactionActionPoint\)/ } qw(Anger Rage));
none('Surge tooltips no longer repeat the refund (Owner, 2026-10-12: Emotional Alchemy tells it)', grep { ($lt{'HW_' . uc(Alchemy::spell_id($_)) . '_EXTRA'} // '') =~ /Any reaction gives back/ } @W);

# ---- stage 2: Overload
my $full = block($p0, 'RESONANT_OVERLOAD_FULL');   # stage 0
like($full, qr/"TickType" "StartTurn"/, 'full: hurts at the start of your turn');
like($full, qr/ClassLevelHigherOrEqualThan\(11,'Arcana'\)\):DealDamage\(6,Psychic,Magical\)/, 'full at level 11+: 6 Psychic');
like(block($p, 'Arcana_Passive_Overload'), qr/"DisplayName"/, 'the Overload passive exists');
like($lt{'HW_ARCANA_PASSIVE_OVERLOAD_DESC'} // '', qr/Emotional Overload/, 'the passive names the ultimate');
# stage 7: the DEBUG scaffold is retired (everything arrives by the progression); it is archived in 90_ARCHIVE
unlike($p, qr/^new entry "(?:Shout_Arcana_Util_DEBUG_Resonant|RESONANT_DEBUG)"/m, 'the DEBUG scaffold is no longer generated');
none('the DEBUG scaffold is retired from the game', grep { my $n = $_; !grep { $_->[1] eq $n } Alchemy::removals({ $n => 'Spell_Shout' }, {}) } qw(Shout_Arcana_Util_DEBUG_Resonant RESONANT_DEBUG));
my $eo = block($p0, 'Target_Arcana_Created_EmotionalOverload');   # stage 0
like($eo, qr/"UseCosts" "BonusActionPoint:1"
/, 'Emotional Overload: a bonus action, no slot or Thread (R22, R48)');
like($eo, qr/^data "RequirementConditions" "HasStatus\('RESONANT_OVERLOAD_FULL'\)"$/m, 'only while Overloaded: greyed out until then (P8, vanilla HasStatus(\'SG_Rage\'))');
unlike($eo, qr/^data "TargetConditions" "[^"]*RESONANT_OVERLOAD_FULL/m, 'the Overloaded check is not a target condition (P8)');
unlike($eo, qr/"SpellRoll"/, 'no saving throw');
is(scalar(() = $eo =~ /IF\(HasStatus\('FEELING_\w+'\)\):DealDamage\(1d6,Psychic,Magical\)/g), 24, '1d6 Psychic per feeling, all 24');
like($eo, qr/ApplyStatus\(PARALYZED,100,2\)/, 'Paralysed 2 turns (vanilla PARALYZED)');
like($eo, qr/ApplyStatus\(SELF,RESONANT_OVERLOAD_SPENT_TECH,100,0\)/, 'tells Osiris to empty the meter');
my $g = $g0;   # stage 0
is(scalar(() = $g =~ /DB_ARCANA_Resonant_OverloadPoints\("EMOTION_\w+", 1\)/g), 8, '+1 for each of the 8 peaks');
is(scalar(() = $g =~ /DB_ARCANA_Resonant_OverloadPoints\("(?:FEELING_\w+|EMOTION_\w+|CATHARSIS)", 2\)/g), 33, '+2 for 24 feelings, 8 intense, Catharsis');
like($g, qr/DB_ARCANA_Resonant_OverloadMax\(5, 11\).*DB_ARCANA_Resonant_OverloadMax\(20, 20\)/s, 'size by level from 25');
like($g, qr/HasPassive\(_Resonant, "Arcana_Passive_Overload", 1\)/, 'counts only for a Resonant with the passive');
unlike($g, qr/[^\x00-\x7F]/, 'ASCII only');
like($g, qr/\r\n/, 'CRLF, like the other goals');

like($eo, qr/not HasPassive\('ARCANA_IS_SPELL', context\.Source\)/, 'Emotional Overload carries the Arcana spell mark (detonates the Sigil, check_cards)');

# ---- stage 2b: Overload from level 1 (R29, R30)
like($full, qr/"Boosts" "BlockSpellCast\(\);CharacterWeaponDamage\(LevelMapValue\(Overload_WeaponPsychic\),Psychic\)"/, 'Overloaded: silenced, Psychic on weapon hits');
is(scalar(() = $full =~ /DealDamage\(\d,Psychic,Magical\)/g), 6, 'Overloaded hurts from level 1: one bracket per slot level 1-6');
like($full, qr/not ClassLevelHigherOrEqualThan\(3,'Arcana'\)\):DealDamage\(1,Psychic,Magical\)/, 'levels 1-2: 1 Psychic per turn');
my $wl = Alchemy::weapon_levelmap();
like($wl, qr/id="Level4" type="LSString" value="1d6".*id="Level5" type="LSString" value="2d6"/s, 'weapon rider: 1d6 to level 4, 2d6 from 5');
like($wl, qr/id="Level10" type="LSString" value="3d6"/, 'weapon rider: 3d6 from level 10');
like($wl, qr/value="Overload_WeaponPsychic".*value="$Alchemy::WEAPON_MAP_UUID"/s, 'weapon map: name and fixed UUID');
unlike($eo, qr/"SpellFlags" "[^"]*IsSpell/, 'Emotional Overload is not a spell (usable while silenced)');
like($g, qr/DB_ARCANA_Resonant_OverloadMax\(1, 5\).*DB_ARCANA_Resonant_OverloadMax\(3, 8\)/s, 'meter from level 1: 5, then 8 at level 3');
like($g, qr/IntegerProduct\(_Lvl, 6, _Secs\)\r?\nAND\r?\nIntegerToReal\(_Secs, _Dur\)\r?\nTHEN\r?\n(?:[^\r\n]*\r?\n)*?ApplyStatus\(_Resonant, "RESONANT_OVERLOAD_FULL", _Dur, 1, _Resonant\);/, 'Overloaded lasts the character level in turns');
like($g, qr/StatusRemoved\(\(CHARACTER\)_Resonant, "RESONANT_OVERLOAD_FULL", _, _\)\r?\nTHEN\r?\nPROC_ARCANA_Resonant_Overload_Reset\(_Resonant\);/, 'the meter empties when Overloaded ends');

# ---- stage 2c: the meter persists, shows a percentage; visible passives and statuses (Owner rules)
my $ov = block($p, 'RESONANT_OVERLOAD');
unlike($ov, qr/OnCombatEnded/, 'the meter persists between combats');
like($ov, qr/"StatusPropertyFlags" "[^"]*ForceOverhead/, 'the meter shows on the character (ForceOverhead)');
unlike($full, qr/OnCombatEnded/, 'Overloaded runs its course across combats');
like($full, qr/"StatusPropertyFlags" "[^"]*ForceOverhead/, 'Overloaded shows on the character (ForceOverhead)');
none('every visible Resonant passive is Highlighted', grep { block($p, $_) !~ /^data "Properties" "Highlighted"$/m }
    qw(Arcana_Passive_EmotionalAlchemy Arcana_Passive_EmpathicSight Arcana_Passive_ComplexFeelings Arcana_Passive_Overwhelm Arcana_Passive_MixedFeelings Arcana_Passive_Overload));
like($lt0{'HW_RESONANT_OVERLOAD_DESC'} // '', qr/Overloaded.*level 5/s, 'the meter text names Overloaded and when Emotional Overload arrives');
like($lt0{'HW_RESONANT_OVERLOAD_FULL_DESC'} // '', qr/Psychic damage equal to your spell slot level/, 'Overloaded says how much it hurts');
like($lt0{'HW_RESONANT_OVERLOAD_FULL_DESC'} // '', qr/level 5/, 'Overloaded says Emotional Overload needs level 5');
unlike($g, qr/IsInCombat\(_Resonant, 1\)/, 'the meter counts in and out of combat');
unlike($g, qr/LeftCombat/, 'leaving a combat does not empty the meter');
like($g, qr/IntegerProduct\(_N, 100, _N100\)\r?\nAND\r?\nIntegerDivide\(_N100, _Max, _Pct\)/, 'the meter shows the percentage of its maximum');
like($g, qr/_Pct < 1\r?\nTHEN\r?\nPROC_ARCANA_Resonant_Overload_ShowPct\(_Resonant, 1\);/, 'never shows 0 while it holds anything');

# ---- a duplicated field makes the Toolkit drop the rest of the table (2026-10-12: RESONANT_OVERLOAD_SPENT_TECH)
none('no entry repeats a field', map { my ($n, $b) = @$_; my %c; $c{$_}++ for $b =~ /^data "(\w+)"/mg; (grep { $c{$_} > 1 } keys %c) ? $n : () } map { [(/^new entry "([^"]+)"/)[0] // "", $_] } split /\n(?=new entry )/, $p);

# ---- stage 3.0b (R32): the meter always shows, at 0% too
like($g, qr/PROC_ARCANA_Resonant_Overload_ShowEmpty\(\(CHARACTER\)_Resonant\)\r?\nAND\r?\nHasPassive\(_Resonant, "Arcana_Passive_Overload", 1\)\r?\nAND\r?\nNOT DB_ARCANA_Resonant_Overload\(_Resonant, _\)\r?\nAND\r?\nNOT DB_ARCANA_Resonant_OverloadFull\(_Resonant\)\r?\nTHEN\r?\nApplyStatus\(_Resonant, "RESONANT_OVERLOAD", -1\.0, 1, _Resonant\);/, 'an empty meter is a permanent status with no number');
like($g, qr/SavegameLoaded\(\)\r?\nAND\r?\nDB_Players\(_Resonant\)\r?\nTHEN\r?\nPROC_ARCANA_Resonant_Overload_ShowEmpty\(_Resonant\);/, 'every player Resonant shows the meter after a load');
none('the meter also appears on level up, on joining the party and on entering a combat',
    grep { $g !~ /IF\r?\n\Q$_\E\r?\nTHEN\r?\nPROC_ARCANA_Resonant_Overload_ShowEmpty\(_Resonant\);/ } 'LeveledUp(_Resonant)', 'CharacterJoinedParty(_Resonant)', 'EnteredCombat((CHARACTER)_Resonant, _)');
like($g, qr/PROC_ARCANA_Resonant_Overload_Reset\(\(CHARACTER\)_Resonant\)\r?\nTHEN\r?\nRemoveStatus\(_Resonant, "RESONANT_OVERLOAD_FULL", _Resonant\);\r?\nPROC_ARCANA_Resonant_Overload_ShowEmpty\(_Resonant\);/, 'a reset shows the empty meter instead of removing it');

# ---- stage 3.1: Heartstring (cantrip, the Deceiver cantrip's pattern: Malicious Whispers)
my $hs = block($p, 'Target_Arcana_Card_Spell_Heartstring');
like($hs, qr/^data "Level" "0"$/m, 'Heartstring is a cantrip');
like($hs, qr/^data "UseCosts" "ActionPoint:1"$/m, 'Heartstring: an action, no slot');
like($hs, qr/^data "TargetRadius" "18"$/m, 'Heartstring range from 25');
like($hs, qr/^data "SpellRoll" "not SavingThrow\(Ability\.Wisdom, SourceSpellDC\(\)\)"$/m, 'Heartstring: Wisdom save');
like($hs, qr/DealDamage\(LevelMapValue\(D4Cantrip\),Psychic,Magical\)/, 'Heartstring: Psychic that scales like vanilla cantrips');
is(scalar(() = $hs =~ /IF\(HasStatus\('(MOOD_\w+)'\)\):SetStatusDuration\(\1,2,Add\)/g), 8, 'a mood on the target lasts 2 turns longer (vanilla SetStatusDuration ... Add)');

# ---- stage 3.2 (R36): Temper pulls the mood back to its root emotion for 1 turn (Bonus Action only, R34)
my $tp = block($p, 'Target_Arcana_Card_Spell_Temper');
like($tp, qr/^data "UseCosts" "BonusActionPoint:1"$/m, 'Temper costs only the bonus action (R34)');
unlike($tp, qr/ContainerSpells|IsLinkedSpellContainer/, 'Temper is one spell, not a container (R36)');
like($tp, qr/^data "SpellRoll" "SpellAutoResolveOnAlly\(Ability\.Wisdom,SourceSpellDC\(\),true\)"$/m, 'Temper: non-allies roll Wisdom, allies auto-resolve (as the Surges)');
my ($tss) = $tp =~ /^data "SpellSuccess" "([^"]*)"$/m; $tss //= '';
none('Temper: each mood becomes its root emotion for 1 turn', grep { my $e = $_;
    index($tss, "IF(HasStatus('" . Alchemy::mood_id($e) . "')):ApplyStatus(" . Alchemy::peak_id($e) . ',100,1)') < 0 } @W);
none('Temper: the emotion is applied before the mood is spent', grep { my $m = Alchemy::mood_id($_);
    index($tss, "IF(HasStatus('$m')):RemoveStatus($m)") < index($tss, "IF(HasStatus('$m')):ApplyStatus(") } @W);
unlike($tss, qr/FEELING_|CATHARSIS|EMOTION_(?:ECSTASY|ADMIRATION|TERROR|AMAZEMENT|GRIEF|LOATHING|RAGE|VIGILANCE)/, 'Temper never causes a reaction (R7)');
ok(!defined &Alchemy::temper_goal, 'Temper needs no Osiris goal any more');
none('the old Temper sides and their statuses are retired', grep { my $n = $_; !grep { $_->[1] eq $n } Alchemy::removals({ $n => 'Spell_Target' }, {}) }
    qw(Target_Arcana_Card_Spell_Temper_Left Target_Arcana_Card_Spell_Temper_Right RESONANT_TEMPER_LEFT_TECH RESONANT_TEMPER_RIGHT_TECH));

# ---- stage 3.3 (R37): Read the Room is gone -- Empathic Sight already gives Advantage on Insight
unlike($p, qr/^new entry "(?:Shout_Arcana_Util_ReadTheRoom|RESONANT_READ_THE_ROOM)"/m, 'Read the Room is not generated');
none('Read the Room is retired', grep { my $n = $_; !grep { $_->[1] eq $n } Alchemy::removals({ $n => 'Spell_Shout' }, {}) } qw(Shout_Arcana_Util_ReadTheRoom RESONANT_READ_THE_ROOM));

# ---- stage 3.4: Ready: Compassion (the mod's Which One: card -> READY status -> interrupt; Hellish Rebuke's UseSpell)
my $cc = block($p, 'Shout_Arcana_Card_Passive_Compassion');
like($cc, qr/^data "Level" "3"$/m, 'Compassion: a level 3 card (R34)');
like($cc, qr/^data "UseCosts" "SpellSlotsGroup:1:1:3"$/m, 'Compassion: pays a level 3 slot');
like($cc, qr/^data "Requirements" "Combat"$/m, 'Compassion: in combat');
like($cc, qr/^data "RequirementConditions" "not HasStatus\('ARCANA_WEAVING',context\.Source\) and not HasStatus\('COMPASSION_READY',context\.Source\)"$/m, 'Compassion: unique while ready');
like($cc, qr/ApplyStatus\(SELF,COMPASSION_READY,100,-1\)/, 'Compassion: ready until the combat ends');
my $cr = block($p, 'COMPASSION_READY');
like($cr, qr/"Boosts" "UnlockInterrupt\(Interrupt_Arcana_Reaction_Compassion\);ActionResource\(ArcanaReactCompassion,1,0\)"/, 'ready: unlocks the reaction and its one charge (the Which One pattern, stage 6.4)');
like($cr, qr/"RemoveEvents" "OnCombatEnded"/, 'ready: ends with the combat');
my $ci = block($p, 'Interrupt_Arcana_Reaction_Compassion');
like($ci, qr/"InterruptContext" "OnCastHit"\n(?:.*\n)*?data "InterruptContextScope" "Nearby"/, 'Compassion: when a nearby creature is hit');
like($ci, qr/Ally\(context\.Target,context\.Observer\) and not Self\(context\.Target,context\.Observer\).*not DistanceToEntityGreaterThan\(9, context\.ObserverPosition, context\.Target\)/, 'an ally within 9 m (25)');
like($ci, qr/"Conditions" "[^"]*Enemy\(context\.Source,context\.Observer\)/, 'only when an ENEMY hits the ally -- your own Surge on it does not trigger it (vanilla Hellish Rebuke)');
like($ci, qr/"Properties" "UseSpell\(OBSERVER_TARGET,Target_Arcana_Created_CompassionTrust,true,true,true\);ApplyStatus\(OBSERVER_OBSERVER,COMPASSION_USED_TECH,100,0\)"/, 'casts the kind Trust on it (R57); marks the use (the PC deck discards one copy)');
like($ci, qr/"Cost" "ReactionActionPoint:1;ArcanaReactCompassion:1"/, 'once per round: the reaction and the charge');
like($ci, qr/"EnableCondition" "HasActionResource\('ArcanaReactCompassion', 1, 0, false, false, context\.Source\)"/, 'only with a charge (Which One)');
like($ci, qr/"EnableContext" "OnActionResourcesChanged;OnStatusApplied;OnStatusRemoved"/, 'rechecked when charges change (Which One)');
like(block($p, 'COMPASSION_USED_TECH'), qr/"StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"/, 'the use mark is hidden');
like($lt{'HW_SHOUT_ARCANA_CARD_PASSIVE_COMPASSION_DESC'} // '', qr/<LSTag Type="Spell" Tooltip="Target_Arcana_Card_Spell_EmotionTrust">Weave Surge: Trust<\/LSTag>/, 'the card links the Surge as a spell');

# ---- stage 3.5: Emotional Contagion (R33: a mood aura)
my $ec = block($p, 'Target_Arcana_Card_Spell_EmotionalContagion');
like($ec, qr/^data "Level" "3"$/m, 'Contagion: a level 3 card (R34)');
like($ec, qr/^data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:3"$/m, 'Contagion: an action and a level 3 slot');
like($ec, qr/^data "SpellFlags" "[^"]*IsConcentration/m, 'Contagion: Concentration');
unlike($ec, qr/"SpellRoll"/, 'Contagion: no saving throw (R33)');
like($ec, qr/ApplyStatus\(RESONANT_CONTAGION,100,10\)/, 'Contagion: 10 turns from 25');
my $ca = block($p, 'RESONANT_CONTAGION');
like($ca, qr/"AuraRadius" "6"/, 'Contagion: 6 m aura from 25');
is(scalar(() = $ca =~ /IF\(not Self\(\) and Ally\(\) and HasStatus\('(MOOD_\w+)', context\.Source\)\):ApplyStatus\(\1,100,1\)/g), 8, 'the aura copies the bearer\'s mood to its allies only (R35, P11), one branch per mood, renewed each turn');

# ---- stage 3: the new cards carry the card mark; the new shown statuses show on the character
none('new cards carry the card mark', grep { block($p, $_) !~ /not HasPassive\('ARCANA_IS_CARD', context\.Source\)/ }
    qw(Target_Arcana_Card_Spell_Heartstring Target_Arcana_Card_Spell_Temper Target_Arcana_Card_Spell_EmotionalContagion Shout_Arcana_Card_Passive_Compassion));
none('new shown statuses are ForceOverhead', grep { block($p, $_) !~ /"StatusPropertyFlags" "[^"]*ForceOverhead/ } qw(COMPASSION_READY RESONANT_CONTAGION));

# ---- stage 4: Aspect Awakening -- 14 · Temperance (the Empress's frame: ARCANA_Aspect_Common + tier statuses)
my $AW = "HasStatus('ASPECT_AWAKENED_TEMPERANCE', context.Source)";
# 4.3 Tier I: Catharsis +1d8 (25: STA_Resonant_Catharsis#tier1_bonus)
my $jss = Alchemy::spell_success('Joy');
like($jss, qr/\QIF(HasStatus('MOOD_PENSIVE') and not Ally() and not Self() and $AW):DealDamage(1d8,Psychic,Magical)\E/, 'Tier I: Catharsis hurts 1d8 more');
like($jss, qr/\QIF(HasStatus('MOOD_PENSIVE') and (Ally() or Self()) and $AW):RegainHitPoints(1d8)\E/, 'Tier I: Catharsis heals 1d8 more');
# 4.4 Tier I: the moods you create last 2 turns longer (25: FEAT_Resonant_AspectAwakening#tier1_mood_extend)
none('Tier I: every peak leaves its mood 2 turns longer once awakened (not after a Temper replay, R49)', map { my $e = $_; my $m = Alchemy::mood_id($e);
    grep { block($p, $_) !~ /\QIF(RemoveCause(StatusRemoveCause.TimeOut) and not HasStatus('RESONANT_REPLAY') and not $AW):ApplyStatus($m,100,5);IF(RemoveCause(StatusRemoveCause.TimeOut) and not HasStatus('RESONANT_REPLAY') and $AW):ApplyStatus($m,100,7)\E/ }
    Alchemy::peak_id($e) } @W);
# 4.2 tier statuses and passives
my $awk = block($p, 'ASPECT_AWAKENED_TEMPERANCE');
like($awk, qr/"Boosts" "UnlockSpell\(Shout_Arcana_Created_Aspect_TwoCups\)"/, 'Tier I unlocks The Two Cups');
like($awk, qr/"OnRemoveFunctors" "RemoveStatus\(ASPECT_AWAKENED_TEMPERANCE_I\);RemoveStatus\(ASPECT_AWAKENED_TEMPERANCE_II\);RemoveStatus\(ASPECT_AWAKENED_TEMPERANCE_III\)"/, 'the awakening takes its tiers with it');
like($awk, qr/"RemoveEvents" "OnCombatEnded"/, 'the awakening ends with the combat');
none('tier statuses: one StackId, priority by tier, shown, end with the combat', grep { my ($t, $n) = @$_; my $b = block($p, "ASPECT_AWAKENED_TEMPERANCE_$t");
    $b !~ /"StackId" "ASPECT_AWAKENED_TEMPERANCE_TIER"/ || $b !~ /"StackPriority" "$n"/ || $b !~ /"StatusPropertyFlags" "[^"]*ForceOverhead/ || $b !~ /"RemoveEvents" "OnCombatEnded"/ } [I => 1], [II => 2], [III => 3]);
like(block($p, 'ASPECT_PROGRESS_TEMPERANCE'), qr/"StatusPropertyFlags" "FreezeDuration;IgnoreResting;ForceOverhead"/, 'progress: a frozen count');
none('tier passives are hidden', grep { block($p, "Arcana_Passive_Aspect_Temperance_$_") !~ /"Properties" "IsHidden"/ } qw(I II III));
like(block($p, 'Arcana_Passive_Aspect_Temperance_Awakening'), qr/"Properties" "Highlighted"/, 'the Awakening passive is shown');
like($lt{'HW_ARCANA_PASSIVE_ASPECT_TEMPERANCE_AWAKENING_DESC'} // '', qr/Level 3: cause 3 reactions.*Level 7: cause 6 reactions.*Level 12: cause 15 reactions/s, 'the Awakening passive names the goals from 25');
like($lt{'HW_ASPECT_AWAKENED_TEMPERANCE_III_DESC'} // '', qr/Resonance:.*Harmony:.*Aspect of Empathy:/s, 'tier III lists every bonus');
# 4.5 The Two Cups (R38: not CATHARSIS, so the Overload ignores it)
my $tc = block($p, 'Shout_Arcana_Created_Aspect_TwoCups');
like($tc, qr/"Cooldown" "OncePerCombat"/, 'Two Cups: once per combat');
like($tc, qr/"AreaRadius" "18"/, 'Two Cups: 18 m from 25');
like($tc, qr/"UseCosts" "ActionPoint:1"\n/, 'Two Cups: an action, no slot');
like($tc, qr/"Requirements" "Combat"/, 'Two Cups: in combat');
like($tc, qr/not HasPassive\('ARCANA_IS_CARD', context\.Source\)/, 'Two Cups: card mark');
like($tc, qr/\QIF(not Ally() and not Self()):DealDamage(LevelMapValue(Catharsis_Damage),Psychic,Magical);IF(not Ally() and not Self()):DealDamage(1d8,Psychic,Magical);IF(Ally() or Self()):RegainHitPoints(LevelMapValue(Catharsis_Damage));IF(Ally() or Self()):RegainHitPoints(1d8);ApplyStatus(RESONANT_TWO_CUPS_CATHARSIS,100,0)\E/, 'Two Cups: a Catharsis with the Tier I bonus');
unlike($tc, qr/ApplyStatus\(CATHARSIS,/, 'Two Cups does not apply CATHARSIS (R38)');
is(scalar(() = block($p, 'RESONANT_TWO_CUPS_CATHARSIS') =~ /RemoveStatus\(MOOD_\w+\)/g), 8, 'the Two Cups Catharsis spends every mood');
unlike($g, qr/RESONANT_TWO_CUPS_CATHARSIS/, 'the Overload ignores The Two Cups (R38)');
# 4.1 the goal and the Common rows
my $ag = $ag0;   # stage 0
is(scalar(() = $ag =~ /DB_ARCANA_Resonant_AwakeningStatus\("[A-Z_]+"\);/g), 34, 'Awakening: 24 feelings, 8 intense, Catharsis, Two Cups Catharsis');
like($ag, qr/StatusApplied\(_Target, _Status, \(CHARACTER\)_Resonant, _\)\r?\nAND\r?\nDB_ARCANA_Resonant_AwakeningStatus\(_Status\)\r?\nAND\r?\nHasPassive\(_Resonant, "Arcana_Passive_Aspect_Temperance_Awakening", 1\)\r?\nTHEN\r?\nPROC_ARCANA_Aspect_Step\(_Resonant, "TEMPERANCE"\);/, 'each reaction is one step');
my $cr4 = Alchemy::common_rows();
like($cr4, qr/DB_ARCANA_Aspect\("TEMPERANCE", "ASPECT_PROGRESS_TEMPERANCE", "ASPECT_AWAKENED_TEMPERANCE", "Arcana_Passive_Aspect_Temperance_I"\);/, 'Common: the aspect row');
like($cr4, qr/"TEMPERANCE", 1, "Arcana_Passive_Aspect_Temperance_I", "ASPECT_AWAKENED_TEMPERANCE_I", 3\).*"TEMPERANCE", 2, .*, 6\).*"TEMPERANCE", 3, .*, 15\)/s, 'Common: goals 3 / 6 / 15 from 25');
like($cr4, qr/DB_ARCANA_AspectShow\("TEMPERANCE", "COUNT"\);/, 'Common: shown as a count');
# 4.6 Tier II, R40: feelings last 2 turns longer; once per turn a Weave Surge costs no action (the Fool's Zephyr pattern)
my $T2 = "HasStatus('RESONANT_TIER2', context.Source)";   # short on purpose: it repeats 12 times per Surge
my $t2s = block($p, 'RESONANT_TIER2');
like($t2s, qr/"StatusPropertyFlags" "IgnoreResting;DisableOverhead;DisableCombatlog;DisablePortraitIndicator"/, 'Tier II marker: hidden');
like($t2s, qr/"RemoveEvents" "OnCombatEnded"/, 'Tier II marker: ends with the combat');
like($ag, qr/_Tier == 2\r?\nTHEN\r?\nApplyStatus\(_Resonant, "RESONANT_SURGE_FREE", 6\.0, 1, _Resonant\);\r?\nApplyStatus\(_Resonant, "RESONANT_TIER2", -1\.0, 1, _Resonant\);/, 'Tier II marker: applied on reaching Tier II');
like($ag, qr/RemoveStatus\(_Char, "RESONANT_TIER2", _Char\);/, 'Tier II marker: removed when the combat ends');
like($jss, qr/\QIF(HasStatus('MOOD_ACCEPTING') and not $T2):ApplyStatus(FEELING_LOVE,100,2);IF(HasStatus('MOOD_ACCEPTING') and $T2):ApplyStatus(FEELING_LOVE,100,4)\E/, 'Tier II: a feeling lasts 2 turns longer');
none('Tier II: every feeling branch of every Surge has both durations', map { my $s = Alchemy::spell_success($_); my $n = () = $s =~ /\Q and not $T2):ApplyStatus(FEELING_\E/g; my $m = () = $s =~ /\Q and $T2):ApplyStatus(FEELING_\E/g; ($n == $m && $n > 0) ? () : $_ } @W);
unlike($ag, qr/HarmonyMood|HarmonyBest|LastSurge|Harmonized/, 'the old Harmony (nearest creature gains a mood) is gone (R40)');
is(scalar(() = $ag =~ /DB_ARCANA_Resonant_SurgeRoot\("Target_Arcana_Card_Spell_Emotion\w+", "[A-Z]+"\);/g), 8, 'the 8 Surges by card (variants through DB_ARCANA_CardFamily)');
like($ag, qr/PROC_ARCANA_Aspect_OnTier\(\(CHARACTER\)_Resonant, \(STRING\)_Aspect, \(INTEGER\)_Tier\)\r?\nAND\r?\n_Aspect == "TEMPERANCE"\r?\nAND\r?\n_Tier == 2\r?\nTHEN\r?\nApplyStatus\(_Resonant, "RESONANT_SURGE_FREE", 6\.0, 1, _Resonant\);/, 'Tier II: the free Surge on awakening');
like($ag, qr/TurnStarted\(\(CHARACTER\)_Resonant\)\r?\nAND\r?\nDB_ARCANA_AspectReached\(_Resonant, 2\)\r?\nTHEN\r?\nApplyStatus\(_Resonant, "RESONANT_SURGE_FREE", 6\.0, 1, _Resonant\);/, 'Tier II: a free Surge every turn');
like($ag, qr/CastedSpell\(\(CHARACTER\)_Resonant, _Spell, _, _, _\)\r?\nAND\r?\nDB_ARCANA_CardFamily\(_Spell, _Root\)\r?\nAND\r?\nDB_ARCANA_Resonant_SurgeRoot\(_Root, _\)\r?\nAND\r?\nHasActiveStatus\(_Resonant, "RESONANT_SURGE_FREE", 1\)\r?\nTHEN\r?\nRemoveStatus\(_Resonant, "RESONANT_SURGE_FREE", _Resonant\);/, 'Tier II: spent by the first Surge');
like($ag, qr/PROC_ARCANA_Aspect_Reset\(\(CHARACTER\)_Char\)\r?\nTHEN\r?\nRemoveStatus\(_Char, "RESONANT_SURGE_FREE", _Char\);/, 'leaving the combat removes the free Surge');
my $sf = block($p, 'RESONANT_SURGE_FREE');
like($sf, qr/"Boosts" "UnlockSpellVariant\(IsWeaveSurge\(\),ModifyUseCosts\(Replace,ActionPoint,0,0,ActionPoint\),ModifyIconGlow\(\),ModifyTooltipDescription\(\)\)"/, 'free Surge: no action (vanilla Extra Attack variant)');
like($sf, qr/"TickType" "EndTurn"/, 'free Surge: one turn');
like($sf, qr/"RemoveEvents" "OnCombatEnded"/, 'free Surge: ends with the combat');
# the Khonsu helper: every Surge, variants included, by a marker in the conditions (the IsCardSpell pattern)
like(Alchemy::weave_surge_khn(), qr/^function IsWeaveSurge\(\)\s+return HasStringInSpellConditions\('ARCANA_IS_SURGE'\)\s+end/m, 'IsWeaveSurge(): the marker');
none('every Surge carries the Surge marker', grep { block($p, Alchemy::spell_id($_)) !~ /not HasPassive\('ARCANA_IS_SURGE', context\.Source\)/ } @W);
none('nothing else carries the Surge marker', grep { !/^Target_Arcana_Card_Spell_Emotion(?:Joy|Trust|Fear|Surprise|Sadness|Disgust|Anger|Anticipation)$/ } grep { block($p, $_) =~ /ARCANA_IS_SURGE/ } @entries);
like($lt{'HW_ASPECT_AWAKENED_TEMPERANCE_II_DESC'} // '', qr/Harmony: Feelings you braid last 2 turns longer\. Once per turn, a Weave Surge costs no action, and the emotion it leaves brings its mood at once\./, 'Tier II text (R42)');
# R42: the free Surge leaves its mood at once, on every target (P25: a single Osiris mark covered only one of an
# upcast Surge's targets). In the peak's own OnApplyFunctors: the free Surge is still on the caster while the spell
# resolves on all its targets; Osiris removes it only after the cast.
none('R42: every peak brings its mood at once while the caster has the free Surge (7 turns: Tier I +2)', grep { my $m = Alchemy::mood_id($_);
    block($p, Alchemy::peak_id($_)) !~ /^data "OnApplyFunctors" "[^"]*\QIF(HasStatus('RESONANT_SURGE_FREE', context.Source)):ApplyStatus($m,100,7)\E/m } @W);
like(block($p, 'EMOTION_SURPRISE'), qr/^data "OnApplyFunctors" "ApplyStatus\(RESONANT_SURPRISE_OPENING,100,1\);IF\(HasStatus\('RESONANT_SURGE_FREE'/m, 'R42 keeps a peak\'s own OnApply (Surprise)');
none('R42 is only on the peaks, not on the intense emotions', grep { block($p, Alchemy::intense_id($_)) =~ /RESONANT_SURGE_FREE/ } @W);
unlike($ag, qr/DB_ARCANA_Resonant_Echo|DB_ARCANA_Resonant_PeakMood/, 'R42: no Osiris mark any more');
# R41: a Surge can target any creature; the player decides
none('Surges target any creature (R41)', grep { block($p, Alchemy::spell_id($_)) =~ /^data "TargetConditions" "[^"]*(?:Ally\(\)|HasStatus\('MOOD_)/m } @W);
# 4.7 Tier III
like($ag, qr/UsingSpellOnTarget\(\(CHARACTER\)_Resonant, \(CHARACTER\)_Target, _Spell, _, _, _\)\r?\nAND\r?\nDB_ARCANA_CardFamily\(_Spell, "Target_Arcana_Created_EmotionalOverload"\)\r?\nAND\r?\nDB_ARCANA_AspectReached\(_Resonant, 3\)/, 'Tier III: Emotional Overload from Tier III (by card family, the check_cards rule)');
unlike($ag, qr/UsingSpellOnTarget\([^\r\n]*"Target_/, 'no card name compared in an event (check_cards)');
like($ag, qr/IsEnemy\(_Resonant, _Cand, 1\)/, 'Tier III: enemies only');
like($ag, qr/ApplyStatus\(_Cand, "PARALYZED", 6\.0, 1, _Resonant\);/, 'Tier III: the others are Paralysed 1 turn');
is(scalar(() = $ag =~ /DB_ARCANA_Resonant_Feeling\("FEELING_\w+"\);/g), 24, 'Tier III: the 24 feelings');
unlike($ag, qr/[^\x00-\x7F]/, 'Temperance goal: ASCII only');
like($ag, qr/\r\n/, 'Temperance goal: CRLF');

# ---- stage 5: Shared Heart, the capstone (R18, R19, R24, R43, R44)
my $sh = block($p, 'Shout_Arcana_Card_Spell_SharedHeart');
like($sh, qr/^data "Level" "5"$/m, 'Shared Heart: a level 5 card (R43)');
like($sh, qr/^data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:5"$/m, 'Shared Heart: an action and a level 5 slot');
like($sh, qr/^data "Cooldown" "OncePerRest"$/m, 'Shared Heart: once per long rest (Grand Deception)');
like($sh, qr/^data "AreaRadius" "18"$/m, 'Shared Heart: 18 m from 25');
like($sh, qr/^data "Requirements" "Combat"$/m, 'Shared Heart: in combat');
like($sh, qr/^data "TargetConditions" "\(Ally\(\) or Self\(\)\) and Character\(\) and not Dead\(\) and not HasPassive\('ARCANA_IS_CARD', context\.Source\)"$/m, 'Shared Heart: you and your allies; card mark');
like($sh, qr/ApplyStatus\(SHARED_HEART,100,-1\)/, 'Shared Heart: linked until the combat ends');
my $shs = block($p, 'SHARED_HEART');
like($shs, qr/"RemoveEvents" "OnCombatEnded"/, 'the link ends with the combat');
like($shs, qr/"StatusPropertyFlags" "[^"]*ForceOverhead/, 'the link is shown');
my $shc = block($p, 'RESONANT_SHARED_CATHARSIS');
like($shc, qr/"OnApplyFunctors" "RegainHitPoints\(LevelMapValue\(Catharsis_Damage\)\);RemoveStatus\(MOOD_/, 'shared Catharsis: heals, then spends the moods (R44)');
is(scalar(() = $shc =~ /RemoveStatus\(MOOD_\w+\)/g), 8, 'shared Catharsis: every mood');
# R46: the free Surge on linked allies (R24) is gone
unlike($p, qr/^new entry "RESONANT_SHARED_REFUND_TECH"/m, 'R46: no free-Surge refund any more');
ok((grep { $_->[1] eq 'RESONANT_SHARED_REFUND_TECH' } Alchemy::removals({ RESONANT_SHARED_REFUND_TECH => 'Status_BOOST' }, {})) ? 1 : 0, 'R46: the free-Surge refund is retired from the game');
my $hg = Alchemy::shared_heart_goal();
is(scalar(() = $hg =~ /DB_ARCANA_Resonant_SharedResult\("(?:EMOTION|FEELING)_\w+"\);/g), scalar(grep { $_->{kind} eq 'A' } values %Alchemy::FEELING), 'R46/R57: only the helpful feelings are copied');
unlike($hg, qr/DB_ARCANA_Resonant_SharedResult\("EMOTION_/, 'R46: no peak or intense emotion is copied');
like($hg, qr/StatusApplied\(\(CHARACTER\)_Target, _Status, \(CHARACTER\)_Resonant, _\)\r?\nAND\r?\nDB_ARCANA_Resonant_SharedResult\(_Status\)\r?\nAND\r?\nHasPassive\(_Resonant, "Arcana_Passive_EmotionalAlchemy", 1\)\r?\nAND\r?\nHasActiveStatus\(_Target, "SHARED_HEART", 1\)/, 'a Resonant\'s Surge result on a linked creature');
like($hg, qr/ApplyStatus\(_Other, _Status, _Dur, 1, _Target\);/, 'the copy\'s source is the linked target: counted once, never copied again (R19)');
like($hg, qr/GetStatusTurns\(_Target, _Status, _Turns\)/, 'the copy keeps the turns');
like($hg, qr/ApplyStatus\(_Other, "RESONANT_SHARED_CATHARSIS", 0\.0, 1, _Target\);/, 'a Catharsis heals every other linked creature (R44)');
unlike($hg, qr/SharedRefunded|RESONANT_SHARED_REFUND_TECH/, 'R46: no free Surge on linked allies');
unlike($og, qr/SHARED_HEART/, 'R46: the reaction refund treats a linked target as any other');
# R47: a feeling braided again in the fight adds its turns (vanilla StackType Additive, RAGE_FRENZY_BURNOUT)
none('R47: every feeling is Additive', grep { block($p, 'FEELING_' . uc $Alchemy::FEELING{$_}{name}) !~ /^data "StackType" "Additive"$/m } keys %Alchemy::FEELING);
like($lt{'HW_SHOUT_ARCANA_CARD_SPELL_SHAREDHEART_DESC'} // '', qr/feeling/, 'Shared Heart text names the feelings (R46)');
unlike($lt{'HW_SHOUT_ARCANA_CARD_SPELL_SHAREDHEART_DESC'} // '', qr/costs nothing/, 'Shared Heart text no longer promises free Surges');
unlike($hg, qr/[^\x00-\x7F]/, 'Shared Heart goal: ASCII only');
like($hg, qr/\r\n/, 'Shared Heart goal: CRLF');

# ==== ARC-0017 stage 1 -- moods and loops (R49, R50, R57)
# R49: using a mood spends it; only an emotion that fades on its own leaves a mood
none('R49: an intense emotion leaves nothing when it ends', grep { block($p, Alchemy::intense_id($_)) =~ /^data "OnRemoveFunctors"/m } @W);
none("R49: a peak's fade skips the mood after a Temper replay, then clears the marker", grep {
    block($p, Alchemy::peak_id($_)) !~ /^data "OnRemoveFunctors" "IF\(RemoveCause\(StatusRemoveCause\.TimeOut\) and not HasStatus\('RESONANT_REPLAY'\)[^"]*ApplyStatus\(MOOD_[^"]*;RemoveStatus\(RESONANT_REPLAY\)"$/m } @W);
my $t17 = block($p, 'Target_Arcana_Card_Spell_Temper');
like($t17, qr/^data "SpellSuccess" "ApplyStatus\(RESONANT_REPLAY,100,2\);/m, 'R49: Temper marks the replay before the emotion');
like(block($p, 'RESONANT_REPLAY'), qr/DisableOverhead/, 'R49: the replay marker is hidden');
like($lt{HW_TARGET_ARCANA_CARD_SPELL_TEMPER_DESC} // '', qr/^Spend a creature's mood .*leaves nothing/, "R49: Temper's text says the mood is spent");
# R50: excess once per fight
like(block($p, 'RESONANT_EXCESS_SPENT'), qr/^data "RemoveEvents" "OnCombatEnded"$/m, 'R50: the excess marker clears at combat end');
none('R50: every intense emotion marks its creature', grep { block($p, Alchemy::intense_id($_)) !~ /ApplyStatus\(RESONANT_EXCESS_SPENT,100,-1\)/ } @W);
none('R50: Intensify only on a creature that has not felt its excess', grep { my $s = $_;
    Alchemy::spell_success($s) !~ /IF\(HasStatus\('${\Alchemy::mood_id($s)}'\) and HasPassive\('Arcana_Passive_Overwhelm', context\.Source\) and not HasStatus\('RESONANT_EXCESS_SPENT'\)\):ApplyStatus\(${\Alchemy::intense_id($s)},100,1\)/ } @W);
# R57: automatic effects never braid a hindering feeling on an ally
my @hind = grep { my $r = Alchemy::reaction('Trust', $_); $r->{kind} eq 'feeling' && Alchemy::feeling_of('Trust', $_)->{kind} eq 'I' } @W;
is_deeply(\@hind, ['Fear'], 'R57: Trust braids one hindering feeling (on Apprehensive: Submission)');
like(block($p, 'Interrupt_Arcana_Reaction_Compassion'), qr/UseSpell\(OBSERVER_TARGET,Target_Arcana_Created_CompassionTrust,true,true,true\)/, 'R57: Compassion casts its kind Trust');
my $ct = block($p, 'Target_Arcana_Created_CompassionTrust');
like($ct, qr/^using "Target_Arcana_Card_Spell_EmotionTrust"$/m, "R57: the kind Trust inherits the Surge");
unlike($ct, qr/FEELING_SUBMISSION|'MOOD_APPREHENSIVE'/, 'R57: the kind Trust never braids Submission; on Apprehensive it lands as a peak');
like($ct, qr/ApplyStatus\(FEELING_LOVE,/, 'R57: the kind Trust still braids Love');
my $hg17 = Alchemy::shared_heart_goal();
none('R57: Shared Heart copies only helpful feelings', grep { my $k = $_; $Alchemy::FEELING{$k}{kind} eq 'I' && $hg17 =~ /"FEELING_\U$Alchemy::FEELING{$k}{name}\E"/ } keys %Alchemy::FEELING);
like($hg17, qr/"FEELING_LOVE"/, 'R57: Shared Heart still copies Love');
# the stage switch: stage 0 is today's game
{ local $Alchemy::STAGE = 0; my $p0 = Alchemy::build_engine_patch();
  unlike($p0, qr/RESONANT_EXCESS_SPENT|RESONANT_REPLAY|CompassionTrust/, 'ARC17_STAGE=0 writes the game of today'); }

# ==== ARC-0017 stage 2 -- the Overload (R51-R53, R56, R66-R68)
my $full17 = block($p, 'RESONANT_OVERLOAD_FULL');
unlike($full17, qr/BlockSpellCast|CharacterWeaponDamage/, 'R51: Overloaded neither silences nor adds a weapon rider');
like($full17, qr/IF\(not ClassLevelHigherOrEqualThan\(5,'Arcana'\)\):DealDamage\(1d4,Psychic,Magical\);IF\(ClassLevelHigherOrEqualThan\(5,'Arcana'\) and not ClassLevelHigherOrEqualThan\(9,'Arcana'\)\):DealDamage\(2d4,Psychic,Magical\);IF\(ClassLevelHigherOrEqualThan\(9,'Arcana'\)\):DealDamage\(3d4,Psychic,Magical\)/,
    'R51/R67: Psychic each turn 1d4 / 2d4 from 5 / 3d4 from 9 (25 overloaded_tick_next)');
like($full17, qr/^data "OnApplyFunctors" "IF\(not ClassLevelHigherOrEqualThan\(5,'Arcana'\)\):ApplyStatus\(RESONANT_OVERLOADED_MIND_1,100,-1\);.*ApplyStatus\(RESONANT_OVERLOADED_MIND_9,100,-1\)"$/m, 'R52: the mind penalty by band, applied with the state');
like($full17, qr/^data "OnRemoveFunctors" "RemoveStatus\(RESONANT_OVERLOADED_MIND_1\);RemoveStatus\(RESONANT_OVERLOADED_MIND_5\);RemoveStatus\(RESONANT_OVERLOADED_MIND_9\)"$/m, 'R52: and removed with it');
for my $b ([1, -1], [5, -2], [9, -3]) { my ($l, $n) = @$b;
    like(block($p, "RESONANT_OVERLOADED_MIND_$l"), qr/"Boosts" "RollBonus\(SavingThrow,$n,Intelligence\);RollBonus\(SavingThrow,$n,Wisdom\);RollBonus\(SavingThrow,$n,Charisma\)"/, "R52: band $l, $n to mental saves (flat)") }
like($lt{HW_RESONANT_OVERLOAD_FULL_DESC} // '', qr/Intelligence, Wisdom and Charisma/, "R51: Overloaded's text names the mental saves");
unlike($lt{HW_RESONANT_OVERLOAD_FULL_DESC} // '', qr/can't cast spells/, "R51: and no silence");
my $og17 = Alchemy::overload_goal();
like($og17, qr/HasActiveStatus\(_Resonant, "RESONANT_OVERLOAD_FULL", 1\)\r?\nAND\r?\nIsEnemy\(_Resonant, _Target, 1\)\r?\nAND\r?\nNOT DB_ARCANA_Resonant_RiderUsed\(_Resonant\)/, 'R51: the Surge rider -- Overloaded, an enemy, not yet this turn');
like($og17, qr/THEN\r?\nDB_ARCANA_Resonant_RiderUsed\(_Resonant\);\r?\nApplyStatus\(_Target, _Tech, 0\.0, 1, _Resonant\);/, 'R51: the rider marks its turn at once (a DB: a multi-target Surge sees it)');
like($og17, qr/TurnStarted\(\(CHARACTER\)_Resonant\)\r?\nAND\r?\nDB_ARCANA_Resonant_RiderUsed\(_Resonant\)\r?\nTHEN\r?\nNOT DB_ARCANA_Resonant_RiderUsed\(_Resonant\);/, 'R51: the rider guard clears at the turn start');
for my $b ([1, '1d4'], [5, '2d4'], [9, '3d4']) { my ($l, $d) = @$b;
    like(block($p, "RESONANT_RIDER_TECH_$l"), qr/"OnApplyFunctors" "DealDamage\($d,Psychic,Magical\)"/, "R51: rider band $l deals $d") }
like($og17, qr/LeftCombat\(\(CHARACTER\)_Resonant, _\)/, 'R53: the end of a fight settles the meter');
like($og17, qr/IntegerDivide\(_N, 2, _Half\)/, 'R53: to half');
like($og17, qr/StatusRemoved\(\(CHARACTER\)_Resonant, "RESONANT_OVERLOAD_FULL", _, _\)\r?\nAND\r?\nNOT DB_ARCANA_Resonant_Settling\(_Resonant\)\r?\nTHEN\r?\nPROC_ARCANA_Resonant_Overload_Reset/, 'R53: settling a full meter does not empty it');
my $ag17 = Alchemy::temperance_goal();
like($ag17, qr/_Tier == 3\r?\nAND\r?\nNOT DB_ARCANA_Resonant_OverloadFull\(_Resonant\)\r?\nTHEN\r?\nPROC_ARCANA_Resonant_Overload_Fill\(_Resonant\);/, 'R56: waking Tier III fills the meter');
like($og17, qr/PROC_ARCANA_Resonant_Overload_Fill\(\(CHARACTER\)_Resonant\)\r?\nAND\r?\nGetLevel\(_Resonant, _Lvl\)\r?\nAND\r?\nDB_ARCANA_Resonant_OverloadMax\(_Lvl, _Max\)\r?\nTHEN\r?\nPROC_ARCANA_Resonant_Overload_Add\(_Resonant, _Max\);/, 'R56: through the usual path');
unlike($ag17, qr/PARALYZED|WaveCollect/, 'R68/R67: no Osiris paralysis wave any more (the area is rank III)');
my $eo17 = block($p, 'Target_Arcana_Created_EmotionalOverload');
like($eo17, qr/^data "Level" "1"$/m, 'R66: a level-1 slot spell');
like($eo17, qr/^data "UseCosts" "BonusActionPoint:1;SpellSlotsGroup:1:1:1"$/m, 'R66: pays a slot (made free by the passive)');
like($eo17, qr/^data "SpellRoll" "not SavingThrow\(Ability\.Wisdom, SourceSpellDC\(\)\)"$/m, 'R51: a Wisdom save');
like($eo17, qr/^data "SpellSuccess" "[^"]*ApplyStatus\(IRRESISTIBLE_DANCE,100,1\)/m, 'R68: a failed save dances 1 turn');
like($eo17, qr/IF\(HasStatus\('ASPECT_AWAKENED_TEMPERANCE_III', context\.Source\)\):ApplyStatus\(IRRESISTIBLE_DANCE,100,2\)/, 'R68: 2 turns at Tier III');
like($eo17, qr/^data "SpellFail" "[^"]*IF\(HasStatus\('FEELING_LOVE'\)\):DealDamage\(\(1d6\)\/2,Psychic,Magical\)/m, 'R51: a made save takes half (vanilla (XdY)/2)');
unlike($eo17, qr/^data "SpellFail" "[^"]*IRRESISTIBLE_DANCE/m, 'R51: no dance on a made save');
like($eo17, qr/^data "SpellSuccess" "[^"]*ApplyStatus\(RESONANT_FATIGUE_TECH,100,0\)/m, 'R51: Mental Fatigue either way (marker, Osiris sets its duration) -- fail');
like($eo17, qr/^data "SpellFail" "[^"]*ApplyStatus\(RESONANT_FATIGUE_TECH,100,0\)/m, '... and on a made save');
unlike($eo17, qr/PARALYZED/, 'R68: no paralysis');
like($eo17, qr/^data "Icon" "Spell_IntellectDevourer_SynapticDischarge"$/m, 'R51: the Synaptic Discharge icon');
like($og17, qr/StatusApplied\(\(CHARACTER\)_Target, "RESONANT_FATIGUE_TECH", \(CHARACTER\)_Resonant, _\)\r?\nAND\r?\nGetLevel\(_Resonant, _Lvl\)/, 'R51: Osiris applies Mental Fatigue for the level');
like($og17, qr/ApplyStatus\(_Target, "MAG_PSYCHIC_MENTAL_FATIGUE", _Dur, 1, _Resonant\);\r?\nApplyStatus\(_Target, "MAG_PSYCHIC_MENTAL_FATIGUE_DURATION_TECHNICAL", 6\.0, 1, _Resonant\);/, 'R51: the vanilla status and its duration cap');
my $free = block($p, 'Arcana_Passive_Overload');   # the free cast rides on the Overload passive: no new progression row
like($free, qr/"Boosts" "UnlockSpellVariant\(SpellId\('Target_Arcana_Created_EmotionalOverload'\) or SpellId\('Target_Arcana_Created_EmotionalOverload_2'\) or SpellId\('Target_Arcana_Created_EmotionalOverload_3'\) or SpellId\('Target_Arcana_Created_EmotionalOverload_4'\) or SpellId\('Target_Arcana_Created_EmotionalOverload_5'\) or SpellId\('Target_Arcana_Created_EmotionalOverload_6'\),ModifyUseCosts\(Replace,ArcanaSpellSlot,0,-1,ArcanaSpellSlot\),ModifyUseCosts\(Replace,SpellSlotsGroup,0,-1,SpellSlotsGroup\)\)"/, 'R66: the free cast (DEBUG_INFINITE_SPELLS pattern)');
unlike($free, qr/ModifyTooltipDescription/, 'R66: no tooltip change');
like($free, qr/"Properties" "Highlighted"/, 'R66: the Overload passive stays visible');
my ($up17) = Alchemy::build_upcast_patch({ map { ("Target_Arcana_Created_EmotionalOverload_$_" => 'Spell_Target') } 2 .. 6 });
like($up17, qr/\@set Target_Arcana_Created_EmotionalOverload_2 AmountOfTargets 1\n\@set Target_Arcana_Created_EmotionalOverload_3 AmountOfTargets 2\n\@set Target_Arcana_Created_EmotionalOverload_4 AmountOfTargets 2\n/, 'R67: ranks I (slots 1-2) and II (3-4)');
like($up17, qr/\@set Target_Arcana_Created_EmotionalOverload_5 AreaRadius 9\n/, 'R51/R67: rank III, the area from slot 5 (probe B5)');
like($lt{HW_ARCANA_PASSIVE_ASPECT_TEMPERANCE_III_DESC} // $lt{HW_ARCANA_PASSIVE_ASPECT_TEMPERANCE_III_DESC} // '', qr/Overload fills at once/, 'R56/R68: the Tier III text');

# ==== ARC-0017 stage 3 -- the Weave Surge container (R54; the Hemoplague pattern)
my $ws = block($p, 'Target_Arcana_Card_Spell_WeaveSurge');
like($ws, qr/^data "ContainerSpells" "\Q${\join(';', map { Alchemy::spell_id($_) } @W)}\E"$/m, 'R54: the container holds the eight emotions, in wheel order');
like($ws, qr/^data "SpellFlags" "[^"]*IsLinkedSpellContainer/m, 'R54: a linked spell container (Hemoplague)');
like($ws, qr/^data "UseCosts" "ActionPoint:1;SpellSlotsGroup:1:1:1"$/m, 'R54: the container costs what an emotion costs');
is($lt{HW_TARGET_ARCANA_CARD_SPELL_WEAVESURGE_NAME}, 'Weave Surge', 'R54: named Weave Surge');
none('R54: each emotion points to the container and holds none', grep { my $b = block($p, Alchemy::spell_id($_));
    $b !~ /^data "SpellContainerID" "Target_Arcana_Card_Spell_WeaveSurge"$/m || $b !~ /^data "ContainerSpells" ""$/m } @W);
none('R54: each emotion is named by its emotion alone', grep { ($lt{ Alchemy::key(Alchemy::spell_id($_), 'NAME') } // '') ne $_ } @W);
my %unlock = (Joy => 1, Trust => 1, Fear => 1, Anticipation => 2, Surprise => 3, Sadness => 3, Disgust => 5, Anger => 5);
none('R54/R59: an emotion opens at the level the Resonant learns it (probe B6)', grep { my $b = block($p, Alchemy::spell_id($_)); my $l = $unlock{$_};
    $l == 1 ? $b =~ /RequirementConditions/ : $b !~ /^data "RequirementConditions" "ClassLevelHigherOrEqualThan\($l,'Arcana'\)"$/m } @W);
{ local $Alchemy::STAGE = 2; unlike(Alchemy::build_engine_patch(), qr/Target_Arcana_Card_Spell_WeaveSurge/, 'stage 2 has no container yet'); }

done_testing();
