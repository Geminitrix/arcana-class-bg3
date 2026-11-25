#!/usr/bin/perl
# ARC-0036 — on the copies a rename_ids.pl dry run wrote (never the game files):
#  1. drop the 9 level maps nothing reads (old Sigil / Mirror / Mimic / Distortion / Ethereal Chains damage series),
#     from both LevelMapValues copies (.lsx and .tbl);
#  2. give the two Rulebook .tbl entries the Toolkit shows as New_Stat_1 / New_Stat_2 their rule names.
# The removed blocks are written to <dir>/REMOVED_levelmaps.txt (they also live in the 94 backup of the apply).
use strict; use warnings;

my $MOD = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $dir = shift or die "usage: cleanup_dead.pl <dry-run dir>\n";
my @DEAD = qw(Distortion_Damage EtherealChains_Damage MimicDistortion_Damage MimicEtherealChains_Damage
              MimicSigilofMalice_Damage MirrorDistortion_Damage MirrorEtherealChains_Damage MirrorSigilofMalice_Damage
              SigilofMalice_Damage);
my %TBLNAME = ( '3eb3fee7-67b4-46b5-a81a-2ac2da66bff7' => 'FacelessCopy', '21aacde3-d14d-7a32-7dbb-5418cc3bdf9d' => 'DoubleOfTheVeil' );

sub slurp { open my $f, '<:raw', $_[0] or die "$_[0]: $!"; local $/; <$f> }
sub spew  { open my $f, '>:raw', $_[0] or die "$_[0]: $!"; print $f $_[1]; close $f }

my $removed = '';
my $lsx = "$dir/Public/$MOD/Levelmaps/LevelMapValues.lsx";
my $tbl = "$dir/Editor/Mods/$MOD/Levelmaps/LevelMapValues.tbl";
my $s = slurp($lsx); my $t = slurp($tbl);
for my $n (@DEAD) {
  $s =~ s/([ \t]*<node id="LevelMapSeries">(?:(?!<node id="LevelMapSeries">).)*?id="Name" type="FixedString" value="\Q$n\E".*?<\/node>\r?\n)//s
    or die "lsx: $n not found\n";
  $removed .= "--- lsx $n\n$1";
  $t =~ s/([ \t]*<stat_object is_substat="false">(?:(?!<stat_object ).)*?name="Name" type="NameTableFieldDefinition" value="\Q$n\E".*?<\/stat_object>\r?\n)//s
    or die "tbl: $n not found\n";
  $removed .= "--- tbl $n\n$1";
}
spew($lsx, $s); spew($tbl, $t);
my $nl = () = $s =~ /<node id="LevelMapSeries">/g; my $nt = () = $t =~ /<stat_object /g;
print "level maps left: lsx $nl, tbl $nt (removed " . scalar(@DEAD) . " from each)\n";

my $rb = "$dir/Editor/Mods/$MOD/Shapeshift/Rulebook.tbl"; my $r = slurp($rb);
for my $uuid (sort keys %TBLNAME) {
  $r =~ s/(name="Name" type="NameTableFieldDefinition" value=")New_Stat_\d+(" \/>\s*<field name="UUID" type="IdTableFieldDefinition" value="\Q$uuid\E")/$1$TBLNAME{$uuid}$2/
    or die "Rulebook.tbl: $uuid not found\n";
}
spew($rb, $r); print "Rulebook.tbl: New_Stat_1/2 → " . join(', ', map { $TBLNAME{$_} } sort keys %TBLNAME) . "\n";
spew("$dir/REMOVED_levelmaps.txt", $removed);
