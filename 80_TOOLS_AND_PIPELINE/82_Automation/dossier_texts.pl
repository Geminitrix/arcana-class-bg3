#!/usr/bin/perl
# dossier_texts — every player-facing text and icon of a set of Stats entries, from the synchronized mod (51).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/dossier_texts.pl <id regex> [--icons]
#   e.g. perl …/dossier_texts.pl 'Kingmaker|KINGMAKER_|COURT_|Coronation|Dethrone'
#
# Output (markdown, stdout): one table per entry type (Spells and cards, Passives, Statuses, Interrupts) with the
# internal id, the in-game name and the description, resolved from the English loca. With --icons: one table of
# id → Icon field instead. Upcast variants (<id>_N) are skipped. Used by the Lore Writer (32.01) and the Icon Artist
# (42.04) during /propagar (00.08). Run from the repository root after sync_data.
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';
my ($pat, $mode) = @ARGV; die "usage: dossier_texts.pl <id regex> [--icons]\n" unless $pat;
my $re = qr/$pat/;
my $M = '50_ENGINEERING/51_Mod_Source'; my $MOD = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';

my %loca;
open my $l, '<:encoding(UTF-8)', "$M/Mods/$MOD/Localization/English/english.xml" or die "loca: $!";
while (<$l>) { next unless /contentuid="([^"]+)"[^>]*>(.*?)<\/content>/; my ($k, $v) = ($1, $2);
  $v =~ s/&lt;[^&]*?&gt;//g; $v =~ s/&quot;/"/g; $v =~ s/&amp;/&/g; $v =~ s/&apos;/'/g; $v =~ s/\|/\\|/g; $loca{$k} = $v }
sub t { my $h = shift // ''; $h =~ s/;\d+$//; $loca{$h} // '' }

my (%e, @o, $cur);
for my $f (sort glob "$M/Public/$MOD/Stats/Generated/Data/*.txt") {
  open my $h, '<:encoding(UTF-8)', $f or next;
  while (my $x = <$h>) { $x =~ s/[\r\n]+$//;
    if ($x =~ /^new entry "([^"]+)"/) { $cur = $1; next }
    next unless $cur && $cur =~ $re && $cur !~ /_\d+$/;
    if ($x =~ /^type "(\w+)Data"/) { $e{$cur}{type} = $1; push @o, $cur unless $e{$cur}{seen}++ }
    $e{$cur}{$1} = $2 if $x =~ /^data "(DisplayName|Description|Icon)" "([^"]*)"/ } }

if (($mode // '') eq '--icons') {
  my %n; $n{ $e{$_}{Icon} // '' }++ for @o;
  print "| Internal id | Icon | Shared by |\n|---|---|---|\n";
  printf "| `%s` | %s | %s |\n", $_, $e{$_}{Icon} // '—', ($n{ $e{$_}{Icon} // '' } > 1 ? $n{ $e{$_}{Icon} // '' } : '') for @o;
  exit 0;
}
my %grp = (Spell => 'Spells and cards', Passive => 'Passives', Status => 'Statuses', Interrupt => 'Reactions');
for my $g (qw(Spell Passive Status Interrupt)) {
  my @r = grep { ($e{$_}{type} // '') eq $g && t($e{$_}{DisplayName}) ne '' } @o; next unless @r;
  print "\n## $grp{$g}\n\n| Internal id | Name | Description |\n|---|---|---|\n";
  for my $id (@r) { my $d = t($e{$id}{Description}); $d =~ s/\s+/ /g; printf "| `%s` | %s | %s |\n", $id, t($e{$id}{DisplayName}), $d }
}
