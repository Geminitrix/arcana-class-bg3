#!/usr/bin/perl
# ARC-0007: Aspect Awakening counts down (spec 50_ENGINEERING/55_Implementation_Specs/SPEC_ARC-0007.md).
#
# Writes to 50_ENGINEERING/55_Implementation_Specs/_wip/ARC-0007/:
#   10_awakening.patch        15 progress statuses (one per Aspect and tier, the text names the next tier) and the
#                             Fool / High Priestess / Star / Death Awakening passives in one shape (same handles).
#                             Temperance's passive is written by gen_emotion_alchemy.pl with the same shape.
#   20_common_display.txt     the countdown block for ARCANA_Aspect_Common.txt (apply_common.pl swaps it in)
#
#   perl gen_awakening_progress.pl            # (re)writes the files; only READS the game
#   perl t/gen_awakening_progress.t           # tests
#
# The goals are read from the live DB_ARCANA_AspectTier rows of ARCANA_Aspect_Common.txt: no number lives here.
package Awake;
use strict; use warnings;
use File::Basename qw(dirname);
use File::Path qw(make_path);
use Cwd qw(abs_path);

our $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
our $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
our $ROOT = abs_path(dirname(__FILE__) . '/../../..');
sub slurp { my $p = shift; open my $h, '<:raw', $p or die "$p: $!"; local $/; my $s = <$h>; close $h; $s =~ s/\r\n/\n/g; $s }

our @ORDER = qw(FOOL EMPRESS TEMPERANCE WHEEL STAR DEATH);
# passive: the tier passives' infix; tiers: their names; left: what the number counts (the status text);
# do: the passive's opening; rule: an extra sentence; goal: the goal in words from the row value
our %A = (
    FOOL => { passive => 'Fool', aspect => 'Curiosity', icon => 'Action_Monk_StepOfTheWind_Dash', mode => 'COUNT',
        tiers => ['Wanderlust', 'Restless Wind', 'Aspect of Curiosity'],
        left => 'Different enemies left to strike this round',
        do => 'Strike different enemies with attacks within a single round',
        rule => 'If fewer enemies stand when your turn begins than a goal asks for, strikes on any enemy count towards that goal instead.',
        goal => sub { "strike $_[0] different enemies in one round" } },
    EMPRESS => { passive => 'Empress', aspect => 'Doubt', icon => 'Spell_Necromancy_BestowCurse', mode => 'COUNT',
        tiers => ['Veiled', 'Two Pillars', 'Aspect of Doubt'],
        left => 'Stacks of Doubt left to apply',
        do => 'Sow <LSTag Type="Status" Tooltip="DOUBT_1">Doubt</LSTag> in your enemies',
        goal => sub { "apply $_[0] stacks of Doubt" } },
    TEMPERANCE => { passive => 'Temperance', aspect => 'Empathy', icon => 'Spell_Enchantment_CalmEmotions', mode => 'COUNT',
        tiers => ['Resonance', 'Harmony', 'Aspect of Empathy'],
        left => 'Reactions left to cause',
        do => 'Cause reactions',
        rule => 'Every feeling you braid, every emotion you intensify and every Catharsis counts.',
        goal => sub { "cause $_[0] reactions" } },
    # ARC-0008 stage 2 (the Kingmaker), 10 - Wheel of Fortune: Crossings (TOOLKIT_ARC-0008_stage2.md)
    WHEEL => { passive => 'WheelOfFortune', aspect => 'Anticipation', icon => 'Spell_Divination_DetectThoughts', mode => 'COUNT',
        tiers => ['Tyche', 'Nemesis', 'Aspect of Anticipation'],
        left => 'Crossings left to cause',
        do => 'Make your enemies fall while your allies reign',
        rule => 'Every Crossing counts, and while only one enemy is on the Wheel each Crossing counts twice.',
        goal => sub { "cause $_[0] Crossings" } },
    STAR => { passive => 'Star', aspect => 'Hope', icon => 'Spell_Evocation_DancingLights', mode => 'HEAL',
        tiers => ['Beacon', 'Sunrise', 'Aspect of Hope'],
        left => 'Hit points left to heal',
        do => 'Heal your allies',
        rule => 'Healing beyond an ally\'s maximum <LSTag Tooltip="HitPoints">hit points</LSTag> doesn\'t count.',
        goal => sub { 'heal hit points equal to ' . ($_[0] / 100) . ' times your level' } },
    DEATH => { passive => 'Death', aspect => 'Sorrow', icon => 'Spell_Conjuration_ArmsOfHadar', mode => 'LOSS',
        tiers => ['Sorrow', 'Mourning', 'Aspect of Sorrow'],
        left => 'Hit points left to lose',
        do => 'Lose <LSTag Tooltip="HitPoints">hit points</LSTag>',
        rule => 'Healing doesn\'t undo the loss.',
        goal => sub { 'lose ' . ($_[0] / 10) . '% of your hit point maximum' } },
);
our @ROMAN = qw(I II III);

sub common_path { "$G/Mods/$M/Story/RawFiles/Goals/ARCANA_Aspect_Common.txt" }
sub goals {
    my $s = slurp(common_path());
    my %g;
    $g{$1}[$2 - 1] = $3 while $s =~ /^DB_ARCANA_AspectTier\("(\w+)", (\d), "[^"]+", "[^"]+", (\d+)\);/mg;
    %g;
}

sub entry {
    my ($name, $type, @kv) = @_;
    my $s = qq{new entry "$name"\ntype "$type"\n};
    while (my ($k, $v) = splice @kv, 0, 2) { $s .= qq{data "$k" "$v"\n} if defined $v }
    "$s\n";
}

sub tier_tag { my ($a, $i) = @_; qq{<LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_$A{$a}{passive}_$ROMAN[$i]">$A{$a}{tiers}[$i]</LSTag>} }
sub passive_text {
    my ($a, $g) = @_; my $x = $A{$a};
    join '', "$x->{do} during a fight to awaken the Aspect of $x->{aspect} until combat ends.",
        ($x->{rule} ? " $x->{rule}" : ''), ' Each goal you reach awakens one more tier.',
        '<br><br>Level 3: ' . $x->{goal}->($g->[0]) . ' to gain ' . tier_tag($a, 0) . '.',
        '<br><br>Level 7: ' . $x->{goal}->($g->[1]) . ' to also gain ' . tier_tag($a, 1) . '.',
        '<br><br>Level 12: ' . $x->{goal}->($g->[2]) . ' to awaken as the ' . tier_tag($a, 2) . '.',
        '<br><br>The Awakening status shows how much is left to the next tier.';
}
sub passive_texts { my %g = goals(); map { $_ => passive_text($_, $g{$_}) } @ORDER }

# the existing Description handle of a passive in the game (its text changes in place, version +1)
sub desc_handle {
    my $id = shift;
    my $s = slurp("$G/Public/$M/Stats/Generated/Data/Passive.txt");
    my ($b) = $s =~ /(^new entry "\Q$id\E"\n.*?)\n\n/ms or die "$id not in Passive.txt\n";
    my ($h) = $b =~ /^data "Description" "(h[0-9a-g]+);\d+"$/m or die "$id has no Description handle\n";
    $h;
}

sub build_patch {
    my (@loca, $body);
    my %pt = passive_texts();
    for my $a (@ORDER) {
        my $x = $A{$a};
        for my $i (0 .. 2) {
            my $id = "ASPECT_PROGRESS_${a}_$ROMAN[$i]";
            my $tier = $x->{tiers}[$i] =~ /^Aspect of/ ? "the $x->{tiers}[$i]" : $x->{tiers}[$i];
            push @loca, ["AW_${id}_NAME", 'Awakening'], ["AW_${id}_DESC", "$x->{left} to awaken $tier."];
            $body .= entry($id, 'StatusData', StatusType => 'BOOST',
                DisplayName => "{{AW_${id}_NAME}}", Description => "{{AW_${id}_DESC}}", Icon => $x->{icon},
                StackId => "ASPECT_PROGRESS_$a", StackType => 'Overwrite', RemoveEvents => 'OnCombatEnded',
                StatusPropertyFlags => 'FreezeDuration;IgnoreResting;ForceOverhead', StatusGroups => 'SG_RemoveOnRespec');
        }
        # Temperance's passive is generated by gen_emotion_alchemy.pl (same shape): not here
        push @loca, [desc_handle("Arcana_Passive_Aspect_$x->{passive}_Awakening"), $pt{$a}] unless $a eq 'TEMPERANCE';
    }
    my $p = "# GENERATED by 80_TOOLS_AND_PIPELINE/82_Automation/stats/gen_awakening_progress.pl -- do not edit by hand.\n"
          . "# Spec: 50_ENGINEERING/55_Implementation_Specs/SPEC_ARC-0007.md\n\n";
    $p .= "\@loca $_->[0] $_->[1]\n" for @loca;
    $p .= "\n\@file Status_BOOST\n\@section ARCANA STATUS\n\n$body";
    ($p, map { @$_ } @loca);
}

# The countdown: replaces the Display / ShowNumber block of ARCANA_Aspect_Common.txt (the "Next tier and the countdown
# on screen" region keeps FindNext). PROCs of one name run in file order: the table is cleared before it is filled.
# The comments follow the house standard of 57.05/OSIRIS.md section 13 (check_osiris.pl).
sub display_block {
    my @rows = map { my $a = $_; map { qq{DB_ARCANA_AspectProgress("$a", } . ($_ + 1) . qq{, "ASPECT_PROGRESS_${a}_$ROMAN[$_]");} } 0 .. 2 } @ORDER;
    my $g = join "\n",
        '// Generated by gen_awakening_progress.pl: the number counts DOWN -- what is left to the next tier, in the',
        '// Aspect\'s unit (COUNT: the goal\'s own unit; HEAL: hit points to heal; LOSS: hit points to lose). One status per',
        '// tier (DB_ARCANA_AspectProgress), so its text names the tier it awakens. Its table is part of the Init.',
        'PROC', 'PROC_ARCANA_Aspect_Init()', 'AND', 'DB_ARCANA_AspectProgress(_Aspect, _Tier, _Status)', 'THEN', 'NOT DB_ARCANA_AspectProgress(_Aspect, _Tier, _Status);', '',
        'PROC', 'PROC_ARCANA_Aspect_Init()', 'THEN', @rows, '',
        '// no next tier (Tier III reached, or the level unlocks none): it goes away',
        'PROC', 'PROC_ARCANA_Aspect_Display((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Value)', 'AND', 'NOT DB_ARCANA_AspectNext(_Char, _)',
        'THEN', 'PROC_ARCANA_Aspect_HideProgress(_Char, _Aspect);', '',
        'PROC', 'PROC_ARCANA_Aspect_Display((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Value)', 'AND', 'DB_ARCANA_AspectNext(_Char, _Tier)',
        'AND', 'DB_ARCANA_AspectTier(_Aspect, _Tier, _, _, _Goal)', 'AND', 'IntegerSubtract(_Goal, _Value, _Left)',
        'THEN', 'PROC_ARCANA_Aspect_ShowLeft(_Char, _Aspect, _Tier, _Left);', '',
        'PROC', 'PROC_ARCANA_Aspect_ShowLeft((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Tier, (INTEGER)_Left)', 'AND', 'DB_ARCANA_AspectShow(_Aspect, "COUNT")',
        'THEN', 'PROC_ARCANA_Aspect_ShowNumber(_Char, _Aspect, _Tier, _Left);', '',
        '// Star: the value is healing x 100 / level -- back to hit points, rounded up',
        'PROC', 'PROC_ARCANA_Aspect_ShowLeft((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Tier, (INTEGER)_Left)', 'AND', 'DB_ARCANA_AspectShow(_Aspect, "HEAL")',
        'AND', 'GetLevel(_Char, _Level)', 'AND', 'IntegerProduct(_Left, _Level, _X)', 'AND', 'IntegerSum(_X, 99, _Up)', 'AND', 'IntegerDivide(_Up, 100, _HP)',
        'THEN', 'PROC_ARCANA_Aspect_ShowNumber(_Char, _Aspect, _Tier, _HP);', '',
        '// Death: the value is loss x 1000 / max HP -- back to hit points, rounded up',
        'PROC', 'PROC_ARCANA_Aspect_ShowLeft((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Tier, (INTEGER)_Left)', 'AND', 'DB_ARCANA_AspectShow(_Aspect, "LOSS")',
        'AND', 'GetMaxHitpoints(_Char, _Max)', 'AND', 'IntegerProduct(_Left, _Max, _X)', 'AND', 'IntegerSum(_X, 999, _Up)', 'AND', 'IntegerDivide(_Up, 1000, _HP)',
        'THEN', 'PROC_ARCANA_Aspect_ShowNumber(_Char, _Aspect, _Tier, _HP);', '',
        '// the number is the frozen duration (6 s per turn); 0 or less: nothing to show',
        'PROC', 'PROC_ARCANA_Aspect_ShowNumber((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Tier, (INTEGER)_N)', 'AND', '_N >= 1',
        'AND', 'DB_ARCANA_AspectProgress(_Aspect, _Tier, _Status)', 'AND', 'IntegerProduct(_N, 6, _Secs)', 'AND', 'IntegerToReal(_Secs, _Dur)',
        'THEN', 'ApplyStatus(_Char, _Status, _Dur, 1, _Char);', '',
        'PROC', 'PROC_ARCANA_Aspect_ShowNumber((CHARACTER)_Char, (STRING)_Aspect, (INTEGER)_Tier, (INTEGER)_N)', 'AND', '_N < 1',
        'THEN', 'PROC_ARCANA_Aspect_HideProgress(_Char, _Aspect);', '',
        'PROC', 'PROC_ARCANA_Aspect_HideProgress((CHARACTER)_Char, (STRING)_Aspect)', 'AND', 'DB_ARCANA_AspectProgress(_Aspect, _Tier, _Status)',
        'THEN', 'RemoveStatus(_Char, _Status, _Char);', '',
        'PROC', 'PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)', 'AND', 'DB_ARCANA_AspectProgress(_Aspect, _Tier, _Status)',
        'THEN', 'RemoveStatus(_Char, _Status, _Char);', '';
    $g =~ s/\n/\r\n/g;
    $g;
}

sub write_file { my ($path, $s) = @_; make_path(dirname($path)); open my $h, '>:raw', $path or die "$path: $!"; print $h $s; close $h }
sub main {
    my $out = "$ROOT/50_ENGINEERING/55_Implementation_Specs/_wip/ARC-0007";
    my ($p) = build_patch();
    write_file("$out/10_awakening.patch", $p);
    write_file("$out/20_common_display.txt", display_block());
    printf "10_awakening.patch: %d entries, %d strings\n", scalar(() = $p =~ /^new entry /mg), scalar(() = $p =~ /^\@loca /mg);
}
main() unless caller;
1;
