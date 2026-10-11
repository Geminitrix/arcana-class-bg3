#!/usr/bin/perl
# gen_type_catalog — build 55.00_Type_Catalog.md from the extracted base game (grounding, spec §32.1).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/gen_type_catalog.pl   (from the repository root)
#
# Reads: every vanilla Stats file under the local extraction (BG3_VANILLA, default
# C:\Projetos\BG3\Base Game BG3\Assets), Modifiers.txt and ValueLists.txt (the official schema),
# and the mod's own Stats in 51. Writes only 50_ENGINEERING/55_Implementation_Specs/55.00_Type_Catalog.md.
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my $V   = $ENV{BG3_VANILLA} // '/c/Projetos/BG3/Base Game BG3/Assets';
my $SCH = "$V/Shared_Extracted/Public/Shared/Stats/Generated/Structure";
my $MOD = '50_ENGINEERING/51_Mod_Source/Public/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Stats/Generated/Data';
my $OUT = '50_ENGINEERING/55_Implementation_Specs/55.00_Type_Catalog.md';
-d $SCH or die "vanilla schema not found at $SCH (set BG3_VANILLA)\n";

sub stats_files { my $root = shift; my @f = split /\n/, `find "$root" -path '*/Stats/Generated/Data/*.txt' -type f 2>/dev/null`; @f }

# count <field> values per entry type in a set of Stats files; remember one example entry per value
sub scan {
  my ($files, $field) = @_; my (%n, %ex, %src);
  for my $f (@$files) {
    open my $fh, '<:encoding(UTF-8)', $f or next; my ($cur, $type);
    (my $short = $f) =~ s{.*/Public/}{Public/};
    while (my $l = <$fh>) { $l =~ s/[\r\n]+$//;
      if ($l =~ /^new entry "([^"]+)"/) { $cur = $1; next }
      if ($l =~ /^data "\Q$field\E" "([^"]+)"/) { $n{$1}++; $ex{$1} //= $cur; $src{$1} //= $short }
    }
  }
  return (\%n, \%ex, \%src);
}

my @van = stats_files($V);
my @mod = stats_files('50_ENGINEERING/51_Mod_Source');
my ($sv, $sex, $ssrc) = scan(\@van, 'SpellType');   my ($sm) = scan(\@mod, 'SpellType');
my ($tv, $tex, $tsrc) = scan(\@van, 'StatusType');  my ($tm) = scan(\@mod, 'StatusType');

# value lists from the schema
my %vl; { open my $fh, '<:encoding(UTF-8)', "$SCH/Base/ValueLists.txt" or die $!; my $cur;
  while (<$fh>) { s/[\r\n]+$//; if (/^valuelist "([^"]+)"/) { $cur = $1; next } push @{ $vl{$cur} }, $1 if $cur && /^value "([^"]+)"/ } }

# modifier types and their field counts
my (%mt, $cur); { open my $fh, '<:encoding(UTF-8)', "$SCH/Modifiers.txt" or die $!;
  while (<$fh>) { if (/^modifier type "([^"]+)"/) { $cur = $1; next } $mt{$cur}++ if $cur && /^modifier "/ } }

my @t = localtime; my $date = sprintf '%04d-%02d-%02d', $t[5]+1900, $t[4]+1, $t[3];
my $o = "# 55.00 · Type catalogue\n\n"
  . "*Generated $date by `82_Automation/gen_type_catalog.pl` from the extracted base game (" . scalar(@van)
  . " vanilla Stats files) and the official schema (`Modifiers.txt`, `ValueLists.txt`). Never edit by hand —\n"
  . "re-run the script. Where in the Toolkit: Stats editor, under the entry type named in the first table.*\n\n"
  . "## Entry types (schema `Modifiers.txt`)\n\n| Entry type | Fields in the schema | Mod file pattern |\n|---|---|---|\n";
my %pat = (SpellData => 'Spell_<SpellType>.txt', StatusData => 'Status_<StatusType>.txt', PassiveData => 'Passive.txt',
           InterruptData => 'Interrupt.txt', Armor => 'Armor.txt', Weapon => 'Weapon.txt', Character => 'Character.txt', Object => 'Object.txt');
$o .= sprintf "| `%s` | %d | %s |\n", $_, $mt{$_}, $pat{$_} // '—' for sort keys %mt;

$o .= "\n## Spell subtypes (`SpellType`, a free string — values found in the base game)\n\n"
   .  "| SpellType | Vanilla entries | Used by the mod | Vanilla example (entry · file) |\n|---|---|---|---|\n";
$o .= sprintf "| `%s` | %d | %s | `%s` · `%s` |\n", $_, $sv->{$_}, $sm->{$_} // '', $sex->{$_}, $ssrc->{$_}
  for sort { $sv->{$b} <=> $sv->{$a} } keys %$sv;

$o .= "\n## Status subtypes (`StatusType` — values found in the base game)\n\n"
   .  "| StatusType | Vanilla entries | Used by the mod | Vanilla example (entry · file) |\n|---|---|---|---|\n";
$o .= sprintf "| `%s` | %d | %s | `%s` · `%s` |\n", $_, $tv->{$_}, $tm->{$_} // '', $tex->{$_}, $tsrc->{$_}
  for sort { $tv->{$b} <=> $tv->{$a} } keys %$tv;

for my $l ('CooldownType', 'SpellSchool', 'SpellStyleGroup', 'ProjectileType') {
  next unless $vl{$l};
  $o .= "\n## `$l` (schema value list)\n\n" . join(', ', map { "`$_`" } @{ $vl{$l} }) . "\n";
}
$o .= "\n## Recommended creation order in a spec (spec §7)\n\n"
   .  "status → passive → spell → spell list → progression → class / subclass → localization → icon.\n";

open my $f, '>:encoding(UTF-8)', $OUT or die $!; print $f $o; close $f;
printf "spell types %d, status types %d, entry types %d, vanilla files %d\n", scalar keys %$sv, scalar keys %$tv, scalar keys %mt, scalar @van;
