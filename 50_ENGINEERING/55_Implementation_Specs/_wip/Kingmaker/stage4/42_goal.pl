#!/usr/bin/perl
# ARC-0008 stage 4: builds the stage-4 ARCANA_Kingmaker_Wheel goal from the stage-3 one (the game's file), by insertions at
# exact anchors; every anchor must match once. Writes 42_goal_stage4.txt next to this script (LF); --apply also writes it
# into the game with the game file's line ending.
#   perl 42_goal.pl            build and report
#   perl 42_goal.pl --apply    also write it into the game ([fechado] ARC-0008)
use strict; use warnings;
use File::Basename qw(dirname);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $GOAL = "$G/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Story/RawFiles/Goals/ARCANA_Kingmaker_Wheel.txt";
my $apply = grep { $_ eq '--apply' } @ARGV;
open my $h, '<:raw', $GOAL or die "$GOAL: $!"; local $/; my $raw = <$h>; close $h;
my $crlf = $raw =~ /\r\n/; (my $s = $raw) =~ s/\r\n/\n/g;
if ($s =~ /KINGMAKER_USURP_TECH/) { print "already stage 4\n"; exit 0 }
die "the goal isn't stage 3\n" unless $s =~ /KINGMAKER_INVERT_TECH/;
my $bad = 0;
sub put { my ($what, $anchor, $text, $before) = @_;
    my $n = () = $s =~ /\Q$anchor\E/g;
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s =~ s/\Q$anchor\E/$before ? "$text$anchor" : "$anchor$text"/e; print "ok     $what\n" }

# 0. header
put('header', "// next Long Rest; the King's Hand wears the crown while no ally Reigns; the Master of Healing lifts the healed).\n",
"// Stage 4: Hubris (an enemy entering Reigning; its next Crossing deals one more die), Nemesis (Tier II: that Crossing drops
// the Falling enemies within 3 m to Fallen), Usurp (an ally and an enemy trade places), the Master of Laws (an enemy that
// attacks the King takes one more step at the next turn, never past Fallen nor up to Reigning), the Master of Secrets.\n");

# 1. tables
put('tables', "DB_ARCANA_Kingmaker_HealStep(\"RISING\");\n", <<'T');
DB_ARCANA_Kingmaker_Office("COURT_MASTER_OF_LAWS", "MASTER_OF_LAWS");
DB_ARCANA_Kingmaker_Office("COURT_MASTER_OF_SECRETS", "MASTER_OF_SECRETS");
DB_ARCANA_Kingmaker_LawStep("REIGNING");
DB_ARCANA_Kingmaker_LawStep("FALLING");
T
put('tables clear', "PROC\nPROC_ARCANA_Kingmaker_Init()\nTHEN\n", <<'T', 1);
PROC
PROC_ARCANA_Kingmaker_Init()
AND
DB_ARCANA_Kingmaker_LawStep(_Position)
THEN
NOT DB_ARCANA_Kingmaker_LawStep(_Position);

T

# 2. an enemy entering Reigning is noted, for Hubris (granted in Settle, if it still Reigns after every step)
put('fell, reigning', "THEN\nDB_ARCANA_Kingmaker_NewFallen(_Owner, _Creature);\n", <<'T');

PROC
PROC_ARCANA_Kingmaker_Fell((GUIDSTRING)_Owner, (CHARACTER)_Creature, (STRING)_Position, (INTEGER)_Side)
AND
_Position == "REIGNING"
AND
_Side == 0
THEN
DB_ARCANA_Kingmaker_NewReigning(_Owner, _Creature);
T

# 3. turn start: the Master of Laws' extra step, after every creature moved and before the crown
put('turn start, Master of Laws', "IF\nTurnStarted(_Owner)\nAND\nDB_ARCANA_Kingmaker_Counter(_Owner, _)\nTHEN\nPROC_ARCANA_Kingmaker_Crown(_Owner);\n", <<'T', 1);
// Master of Laws: an enemy that attacked the King and now Reigns (came from Rising) or Falls (came from Reigning) takes one
// more step - it skips its reign, or drops to Fallen; from Falling or Fallen nothing more
IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, _Position, 0, _)
AND
DB_ARCANA_Kingmaker_LawStep(_Position)
THEN
DB_ARCANA_Kingmaker_LawPending(_Owner, _Enemy);

IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_LawPending(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_LawPending(_Owner, _Enemy);
PROC_ARCANA_Kingmaker_Move(_Owner, _Enemy);

IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy);

IF
TurnStarted(_Owner)
AND
DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _Creature, _Position, _Side, _Order)
THEN
NOT DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _Creature, _Position, _Side, _Order);

T

# 4. Usurp and the Master of Laws' sentence, after Peripeteia
put('usurp, laws', "//REGION Turn the Spoke - one step for one creature\n", <<'T', 1);
//REGION Usurp (level 7) - an ally and an enemy on the Wheel trade positions (two targets: the first waits for the second)
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_USURP_TECH", _Owner, _)
AND
NOT DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _, _, _, _)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order)
THEN
DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _Creature, _Position, _Side, _Order);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_USURP_TECH", _Owner, _)
AND
DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _First, _FirstPosition, _FirstSide, _FirstOrder)
AND
_First != _Creature
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Creature, _Position, _Side, _Order)
AND
_Side != _FirstSide
THEN
DB_ARCANA_Kingmaker_Usurping(_Owner, _First, _FirstPosition, _FirstSide, _FirstOrder, _Creature, _Position, _Side, _Order);

// the second target always closes the pair (two allies or two enemies don't trade)
IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_USURP_TECH", _Owner, _)
AND
DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _First, _FirstPosition, _FirstSide, _FirstOrder)
AND
_First != _Creature
THEN
NOT DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _First, _FirstPosition, _FirstSide, _FirstOrder);

IF
StatusApplied((CHARACTER)_Creature, "KINGMAKER_USURP_TECH", _Owner, _)
AND
DB_ARCANA_Kingmaker_Usurping(_Owner, _A, _PositionA, _SideA, _OrderA, _B, _PositionB, _SideB, _OrderB)
AND
DB_ARCANA_Kingmaker_PositionStatus(_PositionA, _StatusA)
AND
DB_ARCANA_Kingmaker_PositionStatus(_PositionB, _StatusB)
THEN
NOT DB_ARCANA_Kingmaker_Usurping(_Owner, _A, _PositionA, _SideA, _OrderA, _B, _PositionB, _SideB, _OrderB);
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _A, _PositionA, _SideA, _OrderA);
NOT DB_ARCANA_Kingmaker_OnWheel(_Owner, _B, _PositionB, _SideB, _OrderB);
DB_ARCANA_Kingmaker_OnWheel(_Owner, _A, _PositionB, _SideA, _OrderA);
DB_ARCANA_Kingmaker_OnWheel(_Owner, _B, _PositionA, _SideB, _OrderB);
RemoveStatus(_A, _StatusA, _Owner);
RemoveStatus(_B, _StatusB, _Owner);
ApplyStatus(_A, _StatusB, -1.0, 1, _Owner);
ApplyStatus(_B, _StatusA, -1.0, 1, _Owner);
PROC_ARCANA_Kingmaker_Fell(_Owner, _A, _PositionB, _SideA);
PROC_ARCANA_Kingmaker_Fell(_Owner, _B, _PositionA, _SideB);
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

//REGION Master of Laws (level 7) - an enemy on the Wheel that attacks the King is sentenced for the next turn of the Wheel
IF
AttackedBy((CHARACTER)_King, (CHARACTER)_Enemy, _, _, _, _, _)
AND
HasActiveStatus(_King, "KINGMAKER_KING", 1)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _, "MASTER_OF_LAWS")
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, _, 0, _)
THEN
DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy);
//END_REGION

T

# 5. Settle: Hubris granted first (to enemies that entered Reigning and still Reign)
put('settle, hubris', "//REGION The Crossing (level 3) - after every change; once per enemy per round, however many allies Reign near it\n", <<'T');
// Hubris (level 7): an enemy that entered Reigning and still Reigns now
PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_NewReigning(_Owner, _Enemy)
AND
HasPassive(_Owner, "Arcana_Passive_Hubris", 1)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, "REIGNING", 0, _)
THEN
ApplyStatus(_Enemy, "KINGMAKER_HUBRIS", -1.0, 1, _Owner);

PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_NewReigning(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_NewReigning(_Owner, _Enemy);

T

# 6. Settle: the Hubris Crossing (before the plain one, which then finds nothing to do for that enemy)
put('settle, hubris crossing', "PROC\nPROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)\nAND\nDB_ARCANA_Kingmaker_CrossPending(_Owner, _Enemy)\nTHEN\n", <<'T', 1);
// an enemy with Hubris: the Crossing deals one more die, the pride is spent, and with Nemesis (Tier II) its Falling
// neighbours within 3 m drop to Fallen
PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_CrossPending(_Owner, _Enemy)
AND
HasActiveStatus(_Enemy, "KINGMAKER_HUBRIS", 1)
THEN
NOT DB_ARCANA_Kingmaker_CrossPending(_Owner, _Enemy);
DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy);
ApplyStatus(_Enemy, "KINGMAKER_CROSSING_HUBRIS_TECH", 0.0, 1, _Owner);
RemoveStatus(_Enemy, "KINGMAKER_HUBRIS", _Owner);
PROC_ARCANA_Kingmaker_CountCrossing((CHARACTER)_Owner);
PROC_ARCANA_Kingmaker_Nemesis((CHARACTER)_Owner, _Enemy);

T

# 7. Nemesis: after the Crossings, the dragged enemies move and the Wheel settles again (only Falling move: the chain ends)
put('nemesis', "//REGION Awakening 10 - Wheel of Fortune", <<'T', 1);
PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
THEN
PROC_ARCANA_Kingmaker_NemesisMove((CHARACTER)_Owner);

PROC
PROC_ARCANA_Kingmaker_Nemesis((CHARACTER)_Owner, (CHARACTER)_Source)
AND
DB_ARCANA_AspectReached(_Owner, 2)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Other, "FALLING", 0, _)
AND
_Other != _Source
AND
GetDistanceTo(_Source, _Other, _Dist)
AND
_Dist <= 3.0
THEN
DB_ARCANA_Kingmaker_NemesisPending(_Owner, _Other);

PROC
PROC_ARCANA_Kingmaker_NemesisMove((CHARACTER)_Owner)
AND
DB_ARCANA_Kingmaker_NemesisPending(_Owner, _Other)
THEN
NOT DB_ARCANA_Kingmaker_NemesisPending(_Owner, _Other);
PROC_ARCANA_Kingmaker_Move(_Owner, _Other);
DB_ARCANA_Kingmaker_NemesisMoved(_Owner);

PROC
PROC_ARCANA_Kingmaker_NemesisMove((CHARACTER)_Owner)
AND
DB_ARCANA_Kingmaker_NemesisMoved(_Owner)
THEN
NOT DB_ARCANA_Kingmaker_NemesisMoved(_Owner);
PROC_ARCANA_Kingmaker_Crown(_Owner);
PROC_ARCANA_Kingmaker_Settle(_Owner);
//END_REGION

T

# 8. the end of combat: the new tables
put('combat end', "IF\nCombatEnded(_)\nAND\nDB_ARCANA_Kingmaker_Enemies(_Owner, _N)\nTHEN\nNOT DB_ARCANA_Kingmaker_Enemies(_Owner, _N);\n", <<'T');

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_Condemned(_Owner, _Enemy);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _Creature, _Position, _Side, _Order)
THEN
NOT DB_ARCANA_Kingmaker_UsurpFirst(_Owner, _Creature, _Position, _Side, _Order);

IF
CombatEnded(_)
AND
DB_ARCANA_Kingmaker_NewReigning(_Owner, _Enemy)
THEN
NOT DB_ARCANA_Kingmaker_NewReigning(_Owner, _Enemy);
T

die "nothing built\n" if $bad;
my $out = dirname(__FILE__) . '/42_goal_stage4.txt';
open my $o, '>:raw', $out or die; print $o $s; close $o; print "built $out\n";
if ($apply) {
    my $w = $s; $w =~ s/\n/\r\n/g if $crlf;
    open my $g, '>:raw', $GOAL or die "$GOAL: $!"; print $g $w; close $g; print "written into the game\n" }
