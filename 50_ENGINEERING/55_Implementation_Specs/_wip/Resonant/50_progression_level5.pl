#!/usr/bin/perl
# ARC-0002 stage 2 (R13): the Overload passive and Emotional Overload arrive at Resonant level 5.
# Edits the game's LSX and its Toolkit twin (TBL) together; each edit needs its exact current text, so it
# changes nothing when the anchor is missing (already applied, or edited in the Toolkit since).
#   perl 50_progression_level5.pl            # shows what it would do
#   perl 50_progression_level5.pl --apply    # writes (game and Toolkit closed, [fechado])
use strict; use warnings;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my @edits = (
  # Resonant level 5 progression row 37a002f2-35d4-4c3f-4987-bd26ec63e7a4
  ["$G/Public/$M/Progressions/Progressions.lsx",
   '<attribute id="PassivesAdded" type="LSString" value="Arcana_Passive_ComplexFeelings"/>',
   '<attribute id="PassivesAdded" type="LSString" value="Arcana_Passive_ComplexFeelings;Arcana_Passive_Overload"/>'],
  ["$G/Editor/Mods/$M/Progressions/Progressions.tbl",
   '<field name="PassivesAdded" type="StringTableFieldDefinition" value="Arcana_Passive_ComplexFeelings" />',
   '<field name="PassivesAdded" type="StringTableFieldDefinition" value="Arcana_Passive_ComplexFeelings;Arcana_Passive_Overload" />'],
  # list "Resonant Level 5" e0d34d66-e311-be56-1810-04f9ba0917fd
  ["$G/Public/$M/Lists/SpellLists.lsx",
   'value="Target_Arcana_Card_Spell_EmotionDisgust;Target_Arcana_Card_Spell_EmotionAnger"/>',
   'value="Target_Arcana_Card_Spell_EmotionDisgust;Target_Arcana_Card_Spell_EmotionAnger;Target_Arcana_Created_EmotionalOverload"/>'],
  ["$G/Editor/Mods/$M/Lists/SpellLists.tbl",
   'value="Target_Arcana_Card_Spell_EmotionDisgust;Target_Arcana_Card_Spell_EmotionAnger" />',
   'value="Target_Arcana_Card_Spell_EmotionDisgust;Target_Arcana_Card_Spell_EmotionAnger;Target_Arcana_Created_EmotionalOverload" />'],
);
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
