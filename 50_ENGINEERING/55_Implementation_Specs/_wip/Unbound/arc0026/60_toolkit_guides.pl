#!/usr/bin/perl
# ARC-0026 — writes the twelve Toolkit guides TOOLKIT_ARC-0026_L01.md … _L12.md (one per level) for the Owner to type
# by hand, following every rule of 55_Implementation_Specs/_TEMPLATE_TOOLKIT_GUIDE.md.
# Sources (read only):
#   - the build patches 10_core / 20_bag_awakening / 30_ranks_cards / 40_capstone_names (entries, fields, texts);
#   - the game as it was before ARC-0026 (commit 09f30e0): the 51 .txt files for everything stage 2 did not touch, the
#     09f30e0 .stats for the fields stage 2 did touch, english.xml, Lists / Progressions / presets .lsx;
#   - vanilla (the local extraction) for every `using` parent and the TooltipExtras names.
# The level of each change is the manifest below (%LEVEL). After writing, run
#   perl 80_TOOLS_AND_PIPELINE/82_Automation/stats/order_toolkit_guide.pl --apply <guide>
# on each guide (the script does it). Numbers' origins (ADR-0008) come from %NUM.
#   perl 60_toolkit_guides.pl            # writes the 12 guides next to SPEC_ARC-0026.md
#   perl 60_toolkit_guides.pl --check    # self-check only (every patch change has a level; nothing assigned twice)
use strict; use warnings; use utf8; use File::Glob qw(bsd_glob);
binmode STDOUT, ':utf8';
my $ROOT = 'C:/Lumox Studios/Arcana Class';
my $WIP  = "$ROOT/50_ENGINEERING/55_Implementation_Specs/_wip/Unbound/arc0026";
my $OUT  = "$ROOT/50_ENGINEERING/55_Implementation_Specs";
my $M    = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $S51  = "$ROOT/50_ENGINEERING/51_Mod_Source";
my $BASE = '09f30e0';   # the game before ARC-0026 wrote anything
my $V    = 'C:/Projetos/BG3/Base Game BG3/Assets';
my $CHECK = grep { $_ eq '--check' } @ARGV;

sub slurp { my $f = shift; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h; $s =~ s/^\xEF\xBB\xBF//; utf8::decode($s); $s }
sub git_show { my $p = shift; my $s = `git -C "$ROOT" show $BASE:"$p"`; die "git show $p failed\n" if $?; $s =~ s/^\xEF\xBB\xBF//; utf8::decode($s); $s }

# ---------------------------------------------------------------- patches
my (%P, @SETS, @DELS, %LOCA, %LOCAH);   # %P name -> {file, using, f => {k=>v}, o => [k]}; @SETS [file,name,k,v]
our %HUSE;   # handle -> the entries that use it (filled below)
for my $pf (qw(10_core 20_bag_awakening 30_ranks_cards 40_capstone_names)) {
    my ($file, $cur);
    for my $l (split /\r?\n/, slurp("$WIP/$pf.patch")) {
        if    ($l =~ /^\@file (\S+)/)            { $file = $1; undef $cur }
        elsif ($l =~ /^\@loca (\S+) (.*)$/)      { my ($k, $t) = ($1, $2); if ($k =~ /^h[0-9a-g]{36}$/) { $LOCAH{$k} = $t } else { $LOCA{$k} = $t } }
        elsif ($l =~ /^\@set (\S+) (\S+) ?(.*)$/) { my @s = ($1, $2, $3); $s[2] =~ s/^"(.*)"$/$1/; push @SETS, [$file, @s, $pf]; undef $cur }
        elsif ($l =~ /^\@remove (\S+)/)          { push @DELS, [$file, $1, $pf]; undef $cur }
        elsif ($l =~ /^new entry "(.+)"/)        { $cur = $1; $P{$cur} = { file => $file, f => {}, o => [], patch => $pf } }
        elsif (defined $cur && $l =~ /^using "(.+)"/) { $P{$cur}{using} = $1 }
        elsif (defined $cur && $l =~ /^data "(\w+)" "(.*)"$/) { push @{$P{$cur}{o}}, $1 unless exists $P{$cur}{f}{$1}; $P{$cur}{f}{$1} = $2 }
        elsif ($l =~ /^\s*$/)                    { undef $cur }
    }
}

# ---------------------------------------------------------------- text files: vanilla + the mod (51 .txt)
my %E;   # name -> {using, f, o, src}
sub load_txt { my ($f, $tag) = @_; my $cur;
    for my $l (split /\r?\n/, slurp($f)) {
        if ($l =~ /^new entry "([^"]+)"/) { $cur = $1; $E{$cur} = { f => {}, o => [], src => $tag }; next }
        next unless defined $cur;
        if ($l =~ /^using "([^"]+)"/) { $E{$cur}{using} = $1; next }
        if ($l =~ /^data "([^"]+)" "(.*)"$/) { push @{$E{$cur}{o}}, $1 unless exists $E{$cur}{f}{$1}; $E{$cur}{f}{$1} = $2 }
    } }
for my $d ("$V/Shared_Extracted/Public/Shared", "$V/Shared_Extracted/Public/SharedDev", "$V/Gustav_Extracted/Public/Gustav",
           "$V/Gustav_Extracted/Public/GustavDev") { load_txt($_, 'vanilla') for bsd_glob("$d/Stats/Generated/Data/*.txt") }
my %VAN = map { $_ => { %{$E{$_}}, f => { %{$E{$_}{f}} } } } keys %E;   # vanilla only, before the mod overrides
load_txt($_, 'mod') for bsd_glob("$S51/Public/$M/Stats/Generated/Data/*.txt");

# Stage 2 (2026-10-17) changed the game after the baseline: undo it in %E so %E is the game before ARC-0026.
my %STATS_DIR = (Spell_Target => 'SpellData/Target', Spell_Shout => 'SpellData/Shout', Spell_Rush => 'SpellData/Rush',
    Spell_Projectile => 'SpellData/Projectile', Spell_Zone => 'SpellData/Zone', Status_BOOST => 'StatusData/Status_BOOST',
    Passive => 'Stats/Passive', Interrupt => 'Stats/Interrupt');
my %ALIAS = (WeaponType => 'WeaponTypes', SpellPrepareCost => 'MemoryCost');
my %BST;   # baseline .stats: full name -> {k => v}
for my $pub (keys %STATS_DIR) {
    my $x = git_show("50_ENGINEERING/51_Mod_Source/Editor/Mods/$M/Stats/$STATS_DIR{$pub}.stats");
    my ($t) = $pub =~ /^Spell_(\w+)$/;
    for my $o (split /<stat_object /, $x) {
        my ($n) = $o =~ /<field name="Name"[^>]*value="([^"]+)"/ or next;
        my $full = $t ? "${t}_$n" : $n; my %f;
        while ($o =~ /<field name="(\w+)" type="(\w+)"([^>]*)\/>/g) { my ($k, $ty, $a) = ($1, $2, $3);
            next if $k =~ /^(UUID|Name|Using)$/;
            my $v = $ty eq 'TranslatedStringTableFieldDefinition' ? (($a =~ /handle="([^"]+)"/) ? "$1;" . (($a =~ /version="(\d+)"/)[0] // 1) : '')
                  : $a =~ /clear_inherited_value="true"/ ? '' : (($a =~ /value="([^"]*)"/)[0] // '');
            $v =~ s/&quot;/"/g; $v =~ s/&apos;/'/g; $v =~ s/&lt;/</g; $v =~ s/&gt;/>/g; $v =~ s/&amp;/&/g;
            $f{$ALIAS{$k} // $k} = $v }
        $BST{$full} = \%f;
    }
}
for my $n (map { $_->[1] } grep { $_->[4] eq '10_core' } @SETS) {   # fields stage 2 set: back to their 09f30e0 value
    my $b = $BST{$n} or next;
    for my $s (grep { $_->[1] eq $n && $_->[4] eq '10_core' } @SETS) { my $k = $s->[2];
        if (exists $b->{$k}) { $E{$n}{f}{$k} = $b->{$k} } else { delete $E{$n}{f}{$k}; @{$E{$n}{o}} = grep { $_ ne $k } @{$E{$n}{o}} } }
}
for my $n (grep { $P{$_}{patch} eq '10_core' && !$BST{$_} } keys %P) { delete $E{$n} }   # stage 2's new entries
if (($E{Interrupt_AttackOfOpportunity}{src} // '') eq 'mod') { $E{Interrupt_AttackOfOpportunity} = $VAN{Interrupt_AttackOfOpportunity} }   # the Owner's copy (P6)

sub resolve { my ($n, $seen) = @_; $seen //= {}; return ({}, []) if !$n || $seen->{$n}++;
    my $e = $P{$n} // $E{$n} or die "no entry $n\n";
    my ($d, $o) = $e->{using} ? resolve($e->{using}, $seen) : ({}, []); my %d = %$d; my @o = @$o;
    for my $k (@{$e->{o}}) { push @o, $k unless exists $d{$k}; $d{$k} = $e->{f}{$k} } (\%d, \@o) }
sub base_resolve { my ($n, $seen) = @_; $seen //= {}; return ({}, []) if !$n || $seen->{$n}++;   # the game before ARC-0026
    my $e = $E{$n} or return ({}, []);
    my ($d, $o) = $e->{using} ? base_resolve($e->{using}, $seen) : ({}, []); my %d = %$d; my @o = @$o;
    for my $k (@{$e->{o}}) { push @o, $k unless exists $d{$k}; $d{$k} = $e->{f}{$k} } (\%d, \@o) }

# ---------------------------------------------------------------- loca: the game before ARC-0026, and TooltipExtras names
my %EN; { my $x = git_show("50_ENGINEERING/51_Mod_Source/Mods/$M/Localization/English/english.xml");
    while ($x =~ /<content contentuid="([^"]+)"[^>]*>(.*?)<\/content>/sg) { my ($h, $t) = ($1, $2);
        $t =~ s/&lt;/</g; $t =~ s/&gt;/>/g; $t =~ s/&quot;/"/g; $t =~ s/&apos;/'/g; $t =~ s/&amp;/&/g; $EN{$h} = $t } }
my %TIP = map { /^([^#\t][^\t]*)\t(.*)$/ ? ($1 => $2) : () } split /\r?\n/, slurp("$WIP/tooltip_extras.tsv");   # the names the Toolkit list shows

# ---------------------------------------------------------------- the level of every change (WB43 level map, DESIGN §9.1)
my %LEVEL;   # "NEW name" | "SET name.field" | "DEL name" | "LOCA handle" -> level
sub at { my ($lv, @keys) = @_; for (@keys) { die "assigned twice: $_\n" if exists $LEVEL{$_}; $LEVEL{$_} = $lv } }
sub sets_of { my $n = shift; map { "SET $n.$_->[2]" } grep { $_->[1] eq $n } @SETS }
at(1, 'NEW ARCANA_WINDSWEPT', 'NEW Arcana_Passive_Windswept_Touch', 'NEW Rush_Arcana_Created_ZephyrRush', 'NEW ARCANA_ZEPHYR_RUSH',
      'NEW Arcana_Passive_Weightless_1', sets_of('Interrupt_AttackOfOpportunity'), sets_of('Arcana_Passive_FlowingStrikeZephyr'),
      sets_of('Target_Arcana_Created_ZephyrStrike'), map({ sets_of($_) } 'Target_Arcana_Card_Spell_GaleBurst', map { "Target_Arcana_Card_Spell_GaleBurst_$_" } 3 .. 6),
      sets_of('Arcana_Passive_BetheLeaf'));
at(2, map({ "NEW $_" } qw(Shout_Arcana_Created_AeolusBag Shout_Arcana_Created_AeolusBag_Boreas Shout_Arcana_Created_AeolusBag_Notus
      ARCANA_BAG_READY ARCANA_BAG_OPEN ARCANA_WIND_BOREAS ARCANA_WIND_NOTUS ARCANA_TAILWIND_BOREAS ARCANA_HEADWIND_BOREAS
      ARCANA_TAILWIND_NOTUS ARCANA_HEADWIND_NOTUS Arcana_Passive_AeolusBag)));
at(3, 'NEW Shout_Arcana_Created_TheCalm', map({ "NEW ARCANA_CALM_GUST_$_" } 1 .. 5), sets_of('Arcana_Passive_Aspect_Fool_I'),
      sets_of('Arcana_Passive_Aspect_Fool_Awakened_I'), sets_of('FOOL_ZEPHYR_FREE'), sets_of('ASPECT_AWAKENED_FOOL'),
      sets_of('Zone_Arcana_Card_Spell_WindBlast'), 'DEL WANDERLUST_HIT_TECH', 'DEL Arcana_Passive_TwinkleToes_1');
at(4, map({ "NEW $_" } qw(Arcana_Passive_Zephyr_Gale Shout_Arcana_Created_AeolusBag_Eurus ARCANA_WIND_EURUS ARCANA_TAILWIND_EURUS
      ARCANA_HEADWIND_EURUS Arcana_Passive_Weightless_4)));
at(5, sets_of('Shout_Arcana_Card_Spell_WindWhispers'), 'DEL Arcana_Passive_TwinkleToes_3');
at(6, map({ sets_of($_) } 'Shout_Arcana_Card_Spell_FlowState', map({ "Shout_Arcana_Card_Spell_FlowState_$_" } 3 .. 6),
      'Interrupt_Arcana_Reaction_GaleDeflection', 'Arcana_Passive_GaleDeflection', 'GALE_DEFLECTION_READY', 'INTERRUPT_GALE_DEFLECT_MISSILES_HIT'),
      map({ "DEL FLOW_STATE_$_" } 3 .. 6));
at(7, map({ sets_of($_) } qw(Shout_Arcana_Card_Spell_StormFists_5 Shout_Arcana_Card_Spell_StormFists_6 STORM_FISTS STORM_FISTS_5 STORM_FISTS_6
      Arcana_Passive_Aspect_Fool_Awakened_II)), 'DEL Arcana_Passive_TwinkleToes_5', 'DEL Arcana_Passive_Weightless_5');
at(8, map({ "NEW $_" } qw(Arcana_Passive_Zephyr_Storm ARCANA_STORM_RUSH Rush_Arcana_Created_ZephyrRush_Storm Arcana_Passive_Weightless_8)));
at(9, sets_of('FLY_UNTETHERED'), map({ "DEL $_" } qw(Arcana_Passive_EyeOfTheStorm Arcana_Passive_EyeOfTheStorm_UI Shout_Arcana_Card_Spell_EvasiveFlow
      Shout_Arcana_Card_Spell_EvasiveFlow_5 Shout_Arcana_Card_Spell_EvasiveFlow_6 EVASIVE_FLOW Arcana_Passive_TwinkleToes_7 Arcana_Passive_Weightless_7)));
at(10, sets_of('Rush_Arcana_Created_Aspect_LeapOfFaith'));
at(11, 'NEW Target_Arcana_Created_WhereTheWindsMeet', map({ "DEL $_" } qw(Shout_Arcana_Card_Spell_Thunderclap Shout_Arcana_Card_Spell_Thunderclap_6
      THUNDERCLAP Arcana_Passive_Thunderclap Arcana_Passive_Momentum Arcana_Passive_Momentum_UI Arcana_Passive_TwinkleToes_9 Arcana_Passive_Weightless_9)));
at(12, map({ "NEW $_" } qw(Arcana_Passive_Zephyr_Hurricane ARCANA_INTO_THE_STORM Shout_Arcana_Created_AeolusBag_BoreasNotus
      Shout_Arcana_Created_AeolusBag_BoreasEurus Shout_Arcana_Created_AeolusBag_NotusEurus Arcana_Passive_Weightless_12)),
      sets_of('Arcana_Passive_Aspect_Fool_III'), sets_of('Arcana_Passive_Aspect_Fool_Awakened_III'),
      map({ "DEL Arcana_Passive_TwinkleToes_$_" } 11, 12, 13, 15, 17, 19, 20), 'DEL Arcana_Passive_Weightless_11', 'DEL Interrupt_Arcana_Aspect_FoolsLuck');

# Aeolus' Bag grows: level 2 shows Boreas and Notus, level 4 adds Eurus, level 12 the pairs (an entry must exist before
# a container lists it).
my @BAG = map { "Shout_Arcana_Created_AeolusBag_$_" } qw(Boreas Notus Eurus BoreasNotus BoreasEurus NotusEurus);
my %BAG_AT = (2 => join(';', @BAG[0, 1]), 4 => join(';', @BAG[0 .. 2]), 12 => join(';', @BAG));
$P{Shout_Arcana_Created_AeolusBag}{f}{ContainerSpells} = $BAG_AT{2};

# Look parents (rule 12): entries the patches wrote with a copied cast block get the spell it came from as `Using`.
my %LOOK = (Shout_Arcana_Created_AeolusBag => 'Shout_Arcana_Card_Spell_FlowState', Shout_Arcana_Created_TheCalm => 'Shout_Arcana_Card_Spell_FlowState');
my %LOOKF = map { $_ => 1 } qw(SpellAnimation DualWieldingSpellAnimation PrepareEffect CastEffect TargetEffect HitEffect TargetHitEffect
    TargetGroundEffect PositionEffect BeamEffect SpellEffect SelectedCharacterEffect SelectedObjectEffect SelectedPositionEffect
    DisappearEffect ReappearEffect ImpactEffect PreviewEffect Trajectories StatusEffect ApplyEffect EndEffect StatusEffectOnTurn);
my %TIPF = map { $_ => 1 } qw(TooltipUpcastDescription TooltipOnSave TooltipOnMiss TooltipPermanentWarnings);
my %TEXTF = map { $_ => 1 } qw(DisplayName Description ExtraDescription ShortDescription LoreDescription);

# ---------------------------------------------------------------- self-check: every patch change has exactly one level
my @miss;
push @miss, map { "NEW $_" } grep { !exists $LEVEL{"NEW $_"} } keys %P;
push @miss, map { "SET $_->[1].$_->[2]" } grep { !exists $LEVEL{"SET $_->[1].$_->[2]"} } @SETS;
push @miss, map { "DEL $_->[1]" } grep { !exists $LEVEL{"DEL $_->[1]"} } @DELS;
my %known = (map({ ("NEW $_" => 1) } keys %P), map({ ("SET $_->[1].$_->[2]" => 1) } @SETS), map({ ("DEL $_->[1]" => 1) } @DELS));
my @extra = grep { !$known{$_} } keys %LEVEL;
die "no level for:\n  " . join("\n  ", sort @miss) . "\n" if @miss;
die "level given to something no patch changes:\n  " . join("\n  ", sort @extra) . "\n" if @extra;
print "self-check: ", scalar(keys %LEVEL), " changes, each on one level\n";
exit 0 if $CHECK;

# ================================================================ rendering
# Toolkit labels: the Toolkit's own definitions (.sod) map the .txt name (export_name) to its label, per type.
my %SODT = (Spell_Target => 'Target', Spell_Shout => 'Shout', Spell_Rush => 'Rush', Spell_Projectile => 'Projectile',
            Spell_Zone => 'Zone', Status_BOOST => 'Status_BOOST', Passive => 'Passive', Interrupt => 'Interrupt');
my %LBL; { my $d; for (split /\n/, slurp('C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data/Editor/Config/Stats/StatObjectDefinitions.sod')) {
    $d = $1 if /<stat_object_definition [^>]*name="([^"]+)"/;
    if ($d && /<field_definition name="[^"]+" display_name="([^"]+)" export_name="([^"]+)"/) { $LBL{$d}{$2} = $1 } } }
sub lbl { my ($pub, $k) = @_; $LBL{$SODT{$pub}}{$k} // $k }

my %AREA = (Spell_Target => 'SpellData / Target', Spell_Shout => 'SpellData / Shout', Spell_Rush => 'SpellData / Rush',
            Spell_Projectile => 'SpellData / Projectile', Spell_Zone => 'SpellData / Zone', Status_BOOST => 'StatusData / Status_BOOST',
            Passive => 'Stats / Passive', Interrupt => 'Stats / Interrupt');
my @PUBORDER = qw(Status_BOOST Passive Interrupt Spell_Target Spell_Shout Spell_Rush Spell_Zone Spell_Projectile);
my %PUBRANK = map { $PUBORDER[$_] => $_ } 0 .. $#PUBORDER;
sub pub_of { my $n = shift; return $P{$n}{file} if $P{$n} && $P{$n}{file}; for my $s (@SETS, @DELS) { return $s->[0] if $s->[1] eq $n }
    return 'Interrupt' if $n =~ /^Interrupt_/; return 'Spell_' . ($n =~ /^(\w+?)_/)[0] if $n =~ /^(Target|Shout|Rush|Zone|Projectile)_/;
    return 'Passive' if $n =~ /^Arcana_Passive_/; 'Status_BOOST' }
sub short { my $n = shift; $n =~ s/^(Target|Shout|Rush|Zone|Projectile|Teleportation)_//; $n }
sub code { my $v = shift; return '—' if !defined $v || $v eq ''; $v =~ s/\|/\\|/g; "`$v`" }
our $NEWCTX = 0;   # inside a NEW entry the Owner types the text (the Toolkit makes a new handle); elsewhere the handle stays
sub text_cell { my $v = shift; return '—' if !defined $v || $v eq '';
    if ($v =~ /^\{\{(\S+)\}\}$/) { my $k = $1;
        if ($k =~ /^h[0-9a-g]{36}$/) { return code($LOCAH{$k} // $EN{$k}) if $NEWCTX; return "(existing handle `$k` — new text in §4)" }
        defined $LOCA{$k} or die "no text for {{$k}}\n"; return code($LOCA{$k}) }
    if ($v =~ /^(h[0-9a-g]{36});\d+$/) { return code($EN{$1}) if $NEWCTX && defined $EN{$1}; return "(existing handle `$1`)" }
    code($v) }
sub cell { my ($k, $v) = @_; return text_cell($v) if $TEXTF{$k}; return code($TIP{$v} // $v) if $TIPF{$k} && defined $v && $v ne ''; code($v) }
sub show_val { my ($k, $v) = @_; return '—' if !defined $v || $v eq ''; cell($k, $v) }

# ---------------------------------------------------------------- per-entry notes and the origin of every number (ADR-0008)
my %WHY = (
  ARCANA_WINDSWEPT => 'The mark (WB8, WB9). `TickType EndTurn` with `TickingWithSource`: the 2 turns of `ApplyStatus(…,100,2)` count down on the Windborn\'s turns only, so a mark lasts until the end of her next turn. Opportunity Attacks are switched off by the Open Path (block of `Interrupt_AttackOfOpportunity`), not by this status.',
  Arcana_Passive_Windswept_Touch => 'Hidden; The Open Road explains it. P7 (QA-0004): `OnAttack` caught only weapon attacks; `OnDamage` with `TotalDamageDoneGreaterThan(0)` marks on any damage she deals, and a miss marks nothing.',
  Interrupt_AttackOfOpportunity => 'The Open Path (WB10, P6 plan B, WB49): a mod copy of the vanilla opportunity attack with the same name, so it replaces it. Every field is vanilla except `EnableCondition`: a Windswept reactor makes no opportunity attack, the way `SG_Blinded` already does. No `Using` (it would point at itself): copy the vanilla entry into the mod the way you did for probe P6 (its texts come along). shortcut: another mod that edits this interrupt wins or loses by load order.',
  Rush_Arcana_Created_ZephyrRush => 'Zephyr\'s Rush (WB5): only to an enemy that isn\'t Windswept; 9 m at Breeze, 12 m from Gale (the `DistanceToTargetLessThan(9) or HasPassive(Gale)` term). `Rush_SpringAttack` is a weapon action: its Cooldown, RechargeValues, Required Weapon Type and weapon requirement are cleared (the ARC-0026 probe P1). Unlocked for the turn by `ARCANA_ZEPHYR_RUSH`.',
  ARCANA_ZEPHYR_RUSH => 'Unlocks Zephyr Rush for the turn, the twin of the existing `ZEPHYR_STRIKE` (The Open Road applies both after an unarmed attack or a card).',
  Arcana_Passive_Weightless_1 => 'Weightless rank 1 (WB39, WB47) replaces Twinkle Toes. Ranks 4, 8 and 12 inherit from it.',
  Shout_Arcana_Created_AeolusBag => 'Aeolus\' Bag (WB11–WB14): a container, one child per wind. Osiris puts `ARCANA_BAG_READY` on her while she has a Windswept enemy and `ARCANA_BAG_OPEN` while a wind blows. At level 2 it lists Boreas and Notus; Eurus joins at 4, the pairs at 12.',
  Shout_Arcana_Created_AeolusBag_Boreas => 'A child of the bag. Its own `RequirementConditions` add "not Hurricane" (at 12 the pairs replace the single winds). Notus inherits everything from Boreas; the goal reads which child was cast.',
  Shout_Arcana_Created_TheCalm => 'The Calm (WB25), the Aspect card of Tier I: only while a wind blows. The spell only spends the action; Osiris turns the turns left into gusts (`ARCANA_CALM_GUST_1`–`_5`) and reopens the bag.',
  ARCANA_BAG_READY => 'Technical: Osiris keeps it on her while she has a Windswept enemy; the bag needs it.',
  ARCANA_BAG_OPEN => '"The bag is open": shows the turns of wind left. `FreezeDuration`: the number never ticks by itself; the goal sets it each time the count changes (the P8 pattern).',
  ARCANA_WIND_BOREAS => 'One aura per wind on her, the whole field (30 m). Osiris applies and removes it. Boon on allies, bane on Windswept enemies.',
  ARCANA_CALM_GUST_1 => 'One gust status per number of turns left (1–5); the goal applies the one that matches. 1d8 per gust to level 6, 2d6 from 7 (WB48).',
  ARCANA_INTO_THE_STORM => 'Tier III: what a sweep does to each swept enemy. `Force` in a status functor pushes away from the status source (probe P9: pass).',
  Arcana_Passive_AeolusBag => 'Hidden marker of level 2 (the goal and the bag read it).',
  Arcana_Passive_Zephyr_Gale => 'Rank 2 of Zephyr (level 4): the push and 12 m Rush read this passive; Eurus needs it.',
  Arcana_Passive_Zephyr_Storm => 'Rank 3 (level 8): after a Rush that deals damage, one more free Rush this turn (`ARCANA_STORM_RUSH`).',
  Arcana_Passive_Zephyr_Hurricane => 'Rank 4 (level 12): the bag offers the pairs of winds instead of single ones.',
  ARCANA_STORM_RUSH => 'Unlocks the free second Rush until the end of the turn; casting it removes the status.',
  Rush_Arcana_Created_ZephyrRush_Storm => 'Storm\'s second Rush: free, 9 m, only to another enemy that isn\'t Windswept.',
  Target_Arcana_Created_WhereTheWindsMeet => 'The capstone (WB26, WB46, WB49, WB50): aimed at a point on the ground. One 9 m area for every enemy; a Windswept enemy is pulled 9 m, any other 6 m (the `IF` is read before the mark is applied). Only while no wind blows. Check in game that the pull goes to the point, not to her; plan B: `GROUND:CreateExplosion` of a pulling explosion.',
);
my %NUM = (
  ARCANA_WINDSWEPT => '`2` (the `ApplyStatus(ARCANA_WINDSWEPT,100,2)` of every mark: 2 of her turn ends) = `FEAT_Unbound_TheOpenRoad#windswept_duration_next`.',
  Arcana_Passive_Windswept_Touch => '`2` = `FEAT_Unbound_TheOpenRoad#windswept_duration_next`.',
  Rush_Arcana_Created_ZephyrRush => '`12` (TargetRadius) = `FEAT_Unbound_TheOpenRoad#rush_range_next`; `9` (`DistanceToTargetLessThan`) = `#rush_range_breeze_next`; `3` (`Force`) = `#gale_push_next`.',
  Target_Arcana_Created_ZephyrStrike => '`3` (`Force`) = `FEAT_Unbound_TheOpenRoad#gale_push_next`.',
  Arcana_Passive_Weightless_1 => '`3` = `FEAT_Unbound_Weightless#speed_next` (level 1).',
  Arcana_Passive_Weightless_4 => '`4.5` / `2` / `0.5` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (level 4).',
  Arcana_Passive_Weightless_8 => '`6` / `3` / `0.5` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (level 8).',
  Arcana_Passive_Weightless_12 => '`9` / `4` / `0` = `FEAT_Unbound_Weightless#speed_next` / `#jump_next` / `#falling_next` (level 12).',
  ARCANA_TAILWIND_BOREAS => '`3` = `FEAT_Unbound_AeolusBag#boreas_ally_next`.',
  ARCANA_HEADWIND_BOREAS => '`3` = `FEAT_Unbound_AeolusBag#boreas_enemy_next`.',
  ARCANA_HEADWIND_NOTUS => '`1` = `FEAT_Unbound_AeolusBag#notus_enemy_next`.',
  ARCANA_TAILWIND_EURUS => '`1` = `FEAT_Unbound_AeolusBag#eurus_ally_next`.',
  ARCANA_HEADWIND_EURUS => '`1` = `FEAT_Unbound_AeolusBag#eurus_enemy_next`.',
  Shout_Arcana_Created_TheCalm => '`1d8` (DescriptionParams) = `SPL_Unbound_TheCalm#gust_damage_next`.',
  ARCANA_CALM_GUST_1 => '`1d8` per gust (levels 3–6) and `2d6` (7+, `CharacterLevelGreaterThan(6)`) = `SPL_Unbound_TheCalm#gust_damage_next` `by_level`; gust *n* deals *n* times that.',
  ARCANA_INTO_THE_STORM => '`3` (`Force`) = `FEAT_Unbound_AspectAwakening#tier3_push_next`.',
  Arcana_Passive_Aspect_Fool_III => '`3` = `FEAT_Unbound_AspectAwakening#tier3_push_next`.',
  Arcana_Passive_Zephyr_Gale => '`3` = `FEAT_Unbound_TheOpenRoad#gale_push_next`.',
  Rush_Arcana_Created_ZephyrRush_Storm => '`9` = `FEAT_Unbound_TheOpenRoad#storm_rush_range_next`.',
  Shout_Arcana_Card_Spell_FlowState => '`3` (turns) = `SPL_Unbound_FlowState#duration_next`, the same at every slot (`_3`…`_6`).',
  STORM_FISTS => '`3` turns (the cards) = `SPL_Unbound_StormFists#duration_next`; the dice are today\'s.',
  FLY_UNTETHERED => '`2` = `SPL_Unbound_Untethered#flying_ac_next`.',
  Interrupt_Arcana_Reaction_GaleDeflection => '`3` = `SPL_Unbound_GaleDeflection#ally_range_next`.',
  Arcana_Passive_GaleDeflection => '`3` = `SPL_Unbound_GaleDeflection#ally_range_next`.',
  GALE_DEFLECTION_READY => '`3` = `SPL_Unbound_GaleDeflection#ally_range_next`.',
  Arcana_Passive_Zephyr_Hurricane => '`2` winds at once (the pair children of the bag) = `FEAT_Unbound_AeolusBag#hurricane_winds_next`.',
  Rush_Arcana_Created_Aspect_LeapOfFaith => 'Level `10` (the list it joins) = `SPL_Unbound_LeapOfFaith#level_next`.',
  Target_Arcana_Created_WhereTheWindsMeet => '`18` = `SPL_Unbound_WhereTheWindsMeet#range_next`; `9` (AreaRadius) = `#area_radius_next`; `9` / `6` (`Force`) = `#pull_distance_windswept_next` / `#pull_distance_next`; `4d8` = `#damage_next`.',
);
sub derived { my %u; for my $t (@_) { while ($t =~ /`((?:SPL|FEAT)_Unbound_\w+|CLS_Unbound)#/g) { my $id = $1;
    $u{'25.0' . ($id =~ /^SPL/ ? 1 : $id =~ /^FEAT/ ? 2 : 4) . "/$id.yaml"} = 1 } } sort keys %u }

my %LOOKSRC = ('Rush_Arcana_Created_Aspect_LeapOfFaith.SpellAnimation' => 'Rush_ForceTunnel');   # WB7: the Force Tunnel dash
my %VARIANT_NOTE = map { $_ => 1 } (map({ "Target_Arcana_Card_Spell_GaleBurst_$_" } 3 .. 6), map({ "Shout_Arcana_Card_Spell_FlowState_$_" } 3 .. 6),
    'Shout_Arcana_Card_Spell_StormFists_5', 'Shout_Arcana_Card_Spell_StormFists_6');

sub van_resolve { my ($m, $s) = @_; $s //= {}; return {} if !$m || $s->{$m}++; my $e = $VAN{$m} or return {};
    my $p = $e->{using} ? van_resolve($e->{using}, $s) : {}; +{ %$p, %{$e->{f}} } }

# ---------------------------------------------------------------- one NEW entry: rows {label => cell} and its notes
sub new_entry { my $n = shift; my $pub = pub_of($n);
    my ($own, $par, $kind);
    if ($n eq 'Interrupt_AttackOfOpportunity') {   # the vanilla interrupt, copied with its own name (no parent)
        $own = { %{van_resolve($n)} }; $_->[1] eq $n and $own->{$_->[2]} = $_->[3] for @SETS; $kind = 'none' }
    else { $own = { %{$P{$n}{f}} }; $par = $P{$n}{using} // $LOOK{$n}; $kind = $P{$n}{using} ? 'using' : $LOOK{$n} ? 'look' : 'none' }
    my ($R) = $par ? resolve($par) : ({});
    local $NEWCTX = $n ne 'Interrupt_AttackOfOpportunity';   # the vanilla copy keeps the vanilla handles
    my (%row, @from, @ours, @clears, @copy, @lookdiff);
    my %keys = map { $_ => 1 } keys(%$own), keys(%$R);
    for my $k (sort keys %keys) {
        next if $k =~ /^(SpellType|StatusType)$/;
        my ($e, $r) = ($own->{$k}, $R->{$k}); my $L = lbl($pub, $k);
        if ($LOOKF{$k}) { push @copy, $L if defined $r && $r ne '';
            push @lookdiff, $L if defined $e && $e ne '' && (!defined $r || $e ne $r); next }
        next if $k eq 'MemoryCost' && $pub ne 'Spell_Rush';
        if ($kind eq 'none') { $row{$L} = show_val($k, $e) if defined $e && $e ne ''; next }
        if (defined $e && $e ne '') {
            if (defined $r && $e eq $r) { $row{$L} = show_val($k, $e); push @from, $L }
            else { $row{$L} = show_val($k, $e); push @ours, (defined $r && $r ne '' && !$TEXTF{$k} ? "$L (the parent has " . code($r) . ')' : $L) } }
        elsif (defined $e) { if (defined $r && $r ne '') { $row{$L} = '—'; push @clears, "$L (the parent has " . ($TEXTF{$k} ? 'its own text' : code($r)) . ')' } }
        elsif (defined $r && $r ne '') {
            if ($kind eq 'look') { $row{$L} = '—'; push @clears, "$L (the parent has " . ($TEXTF{$k} ? 'its own text' : code($r)) . ')' }
            else { $row{$L} = show_val($k, $r); push @from, $L } }
    }
    die "$n: look fields @lookdiff with no parent to copy them from\n" if $kind eq 'none' && @lookdiff;
    if ($n eq 'Interrupt_AttackOfOpportunity') {   # the vanilla texts, as the Owner's P6 copy holds them (51 english.xml hf509ba10…, h39feedd4…)
        @row{qw(DisplayName Description)} = (code('Opportunity Attack'), code('Attack an enemy moving out of your reach.')) }
    my $nm = $pub =~ /^Spell_/ ? short($n) : $n; my %r = (Name => code($nm), %row);
    $r{Using} = code($pub =~ /^Spell_/ ? short($par) : $par) if $par;
    return { name => $n, pub => $pub, rows => \%r, from => \@from, ours => \@ours, clears => \@clears, copy => \@copy,
             lookdiff => \@lookdiff, par => $par, kind => $kind };
}

sub notes_of { my ($x) = @_; my @o;
    my $par = $x->{par}; my $own_parent = $par && $x->{kind} ne 'look' && ($P{$par} || ($E{$par}{src} // '') eq 'mod');
    if ($par) { my $s = $x->{pub} =~ /^Spell_/ ? short($par) : $par;
        push @o, "Notes — `$x->{name}` (`Using` = `$s`; search `$s` in the picker" . ($own_parent ? ', our own entry' : '') . '):';
        if ($own_parent) { push @o, '- `Using` stays: the parent is our own entry, so its look and the fields marked *From the parent* come with it.' }
        elsif (@{$x->{copy}}) { push @o, '- **Copy from the parent in the Toolkit, then remove `Using`:** ' . join(', ', @{$x->{copy}}) . '.' }
        push @o, '- **From the parent:** ' . join(', ', @{$x->{from}}) . '.' if @{$x->{from}};
        push @o, '- **Ours:** ' . join(', ', @{$x->{ours}}) . '.' if @{$x->{ours}};
        push @o, '- **Clears the parent:** ' . join(', ', @{$x->{clears}}) . '.' if @{$x->{clears}};
        my ($R) = resolve($par);
        push @o, '- MemoryCost: the parent\'s `1` stays and does no harm (cards are always prepared).' if $x->{pub} ne 'Spell_Rush' && ($R->{MemoryCost} // '') =~ /^[1-9]/ }
    else { push @o, "Notes — `$x->{name}`:" }
    push @o, "- $WHY{$x->{name}}" if $WHY{$x->{name}};
    push @o, '- The Icon is a suggestion.' if exists $x->{rows}{Icon} && $x->{rows}{Icon} ne '—';
    push @o, '', "Numbers: $NUM{$x->{name}}" if $NUM{$x->{name}};
    join "\n", @o }

sub new_block { my ($num, $title, @x) = @_; my $pub = $x[0]{pub};
    my %all; $all{$_} = 1 for map { keys %{$_->{rows}} } @x;
    my @f = ('Name', (grep { $_ eq 'Using' } keys %all), sort grep { $_ ne 'Name' && $_ ne 'Using' } keys %all);
    my @o = ("### $num · NEW · $AREA{$pub} · $title", '', '| Field | ' . join(' | ', map { "`$_->{name}`" } @x) . ' |',
             '|---|' . join('|', map { '---' } @x) . '|');
    for my $k (@f) { push @o, "| $k | " . join(' | ', map { $_->{rows}{$k} // '—' } @x) . ' |' }
    push @o, '', join("\n\n", map { notes_of($_) } @x), '';
    join "\n", @o }

# ---------------------------------------------------------------- CHANGED entries (before -> after), REPLACED ones too
sub before_of { my ($n, $k) = @_; my $e = $E{$n} or return '—';
    return show_val($k, $e->{f}{$k}) if exists $e->{f}{$k};
    my ($R) = base_resolve($e->{using}); defined $R->{$k} && $R->{$k} ne '' ? 'inherits ' . show_val($k, $R->{$k}) : '—' }
sub changed_block { my ($num, $n, @sets) = @_; my $pub = pub_of($n);
    my @o = ("### $num · CHANGED · $AREA{$pub} · `$n`", '', '| Field | Before | After |', '|---|---|---|');
    for my $s (@sets) { my ($k, $v) = @$s; my $L = lbl($pub, $k);
        my $after = $LOOKF{$k} ? 'copy it from vanilla `' . ($LOOKSRC{"$n.$k"} // die "no look source for $n.$k\n") . '` (open it, copy the field, paste it here)'
                  : $TEXTF{$k} && $v =~ /^\{\{(h[0-9a-g]{36})\}\}$/ ? "(existing handle `$1` — new text in §4)" : show_val($k, $v);
        my $before = $LOOKF{$k} ? 'the current animation' : before_of($n, $k);
        push @o, "| $L | $before | $after |" }
    my @no; for my $s (@sets) { my ($k, $v) = @$s; next unless $TEXTF{$k}; my ($bh) = (($E{$n}{f}{$k} // "") =~ /^(h[0-9a-g]{36});/) or next;
        my @others = grep { !/^\Q$n\E\./ } @{$HUSE{$bh} // []};
        my ($nh) = $v =~ /^\{\{(h[0-9a-g]{36})\}\}$/;
        if (!$nh && @others) { push @no, "- **$k: make a new handle.** The old one (`$bh`) is also used by " . join(', ', map { "`$_`" } @others) . ": type the new text into a new handle, don't edit the old text." }
        elsif ($nh && @others) { push @no, "- $k: the new text goes into `$nh` itself, which " . join(', ', map { "`$_`" } @others) . ' also show (intended).' } }

    push @no, '- A variant: `gen_upcast_variants.pl` keeps fields edited by hand, so this one is typed here, not generated.' if $VARIANT_NOTE{$n};
    push @no, "- $WHY{$n}" if $WHY{$n};
    push @o, '', "Notes — `$n`:", @no if @no;
    (my $root = $n) =~ s/_\d$//;
    push @o, '', "Numbers: " . ($NUM{$n} // $NUM{$root}) if $NUM{$n} || $NUM{$root};
    push @o, ''; join "\n", @o }
sub replaced_block { my ($num, $n) = @_; my $pub = pub_of($n); my $b = $E{$n}; my $p = $P{$n};
    my %k = map { $_ => 1 } grep { !/^(SpellType|StatusType)$/ } keys(%{$b->{f}}), keys(%{$p->{f}});
    my @o = ("### $num · CHANGED (rewritten) · $AREA{$pub} · `$n`", '', '| Field | Before | After |', '|---|---|---|');
    push @o, '| Using | ' . code($b->{using}) . ' | ' . code($p->{using}) . ' |' if ($b->{using} // '') ne ($p->{using} // '');
    for my $f (sort keys %k) { my ($x, $y) = ($b->{f}{$f}, $p->{f}{$f}); next if defined $x && defined $y && $x eq $y;
        push @o, '| ' . lbl($pub, $f) . ' | ' . show_val($f, $x) . ' | ' . (defined $y ? show_val($f, $y) : '— (clear it: the parent gives it)') . ' |' }
    push @o, '', "Notes — `$n`: the old entry is reused under the same name; every row that differs is listed. With `Using` set, the cleared rows come from the parent.";
    push @o, '', "Numbers: $NUM{$n}" if $NUM{$n}; push @o, ''; join "\n", @o }

# ---------------------------------------------------------------- notes for CHANGED entries and removals
%WHY = (%WHY,
  Arcana_Passive_FlowingStrikeZephyr => 'The Open Road (WB3, WB27): the core passive keeps its id (ADR-0002). True Strike leaves its condition (WB29); after an unarmed attack or a card it now grants Zephyr Strike **and** Zephyr Rush for the turn.',
  Target_Arcana_Created_ZephyrStrike => 'The plain strike against a Windswept enemy; from Gale (level 4) it also pushes 3 m. The `IF(HasPassive)` reads the rank, so nothing changes here at level 4.',
  Target_Arcana_Card_Spell_GaleBurst => 'Gale Burst marks on a failed save (WB8) and loses its free unarmed strike (WB28: its `SpellProperties` go).',
  Zone_Arcana_Card_Spell_WindBlast => 'Wind Blast marks every creature that fails its save (WB8); its variants inherit this field.',
  Arcana_Passive_BetheLeaf => 'Be the Leaf (WB21): Intelligence instead of Wisdom in the Armour Class.',
  Arcana_Passive_Aspect_Fool_I => 'Tier I *The First Step* (WB22): the old Wanderlust round count (`WANDERLUST_HIT_TECH`) leaves; Osiris counts the marks released now.',
  Arcana_Passive_Aspect_Fool_Awakened_I => 'The old tier bonus goes (WB24: no ability bonus).',
  Arcana_Passive_Aspect_Fool_Awakened_II => 'The old tier bonus goes (WB24).',
  Arcana_Passive_Aspect_Fool_Awakened_III => 'The old tier bonus goes (WB24), Fool\'s Luck with it (its interrupt and resource are removed at this level).',
  FOOL_ZEPHYR_FREE => 'Tier I: once per turn the Rush to an enemy costs no bonus action — the free variant of Zephyr Rush (the old Leap of Faith discount goes).',
  ASPECT_AWAKENED_FOOL => 'The Aspect card is The Calm now (WB25); Leap of Faith becomes a level-10 card.',
  Shout_Arcana_Card_Spell_WindWhispers => 'Wind Whispers absorbs Evasive Flow\'s Advantage (WB33): it applies `EVASIVE_FLOW_OPENING` (kept) too.',
  Shout_Arcana_Card_Spell_FlowState => 'Flow State (WB31): 3 turns and one extra bonus action at every slot; the per-slot statuses `FLOW_STATE_3`–`_6` go (removed at this level).',
  Interrupt_Arcana_Reaction_GaleDeflection => 'Ready: Gale Deflection (WB32) also protects an ally within 3 m. Anchor: vanilla `Interrupt_FightingStyle_Protection` (scope `Nearby`, `DistanceToEntityGreaterThan(_, context.ObserverPosition, context.Target)`).',
  INTERRUPT_GALE_DEFLECT_MISSILES_HIT => 'Its id showed in the combat log (32.01 review): hidden.',
  STORM_FISTS => 'Storm Fists (WB34) adds its damage only against an enemy that isn\'t Windswept; it absorbs Thunderclap (removed at level 11 with its list).',
  Shout_Arcana_Card_Spell_StormFists_5 => 'Storm Fists lasts 3 turns at every slot (WB34).',
  FLY_UNTETHERED => 'Untethered (WB35) folds Eye of the Storm\'s +2 Armour Class into the flight; the passive goes (removed at this level).',
  Rush_Arcana_Created_Aspect_LeapOfFaith => 'Leap of Faith (WB7, WB38): a level-10 card, once per Short Rest, on the Force Tunnel dash. Its old `SpellProperties` (the Zephyr it granted) go: it is a card, so The Open Road grants Zephyr after it.',
  Arcana_Passive_Aspect_Fool_III => 'Tier III *Into the Storm*: the push in its text.',
);
for my $v (3 .. 6) { $WHY{"Target_Arcana_Card_Spell_GaleBurst_$v"} = $WHY{Target_Arcana_Card_Spell_GaleBurst}; $WHY{"Shout_Arcana_Card_Spell_FlowState_$v"} = $WHY{Shout_Arcana_Card_Spell_FlowState} }
$WHY{Shout_Arcana_Card_Spell_StormFists_6} = $WHY{Shout_Arcana_Card_Spell_StormFists_5}; $WHY{$_} = $WHY{STORM_FISTS} for qw(STORM_FISTS_5 STORM_FISTS_6);
$NUM{$_} = $NUM{STORM_FISTS} for qw(Shout_Arcana_Card_Spell_StormFists_5 Shout_Arcana_Card_Spell_StormFists_6);
my %DELWHY = (WANDERLUST_HIT_TECH => 'the Wanderlust round count (old Tier I)', Interrupt_Arcana_Aspect_FoolsLuck => 'Fool\'s Luck (old Tier III, WB24)',
  Arcana_Passive_EyeOfTheStorm => 'folded into Untethered (WB35)', Arcana_Passive_EyeOfTheStorm_UI => 'its level-9 marker; Empty State takes the slot',
  Shout_Arcana_Card_Spell_EvasiveFlow => 'retired (WB36); Wind Whispers keeps its Advantage', EVASIVE_FLOW => 'Evasive Flow\'s status',
  Shout_Arcana_Card_Spell_Thunderclap => 'absorbed by Storm Fists (WB34, WB37)', THUNDERCLAP => 'Thunderclap\'s status',
  Arcana_Passive_Thunderclap => 'Thunderclap\'s passive', Arcana_Passive_Momentum => 'retired (WB37)', Arcana_Passive_Momentum_UI => 'its level-11 marker');
$DELWHY{"Shout_Arcana_Card_Spell_EvasiveFlow_$_"} = 'a variant of Evasive Flow' for 5, 6; $DELWHY{Shout_Arcana_Card_Spell_Thunderclap_6} = 'a variant of Thunderclap';
$DELWHY{"FLOW_STATE_$_"} = 'a per-slot Flow State status (WB31: one status at every slot)' for 3 .. 6;
$DELWHY{"Arcana_Passive_TwinkleToes_$_"} = 'Twinkle Toes, replaced by Weightless (WB39)' for 1, 3, 5, 7, 9, 11, 12, 13, 15, 17, 19, 20;
$DELWHY{"Arcana_Passive_Weightless_$_"} = 'the old Feather Fall chain, replaced by Weightless 1/4/8/12 (WB47)' for 5, 7, 9, 11;

# ---------------------------------------------------------------- lists and progression (the WB43 map; 50_structure.pl holds the same rows)
my $TABLE = 'd75cb44d-bba6-43ad-851f-4497ec526e80';
my %BLIST; { my $x = git_show("50_ENGINEERING/51_Mod_Source/Public/$M/Lists/SpellLists.lsx");
    for my $b (split /<node id="SpellList">/, $x) { my ($u) = $b =~ /id="UUID"[^>]*value="([^"]+)"/ or next;
        my ($n) = $b =~ /id="Name"[^>]*value="([^"]*)"/; my ($s) = $b =~ /id="Spells"[^>]*value="([^"]*)"/; $BLIST{$u} = [$n, $s // ''] } }
my %LISTAT = (1 => ['43261c49-335c-4231-ae5d-6a828cff974c', 'Target_Arcana_Card_Spell_GaleBurst'],
    2 => [undef, 'Shout_Arcana_Created_AeolusBag'], 3 => ['706b4719-9a6d-42c0-8e08-8b273eb3e0e4', 'Zone_Arcana_Card_Spell_WindBlast'],
    6 => [undef, 'Shout_Arcana_Card_Spell_FlowState;Shout_Arcana_Card_Passive_GaleDeflection'],
    7 => ['87872209-4d00-4a57-8e24-02fbb18c75bc', 'Shout_Arcana_Card_Spell_StormFists'],
    9 => ['fc46dcfe-4126-4b55-92ab-87e8fb43e8f9', 'Shout_Arcana_Card_Ability_Untethered'],
    10 => [undef, 'Rush_Arcana_Created_Aspect_LeapOfFaith'], 11 => ['f0892650-f4dd-41c1-bbe3-76cd7e361985', 'Target_Arcana_Created_WhereTheWindsMeet']);
my %BPROG; { my $x = git_show("50_ENGINEERING/51_Mod_Source/Public/$M/Progressions/Progressions.lsx");
    for my $b (split /<node id="Progression"/, $x) { next unless $b =~ /value="$TABLE"/; my %a;
        while ($b =~ /<attribute id="(\w+)" type="[^"]*" value="([^"]*)"/g) { $a{$1} //= $2 }
        $BPROG{$a{Level} . (($a{IsMulticlass} // '') eq 'true' ? 'mc' : '')} = \%a } }
my $GD = 'ActionResource(ArcanaGaleDeflectReturn,1,0)'; my $GR = 'ActionResource(ArcanaReactGaleDeflection,3,0)';
sub tt { "Arcana_Passive_TwinkleToes_$_[0]" } sub wl { "Arcana_Passive_Weightless_$_[0]" } sub sel { "AddSpells($_[0],,,,AlwaysPrepared)" }
my @ROWS = (   # [level, also the multiclass row?, field, add, remove]
    [1, 1, 'PassivesAdded', wl(1), tt(1)], [1, 1, 'PassivesAdded', 'Arcana_Passive_Windswept_Touch', undef],
    [2, 0, 'PassivesAdded', 'Arcana_Passive_AeolusBag', undef], [2, 0, 'Selectors', sel('LIST2'), undef],
    [3, 0, 'PassivesAdded', undef, tt(3)], [3, 0, 'PassivesRemoved', undef, tt(1)], [3, 0, 'Boosts', undef, $GD], [3, 0, 'Boosts', undef, $GR],
    [4, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Gale'], [4, 0, 'PassivesAdded', wl(4)], [4, 0, 'PassivesRemoved', wl(1)],
    [5, 0, 'PassivesAdded', undef, tt(5)], [5, 0, 'PassivesAdded', undef, wl(5)], [5, 0, 'PassivesRemoved', undef, tt(3)],
    [6, 0, 'Boosts', $GD], [6, 0, 'Boosts', $GR], [6, 0, 'Selectors', sel('LIST6')],
    [7, 0, 'PassivesAdded', undef, tt(7)], [7, 0, 'PassivesAdded', undef, wl(7)], [7, 0, 'PassivesRemoved', undef, tt(5)], [7, 0, 'PassivesRemoved', undef, wl(5)],
    [8, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Storm'], [8, 0, 'PassivesAdded', wl(8)], [8, 0, 'PassivesRemoved', wl(4)],
    [9, 0, 'PassivesAdded', undef, tt(9)], [9, 0, 'PassivesAdded', undef, wl(9)], [9, 0, 'PassivesAdded', 'Arcana_Passive_EmptyState', 'Arcana_Passive_EyeOfTheStorm_UI'],
    [9, 0, 'PassivesRemoved', undef, tt(7)], [9, 0, 'PassivesRemoved', undef, wl(7)],
    [10, 0, 'Selectors', sel('LIST10')],
    [11, 0, 'PassivesAdded', undef, tt(11)], [11, 0, 'PassivesAdded', undef, wl(11)], [11, 0, 'PassivesAdded', undef, 'Arcana_Passive_Momentum_UI'],
    [11, 0, 'PassivesRemoved', undef, tt(9)], [11, 0, 'PassivesRemoved', undef, wl(9)],
    [12, 0, 'PassivesAdded', 'Arcana_Passive_Zephyr_Hurricane', tt(12)], [12, 0, 'PassivesAdded', undef, 'Arcana_Passive_EmptyState'],
    [12, 0, 'PassivesRemoved', wl(8), tt(11)], [12, 0, 'PassivesRemoved', undef, wl(11)],
    (map { my ($l, $p) = @$_; ([12, 0, 'PassivesAdded', undef, tt($l), $l], [12, 0, 'PassivesRemoved', undef, tt($p), $l]) } [13, 12], [15, 13], [17, 15], [19, 17], [20, 19]),
);   # a 6th element: the progression row's level when it isn't the guide's (13-20 go with level 12)
sub list_join { my ($old, $add, $rm) = @_; my @v = grep { length } split /;/, ($old // ''); @v = grep { $_ ne $rm } @v if defined $rm;
    push @v, $add if defined $add && !grep { $_ eq $add } @v; join ';', @v }

# ---------------------------------------------------------------- texts that change on an existing handle
my %HLV = (h8bcf3e57gbc72gd8bbg1503g0762e93077a9 => 1, hf4767ceag7e98g7466g81cdg572e1744f0aa => 1, h869a34deg0c99gfa1bg8672g22a4fb8339b4 => 1,
    h9a3184f7g73a8g6169g04a6g6dc398547d7f => 1, hf756bce1g79bag5985ga624gb4cc6e843978 => 1, he3d63e7ege30bg4ab2gb047ga84261db272b => 1,
    hd9d08b83g0a51g6c77g9187g4e63243b7a82 => 1, h76abef56g542egceedg9549gf86ef239edc5 => 3, h8451466fg943fg2766g54bbge5811a2ba1a9 => 7,
    hd61170aagfbdeg9e94g39f3gab4d01140c21 => 7, h5aa211b3g50d8gd054g2146g6b9097806a16 => 3, hc98e7379g11e3gb428g4681g9f94f5551213 => 7,
    h0d5de297g3e6egdc22gc822gf7519e223fc6 => 12, hb6f88d63g8e4fg7022gb6fag9bfa869369c6 => 12, hd927c9e2gb38ega2c3gb9f5g7e9604a31909 => 12,
    h456b6976gfa1cg7d54geb90g1660c0e4606b => 7, hc722a395gc58egeaa3g741ag3ed8de7bb01f => 9);
%main::HUSE = ();   # handle -> "entry.field" in the game before ARC-0026
for my $n (keys %E) { next unless ($E{$n}{src} // '') eq 'mod'; for my $k (grep { $TEXTF{$_} } keys %{$E{$n}{f}}) {
    push @{$HUSE{$1}}, "$n.$k" if $E{$n}{f}{$k} =~ /^(h[0-9a-g]{36});/ } }
my %CLSH = (h8bcf3e57gbc72gd8bbg1503g0762e93077a9 => 'ClassDescriptions `Unbound` · DisplayName', hf756bce1g79bag5985ga624gb4cc6e843978 => 'ClassDescriptions `Unbound` · Description',
    h869a34deg0c99gfa1bg8672g22a4fb8339b4 => "ProgressionDescriptions (the subclass) · DisplayName", h9a3184f7g73a8g6169g04a6g6dc398547d7f => "ProgressionDescriptions (the subclass) · Description",
    he3d63e7ege30bg4ab2gb047ga84261db272b => "RootTemplate `d586b188…` (the robe) · DisplayName", hf4767ceag7e98g7466g81cdg572e1744f0aa => "Tag `1901f3df…` · DisplayName",
    hd9d08b83g0a51g6c77g9187g4e63243b7a82 => "found only in the localisation files (the spell book tab)");
# the three Awakening progress statuses (ARC-0007 shape): their text still names Wanderlust; same shape as the other Aspects
my @TIER = ('The First Step', 'Fellow Travellers', 'Into the Storm');
for my $i (0 .. 2) { my $id = 'ASPECT_PROGRESS_FOOL_' . ('I', 'II', 'III')[$i]; my ($h) = ($E{$id}{f}{Description} // '') =~ /^(h[0-9a-g]{36})/ or die "$id: no Description handle\n";
    $LOCAH{$h} = "Windswept marks left to release to awaken $TIER[$i]."; $HLV{$h} = 3 }
sub hlevel { my $h = shift; return $HLV{$h} if $HLV{$h}; my @lv;
    for my $u (@{$HUSE{$h} // []}) { my ($n) = $u =~ /^(.+)\.\w+$/; push @lv, $LEVEL{$_} for grep { /^(NEW|SET|DEL) \Q$n\E(\.|$)/ } keys %LEVEL }
    @lv or return undef; (sort { $a <=> $b } @lv)[0] }
{ my @no = grep { !defined hlevel($_) } sort keys %LOCAH;
  die "no level for these texts:\n" . join('', map { "  $_ (used by @{$HUSE{$_} // ['nothing']}): $LOCAH{$_}\n" } @no) if @no }

# ---------------------------------------------------------------- what Claude runs after each level, and the PC deck lines
my %GEN = (1 => ['Gale Burst `_2` (inherits the base) and `ARCANA_CardFamilies` rows for Zephyr Rush'],
    3 => ['Wind Blast\'s variants (they inherit the base `SpellSuccess`)'], 6 => ['Flow State `_2` (inherits the base)'],
    9 => ['`ARCANA_CardFamilies` without Evasive Flow'], 10 => ['`ARCANA_CardFamilies` row for Leap of Faith'],
    11 => ['`ARCANA_CardFamilies` without Thunderclap, with Where the Winds Meet']);
my %CDB = (1 => 'Zephyr Rush: a deck card (`cost 1`) and `ARCANA_ZEPHYR_RUSH` in `statusConjures`.',
    2 => 'Aeolus\' Bag: a 0-Thread card conjured by `ARCANA_BAG_READY`, with its container children.',
    3 => 'The Calm: conjured by `ASPECT_AWAKENED_FOOL` (replaces the Leap of Faith line).',
    8 => 'Storm\'s second Rush: conjured by `ARCANA_STORM_RUSH`.', 10 => 'Leap of Faith: a deck card (`cost 0`).',
    11 => 'Where the Winds Meet: a 0-Thread card.', 4 => 'The bag\'s container gains Eurus.', 12 => 'The bag\'s container gains the three pairs.');

my %HEAD; for (split /\n/, slurp("$ROOT/20_GAME_DESIGN/21_GDD_Arcana_Class/21.04_Subclasses/Unbound/DESIGN.md")) {
    $HEAD{$1} = [$2, $3] if /^\| (\d+) \| (.+?) \| "(.+?)" \|/ }
die "DESIGN §9.1 not read\n" unless keys(%HEAD) == 12;
(my $RULES = slurp("$OUT/_TEMPLATE_TOOLKIT_GUIDE.md")) =~ s/\r\n/\n/g;
my ($RULESEC) = $RULES =~ /(## Rules for whoever writes this file\n.*?)\n---\n/s or die "template: no rules\n";
my ($KEY) = $RULES =~ /\n(> \*\*Every cell is exactly what you paste\*\*.*?)\n\n/s or die "template: no reading key\n";
my ($ORDERSEC) = $RULES =~ /\n(#### Toolkit field order\n.*?)\n### /s or die "template: no field order\n";

sub textrow { my $k = shift; $k =~ /^h[0-9a-g]{36}$/ ? ["new handle (the text of `$k`)", $LOCAH{$k} // $EN{$k}] : [$k, $LOCA{$k}] }

# ================================================================ one guide per level
my $TODAY = do { my @t = localtime; sprintf '%04d-%02d-%02d', $t[5] + 1900, $t[4] + 1, $t[3] };
my @written;
for my $lv (1 .. 12) {
    my $LL = sprintf 'L%02d', $lv;
    my @new  = sort { $PUBRANK{pub_of($a)} <=> $PUBRANK{pub_of($b)} || $a cmp $b } map { /^NEW (.+)$/ ? $1 : () } grep { $LEVEL{$_} == $lv } keys %LEVEL;
    push @new, 'Interrupt_AttackOfOpportunity' if $lv == 1;   # the Open Path: a NEW copy of the vanilla interrupt (only a SET in the patches)
    my %sets; for my $s (@SETS) { push @{$sets{$s->[1]}}, [$s->[2], $s->[3]] if ($LEVEL{"SET $s->[1].$s->[2]"} // 0) == $lv }
    if ($BAG_AT{$lv} && $lv > 2) { push @{$sets{Shout_Arcana_Created_AeolusBag}}, ['ContainerSpells', $BAG_AT{$lv}] }
    my @dels = sort { $PUBRANK{pub_of($b)} <=> $PUBRANK{pub_of($a)} || $b cmp $a } map { /^DEL (.+)$/ ? $1 : () } grep { $LEVEL{$_} == $lv } keys %LEVEL;
    { my %left = map { $_ => 1 } @dels; my @o;   # an entry that names another one in its fields goes first
        my $refs = sub { my ($a, $b) = @_; my $f = $E{$a}{f} // {}; grep { /\b\Q$b\E\b/ } values %$f };
        while (%left) { my @free = grep { my $x = $_; !grep { $_ ne $x && $refs->($_, $x) } keys %left } @dels; @free = grep { $left{$_} } @free;
            @free or die "removal cycle at level $lv: @{[sort keys %left]}\n"; push @o, @free; delete @left{@free} }
        @dels = @o }
    my @replaced = grep { $E{$_} && ($E{$_}{src} // '') eq 'mod' && $_ ne 'Interrupt_AttackOfOpportunity' } @new;
    @new = grep { my $n = $_; !grep { $_ eq $n } @replaced } @new;
    my (@order, %numof, @uuid, @stats, @stories, @remove, @texts, @nums);
    my $step = 0; my $next = sub { sprintf '%02d', ++$step };
    my $row = sub { my ($area, $file, $entry, $action, $needs) = @_; my $n = $next->(); push @order, [$n, $area, $file, $entry, $action, $needs // '—']; $n };

    # ---- Stats: NEW (3 entries per block, same file), then CHANGED
    my @bl; my @cur; for my $n (@new) { if (@cur && (pub_of($cur[0]) ne pub_of($n) || @cur == 3)) { push @bl, [@cur]; @cur = () } push @cur, $n } push @bl, [@cur] if @cur;
    for my $b (@bl) { my $first = $step + 1; my @x = map { new_entry($_) } @$b;
        for (@$b) { $numof{$_} = $row->('Stats Editor', $AREA{pub_of($_)}, "`$_`", 'new') }
        my $num = @$b > 1 ? sprintf('%02d–%02d', $first, $step) : sprintf('%02d', $first);
        my $title = join(', ', map { my $t = $P{$_}{f}{DisplayName} // ''; $t =~ /^\{\{(\w+)\}\}$/ && $LOCA{$1} ? $LOCA{$1} : "`$_`" } @$b);
        push @stats, new_block($num, $title, @x); push @nums, map { $NUM{$_} // () } @$b;
        for my $k (map { values %{$P{$_}{f} // {}} } @$b) { push @texts, textrow($1) while $k =~ /\{\{(\w+)\}\}/g } }
    for my $n (@replaced) { my $num = $row->('Stats Editor', $AREA{pub_of($n)}, "`$n`", 'change (rewritten)'); $numof{$n} = $num;
        push @stats, replaced_block($num, $n); push @nums, $NUM{$n} // ();
        for my $k (values %{$P{$n}{f}}) { push @texts, textrow($1) while $k =~ /\{\{(\w+)\}\}/g } }
    for my $n (sort { $PUBRANK{pub_of($a)} <=> $PUBRANK{pub_of($b)} || $a cmp $b } keys %sets) { next if $n eq 'Interrupt_AttackOfOpportunity';
        my $num = $row->('Stats Editor', $AREA{pub_of($n)}, "`$n`", 'change'); $numof{$n} = $num;
        push @stats, changed_block($num, $n, @{$sets{$n}}); (my $root = $n) =~ s/_\d$//; push @nums, $NUM{$n} // $NUM{$root} // ();
        for my $s (@{$sets{$n}}) { while ($s->[1] =~ /\{\{(\w+)\}\}/g) { my $k = $1; push @texts, [$k, $LOCA{$k}] unless $k =~ /^h[0-9a-g]{36}$/ } } }   # handles: §4 "existing"

    # ---- UUID Object Editor: lists, progression rows, the preset; removals of resources go last
    my %listnum;
    if (my $t = $LISTAT{$lv}) { my ($u, $spells) = @$t; my $name = "Unbound Level $lv";
        if (!$u) { my $n = $row->('UUID Object Editor', 'Lists / SpellLists', "\"$name\"", 'new'); $listnum{$lv} = $n;
            push @uuid, "### $n · NEW · Lists / SpellLists · \"$name\"\n\n| Field | Value |\n|---|---|\n| Name | `$name` |\n| Spells | `$spells` |\n\nUUID: ________ (used in step " . sprintf('%02d', $step + 1) . ")\n" }
        else { my ($bn, $bs) = @{$BLIST{$u}}; my @r;
            push @r, "| Name | `$bn` | `$name` |" if $bn ne $name; push @r, "| Spells | `$bs` | `$spells` |" if $bs ne $spells;
            if (@r) { my $n = $row->('UUID Object Editor', 'Lists / SpellLists', "\"$bn\"", 'change');
                push @uuid, "### $n · CHANGED · Lists / SpellLists · `$u` (\"$bn\")\n\n| Field | Before | After |\n|---|---|---|\n" . join("\n", @r) . "\n" } } }
    my %prow; for my $r (grep { $_->[0] == $lv } @ROWS) { my $pl = $r->[5] // $lv; push @{$prow{$pl}}, $r }
    for my $pl (sort { $a <=> $b } keys %prow) { for my $mc ($pl == 1 ? ('mc', '') : ('')) {
        my $b = $BPROG{"$pl$mc"} or die "no progression row $pl$mc\n"; my %after = map { $_ => $b->{$_} // '' } qw(PassivesAdded PassivesRemoved Boosts Selectors);
        for my $r (@{$prow{$pl}}) { next if $mc && !$r->[1]; my ($add, $rm) = @$r[3, 4];
            $add =~ s/LIST(\d+)/<UUID from step $listnum{$1}>/ if defined $add && $add =~ /LIST(\d+)/;
            $after{$r->[2]} = list_join($after{$r->[2]}, $add, $rm) }
        my @r = map { my $bv = $b->{$_} // ''; $bv =~ s/;$//; $bv eq $after{$_} ? () : "| $_ | " . code($b->{$_}) . ' | ' . code($after{$_}) . ' |' } qw(PassivesAdded PassivesRemoved Boosts Selectors);
        next unless @r;
        my $n = $row->('UUID Object Editor', 'Progressions / Progressions', "table `d75cb44d…` level $pl" . ($mc ? ' (multiclass row)' : ''), 'change');
        push @uuid, "### $n · CHANGED · Progressions / Progressions · `$b->{UUID}` (table `d75cb44d…`, level $pl" . ($mc ? ', the multiclass row' : '') . ")\n\n| Field | Before | After |\n|---|---|---|\n" . join("\n", @r) . "\n" } }
    if ($lv == 1) { my $n = $row->('UUID Object Editor', 'CharacterCreationPresets / AbilityDistributionPresets', 'the Unbound preset', 'change');
        my %b = (Strength => 10, Dexterity => 15, Constitution => 10, Intelligence => 15, Wisdom => 13, Charisma => 8);
        my %a = (Strength => 8, Dexterity => 15, Constitution => 13, Intelligence => 15, Wisdom => 10, Charisma => 10);
        push @uuid, "### $n · CHANGED · CharacterCreationPresets / AbilityDistributionPresets · `e611f20a-75c8-47ac-8323-c9e65898c1ec` (class `dc2e68d3…` Unbound)\n\n| Field | Before | After |\n|---|---|---|\n"
            . join("\n", map { "| $_ | `$b{$_}` | `$a{$_}` |" } grep { $b{$_} != $a{$_} } qw(Strength Dexterity Constitution Intelligence Wisdom Charisma))
            . "\n\nNumbers: `CLS_Unbound#preset_next` (STR 8 · DEX 15 · CON 13 · INT 15 · WIS 10 · CHA 10, WB21: DEX and INT for Be the Leaf).\n";
        push @nums, '`CLS_Unbound#preset_next`' }

    # ---- Stories
    if ($lv == 2) { my $n = $row->('Stories', 'Goals', '`ARCANA_Aspect_Fool`', '**replace the whole text**', join(', ', map { $numof{$_} // () } qw(ARCANA_BAG_READY ARCANA_BAG_OPEN)));
        (my $g = slurp("$WIP/22_goal_fool.txt")) =~ s/\r\n/\n/g; $g =~ s/\n+$//;
        push @stories, "### $n · CHANGED goal `ARCANA_Aspect_Fool` — select all its text and paste this over it\n\n"
          . "It replaces the Wanderlust round goal. What it does (all levels; the parts of later levels wait for their passives and statuses):\n"
          . "marks mirrored in `DB_ARCANA_Windswept` (hers, and her allies' at Tier II); the bag counts X (her standing Windswept\n"
          . "enemies, capped 2 / 3 / 4 / 5 by Zephyr's rank), releases every mark and starts the chosen wind(s) for X of her turns,\n"
          . "a sweep at each of her turn starts while it blows, `ARCANA_BAG_OPEN` showing the turns left; The Calm's gusts; Tier I's\n"
          . "free Rush; Tier III's push on each sweep; each released mark is one Awakening step; the reset at combat end.\n\n```\n$g\n```\n\n"
          . "Numbers: the cap `2` / `3` / `4` / `5` = `FEAT_Unbound_AeolusBag#wind_cap_next` `by_level`.\n";
        push @nums, '`FEAT_Unbound_AeolusBag#wind_cap_next`' }
    if ($lv == 3) { my $n = $row->('Stories', 'Goals', '`ARCANA_Aspect_Common`', 'change 3 lines', '—');
        push @stories, "### $n · CHANGED goal `ARCANA_Aspect_Common` — the three Fool goals\n\nIn `PROC_ARCANA_Aspect_Init()`, find these three lines:\n\n```\n"
          . qq{DB_ARCANA_AspectTier("FOOL", 1, "Arcana_Passive_Aspect_Fool_I", "ASPECT_AWAKENED_FOOL_I", 3);\nDB_ARCANA_AspectTier("FOOL", 2, "Arcana_Passive_Aspect_Fool_II", "ASPECT_AWAKENED_FOOL_II", 4);\nDB_ARCANA_AspectTier("FOOL", 3, "Arcana_Passive_Aspect_Fool_III", "ASPECT_AWAKENED_FOOL_III", 5);\n}
          . "```\n\nand paste these over them. Nothing else in the goal changes.\n\n```\n"
          . qq{DB_ARCANA_AspectTier("FOOL", 1, "Arcana_Passive_Aspect_Fool_I", "ASPECT_AWAKENED_FOOL_I", 3);\nDB_ARCANA_AspectTier("FOOL", 2, "Arcana_Passive_Aspect_Fool_II", "ASPECT_AWAKENED_FOOL_II", 5);\nDB_ARCANA_AspectTier("FOOL", 3, "Arcana_Passive_Aspect_Fool_III", "ASPECT_AWAKENED_FOOL_III", 8);\n}
          . "```\n\nNumbers: goals `3` / `5` / `8` (marks released in the fight) = `FEAT_Unbound_AspectAwakening#goals_next` `by_level`.\n";
        push @nums, '`FEAT_Unbound_AspectAwakening#goals_next`' }
    push @stories, "After pasting: **compile** in the Story Editor and read `Mods/AspectClass_…/Story/log.txt` — it must end with `0 error(s)`. A warning such as *Database defined but never checked* is a defect: send me the log.\n" if @stories;

    # ---- retired entries (OR-10: a published entry is never deleted; after this level nothing in the mod points to them)
    if (@dels) { my @r = map { "| `$_` | $AREA{pub_of($_)} | " . ($DELWHY{$_} // die "no reason for retiring $_\n") . ' |' } @dels;
        push @remove, "### RETIRE · entries that leave the Windborn at this level — do not delete them\n\nNothing to type. After the steps above no list, progression or entry of the mod points to them any more; they stay in the mod, unused (OR-10: a published entry is never renamed or deleted — an old save may still name it).\n\n| Entry | File | Why it leaves |\n|---|---|---|\n" . join("\n", @r) . "\n"
          . ($lv == 12 ? "\nThe resource `ArcanaFoolsLuck` (UUID Object Editor → ActionResourceDefinitions; old Tier III Fool's Luck, WB24) is retired the same way: after this level only the retired interrupt names it.\n" : '') }

    # ---- texts that change on an existing handle at this level
    my @ch = sort grep { hlevel($_) == $lv } keys %LOCAH;
    my $gen = $GEN{$lv} ? $row->('—', 'Generated', join('; ', @{$GEN{$lv}}), 'Claude runs scripts', 'all above') : undef;
    my $cdb = $CDB{$lv} ? $row->('—', 'PC edition', '`CardDB.lua`', 'Claude adds the lines', 'all above') : undef;

    # ---- write it
    my ($arr, $hl) = @{$HEAD{$lv}};
    my @der = derived(@nums); my $o = '';
    $o .= "---\nid: TOOLKIT_ARC-0026_$LL\nticket: ARC-0026\nspec: SPEC_ARC-0026\nstatus: draft\nderived_from: [" . join(', ', @der) . "]\ngenerated_at: $TODAY\nauthor: Mod Engineer\n---\n\n";
    $o .= "# TOOLKIT_ARC-0026 · The Windborn — level $lv\n\n> **What this file is.** The point-by-point guide to enter **level $lv** of the Windborn (internal name *Unbound*)\n"
        . "> by hand in the BG3 Toolkit — *$arr*. Headline: \"$hl\". Technical source: `SPEC_ARC-0026` (stage $lv).\n"
        . "> Generated by `_wip/Unbound/arc0026/60_toolkit_guides.pl` from the build patches and the game before ARC-0026\n> (commit `$BASE`): regenerate it, never edit a number by hand (ADR-0008).\n>\n";
    $o .= $lv == 1 ? "> **Before you start:** see step 00 below — the game already holds a first version of part of this level.\n"
                   : "> **Before you start:** level " . ($lv - 1) . " is typed, compiled and its tests in `QA-0004` passed.\n";
    $o .= "\n---\n\n$RULESEC\n---\n\n## 0 · Order of work\n\n";
    if ($lv == 1) { $o .= "**00 · Clear the first version.** On 2026-10-17 a patch (ARC-0026 stage 2, before this guide) put part of level 1 in\n"
        . "the game. To type this level as new: in the Stats Editor delete `ARCANA_WINDSWEPT`, `ARCANA_ZEPHYR_RUSH`,\n"
        . "`Arcana_Passive_Windswept_Touch`, `Rush_Arcana_Created_ZephyrRush` and your copy of `Interrupt_AttackOfOpportunity`;\n"
        . "in the UUID Object Editor take `Arcana_Passive_Windswept_Touch` out of both level-1 progression rows. The fields of\n"
        . "the CHANGED blocks already hold their *After* value: type them over anyway. In the Story Editor, the goal\n"
        . "`ARCANA_Probe_ARC0026` (it removes the old probe spells on load) can be deleted once you have loaded your save.\n\n" }
    $o .= "| # | Area | File | Entry | Action | Needs | ☐ |\n|---|---|---|---|---|---|---|\n" . join('', map { "| $_->[0] | $_->[1] | $_->[2] | $_->[3] | $_->[4] | $_->[5] | ☐ |\n" } @order);
    $o .= "\n---\n\n## 1 · Stories (Osiris)\n\n" . (@stories ? join("\n", @stories) : "Nothing at this level" . ($lv > 2 ? ': the goal entered at level 2 already handles it.' : '.') . "\n");
    $o .= "\n---\n\n## 2 · UUID Object Editor\n\n" . (@uuid ? join("\n", @uuid) : "Nothing at this level.\n");
    $o .= "\n---\n\n## 3 · Stats Editor\n\n$KEY\n\n" . join("\n", @stats) . (@remove ? "\n" . join("\n", @remove) : '');
    if ($gen || $cdb) { $o .= "\n### Generated and PC edition — do not type\n\n| # | What | Built by | When |\n|---|---|---|---|\n";
        $o .= "| $gen | " . join('; ', @{$GEN{$lv}}) . ' | `82_Automation/stats/gen_upcast_variants.pl --apply`, then `sort_stats.pl --apply` and `check_cards.pl` | after you save |' . "\n" if $gen;
        $o .= "| $cdb | $CDB{$lv} | Claude, in `ScriptExtender/Lua/Server/Cards/CardDB.lua` (`lua/CardDB.patch`) | after you save |\n" if $cdb }
    my %seen; @texts = grep { !$seen{$_->[0]}++ } @texts;
    $o .= "\n---\n\n## 4 · Localisation summary\n\nEvery text of this level, so nothing is missed.\n\n";
    $o .= "**New handles** (typed in the blocks above):\n\n| Key | English text |\n|---|---|\n" . join('', map { "| `$_->[0]` | " . code($_->[1]) . " |\n" } @texts) . "\n" if @texts;
    $o .= "**Existing handles whose text changes** (open the entry, then the text of the field):\n\n| Handle | Used by | Before | After |\n|---|---|---|---|\n"
        . join('', map { my $h = $_; "| `$h` | " . join(', ', map { "`$_`" } @{$HUSE{$h} // []}, $CLSH{$h} // ()) . ' | ' . code($EN{$h}) . ' | ' . code($LOCAH{$h}) . " |\n" } @ch) . "\n" if @ch;
    $o .= "No text at this level.\n\n" unless @texts || @ch;
    $o .= "---\n\n## 5 · After the Toolkit\n\n1. Stats Editor → *File → Reload Stats Files*" . (@stories ? '; Story Editor → compile, read `Story/log.txt` (`0 error(s)`)' : '') . ".\n"
        . "2. Save in the Toolkit and close it. Tell me (`[fechado] ARC-0026 — nível $lv digitado`): I check every block against this\n"
        . "   guide, run `sync_data` and what the *Generated and PC edition* table lists, then `check_cards.pl` and commit.\n"
        . "3. Play the level-$lv tests of `QA-0004` (the Arcana Test Guides page, tab Windborn, session L$lv) and write the results there.\n"
        . "4. Tick the steps in section 0.\n";
    my $file = "$OUT/TOOLKIT_ARC-0026_$LL.md";
    open my $h, '>:raw:encoding(UTF-8)', $file or die "$file: $!"; print $h $o; close $h; push @written, $file;
}
for my $f (@written) { my $r = `perl "$ROOT/80_TOOLS_AND_PIPELINE/82_Automation/stats/order_toolkit_guide.pl" --apply "$f" 2>&1`; print $r }
print "written: ", scalar(@written), " guides\n";
