# ARC-0035: builds goals/ from before/ (the game's copies of 2026-11-25). Idempotent: always starts from before/.
#   perl build.pl
# Part 1 (the 6 errors, no code change): CRLF everywhere; the Fool's header restored (text of b071443, the Owner's
# rename PROC_ARCANA_Fool_Aspect_Init kept); a blank line after the INITSECTION of the Aeolus' Bag goal.
# Part 2 (the 23 warnings): every DB shared between Kingmaker goals pinned once, in its owner goal; every event that
# binds the Kingmaker as an uncast GUIDSTRING (TurnStarted, StatusApplied's object or causee) casts it to CHARACTER, so
# the CHARACTER pins never meet a GUIDSTRING (57.05 section 5: a mismatch makes the Story Editor skip the rule).
use strict; use warnings;
my $hdr = do { local $/; open my $h, '<', 'fool_header.txt' or die; <$h> };
my $Z = '(CHARACTER)NULL_00000000-0000-0000-0000-000000000000';
my %pins = (
  ARCANA_Kingmaker_Wheel => [
    ['OnWheel', "$Z, $Z, \"\", 0, 0"], ['Counter', "$Z, 0"], ['Moving', "$Z, $Z, \"\", 0, 0"], ['Pending', "$Z, $Z"],
    ['Enemies', "$Z, 0"], ['Held', "$Z, $Z"], ['ReignTime', "$Z, $Z, 0"], ['Stopped', "$Z, 0"],
    ['Next', '"", ""'], ['Opposite', '"", ""'], ['PositionStatus', '"", ""'], ['CrossStatus', '0, ""'],
    ['NewFallen', "$Z, $Z"], ['NewRuler', "$Z, $Z"], ['NewReigning', "$Z, $Z"] ],
  ARCANA_Kingmaker_Crossing => [ ['CrossedBy', "$Z, $Z, $Z"], ['CrossSlot', "$Z, $Z, 0"], ['CrossPair', "$Z, $Z, $Z"], ['HubrisSpent', "$Z, $Z"] ],
  ARCANA_Kingmaker_CrownTheKing => [ ['King', "$Z, $Z"], ['Best', "$Z, $Z, 0"] ],
  ARCANA_Kingmaker_KingsCourt => [ ['Court', "$Z, $Z, \"\""], ['Condemned', "$Z, $Z"] ],
  ARCANA_Kingmaker_Usurp => [ ['UsurpFirst', "$Z, $Z, \"\", 0, 0"] ],
);
for my $f (glob 'before/*.txt') {
  (my $g = $f) =~ s{^before/|\.txt$}{}g;
  open my $h, '<:raw', $f or die; local $/; my $s = <$h>; close $h;
  $s =~ s/\r//g;
  if ($g eq 'ARCANA_Aspect_Fool') { $s =~ s/\nKBSECTION\n(?=\/\/REGION)/\nKBSECTION\n$hdr\n\n/ or die "fool header\n" }
  if ($g eq 'ARCANA_Unbound_AeolusBag') { $s =~ s/\n(PROC_ARCANA_Unbound_AeolusBag_Init\(\);)\nKBSECTION\n/\n$1\n\nKBSECTION\n/ or die "bag\n" }
  if (my $p = $pins{$g}) {
    my $lines = join '', map { "DB_ARCANA_Kingmaker_$_->[0]($_->[1]);\nNOT DB_ARCANA_Kingmaker_$_->[0]($_->[1]);\n" } @$p;
    $s =~ s/\nINITSECTION\n/\nINITSECTION\n$lines/ or die "init $g\n";
  }
  if ($g =~ /^ARCANA_Kingmaker_|^ARCANA_Aspect_WheelOfFortune$/) {
    $s =~ s/^TurnStarted\(_Owner\)$/TurnStarted((CHARACTER)_Owner)/mg;
    $s =~ s/^StatusApplied\(_Owner, ("KINGMAKER_[A-Z_]+_TECH"), _, _\)$/StatusApplied((CHARACTER)_Owner, $1, _, _)/mg;
    $s =~ s/^(StatusApplied\(\(CHARACTER\)_\w+, (?:"KINGMAKER_[A-Z_]+_TECH"|_Status), )_Owner, _\)$/$1(CHARACTER)_Owner, _)/mg;
  }
  $s =~ s/\n/\r\n/g;
  open $h, '>:raw', "goals/$g.txt" or die; print $h $s; close $h;
}
print "built\n";
