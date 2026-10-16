#!/usr/bin/perl
# ARC-0017: the Resonant's progression, stage by stage (SPEC_ARC-0017, task 0.13). ARC17_STAGE=N is cumulative:
#   2  Emotional Overload is granted at level 1 (R51; rank I) instead of 5
#   3  the Weave Surge container replaces the eight emotions in the level lists (R54); level 5 grants no list
#   4  the spread map (R59): Temper at 2 (the old level-3 list, renamed), Opposites at 3 (R60), Deeper Feelings at
#      5 and 9 (R62), Complex Feelings at 6, Ready: Compassion at 10 (a new list), Shared Heart alone at 11
# Every change goes to the game's LSX and the Toolkit's TBL together; the Resonant's nodes exist at every level, so
# only attributes change. Idempotent; stops at a missing anchor. Test: ARC-0017/t_progression.t (a scratch copy).
#   ARC17_STAGE=N perl 64_progression_arc0017.pl            # shows what it would do
#   ARC17_STAGE=N perl 64_progression_arc0017.pl --apply    # writes (game and Toolkit closed, [fechado] ARC-0017)
use strict; use warnings;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my $ST = $ENV{ARC17_STAGE} // 0;

my $C = 'Target_Arcana_Card_Spell_'; my $P = 'Arcana_Passive_'; my $EO = 'Target_Arcana_Created_EmotionalOverload';
my %UUID = (L1 => '05269c79-116f-2b07-6dc1-deeefddc7ae4', L3 => '74e89dac-4330-83f6-cf7b-881854bd4663', L5 => 'e0d34d66-e311-be56-1810-04f9ba0917fd',
            L9 => 'f015022c-43e0-42f3-8f0a-0ab542e8641d', L10 => 'e9fb9260-2979-4c45-b326-59886e342963', L11 => 'e7063c7e-67e5-4887-8f3a-8ed09a03340f');
my %RESONANT_LIST = map { $_ => 1 } values %UUID;

# ---- the target state (ARC-0002 first, then each stage on top)
my %pass = (1 => "${P}EmotionalAlchemy;${P}EmpathicSight;${P}Overload", 3 => "${P}Aspect_Temperance_I;${P}Aspect_Temperance_Awakening",
            5 => "${P}ComplexFeelings", 7 => "${P}Overwhelm;${P}Aspect_Temperance_II", 9 => "${P}MixedFeelings", 12 => "${P}Aspect_Temperance_III");
my %list = (1 => 'L1', 3 => 'L3', 5 => 'L5', 9 => 'L9', 11 => 'L11');
my %spells = (L1 => "${C}EmotionJoy;${C}EmotionTrust;${C}EmotionFear;${C}Heartstring",
              L3 => "${C}EmotionAnticipation;${C}EmotionSurprise;${C}EmotionSadness;${C}Temper",
              L5 => "${C}EmotionDisgust;${C}EmotionAnger;$EO", L9 => "${C}EmotionalContagion",
              L11 => 'Shout_Arcana_Card_Passive_Compassion;Shout_Arcana_Card_Spell_SharedHeart');
my %name = (L1 => 'Resonant Level 1', L3 => 'Resonant Level 3', L5 => 'Resonant Level 5', L9 => 'Resonant Level 9', L11 => 'Resonant Level 11');
if ($ST >= 2) { $spells{L1} .= ";$EO"; $spells{L5} = "${C}EmotionDisgust;${C}EmotionAnger" }
if ($ST >= 3) { $spells{L1} = "${C}WeaveSurge;${C}Heartstring;$EO"; $spells{L3} = "${C}Temper"; delete $list{5} }
if ($ST >= 4) {
    $list{2} = 'L3'; delete $list{3}; $name{L3} = 'Resonant Level 2';
    $pass{3} .= ";${P}Opposites"; $pass{5} = "${P}DeeperFeelings_5"; $pass{6} = "${P}ComplexFeelings"; $pass{9} .= ";${P}DeeperFeelings_9";
    $list{10} = 'L10'; $spells{L10} = 'Shout_Arcana_Card_Passive_Compassion'; $name{L10} = 'Resonant Level 10';
    $spells{L11} = 'Shout_Arcana_Card_Spell_SharedHeart';
}

my ($bad, $changes) = (0, 0);
sub rd { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s }
sub wr { my ($f, $s) = @_; return unless $apply; open my $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h }
sub say_ { $changes++; print(($apply ? 'write    ' : 'would    ') . "$_[0]\n") }
sub nl { $_[0] =~ /\r\n/ ? "\r\n" : "\n" }
# a Selectors value with the Resonant's own list swapped (other selectors -- the level-1 creation row's -- stay)
sub selectors { my ($old, $lst) = @_;
    my @s = grep { length && !(/^AddSpells\(([0-9a-f-]+),/ && $RESONANT_LIST{$1}) } split /;/, $old // '';
    my $add = $lst ? "AddSpells($UUID{$lst},,,,AlwaysPrepared)" : undef;
    my ($i) = grep { ($old // '') =~ /AddSpells\(\Q$UUID{$_}\E,/ } keys %UUID;   # keep the position of the old one
    my @parts = split /;/, $old // ''; my @out; my $placed = 0;
    for my $p (@parts) { next unless length $p;
        if ($p =~ /^AddSpells\(([0-9a-f-]+),/ && $RESONANT_LIST{$1}) { if ($add && !$placed) { push @out, $add; $placed = 1 } next }
        push @out, $p }
    push @out, $add if $add && !$placed;
    join ';', @out }

# ---- Progressions (LSX: attributes in alphabetical order; TBL: fields appended before </fields>)
{
    my $f = "$G/Public/$M/Progressions/Progressions.lsx"; my $s = rd($f); my $n = nl($s); my $before = $s;
    $s =~ s{(<node id="Progression">)(.*?)(\s*</node>)}{ my ($o, $b, $c) = ($1, $2, $3);
        if ($b =~ /id="Name" type="LSString" value="Resonant"/ && $b =~ /id="Level" type="uint8" value="(\d+)"/ && $1 <= 12) {
            my $l = $1; my ($ind) = $b =~ /\n([ \t]*)<attribute/;
            my ($op) = $b =~ /id="PassivesAdded" type="LSString" value="([^"]*)"/; my ($os) = $b =~ /id="Selectors" type="LSString" value="([^"]*)"/;
            my ($np, $ns) = ($pass{$l} // '', selectors($os, $list{$l}));
            if (($op // '') ne $np) { say_("L$l passives: '" . ($op // '') . "' -> '$np' (LSX)");
                $b =~ s/\r?\n[ \t]*<attribute id="PassivesAdded" [^\n]*//;
                $b =~ s/(\r?\n[ \t]*<attribute id="ProgressionType")/$n$ind<attribute id="PassivesAdded" type="LSString" value="$np"\/>$1/ if length $np }
            if (($os // '') ne $ns) { say_("L$l selectors: '" . ($os // '') . "' -> '$ns' (LSX)");
                $b =~ s/\r?\n[ \t]*<attribute id="Selectors" [^\n]*//;
                $b =~ s/(\r?\n[ \t]*<attribute id="TableUUID")/$n$ind<attribute id="Selectors" type="LSString" value="$ns"\/>$1/ if length $ns }
        }
        "$o$b$c" }sge;
    wr($f, $s) if $s ne $before;
}
{
    my $f = "$G/Editor/Mods/$M/Progressions/Progressions.tbl"; my $s = rd($f); my $n = nl($s); my $before = $s;
    $s =~ s{(<stat_object[^>]*>)(.*?)(</stat_object>)}{ my ($o, $b, $c) = ($1, $2, $3);
        if ($b =~ /name="FSName" type="StringTableFieldDefinition" value="Resonant"/ && $b =~ /name="Level" type="ByteTableFieldDefinition" value="(\d+)"/ && $1 <= 12) {
            my $l = $1; my ($ind) = $b =~ /\n([ \t]*)<field/;
            my ($op) = $b =~ /name="PassivesAdded" type="StringTableFieldDefinition" value="([^"]*)"/; my ($os) = $b =~ /name="Selectors" type="StringTableFieldDefinition" value="([^"]*)"/;
            my ($np, $ns) = ($pass{$l} // '', selectors($os, $list{$l}));
            if (($op // '') ne $np) { say_("L$l passives (TBL)");
                $b =~ s/\r?\n[ \t]*<field name="PassivesAdded" [^\n]*//;
                $b =~ s/(\r?\n[ \t]*<\/fields>)/$n$ind<field name="PassivesAdded" type="StringTableFieldDefinition" value="$np" \/>$1/ if length $np }
            if (($os // '') ne $ns) { say_("L$l selectors (TBL)");
                $b =~ s/\r?\n[ \t]*<field name="Selectors" [^\n]*//;
                $b =~ s/(\r?\n[ \t]*<\/fields>)/$n$ind<field name="Selectors" type="StringTableFieldDefinition" value="$ns" \/>$1/ if length $ns }
        }
        "$o$b$c" }sge;
    wr($f, $s) if $s ne $before;
}

# ---- Spell lists
{
    my $f = "$G/Public/$M/Lists/SpellLists.lsx"; my $s = rd($f); my $n = nl($s); my $before = $s;
    for my $k (sort keys %spells) { my $u = $UUID{$k};
        if ($s =~ /(<node id="SpellList">(?:(?!<\/node>).)*?value="\Q$u\E"(?:(?!<\/node>).)*?<\/node>)/s) {
            my $old = $1; my $new = $old;
            $new =~ s/(id="Spells" type="LSString" value=")[^"]*"/$1$spells{$k}"/; $new =~ s/(id="Name" type="FixedString" value=")[^"]*"/$1$name{$k}"/;
            if ($new ne $old) { say_("list $k: $name{$k} = $spells{$k} (LSX)"); $s =~ s/\Q$old\E/$new/ }
        } elsif ($k eq 'L10') {   # new, right after the level-9 list
            my $ind = '                ';
            my $node = "$ind<node id=\"SpellList\">$n$ind    <attribute id=\"Name\" type=\"FixedString\" value=\"$name{$k}\"/>$n"
                     . "$ind    <attribute id=\"Spells\" type=\"LSString\" value=\"$spells{$k}\"/>$n$ind    <attribute id=\"UUID\" type=\"guid\" value=\"$u\"/>$n$ind</node>$n";
            if ($s =~ s/(<attribute id="UUID" type="guid" value="\Q$UUID{L9}\E"\/>\r?\n[ \t]*<\/node>\r?\n)/$1$node/) { say_("+ list $name{$k} (LSX)") }
            else { print "ANCHOR   after Resonant Level 9 (LSX)\n"; $bad++ }
        } else { print "ANCHOR   list $k (LSX)\n"; $bad++ }
    }
    wr($f, $s) if $s ne $before && !$bad;
}
{
    my $f = "$G/Editor/Mods/$M/Lists/SpellLists.tbl"; my $s = rd($f); my $n = nl($s); my $before = $s;
    for my $k (sort keys %spells) { my $u = $UUID{$k};
        if ($s =~ /(<stat_object[^>]*>(?:(?!<\/stat_object>).)*?value="\Q$u\E"(?:(?!<\/stat_object>).)*?<\/stat_object>)/s) {
            my $old = $1; my $new = $old;
            $new =~ s/(name="Spells" type="StringTableFieldDefinition" value=")[^"]*"/$1$spells{$k}"/; $new =~ s/(name="Name" type="NameTableFieldDefinition" value=")[^"]*"/$1$name{$k}"/;
            if ($new ne $old) { say_("list $k (TBL)"); $s =~ s/\Q$old\E/$new/ }
        } elsif ($k eq 'L10') {
            my $obj = "    <stat_object color=\"#FF6A5ACD\" is_substat=\"false\">$n      <fields>$n"
                    . "        <field name=\"UUID\" type=\"IdTableFieldDefinition\" value=\"$u\" />$n"
                    . "        <field name=\"Name\" type=\"NameTableFieldDefinition\" value=\"$name{$k}\" />$n"
                    . "        <field name=\"Spells\" type=\"StringTableFieldDefinition\" value=\"$spells{$k}\" />$n      </fields>$n    </stat_object>$n";
            if ($s =~ s/(value="\Q$UUID{L9}\E" \/>\r?\n(?:(?!<\/stat_object>).)*?<\/stat_object>\r?\n)/$1$obj/s) { say_("+ list $name{$k} (TBL)") }
            else { print "ANCHOR   after Resonant Level 9 (TBL)\n"; $bad++ }
        } else { print "ANCHOR   list $k (TBL)\n"; $bad++ }
    }
    wr($f, $s) if $s ne $before && !$bad;
}

print $bad ? "STOPPED: $bad anchor(s) missing\n" : $changes ? '' : "nothing to change (stage $ST)\n";
exit($bad ? 1 : 0);
