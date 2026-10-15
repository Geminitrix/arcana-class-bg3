#!/usr/bin/perl
# Tests for gen_awakening_progress.pl (ARC-0007).   perl t/gen_awakening_progress.t
use strict; use warnings; no warnings 'once';
use Test::More;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
require(abs_path(dirname(__FILE__)) . '/../gen_awakening_progress.pl');
sub none { my ($name, @bad) = @_; is_deeply(\@bad, [], $name) }
sub block { my ($p, $id) = @_; my ($b) = $p =~ /(^new entry "\Q$id\E"\n.*?)\n\n/ms; $b // '' }

my %goals = Awake::goals();
is_deeply($goals{TEMPERANCE}, [3, 6, 15], 'goals read from the live ARCANA_Aspect_Common rows (Temperance)');
is_deeply($goals{FOOL}, [3, 4, 5], 'goals: Fool');
is_deeply($goals{STAR}, [500, 800, 1200], 'goals: Star (healing x 100 / level)');

my ($p, %lt) = Awake::build_patch();
my @ids = map { my $a = $_; map { "ASPECT_PROGRESS_${a}_$_" } qw(I II III) } @Awake::ORDER;
is(scalar(@ids), 18, '6 Aspects x 3 tiers');
none('every tier has its progress status', grep { block($p, $_) eq '' } @ids);
none('progress statuses share the Aspect\'s StackId, so the next tier replaces the last', map { my $a = $_;
    grep { block($p, "ASPECT_PROGRESS_${a}_$_") !~ /^data "StackId" "ASPECT_PROGRESS_$a"$/m } qw(I II III) } @Awake::ORDER);
none('progress statuses: a frozen number, shown, gone with the combat', grep { my $b = block($p, $_);
    $b !~ /"StatusPropertyFlags" "FreezeDuration;IgnoreResting;ForceOverhead"/ || $b !~ /"RemoveEvents" "OnCombatEnded"/ || $b !~ /"StackType" "Overwrite"/ } @ids);
none('named Awakening', grep { ($lt{"AW_${_}_NAME"} // '') ne 'Awakening' } @ids);
is($lt{AW_ASPECT_PROGRESS_TEMPERANCE_I_DESC}, 'Reactions left to cause to awaken Resonance.', 'text: what is left and the next tier');
is($lt{AW_ASPECT_PROGRESS_STAR_II_DESC}, 'Hit points left to heal to awaken Sunrise.', 'text: Star in hit points');
is($lt{AW_ASPECT_PROGRESS_DEATH_III_DESC}, 'Hit points left to lose to awaken the Aspect of Sorrow.', 'text: Death in hit points');
is($lt{AW_ASPECT_PROGRESS_FOOL_I_DESC}, 'Different enemies left to strike this round to awaken Wanderlust.', 'text: Fool, this round');
none('progress texts are one line, ASCII', grep { $lt{$_} =~ /<br>|[^\x00-\x7F]/ } grep { /^AW_ASPECT_PROGRESS_/ } keys %lt);

# the five Awakening passives, one shape
my %pt = Awake::passive_texts();
for my $a (@Awake::ORDER) {
    my $t = $pt{$a};
    like($t, qr/during a fight to awaken the Aspect of \w+ until combat ends\./, "$a: what you do, then the Aspect");
    like($t, qr/Each goal you reach awakens one more tier\.<br><br>Level 3: [^<]+<LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_\w+_I">[^<]+<\/LSTag>\.<br><br>Level 7: [^<]+ to also gain <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_\w+_II">[^<]+<\/LSTag>\.<br><br>Level 12: [^<]+ to awaken as the <LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_\w+_III">Aspect of \w+<\/LSTag>\./, "$a: one line per tier");
    like($t, qr/<br><br>The Awakening status shows how much is left to the next tier\.$/, "$a: says what the number means");
}
like($pt{TEMPERANCE}, qr/Level 3: cause 3 reactions to gain/, 'Temperance: goal from the rows');
like($pt{STAR}, qr/Level 7: heal hit points equal to 8 times your level to also gain/, 'Star: 800 -> 8 times your level');
like($pt{DEATH}, qr/Level 12: lose 70% of your hit point maximum to awaken/, 'Death: 700 -> 70%');
like($pt{FOOL}, qr/If fewer enemies stand when your turn begins than a goal asks for, strikes on any enemy count towards that goal instead\./, 'Fool keeps its rule');
like($p, qr/^\@loca h76abef56g542egceedg9549gf86ef239edc5 /m, 'Fool\'s passive text changes in place (its handle)');
unlike($p, qr/^\@loca \S+ .*14 - Temperance/m, 'Temperance\'s passive belongs to gen_emotion_alchemy (not in this patch)');

# the countdown in ARCANA_Aspect_Common
my $d = Awake::display_block();
like($d, qr/IntegerSubtract\(_Goal, _Value, _Left\)/, 'left = goal - value');
like($d, qr/DB_ARCANA_AspectShow\(_Aspect, "HEAL"\)\r?\nAND\r?\nGetLevel\(_Char, _Level\)\r?\nAND\r?\nIntegerProduct\(_Left, _Level, _X\)\r?\nAND\r?\nIntegerSum\(_X, 99, _Up\)\r?\nAND\r?\nIntegerDivide\(_Up, 100, _HP\)/, 'Star: left x level / 100, rounded up');
like($d, qr/DB_ARCANA_AspectShow\(_Aspect, "LOSS"\)\r?\nAND\r?\nGetMaxHitpoints\(_Char, _Max\)\r?\nAND\r?\nIntegerProduct\(_Left, _Max, _X\)\r?\nAND\r?\nIntegerSum\(_X, 999, _Up\)\r?\nAND\r?\nIntegerDivide\(_Up, 1000, _HP\)/, 'Death: left x max HP / 1000, rounded up');
unlike($d, qr/_N < 100/, 'no 99 cap (it was for percentages)');
is(scalar(() = $d =~ /DB_ARCANA_AspectProgress\("\w+", [123], "ASPECT_PROGRESS_\w+_I+"\);/g), 18, 'the 18 progress rows');
like($d, qr/PROC_ARCANA_Aspect_Reset\(\(CHARACTER\)_Char\)\r?\nAND\r?\nDB_ARCANA_AspectProgress\(_Aspect, _Tier, _Status\)\r?\nTHEN\r?\nRemoveStatus\(_Char, _Status, _Char\);/, 'leaving the combat removes every progress status');
unlike($d, qr/[^\x00-\x7F]/, 'ASCII');
like($d, qr/\r\n/, 'CRLF');

# Temperance's passive is written by gen_emotion_alchemy.pl: it must say exactly the same
require(abs_path(dirname(__FILE__)) . '/../gen_emotion_alchemy.pl');
my ($rp) = Alchemy::build_engine_patch();
my ($rt) = $rp =~ /^\@loca HW_ARCANA_PASSIVE_ASPECT_TEMPERANCE_AWAKENING_DESC (.*)$/m;
is($rt, $pt{TEMPERANCE}, 'Temperance passive: the same text in both generators');

done_testing();
