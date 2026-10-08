#!/usr/bin/perl
# Gera aspect/81_upcast.patch: troca o LevelMapValue de dano e cura pelo sistema de upcast, como o jogo base
# (2026-10-01, decisao do usuario: +1 dado por nivel de espaco acima do nivel da carta). O Arcana tem espaco
# de um nivel so por vez, entao a carta sempre sai na variante do espaco atual.
#
# Le os valores ATUAIS do Public/*.txt e so troca o token: o que mais estiver no campo fica igual. Quem
# depende de status ou de projetil de explosao ganha uma versao por nivel (status com o mesmo StackId e
# StackPriority = nivel, no molde do STORM_FISTS_5 que o usuario fez no Unbound).
#
#   perl gen_upcast_damage.pl > ../aspect/81_upcast.patch
# RODA UMA VEZ: depois de aplicado nao sobra LevelMapValue para trocar (ele morre avisando). Dai em diante
# o 81_upcast.patch e a fonte da verdade -- mude os valores nele, como nos outros patches.
# Fica com LevelMap, de proposito: truques (D4Cantrip), copias do Mirror Image, a marca do Sigil e o
# bonus de proficiencia do clone -- nada disso tem espaco de magia para fazer upcast. O Unbound e do
# usuario e nao entra aqui.
use strict; use warnings;
my $D = ($ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data')
      . '/Public/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Stats/Generated/Data';
my (%val, %file);
opendir my $dh, $D or die "$D: $!";
for my $f (grep { /\.txt$/ } readdir $dh) { open my $h, '<', "$D/$f" or die; my $cur;
  while (<$h>) { s/\r?\n//; if (/^new entry "(.*)"/) { $cur = $1; $file{$cur} = $f =~ s/\.txt$//r }
    elsif (defined $cur && /^data "(\w+)" "(.*)"$/) { $val{$cur}{$1} = $2 } } }

# troca LevelMapValue(serie) / Cause.LevelMapValue(serie) por NdM; "/2" ganha parenteses, como o jogo base
sub dice { my ($s, $series, $d) = @_; my $n = 0;
  $n += $s =~ s/\(\s*(?:Cause\.)?LevelMapValue\(\Q$series\E\)\s*\)\/2/($d)\/2/g;
  $n += $s =~ s/(?:Cause\.)?LevelMapValue\(\Q$series\E\)\/2/($d)\/2/g;
  $n += $s =~ s/(?:Cause\.)?LevelMapValue\(\Q$series\E\)/$d/g; ($s, $n) }
sub fields { my ($e, $series) = @_; die "$e nao existe\n" unless $val{$e};
  my @f = grep { $val{$e}{$_} =~ /LevelMapValue\(\Q$series\E\)/ } sort keys %{ $val{$e} };
  die "$e: nenhum campo com $series\n" unless @f; @f }

my @out; my %seen;
sub say { push @out, @_ }
sub sets { my ($e, $series, $d, $rename) = @_; my @f = fields($_[4] // $e, $series);
  for my $k (@f) { my ($v) = dice($val{$_[4] // $e}{$k}, $series, $d); $v = $rename->($v, $k) if $rename; say "\@set $e $k $v" }
  if ($rename) { for my $k (grep { my $k = $_; !grep { $_ eq $k } @f } qw(SpellProperties SpellSuccess TooltipStatusApply OriginSpellProperties)) {
      next unless defined $val{$_[4] // $e}{$k}; my $v = $rename->($val{$_[4] // $e}{$k}, $k); say "\@set $e $k $v" if $v ne $val{$_[4] // $e}{$k} } } }

# carta: [entrada, serie, dado, nivel da carta, dados no nivel da carta]
sub card { my ($e, $series, $die, $L, $n0, %o) = @_;
  say '', "# $e: ${n0}d$die no nivel $L, +1d$die por nivel" . ($o{note} ? " ($o{note})" : '');
  for my $S ($L .. 6) { my $name = $S == $L ? $e : "${e}_$S"; die "$name nao existe\n" unless $val{$name};
    my $d = ($n0 + $S - $L) . "d$die";
    sets($name, $series, $d, $o{rename} ? sub { $o{rename}->($_[0], $S, $_[1]) } : undef, $e) } }

# status ou projetil por nivel: o base recebe os dados do nivel da carta, os outros nascem com "using"
sub perlevel { my ($base, $series, $die, $L, $n0, $file, $section, %o) = @_;
  my @f = fields($base, $series);
  say '', "# $base: ${n0}d$die no nivel $L; uma versao por nivel acima" . ($o{prio} ? " (StackPriority = nivel)" : '');
  for my $k (@f) { my ($v) = dice($val{$base}{$k}, $series, "${n0}d$die"); say "\@set $base $k $v" }
  say "\@set $base StackPriority $L" if $o{prio};
  say "\@file $file", "\@section $section";
  for my $S ($L + 1 .. 6) { my $d = ($n0 + $S - $L) . "d$die";
    say '', "new entry \"${base}_$S\"", "type \"$o{type}\"", ($o{type} eq 'StatusData' ? 'data "StatusType" "BOOST"' : 'data "SpellType" "Projectile"'), "using \"$base\"";
    for my $k (@f) { my ($v) = dice($val{$base}{$k}, $series, $d); say "data \"$k\" \"$v\"" }
    say "data \"StackPriority\" \"$S\"" if $o{prio} } say '' }

# ---------------- Deceiver ----------------
say "# Gerado uma vez por tools/gen_upcast_damage.pl (2026-10-01); daqui em diante este patch e a fonte da verdade.";
say "# 2026-10-01: Deceiver, Starchild e Eternal saem do LevelMapValue para o upcast (+1 dado por nivel).";
card('Projectile_Arcana_Card_Spell_SigilofMalice', 'SigilofMalice_Damage', 6, 1, 1);
card('Projectile_Arcana_Created_MimicSigilofMalice', 'MimicSigilofMalice_Damage', 6, 1, 4);
perlevel('Projectile_Arcana_Distortion_Explosion', 'Distortion_Damage', 8, 3, 3, 'Spell_Projectile', 'Projectile_DECEIVER SPELLS', type => 'SpellData');
card('Target_Arcana_Card_Spell_Distortion', 'Distortion_Damage', 8, 3, 3, note => 'a explosao de cada nivel',
     rename => sub { my ($v, $S, $k) = @_; $v =~ s/\bProjectile_Arcana_Distortion_Explosion\b/Projectile_Arcana_Distortion_Explosion_$S/g if $S > 3 && $k eq 'SpellProperties'; $v });
perlevel('Projectile_Arcana_MimicDistortion_Explosion', 'MimicDistortion_Damage', 8, 2, 4, 'Spell_Projectile', 'Projectile_DECEIVER SPELLS', type => 'SpellData');
card('Target_Arcana_Created_MimicDistortion', 'MimicDistortion_Damage', 8, 2, 4, note => 'a explosao de cada nivel',
     rename => sub { my ($v, $S, $k) = @_; $v =~ s/\bProjectile_Arcana_MimicDistortion_Explosion\b/Projectile_Arcana_MimicDistortion_Explosion_$S/g if $S > 2 && $k eq 'SpellProperties'; $v });
perlevel('ETHEREAL_CHAINS', 'EtherealChains_Damage', 6, 2, 1, 'Status_BOOST', 'DECEIVER STATUS', type => 'StatusData', prio => 1);
card('Target_Arcana_Card_Spell_EtherealChains', 'EtherealChains_Damage', 6, 2, 1, note => 'o status de cada nivel',
     rename => sub { my ($v, $S, $k) = @_; $v =~ s/\bETHEREAL_CHAINS(?=,)/ETHEREAL_CHAINS_$S/g if $S > 2; $v });
perlevel('MIMIC_ETHEREAL_CHAINS', 'MimicEtherealChains_Damage', 6, 1, 3, 'Status_BOOST', 'DECEIVER STATUS', type => 'StatusData', prio => 1);
card('Target_Arcana_Created_MimicEtherealChains', 'MimicEtherealChains_Damage', 6, 1, 3, note => 'o status de cada nivel',
     rename => sub { my ($v, $S, $k) = @_; $v =~ s/\bMIMIC_ETHEREAL_CHAINS(?=,)/MIMIC_ETHEREAL_CHAINS_$S/g if $S > 1; $v });
# quem pergunta pelas correntes pelo nome passa a aceitar todos os niveis
my @chains = ('ETHEREAL_CHAINS', map({ "ETHEREAL_CHAINS_$_" } 3 .. 6), 'MIMIC_ETHEREAL_CHAINS', map({ "MIMIC_ETHEREAL_CHAINS_$_" } 2 .. 6), 'MIRROR_ETHEREAL_CHAINS');
my $any = join ',', map { "'$_'" } @chains;
say '', '# o Sigil detona com o dano das correntes, e o visual das correntes some sem elas: os dois aceitam todos os niveis';
{ my $v = $val{SIGIL}{RemoveConditions}; $v =~ s/HasAnyStatus\(\{'ETHEREAL_CHAINS','MIMIC_ETHEREAL_CHAINS','MIRROR_ETHEREAL_CHAINS'\}\)/HasAnyStatus({$any})/ or die "SIGIL RemoveConditions mudou\n"; say "\@set SIGIL RemoveConditions $v" }
{ $val{ETHEREAL_CHAINS_EFFECT}{RemoveConditions} eq "not HasStatus('ETHEREAL_CHAINS')" or die "ETHEREAL_CHAINS_EFFECT mudou\n"; say "\@set ETHEREAL_CHAINS_EFFECT RemoveConditions not HasAnyStatus({$any})" }

# ---------------- Starchild ----------------
card('Projectile_Arcana_Card_Spell_Starcall', 'Starcall_Damage', 6, 1, 1);
card('Target_Arcana_Card_Spell_AstralInfusion', 'AstralInfusion_Heal', 10, 1, 1);
card('Shout_Arcana_Card_Spell_Wish', 'Wish_Heal', 4, 4, 4);
card('Target_Arcana_Card_Spell_SolarFlare', 'SolarFlare_Damage', 6, 6, 8, note => 'nivel 6 e o ultimo: so troca o LevelMap pelo valor que ele ja dava');
card('Zone_Arcana_Card_Spell_FinalSpark', 'FinalSpark_Damage', 6, 6, 6, note => 'nivel 6 e o ultimo');
# Starbreath: revive com % da vida; o topo de cada faixa de nivel que o LevelMap ja dava (decisao do usuario)
say '', '# Starbreath: revive com 10/30/60/100% da vida nos espacos 3/4/5/6 (o topo de cada faixa que o LevelMap dava)';
{ my %pct = (3 => 10, 4 => 30, 5 => 60, 6 => 100);
  my $base = $val{Teleportation_Arcana_Card_Spell_Starbreath}{OriginSpellProperties};
  # tira os IF(...):Resurrect(100,N) por nivel de personagem; o resto (movimento, acoes, RESURRECTING) fica
  $base = join ';', grep { !/Resurrect\(/ } split /;/, $base; $base .= ';' if $val{Teleportation_Arcana_Card_Spell_Starbreath}{OriginSpellProperties} =~ /;\z/;
  for my $S (3 .. 6) { my $e = $S == 3 ? 'Teleportation_Arcana_Card_Spell_Starbreath' : "Teleportation_Arcana_Card_Spell_Starbreath_$S";
    say "\@set $e OriginSpellProperties Resurrect(100,$pct{$S});$base", "\@set $e DescriptionParams $pct{$S}" } }

# ---------------- Eternal ----------------
card('Target_Arcana_Card_Spell_DeathsGrasp', 'DeathsGrasp_Damage', 8, 2, 1);
perlevel('BLOOD_OFFERING', 'DeathsGrasp_Damage', 8, 3, 2, 'Status_BOOST', 'ETERNAL STATUS', type => 'StatusData', prio => 1);
card('Shout_Arcana_Card_Spell_BloodOffering', 'DeathsGrasp_Damage', 8, 3, 2, note => 'o status de cada nivel',
     rename => sub { my ($v, $S, $k) = @_; $v =~ s/\bBLOOD_OFFERING(?=,)/BLOOD_OFFERING_$S/g if $S > 3; $v });
card('Target_Arcana_Card_Spell_Obliterate', 'Obliterate_Damage', 8, 1, 1);
card('Target_Arcana_Card_Spell_Transfusion', 'Transfusion_Damage', 6, 1, 1);

print "$_\n" for @out;
