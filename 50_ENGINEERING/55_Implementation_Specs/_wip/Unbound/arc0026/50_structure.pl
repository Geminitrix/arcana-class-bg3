#!/usr/bin/perl
# ARC-0026 Task 0.7 — the Windborn's level map (WB16, WB43; DESIGN.md §9.1), both sides (lsx + tbl).
# Model: ../../Deceiver/arc0020/20_structure.pl (same edit and self-check code).
#   perl 50_structure.pl            # dry run (reads the game files, writes nothing)
#   perl 50_structure.pl --apply --stage N   # writes the rows and lists of stages 2..N (game and Toolkit closed);
#                                   # without --stage: the end state (5). Each row and list carries the stage that applies it.
# Idempotent: a second dry run after --apply prints "changed:" empty.
# Lists: six reused (Level 7's name typo fixed, Level 11 now holds the capstone), three new — UUIDs are MD5 v3 of
# "arcana/unbound/list/levelN", as the Deceiver's Level 2.
use strict; use warnings;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my ($STAGE) = join(' ', @ARGV) =~ /--stage (\d)/; $STAGE //= 5;
my %F = (sl_lsx => "$G/Public/$M/Lists/SpellLists.lsx", sl_tbl => "$G/Editor/Mods/$M/Lists/SpellLists.tbl",
         pr_lsx => "$G/Public/$M/Progressions/Progressions.lsx", pr_tbl => "$G/Editor/Mods/$M/Progressions/Progressions.tbl");
my $TABLE = 'd75cb44d-bba6-43ad-851f-4497ec526e80';
my ($L1, $L2, $L3, $L5, $L6, $L7, $L9, $L10, $L11) = (
    '43261c49-335c-4231-ae5d-6a828cff974c', '78b03162-cdb7-3dda-811d-53a6eb2894ec', '706b4719-9a6d-42c0-8e08-8b273eb3e0e4',
    '438610de-b4a4-4a60-87e0-7f6c4034b140', '4694ff36-daaa-387a-89e1-386121589d0b', '87872209-4d00-4a57-8e24-02fbb18c75bc',
    'fc46dcfe-4126-4b55-92ab-87e8fb43e8f9', '167bc833-2a47-3ab8-9157-c7bda3c4695a', 'f0892650-f4dd-41c1-bbe3-76cd7e361985');
my @NEW = ($L2, $L6, $L10);
my %LISTS = (   # uuid => [name, spells]
    $L1  => ['Unbound Level 1',  'Target_Arcana_Card_Spell_GaleBurst'],
    $L2  => ['Unbound Level 2',  'Shout_Arcana_Created_AeolusBag'],
    $L3  => ['Unbound Level 3',  'Zone_Arcana_Card_Spell_WindBlast'],
    $L5  => ['Unbound Level 5',  'Shout_Arcana_Card_Spell_WindWhispers'],
    $L6  => ['Unbound Level 6',  'Shout_Arcana_Card_Spell_FlowState;Shout_Arcana_Card_Passive_GaleDeflection'],
    $L7  => ['Unbound Level 7',  'Shout_Arcana_Card_Spell_StormFists'],
    $L9  => ['Unbound Level 9',  'Shout_Arcana_Card_Ability_Untethered'],
    $L10 => ['Unbound Level 10', 'Rush_Arcana_Created_Aspect_LeapOfFaith'],
    $L11 => ['Unbound Level 11', 'Projectile_Arcana_Created_WhereTheWindsMeet'],
);
my %LSTAGE = ($L2 => 3, $L11 => 5);   # every other list: stage 4 (the cards and removals of 30_ranks_cards.patch)
delete @LISTS{ grep { ($LSTAGE{$_} // 4) > $STAGE } keys %LISTS }; @NEW = grep { $LISTS{$_} } @NEW;
sub sel { "AddSpells($_[0],,,,AlwaysPrepared)" }
my $GD = 'ActionResource(ArcanaGaleDeflectReturn,1,0)';
my $GR = 'ActionResource(ArcanaReactGaleDeflection,3,0)';
sub tt { "Arcana_Passive_TwinkleToes_$_[0]" } sub wl { "Arcana_Passive_Weightless_$_[0]" }
# [level, also the multiclass row?, field, add, remove, stage (default 4)]
my @ROWS = (
    [1, 1, 'PassivesAdded', wl(1), tt(1)], [1, 1, 'PassivesAdded', 'Arcana_Passive_Windswept_Touch', undef, 2],
    [1, 1, 'PassivesAdded', 'Arcana_Passive_OpenPath', undef, 2],
    [2, 0, 'PassivesAdded', 'Arcana_Passive_AeolusBag', undef, 3], [2, 0, 'Selectors', sel($L2), undef, 3],
    [3, 0, 'PassivesAdded', undef, tt(3)], [3, 0, 'PassivesRemoved', undef, tt(1)],
    [3, 0, 'Boosts', undef, $GD], [3, 0, 'Boosts', undef, $GR],
    [4, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Gale'], [4, 0, 'PassivesAdded', wl(4)], [4, 0, 'PassivesRemoved', wl(1)],
    [5, 0, 'PassivesAdded', undef, tt(5)], [5, 0, 'PassivesAdded', undef, wl(5)], [5, 0, 'PassivesRemoved', undef, tt(3)],
    [6, 0, 'Boosts', $GD], [6, 0, 'Boosts', $GR], [6, 0, 'Selectors', sel($L6)],
    [7, 0, 'PassivesAdded', undef, tt(7)], [7, 0, 'PassivesAdded', undef, wl(7)],
    [7, 0, 'PassivesRemoved', undef, tt(5)], [7, 0, 'PassivesRemoved', undef, wl(5)],
    [8, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Storm'], [8, 0, 'PassivesAdded', wl(8)], [8, 0, 'PassivesRemoved', wl(4)],
    [9, 0, 'PassivesAdded', undef, tt(9)], [9, 0, 'PassivesAdded', undef, wl(9)],
    [9, 0, 'PassivesAdded', 'Arcana_Passive_EmptyState', 'Arcana_Passive_EyeOfTheStorm_UI'],
    [9, 0, 'PassivesRemoved', undef, tt(7)], [9, 0, 'PassivesRemoved', undef, wl(7)],
    [10, 0, 'Selectors', sel($L10)],
    [11, 0, 'PassivesAdded', undef, tt(11)], [11, 0, 'PassivesAdded', undef, wl(11)],
    [11, 0, 'PassivesAdded', undef, 'Arcana_Passive_Momentum_UI'],
    [11, 0, 'PassivesRemoved', undef, tt(9)], [11, 0, 'PassivesRemoved', undef, wl(9)],
    [12, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Hurricane', tt(12)], [12, 0, 'PassivesAdded', undef, 'Arcana_Passive_EmptyState'],
    [12, 0, 'PassivesRemoved', wl(8), tt(11)], [12, 0, 'PassivesRemoved', undef, wl(11)],
    # 13-20 (the expansion module, 21.07): Twinkle Toes leaves; nothing yet in its place
    (map { my ($l, $p) = @$_; ([$l, 0, 'PassivesAdded', undef, tt($l)], [$l, 0, 'PassivesRemoved', undef, tt($p)]) }
        [13, 12], [15, 13], [17, 15], [19, 17], [20, 19]),
);
@ROWS = grep { ($_->[5] // 4) <= $STAGE } @ROWS;

sub slurp { open my $h, '<:raw', $_[0] or die "$_[0]: $!"; local $/; my $s = <$h>; close $h; $s }
sub spew { open my $h, '>:raw', $_[0] or die "$_[0]: $!"; print $h $_[1]; close $h }
my %S = map { $_ => slurp($F{$_}) } keys %F; my %O = %S; my @log;
sub nl { $_[0] =~ /\r\n/ ? "\r\n" : "\n" }
sub list_join { my ($old, $add, $rm) = @_; my @v = grep { length } split /;/, $old;
    @v = grep { $_ ne $rm } @v if defined $rm; push @v, $add if defined $add && !grep { $_ eq $add } @v; join ';', @v }

# ---- lists: the three new ones are copies of "Unbound Level 1" placed after it; then name + spells of all nine
for my $u (@NEW) {
    unless ($S{sl_lsx} =~ /value="\Q$u\E"/) {
        $S{sl_lsx} =~ s{(<node id="SpellList">\s*<attribute id="Name" type="FixedString" value="Unbound Level 1"/>(?:(?!</node>).)*</node>)(\s*)}
            {my ($b, $ws) = ($1, $2); (my $c = $b) =~ s/\Q$L1\E/$u/; "$b$ws$c$ws"}se or die "lsx: Level 1 list not found\n";
        push @log, "lsx: list $u created";
    }
    unless ($S{sl_tbl} =~ /value="\Q$u\E"/) {
        $S{sl_tbl} =~ s{(<stat_object[^>]*>\s*<fields>\s*<field name="UUID" type="IdTableFieldDefinition" value="\Q$L1\E" />(?:(?!</stat_object>).)*</stat_object>)(\s*)}
            {my ($b, $ws) = ($1, $2); (my $c = $b) =~ s/\Q$L1\E/$u/; "$b$ws$c$ws"}se or die "tbl: Level 1 list not found\n";
        push @log, "tbl: list $u created";
    }
}
for my $u (sort keys %LISTS) {
    my ($name, $spells) = @{ $LISTS{$u} };
    $S{sl_lsx} =~ s{(<attribute id="Name" type="FixedString" value=")[^"]*("/>\s*<attribute id="Spells" type="LSString" value=")[^"]*("/>\s*<attribute id="UUID" type="guid" value="\Q$u\E")}{$1$name$2$spells$3} or die "lsx list $u\n";
    $S{sl_tbl} =~ s{(value="\Q$u\E" />\s*<field name="Name" type="NameTableFieldDefinition" value=")[^"]*(" />\s*<field name="Spells" type="StringTableFieldDefinition" value=")[^"]*}{$1$name$2$spells} or die "tbl list $u\n";
}
push @log, 'lists: ' . scalar(keys %LISTS) . ' set';

# ---- progression rows
sub edit_field {   # one row block; lsx attributes stay in alphabetical order, tbl fields go at the end
    my ($blk, $field, $add, $rm, $tbl) = @_;
    my $n = nl($blk);
    my $re = $tbl ? qr/<field name="$field" type="\w+" value="([^"]*)"/ : qr/<attribute id="$field" type="\w+" value="([^"]*)"/;
    my $new = list_join($blk =~ $re ? $1 : '', $add, $rm);
    if ($blk =~ $re) {
        if (length $new) { $blk =~ s/($re)/my $m = $1; $m =~ s{value="[^"]*"}{value="$new"}; $m/e }
        else { $blk =~ s/[ \t]*(?:<field name|<attribute id)="$field" type="\w+" value="[^"]*"\s*\/>\r?\n// }
    } elsif (length $new) {
        if ($tbl) { $blk =~ s{(\n(\s*)<field [^\n]*\n)(\s*</fields>)}{$1$2<field name="$field" type="StringTableFieldDefinition" value="$new" />$n$3} or die "tbl row: no fields\n" }
        else {
            my ($after) = grep { $_ gt $field } $blk =~ /<attribute id="(\w+)"/g;
            $blk =~ s{(\n(\s*)<attribute id="$after")}{$n$2<attribute id="$field" type="LSString" value="$new"/>$1} or die "lsx row: no $after\n";
        }
    }
    $blk;
}
for my $side (['pr_lsx', qr/<node id="Progression">(?:(?!<node id="Progression">).)*?<\/node>/s, 0],
              ['pr_tbl', qr/<stat_object[^>]*>(?:(?!<\/stat_object>).)*<\/stat_object>/s, 1]) {
    my ($k, $re, $tbl) = @$side; my $hits = 0;
    $S{$k} =~ s{($re)}{ my $b = $1;
        if ($b =~ /\Q$TABLE\E/) {
            my ($lvl) = $b =~ /"Level" type="\w+" value="(\d+)"/;
            my $mc = $b =~ /"IsMulticlass" type="\w+" value="(?i:true)"/;
            for my $r (grep { $_->[0] == $lvl && (!$mc || $_->[1]) } @ROWS) { $b = edit_field($b, @$r[2, 3, 4], $tbl); $hits++ }
        }
        $b }ge;
    push @log, "$k: $hits row edits";
}

# ---- self-check: what the Windborn rows grant afterwards, and the rules of the map
my %grant;
for my $b ($S{pr_lsx} =~ /(<node id="Progression">(?:(?!<node id="Progression">).)*?<\/node>)/sg) {
    next unless $b =~ /\Q$TABLE\E/;
    my ($lvl) = $b =~ /"Level" type="\w+" value="(\d+)"/;
    my ($p) = $b =~ /"PassivesAdded" type="\w+" value="([^"]*)"/; my ($r) = $b =~ /"PassivesRemoved" type="\w+" value="([^"]*)"/;
    my @s = $b =~ /AddSpells\(([0-9a-f-]{36})/g;
    $grant{$lvl} .= ($p // '') . ';';
    printf "  L%-2d +%s -%s | lists: %s\n", $lvl, $p // '-', $r // '-', join(',', map { $LISTS{$_} ? $LISTS{$_}[0] : $_ } @s) || '-' if $lvl <= 12;
}
my $all = join ';', values %grant;
if ($STAGE >= 4) {   # the end-state rules hold from stage 4 (removals)
die "self-check: Twinkle Toes still granted\n"   if $all =~ /TwinkleToes/;
die "self-check: a retired passive is granted\n" if $all =~ /EyeOfTheStorm|Momentum|Weightless_(5|7|9|11)\b/;
die "self-check: Weightless rank missing\n"      unless (grep { $all =~ /\Q@{[wl($_)]}\E/ } 1, 4, 8, 12) == 4;
die "self-check: True Strike still listed\n"     if $S{sl_lsx} =~ /value="[^"]*Target_TrueStrike[^"]*"\/>\s*<attribute id="UUID" type="guid" value="\Q$L1\E"/;
}

my @dirty = grep { $S{$_} ne $O{$_} } sort keys %S;
print "$_\n" for @log; print "changed: @dirty\n";
if ($apply) { spew($F{$_}, $S{$_}) for @dirty; print "written.\n" } else { print "(dry run)\n" }
