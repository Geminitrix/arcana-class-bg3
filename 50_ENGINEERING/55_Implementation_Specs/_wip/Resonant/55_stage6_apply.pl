#!/usr/bin/perl
# ARC-0002 stage 6: the Resonant's spells at their levels, and the PC edition's reaction resource for Compassion.
#   - "Resonant Level 5" loses Emotional Contagion and Ready: Compassion (they were there for testing, stage 3);
#   - new lists "Resonant Level 9" (Emotional Contagion) and "Resonant Level 11" (Ready: Compassion, Shared Heart),
#     after "Resonant Level 5", as the Deceiver's lists;
#   - the Resonant L9 and L11 progression rows get Selectors AddSpells(<list>,,,,AlwaysPrepared);
#   - ActionResource ArcanaReactCompassion (hidden, ReplenishType Turn), after ArcanaReactWhichOne, as it.
# Every change goes to the game's LSX and the Toolkit's TBL together. Idempotent; stops when an anchor is missing.
#   perl 55_stage6_apply.pl            # shows what it would do
#   perl 55_stage6_apply.pl --apply    # writes (game and Toolkit closed, [fechado])
use strict; use warnings;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my $TABLE = '62727cb1-9114-ffbf-7fdb-51e28f73bd0f';
my %LIST = (9 => ['Resonant Level 9', 'f015022c-43e0-42f3-8f0a-0ab542e8641d', 'Target_Arcana_Card_Spell_EmotionalContagion'],
            11 => ['Resonant Level 11', 'e7063c7e-67e5-4887-8f3a-8ed09a03340f', 'Shout_Arcana_Card_Passive_Compassion;Shout_Arcana_Card_Spell_SharedHeart']);
my $RES_UUID = 'ea30fc2f-59cf-4d37-940e-e0db4fa4b595';
my $L5_OLD = 'Target_Arcana_Card_Spell_EmotionDisgust;Target_Arcana_Card_Spell_EmotionAnger;Target_Arcana_Created_EmotionalOverload;Target_Arcana_Card_Spell_EmotionalContagion;Shout_Arcana_Card_Passive_Compassion';
my $L5_NEW = 'Target_Arcana_Card_Spell_EmotionDisgust;Target_Arcana_Card_Spell_EmotionAnger;Target_Arcana_Created_EmotionalOverload';
my $bad = 0;

sub rd { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s }
sub wr { my ($f, $s) = @_; return unless $apply; open my $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h }
sub say_ { print(($apply ? 'write    ' : 'would    ') . "$_[0]\n") }
sub nl { $_[0] =~ /\r\n/ ? "\r\n" : "\n" }

# ---- spell lists
{
    my $f = "$G/Public/$M/Lists/SpellLists.lsx"; my $s = rd($f); my $n = nl($s); my $ch = 0;
    if ($s =~ s/\Qvalue="$L5_OLD"\E/value="$L5_NEW"/) { say_("L5 list without the test spells (LSX)"); $ch++ }
    elsif ($s !~ /\Qvalue="$L5_NEW"\/>\E/) { print "ANCHOR   L5 list (LSX)\n"; $bad++ }
    for my $lvl (11, 9) {   # each goes right after Level 5, so insert 11 first
        my ($name, $uuid, $spells) = @{ $LIST{$lvl} };
        next if $s =~ /\Q$uuid\E/;
        my $ind = '                ';
        my $node = "$ind<node id=\"SpellList\">$n$ind    <attribute id=\"Name\" type=\"FixedString\" value=\"$name\"/>$n"
                 . "$ind    <attribute id=\"Spells\" type=\"LSString\" value=\"$spells\"/>$n$ind    <attribute id=\"UUID\" type=\"guid\" value=\"$uuid\"/>$n$ind</node>$n";
        if ($s =~ s/(<attribute id="UUID" type="guid" value="e0d34d66-e311-be56-1810-04f9ba0917fd"\/>\r?\n[ \t]*<\/node>\r?\n)/$1$node/) { say_("+ list \"$name\" (LSX)"); $ch++ }
        else { print "ANCHOR   after Resonant Level 5 (LSX)\n"; $bad++ }
    }
    wr($f, $s) if $ch && !$bad;
}
{
    my $f = "$G/Editor/Mods/$M/Lists/SpellLists.tbl"; my $s = rd($f); my $n = nl($s); my $ch = 0;
    if ($s =~ s/\Qvalue="$L5_OLD" \/>\E/value="$L5_NEW" \/>/) { say_("L5 list without the test spells (TBL)"); $ch++ }
    elsif ($s !~ /\Qvalue="$L5_NEW" \/>\E/) { print "ANCHOR   L5 list (TBL)\n"; $bad++ }
    for my $lvl (11, 9) {   # each goes right after Level 5, so insert 11 first
        my ($name, $uuid, $spells) = @{ $LIST{$lvl} };
        next if $s =~ /\Q$uuid\E/;
        my $obj = "    <stat_object color=\"#FF6A5ACD\" is_substat=\"false\">$n      <fields>$n"
                . "        <field name=\"UUID\" type=\"IdTableFieldDefinition\" value=\"$uuid\" />$n"
                . "        <field name=\"Name\" type=\"NameTableFieldDefinition\" value=\"$name\" />$n"
                . "        <field name=\"Spells\" type=\"StringTableFieldDefinition\" value=\"$spells\" />$n      </fields>$n    </stat_object>$n";
        if ($s =~ s/(value="Resonant Level 5" \/>\r?\n.*?<\/stat_object>\r?\n)/$1$obj/s) { say_("+ list \"$name\" (TBL)"); $ch++ }
        else { print "ANCHOR   after Resonant Level 5 (TBL)\n"; $bad++ }
    }
    wr($f, $s) if $ch && !$bad;
}

# ---- progression: Selectors on the L9 and L11 rows of the Resonant table
for my $fdef (["$G/Public/$M/Progressions/Progressions.lsx", qr{<node id="Progression">.*?</node>}s, qr{id="Level" type="uint8" value="(\d+)"},
               sub { my ($ind, $v, $n) = @_; qq{$ind<attribute id="Selectors" type="LSString" value="$v"/>$n} },
               qr{([ \t]*)(<attribute id="TableUUID")}],
              ["$G/Editor/Mods/$M/Progressions/Progressions.tbl", qr{<stat_object\b.*?</stat_object>}s, qr{name="Level" type="\w+" value="(\d+)"},
               sub { my ($ind, $v, $n) = @_; qq{$ind<field name="Selectors" type="StringTableFieldDefinition" value="$v" />$n} },
               qr{([ \t]*)(</fields>)}]) {
    my ($f, $block, $level, $mk, $before) = @$fdef;
    my $s = rd($f); my $n = nl($s); my (%seen, $ch);
    $s =~ s{($block)}{
        my $b = $1;
        if ($b =~ /\Q$TABLE\E/ && $b =~ $level && $LIST{$1}) {
            my $lvl = $1; $seen{$lvl}++;
            my $want = "AddSpells($LIST{$lvl}[1],,,,AlwaysPrepared)";
            if ($b =~ /Selectors/) { if ($b =~ /\Q$want\E/) { print "already  L$lvl Selectors ($f)\n" } else { print "STOP     L$lvl already has other Selectors ($f)\n"; $bad++ } }
            elsif ($b =~ $before) { my $ind = $1; $ind = '        ' if $2 eq '</fields>';   # a field, not the closing tag's indent
                $b =~ s/$before/$mk->($ind, $want, $n) . "$1$2"/e; $ch++; say_("L$lvl Selectors = $want ($f)") }
            else { print "ANCHOR   L$lvl ($f)\n"; $bad++ }
        }
        $b }ge;
    for (9, 11) { unless ($seen{$_}) { print "MISSING  L$_ ($f)\n"; $bad++ } }
    wr($f, $s) if $ch && !$bad;
}

# ---- the ActionResource ArcanaReactCompassion (copied from ArcanaReactWhichOne)
{
    my $f = "$G/Public/$M/ActionResourceDefinitions/ActionResourceDefinitions.lsx"; my $s = rd($f); my $n = nl($s);
    if ($s =~ /ArcanaReactCompassion/) { print "already  ArcanaReactCompassion (LSX)\n" }
    elsif ($s =~ s/(([ \t]*)<node id="ActionResourceDefinition">\r?\n(?:(?!<\/node>).)*?value="ArcanaReactWhichOne"(?:(?!<\/node>).)*?<\/node>\r?\n)/
        my ($whole, $ind) = ($1, $2); (my $copy = $whole) =~ s{value="ArcanaReactWhichOne"}{value="ArcanaReactCompassion"}; $copy =~ s{value="2fc93ef1-33b0-0569-e5dd-90b0d579e8ba"}{value="$RES_UUID"}; "$whole$copy"/se) {
        say_('+ ArcanaReactCompassion (LSX)'); wr($f, $s) unless $bad }
    else { print "ANCHOR   ArcanaReactWhichOne (LSX)\n"; $bad++ }
}
{
    my $f = "$G/Editor/Mods/$M/ActionResourceDefinitions/ActionResourceDefinitions.tbl"; my $s = rd($f);
    if ($s =~ /ArcanaReactCompassion/) { print "already  ArcanaReactCompassion (TBL)\n" }
    elsif ($s =~ s/(([ \t]*)<stat_object is_substat="false">\r?\n(?:(?!<\/stat_object>).)*?value="ArcanaReactWhichOne"(?:(?!<\/stat_object>).)*?<\/stat_object>\r?\n)/
        my $whole = $1; (my $copy = $whole) =~ s{"ArcanaReactWhichOne"}{"ArcanaReactCompassion"}g; $copy =~ s{value="2fc93ef1-33b0-0569-e5dd-90b0d579e8ba"}{value="$RES_UUID"}; "$whole$copy"/se) {
        say_('+ ArcanaReactCompassion (TBL)'); wr($f, $s) unless $bad }
    else { print "ANCHOR   ArcanaReactWhichOne (TBL)\n"; $bad++ }
}
exit($bad ? 1 : 0);
