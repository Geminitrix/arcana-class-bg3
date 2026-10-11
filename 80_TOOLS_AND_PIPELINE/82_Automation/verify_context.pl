#!/usr/bin/perl
# verify_context — check the 05 Live Context against the game files (one cheap, falsifiable test).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/verify_context.pl      (from the repository root)
#
# For each progression (from dump_progression.pl): every granted spell / passive must be named in the
# matching 05 file (by in-game name or internal id). And every internal id written in a 05 file must
# exist in the mod's Stats (25.05_inventory). Prints the misses; exit 1 when any.
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my %file = (Arcana => '05_LIVE_CONTEXT/05.01_Class/Arcana_Base_Class.md');
$file{$_} = "05_LIVE_CONTEXT/05.02_Subclasses/$_.md" for qw(Unbound Deceiver Starchild Eternal Resonant Spinner Lionheart);
my %alias = (Titan => 'Lionheart');   # internal progression name → studio name (to confirm)

# known stats entries
my %known;
for my $y (glob '20_GAME_DESIGN/25_Master_Data/25.05_inventory/*.yaml') {
  open my $fh, '<:encoding(UTF-8)', $y or next; while (<$fh>) { $known{$1} = 1 if /^"([^"]+)":/ } }
die "run gen_catalog.pl first\n" unless %known;

# progression dump
my $dump = `perl 80_TOOLS_AND_PIPELINE/82_Automation/dump_progression.pl`;
utf8::decode($dump);
my (%grant, $sec, $lvl);
for (split /\n/, $dump) {
  if (/^=== (\w+) L(\d+)/) { ($sec, $lvl) = ($alias{$1} // $1, $2); next }
  if (/^\s+- (SPELL|PASSIVE) (\S+) \| "([^"]*)"/) { push @{ $grant{$sec} }, [$lvl, $1, $2, $3] }
}

my $bad = 0;
for my $s (sort keys %grant) {
  my $f = $file{$s} or do { print "## $s: no 05 file mapped\n"; $bad++; next };
  open my $fh, '<:encoding(UTF-8)', $f or do { print "## $s: $f missing\n"; $bad++; next };
  local $/; my $t = <$fh>; close $fh;
  my (%seen, @miss);
  for my $g (@{ $grant{$s} }) {
    my ($l, $k, $id, $name) = @$g; next if $seen{$id}++;
    (my $base = $id) =~ s/_\d+$//;
    next if index($t, $id) >= 0 || index($t, $base) >= 0 || ($name ne '' && index($t, $name) >= 0);
    push @miss, sprintf "L%-2s %-7s %s \"%s\"", $l, $k, $id, $name;
  }
  my @ghost;
  while ($t =~ /\b((?:Target|Shout|Projectile|Zone|Rush|Teleportation|Throw|Wall|ProjectileStrike)_[A-Za-z0-9_]+|Arcana_Passive_[A-Za-z0-9_]+)/g) {
    my $id = $1; push @ghost, $id unless $known{$id} || $known{"${id}_2"} || grep { $_ eq $id } @ghost;
  }
  my $n = scalar keys %seen;
  printf "## %s (%s) — %d granted, %d not in the file, %d ids in the file not in the game\n", $s, $f, $n, scalar @miss, scalar @ghost;
  print "   missing: $_\n" for @miss;
  print "   ghost:   $_\n" for @ghost;
  $bad += @miss + @ghost;
}
exit($bad ? 1 : 0);
