#!/usr/bin/perl
# Adds a generated LevelMapSeries node (a *.lsx-fragment from gen_emotion_alchemy.pl) to the game's
# LevelMapValues.lsx and the matching row to its Toolkit twin LevelMapValues.tbl, after Starcall_Damage.
# Skips a map whose name is already there.
#   perl 35_levelmap_apply.pl FRAGMENT [FRAGMENT...]            # shows what it would do
#   perl 35_levelmap_apply.pl FRAGMENT [FRAGMENT...] --apply    # writes (game and Toolkit closed, [fechado])
use strict; use warnings;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my @frags = grep { $_ ne '--apply' } @ARGV or die "usage: $0 FRAGMENT... [--apply]\n";
my ($lsx, $tbl) = ("$G/Public/$M/Levelmaps/LevelMapValues.lsx", "$G/Editor/Mods/$M/Levelmaps/LevelMapValues.tbl");
sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s }
sub spit  { my ($f, $s) = @_; open my $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h }
my ($l, $t) = (slurp($lsx), slurp($tbl));
for my $frag (@frags) {
    (my $node = slurp($frag)) =~ s/\r\n/\n/g;
    my %lv = $node =~ /id="Level(\d+)" type="LSString" value="([^"]+)"/g;
    my ($name) = $node =~ /id="Name" type="FixedString" value="([^"]+)"/ or die "$frag: no Name\n";
    my ($uuid) = $node =~ /id="UUID" type="guid" value="([^"]+)"/ or die "$frag: no UUID\n";
    if ($l =~ /value="\Q$name\E"/) { print "already  $name\n"; next }
    $l =~ s/(value="Starcall_Damage"\/>\n[^\n]*\n\s*<\/node>\n)/$1$node/ or die "lsx anchor (Starcall_Damage) not found\n";
    my $row = qq{    <stat_object is_substat="false">\r\n      <fields>\r\n        <field name="Name" type="NameTableFieldDefinition" value="$name" />\r\n        <field name="UUID" type="IdTableFieldDefinition" value="$uuid" />\r\n};
    $row .= qq{        <field name="Level$_" type="StringTableFieldDefinition" value="$lv{$_}" />\r\n} for 1 .. 20;
    $row .= qq{      </fields>\r\n    </stat_object>\r\n};
    $t =~ s/(value="Starcall_Damage" \/>\r\n(?:.*\r\n)*?    <\/stat_object>\r\n)/$1$row/ or die "tbl anchor (Starcall_Damage) not found\n";
    print(($apply ? "add      " : "would add ") . "$name ($uuid)\n");
}
if ($apply) { spit($lsx, $l); spit($tbl, $t) }
