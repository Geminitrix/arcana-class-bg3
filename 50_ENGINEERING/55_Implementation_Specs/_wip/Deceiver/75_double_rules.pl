#!/usr/bin/perl
# The Veil: the Double's spells live in its shapeshift rule. Transform's RemovePrevSpells shows only the rule's SpellsAdd
# while the Double is transformed, so AddSpell from Osiris never reached its hotbar (in-game test 2026-10-07).
# One rule per tier of her kit; ARCANA_Deceiver_Doubles.txt picks the rule from her passives and level.
#   perl 75_double_rules.pl [--apply]      (both sides: Public Rulebook.lsx + Toolkit Rulebook.tbl; twice = no change)
use strict; use warnings;
use Digest::MD5 qw(md5_hex);
my $G = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my ($LSX, $TBL) = ("$G/Public/$M/Shapeshift/Rulebook.lsx", "$G/Editor/Mods/$M/Shapeshift/Rulebook.tbl");
my $BASE = '21aacde3-d14d-7a32-7dbb-5418cc3bdf9d';
my $KIT = 'Shout_Dash;Shout_Disengage;Shout_Deceiver_Double_Shatter;Shout_Deceiver_Clone_Dismiss';
sub uuid { my @h = unpack '(A4)8', md5_hex("arcana-veil:" . shift); "$h[0]$h[1]-$h[2]-$h[3]-$h[4]-$h[5]$h[6]$h[7]" }
sub mirror { my $n = shift; "Projectile_Deceiver_Double_MirrorSigil_Slot$n;Target_Deceiver_Double_MirrorChains_Slot$n" }
# name => [uuid, SpellsAdd]
my @RULES = (
    ['DoubleOfTheVeil', $BASE, $KIT],
    (map { my $n = $_; ["DoubleOfTheVeil_Slot$n", uuid("rule_slot$n"), "$KIT;" . mirror($n)] } 3, 4),
    (map { my $n = $_; ["DoubleOfTheVeil_Slot$n", uuid("rule_slot$n"), "$KIT;" . mirror($n) . ';Target_Deceiver_Double_Unveil'] } 5, 6),
    ['DoubleOfTheVeil_Slot5_NoUnveil', uuid('rule_slot5_nounveil'), "$KIT;" . mirror(5)],
    ['DoubleOfTheVeil_Slot6_NoUnveil', uuid('rule_slot6_nounveil'), "$KIT;" . mirror(6)],
);
sub slurp { open my $h, '<:raw', $_[0] or die "$_[0]: $!"; local $/; my $s = <$h>; close $h; $s }
sub spew { open my $h, '>:raw', $_[0] or die "$_[0]: $!"; print $h $_[1]; close $h }
my ($lsx, $tbl) = (slurp($LSX), slurp($TBL)); my ($ol, $ot) = ($lsx, $tbl);
my ($node) = $lsx =~ /(\n[ \t]*<node id="Rule">(?:(?!<node id="Rule">).)*?value="\Q$BASE\E".*?\n                <\/node>)/s or die "lsx: base rule\n";
my ($obj) = $tbl =~ /(\r?\n[ \t]*<stat_object[^>]*>(?:(?!<stat_object).)*?value="\Q$BASE\E".*?<\/stat_object>)/s or die "tbl: base rule\n";
for my $r (@RULES) {
    my ($name, $u, $spells) = @$r;
    if ($lsx !~ /value="\Q$u\E"/) {
        (my $n = $node) =~ s/value="\Q$BASE\E"/value="$u"/; $n =~ s/(id="RuleName" type="LSString" value=")[^"]*/$1$name/;
        $lsx =~ s/(\Q$node\E)/$1$n/ or die "lsx insert $name\n"; $node = $n;   # each new rule goes after the previous one
        (my $o = $obj) =~ s/value="\Q$BASE\E"/value="$u"/; $o =~ s/(name="RuleName" type="StringTableFieldDefinition" value=")[^"]*/$1$name/;
        $o =~ s/(name="Name" type="NameTableFieldDefinition" value=")[^"]*/$1$name/;
        $tbl =~ s/(\Q$obj\E)/$1$o/ or die "tbl insert $name\n"; $obj = $o;
        print "+ rule $name $u\n";
    }
}
# second pass: every rule's spells, once the clones exist (they copy the base text as it was)
for my $r (@RULES) {
    my ($name, $u, $spells) = @$r;
    $lsx =~ s/(id="RuleName" type="LSString" value="\Q$name\E"\/>(?:(?!<\/node>).)*?id="SpellsAdd" type="LSString" value=")[^"]*/$1$spells/s or die "lsx SpellsAdd $name\n";
    $tbl =~ s/(name="RuleName" type="StringTableFieldDefinition" value="\Q$name\E" \/>(?:(?!<\/stat_object>).)*?name="SpellsAdd" type="StringTableFieldDefinition" value=")[^"]*/$1$spells/s or die "tbl SpellsAdd $name\n";
}
print "changed: ", join(' ', ($lsx ne $ol ? 'lsx' : ()), ($tbl ne $ot ? 'tbl' : ())), "\n";
print "$_->[0] => $_->[1]\n" for @RULES;
if ($apply) { spew($LSX, $lsx) if $lsx ne $ol; spew($TBL, $tbl) if $tbl ne $ot; print "written.\n" } else { print "(dry run)\n" }
