#!/usr/bin/perl
# ARC-0002 stage 3: the spells outside the Surges reach the Resonant's level lists, so they can be tested.
#   Resonant Level 1: Heartstring, Read the Room        Resonant Level 3: Temper
#   Resonant Level 5 (FOR NOW): Emotional Contagion and Ready: Compassion -- their lists (levels 9 and 11) do not
#   exist yet; stage 6 creates them and moves both there.
# Edits the game's LSX and its Toolkit twin (TBL) together; each edit needs its exact current text, so it
# changes nothing when the anchor is missing (already applied, or edited in the Toolkit since).
#   perl 52_progression_stage3.pl            # shows what it would do
#   perl 52_progression_stage3.pl --apply    # writes (game and Toolkit closed, [fechado])
use strict; use warnings;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my $S = 'Target_Arcana_Card_Spell_';
my @lists = (   # [old spells, new spells]
  # "Resonant Level 1" 05269c79-116f-2b07-6dc1-deeefddc7ae4
  ["${S}EmotionJoy;${S}EmotionTrust;${S}EmotionFear", "${S}EmotionJoy;${S}EmotionTrust;${S}EmotionFear;${S}Heartstring;Shout_Arcana_Util_ReadTheRoom"],
  # "Resonant Level 3" 74e89dac-4330-83f6-cf7b-881854bd4663
  ["${S}EmotionAnticipation;${S}EmotionSurprise;${S}EmotionSadness", "${S}EmotionAnticipation;${S}EmotionSurprise;${S}EmotionSadness;${S}Temper"],
  # "Resonant Level 5" e0d34d66-e311-be56-1810-04f9ba0917fd
  ["${S}EmotionDisgust;${S}EmotionAnger;Target_Arcana_Created_EmotionalOverload",
   "${S}EmotionDisgust;${S}EmotionAnger;Target_Arcana_Created_EmotionalOverload;${S}EmotionalContagion;Shout_Arcana_Card_Passive_Compassion"],
);
my @edits = map { my ($o, $n) = @$_;
  (["$G/Public/$M/Lists/SpellLists.lsx", qq{value="$o"/>}, qq{value="$n"/>}],
   ["$G/Editor/Mods/$M/Lists/SpellLists.tbl", qq{value="$o" />}, qq{value="$n" />}]) } @lists;
my $bad = 0;
for my $e (@edits) {
    my ($f, $old, $new) = @$e;
    open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h;
    my $n = () = $s =~ /\Q$old\E/g; my $done = () = $s =~ /\Q$new\E/g;
    if ($done == 1 && $n == 0) { print "already  $f\n"; next }
    if ($n != 1) { print "ANCHOR $n x  $f  -- not changed\n"; $bad++; next }
    print(($apply ? "write    " : "would    ") . "$f\n");
    next unless $apply;
    my $i = index($s, $old); substr($s, $i, length $old) = $new;
    open $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h;
}
exit($bad ? 1 : 0);
