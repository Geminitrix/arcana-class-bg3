#!/usr/bin/perl
# playtests — QA-#### playtest tickets from the test guides (ARC-0024). Run from the repository root.
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl new <guide.json> <subclass|feature|bug-retest> [subclass]
#       Writes 10.01_Product_Backlog/playtests/QA-####_<Name>_<ARC>.md (next free QA id), status ready.
#       The subclass comes from the guide's folder (61.02_Test_Cases/<Subclass>/) unless given.
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/playtests.pl sync <results dir>
#       <results dir> holds one JSON per Arcana Test Guides result (ArtifactData list `results` with out_dir),
#       named <ARC>_<test id>.json. Rewrites the test lines of every QA ticket: pass -> [x] … — pass,
#       skip -> [x] … — skipped, fail -> [ ] … — FAIL: <notes>, no result -> [ ] (pending).
use strict; use warnings;
use JSON::PP;

my $P = '10_PRODUCTION/10.01_Product_Backlog/playtests';
my $T = '60_QA_AND_TESTING/61_Test_Plan';
my $TESTS = 'https://claude.ai/artifact/3us5sESX9EbPDksY6H7W1E';
sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s }
sub spew { my ($f, $s) = @_; open my $h, '>:raw', $f or die "$f: $!"; print $h $s; close $h }
sub date { my @l = localtime; sprintf '%04d-%02d-%02d', $l[5] + 1900, $l[4] + 1, $l[3] }

my $cmd = shift // '';
if ($cmd eq 'new') {
    my ($guide, $kind, $sub) = @ARGV;
    die "usage: new <guide.json> <subclass|feature|bug-retest> [subclass]\n" unless $guide && $kind && $kind =~ /^(subclass|feature|bug-retest)$/;
    my $g = JSON::PP->new->decode(slurp($guide));
    my ($folder) = $guide =~ m{61\.02_Test_Cases/([^/]+)/};
    $sub //= lc($folder // 'none');
    (my $rel = $guide) =~ s{^.*?61_Test_Plan/}{};
    my ($last) = sort { $b <=> $a } map { /QA-(\d+)/ ? $1 : () } glob "$P/QA-*.md";
    my $id = sprintf 'QA-%04d', ($last // 0) + 1;
    my $title = "Playtest — $g->{title}";
    my $o = "---\nid: $id\ntitle: $title\ntype: playtest\nkind: $kind\nsubclass: $sub\nbuild: $g->{ticket}\nguide: $rel\n"
          . "status: ready\nowner: QA\nimplementation: owner\nblocked_by: []\ncreated: " . date() . "\n---\n\n# $id · $title\n\n"
          . "**Goal:** play every test of `$rel` and mark it on Arcana Test Guides ($TESTS, tab " . ($folder // $sub) . ").\n"
          . "**Intent:** $g->{ticket} is proven in the game, or each failure becomes an ARC bug and a QA bug-retest.\n\n"
          . "Steps, expected results and plan B are on the test page and in the record `"
          . ($rel =~ s/\.json$/.md/r) . "`. Results reach this ticket at the kanban sync.\n\n## Before you start\n\n"
          . join('', map { "- $_\n" } @{ $g->{before} // [] });
    my $n = 0;
    for my $s (@{ $g->{sessions} }) {
        $o .= "\n## $s->{name}\n\n**Setup:** $s->{setup}\n\n";
        $o .= "- [ ] $_->{id} · $_->{title}" . ($_->{rule} ? " ($_->{rule})" : '') . "\n" for @{ $s->{tests} };
        $n += @{ $s->{tests} };
    }
    $o .= "\n## Gates\n\n- [ ] DoD (`00.03`) — every test pass or skipped; each fail has an ARC bug and a QA bug-retest\n\n"
        . "## Log\n\n- " . date() . " — created from `$rel` ($n tests).\n";
    (my $name = $folder // $sub) =~ s/\W+/_/g;
    my $f = "$P/${id}_${name}_$g->{ticket}.md";
    mkdir $P; spew($f, $o);
    print "$f: $n tests\n";
}
elsif ($cmd eq 'sync') {
    my $dir = shift or die "usage: sync <results dir>\n";
    $dir =~ s{\\}{/}g;   # glob needs forward slashes on Windows
    my %r;
    for my $f (glob "$dir/*.json") {
        my $j = JSON::PP->new->decode(slurp($f)); $j = $j->{data} if ref $j->{data} eq 'HASH';
        (my $k = $f) =~ s{.*/|\.json$}{}g;
        $r{$k} = $j;
    }
    for my $f (glob "$P/QA-*.md") {
        my $s = slurp($f);
        my ($build) = $s =~ /^build:\s*(\S+)/m or next;
        my ($p, $x, $l) = (0, 0, 0);
        $s =~ s{^- \[[ x]\] (\S+) · (.*?)(?: — (?:pass|skipped|FAIL\b.*))?$}{
            my ($id, $t) = ($1, $2); my $res = $r{"${build}_$id"} // {}; my $st = $res->{status} // '';
            my $note = ($res->{notes} // '') =~ s/\s+/ /gr;
            $st eq 'pass' ? do { $p++; "- [x] $id · $t — pass" }
          : $st eq 'skip' ? do { $p++; "- [x] $id · $t — skipped" }
          : $st eq 'fail' ? do { $x++; "- [ ] $id · $t — FAIL" . ($note ne '' ? ": $note" : '') }
          : do { $l++; "- [ ] $id · $t" }
        }gme;
        spew($f, $s);
        print "$f: $p done, $x failed, $l left\n";
    }
}
else { die "usage: playtests.pl new <guide.json> <kind> [subclass] | sync <results dir>\n" }
