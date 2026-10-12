#!/usr/bin/perl
# ARC-0002 stage 2b (R29): the Overload passive moves from Resonant level 5 to level 1.
# Edits only the Resonant progression table (62727cb1-9114-ffbf-7fdb-51e28f73bd0f), node by node: the Spinner's
# placeholder table holds the same level-1 passives, so a plain text replace would hit it too.
# LSX (game) and TBL (Toolkit twin) change together. Idempotent.
#   perl 51_progression_overload_level1.pl            # shows what it would do
#   perl 51_progression_overload_level1.pl --apply    # writes (game and Toolkit closed, [fechado])
use strict; use warnings;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $TABLE = '62727cb1-9114-ffbf-7fdb-51e28f73bd0f';
my $apply = grep { $_ eq '--apply' } @ARGV;
my %want = (1 => 'Arcana_Passive_EmotionalAlchemy;Arcana_Passive_EmpathicSight;Arcana_Passive_Overload',
            5 => 'Arcana_Passive_ComplexFeelings');
my @files = (["$G/Public/$M/Progressions/Progressions.lsx", qr{<node id="Progression">.*?</node>}s,
              qr{id="Level" type="uint8" value="(\d+)"}, qr{(id="PassivesAdded" type="LSString" value=")([^"]*)(")}],
             ["$G/Editor/Mods/$M/Progressions/Progressions.tbl", qr{<stat_object\b.*?</stat_object>}s,
              qr{name="Level" type="\w+" value="(\d+)"}, qr{(name="PassivesAdded" type="\w+" value=")([^"]*)(")}]);
my $bad = 0;
for my $f (@files) {
    my ($path, $blockre, $levelre, $passre) = @$f;
    open my $h, '<:raw', $path or die "$path: $!"; local $/; my $s = <$h>; close $h;
    my %seen;
    $s =~ s{($blockre)}{
        my $b = $1;
        if ($b =~ /\Q$TABLE\E/ && $b =~ $levelre && exists $want{$1}) {
            my $lvl = $1;
            if ($b =~ $passre) { my $old = $2; $seen{$lvl}++;
                print(($old eq $want{$lvl} ? 'already  ' : ($apply ? 'write    ' : 'would    ')) . "L$lvl  $old -> $want{$lvl}  ($path)\n");
                $b =~ s/$passre/$1$want{$lvl}$3/; }
        }
        $b }ge;
    for my $lvl (sort keys %want) { unless ($seen{$lvl}) { print "MISSING L$lvl in $path\n"; $bad++ } }
    if ($apply && !$bad) { open $h, '>:raw', $path or die "$path: $!"; print $h $s; close $h }
}
exit($bad ? 1 : 0);
