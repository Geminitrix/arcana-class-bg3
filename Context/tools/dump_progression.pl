# Prints every Arcana progression level from the game files: boosts, passives and granted spells,
# with English names and texts resolved from the loca. Read-only. Used to check Context/*.md.
use strict; use warnings;
my $D = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $P = "$D/Public/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7";
my $M = "$D/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7";

sub slurp { my $f=shift; open(my $h,'<:encoding(UTF-8)',$f) or die "$f $!"; local $/; my $c=<$h>; $c=~s/\r//g; $c }

# loca
my %loc; { my $x = slurp("$M/Localization/English/english.xml");
  while($x=~/contentuid="([^"]+)"[^>]*>(.*?)<\/content>/gs){ my($k,$v)=($1,$2); $v=~s/&lt;/</g;$v=~s/&gt;/>/g;$v=~s/&amp;/&/g;$v=~s/&quot;/"/g; $v=~s/<[^>]+>//g; $loc{$k}=$v } }
sub L { my $h=shift//''; $h=~s/;\d+$//; return $loc{$h} // ($h? "[$h]":'') }

# stats entries
my %st;
for my $f (glob("\"$P/Stats/Generated/Data/*.txt\"")) {
  my $c = slurp($f); my $cur;
  for (split /\n/, $c) {
    if (/^new entry "([^"]+)"/) { $cur=$1; $st{$cur}{_file}=$f; $st{$cur}{_file}=~s/.*\///; next }
    next unless $cur;
    if (/^type "([^"]+)"/) { $st{$cur}{_type}=$1 }
    elsif (/^using "([^"]+)"/) { $st{$cur}{_using}=$1 }
    elsif (/^data "([^"]+)" "(.*)"$/) { $st{$cur}{$1}=$2 }
  }
}
sub F { my($n,$k,$d)=@_; $d//=0; return undef if $d>8 || !$st{$n}; return $st{$n}{$k} if defined $st{$n}{$k}; return $st{$n}{_using}? F($st{$n}{_using},$k,$d+1):undef }

# spell lists
my %sl; { my $x=slurp("$P/Lists/SpellLists.lsx");
  while($x=~/<node id="SpellList">(.*?)<\/node>/gs){ my $b=$1; my($n)=$b=~/id="Name"[^>]*value="([^"]*)"/; my($s)=$b=~/id="Spells"[^>]*value="([^"]*)"/; my($u)=$b=~/id="UUID"[^>]*value="([^"]*)"/; $sl{$u}={name=>$n//'',spells=>[split /;/,($s//'')]} } }
my %pl; { my $x=slurp("$P/Lists/PassiveLists.lsx");
  while($x=~/<node id="PassiveList">(.*?)<\/node>/gs){ my $b=$1; my($n)=$b=~/id="Name"[^>]*value="([^"]*)"/; my($s)=$b=~/id="Passives"[^>]*value="([^"]*)"/; my($u)=$b=~/id="UUID"[^>]*value="([^"]*)"/; $pl{$u}={name=>$n//'',p=>[split /,|;/,($s//'')]} } }

sub spell { my $s=shift; my $dn=L(F($s,'DisplayName')); my $lvl=F($s,'Level')//'?'; my $cost=F($s,'UseCosts')//''; my $cd=F($s,'Cooldown')//''; my $sch=F($s,'SpellSchool')//'';
  my $desc=L(F($s,'Description')); my $dp=F($s,'DescriptionParams')//'';
  my $flags=F($s,'SpellFlags')//''; my $conc = $flags=~/IsConcentration/?' Conc':'';
  return "  - SPELL $s | \"$dn\" | L$lvl $sch | $cost | cd:$cd$conc\n      $desc  {$dp}\n" }
sub passive { my $p=shift; my $dn=L(F($p,'DisplayName')); my $desc=L(F($p,'Description')); my $dp=F($p,'DescriptionParams')//''; my $pr=F($p,'Properties')//'';
  return "  - PASSIVE $p | \"$dn\" [$pr]\n      $desc  {$dp}\n" }

my $x = slurp("$P/Progressions/Progressions.lsx");
my @rows;
while ($x =~ /<node id="Progression">(.*?)(?=<node id="Progression">|<\/region>)/gs) {
  my $b=$1; my %r;
  for my $k (qw(Name Level Boosts PassivesAdded PassivesRemoved Selectors TableUUID AllowImprovement)) { ($r{$k}) = $b=~/id="$k"[^>]*value="([^"]*)"/ }
  push @rows, \%r;
}
my %order=(Arcana=>0,Unbound=>1,Deceiver=>2,Starchild=>3,Eternal=>4);
for my $r (sort { ($order{$a->{Name}}//9) <=> ($order{$b->{Name}}//9) || $a->{Name} cmp $b->{Name} || $a->{Level} <=> $b->{Level} } @rows) {
  print "\n=== $r->{Name} L$r->{Level}", ($r->{AllowImprovement}?' [ASI]':''), "\n";
  print "  Boosts: $r->{Boosts}\n" if $r->{Boosts};
  print "  PassivesRemoved: $r->{PassivesRemoved}\n" if $r->{PassivesRemoved};
  for my $p (split /;/, $r->{PassivesAdded}//'') { print passive($p) }
  for my $sel (split /;/, $r->{Selectors}//'') {
    if ($sel=~/^(AddSpells|SelectSpells)\(([0-9a-f-]+)(.*)\)/) { my $l=$sl{$2}; print "  $1 [$l->{name}] $3\n"; print spell($_) for @{$l->{spells}} }
    elsif ($sel=~/^(SelectPassives|AddPassives)\(([0-9a-f-]+)(.*)\)/) { my $l=$pl{$2}; print "  $1 [$l->{name}] $3\n"; print passive($_) for @{$l->{p}} }
    else { print "  SEL $sel\n" }
  }
}
