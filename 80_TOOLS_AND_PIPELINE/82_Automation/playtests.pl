#!/usr/bin/perl
# playtests — QA-#### playtest tickets from the test guides (ARC-0024, standardised in ARC-0027). Run from the repository root.
# Format of a guide: 60_QA_AND_TESTING/61_Test_Plan/GUIDE_FORMAT.md. Work flow: 00.01 Operating Rules §1, OR-4.
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl new <guide.json> <subclass|feature|bug-retest> [subclass]
#       Writes 10.01_Product_Backlog/playtests/QA-####_<Name>_<ARC>.md (next free QA id), status ready.
#       The subclass comes from the guide's folder (61.02_Test_Cases/<Subclass>/) unless given.
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl sync [results dir]
#       The guides are the source. For every QA ticket: refreshes its title from the guide, rebuilds its test sections
#       (one section per level) and writes each result — pass -> [x] … — pass, skip -> [x] … — skipped,
#       fail -> [ ] … — FAIL: <notes>, notes only -> [ ] … — note: <notes>, none -> [ ] (left).
#       [results dir] holds one JSON per Arcana Test Guides result (ArtifactData list `results` with out_dir), named
#       <ARC>_<test id>.json. A result whose key matches no test of any QA ticket's guide is reported as ORPHAN —
#       map it to the new test id before anything else (a guide changed under it).
#       Then rewrites 61_Test_Plan/TEST_GUIDES.json (one tab per subproject with a playable ticket: ready or in_qa)
#       and each guide's .md record (gen_test_guide_md.pl).
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl check
#       Every guide and every QA ticket against GUIDE_FORMAT.md; exit 1 when anything is off.
use strict; use warnings;
use JSON::PP;

my $P = '10_PRODUCTION/10.01_Product_Backlog/playtests';
my $T = '60_QA_AND_TESTING/61_Test_Plan';
my $TESTS = 'https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E';
sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s }
sub spew { my ($f, $s) = @_; open my $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h }
sub date { my @l = localtime; sprintf '%04d-%02d-%02d', $l[5] + 1900, $l[4] + 1, $l[3] }
sub guide { JSON::PP->new->decode(slurp("$T/$_[0]")) }   # bytes in, bytes out: the UTF-8 text passes through untouched
sub folder { $_[0] =~ m{61\.02_Test_Cases/([^/]+)/} ? $1 : undef }
# Tabs show the display names (31.01 §6, ARC-0021); folders keep the internal names (ADR-0002).
my %DISPLAY = (Unbound => 'Windborn', Deceiver => 'Veilwalker', Eternal => 'Palerider', Resonant => 'Heartsong');
my %SUBCLASS = map { $_ => 1 } qw(unbound deceiver starchild eternal resonant kingmaker lionheart class none);
my %PLAYABLE = (ready => 1, in_qa => 1);

# The test part of a QA ticket, from "## Before you start" to just before "## Gates". %$r = results by "<ARC>_<id>".
sub tests_md {
    my ($g, $r, $c) = @_;
    my $o = "## Before you start\n\n" . join('', map { "- $_\n" } @{ $g->{before} // [] });
    for my $s (@{ $g->{sessions} }) {
        $o .= "\n## $s->{name}\n\n**Setup:** $s->{setup}\n\n";
        for my $t (@{ $s->{tests} }) {
            my $k = "$g->{ticket}_$t->{id}"; $c->{seen}{$k} = 1;
            my $line = "$t->{id} · $t->{title}" . ($t->{rule} ? " ($t->{rule})" : '') . (($t->{edition} // '') eq 'PC' ? ' [PC]' : '');
            my $res = $r->{$k} // {}; my $st = $res->{status} // '';
            my $note = ($res->{notes} // '') =~ s/\s+/ /gr; $note =~ s/^ | $//g;
            $o .= $st eq 'pass' ? do { $c->{ok}++; "- [x] $line — pass\n" }
                : $st eq 'skip' ? do { $c->{ok}++; "- [x] $line — skipped\n" }
                : $st eq 'fail' ? do { $c->{fail}++; "- [ ] $line — FAIL" . ($note ne '' ? ": $note" : '') . "\n" }
                : do { $c->{left}++; "- [ ] $line" . ($note ne '' ? " — note: $note" : '') . "\n" };
        }
    }
    "$o\n";
}

sub check {
    my @bad;
    my %open_by_guide;
    for my $f (sort glob "$P/QA-*.md") {
        my $s = slurp($f); my %h = $s =~ /^(id|title|type|kind|subclass|build|guide|status|owner):[ \t]*(\S[^\n]*?)\s*$/mg;
        push @bad, "$f: owner '$h{owner}' — must be QA Lead" if ($h{owner} // '') ne 'QA Lead';
        push @bad, "$f: kind '$h{kind}'" unless ($h{kind} // '') =~ /^(subclass|feature|bug-retest)$/;
        push @bad, "$f: subclass '$h{subclass}' — lowercase id from the board" unless $SUBCLASS{ $h{subclass} // '' };
        push @bad, "$f: status '$h{status}' — backlog | ready | in_qa | done" unless ($h{status} // '') =~ /^(backlog|ready|in_qa|done)$/;
        push @bad, "$f: guide '$h{guide}' missing" unless $h{guide} && -f "$T/$h{guide}";
        push @{ $open_by_guide{ $h{guide} // '' } }, $h{id} if ($h{status} // '') ne 'done';
    }
    push @bad, "guide $_ has several open QA tickets: @{ $open_by_guide{$_} }" for grep { @{ $open_by_guide{$_} } > 1 } sort keys %open_by_guide;
    for my $f (sort glob "$T/61.02_Test_Cases/*/GUIDE_*.json") {
        my $g = eval { JSON::PP->new->decode(slurp($f)) } or do { push @bad, "$f: not JSON"; next };   # bytes, like the patterns
        for (qw(ticket title before sessions)) { push @bad, "$f: no '$_'" unless defined $g->{$_} }
        my %known = map { $_ => 1 } qw(ticket title before sessions); push @bad, "$f: unknown key '$_'" for grep { !$known{$_} } sort keys %$g;
        push @bad, "$f: title '$g->{title}' — 'The <Name> — <what> (…)'" unless ($g->{title} // '') =~ /^The \S+ — .+/;
        my %ids; my $closed = $f =~ /_probes\.json$/;
        for my $s (@{ $g->{sessions} // [] }) {
            my $lvl = $s->{level};
            push @bad, "$f: session '$s->{name}' — 'Level N — …' or 'Any level — full run'"
                unless $closed || (defined $lvl ? $s->{name} =~ /^Level $lvl — \S/ : $s->{name} eq 'Any level — full run');
            for my $t (@{ $s->{tests} // [] }) {
                push @bad, "$f: duplicate id $t->{id}" if $ids{ $t->{id} }++;
                push @bad, "$f: id $t->{id} — L<level>.<n> or A.<n>" unless $closed || $t->{id} =~ (defined $lvl ? qr/^L\Q$lvl\E\.\d+$/ : qr/^A\.\d+$/);
                for my $k (qw(title rule steps expected fails)) { push @bad, "$f: $t->{id} has no '$k'" unless defined $t->{$k} && $t->{$k} ne '' }
            }
        }
    }
    print "$_\n" for @bad;
    print @bad ? scalar(@bad) . " problem(s)\n" : "OK: guides and QA tickets follow GUIDE_FORMAT.md\n";
    exit(@bad ? 1 : 0);
}

my $cmd = shift // '';
if ($cmd eq 'new') {
    my ($path, $kind, $sub) = @ARGV;
    die "usage: new <guide.json> <subclass|feature|bug-retest> [subclass]\n" unless $path && $kind && $kind =~ /^(subclass|feature|bug-retest)$/;
    (my $rel = $path) =~ s{\\}{/}g; $rel =~ s{^.*?61_Test_Plan/}{};
    my $g = guide($rel); my $folder = folder($rel);
    $sub = lc($sub // $folder // 'none');
    my ($last) = sort { $b <=> $a } map { /QA-(\d+)/ ? $1 : () } glob "$P/QA-*.md";
    my $id = sprintf 'QA-%04d', ($last // 0) + 1;
    my $title = "Playtest — $g->{title}";
    my %c;
    my $o = "---\nid: $id\ntitle: $title\ntype: playtest\nkind: $kind\nsubclass: $sub\nbuild: $g->{ticket}\nguide: $rel\n"
          . "status: ready\nowner: QA Lead\nimplementation: owner\nblocked_by: []\ncreated: " . date() . "\n---\n\n# $id · $title\n\n"
          . "**Goal:** play every test of `$rel`, level by level, and mark it on Arcana Test Guides ($TESTS).\n"
          . "**Intent:** $g->{ticket} is proven in the game, or each failure becomes a fix (a bug) or a decision (design feedback, OR-1).\n\n"
          . "Steps, expected results and plan B are on the test page and in the record `" . ($rel =~ s/\.json$/.md/r)
          . "`. This list is rebuilt from the guide, with the results, at every test guides sync (`/sync-test-guides`).\n\n"
          . tests_md($g, {}, \%c)
          . "## Gates\n\n- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)\n\n"
          . "## Log\n\n- " . date() . " — created from `$rel` ($c{left} tests).\n";
    (my $name = $folder // $sub) =~ s/\W+/_/g;
    my $f = "$P/${id}_${name}_$g->{ticket}.md";
    mkdir $P; spew($f, $o);
    print "$f: $c{left} tests\n";
}
elsif ($cmd eq 'sync') {
    my $dir = shift; my %r;
    if ($dir) {
        $dir =~ s{\\}{/}g;   # glob needs forward slashes on Windows
        for my $f (glob "$dir/*.json") {
            my $j = JSON::PP->new->decode(slurp($f)); $j = $j->{data} if ref $j->{data} eq 'HASH';
            (my $k = $f) =~ s{.*/|\.json$}{}g;
            $r{$k} = $j;
        }
    }
    my (%tabs, @order, %guides, %seen);
    for my $f (sort glob "$P/QA-*.md") {
        my $s = slurp($f);
        my ($rel) = $s =~ /^guide:\s*(\S+)/m or next;
        my ($id) = $s =~ /^id:\s*(\S+)/m;
        my ($kind) = $s =~ /^kind:\s*(\S+)/m; my ($status) = $s =~ /^status:\s*(\S+)/m;
        my $g = guide($rel); my %c = (ok => 0, fail => 0, left => 0, seen => \%seen);
        my $new = tests_md($g, \%r, \%c);
        $s =~ s{^## Before you start\n.*?(?=^## Gates\n)}{$new}ms or die "$f: no '## Before you start' … '## Gates' block\n";
        my $title = "Playtest — $g->{title}";
        $s =~ s/^title:[^\n]*/title: $title/m; $s =~ s/^# \Q$id\E · [^\n]*/# $id · $title/m;
        spew($f, $s);
        $guides{$rel} = 1;
        print "$f: $c{ok} done, $c{fail} failed, $c{left} left\n";
        next unless $PLAYABLE{ $status // '' };
        my $tab = ($kind // '') eq 'feature' ? 'Features' : ($kind // '') eq 'bug-retest' ? 'Bug retests' : do { my $d = folder($rel) // 'Other'; $DISPLAY{$d} // $d };
        push @order, $tab unless $tabs{$tab};
        push @{ $tabs{$tab} }, $rel;
    }
    my %migrated = map { ($_->{migrated_from} // '') => 1 } values %r;   # an old key copied to a new id is kept, not reported
    for my $k (sort keys %r) {
        next if $seen{$k} || $migrated{$k};
        printf "ORPHAN result %s (%s%s): no test has this id — map it to the new id\n", $k, $r{$k}{status} // 'note', ($r{$k}{notes} ? ', with notes' : '');
    }
    my $m = { note => 'Generated by playtests.pl sync from the QA-#### tickets that can be played now (ready, in_qa) - do not edit. One tab per subproject.',
              tabs => [ map { +{ name => $_, guides => $tabs{$_} } } @order ] };
    spew("$T/TEST_GUIDES.json", JSON::PP->new->canonical->pretty->encode($m));
    system($^X, '80_TOOLS_AND_PIPELINE/82_Automation/gen_test_guide_md.pl', map { "$T/$_" } sort keys %guides) == 0 or die "gen_test_guide_md failed\n";
    print "$T/TEST_GUIDES.json: ", scalar(@order), " tabs\n";
}
elsif ($cmd eq 'check') { check() }
else { die "usage: playtests.pl new <guide.json> <kind> [subclass] | sync [results dir] | check\n" }
