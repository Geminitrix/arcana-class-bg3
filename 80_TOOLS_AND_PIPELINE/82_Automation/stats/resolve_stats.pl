#!/usr/bin/perl
# Prints the effective fields of stats entries after resolving `using`, from vanilla + the mod.
# usage: resolve_stats.pl ENTRY [ENTRY...]
use strict; use warnings;
my $V = 'C:/Projetos/BG3/Base Game BG3/Assets';
my @dirs = (
  "$V/Shared_Extracted/Public/Shared/Stats/Generated/Data",
  "$V/Shared_Extracted/Public/SharedDev/Stats/Generated/Data",
  "$V/Gustav_Extracted/Public/Gustav/Stats/Generated/Data",
  "$V/Gustav_Extracted/Public/GustavDev/Stats/Generated/Data",
  'C:/Lumox Studios/Arcana Class/50_ENGINEERING/51_Mod_Source/Public/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Stats/Generated/Data',
);
my %E;   # name -> { using => ..., data => { k => v }, order => [k...], src => file }
for my $d (@dirs) {
  opendir my $dh, $d or next;
  for my $f (sort grep { /\.txt$/ } readdir $dh) {
    open my $h, '<', "$d/$f" or die;
    my $cur;
    while (my $l = <$h>) {
      $l =~ s/[\r\n]+$//;
      if ($l =~ /^new entry "([^"]+)"/) { $cur = $1; $E{$cur} = { data => {}, order => [], src => "$d/$f" }; next }
      next unless defined $cur;
      if ($l =~ /^using "([^"]+)"/) { $E{$cur}{using} = $1; next }
      if ($l =~ /^data "([^"]+)" "(.*)"$/) { push @{$E{$cur}{order}}, $1 unless exists $E{$cur}{data}{$1}; $E{$cur}{data}{$1} = $2 }
    }
  }
}
sub resolve { my ($n, $seen) = @_; $seen ||= {}; die "loop at $n\n" if $seen->{$n}++;
  my $e = $E{$n} or die "no entry $n\n";
  my (%d, @o);
  if ($e->{using}) { my ($pd, $po) = resolve($e->{using}, $seen); %d = %$pd; @o = @$po }
  for my $k (@{$e->{order}}) { push @o, $k unless exists $d{$k}; $d{$k} = $e->{data}{$k} }
  return (\%d, \@o);
}
for my $n (@ARGV) {
  my ($d, $o) = resolve($n);
  my $chain = $n; my $x = $n; while ($E{$x}{using}) { $x = $E{$x}{using}; $chain .= " -> $x" }
  print "### $chain\n";
  print "$_\t$d->{$_}\n" for @$o;
  print "\n";
}
