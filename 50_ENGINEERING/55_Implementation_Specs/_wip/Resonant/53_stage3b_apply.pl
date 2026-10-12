#!/usr/bin/perl
# ARC-0002 stage 3b (R36, R37): what the game needs besides the engine patch.
#   - "Resonant Level 1" loses Read the Room (R37: Empathic Sight already gives Advantage on Insight);
#   - the Osiris goal ARCANA_Resonant_Temper leaves the mod (R36: Temper is pure Stats now). It is moved, not
#     deleted, to _wip/Resonant/retired/ (the 51 copy stays in git history).
# Each list edit needs its exact current text, so it changes nothing when the anchor is missing.
#   perl 53_stage3b_apply.pl            # shows what it would do
#   perl 53_stage3b_apply.pl --apply    # writes (game and Toolkit closed, [fechado])
use strict; use warnings;
use File::Basename qw(dirname);
use File::Copy qw(move);
use File::Path qw(make_path);
use Cwd qw(abs_path);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my $S = 'Target_Arcana_Card_Spell_';
# "Resonant Level 1" 05269c79-116f-2b07-6dc1-deeefddc7ae4
my ($o, $n) = ("${S}EmotionJoy;${S}EmotionTrust;${S}EmotionFear;${S}Heartstring;Shout_Arcana_Util_ReadTheRoom",
               "${S}EmotionJoy;${S}EmotionTrust;${S}EmotionFear;${S}Heartstring");
my @edits = (["$G/Public/$M/Lists/SpellLists.lsx", qq{value="$o"/>}, qq{value="$n"/>}],
             ["$G/Editor/Mods/$M/Lists/SpellLists.tbl", qq{value="$o" />}, qq{value="$n" />}]);
my $bad = 0;
for my $e (@edits) {
    my ($f, $old, $new) = @$e;
    open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h;
    my $c = () = $s =~ /\Q$old\E/g; my $done = () = $s =~ /\Q$new\E/g;
    if ($done == 1 && $c == 0) { print "already  $f\n"; next }
    if ($c != 1) { print "ANCHOR $c x  $f  -- not changed\n"; $bad++; next }
    print(($apply ? "write    " : "would    ") . "$f\n");
    next unless $apply;
    my $i = index($s, $old); substr($s, $i, length $old) = $new;
    open $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h;
}
my $goal = "$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Resonant_Temper.txt";
my $to = abs_path(dirname(__FILE__)) . '/retired';
if (!-e $goal) { print "already  goal moved\n" }
else {
    print(($apply ? "move     " : "would move ") . "$goal -> $to/\n");
    if ($apply) { make_path($to); move($goal, "$to/ARCANA_Resonant_Temper.txt") or die "move: $!" }
}
exit($bad ? 1 : 0);
