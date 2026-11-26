#!/usr/bin/perl
# ARC-0036 — the Veilwalker's dead English strings: handles whose text names an old term and that NO file of the mod
# cites (text and binary: Stats, .stats, LSX/LSF, .tbl, Lua, Khonsu, Osiris, every loca LSTag).
#   perl dead_loca.pl                 list them
#   perl dead_loca.pl --remove <out>  remove their <content> lines from the 15 loca files in Data (needs [fechado]);
#                                     the removed lines go to <out>/removed_loca.xml
use strict; use warnings; use File::Find;
my $D   = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $MOD = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $LOC = "$D/Mods/$MOD/Localization";
my $TERMS = qr/Sigil|Mirror|Clone|Hollow Image|Deceiver|Mimic|Distortion|Ethereal/i;

sub slurp { open my $f, '<:raw', $_[0] or die "$_[0]: $!"; local $/; <$f> }

my %txt; my $en = slurp("$LOC/English/english.xml");
$txt{$1} = $2 while $en =~ /contentuid="([^"]+)"[^>]*>(.*?)<\/content>/g;
my @cand = grep { $txt{$_} =~ $TERMS } keys %txt;

my %cited;   # every handle cited anywhere outside the <content contentuid=…> of the loca files
my @files; find(sub { push @files, $File::Find::name if -f }, "$D/Public/$MOD", "$D/Mods/$MOD", "$D/Editor/Mods/$MOD");
for my $p (@files) {
  next if $p =~ /\.(?:md|bak)$/i;
  my $s = slurp($p);
  $s =~ s/contentuid="h[0-9a-g]+"//g if $p =~ m{/Localization/};
  $cited{$1} = 1 while $s =~ /(h[0-9a-f]{8}g[0-9a-f]{4}g[0-9a-f]{4}g[0-9a-f]{4}g[0-9a-f]{12})/g;
}
my @dead = sort { $txt{$a} cmp $txt{$b} } grep { !$cited{$_} } @cand;
printf "%s  %s\n", $_, substr($txt{$_} =~ s/&lt;.*?&gt;//gr, 0, 90) for @dead;
print scalar(@dead), " dead of ", scalar(@cand), " candidates\n";

if (@ARGV && $ARGV[0] eq '--remove') {
  my $out = $ARGV[1] or die "--remove <out dir>\n"; my $removed = '';
  my %dead = map { $_ => 1 } @dead;
  opendir my $dh, $LOC or die; for my $lang (grep { !/^\./ && -d "$LOC/$_" } readdir $dh) {
    opendir my $lh, "$LOC/$lang" or die; for my $x (grep { /\.xml$/ } readdir $lh) {
      my $p = "$LOC/$lang/$x"; my $s = slurp($p); my $n = 0;
      $s =~ s{^([ \t]*<content contentuid="(h[^"]+)"[^\n]*\n)}{ $dead{$2} ? do { $n++; $removed .= "<!-- $lang -->$1"; '' } : $1 }gme;
      open my $o, '>:raw', $p or die; print $o $s; close $o; print "$lang: $n removed\n";
    }
  }
  open my $o, '>:raw', "$out/removed_loca.xml" or die; print $o $removed; close $o;
}
