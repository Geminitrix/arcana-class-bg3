#!/usr/bin/perl
# ARC-0008 stage 3: builds the stage-3 ARCANA_Kingmaker_Wheel goal from the stage-2 one (the game's file), by insertions at
# exact anchors; every anchor must match once. Writes 32_goal_stage3.txt next to this script (LF); the apply step copies it
# into the game with the game file's line ending.
#   perl 32_goal.pl            build and report
#   perl 32_goal.pl --apply    also write it into the game ([fechado] ARC-0008)
use strict; use warnings;
use File::Basename qw(dirname);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $GOAL = "$G/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Story/RawFiles/Goals/ARCANA_Kingmaker_Wheel.txt";
my $apply = grep { $_ eq '--apply' } @ARGV;
open my $h, '<:raw', $GOAL or die "$GOAL: $!"; local $/; my $raw = <$h>; close $h;
my $crlf = $raw =~ /\r\n/; (my $s = $raw) =~ s/\r\n/\n/g;
if ($s =~ /KINGMAKER_INVERT_TECH/) { print "already stage 3\n"; exit 0 }
my $bad = 0;
sub put { my ($what, $anchor, $text, $before) = @_;
    my $n = () = $s =~ /\Q$anchor\E/g;
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s =~ s/\Q$anchor\E/$before ? "$text$anchor" : "$anchor$text"/e; print "ok     $what\n" }

# 0. header
put('header', "// (the Wheel turns once more) and Atropos' Cut (the thread is cut).\n",
"// Stage 3: Peripeteia (every creature on the Wheel within 18 m to the opposite position) and the Court (offices until the
// next Long Rest; the King's Hand wears the crown while no ally Reigns; the Master of Healing lifts the healed).\n");

# 1. tables
put('tables', "DB_ARCANA_Kingmaker_PositionStatus(\"FALLEN\", \"KINGMAKER_FALLEN\");\n", <<'T');
DB_ARCANA_Kingmaker_Opposite("RISING", "FALLING");
DB_ARCANA_Kingmaker_Opposite("FALLING", "RISING");
DB_ARCANA_Kingmaker_Opposite("REIGNING", "FALLEN");
DB_ARCANA_Kingmaker_Opposite("FALLEN", "REIGNING");
DB_ARCANA_Kingmaker_Office("COURT_KINGS_HAND", "KINGS_HAND");
DB_ARCANA_Kingmaker_Office("COURT_LORD_COMMANDER", "LORD_COMMANDER");
DB_ARCANA_Kingmaker_Office("COURT_MASTER_OF_HEALING", "MASTER_OF_HEALING");
DB_ARCANA_Kingmaker_HealStep("FALLEN");
DB_ARCANA_Kingmaker_HealStep("RISING");
T
put('tables clear', "PROC\nPROC_ARCANA_Kingmaker_Init()\nTHEN\n", <<'T', 1);
PROC
PROC_ARCANA_Kingmaker_Init()
AND
DB_ARCANA_Kingmaker_Opposite(_From, _To)
THEN
NOT DB_ARCANA_Kingmaker_Opposite(_From, _To);

PROC
PROC_ARCANA_Kingmaker_Init()
AND
DB_ARCANA_Kingmaker_Office(_Status, _Office)
THEN
NOT DB_ARCANA_Kingmaker_Office(_Status, _Office);

PROC
PROC_ARCANA_Kingmaker_Init()
AND
DB_ARCANA_Kingmaker_HealStep(_Position)
THEN
NOT DB_ARCANA_Kingmaker_HealStep(_Position);

T

# 2. the Court, before every rule that reads it (its column types are set here)
put('court', "//REGION Bind - Coronation", <<'T', 1);
//REGION The Court (level 5) - offices until the next Long Rest; seats = Charisma modifier, at least 1
IF
StatusApplied((CHARACTER)_Holder, _Status, _Owner, _)
AND
DB_ARCANA_Kingmaker_Office(_Status, _Office)
THEN
DB_ARCANA_Kingmaker_Court(_Owner, _Holder, _Office);
ApplyStatus(_Holder, "COURT_HOLDER", -1.0, 1, _Owner);
PROC_ARCANA_Kingmaker_TakeSeat((CHARACTER)_Owner);

PROC
PROC_ARCANA_Kingmaker_TakeSeat((CHARACTER)_Owner)
AND
NOT DB_ARCANA_Kingmaker_Seats(_Owner, _)
THEN
DB_ARCANA_Kingmaker_Seats(_Owner, 0);

PROC
PROC_ARCANA_Kingmaker_TakeSeat((CHARACTER)_Owner)
AND
DB_ARCANA_Kingmaker_Seats(_Owner, _Old)
AND
IntegerSum(_Old, 1, _New)
THEN
NOT DB_ARCANA_Kingmaker_Seats(_Owner, _Old);
DB_ARCANA_Kingmaker_Seats(_Owner, _New);

// full when the seats taken reach the Charisma modifier (at least 1): the Convene the Court options then can't be cast
PROC
PROC_ARCANA_Kingmaker_TakeSeat((CHARACTER)_Owner)
AND
DB_ARCANA_Kingmaker_Seats(_Owner, _N)
AND
GetAbility(_Owner, "Charisma", _Score)
AND
IntegerSubtract(_Score, 10, _X)
AND
IntegerDivide(_X, 2, _Mod)
AND
_Mod < 1
AND
_N >= 1
THEN
ApplyStatus(_Owner, "COURT_FULL", -1.0, 1, _Owner);

PROC
PROC_ARCANA_Kingmaker_TakeSeat((CHARACTER)_Owner)
AND
DB_ARCANA_Kingmaker_Seats(_Owner, _N)
AND
GetAbility(_Owner, "Charisma", _Score)
AND
IntegerSubtract(_Score, 10, _X)
AND
IntegerDivide(_X, 2, _Mod)
AND
_Mod >= 1
AND
_N >= _Mod
THEN
ApplyStatus(_Owner, "COURT_FULL", -1.0, 1, _Owner);

// an office that ends (death, Long Rest) leaves the Court; its seat stays taken until the Long Rest
IF
StatusRemoved((CHARACTER)_Holder, _Status, _, _)
AND
DB_ARCANA_Kingmaker_Office(_Status, _Office)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Holder, _Office)
THEN
NOT DB_ARCANA_Kingmaker_Court(_Owner, _Holder, _Office);
RemoveStatus(_Holder, "COURT_HOLDER", _Owner);
RemoveStatus(_Holder, "KINGMAKER_HAND_CROWN", _Owner);
PROC_ARCANA_Kingmaker_Crown(_Owner);

IF
Died(_Holder)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Holder, _Office)
AND
DB_ARCANA_Kingmaker_Office(_Status, _Office)
THEN
RemoveStatus(_Holder, _Status, _Owner);

IF
LongRestFinished()
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Holder, _Office)
AND
DB_ARCANA_Kingmaker_Office(_Status, _Office)
THEN
RemoveStatus(_Holder, _Status, _Owner);

IF
LongRestFinished()
AND
DB_ARCANA_Kingmaker_Seats(_Owner, _N)
THEN
NOT DB_ARCANA_Kingmaker_Seats(_Owner, _N);
RemoveStatus(_Owner, "COURT_FULL", _Owner);
//END_REGION

T

# 3. turn start: the Hand is crowned even before anyone is on the Wheel
put('turn start, Hand', "//END_REGION\n\n//REGION Rota Fortunae", <<'T', 1);

IF
TurnStarted(_Owner)
AND
NOT DB_ARCANA_Kingmaker_Counter(_Owner, _)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _, "KINGS_HAND")
THEN
PROC_ARCANA_Kingmaker_Crown(_Owner);
T

# 4. Peripeteia, after Rota Fortunae
put('peripeteia', "//REGION Turn the Spoke - one step for one creature\n", <<'T', 1);
//REGION Peripeteia (level 5) - every creature on the Wheel within 18 m of the Kingmaker to the opposite position, at once
IF
StatusApplied(_Owner, "KINGMAKER_INVERT_TECH", _, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order)
AND
GetDistanceTo(_Owner, _Creature, _Dist)
AND
_Dist <= 18.0
THEN
DB_ARCANA_Kingmaker_Inverting(_Owner, _Creature, _Position, _Side, _Order);

IF
StatusApplied(_Owner, "KINGMAKER_INVERT_TECH", _, _)
AND
DB_ARCANA_Kingmaker_Inverting(_Owner, _Creature, _Position, _Side, _Order)
AND
DB_ARCANA_Kingmaker_Opposite(_Position, _NewPosition)
AND
DB_ARCANA_Kingmaker_PositionStatus(_Position, _OldStatus)
AND
DB_ARCANA_Kingmaker_PositionStatus(_NewPosition, _NewStatus)
THEN
NOT DB_ARCANA_Kingmaker_Inverting(_Owner, _Creature, _Position, _Side, _Order);
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order);
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _NewPosition, _Side, _Order);
RemoveStatus(_Creature, _OldStatus, _Owner);
ApplyStatus(_Creature, _NewStatus, -1.0, 1, _Owner);
PROC_ARCANA_Kingmaker_Fell(_Owner, _Creature, _NewPosition, _Side);

IF
StatusApplied(_Owner, "KINGMAKER_INVERT_TECH", _, _)
AND
DB_ARCANA_Kingmaker_Counter(_Owner, _)
THEN
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

T

# 5. Master of Healing, after Atropos' Cut
put('master of healing', "//REGION The crown - the ally Reigning longest", <<'T', 1);
//REGION Master of Healing - healing an ally on the Wheel that is Fallen or Rising moves it one step (toward Reigning)
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_HEAL_STEP_TECH", (CHARACTER)_Healer, _)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Healer, "MASTER_OF_HEALING")
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, 1, _)
AND
DB_ARCANA_Kingmaker_HealStep(_Position)
THEN
PROC_ARCANA_Kingmaker_Move(_Owner, _Creature);
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

T

# 6. the crown: the Hand loses it first (before the King is chosen) and takes it last, when no ally Reigns
put('crown, Hand off', "PROC\nPROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)\nAND\nDB_ARCANA_Kingmaker_Best(_Owner, _Creature, _Order)\nTHEN\nNOT DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _Order);\n", <<'T', 1);
PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Hand, "KINGS_HAND")
THEN
RemoveStatus(_Hand, "KINGMAKER_KING", _Owner);
RemoveStatus(_Hand, "KINGMAKER_HAND_CROWN", _Owner);

T
put('crown, Hand on', "NOT DB_ARCANA_Kingmaker_Best(_Owner, _Creature, _)\nTHEN\nApplyStatus(_Creature, \"KINGMAKER_REGENT\", -1.0, 1, _Owner);\n", <<'T');

// King's Hand: while no ally Reigns, the Hand wears the crown and crits on 19-20
PROC
PROC_ARCANA_Kingmaker_Crown((GUIDSTRING)_Owner)
AND
NOT DB_ARCANA_Kingmaker_Best(_Owner, _, _)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Hand, "KINGS_HAND")
AND
IsDead(_Hand, 0)
AND
IsInCombat(_Hand, 1)
THEN
ApplyStatus(_Hand, "KINGMAKER_KING", -1.0, 1, _Owner);
ApplyStatus(_Hand, "KINGMAKER_HAND_CROWN", -1.0, 1, _Owner);
T

# 7. the end of combat: the Hand's crown goes
put('combat end, Hand', "IF\nCombatEnded(_)\nAND\nDB_ARCANA_Kingmaker_Enemies(_Owner, _N)\nTHEN\nNOT DB_ARCANA_Kingmaker_Enemies(_Owner, _N);\n", <<'T');

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Hand, "KINGS_HAND")
THEN
RemoveStatus(_Hand, "KINGMAKER_KING", _Owner);
RemoveStatus(_Hand, "KINGMAKER_HAND_CROWN", _Owner);
T

die "nothing built\n" if $bad;
my $out = dirname(__FILE__) . '/32_goal_stage3.txt';
open my $o, '>:raw', $out or die; print $o $s; close $o; print "built $out\n";
if ($apply) {
    my $w = $s; $w =~ s/\n/\r\n/g if $crlf;
    open my $g, '>:raw', $GOAL or die "$GOAL: $!"; print $g $w; close $g; print "written into the game\n" }
