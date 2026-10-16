#!/usr/bin/perl
# ARC-0017: 64_progression_arc0017.pl on a scratch copy of the mod (51), stage by stage, against DESIGN.md §10.
#   perl 50_ENGINEERING/55_Implementation_Specs/_wip/Resonant/ARC-0017/t_progression.t <scratch dir>
use strict; use warnings;
use Test::More;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use File::Path qw(make_path remove_tree);
use File::Copy qw(copy);

my $HERE = abs_path(dirname(__FILE__));
my $ROOT = abs_path("$HERE/../../../../..");
my $SCRATCH = shift // die "scratch dir\n";
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $SRC = "$ROOT/50_ENGINEERING/51_Mod_Source";
my @FILES = ("Public/$M/Progressions/Progressions.lsx", "Public/$M/Lists/SpellLists.lsx",
             "Editor/Mods/$M/Progressions/Progressions.tbl", "Editor/Mods/$M/Lists/SpellLists.tbl");

sub fresh { remove_tree($SCRATCH); for my $f (@FILES) { make_path(dirname("$SCRATCH/$f")); copy("$SRC/$f", "$SCRATCH/$f") or die "$f: $!" } }
sub run_stage { my $st = shift; local $ENV{BG3_DATA} = $SCRATCH; local $ENV{ARC17_STAGE} = $st;
    my $out = `perl "$ROOT/50_ENGINEERING/55_Implementation_Specs/_wip/Resonant/64_progression_arc0017.pl" --apply 2>&1`; ($? >> 8, $out) }
sub slurp { open my $h, '<:raw', shift or die; local $/; my $s = <$h>; $s }

# the Resonant rows: level => [passives, selectors] (two level-1 rows: creation and level-up, same passives)
sub rows_lsx { my $s = slurp("$SCRATCH/Public/$M/Progressions/Progressions.lsx"); my %r;
    while ($s =~ /<node id="Progression">(.*?)<\/node>/sg) { my $b = $1; next unless $b =~ /id="Name" type="LSString" value="Resonant"/;
        my ($l) = $b =~ /id="Level" type="uint8" value="(\d+)"/; next if $l > 12;
        my ($p) = $b =~ /id="PassivesAdded" type="LSString" value="([^"]*)"/; my ($sel) = $b =~ /id="Selectors" type="LSString" value="([^"]*)"/;
        my ($add) = ($sel // '') =~ /AddSpells\(([0-9a-f-]+),/; push @{ $r{$l} }, [$p // '', $add // ''] } \%r }
sub rows_tbl { my $s = slurp("$SCRATCH/Editor/Mods/$M/Progressions/Progressions.tbl"); my %r;
    while ($s =~ /<stat_object[^>]*>(.*?)<\/stat_object>/sg) { my $b = $1; next unless $b =~ /name="FSName" type="StringTableFieldDefinition" value="Resonant"/;
        my ($l) = $b =~ /name="Level" type="ByteTableFieldDefinition" value="(\d+)"/; next if $l > 12;
        my ($p) = $b =~ /name="PassivesAdded" type="StringTableFieldDefinition" value="([^"]*)"/; my ($sel) = $b =~ /name="Selectors" type="StringTableFieldDefinition" value="([^"]*)"/;
        my ($add) = ($sel // '') =~ /AddSpells\(([0-9a-f-]+),/; push @{ $r{$l} }, [$p // '', $add // ''] } \%r }
sub lists { my ($lsx, $tbl) = (slurp("$SCRATCH/Public/$M/Lists/SpellLists.lsx"), slurp("$SCRATCH/Editor/Mods/$M/Lists/SpellLists.tbl")); my (%a, %b);
    while ($lsx =~ /<node id="SpellList">(.*?)<\/node>/sg) { my $n = $1; my ($sp) = $n =~ /id="Spells" type="LSString" value="([^"]*)"/; my ($u) = $n =~ /id="UUID" type="guid" value="([^"]*)"/; $a{$u} = $sp }
    while ($tbl =~ /<stat_object[^>]*>(.*?)<\/stat_object>/sg) { my $n = $1; my ($sp) = $n =~ /name="Spells" type="StringTableFieldDefinition" value="([^"]*)"/; my ($u) = $n =~ /name="UUID" type="IdTableFieldDefinition" value="([^"]*)"/; $b{$u} = $sp if $u }
    (\%a, \%b) }

my $C = 'Target_Arcana_Card_Spell_'; my $EO = 'Target_Arcana_Created_EmotionalOverload';
my %L = (L1 => '05269c79-116f-2b07-6dc1-deeefddc7ae4', L3 => '74e89dac-4330-83f6-cf7b-881854bd4663', L5 => 'e0d34d66-e311-be56-1810-04f9ba0917fd',
         L9 => 'f015022c-43e0-42f3-8f0a-0ab542e8641d', L10 => 'e9fb9260-2979-4c45-b326-59886e342963', L11 => 'e7063c7e-67e5-4887-8f3a-8ed09a03340f');
my $P = 'Arcana_Passive_';

# stage 0 / 1: nothing changes
fresh(); my ($code, $out) = run_stage(1); is($code, 0, 'stage 1 runs'); like($out, qr/nothing to change/, 'stage 1: the progression is the ARC-0002 one');

# stage 2: Emotional Overload moves to level 1 (R51)
fresh(); ($code, $out) = run_stage(2); is($code, 0, 'stage 2 runs') or diag $out;
my ($la, $lb) = lists();
is($la->{$L{L1}}, "${C}EmotionJoy;${C}EmotionTrust;${C}EmotionFear;${C}Heartstring;$EO", 'stage 2: Emotional Overload at level 1 (LSX)');
is($lb->{$L{L1}}, $la->{$L{L1}}, 'stage 2: TBL twin');
is($la->{$L{L5}}, "${C}EmotionDisgust;${C}EmotionAnger", 'stage 2: and no longer at 5');

# stage 3: the container replaces the emotions (R54)
fresh(); ($code, $out) = run_stage(3); is($code, 0, 'stage 3 runs') or diag $out;
($la, $lb) = lists(); my $r3 = rows_lsx();
is($la->{$L{L1}}, "${C}WeaveSurge;${C}Heartstring;$EO", 'stage 3: level 1 grants the container');
is($la->{$L{L3}}, "${C}Temper", 'stage 3: level 3 keeps Temper only');
is($r3->{5}[0][1], '', 'stage 3: level 5 grants no spell list (the emotions open inside the container)');

# stage 4: the spread map (R59, R60, R62)
fresh(); ($code, $out) = run_stage(4); is($code, 0, 'stage 4 runs') or diag $out;
($la, $lb) = lists();
for my $want ([L1 => "${C}WeaveSurge;${C}Heartstring;$EO"], [L3 => "${C}Temper"], [L9 => "${C}EmotionalContagion"],
              [L10 => 'Shout_Arcana_Card_Passive_Compassion'], [L11 => 'Shout_Arcana_Card_Spell_SharedHeart']) {
    is($la->{ $L{$want->[0]} }, $want->[1], "stage 4: list $want->[0] (LSX)"); is($lb->{ $L{$want->[0]} }, $want->[1], "stage 4: list $want->[0] (TBL)") }
my %want = (1 => ["${P}EmotionalAlchemy;${P}EmpathicSight;${P}Overload", $L{L1}], 2 => ['', $L{L3}],
    3 => ["${P}Aspect_Temperance_I;${P}Aspect_Temperance_Awakening;${P}Opposites", ''], 4 => ['', ''],
    5 => ["${P}DeeperFeelings_5", ''], 6 => ["${P}ComplexFeelings", ''], 7 => ["${P}Overwhelm;${P}Aspect_Temperance_II", ''], 8 => ['', ''],
    9 => ["${P}MixedFeelings;${P}DeeperFeelings_9", $L{L9}], 10 => ['', $L{L10}], 11 => ['', $L{L11}], 12 => ["${P}Aspect_Temperance_III", '']);
for my $tw (['LSX', rows_lsx()], ['TBL', rows_tbl()]) { my ($n, $r) = @$tw;
    for my $l (1 .. 12) { for my $row (@{ $r->{$l} || [] }) {
        is($row->[0], $want{$l}[0], "stage 4 $n L$l passives"); is($row->[1], $want{$l}[1], "stage 4 $n L$l spells") } } }
# idempotent
($code, $out) = run_stage(4); like($out, qr/nothing to change/, 'stage 4 again: nothing to change');
done_testing();
