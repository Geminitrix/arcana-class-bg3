#!/usr/bin/perl
# validate — static checks on the synchronized mod copy (53.03, code gate item 3).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/validate.pl      (from the repository root, after sync_data)
#
# 1. Duplicate UUID definitions in the data tables (Lists, Progressions, ClassDescriptions, ActionResource*).
# 2. Text handles used by Stats / LSX that are missing from the mod's English loca (may be vanilla — listed
#    as warnings, not errors).
# 3. Expansion inventory: what progression rows above level 12 grant (module 13–20). Listed for review —
#    the rule is that the 1–12 core never depends on it, which needs a human read.
# 4. Master-data YAML vs schemas in 25.00_schemas (skipped while no schema exists).
# Exit 1 on errors (check 1).
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';
my $M = '50_ENGINEERING/51_Mod_Source';
my ($err, $warn) = (0, 0);

# 1 — duplicate UUID definitions
my %uuid;
for my $f (split /\n/, `find "$M/Public" -name '*.lsx' \\( -path '*/Lists/*' -o -path '*/Progressions/*' -o -path '*/ClassDescriptions/*' -o -path '*/ActionResource*' \\)`) {
  open my $fh, '<:encoding(UTF-8)', $f or next;
  while (<$fh>) { $uuid{lc $1}{$f}++ while /<attribute id="UUID"[^>]*value="([0-9a-fA-F-]{36})"/g } }
my @dup = grep { my $n = 0; $n += $_ for values %{ $uuid{$_} }; $n > 1 } sort keys %uuid;
printf "1. UUID definitions: %d, duplicates: %d\n", scalar keys %uuid, scalar @dup;
for my $u (@dup) { print "   DUP $u in " . join(', ', map { s{.*/}{}r } sort keys %{ $uuid{$u} }) . "\n"; $err++ }

# 2 — handles
my %loca;
for my $f (split /\n/, `find "$M" -ipath '*Localization/English/english.xml'`) {
  open my $fh, '<:encoding(UTF-8)', $f or next; while (<$fh>) { $loca{$1} = 1 if /contentuid="([^"]+)"/ } }
my %miss;
for my $f (split /\n/, `find "$M/Public" -name '*.txt' -o -name '*.lsx'`) {
  open my $fh, '<:encoding(UTF-8)', $f or next;
  while (my $l = <$fh>) { while ($l =~ /\b(h[0-9a-f]{8}g[0-9a-f]{4}g[0-9a-f]{4}g[0-9a-f]{4}g[0-9a-f]{12})/g) { $miss{$1} //= $f =~ s{.*/}{}r unless $loca{$1} } } }
printf "2. Handles not in the mod's English loca (vanilla or missing): %d\n", scalar keys %miss;
print "   WARN $_ ($miss{$_})\n" for (sort keys %miss)[0 .. (keys %miss > 15 ? 14 : $#{[keys %miss]})];
print "   … " . (keys(%miss) - 15) . " more\n" if keys %miss > 15;
$warn += keys %miss;

# 3 — core vs expansion
my $exp = 0;
for my $f (split /\n/, `find "$M/Public" -path '*Progressions*' -name '*.lsx'`) {
  open my $fh, '<:encoding(UTF-8)', $f or next; local $/; my $t = <$fh>;
  while ($t =~ /<node id="Progression">(.*?)<\/node>\s*(?=<node id="Progression">|<\/children>)/sg) {
    my $n = $1; my ($lv) = $n =~ /id="Level"[^>]*value="(\d+)"/; next unless $lv && $lv > 12;
    my $grants = () = $n =~ /id="(?:Boosts|PassivesAdded|PassivesRemoved|Selectors|AllowImprovement)"[^>]*value="([^"]+)"/g;
    my ($name) = $n =~ /id="Name"[^>]*value="([^"]+)"/;
    if ($grants && $n !~ /id="AllowImprovement"[^>]*value="true"/) { print "   INFO $name level $lv grants content\n"; $exp++ }
  } }
printf "3. Progression rows above level 12 granting content (expansion, review only): %d\n", $exp;

# 4 — schemas
my @sch = glob '20_GAME_DESIGN/25_Master_Data/25.00_schemas/*';
print "4. Master-data schemas: " . (@sch ? scalar(@sch) . " (YAML validation not implemented yet)" : "none yet — skipped") . "\n";

print $err ? "FAIL: $err error(s), $warn warning(s)\n" : "OK: 0 errors, $warn warning(s)\n";
exit($err ? 1 : 0);
