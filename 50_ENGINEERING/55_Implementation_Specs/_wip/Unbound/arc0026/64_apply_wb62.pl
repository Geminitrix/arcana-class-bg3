use strict; use warnings;
# ARC-0026 WB62 + WB63: apply SPEC_ARC-0026 "Fixes owed" F1-F22 and the Gale Deflection rule (one use per turn, the
# card Unique) to the game files. Bytes in, bytes out (line endings and BOM kept). Every edit must match exactly once.
# Usage: perl apply_wb62.pl [--apply]   (without --apply: checks every edit, writes nothing)
my $APPLY = grep { $_ eq '--apply' } @ARGV;
my $G = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
my $ED = "$G/Editor/Mods/$M"; my $PUB = "$G/Public/$M"; my $MOD = "$G/Mods/$M";
my (%file, %orig);
sub load { my $f = shift; return if exists $file{$f}; open my $h, '<:raw', $f or die "$f: $!"; local $/; $file{$f} = <$h>; $orig{$f} = $file{$f} }
my $n = 0;
sub rep { my ($f, $a, $b, $tag) = @_; load($f); my $c = () = $file{$f} =~ /\Q$a\E/g;
  die "$tag: $c matches in $f\n  $a\n" unless $c == 1; $file{$f} =~ s/\Q$a\E/$b/; $n++; print "ok $tag\n" }
# inside one Editor stat_object (by its Name)
sub obj { my ($f, $name, $a, $b, $tag) = @_; load($f); my $hit = 0;
  $file{$f} =~ s{(<stat_object\b(?:(?!</stat_object>).)*?name="Name"[^>]*value="\Q$name\E"(?:(?!</stat_object>).)*</stat_object>)}{
    my $o = $1; my $c = () = $o =~ /\Q$a\E/g; die "$tag: $c matches in $name\n" unless $c == 1; $o =~ s/\Q$a\E/$b/; $hit++; $o }se;
  die "$tag: object $name not found\n" unless $hit == 1; $n++; print "ok $tag\n" }
# inside one Public entry
sub ent { my ($f, $name, $a, $b, $tag) = @_; load($f); my $hit = 0;
  $file{$f} =~ s{(new entry "\Q$name\E"\r?\n(?:(?!new entry ).)*)}{
    my $o = $1; my $c = () = $o =~ /\Q$a\E/g; die "$tag: $c matches in $name\n" unless $c == 1; $o =~ s/\Q$a\E/$b/; $hit++; $o }se;
  die "$tag: entry $name not found\n" unless $hit == 1; $n++; print "ok $tag\n" }

my $ST = "$ED/Stats"; my $GD = "$PUB/Stats/Generated/Data";
# F1 Zephyr Strike's own name
obj("$ST/SpellData/Target.stats", 'Arcana_Created_ZephyrStrike', 'handle="h56bc27caga588g2b1agc487ge918b523cedf"', 'handle="h939a9ea3gfbabg50bbgaa8fga3efd4c6de88"', 'F1 editor');
ent("$GD/Spell_Target.txt", 'Target_Arcana_Created_ZephyrStrike', '"h56bc27caga588g2b1agc487ge918b523cedf;5"', '"h939a9ea3gfbabg50bbgaa8fga3efd4c6de88;5"', 'F1 public');
# F2 Unleashed Winds' TargetConditions
for (["$ST/SpellData/Target.stats", 'obj', 'Arcana_Created_UnleashedWinds'], ["$GD/Spell_Target.txt", 'ent', 'Target_Arcana_Created_UnleashedWinds']) {
  my ($f, $k, $nm) = @$_; my $s = $k eq 'obj' ? \&obj : \&ent;
  $s->($f, $nm, "Enemy() not Dead() and not HasPassive(", "Enemy() and not Dead() and not HasPassive(", "F2 $k") }
# F3 + WB63 Gale Deflection card: level 3; one use per turn (the resource refills each turn), no stock
my $gdOld = "IF(not HasStatus('GALE_DEFLECTION_READY')):UseActionResource(SELF,ArcanaReactGaleDeflection,100%,0);IF(not HasStatus('GALE_DEFLECTION_READY')):ApplyStatus(SELF,GALE_DEFLECTION_READY,100,-1);RestoreResource(SELF,ArcanaReactGaleDeflection,1,0)";
my $gdNew = "ApplyStatus(SELF,GALE_DEFLECTION_READY,100,-1)";
my $rcOld = "not HasStatus('ARCANA_WEAVING',context.Source) and not (HasStatus('GALE_DEFLECTION_READY',context.Source) and HasActionResource('ArcanaReactGaleDeflection',3,0,false,false,context.Source))";
my $rcNew = "not HasStatus('GALE_DEFLECTION_READY',context.Source)";
obj("$ST/SpellData/Shout.stats", 'Arcana_Card_Passive_GaleDeflection', 'name="Level" type="IntegerTableFieldDefinition" value="2"', 'name="Level" type="IntegerTableFieldDefinition" value="3"', 'F3 editor');
obj("$ST/SpellData/Shout.stats", 'Arcana_Card_Passive_GaleDeflection', $gdOld, $gdNew, 'WB63 card editor');
obj("$ST/SpellData/Shout.stats", 'Arcana_Card_Passive_GaleDeflection', $rcOld, $rcNew, 'WB63 requirement editor');
ent("$GD/Spell_Shout.txt", 'Shout_Arcana_Card_Passive_GaleDeflection', 'data "Level" "2"', 'data "Level" "3"', 'F3 public');
ent("$GD/Spell_Shout.txt", 'Shout_Arcana_Card_Passive_GaleDeflection', $gdOld, $gdNew, 'WB63 card public');
ent("$GD/Spell_Shout.txt", 'Shout_Arcana_Card_Passive_GaleDeflection', $rcOld, $rcNew, 'WB63 requirement public');
rep("$PUB/ActionResourceDefinitions/ActionResourceDefinitions.lsx",
    qq{value="ArcanaReactGaleDeflection"/>\n                    <attribute id="ReplenishType" type="FixedString" value="Never"/>},
    qq{value="ArcanaReactGaleDeflection"/>\n                    <attribute id="ReplenishType" type="FixedString" value="Turn"/>}, 'WB63 refill per turn');
for my $f ("$PUB/Progressions/Progressions.lsx", "$ED/Progressions/Progressions.tbl") {
  rep($f, 'ActionResource(ArcanaGaleDeflectReturn,1,0);ActionResource(ArcanaReactGaleDeflection,3,0)',
          'ActionResource(ArcanaGaleDeflectReturn,1,0);ActionResource(ArcanaReactGaleDeflection,1,0)', 'WB63 one use') }
# F4 Ally Tempest status: its own icon (it inherited Tempest's)
obj("$ST/StatusData/Status_BOOST.stats", 'ZEPHYR_TEMPEST_ALLY', 'handle="hc8e70842g41d8gaaa2gbb19gbd131a7330f8" version="2" />',
    qq{handle="hc8e70842g41d8gaaa2gbb19gbd131a7330f8" version="2" />\n        <field name="Icon" type="StringTableFieldDefinition" value="PassiveFeature_HeartOfTheStorm_Resistance" />}, 'F4 editor');
ent("$GD/Status_BOOST.txt", 'ZEPHYR_TEMPEST_ALLY', 'data "DisplayName" "hc8e70842g41d8gaaa2gbb19gbd131a7330f8;2"',
    qq{data "DisplayName" "hc8e70842g41d8gaaa2gbb19gbd131a7330f8;2"\ndata "Icon" "PassiveFeature_HeartOfTheStorm_Resistance"}, 'F4 public');

# F5-F17 English loca
my $L = "$MOD/Localization/English/english.xml";
sub loca { my ($h, $a, $b, $tag) = @_; load($L); my $hit = 0;
  $file{$L} =~ s{(contentuid="\Q$h\E"[^>]*>)(.*?)(</content>)}{ my ($p, $t, $s) = ($1, $2, $3);
    my $c = () = $t =~ /\Q$a\E/g; die "$tag: $c in $h\n" unless $c >= 1; $t =~ s/\Q$a\E/$b/g; $hit++; "$p$t$s" }se;
  die "$tag: handle $h\n" unless $hit == 1; $n++; print "ok $tag\n" }
loca('hccc388f3g3470g7274g913agf1747c6c5cb9', 'Weast Wind', 'West Wind', 'F5');
loca('h955602a4ga4e5g7675gd372g15f80a687280', 'Weast Wind', 'West Wind', 'F6');
loca($_, 'Weast Wind', 'West Wind', 'F7') for qw(hf9cd17fegc710g12cbg5181gb6e7c97bf309 h54c232b7gf728g84d0gea11g54ae2c0eba23);
loca('h172ef75ag97bcgf51fg3ab5geb33714349e2', 'Winswept', 'Windswept', 'F8');
loca('hdae8725bg5610gc5e1g134ag9ee368e826f7', 'Whind Whispers', 'Wind Whispers', 'F9');
loca('hd97fd5c1g81d2g01ebgc6f7gd346aa83d5dc', 'Unleash Winds', 'Unleashed Winds', 'F10');
loca($_, 'West wind', 'West Wind', 'F11') for qw(h456b6976gfa1cg7d54geb90g1660c0e4606b hc7a1320ag001bg324fg456fg54638e396870 hf77f8e6egab61g4904gb290gb7bc67941ee7);
loca('h9a99082cgad37ga1deg8c8ag4e88ffbcce58', 'the South and North Winds', 'the East and North Winds', 'F12');
loca('h78ff60d5g9c31g530dgf804g554f995ec4d7', 'Your gain protection', 'Your allies gain protection', 'F13');
loca('h402ace5bgf1e8g2fe1gf6e4g220b7505458b', 'Reduce the damage from a ranged weapon attack by', 'Reduce the damage from a ranged weapon attack made by a non-Windswept enemy by', 'F14');
loca('h04212dafge9bcgc6d2g82d7gf9dd7540b5d0', 'Every enemy you hit, becomes ', 'Enemies you hit, or that fail a saving throw against you, become ', 'F15');
loca('ha5a822f1g6c30g657cg2335gd1a7e2288437', 'After making an attack while unarmed,', 'After an unarmed attack or an Arcane card,', 'F16');
loca($_, '### EMPTY', '', 'F17') for qw(h6e8df9f1g98f4gc696g0586g988b14114aa3 hdefa8084g831cg23b3ga2adg71c342e61c0c hb5e3c061ge8f4gdda1g76d1gbe8b970f9fbf h73f0d397g8ed2gde09g1339g785e8b68d8f3 he8f928aag9dadg34dcgd4f0g4de0daeac346);

# F18-F22 PC deck
my $C = "$MOD/ScriptExtender/Lua/Server/Cards/CardDB.lua";
rep($C, qq{    -- Reaction cards: see D.reactions. Gale Deflection can be used up to 3 times a round, so it takes\n    -- three copies.\n    ["Shout_Arcana_Card_Passive_GaleDeflection"] = { aspect = "Unbound", cost = 2 },\n},
        qq{    -- Ready: Gale Deflection (WB63): a normal card, one copy. Played, it keeps GALE_DEFLECTION_READY until combat\n    -- ends; the reaction refills once a turn by itself (ArcanaReactGaleDeflection, ReplenishType Turn).\n    ["Shout_Arcana_Card_Passive_GaleDeflection"] = { aspect = "Unbound", cost = 3, keywords = { Unique = true } },\n}, 'F21 card');
rep($C, qq{    ["Rush_Arcana_Created_Aspect_LeapOfFaith"] = { aspect = "Unbound" },\n},
        qq{    ["Shout_Arcana_Created_TheCalm"] = { aspect = "Unbound" },\n    -- The Windborn's ultimate (WB11): a Created ability, conjured while she has a mark to release (BAG_READY,\n    -- D.statusConjures), no slot, no Thread -- otherwise the lock of non-cards would keep it out of combat.\n    ["Shout_Arcana_Created_AeolusBag"] = { aspect = "Unbound", cost = 0 },\n}, 'F18 + F22 card');
rep($C, qq{    ARCANA_ZEPHYR_RUSH = { id = "Rush_Arcana_Created_ZephyrRush", lasts = 1 },\n    -- the Aspect card stays playable for the rest of the fight\n    ASPECT_AWAKENED_FOOL = { id = "Rush_Arcana_Created_Aspect_LeapOfFaith", lasts = 99 },\n},
        qq{    ZEPHYR_RUSH = { id = "Rush_Arcana_Created_ZephyrRush", lasts = 1 },\n    ZEPHYR_RUSH_STORM = { id = "Rush_Arcana_Created_ZephyrRush_Storm", lasts = 1 },\n    BAG_READY = { id = "Shout_Arcana_Created_AeolusBag", lasts = 99 },\n    -- the Aspect card stays playable for the rest of the fight\n    ASPECT_AWAKENED_FOOL = { id = "Shout_Arcana_Created_TheCalm", lasts = 99 },\n}, 'F19 + F20 + F22 conjures');
rep($C, qq{    ["Shout_Arcana_Card_Passive_GaleDeflection"] = {\n        ready = "GALE_DEFLECTION_READY", resource = "ArcanaReactGaleDeflection",\n        used = "GALE_DEFLECTION_USED_TECH", perRound = 3,\n    },\n}, '', 'F21 reaction card out');

print "$n edits checked\n";
exit 0 unless $APPLY;
for my $f (sort keys %file) { next if $file{$f} eq $orig{$f}; open my $o, '>:raw', $f or die "$f: $!"; print $o $file{$f}; close $o; print "wrote $f\n" }
