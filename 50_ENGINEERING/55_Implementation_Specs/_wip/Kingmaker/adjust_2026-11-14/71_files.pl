#!/usr/bin/perl
# ARC-0008 adjustments (Owner, 2026-11-14/16): the files stats_add.pl doesn't touch, both sides
# (Public .lsx = the game, Editor .tbl = the Toolkit):
#   - LevelMaps Kingmaker_Crossing (1d8 / 2d6 / 2d8) and Kingmaker_CrossingHubris (2d8 / 3d6 / 3d8), levels 1-4 / 5-8 / 9-20;
#   - Progression Kingmaker level 3: + Arcana_Passive_SwiftShears; level 4: Arcana_Passive_PLACEHOLDER1 -> Arcana_Passive_Severance;
#   - the Story goal ARCANA_Kingmaker_Wheel.txt replaced by this folder's copy (CRLF, like the game's).
# Exact anchors, each must match once; nothing is written otherwise; idempotent.
#   perl 71_files.pl BACKUP_DIR            shows what it would do
#   perl 71_files.pl BACKUP_DIR --apply    writes ([fechado] ARC-0008)
use strict; use warnings;
use File::Basename qw(dirname basename);
use File::Path qw(make_path);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $bk = shift or die "usage: 71_files.pl BACKUP_DIR [--apply]\n";
my $apply = grep { $_ eq '--apply' } @ARGV;
my $HERE = dirname(__FILE__);
my %F = (lsx_lm => "$G/Public/$M/Levelmaps/LevelMapValues.lsx",       tbl_lm => "$G/Editor/Mods/$M/Levelmaps/LevelMapValues.tbl",
         lsx_pg => "$G/Public/$M/Progressions/Progressions.lsx",      tbl_pg => "$G/Editor/Mods/$M/Progressions/Progressions.tbl",
         goal   => "$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Kingmaker_Wheel.txt");
my (%s, %orig);
for my $k (keys %F) { open my $h, '<:raw', $F{$k} or die "$F{$k}: $!"; local $/; $s{$k} = $orig{$k} = <$h>; close $h }
my $bad = 0;
sub say_ { print(($apply ? 'write  ' : 'would  ') . "@_\n") }

# 1. LevelMaps: every LevelN value of the named series
my %MAP = (Kingmaker_Crossing => ['1d8', '2d6', '2d8'], Kingmaker_CrossingHubris => ['2d8', '3d6', '3d8']);
sub die_for { my ($n, $v) = @_; $n <= 4 ? $v->[0] : $n <= 8 ? $v->[1] : $v->[2] }
for my $name (sort keys %MAP) {
    for my $k (qw(lsx_lm tbl_lm)) {
        my $blk = $k eq 'lsx_lm'
            ? qr{<node id="LevelMapSeries">(?:(?!</node>).)*?value="\Q$name\E"/>(?:(?!</node>).)*?</node>}s
            : qr{<stat_object is_substat="false">(?:(?!</stat_object>).)*?value="\Q$name\E" />(?:(?!</stat_object>).)*?</stat_object>}s;
        my @m = $s{$k} =~ /($blk)/g;
        if (@m != 1) { print "ANCHOR (" . scalar(@m) . "): $name in $k\n"; $bad++; next }
        (my $new = $m[0]) =~ s{(id="Level(\d+)" type="LSString" value=")[^"]*"|(name="Level(\d+)" type="StringTableFieldDefinition" value=")[^"]*"}
                              { defined $1 ? "$1" . die_for($2, $MAP{$name}) . '"' : "$3" . die_for($4, $MAP{$name}) . '"' }ge;
        my $n = () = $new =~ /Level\d+"/g;
        if ($n != 20) { print "LEVELS ($n, not 20): $name in $k\n"; $bad++; next }
        if ($new eq $m[0]) { print "same   $name in $k\n"; next }
        my $at = index($s{$k}, $m[0]); substr($s{$k}, $at, length $m[0]) = $new; say_("$name in $k");
    }
}

# 2. Progressions
my $L3_OLD = 'Arcana_Passive_TheCrossing;Arcana_Passive_Aspect_WheelOfFortune_Awakening;Arcana_Passive_Aspect_WheelOfFortune_I';
my $L3_NEW = "$L3_OLD;Arcana_Passive_SwiftShears";
for my $k (qw(lsx_pg tbl_pg)) {
    for my $pair ([$L3_OLD, $L3_NEW, 'level 3 + Swift Shears'], ['Arcana_Passive_PLACEHOLDER1', 'Arcana_Passive_Severance', 'level 4 PLACEHOLDER1 -> Severance']) {
        my ($old, $new, $what) = @$pair;
        my $nn = () = $s{$k} =~ /value="\Q$new\E"/g;
        if ($nn == 1) { print "same   $what in $k\n"; next }
        my $no = () = $s{$k} =~ /value="\Q$old\E"/g;
        if ($no != 1) { print "ANCHOR ($no): $what in $k\n"; $bad++; next }
        $s{$k} =~ s/value="\Q$old\E"/value="$new"/; say_("$what in $k");
    }
}

# 3. the goal (CRLF)
{ open my $h, '<:raw', "$HERE/ARCANA_Kingmaker_Wheel.txt" or die $!; local $/; my $g = <$h>; close $h;
  $g =~ s/\r\n/\n/g; $g =~ s/\n/\r\n/g;
  if ($g eq $s{goal}) { print "same   goal\n" } else { $s{goal} = $g; say_('goal ARCANA_Kingmaker_Wheel.txt') } }

if ($bad) { print "\n$bad problem(s): nothing written\n"; exit 1 }
exit 0 unless $apply;
make_path($bk);
for my $k (sort keys %F) {
    next if $s{$k} eq $orig{$k};
    my $b = "$bk/" . basename($F{$k}); open my $o, '>:raw', $b or die "$b: $!"; print $o $orig{$k}; close $o;
    open my $w, '>:raw', $F{$k} or die "$F{$k}: $!"; print $w $s{$k}; close $w;
}
print "done (backups in $bk)\n";
