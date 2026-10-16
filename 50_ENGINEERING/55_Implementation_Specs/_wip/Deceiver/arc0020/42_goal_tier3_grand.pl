# ARC-0020 Tasks 0.6 + 0.7 — ARCANA_Deceiver_Doubles.txt: Grand Deception reads the Veil (DV22) and Tier III
# "the lie explodes" (DV21). Same stage as 40_tier3.patch.
#   perl 42_goal_tier3_grand.pl <path to the goal>   (stage 3, game and Toolkit closed; CRLF and ASCII kept; idempotent)
# Signatures checked in a story header (LeBlanc reference mod): UsingSpell, CastSpell, CastedSpell, GetPosition,
# GetDistanceTo, CreateExplosionAtPosition. Numbers from 25: 3.0 m (SPL_Deceiver_GrandDeception.doubles_range_next),
# 1 Doubt per Double (doubt_per_double_next = one PROC_ARCANA_Doubt_Add per matching Double).
use strict; use warnings;
my $f = shift or die "goal path\n";
open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h;
exit 0 if $s =~ /ARC-0020: Tier III/;   # idempotent

my $init = <<'EOF';
DB_ARCANA_GDBefore((CHARACTER)00000000-0000-0000-0000-000000000000, (CHARACTER)00000000-0000-0000-0000-000000000000);
NOT DB_ARCANA_GDBefore((CHARACTER)00000000-0000-0000-0000-000000000000, (CHARACTER)00000000-0000-0000-0000-000000000000);
EOF

my $old_rule = <<'EOF';
IF
StatusApplied((CHARACTER)_Foe, "GRAND_DECEPTION_TECH", (CHARACTER)_Cause, _)
THEN
PROC_ARCANA_Doubt_Add(_Foe, _Cause);
PROC_ARCANA_Doubt_Add(_Foe, _Cause);
EOF

my $new_rules = <<'EOF';
// ARC-0020 (DV22): the flat two stacks are gone. Grand Deception reads where she placed her Doubles: before the spell
// resolves (UsingSpell, earlier than its Summon functors), the Doubles she has are written down; each enemy that fails
// (GRAND_DECEPTION_TECH) gains one Doubt for each of those Doubles within 3 m of it (25: doubles_range_next), through
// PROC_ARCANA_Doubt_Add as before (one full call per Double, so the count rises by one each time). The list is cleared
// 1.5 s after the cast. Probe B5 (SPEC_ARC-0020): UsingSpell fires before the new Doubles register.
IF
UsingSpell((CHARACTER)_Owner, _Spell, _, _, _)
AND
DB_ARCANA_CardFamily(_Spell, "Shout_Arcana_Card_Spell_GrandDeception")
AND
DB_ARCANA_Double(_Double, _Owner, _)
AND
NOT DB_ARCANA_DoubleGone(_Double, _Owner)
THEN
DB_ARCANA_GDBefore(_Owner, _Double);

IF
StatusApplied((CHARACTER)_Foe, "GRAND_DECEPTION_TECH", (CHARACTER)_Owner, _)
AND
DB_ARCANA_GDBefore(_Owner, _Double)
AND
NOT DB_ARCANA_DoubleGone(_Double, _Owner)
AND
GetDistanceTo(_Foe, _Double, _Dist)
AND
_Dist <= 3.0
THEN
PROC_ARCANA_Doubt_Add(_Foe, _Owner);

IF
CastedSpell((CHARACTER)_Owner, _Spell, _, _, _)
AND
DB_ARCANA_CardFamily(_Spell, "Shout_Arcana_Card_Spell_GrandDeception")
THEN
RealtimeObjectTimerLaunch(_Owner, "ARCANA_GDBefore", 1500);

IF
ObjectTimerFinished((CHARACTER)_Owner, "ARCANA_GDBefore")
AND
DB_ARCANA_GDBefore(_Owner, _Double)
THEN
NOT DB_ARCANA_GDBefore(_Owner, _Double);
EOF

my $tier3 = <<'EOF';
//REGION ARC-0020: Tier III, the lie explodes (DV21)
// From Tier III every Splinter is one burst of 4 m (25: SPL_Deceiver_Splinter.tier3_radius_next), made here with the
// vanilla Death Burst pattern (GLO_CombatNPCs.txt: CreateExplosionAtPosition at the creature, the projectile's
// ExplodeRadius sets the area). At Tier III the shout itself deals nothing (its SpellProperties check her Tier III
// status, 40_tier3.patch), so a Splinter is never two bursts. She is the caster: the damage and the Doubt are hers.
// A Splinter cast (its own turn, Splinter on Command, The Veil Lifts):
IF
CastSpell((CHARACTER)_Double, "Shout_Deceiver_Double_Shatter", _, _, _)
AND
DB_ARCANA_MirrorImageOf(_Double, _Owner)
AND
DB_ARCANA_AspectReached(_Owner, 3)
AND
GetPosition(_Double, _X, _Y, _Z)
THEN
CreateExplosionAtPosition(_X, _Y, _Z, "Projectile_Deceiver_Double_SplinterBurst", 1, _Owner);

// A Double destroyed by an enemy splinters by itself. Only the enemy's doing: the cap, Dismiss, the cleanups and a
// Splinter's own vanishing are marked blameless before the death (review focus 1); an ally's hit is not an enemy's.
// Probe B3: the position of a Double that has just died is still valid here.
IF
Died(_Double)
AND
DB_ARCANA_MirrorImageOf(_Double, _Owner)
AND
NOT DB_ARCANA_DoubleNoBlame(_Double)
AND
DB_ARCANA_DoubleKiller(_Double, _Killer)
AND
IsEnemy(_Killer, _Owner, 1)
AND
DB_ARCANA_AspectReached(_Owner, 3)
AND
GetPosition(_Double, _X, _Y, _Z)
THEN
CreateExplosionAtPosition(_X, _Y, _Z, "Projectile_Deceiver_Double_SplinterBurst", 1, _Owner);
//END_REGION

EOF
for ($init, $old_rule, $new_rules, $tier3) { s/\r?\n/\r\n/g }

$s =~ s/(INITSECTION\r\n\/\/ Type-pinning for every DB this goal owns \(declare, then delete the dummy row\)\.\r\n)/$1$init/ or die "INITSECTION anchor\n";
my $n = ($s =~ s/\Q$old_rule\E/$new_rules/);
die "Grand Deception rule not found (expected once, got $n)\n" unless $n == 1;
$s =~ s{(//REGION A Double goes\r\n)}{$tier3$1} or die "A Double goes anchor\n";
die "non-ASCII\n" if $s =~ /[^\x00-\x7F]/;
open $h, '>:raw', $f or die $!; print $h $s; close $h; print "applied\n";
