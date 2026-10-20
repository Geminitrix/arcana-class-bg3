#!/usr/bin/perl
# check_osiris — the house standard of the mod's Osiris goals (57.05/OSIRIS.md §13).
#
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/check_osiris.pl                    # the 51 copy
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/check_osiris.pl --dir DIR          # any folder of goals
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/check_osiris.pl --compare OLD NEW  # code lines that differ
#
# Errors (E) break the standard; warnings (W) need a human read. --compare ignores comments, blank lines and
# line endings, so a tidy-up that changed no rule prints nothing but "same code".
# Exit 1 on errors (or, with --compare, on any code difference).
use strict; use warnings;

my $DEFAULT = '50_ENGINEERING/51_Mod_Source/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Story/RawFiles/Goals';

# Portuguese function words; two in one comment line mark it as not English
my $PT = qr/\b(?:nao|quando|uma|que|com|sem|pelo|pela|dos|das|nas|aos|tambem|desde|cada|sobre|entre|ainda|mais|esta|isso|este|essa|seu|sua|ele|ela|onde|porque|entao|aqui|agora|todo|toda|tudo|fica|ficam|dano|cura|alvo|tabela|limpeza|registro|objetivo|janela)\b/i;
# history in a comment: tickets, build tasks and stages, fix rounds
my $HISTORY = qr/\bARC-\d{4}\b|\bTask \d|\bstages? \d|\bfix round\b|\bGERADO\b/i;
my $TIMER_CALL = qr/\b(RealtimeObjectTimer|ObjectTimer|Timer)(Launch|Cancel)\(/;

sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s }
sub goals_in { my $d = shift; opendir my $h, $d or die "$d: $!"; my @f = sort grep { /\.txt$/ } readdir $h; closedir $h; @f }
sub code_lines {   # comments, blank lines and line endings stripped; trailing spaces trimmed
    map { s/\s+$//r } grep { /\S/ && !m{^\s*//} } split /\r?\n/, shift;
}

# ---------------------------------------------------------------- --compare
if (@ARGV && $ARGV[0] eq '--compare') {
    my (undef, $old, $new) = @ARGV;
    die "usage: check_osiris.pl --compare OLD NEW\n" unless $old && $new;
    my %all = map { $_ => 1 } goals_in($old), goals_in($new);
    my $diffs = 0;
    for my $f (sort keys %all) {
        unless (-e "$old/$f") { print "$f: only in NEW\n"; $diffs++; next }
        unless (-e "$new/$f") { print "$f: only in OLD\n"; $diffs++; next }
        my @a = code_lines(slurp("$old/$f"));
        my @b = code_lines(slurp("$new/$f"));
        my @d = diff(\@a, \@b);
        if (@d) { $diffs++; print "$f:\n", map { "  $_\n" } @d } else { print "$f: same code\n" }
    }
    print $diffs ? "\n$diffs goal(s) with code changes\n" : "\nsame code in every goal\n";
    exit($diffs ? 1 : 0);
}

# LCS diff: "- old", "+ new" lines in order
sub diff {
    my ($a, $b) = @_;
    my ($n, $m) = (scalar @$a, scalar @$b);
    my @L; $L[$n][$_] = 0 for 0 .. $m;
    for (my $i = $n - 1; $i >= 0; $i--) {
        $L[$i][$m] = 0;
        for (my $j = $m - 1; $j >= 0; $j--) {
            $L[$i][$j] = $a->[$i] eq $b->[$j] ? $L[$i + 1][$j + 1] + 1
                       : ($L[$i + 1][$j] >= $L[$i][$j + 1] ? $L[$i + 1][$j] : $L[$i][$j + 1]);
        }
    }
    my ($i, $j, @out) = (0, 0);
    while ($i < $n && $j < $m) {
        if ($a->[$i] eq $b->[$j]) { $i++; $j++ }
        elsif ($L[$i + 1][$j] >= $L[$i][$j + 1]) { push @out, "- $a->[$i++]" }
        else { push @out, "+ $b->[$j++]" }
    }
    push @out, "- $a->[$i++]" while $i < $n;
    push @out, "+ $b->[$j++]" while $j < $m;
    @out;
}

# ---------------------------------------------------------------- the standard
my $dir = $DEFAULT;
if (@ARGV && $ARGV[0] eq '--dir') { $dir = $ARGV[1] or die "usage: check_osiris.pl --dir DIR\n" }
my @files = goals_in($dir);
die "no goals in $dir\n" unless @files;

my (%written, %pinned, %code, $errors, $warnings);
my %report;
sub err  { my ($f, $m) = @_; push @{ $report{$f} }, "E $m"; $errors++ }
sub warn_ { my ($f, $m) = @_; push @{ $report{$f} }, "W $m"; $warnings++ }

for my $f (@files) {
    my $raw = slurp("$dir/$f");
    err($f, 'file name: not ARCANA_<Area>_<Feature>.txt') unless $f =~ /^ARCANA_[A-Za-z0-9_]+\.txt$/;
    my $lf = () = $raw =~ /(?<!\r)\n/g;
    err($f, "line endings: $lf line(s) end in LF only (CRLF everywhere)") if $lf;
    err($f, 'non-ASCII character') if $raw =~ /[^\x00-\x7F]/;
    err($f, 'tab character') if $raw =~ /\t/;

    my @l = split /\r?\n/, $raw, -1;
    pop @l if @l && $l[-1] eq '';
    $code{$f} = join "\n", code_lines($raw);

    # skeleton
    err($f, 'skeleton: the first lines must be Version 1 / SubGoalCombiner SGC_AND / INITSECTION')
        unless ($l[0] // '') eq 'Version 1' && ($l[1] // '') eq 'SubGoalCombiner SGC_AND' && ($l[2] // '') eq 'INITSECTION';
    err($f, 'skeleton: the file must end EXITSECTION / (blank) / ENDEXITSECTION')
        unless @l >= 3 && $l[-3] eq 'EXITSECTION' && $l[-2] eq '' && $l[-1] eq 'ENDEXITSECTION';
    my ($kb) = grep { $l[$_] eq 'KBSECTION' } 0 .. $#l;
    unless (defined $kb) { err($f, 'skeleton: no KBSECTION'); next }
    my $exit = $#l - 2;

    # INITSECTION: type pins (a fact and its NOT on the next line) and Init calls only
    for (my $i = 3; $i < $kb; $i++) {
        my $s = $l[$i];
        next if $s eq '' || $s =~ m{^//};
        if ($s =~ /^PROC_ARCANA_\w+\(\);$/) { next }
        if ($s =~ /^(DB_\w+)\((.*)\);$/ && ($l[$i + 1] // '') eq "NOT $s") {
            $pinned{$1} = $f; $written{$1}{$f} = 1;
            err($f, "INITSECTION: $1 has no ARCANA_ prefix") unless $1 =~ /^DB_ARCANA_/;
            $i++; next;
        }
        err($f, "INITSECTION line " . ($i + 1) . ": only type pins and PROC_ARCANA_<Goal>_Init(); (a table goes in an Init PROC)");
    }

    # header block: the first lines of KBSECTION are // lines, then a blank line
    my $h = $kb + 1;
    my @header;
    push @header, $l[$h++] while $h < $exit && $l[$h] =~ m{^//} && $l[$h] !~ m{^//(REGION|END_REGION)};
    err($f, 'header: KBSECTION must open with a // block that says what the goal does') unless @header;
    err($f, 'header: a blank line must follow the header block') if @header && ($l[$h] // '') ne '';
    my $headertext = join "\n", @header;

    # regions, rules and comments
    my ($open, $prevEnd) = (undef, undef);
    my (@rules, $rule, $inThen);
    my %definedProc;
    for (my $i = $kb + 1; $i < $exit; $i++) {
        my $s = $l[$i]; my $n = $i + 1;
        if ($s =~ m{^//REGION(.*)$}) {
            my $t = $1;
            err($f, "line $n: //REGION needs a title after one space") unless $t =~ /^ \S/;
            err($f, "line $n: region inside region '$open'") if defined $open;
            err($f, "line $n: one blank line must separate regions")
                if defined $prevEnd && !($i - $prevEnd == 2 && $l[$i - 1] eq '');
            $open = $t; $open =~ s/^ //;
            check_comment($f, $n, $open);
            undef $rule; next;
        }
        if ($s =~ m{^//END_REGION}) {
            err($f, "line $n: write //END_REGION with nothing after it") unless $s eq '//END_REGION';
            err($f, "line $n: //END_REGION with no open region") unless defined $open;
            undef $open; $prevEnd = $i; undef $rule; next;
        }
        if ($s =~ m{^\s*//(.*)$}) {
            check_comment($f, $n, $1) unless $i - $kb - 1 < @header;
            err($f, "line $n: comment between regions (put it inside a region or in the header)")
                if !defined $open && $i - $kb - 1 >= @header;
            next;
        }
        if ($s eq '') { undef $rule; next }
        if ($s =~ m{//(.*)$}) { check_comment($f, $n, $1) }
        if ($s =~ /^(IF|PROC|QRY)$/) {
            err($f, "line $n: rule outside a region") unless defined $open;
            $rule = { kind => $1, line => $n, actions => [] }; push @rules, $rule; $inThen = 0; next;
        }
        unless ($rule) { err($f, "line $n: code outside a rule"); next }
        if (!defined $rule->{head}) {
            $rule->{head} = $s;
            if ($rule->{kind} ne 'IF') {
                my ($name) = $s =~ /^(\w+)\(/;
                err($f, "line $n: $rule->{kind} name $name has no $rule->{kind}_ARCANA_ prefix")
                    unless $name && $name =~ /^$rule->{kind}_ARCANA_/;
                $definedProc{$name}++ if $name;
                $rule->{name} = $name;
            }
            next;
        }
        if ($s eq 'THEN') { $inThen = 1; next }
        next unless $inThen;
        push @{ $rule->{actions} }, [$n, $s];
        if ($s =~ /^(?:NOT )?(DB_\w+)\(/) {
            $written{$1}{$f} = 1;
            err($f, "line $n: $1 has no ARCANA_ prefix") unless $1 =~ /^DB_ARCANA_/ || $1 eq 'DB_NOOP';
        }
    }
    err($f, "region '$open' is never closed") if defined $open;

    # timers: prefix, matching family, cancel before launch
    my (%launchFamily, %cancels);
    for my $r (@rules) { for my $a (@{ $r->{actions} }) {
        my ($n, $s) = @$a;
        next unless $s =~ $TIMER_CALL;
        my ($fam, $op) = ($1, $2);
        my ($name) = $s =~ /"([^"]+)"/;
        next unless defined $name;
        err($f, "line $n: timer \"$name\" has no ARCANA_ prefix") unless $name =~ /^ARCANA_/;
        push @{ $launchFamily{$name} }, $fam if $op eq 'Launch';
        $cancels{ $r->{name} // '' }{"$fam:$name"} = 1 if $op eq 'Cancel' && $r->{kind} eq 'PROC';
    } }
    for my $r (@rules) {
        my %done;
        for my $a (@{ $r->{actions} }) {
            my ($n, $s) = @$a;
            if ($s =~ /^(PROC_ARCANA_\w+)\(/ && $cancels{$1}) { $done{$_} = 1 for keys %{ $cancels{$1} } }
            next unless $s =~ $TIMER_CALL;
            my ($fam, $op) = ($1, $2);
            my ($name) = $s =~ /"([^"]+)"/;
            next unless defined $name;
            if ($op eq 'Cancel') {
                $done{"$fam:$name"} = 1;
                my @fams = @{ $launchFamily{$name} || [] };
                err($f, "line $n: \"$name\" is launched by ${\ join '/', map { \"${_}Launch\" } @fams } but cancelled by ${fam}Cancel")
                    if @fams && !grep { $_ eq $fam } @fams;
            } elsif (!$done{"$fam:$name"}) {
                err($f, "line $n: ${fam}Launch \"$name\" without ${fam}Cancel of the same timer before it in the rule");
            }
        }
    }

    # event strings of TeleportToPosition
    for my $r (@rules) { for my $a (@{ $r->{actions} }) {
        my ($n, $s) = @$a;
        err($f, "line $n: TeleportToPosition event \"$1\" has no ARCANA_ prefix")
            if $s =~ /^TeleportToPosition\([^"]*"([^"]+)"/ && $1 !~ /^ARCANA_/;
    } }

    # the header names every DB the goal writes
    for my $db (sort grep { $written{$_}{$f} && $_ ne 'DB_NOOP' } keys %written) {
        err($f, "header: $db is written here but not named in the header") unless $headertext =~ /\b\Q$db\E\b/;
    }
}

# a DB that two goals touch is pinned somewhere
for my $db (sort keys %written) {
    next if $db eq 'DB_NOOP' || $pinned{$db};
    my @owners = sort keys %{ $written{$db} };
    my @others = grep { my $g = $_; !$written{$db}{$g} && $code{$g} =~ /\b\Q$db\E\(/ } @files;
    next unless @others || @owners > 1;
    warn_($owners[0], "$db is shared (" . join(', ', grep { $_ ne $owners[0] } @owners, @others)
        . ") but has no type pin in any INITSECTION");
}

sub check_comment {
    my ($f, $n, $c) = @_;
    err($f, "line $n: history in a comment ($&): say what the code does, not when or in which ticket") if $c =~ $HISTORY;
    my $pt = () = $c =~ /$PT/g;
    err($f, "line $n: comment not in English") if $pt >= 2;
}

for my $f (@files) {
    if ($report{$f}) { print "$f\n", map { "  $_\n" } @{ $report{$f} } } else { print "$f: OK\n" }
}
printf "\n%d goals: %d error(s), %d warning(s)%s\n", scalar @files, $errors // 0, $warnings // 0, ($errors ? '' : ' -- OK');
exit($errors ? 1 : 0);
