#!/usr/bin/perl
# update_board — generate BACKLOG.md (10.01) and SPRINT_BOARD.md (10.02) from the ticket headers.
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/update_board.pl      (from the repository root)
#
# Tickets: 10_PRODUCTION/10.01_Product_Backlog/stories/ARC-*.md with a YAML header (_TEMPLATE_TICKET.md).
# Current sprint: first line "sprint: S##" of 10_PRODUCTION/10.02_Active_Sprint/SPRINT_GOAL.md.
use strict; use warnings; use utf8;
binmode STDOUT, ':utf8';

my $B = '10_PRODUCTION/10.01_Product_Backlog';
my $A = '10_PRODUCTION/10.02_Active_Sprint';
my @t;
for my $f (sort glob "$B/stories/ARC-*.md") {
  open my $fh, '<:encoding(UTF-8)', $f or next; my %h; my $in = 0;
  while (<$fh>) { s/[\r\n]+$//;
    if (/^---\s*$/) { last if $in; $in = 1; next }
    next unless $in;
    $h{$1} = $2 if /^(\w+):\s*(.*?)\s*(?:#.*)?$/;
  }
  ($h{file} = $f) =~ s{.*/}{};
  push @t, \%h if $h{id};
}
my %pr = (must => 0, should => 1, could => 2, wont => 3);
my @order = sort { ($pr{$a->{priority} // 'could'} // 2) <=> ($pr{$b->{priority} // 'could'} // 2)
                   || (($b->{value} // 0) / (($b->{effort} || 1))) <=> (($a->{value} // 0) / (($a->{effort} || 1)))
                   || $a->{id} cmp $b->{id} } grep { ($_->{status} // '') ne 'done' } @t;

my @l = localtime; my $date = sprintf '%04d-%02d-%02d', $l[5]+1900, $l[4]+1, $l[3];
my $o = "# Backlog\n\n*Generated $date by `82_Automation/update_board.pl` — do not edit; change the tickets.*\n\n"
      . "| Ticket | Title | Type | Owner | Priority | Value/Effort | Status | Impl. | Sprint |\n|---|---|---|---|---|---|---|---|---|\n";
$o .= sprintf "| [%s](stories/%s) | %s | %s | %s | %s | %s/%s | %s | %s | %s |\n", $_->{id}, $_->{file},
  $_->{title} // '', $_->{type} // '', $_->{owner} // '', $_->{priority} // '', $_->{value} // '', $_->{effort} // '',
  $_->{status} // '', $_->{implementation} // '', $_->{sprint} // '' for @order;
$o .= "\n_No open tickets._\n" unless @order;
my $done = grep { ($_->{status} // '') eq 'done' } @t;
$o .= "\nDone tickets: $done.\n";
open my $fb, '>:encoding(UTF-8)', "$B/BACKLOG.md" or die $!; print $fb $o; close $fb;

my $sprint = '';
if (open my $g, '<:encoding(UTF-8)', "$A/SPRINT_GOAL.md") { my $first = <$g> // ''; $sprint = $1 if $first =~ /sprint:\s*(S\d+)/ }
my @cols = (['To Do', qw(backlog ready)], ['In Progress', qw(in_progress blocked)], ['Spec Ready', 'spec_ready'],
            ['In QA', 'in_qa'], ['Done', 'done']);
my $s = "# Sprint board" . ($sprint ? " — $sprint" : '') . "\n\n*Generated $date by `82_Automation/update_board.pl` — do not edit.*\n\n";
if (!$sprint) { $s .= "_No active sprint (`SPRINT_GOAL.md` has no `sprint: S##` line)._\n" }
else {
  my @in = grep { ($_->{sprint} // '') eq $sprint } @t;
  for my $c (@cols) { my ($name, @st) = @$c; my %w = map { $_ => 1 } @st;
    my @x = grep { $w{ $_->{status} // 'backlog' } } @in;
    $s .= "## $name (" . scalar(@x) . ")\n\n" . (join '', map { "- **$_->{id}** $_->{title}" . (($_->{status} // '') eq 'blocked' ? " — ⛔ blocked by $_->{blocked_by}" : '') . "\n" } @x) . "\n";
  }
}
open my $fs, '>:encoding(UTF-8)', "$A/SPRINT_BOARD.md" or die $!; print $fs $s; close $fs;
printf "tickets %d (open %d, done %d), sprint %s\n", scalar @t, scalar @order, $done, $sprint || 'none';
