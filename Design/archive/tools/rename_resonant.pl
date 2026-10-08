#!/usr/bin/perl
# Heartweaver -> Resonant, game side (2026-10-08). Text files only, game .lsx/.txt/.xml and Toolkit .tbl/.stats.
# Left for the author to rename in the Toolkit: ClassDescription Name, ProgressionDescription Type/Name and the
# THEHEARTWEAVER tag (.lsf, binary) -- the identity keys.
#
#   perl rename_resonant.pl            # dry run: counts per file
#   perl rename_resonant.pl --apply    # writes, with a backup (game and Toolkit closed)
use strict; use warnings;
use File::Path qw(make_path); use File::Copy qw(copy); use POSIX qw(strftime);
my $apply = grep { $_ eq '--apply' } @ARGV;
my $G = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my ($P, $E, $L) = ("$G/Public/$M", "$G/Editor/Mods/$M", "$G/Mods/$M");
# file => expected replacements (a mismatch aborts before anything is written)
my %F = (
    "$L/Localization/English/english.xml"                 => 8,
    "$P/ClassDescriptions/ClassDescriptions.lsx"          => 1,  # ClassEquipment only
    "$E/ClassDescriptions/ClassDescriptions.tbl"          => 1,
    "$P/Lists/SpellLists.lsx"                             => 4,
    "$E/Lists/SpellLists.tbl"                             => 4,
    "$P/Progressions/Progressions.lsx"                    => 21,
    "$E/Progressions/Progressions.tbl"                    => 21,
    "$P/Stats/Generated/Data/Passive.txt"                 => 1,
    "$E/Stats/Stats/Passive.stats"                        => 1,
    "$P/Stats/Generated/Data/Spell_Shout.txt"             => 2,
    "$E/Stats/SpellData/Shout.stats"                      => 2,
    "$P/Stats/Generated/Data/Spell_Target.txt"            => 1,
    "$E/Stats/SpellData/Target.stats"                     => 1,
    "$P/Stats/Generated/Data/Status_BOOST.txt"            => 3,
    "$E/Stats/StatusData/Status_BOOST.stats"              => 3,
    "$P/Stats/Generated/Data/Status_FEAR.txt"             => 1,
    "$E/Stats/StatusData/Status_FEAR.stats"               => 1,
    "$P/Stats/Generated/Data/Status_INCAPACITATED.txt"    => 1,
    "$E/Stats/StatusData/Status_INCAPACITATED.stats"      => 1,
    "$P/Stats/Generated/Equipment.txt"                    => 1,
    "$E/Stats/Equipment/Equipment.stats"                  => 1,
    "$E/CharacterCreationPresets/AbilityDistributionPresets.tbl" => 1,
    "$E/DefaultValues/Abilities.tbl"                      => 1,
    "$E/DefaultValues/Skills.tbl"                         => 1,
);
my $keep = qr/(<attribute id="Name" type="FixedString" value="Heartweaver"\/>|name="NameFS" type="FixedStringTableFieldDefinition" value="Heartweaver")/;
my (%out, $bad);
for my $f (sort keys %F) {
    open my $in, '<:raw', $f or die "$f: $!"; local $/; my $s = <$in>; close $in;
    my @hold; $s =~ s/$keep/push @hold, $1; "\x{1}$#hold\x{2}"/ge;
    my $n = 0; $n += $s =~ s/Heartweaver/Resonant/g; $n += $s =~ s/HEARTWEAVER/RESONANT/g;
    $s =~ s/\x{1}(\d+)\x{2}/$hold[$1]/g;
    (my $short = $f) =~ s{^\Q$G\E/}{};
    printf "%-3s %2d/%2d  %s\n", ($n == $F{$f} ? 'ok' : 'BAD'), $n, $F{$f}, $short;
    $bad++ if $n != $F{$f}; $out{$f} = $s;
}
die "count mismatch, nothing written\n" if $bad;
exit 0 unless $apply;
my $bk = 'C:/Projetos/BG3 Modding/Arcana Class/Backup/rename_resonant_' . strftime('%Y%m%d-%H%M%S', localtime);
for my $f (sort keys %out) {
    (my $rel = $f) =~ s{^\Q$G\E/}{}; (my $dir = "$bk/$rel") =~ s{/[^/]+$}{}; make_path($dir);
    copy($f, "$bk/$rel") or die "backup $f: $!";
    open my $o, '>:raw', $f or die "$f: $!"; print $o $out{$f}; close $o;
}
print "written; backup in $bk\n";
