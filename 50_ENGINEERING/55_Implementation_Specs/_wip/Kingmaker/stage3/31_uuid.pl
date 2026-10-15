#!/usr/bin/perl
# ARC-0008 stage 3: the UUID Object Editor side, written on both sides (Public .lsx = the game, Editor .tbl = the Toolkit).
#   - new spell list "Kingmaker Level 5": Peripeteia and Convene the Court;
#   - Progression 856b4cd7 (Kingmaker level 5) gets Selectors AddSpells(<that list>,,,,AlwaysPrepared).
# Exact anchors, each must match once; nothing is written otherwise; idempotent (stops if the list exists).
# Line endings: each insertion reuses the ending of the block it follows (the Toolkit's .tbl files mix CRLF and LF).
#   perl 31_uuid.pl BACKUP_DIR            shows what it would do
#   perl 31_uuid.pl BACKUP_DIR --apply    writes ([fechado] ARC-0008)
use strict; use warnings;
use Digest::MD5 qw(md5_hex);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $bk = shift or die "usage: 31_uuid.pl BACKUP_DIR [--apply]\n";
my $apply = grep { $_ eq '--apply' } @ARGV;
sub uuid { my @h = unpack '(A4)8', md5_hex('arcana-kingmaker:' . shift);
    $h[3] = sprintf('4%03x', hex($h[3]) & 0x0fff); $h[4] = sprintf('%04x', (hex($h[4]) & 0x3fff) | 0x8000);
    "$h[0]$h[1]-$h[2]-$h[3]-$h[4]-$h[5]$h[6]$h[7]" }
my $LIST   = uuid('Kingmaker Level 5');
my $SPELLS = 'Shout_Arcana_Card_Spell_Peripeteia;Target_Arcana_Util_ConveneTheCourt';
my $ROW    = '856b4cd7-2846-4303-860c-23b118a3c24c';
my $L3     = 'f48fbecb-c8b6-4837-a3f9-270a905caa19';
my %F = (lsx_list => "$G/Public/$M/Lists/SpellLists.lsx",       tbl_list => "$G/Editor/Mods/$M/Lists/SpellLists.tbl",
         lsx_prog => "$G/Public/$M/Progressions/Progressions.lsx", tbl_prog => "$G/Editor/Mods/$M/Progressions/Progressions.tbl");
my (%s, %orig);
for my $k (keys %F) { open my $h, '<:raw', $F{$k} or die "$F{$k}: $!"; local $/; $s{$k} = $orig{$k} = <$h>; close $h }
if (index($s{lsx_list}, 'value="Kingmaker Level 5"') >= 0) { print "already done (list exists)\n"; exit 0 }
my $bad = 0;
# $code gets the captures as arguments (never reads $1 itself)
sub once { my ($k, $re, $code, $what) = @_;
    my @m; my $n = 0; while ($s{$k} =~ /$re/g) { $n++; @m = map { substr($s{$k}, $-[$_], $+[$_] - $-[$_]) } 1 .. $#- }
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s{$k} =~ s/$re/$m[0] . $code->(@m)/e; print(($apply ? 'write  ' : 'would  ') . "$what\n") }

# 1. the spell list, right after "Kingmaker Level 3"
once('lsx_list',
    qr{(<node id="SpellList">(\r?\n)([ \t]+)<attribute id="Name" type="FixedString" value="Kingmaker Level 3"/>\r?\n(?:[ \t]+<attribute [^\n]*\n){2}([ \t]+)</node>\r?\n)},
    sub { my (undef, $nl, $in, $out) = @_;
          "$out<node id=\"SpellList\">$nl"
        . "$in<attribute id=\"Name\" type=\"FixedString\" value=\"Kingmaker Level 5\"/>$nl"
        . "$in<attribute id=\"Spells\" type=\"LSString\" value=\"$SPELLS\"/>$nl"
        . "$in<attribute id=\"UUID\" type=\"guid\" value=\"$LIST\"/>$nl"
        . "$out</node>$nl" },
    'SpellLists.lsx: + Kingmaker Level 5');
once('tbl_list',
    qr{(([ \t]+)<stat_object([^>]*)>(\r?\n)[ \t]+<fields>\r?\n[ \t]+<field name="UUID" type="IdTableFieldDefinition" value="$L3" />\r?\n(?:[^\n]*\n)*?[ \t]+</stat_object>\r?\n)},
    sub { my (undef, $ind, $attrs, $nl) = @_;
          "$ind<stat_object$attrs>$nl      <fields>$nl"
        . "        <field name=\"UUID\" type=\"IdTableFieldDefinition\" value=\"$LIST\" />$nl"
        . "        <field name=\"Name\" type=\"NameTableFieldDefinition\" value=\"Kingmaker Level 5\" />$nl"
        . "        <field name=\"Spells\" type=\"StringTableFieldDefinition\" value=\"$SPELLS\" />$nl"
        . "      </fields>$nl$ind</stat_object>$nl" },
    'SpellLists.tbl: + Kingmaker Level 5');

# 2. progression level 5: Selectors right after ProgressionType (the attribute / field order of the level-3 row)
once('lsx_prog',
    qr{(<attribute id="Level" type="uint8" value="5"/>\r?\n[ \t]+<attribute id="Name" type="LSString" value="Kingmaker"/>\r?\n([ \t]+)<attribute id="ProgressionType" type="uint8" value="1"/>(\r?\n))(?=[ \t]+<attribute id="TableUUID" type="guid" value="a688d11f-edff-44c5-95ac-0e4999ebf876"/>\r?\n[ \t]+<attribute id="UUID" type="guid" value="$ROW"/>)},
    sub { my (undef, $in, $nl) = @_; "$in<attribute id=\"Selectors\" type=\"LSString\" value=\"AddSpells($LIST,,,,AlwaysPrepared)\"/>$nl" },
    'Progressions.lsx: level 5 Selectors');
once('tbl_prog',
    qr{(<field name="UUID" type="IdTableFieldDefinition" value="$ROW" />\r?\n(?:[ \t]+<field [^\n]*\n){3}([ \t]+)<field name="ProgressionType" type="ByteTableFieldDefinition" value="1" />(\r?\n))(?=[ \t]+</fields>)},
    sub { my (undef, $in, $nl) = @_; "$in<field name=\"Selectors\" type=\"StringTableFieldDefinition\" value=\"AddSpells($LIST,,,,AlwaysPrepared)\" />$nl" },
    'Progressions.tbl: level 5 Selectors');

die "nothing written\n" if $bad;
print "list UUID: $LIST\n";
exit 0 unless $apply;
mkdir $bk;
for my $k (sort keys %F) { (my $b = $F{$k}) =~ s{.*/}{};
    open my $o, '>:raw', "$bk/$b.orig" or die "$bk: $!"; print $o $orig{$k}; close $o;
    open my $w, '>:raw', $F{$k} or die "$F{$k}: $!"; print $w $s{$k}; close $w; print "written $b\n" }
