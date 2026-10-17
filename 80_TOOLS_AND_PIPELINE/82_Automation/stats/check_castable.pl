#!/usr/bin/perl
# check_castable — every spell a patch creates must be castable by the player: after following its `using` chain
# (the patch's own entries first, then the mod, then vanilla Shared/Gustav), it must have a SpellAnimation and a
# CastTextEvent. Without them the game shows the spell but never enters targeting (ARC-0026, Probe: Mark).
# Explosions cast only through CreateExplosion are exempt: name them *Inner or *_Explosion.
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/check_castable.pl <patch> [patch ...]     (exit 1 on a failure)
use strict; use warnings; use File::Glob qw(bsd_glob);   # paths with spaces
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $V = 'C:/Projetos/BG3/Base Game BG3/Assets';
my (%using, %field, %new);
sub read_entries {   # name -> using, and the fields it sets
    my ($text, $mark) = @_; my $e;
    for (split /\r?\n/, $text) {
        if (/^new entry "(.+)"/) { $e = $1; $new{$e} = 1 if $mark; delete $field{$e} if $mark; next }
        next unless defined $e;
        $using{$e} //= $1 if /^using "(.+)"/;
        $field{$e}{$1} //= $2 if /^data "(\w+)" "(.*)"/;
    }
}
sub slurp { open my $h, '<:raw', $_[0] or return ''; local $/; my $s = <$h>; $s }
# lowest priority first: later reads keep the first value seen per entry, so read the patches before the game
for my $p (@ARGV) { read_entries(slurp($p), 1) }
for my $f (bsd_glob("$G/Public/$M/Stats/Generated/Data/Spell_*.txt"),
           bsd_glob("$V/Shared_Extracted/Public/*/Stats/Generated/Data/Spell_*.txt"),
           bsd_glob("$V/Gustav_Extracted/Public/*/Stats/Generated/Data/Spell_*.txt")) { read_entries(slurp($f), 0) }
sub resolved { my ($e, $k, $seen) = @_; $seen //= {};
    while (defined $e && !$seen->{$e}++) { return $field{$e}{$k} if exists $field{$e}{$k}; $e = $using{$e} } undef }
my @bad;
for my $e (sort keys %new) {
    next unless exists $field{$e}{SpellType} || defined resolved($e, 'SpellType');
    next if $e =~ /(Inner|_Explosion)$/;
    my @miss = grep { !length(resolved($e, $_) // '') } qw(SpellAnimation CastTextEvent);
    push @bad, "$e: no " . join(' / ', @miss) if @miss;
}
print @bad ? join("\n", @bad) . "\nNOT CASTABLE: " . scalar(@bad) . "\n" : "castable: " . scalar(grep { defined resolved($_, 'SpellType') } keys %new) . " spells OK\n";
exit(@bad ? 1 : 0);
