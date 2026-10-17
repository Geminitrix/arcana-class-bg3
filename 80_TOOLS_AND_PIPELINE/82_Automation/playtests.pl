#!/usr/bin/perl
# playtests — QA-#### playtest tickets from the test guides (ARC-0024). Run from the repository root.
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl new <guide.json> <subclass|feature|bug-retest> [subclass]
#       Writes 10.01_Product_Backlog/playtests/QA-####_<Name>_<ARC>.md (next free QA id), status ready.
#       The subclass comes from the guide's folder (61.02_Test_Cases/<Subclass>/) unless given.
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl sync [results dir]
#       The guides are the source. For every QA ticket: rebuilds its test sections from its guide (one section per
#       level) and writes each result — pass -> [x] … — pass, skip -> [x] … — skipped, fail -> [ ] … — FAIL: <notes>,
#       none -> [ ] (left). [results dir] holds one JSON per Arcana Test Guides result (ArtifactData list `results`
#       with out_dir), named <ARC>_<test id>.json; without it every test shows as left.
#       Then rewrites 61_Test_Plan/TEST_GUIDES.json (one tab per open QA ticket's subproject; Done tickets drop out)
#       and each guide's .md record (gen_test_guide_md.pl).
use strict; use warnings;
use JSON::PP;

my $P = '10_PRODUCTION/10.01_Product_Backlog/playtests';
my $T = '60_QA_AND_TESTING/61_Test_Plan';
my $TESTS = 'https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E';
sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s }
sub spew { my ($f, $s) = @_; open my $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h }
sub date { my @l = localtime; sprintf '%04d-%02d-%02d', $l[5] + 1900, $l[4] + 1, $l[3] }
sub guide { JSON::PP->new->decode(slurp("$T/$_[0]")) }
sub folder { $_[0] =~ m{61\.02_Test_Cases/([^/]+)/} ? $1 : undef }
# Tabs show the display names (31.01 §6, ARC-0021); folders keep the internal names (ADR-0002).
my %DISPLAY = (Unbound => 'Windborn', Deceiver => 'Veilwalker', Eternal => 'Palerider', Resonant => 'Heartsong');

# The test part of a QA ticket, from "## Before you start" to just before "## Gates". %$r = results by "<ARC>_<id>".
sub tests_md {
    my ($g, $r, $c) = @_;
    my $o = "## Before you start\n\n" . join('', map { "- $_\n" } @{ $g->{before} // [] });
    for my $s (@{ $g->{sessions} }) {
        $o .= "\n## $s->{name}\n\n**Setup:** $s->{setup}\n\n";
        for my $t (@{ $s->{tests} }) {
            my $line = "$t->{id} · $t->{title}" . ($t->{rule} ? " ($t->{rule})" : '') . (($t->{edition} // '') eq 'PC' ? ' [PC]' : '');
            my $res = $r->{"$g->{ticket}_$t->{id}"} // {}; my $st = $res->{status} // '';
            my $note = ($res->{notes} // '') =~ s/\s+/ /gr; $note =~ s/^ | $//g;
            $o .= $st eq 'pass' ? do { $c->{ok}++; "- [x] $line — pass\n" }
                : $st eq 'skip' ? do { $c->{ok}++; "- [x] $line — skipped\n" }
                : $st eq 'fail' ? do { $c->{fail}++; "- [ ] $line — FAIL" . ($note ne '' ? ": $note" : '') . "\n" }
                : do { $c->{left}++; "- [ ] $line\n" };
        }
    }
    "$o\n";
}

my $cmd = shift // '';
if ($cmd eq 'new') {
    my ($path, $kind, $sub) = @ARGV;
    die "usage: new <guide.json> <subclass|feature|bug-retest> [subclass]\n" unless $path && $kind && $kind =~ /^(subclass|feature|bug-retest)$/;
    (my $rel = $path) =~ s{\\}{/}g; $rel =~ s{^.*?61_Test_Plan/}{};
    my $g = guide($rel); my $folder = folder($rel);
    $sub //= lc($folder // 'none');
    my ($last) = sort { $b <=> $a } map { /QA-(\d+)/ ? $1 : () } glob "$P/QA-*.md";
    my $id = sprintf 'QA-%04d', ($last // 0) + 1;
    my $title = "Playtest — $g->{title}";
    my %c;
    my $o = "---\nid: $id\ntitle: $title\ntype: playtest\nkind: $kind\nsubclass: $sub\nbuild: $g->{ticket}\nguide: $rel\n"
          . "status: ready\nowner: QA\nimplementation: owner\nblocked_by: []\ncreated: " . date() . "\n---\n\n# $id · $title\n\n"
          . "**Goal:** play every test of `$rel`, level by level, and mark it on Arcana Test Guides ($TESTS).\n"
          . "**Intent:** $g->{ticket} is proven in the game, or each failure becomes an ARC bug and a QA bug-retest.\n\n"
          . "Steps, expected results and plan B are on the test page and in the record `" . ($rel =~ s/\.json$/.md/r)
          . "`. This list is rebuilt from the guide, with the results, at every kanban sync (`/update-board`).\n\n"
          . tests_md($g, {}, \%c)
          . "## Gates\n\n- [ ] DoD (`00.03`) — every test pass or skipped; each fail has an ARC bug and a QA bug-retest\n\n"
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
    my (%tabs, @order, %guides);
    for my $f (sort glob "$P/QA-*.md") {
        my $s = slurp($f);
        my ($rel) = $s =~ /^guide:\s*(\S+)/m or next;
        my ($kind) = $s =~ /^kind:\s*(\S+)/m; my ($status) = $s =~ /^status:\s*(\S+)/m;
        my $g = guide($rel); my %c = (ok => 0, fail => 0, left => 0);
        my $new = tests_md($g, \%r, \%c);
        $s =~ s{^## Before you start\n.*?(?=^## Gates\n)}{$new}ms or die "$f: no '## Before you start' … '## Gates' block\n";
        spew($f, $s);
        $guides{$rel} = 1;
        print "$f: $c{ok} done, $c{fail} failed, $c{left} left\n";
        next if ($status // '') eq 'done';
        my $tab = ($kind // '') eq 'feature' ? 'Features' : ($kind // '') eq 'bug-retest' ? 'Bug retests' : do { my $d = folder($rel) // 'Other'; $DISPLAY{$d} // $d };
        push @order, $tab unless $tabs{$tab};
        push @{ $tabs{$tab} }, $rel;
    }
    my $m = { note => 'Generated by playtests.pl sync from the open QA-#### tickets (ARC-0024) - do not edit. One tab per subproject; a guide leaves when its playtest is Done.',
              tabs => [ map { +{ name => $_, guides => $tabs{$_} } } @order ] };
    spew("$T/TEST_GUIDES.json", JSON::PP->new->canonical->pretty->encode($m));
    system($^X, '80_TOOLS_AND_PIPELINE/82_Automation/gen_test_guide_md.pl', map { "$T/$_" } sort keys %guides) == 0 or die "gen_test_guide_md failed\n";
    print "$T/TEST_GUIDES.json: ", scalar(@order), " tabs\n";
}
else { die "usage: playtests.pl new <guide.json> <kind> [subclass] | sync [results dir]\n" }
