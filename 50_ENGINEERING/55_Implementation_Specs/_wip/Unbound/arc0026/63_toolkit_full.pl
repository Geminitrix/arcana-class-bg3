#!/usr/bin/perl
# ARC-0026 — writes 55/TOOLKIT_ARC-0026.md: the whole Windborn typed FROM ZERO in the Toolkit (Owner, 2026-10-18:
# "vou excluir tudo o que tem no Unbound e refazer do 0 com apenas a versão correta"). One file (OR-4), in the order to
# implement, feature by feature, each feature complete in one place (OR-5), ids by OR-59, every rule of
# _TEMPLATE_TOOLKIT_GUIDE.md. It replaces the per-level generator 60_toolkit_guides.pl.
#
# The final Windborn = the game before ARC-0026 (commit 09f30e0, read from its .stats) + the build patches (10–40) + the
# Owner's own typing in the Toolkit (2026-10-17/18, read from the 51 .txt after sync_data) where it doesn't contradict a
# decision + the answers of 2026-10-18 (Zephyr after an unarmed attack OR a card, WB3; a wind's bane only on Windswept
# enemies, WB12; the cards keep their slot costs). Only what the Windborn owns is written (shared entries stay).
#   perl 63_toolkit_full.pl            # writes the file, then runs order_toolkit_guide.pl --apply on it
#   perl 63_toolkit_full.pl --check    # self-check only
use strict; use warnings; use utf8; use File::Glob qw(bsd_glob);
binmode STDOUT, ':utf8';
my $ROOT = 'C:/Lumox Studios/Arcana Class';
my $WIP  = "$ROOT/50_ENGINEERING/55_Implementation_Specs/_wip/Unbound/arc0026";
my $OUTF = "$ROOT/50_ENGINEERING/55_Implementation_Specs/TOOLKIT_ARC-0026.md";
my $M    = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $S51  = "$ROOT/50_ENGINEERING/51_Mod_Source";
my $GAME = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $BASE = '09f30e0';
my $V    = 'C:/Projetos/BG3/Base Game BG3/Assets';
my $CHECK = grep { $_ eq '--check' } @ARGV;

sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s =~ s/^\xEF\xBB\xBF//; utf8::decode($s); $s =~ s/\r\n/\n/g; $s }
sub git_show { my $p = shift; my $s = `git -C "$ROOT" show $BASE:"$p"`; die "git show $p\n" if $?; $s =~ s/^\xEF\xBB\xBF//; utf8::decode($s); $s =~ s/\r\n/\n/g; $s }
sub unxml { my $v = shift; $v =~ s/&quot;/"/g; $v =~ s/&apos;/'/g; $v =~ s/&lt;/</g; $v =~ s/&gt;/>/g; $v =~ s/&amp;/&/g; $v }

# ---------------------------------------------------------------- the Toolkit's own definitions: labels, export names, order
my (%EXP, %LBL, %ORD);   # type -> {stats name -> export name}, type -> {export -> label}, type -> [labels in order]
{ my $d; for (split /\n/, slurp("$GAME/Editor/Config/Stats/StatObjectDefinitions.sod")) {
    $d = $1 if /<stat_object_definition [^>]*name="([^"]+)"/;
    next unless $d && /<field_definition name="([^"]+)" display_name="([^"]+)" export_name="([^"]+)"/;
    my ($n, $dn, $ex) = ($1, $2, $3); next if /is_internal="true"/;
    $EXP{$d}{$n} = $ex; $LBL{$d}{$ex} = $dn; push @{$ORD{$d}}, $dn } }
my %TYPEOF = (Spell_Target => 'Target', Spell_Shout => 'Shout', Spell_Rush => 'Rush', Spell_Projectile => 'Projectile',
    Spell_Zone => 'Zone', Spell_Teleportation => 'Teleportation', Status_BOOST => 'Status_BOOST', Passive => 'Passive',
    Interrupt => 'Interrupt', Armor => 'Armor', Equipment => 'Equipment', map({ ("Status_$_" => "Status_$_") } qw(EFFECT DOWNED FEAR INCAPACITATED INVISIBLE KNOCKED_DOWN POLYMORPHED)));
my %STATSF = (Spell_Target => 'SpellData/Target', Spell_Shout => 'SpellData/Shout', Spell_Rush => 'SpellData/Rush',
    Spell_Projectile => 'SpellData/Projectile', Spell_Zone => 'SpellData/Zone', Spell_Teleportation => 'SpellData/Teleportation',
    Status_BOOST => 'StatusData/Status_BOOST', Passive => 'Stats/Passive', Interrupt => 'Stats/Interrupt', Armor => 'Stats/Armor',
    Equipment => 'Equipment/Equipment', map({ ("Status_$_" => "StatusData/Status_$_") } qw(EFFECT DOWNED FEAR INCAPACITATED INVISIBLE KNOCKED_DOWN POLYMORPHED)));
sub lbl { my ($pub, $k) = @_; $LBL{$TYPEOF{$pub}}{$k} // $k }

# ---------------------------------------------------------------- .stats reader (UUIDs of Using resolved over every module)
my %UUIDNAME;   # stat object UUID -> full entry name
sub stats_objs { my ($x, $pub) = @_; my ($t) = $pub =~ /^Spell_(\w+)$/; my @o;
    for my $o (split /<stat_object /, $x) {
        my ($n) = $o =~ /<field name="Name"[^>]*value="([^"]+)"/ or next; my ($u) = $o =~ /<field name="UUID"[^>]*value="([^"]+)"/;
        my $full = $t ? "${t}_$n" : $n; my (%f, @ord, $using);
        while ($o =~ /<field name="(\w+)" type="(\w+)"([^>]*)\/>/g) { my ($k, $ty, $a) = ($1, $2, $3);
            next if $k eq 'UUID' || $k eq 'Name';
            if ($k eq 'Using') { ($using) = $a =~ /value="([^"]+)"/; next }
            my $v = $ty eq 'TranslatedStringTableFieldDefinition' ? (($a =~ /handle="([^"]+)"/) ? "$1;" . (($a =~ /version="(\d+)"/)[0] // 1) : '')
                  : $a =~ /clear_inherited_value="true"/ ? '' : unxml((($a =~ /value="([^"]*)"/)[0] // ''));
            my $ex = $EXP{$TYPEOF{$pub}}{$k} // $k; push @ord, $ex unless exists $f{$ex}; $f{$ex} = $v }
        push @o, { name => $full, uuid => $u, using => $using, f => \%f, o => \@ord, pub => $pub } }
    @o }
for my $mod (qw(Shared SharedDev Gustav GustavDev GustavX)) { for my $pub (keys %STATSF) { my $f = "$GAME/Editor/Mods/$mod/Stats/$STATSF{$pub}.stats"; next unless -e $f;
    $UUIDNAME{$_->{uuid}} = $_->{name} for grep { $_->{uuid} } stats_objs(slurp($f), $pub) } }
my %B;   # the mod before ARC-0026: name -> {pub, using (name), f, o}
for my $pub (keys %STATSF) { my $x = eval { git_show("50_ENGINEERING/51_Mod_Source/Editor/Mods/$M/Stats/$STATSF{$pub}.stats") } or next;
    my @o = stats_objs($x, $pub); $UUIDNAME{$_->{uuid}} = $_->{name} for grep { $_->{uuid} } @o; $B{$_->{name}} = $_ for @o }
for my $e (values %B) { $e->{using} = $UUIDNAME{$e->{using}} // die "$e->{name}: Using $e->{using} unknown\n" if $e->{using} }

# ---------------------------------------------------------------- vanilla .txt (parents) and the 51 .txt (the Owner's typing)
sub load_txt { my ($f, $into) = @_; my $cur;
    for my $l (split /\n/, slurp($f)) {
        if ($l =~ /^new entry "([^"]+)"/) { $cur = $1; $into->{$cur} = { f => {}, o => [] }; next }
        next unless defined $cur;
        if ($l =~ /^using "([^"]+)"/) { $into->{$cur}{using} = $1; next }
        if ($l =~ /^data "([^"]+)" "(.*)"$/) { push @{$into->{$cur}{o}}, $1 unless exists $into->{$cur}{f}{$1}; $into->{$cur}{f}{$1} = $2 } } }
my (%VAN, %OWN);
for my $d ("$V/Shared_Extracted/Public/Shared", "$V/Shared_Extracted/Public/SharedDev", "$V/Gustav_Extracted/Public/Gustav",
           "$V/Gustav_Extracted/Public/GustavDev") { load_txt($_, \%VAN) for bsd_glob("$d/Stats/Generated/Data/*.txt") }
load_txt($_, \%OWN) for bsd_glob("$S51/Public/$M/Stats/Generated/Data/*.txt");

# ---------------------------------------------------------------- loca: the game before ARC-0026, the Owner's texts now, vanilla
my (%ENB, %ENO);
for ([\%ENB, git_show("50_ENGINEERING/51_Mod_Source/Mods/$M/Localization/English/english.xml")],
     [\%ENO, slurp("$S51/Mods/$M/Localization/English/english.xml")]) { my ($h, $x) = @$_;
    $h->{$1} = unxml($2) while $x =~ /<content contentuid="([^"]+)"[^>]*>(.*?)<\/content>/sg }
my %ENV_VAN = -e "$WIP/vanilla_texts.tsv" ? (map { /^(h[0-9a-g]{36})	(.*)$/ ? ($1 => $2) : () } split /
/, slurp("$WIP/vanilla_texts.tsv")) : ();
my %TIP = map { /^([^#\t][^\t]*)\t(.*)$/ ? ($1 => $2) : () } split /\n/, slurp("$WIP/tooltip_extras.tsv");
our %NEED;   # vanilla text handles the table below lacks: listed in vanilla_texts.need, the run stops
my %ENV_VAN = -e "$WIP/vanilla_texts.tsv" ? (map { /^(h[0-9a-g]{36})\t(.*)$/ ? ($1 => $2) : () } split /\n/, slurp("$WIP/vanilla_texts.tsv")) : ();

# ---------------------------------------------------------------- the build patches
my (%PNEW, @PSET, @PDEL, %LOCA, %LOCAH);
for my $pf (qw(10_core 20_bag_awakening 30_ranks_cards 40_capstone_names)) { my ($file, $cur);
    for my $l (split /\n/, slurp("$WIP/$pf.patch")) {
        if    ($l =~ /^\@file (\S+)/)            { $file = $1; undef $cur }
        elsif ($l =~ /^\@loca (\S+) (.*)$/)      { my ($k, $t) = ($1, $2); ($k =~ /^h[0-9a-g]{36}$/ ? \%LOCAH : \%LOCA)->{$k} = $t }
        elsif ($l =~ /^\@set (\S+) (\S+) ?(.*)$/) { my @s = ($1, $2, $3); $s[2] =~ s/^"(.*)"$/$1/; push @PSET, [$file, @s]; undef $cur }
        elsif ($l =~ /^\@remove (\S+)/)          { push @PDEL, $1; undef $cur }
        elsif ($l =~ /^new entry "(.+)"/)        { $cur = $1; $PNEW{$cur} = { pub => $file, f => {}, o => [] } }
        elsif (defined $cur && $l =~ /^using "(.+)"/) { $PNEW{$cur}{using} = $1 }
        elsif (defined $cur && $l =~ /^data "(\w+)" "(.*)"$/) { push @{$PNEW{$cur}{o}}, $1 unless exists $PNEW{$cur}{f}{$1}; $PNEW{$cur}{f}{$1} = $2 }
        elsif ($l =~ /^\s*$/)                    { undef $cur } } }
print "loaded: ", scalar(keys %B), " mod entries before ARC-0026, ", scalar(keys %PNEW), " new in the patches, ",
      scalar(@PSET), " fields set, ", scalar(@PDEL), " removals, ", scalar(keys %OWN), " entries in the game now\n";

# ================================================================ the final Windborn
# %F name -> {pub, using, f => {k => v}, o => [k], src}. Start from the game before ARC-0026, then the patches.
my %F = map { my $e = $B{$_}; ($_ => { pub => $e->{pub}, using => $e->{using}, f => { %{$e->{f}} }, o => [@{$e->{o}}], src => 'kept' }) } keys %B;
for my $n (keys %PNEW) { my $p = $PNEW{$n}; $F{$n} = { pub => $p->{pub}, using => $p->{using}, f => { %{$p->{f}} }, o => [@{$p->{o}}], src => 'patch' } }
for my $s (@PSET) { my ($file, $n, $k, $v) = @$s; next if $n eq 'Interrupt_AttackOfOpportunity'; $n = 'INTERRUPT_GALE_DEFLECT_MISSILES_HIT' if 0; my $e = $F{$n} or die "set on unknown $n\n";
    push @{$e->{o}}, $k unless exists $e->{f}{$k}; $e->{f}{$k} = $v; $e->{src} = 'changed' if $e->{src} eq 'kept' }
my %RETIRED = map { $_ => 1 } @PDEL; delete @F{@PDEL};
# The Open Path: the vanilla opportunity attack copied into the mod under its own name (P6 plan B, WB49).
{ my %v; my $r; $r = sub { my $m = shift; my $e = $VAN{$m} or return; $r->($e->{using}) if $e->{using}; @v{keys %{$e->{f}}} = values %{$e->{f}} };
  $r->('Interrupt_AttackOfOpportunity'); $v{EnableCondition} = "not HasStatus('SG_Blinded') and not HasStatus('WINDSWEPT');";
  $F{Interrupt_AttackOfOpportunity} = { pub => 'Interrupt', f => \%v, o => [sort keys %v], src => 'vanilla copy' } }

# ---- the Owner's typing (2026-10-17/18), kept where it doesn't contradict a decision
sub own { my ($n, @k) = @_; my $o = $OWN{$n} or die "the Owner's $n is not in the game\n"; @k = @{$o->{o}} unless @k;
    my $e = $F{$n} //= { pub => undef, f => {}, o => [], src => 'owner' };
    for my $k (@k) { if (exists $o->{f}{$k}) { push @{$e->{o}}, $k unless exists $e->{f}{$k}; $e->{f}{$k} = $o->{f}{$k} } else { delete $e->{f}{$k} } }
    $e->{src} = 'owner' if $e->{src} ne 'patch'; $e }
# The Open Road = the mark (the old Windswept_Touch, hidden) made the visible core passive; Zephyr is its own passive.
own('Arcana_Passive_TheOpenRoad')->{pub} = 'Passive';
my $z = own('Arcana_Passive_Zephyr'); $z->{pub} = 'Passive';
$z->{f}{Conditions} = "((IsMeleeAttack() and not IsWeaponAttack()) or IsCardSpell()) and not SpellId('Target_Arcana_Created_ZephyrStrike') and not SpellId('Rush_Arcana_Created_ZephyrRush') and not (WearingArmor(context.Source) or HasShieldEquipped(context.Source));";   # WB3: an unarmed attack OR a card (Owner, 2026-10-18)
delete @F{qw(Arcana_Passive_FlowingStrikeZephyr Arcana_Passive_Windswept_Touch)}; @RETIRED{qw(Arcana_Passive_FlowingStrikeZephyr Arcana_Passive_Windswept_Touch)} = (1, 1);
# statuses the Owner typed with their OR-59 names
for my $n (qw(WINDSWEPT ZEPHYR_RUSH)) { own($n)->{pub} = 'Status_BOOST' }
own('ZEPHYR_STRIKE', qw(StackId StackType StatusPropertyFlags));
own('Arcana_Passive_AeolusBag');
# Zephyr Rush: the Owner's choices (school, flags, sheathing, no AI helper, no Character() term)
{ my $r = $F{Rush_Arcana_Created_ZephyrRush}; my $o = $OWN{Rush_Arcana_Created_ZephyrRush}{f};
  $r->{f}{$_} = $o->{$_} for qw(SpellSchool SpellFlags Sheathing TargetConditions RequirementConditions);
  $r->{f}{SpellProperties} = '' }
# the bag and its children: the Owner's entries (copied from Flow State), status name BAG_READY (the spells' own check)
for my $n (qw(Shout_Arcana_Created_AeolusBag Shout_Arcana_Created_AeolusBag_Boreas Shout_Arcana_Created_AeolusBag_Notus)) {
    my $keep = $F{$n}{f}{ContainerSpells}; my $e = own($n); $e->{pub} = 'Spell_Shout';
    $e->{using} = $OWN{$n}{using}; $e->{f}{ContainerSpells} = $keep if $n eq 'Shout_Arcana_Created_AeolusBag' }
# the winds and their tail/headwinds: the Owner's entries; the bane only on Windswept enemies (WB12, Owner 2026-10-18)
for my $w (qw(BOREAS NOTUS)) { my $e = own("WIND_$w"); $e->{pub} = 'Status_BOOST';
    $e->{f}{AuraStatuses} = "IF(Ally()):ApplyStatus(TAILWIND_$w);IF(Enemy() and HasStatus('WINDSWEPT')):ApplyStatus(HEADWIND_$w)";
    for my $s ("TAILWIND_$w", "HEADWIND_$w") { own($s)->{pub} = 'Status_BOOST' } }
$F{TAILWIND_BOREAS}{f}{DescriptionParams} = 'Distance(3)'; delete $F{TAILWIND_NOTUS}{f}{DescriptionParams}; $F{HEADWIND_NOTUS}{f}{DescriptionParams} = '1';   # the texts' [1]
delete @F{qw(ARCANA_WINDSWEPT ARCANA_ZEPHYR_RUSH ARCANA_WIND_BOREAS ARCANA_WIND_NOTUS ARCANA_TAILWIND_BOREAS ARCANA_HEADWIND_BOREAS ARCANA_TAILWIND_NOTUS ARCANA_HEADWIND_NOTUS)};
# Gale Burst and Wind Blast: the Owner's tooltips and target rule; the slot costs stay (Owner, 2026-10-18)
for my $n ('Target_Arcana_Card_Spell_GaleBurst', map { "Target_Arcana_Card_Spell_GaleBurst_$_" } 3 .. 6) { own($n, 'TooltipDamageList') }
own('Target_Arcana_Card_Spell_GaleBurst', qw(VerbalIntent ExtraDescription));
own('Zone_Arcana_Card_Spell_WindBlast', 'TargetConditions');

# tooltips a vanilla parent shows that ours doesn't do: Spring Attack's Off Balance, Shatter's upcast (the capstone is level 0)
$F{Rush_Arcana_Created_Aspect_LeapOfFaith}{f}{TooltipStatusApply} = '';
$F{Target_Arcana_Created_WhereTheWindsMeet}{f}{$_} = '' for qw(TooltipUpcastDescription TooltipUpcastDescriptionParams);

# ---- OR-59 names: statuses lose the ARCANA_ prefix (the shipped marker ARCANA_IS_CARD stays)
my %REN = (ARCANA_BAG_OPEN => 'BAG_OPEN', ARCANA_BAG_READY => 'BAG_READY', ARCANA_WINDSWEPT => 'WINDSWEPT', ARCANA_ZEPHYR_RUSH => 'ZEPHYR_RUSH',
    ARCANA_STORM_RUSH => 'STORM_RUSH', ARCANA_INTO_THE_STORM => 'INTO_THE_STORM', Arcana_Passive_Windswept_Touch => 'Arcana_Passive_TheOpenRoad',
    map({ ("ARCANA_WIND_$_" => "WIND_$_", "ARCANA_TAILWIND_$_" => "TAILWIND_$_", "ARCANA_HEADWIND_$_" => "HEADWIND_$_") } qw(BOREAS NOTUS EURUS)),
    map({ ("ARCANA_CALM_GUST_$_" => "CALM_GUST_$_") } 1 .. 5), ARCANA_CALM_GUST => 'CALM_GUST');
my $REN_RE = join '|', map { quotemeta } sort { length $b <=> length $a } keys %REN;
sub ren { my $s = shift; $s =~ s/\b($REN_RE)\b/$REN{$1}/g; $s }
for my $old (grep { $F{$_} } keys %REN) { my $new = $REN{$old}; if ($F{$new}) { delete $F{$old} } else { $F{$new} = delete $F{$old} } }
for my $e (values %F) { $_ = ren($_) for values %{$e->{f}}; $e->{using} = ren($e->{using}) if $e->{using} }
# ---- one armour rule everywhere, in the Owner's form
for my $e (values %F) { s/not WearingArmor\(context\.Source\) and not HasShieldEquipped\(context\.Source\)/not (WearingArmor(context.Source) or HasShieldEquipped(context.Source))/g for values %{$e->{f}} }
# Eurus: the Owner's Boreas pair with the patch's Eurus values (standalone, like the Owner's)
for my $p (['WIND_EURUS', 'WIND_BOREAS'], ['TAILWIND_EURUS', 'TAILWIND_BOREAS'], ['HEADWIND_EURUS', 'HEADWIND_BOREAS']) { my ($n, $like) = @$p;
    my $patch = $F{$n} or die "no patch entry $n\n"; my %f = %{$F{$like}{f}}; $f{$_} = $patch->{f}{$_} for grep { $_ ne 'StatusType' } keys %{$patch->{f}};
    $f{StackId} = $n; delete $f{DescriptionParams} unless exists $patch->{f}{DescriptionParams};
    $F{$n} = { pub => 'Status_BOOST', f => \%f, o => [sort keys %f], src => 'patch' } }
$F{WIND_EURUS}{f}{AuraStatuses} = "IF(Ally()):ApplyStatus(TAILWIND_EURUS);IF(Enemy() and HasStatus('WINDSWEPT')):ApplyStatus(HEADWIND_EURUS)";
$F{WIND_EURUS}{f}{AuraRadius} = $F{WIND_BOREAS}{f}{AuraRadius};

# ---- every name an entry points to must exist (in the Windborn, the rest of the mod or vanilla)
{ my @bad; for my $n (sort keys %F) { for my $k (grep { $_ ne 'StackId' } keys %{$F{$n}{f}}) { my $v = $F{$n}{f}{$k};
      while ($v =~ /\b((?:ARCANA_|Arcana_Passive_)\w+|(?:Target|Shout|Rush|Zone|Projectile)_Arcana_\w+|(?:WIND|TAILWIND|HEADWIND|BAG|CALM_GUST|ZEPHYR|STORM|INTO_THE|WINDSWEPT)\w*)\b/g) {
          my $r = $1; next if $F{$r} || $VAN{$r} || $r =~ /^ARCANA_IS_/; push @bad, "$n.$k -> $r" } } }
  if (@bad) { print "DANGLING:\n  ", join("\n  ", @bad), "\n" } }
print "final: ", scalar(keys %F), " mod entries; retired ", scalar(keys %RETIRED), "\n";

# ================================================================ lists, progression, class objects (the game before ARC-0026 + the WB43 map)
my $TABLE = 'd75cb44d-bba6-43ad-851f-4497ec526e80'; my $CLASS = 'dc2e68d3-5577-4a9f-be4f-1a71707c1995';
sub lsx_nodes { my ($x, $id) = @_; my @n;
    for my $b (split /<node id="\Q$id\E"/, $x) { next unless $b =~ /<attribute/; my (%a, @ord);
        while ($b =~ /<attribute id="(\w+)" type="([^"]*)" (value|handle)="([^"]*)"/g) { next if exists $a{$1}; $a{$1} = unxml($4); push @ord, $1 }
        my @kids = $b =~ /<node id="(?:SubClass|Tags|Object)">\s*<attribute id="Object" type="guid" value="([^"]+)"/g;
        push @n, { a => \%a, o => \@ord, kids => \@kids } } @n }
my $PUBDIR = "50_ENGINEERING/51_Mod_Source/Public/$M";
my @BPROG = grep { ($_->{a}{TableUUID} // '') eq $TABLE } lsx_nodes(git_show("$PUBDIR/Progressions/Progressions.lsx"), 'Progression');
my @OTHERPROG = grep { ($_->{a}{TableUUID} // '') ne $TABLE } lsx_nodes(git_show("$PUBDIR/Progressions/Progressions.lsx"), 'Progression');
my %BLIST = map { $_->{a}{UUID} => $_ } lsx_nodes(git_show("$PUBDIR/Lists/SpellLists.lsx"), 'SpellList');
my ($BCLASS) = grep { ($_->{a}{UUID} // '') eq $CLASS } lsx_nodes(git_show("$PUBDIR/ClassDescriptions/ClassDescriptions.lsx"), 'ClassDescription');
my ($BPDESC) = grep { ($_->{a}{ProgressionTableId} // '') eq $TABLE } lsx_nodes(git_show("$PUBDIR/Progressions/ProgressionDescriptions.lsx"), 'ProgressionDescription');
my ($BPRESET) = grep { ($_->{a}{ClassUUID} // '') eq $CLASS } lsx_nodes(git_show("$PUBDIR/CharacterCreationPresets/AbilityDistributionPresets.lsx"), 'AbilityDistributionPreset');
my @BDEF = map { my $f = $_; map { +{ %$_, file => $f } } grep { ($_->{a}{TableUUID} // '') eq $TABLE } lsx_nodes(git_show("$PUBDIR/DefaultValues/$f.lsx"), $f) } qw(Abilities Skills);
my @BRES = lsx_nodes(git_show("$PUBDIR/ActionResourceDefinitions/ActionResourceDefinitions.lsx"), 'ActionResourceDefinition');
my @BLMAP = lsx_nodes(git_show("$PUBDIR/Levelmaps/LevelMapValues.lsx"), 'LevelMapSeries');
die "baseline class objects not found\n" unless $BCLASS && $BPDESC && $BPRESET && @BPROG == 21;

# the level map (WB43): what each level adds and takes, the rows of 50_structure.pl, with the Owner's passive names
my $GD = 'ActionResource(ArcanaGaleDeflectReturn,1,0)'; my $GR = 'ActionResource(ArcanaReactGaleDeflection,3,0)';
sub tt { "Arcana_Passive_TwinkleToes_$_[0]" } sub wl { "Arcana_Passive_Weightless_$_[0]" }
my @ROWS = (   # [level, also the multiclass row?, field, add, remove]
    [1, 1, 'PassivesAdded', wl(1), tt(1)], [1, 1, 'PassivesAdded', 'Arcana_Passive_TheOpenRoad', 'Arcana_Passive_FlowingStrikeZephyr'], [1, 1, 'PassivesAdded', 'Arcana_Passive_Zephyr'],
    [2, 0, 'PassivesAdded', 'Arcana_Passive_AeolusBag'], [2, 0, 'Selectors', 'LIST2'],
    [3, 0, 'PassivesAdded', undef, tt(3)], [3, 0, 'PassivesRemoved', undef, tt(1)], [3, 0, 'Boosts', undef, $GD], [3, 0, 'Boosts', undef, $GR],
    [4, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Gale'], [4, 0, 'PassivesAdded', wl(4)], [4, 0, 'PassivesRemoved', wl(1)],
    [5, 0, 'PassivesAdded', undef, tt(5)], [5, 0, 'PassivesAdded', undef, 'Arcana_Passive_Weightless_5'], [5, 0, 'PassivesRemoved', undef, tt(3)],
    [6, 0, 'Boosts', $GD], [6, 0, 'Boosts', $GR], [6, 0, 'Selectors', 'LIST6'],
    [7, 0, 'PassivesAdded', undef, tt(7)], [7, 0, 'PassivesAdded', undef, 'Arcana_Passive_Weightless_7'], [7, 0, 'PassivesRemoved', undef, tt(5)], [7, 0, 'PassivesRemoved', undef, 'Arcana_Passive_Weightless_5'],
    [8, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Storm'], [8, 0, 'PassivesAdded', wl(8)], [8, 0, 'PassivesRemoved', wl(4)],
    [9, 0, 'PassivesAdded', undef, tt(9)], [9, 0, 'PassivesAdded', undef, 'Arcana_Passive_Weightless_9'], [9, 0, 'PassivesAdded', 'Arcana_Passive_EmptyState', 'Arcana_Passive_EyeOfTheStorm_UI'],
    [9, 0, 'PassivesRemoved', undef, tt(7)], [9, 0, 'PassivesRemoved', undef, 'Arcana_Passive_Weightless_7'],
    [10, 0, 'Selectors', 'LIST10'],
    [11, 0, 'PassivesAdded', undef, tt(11)], [11, 0, 'PassivesAdded', undef, 'Arcana_Passive_Weightless_11'], [11, 0, 'PassivesAdded', undef, 'Arcana_Passive_Momentum_UI'],
    [11, 0, 'PassivesRemoved', undef, tt(9)], [11, 0, 'PassivesRemoved', undef, 'Arcana_Passive_Weightless_9'],
    [12, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Hurricane', tt(12)], [12, 0, 'PassivesAdded', undef, 'Arcana_Passive_EmptyState'],
    [12, 0, 'PassivesRemoved', wl(8), tt(11)], [12, 0, 'PassivesRemoved', undef, 'Arcana_Passive_Weightless_11'],
    (map { ([$_->[0], 0, 'PassivesAdded', undef, tt($_->[0])], [$_->[0], 0, 'PassivesRemoved', undef, tt($_->[1])]) } [13, 12], [15, 13], [17, 15], [19, 17], [20, 19]));
sub list_join { my ($old, $add, $rm) = @_; my @v = grep { length } split /;/, ($old // ''); @v = grep { $_ ne $rm } @v if defined $rm;
    push @v, $add if defined $add && !grep { $_ eq $add } @v; join ';', @v }
my @PROG;   # the final rows, level order (the multiclass level-1 row first)
for my $b (sort { $a->{a}{Level} <=> $b->{a}{Level} || (($b->{a}{IsMulticlass} // '') cmp ($a->{a}{IsMulticlass} // '')) } @BPROG) {
    my %a = %{$b->{a}}; my $lv = $a{Level}; my $mc = ($a{IsMulticlass} // '') eq 'true';
    for my $r (grep { $_->[0] == $lv && (!$mc || $_->[1]) } @ROWS) { $a{$r->[2]} = list_join($a{$r->[2]}, $r->[3], $r->[4]) }
    push @PROG, { a => \%a, o => $b->{o}, mc => $mc, level => $lv } }
my %LISTS = (1 => 'Target_Arcana_Card_Spell_GaleBurst', 2 => 'Shout_Arcana_Created_AeolusBag', 3 => 'Zone_Arcana_Card_Spell_WindBlast',
    5 => 'Shout_Arcana_Card_Spell_WindWhispers', 6 => 'Shout_Arcana_Card_Spell_FlowState;Shout_Arcana_Card_Passive_GaleDeflection',
    7 => 'Shout_Arcana_Card_Spell_StormFists', 9 => 'Shout_Arcana_Card_Ability_Untethered', 10 => 'Rush_Arcana_Created_Aspect_LeapOfFaith',
    11 => 'Target_Arcana_Created_WhereTheWindsMeet');

# ================================================================ what the Windborn owns
sub refs_of { my ($tab, $n) = @_; my $e = $tab->{$n} or return (); my %r;
    for my $k (keys %{$e->{f}}) { next if $k eq 'StackId'; my $v = $e->{f}{$k}; $r{$1} = 1 while $v =~ /\b([A-Za-z][A-Za-z0-9_]{3,})\b/g }
    $r{$e->{using}} = 1 if $e->{using}; grep { $tab->{$_} && $_ ne $n } keys %r }
sub closure { my ($tab, @roots) = @_; my %in; my @q = grep { $tab->{$_} } @roots;
    my %kids; for my $n (keys %$tab) { my $e = $tab->{$n}; push @{$kids{$e->{using}}}, $n if $e->{using}; push @{$kids{$e->{f}{RootSpellID}}}, $n if $e->{f}{RootSpellID};
        push @{$kids{$e->{f}{SpellContainerID}}}, $n if $e->{f}{SpellContainerID} }
    while (defined(my $n = shift @q)) { next if $in{$n}++; push @q, refs_of($tab, $n), grep { $tab->{$_} } @{$kids{$n} // []} } \%in }
sub tokens { my %t; for (@_) { $t{$1} = 1 while /\b([A-Za-z][A-Za-z0-9_]{3,})\b/g } keys %t }
my (%GOALS, %GOALB);
# one goal per mechanic, as the other subclasses (Owner, 2026-11-12): the marks, the bag, the Aspect alone
my $SPLIT = "$ROOT/50_ENGINEERING/55_Implementation_Specs/_wip/Unbound/goals_split";
my @GOALSPLIT = (
  ['Unbound_Windswept', "Marks mirrored (hers, and her allies' at Tier II); the release (every mark counted, then removed).", ''],
  ['Unbound_AeolusBag', "The bag: X, the cap by rank, the headwinds, the release, the wind until the start of her X-th next turn, a sweep at each of her turns the wind outlasts, `BAG_OPEN` showing the turns left; the reset at combat end.",
   "\nNumbers: the cap `2` / `3` / `4` / `5` = `FEAT_Unbound_AeolusBag#wind_cap_next`.\n"],
  ['Aspect_Fool', "Each released mark is one Awakening step; Tier II's Fellow Travellers; The Calm's gusts (Tier I's free Rush and Tier III's push live in the Stats); the reset at combat end.", ''],
);
$GOALS{$_->[0]} = slurp("$SPLIT/ARCANA_$_->[0].txt") for @GOALSPLIT;
(my $gcode = join "\n", map { $GOALS{$_->[0]} } @GOALSPLIT) =~ s{//[^\n]*}{}g;
my $COMMON = git_show("50_ENGINEERING/51_Mod_Source/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Common.txt");
my @COMMONFOOL = grep { /"FOOL"/ } split /\n/, $COMMON;
my @roots = (map({ split /;/, ($_->{a}{PassivesAdded} // '') } @PROG), map({ split /;/ } values %LISTS), 'EQP_CC_Unbound',
             tokens($gcode, @COMMONFOOL), 'Interrupt_AttackOfOpportunity');
my $OWN_ALL = closure(\%F, @roots);
my $SHARED = closure(\%B, map({ split /;/, ($_->{a}{PassivesAdded} // '') } @OTHERPROG),
    map({ my $u = $_; map { split /;/, ($BLIST{$_}{a}{Spells} // '') } ((join ' ', map { $_->{a}{Selectors} // '' } @OTHERPROG) =~ /AddSpells\(([0-9a-f-]{36})/g) } 1));
my %OWNED = map { $_ => 1 } grep { !$SHARED->{$_} } keys %$OWN_ALL;
my @SHAREDUSED = sort grep { $SHARED->{$_} } keys %$OWN_ALL;
print "the Windborn owns ", scalar(keys %OWNED), " entries; ", scalar(@SHAREDUSED), " shared with other subclasses (not typed): @SHAREDUSED\n";
if (grep { $_ eq '--owned' } @ARGV) { my %by; push @{$by{$F{$_}{pub} // '?'}}, $_ for sort keys %OWNED; print "$_ (", scalar(@{$by{$_}}), "): @{$by{$_}}\n\n" for sort keys %by; exit 0 }

# ================================================================ rendering helpers
my %LOOKF = map { $_ => 1 } qw(SpellAnimation DualWieldingSpellAnimation PrepareEffect CastEffect TargetEffect HitEffect TargetHitEffect
    TargetGroundEffect PositionEffect BeamEffect SpellEffect SelectedCharacterEffect SelectedObjectEffect SelectedPositionEffect
    DisappearEffect ReappearEffect ImpactEffect PreviewEffect Trajectories StatusEffect ApplyEffect EndEffect StatusEffectOnTurn
    StatusEffectOverride StatusEffectOverrideForItems Material MeshEffect);
my %TIPF  = map { $_ => 1 } qw(TooltipUpcastDescription TooltipOnSave TooltipOnMiss TooltipPermanentWarnings);
my %TEXTF = map { $_ => 1 } qw(DisplayName Description ExtraDescription ShortDescription LoreDescription);
my %GENF  = map { $_ => 1 } qw(RootSpellID PowerLevel UseCosts);   # what gen_upcast_variants.pl writes in every variant
my %AREA = (Spell_Target => 'SpellData / Target', Spell_Shout => 'SpellData / Shout', Spell_Rush => 'SpellData / Rush',
    Spell_Projectile => 'SpellData / Projectile', Spell_Zone => 'SpellData / Zone', Status_BOOST => 'StatusData / Status_BOOST',
    Status_EFFECT => 'StatusData / Status_EFFECT', Passive => 'Stats / Passive', Interrupt => 'Stats / Interrupt', Armor => 'Stats / Armor',
    Equipment => 'Equipment / Equipment');
sub short { my $n = shift; $n =~ s/^(Target|Shout|Rush|Zone|Projectile|Teleportation)_//; $n }
sub code { my $v = shift; return '—' if !defined $v || $v eq ''; $v =~ s/\|/\\|/g; "`$v`" }
# the 2026-10-18 Zephyr rule (WB3) in the Owner's own sentence
my %TEXTFIX = ('Arcana_Passive_Zephyr.Description' => 'After making an attack while unarmed or casting an Arcane spell, you can make a <LSTag Type="Spell" Tooltip="Target_Arcana_Created_ZephyrStrike">Zephyr Strike</LSTag> or a <LSTag Type="Spell" Tooltip="Rush_Arcana_Created_ZephyrRush">Zephyr Rush</LSTag> as a bonus action.');
# the three Awakening progress statuses (ARC-0007 shape), named after the new tiers
# one name per entry: the Owner's typing renamed the shared Zephyr Strike handles to "Zephyr Rush" (2026-10-18)
$TEXTFIX{'ZEPHYR_STRIKE.DisplayName'} = $TEXTFIX{'Target_Arcana_Created_ZephyrStrike.DisplayName'} = 'Zephyr Strike';
$TEXTFIX{'ZEPHYR_RUSH.DisplayName'} = $TEXTFIX{'Rush_Arcana_Created_ZephyrRush.DisplayName'} = 'Zephyr Rush';
($TEXTFIX{'ZEPHYR_RUSH.Description'} = $ENB{h56efad21g20d8gbfd6g293dg4e2c421af268}) =~ s/Target_Arcana_Created_ZephyrStrike">Zephyr Strike/Rush_Arcana_Created_ZephyrRush">Zephyr Rush/;
$TEXTFIX{'Arcana_Passive_TheOpenRoad.DisplayName'} = 'The Open Road';
($TEXTFIX{'Arcana_Passive_TheOpenRoad.Description'} = $ENO{h04212dafge9bcgc6d2g82d7gf9dd7540b5d0} // die "no Open Road text
") =~ s/you hit, becomes/you hit becomes/;
$TEXTFIX{'Interrupt_AttackOfOpportunity.DisplayName'} = 'Opportunity Attack';   # the vanilla texts, as the Owner's P6 copy holds them
$TEXTFIX{'Interrupt_AttackOfOpportunity.Description'} = 'Attack an enemy moving out of your reach.';
{ my @tier = ('The First Step', 'Fellow Travellers', 'Into the Storm');
  for my $i (0 .. 2) { my $id = 'ASPECT_PROGRESS_FOOL_' . ('I', 'II', 'III')[$i]; $TEXTFIX{"$id.Description"} = "Windswept marks left to release to awaken $tier[$i]." } }
my @TEXTS;   # [entry, field, text] for the localisation summary
sub text_of { ren(text_raw(@_)) }   # texts name statuses too (OR-59)
sub text_raw { my ($n, $k, $v) = @_; return $TEXTFIX{"$n.$k"} if exists $TEXTFIX{"$n.$k"};
    if ($v =~ /^\{\{(\S+)\}\}$/) { my $key = $1; return $key =~ /^h[0-9a-g]{36}$/ ? ($LOCAH{$key} // $ENO{$key} // $ENB{$key} // die "no text for $key\n") : ($LOCA{$key} // die "no text for {{$key}}\n") }
    if ($v =~ /^(h[0-9a-g]{36});\d+$/) { my $h = $1;   # an entry the Owner typed reads its own text; the others the approved or the old one
        my @src = ($F{$n} && ($F{$n}{src} // '') eq 'owner') ? ($ENO{$h}, $LOCAH{$h}, $ENB{$h}) : ($LOCAH{$h}, $ENB{$h}, $ENO{$h});
        for (@src, $ENV_VAN{$h}) { return $_ if defined && length } $NEED{$h} = 1; return "TEXT OF $h" }
    $v }
sub cell { my ($n, $k, $v) = @_; return '—' if !defined $v || $v eq '';
    if ($TEXTF{$k}) { my $t = text_of($n, $k, $v); push @TEXTS, [$n, $k, $t]; return code($t) }
    return code($TIP{$v} // $v) if $TIPF{$k}; code($v) }
sub eff { my ($n, $seen) = @_; $seen //= {}; return {} if !$n || $seen->{$n}++; my $e = $F{$n} // $VAN{$n} or return {};
    my $p = $e->{using} ? eff($e->{using}, $seen) : {}; +{ %$p, %{$e->{f}} } }
my %VANANIM; for my $n (keys %VAN) { my $sa = $VAN{$n}{f}{SpellAnimation} or next; push @{$VANANIM{$sa}}, $n }
# effect fields are picked in the Toolkit by the MultiEffectInfo's name (vanilla and the mod's own)
my %MEI; { my @d = bsd_glob("$GAME/Editor/Mods/*/MultiEffectInfos"); while (my $d = shift @d) { for my $f (bsd_glob("$d/*")) {
    if (-d $f) { push @d, $f; next } next unless $f =~ /\.mei$/; open my $h, '<:raw', $f or next; read $h, my $head, 600; close $h;
    $MEI{$1} = $2 if $head =~ /<MultiEffectInfos UUID="([^"]+)"[^>]*Name="([^"]*)"/ } } }
my %ANIMF = map { $_ => 1 } qw(SpellAnimation DualWieldingSpellAnimation Trajectories);   # copied from a parent; every other look field is picked by name
sub look_parent { my ($n, $own) = @_; my $sa = $own->{SpellAnimation} or return undef; my @c = sort @{$VANANIM{$sa} // []} or return undef;
    my ($t) = $n =~ /^(\w+?)_/; my @same = grep { /^\Q$t\E_/ } @c; my @plain = grep { !/_\d$/ } (@same ? @same : @c); (@plain ? $plain[0] : (@same ? $same[0] : $c[0])) }

# ---------------------------------------------------------------- one NEW entry
sub entry_rows { my $n = shift; my $e = $F{$n} or die "no final entry $n\n"; my $pub = $e->{pub}; my $own = $e->{f};
    my $base = $e->{f}{RootSpellID} && $e->{using} && $e->{using} eq $e->{f}{RootSpellID} ? $e->{using} : undef;   # an upcast variant
    my ($par, $kind);
    if ($base) { ($par, $kind) = ($base, 'variant') }
    elsif ($e->{using}) { $par = $e->{using}; $kind = $OWNED{$par} ? 'own' : 'vanilla' }
    elsif (my $lp = (grep { $ANIMF{$_} && length $own->{$_} } keys %$own) ? look_parent($n, $own) : undef) { ($par, $kind) = ($lp, 'look') }
    else { $kind = 'none' }
    my $R = $par ? eff($par) : {};
    my (%row, @from, @ours, @clears, @copy, @lookdiff, @picked);
    for my $k (sort { $a cmp $b } keys %{{ %$own, ($kind eq 'variant' ? () : %$R) }}) {
        next if $k =~ /^(SpellType|StatusType)$/;
        my ($v, $r) = ($own->{$k}, $R->{$k}); my $L = lbl($pub, $k);
        if ($kind eq 'variant') { next if $GENF{$k} || (defined $r && defined $v && $v eq $r); $row{$L} = cell($n, $k, $v); push @ours, $L; next }
        if ($LOOKF{$k} && !$ANIMF{$k}) { my $val = defined $v ? $v : ($kind eq 'own' ? undef : $r); next unless defined $val && $val ne '';
            my $name = $MEI{$val} // die "$n.$k: effect $val has no MultiEffectInfo name\n"; $row{$L} = code($name); push @picked, $L; next }
        if ($LOOKF{$k}) { push @copy, $L if defined $r && $r ne ''; push @lookdiff, $L if defined $v && $v ne '' && (!defined $r || $v ne $r); next }
        next if $k eq 'MemoryCost' && $pub ne 'Spell_Rush';
        if ($kind eq 'none') { $row{$L} = cell($n, $k, $v) if defined $v && $v ne ''; next }
        if (defined $v && $v ne '') {
            $row{$L} = cell($n, $k, $v);
            if (defined $r && $v eq $r && !$TEXTF{$k}) { push @from, $L }
            else { push @ours, (defined $r && $r ne '' && !$TEXTF{$k} ? "$L (the parent has " . code($TIPF{$k} ? ($TIP{$r} // $r) : $r) . ')' : $L) } }
        elsif (defined $r && $r ne '') {
            if (defined $v || $kind eq 'look') { $row{$L} = '—'; push @clears, "$L (the parent has " . ($TEXTF{$k} ? 'its own text' : code($TIPF{$k} ? ($TIP{$r} // $r) : $r)) . ')' }
            else { $row{$L} = cell($n, $k, $r); push @from, $L } } }
    my %r = (Name => code($pub =~ /^Spell_/ ? short($n) : $n), %row);
    $r{Using} = code($pub =~ /^Spell_/ ? short($par) : $par) if $par && $kind ne 'look';
    $r{Using} = code(short($par)) if $kind eq 'look';
    die "$n: its look (@lookdiff) has no parent to copy from\n" if @lookdiff && $kind eq 'none';
    { name => $n, pub => $pub, rows => \%r, picked => \@picked, from => \@from, ours => \@ours, clears => \@clears, copy => \@copy, lookdiff => \@lookdiff, par => $par, kind => $kind } }

# ================================================================ features, in the order to type them (OR-5): what others point to comes first
my @FEAT = (
 ['The mark: Windswept and the Open Path', 'Every enemy the Windborn damages becomes Windswept until the end of her next turn, and a Windswept enemy makes no opportunity attack (WB8–WB10, WB49).',
   [qw(WINDSWEPT Arcana_Passive_TheOpenRoad Interrupt_AttackOfOpportunity)]],
 ['Zephyr and its ranks', 'After an unarmed attack or an Arcane spell: Zephyr Strike, or Zephyr Rush to an enemy that isn\'t Windswept (WB3, WB5). Ranks: Gale at 4 (push, 12 m), Storm at 8 (a second Rush), Hurricane at 12 (two winds) (WB16–WB18).',
   [qw(ZEPHYR_STRIKE ZEPHYR_RUSH STORM_RUSH Arcana_Passive_Zephyr Arcana_Passive_Zephyr_Gale Arcana_Passive_Zephyr_Storm Arcana_Passive_Zephyr_Hurricane
       Target_Arcana_Created_ZephyrStrike Rush_Arcana_Created_ZephyrRush Rush_Arcana_Created_ZephyrRush_Storm)]],
 ['Aeolus\' Bag and the winds', 'A bonus action with at least one Windswept enemy: every mark is released and one wind blows for X of her turns (X = the marks, capped 2 / 3 / 4 / 5 by rank); boon on allies, bane on Windswept enemies (WB11–WB15). The goal (Osiris) moves these statuses.',
   [qw(BAG_READY BAG_OPEN TAILWIND_BOREAS HEADWIND_BOREAS TAILWIND_NOTUS HEADWIND_NOTUS TAILWIND_EURUS HEADWIND_EURUS WIND_BOREAS WIND_NOTUS WIND_EURUS
       Arcana_Passive_AeolusBag Shout_Arcana_Created_AeolusBag Shout_Arcana_Created_AeolusBag_Boreas Shout_Arcana_Created_AeolusBag_Notus
       Shout_Arcana_Created_AeolusBag_Eurus Shout_Arcana_Created_AeolusBag_BoreasNotus Shout_Arcana_Created_AeolusBag_BoreasEurus Shout_Arcana_Created_AeolusBag_NotusEurus)]],
 ['The Calm', 'The Aspect card of Tier I: only while a wind blows; the turns left become Thunder gusts on every Windswept enemy and the bag can open again (WB25, WB48).',
   [qw(CALM_GUST_1 CALM_GUST_2 CALM_GUST_3 CALM_GUST_4 CALM_GUST_5 Shout_Arcana_Created_TheCalm)]],
 ['The Awakening — 0 · The Fool', 'Released marks wake the tiers at 3 / 5 / 8 (WB22–WB24): The First Step (the first Rush each turn free), Fellow Travellers (allies\' hits mark), Into the Storm (each sweep pushes). No ability bonus.',
   [qw(INTO_THE_STORM FOOL_ZEPHYR_FREE ASPECT_PROGRESS_FOOL ASPECT_PROGRESS_FOOL_I ASPECT_PROGRESS_FOOL_II ASPECT_PROGRESS_FOOL_III
       Arcana_Passive_Aspect_Fool_Awakened_I Arcana_Passive_Aspect_Fool_Awakened_II Arcana_Passive_Aspect_Fool_Awakened_III
       ASPECT_AWAKENED_FOOL ASPECT_AWAKENED_FOOL_I ASPECT_AWAKENED_FOOL_II ASPECT_AWAKENED_FOOL_III
       Arcana_Passive_Aspect_Fool_Awakening Arcana_Passive_Aspect_Fool_I Arcana_Passive_Aspect_Fool_II Arcana_Passive_Aspect_Fool_III)]],
 ['The body: movement, defence and strikes', 'Weightless at 1 / 4 / 8 / 12 (WB39, WB47), Be the Leaf with Intelligence (WB21), the Flowing Strikes, Magic Strikes, Flowing Assault and Empty State.',
   [qw(Arcana_Passive_Weightless_1 Arcana_Passive_Weightless_4 Arcana_Passive_Weightless_8 Arcana_Passive_Weightless_12 Arcana_Passive_BetheLeaf
       Arcana_Passive_FlowingStrikesAgility Arcana_Passive_FlowingStrikesPrecision Arcana_Passive_MagicStrikes Arcana_Passive_FlowingAssault Arcana_Passive_EmptyState)]],
 ['Card · Gale Burst', 'Marks a target that fails its save; no free strike any more (WB8, WB28).', [qw(Target_Arcana_Card_Spell_GaleBurst)]],
 ['Card · Wind Blast', 'Marks every enemy that fails its save; allies are not hit (WB8).', [qw(Zone_Arcana_Card_Spell_WindBlast)]],
 ['Card · Wind Whispers', 'With Evasive Flow\'s opening Advantage folded in (WB33), and its riposte.', [qw(EVASIVE_FLOW_OPENING WIND_WHISPERS Shout_Arcana_Card_Spell_WindWhispers Target_Arcana_WindRiposte Interrupt_Arcana_WindWhispers_Riposte)]],
 ['Card · Flow State', '3 turns and one extra bonus action at every slot (WB31).', [qw(FLOW_STATE Shout_Arcana_Card_Spell_FlowState)]],
 ['Card · Ready: Gale Deflection', 'Also protects an ally within 3 m (WB32).', [qw(GALE_DEFLECTION_READY GALE_DEFLECTION_USED_TECH INTERRUPT_GALE_DEFLECT_MISSILES_HIT Arcana_Passive_GaleDeflection
    Projectile_Arcana_Reaction_GaleDeflection Shout_Arcana_Card_Passive_GaleDeflection Interrupt_Arcana_Reaction_GaleDeflection Interrupt_Arcana_Reaction_GaleDeflection_Return)]],
 ['Card · Storm Fists', 'Extra damage only against enemies that aren\'t Windswept; 3 turns at every slot (WB34).', [qw(STORM_FISTS STORM_FISTS_5 STORM_FISTS_6 Shout_Arcana_Card_Spell_StormFists)]],
 ['Card · Untethered', 'Flight with +2 Armour Class (Eye of the Storm folded in, WB35).', [qw(FLY_UNTETHERED Projectile_Arcana_Card_Ability_Fly_Untethered Shout_Arcana_Card_Ability_Untethered)]],
 ['Card · Leap of Faith', 'A level-10 card, once per Short Rest, on the Force Tunnel dash (WB7, WB38).', [qw(Rush_Arcana_Created_Aspect_LeapOfFaith)]],
 ['Card · Where the Winds Meet', 'The capstone, aimed at the ground: one 9 m area; Windswept enemies pulled 9 m, the others 6 m (WB26, WB46, WB49, WB50).', [qw(Target_Arcana_Created_WhereTheWindsMeet)]],
 ['Starting equipment', 'The Windborn\'s robe and the character-creation kit.', [qw(ARCANA_CC_ARM_Robe_Unbound EQP_CC_Unbound)]],
);
my %RANK = (Status_BOOST => 0, Status_EFFECT => 0, Passive => 1, Spell_Projectile => 2, Spell_Target => 2, Spell_Shout => 2, Spell_Rush => 2, Spell_Zone => 2, Interrupt => 3, Armor => 4, Equipment => 5);
my %VARS; for my $n (keys %OWNED) { my $b = $F{$n}{f}{RootSpellID} or next; push @{$VARS{$b}}, $n if $F{$n}{using} && $F{$n}{using} eq $b }
my %placed; for my $f (@FEAT) { for (@{$f->[2]}) { die "$_ is not a Windborn entry\n" unless $OWNED{$_}; $placed{$_} = 1; $placed{$_} = 1 for @{$VARS{$_} // []} } }
my @unplaced = sort grep { !$placed{$_} } keys %OWNED; die "not placed in a feature: @unplaced\n" if @unplaced;
sub typed_variant { my $n = shift; my $e = $F{$n}; my $b = eff($e->{using}); grep { !$GENF{$_} && (!defined $b->{$_} || $e->{f}{$_} ne $b->{$_}) } keys %{$e->{f}} }

# the origin of every number (ADR-0008)
my %NUM = (
  WINDSWEPT => '`2` (each mark is applied for 2 of her turn ends) = `FEAT_Unbound_TheOpenRoad#windswept_duration_next`.',
  Rush_Arcana_Created_ZephyrRush => '`12` = `FEAT_Unbound_TheOpenRoad#rush_range_next`; `9` = `#rush_range_breeze_next`; `3` = `#gale_push_next`.',
  Target_Arcana_Created_ZephyrStrike => '`3` = `FEAT_Unbound_TheOpenRoad#gale_push_next`.', Arcana_Passive_Zephyr_Gale => '`3` = `FEAT_Unbound_TheOpenRoad#gale_push_next`.',
  Rush_Arcana_Created_ZephyrRush_Storm => '`9` = `FEAT_Unbound_TheOpenRoad#storm_rush_range_next`.',
  Arcana_Passive_Zephyr_Hurricane => '`2` winds = `FEAT_Unbound_AeolusBag#hurricane_winds_next`.',
  TAILWIND_BOREAS => '`3` = `FEAT_Unbound_AeolusBag#boreas_ally_next`.', HEADWIND_BOREAS => '`3` = `FEAT_Unbound_AeolusBag#boreas_enemy_next`.',
  HEADWIND_NOTUS => '`1` = `FEAT_Unbound_AeolusBag#notus_enemy_next`.', TAILWIND_EURUS => '`1` = `FEAT_Unbound_AeolusBag#eurus_ally_next`.',
  HEADWIND_EURUS => '`1` = `FEAT_Unbound_AeolusBag#eurus_enemy_next`.', Shout_Arcana_Created_TheCalm => '`1d8` = `SPL_Unbound_TheCalm#gust_damage_next`.',
  CALM_GUST_1 => '`1d8` per gust to level 6, `2d6` from 7 = `SPL_Unbound_TheCalm#gust_damage_next` `by_level`; gust *n* deals *n* times that.',
  INTO_THE_STORM => '`3` = `FEAT_Unbound_AspectAwakening#tier3_push_next`.', Arcana_Passive_Aspect_Fool_III => '`3` = `FEAT_Unbound_AspectAwakening#tier3_push_next`.',
  Arcana_Passive_Weightless_1 => '`3` = `FEAT_Unbound_Weightless#speed_next` (1).', Arcana_Passive_Weightless_4 => '`4.5` / `2` / `0.5` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (4).',
  Arcana_Passive_Weightless_8 => '`6` / `3` / `0.5` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (8).',
  Arcana_Passive_Weightless_12 => '`9` / `4` / `0` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (12).',
  Shout_Arcana_Card_Spell_FlowState => '`3` turns = `SPL_Unbound_FlowState#duration_next`.', STORM_FISTS => '`3` turns (the cards) = `SPL_Unbound_StormFists#duration_next`.',
  FLY_UNTETHERED => '`2` = `SPL_Unbound_Untethered#flying_ac_next`.', Interrupt_Arcana_Reaction_GaleDeflection => '`3` = `SPL_Unbound_GaleDeflection#ally_range_next`.',
  Target_Arcana_Created_WhereTheWindsMeet => '`18` = `SPL_Unbound_WhereTheWindsMeet#range_next`; `9` (AreaRadius) = `#area_radius_next`; `9` / `6` = `#pull_distance_windswept_next` / `#pull_distance_next`; `4d8` = `#damage_next`.');

sub notes_of { my $x = shift; my $s = $x->{par} ? ($x->{pub} =~ /^Spell_/ ? short($x->{par}) : $x->{par}) : ''; my @o;
    if ($x->{kind} eq 'variant') { push @o, "Notes — `$x->{name}`: an upcast of `$s` (`Using`); type only the rows above. `gen_upcast_variants.pl` writes its RootSpellID, PowerLevel and UseCosts after you save." }
    elsif ($x->{kind} eq 'own') { push @o, "Notes — `$x->{name}` (`Using` = `$s`, typed above; it stays):", ($x->{from} && @{$x->{from}} ? '- **From the parent:** ' . join(', ', @{$x->{from}}) . '.' : ()) }
    elsif ($x->{kind} eq 'none') { push @o, "Notes — `$x->{name}`:" }
    else { push @o, "Notes — `$x->{name}` (`Using` = `$s`; search `$s` in the picker" . ($x->{kind} eq 'look' ? ' — only to copy its look' : '') . '):';
        my %diff = map { $_ => 1 } @{$x->{lookdiff}}; my @same = grep { !$diff{$_} } @{$x->{copy}};
        push @o, '- **Copy from the parent in the Toolkit, then remove `Using`:** ' . join(', ', @same) . '.' if @same;
        for my $L (@{$x->{lookdiff}}) { my $own = $F{$x->{name}}{f}{SpellAnimation}; my $src = $own ? look_parent($x->{name}, { SpellAnimation => $own }) : undef;
            push @o, "- **$L: copy it from `" . ($src // die "$x->{name}: no vanilla spell has its $L\n") . "`** (open it in the Toolkit, copy the field, paste it here) — not from the parent." }
        push @o, '- **From the parent:** ' . join(', ', @{$x->{from}}) . '.' if @{$x->{from}};
        push @o, "- MemoryCost: the parent's `1` stays and does no harm (cards are always prepared)." if $x->{pub} ne 'Spell_Rush' && (eff($x->{par})->{MemoryCost} // '') =~ /^[1-9]/ }
    push @o, '- **Ours:** ' . join(', ', @{$x->{ours}}) . '.' if @{$x->{ours}} && $x->{kind} ne 'variant' && $x->{kind} ne 'none';
    push @o, '- **Clears the parent:** ' . join(', ', @{$x->{clears}}) . '.' if @{$x->{clears}};
    push @o, "- **Picked by name in the field's list** (an effect): " . join(', ', @{$x->{picked}}) . '.' if @{$x->{picked} // []};
    @o = () if @o == 1 && $o[0] =~ /:$/;   # nothing to say
    push @o, (@o ? '' : ()), "Numbers (`$x->{name}`): $NUM{$x->{name}}" if $NUM{$x->{name}};
    join "\n", @o }
sub block { my ($num, $title, @x) = @_; my $pub = $x[0]{pub};
    my %all; $all{$_} = 1 for map { keys %{$_->{rows}} } @x;
    my @f = ('Name', (grep { $_ eq 'Using' } keys %all), sort grep { $_ ne 'Name' && $_ ne 'Using' } keys %all);
    my @o = ("### $num · NEW · $AREA{$pub} · $title", '', '| Field | ' . join(' | ', map { "`$_->{name}`" } @x) . ' |', '|---|' . join('|', map { '---' } @x) . '|');
    push @o, "| $_ | " . join(' | ', map { my $c = $_->{rows}; $c->{$_[0]} } @x) . ' |' for ();
    for my $k (@f) { push @o, "| $k | " . join(' | ', map { $_->{rows}{$k} // '—' } @x) . ' |' }
    my @v = grep { $_->{kind} eq 'variant' } @x;
    my @n = grep { length } map { notes_of($_) } grep { $_->{kind} ne 'variant' } @x;
    push @n, 'Notes — ' . join(', ', map { "`$_->{name}`" } @v) . ': upcast' . (@v > 1 ? 's' : '') . ' of `' . short($v[0]{par}) . "` (its `Using`); type only the rows above — `gen_upcast_variants.pl` writes their RootSpellID, PowerLevel and UseCosts after you save." if @v;
    push @o, '', join("\n\n", @n) if @n; push @o, ''; join "\n", @o }

# every player-cast spell must have an animation and a cast text event (ARC-0026 probe P1, check_castable.pl)
{ my @bad; for my $n (sort grep { /^(Target|Shout|Rush|Zone|Projectile)_/ && !/(_Explosion|Inner)$/ && !/^Projectile_Arcana_Reaction_/ } keys %OWNED) {
      my $r = eff($n); push @bad, "$n (" . join('/', grep { !length($r->{$_} // '') } qw(SpellAnimation CastTextEvent)) . ')' if grep { !length($r->{$_} // '') } qw(SpellAnimation CastTextEvent) }
  die "not castable: @bad\n" if @bad; print "castable: every Windborn spell has a Spell Animation and a CastTextEvent\n" }
exit 0 if $CHECK;
# ================================================================ assemble the file
my (@order, @stats, @uuid, @stories, @gen, %stepof);
my $step = 0; my $next = sub { sprintf '%02d', ++$step };
my $row = sub { my ($area, $file, $entry, $action, $needs) = @_; my $n = $next->(); push @order, [$n, $area, $file, $entry, $action, $needs // '—']; $n };
my @NUMS;
for my $fi (0 .. $#FEAT) { my ($title, $intro, $list) = @{$FEAT[$fi]};
    my @entries = map { my $b = $_; ($b, (sort grep { typed_variant($_) } @{$VARS{$b} // []})) } @$list;
    @entries = map { $_->[1] } sort { $a->[0] <=> $b->[0] } map { my $i = $_; [($RANK{$F{$entries[$i]}{pub}} // 9) * 1000 + $i, $entries[$i]] } 0 .. $#entries;
    my @genv = map { my $b = $_; sort grep { !typed_variant($_) } @{$VARS{$b} // []} } @$list;
    push @stats, sprintf("## 3.%d · %s\n\n%s\n", $fi + 1, $title, $intro);
    my @cur; my $flush = sub { return unless @cur; my $first = $step + 1;
        for (@cur) { my $needs = join ', ', sort { $a <=> $b } grep { defined } map { $stepof{$_} } refs_of(\%F, $_);
            $stepof{$_} = $row->('Stats Editor', $AREA{$F{$_}{pub}}, "`$_`", 'new', $needs || '—') }
        my $num = @cur > 1 ? sprintf('%02d–%02d', $first, $step) : sprintf('%02d', $first);
        my @x = map { entry_rows($_) } @cur;
        my $t = join ', ', map { my $d = $F{$_}{f}{DisplayName}; $d && $d ne '' ? text_of($_, 'DisplayName', $d) : "`$_`" } @cur;
        push @stats, block($num, $t, @x); push @NUMS, map { $NUM{$_} // () } @cur; @cur = () };
    for my $n (@entries) { $flush->() if @cur && ($F{$cur[0]}{pub} ne $F{$n}{pub} || @cur == 3); push @cur, $n } $flush->();
    push @stats, "Generated after you save (do not type): " . join(', ', map { "`$_`" } @genv) . " — `gen_upcast_variants.pl` makes them from the card above.\n" if @genv }

# ---------------------------------------------------------------- UUID Object Editor (lists → progression → class → defaults)
sub uuid_table { my ($node, $skip, $over) = @_; my @r;
    my @keys = sort { ($a eq 'Name' ? 0 : 1) <=> ($b eq 'Name' ? 0 : 1) or (($a =~ /^Level(\d+)$/)[0] // 0) <=> (($b =~ /^Level(\d+)$/)[0] // 0) } @{$node->{o}};
    for my $k (@keys) { next if $skip->{$k}; my $v = exists $over->{$k} ? $over->{$k} : $node->{a}{$k};
        my $c = $v =~ /^h[0-9a-g]{36}$/ ? do { my $t = $LOCAH{$v} // $ENO{$v} // $ENB{$v}; push @TEXTS, ['(UUID object)', $k, $t]; code($t) } : code($v);
        push @r, "| $k | $c |" } "| Field | Value |\n|---|---|\n" . join("\n", @r) . "\n" }
my %RESNAME = map { $_ => 1 } qw(ArcanaGaleDeflectReturn ArcanaReactGaleDeflection);
for my $res (grep { $RESNAME{$_->{a}{Name} // ''} } @BRES) { my $n = $row->('UUID Object Editor', 'ActionResourceDefinitions', "`$res->{a}{Name}`", 'new');
    $stepof{$res->{a}{Name}} = $n; push @uuid, "### $n · NEW · ActionResourceDefinitions · `$res->{a}{Name}`\n\n" . uuid_table($res, { UUID => 1 }) }
for my $lm (grep { ($_->{a}{Name} // '') eq 'GaleBurst_Damage' } @BLMAP) { my $n = $row->('UUID Object Editor', 'Levelmaps / LevelMapValues', '`GaleBurst_Damage`', 'new');
    push @uuid, "### $n · NEW · Levelmaps / LevelMapValues · `GaleBurst_Damage`\n\n" . uuid_table($lm, { UUID => 1 }) . "\nUsed by Leap of Faith's Thunder damage.\n" }
my %LISTSTEP;
for my $lv (sort { $a <=> $b } keys %LISTS) { my $n = $row->('UUID Object Editor', 'Lists / SpellLists', "\"Unbound Level $lv\"", 'new', join(', ', grep { defined } map { $stepof{$_} } split /;/, $LISTS{$lv}) || '—');
    $LISTSTEP{$lv} = $n; push @uuid, "### $n · NEW · Lists / SpellLists · \"Unbound Level $lv\"\n\n| Field | Value |\n|---|---|\n| Name | `Unbound Level $lv` |\n| Spells | `$LISTS{$lv}` |\n\nUUID: ________\n" }
{ my $n = $row->('UUID Object Editor', 'Progressions / Progressions', 'the Windborn table, levels 1–20 (21 rows)', 'new', join(', ', map { $LISTSTEP{$_} } sort { $a <=> $b } keys %LISTSTEP));
  my @r; for my $p (@PROG) { my %a = %{$p->{a}};
      my $sel = $a{Selectors} // ''; $sel =~ s/AddSpells\(([0-9a-f-]{36})/my $u = $1; my ($lv) = grep { $BLIST{$u} && ($BLIST{$u}{a}{Name} =~ m{Level (\d+)}) && $1 == $_ } keys %LISTS; $lv ? "AddSpells(<UUID from step $LISTSTEP{$lv}>" : "AddSpells($u"/ge;
      $sel =~ s/LIST(\d+)/AddSpells(<UUID from step $LISTSTEP{$1}>,,,,AlwaysPrepared)/g;
      push @r, sprintf '| %s | %s | %s | %s | %s | %s |', $a{Level} . ($p->{mc} ? ' (multiclass)' : ''), (map { code($_) } @a{qw(PassivesAdded PassivesRemoved Boosts)}), code($sel), code($a{AllowImprovement}) }
  push @uuid, "### $n · NEW · Progressions / Progressions · the Windborn table\n\nEvery row: `Name` `Unbound`, `ProgressionType` `1` (subclass), `TableUUID` = one new GUID for the whole table (write it here: ________ — steps "
     . sprintf('%02d', $step + 1) . "–" . sprintf('%02d', $step + 3) . " use it). The level-1 row exists twice: the normal one and the multiclass one (`IsMulticlass` true). A row with every cell `—` still exists (one row per level).\n\n| Level | PassivesAdded | PassivesRemoved | Boosts | Selectors | AllowImprovement |\n|---|---|---|---|---|---|\n" . join("\n", @r) . "\n" }
{ my $n = $row->('UUID Object Editor', 'Progressions / ProgressionDescriptions', 'the Windborn', 'new');
  push @uuid, "### $n · NEW · Progressions / ProgressionDescriptions · the Windborn\n\n" . uuid_table($BPDESC, { UUID => 1 }, { ProgressionTableId => '<the table GUID>' }) }
{ my $n = $row->('UUID Object Editor', 'ClassDescriptions', 'Unbound (the Windborn)', 'new');
  push @uuid, "### $n · NEW · ClassDescriptions · `Unbound` (the Windborn)\n\n" . uuid_table($BCLASS, { UUID => 1, Object => 1 },{ ProgressionTableUUID => '<the table GUID>' })
     . "\nTags: `e1e460bb-d0ae-4452-8529-c9e176558731` and `1901f3df-a4aa-4633-80eb-13e9148c2928` (the Windborn tag — an asset, kept).\n\nUUID: ________ (the class; used in the next steps)\n"; $stepof{CLASS} = $n }
for my $d (@BDEF) { my $n = $row->('UUID Object Editor', "DefaultValues / $d->{file}", 'the Windborn, level 1', 'new');
  push @uuid, "### $n · NEW · DefaultValues / $d->{file} · the Windborn, level 1\n\n" . uuid_table($d, { UUID => 1 }, { TableUUID => '<the table GUID>' }) }
{ my $n = $row->('UUID Object Editor', 'CharacterCreationPresets / AbilityDistributionPresets', 'the Windborn', 'new', $stepof{CLASS});
  my %v = (Strength => 8, Dexterity => 15, Constitution => 13, Intelligence => 15, Wisdom => 10, Charisma => 10);
  push @uuid, "### $n · NEW · CharacterCreationPresets / AbilityDistributionPresets · the Windborn\n\n| Field | Value |\n|---|---|\n| ClassUUID | `<UUID from step $stepof{CLASS}>` |\n"
     . join("\n", map { "| $_ | `$v{$_}` |" } qw(Strength Dexterity Constitution Intelligence Wisdom Charisma)) . "\n\nNumbers: `CLS_Unbound#preset_next` (WB21: DEX and INT for Be the Leaf).\n"; push @NUMS, '`CLS_Unbound#preset_next`' }
{ my $n = $row->('UUID Object Editor', 'Progressions / Progressions', 'Arcana level 1 (both rows)', 'change', $stepof{CLASS});
  push @uuid, "### $n · CHANGED · Progressions / Progressions · the Arcana class, level 1 (`39f4e9d3…` and `082473bf…`)\n\nIn both rows, add the Windborn to **SubClasses**: `<UUID from step $stepof{CLASS}>` (if you deleted the old Unbound, its entry left this list with it).\n" }

# ---------------------------------------------------------------- Osiris (last: everything it names exists)
{ my $names = join(', ', map { "`ARCANA_$_->[0]`" } @GOALSPLIT);
  my $n = $row->('Stories', 'Goals', $names, 'new goals', '—');
  my $s = "### $n · NEW goals $names — parent goal: the same as the other `ARCANA_` goals\n\nOne goal per mechanic, as the other subclasses: the marks, the bag, and the Aspect alone. Create the three, then compile once.\n";
  for my $gs (@GOALSPLIT) { (my $g = $GOALS{$gs->[0]}) =~ s/\n+$//; $s .= "\n#### `ARCANA_$gs->[0]`\n\n$gs->[1]\n\n```\n$g\n```\n$gs->[2]" }
  push @stories, $s; push @NUMS, '`FEAT_Unbound_AeolusBag#wind_cap_next`' }
{ my $n = $row->('Stories', 'Goals', '`ARCANA_Aspect_Common`', 'check the Fool lines', '—');
  my @l = map { my $x = $_; $x =~ s/^\s+//; $x =~ s/("FOOL", 2, "Arcana_Passive_Aspect_Fool_II", "ASPECT_AWAKENED_FOOL_II", )4\)/${1}5)/; $x =~ s/("FOOL", 3, "Arcana_Passive_Aspect_Fool_III", "ASPECT_AWAKENED_FOOL_III", )5\)/${1}8)/; $x } @COMMONFOOL;
  push @stories, "### $n · CHANGED goal `ARCANA_Aspect_Common` — the Fool lines (a shared goal: only these lines)\n\nIn `PROC_ARCANA_Aspect_Init()`, the Fool's lines must read exactly:\n\n```\n" . join("\n", @l) . "\n```\n\nNumbers: goals `3` / `5` / `8` = `FEAT_Unbound_AspectAwakening#goals_next`.\n"; push @NUMS, '`FEAT_Unbound_AspectAwakening#goals_next`' }
push @stories, "After pasting: **compile** in the Story Editor and read `Mods/AspectClass_…/Story/log.txt` — it must end with `0 error(s)`. A warning such as *Database defined but never checked* is a defect: send me the log.\n";
my $gstep = $row->('—', 'Generated and PC edition', 'upcast variants, `ARCANA_CardFamilies`, `CardDB.lua`', 'Claude', 'all above');

# ---------------------------------------------------------------- write
my %seen; my @tx = grep { !$seen{"$_->[0]|$_->[1]|$_->[2]"}++ } @TEXTS;
my %der; for (@NUMS) { while (/`((?:SPL|FEAT)_Unbound_\w+|CLS_Unbound)#/g) { my $id = $1; $der{'25.0' . ($id =~ /^SPL/ ? 1 : $id =~ /^FEAT/ ? 2 : 4) . "/$id.yaml"} = 1 } }
my $today = do { my @t = localtime; sprintf '%04d-%02d-%02d', $t[5] + 1900, $t[4] + 1, $t[3] };
(my $tpl = slurp("$ROOT/50_ENGINEERING/55_Implementation_Specs/_TEMPLATE_TOOLKIT_GUIDE.md"));
my ($RULES) = $tpl =~ /(## Rules for whoever writes this file\n.*?)\n---\n/s or die "template: no rules\n";
my ($KEY) = $tpl =~ /\n(> \*\*Every cell is exactly what you paste\*\*.*?)\n\n/s or die "template: no reading key\n";
my $o = "---\nid: TOOLKIT_ARC-0026\nticket: ARC-0026\nspec: SPEC_ARC-0026\nstatus: draft\nderived_from: [" . join(', ', sort keys %der) . "]\ngenerated_at: $today\nauthor: Mod Engineer\n---\n\n"
  . "# TOOLKIT_ARC-0026 · The Windborn — the whole subclass, from zero\n\n"
  . "> **What this file is.** Everything to type in the BG3 Toolkit to build the Windborn (internal name *Unbound*) **from zero**,\n"
  . "> after you delete the old Unbound: " . scalar(keys %OWNED) . " Stats entries, the lists, the progression, the class objects and two goals — the final\n"
  . "> version of the decisions WB0–WB50 and of the answers of 2026-10-18. One file, in the order to type it, **feature by\n"
  . "> feature** (OR-5): §0 is the checklist top to bottom; each feature is complete in its part of §3; what each level grants is\n"
  . "> written once, in the progression (§2). The tests, level by level, are in `QA_ARC-0026`.\n>\n"
  . "> **Not in this file:** the robe's RootTemplate (`d586b188…`), the Windborn tag (`1901f3df…`) and the class icons are assets — keep\n"
  . "> them. `ARCANA_WEAVING` is shared with the other subclasses — don't delete it. Generated by `_wip/Unbound/arc0026/63_toolkit_full.pl`;\n"
  . "> regenerate it, never edit a number by hand (ADR-0008).\n\n---\n\n$RULES\n---\n\n## 0 · Order of work\n\n"
  . "| # | Area | File | Entry | Action | Needs | ☐ |\n|---|---|---|---|---|---|---|\n" . join('', map { "| $_->[0] | $_->[1] | $_->[2] | $_->[3] | $_->[4] | $_->[5] | ☐ |\n" } @order)
  . "\n---\n\n## 1 · Stories (Osiris)\n\nTyped **last** (steps " . join(', ', map { $_->[0] } grep { $_->[1] eq 'Stories' } @order) . "): by then every status and spell they name exists.\n\n" . join("\n", @stories)
  . "\n---\n\n## 2 · UUID Object Editor\n\nAfter the Stats (§3). The Toolkit makes every UUID; write each one in its slot.\n\n" . join("\n", @uuid)
  . "\n---\n\n## 3 · Stats Editor\n\n$KEY\n\nEvery Icon below is a suggestion: check it in the Toolkit (the custom `ICO_` icons come later).\n\n" . join("\n", @stats)
  . "\n### Generated and PC edition — do not type\n\n| # | What | Built by | When |\n|---|---|---|---|\n"
  . "| $gstep | The upcast variants listed under each card (cost, RootSpellID, PowerLevel), the typed ones completed; `ARCANA_CardFamilies` | `82_Automation/stats/gen_upcast_variants.pl --apply`, `sort_stats.pl --apply`, `check_cards.pl` | after you save |\n"
  . "| $gstep | The PC deck (`CardDB.lua`): Zephyr Rush, the bag, The Calm, Storm's Rush, Leap of Faith, Where the Winds Meet | Claude (`lua/CardDB.patch`) | after you save |\n"
  . "\n---\n\n## 4 · Localisation summary\n\nEvery text typed above, in one table, so nothing is missed.\n\n| Entry | Field | English text |\n|---|---|---|\n"
  . join('', map { "| `$_->[0]` | $_->[1] | " . code($_->[2]) . " |\n" } @tx)
  . "\n---\n\n## 5 · After the Toolkit\n\n1. Stats Editor → *File → Reload Stats Files*; Story Editor → compile, read `Story/log.txt` (`0 error(s)`).\n"
  . "2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026`): I check every entry against this file, run `sync_data`,\n   the generators and `CardDB.lua` of the *Generated* table, then `check_cards.pl`, and commit (OR-11: I fix only divergences).\n"
  . "3. Play `QA_ARC-0026` level by level.\n4. Tick the steps in section 0.\n";
if (%NEED) { open my $q, '>', "$WIP/vanilla_texts.need" or die; print $q "$_\n" for sort keys %NEED; close $q; die scalar(keys %NEED) . " vanilla texts missing: see vanilla_texts.need\n" }
open my $h, '>:raw:encoding(UTF-8)', $OUTF or die "$OUTF: $!"; print $h $o; close $h;
print "TOOLKIT_ARC-0026.md: ", scalar(@order), " steps, ", scalar(keys %OWNED), " entries\n";
print `perl "$ROOT/80_TOOLS_AND_PIPELINE/82_Automation/stats/order_toolkit_guide.pl" --apply "$OUTF" 2>&1`;

# ================================================================ SPEC_ARC-0026.md: the same build, as the technical source (OR-5 order)
{ my $SPEC = "$ROOT/50_ENGINEERING/55_Implementation_Specs/SPEC_ARC-0026.md"; my $old = slurp($SPEC);
  my $hist = $old =~ /\n<!-- history -->\n(.*)\z/s ? $1 : do { (my $h = $old) =~ s/\A---\n.*?\n---\n\n//s; "## The per-level build kit (2026-10-17, superseded on 2026-10-18)\n\n$h" };
  my $s = "---\nid: SPEC_ARC-0026\nticket: ARC-0026\nstatus: draft\nimplementation: owner\nauthor: Mod Engineer\nupdated: $today\n---\n\n"
    . "# SPEC_ARC-0026 · The Windborn — implementation plan\n\n"
    . "> Technical source for building the Windborn (internal name *Unbound*) **from zero** in the Toolkit (Owner, 2026-10-18: the old\n"
    . "> Unbound is deleted and typed again). The typing view is **`TOOLKIT_ARC-0026.md`** (one file, OR-4), in the order to implement,\n"
    . "> feature by feature (OR-5). The tests, level by level, are **`61.02/Unbound/QA_ARC-0026.md`**. Both this file and the Toolkit file\n"
    . "> are generated by `_wip/Unbound/arc0026/63_toolkit_full.pl` — rerun it after a decision or a `25` change.\n\n"
    . "**Intent:** the game plays the Windborn as `21.04/Unbound/DESIGN.md` describes it (WB0–WB51), in both editions.\n\n"
    . "**Design:** `21.04/Unbound/DESIGN.md` · **Decisions:** `21.04/Unbound/DECISIONS.md` · **Numbers:** `25` (`*_Unbound_*.yaml`) ·\n"
    . "**Texts:** `_wip/Unbound/arc0026/00_texts.md` (approved) and the Owner's own texts in the game · **Balance:** `22.05/Unbound.md`.\n\n"
    . "## Global constraints\n\n"
    . "- Built from zero: " . scalar(keys %OWNED) . " Stats entries the Windborn owns (computed from its progression, lists, starting kit and goals;\n"
    . "  shared entries such as `ARCANA_WEAVING` are not touched), its lists and progression, its class objects and two goals.\n"
    . "- Ids by OR-59: statuses in UPPER_SNAKE_CASE without `ARCANA_` (`WINDSWEPT`, `BAG_READY`, `WIND_BOREAS`, `CALM_GUST_1` …);\n"
    . "  cards keep their published ids; new passives `Arcana_Passive_X`. Internal names keep *Unbound* / *Fool* (ADR-0002).\n"
    . "- The final version = the game before ARC-0026 (`$BASE`) + the build patches 10–40 + the Owner's typing of 2026-10-17/18 where it\n"
    . "  agrees with the decisions + WB51 (the answers of 2026-10-18). The armour rule is written `not (WearingArmor(context.Source) or\n"
    . "  HasShieldEquipped(context.Source))` everywhere.\n"
    . "- Every player-cast spell has a Spell Animation and a `CastTextEvent` (checked by the generator); effects are picked by name;\n"
    . "  animations are copied from a named vanilla spell (template rule 12).\n"
    . "- Upcast variants: typed only where they differ from the card (Gale Burst `_3`–`_6`, Flow State `_5`–`_6` …); the generator\n"
    . "  writes the rest and every variant's cost. The PC deck (`CardDB.lua`) is Claude's, after the Owner saves.\n\n"
    . "## Implementation order — feature by feature\n\n| # | Feature | Entries | Toolkit part |\n|---|---|---|---|\n";
  for my $i (0 .. $#FEAT) { my ($t, $intro, $l) = @{$FEAT[$i]}; my @all = map { ($_, sort @{$VARS{$_} // []}) } @$l;
      $s .= sprintf "| %d | %s | %d | §3.%d |\n", $i + 1, $t, scalar(@all), $i + 1 }
  $s .= "| " . (@FEAT + 1) . " | Lists, progression, class, defaults, preset (what each level grants) | — | §2 |\n| " . (@FEAT + 2) . " | Osiris: `ARCANA_Aspect_Fool`, the Fool lines of `ARCANA_Aspect_Common` | — | §1 |\n\n";
  for my $i (0 .. $#FEAT) { my ($t, $intro, $l) = @{$FEAT[$i]};
      $s .= "### " . ($i + 1) . " · $t\n\n$intro\n\n" . join(', ', map { my $b = $_; "`$b`" . (@{$VARS{$b} // []} ? ' (+ ' . join(', ', map { (/(_\d+)$/)[0] } sort @{$VARS{$b}}) . ')' : '') } @$l) . "\n\n" }
  $s .= "## What each level grants\n\n| Level | Passives added | Passives removed | Spells (list) | Other |\n|---|---|---|---|---|\n";
  for my $p (@PROG) { next if $p->{mc}; my $lv = $p->{level}; my %a = %{$p->{a}};
      $s .= "| $lv | " . join(' | ', map { code($_) } @a{qw(PassivesAdded PassivesRemoved)}) . ' | ' . code($LISTS{$lv}) . ' | ' . code($lv == 1 ? 'the multiclass row grants the same passives' : $a{Boosts}) . " |\n" }
  $s .= "\n## Not in the Windborn any more (not typed)\n\n" . join(', ', map { "`$_`" } sort keys %RETIRED)
     . ".\nAlso gone: Twinkle Toes and the old Weightless chain (Weightless 1/4/8/12 replace them), Target_TrueStrike from the level-1 list.\n\n"
     . "## Tests\n\n`61.02/Unbound/QA_ARC-0026.md`, level by level.\n\n<!-- history -->\n$hist";
  open my $h, '>:raw:encoding(UTF-8)', $SPEC or die; print $h $s; close $h; my $ln = () = $s =~ /\n/g; print "SPEC_ARC-0026.md: $ln lines\n" }
