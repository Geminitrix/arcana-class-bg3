#!/usr/bin/perl
# check_readme — compare README.md with the live context (05.00) before a commit (spec §12).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/check_readme.pl      (from the repository root)
#
# Checks: the published version in README matches 05.00; every subclass in 05.00's table is in README's
# table with the same state wording. Prints mismatches; exit 1 when any.
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

sub slurp { my $f = shift; open my $h, '<:encoding(UTF-8)', $f or die "$f: $!"; local $/; <$h> }
my $readme = slurp('README.md');
my $ctx    = slurp('05_LIVE_CONTEXT/05.00_READ_FIRST.md');
my $bad = 0;

my ($vr) = $readme =~ /published version \*\*([\d.]+)\*\*/i;
my ($vc) = $ctx    =~ /Published version \*\*([\d.]+)\*\*/i;
if (($vr // '') ne ($vc // '')) { print "version: README " . ($vr // '?') . " vs 05.00 " . ($vc // '?') . "\n"; $bad++ }

my (%r, %c);
while ($readme =~ /^\| (\w+) \| [^|]+ \| ([^|]+?) \|$/mg) { $r{$1} = $2 }
while ($ctx    =~ /^\| (\w+) \| [^|]+ \| ([^|]+?) \|$/mg) { $c{$1} = $2 }
for my $s (sort keys %c) {
  next if $s eq 'Subclass';
  if (!exists $r{$s}) { print "subclass $s: in 05.00, missing in README\n"; $bad++; next }
  (my $a = lc $r{$s}) =~ s/\W+/ /g; (my $b = lc $c{$s}) =~ s/\W+/ /g;
  my ($ka) = $a =~ /^\s*(\w+)/; my ($kb) = $b =~ /^\s*(\w+)/;   # compare the leading word: existing / new
  if (($ka // '') ne ($kb // '')) { print "subclass $s: README \"$r{$s}\" vs 05.00 \"$c{$s}\"\n"; $bad++ }
}
print $bad ? "README needs an update ($bad)\n" : "README matches 05.00\n";
exit($bad ? 1 : 0);
