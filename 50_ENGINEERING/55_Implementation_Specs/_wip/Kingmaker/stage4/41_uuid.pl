#!/usr/bin/perl
# ARC-0008 stage 4: the UUID Object Editor side, both sides (Public .lsx = the game, Editor .tbl = the Toolkit).
#   - spell list "Kingmaker Level 7": Usurp (after "Kingmaker Level 5");
#   - Progression 743d27d7 (Kingmaker level 7): PassivesAdded Hubris, Tier II, the Court's second circle; AddSpells(<list>);
#   - LevelMap Kingmaker_CrossingHubris: Kingmaker_Crossing's node copied with one more die (FEAT_Kingmaker_Hubris#extra_dice).
# Exact anchors, each must match once; nothing is written otherwise; idempotent (stops if the list exists).
#   perl 41_uuid.pl BACKUP_DIR            shows what it would do
#   perl 41_uuid.pl BACKUP_DIR --apply    writes ([fechado] ARC-0008)
use strict; use warnings;
use Digest::MD5 qw(md5_hex);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $bk = shift or die "usage: 41_uuid.pl BACKUP_DIR [--apply]\n";
my $apply = grep { $_ eq '--apply' } @ARGV;
sub uuid { my @h = unpack '(A4)8', md5_hex('arcana-kingmaker:' . shift);
    $h[3] = sprintf('4%03x', hex($h[3]) & 0x0fff); $h[4] = sprintf('%04x', (hex($h[4]) & 0x3fff) | 0x8000);
    "$h[0]$h[1]-$h[2]-$h[3]-$h[4]-$h[5]$h[6]$h[7]" }
my $LIST   = uuid('Kingmaker Level 7');
my $LMAP   = uuid('Kingmaker_CrossingHubris');
my $SPELLS = 'Target_Arcana_Card_Spell_Usurp';
my $PASS   = 'Arcana_Passive_Hubris;Arcana_Passive_Aspect_WheelOfFortune_II;Arcana_Passive_Court_Level7';
my $ROW    = '743d27d7-27a0-414a-bbad-1407a944df0b';
my $L5     = '293ae797-c86c-41fd-a0e0-dff628b1ea57';
my $XMAP   = 'cbcd0570-33d1-4182-a148-9770802881f3';   # Kingmaker_Crossing
my %F = (lsx_list => "$G/Public/$M/Lists/SpellLists.lsx",            tbl_list => "$G/Editor/Mods/$M/Lists/SpellLists.tbl",
         lsx_prog => "$G/Public/$M/Progressions/Progressions.lsx",   tbl_prog => "$G/Editor/Mods/$M/Progressions/Progressions.tbl",
         lsx_map  => "$G/Public/$M/Levelmaps/LevelMapValues.lsx",    tbl_map  => "$G/Editor/Mods/$M/Levelmaps/LevelMapValues.tbl");
my (%s, %orig);
for my $k (keys %F) { open my $h, '<:raw', $F{$k} or die "$F{$k}: $!"; local $/; $s{$k} = $orig{$k} = <$h>; close $h }
if (index($s{lsx_list}, 'value="Kingmaker Level 7"') >= 0) { print "already done (list exists)\n"; exit 0 }
my $bad = 0;
sub once { my ($k, $re, $code, $what) = @_;
    my @m; my $n = 0; while ($s{$k} =~ /$re/g) { $n++; @m = map { substr($s{$k}, $-[$_], $+[$_] - $-[$_]) } 1 .. $#- }
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s{$k} =~ s/$re/$m[0] . $code->(@m)/e; print(($apply ? 'write  ' : 'would  ') . "$what\n") }
sub hubris { my $b = shift; $b =~ s/value="1d(\d+)"/value="2d$1"/g; $b =~ s/value="Kingmaker_Crossing"/value="Kingmaker_CrossingHubris"/; $b =~ s/value="$XMAP"/value="$LMAP"/; $b }

# 1. the spell list, right after "Kingmaker Level 5"
once('lsx_list',
    qr{(<node id="SpellList">(\r?\n)([ \t]+)<attribute id="Name" type="FixedString" value="Kingmaker Level 5"/>\r?\n(?:[ \t]+<attribute [^\n]*\n){2}([ \t]+)</node>\r?\n)},
    sub { my (undef, $nl, $in, $out) = @_;
          "$out<node id=\"SpellList\">$nl"
        . "$in<attribute id=\"Name\" type=\"FixedString\" value=\"Kingmaker Level 7\"/>$nl"
        . "$in<attribute id=\"Spells\" type=\"LSString\" value=\"$SPELLS\"/>$nl"
        . "$in<attribute id=\"UUID\" type=\"guid\" value=\"$LIST\"/>$nl"
        . "$out</node>$nl" },
    'SpellLists.lsx: + Kingmaker Level 7');
once('tbl_list',
    qr{(([ \t]+)<stat_object([^>]*)>(\r?\n)[ \t]+<fields>\r?\n[ \t]+<field name="UUID" type="IdTableFieldDefinition" value="$L5" />\r?\n(?:[^\n]*\n)*?[ \t]+</stat_object>\r?\n)},
    sub { my (undef, $ind, $attrs, $nl) = @_;
          "$ind<stat_object$attrs>$nl      <fields>$nl"
        . "        <field name=\"UUID\" type=\"IdTableFieldDefinition\" value=\"$LIST\" />$nl"
        . "        <field name=\"Name\" type=\"NameTableFieldDefinition\" value=\"Kingmaker Level 7\" />$nl"
        . "        <field name=\"Spells\" type=\"StringTableFieldDefinition\" value=\"$SPELLS\" />$nl"
        . "      </fields>$nl$ind</stat_object>$nl" },
    'SpellLists.tbl: + Kingmaker Level 7');

# 2. progression level 7: PassivesAdded after Name, Selectors after ProgressionType (the level-3 row's order)
once('lsx_prog',
    qr{(<attribute id="Level" type="uint8" value="7"/>\r?\n([ \t]+)<attribute id="Name" type="LSString" value="Kingmaker"/>(\r?\n))(?=[ \t]+<attribute id="ProgressionType" type="uint8" value="1"/>\r?\n[ \t]+<attribute id="TableUUID" type="guid" value="a688d11f-edff-44c5-95ac-0e4999ebf876"/>\r?\n[ \t]+<attribute id="UUID" type="guid" value="$ROW"/>)},
    sub { my (undef, $in, $nl) = @_; "$in<attribute id=\"PassivesAdded\" type=\"LSString\" value=\"$PASS\"/>$nl" },
    'Progressions.lsx: level 7 PassivesAdded');
once('lsx_prog',
    qr{(<attribute id="PassivesAdded" type="LSString" value="$PASS"/>\r?\n([ \t]+)<attribute id="ProgressionType" type="uint8" value="1"/>(\r?\n))(?=[ \t]+<attribute id="TableUUID" type="guid" value="a688d11f-edff-44c5-95ac-0e4999ebf876"/>\r?\n[ \t]+<attribute id="UUID" type="guid" value="$ROW"/>)},
    sub { my (undef, $in, $nl) = @_; "$in<attribute id=\"Selectors\" type=\"LSString\" value=\"AddSpells($LIST,,,,AlwaysPrepared)\"/>$nl" },
    'Progressions.lsx: level 7 Selectors');
once('tbl_prog',
    qr{(<field name="UUID" type="IdTableFieldDefinition" value="$ROW" />\r?\n(?:[ \t]+<field [^\n]*\n){3}([ \t]+)<field name="ProgressionType" type="ByteTableFieldDefinition" value="1" />(\r?\n))(?=[ \t]+</fields>)},
    sub { my (undef, $in, $nl) = @_;
          "$in<field name=\"PassivesAdded\" type=\"StringTableFieldDefinition\" value=\"$PASS\" />$nl"
        . "$in<field name=\"Selectors\" type=\"StringTableFieldDefinition\" value=\"AddSpells($LIST,,,,AlwaysPrepared)\" />$nl" },
    'Progressions.tbl: level 7 PassivesAdded, Selectors');

# 3. the Hubris level map: a copy of Kingmaker_Crossing right after it
once('lsx_map',
    qr{(([ \t]+)<node id="LevelMapSeries">\r?\n(?:(?![ \t]+</node>)[^\n]*\n)*?[ \t]+<attribute id="UUID" type="guid" value="$XMAP"/>\r?\n[ \t]+</node>\r?\n)},
    sub { hubris($_[0]) }, 'LevelMapValues.lsx: + Kingmaker_CrossingHubris');
once('tbl_map',
    qr{(([ \t]+)<stat_object[^>]*>\r?\n[ \t]+<fields>\r?\n[ \t]+<field name="Name" type="NameTableFieldDefinition" value="Kingmaker_Crossing" />\r?\n(?:[^\n]*\n)*?[ \t]+</stat_object>\r?\n)},
    sub { hubris($_[0]) }, 'LevelMapValues.tbl: + Kingmaker_CrossingHubris');

die "nothing written\n" if $bad;
print "list UUID: $LIST   levelmap UUID: $LMAP\n";
exit 0 unless $apply;
mkdir $bk;
for my $k (sort keys %F) { (my $b = $F{$k}) =~ s{.*/}{};
    open my $o, '>:raw', "$bk/$b.orig" or die "$bk: $!"; print $o $orig{$k}; close $o;
    open my $w, '>:raw', $F{$k} or die "$F{$k}: $!"; print $w $s{$k}; close $w; print "written $b\n" }
