use strict; use warnings;
use File::Glob ':bsd_glob';   # plain glob() splits the pattern on the spaces in "Program Files (x86)"
# rename_taxonomy.pl <Data dir> [--dry] [--backup <dir>]
#   Arcana_Ability_ -> Arcana_Card_Ability_
#   Arcana_Card_    -> Arcana_Card_Spell_   (except when already followed by Ability_)
#   Arcana_Token_   -> Arcana_Created_
# Plan: Design/Rework/plans/2026-09-17-taxonomy-rename.md
# Text files only. The two clone .lsf templates go through Divine (see the plan, Task 2).
my $D = shift or die "usage: rename_taxonomy.pl <Data dir> [--dry] [--backup <dir>]\n";
my ($dry, $backup) = (0, undef);
while (@ARGV) {
  my $a = shift;
  if ($a eq '--dry') { $dry = 1 }
  elsif ($a eq '--backup') { $backup = shift or die "--backup needs a dir\n" }
  else { die "unknown option $a\n" }
}
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';

my @files;
push @files, map { "Public/$M/Stats/Generated/Data/$_" }
  qw(Spell_Shout.txt Spell_Target.txt Spell_Projectile.txt Spell_Zone.txt Spell_Teleportation.txt Passive.txt Status_BOOST.txt Interrupt.txt);
push @files, "Public/$M/Lists/SpellLists.lsx";
push @files, map { "Editor/Mods/$M/Stats/SpellData/$_" } qw(Shout.stats Target.stats Projectile.stats Zone.stats Teleportation.stats);
push @files, map { "Editor/Mods/$M/Stats/Stats/$_" } qw(Passive.stats Interrupt.stats);
push @files, "Editor/Mods/$M/Stats/StatusData/Status_BOOST.stats", "Editor/Mods/$M/Lists/SpellLists.tbl";
push @files, map { "Mods/$M/Scripts/thoth/helpers/$_" } qw(IsArcanaCantrip.khn IsDeceiverOneTargetSpell.khn);
push @files, map { "Mods/$M/Story/RawFiles/Goals/$_" }
  qw(ARCANA_Spell_FacelessCopy_EX.txt ARCANA_Spell_MimicWithdraw.txt ARCANA_Spell_Mimic_Last_Casted.txt ARCANA_Spell_Withdraw.txt);
push @files, "Mods/$M/Localization/English/english.xml";
push @files, map { "Mods/$M/ScriptExtender/Lua/$_" } qw(Server/Core/Const.lua Server/Cards/CardDB.lua);
push @files, map { my $p = $_; $p =~ s{^\Q$D\E/}{}; $p } sort(bsd_glob("$D/Mods/$M/ScriptExtender/Lua/Tests/*.lua"));

sub slurp { my $p = shift; open(my $in, '<:raw', $p) or die "$p: $!"; local $/; my $s = <$in>; close $in; $s }

sub apply {
  my ($rel, $s) = @_;
  my %n = (pre => 0, ability => 0, card => 0, token => 0);
  # english.xml still points the FinalSpark tooltip at the pre-Token name; send it through the Token pass
  if ($rel =~ /english\.xml$/) {
    $n{pre} = ($s =~ s/(?<![A-Za-z0-9])Arcana_Card_(FinalSpark_Recreate)/Arcana_Token_$1/g) || 0;
  }
  # Ability first (creates "Card_Ability_"), then Card must skip what was just created, then Token.
  # The lookbehind is the same guard as the IND_ rename (no hits inside longer identifiers).
  $n{ability} = ($s =~ s/(?<![A-Za-z0-9])Arcana_Ability_/Arcana_Card_Ability_/g) || 0;
  $n{card}    = ($s =~ s/(?<![A-Za-z0-9])Arcana_Card_(?!Ability_)/Arcana_Card_Spell_/g) || 0;
  $n{token}   = ($s =~ s/(?<![A-Za-z0-9])Arcana_Token_/Arcana_Created_/g) || 0;
  return ($s, \%n);
}

my (@changed, %tot);
for my $rel (@files) {
  my $p = "$D/$rel";
  -f $p or die "missing file: $rel\n";
  my $orig = slurp($p);
  my ($new, $n) = apply($rel, $orig);
  next if $new eq $orig;
  push @changed, [$rel, $new, $n];
  $tot{$_} += $n->{$_} for keys %$n;
}

for my $c (@changed) {
  my ($rel, undef, $n) = @$c;
  printf "%s  pre=%d ability=%d card=%d token=%d  %s\n", ($dry ? '[dry]' : 'write'), @$n{qw(pre ability card token)}, $rel;
}
printf "files changed: %d of %d   TOTAL ability=%d card=%d token=%d (pre=%d)\n",
  scalar(@changed), scalar(@files), map { $tot{$_} || 0 } qw(ability card token pre);
exit 0 if $dry;

if (defined $backup) {
  for my $c (@changed) {
    my $rel = $c->[0];
    my $dest = "$backup/$rel";
    (my $dir = $dest) =~ s{/[^/]+$}{};
    system('mkdir', '-p', $dir) == 0 or die "mkdir $dir failed\n";
    system('cp', '-p', "$D/$rel", $dest) == 0 or die "backup of $rel failed\n";
  }
  print "backup: " . scalar(@changed) . " files in $backup\n";
}
for my $c (@changed) {
  my ($rel, $new) = @$c;
  open(my $out, '>:raw', "$D/$rel") or die "$rel: $!";
  print $out $new; close $out;
}
print "done\n";
