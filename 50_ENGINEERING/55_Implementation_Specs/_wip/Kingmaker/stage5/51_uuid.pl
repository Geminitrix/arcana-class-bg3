#!/usr/bin/perl
# ARC-0008 stage 5: the UUID Object Editor side, both sides (Public .lsx = the game, Editor .tbl = the Toolkit).
#   - spell list "Kingmaker Level 9": Wheel of Ixion (after "Kingmaker Level 7");
#   - Progression ac94328c (Kingmaker level 9): PassivesAdded Succession, the Court's third circle; AddSpells(<list>).
# Exact anchors, each must match once; nothing is written otherwise; idempotent (stops if the list exists).
#   perl 51_uuid.pl BACKUP_DIR            shows what it would do
#   perl 51_uuid.pl BACKUP_DIR --apply    writes ([fechado] ARC-0008)
use strict; use warnings;
use Digest::MD5 qw(md5_hex);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $bk = shift or die "usage: 51_uuid.pl BACKUP_DIR [--apply]\n";
my $apply = grep { $_ eq '--apply' } @ARGV;
sub uuid { my @h = unpack '(A4)8', md5_hex('arcana-kingmaker:' . shift);
    $h[3] = sprintf('4%03x', hex($h[3]) & 0x0fff); $h[4] = sprintf('%04x', (hex($h[4]) & 0x3fff) | 0x8000);
    "$h[0]$h[1]-$h[2]-$h[3]-$h[4]-$h[5]$h[6]$h[7]" }
my $LIST   = uuid('Kingmaker Level 9');
my $SPELLS = 'Zone_Arcana_Card_Spell_WheelOfIxion';
my $PASS   = 'Arcana_Passive_Succession;Arcana_Passive_Court_Level9';
my $ROW    = 'ac94328c-98f4-4068-805d-5a6e39b8ecb2';
my $L7     = 'bb58ab5e-e55f-44d2-83e9-1527b9e543a5';   # "Kingmaker Level 7", the list this one follows
my %F = (lsx_list => "$G/Public/$M/Lists/SpellLists.lsx",          tbl_list => "$G/Editor/Mods/$M/Lists/SpellLists.tbl",
         lsx_prog => "$G/Public/$M/Progressions/Progressions.lsx", tbl_prog => "$G/Editor/Mods/$M/Progressions/Progressions.tbl");
my (%s, %orig);
for my $k (keys %F) { open my $h, '<:raw', $F{$k} or die "$F{$k}: $!"; local $/; $s{$k} = $orig{$k} = <$h>; close $h }
if (index($s{lsx_list}, 'value="Kingmaker Level 9"') >= 0) { print "already done (list exists)\n"; exit 0 }
my $bad = 0;
sub once { my ($k, $re, $code, $what) = @_;
    my @m; my $n = 0; while ($s{$k} =~ /$re/g) { $n++; @m = map { substr($s{$k}, $-[$_], $+[$_] - $-[$_]) } 1 .. $#- }
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s{$k} =~ s/$re/$m[0] . $code->(@m)/e; print(($apply ? 'write  ' : 'would  ') . "$what\n") }

# 1. the spell list, right after "Kingmaker Level 7"
once('lsx_list',
    qr{(<node id="SpellList">(\r?\n)([ \t]+)<attribute id="Name" type="FixedString" value="Kingmaker Level 7"/>\r?\n(?:[ \t]+<attribute [^\n]*\n){2}([ \t]+)</node>\r?\n)},
    sub { my (undef, $nl, $in, $out) = @_;
          "$out<node id=\"SpellList\">$nl"
        . "$in<attribute id=\"Name\" type=\"FixedString\" value=\"Kingmaker Level 9\"/>$nl"
        . "$in<attribute id=\"Spells\" type=\"LSString\" value=\"$SPELLS\"/>$nl"
        . "$in<attribute id=\"UUID\" type=\"guid\" value=\"$LIST\"/>$nl"
        . "$out</node>$nl" },
    'SpellLists.lsx: + Kingmaker Level 9');
once('tbl_list',
    qr{(([ \t]+)<stat_object([^>]*)>(\r?\n)[ \t]+<fields>\r?\n[ \t]+<field name="UUID" type="IdTableFieldDefinition" value="$L7" />\r?\n(?:[^\n]*\n)*?[ \t]+</stat_object>\r?\n)},
    sub { my (undef, $ind, $attrs, $nl) = @_;
          "$ind<stat_object$attrs>$nl      <fields>$nl"
        . "        <field name=\"UUID\" type=\"IdTableFieldDefinition\" value=\"$LIST\" />$nl"
        . "        <field name=\"Name\" type=\"NameTableFieldDefinition\" value=\"Kingmaker Level 9\" />$nl"
        . "        <field name=\"Spells\" type=\"StringTableFieldDefinition\" value=\"$SPELLS\" />$nl"
        . "      </fields>$nl$ind</stat_object>$nl" },
    'SpellLists.tbl: + Kingmaker Level 9');

# 2. progression level 9: PassivesAdded after Name, Selectors after ProgressionType
once('lsx_prog',
    qr{(<attribute id="Level" type="uint8" value="9"/>\r?\n([ \t]+)<attribute id="Name" type="LSString" value="Kingmaker"/>(\r?\n))(?=[ \t]+<attribute id="ProgressionType" type="uint8" value="1"/>\r?\n[ \t]+<attribute id="TableUUID" type="guid" value="a688d11f-edff-44c5-95ac-0e4999ebf876"/>\r?\n[ \t]+<attribute id="UUID" type="guid" value="$ROW"/>)},
    sub { my (undef, $in, $nl) = @_; "$in<attribute id=\"PassivesAdded\" type=\"LSString\" value=\"$PASS\"/>$nl" },
    'Progressions.lsx: level 9 PassivesAdded');
once('lsx_prog',
    qr{(<attribute id="PassivesAdded" type="LSString" value="$PASS"/>\r?\n([ \t]+)<attribute id="ProgressionType" type="uint8" value="1"/>(\r?\n))(?=[ \t]+<attribute id="TableUUID" type="guid" value="a688d11f-edff-44c5-95ac-0e4999ebf876"/>\r?\n[ \t]+<attribute id="UUID" type="guid" value="$ROW"/>)},
    sub { my (undef, $in, $nl) = @_; "$in<attribute id=\"Selectors\" type=\"LSString\" value=\"AddSpells($LIST,,,,AlwaysPrepared)\"/>$nl" },
    'Progressions.lsx: level 9 Selectors');
once('tbl_prog',
    qr{(<field name="UUID" type="IdTableFieldDefinition" value="$ROW" />\r?\n(?:[ \t]+<field [^\n]*\n){3}([ \t]+)<field name="ProgressionType" type="ByteTableFieldDefinition" value="1" />(\r?\n))(?=[ \t]+</fields>)},
    sub { my (undef, $in, $nl) = @_;
          "$in<field name=\"PassivesAdded\" type=\"StringTableFieldDefinition\" value=\"$PASS\" />$nl"
        . "$in<field name=\"Selectors\" type=\"StringTableFieldDefinition\" value=\"AddSpells($LIST,,,,AlwaysPrepared)\" />$nl" },
    'Progressions.tbl: level 9 PassivesAdded, Selectors');

die "nothing written\n" if $bad;
print "list UUID: $LIST\n";
exit 0 unless $apply;
mkdir $bk;
for my $k (sort keys %F) { (my $b = $F{$k}) =~ s{.*/}{};
    open my $o, '>:raw', "$bk/$b.orig" or die "$bk: $!"; print $o $orig{$k}; close $o;
    open my $w, '>:raw', $F{$k} or die "$F{$k}: $!"; print $w $s{$k}; close $w; print "written $b\n" }
