#!/usr/bin/perl
use strict; use warnings;
# Merges per-level / per-stage Toolkit guides into ONE TOOLKIT_ARC-####.md (Owner, 2026-10-17: one file per ARC).
# Nothing is dropped: every part keeps its intro and sections (headings demoted one level under "# Level N — …");
# a "Rules for whoever writes this file" section identical in every part is written once at the top.
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/merge_toolkit_parts.pl <out.md> <ARC-####> "<title>" <part.md>...  (bytes in, bytes out)
my ($out, $ticket, $title, @parts) = @ARGV;
sub slurp { local $/; open my $h, '<:raw', $_[0] or die "$_[0]: $!"; my $s = <$h>; $s =~ s/\r\n/\n/g; $s }
my (@p, %derived, %rules, @order_rules);
for my $f (@parts) {
  my $s = slurp($f);
  my ($fm, $body) = $s =~ /\A---\n(.*?)\n---\n(.*)\z/s or die "$f: no frontmatter\n";
  my %h = $fm =~ /^(\w+):\s*(.*?)\s*$/mg;
  if (($h{derived_from} // '') =~ /^\[(.*)\]$/) { $derived{$_} = 1 for grep { length } map { s/^\s+|\s+$//gr } split /,/, $1 }
  my ($h1, $rest) = $body =~ /\A\s*# ([^\n]*)\n(.*)\z/s or die "$f: no H1\n";
  my ($rules) = $rest =~ /(## Rules for whoever writes this file\n.*?)(?=\n## 0 )/s;
  $rules{$rules // ''}++; push @order_rules, $rules // '';
  push @p, { file => $f, h1 => $h1, rest => $rest, rules => $rules, fm => \%h };
}
my $shared = (keys %rules == 1 && $order_rules[0] ne '') ? $order_rules[0] : undef;
my $o = "---\nid: TOOLKIT_$ticket\nticket: $ticket\nspec: SPEC_$ticket\nstatus: " . ($p[-1]{fm}{status} // 'draft')
      . "\nderived_from: [" . join(', ', sort keys %derived) . "]\nmerged_from: [" . join(', ', map { s/\.md$//r } @parts)
      . "]\nauthor: Mod Engineer\n---\n\n# TOOLKIT_$ticket · $title\n\n"
      . "> **One file for the whole build** (Owner, 2026-10-17): a part per level, in the order you type them. Type a level,\n"
      . "> then play that level's tests in `QA_$ticket`. Merged on 2026-10-17 from " . scalar(@p) . " files (`merged_from`); nothing removed.\n\n"
      . "## Contents\n\n" . join('', map { my $a = $_->{h1} =~ s/^TOOLKIT_\S+ · //r; "- $a\n" } @p) . "\n";
$o .= "$shared\n" if $shared;
for my $x (@p) {
  my $rest = $x->{rest};
  $rest =~ s/\Q$x->{rules}\E\n?// if $shared && $x->{rules};
  $rest =~ s/^(#{2,5}) /#$1 /mg;                 # demote: the level is the "#" heading
  (my $h = $x->{h1}) =~ s/^TOOLKIT_\S+ · //;
  $o .= "---\n\n# $h\n$rest\n";
}
$o =~ s/\n{3,}/\n\n/g;
open my $w, '>:raw', $out or die; print $w $o; close $w;
my $lines = () = $o =~ /\n/g;
my $in = 0; $in += () = slurp($_) =~ /\n/g for @parts;
print "$out: $lines lines from ", scalar(@p), " parts ($in lines in)", ($shared ? ', rules section written once' : ', rules kept per part'), "\n";
