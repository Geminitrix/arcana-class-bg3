# Despertar do Aspecto — Plano de implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** implementar o Despertar do Aspecto das 4 subclasses (objetivo em combate → status desperto com tiers I/II/III cumulativos + carta do Aspecto + VFX), as spells alteradas por redundância e a saída dos capstones de nível 20.

**Architecture:** o Osiris conta os objetivos numa DB única (`DB_ARCANA_Aspect_Steps`) e aplica o status `ASPECT_AWAKENED_<ARCANO>`, que carrega os boosts (via passivas ocultas com `BoostConditions` só de funções nativas), o VFX e o `UnlockSpell` da carta. As duas edições compartilham tudo isso; o Lua (PC) só põe a carta na mão via `D.statusConjures`. Todas as entradas de stats são escritas como *patches* aplicados por uma ferramenta nova que grava o `.txt` (jogo), o `.stats` (Toolkit) e o `english.xml` de uma vez.

**Tech Stack:** BG3 Stats (`.txt` + `.stats`), LSX/TBL (progressões, listas, recursos), Osiris (Story goals), Khonsu (`.khn`), Lua 5.4 (Script Extender, testes offline), Perl (ferramentas).

**Spec:** `Design/Rework/specs/2026-09-28-aspect-awakening-design.md`

## Global Constraints

- Jogo **e** Toolkit fechados antes de qualquer escrita em arquivo do mod (regra 2 do CLAUDE.md). Perguntar no início da execução.
- Nada que a edição console carrega pode depender de SE. Lua só mexe no deck.
- Só o **inglês** recebe strings novas ou alteradas; as outras 15 línguas ficam para a rodada de localização.
- Texto em inglês segue a memória `bg3-english-writing-style`: britânico, sem travessão (usar ` - `), aspas simples, Title Case para Advantage/Saving Throw/Attack Roll, minúsculo para hit points/bonus action/reaction, `<br><br>` só para regras separadas.
- **Nunca** função Khonsu custom em `BoostConditions` (crash do Toolkit, memória `aspectclass-mod-khonsu-scripting`). Custom só em `Conditions`, functors e `IF()` dentro de `Boosts`.
- Nenhum gatilho de Osiris compara nome literal de carta: usar `DB_ARCANA_CardFamily`.
- Toda filha `using` declara `SpellType` antes do `using`; campo numa filha **substitui** o herdado.
- Magia mirada no chão: `GROUND:` em todo functor, inclusive `ApplyStatus(SELF,…)`.
- Todo bloco de mudança termina com: `sync-mod.sh`, commit e push no repo `Geminitrix/bg3-arcana-deckbuilder` (identidade do repo), e commit no git local do ScriptExtender com `GIT_AUTHOR_*`/`GIT_COMMITTER_*` (victr / lumox.gemini@gmail.com).
- Backups em `Data\Backup\aspect_awakening_20260928\`, espelhando `Public/`, `Editor/Mods/`, `Mods/`.

## Mapa de arquivos

| Arquivo | Papel |
|---|---|
| `Design/Rework/tools/stats_add.pl` (novo) | aplica patches de stats nos dois lados + loca; `--selftest` |
| `Design/Rework/tools/aspect_structure.pl` (novo) | progressões, listas de magia e recursos de ação (LSX + TBL) |
| `Design/Rework/aspect/00_common.patch` … `50_cleanup.patch` (novos) | os dados: strings, passivas, status, cartas, remoções |
| `Mods/…/Story/RawFiles/Goals/ARCANA_Aspect_Common.txt` (novo) | tabela dos Aspectos, roster de combate, passos, despertar, reset |
| `…/Goals/ARCANA_Aspect_Fool.txt`, `_Empress`, `_Star`, `_Death` (novos) | objetivo e efeitos em Osiris de cada subclasse |
| `…/Goals/ARCANA_Passive_DarknessRise.txt` (apagado) | o gatilho antigo de 3 acertos, substituído pelo Tier I |
| `Mods/…/Scripts/thoth/helpers/IsIsolatedFoe.khn` (novo) | condição "inimigo isolado" do Tier II do Eternal |
| `Mods/…/ScriptExtender/Lua/Server/Cards/CardDB.lua` | cartas do Aspecto, Blood Offering, `statusConjures` |
| `…/Lua/Tests/KeywordsTest.lua`, `DestinationTest.lua` | testes offline |
| `Public/…/Stats/Generated/Data/Spell_Rush.txt`, `Status_DOWNED.txt` (novos) | Leap of Faith; estados DOWNED do Undying Hope e do Mourning |
| `Editor/Mods/…/Stats/SpellData/Rush.stats` (novo) | lado Toolkit do Leap of Faith |

Caminhos abreviados: `$G` = `C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data`, `$M` = `AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7`, `$P` = `C:/Projetos/BG3 Modding/Arcana Class`, `$LUA` = `$G/Mods/$M/ScriptExtender/Lua`, `$LUAEXE` = `C:/Users/victr/AppData/Local/Programs/Lua/bin/lua.exe`.

---

### Task 0: Preflight e backup

**Files:** nenhum do mod é alterado.

- [ ] **Step 1:** perguntar ao usuário se o jogo e o Toolkit estão fechados. Sem um "sim" explícito, parar.
- [ ] **Step 2:** rodar a suíte Lua e registrar a linha de base.

Run: `"$LUAEXE" "$P/tools/run_tests.lua" "$LUA"`
Expected: `[ArcanaDeck tests] 120 passed, 0 failed`

- [ ] **Step 3:** backup.

```bash
B="$G/Backup/aspect_awakening_20260928"
mkdir -p "$B"
for d in "Public/$M/Stats" "Public/$M/Progressions" "Public/$M/Lists" "Public/$M/ActionResourceDefinitions" \
         "Editor/Mods/$M/Stats" "Editor/Mods/$M/Progressions" "Editor/Mods/$M/Lists" "Editor/Mods/$M/ActionResourceDefinitions" \
         "Mods/$M/Story/RawFiles/Goals" "Mods/$M/Scripts" "Mods/$M/ScriptExtender/Lua" "Mods/$M/Localization/English"; do
  mkdir -p "$B/$(dirname "$d")"; cp -r "$G/$d" "$B/$d"; done
ls -R "$B" | head
```

- [ ] **Step 4:** rodar o lint atual e registrar o resultado de base: `perl "$P/Design/Rework/tools/check_cards.pl"`.

---

### Task 1: Ferramenta `stats_add.pl` (TDD pelo `--selftest`)

**Files:**
- Create: `Design/Rework/tools/stats_add.pl`

**Interfaces:**
- Produces: `perl stats_add.pl <patch...> [--apply]` e `perl stats_add.pl --selftest`. Formato do patch documentado no cabeçalho. Handles novos = `h` + md5(`arcana-aspect-loca:<CHAVE>`) no formato 8-4-4-4-12 com `g`; UUIDs novos = md5(`arcana-aspect:<nome>`).

- [ ] **Step 1: escrever a ferramenta com o `--selftest` primeiro.** O selftest é o teste: para cada entrada dos `.txt` do mod que tem objeto no `.stats`, gera o objeto com o UUID existente e compara campo a campo (nome, tipo, valor/handle, versão, atributos de cauda; ignora ordem e `color`).

```perl
#!/usr/bin/perl
# Aplica patches de stats nos dois lados do mod -- Public/*.txt (o jogo) e Editor/*.stats (o Toolkit) --
# e as strings em ingles no english.xml. Um publish do Toolkit regera o Public a partir do .stats, entao
# o que so existe no .txt some; escrever os dois lados a mao foi a fonte classica de erro.
#
#   perl stats_add.pl a.patch [b.patch ...]            # mostra o que faria
#   perl stats_add.pl a.patch [b.patch ...] --apply    # grava (jogo e Toolkit fechados)
#   perl stats_add.pl --selftest                       # regera o .stats de cada entrada existente e compara
#
# Formato do patch (LF):
#   # comentario
#   @file Status_BOOST          arquivo Public (sem .txt) das entradas seguintes
#   @section UNBOUND STATUS     divisoria sob a qual entradas NOVAS entram ("-" = fim do arquivo)
#   @remove NOME                apaga a entrada dos dois lados (aviso se nao existir)
#   @set NOME CAMPO VALOR...    troca ou acrescenta um campo de uma entrada existente
#   @loca CHAVE Texto...        string em ingles. CHAVE livre = handle novo e deterministico;
#                               CHAVE = handle existente = texto trocado e versao +1 em todo lugar
#   new entry "X" ... (ate a linha em branco)   entrada completa; substitui se ja existir no mesmo arquivo
# Em qualquer valor, {{CHAVE}} ou {{hXXXX...}} vira "handle;versao".
use strict; use warnings;
use Digest::MD5 qw(md5_hex);

my $GAME = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $MOD  = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $PUB  = "$GAME/Public/$MOD/Stats/Generated/Data";
my $EDS  = "$GAME/Editor/Mods/$MOD/Stats";
my $LOCA = "$GAME/Mods/$MOD/Localization/English/english.xml";
my @VANILLA = map { "$GAME/Editor/Mods/$_/Stats" } qw(Shared SharedDev Gustav GustavDev GustavX);
my %NEW_DEF = ('SpellData/Rush' => 'bbe0e72e-fa2a-41d2-be9a-c604af561421');   # de Editor/Mods/Shared/Stats/SpellData/Rush.stats

my $apply    = grep { $_ eq '--apply' } @ARGV;
my $selftest = grep { $_ eq '--selftest' } @ARGV;
my @patches  = grep { !/^--/ } @ARGV;

# ---------- io: preserva BOM e CRLF de cada arquivo ----------
my %orig;
sub slurp { my $p = shift; open my $fh, '<:raw', $p or return undef; local $/; my $s = <$fh>; close $fh;
    my $bom = ($s =~ s/^\xEF\xBB\xBF//) ? 1 : 0; my $crlf = ($s =~ /\r\n/) ? 1 : 0; $s =~ s/\r\n/\n/g;
    $orig{$p} = { bom => $bom, crlf => $crlf }; return $s }
sub spew { my ($p, $s) = @_; my $o = $orig{$p} // { bom => 0, crlf => 1 };
    $s =~ s/\n/\r\n/g if $o->{crlf}; $s = "\xEF\xBB\xBF$s" if $o->{bom};
    open my $fh, '>:raw', $p or die "$p: $!"; print $fh $s; close $fh }
sub files_under { my ($dir, $re) = @_; my @out; opendir my $d, $dir or return ();
    for my $f (sort readdir $d) { next if $f =~ /^\./; my $p = "$dir/$f";
        if (-d $p) { push @out, files_under($p, $re) } elsif ($f =~ $re) { push @out, $p } } @out }

sub det_uuid { my @h = unpack '(A4)8', md5_hex("arcana-aspect:" . shift); "$h[0]$h[1]-$h[2]-$h[3]-$h[4]-$h[5]$h[6]$h[7]" }
sub det_handle { my $h = md5_hex("arcana-aspect-loca:" . shift);
    'h' . substr($h,0,8) . 'g' . substr($h,8,4) . 'g' . substr($h,12,4) . 'g' . substr($h,16,4) . 'g' . substr($h,20,12) }

# ---------- Public basename <-> Editor .stats ----------
sub stats_rel { my $pub = shift;
    return "SpellData/$1" if $pub =~ /^Spell_(\w+)$/;
    return "StatusData/$pub" if $pub =~ /^Status_/;
    return "Stats/$pub" }
sub stats_name { my ($pub, $n) = @_; return $n unless $pub =~ /^Spell_(\w+)$/; my $t = $1;
    $n =~ s/^\Q$t\E_// or die "$n: magia sem o prefixo ${t}_\n"; $n }

# ---------- aprende tipos de campo e UUIDs (mod primeiro, depois vanilla) ----------
my (%ftype, %uuid_of);
my $FIELD = qr{<field name="(\w+)" type="(\w+)"((?:\s+\w+="[^"]*")*)\s*/>};
sub learn { my $root = shift;
    for my $f (files_under($root, qr/\.stats$/)) {
        (my $rel = $f) =~ s{^\Q$root\E/}{}; $rel =~ s/\.stats$//;
        my $s = slurp($f) // next;
        for my $obj ($s =~ /<stat_object\b.*?<\/stat_object>/gs) {
            my ($name) = $obj =~ /<field name="Name" type="\w+" value="([^"]*)"/;
            my ($uuid) = $obj =~ /<field name="UUID" type="\w+" value="([^"]*)"/;
            if (defined $name && defined $uuid) {
                my $full = $rel =~ m{^SpellData/(\w+)$} ? "$1_$name" : $name; $uuid_of{$full} //= $uuid }
            while ($obj =~ /$FIELD/g) { my ($fn, $ty, $rest) = ($1, $2, $3);
                next if $rest =~ /clear_inherited_value/;
                (my $tail = $rest) =~ s/\s+(?:value|handle)="[^"]*"//g;
                $tail =~ s/\s+version="\d+"// if $ty eq 'TranslatedStringTableFieldDefinition';
                $ftype{$rel}{$fn} //= [$ty, $tail] } } } }

# ---------- .txt ----------
my %blocks;   # path -> [blocks]
sub blocks_of { my $pub = shift; my $p = "$PUB/$pub.txt";
    $blocks{$p} //= do { my $s = slurp($p); if (!defined $s) { $orig{$p} = { bom => 0, crlf => 1 }; $s = '' }
        $s =~ s/^\s+|\s+$//g; [ grep { length } split /\n{2,}/, $s ] };
    ($p, $blocks{$p}) }
sub bname { $_[0] =~ /^new entry "([^"]+)"/ ? $1 : '' }
sub is_divider { bname($_[0]) =~ / / }
sub parse_entry { my %e = (data => []);
    for my $l (split /\n/, shift) {
        if    ($l =~ /^new entry "([^"]+)"/)      { $e{name} = $1 }
        elsif ($l =~ /^type "([^"]+)"/)           { $e{type} = $1 }
        elsif ($l =~ /^using "([^"]+)"/)          { $e{using} = $1 }
        elsif ($l =~ /^data "([^"]+)" "(.*)"\s*$/) { push @{$e{data}}, [$1, $2] } }
    \%e }
sub all_pubs { map { m{/([^/]+)\.txt$} ? $1 : () } files_under($PUB, qr/\.txt$/) }
sub find_entry { my $name = shift;
    for my $pub (all_pubs()) { my (undef, $tb) = blocks_of($pub);
        for my $i (0..$#$tb) { return ($pub, $i) if bname($tb->[$i]) eq $name } }
    () }

# ---------- .stats ----------
my %stats;   # path -> {head, objs, foot}
sub stats_of { my $pub = shift; my $rel = stats_rel($pub); my $p = "$EDS/$rel.stats";
    $stats{$p} //= do { my $s = slurp($p);
        if (!defined $s) { my $def = $NEW_DEF{$rel} // die "$rel.stats nao existe e nao sei o stat_object_definition_id\n";
            $orig{$p} = { bom => 1, crlf => 1 };
            $s = qq{<?xml version="1.0" encoding="utf-8"?>\n<stats stat_object_definition_id="$def">\n  <stat_objects />\n</stats>\n} }
        $s =~ s{<stat_objects />}{<stat_objects>\n  </stat_objects>};
        my ($head, $body, $foot) = $s =~ m{^(.*?<stat_objects>\n)(.*?)(\n?\s*</stat_objects>.*)$}s or die "$p: formato inesperado\n";
        { head => $head, objs => [ $body =~ /( *<stat_object\b.*?<\/stat_object>)/gs ], foot => $foot } };
    ($p, $stats{$p}) }
sub oname  { $_[0] =~ /<field name="Name" type="\w+" value="([^"]*)"/ ? $1 : '' }
sub ouuid  { $_[0] =~ /<field name="UUID" type="\w+" value="([^"]*)"/ ? $1 : '' }
sub ocolor { $_[0] =~ /<stat_object color="([^"]*)"/ ? $1 : undef }
sub xml_attr { my $v = shift; $v =~ s/&/&amp;/g; $v =~ s/</&lt;/g; $v =~ s/>/&gt;/g; $v =~ s/"/&quot;/g; $v }
sub field_line { my ($n, $t, $a) = @_; qq{<field name="$n" type="$t" $a />} }
sub build_field { my ($rel, $ename, $k, $v) = @_;
    my $t = $ftype{$rel}{$k} // die "$ename: campo $k sem tipo conhecido em $rel\n"; my ($ty, $tail) = @$t;
    if ($ty eq 'TranslatedStringTableFieldDefinition') {
        return field_line($k, $ty, 'clear_inherited_value="true"') if $v eq '';
        my ($h, $ver) = $v =~ /^(h[0-9a-g]+);(\d+)$/ or die "$ename: $k nao e handle;versao: $v\n";
        return field_line($k, $ty, qq{handle="$h" version="$ver"}) }
    return field_line($k, $ty, 'clear_inherited_value="true" value=""' . $tail) if $v eq '';
    field_line($k, $ty, 'value="' . xml_attr($v) . '"' . $tail) }
sub build_obj { my ($pub, $e, $uuid, $color) = @_; my $rel = stats_rel($pub);
    my @f = (field_line('UUID', 'IdTableFieldDefinition', qq{value="$uuid"}),
             field_line('Name', 'NameTableFieldDefinition', 'value="' . xml_attr(stats_name($pub, $e->{name})) . '"'));
    if (defined $e->{using}) { my $u = $uuid_of{$e->{using}} // die "$e->{name}: using $e->{using} sem UUID conhecido\n";
        push @f, field_line('Using', 'BaseClassTableFieldDefinition', qq{value="$u"}) }
    for my $d (@{$e->{data}}) { my ($k, $v) = @$d; next if $k eq 'SpellType' || $k eq 'StatusType';
        push @f, build_field($rel, $e->{name}, $k, $v) }
    my $open = defined $color ? qq{<stat_object color="$color" is_substat="false">} : qq{<stat_object is_substat="false">};
    "    $open\n      <fields>\n" . join('', map { "        $_\n" } @f) . "      </fields>\n    </stat_object>" }

# ---------- selftest ----------
sub norm_fields { my $obj = shift; my %f;
    while ($obj =~ /$FIELD/g) { my ($n, $t, $r) = ($1, $2, $3); next if $n eq 'UUID';
        my %a = $r =~ /(\w+)="([^"]*)"/g; $f{$n} = join '|', $t, map { "$_=$a{$_}" } sort keys %a } \%f }
sub run_selftest {
    learn($EDS); learn($_) for @VANILLA;
    my ($ok, $bad, $missing) = (0, 0, 0);
    for my $pub (all_pubs()) { my $sp = "$EDS/" . stats_rel($pub) . ".stats"; next unless -e $sp;
        my (undef, $tb) = blocks_of($pub); my (undef, $st) = stats_of($pub);
        my %by = map { oname($_) => $_ } @{$st->{objs}};
        for my $blk (@$tb) { my $e = parse_entry($blk); my $sn = eval { stats_name($pub, $e->{name}) } // $e->{name};
            my $have = $by{$sn}; if (!$have) { $missing++; print "  sem .stats: $pub $e->{name}\n" if $missing <= 10; next }
            my $gen = eval { build_obj($pub, $e, ouuid($have), ocolor($have)) };
            if (!$gen) { $bad++; print "  ERRO $pub $e->{name}: $@" if $bad <= 30; next }
            my ($a, $b) = (norm_fields($have), norm_fields($gen));
            my @diff = grep { ($a->{$_} // '') ne ($b->{$_} // '') } sort keys %{{ %$a, %$b }};
            if (@diff) { $bad++; if ($bad <= 30) { print "  DIFERE $pub $e->{name}:\n";
                    print "    $_\n      tem: ", ($a->{$_} // '(nada)'), "\n      gen: ", ($b->{$_} // '(nada)'), "\n" for @diff } }
            else { $ok++ } } }
    print "selftest: $ok iguais, $bad diferentes, $missing sem objeto no .stats\n";
    exit($bad ? 1 : 0) }

run_selftest() if $selftest;
die "uso: perl stats_add.pl a.patch [...] [--apply] | --selftest\n" unless @patches;

# ---------- patches ----------
learn($EDS); learn($_) for @VANILLA;
my $loca = slurp($LOCA) // die "$LOCA: $!";
my (%loca_ver, %loca_key, %bumped, @log);
$loca_ver{$1} = $2 while $loca =~ /<content contentuid="(h[0-9a-g]+)" version="(\d+)">/g;
sub note { push @log, shift }
sub loca_esc { my $t = shift; $t =~ s/&(?!(?:amp|lt|gt|quot|apos);)/&amp;/g; $t =~ s/</&lt;/g; $t =~ s/>/&gt;/g; $t }
sub loca_set { my ($key, $text) = @_;
    my $is_h = $key =~ /^h[0-9a-f]{8}g[0-9a-f]{4}g/; my $h = $is_h ? $key : det_handle($key); my $esc = loca_esc($text);
    if ($loca =~ /<content contentuid="\Q$h\E" version="(\d+)">(.*?)<\/content>/) { my ($ver, $old) = ($1, $2);
        if ($old ne $esc) { my $nv = $ver + 1;
            $loca =~ s/<content contentuid="\Q$h\E" version="\d+">.*?<\/content>/<content contentuid="$h" version="$nv">$esc<\/content>/;
            $loca_ver{$h} = $nv; $bumped{$h} = $nv; note("loca ~ $key ($h;$nv)") } }
    else { die "$key: handle nao existe no english.xml\n" if $is_h;
        $loca =~ s{(\n?</contentList>)}{\n  <content contentuid="$h" version="1">$esc</content>$1};
        $loca_ver{$h} = 1; note("loca + $key ($h)") }
    $loca_key{$key} = $h }
sub resolve { my $v = shift;
    $v =~ s{\{\{([\w]+)\}\}}{ my $k = $1; my $h = $k =~ /^h[0-9a-f]{8}g/ ? $k : ($loca_key{$k} // die "{{$k}}: chave sem \@loca\n");
        "$h;" . ($loca_ver{$h} // die "{{$k}}: handle $h sem versao\n") }ge; $v }

my @ops;   # pass 1: le todos os patches, aplica @loca
for my $pf (@patches) { my $s = slurp($pf) // die "$pf: $!"; my ($file, $sec) = (undef, '-');
    my @chunks = split /\n{2,}/, $s;
    for my $c (@chunks) { my @rest;
        for my $l (split /\n/, $c) {
            next if $l =~ /^\s*(#|$)/;
            if    ($l =~ /^\@file (\S+)/)            { $file = $1 }
            elsif ($l =~ /^\@section (.+?)\s*$/)     { $sec = $1 }
            elsif ($l =~ /^\@remove (\S+)/)          { push @ops, ['remove', $1] }
            elsif ($l =~ /^\@set (\S+) (\S+) ?(.*)$/) { push @ops, ['set', $1, $2, $3] }
            elsif ($l =~ /^\@loca (\S+) (.+)$/)      { loca_set($1, $2) }
            else { push @rest, $l } }
        next unless @rest;
        die "$pf: bloco sem 'new entry': $rest[0]\n" unless $rest[0] =~ /^new entry /;
        die "$pf: entrada antes de \@file\n" unless defined $file;
        push @ops, ['put', $file, $sec, join("\n", @rest)] } }

sub put_entry { my ($pub, $sec, $blk) = @_; my $e = parse_entry($blk);
    my ($opub, $oi) = find_entry($e->{name}); die "$e->{name} ja existe em $opub, nao em $pub\n" if defined $opub && $opub ne $pub;
    my (undef, $tb) = blocks_of($pub);
    if (defined $oi) { $tb->[$oi] = $blk; note("txt ~ $pub $e->{name}") }
    elsif ($sec eq '-') { push @$tb, $blk; note("txt + $pub $e->{name} (fim)") }
    else { my ($d) = grep { bname($tb->[$_]) eq $sec } 0..$#$tb; die "divisoria '$sec' nao achada em $pub\n" unless defined $d;
        my $k = $d + 1; $k++ while $k <= $#$tb && !is_divider($tb->[$k]); splice @$tb, $k, 0, $blk; note("txt + $pub $e->{name} (em $sec)") }
    my (undef, $st) = stats_of($pub); my $sn = stats_name($pub, $e->{name});
    my ($j) = grep { oname($st->{objs}[$_]) eq $sn } 0..$#{$st->{objs}};
    my $uuid = defined $j ? ouuid($st->{objs}[$j]) : det_uuid($e->{name});
    my $obj = build_obj($pub, $e, $uuid, defined $j ? ocolor($st->{objs}[$j]) : undef);
    if (defined $j) { $st->{objs}[$j] = $obj } else { push @{$st->{objs}}, $obj }
    $uuid_of{$e->{name}} = $uuid }
sub set_field { my ($name, $k, $v) = @_; my ($pub, $i) = find_entry($name); die "\@set: $name nao existe\n" unless defined $pub;
    my (undef, $tb) = blocks_of($pub); my $blk = $tb->[$i];
    if ($blk =~ /^data "\Q$k\E" ".*"$/m) { $blk =~ s/^data "\Q$k\E" ".*"$/data "$k" "$v"/m } else { $blk .= qq{\ndata "$k" "$v"} }
    $tb->[$i] = $blk;
    my (undef, $st) = stats_of($pub); my $sn = stats_name($pub, $name);
    my ($j) = grep { oname($st->{objs}[$_]) eq $sn } 0..$#{$st->{objs}}; die "\@set: $name sem objeto no .stats\n" unless defined $j;
    my $line = build_field(stats_rel($pub), $name, $k, $v);
    if ($st->{objs}[$j] =~ /<field name="\Q$k\E" /) { $st->{objs}[$j] =~ s/<field name="\Q$k\E" [^\n]*\/>/$line/ }
    else { $st->{objs}[$j] =~ s{(\n\s*</fields>)}{\n        $line$1} }
    note("set $name.$k") }
sub remove_entry { my $name = shift; my ($pub, $i) = find_entry($name);
    if (!defined $pub) { note("AVISO: \@remove $name - nao existe"); return }
    my (undef, $tb) = blocks_of($pub); splice @$tb, $i, 1;
    my (undef, $st) = stats_of($pub); my $sn = stats_name($pub, $name);
    @{$st->{objs}} = grep { oname($_) ne $sn } @{$st->{objs}}; note("remove $pub $name") }

for my $op (@ops) { my ($k, @a) = @$op;
    if    ($k eq 'put')    { put_entry($a[0], $a[1], resolve($a[2])) }
    elsif ($k eq 'set')    { set_field($a[0], $a[1], resolve($a[2])) }
    elsif ($k eq 'remove') { remove_entry($a[0]) } }

# versao nova de um handle existente vale em todo lugar que o cita
if (%bumped) {
    for my $pub (all_pubs()) { my (undef, $tb) = blocks_of($pub);
        for (@$tb) { for my $h (keys %bumped) { s/\b\Q$h\E;\d+/$h;$bumped{$h}/g } } }
    for my $pub (all_pubs()) { next unless -e "$EDS/" . stats_rel($pub) . ".stats" or $stats{"$EDS/" . stats_rel($pub) . ".stats"};
        my (undef, $st) = stats_of($pub);
        for (@{$st->{objs}}) { for my $h (keys %bumped) { s/handle="\Q$h\E" version="\d+"/handle="$h" version="$bumped{$h}"/g } } } }

print "$_\n" for @log;
if ($apply) {
    for my $p (keys %blocks) { spew($p, join("\n\n", @{$blocks{$p}}) . "\n") }
    for my $p (keys %stats) { my $s = $stats{$p}; spew($p, $s->{head} . join("\n", @{$s->{objs}}) . $s->{foot}) }
    spew($LOCA, $loca); print "gravado.\n" }
else { print "(simulacao -- rode com --apply para gravar)\n" }
```

- [ ] **Step 2: rodar o selftest e ver as diferenças.**

Run: `perl "$P/Design/Rework/tools/stats_add.pl" --selftest`
Expected na primeira rodada: alguma quantidade de `DIFERE` (a regra exata de cada campo só aparece comparando).

- [ ] **Step 3: corrigir a ferramenta até o selftest passar.** Para cada padrão de diferença, ajustar `build_field`/`learn` (exemplos esperados: um campo cujo tipo no Public e no Toolkit diverge por arquivo; `ExtraDescriptionParams` vazio; espaços). **Não** alterar arquivos do mod para fazer o teste passar. Objetos `sem .stats` são informativos, não falha.

Run: `perl "$P/Design/Rework/tools/stats_add.pl" --selftest`
Expected: `selftest: N iguais, 0 diferentes, …` e código de saída 0.

- [ ] **Step 4: teste de ida e volta de um `@set` sem efeito.** Criar `$P/Design/Rework/aspect/zz_noop.patch` com `@set Shout_Arcana_Card_Spell_Wish Level 4` e rodar **sem** `--apply`: a saída deve listar só `set Shout_Arcana_Card_Spell_Wish.Level`. Apagar o arquivo.

- [ ] **Step 5: commit** (o repo espelha `Design/Rework/tools` em `tools/stats` via `sync-mod.sh`).

```bash
cd "$P" && bash tools/sync-mod.sh && git add tools/stats && git commit -m "stats_add.pl: write a stats patch to both the game and the Toolkit side, with a selftest

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>" && git push
```

---

### Task 2: Estrutura comum em Osiris

**Files:**
- Create: `$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Common.txt`
- Create: `$P/Design/Rework/aspect/00_common.patch`

**Interfaces:**
- Produces (Osiris): `PROC_ARCANA_Aspect_Step((CHARACTER)_Char, (STRING)_Aspect)` soma 1 passo; `PROC_ARCANA_Aspect_Advance((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Target)` leva os passos a `_Target` (nunca diminui, teto 3); `PROC_ARCANA_Aspect_OnAwakened((CHARACTER)_Char, (STRING)_Aspect)` gancho chamado ao despertar; `PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)` gancho chamado ao sair do combate; `DB_ARCANA_Aspect_InCombat((CHARACTER)_Char, (GUIDSTRING)_Combat)`. Aspectos: `"FOOL"`, `"EMPRESS"`, `"STAR"`, `"DEATH"`.
- Produces (stats): string `ASPECT_TECH_NAME`.

- [ ] **Step 1:** criar `00_common.patch`:

```
# Strings compartilhadas pelos status tecnicos do Despertar
@loca ASPECT_TECH_NAME Aspect
```

- [ ] **Step 2:** criar `ARCANA_Aspect_Common.txt` (CRLF, como os outros goals):

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION
PROC_ARCANA_Aspect_Init();

KBSECTION
// Despertar do Aspecto (spec 2026-09-28). Cada subclasse soma passos pelo seu objetivo; com 3, o
// personagem desperta ate o fim do combate. Este goal guarda a tabela, o roster do combate, os passos,
// o despertar e a limpeza. O objetivo e os efeitos de cada Aspecto moram em ARCANA_Aspect_<Arcano>.txt.

//REGION Tabela: aspecto, status de progresso, status desperto, passiva do Tier I
PROC
PROC_ARCANA_Aspect_Init()
THEN
DB_ARCANA_Aspect("FOOL", "ASPECT_PROGRESS_FOOL", "ASPECT_AWAKENED_FOOL", "Arcana_Passive_Aspect_Fool_I");
DB_ARCANA_Aspect("EMPRESS", "ASPECT_PROGRESS_EMPRESS", "ASPECT_AWAKENED_EMPRESS", "Arcana_Passive_Aspect_Empress_I");
DB_ARCANA_Aspect("STAR", "ASPECT_PROGRESS_STAR", "ASPECT_AWAKENED_STAR", "Arcana_Passive_Aspect_Star_I");
DB_ARCANA_Aspect("DEATH", "ASPECT_PROGRESS_DEATH", "ASPECT_AWAKENED_DEATH", "Arcana_Passive_Aspect_Death_I");

// INITSECTION nao roda de novo em save existente
IF
SavegameLoaded()
THEN
PROC_ARCANA_Aspect_Init();
//END_REGION

//REGION Roster do combate
IF
EnteredCombat((CHARACTER)_Char, _Combat)
THEN
DB_ARCANA_Aspect_InCombat(_Char, _Combat);

IF
LeftCombat((CHARACTER)_Char, _Combat)
AND
DB_ARCANA_Aspect_InCombat(_Char, _Combat)
THEN
NOT DB_ARCANA_Aspect_InCombat(_Char, _Combat);
PROC_ARCANA_Aspect_Reset(_Char);
//END_REGION

//REGION Passos
PROC
PROC_ARCANA_Aspect_Step((CHARACTER)_Char, (STRING)_Aspect)
AND
DB_ARCANA_Aspect_Steps(_Char, _Old)
AND
IntegerSum(_Old, 1, _New)
THEN
PROC_ARCANA_Aspect_Advance(_Char, _Aspect, _New);

PROC
PROC_ARCANA_Aspect_Step((CHARACTER)_Char, (STRING)_Aspect)
AND
NOT DB_ARCANA_Aspect_Steps(_Char, _)
THEN
PROC_ARCANA_Aspect_Advance(_Char, _Aspect, 1);

// So conta com o Tier I, em combate e antes de despertar
PROC
PROC_ARCANA_Aspect_Advance((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Target)
AND
DB_ARCANA_Aspect(_Aspect, _Progress, _Awakened, _TierI)
AND
HasPassive(_Char, _TierI, 1)
AND
HasActiveStatus(_Char, _Awakened, 0)
AND
IsInCombat(_Char, 1)
AND
NOT DB_ARCANA_Aspect_Steps(_Char, _)
THEN
DB_ARCANA_Aspect_Steps(_Char, 0);

PROC
PROC_ARCANA_Aspect_Advance((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Target)
AND
DB_ARCANA_Aspect(_Aspect, _Progress, _Awakened, _TierI)
AND
HasPassive(_Char, _TierI, 1)
AND
HasActiveStatus(_Char, _Awakened, 0)
AND
DB_ARCANA_Aspect_Steps(_Char, _Old)
AND
_Target > _Old
AND
IntegerMin(_Target, 3, _New)
THEN
NOT DB_ARCANA_Aspect_Steps(_Char, _Old);
DB_ARCANA_Aspect_Steps(_Char, _New);
PROC_ARCANA_Aspect_Show(_Char, _Progress, _New);
PROC_ARCANA_Aspect_TryAwaken(_Char, _Aspect, _New);

// O status de progresso so mostra: duracao = passos (FreezeDuration), 6 s por turno
PROC
PROC_ARCANA_Aspect_Show((CHARACTER)_Char, (STRING)_Progress, (INTEGER)_N)
AND
_N < 3
AND
IntegerProduct(_N, 6, _Secs)
AND
IntegerToReal(_Secs, _Dur)
THEN
ApplyStatus(_Char, _Progress, _Dur, 1, _Char);

PROC
PROC_ARCANA_Aspect_TryAwaken((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_N)
AND
_N >= 3
AND
DB_ARCANA_Aspect(_Aspect, _Progress, _Awakened, _TierI)
THEN
RemoveStatus(_Char, _Progress, _Char);
ApplyStatus(_Char, _Awakened, -1.0, 1, _Char);
PROC_ARCANA_Aspect_OnAwakened(_Char, _Aspect);
//END_REGION

//REGION Limpeza ao sair do combate (os goals de cada Aspecto acrescentam as suas regras)
PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_Aspect_Steps(_Char, _N)
THEN
NOT DB_ARCANA_Aspect_Steps(_Char, _N);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_Aspect(_Aspect, _Progress, _Awakened, _TierI)
THEN
RemoveStatus(_Char, _Progress, _Char);
RemoveStatus(_Char, _Awakened, _Char);
//END_REGION
EXITSECTION

ENDEXITSECTION
```

- [ ] **Step 3:** converter o goal para CRLF: `perl -pi -e 's/\r?\n/\r\n/' "$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Common.txt"`.
- [ ] **Step 4:** simular o patch: `perl "$P/Design/Rework/tools/stats_add.pl" "$P/Design/Rework/aspect/00_common.patch"` → espera `loca + ASPECT_TECH_NAME`. Aplicar com `--apply`.

A compilação do Story fica para a Task 9 (todos os goals juntos).

---

### Task 3: The Fool (Unbound)

**Files:**
- Create: `$P/Design/Rework/aspect/10_fool.patch`
- Create: `$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Fool.txt`

**Interfaces:**
- Consumes: `PROC_ARCANA_Aspect_Step`, `PROC_ARCANA_Aspect_OnAwakened`, `PROC_ARCANA_Aspect_Reset` (Task 2); `DB_ARCANA_CardFamily` (gerado); `ASPECT_TECH_NAME`.
- Produces: passivas `Arcana_Passive_Aspect_Fool_I/_II/_III` (progressão, Task 7); recurso `ArcanaFoolsLuck` (Task 7); carta `Rush_Arcana_Created_Aspect_LeapOfFaith`; status `ASPECT_AWAKENED_FOOL` (Lua, Task 8).

- [ ] **Step 1:** criar `10_fool.patch`:

```
# ===== The Fool (Unbound) =====
@loca FOOL_I_NAME 0 - The Fool: Wanderlust
@loca FOOL_I_DESC Hit different enemies with unarmed attacks during combat to awaken the Aspect of Curiosity until combat ends. Every hit on an enemy you haven't struck this turn counts, and 3 of them awaken it.<br><br>While awakened, your <LSTag Tooltip="MovementSpeed">movement speed</LSTag> increases by [1], you can move without provoking <LSTag Tooltip="OpportunityAttack">Opportunity Attacks</LSTag>, and your unarmed attacks deal an additional [2].
@loca FOOL_II_NAME 0 - The Fool: Restless Wind
@loca FOOL_II_DESC While your Aspect of Curiosity is awakened, you have <LSTag Tooltip="Advantage">Advantage</LSTag> on Dexterity <LSTag Tooltip="SavingThrow">Saving Throws</LSTag> and an additional <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag>. Once per turn, Flowing Strikes: Zephyr doesn't cost a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.
@loca FOOL_III_NAME 0 - The Fool: Aspect of Curiosity
@loca FOOL_III_DESC While your Aspect of Curiosity is awakened, your Dexterity increases by [1] and you have another additional <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag>. Once per round, the first attack against you misses.
@loca FOOL_AWAKENED_NAME 0 - The Fool
@loca FOOL_AWAKENED_DESC Awakened as the Aspect of Curiosity until combat ends.
@loca FOOL_PROGRESS_NAME Wanderlust
@loca FOOL_PROGRESS_DESC Progress towards awakening the Aspect of Curiosity. Awakens at 3.
@loca FOOL_ZEPHYR_NAME Restless Wind
@loca FOOL_ZEPHYR_DESC The next Flowing Strikes: Zephyr this turn doesn't cost a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.
@loca FOOLS_LUCK_NAME Fool's Luck
@loca FOOLS_LUCK_DESC Once per round, the first attack against you misses.
@loca LEAP_NAME Leap of Faith
@loca LEAP_DESC Dash through the fray, striking every creature in your path with an unarmed attack that also deals [1]. You can then make an unarmed attack as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.
@loca EVASIVE_OPENING_NAME Opening
@loca EVASIVE_OPENING_DESC Has <LSTag Tooltip="Advantage">Advantage</LSTag> on the next unarmed <LSTag Tooltip="AttackRoll">Attack Roll</LSTag> this turn.
# textos existentes que mudam (versao +1 em todo lugar que os cita)
@loca hbec0c1e5g4648g9671g5329g17403f153608 Leap into an opening. Jumping no longer requires a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>, and your next unarmed attack this turn has <LSTag Tooltip="Advantage">Advantage</LSTag>.
@loca hb2cbdec3g90c8g7e43g9d01g7c45f6af7a6a Jumping no longer requires a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.<br><br>Equipping armour or a shield ends this effect.
@loca h64279279ga897g3b4bgc173gcc1156e709e0 You can sense movement in the air. <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag> against you have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag>, and when one misses you, you can strike back with an unarmed attack as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.
@loca hba599070gc262gfacfg3f31geafbde30b608 Focusing on avoiding attacks. <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag> against you have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag>. When one misses, you can make an unarmed attack as a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.<br><br>Equipping armour or a shield ends this effect.

@file Passive
@section UNBOUND PASSIVES

new entry "Arcana_Passive_Aspect_Fool_I"
type "PassiveData"
data "DisplayName" "{{FOOL_I_NAME}}"
data "Description" "{{FOOL_I_DESC}}"
data "DescriptionParams" "Distance(3);DealDamage(1d4,Thunder)"
data "ExtraDescription" "{{h73613d54g9e1dg231dg03c1gcb8d2ba41166}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnAttack"
data "Conditions" "Combat() and IsMeleeUnarmedAttack() and IsHit() and Enemy() and not HasStatus('WANDERLUST_MARK', context.Target, context.Source) and not HasStatus('ASPECT_AWAKENED_FOOL', context.Source) and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);"
data "StatsFunctors" "ApplyStatus(WANDERLUST_MARK,100,-1);ApplyStatus(SELF,WANDERLUST_HIT_TECH,100,0)"

new entry "Arcana_Passive_Aspect_Fool_II"
type "PassiveData"
data "DisplayName" "{{FOOL_II_NAME}}"
data "Description" "{{FOOL_II_DESC}}"
data "ExtraDescription" "{{h73613d54g9e1dg231dg03c1gcb8d2ba41166}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Fool_III"
type "PassiveData"
data "DisplayName" "{{FOOL_III_NAME}}"
data "Description" "{{FOOL_III_DESC}}"
data "DescriptionParams" "3"
data "ExtraDescription" "{{h73613d54g9e1dg231dg03c1gcb8d2ba41166}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Fool_Awakened_I"
type "PassiveData"
data "DisplayName" "{{FOOL_I_NAME}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "Properties" "IsHidden"
data "BoostConditions" "not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);"
data "Boosts" "ActionResource(Movement,3,0);IgnoreLeaveAttackRange();IF(IsMeleeUnarmedAttack()):DamageBonus(1d4,Thunder);"

new entry "Arcana_Passive_Aspect_Fool_Awakened_II"
type "PassiveData"
data "DisplayName" "{{FOOL_II_NAME}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "Properties" "IsHidden"
data "BoostConditions" "HasPassive('Arcana_Passive_Aspect_Fool_II', context.Source) and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);"
data "Boosts" "Advantage(SavingThrow, Dexterity);ActionResource(ReactionActionPoint,1,0);"

new entry "Arcana_Passive_Aspect_Fool_Awakened_III"
type "PassiveData"
data "DisplayName" "{{FOOL_III_NAME}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "Properties" "IsHidden"
data "BoostConditions" "HasPassive('Arcana_Passive_Aspect_Fool_III', context.Source) and not WearingArmor(context.Source) and not HasShieldEquipped(context.Source);"
data "Boosts" "Ability(Dexterity,3);ActionResource(ReactionActionPoint,1,0);UnlockInterrupt(Interrupt_Arcana_Aspect_FoolsLuck);ActionResource(ArcanaFoolsLuck,1,0);"

new entry "Arcana_Passive_WindWhispers_Counter"
type "PassiveData"
data "DisplayName" "he348b9b5g4bffgf77cgaa79g953924869067;2"
data "Icon" "PassiveFeature_DangerSense"
data "Properties" "IsHidden"
data "StatsFunctorContext" "OnAttacked"
data "Conditions" "IsMiss();"
data "StatsFunctors" "ApplyStatus(SELF,ZEPHYR_STRIKE,100,2)"

@file Status_BOOST
@section UNBOUND STATUS

new entry "ASPECT_PROGRESS_FOOL"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{FOOL_PROGRESS_NAME}}"
data "Description" "{{FOOL_PROGRESS_DESC}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "StackId" "ASPECT_PROGRESS_FOOL"
data "StackType" "Overwrite"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "FreezeDuration;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "ASPECT_AWAKENED_FOOL"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{FOOL_AWAKENED_NAME}}"
data "Description" "{{FOOL_AWAKENED_DESC}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "StackId" "ASPECT_AWAKENED_FOOL"
data "StackType" "Ignore"
data "Boosts" "UnlockSpell(Rush_Arcana_Created_Aspect_LeapOfFaith);"
data "Passives" "Arcana_Passive_Aspect_Fool_Awakened_I;Arcana_Passive_Aspect_Fool_Awakened_II;Arcana_Passive_Aspect_Fool_Awakened_III"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "ForceOverhead;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"
data "StatusEffect" "b79270c7-13cd-44d9-82f5-11eb41ca5f8a"

new entry "WANDERLUST_MARK"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "WANDERLUST_MARK"
data "StackType" "Ignore"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "WANDERLUST_HIT_TECH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "WANDERLUST_HIT_TECH"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "FOOL_ZEPHYR_FREE"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{FOOL_ZEPHYR_NAME}}"
data "Description" "{{FOOL_ZEPHYR_DESC}}"
data "Icon" "PassiveFeature_MartialArts_BonusUnarmedStrike"
data "StackId" "FOOL_ZEPHYR_FREE"
data "StackType" "Overwrite"
data "TickType" "EndTurn"
data "Boosts" "UnlockSpellVariant(SpellId('Target_Arcana_Created_ZephyrStrike') or SpellId('Target_Arcana_Created_ZephyrStrike_2') or SpellId('Target_Arcana_Created_ZephyrStrike_3') or SpellId('Target_Arcana_Created_ZephyrStrike_4') or SpellId('Target_Arcana_Created_ZephyrStrike_5') or SpellId('Target_Arcana_Created_ZephyrStrike_6'),ModifyUseCosts(Replace,BonusActionPoint,0,0,BonusActionPoint));"
data "RemoveEvents" "OnCombatEnded"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "EVASIVE_FLOW_OPENING"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{EVASIVE_OPENING_NAME}}"
data "Description" "{{EVASIVE_OPENING_DESC}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "StackId" "EVASIVE_FLOW_OPENING"
data "StackType" "Overwrite"
data "TickType" "EndTurn"
data "Boosts" "IF(IsMeleeUnarmedAttack()):Advantage(AttackRoll);"
data "RemoveConditions" "IsMeleeUnarmedAttack()"
data "RemoveEvents" "OnAttack"
data "StatusGroups" "SG_RemoveOnRespec"

# Tier I tira o ataque de oportunidade; o Evasive Flow fica com o pulo gratis e ganha a abertura
@set EVASIVE_FLOW Boosts UnlockSpellVariant(SpellId('Projectile_Jump'),ModifyUseCosts(Replace,BonusActionPoint,0,0,BonusActionPoint));
@set Shout_Arcana_Card_Spell_EvasiveFlow SpellProperties ApplyStatus(SELF,EVASIVE_FLOW,100,1);ApplyStatus(SELF,EVASIVE_FLOW_OPENING,100,1);
@set Shout_Arcana_Card_Spell_EvasiveFlow_EX SpellProperties ApplyStatus(SELF,EVASIVE_FLOW_EX,100,5);ApplyStatus(SELF,EVASIVE_FLOW_OPENING,100,1);
# Tier II da Vantagem em DES; o Wind Whispers troca a dele por contra-ataque
@set WIND_WHISPERS Boosts Disadvantage(AttackTarget);
@set WIND_WHISPERS Passives Arcana_Passive_WindWhispers_Counter

@file Interrupt
@section -

new entry "Interrupt_Arcana_Aspect_FoolsLuck"
type "InterruptData"
data "DisplayName" "{{FOOLS_LUCK_NAME}}"
data "Description" "{{FOOLS_LUCK_DESC}}"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "InterruptContext" "OnPostRoll"
data "InterruptContextScope" "Self"
data "Container" "YesNoDecision"
data "Conditions" "Self(context.Target,context.Observer) and HasInterruptedAttack() and not AnyEntityIsItem() and IsSetInterruptInteresting(1, context.Source)"
data "Properties" "SetRoll(1)"
data "Cost" "ArcanaFoolsLuck:1"
data "InterruptDefaultValue" "Ask;Enabled"
data "EnableCondition" "HasActionResource('ArcanaFoolsLuck', 1, 0, false, false, context.Source);"
data "EnableContext" "OnActionResourcesChanged"

@file Spell_Rush
@section -

new entry "Rush_Arcana_Created_Aspect_LeapOfFaith"
type "SpellData"
data "SpellType" "Rush"
using "Rush_SpringAttack"
data "Level" "0"
data "SpellSchool" "Evocation"
data "Cooldown" "OncePerCombat"
data "SpellProperties" "GROUND:ApplyStatus(SELF,ZEPHYR_STRIKE,100,1)"
data "TargetRadius" "18"
data "MovementSpeed" "60000"
data "SpellRoll" "Attack(AttackType.MeleeUnarmedAttack)"
data "SpellSuccess" "DealDamage(UnarmedDamage,Bludgeoning);DealDamage(LevelMapValue(GaleBurst_Damage),Thunder,Magical)"
data "TargetConditions" "((Character() and not Ally() and not Dead()) or Item()) and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Action_Monk_StepOfTheWind_Dash"
data "DisplayName" "{{LEAP_NAME}}"
data "Description" "{{LEAP_DESC}}"
data "DescriptionParams" "DealDamage(LevelMapValue(GaleBurst_Damage),Thunder)"
data "TooltipDamageList" "DealDamage(UnarmedDamage,Bludgeoning);DealDamage(LevelMapValue(GaleBurst_Damage),Thunder)"
data "TooltipAttackSave" "MeleeUnarmedAttack"
data "Requirements" "Combat;!Immobile"
data "RequirementConditions" "not WearingArmor(context.Source) and not HasShieldEquipped(context.Source)"
data "UseCosts" "ActionPoint:1;"
data "WeaponTypes" ""
data "RechargeValues" ""
data "SpellFlags" "IsSpell;IsHarmful;HasSomaticComponent"
data "OnlyHit1Target" "0"
data "DamageType" "Thunder"
data "Sheathing" "DontChange"
```

- [ ] **Step 2:** simular: `perl "$P/Design/Rework/tools/stats_add.pl" "$P/Design/Rework/aspect/00_common.patch" "$P/Design/Rework/aspect/10_fool.patch"`.
Expected: 14 `loca +` e 4 `loca ~` do Fool; 9 `txt +`; 5 `set`; Rush e Interrupt `(fim)`; nenhum `die`. Um `die` por campo sem tipo (ex.: `TooltipAttackSave` em `SpellData/Rush`) indica que o tipo tem de vir do vanilla: conferir se o `learn` leu `Editor/Mods/Shared/Stats/SpellData/Rush.stats`.
- [ ] **Step 3:** aplicar com `--apply`.
- [ ] **Step 4:** criar `ARCANA_Aspect_Fool.txt` (CRLF):

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION

KBSECTION
// The Fool (Unbound). Objetivo Wanderlust: a passiva Arcana_Passive_Aspect_Fool_I marca o inimigo
// (WANDERLUST_MARK) e avisa com WANDERLUST_HIT_TECH a cada golpe desarmado num inimigo ainda nao marcado.
// A marca vale ate o proximo turno do Unbound, entao um inimigo conta uma vez por turno.

//REGION Objetivo
IF
StatusApplied((CHARACTER)_Unbound, "WANDERLUST_HIT_TECH", _, _)
THEN
PROC_ARCANA_Aspect_Step(_Unbound, "FOOL");

IF
StatusApplied((CHARACTER)_Foe, "WANDERLUST_MARK", (CHARACTER)_Unbound, _)
THEN
DB_ARCANA_WanderlustMark(_Unbound, _Foe);

IF
TurnStarted((CHARACTER)_Unbound)
AND
DB_ARCANA_WanderlustMark(_Unbound, _Foe)
THEN
NOT DB_ARCANA_WanderlustMark(_Unbound, _Foe);
RemoveStatus(_Foe, "WANDERLUST_MARK", _Unbound);
//END_REGION

//REGION Tier II: Zephyr sem Bonus Action uma vez por turno
PROC
PROC_ARCANA_Aspect_OnAwakened((CHARACTER)_Unbound, (STRING)_Aspect)
AND
_Aspect == "FOOL"
AND
HasPassive(_Unbound, "Arcana_Passive_Aspect_Fool_II", 1)
THEN
ApplyStatus(_Unbound, "FOOL_ZEPHYR_FREE", 6.0, 1, _Unbound);

IF
TurnStarted((CHARACTER)_Unbound)
AND
HasActiveStatus(_Unbound, "ASPECT_AWAKENED_FOOL", 1)
AND
HasPassive(_Unbound, "Arcana_Passive_Aspect_Fool_II", 1)
THEN
ApplyStatus(_Unbound, "FOOL_ZEPHYR_FREE", 6.0, 1, _Unbound);

IF
CastedSpell((CHARACTER)_Unbound, _Spell, _, _, _)
AND
DB_ARCANA_CardFamily(_Spell, "Target_Arcana_Created_ZephyrStrike")
AND
HasActiveStatus(_Unbound, "FOOL_ZEPHYR_FREE", 1)
THEN
RemoveStatus(_Unbound, "FOOL_ZEPHYR_FREE", _Unbound);
//END_REGION

//REGION Limpeza
PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Unbound)
AND
DB_ARCANA_WanderlustMark(_Unbound, _Foe)
THEN
NOT DB_ARCANA_WanderlustMark(_Unbound, _Foe);
RemoveStatus(_Foe, "WANDERLUST_MARK", _Unbound);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Unbound)
THEN
RemoveStatus(_Unbound, "FOOL_ZEPHYR_FREE", _Unbound);
//END_REGION
EXITSECTION

ENDEXITSECTION
```

- [ ] **Step 5:** CRLF (mesmo comando da Task 2 Step 3) e confirmar que o Zephyr está na tabela de famílias: `grep -c 'DB_ARCANA_CardFamily("Target_Arcana_Created_ZephyrStrike' "$G/Mods/$M/Story/RawFiles/Goals/ARCANA_CardFamilies.txt"` → espera 6.

---

### Task 4: The Empress (Deceiver)

**Files:**
- Create: `$P/Design/Rework/aspect/20_empress.patch`
- Create: `$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Empress.txt`

**Interfaces:**
- Consumes: Task 2; `SIGIL` e `ARCANA_Status_Sigil.txt` (a marca já nasce em nome do Deceiver dono).
- Produces: `Arcana_Passive_Aspect_Empress_I/_II/_III`; recurso `ArcanaBeloved`; carta `Shout_Arcana_Created_Aspect_Heartbreak`; status `ASPECT_AWAKENED_EMPRESS`.

- [ ] **Step 1:** criar `20_empress.patch`:

```
# ===== The Empress (Deceiver) =====
@loca EMPRESS_I_NAME 3 - The Empress: Obsession
@loca EMPRESS_I_DESC Detonate 3 of your <LSTag Type="Status" Tooltip="SIGIL">Sigils</LSTag> during combat to awaken the Aspect of Love until combat ends.<br><br>While awakened, creatures marked with your Sigil have <LSTag Tooltip="Disadvantage">Disadvantage</LSTag> on <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag> against you.
@loca EMPRESS_II_NAME 3 - The Empress: Devotion
@loca EMPRESS_II_DESC While your Aspect of Love is awakened, once per turn, when one of your <LSTag Type="Status" Tooltip="SIGIL">Sigils</LSTag> detonates, the nearest unmarked enemy within [1] of it is marked with a Sigil.
@loca EMPRESS_III_NAME 3 - The Empress: Aspect of Love
@loca EMPRESS_III_DESC While your Aspect of Love is awakened, your Charisma increases by [1] and your Arcane spells add your Charisma Modifier to their damage. Once per round, the first enemy that attacks you must succeed a Wisdom <LSTag Tooltip="SavingThrow">Saving Throw</LSTag> or be <LSTag Type="Status" Tooltip="CHARMED">Charmed</LSTag> for 1 turn.
@loca EMPRESS_AWAKENED_NAME 3 - The Empress
@loca EMPRESS_AWAKENED_DESC Awakened as the Aspect of Love until combat ends.
@loca EMPRESS_PROGRESS_NAME Obsession
@loca EMPRESS_PROGRESS_DESC Progress towards awakening the Aspect of Love. Awakens at 3.
@loca BELOVED_NAME Beloved
@loca BELOVED_DESC Once per round, the first enemy that attacks you must succeed a Wisdom <LSTag Tooltip="SavingThrow">Saving Throw</LSTag> or be <LSTag Type="Status" Tooltip="CHARMED">Charmed</LSTag> for 1 turn.
@loca HEARTBREAK_NAME Heartbreak
@loca HEARTBREAK_DESC Detonate every <LSTag Type="Status" Tooltip="SIGIL">Sigil</LSTag> you have placed at once. Each marked creature is <LSTag Type="Status" Tooltip="CHARMED">Charmed</LSTag> for 1 turn.
@loca PARANOIA_NAME Paranoia
@loca PARANOIA_DESC Can't take <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reactions</LSTag>.
@loca FERVOUR_NAME Infatuated
@loca FERVOUR_DESC Has <LSTag Tooltip="Advantage">Advantage</LSTag> on the next <LSTag Tooltip="AttackRoll">Attack Roll</LSTag>.
@loca h358611e4gab01gee5dg782ag87ac7ba30c60 Invade a creature's mind with malicious whispers, imposing <LSTag Tooltip="Disadvantage">Disadvantage</LSTag> on its next <LSTag Tooltip="AttackRoll">Attack Roll</LSTag>. A creature marked with your <LSTag Type="Status" Tooltip="SIGIL">Sigil</LSTag> also can't take <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reactions</LSTag>.
@loca hf220ce90g2b6eg3f2cg1707gbbc0a6ea2bd3 Use your <LSTag Type="ActionResource" Tooltip="ReactionActionPoint">reaction</LSTag> to <LSTag Type="Status" Tooltip="CHARMED">Charm</LSTag> an enemy attacking you. They will attack a new target if possible, with <LSTag Tooltip="Advantage">Advantage</LSTag>.

@file Passive
@section DECEIVER PASSIVES

new entry "Arcana_Passive_Aspect_Empress_I"
type "PassiveData"
data "DisplayName" "{{EMPRESS_I_NAME}}"
data "Description" "{{EMPRESS_I_DESC}}"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Empress_II"
type "PassiveData"
data "DisplayName" "{{EMPRESS_II_NAME}}"
data "Description" "{{EMPRESS_II_DESC}}"
data "DescriptionParams" "Distance(6)"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Empress_III"
type "PassiveData"
data "DisplayName" "{{EMPRESS_III_NAME}}"
data "Description" "{{EMPRESS_III_DESC}}"
data "DescriptionParams" "3"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Empress_Awakened_III"
type "PassiveData"
data "DisplayName" "{{EMPRESS_III_NAME}}"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "IsHidden"
data "BoostConditions" "HasPassive('Arcana_Passive_Aspect_Empress_III', context.Source);"
data "Boosts" "Ability(Charisma,3);UnlockInterrupt(Interrupt_Arcana_Aspect_Beloved);ActionResource(ArcanaBeloved,1,0);"

# funcao custom (IsCardSpell) so dentro de IF, nunca em BoostConditions
new entry "Arcana_Passive_Aspect_Empress_Awakened_III_Damage"
type "PassiveData"
data "DisplayName" "{{EMPRESS_III_NAME}}"
data "Icon" "Spell_Necromancy_BestowCurse"
data "Properties" "IsHidden"
data "Boosts" "IF(HasPassive('Arcana_Passive_Aspect_Empress_III', context.Source) and (IsCardSpell() or IsArcanaCantrip())):DamageBonus(max(0, CharismaModifier));"

@file Status_BOOST
@section DECEIVER STATUS

new entry "ASPECT_PROGRESS_EMPRESS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{EMPRESS_PROGRESS_NAME}}"
data "Description" "{{EMPRESS_PROGRESS_DESC}}"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "ASPECT_PROGRESS_EMPRESS"
data "StackType" "Overwrite"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "FreezeDuration;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "ASPECT_AWAKENED_EMPRESS"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{EMPRESS_AWAKENED_NAME}}"
data "Description" "{{EMPRESS_AWAKENED_DESC}}"
data "Icon" "Spell_Necromancy_BestowCurse"
data "StackId" "ASPECT_AWAKENED_EMPRESS"
data "StackType" "Ignore"
data "Boosts" "UnlockSpell(Shout_Arcana_Created_Aspect_Heartbreak);"
data "Passives" "Arcana_Passive_Aspect_Empress_Awakened_III;Arcana_Passive_Aspect_Empress_Awakened_III_Damage"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "ForceOverhead;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"
data "StatusEffect" "d37fab67-6932-44c4-995e-f051d7027fc5"

new entry "SIGIL_DETONATED_TECH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "SIGIL_DETONATED_TECH"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "HEARTBREAK_TECH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "HEARTBREAK_TECH"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "WHISPERED_PARANOIA"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{PARANOIA_NAME}}"
data "Description" "{{PARANOIA_DESC}}"
data "Icon" "Spell_Enchantment_DissonantWhispers"
data "StackId" "WHISPERED_PARANOIA"
data "StackType" "Overwrite"
data "TickType" "StartTurn"
data "Boosts" "ActionResourceBlock(ReactionActionPoint);"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "INSTINCTIVE_CHARM_FERVOR"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{FERVOUR_NAME}}"
data "Description" "{{FERVOUR_DESC}}"
data "Icon" "PassiveFeature_InstinctiveCharm"
data "StackId" "INSTINCTIVE_CHARM_FERVOR"
data "StackType" "Overwrite"
data "TickType" "EndTurn"
data "Boosts" "Advantage(AttackRoll);"
data "RemoveConditions" "IsAttack()"
data "RemoveEvents" "OnAttack"
data "StatusGroups" "SG_RemoveOnRespec"

# Tier I no proprio SIGIL: quem carrega a marca ataca o dono dela com Desvantagem (padrao do Nemesis:
# no boost do atacante, context.Source = atacante, context.Target = vitima)
@set SIGIL Boosts IF(HasStatus('ASPECT_AWAKENED_EMPRESS', context.Target) and HasStatus('SIGIL', context.Source, context.Target)):Disadvantage(AttackRoll);
# a detonacao que da dano avisa o Osiris
@set SIGIL OnRemoveFunctors IF(not IsKillingBlow()):DealDamage(Cause.LevelMapValue(Sigil_MarkDamage),Psychic,Magical);IF(not IsKillingBlow()):ApplyStatus(SIGIL_DETONATED_TECH,100,0)
# a checagem da marca vem ANTES do dano, porque o dano detona a marca
@set Target_Arcana_Card_Spell_MaliciousWhispers SpellSuccess IF(HasStatus('SIGIL',context.Target,context.Source)):ApplyStatus(WHISPERED_PARANOIA,100,1);ApplyStatus(MALICIOUS_WHISPERS,100,1);DealDamage(LevelMapValue(D4Cantrip),Psychic,Magical);
@set Interrupt_Arcana_Reaction_InstinctiveCharm Success Counterspell();UseSpell(OBSERVER_SOURCE,Target_Arcana_Reaction_InstinctiveCharm,true,true,true);IF(HasAnyExtraAttack(context.Source)):ApplyStatus(SELF,EXTRA_ATTACK_Q,100,1);IF(not HasAnyExtraAttack(context.Source)):ApplyStatus(SELF,EXTRA_ATTACK,100,1);ApplyStatus(SELF,INSTINCTIVE_CHARM_FERVOR,100,1);

@file Interrupt
@section -

new entry "Interrupt_Arcana_Aspect_Beloved"
type "InterruptData"
data "DisplayName" "{{BELOVED_NAME}}"
data "Description" "{{BELOVED_DESC}}"
data "Icon" "PassiveFeature_InstinctiveCharm"
data "InterruptContext" "OnSpellCast"
data "InterruptContextScope" "Self"
data "Container" "YesNoDecision"
data "Conditions" "Self(context.Target,context.Observer) and HasStringInSpellRoll('Attack') and not AnyEntityIsItem()"
data "Roll" "not SavingThrow(Ability.Wisdom, SourceSpellDC(14,context.Observer,Ability.Intelligence),AdvantageOnCharmPerson(),false,context.Source)"
data "Success" "ApplyStatus(OBSERVER_SOURCE,CHARMED,100,1)"
data "Cost" "ArcanaBeloved:1"
data "InterruptDefaultValue" "Ask;Enabled"
data "EnableCondition" "HasActionResource('ArcanaBeloved', 1, 0, false, false, context.Source);"
data "EnableContext" "OnActionResourcesChanged"

@file Spell_Shout
@section Shout_DECEIVER SPELLS

new entry "Shout_Arcana_Created_Aspect_Heartbreak"
type "SpellData"
data "SpellType" "Shout"
data "Level" "0"
data "SpellSchool" "Enchantment"
data "Cooldown" "OncePerCombat"
data "SpellProperties" "ApplyStatus(HEARTBREAK_TECH,100,1);IF(HasStatus('HEARTBREAK_TECH')):ApplyStatus(CHARMED,100,1)"
data "AreaRadius" "18"
data "TargetConditions" "Character() and Enemy() and not Dead() and HasStatus('SIGIL', context.Target, context.Source) and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Spell_Necromancy_BestowCurse"
data "DisplayName" "{{HEARTBREAK_NAME}}"
data "Description" "{{HEARTBREAK_DESC}}"
data "TooltipStatusApply" "ApplyStatus(CHARMED,100,1)"
data "CastSound" "Spell_Cast_Monk_WholenessOfBody_L1to3"
data "PreviewCursor" "Cast"
data "CastTextEvent" "Cast"
data "UseCosts" "ActionPoint:1;"
data "SpellAnimation" "355a5479-07c9-4a34-9ab6-3b2669fdd248,,;,,;2ac8ee64-6d74-4cad-a74c-660ef3fc3d06,,;5bf6f6e6-353e-40f9-9a6f-0d6d16e19496,,;1c5627cb-6352-454b-9b84-c5b10ef2d201,,;,,;1cc6ba3b-fa78-48f8-858c-ac4c78fdb8fc,,;,,;,,"
data "VerbalIntent" "Control"
data "SpellStyleGroup" "Class"
data "SpellFlags" "IsSpell;IsHarmful;HasVerbalComponent"
data "HitAnimationType" "None"
data "Requirements" "Combat"
```

- [ ] **Step 2:** simular os patches 00+10+20 juntos (o 10 já aplicado só gera `~` sem mudança real); aplicar.
- [ ] **Step 3:** criar `ARCANA_Aspect_Empress.txt` (CRLF):

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION

KBSECTION
// The Empress (Deceiver). Objetivo Obsession: cada detonacao de Sigil que da dano aplica
// SIGIL_DETONATED_TECH na vitima (OnRemoveFunctors do SIGIL). O dono da marca vem da DB abaixo, porque a
// origem de um status aplicado num OnRemoveFunctors nao e garantida.

//REGION Dono de cada marca (ARCANA_Status_Sigil.txt ja aplica a SIGIL em nome do Deceiver, clone incluso)
IF
StatusApplied((CHARACTER)_Foe, "SIGIL", (CHARACTER)_Owner, _)
THEN
PROC_ARCANA_Empress_SetOwner(_Foe, _Owner);

PROC
PROC_ARCANA_Empress_SetOwner((CHARACTER)_Foe, (CHARACTER)_Owner)
AND
DB_ARCANA_SigilOwner(_Foe, _Old)
THEN
NOT DB_ARCANA_SigilOwner(_Foe, _Old);

PROC
PROC_ARCANA_Empress_SetOwner((CHARACTER)_Foe, (CHARACTER)_Owner)
THEN
DB_ARCANA_SigilOwner(_Foe, _Owner);
//END_REGION

//REGION Objetivo e Tier II
IF
StatusApplied((CHARACTER)_Foe, "SIGIL_DETONATED_TECH", _, _)
AND
DB_ARCANA_SigilOwner(_Foe, _Deceiver)
THEN
NOT DB_ARCANA_SigilOwner(_Foe, _Deceiver);
PROC_ARCANA_Aspect_Step(_Deceiver, "EMPRESS");
PROC_ARCANA_Empress_Chain(_Deceiver, _Foe);

// Tier II: a marca passa para o inimigo nao marcado mais proximo a ate 6 m, uma vez por turno, e nunca a
// partir de uma detonacao do Heartbreak
PROC
PROC_ARCANA_Empress_Chain((CHARACTER)_Deceiver, (CHARACTER)_From)
AND
HasActiveStatus(_Deceiver, "ASPECT_AWAKENED_EMPRESS", 1)
AND
HasPassive(_Deceiver, "Arcana_Passive_Aspect_Empress_II", 1)
AND
NOT DB_ARCANA_EmpressChained(_Deceiver)
AND
HasActiveStatus(_From, "HEARTBREAK_TECH", 0)
AND
DB_ARCANA_Aspect_InCombat(_Deceiver, _Combat)
THEN
PROC_ARCANA_Empress_ClearBest(_Deceiver);
PROC_ARCANA_Empress_Consider(_Deceiver, _From, _Combat);
PROC_ARCANA_Empress_Mark(_Deceiver);

PROC
PROC_ARCANA_Empress_ClearBest((CHARACTER)_Deceiver)
AND
DB_ARCANA_EmpressBest(_Deceiver, _Cand, _Dist)
THEN
NOT DB_ARCANA_EmpressBest(_Deceiver, _Cand, _Dist);

PROC
PROC_ARCANA_Empress_Consider((CHARACTER)_Deceiver, (CHARACTER)_From, (GUIDSTRING)_Combat)
AND
DB_ARCANA_Aspect_InCombat(_Cand, _Combat)
AND
_Cand != _From
AND
IsEnemy(_Deceiver, _Cand, 1)
AND
IsDead(_Cand, 0)
AND
HasActiveStatus(_Cand, "SIGIL", 0)
AND
GetDistanceTo(_From, _Cand, _Dist)
AND
_Dist <= 6.0
THEN
PROC_ARCANA_Empress_Offer(_Deceiver, _Cand, _Dist);

PROC
PROC_ARCANA_Empress_Offer((CHARACTER)_Deceiver, (CHARACTER)_Cand, (REAL)_Dist)
AND
DB_ARCANA_EmpressBest(_Deceiver, _Old, _OldDist)
AND
_Dist < _OldDist
THEN
NOT DB_ARCANA_EmpressBest(_Deceiver, _Old, _OldDist);
DB_ARCANA_EmpressBest(_Deceiver, _Cand, _Dist);

PROC
PROC_ARCANA_Empress_Offer((CHARACTER)_Deceiver, (CHARACTER)_Cand, (REAL)_Dist)
AND
NOT DB_ARCANA_EmpressBest(_Deceiver, _, _)
THEN
DB_ARCANA_EmpressBest(_Deceiver, _Cand, _Dist);

PROC
PROC_ARCANA_Empress_Mark((CHARACTER)_Deceiver)
AND
DB_ARCANA_EmpressBest(_Deceiver, _Cand, _Dist)
THEN
NOT DB_ARCANA_EmpressBest(_Deceiver, _Cand, _Dist);
DB_ARCANA_EmpressChained(_Deceiver);
ApplyStatus(_Cand, "SIGIL", -6.0, 1, _Deceiver);

IF
TurnStarted((CHARACTER)_Deceiver)
AND
DB_ARCANA_EmpressChained(_Deceiver)
THEN
NOT DB_ARCANA_EmpressChained(_Deceiver);
//END_REGION

//REGION Limpeza
PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_EmpressChained(_Char)
THEN
NOT DB_ARCANA_EmpressChained(_Char);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_SigilOwner(_Foe, _Char)
THEN
NOT DB_ARCANA_SigilOwner(_Foe, _Char);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_SigilOwner(_Char, _Owner)
THEN
NOT DB_ARCANA_SigilOwner(_Char, _Owner);
//END_REGION
EXITSECTION

ENDEXITSECTION
```

- [ ] **Step 4:** CRLF.

---

### Task 5: The Star (Starchild)

**Files:**
- Create: `$P/Design/Rework/aspect/30_star.patch`
- Create: `$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Star.txt`

**Interfaces:**
- Consumes: Task 2; `LUNAR_WISP` e `LUNAR_WISP_TECHNICAL` (THP por duração).
- Produces: `Arcana_Passive_Aspect_Star_I/_II/_III`; carta `Shout_Arcana_Created_Aspect_WishUponAStar`; status `ASPECT_AWAKENED_STAR`; arquivo novo `Status_DOWNED.txt`.

- [ ] **Step 1:** criar `30_star.patch`:

```
# ===== The Star (Starchild) =====
@loca STAR_I_NAME 17 - The Star: Beacon
@loca STAR_I_DESC Heal your allies during combat to awaken the Aspect of Hope until combat ends. Healing beyond an ally's maximum <LSTag Tooltip="HitPoints">hit points</LSTag> doesn't count.<br><br>While awakened, allies you heal or target with an Arcane spell deal an additional [1] with their next attack.
@loca STAR_I_EXTRA The healing needed is 5 times your level.
@loca STAR_II_NAME 17 - The Star: Sunrise
@loca STAR_II_DESC While your Aspect of Hope is awakened, allies you heal or target with an Arcane spell also deal an additional [1] with their next attack, and once per round an ally you heal regains a <LSTag Type="ActionResource" Tooltip="BonusActionPoint">bonus action</LSTag>.
@loca STAR_III_NAME 17 - The Star: Aspect of Hope
@loca STAR_III_DESC While your Aspect of Hope is awakened, your Wisdom increases by [1] and you can Fly. The first ally who would be downed during the fight instead regains half their <LSTag Tooltip="HitPoints">hit points</LSTag> and gains <LSTag Tooltip="TemporaryHitPoints">temporary hit points</LSTag>.
@loca STAR_AWAKENED_NAME 17 - The Star
@loca STAR_AWAKENED_DESC Awakened as the Aspect of Hope until combat ends.
@loca STAR_PROGRESS_NAME Beacon
@loca STAR_PROGRESS_DESC Progress towards awakening the Aspect of Hope. Awakens at 3.
@loca MOONLIT_NAME Moonlit
@loca MOONLIT_DESC The next attack deals an additional [1].
@loca SUNLIT_NAME Sunlit
@loca SUNLIT_DESC The next attack deals an additional [1].
@loca WISHSTAR_NAME Wish Upon a Star
@loca WISHSTAR_DESC Grant your allies within [1] <LSTag Tooltip="Advantage">Advantage</LSTag> on their next <LSTag Tooltip="AttackRoll">Attack Roll</LSTag>.
@loca WISHSTAR_STATUS_DESC Has <LSTag Tooltip="Advantage">Advantage</LSTag> on the next <LSTag Tooltip="AttackRoll">Attack Roll</LSTag>.
@loca HOPE_NAME Undying Hope
@loca HOPE_DESC The first time this creature would be downed during this fight, it instead regains half its <LSTag Tooltip="HitPoints">hit points</LSTag>.

@file Passive
@section STARCHILD PASSIVES

new entry "Arcana_Passive_Aspect_Star_I"
type "PassiveData"
data "DisplayName" "{{STAR_I_NAME}}"
data "Description" "{{STAR_I_DESC}}"
data "DescriptionParams" "DealDamage(1d4,Cold)"
data "ExtraDescription" "{{STAR_I_EXTRA}}"
data "Icon" "Spell_Evocation_DancingLights"
data "Properties" "Highlighted"
data "StatsFunctorContext" "OnHeal"
data "Conditions" "Combat() and not Self() and HealDoneGreaterThan(0) and not HasStatus('ASPECT_AWAKENED_STAR', context.Source);"
data "StatsFunctors" "ApplyStatus(BEACON_HEAL_TECH,100,1)"

new entry "Arcana_Passive_Aspect_Star_II"
type "PassiveData"
data "DisplayName" "{{STAR_II_NAME}}"
data "Description" "{{STAR_II_DESC}}"
data "DescriptionParams" "DealDamage(1d4,Fire)"
data "Icon" "Spell_Evocation_DancingLights"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Star_III"
type "PassiveData"
data "DisplayName" "{{STAR_III_NAME}}"
data "Description" "{{STAR_III_DESC}}"
data "DescriptionParams" "3"
data "Icon" "Spell_Evocation_DancingLights"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Star_Awakened_Heal"
type "PassiveData"
data "DisplayName" "{{STAR_I_NAME}}"
data "Icon" "Spell_Evocation_DancingLights"
data "Properties" "IsHidden"
data "StatsFunctorContext" "OnHeal"
data "Conditions" "not Self() and HealDoneGreaterThan(0);"
data "StatsFunctors" "ApplyStatus(STAR_MOONLIT,100,2);IF(HasPassive('Arcana_Passive_Aspect_Star_II', context.Source)):ApplyStatus(STAR_SUNLIT,100,2);IF(HasPassive('Arcana_Passive_Aspect_Star_II', context.Source) and not HasStatus('STAR_REFRESHED')):RestoreResource(BonusActionPoint,1,0);IF(HasPassive('Arcana_Passive_Aspect_Star_II', context.Source)):ApplyStatus(STAR_REFRESHED,100,1)"

new entry "Arcana_Passive_Aspect_Star_Awakened_III"
type "PassiveData"
data "DisplayName" "{{STAR_III_NAME}}"
data "Icon" "Spell_Evocation_DancingLights"
data "Properties" "IsHidden"
data "BoostConditions" "HasPassive('Arcana_Passive_Aspect_Star_III', context.Source);"
data "Boosts" "Ability(Wisdom,3);UnlockSpell(Projectile_Fly_Spell);"

@file Status_BOOST
@section STARCHILD STATUS

new entry "ASPECT_PROGRESS_STAR"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{STAR_PROGRESS_NAME}}"
data "Description" "{{STAR_PROGRESS_DESC}}"
data "Icon" "Spell_Evocation_DancingLights"
data "StackId" "ASPECT_PROGRESS_STAR"
data "StackType" "Overwrite"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "FreezeDuration;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "ASPECT_AWAKENED_STAR"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{STAR_AWAKENED_NAME}}"
data "Description" "{{STAR_AWAKENED_DESC}}"
data "Icon" "Spell_Evocation_DancingLights"
data "StackId" "ASPECT_AWAKENED_STAR"
data "StackType" "Ignore"
data "Boosts" "UnlockSpell(Shout_Arcana_Created_Aspect_WishUponAStar);"
data "Passives" "Arcana_Passive_Aspect_Star_Awakened_Heal;Arcana_Passive_Aspect_Star_Awakened_III"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "ForceOverhead;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"
data "StatusEffect" "61fe31f9-ae4b-4926-a033-e56ea67c7d92"

new entry "BEACON_HEAL_TECH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "BEACON_HEAL_TECH"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "STAR_MOONLIT"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{MOONLIT_NAME}}"
data "Description" "{{MOONLIT_DESC}}"
data "DescriptionParams" "DealDamage(1d4,Cold)"
data "Icon" "Spell_Evocation_DancingLights"
data "StackId" "STAR_MOONLIT"
data "StackType" "Overwrite"
data "Boosts" "IF(IsAttack()):DamageBonus(1d4,Cold);"
data "RemoveConditions" "IsAttack()"
data "RemoveEvents" "OnAttack"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "STAR_SUNLIT"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{SUNLIT_NAME}}"
data "Description" "{{SUNLIT_DESC}}"
data "DescriptionParams" "DealDamage(1d4,Fire)"
data "Icon" "Spell_Evocation_DancingLights"
data "StackId" "STAR_SUNLIT"
data "StackType" "Overwrite"
data "Boosts" "IF(IsAttack()):DamageBonus(1d4,Fire);"
data "RemoveConditions" "IsAttack()"
data "RemoveEvents" "OnAttack"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "STAR_REFRESHED"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "STAR_REFRESHED"
data "StackType" "Overwrite"
data "TickType" "StartTurn"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "WISH_UPON_A_STAR"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{WISHSTAR_NAME}}"
data "Description" "{{WISHSTAR_STATUS_DESC}}"
data "Icon" "Spell_Evocation_DancingLights"
data "StackId" "WISH_UPON_A_STAR"
data "StackType" "Overwrite"
data "Boosts" "Advantage(AttackRoll);"
data "RemoveConditions" "IsAttack()"
data "RemoveEvents" "OnAttack"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "UNDYING_HOPE"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{HOPE_NAME}}"
data "Description" "{{HOPE_DESC}}"
data "Icon" "Spell_Evocation_DancingLights"
data "StackId" "UNDYING_HOPE"
data "StackType" "Ignore"
data "Boosts" "DownedStatus(UNDYING_HOPE_DOWNED,10)"
data "RemoveEvents" "OnCombatEnded"
data "StatusGroups" "SG_RemoveOnRespec"

@file Status_DOWNED
@section -

# molde: DEATH_WARD_DOWNED do vanilla (SharedDev)
new entry "UNDYING_HOPE_DOWNED"
type "StatusData"
data "StatusType" "DOWNED"
using "SURVIVAL_INSTINCT_DOWNED"
data "DisplayName" "{{HOPE_NAME}}"
data "Description" ""
data "Icon" "Spell_Evocation_DancingLights"
data "AnimationStart" "7e811df9-74e7-4515-bd02-7043164dbf33(STAT_Fallen_Peace_01_Start)"
data "AnimationLoop" "d7b7cf53-fe71-4a23-8011-9675a6e1d902(STAT_Fallen_Peace_01_Loop)"
data "AnimationEnd" "ade4cf7f-a34a-40c4-b810-096f0c186bc2(STAT_Fallen_Peace_01_End)"
data "StatusPropertyFlags" "DisableCombatlog;DisablePortraitIndicator"
data "OnApplyFunctors" "RemoveStatus(UNDYING_HOPE);RegainHitPoints(MaxHP/2,Guaranteed)"
data "StatusGroups" "SG_Incapacitated"
data "ApplyEffect" "5508ea40-3f23-436d-980d-0b8143f6e2f3"
data "HideOverheadUI" "1"

@file Spell_Shout
@section Shout_STARCHILD SPELLS

new entry "Shout_Arcana_Created_Aspect_WishUponAStar"
type "SpellData"
data "SpellType" "Shout"
data "Level" "0"
data "SpellSchool" "Evocation"
data "Cooldown" "OncePerCombat"
data "SpellProperties" "ApplyStatus(WISH_UPON_A_STAR,100,2)"
data "AreaRadius" "18"
data "TargetConditions" "Ally() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Spell_Evocation_DancingLights"
data "DisplayName" "{{WISHSTAR_NAME}}"
data "Description" "{{WISHSTAR_DESC}}"
data "DescriptionParams" "Distance(18)"
data "TooltipStatusApply" "ApplyStatus(WISH_UPON_A_STAR,100,2)"
data "CastSound" "Spell_Cast_Monk_WholenessOfBody_L1to3"
data "TargetSound" "Spell_Impact_Healing_MassHealingWord_L1to3"
data "PreviewCursor" "Cast"
data "CastTextEvent" "Cast"
data "UseCosts" "ActionPoint:1;"
data "SpellAnimation" "355a5479-07c9-4a34-9ab6-3b2669fdd248,,;,,;2ac8ee64-6d74-4cad-a74c-660ef3fc3d06,,;5bf6f6e6-353e-40f9-9a6f-0d6d16e19496,,;1c5627cb-6352-454b-9b84-c5b10ef2d201,,;,,;1cc6ba3b-fa78-48f8-858c-ac4c78fdb8fc,,;,,;,,"
data "VerbalIntent" "Buff"
data "SpellStyleGroup" "Class"
data "SpellFlags" "IsSpell;HasVerbalComponent;HasSomaticComponent"
data "HitAnimationType" "None"
data "Requirements" "Combat"
```

- [ ] **Step 2:** simular os patches até o 30 e aplicar.
- [ ] **Step 3:** criar `ARCANA_Aspect_Star.txt` (CRLF):

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION

KBSECTION
// The Star (Starchild). Objetivo Beacon: a passiva Arcana_Passive_Aspect_Star_I aplica BEACON_HEAL_TECH
// em quem o Starchild cura. Aqui a diferenca de HP de cada personagem e acompanhada; uma subida com o
// status tecnico ativo vira cura efetiva (o excesso nao sobe o HP, entao nao conta). Meta: nivel x 5.

//REGION HP de referencia
IF
EnteredCombat((CHARACTER)_Char, _)
AND
GetHitpoints(_Char, _HP)
THEN
PROC_ARCANA_Star_SetHP(_Char, _HP);

PROC
PROC_ARCANA_Star_SetHP((CHARACTER)_Char, (INTEGER)_HP)
AND
DB_ARCANA_StarHP(_Char, _Old)
THEN
NOT DB_ARCANA_StarHP(_Char, _Old);

PROC
PROC_ARCANA_Star_SetHP((CHARACTER)_Char, (INTEGER)_HP)
THEN
DB_ARCANA_StarHP(_Char, _HP);
//END_REGION

//REGION Cura efetiva (os dois ordenamentos possiveis do evento e do status)
IF
HitpointsChanged((CHARACTER)_Char, _)
AND
DB_ARCANA_StarHP(_Char, _Old)
AND
GetHitpoints(_Char, _New)
THEN
PROC_ARCANA_Star_Credit(_Char, _Old, _New);
PROC_ARCANA_Star_SetHP(_Char, _New);

IF
HitpointsChanged((CHARACTER)_Char, _)
AND
NOT DB_ARCANA_StarHP(_Char, _)
AND
GetHitpoints(_Char, _HP)
THEN
PROC_ARCANA_Star_SetHP(_Char, _HP);

IF
StatusApplied((CHARACTER)_Char, "BEACON_HEAL_TECH", _, _)
AND
DB_ARCANA_StarHP(_Char, _Old)
AND
GetHitpoints(_Char, _New)
THEN
PROC_ARCANA_Star_Credit(_Char, _Old, _New);
PROC_ARCANA_Star_SetHP(_Char, _New);

PROC
PROC_ARCANA_Star_Credit((CHARACTER)_Char, (INTEGER)_Old, (INTEGER)_New)
AND
_New > _Old
AND
HasActiveStatus(_Char, "BEACON_HEAL_TECH", 1)
AND
IntegerSubtract(_New, _Old, _Gain)
THEN
RemoveStatus(_Char, "BEACON_HEAL_TECH", _Char);
PROC_ARCANA_Star_AddHealed(_Char, _Gain);

PROC
PROC_ARCANA_Star_AddHealed((CHARACTER)_Char, (INTEGER)_Gain)
AND
DB_ARCANA_Aspect_InCombat(_Char, _Combat)
AND
DB_ARCANA_Aspect_InCombat(_Star, _Combat)
AND
HasPassive(_Star, "Arcana_Passive_Aspect_Star_I", 1)
AND
HasActiveStatus(_Star, "ASPECT_AWAKENED_STAR", 0)
THEN
PROC_ARCANA_Star_Bank(_Star, _Gain);

PROC
PROC_ARCANA_Star_Bank((CHARACTER)_Star, (INTEGER)_Gain)
AND
NOT DB_ARCANA_StarHealed(_Star, _)
THEN
DB_ARCANA_StarHealed(_Star, 0);

PROC
PROC_ARCANA_Star_Bank((CHARACTER)_Star, (INTEGER)_Gain)
AND
DB_ARCANA_StarHealed(_Star, _Old)
AND
IntegerSum(_Old, _Gain, _Sum)
THEN
NOT DB_ARCANA_StarHealed(_Star, _Old);
DB_ARCANA_StarHealed(_Star, _Sum);
PROC_ARCANA_Star_Measure(_Star, _Sum);

// passos = cura x 3 / (nivel x 5), teto 3 no Advance
PROC
PROC_ARCANA_Star_Measure((CHARACTER)_Star, (INTEGER)_Sum)
AND
GetLevel(_Star, _Level)
AND
IntegerProduct(_Level, 5, _Goal)
AND
IntegerProduct(_Sum, 3, _Sum3)
AND
IntegerDivide(_Sum3, _Goal, _Steps)
THEN
PROC_ARCANA_Aspect_Advance(_Star, "STAR", _Steps);
//END_REGION

//REGION Carta num aliado: Moonlit (I) e Sunlit (II). A cura faz o mesmo pela passiva do status desperto.
IF
UsingSpellOnTarget((CHARACTER)_Star, (CHARACTER)_Ally, _Spell, _, _, _)
AND
HasActiveStatus(_Star, "ASPECT_AWAKENED_STAR", 1)
AND
DB_ARCANA_CardFamily(_Spell, _)
AND
_Ally != _Star
AND
IsAlly(_Star, _Ally, 1)
THEN
ApplyStatus(_Ally, "STAR_MOONLIT", 12.0, 1, _Star);
PROC_ARCANA_Star_Sunlit(_Star, _Ally);

PROC
PROC_ARCANA_Star_Sunlit((CHARACTER)_Star, (CHARACTER)_Ally)
AND
HasPassive(_Star, "Arcana_Passive_Aspect_Star_II", 1)
THEN
ApplyStatus(_Ally, "STAR_SUNLIT", 12.0, 1, _Star);
//END_REGION

//REGION Tier III: Undying Hope nos aliados do combate (o proprio Starchild incluso)
PROC
PROC_ARCANA_Aspect_OnAwakened((CHARACTER)_Star, (STRING)_Aspect)
AND
_Aspect == "STAR"
AND
HasPassive(_Star, "Arcana_Passive_Aspect_Star_III", 1)
AND
DB_ARCANA_Aspect_InCombat(_Star, _Combat)
AND
DB_ARCANA_Aspect_InCombat(_Ally, _Combat)
AND
IsAlly(_Star, _Ally, 1)
AND
IsDead(_Ally, 0)
THEN
PROC_ARCANA_Star_GiveHope(_Star, _Ally);

PROC
PROC_ARCANA_Aspect_OnAwakened((CHARACTER)_Star, (STRING)_Aspect)
AND
_Aspect == "STAR"
AND
HasPassive(_Star, "Arcana_Passive_Aspect_Star_III", 1)
THEN
PROC_ARCANA_Star_GiveHope(_Star, _Star);

PROC
PROC_ARCANA_Star_GiveHope((CHARACTER)_Star, (CHARACTER)_Ally)
THEN
DB_ARCANA_HopeGiver(_Ally, _Star);
ApplyStatus(_Ally, "UNDYING_HOPE", -1.0, 1, _Star);

// o primeiro que cai gasta a esperanca de todos, e ganha o THP do Lunar Wisp do Starchild
IF
StatusApplied((CHARACTER)_Saved, "UNDYING_HOPE_DOWNED", _, _)
AND
DB_ARCANA_HopeGiver(_Saved, _Star)
AND
DB_ARCANA_Aspect_InCombat(_Saved, _Combat)
THEN
PROC_ARCANA_Star_HopeSpent(_Combat);
PROC_ARCANA_Star_HopeWisp(_Saved, _Star);

PROC
PROC_ARCANA_Star_HopeSpent((GUIDSTRING)_Combat)
AND
DB_ARCANA_Aspect_InCombat(_Other, _Combat)
AND
DB_ARCANA_HopeGiver(_Other, _Star)
THEN
NOT DB_ARCANA_HopeGiver(_Other, _Star);
RemoveStatus(_Other, "UNDYING_HOPE", _Star);

// THP = nivel + 2 x modificador de Sabedoria (a formula do Lunar Wisp); o LUNAR_WISP multiplica pela duracao
PROC
PROC_ARCANA_Star_HopeWisp((CHARACTER)_Saved, (CHARACTER)_Star)
AND
GetLevel(_Star, _Level)
AND
GetAbility(_Star, "Wisdom", _Wis)
AND
IntegerSubtract(_Wis, 10, _Over)
AND
IntegerDivide(_Over, 2, _Mod)
AND
IntegerProduct(_Mod, 2, _Mod2)
AND
IntegerSum(_Level, _Mod2, _Raw)
AND
IntegerMax(_Raw, 1, _Thp)
AND
IntegerProduct(_Thp, 6, _Secs)
AND
IntegerToReal(_Secs, _Dur)
THEN
ApplyStatus(_Saved, "LUNAR_WISP", _Dur, 1, _Star);
ApplyStatus(_Saved, "LUNAR_WISP_TECHNICAL", 6.0, 1, _Star);
//END_REGION

//REGION Limpeza
PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_StarHealed(_Char, _N)
THEN
NOT DB_ARCANA_StarHealed(_Char, _N);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_StarHP(_Char, _HP)
THEN
NOT DB_ARCANA_StarHP(_Char, _HP);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_HopeGiver(_Char, _Star)
THEN
NOT DB_ARCANA_HopeGiver(_Char, _Star);
RemoveStatus(_Char, "UNDYING_HOPE", _Char);
//END_REGION
EXITSECTION

ENDEXITSECTION
```

- [ ] **Step 4:** CRLF.

---

### Task 6: Death (Eternal)

**Files:**
- Create: `$P/Design/Rework/aspect/40_death.patch`
- Create: `$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Death.txt`
- Create: `$G/Mods/$M/Scripts/thoth/helpers/IsIsolatedFoe.khn`
- Delete: `$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Passive_DarknessRise.txt`

**Interfaces:**
- Consumes: Task 2; `DARKNESS_RISE_AURA` (fica); `CRAWLING_GNAW_SWITCH` (vanilla, como no Hemoplague EX).
- Produces: `Arcana_Passive_Aspect_Death_I/_II/_III`; cartas `Target_Arcana_Created_Aspect_FinalToll` e `Shout_Arcana_Card_Spell_BloodOffering`; status `ASPECT_AWAKENED_DEATH`; `IsIsolatedFoe()`.

- [ ] **Step 1:** criar `IsIsolatedFoe.khn` (CRLF):

```lua
-- Tier II do Aspecto de Death (ETERNAL_DREAD_AURA). No functor da aura, context.Source e o Eternal e
-- context.Target e o inimigo dentro dela. O inimigo esta isolado quando e o unico inimigo do Eternal a
-- ate 3 m e nenhum aliado dele esta a ate 6 m. Usa os mesmos construtores do HasEnemyWithinRange e do
-- HasAllyWithinRange do CommonConditions.khn do vanilla.
function IsIsolatedFoe()
    local foes = GetEnemiesWithinRange(3, context.Source, context.Source)
    local friends = GetAlliesWithinRange(6, context.Target, context.Target)
    local foeCount = 0
    if foes ~= nil then foeCount = #foes.Enemies end
    local friendCount = 0
    if friends ~= nil then friendCount = #friends.Allies end
    return ConditionResult(foeCount <= 1 and friendCount == 0)
end
```

- [ ] **Step 2:** criar `40_death.patch`:

```
# ===== Death (Eternal) =====
@loca DEATH_I_NAME 13 - Death: Sorrow
@loca DEATH_I_DESC Lose <LSTag Tooltip="HitPoints">hit points</LSTag> equal to 30% of your hit point maximum during combat to awaken the Aspect of Sorrow until combat ends. Healing doesn't undo the loss.<br><br>While awakened, you emanate <LSTag Type="Status" Tooltip="DARKNESS_RISE_AURA">Darkness Rise</LSTag>.
@loca DEATH_II_NAME 13 - Death: Mourning
@loca DEATH_II_DESC While your Aspect of Sorrow is awakened, the first time you would drop to 0 <LSTag Tooltip="HitPoints">hit points</LSTag>, you drop to 1 instead, and an isolated enemy within [1] of you has <LSTag Tooltip="Disadvantage">Disadvantage</LSTag> on <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag> against you.
@loca DEATH_II_EXTRA An enemy is isolated when it is the only enemy within [1] of you and none of its allies is within [2] of it.
@loca DEATH_III_NAME 13 - Death: Aspect of Sorrow
@loca DEATH_III_DESC While your Aspect of Sorrow is awakened, your Constitution increases by [1]. Once per turn, when a hostile creature dies within [2] of you, you gain an additional action.
@loca DEATH_AWAKENED_NAME 13 - Death
@loca DEATH_AWAKENED_DESC Awakened as the Aspect of Sorrow until combat ends.
@loca DEATH_PROGRESS_NAME Sorrow
@loca DEATH_PROGRESS_DESC Progress towards awakening the Aspect of Sorrow. Awakens at 3.
@loca MOURNING_NAME Mourning
@loca MOURNING_DESC The first time this creature would drop to 0 <LSTag Tooltip="HitPoints">hit points</LSTag> during this fight, it drops to 1 instead.
@loca DREAD_NAME Dread
@loca DREAD_DESC Isolated and afraid. Has <LSTag Tooltip="Disadvantage">Disadvantage</LSTag> on <LSTag Tooltip="AttackRoll">Attack Rolls</LSTag> against the Eternal.
@loca HARVEST_NAME Harvest
@loca HARVEST_DESC Has an additional action.
@loca FINALTOLL_NAME The Final Toll
@loca FINALTOLL_DESC Turn your suffering on a foe, dealing [1] equal to the <LSTag Tooltip="HitPoints">hit points</LSTag> you have lost this combat, up to half your hit point maximum. A creature killed this way rises as a zombie.
@loca BLOOD_NAME Blood Offering
@loca BLOOD_DESC Open your veins to the dark. Lose a tenth of your hit point maximum, and your Arcane spells deal an additional [1] until the end of your turn.
@loca BLOOD_STATUS_DESC Arcane spells deal an additional [1].
@loca h91f28c87g52b1g5bccg9ba6g7f8c47b3c9e1 Death is your domain. Protect an ally from it. The next time damage would reduce the ally to 0 <LSTag Tooltip="HitPoints">hit points</LSTag>, they remain conscious with 1 hit point left.

@file Passive
@section ETERNAL PASSIVES

@remove Arcana_Passive_DarknessRise

new entry "Arcana_Passive_Aspect_Death_I"
type "PassiveData"
data "DisplayName" "{{DEATH_I_NAME}}"
data "Description" "{{DEATH_I_DESC}}"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Death_II"
type "PassiveData"
data "DisplayName" "{{DEATH_II_NAME}}"
data "Description" "{{DEATH_II_DESC}}"
data "DescriptionParams" "Distance(3)"
data "ExtraDescription" "{{DEATH_II_EXTRA}}"
data "ExtraDescriptionParams" "Distance(3);Distance(6)"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Death_III"
type "PassiveData"
data "DisplayName" "{{DEATH_III_NAME}}"
data "Description" "{{DEATH_III_DESC}}"
data "DescriptionParams" "3;Distance(9)"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "Properties" "Highlighted"

new entry "Arcana_Passive_Aspect_Death_Awakened_III"
type "PassiveData"
data "DisplayName" "{{DEATH_III_NAME}}"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "Properties" "IsHidden"
data "BoostConditions" "HasPassive('Arcana_Passive_Aspect_Death_III', context.Source);"
data "Boosts" "Ability(Constitution,3);"

@file Status_BOOST
@section ETERNAL STATUS

@remove DARKNESS_RISE_ACTIVE
@remove DARKNESS_RISE_TECH_1
@remove DARKNESS_RISE_TECH_2

new entry "ASPECT_PROGRESS_DEATH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{DEATH_PROGRESS_NAME}}"
data "Description" "{{DEATH_PROGRESS_DESC}}"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "StackId" "ASPECT_PROGRESS_DEATH"
data "StackType" "Overwrite"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "FreezeDuration;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"

# sem StatusEffect: o Tier I e a aura do Darkness Rise, que ja tem o seu
new entry "ASPECT_AWAKENED_DEATH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{DEATH_AWAKENED_NAME}}"
data "Description" "{{DEATH_AWAKENED_DESC}}"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "StackId" "ASPECT_AWAKENED_DEATH"
data "StackType" "Ignore"
data "Boosts" "UnlockSpell(Target_Arcana_Created_Aspect_FinalToll);"
data "Passives" "Arcana_Passive_Aspect_Death_Awakened_III"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "ForceOverhead;IgnoreResting"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "ETERNAL_UNDYING"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{MOURNING_NAME}}"
data "Description" "{{MOURNING_DESC}}"
data "Icon" "Spell_Abjuration_DeathWard"
data "StackId" "ETERNAL_UNDYING"
data "StackType" "Ignore"
data "Boosts" "DownedStatus(ETERNAL_UNDYING_DOWNED,10)"
data "RemoveEvents" "OnCombatEnded"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "ETERNAL_DREAD_AURA"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "ETERNAL_DREAD_AURA"
data "StackType" "Ignore"
data "AuraRadius" "3"
data "AuraStatuses" "TARGET:IF(Enemy() and not Dead() and IsIsolatedFoe()):ApplyStatus(ETERNAL_DREAD,100,1)"
data "RemoveEvents" "OnCombatEnded"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "ETERNAL_DREAD"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{DREAD_NAME}}"
data "Description" "{{DREAD_DESC}}"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "StackId" "ETERNAL_DREAD"
data "StackType" "Overwrite"
data "Boosts" "IF(HasStatus('ETERNAL_DREAD', context.Source, context.Target)):Disadvantage(AttackRoll);"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "HARVEST_ACTION"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{HARVEST_NAME}}"
data "Description" "{{HARVEST_DESC}}"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "StackId" "HARVEST_ACTION"
data "StackType" "Overwrite"
data "TickType" "EndTurn"
data "Boosts" "ActionResource(ActionPoint,1,0)"
data "StatusGroups" "SG_RemoveOnRespec"

new entry "HARVEST_SPENT"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "HARVEST_SPENT"
data "StackType" "Overwrite"
data "TickType" "StartTurn"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "FINAL_TOLL_TECH"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{ASPECT_TECH_NAME}}"
data "StackId" "FINAL_TOLL_TECH"
data "StackType" "Overwrite"
data "StatusPropertyFlags" "DisableOverhead;DisableCombatlog;DisablePortraitIndicator"

new entry "BLOOD_OFFERING"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "{{BLOOD_NAME}}"
data "Description" "{{BLOOD_STATUS_DESC}}"
data "DescriptionParams" "DealDamage(LevelMapValue(DeathsGrasp_Damage),Necrotic)"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "StackId" "BLOOD_OFFERING"
data "StackType" "Overwrite"
data "TickType" "EndTurn"
data "Boosts" "IF(IsCardSpell() or IsArcanaCantrip()):DamageBonus(LevelMapValue(DeathsGrasp_Damage),Necrotic);"
data "StatusGroups" "SG_RemoveOnRespec"

@file Status_DOWNED
@section -

new entry "ETERNAL_UNDYING_DOWNED"
type "StatusData"
data "StatusType" "DOWNED"
using "SURVIVAL_INSTINCT_DOWNED"
data "DisplayName" "{{MOURNING_NAME}}"
data "Description" ""
data "Icon" "Spell_Abjuration_DeathWard"
data "AnimationStart" "7e811df9-74e7-4515-bd02-7043164dbf33(STAT_Fallen_Peace_01_Start)"
data "AnimationLoop" "d7b7cf53-fe71-4a23-8011-9675a6e1d902(STAT_Fallen_Peace_01_Loop)"
data "AnimationEnd" "ade4cf7f-a34a-40c4-b810-096f0c186bc2(STAT_Fallen_Peace_01_End)"
data "StatusPropertyFlags" "DisableCombatlog;DisablePortraitIndicator"
data "OnApplyFunctors" "RemoveStatus(ETERNAL_UNDYING);RegainHitPoints(1,Guaranteed)"
data "StatusGroups" "SG_Incapacitated"
data "ApplyEffect" "5508ea40-3f23-436d-980d-0b8143f6e2f3"
data "HideOverheadUI" "1"

@file Spell_Shout
@section Shout_ETERNAL SPELLS

@remove Shout_Arcana_Card_Passive_DarknessRise
@remove Shout_Arcana_Card_Passive_DarknessRise_4
@remove Shout_Arcana_Card_Passive_DarknessRise_5
@remove Shout_Arcana_Card_Passive_DarknessRise_6

new entry "Shout_Arcana_Card_Spell_BloodOffering"
type "SpellData"
data "SpellType" "Shout"
data "Level" "3"
data "SpellSchool" "Necromancy"
data "SpellProperties" "ApplyStatus(SELF,BLOOD_OFFERING,100,1);DealDamage(MaxHP/10,Necrotic,Magical)"
data "TargetConditions" "Self() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "DisplayName" "{{BLOOD_NAME}}"
data "Description" "{{BLOOD_DESC}}"
data "DescriptionParams" "DealDamage(LevelMapValue(DeathsGrasp_Damage),Necrotic)"
data "TooltipStatusApply" "ApplyStatus(BLOOD_OFFERING,100,1)"
data "CastSound" "Spell_Cast_Monk_WholenessOfBody_L1to3"
data "PreviewCursor" "Cast"
data "CastTextEvent" "Cast"
data "UseCosts" "BonusActionPoint:1;SpellSlotsGroup:1:1:3;"
data "SpellAnimation" "355a5479-07c9-4a34-9ab6-3b2669fdd248,,;,,;2ac8ee64-6d74-4cad-a74c-660ef3fc3d06,,;5bf6f6e6-353e-40f9-9a6f-0d6d16e19496,,;1c5627cb-6352-454b-9b84-c5b10ef2d201,,;,,;1cc6ba3b-fa78-48f8-858c-ac4c78fdb8fc,,;,,;,,"
data "VerbalIntent" "Buff"
data "SpellStyleGroup" "Class"
data "SpellFlags" "IsSpell;HasVerbalComponent"
data "HitAnimationType" "None"
data "Requirements" "Combat"

@file Spell_Target
@section Target_ETERNAL SPELLS

new entry "Target_Arcana_Created_Aspect_FinalToll"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Necromancy"
data "Cooldown" "OncePerCombat"
data "SpellProperties" "IF(not Tagged('UNDEAD') and not Tagged('PLAYABLE') and not Tagged('CONSTRUCT') and not Tagged('ELEMENTAL') and not Tagged('PLANT') and not Tagged('OOZE')):ApplyStatus(CRAWLING_GNAW_SWITCH,100,1);ApplyStatus(FINAL_TOLL_TECH,100,0)"
data "TargetRadius" "18"
data "TargetConditions" "Character() and Enemy() and not Dead() and not HasPassive('ARCANA_IS_CARD', context.Source)"
data "Icon" "Spell_Conjuration_ArmsOfHadar"
data "DisplayName" "{{FINALTOLL_NAME}}"
data "Description" "{{FINALTOLL_DESC}}"
data "DescriptionParams" "DealDamage(,Necrotic)"
data "CastSound" "Spell_Cast_Damage_Necrotic_VampiricTouch_L4to5"
data "TargetSound" "Spell_Impact_Damage_Necrotic_VampiricTouch_L4to5"
data "PreviewCursor" "Cast"
data "CastTextEvent" "Cast"
data "CycleConditions" "Enemy() and not Dead()"
data "UseCosts" "ActionPoint:1;"
data "SpellAnimation" "3ff87abf-1ea1-4c32-aadf-c822d74c7dc0,,;,,;c17a3562-3758-4c4a-96e8-790cebed1df4,,;a8012b19-b279-45ec-89b0-86a1b73ad584,,;d8925ce4-d6d9-400c-92f5-ad772ef7f178,,;,,;eadedcce-d01b-4fbb-a1ae-d218f13aa5d6,,;,,;,,"
data "VerbalIntent" "Damage"
data "SpellStyleGroup" "Class"
data "SpellFlags" "IsSpell;IsHarmful;HasVerbalComponent;HasSomaticComponent"
data "HitAnimationType" "MagicalDamage_Internal"
data "Requirements" "Combat"

# Death Ward passa a mirar so aliados (o Tier II ja salva o Eternal)
@set Target_Arcana_Card_Spell_DeathWard TargetConditions Character() and Ally() and not Self() and not HasPassive('ARCANA_IS_CARD', context.Source)
```

- [ ] **Step 3:** simular os patches até o 40 e aplicar.
- [ ] **Step 4:** criar `ARCANA_Aspect_Death.txt` (CRLF):

```
Version 1
SubGoalCombiner SGC_AND
INITSECTION

KBSECTION
// Death (Eternal). Objetivo Sorrow: todo dano que o Eternal recebe em combate vai para um registro que a
// cura nao desfaz; cada 10% do HP maximo e um passo. O mesmo registro e o dano do The Final Toll.

//REGION Registro e objetivo
IF
AttackedBy((CHARACTER)_Eternal, _, _, _, _Amount, _, _)
AND
_Amount > 0
AND
HasPassive(_Eternal, "Arcana_Passive_Aspect_Death_I", 1)
AND
IsInCombat(_Eternal, 1)
THEN
PROC_ARCANA_Death_Suffer(_Eternal, _Amount);

PROC
PROC_ARCANA_Death_Suffer((CHARACTER)_Eternal, (INTEGER)_Amount)
AND
NOT DB_ARCANA_SorrowLedger(_Eternal, _)
THEN
DB_ARCANA_SorrowLedger(_Eternal, 0);

PROC
PROC_ARCANA_Death_Suffer((CHARACTER)_Eternal, (INTEGER)_Amount)
AND
DB_ARCANA_SorrowLedger(_Eternal, _Old)
AND
IntegerSum(_Old, _Amount, _Sum)
THEN
NOT DB_ARCANA_SorrowLedger(_Eternal, _Old);
DB_ARCANA_SorrowLedger(_Eternal, _Sum);
PROC_ARCANA_Death_Measure(_Eternal, _Sum);

PROC
PROC_ARCANA_Death_Measure((CHARACTER)_Eternal, (INTEGER)_Sum)
AND
GetMaxHitpoints(_Eternal, _Max)
AND
IntegerProduct(_Sum, 10, _Sum10)
AND
IntegerDivide(_Sum10, _Max, _Steps)
THEN
PROC_ARCANA_Aspect_Advance(_Eternal, "DEATH", _Steps);
//END_REGION

//REGION Tiers I e II ao despertar
PROC
PROC_ARCANA_Aspect_OnAwakened((CHARACTER)_Eternal, (STRING)_Aspect)
AND
_Aspect == "DEATH"
THEN
ApplyStatus(_Eternal, "DARKNESS_RISE_AURA", -1.0, 1, _Eternal);

PROC
PROC_ARCANA_Aspect_OnAwakened((CHARACTER)_Eternal, (STRING)_Aspect)
AND
_Aspect == "DEATH"
AND
HasPassive(_Eternal, "Arcana_Passive_Aspect_Death_II", 1)
THEN
ApplyStatus(_Eternal, "ETERNAL_UNDYING", -1.0, 1, _Eternal);
ApplyStatus(_Eternal, "ETERNAL_DREAD_AURA", -1.0, 1, _Eternal);
//END_REGION

//REGION Tier III: Harvest
IF
Died(_Dead)
AND
DB_ARCANA_Aspect_InCombat(_Eternal, _)
AND
HasActiveStatus(_Eternal, "ASPECT_AWAKENED_DEATH", 1)
AND
HasPassive(_Eternal, "Arcana_Passive_Aspect_Death_III", 1)
AND
HasActiveStatus(_Eternal, "HARVEST_SPENT", 0)
AND
IsEnemy(_Eternal, _Dead, 1)
AND
GetDistanceTo(_Eternal, _Dead, _Dist)
AND
_Dist <= 9.0
THEN
ApplyStatus(_Eternal, "HARVEST_ACTION", 6.0, 1, _Eternal);
ApplyStatus(_Eternal, "HARVEST_SPENT", 6.0, 1, _Eternal);
//END_REGION

//REGION The Final Toll: dano = registro, teto metade do HP maximo
IF
StatusApplied((CHARACTER)_Foe, "FINAL_TOLL_TECH", (CHARACTER)_Eternal, _)
AND
DB_ARCANA_SorrowLedger(_Eternal, _Ledger)
AND
GetMaxHitpoints(_Eternal, _Max)
AND
IntegerDivide(_Max, 2, _Cap)
AND
IntegerMin(_Ledger, _Cap, _Damage)
AND
_Damage > 0
THEN
ApplyDamage(_Foe, _Damage, "Necrotic", _Eternal);
//END_REGION

//REGION Limpeza
PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
DB_ARCANA_SorrowLedger(_Char, _N)
THEN
NOT DB_ARCANA_SorrowLedger(_Char, _N);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
HasPassive(_Char, "Arcana_Passive_Aspect_Death_I", 1)
THEN
RemoveStatus(_Char, "DARKNESS_RISE_AURA", _Char);

PROC
PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)
AND
HasPassive(_Char, "Arcana_Passive_Aspect_Death_II", 1)
THEN
RemoveStatus(_Char, "ETERNAL_DREAD_AURA", _Char);
RemoveStatus(_Char, "ETERNAL_UNDYING", _Char);
//END_REGION
EXITSECTION

ENDEXITSECTION
```

- [ ] **Step 5:** CRLF nos dois arquivos novos e apagar o goal antigo: `rm "$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Passive_DarknessRise.txt"`.

---

### Task 7: Capstones, progressões, listas e recursos

**Files:**
- Create: `$P/Design/Rework/aspect/50_cleanup.patch`
- Create: `$P/Design/Rework/tools/aspect_structure.pl`
- Modify (pelo script): `Progressions.lsx/.tbl`, `SpellLists.lsx/.tbl`, `ActionResourceDefinitions.lsx/.tbl`

- [ ] **Step 1:** criar `50_cleanup.patch`:

```
# Os capstones de nivel 20 viram o Tier III. Friends: Faux Amis e Howl of the Dead passam a vir pela
# lista de nivel 13 (aspect_structure.pl).
@remove Arcana_Passive_TheFool_EX
@remove Arcana_Passive_TheFool_EX_Tech
@remove Arcana_Passive_TheEmpress_EX
@remove Arcana_Passive_TheEmpress_EX_Tech_I
@remove Arcana_Passive_TheEmpress_EX_Tech_II
@remove Arcana_Passive_TheEmpress_EX_Unlock
@remove Arcana_Passive_TheStar_EX
@remove Arcana_Passive_TheStar_EX_Tech
@remove Arcana_Passive_TheStar_EX_Unlock
@remove Arcana_Passive_Death_EX
@remove Arcana_Passive_Death_EX_Unlock
# o voo da The Star agora vem do Tier III (Projectile_Fly_Spell do vanilla)
@remove Projectile_Arcana_Card_Ability_Fly_TheStarchild
```

- [ ] **Step 2:** criar `aspect_structure.pl`:

```perl
#!/usr/bin/perl
# Despertar do Aspecto: passivas de tier nas progressoes (e saida dos capstones do nivel 20), magias nas
# listas de nivel 7 e 13, e os dois recursos por turno (Fool's Luck, Beloved). Lado jogo (.lsx) e lado
# Toolkit (.tbl) sempre juntos. Idempotente.
#
#   perl aspect_structure.pl            # mostra o que faria
#   perl aspect_structure.pl --apply    # grava (jogo e Toolkit fechados)
use strict; use warnings;
use Digest::MD5 qw(md5_hex);
my $apply = grep { $_ eq '--apply' } @ARGV;
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my %F = (
    plsx => "$G/Public/$M/Progressions/Progressions.lsx",
    ptbl => "$G/Editor/Mods/$M/Progressions/Progressions.tbl",
    llsx => "$G/Public/$M/Lists/SpellLists.lsx",
    ltbl => "$G/Editor/Mods/$M/Lists/SpellLists.tbl",
    rlsx => "$G/Public/$M/ActionResourceDefinitions/ActionResourceDefinitions.lsx",
    rtbl => "$G/Editor/Mods/$M/ActionResourceDefinitions/ActionResourceDefinitions.tbl",
);
# linha da progressao (UUID) => [passivas a acrescentar], [passivas a tirar]
my %prog = (
    'fb53cf40-4c7a-4130-9b21-6f42fb58cb1c' => [['Arcana_Passive_Aspect_Fool_I'], []],        # Unbound 3
    '1e8fdfd5-879c-455b-a5bd-0a52c7ea5dd9' => [['Arcana_Passive_Aspect_Fool_II'], []],       # Unbound 9
    'f654f991-a4b7-452b-96b1-57029a496eb6' => [['Arcana_Passive_Aspect_Fool_III'], []],      # Unbound 17
    'd33bb4ba-8201-4993-a418-8c697850a2a1' => [[], [qw(Arcana_Passive_TheFool_EX Arcana_Passive_TheFool_EX_Tech)]],
    '8e9c09c9-9390-4c6f-9d49-0585c4ec842a' => [['Arcana_Passive_Aspect_Empress_I'], []],     # Deceiver 3
    '3ce373b9-deb5-4c79-8592-0fe462f524fb' => [['Arcana_Passive_Aspect_Empress_II'], []],    # Deceiver 9
    '678e0915-e01b-46c2-8636-20d3e62ad121' => [['Arcana_Passive_Aspect_Empress_III'], []],   # Deceiver 17
    '2c4887f9-d4f8-4a95-974c-519643440029' => [[], [qw(Arcana_Passive_TheEmpress_EX Arcana_Passive_TheEmpress_EX_Tech_I Arcana_Passive_TheEmpress_EX_Tech_II Arcana_Passive_TheEmpress_EX_Unlock)]],
    'b5d65203-1e22-4ae6-874b-01a1721ccda1' => [['Arcana_Passive_Aspect_Star_I'], []],        # Starchild 3
    '293b4c11-0e14-44ce-a47a-ce3eee94ae88' => [['Arcana_Passive_Aspect_Star_II'], []],       # Starchild 9
    '4e960d48-8a90-4605-8f27-dd5152989df7' => [['Arcana_Passive_Aspect_Star_III'], []],      # Starchild 17
    '60e3e094-10e1-4d36-9f12-f368dad72f47' => [[], [qw(Arcana_Passive_TheStar_EX Arcana_Passive_TheStar_EX_Tech Arcana_Passive_TheStar_EX_Unlock)]],
    '0fe06ade-94c1-4618-9abe-4fe8e204ed7d' => [['Arcana_Passive_Aspect_Death_I'], []],       # Eternal 3
    'b66c5349-7135-4c4a-a568-5aa4e233f656' => [['Arcana_Passive_Aspect_Death_II'], []],      # Eternal 9
    'b965d74f-79bb-40dd-be0f-fb4d8d9e3f30' => [['Arcana_Passive_Aspect_Death_III'], []],     # Eternal 17
    '8ba69d3c-9e0e-4a78-9637-8466e41314d2' => [[], [qw(Arcana_Passive_Death_EX Arcana_Passive_Death_EX_Unlock)]],
);
my %lists = (
    '6cc7bce7-943c-4b5c-b4b4-e5144917adf1' => [['Shout_Arcana_Card_Spell_BloodOffering'], ['Shout_Arcana_Card_Passive_DarknessRise']], # Eternal 7
    '8abac308-3262-4ce8-99c2-3d3e9c6ba42e' => [['Shout_Arcana_Card_Spell_HowlOfTheDead'], []],   # Eternal 13
    '4657a3f6-e7f5-4ac4-b5c4-c0665adcb36d' => [['Target_Arcana_Util_Friends_EX'], []],            # Deceiver 13
);
my @resources = qw(ArcanaFoolsLuck ArcanaBeloved);   # ReplenishType Turn, ocultos

my (%txt, %crlf, %bom, @log);
for my $k (keys %F) { open my $fh, '<:raw', $F{$k} or die "$F{$k}: $!"; local $/; my $s = <$fh>;
    $bom{$k} = ($s =~ s/^\xEF\xBB\xBF//) ? 1 : 0; $crlf{$k} = ($s =~ /\r\n/) ? 1 : 0; $s =~ s/\r\n/\n/g; $txt{$k} = $s }
sub uuid { my @h = unpack '(A4)8', md5_hex("arcana-aspect-resource:" . shift); "$h[0]$h[1]-$h[2]-$h[3]-$h[4]-$h[5]$h[6]$h[7]" }
sub merge { my ($cur, $add, $del) = @_; my %d = map { $_ => 1 } @$del;
    my @out = grep { length && !$d{$_} } split /;/, ($cur // ''); my %have = map { $_ => 1 } @out;
    push @out, grep { !$have{$_}++ } @$add; join ';', @out }

# --- progressoes, lado jogo: o atributo UUID e o ultimo do no (ordem alfabetica) ---
for my $u (sort keys %prog) { my ($add, $del) = @{$prog{$u}};
    $txt{plsx} =~ s{(<node id="Progression">\n(?:(?!</node>).)*?<attribute id="UUID" type="guid" value="\Q$u\E"/>\n\s*</node>)}{
        my $n = $1; my ($cur) = $n =~ /<attribute id="PassivesAdded" type="LSString" value="([^"]*)"\/>/;
        my $new = merge($cur, $add, $del);
        if (defined $cur) { if (length $new) { $n =~ s/(<attribute id="PassivesAdded" type="LSString" value=")[^"]*/$1$new/ }
                            else { $n =~ s/\n[ \t]*<attribute id="PassivesAdded" type="LSString" value="[^"]*"\/>// } }
        elsif (length $new) { $n =~ s/(\n([ \t]*)<attribute id="Name" type="LSString" value="[^"]*"\/>)/$1\n$2<attribute id="PassivesAdded" type="LSString" value="$new"\/>/ }
        push @log, "plsx $u: " . ($cur // '(nada)') . " -> $new"; $n }se or die "progressao $u nao achada no .lsx\n" }
# --- progressoes, lado Toolkit ---
for my $u (sort keys %prog) { my ($add, $del) = @{$prog{$u}};
    $txt{ptbl} =~ s{(<stat_object\b(?:(?!</stat_object>).)*?<field name="UUID" type="IdTableFieldDefinition" value="\Q$u\E" />.*?</stat_object>)}{
        my $o = $1; my ($cur) = $o =~ /<field name="PassivesAdded" type="StringTableFieldDefinition" value="([^"]*)" \/>/;
        my $new = merge($cur, $add, $del);
        if (defined $cur) { if (length $new) { $o =~ s/(<field name="PassivesAdded" type="StringTableFieldDefinition" value=")[^"]*/$1$new/ }
                            else { $o =~ s/\n[ \t]*<field name="PassivesAdded" type="StringTableFieldDefinition" value="[^"]*" \/>// } }
        elsif (length $new) { $o =~ s/(\n([ \t]*)<field name="ProgressionType" [^\n]*\/>)/$1\n$2<field name="PassivesAdded" type="StringTableFieldDefinition" value="$new" \/>/ }
        push @log, "ptbl $u: " . ($cur // '(nada)') . " -> $new"; $o }se or die "progressao $u nao achada no .tbl\n" }
# --- listas ---
for my $u (sort keys %lists) { my ($add, $del) = @{$lists{$u}};
    $txt{llsx} =~ s{(<attribute id="Spells" type="LSString" value=")([^"]*)("/>\n\s*<attribute id="UUID" type="guid" value="\Q$u\E"/>)}{ my $n = merge($2, $add, $del); push @log, "llsx $u: $2 -> $n"; "$1$n$3" }e
        or die "lista $u nao achada no .lsx\n";
    $txt{ltbl} =~ s{(value="\Q$u\E" />(?:(?!</stat_object>).)*?<field name="Spells" type="StringTableFieldDefinition" value=")([^"]*)}{ my $n = merge($2, $add, $del); push @log, "ltbl $u: $2 -> $n"; "$1$n" }se
        or die "lista $u nao achada no .tbl\n" }
# --- recursos ---
for my $r (@resources) { my $id = uuid($r);
    if ($txt{rlsx} !~ /value="\Q$r\E"/) {
        $txt{rlsx} =~ s{(\n([ \t]*)<node id="ActionResourceDefinition">)}{\n$2<node id="ActionResourceDefinition">\n$2    <attribute id="IsHidden" type="bool" value="true"/>\n$2    <attribute id="Name" type="FixedString" value="$r"/>\n$2    <attribute id="ReplenishType" type="FixedString" value="Turn"/>\n$2    <attribute id="UUID" type="guid" value="$id"/>\n$2</node>$1} or die "sem ActionResourceDefinition no .lsx\n";
        push @log, "rlsx + $r ($id)" }
    if ($txt{rtbl} !~ /value="\Q$r\E"/) {
        my $obj = qq{    <stat_object is_substat="false">\n      <fields>\n        <field name="Name" type="NameTableFieldDefinition" value="$r" />\n        <field name="UUID" type="IdTableFieldDefinition" value="$id" />\n        <field name="NameFS" type="FixedStringTableFieldDefinition" value="$r" />\n        <field name="ReplenishType" type="FixedStringTableFieldDefinition" value="Turn" />\n        <field name="IsHidden" type="BoolTableFieldDefinition" value="True" />\n      </fields>\n    </stat_object>\n};
        $txt{rtbl} =~ s{(\s*</stat_objects>)}{\n$obj$1} or die "sem </stat_objects> no .tbl\n";
        push @log, "rtbl + $r ($id)" } }

print "$_\n" for @log;
if ($apply) { for my $k (keys %F) { my $s = $txt{$k}; $s =~ s/\n/\r\n/g if $crlf{$k}; $s = "\xEF\xBB\xBF$s" if $bom{$k};
        open my $fh, '>:raw', $F{$k} or die $!; print $fh $s; close $fh } print "gravado.\n" }
else { print "(simulacao -- rode com --apply para gravar)\n" }
```

- [ ] **Step 3:** simular: `perl "$P/Design/Rework/tools/aspect_structure.pl"`.
Expected: 16 linhas `plsx`, 16 `ptbl`, 3 `llsx`, 3 `ltbl`, 2 `rlsx +`, 2 `rtbl +`. Conferir à mão três delas: Starchild 3 fica `Arcana_Passive_StellarAnchor;Arcana_Passive_Aspect_Star_I`; Deceiver 20 fica vazia; Eternal 7 troca DarknessRise por BloodOffering.
- [ ] **Step 4:** aplicar os dois: `perl … aspect_structure.pl --apply` e `perl …/stats_add.pl …/50_cleanup.patch --apply`.
- [ ] **Step 5:** rodar de novo o `aspect_structure.pl` sem `--apply`: cada linha deve mostrar origem = destino (idempotente).

---

### Task 8: Lua — cartas do Aspecto e Blood Offering (TDD)

**Files:**
- Modify: `$LUA/Server/Cards/CardDB.lua` (entrada do DarknessRise ~linha 100; `D.statusConjures` ~linha 125)
- Modify: `$LUA/Tests/KeywordsTest.lua` (depois do teste "A status can conjure a card", ~linha 98)
- Modify: `$LUA/Tests/DestinationTest.lua:82`

- [ ] **Step 1: escrever os testes que falham.** Em `KeywordsTest.lua`, logo depois de `["Nothing is conjured out of combat"]`:

```lua
        ["Awakening an Aspect puts its card in hand"] = function()
            local cards = {
                ASPECT_AWAKENED_FOOL = "Rush_Arcana_Created_Aspect_LeapOfFaith",
                ASPECT_AWAKENED_EMPRESS = "Shout_Arcana_Created_Aspect_Heartbreak",
                ASPECT_AWAKENED_STAR = "Shout_Arcana_Created_Aspect_WishUponAStar",
                ASPECT_AWAKENED_DEATH = "Target_Arcana_Created_Aspect_FinalToll",
            }
            for status, card in pairs(cards) do
                local st = begin()
                F.StartTurn("c", st, yes)
                F.StatusApplied("c", st, status)
                T.eq(count(st.hand, card), 1, status)
            end
        end,
        ["The Aspect card lasts for the rest of the fight"] = function()
            local st = begin()
            F.StartTurn("c", st, yes)
            F.StatusApplied("c", st, "ASPECT_AWAKENED_DEATH")
            nextTurn(st)
            nextTurn(st)
            nextTurn(st)
            T.eq(count(st.hand, "Target_Arcana_Created_Aspect_FinalToll"), 1)
        end,
```

- [ ] **Step 2: rodar e ver falhar.**

Run: `"$LUAEXE" "$P/tools/run_tests.lua" "$LUA"`
Expected: `120 passed, 2 failed` (os dois novos).

- [ ] **Step 3: implementar.** Em `CardDB.lua`, trocar a entrada `["Shout_Arcana_Card_Passive_DarknessRise"] = { … },` (as três linhas) por:

```lua
    -- Blood Offering replaced the Darkness Rise card on 2026-09-28: Darkness Rise is now Tier I of the
    -- Eternal's Aspect. A normal spell card, so it goes back to the discard.
    ["Shout_Arcana_Card_Spell_BloodOffering"] = { aspect = "Eternal" },

    -- Aspect cards (2026-09-28): created when the subclass awakens its Aspect (ASPECT_AWAKENED_*, see
    -- D.statusConjures). Level 0 and no slot, so they cost no Threads; being conjured sends them to the
    -- exile, and the engine's own OncePerCombat cooldown does the same job on the console.
    ["Rush_Arcana_Created_Aspect_LeapOfFaith"] = { aspect = "Unbound" },
    ["Shout_Arcana_Created_Aspect_Heartbreak"] = { aspect = "Deceiver" },
    ["Shout_Arcana_Created_Aspect_WishUponAStar"] = { aspect = "Starchild" },
    ["Target_Arcana_Created_Aspect_FinalToll"] = { aspect = "Eternal" },
```

e trocar `D.statusConjures` por:

```lua
D.statusConjures = {
    ZEPHYR_STRIKE = { id = "Target_Arcana_Created_ZephyrStrike", lasts = 1 },
    -- the Aspect card stays playable for the rest of the fight
    ASPECT_AWAKENED_FOOL = { id = "Rush_Arcana_Created_Aspect_LeapOfFaith", lasts = 99 },
    ASPECT_AWAKENED_EMPRESS = { id = "Shout_Arcana_Created_Aspect_Heartbreak", lasts = 99 },
    ASPECT_AWAKENED_STAR = { id = "Shout_Arcana_Created_Aspect_WishUponAStar", lasts = 99 },
    ASPECT_AWAKENED_DEATH = { id = "Target_Arcana_Created_Aspect_FinalToll", lasts = 99 },
}
```

Em `DestinationTest.lua:82`, tirar `"Shout_Arcana_Card_Passive_DarknessRise", ` da lista (ela é das cartas que vão para o exílio; o Blood Offering não é).

- [ ] **Step 4: rodar e ver passar.**

Run: `"$LUAEXE" "$P/tools/run_tests.lua" "$LUA"`
Expected: `[ArcanaDeck tests] 122 passed, 0 failed`

- [ ] **Step 5: commit no git local do ScriptExtender.**

```bash
cd "$G/Mods/$M/ScriptExtender" && git add -A && \
GIT_AUTHOR_NAME=victr GIT_AUTHOR_EMAIL=lumox.gemini@gmail.com GIT_COMMITTER_NAME=victr GIT_COMMITTER_EMAIL=lumox.gemini@gmail.com \
git commit -m "Aspect cards enter the hand when the subclass awakens; Blood Offering replaces the Darkness Rise card

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Pipeline, lint e publicação no GitHub

- [ ] **Step 1:** variantes de upcast e famílias (cria `_4.._6` do Blood Offering e regera `ARCANA_CardFamilies.txt`):

```bash
perl "$P/Design/Rework/tools/gen_upcast_variants.pl"          # conferir: BloodOffering_4/_5/_6, nada do DarknessRise
perl "$P/Design/Rework/tools/gen_upcast_variants.pl" --apply
```

- [ ] **Step 2:** ordem dos stats: `perl "$P/Design/Rework/tools/sort_stats.pl"` e depois `--apply`. Conferir que `Spell_Rush.txt` e `Status_DOWNED.txt` saem intactos (se o script não conhece os arquivos, ele não mexe; entradas novas nos outros vão para dentro da divisória certa).
- [ ] **Step 3:** lint: `perl "$P/Design/Rework/tools/check_cards.pl"`. Expected: mesma saída da linha de base (Task 0 Step 4), sem erro novo. Um erro novo sobre uma carta do Aspecto se corrige no patch correspondente com `@set` e reaplica.
- [ ] **Step 4:** selftest de novo: `perl "$P/Design/Rework/tools/stats_add.pl" --selftest` → `0 diferentes` (agora cobrindo as entradas novas).
- [ ] **Step 5:** conferência cruzada de nomes (nada citado sem existir):

```bash
cd "$G"
for n in ASPECT_AWAKENED_FOOL ASPECT_AWAKENED_EMPRESS ASPECT_AWAKENED_STAR ASPECT_AWAKENED_DEATH ASPECT_PROGRESS_FOOL \
  WANDERLUST_MARK WANDERLUST_HIT_TECH FOOL_ZEPHYR_FREE SIGIL_DETONATED_TECH HEARTBREAK_TECH BEACON_HEAL_TECH \
  UNDYING_HOPE UNDYING_HOPE_DOWNED ETERNAL_UNDYING ETERNAL_UNDYING_DOWNED ETERNAL_DREAD_AURA ETERNAL_DREAD \
  HARVEST_ACTION HARVEST_SPENT FINAL_TOLL_TECH Interrupt_Arcana_Aspect_FoolsLuck Interrupt_Arcana_Aspect_Beloved \
  Rush_Arcana_Created_Aspect_LeapOfFaith Shout_Arcana_Created_Aspect_Heartbreak Shout_Arcana_Created_Aspect_WishUponAStar \
  Target_Arcana_Created_Aspect_FinalToll Shout_Arcana_Card_Spell_BloodOffering; do
  grep -rqa "new entry \"$n\"" "Public/$M/Stats/Generated/Data" || echo "FALTA: $n"; done
grep -rlaE "TheFool_EX|TheEmpress_EX|TheStar_EX|Arcana_Passive_Death_EX|Fly_TheStarchild|Card_Passive_DarknessRise|DARKNESS_RISE_ACTIVE|DARKNESS_RISE_TECH" \
  "Public/$M" "Editor/Mods/$M" "Mods/$M/Story/RawFiles" "Mods/$M/ScriptExtender" "Mods/$M/Scripts" | grep -v -E "Localization|\.lsf$|story\.div|goals\.raw|story_ac"
```

Expected: nenhum `FALTA:` e nenhum arquivo listado (os compilados do Story só mudam quando o usuário recompila).

- [ ] **Step 6:** atualizar a spec com uma seção "Notas de implementação (2026-09-28)" registrando as decisões tomadas no plano: Undying Hope automático (padrão Death Ward); Howl of the Dead e Friends: Faux Amis no nível 13; Blood Offering = perde 1/10 do HP máximo e +`DeathsGrasp_Damage` necrótico nas cartas até o fim do turno (Bonus Action, nível 3); Fool's Luck e Beloved gatados por recursos que recarregam por turno; progresso contado em DB no Osiris (o status com FreezeDuration só mostra); Moonlit/Sunlit duram 2 turnos até o próximo ataque; a marca de zumbi do Final Toll dura 1 turno; Beloved reage a ataques (não a magias de save); Mourning usa status próprio (`ETERNAL_UNDYING`) em vez do `DEATH_WARD` do vanilla; o VFX vem de status vanilla (HASTE, BLUR, BLESS; Death usa a aura do Darkness Rise) e o som de level-up ficou de fora nesta rodada.
- [ ] **Step 7:** `cd "$P" && bash tools/sync-mod.sh && git add -A mod tools && git commit` com a mensagem abaixo, e `git push`.

```
Aspect Awakening: each subclass awakens its tarot Aspect in combat

- Osiris counts each subclass's objective (Wanderlust, Obsession, Beacon, Sorrow) and applies
  ASPECT_AWAKENED_<ARCANA>, whose hidden passives carry Tiers I/II/III (levels 3/9/17).
- The level-20 tarot capstones become Tier III and leave the progressions.
- Aspect cards: Leap of Faith (new Rush file), Heartbreak, Wish Upon a Star, The Final Toll.
- Spells changed for redundancy: Evasive Flow, Wind Whispers, Malicious Whispers, Instinctive Charm,
  Death Ward; the Darkness Rise card becomes Blood Offering.
- stats_add.pl and aspect_structure.pl write the game and the Toolkit side together.

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
```

---

### Task 10: Guia de teste no jogo (para o usuário)

**Files:**
- Create: `$P/Design/Rework/plans/2026-09-28-aspect-teste-no-jogo.md`

- [ ] **Step 1:** escrever o guia com estes passos, na ordem:
  1. **Toolkit:** *Reload Stats*. Abrir o Story Editor, compilar e ler `Story\log.txt` até `0 error(s)`. Os avisos novos que importam: DB "defined but never checked" em `DB_ARCANA_*`.
  2. **Publicar** e testar no **jogo com SE** (o play mode do Toolkit roda sem SE, então não há Threads nem mão lá).
  3. **S1 Beacon:** Starchild nível 3+ cura um aliado ferido com Astral Infusion. Espera ver "Beacon" com duração 1 depois de ~5 HP efetivos (nível 3 → meta 15, passo a cada 5). Se nada aparecer, o `HitpointsChanged` não dispara com cura, e o plano B é contar cartas de cura.
  4. **S2 Sorrow com THP:** Eternal usa Indestructible e apanha. O "Sorrow" deve avançar mesmo com o dano indo para o THP; se não avançar, anotar.
  5. **S3 Leap of Faith:** com 2 inimigos em linha, a carta rola ataque contra os dois e depois dá o Zephyr Strike.
  6. **S4 Wanderlust:** acertar o mesmo inimigo duas vezes no turno conta 1; no turno seguinte, conta de novo.
  7. **S5 Corrente do Sigil (Tier II):** detonar uma marca com outro inimigo a menos de 6 m; a marca aparece nele, uma vez por turno, e nunca depois do Heartbreak.
  8. **S6 Undying Hope:** um aliado que cairia volta com metade do HP e com THP; a proteção some dos outros.
  9. **S7 Dread (Tier II do Eternal):** inimigo sozinho a 3 m ataca com Desvantagem; com um aliado dele perto, não.
  10. **S8 Sigil (Tier I da Empress):** marcado ataca o Deceiver com Desvantagem, e outro personagem sem Desvantagem.
  11. **S9 Wind Whispers:** um ataque que erra o Unbound dá o Zephyr Strike, que continua disponível no turno dele.
  12. **Mão (PC):** ao despertar, a carta do Aspecto aparece na mão e fica até o fim do combate; ao jogar, vai para o exílio.
  13. **Console (sem SE):** a carta aparece no spellbook ao despertar e some quando o combate acaba.
  14. **Capstones:** um personagem nível 20 não tem mais as passivas de tarô fora de combate; Friends: Faux Amis e Howl of the Dead aparecem no nível 13.
- [ ] **Step 2:** apontar o guia no fim da spec e atualizar a memória `arcana-rework-2026` com o estado (implementado, aguardando teste no jogo, backup e commits).
```
