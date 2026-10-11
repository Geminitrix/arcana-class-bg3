#!/usr/bin/perl
# The Veil, stage 6: English strings left orphan by the rework.
# Candidates = handles cited by the mod's text files BEFORE the rework (Backup\deceiver_veil_20261006) that no text file
# of the mod cites NOW (stats, lsx, tbl, goals, Lua, khn). Binary .lsf files (tags, templates) are converted with Divine
# and searched too. Only candidates are touched: an old orphan that predates the rework stays.
#   perl 90_loca_orphans.pl [--apply]
use strict; use warnings;
use File::Find; use File::Temp qw(tempdir);
my $G = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $OLD = "$G/Backup/deceiver_veil_20261006";
my $LOCA = "$G/Mods/$M/Localization/English/english.xml";
my $DIVINE = 'C:/Softwares/ExportTool/Packed/Tools/Divine.exe';
my $apply = grep { $_ eq '--apply' } @ARGV;
my $H = qr/\bh[0-9a-f]{8}g[0-9a-f]{4}g[0-9a-f]{4}g[0-9a-f]{4}g[0-9a-f]{12}\b/;
sub slurp { open my $h, '<:raw', $_[0] or return ''; local $/; my $s = <$h>; close $h; $s }
sub handles_in { my %h; for my $dir (@_) { next unless -d $dir; find({ no_chdir => 1, wanted => sub {
    return unless -f && /\.(txt|stats|lsx|tbl|lua|khn|xml)$/i; return if m{/Localization/};
    $h{$_} = 1 for slurp($_) =~ /($H)/g } }, $dir) } \%h }
my $before = handles_in($OLD);
my $now = handles_in("$G/Public/$M", "$G/Editor/Mods/$M", "$G/Mods/$M");
# .lsf: convert and search
my $tmp = tempdir(CLEANUP => 1); my $n = 0;
find({ no_chdir => 1, wanted => sub { return unless -f && /\.lsf$/i; my $out = "$tmp/" . $n++ . '.lsx';
    system($DIVINE, '-g', 'bg3', '-a', 'convert-resource', '-s', $_, '-d', $out) == 0 or return;
    $now->{$_} = 1 for slurp($out) =~ /($H)/g } }, "$G/Public/$M");
my $loca = slurp($LOCA);
my @gone = grep { !$now->{$_} && $loca =~ /contentuid="\Q$_\E"/ } sort keys %$before;
my $o = $loca;
for my $h (@gone) {
    my ($t) = $loca =~ /<content contentuid="\Q$h\E"[^>]*>(.*?)<\/content>/; print "- $h  ", substr($t // '', 0, 90), "\n";
    $loca =~ s/[ \t]*<content contentuid="\Q$h\E"[^>]*>.*?<\/content>\r?\n//;
}
printf "%d orphan strings (of %d handles cited before the rework)\n", scalar(@gone), scalar(keys %$before);
if ($apply && $loca ne $o) { open my $fh, '>:raw', $LOCA or die; print $fh $loca; close $fh; print "written.\n" } elsif (!$apply) { print "(dry run)\n" }
