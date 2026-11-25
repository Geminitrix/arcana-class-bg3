#!/usr/bin/perl
# ARC-0036 — put back the Double's slot rules (DoubleOfTheVeil_3 … _6, _5/_6_NoUnveil) in BOTH copies of the
# shapeshift Rulebook. They lived only in the .lsx (the Toolkit reads the .tbl), so the Owner's save of 2026-11-25
# 18:41 dropped five of them and left _3 with Splinter only; Osiris (ARCANA_Deceiver_TheVeil) still applies all seven.
#
#   perl restore_double_rules.pl <dir>   edits <dir>/Public/…/Rulebook.lsx and <dir>/Editor/Mods/…/Rulebook.tbl,
#                                        the renamed copies a rename_ids.pl dry run wrote (never the game files).
# Each rule is a clone of the _3 rule (the Owner's current settings), with the UUID Osiris already uses and the
# spells of the 2026-10-11 rulebook (51), renamed (DV37). The base rule and _3 keep their place; the new ones follow _3.
use strict; use warnings;

my $MOD = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $dir = shift or die "usage: restore_double_rules.pl <dry-run dir>\n";
my $LSX = "$dir/Public/$MOD/Shapeshift/Rulebook.lsx";
my $TBL = "$dir/Editor/Mods/$MOD/Shapeshift/Rulebook.tbl";

my $BASE = 'Shout_Disengage;Shout_Dash;Shout_Dismiss_Self;Shout_Arcana_Double_Splinter;';
sub kit { my ($n, $unveil) = @_; $BASE . "Projectile_Arcana_Double_ReflectedSeed_$n;Target_Arcana_Double_ReflectedFalsehood_$n;" . ($unveil ? 'Target_Arcana_Double_Unveil;' : '') }
my @RULES = (   # name, UUID (from ARCANA_Deceiver_TheVeil), spells
  [ 'DoubleOfTheVeil_3',          'd27e2641-3a75-82be-7741-ec16ebc2561f', kit(3) ],
  [ 'DoubleOfTheVeil_4',          'cfbaa6cd-62ba-7b67-9700-114cd3b86b75', kit(4) ],
  [ 'DoubleOfTheVeil_5_NoUnveil', '615d1e0d-b8f5-7ef4-e5ee-3b66eb467645', kit(5) ],
  [ 'DoubleOfTheVeil_5',          'd6306a71-9b8a-4dd0-f97a-3f6df38c9b8c', kit(5, 1) ],
  [ 'DoubleOfTheVeil_6_NoUnveil', 'c0c93c59-f1a4-7866-6887-0f782fa29689', kit(6) ],
  [ 'DoubleOfTheVeil_6',          '8014e496-f3d0-76b1-532c-fcd4863b6199', kit(6, 1) ],
);

sub slurp { open my $f, '<:raw', $_[0] or die "$_[0]: $!"; local $/; <$f> }
sub spew  { open my $f, '>:raw', $_[0] or die "$_[0]: $!"; print $f $_[1]; close $f }

# --- .lsx: <node id="Rule"> … </node> blocks
my $lsx = slurp($LSX);
my ($r3) = $lsx =~ /([ \t]*<node id="Rule">(?:(?!<node id="Rule">).)*?value="d27e2641-3a75-82be-7741-ec16ebc2561f".*?<\/children>\s*<\/node>\r?\n)/s
  or die "lsx: rule _3 not found\n";
my $lsx_new = '';
for my $r (@RULES) {
  my ($name, $uuid, $spells) = @$r; my $b = $r3;
  $b =~ s/(id="RuleName" type="LSString" value=")[^"]*/$1$name/ or die "lsx RuleName";
  $b =~ s/(id="SpellsAdd" type="LSString" value=")[^"]*/$1$spells/ or die "lsx SpellsAdd";
  $b =~ s/(id="UUID" type="guid" value=")[^"]*/$1$uuid/ or die "lsx UUID";
  $lsx_new .= $b;
}
$lsx =~ s/\Q$r3\E/$lsx_new/ or die "lsx replace";
spew($LSX, $lsx);

# --- .tbl: <stat_object> … </stat_object> blocks
my $tbl = slurp($TBL);
my ($t3) = $tbl =~ /([ \t]*<stat_object is_substat="false">(?:(?!<stat_object ).)*?value="d27e2641-3a75-82be-7741-ec16ebc2561f".*?<\/stat_object>\r?\n)/s
  or die "tbl: rule _3 not found\n";
my $tbl_new = '';
for my $r (@RULES) {
  my ($name, $uuid, $spells) = @$r; my $b = $t3;
  $b =~ s/(name="Name" type="NameTableFieldDefinition" value=")[^"]*/$1$name/ or die "tbl Name";
  $b =~ s/(name="RuleName" type="StringTableFieldDefinition" value=")[^"]*/$1$name/ or die "tbl RuleName";
  $b =~ s/(name="SpellsAdd" type="StringTableFieldDefinition" value=")[^"]*/$1$spells/ or die "tbl SpellsAdd";
  $b =~ s/(name="UUID" type="IdTableFieldDefinition" value=")[^"]*/$1$uuid/ or die "tbl UUID";
  $tbl_new .= $b;
}
$tbl =~ s/\Q$t3\E/$tbl_new/ or die "tbl replace";
spew($TBL, $tbl);

my $nl = () = $lsx =~ /<node id="Rule">/g; my $nt = () = $tbl =~ /<stat_object /g;
print "rules: lsx $nl, tbl $nt\n";
