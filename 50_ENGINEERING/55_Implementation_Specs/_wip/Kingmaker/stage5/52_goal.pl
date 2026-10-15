#!/usr/bin/perl
# ARC-0008 stage 5: builds the stage-5 ARCANA_Kingmaker_Wheel goal from the stage-4 one (the game's file), by insertions at
# exact anchors; every anchor must match once. Writes 52_goal_stage5.txt next to this script (LF); --apply also writes it
# into the game with the game file's line ending.
#   perl 52_goal.pl            build and report
#   perl 52_goal.pl --apply    also write it into the game ([fechado] ARC-0008)
use strict; use warnings;
use File::Basename qw(dirname);
my $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
my $GOAL = "$G/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/Story/RawFiles/Goals/ARCANA_Kingmaker_Wheel.txt";
my $apply = grep { $_ eq '--apply' } @ARGV;
open my $h, '<:raw', $GOAL or die "$GOAL: $!"; local $/; my $raw = <$h>; close $h;
my $crlf = $raw =~ /\r\n/; (my $s = $raw) =~ s/\r\n/\n/g;
if ($s =~ /PROC_ARCANA_Kingmaker_Succession/) { print "already stage 5\n"; exit 0 }
die "the goal isn't stage 4\n" unless $s =~ /KINGMAKER_USURP_TECH/;
my $bad = 0;
sub put { my ($what, $anchor, $text, $before) = @_;
    my $n = () = $s =~ /\Q$anchor\E/g;
    if ($n != 1) { print "ANCHOR ($n): $what\n"; $bad++; return }
    $s =~ s/\Q$anchor\E/$before ? "$text$anchor" : "$anchor$text"/e; print "ok     $what\n" }

# 0. header
put('header', "// attacks the King takes one more step at the next turn, never past Fallen nor up to Reigning), the Master of Secrets.\n",
"// Stage 5: Succession (a dead enemy's position passes to the nearest enemy off the Wheel within 9 m of the body), the
// Master of Ships (a Crossing also pays within 9 m of the Ships), the Master of Coin (once per Long Rest, a spell slot back).
// Wheel of Ixion binds through KINGMAKER_BIND_ENEMY_TECH like Dethrone.\n");

# 1. tables
put('tables', "DB_ARCANA_Kingmaker_Office(\"COURT_MASTER_OF_SECRETS\", \"MASTER_OF_SECRETS\");\n", <<'T');
DB_ARCANA_Kingmaker_Office("COURT_MASTER_OF_COIN", "MASTER_OF_COIN");
DB_ARCANA_Kingmaker_Office("COURT_MASTER_OF_SHIPS", "MASTER_OF_SHIPS");
T

# 2. Master of Coin: once per Long Rest; the spent mark goes with the Long Rest (before the seats are cleared)
put('court, coin', "IF\nLongRestFinished()\nAND\nDB_ARCANA_Kingmaker_Seats(_Owner, _N)\nTHEN\n", <<'T', 1);
IF
LongRestFinished()
AND
DB_ARCANA_Kingmaker_Seats(_Owner, _N)
THEN
RemoveStatus(_Owner, "KINGMAKER_COIN_SPENT", _Owner);

T
put('court, coin rule', "//REGION Bind - Coronation", <<'T', 1);
//REGION Master of Coin (level 9) - once per Long Rest, its hit on a Fallen enemy gives the Kingmaker a spell slot back
IF
StatusApplied((CHARACTER)_Enemy, "KINGMAKER_COIN_TECH", (CHARACTER)_Holder, _)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Holder, "MASTER_OF_COIN")
AND
HasActiveStatus(_Owner, "KINGMAKER_COIN_SPENT", 0)
THEN
ApplyStatus(_Owner, "KINGMAKER_COIN_SPENT", -1.0, 1, _Owner);
ApplyStatus(_Owner, "KINGMAKER_COIN_RESTORE", 0.0, 1, _Owner);
//END_REGION

T

# 3. Master of Ships: a second source of the Crossing, checked with the Reigning allies
put('settle, ships', "PROC\nPROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)\nAND\nDB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy)\nTHEN\nNOT DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy);\n", <<'T', 1);
// Master of Ships (level 9): within 9 m of the Ships, as if a Reigning ally stood there
PROC
PROC_ARCANA_Kingmaker_Settle((GUIDSTRING)_Owner)
AND
DB_ARCANA_Kingmaker_NewFallen(_Owner, _Enemy)
AND
HasPassive(_Owner, "Arcana_Passive_TheCrossing", 1)
AND
NOT DB_ARCANA_Kingmaker_Crossed(_Owner, _Enemy)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Enemy, "FALLEN", 0, _)
AND
DB_ARCANA_Kingmaker_Court(_Owner, _Ships, "MASTER_OF_SHIPS")
AND
IsDead(_Ships, 0)
AND
GetDistanceTo(_Enemy, _Ships, _Dist)
AND
_Dist <= 9.0
THEN
DB_ARCANA_Kingmaker_CrossPending(_Owner, _Enemy);

T

# 4. Succession, before the death rule that takes the dead off the ledger
put('succession', "//REGION Leaving the Wheel - death and the end of combat\n", <<'T', 1);
//REGION Succession (level 9) - the nearest enemy off the Wheel within 9 m of the body takes the dead enemy's position
IF
Died(_Dead)
AND
DB_ARCANA_Kingmaker_OnWheel(_Owner, _Dead, _Position, 0, _)
AND
HasPassive(_Owner, "Arcana_Passive_Succession", 1)
THEN
PROC_ARCANA_Kingmaker_Succession((CHARACTER)_Owner, _Dead, _Position);

PROC
PROC_ARCANA_Kingmaker_Succession((CHARACTER)_Owner, (CHARACTER)_Dead, (STRING)_Position)
AND
DB_ARCANA_Kingmaker_Heir(_Owner, _Candidate, _Dist)
THEN
NOT DB_ARCANA_Kingmaker_Heir(_Owner, _Candidate, _Dist);

// candidates: the owner's combat (the Awakening roster), enemies of the owner, alive, on no Wheel, within 9 m of the body
PROC
PROC_ARCANA_Kingmaker_Succession((CHARACTER)_Owner, (CHARACTER)_Dead, (STRING)_Position)
AND
DB_ARCANA_Aspect_InCombat(_Owner, _Combat)
AND
DB_ARCANA_Aspect_InCombat(_Candidate, _Combat)
AND
_Candidate != _Dead
AND
IsEnemy(_Owner, _Candidate, 1)
AND
IsDead(_Candidate, 0)
AND
NOT DB_ARCANA_Kingmaker_OnWheel(_, _Candidate, _, _, _)
AND
GetDistanceTo(_Dead, _Candidate, _Dist)
AND
_Dist <= 9.0
AND
NOT DB_ARCANA_Kingmaker_Heir(_Owner, _, _)
THEN
DB_ARCANA_Kingmaker_Heir(_Owner, _Candidate, _Dist);

PROC
PROC_ARCANA_Kingmaker_Succession((CHARACTER)_Owner, (CHARACTER)_Dead, (STRING)_Position)
AND
DB_ARCANA_Aspect_InCombat(_Owner, _Combat)
AND
DB_ARCANA_Aspect_InCombat(_Candidate, _Combat)
AND
_Candidate != _Dead
AND
IsEnemy(_Owner, _Candidate, 1)
AND
IsDead(_Candidate, 0)
AND
NOT DB_ARCANA_Kingmaker_OnWheel(_, _Candidate, _, _, _)
AND
GetDistanceTo(_Dead, _Candidate, _Dist)
AND
_Dist <= 9.0
AND
DB_ARCANA_Kingmaker_Heir(_Owner, _Best, _BestDist)
AND
_Dist < _BestDist
THEN
NOT DB_ARCANA_Kingmaker_Heir(_Owner, _Best, _BestDist);
DB_ARCANA_Kingmaker_Heir(_Owner, _Candidate, _Dist);

PROC
PROC_ARCANA_Kingmaker_Succession((CHARACTER)_Owner, (CHARACTER)_Dead, (STRING)_Position)
AND
DB_ARCANA_Kingmaker_Heir(_Owner, _Heir, _Dist)
THEN
NOT DB_ARCANA_Kingmaker_Heir(_Owner, _Heir, _Dist);
PROC_ARCANA_Kingmaker_Bind(_Owner, _Heir, _Position, 0);
//END_REGION

T

die "nothing built\n" if $bad;
my $out = dirname(__FILE__) . '/52_goal_stage5.txt';
open my $o, '>:raw', $out or die; print $o $s; close $o; print "built $out\n";
if ($apply) {
    my $w = $s; $w =~ s/\n/\r\n/g if $crlf;
    open my $g, '>:raw', $GOAL or die "$GOAL: $!"; print $g $w; close $g; print "written into the game\n" }
