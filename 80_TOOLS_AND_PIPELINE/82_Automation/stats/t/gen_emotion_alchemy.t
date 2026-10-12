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
like($ss, qr/IF\(HasStatus\('MOOD_SERENE'\) and HasPassive\('Arcana_Passive_ComplexFeelings', context\.Source\)\):ApplyStatus\(FEELING_GUILT,100,2\)/, 'a gated reaction');
like($ss, qr/DealDamage\(LevelMapValue\(Catharsis_Damage\),Psychic,Magical\).*RegainHitPoints\(LevelMapValue\(Catharsis_Damage\)\).*ApplyStatus\(CATHARSIS,100,0\)$/, 'Catharsis harms, heals, then clears the moods last');
none('each Surge: 1 base case + 7 reactions + 3 Catharsis functors', grep { (() = Alchemy::spell_success($_) =~ /IF\(/g) != 12 } @W);

# ---- the whole patch
my $p = Alchemy::build_engine_patch();
my @entries = $p =~ /^new entry "([^"]+)"/mg;
my %defined = map { $_ => 1 } @entries;
is_deeply([map { my $re = $_; scalar grep { /$re/ } @entries } qr/^Target_Arcana_Card_Spell_Emotion/, qr/^MOOD_/, qr/^FEELING_(?!.*_TECH$|DISAPPROVED$)/, qr/^EMOTION_/],
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
like(block($p, 'EMOTION_AMAZEMENT'), qr/data "OnApplyFunctors" "RemoveStatus\(MOOD_DISTRACTED\);BreakConcentration\(\)"/, 'Amazement keeps BreakConcentration');
none('statuses with `using` inherit TickType', grep { block($p, $_) =~ /^data "TickType"/m } qw(FEELING_AWE EMOTION_TERROR EMOTION_AMAZEMENT));

# ---- StackIds: peaks and intense share EMOTION, moods share MOOD, each feeling its own
my %stack_of; my $cs = '';
for my $l (split /\n/, $p) { $cs = $1 if $l =~ /^new entry "([^"]+)"/; $stack_of{$cs} = $1 if $l =~ /^data "StackId" "([^"]*)"$/ }
none('StackIds', (grep { $stack_of{$_} ne 'EMOTION' } map { ('EMOTION_' . uc $_, 'EMOTION_' . uc $Alchemy::EMO{$_}{intense}{name}) } @W),
    (grep { $stack_of{$_} ne 'MOOD' } map { 'MOOD_' . uc $Alchemy::EMO{$_}{mood}{name} } @W),
    (grep { $stack_of{$_} ne $_ } map { 'FEELING_' . uc $Alchemy::FEELING{$_}{name} } keys %Alchemy::FEELING));

# ---- the Surges
none('Surges: Wisdom save for non-allies, SpellFail, IsHarmful only on the dark arc, standard warning', map {
    my $sp = block($p, Alchemy::spell_id($_)); my $dark = $Alchemy::EMO{$_}{side} eq 'I';
    ($sp =~ /^data "SpellRoll" "Ally\(\) or Self\(\) or not SavingThrow\(Ability\.Wisdom, SourceSpellDC\(\)\)"$/m
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
none('Surge text: flavour, effect, then the mood; one line per kind of reaction, 8 reactions', map {
    my $id = uc Alchemy::spell_id($_); my $mood = $Alchemy::EMO{$_}{mood}{name}; my $x = $lt{"HW_${id}_EXTRA"};
    ($lt{"HW_${id}_DESC"} =~ /^[^.]+\. The target\b.*<br><br>When the surge fades, it leaves the target <LSTag[^>]*>$mood<\/LSTag> for 5 turns, /
     && join(',', map { /^(\w+)/ } split /<br>/, $x) eq 'Primary,Secondary,Tertiary,Catharsis,Intense,Any'
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

# ---- refund (R16): the second functor fires on any reaction, before a reaction spends the mood
my @ff = split /;(?=IF\()/, Alchemy::spell_success('Joy');
like($ff[1], qr/^IF\(\(HasStatus\('MOOD_.*\)\):ApplyStatus\(SELF,RESONANT_REFUND_TECH,100,0\)$/, 'refund comes right after the base case');
is(scalar(() = $ff[1] =~ /HasStatus\('MOOD_/g), 8, 'refund condition covers the 8 moods');
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
none('every Surge tooltip tells the refund', grep { ($lt{'HW_' . uc(Alchemy::spell_id($_)) . '_EXTRA'} // '') !~ /<br><br>Any reaction gives back the spell slot this surge used\. Once per turn\.$/ } @W);

# ---- stage 2: Overload
like(block($p, 'RESONANT_OVERLOAD'), qr/"StackType" "Overwrite".*"RemoveEvents" "OnCombatEnded".*"StatusPropertyFlags" "FreezeDuration;IgnoreResting"/s, 'the meter shows a frozen count, gone after combat');
my $full = block($p, 'RESONANT_OVERLOAD_FULL');
like($full, qr/"TickType" "StartTurn"/, 'full: hurts at the start of your turn');
like($full, qr/ClassLevelHigherOrEqualThan\(11,'Arcana'\)\):DealDamage\(6,Psychic,Magical\)/, 'full at level 11+: 6 Psychic');
like(block($p, 'Arcana_Passive_Overload'), qr/"DisplayName"/, 'the Overload passive exists');
like($lt{'HW_ARCANA_PASSIVE_OVERLOAD_DESC'} // '', qr/Emotional Overload/, 'the passive names the ultimate');
like(block($p, 'RESONANT_DEBUG'), qr/Arcana_Passive_Overload.*UnlockSpell\(Target_Arcana_Created_EmotionalOverload\)/s, 'DEBUG grants the passive and the ultimate');
my $eo = block($p, 'Target_Arcana_Created_EmotionalOverload');
like($eo, qr/"UseCosts" "ActionPoint:1"\n/, 'Emotional Overload: an action, no slot or Thread (R22)');
like($eo, qr/HasStatus\('RESONANT_OVERLOAD_FULL', ?context\.Source\)/, 'only with the meter full');
unlike($eo, qr/"SpellRoll"/, 'no saving throw');
is(scalar(() = $eo =~ /IF\(HasStatus\('FEELING_\w+'\)\):DealDamage\(1d6,Psychic,Magical\)/g), 24, '1d6 Psychic per feeling, all 24');
like($eo, qr/ApplyStatus\(PARALYZED,100,2\)/, 'Paralysed 2 turns (vanilla PARALYZED)');
like($eo, qr/ApplyStatus\(SELF,RESONANT_OVERLOAD_SPENT_TECH,100,0\)/, 'tells Osiris to empty the meter');
my $g = Alchemy::overload_goal();
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

done_testing();
