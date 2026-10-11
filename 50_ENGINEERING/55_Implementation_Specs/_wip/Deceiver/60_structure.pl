#!/usr/bin/perl
# The Veil, stage 3: Deceiver lists, progression rows and action resources, both sides (lsx + tbl).
#   perl 60_structure.pl            # dry run
#   perl 60_structure.pl --apply    # writes (game and Toolkit closed)
# Running it twice changes nothing.
use strict; use warnings;
my $G = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my %F = (sl_lsx => "$G/Public/$M/Lists/SpellLists.lsx", sl_tbl => "$G/Editor/Mods/$M/Lists/SpellLists.tbl",
         pr_lsx => "$G/Public/$M/Progressions/Progressions.lsx", pr_tbl => "$G/Editor/Mods/$M/Progressions/Progressions.tbl",
         ar_lsx => "$G/Public/$M/ActionResourceDefinitions/ActionResourceDefinitions.lsx",
         ar_tbl => "$G/Editor/Mods/$M/ActionResourceDefinitions/ActionResourceDefinitions.tbl");
my $TABLE = '8fe1f693-d8ff-4b02-a655-efd4acbc04cb';
my %LISTS = (
    '507f2c2a-ccdd-44f0-bf45-ca3676e1a03f' => 'Projectile_Arcana_Card_Spell_SigilofMalice;Shout_Arcana_Util_Faceless;Target_Arcana_Card_Spell_MaliciousWhispers;Target_Arcana_Card_Spell_MirrorImage;Target_Arcana_Util_Friends',
    'f5216d9b-4fed-49f0-b1ea-8a5e2b831b59' => 'Target_Arcana_Card_Spell_EtherealChains;Target_Arcana_Card_Spell_VeiledPrison',
    '9aac7d55-57b7-4942-afb4-1751e506b172' => 'Target_Arcana_Card_Spell_Distortion',
    '8163075e-1c66-4173-a15c-2c78a9524021' => 'Target_Arcana_Created_Mimic',
    '55ff77d4-6dd9-4cda-8e9b-84ba78cf5a54' => 'Target_Arcana_Card_Spell_Marionette',
    '7134712c-169c-4210-9b13-541e9660392c' => 'Shout_Arcana_Card_Spell_GrandDeception',
);
my $L13 = '4657a3f6-e7f5-4ac4-b5c4-c0665adcb36d';
# [level, multiclass rows too?, passives to add, boost to remove, selector to remove]
my @ROWS = ([1, 1, 'Arcana_Passive_TheVeil'], [1, 1, 'Arcana_Passive_Doubt'], [5, 0, 'Arcana_Passive_TwoTruths', 'ActionResource(ArcanaReactInstinctiveCharm,1,0)'],
            [7, 0, 'Arcana_Passive_VeilCap4'], [9, 0, 'Arcana_Passive_Unveil'], [12, 0, 'Arcana_Passive_VeilCap5'],
            [13, 0, undef, undef, "AddSpells($L13,,,,AlwaysPrepared)"]);
my @RESOURCES = qw(ArcanaReactHollowImage ArcanaReactInstinctiveCharm);

sub slurp { open my $h, '<:raw', $_[0] or die "$_[0]: $!"; local $/; my $s = <$h>; close $h; $s }
sub spew { open my $h, '>:raw', $_[0] or die "$_[0]: $!"; print $h $_[1]; close $h }
my %S = map { $_ => slurp($F{$_}) } keys %F; my %O = %S; my @log;
sub nl { $_[0] =~ /\r\n/ ? "\r\n" : "\n" }
sub list_join { my ($old, $add, $rm) = @_; my @v = grep { length } split /;/, $old;
    @v = grep { $_ ne $rm } @v if defined $rm; push @v, $add if defined $add && !grep { $_ eq $add } @v; join ';', @v }

# ---- lists
for my $u (sort keys %LISTS) {
    $S{sl_lsx} =~ s{(<attribute id="Spells" type="LSString" value=")[^"]*("/>\s*<attribute id="UUID" type="guid" value="\Q$u\E")}{$1$LISTS{$u}$2} or die "lsx list $u\n";
    $S{sl_tbl} =~ s{(value="\Q$u\E" />\s*<field name="Name"[^\n]*\n\s*<field name="Spells" type="StringTableFieldDefinition" value=")[^"]*}{$1$LISTS{$u}} or die "tbl list $u\n";
}
push @log, 'lists: ' . scalar(keys %LISTS) . ' set';
# level 13 list goes (Faux Amis is now Friends at level 6)
$S{sl_lsx} =~ s{\s*<node id="SpellList">(?:(?!</node>).)*?value="\Q$L13\E"(?:(?!</node>).)*</node>}{}s and push @log, 'lsx: list Level 13 removed';
$S{sl_tbl} =~ s{\s*<stat_object[^>]*>(?:(?!</stat_object>).)*?value="\Q$L13\E"(?:(?!</stat_object>).)*</stat_object>}{}s and push @log, 'tbl: list Level 13 removed';

# ---- progression rows
sub edit_row {   # $blk: one row; $add/$boost/$sel as in @ROWS; $tbl: field syntax
    my ($blk, $add, $boost, $sel, $tbl) = @_;
    my $n = nl($blk);
    my ($open, $close) = $tbl ? (qr/<field name="(\w+)" type="\w+" value="/, '" />') : (qr/<attribute id="(\w+)" type="\w+" value="/, '"/>');
    my $edit = sub { my ($field, $code) = @_;
        if ($blk =~ /<(?:field name|attribute id)="$field" type="\w+" value="([^"]*)"/) {
            my $new = $code->($1);
            if (length $new) { $blk =~ s/(<(?:field name|attribute id)="$field" type="\w+" value=")[^"]*/$1$new/ }
            else { $blk =~ s/[ \t]*<(?:field name|attribute id)="$field" type="\w+" value="[^"]*"\s*\/>\r?\n//; }
        } else {
            my $new = $code->(''); return unless length $new;
            if ($tbl) { $blk =~ s{(\n(\s*)<field name="TableUUID"[^\n]*\n)}{$1$2<field name="$field" type="StringTableFieldDefinition" value="$new" />$n} or die "tbl row: no TableUUID\n" }
            else { $blk =~ s{(\n(\s*)<attribute id="ProgressionType")}{$n$2<attribute id="$field" type="LSString" value="$new"/>$1} or die "lsx row: no ProgressionType\n" }
        } };
    $edit->('PassivesAdded', sub { list_join($_[0], $add) }) if defined $add;
    $edit->('Boosts', sub { list_join($_[0], undef, $boost) }) if defined $boost;
    $edit->('Selectors', sub { list_join($_[0], undef, $sel) }) if defined $sel;
    $blk;
}
for my $side (['pr_lsx', qr/<node id="Progression">(?:(?!<node id="Progression">).)*?<\/node>/s, 0],
              ['pr_tbl', qr/<stat_object[^>]*>(?:(?!<\/stat_object>).)*<\/stat_object>/s, 1]) {
    my ($k, $re, $tbl) = @$side; my $hits = 0;
    $S{$k} =~ s{($re)}{ my $b = $1;
        if ($b =~ /\Q$TABLE\E/) {
            my ($lvl) = $b =~ /"Level" type="\w+" value="(\d+)"/;
            my $mc = $b =~ /"IsMulticlass" type="\w+" value="(?i:true)"/;
            for my $r (grep { $_->[0] == $lvl && (!$mc || $_->[1]) } @ROWS) { $b = edit_row($b, @$r[2, 3, 4], $tbl); $hits++ }
        }
        $b }ge;
    push @log, "$k: $hits rows touched";
}

# ---- action resources
for my $r (@RESOURCES) {
    $S{ar_lsx} =~ s{\s*<node id="ActionResourceDefinition">(?:(?!</node>).)*?value="\Q$r\E"(?:(?!</node>).)*</node>}{}s and push @log, "lsx: resource $r removed";
    $S{ar_tbl} =~ s{\s*<stat_object[^>]*>(?:(?!</stat_object>).)*?value="\Q$r\E"(?:(?!</stat_object>).)*</stat_object>}{}s and push @log, "tbl: resource $r removed";
}

my @dirty = grep { $S{$_} ne $O{$_} } sort keys %S;
print "$_\n" for @log; print "changed: @dirty\n";
if ($apply) { spew($F{$_}, $S{$_}) for @dirty; print "written.\n" } else { print "(dry run)\n" }
