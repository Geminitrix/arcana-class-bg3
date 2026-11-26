#!/usr/bin/perl
# ARC-0036 — rename the Veilwalker ids (DV37) in place, keeping every entry's position.
#
#   perl rename_ids.pl --out <dir>      dry run: reads the game files, writes renamed copies under <dir>
#                                       (same relative paths) and <dir>/REPORT.md. Touches nothing in Data.
#   perl rename_ids.pl --apply <dir>    copies the files of a dry run back into Data (needs `[fechado] ARC-0036`,
#                                       a backup first, and the Toolkit closed).
#
# Text files only. Compiled Story (story.div, goals.raw, story_ac.dat) is left to the Story Editor (OR-15);
# root templates (.lsf) are reported, not changed. Loca: only LSTag Tooltip="…" ids change, never the prose.
use strict; use warnings;
use File::Find; use File::Path qw(make_path); use File::Copy qw(copy); use File::Basename qw(dirname);

my $DATA = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $MOD  = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $PROJ = 'C:/Lumox Studios/Arcana Class';
my @ROOTS = ("Public/$MOD", "Mods/$MOD", "Editor/Mods/$MOD");
my $TEXT  = qr/\.(txt|stats|lsx|tbl|lua|khn|xml|md|json)$/i;
my $SKIP  = qr{(?:^|/)(?:story\.div|goals\.raw|story_ac\.dat)$}i;

my ($mode, $dir) = @ARGV; die "usage: --out <dir> | --apply <dir> | --docs <file>...\n" unless $mode && $dir && $mode =~ /^--(out|apply|docs)$/;

# Ordered: the longer / more specific ids first. N = boundary: no letter or digit around the match
# (an underscore is allowed, so type prefixes and _N variants ride along).
my @MAP = (
  # spells and passives (ids without the type prefix, so the .stats Name matches too)
  [ 'Arcana_Created_MimicSigilofMalice', 'Arcana_Created_TwiceTold_SeedOfDoubt' ],
  [ 'Arcana_Created_MimicEtherealChains', 'Arcana_Created_TwiceTold_BindingFalsehood' ],
  [ 'Arcana_Created_MimicDistortion', 'Arcana_Created_TwiceTold_Veilstep' ],
  [ 'Arcana_Created_MimicWithdraw', 'Arcana_Created_TwiceTold_Withdraw' ],
  [ 'Arcana_Created_Mimic', 'Arcana_Created_TwiceTold' ],
  [ 'Arcana_MimicDistortion_Explosion', 'Arcana_TwiceTold_Veilstep_Explosion' ],
  [ 'Arcana_Distortion_Explosion', 'Arcana_Veilstep_Explosion' ],
  [ 'Arcana_Card_Spell_SigilofMalice', 'Arcana_Card_Spell_SeedOfDoubt' ],
  [ 'DEBUG_SigilofMalice', 'Arcana_Util_DEBUG_SeedOfDoubt' ],
  [ 'Arcana_Card_Spell_MirrorImage', 'Arcana_Card_Spell_Eidolon' ],
  [ 'Arcana_Card_Spell_EtherealChains', 'Arcana_Card_Spell_BindingFalsehood' ],
  [ 'Arcana_Card_Spell_Distortion', 'Arcana_Card_Spell_Veilstep' ],
  [ 'Arcana_Card_Passive_MirroredCharm', 'Arcana_Card_Passive_MirroredSelf' ],
  [ 'Arcana_Passive_MirroredCharm', 'Arcana_Passive_MirroredSelf' ],
  [ 'Arcana_Aspect_WhichOne', 'Arcana_Reaction_WhichOne' ],
  [ 'Arcana_Passive_Aspect_Empress', 'Arcana_Passive_Aspect_HighPriestess' ],
  [ 'Deceiver_Double_MirrorSigil', 'Arcana_Double_ReflectedSeed', 'slot' ],
  [ 'Deceiver_Double_MirrorChains', 'Arcana_Double_ReflectedFalsehood', 'slot' ],
  [ 'Deceiver_Double_Unveil', 'Arcana_Double_Unveil' ],
  # statuses (uppercase, case-sensitive)
  [ 'SIGIL_OF_MALICE_LAST_CASTED', 'SEED_OF_DOUBT_LAST_CASTED' ],
  [ 'SIGIL_DETONATED_TECH', 'SEED_BURST_TECH' ],
  [ 'SIGIL_TECH', 'SEED_TECH' ],
  [ 'MIMIC_DISTORTION_HELPER', 'TWICE_TOLD_VEILSTEP_HELPER' ],
  [ 'MIMIC_ETHEREAL_CHAINS', 'TWICE_TOLD_BINDING_FALSEHOOD' ],
  [ 'DISTORTION_HELPER', 'VEILSTEP_HELPER' ],
  [ 'DISTORTION_LAST_CASTED', 'VEILSTEP_LAST_CASTED' ],
  [ 'ASPECT_AWAKENED_EMPRESS', 'ASPECT_AWAKENED_HIGHPRIESTESS' ],
  [ 'ASPECT_PROGRESS_EMPRESS', 'ASPECT_PROGRESS_HIGHPRIESTESS' ],
  [ 'MIMIC_LAST_CAST', 'TWICE_TOLD_LAST_CAST' ],
  # found by the first dry run (2026-11-25)
  [ 'Shout_Deceiver_Double_Shatter', 'Shout_Arcana_Double_Splinter' ],   # Osiris still used the old id
  [ 'Sigil_MarkDamage', 'Seed_BurstDamage' ],                            # level map read by the Seed
  [ 'DB_ARCANA_MirrorImageOf', 'DB_ARCANA_DoubleOf' ],
  [ 'DB_ARCANA_SigilDoubtOwner', 'DB_ARCANA_SeedDoubtOwner' ],
  [ 'PROC_ARCANA_Sigil_Doubt', 'PROC_ARCANA_Seed_Doubt' ],
  [ 'PROC_ARCANA_Sigil_SetDoubtOwner', 'PROC_ARCANA_Seed_SetDoubtOwner' ],
  [ 'ARCANA_MimicWithdraw', 'ARCANA_TwiceToldWithdraw' ],                 # its DB_, PROC_ and timer strings
  [ 'DoubleOfTheVeil', 'DoubleOfTheVeil', 'slot' ],                      # shapeshift rules: _SlotN -> _N
);
# ETHEREAL_CHAINS family (Binding Falsehood's statuses): a whole id start, after MIMIC_ETHEREAL_CHAINS is gone.
my @PREFIX = ( [ 'ETHEREAL_CHAINS', 'BINDING_FALSEHOOD' ] );
# SIGIL alone: a whole id (no letter, digit or underscore around it), so SIGIL_X leftovers are reported, not guessed.
my @EXACT = ( [ 'SIGIL', 'SEED' ], [ 'EMPRESS', 'HIGHPRIESTESS' ] );   # "EMPRESS" = the Awakening key

my $LEFT = qr/Sigil|SIGIL|MirrorImage|MirrorSigil|MirrorChains|MirroredCharm|EtherealChains|ETHEREAL_CHAINS|Mimic|MIMIC|Distortion|DISTORTION|Empress|EMPRESS|_Slot\d|Deceiver_Double|Aspect_WhichOne/;

sub rename_ids {
  my ($s, $n) = @_;
  for my $m (@MAP) {
    my ($old, $new, $slot) = @$m;
    if ($slot) { $$n += $s =~ s/(?<![A-Za-z0-9])\Q$old\E_Slot(\d)(?![0-9])/${new}_$1/g; }
    $$n += $s =~ s/(?<![A-Za-z0-9])\Q$old\E(?![A-Za-z0-9])/$new/g if $old ne $new;
  }
  for my $m (@PREFIX) { my ($old, $new) = @$m; $$n += $s =~ s/(?<![A-Za-z0-9_])\Q$old\E(?![A-Za-z0-9])/$new/g; }
  for my $m (@EXACT) { my ($old, $new) = @$m; $$n += $s =~ s/(?<![A-Za-z0-9_])\Q$old\E(?![A-Za-z0-9_])/$new/g; }
  return $s;
}

sub entries {   # entry names in file order (.txt "new entry", .stats Name field)
  my ($s) = @_;
  my @e = $s =~ /^new entry "([^"]+)"/mg;
  push @e, $s =~ /<field name="Name"[^>]*value="([^"]+)"/g;
  return @e;
}

sub slurp { open my $f, '<:raw', $_[0] or die "$_[0]: $!"; local $/; <$f> }
sub spew  { make_path(dirname($_[0])); open my $f, '>:raw', $_[0] or die "$_[0]: $!"; print $f $_[1]; close $f }

if ($mode eq '--docs') {   # project documents that describe the current build: same table, in place
  shift @ARGV;
  for my $p (@ARGV) { my $s = slurp($p); my $n = 0; my $t = rename_ids($s, \$n); next unless $n; spew($p, $t); print "$n\t$p\n"; }
  exit 0;
}

if ($mode eq '--apply') {
  my @files; find(sub { push @files, $File::Find::name if -f && $File::Find::dir =~ m{/(?:Public|Mods|Editor)/} }, $dir);   # game paths only (no REPORT, REMOVED_*)
  for my $src (@files) { (my $rel = $src) =~ s/^\Q$dir\E\/?//; copy($src, "$DATA/$rel") or die "$rel: $!"; print "applied $rel\n"; }
  exit 0;
}

my (@rep, @left, @order_bad, $total, %clash);
my @files;
for my $r (@ROOTS) { find(sub { push @files, $File::Find::name if -f }, "$DATA/$r") if -d "$DATA/$r"; }
for my $p (sort @files) {
  (my $rel = $p) =~ s/^\Q$DATA\E\///;
  if ($rel =~ /\.lsf$/i) {
    my $raw = slurp($p); my %h; $h{$1}++ while $raw =~ /([A-Za-z_]*(?:$LEFT)[A-Za-z0-9_]*)/g;
    push @left, "$rel (binary, not changed): " . join(', ', sort keys %h) if %h; next;
  }
  next unless $rel =~ $TEXT; next if $rel =~ $SKIP;
  my $s = slurp($p); my $n = 0; my $t;
  for my $m (@MAP, @EXACT, @PREFIX) {   # a new name already in use would merge two ids
    my ($old, $new) = @$m; next if $old eq $new;
    $clash{$new}{$rel}++ if $s =~ /(?<![A-Za-z0-9_])\Q$new\E(?![A-Za-z0-9])/;
  }
  if ($rel =~ m{/Localization/}) {
    $t = $s; $t =~ s/(Tooltip=(?:"|&quot;))([^"&]+)/$1 . rename_ids($2, \$n)/ge;
  } else { $t = rename_ids($s, \$n); }
  my @b = entries($s); my @a = entries($t);
  if (@b) {
    my @mapped = map { my $x = 0; rename_ids($_, \$x) } @b;
    push @order_bad, "$rel: count " . scalar(@b) . " → " . scalar(@a) if @a != @b || join("\n", @mapped) ne join("\n", @a);
  }
  my %h; my $chk = $rel =~ m{/Localization/} ? join(' ', $t =~ /Tooltip=(?:"|&quot;)([^"&]+)/g) : $t;
  $h{$1}++ while $chk =~ /([A-Za-z_]*(?:$LEFT)[A-Za-z0-9_]*)/g;
  push @left, "$rel: " . join(', ', map { "$_ ×$h{$_}" } sort keys %h) if %h;
  next unless $n;
  $total += $n; push @rep, sprintf("| `%s` | %d | %d |", $rel, $n, scalar @b);
  spew("$dir/$rel", $t);
}

# Project side: tools that generate game files would write the old names back.
my @tools; find(sub { push @tools, $File::Find::name if -f && /\.(pl|py|lua|json|yaml|yml)$/ }, "$PROJ/80_TOOLS_AND_PIPELINE");
my @toolhits; for my $p (@tools) { my $s = slurp($p); my %h; $h{$1}++ while $s =~ /([A-Za-z_]*(?:$LEFT)[A-Za-z0-9_]*)/g; push @toolhits, ($p =~ s/^\Q$PROJ\E\///r) . ': ' . join(', ', sort keys %h) if %h; }

my $out = "# ARC-0036 — dry run of rename_ids.pl\n\nReplacements: $total in " . scalar(@rep) . " files.\n\n"
  . "## Files changed\n\n| File | Replacements | Entries |\n|---|---|---|\n" . join("\n", @rep) . "\n\n"
  . "## Entry order (must be empty)\n\n" . (@order_bad ? join("\n", map {"- $_"} @order_bad) : "OK — every Stats file keeps its entries, count and sequence.") . "\n\n"
  . "## New names already in use before the rename (must be empty)\n\n"
  . (%clash ? join("\n", map { my $k = $_; "- `$k`: " . join(', ', sort keys %{$clash{$k}}) } sort keys %clash) : "None.") . "\n\n"
  . "## Old words left in game files (to review)\n\n" . (@left ? join("\n", map {"- $_"} @left) : "None.") . "\n\n"
  . "## Project tools that still say an old word\n\n" . (@toolhits ? join("\n", map {"- $_"} @toolhits) : "None.") . "\n";
spew("$dir/REPORT.md", $out);
print "replacements $total, files " . scalar(@rep) . ", order problems " . scalar(@order_bad) . ", clashes " . scalar(keys %clash) . ", leftovers " . scalar(@left) . ", tool hits " . scalar(@toolhits) . "\n";
