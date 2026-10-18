#!/usr/bin/perl
# audit — the organisation checks of ARC-0027, run by /auditoria (00.01 Operating Rules).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/audit.pl      (from the repository root; exit 1 when anything is found)
#
# 1 dead citations: a file named in backticks by a rule file (CLAUDE.md, AGENTS.md, 00.01, _AGENT.md, agents, commands)
#   that exists nowhere in the repository — unless the same line says it is "not written".
# 2 owners: every _AGENT.md / _INDEX.md "Owner:" and every ticket "owner:" is one of the active roles (OR-26).
# 3 tickets: status in the template's vocabulary; WIP (in_progress + in_qa) <= 3 (OR-36); open WIP tickets in the sprint.
# 4 handoffs outside 90_ARCHIVE without status done / deferred (OR-27).
# 5 daily logs: a day with commits but no log in 10.02/daily_logs or the closed sprints (OR-37).
use strict; use warnings; use utf8; use File::Find;
binmode STDOUT, ':utf8';

# The active roles of 00.05 (OR-26). shortcut: a fixed list — update it when a dormant role is activated.
my %ROLE = map { $_ => 1 } ('Owner', 'Producer', 'Lead Class Designer', 'Spell Designer', 'Balance Designer',
  'Lore Writer', 'Mod Engineer', 'Icon Artist', 'Context Keeper', 'QA Lead');
my %STATUS = map { $_ => 1 } qw(backlog ready in_progress blocked in_review spec_ready in_qa done);

sub slurp { my $f = shift; open my $h, '<:encoding(UTF-8)', $f or return ''; local $/; (<$h> // '') =~ s/\r//gr }
sub role_ok { my $r = shift; $r =~ s/\s*\(.*//; $r =~ s/\s+$//; !grep { !$ROLE{$_} } split /\s*\+\s*/, $r }

my (@files, %base);
find({ no_chdir => 1, wanted => sub {
  return if m{^\./(_LEGACY|90_ARCHIVE|\.git)(/|$)} || m{/\.superpowers/};
  return unless -f;
  (my $b = $_) =~ s{.*/}{}; $base{$b} = 1; (my $n = $b) =~ s/\.\w+$//; $base{$n} = 1;
  push @files, $_ if m{/(_AGENT|_INDEX)\.md$};
} }, '.');
my @problems;

# 1 dead citations
my @rules = ('CLAUDE.md', 'AGENTS.md', '00_GOVERNANCE/00.01_Studio_Constitution/Operating_Rules.md',
             (grep { m{/_AGENT\.md$} } @files), glob('.claude/agents/*.md'), glob('.claude/commands/*.md'));
for my $f (@rules) {
  for my $line (split /\n/, slurp($f)) {
    next if $line =~ /not written|create it/i;
    while ($line =~ /`([^`\s]+\.(?:md|pl|sh|json|ps1|lua|yaml))`/g) {
      my $r = $1; next if $r =~ /[<*{#]|\.\.\./;
      (my $b = $r) =~ s{.*/}{};
      push @problems, "dead citation: $f -> $r" unless $base{$b};
    }
  }
}

# 2 owners
for my $f (@files) {
  my ($o) = slurp($f) =~ /^(?:- )?\*\*Owner:\*\*\s*([^\n]+)/m or next;
  push @problems, "owner not an active role: $f -> $o" unless role_ok($o);
}

# 3 tickets
my $sprint = (slurp('10_PRODUCTION/10.02_Active_Sprint/SPRINT_GOAL.md') =~ /^sprint:\s*(\S+)/m)[0] // '';
my @wip;
for my $f (glob('10_PRODUCTION/10.01_Product_Backlog/stories/*.md')) {
  my $t = slurp($f); my %h = $t =~ /^(id|status|owner|sprint):[ \t]*([^\n#]*?)\s*$/mg;
  my $id = $h{id} // $f;
  push @problems, "ticket $id: status '$h{status}' not in the template" unless $STATUS{ $h{status} // '' };
  push @problems, "ticket $id: owner '$h{owner}' not an active role" unless role_ok($h{owner} // '');
  if (($h{status} // '') =~ /^(in_progress|in_qa)$/) {
    push @wip, $id;
    push @problems, "ticket $id: in progress but not in sprint $sprint" if ($h{sprint} // '') ne $sprint;
  }
}
push @problems, "WIP " . scalar(@wip) . " > 3 (OR-36): @wip" if @wip > 3;

# 4 open handoffs
for my $f (grep { m{/HANDOFF_[^/]*\.md$} } map { s{^\./}{}r } do { my @h; find({ no_chdir => 1, wanted => sub {
    return if m{^\./(_LEGACY|90_ARCHIVE)/}; push @h, $_ if m{/HANDOFF_[^/]*\.md$} } }, '.'); @h }) {
  push @problems, "open handoff: $f" unless slurp($f) =~ /^status:\s*(done|deferred)/m;
}

# 5 daily logs
my %logged;   # a log named 2026-10-16_17_… covers both days
find(sub { $logged{$1} = 1 if /^(\d{4}-\d{2}-\d{2})/; $logged{"$1-$2"} = 1 if /^(\d{4}-\d{2})-\d{2}_(\d{2})_/ },
  grep { -d } '10_PRODUCTION/10.02_Active_Sprint/daily_logs', '90_ARCHIVE/91_Closed_Sprints');
my ($start) = slurp('10_PRODUCTION/10.02_Active_Sprint/SPRINT_GOAL.md') =~ /Dates:\s*(\d{4}-\d{2}-\d{2})/;   # current sprint only
my %days = $start ? map { $_ => 1 } grep { /\S/ } split /\n/, `git log --since=$start --format=%ad --date=short` : ();
for my $d (sort keys %days) { push @problems, "commits on $d but no daily log (OR-37)" unless $logged{$d} }

print "$_\n" for @problems;
print @problems ? scalar(@problems) . " finding(s)\n" : "OK: no finding\n";
exit(@problems ? 1 : 0);
