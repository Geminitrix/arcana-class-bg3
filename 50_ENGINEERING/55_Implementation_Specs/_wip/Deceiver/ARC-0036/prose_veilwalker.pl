#!/usr/bin/perl
# ARC-0036 (Owner: documents call the subclass *Veilwalker* in prose; *Deceiver* only as an id or folder, in `code`).
#   perl prose_veilwalker.pl <file>...   rewrites in place, prints the count per file
# Outside backticks only. Kept: paths and ids (Deceiver next to / _ . - or a digit), the italic *Deceiver* that names
# the internal name, "internal: Deceiver", "Deceiver robe" / "Deceiver's Robe" (an item name in game text), YAML headers.
use strict; use warnings;
for my $p (@ARGV) {
  open my $f, '<:raw', $p or die "$p: $!"; local $/; my $s = <$f>; close $f;
  my $n = 0; my $out = ''; my $yaml = 0; my $first = 1;
  for my $line (split /(?<=\n)/, $s) {
    if ($first && $line =~ /^---\r?$/) { $yaml = 1; $first = 0; $out .= $line; next }
    $first = 0;
    if ($yaml) { $yaml = 0 if $line =~ /^---\r?$/; $out .= $line; next }
    my @seg = split /(`[^`]*`)/, $line;
    for my $seg (@seg) {
      next if $seg =~ /^`/;
      $n += $seg =~ s{(?<![/_.\-\w*`:]|internal: )(?<!internal: )\bDeceiver\b(?![/_.\-\w*`]|(?:'s)? [Rr]obe)}{Veilwalker}g;
    }
    $out .= join '', @seg;
  }
  next unless $n;
  open my $o, '>:raw', $p or die "$p: $!"; print $o $out; close $o; print "$n\t$p\n";
}
