#!/usr/bin/perl
# ARC-0002 stage 4 (Aspect Awakening -- 14 · Temperance): what the game needs besides the engine patch and the goal.
#   - Resonant progression (table 62727cb1-9114-ffbf-7fdb-51e28f73bd0f), node by node, LSX + TBL:
#       L3 + Arcana_Passive_Aspect_Temperance_I;Arcana_Passive_Aspect_Temperance_Awakening
#       L7 + Arcana_Passive_Aspect_Temperance_II        L12 + Arcana_Passive_Aspect_Temperance_III
#     A node without PassivesAdded gets the attribute (LSX: after Name; TBL: after TableUUID, as level 7 has it).
#   - ARCANA_Aspect_Common.txt: the TEMPERANCE rows (43_common_rows.txt, generated) after the DEATH Show row.
# Idempotent; changes nothing when an anchor is missing.
#   perl 54_stage4_apply.pl            # shows what it would do
#   perl 54_stage4_apply.pl --apply    # writes (game and Toolkit closed, [fechado])
use strict; use warnings;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $TABLE = '62727cb1-9114-ffbf-7fdb-51e28f73bd0f';
my $apply = grep { $_ eq '--apply' } @ARGV;
my %add = (3 => ['Arcana_Passive_Aspect_Temperance_I', 'Arcana_Passive_Aspect_Temperance_Awakening'],
           7 => ['Arcana_Passive_Aspect_Temperance_II'], 12 => ['Arcana_Passive_Aspect_Temperance_III']);
my $bad = 0;

my @files = (
  { path => "$G/Public/$M/Progressions/Progressions.lsx", block => qr{<node id="Progression">.*?</node>}s,
    level => qr{id="Level" type="uint8" value="(\d+)"}, pass => qr{(id="PassivesAdded" type="LSString" value=")([^"]*)(")},
    after => qr{([ \t]*)(<attribute id="Name" type="LSString" value="Resonant"/>)(\r?\n)},
    new => sub { my ($ind, $v) = @_; qq{$ind<attribute id="PassivesAdded" type="LSString" value="$v"/>} } },
  { path => "$G/Editor/Mods/$M/Progressions/Progressions.tbl", block => qr{<stat_object\b.*?</stat_object>}s,
    level => qr{name="Level" type="\w+" value="(\d+)"}, pass => qr{(name="PassivesAdded" type="\w+" value=")([^"]*)(")},
    after => qr{([ \t]*)(<field name="TableUUID" type="GuidTableFieldDefinition" value="$TABLE" />)(\r?\n)},
    new => sub { my ($ind, $v) = @_; qq{$ind<field name="PassivesAdded" type="StringTableFieldDefinition" value="$v" />} } });
for my $f (@files) {
    open my $h, '<:raw', $f->{path} or die "$f->{path}: $!"; local $/; my $s = <$h>; close $h;
    my %seen;
    $s =~ s{($f->{block})}{
        my $b = $1;
        if ($b =~ /\Q$TABLE\E/ && $b =~ $f->{level} && exists $add{$1}) {
            my $lvl = $1; $seen{$lvl}++;
            if ($b =~ $f->{pass}) { my $cur = $2;
                my %have = map { $_ => 1 } split /;/, $cur;
                my @miss = grep { !$have{$_} } @{ $add{$lvl} };
                if (@miss) { my $v = join ';', (grep { length } split /;/, $cur), @miss; $b =~ s/$f->{pass}/$1$v$3/;
                             print(($apply ? 'write    ' : 'would    ') . "L$lvl  PassivesAdded = $v  ($f->{path})\n") }
                else { print "already  L$lvl  ($f->{path})\n" }
            } elsif ($b =~ $f->{after}) {
                my $v = join ';', @{ $add{$lvl} };
                $b =~ s/$f->{after}/$1 . $2 . $3 . $f->{new}->($1, $v) . $3/e;
                print(($apply ? 'write    ' : 'would    ') . "L$lvl  + PassivesAdded = $v  ($f->{path})\n");
            } else { print "ANCHOR   L$lvl has no place for PassivesAdded ($f->{path})\n"; $bad++ }
        }
        $b }ge;
    for my $lvl (sort { $a <=> $b } keys %add) { unless ($seen{$lvl}) { print "MISSING  L$lvl in $f->{path}\n"; $bad++ } }
    if ($apply && !$bad) { open $h, '>:raw', $f->{path} or die "$f->{path}: $!"; print $h $s; close $h }
}

my $common = "$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Common.txt";
my $rows = do { open my $h, '<:raw', abs_path(dirname(__FILE__)) . '/43_common_rows.txt' or die "43_common_rows.txt: $!"; local $/; <$h> };
{
    open my $h, '<:raw', $common or die "$common: $!"; local $/; my $s = <$h>; close $h;
    my $anchor = qq{DB_ARCANA_AspectShow("DEATH", "PERCENT");\r\n};
    if ($s =~ /"TEMPERANCE"/) { print "already  Common has TEMPERANCE\n" }
    elsif ((() = $s =~ /\Q$anchor\E/g) != 1) { print "ANCHOR   Common: the DEATH Show row\n"; $bad++ }
    else {
        print(($apply ? 'write    ' : 'would    ') . "Common + TEMPERANCE rows\n");
        if ($apply) { my $i = index($s, $anchor) + length $anchor; substr($s, $i, 0) = $rows; open $h, '>:raw', $common or die; print $h $s; close $h }
    }
}
exit($bad ? 1 : 0);
