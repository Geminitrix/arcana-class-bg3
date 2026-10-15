#!/usr/bin/perl
# ARC-0008 stage 6: the UUID Object Editor side, both sides (Public .lsx = the game, Editor .tbl = the Toolkit).
#   - spell list "Kingmaker Level 11": The Wheel Stops (after "Kingmaker Level 9");
#   - Progression 10cd57aa (Kingmaker level 11): Selectors AddSpells(<list>);
#   - Progression 599e1b1a (Kingmaker level 12): PassivesAdded Fortune's Reach, Tier III (Aspect of Anticipation).
# Exact anchors, each must match once; nothing is written otherwise; idempotent (stops if the list exists).
#   perl 61_uuid.pl BACKUP_DIR            shows what it would do
#   perl 61_uuid.pl BACKUP_DIR --apply    writes ([fechado] ARC-0008)
use strict; use warnings;
use Digest::MD5 qw(md5_hex);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $bk = shift or die "usage: 61_uuid.pl BACKUP_DIR [--apply]\n";
my $apply = grep { $_ eq '--apply' } @ARGV;
sub uuid { my @h = unpack '(A4)8', md5_hex('arcana-kingmaker:' . shift);
    $h[3] = sprintf('4%03x', hex($h[3]) & 0x0fff); $h[4] = sprintf('%04x', (hex($h[4]) & 0x3fff) | 0x8000);
    "$h[0]$h[1]-$h[2]-$h[3]-$h[4]-$h[5]$h[6]$h[7]" }
my $LIST   = uuid('Kingmaker Level 11');
my $SPELLS = 'Shout_Arcana_Card_Spell_TheWheelStops';
my $PASS12 = 'Arcana_Passive_FortunesReach;Arcana_Passive_Aspect_WheelOfFortune_III';
my $ROW11  = '10cd57aa-594a-4828-b934-1ed04d46d613';
my $ROW12  = '599e1b1a-c8cd-47d1-b790-c169bca584bb';
my $L9     = 'ceaf01b3-f829-4df9-9dbc-2d207ee56891';   # "Kingmaker Level 9", the list this one follows
my $TABLE  = 'a688d11f-edff-44c5-95ac-0e4999ebf876';
my %F = (lsx_list => "$G/Public/$M/Lists/SpellLists.lsx",          tbl_list => "$G/Editor/Mods/$M/Lists/SpellLists.tbl",
         lsx_prog => "$G/Public/$M/Progressions/Progressions.lsx", tbl_prog => "$G/Editor/Mods/$M/Progressions/Progressions.tbl");
my (%s, %orig);
for my $k (keys %F) { open my $h, '<:raw', $F{$k} or die "$F{$k}: $!"; local $/; $s{$k} = $orig{$k} = <$h>; close $h }
if (index($s{lsx_list}, 'value="Kingmaker Level 11"') >= 0) { print "already done (list exists)\n"; exit 0 }
my $bad = 0;
sub once { my ($k, $re, $code, $what) = @_;
    my @m; my $n = 0; while ($s{$k} =~ /$re/g) { $n++; @m = map { substr($s{$k}, $-[$_], $+[$_] - $-[$_]) } 1 .. $#- }
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s{$k} =~ s/$re/$m[0] . $code->(@m)/e; print(($apply ? 'write  ' : 'would  ') . "$what\n") }

# 1. the spell list, right after "Kingmaker Level 9"
once('lsx_list',
    qr{(<node id="SpellList">(\r?\n)([ \t]+)<attribute id="Name" type="FixedString" value="Kingmaker Level 9"/>\r?\n(?:[ \t]+<attribute [^\n]*\n){2}([ \t]+)</node>\r?\n)},
    sub { my (undef, $nl, $in, $out) = @_;
          "$out<node id=\"SpellList\">$nl"
        . "$in<attribute id=\"Name\" type=\"FixedString\" value=\"Kingmaker Level 11\"/>$nl"
        . "$in<attribute id=\"Spells\" type=\"LSString\" value=\"$SPELLS\"/>$nl"
        . "$in<attribute id=\"UUID\" type=\"guid\" value=\"$LIST\"/>$nl"
        . "$out</node>$nl" },
    'SpellLists.lsx: + Kingmaker Level 11');
once('tbl_list',
    qr{(([ \t]+)<stat_object([^>]*)>(\r?\n)[ \t]+<fields>\r?\n[ \t]+<field name="UUID" type="IdTableFieldDefinition" value="$L9" />\r?\n(?:[^\n]*\n)*?[ \t]+</stat_object>\r?\n)},
    sub { my (undef, $ind, $attrs, $nl) = @_;
          "$ind<stat_object$attrs>$nl      <fields>$nl"
        . "        <field name=\"UUID\" type=\"IdTableFieldDefinition\" value=\"$LIST\" />$nl"
        . "        <field name=\"Name\" type=\"NameTableFieldDefinition\" value=\"Kingmaker Level 11\" />$nl"
        . "        <field name=\"Spells\" type=\"StringTableFieldDefinition\" value=\"$SPELLS\" />$nl"
        . "      </fields>$nl$ind</stat_object>$nl" },
    'SpellLists.tbl: + Kingmaker Level 11');

# 2. level 11: Selectors after ProgressionType
once('lsx_prog',
    qr{(<attribute id="Level" type="uint8" value="11"/>\r?\n[ \t]+<attribute id="Name" type="LSString" value="Kingmaker"/>\r?\n([ \t]+)<attribute id="ProgressionType" type="uint8" value="1"/>(\r?\n))(?=[ \t]+<attribute id="TableUUID" type="guid" value="$TABLE"/>\r?\n[ \t]+<attribute id="UUID" type="guid" value="$ROW11"/>)},
    sub { my (undef, $in, $nl) = @_; "$in<attribute id=\"Selectors\" type=\"LSString\" value=\"AddSpells($LIST,,,,AlwaysPrepared)\"/>$nl" },
    'Progressions.lsx: level 11 Selectors');
once('tbl_prog',
    qr{(<field name="UUID" type="IdTableFieldDefinition" value="$ROW11" />\r?\n(?:[ \t]+<field [^\n]*\n){3}([ \t]+)<field name="ProgressionType" type="ByteTableFieldDefinition" value="1" />(\r?\n))(?=[ \t]+</fields>)},
    sub { my (undef, $in, $nl) = @_; "$in<field name=\"Selectors\" type=\"StringTableFieldDefinition\" value=\"AddSpells($LIST,,,,AlwaysPrepared)\" />$nl" },
    'Progressions.tbl: level 11 Selectors');

# 3. level 12: PassivesAdded after Name (.lsx), after ProgressionType (.tbl)
once('lsx_prog',
    qr{(<attribute id="Level" type="uint8" value="12"/>\r?\n([ \t]+)<attribute id="Name" type="LSString" value="Kingmaker"/>(\r?\n))(?=[ \t]+<attribute id="ProgressionType" type="uint8" value="1"/>\r?\n[ \t]+<attribute id="TableUUID" type="guid" value="$TABLE"/>\r?\n[ \t]+<attribute id="UUID" type="guid" value="$ROW12"/>)},
    sub { my (undef, $in, $nl) = @_; "$in<attribute id=\"PassivesAdded\" type=\"LSString\" value=\"$PASS12\"/>$nl" },
    'Progressions.lsx: level 12 PassivesAdded');
once('tbl_prog',
    qr{(<field name="UUID" type="IdTableFieldDefinition" value="$ROW12" />\r?\n(?:[ \t]+<field [^\n]*\n){3}([ \t]+)<field name="ProgressionType" type="ByteTableFieldDefinition" value="1" />(\r?\n))(?=[ \t]+</fields>)},
    sub { my (undef, $in, $nl) = @_; "$in<field name=\"PassivesAdded\" type=\"StringTableFieldDefinition\" value=\"$PASS12\" />$nl" },
    'Progressions.tbl: level 12 PassivesAdded');

die "nothing written\n" if $bad;
print "list UUID: $LIST\n";
exit 0 unless $apply;
mkdir $bk;
for my $k (sort keys %F) { (my $b = $F{$k}) =~ s{.*/}{};
    open my $o, '>:raw', "$bk/$b.orig" or die "$bk: $!"; print $o $orig{$k}; close $o;
    open my $w, '>:raw', $F{$k} or die "$F{$k}: $!"; print $w $s{$k}; close $w; print "written $b\n" }
