# ARC-0020 Task 0.5 — inserts the Splinter on Command region into ARCANA_Deceiver_Doubles.txt, before the Task 4 region.
#   perl 32_goal_splinter_command.pl <path to the goal>   (stage 2, game and Toolkit closed; CRLF and ASCII kept; idempotent)
# Checked 2026-10-16 on a copy of the synced goal (51): 18 lines added, nothing else changed.
use strict; use warnings;
my $f = shift or die "goal path\n";
my $region = <<'EOF';
//REGION ARC-0020: Splinter on Command (DV24, DV31, DV32)
// Her card Target_Arcana_Card_Spell_SplinterOnCommand only marks one Double with SPLINTER_COMMAND_TECH. The Double then
// casts its own Splinter now, with the path The Veil Lifts uses (ARCANA_Aspect_Empress.txt): UseSpell, so the two
// CastSpell rules of Task 3 above mark it blameless and retire it after the burst, exactly as a Splinter cast on its
// own turn. A Double that isn't hers, or is already gone, is ignored: the card is spent and nothing happens.
// Probe B1 (SPEC_ARC-0020): the Splinter fires off the Double's turn, even if it already spent its action.
IF
StatusApplied((CHARACTER)_Double, "SPLINTER_COMMAND_TECH", (CHARACTER)_Owner, _)
AND
DB_ARCANA_Double(_Double, _Owner, _)
AND
NOT DB_ARCANA_DoubleGone(_Double, _Owner)
AND
IsDead(_Double, 0)
THEN
UseSpell(_Double, "Shout_Deceiver_Double_Shatter", _Double, _Double, 1);
//END_REGION

EOF
$region =~ s/\n/\r\n/g;
open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; close $h;
exit 0 if $s =~ /REGION ARC-0020: Splinter on Command/;   # idempotent
$s =~ s{(//REGION Task 4: a Double that is summoned somewhere else goes Home)}{$region$1} or die "anchor not found\n";
die "non-ASCII\n" if $s =~ /[^\x00-\x7F]/;
open $h, '>:raw', $f or die $!; print $h $s; close $h; print "inserted\n";
