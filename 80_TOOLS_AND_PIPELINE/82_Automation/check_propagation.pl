#!/usr/bin/perl
# check_propagation — is every department's artifact newer than the decisions it depends on? (00.08)
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/check_propagation.pl [Subclass]   report (exit 1 when pending)
#   perl …/check_propagation.pl --hook                                         Stop hook (JSON on stdin)
#
# Reads the subclass table of 00_GOVERNANCE/00.08_Propagation_Map/Propagation_Map.md (single source):
# sources and artifacts with the placeholder <S>. One dossier per folder in 21.04_Subclasses. A dossier
# with no source file yet is skipped. An artifact is STALE when any source is newer (file mtime), MISSING
# when absent. Also lists HANDOFF_*.md files without "status: done".
# Hook mode: blocks the end of a session when a dossier whose sources changed DURING THIS SESSION (since the
# transcript was created) has pending artifacts, or a handoff touched in this session is open. Never blocks twice in a row.
use strict; use warnings; use utf8;
use File::Find;
binmode STDOUT, ':utf8';

my $ROOT = $ENV{ARCANA_REPO} // 'C:/Lumox Studios/Arcana Class';
$ROOT =~ s{\\}{/}g;
my $hook = @ARGV && $ARGV[0] eq '--hook';
my $only = (!$hook && @ARGV) ? $ARGV[0] : undef;
my $WINDOW = 12 * 3600;

my ($stop_active, $cwd, $since) = (0, '', time - 12 * 3600);
if ($hook) {
  local $/; my $in = <STDIN> // '';
  $stop_active = $in =~ /"stop_hook_active"\s*:\s*true/ ? 1 : 0;
  ($cwd) = $in =~ /"cwd"\s*:\s*"([^"]*)"/; $cwd //= ''; $cwd =~ s/\\\\/\\/g;
  # session start = creation time of the transcript (Windows stat[10]); fallback: the last 12 hours
  if (my ($tp) = $in =~ /"transcript_path"\s*:\s*"([^"]*)"/) {
    $tp =~ s/\\\\/\\/g; my $c = (stat $tp)[10]; $since = $c if $c;
  }
  exit 0 unless $cwd =~ /Lumox Studios[\\\/]Arcana Class|Baldurs Gate 3[\\\/]Data/i;
}
chdir $ROOT or exit 0;

# --- the map ---
open my $mf, '<:encoding(UTF-8)', '00_GOVERNANCE/00.08_Propagation_Map/Propagation_Map.md' or die "map missing\n";
my $map = do { local $/; <$mf> };
my ($sec) = $map =~ /## Change type: subclass.*?\n(.*?)\n## /s or die "subclass section missing\n";
my ($srcline) = $sec =~ /Sources[^:]*:\s*\n(.*?)\n\n/s;
my @sources = $srcline =~ /`([^`]+)`/g;
my @arts;
for (split /\n/, $sec) { push @arts, [$1, $2] if /^\| `([^`]+)` \| ([^|]+?) \|/ }

# --- helpers ---
sub newest {   # mtime of a file, or of the newest file in a folder / glob; undef when nothing
  my $p = shift; my $t;
  my @hits = $p =~ /[*\[]/ ? glob($p) : (-e $p ? ($p) : ());
  for my $h (@hits) {
    if (-d $h) { find({ no_chdir => 1, wanted => sub { return unless -f $_; return if /\.gitkeep$/;
                   my $m = (stat $_)[9]; $t = $m if !defined $t || $m > $t } }, $h) }
    elsif (-f $h) { my $m = (stat $h)[9]; $t = $m if !defined $t || $m > $t }
  }
  $t;
}
sub dur { my $s = shift; $s < 3600 ? int($s/60) . ' min' : $s < 86400 ? int($s/3600) . ' h' : int($s/86400) . ' d' }
sub age { my $s = time - shift; $s < 3600 ? int($s/60) . ' min' : $s < 86400 ? int($s/3600) . ' h' : int($s/86400) . ' d' }

# --- dossiers ---
my $SUB = '20_GAME_DESIGN/21_GDD_Arcana_Class/21.04_Subclasses';
opendir my $dh, $SUB or die; my @dossiers = sort grep { !/^[._]/ && -d "$SUB/$_" } readdir $dh;
@dossiers = grep { $_ eq $only } @dossiers if $only;

my @report; my ($pending, $recent_pending) = (0, 0);
for my $s (@dossiers) {
  my $src;
  for my $p (@sources) { (my $x = $p) =~ s/<S>/$s/g; $x =~ s{/$}{};
    if ($x =~ m{/21\.04_Subclasses/$s$}) { next }   # folder itself handled below
    my $t = newest($x); $src = $t if defined $t && (!defined $src || $t > $src) }
  # dated specs in the dossier folder count as sources (DESIGN.md does not)
  for my $f (glob "$SUB/$s/*.md") { next if $f =~ m{/DESIGN\.md$}; my $t = (stat $f)[9]; $src = $t if !defined $src || $t > $src }
  unless (defined $src) { push @report, "## $s — no decisions recorded yet (skipped)"; next }
  my @lines;
  for my $a (@arts) { my ($p, $owner) = @$a; (my $x = $p) =~ s/<S>/$s/g; my $isdir = $x =~ s{/$}{};
    my $t = newest($x);
    if (!defined $t)    { push @lines, sprintf "   MISSING  %-26s %s", $owner, $x; }
    elsif ($t < $src)   { push @lines, sprintf "   STALE    %-26s %s (%s behind the last decision)", $owner, $x, dur($src - $t); }
  }
  my $recent = $src >= $since;
  $pending += @lines; $recent_pending += @lines if $recent;
  push @report, sprintf("## %s — last decision %s ago — %d pending", $s, age($src), scalar @lines), @lines;
}

# --- open handoffs ---
my @ho; my $recent_ho = 0;
find({ no_chdir => 1, wanted => sub {
  return if m{/(_LEGACY|90_ARCHIVE|\.git)/}; return unless m{/HANDOFF_[^/]*\.md$};
  open my $h, '<:encoding(UTF-8)', $_ or return; my $c = do { local $/; <$h> };
  return if $c =~ /^status:\s*done/mi;
  push @ho, $_ =~ s{^\./}{}r; $recent_ho++ if (stat $_)[9] >= $since } }, '.');
push @report, "## Open handoffs: " . scalar(@ho), map { "   OPEN     $_" } @ho;

if (!$hook) {
  print "$_\n" for @report;
  my $n = $pending + @ho;
  print $n ? "\nPENDING: $n — propagate (00.08) before ending the session\n" : "\nOK: every artifact is up to date\n";
  exit($n ? 1 : 0);
}

# hook mode
my $n = $recent_pending + $recent_ho;
exit 0 unless $n;
my $msg = "Propagation pending (00.08): $n artifact(s)/handoff(s) behind decisions taken in this session. "
        . "Run `perl 80_TOOLS_AND_PIPELINE/82_Automation/check_propagation.pl`, then update each artifact in its "
        . "owner's role (or refresh its `reviewed:` line when unaffected), execute open handoffs, log it in the ticket, commit.";
$msg =~ s/"/\\"/g;
if ($stop_active) { print "{\"systemMessage\":\"$msg\"}"; exit 0 }   # never block twice in a row
print "{\"decision\":\"block\",\"reason\":\"$msg\"}";
exit 0;
