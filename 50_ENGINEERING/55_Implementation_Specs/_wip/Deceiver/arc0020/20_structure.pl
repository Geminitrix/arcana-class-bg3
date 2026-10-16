#!/usr/bin/perl
# ARC-0020 Task 0.4 — the Deceiver's level map (DV28), both sides (lsx + tbl). Model: ../60_structure.pl.
#   perl 20_structure.pl            # dry run (reads the game files, writes nothing)
#   perl 20_structure.pl --apply    # writes (game and Toolkit closed, stage 2, AFTER 30_splinter_command.patch)
# Running it twice changes nothing (checked in stage 2: a second dry run after --apply must print "changed:" empty). Two lists are reused (renamed and moved) so only one new list is created:
#   "Deceiver Level 7"  (8163075e) -> "Deceiver Level 6":  Twice-Told + Mirrored Spell, selector 7 -> 6
#   "Deceiver Level 12" (292cab8b) -> "Deceiver Level 10": Mirrored Self,               selector 12 -> 10
#   new "Deceiver Level 2" (5f9b529a, MD5 of "arcana/deceiver/list/level2"): Faceless, Friends, Splinter on command
use strict; use warnings;
my $G = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $apply = grep { $_ eq '--apply' } @ARGV;
my %F = (sl_lsx => "$G/Public/$M/Lists/SpellLists.lsx", sl_tbl => "$G/Editor/Mods/$M/Lists/SpellLists.tbl",
         pr_lsx => "$G/Public/$M/Progressions/Progressions.lsx", pr_tbl => "$G/Editor/Mods/$M/Progressions/Progressions.tbl");
my $TABLE = '8fe1f693-d8ff-4b02-a655-efd4acbc04cb';
my ($L1, $L2, $L6, $L10) = ('507f2c2a-ccdd-44f0-bf45-ca3676e1a03f', '5f9b529a-e3fd-3c4c-aab8-d888f009404f',
                            '8163075e-1c66-4173-a15c-2c78a9524021', '292cab8b-27ad-467c-9a99-2f0b7bddd406');
my %LISTS = (   # uuid => [name, spells]
    $L1  => ['Deceiver Level 1',  'Projectile_Arcana_Card_Spell_SigilofMalice;Target_Arcana_Card_Spell_MaliciousWhispers;Target_Arcana_Card_Spell_MirrorImage'],
    $L2  => ['Deceiver Level 2',  'Shout_Arcana_Util_Faceless;Target_Arcana_Util_Friends;Target_Arcana_Card_Spell_SplinterOnCommand'],
    $L6  => ['Deceiver Level 6',  'Target_Arcana_Created_Mimic;Shout_Arcana_Card_Passive_MirroredSpell'],
    $L10 => ['Deceiver Level 10', 'Shout_Arcana_Card_Passive_MirroredCharm'],
);
sub sel { "AddSpells($_[0],,,,AlwaysPrepared)" }
# [level, also the multiclass row?, field, add, remove]
my @ROWS = ([1, 1, 'PassivesAdded', undef, 'Arcana_Passive_Telepathy'], [1, 1, 'PassivesAdded', undef, 'Arcana_Passive_Doubt'],
            [2, 0, 'Selectors', sel($L2)], [6, 0, 'Selectors', sel($L6)], [7, 0, 'Selectors', undef, sel($L6)],
            [10, 0, 'Selectors', sel($L10)], [12, 0, 'Selectors', undef, sel($L10)]);

sub slurp { open my $h, '<:raw', $_[0] or die "$_[0]: $!"; local $/; my $s = <$h>; close $h; $s }
sub spew { open my $h, '>:raw', $_[0] or die "$_[0]: $!"; print $h $_[1]; close $h }
my %S = map { $_ => slurp($F{$_}) } keys %F; my %O = %S; my @log;
sub nl { $_[0] =~ /\r\n/ ? "\r\n" : "\n" }
sub list_join { my ($old, $add, $rm) = @_; my @v = grep { length } split /;/, $old;
    @v = grep { $_ ne $rm } @v if defined $rm; push @v, $add if defined $add && !grep { $_ eq $add } @v; join ';', @v }

# ---- lists: create the new one after "Deceiver Level 1", then set name + spells of all four
unless ($S{sl_lsx} =~ /value="\Q$L2\E"/) {
    $S{sl_lsx} =~ s{(<node id="SpellList">\s*<attribute id="Name" type="FixedString" value="Deceiver Level 1"/>(?:(?!</node>).)*</node>)(\s*)}
        {my ($b, $ws) = ($1, $2); (my $c = $b) =~ s/\Q$L1\E/$L2/; "$b$ws$c$ws"}se or die "lsx: Level 1 list not found\n";
    push @log, 'lsx: list Level 2 created';
}
unless ($S{sl_tbl} =~ /value="\Q$L2\E"/) {
    $S{sl_tbl} =~ s{(<stat_object[^>]*>\s*<fields>\s*<field name="UUID" type="IdTableFieldDefinition" value="\Q$L1\E" />(?:(?!</stat_object>).)*</stat_object>)(\s*)}
        {my ($b, $ws) = ($1, $2); (my $c = $b) =~ s/\Q$L1\E/$L2/; "$b$ws$c$ws"}se or die "tbl: Level 1 list not found\n";
    push @log, 'tbl: list Level 2 created';
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

# ---- self-check: what the Deceiver rows grant afterwards
for my $k ('pr_lsx') {
    for my $b ($S{$k} =~ /(<node id="Progression">(?:(?!<node id="Progression">).)*?<\/node>)/sg) {
        next unless $b =~ /\Q$TABLE\E/;
        my ($lvl) = $b =~ /"Level" type="\w+" value="(\d+)"/; next if $lvl > 12;
        my ($p) = $b =~ /"PassivesAdded" type="\w+" value="([^"]*)"/; my @s = $b =~ /AddSpells\(([0-9a-f-]{36})/g;
        printf "  L%-2d passives: %s | lists: %s\n", $lvl, $p // '-', join(',', map { $LISTS{$_} ? $LISTS{$_}[0] : $_ } @s) || '-';
    }
}
die "self-check: Telepathy still granted\n" if $S{pr_lsx} =~ /Arcana_Passive_Telepathy/ && $S{pr_lsx} =~ /Arcana_Passive_Telepathy;Arcana_Passive_TheVeil/;

my @dirty = grep { $S{$_} ne $O{$_} } sort keys %S;
print "$_\n" for @log; print "changed: @dirty\n";
if ($apply) { spew($F{$_}, $S{$_}) for @dirty; print "written.\n" } else { print "(dry run)\n" }
