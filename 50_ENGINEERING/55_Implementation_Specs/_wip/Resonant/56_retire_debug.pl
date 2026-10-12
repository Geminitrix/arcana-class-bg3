#!/usr/bin/perl
# ARC-0002 stage 7: the Resonant's DEBUG scaffold is retired -- every spell and passive now arrives by the progression.
# The engine patch removes Shout_Arcana_Util_DEBUG_Resonant and RESONANT_DEBUG (gen_emotion_alchemy %RETIRED); this
# script takes the shout off the "Arcana Deck DEBUG" list (f2e5e2e9-42c8-4f0e-88de-830ef0224290), LSX + TBL. The
# entries' text is in 90_ARCHIVE/93_Old_Versions/2026-10-12_ARC-0002_resonant_debug/. Idempotent.
#   perl 56_retire_debug.pl            # shows what it would do
#   perl 56_retire_debug.pl --apply    # writes (game and Toolkit closed, [fechado] ARC-0002)
use strict; use warnings;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my $old = 'Shout_Arcana_Card_Spell_DEBUG_Tangler;Shout_Arcana_Util_DEBUG_Resonant;Target_Arcana_Util_DEBUG_AddDoubt';
my $new = 'Shout_Arcana_Card_Spell_DEBUG_Tangler;Target_Arcana_Util_DEBUG_AddDoubt';
my $bad = 0;
for my $f ("$G/Public/$M/Lists/SpellLists.lsx", "$G/Editor/Mods/$M/Lists/SpellLists.tbl") {
    open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h;
    my $c = () = $s =~ /\Q$old\E/g;
    if ($c == 0 && $s !~ /Shout_Arcana_Util_DEBUG_Resonant/) { print "already  $f\n"; next }
    if ($c != 1) { print "ANCHOR $c x  $f\n"; $bad++; next }
    print(($apply ? 'write    ' : 'would    ') . "$f\n");
    next unless $apply;
    $s =~ s/\Q$old\E/$new/;
    open $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h;
}
exit($bad ? 1 : 0);
