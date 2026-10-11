#!/usr/bin/perl
# compare_versions — structured diff between two versions of the mod (spec §11, feeds 76.02).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/compare_versions.pl <old dir> <new dir> [out.md]
#
# Each dir is an extracted .pak (extract_pak.sh) or 50_ENGINEERING/51_Mod_Source. Compares:
#   Stats entries (added / removed / changed fields, by entry type), English loca texts, LSX / other files
#   (added / removed / changed by content), icons (.dds). Output: markdown to [out.md] or stdout.
use strict; use warnings; use utf8;
use Digest::MD5 qw(md5_hex);
binmode STDOUT, ':utf8';
my ($OLD, $NEW, $OUT) = @ARGV;
die "usage: compare_versions.pl <old dir> <new dir> [out.md]\n" unless $OLD && $NEW && -d $OLD && -d $NEW;

sub files { my $d = shift; my %f; for (split /\n/, `find "$d" -type f -not -path '*/.git/*'`) { (my $r = $_) =~ s{^\Q$d\E/?}{}; $f{$r} = $_ } \%f }
sub stats { my $d = shift; my %e;
  for my $f (split /\n/, `find "$d" -path '*Stats/Generated/Data/*.txt' -type f`) {
    open my $fh, '<:encoding(UTF-8)', $f or next; my $cur;
    while (my $l = <$fh>) { $l =~ s/[\r\n]+$//;
      if ($l =~ /^new entry "([^"]+)"/) { $cur = $1; $e{$cur} = { _type => '' }; next }
      next unless $cur;
      if ($l =~ /^type "([^"]+)"/) { $e{$cur}{_type} = $1 } elsif ($l =~ /^using "([^"]+)"/) { $e{$cur}{using} = $1 }
      elsif ($l =~ /^data "([^"]+)" "(.*)"$/) { $e{$cur}{$1} = $2 } } }
  \%e }
sub loca { my $d = shift; my %m;
  my ($f) = grep { m{English/english\.xml$}i } split /\n/, `find "$d" -iname 'english.xml'`;
  return \%m unless $f; open my $fh, '<:encoding(UTF-8)', $f or return \%m;
  while (<$fh>) { $m{$1} = $2 if /contentuid="([^"]+)"[^>]*>(.*?)<\/content>/ } \%m }
sub hash { my $p = shift; open my $fh, '<:raw', $p or return ''; local $/; my $c = <$fh>; $c =~ s/\r\n/\n/g; md5_hex($c) }

my ($so, $sn) = (stats($OLD), stats($NEW));
my ($lo, $ln) = (loca($OLD), loca($NEW));
my $name = sub { my ($e, $s) = @_; my $h = $s->{$e}{DisplayName} // ''; $h =~ s/;\d+$//; my $n = $ln->{$h} // $lo->{$h} // ''; $n =~ s/&lt;[^&]*?&gt;//g; $n ? " ($n)" : '' };

my $o = "# Version diff\n\n- Old: `$OLD`\n- New: `$NEW`\n\n## Stats entries\n";
my %types;   # read without autovivifying entries of the other version
$types{ $so->{$_}{_type} }++ for keys %$so;
$types{ $sn->{$_}{_type} }++ for keys %$sn;
my ($na, $nr, $nc) = (0, 0, 0);
for my $t (sort keys %types) {
  my @add = sort grep { !$so->{$_} && $sn->{$_}{_type} eq $t } keys %$sn;
  my @rem = sort grep { !$sn->{$_} && $so->{$_}{_type} eq $t } keys %$so;
  my @chg;
  for my $e (sort grep { $sn->{$_} && $sn->{$_}{_type} eq $t } keys %$so) {
    my %k = map { $_ => 1 } (keys %{ $so->{$e} }, keys %{ $sn->{$e} });
    my @d = map { sprintf "    - `%s`: %s ⇒ **%s**", $_, $so->{$e}{$_} // '—', $sn->{$e}{$_} // '—' }
            grep { $_ ne '_type' && ($so->{$e}{$_} // "\0") ne ($sn->{$e}{$_} // "\0") } sort keys %k;
    push @chg, ["$e" . $name->($e, $sn), @d] if @d;
  }
  next unless @add || @rem || @chg;
  $na += @add; $nr += @rem; $nc += @chg;
  $o .= "\n### $t\n\n";
  $o .= "- NEW `$_`" . $name->($_, $sn) . "\n" for @add;
  $o .= "- REMOVED `$_`" . $name->($_, $so) . "\n" for @rem;
  for (@chg) { my ($h, @d) = @$_; $o .= "- CHANGED `$h`\n" . join("\n", @d) . "\n" }
}
my @lc = grep { exists $lo->{$_} && $lo->{$_} ne $ln->{$_} } sort keys %$ln;
my @la = grep { !exists $lo->{$_} } sort keys %$ln;
my @lr = grep { !exists $ln->{$_} } sort keys %$lo;
$o .= "\n## English texts\n\n" . scalar(@la) . " new, " . scalar(@lr) . " removed, " . scalar(@lc) . " changed.\n\n";
$o .= "- `$_`: \"$lo->{$_}\" ⇒ \"$ln->{$_}\"\n" for @lc;

my ($fo, $fn) = (files($OLD), files($NEW));
my @skip = (qr/Stats\/Generated\/Data\/.*\.txt$/, qr/english\.xml$/i, qr/\.(md|gitkeep)$/, qr/\.lsf$/);
my $keep = sub { my $r = shift; !grep { $r =~ $_ } @skip };
my @fa = grep { $keep->($_) && !$fo->{$_} } sort keys %$fn;
my @fr = grep { $keep->($_) && !$fn->{$_} } sort keys %$fo;
my @fc = grep { $keep->($_) && $fn->{$_} && hash($fo->{$_}) ne hash($fn->{$_}) } sort keys %$fo;
$o .= "\n## Other files (LSX, Lua, Khonsu, Osiris goals, icons…)\n\n";
$o .= "- NEW `$_`\n" for @fa; $o .= "- REMOVED `$_`\n" for @fr; $o .= "- CHANGED `$_`\n" for @fc;
$o .= "_None._\n" unless @fa || @fr || @fc;
my $sum = "Stats: $na new, $nr removed, $nc changed · texts: " . scalar(@la) . "/" . scalar(@lr) . "/" . scalar(@lc)
        . " · files: " . scalar(@fa) . "/" . scalar(@fr) . "/" . scalar(@fc);
$o =~ s/\n## Stats entries\n/\n**Summary:** $sum\n\n## Stats entries\n/;
if ($OUT) { open my $f, '>:encoding(UTF-8)', $OUT or die $!; print $f $o; close $f } else { print $o }
print STDERR "$sum\n";
