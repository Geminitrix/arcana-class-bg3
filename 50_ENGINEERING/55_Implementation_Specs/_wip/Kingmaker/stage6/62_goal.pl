#!/usr/bin/perl
# ARC-0008 stage 6: builds the stage-6 ARCANA_Kingmaker_Wheel goal from the stage-5 one (the game's file), by insertions at
# exact anchors and two exact rule replacements (the turn and the Master of Laws' step wait while the Wheel is stopped,
# SP112); every anchor must match once. Writes 62_goal_stage6.txt next to this script (LF); --apply also writes it into
# the game with the game file's line ending.
#   perl 62_goal.pl            build and report
#   perl 62_goal.pl --apply    also write it into the game ([fechado] ARC-0008)
use strict; use warnings;
use File::Basename qw(dirname);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $GOAL = "$G/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Story/RawFiles/Goals/ARCANA_Kingmaker_Wheel.txt";
my $apply = grep { $_ eq '--apply' } @ARGV;
open my $h, '<:raw', $GOAL or die "$GOAL: $!"; local $/; my $raw = <$h>; close $h;
my $crlf = $raw =~ /\r\n/; (my $s = $raw) =~ s/\r\n/\n/g;
if ($s =~ /KINGMAKER_STOP_TECH/) { print "already stage 6\n"; exit 0 }
die "the goal isn't stage 5\n" unless $s =~ /PROC_ARCANA_Kingmaker_Succession/;
my $bad = 0;
sub put { my ($what, $anchor, $text, $before) = @_;
    my $n = () = $s =~ /\Q$anchor\E/g;
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s =~ s/\Q$anchor\E/$before ? "$text$anchor" : "$anchor$text"/e; print "ok     $what\n" }
sub swap { my ($what, $old, $new) = @_;
    my $n = () = $s =~ /\Q$old\E/g;
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s =~ s/\Q$old\E/$new/; print "ok     $what (replaced)\n" }

# 0. header
put('header', "// Wheel of Ixion binds through KINGMAKER_BIND_ENEMY_TECH like Dethrone.\n",
"// Stage 6: The Wheel Stops (2 turns: the Wheel doesn't turn and every Fallen enemy near a Reigning ally crosses at the
// turn start; the Kingmaker's own cards still move, SP112), Fortune's Reach (level 12: the Crossing needs no distance),
// Tier III (an ally never enters Fallen: it stays Falling one more turn), Foreseen (the reaction pushes a Reigning or
// Falling attacker one step before its blow). Two Kingmakers keep separate Wheels (SP113).\n");

# 1. tables
put('tables', "DB_ARCANA_Kingmaker_LawStep(\"FALLING\");\n", <<'T');
DB_ARCANA_Kingmaker_ForeseenStep("REIGNING");
DB_ARCANA_Kingmaker_ForeseenStep("FALLING");
T
put('tables clear', "PROC\nPROC_ARCANA_Kingmaker_Init()\nTHEN\n", <<'T', 1);
PROC
PROC_ARCANA_Kingmaker_Init()
AND
DB_ARCANA_Kingmaker_ForeseenStep(_Position)
THEN
NOT DB_ARCANA_Kingmaker_ForeseenStep(_Position);

T

# 2. a creature bound while the Wheel is stopped is held too
put('bind, stopped', "//END_REGION\n\n//REGION Move one step", <<'T', 1);

PROC
PROC_ARCANA_Kingmaker_Bind((GUIDSTRING)_Owner, (CHARACTER)_Creature, (STRING)_Position, (INTEGER)_Side)
AND
DB_ARCANA_Kingmaker_Stopped(_Owner, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
ApplyStatus(_Creature, "KINGMAKER_WHEEL_STOPPED", -1.0, 1, _Owner);
T

# 3. Tier III: an ally held at Falling goes on to Rising (it never touches Fallen)
put('move, tier III', "PROC\nPROC_ARCANA_Kingmaker_Move((GUIDSTRING)_Owner, (CHARACTER)_Creature)\nAND\nDB_ARCANA_Kingmaker_Moving(", <<'T', 1);
// Tier III (Aspect of Anticipation): an ally that already spent one more turn Falling goes on to Rising
PROC
PROC_ARCANA_Kingmaker_Move((GUIDSTRING)_Owner, (CHARACTER)_Creature)
AND
DB_ARCANA_Kingmaker_Moving(_Owner, _Creature, "FALLING", 1, _Order)
AND
DB_ARCANA_Kingmaker_Held(_Owner, _Creature)
THEN
NOT DB_ARCANA_Kingmaker_Moving(_Owner, _Creature, "FALLING", 1, _Order);
NOT DB_ARCANA_Kingmaker_Held(_Owner, _Creature);
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, "FALLING", 1, _Order);
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, "RISING", 1, _Order);
RemoveStatus(_Creature, "KINGMAKER_FALLING", _Owner);
ApplyStatus(_Creature, "KINGMAKER_RISING", -1.0, 1, _Owner);

T
put('fell, tier III', "THEN\nDB_ARCANA_Kingmaker_NewReigning(_Owner, _Creature);\n", <<'T');

// Tier III: an ally that would enter Fallen (any cause) stays Falling one more turn instead
PROC
PROC_ARCANA_Kingmaker_Fell((GUIDSTRING)_Owner, (CHARACTER)_Creature, (STRING)_Position, (INTEGER)_Side)
AND
_Position == "FALLEN"
AND
_Side == 1
AND
HasActiveStatus(_Owner, "ASPECT_AWAKENED_WHEEL_III", 1)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, "FALLEN", 1, _Order)
THEN
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, "FALLEN", 1, _Order);
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, "FALLING", 1, _Order);
RemoveStatus(_Creature, "KINGMAKER_FALLEN", _Owner);
ApplyStatus(_Creature, "KINGMAKER_FALLING", -1.0, 1, _Owner);
DB_ARCANA_Kingmaker_Held(_Owner, _Creature);
T

# 4. turn start: no turn and no Laws step while stopped; the stopped Wheel presses; the stop counts down
swap('turn start, pending',
"IF\nTurnStarted(_Owner)\nAND\nDB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)\nTHEN\nDB_ARCANA_Kingmaker_Pending(_Owner, _Creature);\n",
"IF\nTurnStarted(_Owner)\nAND\nNOT DB_ARCANA_Kingmaker_Stopped(_Owner, _)\nAND\nDB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)\nTHEN\nDB_ARCANA_Kingmaker_Pending(_Owner, _Creature);\n");
swap('turn start, Laws',
"IF\nTurnStarted(_Owner)\nAND\nDB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy)\nAND\nDB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, _Position, 0, _)\n",
"IF\nTurnStarted(_Owner)\nAND\nNOT DB_ARCANA_Kingmaker_Stopped(_Owner, _)\nAND\nDB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy)\nAND\nDB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, _Position, 0, _)\n");
put('turn start, press', "IF\nTurnStarted(_Owner)\nAND\nDB_ARCANA_Kingmaker_Counter(_Owner, _)\nTHEN\nPROC_ARCANA_Kingmaker_Crown(_Owner);\nPROC_ARCANA_Kingmaker_Settle(_Owner);\n", <<'T', 1);
// The Wheel Stops: every Fallen enemy on the stopped Wheel is checked for its Crossing again (once per round still holds)
IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_Stopped(_Owner, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, "FALLEN", 0, _)
THEN
DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy);

T
put('turn start, countdown', "IF\nTurnStarted(_Owner)\nAND\nDB_ARCANA_Kingmaker_Counter(_Owner, _)\nTHEN\nPROC_ARCANA_Kingmaker_Crown(_Owner);\nPROC_ARCANA_Kingmaker_Settle(_Owner);\n", <<'T');

IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_Stopped(_Owner, _Turns)
AND
IntegerSubtract(_Turns, 1, _Left)
THEN
NOT DB_ARCANA_Kingmaker_Stopped(_Owner, _Turns);
PROC_ARCANA_Kingmaker_StopTick(_Owner, _Left);

PROC
PROC_ARCANA_Kingmaker_StopTick((GUIDSTRING)_Owner, (INTEGER)_Left)
AND
_Left > 0
THEN
DB_ARCANA_Kingmaker_Stopped(_Owner, _Left);

PROC
PROC_ARCANA_Kingmaker_StopTick((GUIDSTRING)_Owner, (INTEGER)_Left)
AND
_Left < 1
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
RemoveStatus(_Creature, "KINGMAKER_WHEEL_STOPPED", _Owner);
T

# 5. The Wheel Stops and Foreseen, before Turn the Spoke
put('stops, foreseen', "//REGION Turn the Spoke - one step for one creature\n", <<'T', 1);
//REGION The Wheel Stops (level 11) - the Wheel doesn't turn at the owner's next 2 turn starts (SPL_Kingmaker_TheWheelStops)
IF
StatusApplied(_Owner, "KINGMAKER_STOP_TECH", _, _)
AND
DB_ARCANA_Kingmaker_Stopped(_Owner, _Turns)
THEN
NOT DB_ARCANA_Kingmaker_Stopped(_Owner, _Turns);

IF
StatusApplied(_Owner, "KINGMAKER_STOP_TECH", _, _)
THEN
DB_ARCANA_Kingmaker_Stopped(_Owner, 2);

IF
StatusApplied(_Owner, "KINGMAKER_STOP_TECH", _, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _, _, _)
THEN
ApplyStatus(_Creature, "KINGMAKER_WHEEL_STOPPED", -1.0, 1, _Owner);
//END_REGION

//REGION Foreseen (Tier III) - a Reigning or Falling attacker on the Wheel takes one step before its blow
IF
StatusApplied((CHARACTER)_Enemy, "KINGMAKER_FORESEEN_TECH", _Owner, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, _Position, 0, _)
AND
DB_ARCANA_Kingmaker_ForeseenStep(_Position)
THEN
PROC_ARCANA_Kingmaker_Move(_Owner, _Enemy);
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

T

# 6. Settle: Fortune's Reach (level 12) - any Reigning ally on the Wheel, at any distance
put('settle, reach', "// Master of Ships (level 9): within 9 m of the Ships, as if a Reigning ally stood there\n", <<'T', 1);
// Fortune's Reach (level 12): the Crossing needs no distance
PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy)
AND
HasPassive(_Owner, "Arcana_Passive_TheCrossing", 1)
AND
HasPassive(_Owner, "Arcana_Passive_FortunesReach", 1)
AND
NOT DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, "FALLEN", 0, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Ally, "REIGNING", 1, _)
THEN
DB_ARCANA_Kingmaker_CrossPending(_Owner, _Enemy);

T

# 7. Atropos' Cut: the stop and the hold go with the creature
put('cut, cleanup', "RemoveStatus(_Creature, \"KINGMAKER_REGENT\", _Owner);\nPROC_ARCANA_Kingmaker_Cut(", <<'T', 1);
RemoveStatus(_Creature, "KINGMAKER_WHEEL_STOPPED", _Owner);
NOT DB_ARCANA_Kingmaker_Held(_Owner, _Creature);
T

# 8. death and the end of combat
put('combat end', "IF\nCombatEnded(_)\nAND\nDB_ARCANA_Kingmaker_NewReigning(_Owner, _Enemy)\nTHEN\nNOT DB_ARCANA_Kingmaker_NewReigning(_Owner, _Enemy);\n", <<'T');

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_Stopped(_Owner, _Turns)
THEN
NOT DB_ARCANA_Kingmaker_Stopped(_Owner, _Turns);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_Held(_Owner, _Creature)
THEN
NOT DB_ARCANA_Kingmaker_Held(_Owner, _Creature);

IF
Died(_Creature)
AND
DB_ARCANA_Kingmaker_Held(_Owner, _Creature)
THEN
NOT DB_ARCANA_Kingmaker_Held(_Owner, _Creature);
T

die "nothing built\n" if $bad;
my $out = dirname(__FILE__) . '/62_goal_stage6.txt';
open my $o, '>:raw', $out or die; print $o $s; close $o; print "built $out\n";
if ($apply) {
    my $w = $s; $w =~ s/\n/\r\n/g if $crlf;
    open my $g, '>:raw', $GOAL or die "$GOAL: $!"; print $g $w; close $g; print "written into the game\n" }
