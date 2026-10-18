#!/usr/bin/perl
# playtests — the QA_ARC playtest documents (OR-4, 61_Test_Plan/QA_ARC_FORMAT.md). Run from the repository root.
#
# One file per build ticket: 60_QA_AND_TESTING/61_Test_Plan/61.02_Test_Cases/<Subclass>/QA_ARC-####.md — every test,
# level by level, with its result. It is also the card on the board's Playtests tab. The JSON the Arcana Test Guides
# page loads is an export of it (test_guides/data/…, never edited by hand).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl new <ARC-####> <Subclass> "<The Name — what (levels 1–12)>"
#       Writes an empty draft QA_ARC-####.md in 61.02_Test_Cases/<Subclass>/.
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl sync [results dir]
#       [results dir] = ArtifactData list `results` of Arcana Test Guides saved with out_dir (<ARC>_<test id>.json).
#       Writes every result into its test's "- **Result:**" line, exports the playable documents (status ready or in_qa)
#       to test_guides/data/<Subclass>/QA_ARC-####.json and rewrites 61_Test_Plan/TEST_GUIDES.json (one tab per
#       subclass, display names). A result that matches no test is reported as ORPHAN (unless another result carries
#       `migrated_from` with its key): copy it to the new id before anything else.
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl check
#       Every QA_ARC against the format; exit 1 when anything is off.
use strict; use warnings;
use JSON::PP;
use File::Path qw(make_path);

my $T = '60_QA_AND_TESTING/61_Test_Plan';
my $C = "$T/61.02_Test_Cases";
my $TESTS = 'https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E';
my %DISPLAY = (Unbound => 'Windborn', Deceiver => 'Veilwalker', Eternal => 'Palerider', Resonant => 'Heartsong');
my %STATUS = map { $_ => 1 } qw(draft ready in_qa done);
my %PLAYABLE = (ready => 1, in_qa => 1);
my @FIELDS = (['rule', 'Rule'], ['steps', 'Steps'], ['expected', 'Expected'], ['fails', 'Fails if'], ['planb', 'Plan B'],
              ['kind', 'Kind'], ['edition', 'Edition']);
my %LABEL = map { $_->[1] => $_->[0] } @FIELDS;

sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s =~ s/\r\n/\n/g; $s }
sub spew { my ($f, $s) = @_; open my $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h }
sub date { my @l = localtime; sprintf '%04d-%02d-%02d', $l[5] + 1900, $l[4] + 1, $l[3] }
sub docs { sort glob "$C/*/QA_ARC-*.md" }
sub folder { $_[0] =~ m{61\.02_Test_Cases/([^/]+)/} ? $1 : undef }

# A QA_ARC document -> { head => {…}, before => [...], sessions => [{id, level, name, setup, closed, tests => [{id, title, …, result}]}] }
# Parsing stops at "## Appendix", "## Gates" or "## Log".
sub parse {
    my $s = shift;
    my ($fm) = $s =~ /\A---\n(.*?)\n---\n/s; my %h = ($fm // '') =~ /^(\w+):[ \t]*(\S[^\n]*?)\s*$/mg;
    my (%d, $sess, $test, $in_before); $d{head} = \%h; $d{before} = []; $d{sessions} = [];
    for my $l (split /\n/, $s) {
        if ($l =~ /^## (Appendix|Gates|Log)\b/) { last }
        if ($l =~ /^## Before you start\s*$/) { $in_before = 1; next }
        if ($l =~ /^## (.+?)\s*$/) {
            my $name = $1; $in_before = 0; $test = undef;
            my $lvl = $name =~ /^Level (\d+) — / ? $1 : undef;
            my $id = defined $lvl ? "L$lvl" : $name =~ /^Probes/ ? 'PR' : $name =~ /^Any level/ ? 'ANY' : 'X';
            $sess = { id => $id, (defined $lvl ? (level => 0 + $lvl) : ()), name => $name, setup => '',
                      closed => ($name =~ /\((closed|never applied)[^)]*\)\s*$/ ? 1 : 0), tests => [] };
            push @{ $d{sessions} }, $sess; next;
        }
        if ($in_before) { push @{ $d{before} }, $1 if $l =~ /^- (.+)$/; next }
        next unless $sess;
        if ($l =~ /^\*\*Setup:\*\*\s*(.*)$/) { $sess->{setup} = $1; next }
        if ($l =~ /^### (\S+) · (.+?)\s*$/) { $test = { id => $1, title => $2 }; push @{ $sess->{tests} }, $test; next }
        if ($test && $l =~ /^- \*\*(.+?):\*\*\s?(.*)$/) {
            my ($k, $v) = ($1, $2);
            if ($k eq 'Result') { $test->{result} = $v } elsif ($LABEL{$k}) { $test->{ $LABEL{$k} } = $v }
        }
    }
    \%d;
}

# The result line written for a test: pass / skipped / FAIL / note / — (left)
sub result_line {
    my $r = shift // {}; my $st = $r->{status} // '';
    my $note = ($r->{notes} // '') =~ s/\s+/ /gr; $note =~ s/^ | $//g;
    my $w = $st eq 'pass' ? 'pass' : $st eq 'skip' ? 'skipped' : $st eq 'fail' ? 'FAIL' : $note ne '' ? 'note' : '—';
    $w . ($note ne '' ? " — $note" : '');
}

sub check {
    my @bad;
    for my $f (docs()) {
        my $s = slurp($f); my $d = parse($s); my %h = %{ $d->{head} };
        my ($n) = $f =~ m{/(QA_ARC-\d{4})\.md$};
        push @bad, "$f: id '$h{id}' should be $n" if ($h{id} // '') ne $n;
        push @bad, "$f: build '$h{build}' should be " . ($n =~ s/^QA_//r) if ($h{build} // '') ne ($n =~ s/^QA_//r);
        push @bad, "$f: owner must be QA Lead" if ($h{owner} // '') ne 'QA Lead';
        push @bad, "$f: status '$h{status}' — draft | ready | in_qa | done" unless $STATUS{ $h{status} // '' };
        push @bad, "$f: subclass '$h{subclass}' — lowercase" if ($h{subclass} // '') ne lc($h{subclass} // '') || !$h{subclass};
        push @bad, "$f: title '$h{title}' — 'Playtest — The <Name> — <what> (…)'" unless ($h{title} // '') =~ /^Playtest — The \S+ — /;
        next unless $PLAYABLE{ $h{status} // '' };   # drafts and closed records may still hold free text
        push @bad, "$f: no tests" unless grep { @{ $_->{tests} } } @{ $d->{sessions} };
        my %ids;
        for my $x (@{ $d->{sessions} }) {
            push @bad, "$f: section '$x->{name}' — 'Level N — …', 'Any level — full run' or 'Probes — … (closed)'" if $x->{id} eq 'X';
            for my $t (@{ $x->{tests} }) {
                push @bad, "$f: duplicate id $t->{id}" if $ids{ $t->{id} }++;
                push @bad, "$f: id $t->{id} — L<level>.<n>, A.<n> or P<n> (probes)"
                    unless $t->{id} =~ ($x->{id} =~ /^L(\d+)$/ ? qr/^L$1\.\d+$/ : $x->{id} eq 'ANY' ? qr/^A\.\d+$/ : qr/^P\d+$/);
                for my $k (qw(rule steps expected fails)) { push @bad, "$f: $t->{id} has no '$k'" unless defined $t->{$k} && $t->{$k} ne '' }
                push @bad, "$f: $t->{id} has no Result line" unless defined $t->{result};
            }
        }
    }
    print "$_\n" for @bad;
    print @bad ? scalar(@bad) . " problem(s)\n" : "OK: every QA_ARC follows QA_ARC_FORMAT.md\n";
    exit(@bad ? 1 : 0);
}

my $cmd = shift // '';
if ($cmd eq 'new') {
    my ($arc, $sub, $title) = @ARGV;
    die "usage: new <ARC-####> <Subclass> \"<The Name — what (levels 1–12)>\"\n" unless $arc && $arc =~ /^ARC-\d{4}$/ && $sub && $title;
    my $f = "$C/$sub/QA_$arc.md"; die "$f exists\n" if -e $f;
    make_path("$C/$sub");
    spew($f, "---\nid: QA_$arc\ntitle: Playtest — $title\ntype: playtest\nsubclass: " . lc($sub) . "\nbuild: $arc\nstatus: draft\n"
        . "owner: QA Lead\ncreated: " . date() . "\n---\n\n# QA_$arc · $title\n\n"
        . "**Goal:** play every test, level by level, and mark it on Arcana Test Guides ($TESTS); results come back here at\n"
        . "`/sync-test-guides`. **Intent:** $arc is proven in the game, or each failure becomes a fix (bug) or a decision (OR-1).\n\n"
        . "## Before you start\n\n- \n\n## Level 1 — \n\n**Setup:** \n\n### L1.1 · \n\n- **Rule:** \n- **Steps:** \n- **Expected:** \n"
        . "- **Fails if:** \n- **Result:** —\n\n## Any level — full run\n\n**Setup:** \n\n## Gates\n\n"
        . "- [ ] DoD (`00.03`) — every test pass or skipped; each fail fixed or decided (OR-1)\n\n## Log\n\n- " . date() . " — created.\n");
    print "$f\n";
}
elsif ($cmd eq 'sync') {
    my $dir = shift; my %r;
    if ($dir) {
        $dir =~ s{\\}{/}g;
        for my $f (glob "$dir/*.json") {
            my $j = JSON::PP->new->decode(slurp($f)); $j = $j->{data} if ref $j->{data} eq 'HASH';
            (my $k = $f) =~ s{.*/|\.json$}{}g; $r{$k} = $j;
        }
    }
    my (%seen, %tabs, @order);
    for my $f (docs()) {
        my $s = slurp($f); my $d = parse($s); my %h = %{ $d->{head} }; my $build = $h{build} // '';
        my %c = (ok => 0, fail => 0, left => 0);
        # rewrite the Result lines in place, test by test
        my $cur;
        $s = join "\n", map {
            if (/^## (Appendix|Gates|Log)\b/) { $cur = '#stop' }
            if (($cur // '') ne '#stop' && /^### (\S+) · /) { $cur = $1 }
            if (($cur // '') ne '' && $cur ne '#stop' && /^- \*\*Result:\*\*/) {
                my $k = "${build}_$cur"; $seen{$k} = 1;
                if ($r{$k}) { $_ = "- **Result:** " . result_line($r{$k}) }
                my ($w) = /^- \*\*Result:\*\*\s*(\S+)/; $w //= '—';
                $w =~ /^(pass|skipped)$/ ? $c{ok}++ : $w eq 'FAIL' ? $c{fail}++ : $c{left}++;
            }
            $_ } split /\n/, $s, -1;
        spew($f, $s);
        print "$f: $c{ok} done, $c{fail} failed, $c{left} left\n";
        next unless $PLAYABLE{ $h{status} // '' };
        my $sub = folder($f) // 'Other';
        my $json = { ticket => $build, title => ($h{title} // '') =~ s/^Playtest — //r, before => $d->{before},
                     sessions => [ map { my $x = $_; +{ id => $x->{id}, (exists $x->{level} ? (level => $x->{level}) : ()), name => $x->{name},
                        setup => $x->{setup}, tests => [ map { my $t = $_; +{ map { defined $t->{$_} && $t->{$_} ne '' ? ($_ => $t->{$_}) : () }
                        qw(id title rule steps expected fails planb kind edition) } } @{ $x->{tests} } ] } }
                        grep { !$_->{closed} && @{ $_->{tests} } } @{ $d->{sessions} } ] };
        my $rel = "test_guides/data/$sub/QA_$build.json";
        make_path("$T/test_guides/data/$sub");
        spew("$T/$rel", JSON::PP->new->canonical->pretty->encode($json));
        my $tab = $DISPLAY{$sub} // $sub;
        push @order, $tab unless $tabs{$tab};
        push @{ $tabs{$tab} }, $rel;
    }
    my %migrated = map { ($_->{migrated_from} // '') => 1 } values %r;
    for my $k (sort keys %r) {
        next if $seen{$k} || $migrated{$k};
        printf "ORPHAN result %s (%s%s): no test has this id — copy it to the new id\n", $k, $r{$k}{status} // 'note', ($r{$k}{notes} ? ', with notes' : '');
    }
    spew("$T/TEST_GUIDES.json", JSON::PP->new->canonical->pretty->encode({
        note => 'Generated by playtests.pl sync from the QA_ARC documents that can be played now (ready, in_qa) - do not edit. One tab per subclass.',
        tabs => [ map { +{ name => $_, guides => $tabs{$_} } } @order ] }));
    print "$T/TEST_GUIDES.json: ", scalar(@order), " tabs\n";
}
elsif ($cmd eq 'check') { check() }
else { die "usage: playtests.pl new <ARC-####> <Subclass> \"<title>\" | sync [results dir] | check\n" }
