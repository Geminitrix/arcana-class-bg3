use strict; use warnings;
# ARC-0026 WB63: the PC deck's Lua tests after Gale Deflection left the reaction cards and The Calm became the
# Fool's Aspect card. Bytes in, bytes out; every edit must match exactly once.
my $T = 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data/Mods/AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7/ScriptExtender/Lua/Tests';
sub edit { my ($f, @pairs) = @_; open my $h, '<:raw', "$T/$f" or die "$f: $!"; local $/; my $s = <$h>; close $h;
  my $nl = $s =~ /\r\n/ ? "\r\n" : "\n";
  while (my ($a, $b) = splice @pairs, 0, 2) { $a =~ s/\n/$nl/g; $b =~ s/\n/$nl/g; my $c = () = $s =~ /\Q$a\E/g;
    die "$f: $c matches\n  $a\n" unless $c == 1; $s =~ s/\Q$a\E/$b/ }
  open my $o, '>:raw', "$T/$f" or die; print $o $s; close $o; print "ok $f\n" }

edit('CardDBTest.lua',
  qq{            T.eq(n, 3, "three reaction cards: Gale Deflection, Which One? and Compassion")\n            T.eq(D.reactions["Shout_Arcana_Card_Passive_GaleDeflection"].perRound, 3)\n},
  qq{            T.eq(n, 2, "two reaction cards: Which One? and Compassion")\n            -- WB63 (2026-10-23): Gale Deflection is a normal card now, one copy; its reaction refills once a turn\n            T.eq(D.reactions["Shout_Arcana_Card_Passive_GaleDeflection"], nil, "Gale Deflection is no reaction card")\n            T.eq(D.Has("Shout_Arcana_Card_Passive_GaleDeflection", "Unique"), true, "Gale Deflection is Unique")\n});
edit('KeywordsTest.lua',
  qq{                ASPECT_AWAKENED_FOOL = "Rush_Arcana_Created_Aspect_LeapOfFaith",\n},
  qq{                ASPECT_AWAKENED_FOOL = "Shout_Arcana_Created_TheCalm",\n});
edit('ReactionsTest.lua',
  qq{local GALE = "Shout_Arcana_Card_Passive_GaleDeflection"\nlocal world, savedIo\n},
  qq{-- Gale Deflection left the reaction cards on 2026-10-23 (WB63: one use a turn, a normal Unique card). No
-- reaction card goes three times a round any more, but the stack rules stay under test: this fixture puts the old
-- three-a-round entry back for the length of the suite.
local GALE = "Shout_Arcana_Card_Passive_GaleDeflection"
local D = Req("Server/Cards/CardDB.lua")
local FIXTURE = {
    ready = "GALE_DEFLECTION_READY", resource = "ArcanaReactGaleDeflection",
    used = "GALE_DEFLECTION_USED_TECH", perRound = 3,
}
local world, savedIo, savedReaction, savedUsed
},
  qq{    before = function()\n        savedIo = R.io\n},
  qq{    before = function()\n        savedReaction, savedUsed = D.reactions[GALE], D.reactionByUsed[FIXTURE.used]\n        D.reactions[GALE], D.reactionByUsed[FIXTURE.used] = FIXTURE, GALE\n        savedIo = R.io\n},
  qq{    after = function() R.io = savedIo end,\n},
  qq{    after = function()\n        R.io = savedIo\n        D.reactions[GALE], D.reactionByUsed[FIXTURE.used] = savedReaction, savedUsed\n    end,\n});
