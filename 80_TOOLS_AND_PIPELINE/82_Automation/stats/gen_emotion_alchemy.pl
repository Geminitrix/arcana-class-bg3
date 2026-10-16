#!/usr/bin/perl
# Resonant: generates the Emotional Alchemy engine (spec 20_GAME_DESIGN/21_GDD_Arcana_Class/21.04_Subclasses/Resonant/2026-10-11-resonant-design.md).
#
# One table -- Plutchik's wheel and its states -- becomes two patches for stats_add.pl:
#   50_ENGINEERING/55_Implementation_Specs/_wip/Resonant/10_engine.patch          8 Weave Surges, the statuses, the passives, and the text
#   50_ENGINEERING/55_Implementation_Specs/_wip/Resonant/20_upcast_targets.patch  +1 target per level on the _N variants (only after gen_upcast_variants)
#   ... and the level maps (30_, 31_) and the Osiris goal (40_ Overload) next to them
#
#   perl gen_emotion_alchemy.pl               # (re)writes the patches; only READS the game
#   perl gen_emotion_alchemy.pl --out DIR     # writes somewhere else
#   perl t/gen_emotion_alchemy.t              # tests (`prove` does not run on this Perl)
#
# The patches are generated: never edit them by hand. To change a number or a line of text, change the table
# here and run again. Everything is Stats, so it works in the console edition (no Script Extender).
package Alchemy;
use strict; use warnings;
use File::Basename qw(dirname);
use File::Path qw(make_path);
use Cwd qw(abs_path);

our $G = $ENV{BG3_DATA} // 'C:/Program Files (x86)/Steam/steamapps/common/Baldurs Gate 3/Data';
our $M = 'AspectClass_9d734fbd-cb67-95c0-e2c9-46f05fe2f8a7';
our $ROOT = abs_path(dirname(__FILE__) . '/../../..');            # repository root
sub default_out { "$ROOT/50_ENGINEERING/55_Implementation_Specs/_wip/Resonant" }
our $MASTER = "$ROOT/20_GAME_DESIGN/25_Master_Data";
# ARC-0017 (R49-R68) is built in stages, one [fechado] each: ARC17_STAGE=N writes the game up to stage N
# (1 moods and loops, 2 the Overload, 3 the container, 4 the rest). Unset = 0 = the game of ARC-0002.
our $STAGE = $ENV{ARC17_STAGE} // 0;
sub at { $STAGE >= $_[0] }
# 25 placeholders ‹…› are the balance pass's proposals: the build uses the number inside
sub plain { (my $v = shift // '') =~ s/[^\x00-\x7F]|"//g; $v }   # by_level keeps the quotes of "‹1d6›"
# a 25 by_level table (1 / 5 / 9) as bands [from, next band or undef, value]
sub bands { my $by = shift; my @l = sort { $a <=> $b } keys %$by; map { [$l[$_], $l[$_ + 1], plain($by->{ $l[$_] })] } 0 .. $#l }
sub band_if { my ($lo, $hi) = @_; my @c;
    push @c, "ClassLevelHigherOrEqualThan($lo,'Arcana')" if $lo > 1;
    push @c, "not ClassLevelHigherOrEqualThan($hi,'Arcana')" if $hi;
    'IF(' . join(' and ', @c) . '):' }
# One value entry of a 25 file: { value => ..., unit => ..., by_level => { level => value } }.
# The files use one-line flow maps (schema 25.00/master_data.schema.yaml), so a line parser is enough.
sub master {
    my ($file, $key) = @_;
    my ($dir) = grep { -e "$MASTER/$_/$file.yaml" } qw(25.01_spells 25.02_features 25.03_statuses);
    die "master data $file not found\n" unless $dir;
    open my $h, '<', "$MASTER/$dir/$file.yaml" or die "$file: $!";
    while (my $l = <$h>) {
        next unless $l =~ /^\s+\Q$key\E:\s*\{(.*)\}\s*$/;
        my $body = $1; my %v;
        $v{by_level} = { $1 =~ /(\d+):\s*([^,\s}]+)/g } if $body =~ s/by_level:\s*\{([^}]*)\},?//;
        while ($body =~ /(\w+):\s*("[^"]*"|[^,]+)/g) { my ($k, $x) = ($1, $2); $x =~ s/^\s+|\s+$//g; $x =~ s/^"(.*)"$/$1/; $v{$k} = $x }
        return \%v;
    }
    die "master data $file has no $key\n";
}

# ---------------------------------------------------------------- the wheel
# Plutchik's clockwise order. The distance between two emotions decides the reaction (spec §4.2).
our @WHEEL = qw(Joy Trust Fear Surprise Sadness Disgust Anger Anticipation);
our %IDX; @IDX{@WHEEL} = 0 .. $#WHEEL;

sub distance { my ($x, $y) = @_; my $d = abs($IDX{$x} - $IDX{$y}); $d > 4 ? 8 - $d : $d }
sub pair     { my ($x, $y) = @_; join '+', sort { $IDX{$a} <=> $IDX{$b} } $x, $y }

# distance => passive that unlocks the reaction (undef = always unlocked)
our %GATE = (0 => 'Arcana_Passive_Overwhelm', 1 => undef, 2 => 'Arcana_Passive_ComplexFeelings',
             3 => 'Arcana_Passive_MixedFeelings', 4 => undef);
our $FEELING_TURNS  = master('STA_Resonant_States', 'feeling_duration')->{value};
our $MOOD_TURNS     = master('STA_Resonant_States', 'mood_duration')->{value};
# Stage 4 -- Aspect Awakening (14 · Temperance). Bonuses check the hidden "Tier I reached" status on the caster, as
# the Empress's do (never the tier passive). Numbers: 25 FEAT_Resonant_AspectAwakening, STA_Resonant_Catharsis.
our $AWAKENED     = 'ASPECT_AWAKENED_TEMPERANCE';
our $AW_COND      = "HasStatus('$AWAKENED', context.Source)";
our $TIER1_BONUS  = master('STA_Resonant_Catharsis', 'tier1_bonus')->{value};
our $TIER1_EXTEND = master('FEAT_Resonant_AspectAwakening', 'tier1_mood_extend')->{value};
# Tier II reached: a hidden marker Osiris applies with the tier (kept through Tier III). Short on purpose: the condition
# repeats 12 times in each Surge's SpellSuccess, which must stay under the Toolkit's 4096-character line.
our $T2_COND      = "HasStatus('RESONANT_TIER2', context.Source)";
our $TIER2_EXTEND = master('FEAT_Resonant_AspectAwakening', 'tier2_feeling_extend')->{value};
# Always-true marker in every Surge's conditions (the ARCANA_IS_CARD pattern): IsWeaveSurge() reads it, so the upcast
# variants count too. The passive ARCANA_IS_SURGE does not exist and never should.
our $SURGE_MARK   = "not HasPassive('ARCANA_IS_SURGE', context.Source)";
our $CATHARSIS_MAP      = 'Catharsis_Damage';
our $CATHARSIS_MAP_UUID = '11006542-a7b5-4599-938a-2840982c4bb1';   # fixed: generated once for this map
our $CATHARSIS_DICE     = "LevelMapValue($CATHARSIS_MAP)";           # damage and healing scale with level (25: STA_Resonant_Catharsis)
our $WEAPON_MAP      = 'Overload_WeaponPsychic';                    # R30: Psychic on weapon hits while Overloaded
our $WEAPON_MAP_UUID = '0303ce32-2343-4901-b428-f5c6ca0099c1';      # fixed: generated once for this map
# One LevelMapSeries node (pattern of the mod's Starcall_Damage): levels 1-20 from a 25 by_level table.
sub levelmap_node {
    my ($name, $uuid, $by) = @_;
    my @th = sort { $a <=> $b } keys %$by;
    my %lv; for my $L (1 .. 20) { my ($t) = grep { $_ <= $L } reverse @th; $lv{$L} = $by->{$t} }
    my $s = qq{                <node id="LevelMapSeries">\n};
    $s .= qq{                    <attribute id="Level$_" type="LSString" value="$lv{$_}"/>\n} for sort { "$a" cmp "$b" } 1 .. 20;
    $s .= qq{                    <attribute id="Name" type="FixedString" value="$name"/>\n};
    $s .= qq{                    <attribute id="UUID" type="guid" value="$uuid"/>\n                </node>\n};
}
sub catharsis_levelmap { levelmap_node($CATHARSIS_MAP, $CATHARSIS_MAP_UUID,
    master('STA_Resonant_Catharsis', at(4) ? 'damage_next' : 'damage')->{by_level}) }   # R67: 1 / 5 / 9 from stage 4
# ARC-0017 stage 4 (R62, R67): the dice states grow at 5 and 9 -- one level map per die family (fixed UUIDs), negative
# twins for the penalties. Pattern: vanilla RollBonus(Attack,LevelMapValue(SuperiorityDie)); whose level -- probe B7.
our %DICE_MAP = (Resonant_Die4 => 'e7480976-ff78-4826-9576-e31f2ee9e7e0', Resonant_Die4Neg => '259ccc06-9888-4067-ae84-429e4cea474e',
                 Resonant_Die6 => 'c80921ce-0450-4e6f-a496-2f69e637a3de', Resonant_Die6Neg => 'f547421b-e27b-4f6c-b969-e2861132421b');
sub dice_by { my ($key, $neg) = @_; my $by = master('STA_Resonant_Feelings', $key)->{by_level};
    +{ map { $_ => ($neg ? '-' : '') . plain($by->{$_}) } keys %$by } }
sub dice_levelmaps {
    levelmap_node('Resonant_Die4', $DICE_MAP{Resonant_Die4}, dice_by('hope_bonus_next'))
  . levelmap_node('Resonant_Die4Neg', $DICE_MAP{Resonant_Die4Neg}, dice_by('hope_bonus_next', 1))
  . levelmap_node('Resonant_Die6', $DICE_MAP{Resonant_Die6}, dice_by('remorse_damage_next'))
  . levelmap_node('Resonant_Die6Neg', $DICE_MAP{Resonant_Die6Neg}, dice_by('remorse_damage_next', 1));
}
our @GROWING = qw(FEELING_HOPE FEELING_DESPAIR MOOD_APPREHENSIVE FEELING_AGGRESSIVENESS FEELING_REMORSE_TECH FEELING_MORBIDNESS_TECH FEELING_DELIGHT FEELING_PESSIMISM);
sub grow { my $s = shift;
    $s =~ s/-1d4\b/LevelMapValue(Resonant_Die4Neg)/g; $s =~ s/\b1d4\b/LevelMapValue(Resonant_Die4)/g;
    $s =~ s/-1d6\b/LevelMapValue(Resonant_Die6Neg)/g; $s =~ s/\b1d6\b/LevelMapValue(Resonant_Die6)/g; $s }
sub weapon_levelmap    { levelmap_node($WEAPON_MAP, $WEAPON_MAP_UUID, master('FEAT_Resonant_Overload', 'weapon_psychic')->{by_level}) }
# the level each gate passive arrives at (Resonant progression), shown in the Surges' list of reactions
our %GATE_LEVEL = (Arcana_Passive_Overwhelm => 7, Arcana_Passive_ComplexFeelings => 5, Arcana_Passive_MixedFeelings => 9);
# TooltipExtraTexts entry (Public/$M/TooltipExtras): the warning every Surge shows, written by hand in that table
our $SURGE_WARNING = '70aa3de3-6968-4c6e-a9cc-46344d0c08c2';

# ---------------------------------------------------------------- the states
# side: A = goes on an ally when the target has no mood (bright arc); I = on a non-ally (dark arc).
# flavour + effect: the Surge's description (one short sentence, then what the target gets).
# peak/mood/intense: boosts + the mechanics sentence of the status. mood fx: the same effect as a clause that
#   closes the Surge's "When the surge fades..." sentence.
# type/using: status type and vanilla parent when it is not a plain BOOST -- the type decides the FILE
#   (Status_<TYPE>.txt) and the engine behaviour (FEAR flees, INCAPACITATED can't act). With `using`, leave
#   boosts undef to inherit the parent's.
# extra: more fields for the entry. params: DescriptionParams. onapply: added to OnApplyFunctors.
our %EMO = (
    Joy => { side => 'A', icon => 'Spell_Enchantment_Heroism',
        flavour => "Pluck a bright thread of joy in an ally's Weave.",
        effect  => "The target's joy is contagious: it and allies near it have Advantage on their next attack.",
        # R17: contagious -- an aura gives the Joyful creature's allies Advantage on their next attack (25: STA_Resonant_Peaks)
        peak    => { boosts => undef, params => 'Distance(' . master('STA_Resonant_Peaks', 'joy_aura_radius')->{value} . ')',
                     text => 'Its joy is contagious: it and its allies within [1] have Advantage on their next attack.',
                     extra => { AuraRadius => master('STA_Resonant_Peaks', 'joy_aura_radius')->{value},
                                AuraStatuses => 'IF(Ally() or Self()):ApplyStatus(RESONANT_JOY_CONTAGION,100,1)' } },
        mood    => { name => 'Serene', fx => 'with Advantage on Wisdom Saving Throws', boosts => 'Advantage(SavingThrow,Wisdom)',
                     text => 'Has Advantage on Wisdom Saving Throws.' },
        intense => { name => 'Ecstasy', boosts => 'ActionResource(ActionPoint,1,0)',
                     text => 'Has an additional action.' } },
    Trust => { side => 'A', icon => 'Spell_Abjuration_ShieldOfFaith',
        flavour => "Steady an ally with a thread of trust.",
        effect  => "The target stands shoulder to shoulder with its allies, sharing the blows meant for them.",
        # R27: shoulder to shoulder -- a reaction that shares a hit aimed at a nearby ally (Interrupt_Arcana_TrustShoulder)
        peak    => { boosts => 'UnlockInterrupt(Interrupt_Arcana_TrustShoulder)', tick => 'StartTurn',
                     extra => { StatusPropertyFlags => 'TickingWithSource' },   # P2: counts on the Resonant's turn, like Anticipation
                     params => 'Distance(' . master('STA_Resonant_Peaks', 'trust_shoulder_range')->{value} . ')',
                     text => 'Shoulder to shoulder: when an ally within [1] is hit by an attack, it can use its reaction to share the blow. The ally is Resistant to it, and it takes the same damage.' },
        mood    => { name => 'Accepting', fx => 'with a +1 bonus to Armour Class', boosts => 'AC(1)',
                     text => 'Armour Class increased by 1.' },
        intense => { name => 'Admiration', boosts => 'Resistance(All, Resistant);StatusImmunity(SG_Charmed);StatusImmunity(SG_Frightened)',
                     text => 'Resistant to all damage. Cannot be Charmed or Frightened.' } },
    Fear => { side => 'I', icon => 'Spell_Illusion_PhantasmalKiller',
        flavour => "Wrap a creature in a cold thread of fear.",
        effect  => "The target can't move and has Disadvantage on Ability Checks and Attack Rolls.",
        peak    => { boosts => 'Disadvantage(AllAbilities);Disadvantage(AttackRoll);ActionResourceBlock(Movement)',
                     text => "Frozen with fear: can't move. Has Disadvantage on Ability Checks and Attack Rolls.",
                     extra => { StatusGroups => 'SG_Frightened;SG_Condition' } },   # R17: vanilla FRIGHTENED's boosts and group
        mood    => { name => 'Apprehensive', fx => 'subtracting 1d4 from its Wisdom Saving Throws', boosts => 'RollBonus(SavingThrow,-1d4,Wisdom)',
                     text => 'Subtracts 1d4 from Wisdom Saving Throws.' },
        # FEAR type (the Fear spell's FEARED): the creature flees. Its per-turn save is switched off -- 1 turn.
        intense => { name => 'Terror', type => 'FEAR', using => 'FEARED',
                     text => 'Flees in terror. Has Disadvantage on Ability Checks and Attack Rolls.',
                     extra => { RemoveConditions => '', RemoveEvents => '', TooltipSave => '' } } },
    Surprise => { side => 'I', icon => 'Spell_Enchantment_Enthrall',
        flavour => "Snap a thread of surprise before a creature's eyes.",
        effect  => "The target is caught off guard: it loses its reaction, and the next attack against it has Advantage.",
        # R17: caught off guard -- the opening is its own status so the first hit removes it, not the peak (GUIDING_BOLT)
        peak    => { boosts => 'ActionResourceBlock(ReactionActionPoint)', onapply => 'ApplyStatus(RESONANT_SURPRISE_OPENING,100,1)',
                     text => "Caught off guard: can't take reactions, and the next attack against it has Advantage." },
        mood    => { name => 'Distracted', fx => 'with Disadvantage on Saving Throws to maintain Concentration', boosts => 'Disadvantage(Concentration)',
                     text => 'Has Disadvantage on Saving Throws to maintain Concentration.' },
        intense => { name => 'Amazement', type => 'INCAPACITATED', using => 'STUNNED', onapply => 'BreakConcentration()',
                     text => "Stunned: can't move or take actions or reactions. Automatically fails Strength and Dexterity Saving Throws, and attacks against it have Advantage." } },
    Sadness => { side => 'I', icon => 'Spell_Necromancy_RayOfInfeeblement',
        flavour => "Weigh a creature down with a grey thread of sorrow.",
        effect  => "The target lets go of what it holds: it loses Concentration and its bonus action.",
        # R17: lets go -- breaks Concentration and blocks the bonus action
        peak    => { boosts => 'ActionResourceBlock(BonusActionPoint)', onapply => 'BreakConcentration()',
                     text => "Lets go of what it holds: loses Concentration and can't take bonus actions." },
        mood    => { name => 'Pensive', fx => 'with its movement speed reduced by [1]', boosts => 'ActionResource(Movement,-3,0)',
                     text => 'Movement speed reduced by [1].', params => 'Distance(3)' },
        intense => { name => 'Grief', type => 'INCAPACITATED', boosts => 'ActionResourceBlock(Movement)', onapply => 'BreakConcentration()',
                     text => "Incapacitated: can't move or take actions, bonus actions or reactions.",
                     extra => { StatusGroups => 'SG_Incapacitated;SG_Condition' } } },
    Disgust => { side => 'I', icon => 'Spell_Conjuration_StinkingCloud',
        flavour => "Twist a creature's Weave into revulsion.",
        effect  => "The target can't take actions and has Disadvantage on Constitution Saving Throws.",
        peak    => { boosts => 'ActionResourceBlock(ActionPoint);Disadvantage(SavingThrow,Constitution)',
                     text => "Can't take actions. Has Disadvantage on Constitution Saving Throws." },
        mood    => { name => 'Bored', fx => 'unable to take reactions', boosts => 'ActionResourceBlock(ReactionActionPoint)',
                     text => "Can't take reactions." },
        intense => { name => 'Loathing', boosts => 'ActionResourceBlock(ActionPoint);ActionResourceBlock(BonusActionPoint);Disadvantage(AttackRoll);Disadvantage(AllAbilities)',
                     text => "Can't take actions or bonus actions. Has Disadvantage on Attack Rolls and Ability Checks." } },
    Anger => { side => 'I', icon => 'Spell_Enchantment_CrownOfMadness',
        flavour => "Set a red thread of fury alight in a creature's mind.",
        effect  => "The target bears a grudge: it attacks the last creature that hurt it, or the nearest one if nobody has.",
        # R26: the grudge (or the fallback) is applied by Osiris (ARCANA_Resonant_Grudge), never both
        peak    => { boosts => undef,   # P4: keeps its reaction, so it still makes opportunity attacks
                     text => 'Bears a grudge: attacks the last creature that hurt it, or the nearest one if nobody has.',
                     extra => { StatusPropertyFlags => 'InitiateCombat;BringIntoCombat', StatusGroups => 'SG_Condition' } },
        mood    => { name => 'Annoyed', fx => 'with its Armour Class reduced by 1', boosts => 'AC(-1)',
                     text => 'Armour Class reduced by 1.' },
        intense => { name => 'Rage', boosts => 'Advantage(AttackRoll);Advantage(AttackTarget)',
                     text => 'Bears a grudge: attacks the last creature that hurt it, or the nearest one if nobody has, with Advantage. Attacks against it also have Advantage.',
                     extra => { StatusPropertyFlags => 'InitiateCombat;BringIntoCombat', StatusGroups => 'SG_Condition' } } },
    Anticipation => { side => 'A', icon => 'Spell_Transmutation_Longstrider',
        flavour => "Pull a taut thread of anticipation through an ally's Weave.",
        effect  => "The target stands on guard and strikes the first enemy that comes within reach.",
        # R17: on guard -- a reaction attack when an enemy enters its reach (Interrupt_Arcana_AnticipationGuard)
        peak    => { boosts => 'UnlockInterrupt(Interrupt_Arcana_AnticipationGuard)', tick => 'StartTurn',
                     text => 'On guard: when an enemy enters its reach, it can use its reaction to attack first.',
                     extra => { StatusPropertyFlags => 'TickingWithSource' } },   # R28: counts on the Resonant's turn, so it covers the round
        mood    => { name => 'Interested', fx => 'with its movement speed increased by [1]', boosts => 'ActionResource(Movement,3,0)',
                     text => 'Movement speed increased by [1].', params => 'Distance(3)' },
        intense => { name => 'Vigilance', boosts => 'ActionResource(ReactionActionPoint,2,0);Advantage(SavingThrow,Dexterity)',
                     text => 'Has 2 additional reactions and Advantage on Dexterity Saving Throws.' } },
);

# The 24 dyads. Key = pair() (wheel order). kind: A = helps whoever carries it, I = hinders.
our %FEELING = (
    # primary (distance 1)
    'Joy+Trust'          => { name => 'Love', kind => 'A', icon => 'Spell_Abjuration_WardingBond',
        boosts => 'AC(1);RollBonus(SavingThrow,1);Resistance(All, Resistant);RedirectDamage(1)',
        text => 'Armour Class and Saving Throws increased by 1, and Resistant to all damage. The spellcaster takes the same damage.',
        extra => { RemoveEvents => 'OnSourceDeath' } },
    'Trust+Fear'         => { name => 'Submission', kind => 'I', icon => 'Spell_Enchantment_DominatePerson',
        boosts => 'CannotHarmCauseEntity(CannotHarmCharmer)',
        text => "Knocked Prone and can't harm the spellcaster.", onapply => 'ApplyStatus(PRONE,100,1)' },
    # INCAPACITATED type (Hypnotic Pattern): can't act until it takes damage.
    'Fear+Surprise'      => { name => 'Awe', kind => 'I', icon => 'Spell_Illusion_HypnoticPattern',
        type => 'INCAPACITATED', using => 'HYPNOTIC_PATTERN', onapply => 'BreakConcentration()',
        text => "Incapacitated: can't move or take actions, bonus actions or reactions. Taking damage ends the effect." },
    'Surprise+Sadness'   => { name => 'Disapproval', kind => 'I', icon => 'Spell_Enchantment_Bane',
        text => 'Its allies within [1] have Disadvantage on Attack Rolls.', params => 'Distance(3)',
        extra => { AuraRadius => '3', AuraStatuses => 'TARGET:IF(Ally() and not Self()):ApplyStatus(FEELING_DISAPPROVED)' } },
    'Sadness+Disgust'    => { name => 'Remorse', kind => 'I', icon => 'Spell_Illusion_PhantasmalKiller',
        text => 'The first time it deals damage each turn, it takes [1].', params => 'DealDamage(1d6,Psychic)',
        extra => { Passives => 'Arcana_Passive_FeelingRemorse' } },
    'Disgust+Anger'      => { name => 'Contempt', kind => 'I', icon => 'Spell_Conjuration_StinkingCloud',
        boosts => 'Resistance(Psychic, Vulnerable)', text => 'Vulnerable to Psychic damage.' },
    'Anger+Anticipation' => { name => 'Aggressiveness', kind => 'A', icon => 'Action_Barbarian_Rage',
        boosts => 'CharacterWeaponDamage(1d4);ActionResource(ReactionActionPoint,1,0)',
        text => 'Weapon attacks deal an additional [1]. Has an additional reaction.', params => 'DealDamage(1d4, MainMeleeWeaponDamageType)' },
    'Joy+Anticipation'   => { name => 'Optimism', kind => 'A', icon => 'Spell_Enchantment_Heroism',
        boosts => 'StatusImmunity(SG_Frightened)', text => 'Cannot be Frightened. Gains temporary hit points each turn.',
        onapply => 'ApplyStatus(HEROISM_TEMP_HP,100,1)', extra => { TickFunctors => 'ApplyStatus(HEROISM_TEMP_HP,100,1)' } },
    # secondary (distance 2)
    'Trust+Anticipation' => { name => 'Hope', kind => 'A', icon => 'Spell_Enchantment_Bless',
        boosts => 'RollBonus(Attack,1d4);RollBonus(SavingThrow,1d4);RollBonus(DeathSavingThrow,1d4)',
        text => 'Adds 1d4 to Attack Rolls and Saving Throws.' },
    'Joy+Fear'           => { name => 'Guilt', kind => 'I', icon => 'Spell_Illusion_PhantasmalKiller',
        boosts => 'ActionResourceBlock(BonusActionPoint);Disadvantage(SavingThrow,Wisdom)',
        text => "Can't take bonus actions. Has Disadvantage on Wisdom Saving Throws." },
    'Trust+Surprise'     => { name => 'Curiosity', kind => 'A', icon => 'Spell_Divination_SeeInvisibility',
        boosts => 'Advantage(AllAbilities);ActionResource(Movement,3,0)',
        text => 'Has Advantage on Ability Checks, movement speed increased by [1], and can see Invisible creatures.', params => 'Distance(3)',
        onapply => 'ApplyStatus(SEE_INVISIBILITY,100,2)' },
    'Fear+Sadness'       => { name => 'Despair', kind => 'I', icon => 'Spell_Enchantment_Bane',
        boosts => 'RollBonus(Attack,-1d4);RollBonus(SavingThrow,-1d4);RollBonus(DeathSavingThrow,-1d4)',
        text => 'Subtracts 1d4 from Attack Rolls and Saving Throws.' },
    'Surprise+Disgust'   => { name => 'Unbelief', kind => 'I', icon => 'Spell_Abjuration_Counterspell',
        boosts => 'BlockSpellCast()', text => "Can't cast spells." },
    'Sadness+Anger'      => { name => 'Envy', kind => 'I', icon => 'Spell_Enchantment_Confusion',
        boosts => 'CannotHarmCauseEntity(CannotHarmMadness);ActionResourceBlock(ReactionActionPoint);AiArchetypeOverride(madness,99);Tag(AI_UNPREFERRED_TARGET);DetectDisturbancesBlock(true)',
        text => 'Will attack the nearest creature, other than the spellcaster.',
        extra => { StatusPropertyFlags => 'InitiateCombat;BringIntoCombat;LoseControl', StatusGroups => 'SG_Condition;SG_Mad' } },
    'Disgust+Anticipation' => { name => 'Cynicism', kind => 'I', icon => 'Spell_Conjuration_StinkingCloud',
        boosts => 'BlockRegainHP()', text => "Can't regain hit points." },
    'Joy+Anger'          => { name => 'Pride', kind => 'A', icon => 'Action_Barbarian_Rage',
        boosts => 'ReduceCriticalAttackThreshold(1)', text => 'Scores a Critical Hit on a roll of 19 or 20.' },
    # tertiary (distance 3)
    'Joy+Surprise'       => { name => 'Delight', kind => 'A', icon => 'Spell_Enchantment_Heroism',
        text => 'Regains [1] at the end of each turn.', params => 'RegainHitPoints(1d6)',
        extra => { TickFunctors => 'RegainHitPoints(1d6)' } },
    'Trust+Sadness'      => { name => 'Sentimentality', kind => 'A', icon => 'Spell_Enchantment_CalmEmotions',
        boosts => 'Resistance(Psychic, Resistant);StatusImmunity(SG_Charmed)', text => 'Resistant to Psychic damage. Cannot be Charmed.' },
    'Fear+Disgust'       => { name => 'Shame', kind => 'I', icon => 'Spell_Illusion_PhantasmalKiller',
        boosts => 'ActionResourceBlock(ReactionActionPoint);Disadvantage(AttackRoll)',
        text => "Can't take reactions. Has Disadvantage on Attack Rolls." },
    'Surprise+Anger'     => { name => 'Outrage', kind => 'I', icon => 'Spell_Enchantment_CompelledDuel',
        boosts => 'Disadvantage(AttackRoll);Advantage(AttackTarget)',
        text => 'Has Disadvantage on Attack Rolls, and attacks against it have Advantage.' },
    'Sadness+Anticipation' => { name => 'Pessimism', kind => 'I', icon => 'Spell_Necromancy_RayOfInfeeblement',
        boosts => 'RollBonus(SavingThrow,-1d6);RollBonus(SkillCheck,-1d6);RollBonus(RawAbility,-1d6)',
        text => 'Subtracts 1d6 from Saving Throws and Ability Checks.' },
    'Joy+Disgust'        => { name => 'Morbidness', kind => 'A', icon => 'Spell_Conjuration_StinkingCloud',
        text => 'The first time it deals damage with a weapon each turn, it regains [1].', params => 'RegainHitPoints(1d6)',
        extra => { Passives => 'Arcana_Passive_FeelingMorbidness' } },
    'Trust+Anger'        => { name => 'Dominance', kind => 'A', icon => 'Spell_Enchantment_DominatePerson',
        boosts => 'Advantage(Skill,Athletics);Advantage(Skill,Intimidation);AC(1)',
        text => 'Has Advantage on Athletics and Intimidation checks. Armour Class increased by 1.' },
    'Fear+Anticipation'  => { name => 'Anxiety', kind => 'I', icon => 'Spell_Enchantment_Confusion',
        boosts => 'ActionResourceBlock(ReactionActionPoint);Disadvantage(Concentration)',
        text => "Loses Concentration. Can't take reactions and has Disadvantage on Saving Throws to maintain Concentration.",
        onapply => 'BreakConcentration()' },
);

# ---------------------------------------------------------------- names
sub peak_id    { 'EMOTION_' . uc $_[0] }
sub mood_id    { 'MOOD_' . uc $EMO{$_[0]}{mood}{name} }
sub intense_id { 'EMOTION_' . uc $EMO{$_[0]}{intense}{name} }
sub feeling_of { $FEELING{ pair(@_) } }
sub feeling_id { 'FEELING_' . uc feeling_of(@_)->{name} }
sub spell_id   { 'Target_Arcana_Card_Spell_Emotion' . $_[0] }
sub key        { my $k = uc join '_', @_; $k =~ s/[^A-Z0-9_]/_/g; "HW_$k" }   # loca key

# The reaction of Surge `$s` on a creature carrying the mood of emotion `$m`.
sub reaction {
    my ($s, $m) = @_;
    my $d = distance($s, $m);
    my %r = (distance => $d, gate => $GATE{$d}, mood => mood_id($m), with => $m);
    if    ($d == 0) { $r{kind} = 'intensify'; $r{status} = intense_id($s) }
    elsif ($d == 4) { $r{kind} = 'catharsis'; $r{status} = 'CATHARSIS' }
    else            { $r{kind} = 'feeling';   $r{status} = feeling_id($s, $m) }
    \%r;
}

sub cond_of { my $r = shift; my $c = "HasStatus('$r->{mood}')";
    $c .= " and HasPassive('$r->{gate}', context.Source)" if $r->{gate};
    $c .= " and not HasStatus('RESONANT_EXCESS_SPENT')" if $r->{kind} eq 'intensify' && at(1);   # R50: excess once per fight
    $c }

# SpellSuccess: the "no reaction" case comes FIRST, before any functor spends a mood (risk R1).
sub refund_functors {   # R16: the slot level per class level, as Arcana_Passive_ArcaneOverflow (mod Passive.txt)
    my @br = ([1, undef, 3], [2, 3, 5], [3, 5, 7], [4, 7, 9], [5, 9, 11], [6, 11, undef]);
    my @f = map { my ($slot, $lo, $hi) = @$_;
        my @c = ("not HasStatus('RESONANT_REFUND_USED')");
        push @c, "ClassLevelHigherOrEqualThan($lo,'Arcana')" if $lo;
        push @c, "not ClassLevelHigherOrEqualThan($hi,'Arcana')" if $hi;
        'IF(' . join(' and ', @c) . "):RestoreResource(SELF,ArcanaSpellSlot,1,$slot)" } @br;
    join ';', @f, "IF(not HasStatus('RESONANT_REFUND_USED')):RestoreResource(SELF,ArcanaThread,1,0)",
              'ApplyStatus(SELF,RESONANT_REFUND_USED,100,1)';
}
sub spell_success {
    my ($s, $kind) = @_;
    my @r = map { reaction($s, $_) } @WHEEL;
    # R57 ($kind): a Surge cast by a rule never braids a hindering feeling -- that mood is left alone, the peak lands
    @r = grep { $_->{kind} ne 'feeling' || feeling_of($s, $_->{with})->{kind} ne 'I' } @r if $kind;
    my @f = ('IF(' . join(' and ', map { 'not (' . cond_of($_) . ')' } @r) . '):ApplyStatus(' . peak_id($s) . ',100,1)');
    # R16's refund is applied by Osiris when a reaction status lands (overload_goal): here it pushed the line past the
    # Toolkit's 4096-character read limit (2026-10-12)
    for my $r (grep { $_->{kind} ne 'catharsis' } @r) {
        my $c = cond_of($r);
        if ($r->{kind} eq 'intensify') { push @f, "IF($c):ApplyStatus($r->{status},100,1)"; next }
        # Tier II Harmony (R40): the feeling lasts longer -- two exclusive branches, so it is applied once
        push @f, "IF($c and not $T2_COND):ApplyStatus($r->{status},100,$FEELING_TURNS)",
                 "IF($c and $T2_COND):ApplyStatus($r->{status},100," . ($FEELING_TURNS + $TIER2_EXTEND) . ')';
    }
    for my $r (grep { $_->{kind} eq 'catharsis' } @r) {
        my $c = cond_of($r);
        push @f, "IF($c and not Ally() and not Self()):DealDamage($CATHARSIS_DICE,Psychic,Magical)",
                 "IF($c and (Ally() or Self())):RegainHitPoints($CATHARSIS_DICE)",
                 # Tier I Resonance: +1d8 either way
                 "IF($c and not Ally() and not Self() and $AW_COND):DealDamage($TIER1_BONUS,Psychic,Magical)",
                 "IF($c and (Ally() or Self()) and $AW_COND):RegainHitPoints($TIER1_BONUS)",
                 "IF($c):ApplyStatus(CATHARSIS,100,0)";
    }
    join ';', @f;
}

sub any_mood { join ' or ', map { "HasStatus('" . mood_id($_) . "')" } @WHEEL }

sub target_conditions {
    my $s = shift;
    # R41: any creature -- the player decides (a dark peak on an ally sets up a bright feeling)
    "Character() and not Dead() and not Tagged('CONSTRUCT') and not HasPassive('ARCANA_IS_CARD', context.Source) and $SURGE_MARK";
}

# ---------------------------------------------------------------- text
# The first mention of each rules term becomes an LSTag (style memory: only the first).
our @TAGS = (
    [qr/\bAttack Rolls?\b/,     'Tooltip="AttackRoll"'],
    [qr/\bAbility Checks?\b/,   'Tooltip="AbilityCheck"'],
    [qr/\bSaving Throws?\b/,    'Tooltip="SavingThrow"'],
    [qr/\bArmour Class\b/,      'Tooltip="ArmourClass"'],
    [qr/\b[Mm]ovement speed\b/, 'Tooltip="MovementSpeed"'],
    [qr/\bDisadvantage\b/,      'Tooltip="Disadvantage"'],
    [qr/\bAdvantage\b/,         'Tooltip="Advantage"'],
    [qr/\bResistant\b/,         'Tooltip="Resistant"'],
    [qr/\bVulnerable\b/,        'Tooltip="Vulnerable"'],
    [qr/\bCritical Hit\b/,      'Tooltip="CriticalHit"'],
    [qr/\bProne\b/,             'Type="Status" Tooltip="PRONE"'],
    [qr/\bFrightened\b/,        'Type="Status" Tooltip="FRIGHTENED"'],
    [qr/\bCharmed\b/,           'Type="Status" Tooltip="CHARMED"'],
    [qr/\bInvisible\b/,         'Type="Status" Tooltip="INVISIBLE"'],
    [qr/\bStunned\b/,           'Type="Status" Tooltip="STUNNED"'],
);
sub tag_terms {
    my $t = shift; my @hold;
    for my $tg (@TAGS) {
        my ($re, $attr) = @$tg;
        # tags already inserted are parked as \x01N\x01, so nothing is ever tagged twice or nested
        $t =~ s/$re/push @hold, "<LSTag $attr>$&<\/LSTag>"; "\x01" . $#hold . "\x01"/e;
    }
    $t =~ s/\x01(\d+)\x01/$hold[$1]/g;
    $t;
}
sub st_tag { my ($id, $text) = @_; qq{<LSTag Type="Status" Tooltip="$id">$text</LSTag>} }
sub sp_tag { my ($id, $text) = @_; qq{<LSTag Type="Spell" Tooltip="$id">$text</LSTag>} }   # as the mod's English tooltips (Gale Deflection)

# ---------------------------------------------------------------- entries
sub nz { my $v = shift; defined $v && length $v ? $v : undef }   # '' -> undef (field left out)

# A field set to '' is written as "" on purpose: it clears the value inherited through `using`.
sub entry {
    my ($name, $type, @kv) = @_;
    my $s = qq{new entry "$name"\ntype "$type"\n};
    while (my ($k, $v) = splice @kv, 0, 2) {
        next unless defined $v;
        $s .= $k eq 'using' ? qq{using "$v"\n} : qq{data "$k" "$v"\n};
    }
    "$s\n";
}

my @LOCA;   # [key, text]
sub loca { my ($k, $t) = @_; push @LOCA, [$k, $t]; "{{$k}}" }

# Returns [file, text]. $kind A/I sets combat flags and groups (unless inherited through `using`);
# $o = { type, using, boosts, extra, params, onapply, onremove, stack, tick }
# Stacking: all 8 peaks and all 8 intense emotions share StackId EMOTION (a creature carries one emotion at a time, so only
# one mood comes out), `using` statuses included (set explicitly so a parent's StackId is not inherited). The 8 moods
# share StackId MOOD (one mood at a time). Every feeling has its own StackId (its own id), so feelings combine.
# Helpers use their own ids.
sub status_entry {
    my ($id, $name, $desc, $icon, $kind, $o) = @_;
    my %x = %{ $o->{extra} || {} };
    my $type = $o->{type} // 'BOOST';
    my $inherit = defined $o->{using};
    my $onapply = join ';', grep { defined && length } $o->{onapply}, delete $x{OnApplyFunctors};
    my @f = (StatusType => $type, using => $o->{using},
        DisplayName => loca(key($id, 'NAME'), $name), Description => loca(key($id, 'DESC'), $desc),
        DescriptionParams => delete $x{DescriptionParams} // $o->{params}, Icon => $icon,
        StackId => $o->{stack}, TickType => $o->{tick} // ($inherit ? undef : 'EndTurn'), Boosts => nz($o->{boosts}),
        Passives => delete $x{Passives},
        StatusPropertyFlags => delete $x{StatusPropertyFlags} // ($kind eq 'I' && !$inherit ? 'InitiateCombat;BringIntoCombat' : undef),
        StatusGroups => delete $x{StatusGroups} // ($kind eq 'I' && !$inherit ? 'SG_Condition' : undef),
        map({ $_ => $x{$_} } sort keys %x),
        OnApplyFunctors => nz($onapply), OnRemoveFunctors => $o->{onremove});
    ["Status_$type", entry($id, 'StatusData', @f)];
}

# Status text: one line, a standard opening that says where the status comes from, then its effect.
sub build_statuses {
    my @out;
    for my $e (@WHEEL) {
        my $E = $EMO{$e};
        my $side = $E->{side};
        # Tier I Resonance: the mood lasts longer once awakened. context.Source in a remove functor is the status's
        # source, the Resonant -- probe P17 (plan B: Osiris re-applies the mood)
        my ($m, $long) = (mood_id($e), $MOOD_TURNS + $TIER1_EXTEND);
        # R49: an emotion Temper replayed leaves nothing -- the fade reads the replay marker, then clears it
        my $replay = at(1) ? " and not HasStatus('RESONANT_REPLAY')" : '';
        $long = $MOOD_TURNS if at(4);   # R63: Tier I no longer lengthens moods
        my $fade = (at(4) ? "IF(RemoveCause(StatusRemoveCause.TimeOut)$replay):ApplyStatus($m,100,$MOOD_TURNS)"
                 : "IF(RemoveCause(StatusRemoveCause.TimeOut)$replay and not $AW_COND):ApplyStatus($m,100,$MOOD_TURNS);"
                 . "IF(RemoveCause(StatusRemoveCause.TimeOut)$replay and $AW_COND):ApplyStatus($m,100,$long)")
                 . (at(1) ? ';RemoveStatus(RESONANT_REPLAY)' : '');
        push @out, status_entry(peak_id($e), "Emotion: $e",
            tag_terms("Surging with $e. $E->{peak}{text}"),
            $E->{icon}, $side, { %{ $E->{peak} }, stack => 'EMOTION', onremove => $fade,
                # R42: the free Surge (Tier II) leaves the mood at once -- on every target, while the spell resolves
                onapply => join(';', grep { defined } $E->{peak}{onapply}, "IF(HasStatus('RESONANT_SURGE_FREE', context.Source)):ApplyStatus($m,100,$long)") });
        push @out, status_entry(mood_id($e), "Mood: $E->{mood}{name}",
            tag_terms("The fading echo of $e. $E->{mood}{text}") . (at(4) ? ' ' . mood_reactions($e) : ''),   # one line: a status text has no <br>
            $E->{icon}, 'mood', { %{ $E->{mood} }, stack => 'MOOD' });
        my $I = $E->{intense};
        push @out, status_entry(intense_id($e), "Emotion: $I->{name}",
            tag_terms("$e surged again on its own echo. $I->{text}"),
            # R49: the intense emotion leaves nothing; R50: it marks the creature for the rest of the fight
            $E->{icon}, $side, { %$I, stack => 'EMOTION', onremove => (at(1) ? undef : $fade),
            onapply => join(';', grep { defined } 'RemoveStatus(' . mood_id($e) . ')', $I->{onapply},
                (at(1) ? 'ApplyStatus(RESONANT_EXCESS_SPENT,100,-1)' : undef)) });
    }
    for my $k (sort { $FEELING{$a}{name} cmp $FEELING{$b}{name} } keys %FEELING) {
        my $F = $FEELING{$k}; my ($x, $y) = split /\+/, $k;
        my $consume = join ';', map { 'RemoveStatus(' . mood_id($_) . ')' } $x, $y;
        push @out, status_entry('FEELING_' . uc $F->{name}, "Feeling: $F->{name}",
            tag_terms("$x and $y, braided together. $F->{text}"),
            $F->{icon}, $F->{kind}, { %$F, stack => 'FEELING_' . uc $F->{name},
            extra => { %{ $F->{extra} || {} }, StackType => 'Additive' },   # R47: braided again, it adds its turns (vanilla RAGE_FRENZY_BURNOUT)
            onapply => join(';', grep { defined } $consume, $F->{onapply}) });
    }
    # helpers
    push @out, status_entry('FEELING_DISAPPROVED', 'Disapproved',
        tag_terms("Shaken by an ally's Disapproval. Has Disadvantage on Attack Rolls."),
        'Spell_Enchantment_Bane', 'I', { boosts => 'Disadvantage(AttackRoll)', stack => 'FEELING_DISAPPROVED' });
    push @out, hidden_status('FEELING_REMORSE_TECH', 'Remorse', 'OnApplyFunctors', 'DealDamage(1d6,Psychic,Magical)');
    push @out, hidden_status('FEELING_MORBIDNESS_TECH', 'Morbidness', 'OnApplyFunctors', 'RegainHitPoints(1d6)');
    push @out, hidden_status('RESONANT_REFUND_TECH', 'Refund', 'OnApplyFunctors', refund_functors());
    push @out, hidden_status('RESONANT_REFUND_USED', 'Refund used', 'TickType', 'StartTurn');
    if (at(1)) {   # ARC-0017 stage 1
        # R49: Temper's replay marker (2 turns; the replayed emotion's fade removes it -- probe B1)
        push @out, hidden_status('RESONANT_REPLAY', 'Replayed emotion', 'StackType', 'Overwrite');
        # R50: a creature feels an intense emotion once per fight (the ASPECT_PROGRESS_* combat-end pattern)
        push @out, hidden_status('RESONANT_EXCESS_SPENT', 'Excess felt', 'RemoveEvents', 'OnCombatEnded');
    }
    # Stage 2: the Overload meter -- a count shown as a frozen duration, like ASPECT_PROGRESS_* (ARCANA_Aspect_Common.txt)
    push @out, ['Status_BOOST', entry('RESONANT_OVERLOAD', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('RESONANT_OVERLOAD', 'NAME'), 'Overload'),
        Description => loca(key('RESONANT_OVERLOAD', 'DESC'), tag_terms(at(2) ? 'Everything you made others feel, felt again. The number shows how full it is: at 100% you become Overloaded. After a fight it settles to half.' : 'Everything you made others feel, felt again. It carries over from one fight to the next. The number shows how full it is: at 100% you become Overloaded. From level 5, Emotional Overload releases it.')),
        Icon => 'Spell_Enchantment_CalmEmotions', StackId => 'RESONANT_OVERLOAD', StackType => 'Overwrite',
        StatusPropertyFlags => 'FreezeDuration;IgnoreResting;ForceOverhead', StatusGroups => 'SG_RemoveOnRespec')];   # R31: persists; shown on the character
    # full: Psychic damage equal to the slot level at the start of each turn (25: FEAT_Resonant_Overload#full_damage),
    # by class-level bracket as Arcana_Passive_ArcaneOverflow; flat TickFunctors damage as vanilla ORI_GALE_AURANECROSIS
    # R29: from level 1, so the brackets start at slot level 1
    my $tick = join ';', map { my ($dmg, $lo, $hi) = @$_; my @c;
        push @c, "ClassLevelHigherOrEqualThan($lo,'Arcana')" if $lo;
        push @c, "not ClassLevelHigherOrEqualThan($hi,'Arcana')" if $hi; 'IF(' . join(' and ', @c) . "):DealDamage($dmg,Psychic,Magical)" }
        ([1, undef, 3], [2, 3, 5], [3, 5, 7], [4, 7, 9], [5, 9, 11], [6, 11, undef]);
    # R29/R30: Overloaded -- silenced (BlockSpellCast(), as Unbelief) and weapon hits deal Psychic by level
    # (CharacterWeaponDamage(LevelMapValue(...)), as the vanilla rage damage). Osiris sets its duration (level x 6 s).
    if (at(2)) {   # ARC-0017 stage 2 -- R51/R52/R67: a Mental Fatigue variant on the Resonant, no silence
        my @tick = bands(master('FEAT_Resonant_Overload', 'overloaded_tick_next')->{by_level});
        my @pen  = bands(master('FEAT_Resonant_Overload', 'overloaded_save_penalty_next')->{by_level});
        push @out, ['Status_BOOST', entry('RESONANT_OVERLOAD_FULL', 'StatusData', StatusType => 'BOOST',
            DisplayName => loca(key('RESONANT_OVERLOAD_FULL', 'NAME'), 'Overloaded'),
            Description => loca(key('RESONANT_OVERLOAD_FULL', 'DESC'), tag_terms('Your own feelings overwhelm you. You have a penalty to Intelligence, Wisdom and Charisma Saving Throws and take Psychic damage at the start of each turn, both growing at levels 5 and 9. Once per turn, a Weave Surge that takes hold of an enemy also deals it the same Psychic damage. Emotional Overload pours it out.')),
            Icon => 'GenericIcon_Intent_Debuff', StackId => 'RESONANT_OVERLOAD_FULL', TickType => 'StartTurn',   # vanilla Mental Fatigue's icon until ICO_Resonant_Overloaded
            TickFunctors => join(';', map { band_if($_->[0], $_->[1]) . "DealDamage($_->[2],Psychic,Magical)" } @tick),
            OnApplyFunctors => join(';', map { band_if($_->[0], $_->[1]) . "ApplyStatus(RESONANT_OVERLOADED_MIND_$_->[0],100,-1)" } @pen),
            OnRemoveFunctors => join(';', map { "RemoveStatus(RESONANT_OVERLOADED_MIND_$_->[0])" } @pen),
            StatusPropertyFlags => 'IgnoreResting;ForceOverhead')];
        # the flat penalty by band (vanilla MAG_PSYCHIC_MENTAL_FATIGUE's boosts, not multiplied by duration)
        for my $b (@pen) {
            my $id = "RESONANT_OVERLOADED_MIND_$b->[0]";
            push @out, ['Status_BOOST', entry($id, 'StatusData', StatusType => 'BOOST',
                DisplayName => loca(key($id, 'NAME'), 'Overloaded'), StackId => $id,
                Boosts => join(';', map { "RollBonus(SavingThrow,$b->[2],$_)" } qw(Intelligence Wisdom Charisma)),
                StatusPropertyFlags => 'DisableOverhead;DisableCombatlog;DisablePortraitIndicator')];
        }
        # the Surge rider (Osiris picks the band; damage from a tech status, the FEELING_REMORSE_TECH pattern)
        push @out, hidden_status("RESONANT_RIDER_TECH_$_->[0]", 'Overloaded', 'OnApplyFunctors', "DealDamage($_->[2],Psychic,Magical)") for @tick;
        # Emotional Overload's Mental Fatigue: a marker; Osiris applies the vanilla status for the Resonant's level
        push @out, hidden_status('RESONANT_FATIGUE_TECH', 'Mental Fatigue', 'StackType', 'Overwrite');
    } else {
    push @out, ['Status_BOOST', entry('RESONANT_OVERLOAD_FULL', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('RESONANT_OVERLOAD_FULL', 'NAME'), 'Overloaded'),
        Description => loca(key('RESONANT_OVERLOAD_FULL', 'DESC'), tag_terms('Overwhelmed by everything you made others feel. You can\'t cast spells, your weapon attacks deal an additional [1], and you take Psychic damage equal to your spell slot level at the start of each of your turns. It lasts a number of turns equal to your level; from level 5, Emotional Overload ends it at once.')),
        DescriptionParams => "DealDamage(LevelMapValue($WEAPON_MAP),Psychic)",
        Icon => 'Spell_Enchantment_CalmEmotions', StackId => 'RESONANT_OVERLOAD_FULL', TickType => 'StartTurn',
        Boosts => "BlockSpellCast();CharacterWeaponDamage(LevelMapValue($WEAPON_MAP),Psychic)",
        TickFunctors => $tick, StatusPropertyFlags => 'IgnoreResting;ForceOverhead')];   # R31: runs its course across combats; shown on the character
    }
    # hidden_status already sets StackId: the extra field must be another one -- a repeated field made the Toolkit
    # drop every Status_BOOST entry after this one (2026-10-12)
    push @out, hidden_status('RESONANT_OVERLOAD_SPENT_TECH', 'Overload spent', 'TickType', 'EndTurn');
    # R17 helpers. Contagion: Advantage(AttackRoll) + RemoveEvents OnAttack (vanilla MAG_MONK_SWIFT_AS_THE_WIND).
    # Opening: Advantage(AttackTarget) + RemoveEvents OnAttacked (vanilla GUIDING_BOLT). Grudge: vanilla TAUNTED's
    # flags and group; Osiris (ARCANA_Resonant_Grudge) applies it with the last attacker as its source.
    push @out, status_entry('RESONANT_JOY_CONTAGION', 'Contagious Joy', tag_terms('Has Advantage on the next attack.'),
        $EMO{Joy}{icon}, 'A', { boosts => 'Advantage(AttackRoll)', stack => 'RESONANT_JOY_CONTAGION',
        extra => { RemoveEvents => 'OnAttack' } });
    push @out, status_entry('RESONANT_SURPRISE_OPENING', 'Off Guard', tag_terms('The next attack against it has Advantage.'),
        $EMO{Surprise}{icon}, 'I', { boosts => 'Advantage(AttackTarget)', stack => 'RESONANT_SURPRISE_OPENING',
        extra => { RemoveEvents => 'OnAttacked' } });
    # R26 fallback: the old "attack the nearest other than you" (Crown of Madness boosts), applied by Osiris only
    # while nobody has hurt the angry creature yet. R27: the ally whose blow Trust shares (vanilla WARDING_BOND boosts).
    push @out, status_entry('RESONANT_ANGER_FALLBACK', 'Lashing Out', 'Angry with no one to blame: attacks the nearest creature, other than the spellcaster.',
        $EMO{Anger}{icon}, 'I', { stack => 'RESONANT_ANGER_FALLBACK',
        boosts => 'CannotHarmCauseEntity(CannotHarmMadness);ActionResourceBlock(ReactionActionPoint);AiArchetypeOverride(madness,99);Tag(AI_UNPREFERRED_TARGET);DetectDisturbancesBlock(true)',
        extra => { StatusPropertyFlags => 'LoseControl', StatusGroups => 'SG_Mad' } });
    push @out, status_entry('RESONANT_TRUST_SHOULDERED', 'Shouldered', tag_terms('Resistant to the blow an ally is sharing with it.'),
        $EMO{Trust}{icon}, 'A', { boosts => 'Resistance(All, Resistant);RedirectDamage(1)', stack => 'RESONANT_TRUST_SHOULDERED',
        extra => { RemoveEvents => 'OnAttacked' } });
    push @out, status_entry('RESONANT_GRUDGE', 'Grudge', 'Bears a grudge against whoever hurt it last and attacks them.',
        $EMO{Anger}{icon}, 'I', { stack => 'RESONANT_GRUDGE',
        extra => { StatusPropertyFlags => 'LoseControl;OverheadOnTurn;LoseControlFriendly', StatusGroups => 'SG_Taunted' } });
    push @out, status_entry('CATHARSIS', 'Catharsis',
        'Opposing emotions, snapped at once. Every mood is spent.',
        'Spell_Enchantment_CalmEmotions', 'mood', { stack => 'CATHARSIS',
        onapply => join(';', map { 'RemoveStatus(' . mood_id($_) . ')' } @WHEEL) });
    if (at(4)) {   # R62/R67: the dice states grow (the entry, not its text)
        my %g = map { $_ => 1 } @GROWING;
        for my $e (@out) { my ($n) = $e->[1] =~ /^new entry "([^"]+)"/; $e->[1] = grow($e->[1]) if $n && $g{$n} }
    }
    @out;
}

sub hidden_status {
    my ($id, $name, $field, $functors) = @_;
    ['Status_BOOST', entry($id, 'StatusData', StatusType => 'BOOST', DisplayName => loca(key($id, 'NAME'), $name),
        StackId => $id, StatusPropertyFlags => 'DisableOverhead;DisableCombatlog;DisablePortraitIndicator', $field => $functors)];
}

our $OVERLOAD_SPELL = 'Target_Arcana_Created_EmotionalOverload';

sub build_passives {
    my $love = st_tag('FEELING_LOVE', 'Love'); my $catharsis = st_tag('CATHARSIS', 'Catharsis');
    my $out = '';
    $out .= at(4)   # R49, R57, R60: Catharsis moves to Opposites (level 3)
        ? passive('Arcana_Passive_EmotionalAlchemy', 'Emotional Alchemy',
            "When your Weave Surge touches a creature that already carries a mood, the threads react instead of surging, and the mood is spent. Only an emotion that fades on its own leaves a mood.<br><br>Neighbouring emotions braid into a feeling, such as $love, that lasts $FEELING_TURNS turns.<br><br>When your Weave Surge causes a reaction, you regain the spell slot it used. Once per turn.<br><br>Weave Surges cast for you never braid a hindering feeling into an ally.",
            'Spell_Enchantment_CalmEmotions')
          . passive('Arcana_Passive_Opposites', 'Opposites',
            "A Weave Surge poured into the mood of its opposite emotion snaps into $catharsis: an enemy takes [1] and an ally regains [2], and the mood is spent.",
            'Spell_Enchantment_CalmEmotions', DescriptionParams => "DealDamage($CATHARSIS_DICE,Psychic);RegainHitPoints($CATHARSIS_DICE)")
          . join('', map { passive("Arcana_Passive_DeeperFeelings_$_", 'Deeper Feelings',   # R62: the growth, announced at 5 and 9
            'Your moods and feelings grow stronger.', 'Spell_Enchantment_Bless') } 5, 9)
        : passive('Arcana_Passive_EmotionalAlchemy', 'Emotional Alchemy',
        "When your Weave Surge touches a creature that already carries a mood, the threads react instead of surging, and the mood is spent.<br><br>Neighbouring emotions braid into a feeling, such as $love, that lasts $FEELING_TURNS turns.<br><br>Opposing emotions snap into $catharsis: an enemy takes [1] and an ally regains [2].<br><br>When your Weave Surge causes a reaction, you regain the spell slot it used. Once per turn.",
        'Spell_Enchantment_CalmEmotions', DescriptionParams => "DealDamage($CATHARSIS_DICE,Psychic);RegainHitPoints($CATHARSIS_DICE)");
    $out .= at(2)   # ARC-0017 stage 2 (R51, R53, R66): no silence; the free cast of Emotional Overload rides on this passive
        ? passive('Arcana_Passive_Overload', 'Overload',
            'You feel what you make others feel. Each emotion that takes hold fills your Overload a little, and each reaction fills it more. At 100% you become Overloaded, and Emotional Overload pours it out. After a fight, your Overload settles to half.',
            'Spell_Enchantment_CalmEmotions', Boosts => "UnlockSpellVariant(" . join(' or ', map { "SpellId('$_')" } $OVERLOAD_SPELL, map { "${OVERLOAD_SPELL}_$_" } 2 .. 6) . ",ModifyUseCosts(Replace,ArcanaSpellSlot,0,-1,ArcanaSpellSlot),ModifyUseCosts(Replace,SpellSlotsGroup,0,-1,SpellSlotsGroup))")
        : passive('Arcana_Passive_Overload', 'Overload',
        'You feel what you make others feel. Each emotion that takes hold fills your Overload a little, and each reaction fills it more; it carries over from one fight to the next. At 100% you become Overloaded: you can\'t cast spells, your weapon attacks deal extra Psychic damage, and you take Psychic damage each turn, for a number of turns equal to your level. From level 5, Emotional Overload ends it at once.',
        'Spell_Enchantment_CalmEmotions');
    $out .= passive('Arcana_Passive_EmpathicSight', 'Empathic Sight',
        tag_terms('You read the threads of feeling in others. You have Advantage on Insight checks.'),
        'Spell_Divination_SeeInvisibility', Boosts => 'Advantage(Skill,Insight)');
    $out .= passive('Arcana_Passive_ComplexFeelings', 'Complex Feelings',
        'Emotions two steps apart on the wheel now braid into complex feelings, such as ' . st_tag('FEELING_HOPE', 'Hope') . ' or ' . st_tag('FEELING_DESPAIR', 'Despair') . '.',
        'Spell_Enchantment_Bless');
    $out .= passive('Arcana_Passive_Overwhelm', 'Overwhelm',
        'A Weave Surge on a creature whose mood echoes the same emotion pulls the thread tight into its overwhelming form, such as ' . st_tag('EMOTION_ECSTASY', 'Ecstasy') . ' or ' . st_tag('EMOTION_TERROR', 'Terror') . '.',
        'Spell_Illusion_PhantasmalKiller');
    $out .= passive('Arcana_Passive_MixedFeelings', 'Mixed Feelings',
        'Emotions three steps apart on the wheel now braid into mixed feelings, such as ' . st_tag('FEELING_DELIGHT', 'Delight') . ' or ' . st_tag('FEELING_SHAME', 'Shame') . '.',
        'Spell_Enchantment_Confusion');
    # Hidden passives that Remorse and Morbidness grant. The 1-turn technical status is the once-per-turn lock
    # and also stops the loop of the creature's own damage triggering the passive again.
    for my $p (['Remorse', 'FEELING_REMORSE_TECH', ''], ['Morbidness', 'FEELING_MORBIDNESS_TECH', 'IsWeaponAttack() and ']) {
        my ($n, $tech, $cond) = @$p;
        $out .= entry("Arcana_Passive_Feeling$n", 'PassiveData', DisplayName => loca(key("Arcana_Passive_Feeling$n", 'NAME'), $n),
            Properties => 'IsHidden', StatsFunctorContext => 'OnDamage',
            Conditions => "${cond}not HasStatus('$tech', context.Source)",
            StatsFunctors => "ApplyStatus(SELF,$tech,100,1)");
    }
    $out;
}

sub passive {
    my ($id, $name, $desc, $icon, %x) = @_;
    entry($id, 'PassiveData', DisplayName => loca(key($id, 'NAME'), $name), Description => loca(key($id, 'DESC'), $desc),
        DescriptionParams => $x{DescriptionParams}, Icon => $icon, Boosts => $x{Boosts},
        Properties => 'Highlighted');   # Owner rule: a passive the player should see is Highlighted (shows on the sheet)
}

# Animation, sounds and effects: Crown of Madness (what Fury already used), the same on all 8.
our @CAST = (
    PrepareSound => 'Spell_Prepare_Control_Gen_L1to3_01', PrepareLoopSound => 'Spell_Prepare_Control_Gen_L1to3_01_Loop',
    CastSound => 'Spell_Cast_Control_CrownOfMadness_L1to3', TargetSound => 'Spell_Impact_Control_CrownOfMadness_L1to3',
    VocalComponentSound => 'Vocal_Component_Confuse',
    SpellAnimation => '554a18f7-952e-494a-b301-7702a85d4bc9,,;,,;0149cfd3-d80f-4ce8-8cf7-234e0864ba46,,;1c58959b-8cb1-491d-89b7-2a7d0a593215,,;22dfbbf4-f417-4c84-b39e-2039315961e6,,;,,;5bfbe9f9-4fc3-4f26-b112-43d404db6a89,,;,,;,,',
    PrepareEffect => '2fa6b127-6f8a-4150-8be6-6f62b7a85911', CastEffect => '4ca6a918-a46b-4269-b11b-d98fb6694677',
    TargetEffect => '4b5dc428-d623-4203-a7f0-a86c47bf9aa8',
);

# The Surge's ExtraDescription: one line per reaction, "Label (level N): Mood into Result." (the Owner's format,
# 2026-10-12: easier to see what gives what). The refund is told by Emotional Alchemy, not here.
our @REACTION_LINES = ([0, 'Intense'], [1, 'Primary'], [2, 'Secondary'], [3, 'Tertiary'], [4, 'Catharsis']);
sub result_name { my ($s, $m, $r) = @_;
    $r->{kind} eq 'catharsis' ? 'Catharsis' : $r->{kind} eq 'intensify' ? $EMO{$s}{intense}{name} : feeling_of($s, $m)->{name} }
# R59: Complex Feelings arrives at 6 from stage 4
sub gate_level { my $g = shift; at(4) && $g eq 'Arcana_Passive_ComplexFeelings' ? 6 : $GATE_LEVEL{$g} }
# R64: a mood says what each emotion would make of it (names only; the effect is one hover away)
sub mood_reactions { my $m = shift;
    'Poured into it: ' . join('; ', map { my $s = $_; my $r = reaction($s, $m);
        "$s makes " . st_tag($r->{status}, result_name($s, $m, $r)) . ($r->{gate} ? ' (level ' . gate_level($r->{gate}) . ')' : '') } @WHEEL) . '.' }
sub reaction_list {
    my $s = shift;
    my @lines;
    for my $l (@REACTION_LINES) {
        my ($d, $label) = @$l;
        my $gate = $GATE{$d};
        my $head = $gate ? "$label (level " . gate_level($gate) . ")" : $label;
        push @lines, map { my $r = reaction($s, $_);
            "$head: " . st_tag(mood_id($_), $EMO{$_}{mood}{name}) . ' into ' . st_tag($r->{status}, result_name($s, $_, $r)) . '.' }
            grep { distance($s, $_) == $d } @WHEEL;
    }
    join('', map { "$_<br>" } @lines);
}

our $WEAVE_SURGE = 'Target_Arcana_Card_Spell_WeaveSurge';
# the level each emotion is learnt at: R59 from stage 4 (Anticipation at 2), the ARC-0002 map before it
sub unlock_level { my $e = shift; my %u = (Joy => 1, Trust => 1, Fear => 1, Anticipation => (at(4) ? 2 : 3), Surprise => 3, Sadness => 3, Disgust => 5, Anger => 5); $u{$e} }

sub build_spells {
    my $out = '';
    for my $e (@WHEEL) {
        my $E = $EMO{$e}; my $dark = $E->{side} eq 'I';
        my $desc = tag_terms("$E->{flavour} $E->{effect}" . ($e eq 'Anger' && at(4) ? ' Strike it first to draw its rage.' : '') . "<br><br>When the surge fades, it leaves the target "
                 . st_tag(mood_id($e), $E->{mood}{name}) . " for $MOOD_TURNS turns, $E->{mood}{fx}.");
        $out .= entry(spell_id($e), 'SpellData',
            SpellType => 'Target', Level => 1, SpellSchool => 'Enchantment', TargetRadius => 18, AmountOfTargets => 1,
            SpellRoll => 'SpellAutoResolveOnAlly(Ability.Wisdom,SourceSpellDC(),true)',   # the Owner's Toolkit edit, vanilla Spell_Target pattern: allies never roll
            SpellSuccess => spell_success($e),
            SpellFail => 'ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL,100,0)',
            TargetConditions => target_conditions($e),
            Icon => $E->{icon},
            DisplayName => loca(key(spell_id($e), 'NAME'), at(3) ? $e : "Weave Surge: $e"),   # R54: named by the emotion inside the container
            Description => loca(key(spell_id($e), 'DESC'), $desc),
            DescriptionParams => $E->{mood}{params},
            ExtraDescription => loca(key(spell_id($e), 'EXTRA'), reaction_list($e)),
            TooltipAttackSave => 'Wisdom',
            TooltipStatusApply => 'ApplyStatus(' . peak_id($e) . ',100,1)',
            TooltipPermanentWarnings => $SURGE_WARNING,
            @CAST,
            PreviewCursor => 'Cast', CastTextEvent => 'Cast',
            CycleConditions => $dark ? 'Enemy() and not Dead()' : 'Ally() and not Dead()',
            UseCosts => 'ActionPoint:1;SpellSlotsGroup:1:1:1',
            VerbalIntent => $dark ? 'Control' : 'Buff', SpellStyleGroup => 'Class',
            SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent;HasHighGroundRangeExtension' . ($dark ? ';IsHarmful' : ''),
            HitAnimationType => $dark ? 'None' : 'MagicalNonDamage', MemoryCost => 1,
            # R54: a child of the Weave Surge container (Hemoplague's children); R59: it opens at the level it is learnt (probe B6)
            (at(3) ? (SpellContainerID => $WEAVE_SURGE, ContainerSpells => '',
                RequirementConditions => (unlock_level($e) > 1 ? "ClassLevelHigherOrEqualThan(" . unlock_level($e) . ",'Arcana')" : undef)) : ()));
    }
    $out .= weave_surge_container() if at(3);
    $out;
}

# ARC-0017 stage 3 (R54): one container for the eight emotions -- the Hemoplague pattern (ContainerSpells + IsLinkedSpellContainer)
sub weave_surge_container {
    entry($WEAVE_SURGE, 'SpellData', SpellType => 'Target', Level => 1, SpellSchool => 'Enchantment', TargetRadius => 18,
        ContainerSpells => join(';', map { spell_id($_) } @WHEEL),
        # no Surge marker: IsWeaveSurge() reads the emotions (the ones cast), never the container (probe B6: Tier II through it)
        TargetConditions => "Character() and not Dead() and not Tagged('CONSTRUCT') and not HasPassive('ARCANA_IS_CARD', context.Source)", Icon => $EMO{Joy}{icon},
        DisplayName => loca(key($WEAVE_SURGE, 'NAME'), 'Weave Surge'),
        Description => loca(key($WEAVE_SURGE, 'DESC'), "Pour an emotion into a creature's Weave. Choose the emotion."),
        PreviewCursor => 'Cast', CastTextEvent => 'Cast', UseCosts => 'ActionPoint:1;SpellSlotsGroup:1:1:1',
        VerbalIntent => 'Control', SpellStyleGroup => 'Class',
        SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent;IsLinkedSpellContainer', MemoryCost => 1);
}

# ---------------------------------------------------------------- what the game already has (read only)
sub slurp { my $p = shift; open my $h, '<:raw', $p or return ''; local $/; my $s = <$h>; close $h; $s =~ s/\r\n/\n/g; $s }
sub data_dir { "$G/Public/$M/Stats/Generated/Data" }
# name => file (no .txt) for every entry in the mod
sub existing_entries {
    my %where;
    opendir my $d, data_dir() or return {};
    for my $f (grep { /\.txt$/ } readdir $d) {
        (my $base = $f) =~ s/\.txt$//;
        my $s = slurp(data_dir() . "/$f");   # read once: a fresh string in the loop condition would never end
        $where{$1} = $base while $s =~ /^new entry "([^"]+)"/mg;
    }
    \%where;
}

# What goes: every old Emotion*/Feeling* spell (and its upcast variants) and every EMOTION_/MOOD_/FEELING_ status
# that is not in the new set or that moved to another file. Never removed: the upcast variants of the current
# Surges (spell_id($e) . "_2" .. "_6" for every $e in @WHEEL); gen_upcast_variants.pl owns those.
# Generated once, then replaced: the Trust follow-up (R27, never published), Temper's two sides and their Osiris
# hand-off (R36: one spell now), Read the Room (R37: Empathic Sight already covers Insight), the DEBUG scaffold
# (stage 7: everything arrives by the progression; the entries are in 90_ARCHIVE).
our %RETIRED = map { $_ => 1 } qw(Interrupt_Arcana_TrustFollowUp
    Target_Arcana_Card_Spell_Temper_Left Target_Arcana_Card_Spell_Temper_Right RESONANT_TEMPER_LEFT_TECH RESONANT_TEMPER_RIGHT_TECH
    Shout_Arcana_Util_ReadTheRoom RESONANT_READ_THE_ROOM Shout_Arcana_Util_DEBUG_Resonant RESONANT_DEBUG
    RESONANT_SHARED_REFUND_TECH);   # R46: Shared Heart no longer makes Surges free
sub removals {
    my ($have, $new) = @_;   # $new: name => file
    # the variants of every card generated here (Emotional Contagion also matches the old Emotion* pattern)
    my %ours = map { my $e = $_; map { ("${e}_$_" => 1) } 2 .. 6 } (map { spell_id($_) } @WHEEL), grep { /^\w+_Arcana_Card_/ } keys %$new;
    my @rm;
    for my $n (sort keys %$have) {
        next if $ours{$n};
        next unless $n =~ /^Target_Arcana_Card_Spell_(?:Emotion|Feeling)\w*$/ || $n =~ /^(?:EMOTION|MOOD|FEELING)_\w+$/ || $RETIRED{$n};
        push @rm, [$have->{$n}, $n] unless ($new->{$n} // '') eq $have->{$n};
    }
    @rm;
}

sub names_in { my $s = shift; my @n = $s =~ /^new entry "([^"]+)"/mg; @n }

# Status files in output order, and the divider new entries go under ("-" = end of file).
our @STATUS_FILES = (['Status_BOOST', 'ARCANA STATUS'], ['Status_FEAR', '-'], ['Status_INCAPACITATED', '-']);

# Interrupts. Shoulder (R27): OnPreDamage, Nearby, Ally(context.Target,context.Observer) and not Self(...) (vanilla
# Interrupt_ProjectedWard), IsAttack() + HasDamageEffectFlag (Interrupt_ShieldMaster), DistanceToEntityGreaterThan
# (Interrupt_MAG_Cunning_Combo_HandCrossbow), ApplyStatus(OBSERVER_TARGET,...) (Interrupt_DampenElements).
# Guard: OnEnterAttackRange, Self, UseAttack(), Stack AttackOfOpportunity (vanilla Interrupt_PolearmMaster).
sub build_interrupts {
    my $r = master('STA_Resonant_Peaks', 'trust_shoulder_range')->{value};
    entry('Interrupt_Arcana_TrustShoulder', 'InterruptData',
        DisplayName => loca(key('Interrupt_Arcana_TrustShoulder', 'NAME'), 'Shoulder to Shoulder'),
        Description => loca(key('Interrupt_Arcana_TrustShoulder', 'DESC'), 'When a nearby ally is hit by an attack, share the blow: the ally is Resistant to it, and you take the same damage.'),
        Icon => $EMO{Trust}{icon}, InterruptContext => 'OnPreDamage', InterruptContextScope => 'Nearby', Container => 'YesNoDecision',
        Conditions => "IsAbleToReact(context.Observer) and Ally(context.Target,context.Observer) and not Self(context.Target,context.Observer) and IsAttack() and HasDamageEffectFlag(DamageFlags.Hit) and not DistanceToEntityGreaterThan($r, context.ObserverPosition, context.Target) and not AnyEntityIsItem()",
        Properties => 'ApplyStatus(OBSERVER_TARGET,RESONANT_TRUST_SHOULDERED,100,1)', Cost => 'ReactionActionPoint:1', InterruptDefaultValue => 'Ask;Enabled')
  . entry('Interrupt_Arcana_AnticipationGuard', 'InterruptData',
        DisplayName => loca(key('Interrupt_Arcana_AnticipationGuard', 'NAME'), 'On Guard'),
        Description => loca(key('Interrupt_Arcana_AnticipationGuard', 'DESC'), 'When an enemy enters your reach, attack it first.'),
        Icon => $EMO{Anticipation}{icon}, InterruptContext => 'OnEnterAttackRange', InterruptContextScope => 'Self', Container => 'YesNoDecision',
        Conditions => 'Self(context.Source,context.Observer) and IsAbleToReact(context.Observer) and Enemy() and not AnyEntityIsItem()',
        Properties => 'UseAttack()', Cost => 'ReactionActionPoint:1', Stack => 'AttackOfOpportunity', InterruptDefaultValue => 'Ask;Enabled');
}
sub build_engine_patch {
    @LOCA = ();
    my ($compassion, $compassion_status, $compassion_interrupt, $compassion_used, $kind_trust) = build_compassion();
    my ($contagion, $contagion_status) = build_contagion();
    my $spells   = build_spells() . build_overload_spell() . build_heartstring() . build_temper() . $contagion . $kind_trust;
    my ($aspect_statuses, $aspect_passives, $two_cups) = build_aspect();
    my ($shared_heart, $shared_statuses) = build_shared_heart();
    my @statuses = (build_statuses(), $compassion_status, $contagion_status, @$aspect_statuses, @$shared_statuses, $compassion_used);
    my $passives = build_passives() . $aspect_passives;
    my $shout = '';
    $shout .= $compassion . $two_cups . $shared_heart;
    my $interrupts = build_interrupts() . $compassion_interrupt;
    my %new;
    $new{$_} = 'Interrupt' for names_in($interrupts);
    $new{$_} = 'Spell_Target' for names_in($spells);
    for my $st (@statuses) { $new{$_} = $st->[0] for names_in($st->[1]) }
    $new{$_} = 'Passive' for names_in($passives);
    $new{$_} = 'Spell_Shout' for names_in($shout);
    my %known = map { $_->[0] => 1 } @STATUS_FILES;
    $known{$_->[0]} or die "status file $_->[0] has no place in \@STATUS_FILES\n" for @statuses;
    my @rm = removals(existing_entries(), \%new);

    my $p = "# GENERATED by tools/stats/gen_emotion_alchemy.pl -- do not edit by hand.\n"
          . "# Spec: 20_GAME_DESIGN/21_GDD_Arcana_Class/21.04_Subclasses/Resonant/2026-10-11-resonant-design.md\n\n";
    $p .= "\@loca $_->[0] $_->[1]\n" for @LOCA;
    my %byfile; push @{ $byfile{$_->[0]} }, $_->[1] for @rm;
    for my $f (sort keys %byfile) { $p .= "\n\@file $f\n"; $p .= "\@remove $_\n" for @{ $byfile{$f} } }
    $p .= "\n\@file Spell_Target\n\@section Target_ARCANA SPELLS\n\n$spells";
    $p .= "\@file Spell_Shout\n\@section Shout_DEBUG SPELLS\n\n$shout";
    for my $sf (@STATUS_FILES) {
        my ($file, $section) = @$sf;
        my $body = join '', map { $_->[1] } grep { $_->[0] eq $file } @statuses;
        $p .= "\@file $file\n\@section $section\n\n$body";
    }
    $p .= "\@file Passive\n\@section ARCANA PASSIVES\n\n$passives";
    $p .= "\@file Interrupt\n\@section -\n\n$interrupts";
    $p;
}

# +1 target per variant level, only for variants that already exist (gen_upcast_variants makes them).
sub build_upcast_patch {
    my $have = shift // existing_entries();
    my $p = "# GENERATED by tools/stats/gen_emotion_alchemy.pl -- do not edit by hand.\n"
          . "# Run AFTER gen_upcast_variants.pl --apply: +1 target per slot level.\n\n\@file Spell_Target\n";
    my $n = 0;
    for my $e (@WHEEL) { for my $L (2 .. 6) {
        my $v = spell_id($e) . "_$L";
        next unless ($have->{$v} // '') eq 'Spell_Target';
        $p .= "\@set $v AmountOfTargets $L\n"; $n++ } }
    if (at(2)) {   # ARC-0017 R67: Emotional Overload ranks by slot variant -- 1 target (1-2), 2 (3-4), the area from 5 (probe B5)
        my $r3 = master('SPL_Resonant_EmotionalOverload', 'rank3_radius_next')->{value};
        for my $L (2 .. 6) {
            my $v = "${OVERLOAD_SPELL}_$L";
            next unless ($have->{$v} // '') eq 'Spell_Target';
            $p .= $L <= 4 ? "\@set $v AmountOfTargets " . ($L <= 2 ? 1 : 2) . "\n" : "\@set $v AreaRadius $r3\n"; $n++ }
    }
    ($p, $n);
}

sub write_file { my ($path, $s) = @_; make_path(dirname($path)); open my $h, '>:raw', $path or die "$path: $!"; print $h $s; close $h }

# ---------------------------------------------------------------- stage 2: the ultimate and the Overload counter
# Emotional Overload (R9, R10, R20, R22): only with the meter full, no save, no slot. Created: never in the deck.
# Paralysis: vanilla PARALYZED (INCAPACITATED, no RemoveConditions). Numbers: 25 SPL_Resonant_EmotionalOverload.
sub build_overload_spell {
    return build_overload_spell2() if at(2);
    my $id = 'Target_Arcana_Created_EmotionalOverload';
    my $dmg = master('SPL_Resonant_EmotionalOverload', 'damage_per_feeling')->{value};
    my $turns = master('SPL_Resonant_EmotionalOverload', 'paralysed')->{value};
    my @feel = map { 'FEELING_' . uc $FEELING{$_}{name} } sort { $FEELING{$a}{name} cmp $FEELING{$b}{name} } keys %FEELING;
    my $success = join ';', (map { "IF(HasStatus('$_')):DealDamage($dmg,Psychic,Magical);IF(HasStatus('$_')):RemoveStatus($_)" } @feel),
        "ApplyStatus(PARALYZED,100,$turns)", 'ApplyStatus(SELF,RESONANT_OVERLOAD_SPENT_TECH,100,0)';
    entry($id, 'SpellData',
        SpellType => 'Target', Level => 0, SpellSchool => 'Enchantment',
        TargetRadius => master('SPL_Resonant_EmotionalOverload', 'range')->{value}, AmountOfTargets => 1,
        SpellSuccess => $success,
        TargetConditions => "Character() and not Dead() and not Ally() and not Self() and not Tagged('CONSTRUCT') and not HasPassive('ARCANA_IS_SPELL', context.Source)",   # Arcana spell mark: detonates the Sigil (check_cards)
        # P8: a requirement greys the action out until the caster is Overloaded (vanilla HasStatus('SG_Rage'));
        # as a target condition it only filtered targets, so it looked castable
        RequirementConditions => "HasStatus('RESONANT_OVERLOAD_FULL')",
        Icon => 'Spell_Enchantment_CalmEmotions',
        DisplayName => loca(key($id, 'NAME'), 'Emotional Overload'),
        Description => loca(key($id, 'DESC'), tag_terms("Pour everything you have felt this fight into one creature. Every feeling it carries tears at it for [1] Psychic damage and is spent, and it is Paralysed for $turns turns. No saving throw.")),
        DescriptionParams => "DealDamage($dmg,Psychic)",
        TooltipStatusApply => "ApplyStatus(PARALYZED,100,$turns)",
        @CAST, PreviewCursor => 'Cast', CastTextEvent => 'Cast',
        CycleConditions => 'Enemy() and not Dead()', UseCosts => 'BonusActionPoint:1',   # R48: a bonus action
        VerbalIntent => 'Control', SpellStyleGroup => 'Class',
        SpellFlags => 'HasSomaticComponent;IsHarmful', HitAnimationType => 'None');   # R29: not a spell -- usable while silenced
}

# ARC-0017 stage 2 (R51, R66, R67, R68): a level-1 slot spell made free by the Overload passive, a Wisdom save; the
# feelings are spent either way (half damage on a save); a failed save dances (vanilla IRRESISTIBLE_DANCE, 2 turns at
# Tier III); Mental Fatigue either way through a marker (Osiris sets the duration). Ranks by variant: build_upcast_patch.
sub build_overload_spell2 {
    my $id = $OVERLOAD_SPELL;
    my $dmg = master('SPL_Resonant_EmotionalOverload', 'damage_per_feeling')->{value};
    my $dance = plain(master('SPL_Resonant_EmotionalOverload', 'dance_next')->{value});
    my $dance3 = plain(master('SPL_Resonant_EmotionalOverload', 'dance_tier3_next')->{value});
    my $t3 = "HasStatus('${AWAKENED}_III', context.Source)";
    my @feel = map { 'FEELING_' . uc $FEELING{$_}{name} } sort { $FEELING{$a}{name} cmp $FEELING{$b}{name} } keys %FEELING;
    my $spend = sub { my $d = shift; join ';', map { "IF(HasStatus('$_')):DealDamage($d,Psychic,Magical);IF(HasStatus('$_')):RemoveStatus($_)" } @feel };
    my $end = 'ApplyStatus(RESONANT_FATIGUE_TECH,100,0);ApplyStatus(SELF,RESONANT_OVERLOAD_SPENT_TECH,100,0)';
    entry($id, 'SpellData',
        SpellType => 'Target', Level => 1, SpellSchool => 'Enchantment',
        TargetRadius => master('SPL_Resonant_EmotionalOverload', 'range')->{value}, AmountOfTargets => 1,
        SpellRoll => 'not SavingThrow(Ability.Wisdom, SourceSpellDC())',
        SpellSuccess => join(';', $spend->($dmg), "IF(not $t3):ApplyStatus(IRRESISTIBLE_DANCE,100,$dance)", "IF($t3):ApplyStatus(IRRESISTIBLE_DANCE,100,$dance3)", $end),
        SpellFail => join(';', $spend->("($dmg)/2"), $end),
        TargetConditions => "Character() and not Dead() and not Ally() and not Self() and not Tagged('CONSTRUCT') and not HasPassive('ARCANA_IS_SPELL', context.Source)",
        RequirementConditions => "HasStatus('RESONANT_OVERLOAD_FULL')",
        Icon => 'Spell_IntellectDevourer_SynapticDischarge',
        DisplayName => loca(key($id, 'NAME'), 'Emotional Overload'),
        Description => loca(key($id, 'DESC'), tag_terms("Pour everything you feel into a creature's mind. Every feeling it carries is spent. If it fails a Wisdom Saving Throw, each feeling deals [1] and it dances helplessly for $dance turn; if it succeeds, each feeling deals half. Either way it suffers Mental Fatigue. Ends Overloaded.")),
        DescriptionParams => "DealDamage($dmg,Psychic)",
        TooltipStatusApply => "ApplyStatus(IRRESISTIBLE_DANCE,100,$dance)", TooltipAttackSave => 'Wisdom',
        @CAST, PreviewCursor => 'Cast', CastTextEvent => 'Cast',
        CycleConditions => 'Enemy() and not Dead()', UseCosts => 'BonusActionPoint:1;SpellSlotsGroup:1:1:1',
        VerbalIntent => 'Control', SpellStyleGroup => 'Class',
        SpellFlags => 'HasSomaticComponent;IsHarmful', HitAnimationType => 'MagicalNonDamage');   # not a spell: no IsSpell
}

# The Overload counter (R12): +1 per peak that lands, +2 per reaction, size by level (25: FEAT_Resonant_Overload).
# Generated from the wheel table so the status lists never drift. Patterns: ARCANA_Aspect_Common.txt (tables
# rebuilt in Init + SavegameLoaded, count shown as a frozen duration of N x 6 s, IntegerSum / IntegerToReal).
sub overload_goal {
    my $peak  = master('FEAT_Resonant_Overload', 'fill_peak')->{value};
    my $react = master('FEAT_Resonant_Overload', 'fill_reaction')->{value};
    my $by = master('FEAT_Resonant_Overload', 'size')->{by_level};
    my @th = sort { $a <=> $b } keys %$by;
    my @rows;
    push @rows, map { qq{DB_ARCANA_Resonant_OverloadPoints("} . peak_id($_) . qq{", $peak);} } @WHEEL;
    push @rows, map { qq{DB_ARCANA_Resonant_OverloadPoints("} . intense_id($_) . qq{", $react);} } @WHEEL;
    push @rows, map { qq{DB_ARCANA_Resonant_OverloadPoints("FEELING_} . uc($FEELING{$_}{name}) . qq{", $react);} } sort keys %FEELING;
    push @rows, qq{DB_ARCANA_Resonant_OverloadPoints("CATHARSIS", $react);};
    # R16: the statuses that are a reaction -- each refunds the Surge's slot (once per turn, RESONANT_REFUND_USED)
    push @rows, map { qq{DB_ARCANA_Resonant_Reaction("$_");} } (map { intense_id($_) } @WHEEL),
        (map { 'FEELING_' . uc $FEELING{$_}{name} } sort keys %FEELING), 'CATHARSIS';
    for my $L (1 .. 20) { my ($t) = grep { $_ <= $L } reverse @th; $t //= $th[0]; push @rows, "DB_ARCANA_Resonant_OverloadMax($L, $by->{$t});" }
    my @clear2;
    if (at(2)) {   # ARC-0017 stage 2: the statuses a landed Surge leaves (a status applied = the save failed), and the rider bands
        push @rows, map { qq{DB_ARCANA_Resonant_Landed("$_");} } (map { (peak_id($_), intense_id($_)) } @WHEEL),
            (map { 'FEELING_' . uc $FEELING{$_}{name} } sort keys %FEELING), 'CATHARSIS';
        my @rb = bands(master('FEAT_Resonant_Overload', 'overloaded_tick_next')->{by_level});
        for my $L (1 .. 20) { my ($b) = grep { $L >= $_->[0] } reverse @rb; push @rows, qq{DB_ARCANA_Resonant_RiderBand($L, "RESONANT_RIDER_TECH_$b->[0]");} }
        @clear2 = map { ('PROC', 'PROC_ARCANA_Resonant_Overload_Init()', 'AND', $_->[0], 'THEN', "NOT $_->[0];", '') }
            ['DB_ARCANA_Resonant_Landed(_Status)'], ['DB_ARCANA_Resonant_RiderBand(_Lvl, _Tech)'];
    }
    my $g = join "\n", 'Version 1', 'SubGoalCombiner SGC_AND', 'INITSECTION', 'PROC_ARCANA_Resonant_Overload_Init();', '', 'KBSECTION',
        '//REGION Resonant - Overload tables (GENERATED by gen_emotion_alchemy.pl -- do not edit by hand)',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Init()', 'AND', 'DB_ARCANA_Resonant_OverloadPoints(_Status, _Pts)', 'THEN', 'NOT DB_ARCANA_Resonant_OverloadPoints(_Status, _Pts);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Init()', 'AND', 'DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max)', 'THEN', 'NOT DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Init()', 'AND', 'DB_ARCANA_Resonant_Reaction(_Status)', 'THEN', 'NOT DB_ARCANA_Resonant_Reaction(_Status);', '',
        @clear2,
        'PROC', 'PROC_ARCANA_Resonant_Overload_Init()', 'THEN', @rows, '',
        'IF', 'SavegameLoaded()', 'THEN', 'PROC_ARCANA_Resonant_Overload_Init();', '//END_REGION', '',
        '//REGION Resonant - refund (R16): a reaction gives the Surge\'s slot back; RESONANT_REFUND_TECH holds the once-per-turn guard',
        'IF', 'StatusApplied(_Target, _Status, (CHARACTER)_Resonant, _)', 'AND', 'DB_ARCANA_Resonant_Reaction(_Status)',
        'AND', 'HasPassive(_Resonant, "Arcana_Passive_EmotionalAlchemy", 1)', 'THEN', 'ApplyStatus(_Resonant, "RESONANT_REFUND_TECH", 0.0, 1, _Resonant);', '//END_REGION', '',
        '//REGION Resonant - Overload count: +1 per peak that lands, +2 per reaction, at any time; it carries over between combats (R12, R31)',
        'IF', 'StatusApplied(_Target, _Status, (CHARACTER)_Resonant, _)', 'AND', 'DB_ARCANA_Resonant_OverloadPoints(_Status, _Pts)',
        'AND', 'HasPassive(_Resonant, "Arcana_Passive_Overload", 1)', 'AND', 'NOT DB_ARCANA_Resonant_OverloadFull(_Resonant)',
        'THEN', 'PROC_ARCANA_Resonant_Overload_Add(_Resonant, _Pts);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Add((CHARACTER)_Resonant, (INTEGER)_Pts)', 'AND', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _)', 'THEN', 'DB_ARCANA_Resonant_Overload(_Resonant, 0);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Add((CHARACTER)_Resonant, (INTEGER)_Pts)', 'AND', 'DB_ARCANA_Resonant_Overload(_Resonant, _Old)',
        'AND', 'IntegerSum(_Old, _Pts, _New)', 'AND', 'GetLevel(_Resonant, _Lvl)', 'AND', 'DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max)',
        'THEN', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _Old);', 'PROC_ARCANA_Resonant_Overload_Set(_Resonant, _New, _Max, _Lvl);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Set((CHARACTER)_Resonant, (INTEGER)_New, (INTEGER)_Max, (INTEGER)_Lvl)', 'AND', '_New < _Max',
        'THEN', 'DB_ARCANA_Resonant_Overload(_Resonant, _New);', 'PROC_ARCANA_Resonant_Overload_Show(_Resonant, _New, _Max);', '',
        '// R29: full -> Overloaded for turns equal to the character level (ApplyStatus duration is in seconds, 6 per turn)',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Set((CHARACTER)_Resonant, (INTEGER)_New, (INTEGER)_Max, (INTEGER)_Lvl)', 'AND', '_New >= _Max',
        'AND', 'IntegerProduct(_Lvl, 6, _Secs)', 'AND', 'IntegerToReal(_Secs, _Dur)',
        'THEN', 'DB_ARCANA_Resonant_Overload(_Resonant, _Max);', 'DB_ARCANA_Resonant_OverloadFull(_Resonant);',
        'RemoveStatus(_Resonant, "RESONANT_OVERLOAD", _Resonant);', 'ApplyStatus(_Resonant, "RESONANT_OVERLOAD_FULL", _Dur, 1, _Resonant);', '',
        '// R31: the meter shows the percentage of its maximum (1-99), as the PERCENT mode of ARCANA_Aspect_Common',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Show((CHARACTER)_Resonant, (INTEGER)_N, (INTEGER)_Max)',
        'AND', 'IntegerProduct(_N, 100, _N100)', 'AND', 'IntegerDivide(_N100, _Max, _Pct)', 'AND', '_Pct < 1',
        'THEN', 'PROC_ARCANA_Resonant_Overload_ShowPct(_Resonant, 1);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Show((CHARACTER)_Resonant, (INTEGER)_N, (INTEGER)_Max)',
        'AND', 'IntegerProduct(_N, 100, _N100)', 'AND', 'IntegerDivide(_N100, _Max, _Pct)', 'AND', '_Pct >= 1', 'AND', '_Pct < 100',
        'THEN', 'PROC_ARCANA_Resonant_Overload_ShowPct(_Resonant, _Pct);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_ShowPct((CHARACTER)_Resonant, (INTEGER)_P)', 'AND', 'IntegerProduct(_P, 6, _Secs)', 'AND', 'IntegerToReal(_Secs, _Dur)',
        'THEN', 'ApplyStatus(_Resonant, "RESONANT_OVERLOAD", _Dur, 1, _Resonant);', '//END_REGION', '',
        '//REGION Resonant - Overload reset: Emotional Overload released, or Overloaded ran its course',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Reset((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_Resonant_Overload(_Resonant, _N)', 'THEN', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _N);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Reset((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_Resonant_OverloadFull(_Resonant)', 'THEN', 'NOT DB_ARCANA_Resonant_OverloadFull(_Resonant);', '',
        '// R32: the meter stays on the character, empty',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Reset((CHARACTER)_Resonant)', 'THEN',
        'RemoveStatus(_Resonant, "RESONANT_OVERLOAD_FULL", _Resonant);', 'PROC_ARCANA_Resonant_Overload_ShowEmpty(_Resonant);', '',
        'IF', 'StatusApplied((CHARACTER)_Resonant, "RESONANT_OVERLOAD_SPENT_TECH", _, _)', 'THEN', 'PROC_ARCANA_Resonant_Overload_Reset(_Resonant);', '',
        '// R29: Overloaded ran out (or was removed) -- the Resonant has steadied, the meter is empty',
        'IF', 'StatusRemoved((CHARACTER)_Resonant, "RESONANT_OVERLOAD_FULL", _, _)', (at(2) ? ('AND', 'NOT DB_ARCANA_Resonant_Settling(_Resonant)') : ()),
        'THEN', 'PROC_ARCANA_Resonant_Overload_Reset(_Resonant);',
        (at(2) ? ('', 'IF', 'StatusRemoved((CHARACTER)_Resonant, "RESONANT_OVERLOAD_FULL", _, _)', 'AND', 'DB_ARCANA_Resonant_Settling(_Resonant)',
            'THEN', 'NOT DB_ARCANA_Resonant_Settling(_Resonant);') : ()), '//END_REGION', '',
        '//REGION Resonant - the empty meter (R32): always shown, at 0% too -- a permanent status with no number',
        'PROC', 'PROC_ARCANA_Resonant_Overload_ShowEmpty((CHARACTER)_Resonant)', 'AND', 'HasPassive(_Resonant, "Arcana_Passive_Overload", 1)',
        'AND', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _)', 'AND', 'NOT DB_ARCANA_Resonant_OverloadFull(_Resonant)',
        'THEN', 'ApplyStatus(_Resonant, "RESONANT_OVERLOAD", -1.0, 1, _Resonant);', '',
        'IF', 'SavegameLoaded()', 'AND', 'DB_Players(_Resonant)', 'THEN', 'PROC_ARCANA_Resonant_Overload_ShowEmpty(_Resonant);', '',
        '// the passive arrives with the class (level 1): a new Resonant, a new party member, or the first fight',
        'IF', 'LeveledUp(_Resonant)', 'THEN', 'PROC_ARCANA_Resonant_Overload_ShowEmpty(_Resonant);', '',
        'IF', 'CharacterJoinedParty(_Resonant)', 'THEN', 'PROC_ARCANA_Resonant_Overload_ShowEmpty(_Resonant);', '',
        'IF', 'EnteredCombat((CHARACTER)_Resonant, _)', 'THEN', 'PROC_ARCANA_Resonant_Overload_ShowEmpty(_Resonant);', '//END_REGION',
        (at(2) ? overload_stage2() : ()),
        'EXITSECTION', '', 'ENDEXITSECTION', '';
    $g =~ s/\n/\r\n/g;
    $g;
}

# ARC-0017 stage 2: the regions the redesigned Overload adds to the counter goal (R51, R53, R56)
sub overload_stage2 {
    ('', '//REGION ARC-0017 R51: once per turn, a Surge that lands on an enemy while Overloaded deals it the Overloaded damage',
     'IF', 'StatusApplied((CHARACTER)_Target, _Status, (CHARACTER)_Resonant, _)', 'AND', 'DB_ARCANA_Resonant_Landed(_Status)',
     'AND', 'HasActiveStatus(_Resonant, "RESONANT_OVERLOAD_FULL", 1)', 'AND', 'IsEnemy(_Resonant, _Target, 1)', 'AND', 'NOT DB_ARCANA_Resonant_RiderUsed(_Resonant)',
     'AND', 'GetLevel(_Resonant, _Lvl)', 'AND', 'DB_ARCANA_Resonant_RiderBand(_Lvl, _Tech)',
     'THEN', 'DB_ARCANA_Resonant_RiderUsed(_Resonant);', 'ApplyStatus(_Target, _Tech, 0.0, 1, _Resonant);', '',
     'IF', 'TurnStarted((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_Resonant_RiderUsed(_Resonant)', 'THEN', 'NOT DB_ARCANA_Resonant_RiderUsed(_Resonant);', '//END_REGION', '',
     '//REGION ARC-0017 R53: when a fight ends the meter settles to half and Overloaded ends (not-full first: the full case sets the count)',
     'IF', 'LeftCombat((CHARACTER)_Resonant, _)', 'AND', 'HasPassive(_Resonant, "Arcana_Passive_Overload", 1)', 'THEN', 'PROC_ARCANA_Resonant_Overload_Settle(_Resonant);', '',
     'PROC', 'PROC_ARCANA_Resonant_Overload_Settle((CHARACTER)_Resonant)', 'AND', 'NOT DB_ARCANA_Resonant_OverloadFull(_Resonant)',
     'AND', 'DB_ARCANA_Resonant_Overload(_Resonant, _N)', 'AND', 'IntegerDivide(_N, 2, _Half)',
     'THEN', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _N);', 'PROC_ARCANA_Resonant_Overload_Keep(_Resonant, _Half);', '',
     'PROC', 'PROC_ARCANA_Resonant_Overload_Settle((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_Resonant_OverloadFull(_Resonant)',
     'AND', 'DB_ARCANA_Resonant_Overload(_Resonant, _N)', 'AND', 'IntegerDivide(_N, 2, _Half)',
     'THEN', 'DB_ARCANA_Resonant_Settling(_Resonant);', 'NOT DB_ARCANA_Resonant_OverloadFull(_Resonant);', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _N);',
     'RemoveStatus(_Resonant, "RESONANT_OVERLOAD_FULL", _Resonant);', 'PROC_ARCANA_Resonant_Overload_Keep(_Resonant, _Half);', '',
     'PROC', 'PROC_ARCANA_Resonant_Overload_Keep((CHARACTER)_Resonant, (INTEGER)_Half)', 'AND', '_Half > 0',
     'AND', 'GetLevel(_Resonant, _Lvl)', 'AND', 'DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max)',
     'THEN', 'DB_ARCANA_Resonant_Overload(_Resonant, _Half);', 'PROC_ARCANA_Resonant_Overload_Show(_Resonant, _Half, _Max);', '',
     'PROC', 'PROC_ARCANA_Resonant_Overload_Keep((CHARACTER)_Resonant, (INTEGER)_Half)', 'AND', '_Half == 0', 'THEN', 'PROC_ARCANA_Resonant_Overload_ShowEmpty(_Resonant);', '//END_REGION', '',
     '//REGION ARC-0017 R56: waking Tier III fills the meter (ARCANA_Aspect_Temperance calls this)',
     'PROC', 'PROC_ARCANA_Resonant_Overload_Fill((CHARACTER)_Resonant)', 'AND', 'GetLevel(_Resonant, _Lvl)', 'AND', 'DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max)',
     'THEN', 'PROC_ARCANA_Resonant_Overload_Add(_Resonant, _Max);', '//END_REGION', '',
     '//REGION ARC-0017 R51: Emotional Overload leaves vanilla Mental Fatigue for the Resonant\'s level (its technical status caps it at 7)',
     'IF', 'StatusApplied((CHARACTER)_Target, "RESONANT_FATIGUE_TECH", (CHARACTER)_Resonant, _)', 'AND', 'GetLevel(_Resonant, _Lvl)',
     'AND', 'IntegerProduct(_Lvl, 6, _Secs)', 'AND', 'IntegerToReal(_Secs, _Dur)',
     'THEN', 'ApplyStatus(_Target, "MAG_PSYCHIC_MENTAL_FATIGUE", _Dur, 1, _Resonant);', 'ApplyStatus(_Target, "MAG_PSYCHIC_MENTAL_FATIGUE_DURATION_TECHNICAL", 6.0, 1, _Resonant);', '//END_REGION')
}

# ---------------------------------------------------------------- stage 3: the spells outside the Surges (spec §7)
our $CARD_MARK = "not HasPassive('ARCANA_IS_CARD', context.Source)";
# the shout animation of the mod's Ready cards (Shout_Arcana_Card_Passive_GaleDeflection)
our $SHOUT_ANIMATION = '355a5479-07c9-4a34-9ab6-3b2669fdd248,,;,,;2ac8ee64-6d74-4cad-a74c-660ef3fc3d06,,;5bf6f6e6-353e-40f9-9a6f-0d6d16e19496,,;1c5627cb-6352-454b-9b84-c5b10ef2d201,,;,,;1cc6ba3b-fa78-48f8-858c-ac4c78fdb8fc,,;,,;,,';

# Heartstring (§7.1): the cantrip pattern of the Deceiver's Malicious Whispers (D4Cantrip, Wisdom, Potent
# Cantrip on a save). A mood lasts longer with vanilla SetStatusDuration(<status>,<turns>,Add) (MAG_ZOC_FORCE_CONDUIT).
sub build_heartstring {
    my $id = 'Target_Arcana_Card_Spell_Heartstring';
    my $ext = master('SPL_Resonant_Heartstring', 'mood_extend')->{value};
    my $dmg = 'LevelMapValue(D4Cantrip)';   # 25 SPL_Resonant_Heartstring#damage: 1d4 / 2d4 / 3d4, the vanilla cantrip map
    my $per = plain(master('SPL_Resonant_Heartstring', 'per_feeling_next')->{value});
    my @feel = map { 'FEELING_' . uc $FEELING{$_}{name} } sort { $FEELING{$a}{name} cmp $FEELING{$b}{name} } keys %FEELING;
    my $success = at(4)   # R61: extra Psychic per feeling the target carries (Emotional Overload's pattern); no mood extension
        ? join(';', "DealDamage($dmg,Psychic,Magical)", map { "IF(HasStatus('$_')):DealDamage($per,Psychic,Magical)" } @feel)
        : join(';', "DealDamage($dmg,Psychic,Magical)", map { my $m = mood_id($_); "IF(HasStatus('$m')):SetStatusDuration($m,$ext,Add)" } @WHEEL);
    entry($id, 'SpellData', SpellType => 'Target', Level => 0, SpellSchool => 'Enchantment',
        TargetRadius => master('SPL_Resonant_Heartstring', 'range')->{value}, AmountOfTargets => 1,
        SpellRoll => 'not SavingThrow(Ability.Wisdom, SourceSpellDC())',
        SpellSuccess => $success,
        SpellFail => "IF(HasPassive('PotentCantrip',context.Source)):DealDamage(($dmg)/2,Psychic,Magical);IF(not HasPassive('PotentCantrip',context.Source)):ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL,100,0)",
        TargetConditions => "Character() and not Self() and not Dead() and $CARD_MARK",
        Icon => 'Spell_Enchantment_ViciousMockery',
        DisplayName => loca(key($id, 'NAME'), 'Heartstring'),
        Description => loca(key($id, 'DESC'), tag_terms(at(4) ? "Pluck the string a creature's heart hangs from. It takes [1], and $per more for each feeling it carries." : "Pluck the string a creature's heart hangs from. It takes [1], and a mood it carries lasts $ext turns longer.")),
        DescriptionParams => "DealDamage($dmg,Psychic)",
        TooltipDamageList => "DealDamage($dmg,Psychic)", TooltipAttackSave => 'Wisdom',
        @CAST, PreviewCursor => 'Cast', CastTextEvent => 'Cast',
        CycleConditions => 'Enemy() and not Dead()', UseCosts => 'ActionPoint:1',
        VerbalIntent => 'Damage', SpellStyleGroup => 'Class',
        SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent;IsHarmful', DamageType => 'Psychic');
}

# Temper (§7.2, R6, R34, R36): Bonus Action; the target's mood goes back to the emotion it came from, for 1 turn.
# When that emotion fades, its own OnRemoveFunctors leave the mood again at full length -- so Temper both replays
# the peak's behaviour and renews the mood. Pure Stats: every peak first (a functor reads the mood before it is
# spent), then the moods are removed. It applies a peak, never a reaction (R7).
sub build_temper {
    my $c = 'Target_Arcana_Card_Spell_Temper';
    my $success = join ';', (at(1) ? 'ApplyStatus(RESONANT_REPLAY,100,2)' : ()),   # R49: the replayed emotion leaves nothing
        (map { "IF(HasStatus('" . mood_id($_) . "')):ApplyStatus(" . peak_id($_) . ',100,1)' } @WHEEL),
        map { my $m = mood_id($_); "IF(HasStatus('$m')):RemoveStatus($m)" } @WHEEL;
    my $text = at(1)
        ? "Spend a creature's mood to make it relive the emotion it came from for 1 turn. That emotion leaves nothing behind when it fades. A creature that is not your ally can resist with a Wisdom Saving Throw."
        : "Pull a creature's mood back to the emotion it came from. It feels that emotion again for 1 turn, and when it fades the mood returns for $MOOD_TURNS turns. A creature that is not your ally can resist with a Wisdom Saving Throw.";
    my $map = join(', ', map { st_tag(mood_id($_), $EMO{$_}{mood}{name}) . ' into ' . st_tag(peak_id($_), $_) } @WHEEL) . '.';
    entry($c, 'SpellData', SpellType => 'Target', Level => 0, SpellSchool => 'Enchantment',
        TargetRadius => master('SPL_Resonant_Temper', 'range')->{value}, AmountOfTargets => 1,
        SpellRoll => 'SpellAutoResolveOnAlly(Ability.Wisdom,SourceSpellDC(),true)',   # as the Surges (Owner, 2026-10-12)
        SpellSuccess => $success,
        SpellFail => 'ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL,100,0)',
        TargetConditions => "Character() and not Dead() and not Tagged('CONSTRUCT') and (" . any_mood() . ") and $CARD_MARK",
        Icon => 'Spell_Enchantment_CalmEmotions',
        DisplayName => loca(key($c, 'NAME'), 'Temper'),
        Description => loca(key($c, 'DESC'), tag_terms($text)),
        ExtraDescription => loca(key($c, 'EXTRA'), $map),
        TooltipAttackSave => 'Wisdom',
        @CAST, PreviewCursor => 'Cast', CastTextEvent => 'Cast',
        UseCosts => 'BonusActionPoint:1', VerbalIntent => 'Control', SpellStyleGroup => 'Class',
        SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent', HitAnimationType => 'MagicalNonDamage');
}

# Ready: Compassion (§7.4, R34): the mod's Which One -- a Ready card (Requirements Combat, not while weaving,
# unique while ready) applies a READY status until the combat ends, and the status unlocks the reaction. The
# reaction is vanilla Hellish Rebuke's: OnCastHit + UseSpell(<target>,<spell>,true,true,true); only the reaction
# is paid. Nearby + an ally within range as Trust's shoulder (Interrupt_Arcana_TrustShoulder).
our $KIND_TRUST = 'Target_Arcana_Created_CompassionTrust';   # R57: the Trust Ready: Compassion casts
sub build_compassion {
    my $lvl = master('SPL_Resonant_Compassion', 'card_level')->{value};
    my $r   = master('SPL_Resonant_Compassion', 'range')->{value};
    my $id = 'Shout_Arcana_Card_Passive_Compassion';
    my $icon = 'Spell_Abjuration_Sanctuary';
    my $trust = sp_tag(spell_id('Trust'), at(3) ? 'Trust' : 'Weave Surge: Trust');   # R54: named by its emotion
    my $card = entry($id, 'SpellData', SpellType => 'Shout', Level => $lvl, SpellSchool => 'Enchantment',
        SpellProperties => 'ApplyStatus(SELF,COMPASSION_READY,100,-1)', TargetConditions => "Self() and $CARD_MARK",
        Icon => $icon,
        DisplayName => loca(key($id, 'NAME'), 'Ready: Compassion'),
        Description => loca(key($id, 'DESC'), "Until the end of the fight, when an ally within [1] takes damage, you can use your reaction to cast $trust on it."),
        DescriptionParams => "Distance($r)",
        TooltipStatusApply => 'ApplyStatus(COMPASSION_READY,100,-1)',
        PreviewCursor => 'Cast', CastTextEvent => 'Cast', UseCosts => "SpellSlotsGroup:1:1:$lvl", SpellAnimation => $SHOUT_ANIMATION,
        VerbalIntent => 'Buff', SpellStyleGroup => 'Class', SpellFlags => 'IsSpell;HasVerbalComponent', HitAnimationType => 'None',
        Requirements => 'Combat',
        RequirementConditions => "not HasStatus('ARCANA_WEAVING',context.Source) and not HasStatus('COMPASSION_READY',context.Source)");
    my $status = ['Status_BOOST', entry('COMPASSION_READY', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('COMPASSION_READY', 'NAME'), 'Ready: Compassion'),
        Description => loca(key('COMPASSION_READY', 'DESC'), "When an ally within [1] takes damage, you can use your reaction to cast $trust on it."),
        DescriptionParams => "Distance($r)", Icon => $icon, StackId => 'COMPASSION_READY', StackType => 'Overwrite',
        # stage 6.4: one charge a turn (ArcanaReactCompassion, ReplenishType Turn), as Which One
        Boosts => 'UnlockInterrupt(Interrupt_Arcana_Reaction_Compassion);ActionResource(ArcanaReactCompassion,1,0)', RemoveEvents => 'OnCombatEnded',
        StatusPropertyFlags => 'RemoveOnLongRest;ForceOverhead', StatusGroups => 'SG_RemoveOnRespec')];
    my $interrupt = entry('Interrupt_Arcana_Reaction_Compassion', 'InterruptData',
        DisplayName => loca(key('Interrupt_Arcana_Reaction_Compassion', 'NAME'), 'Compassion'),
        Description => loca(key('Interrupt_Arcana_Reaction_Compassion', 'DESC'), "An ally within [1] took damage. Cast $trust on it."),
        DescriptionParams => "Distance($r)", Icon => $icon,
        InterruptContext => 'OnCastHit', InterruptContextScope => 'Nearby', Container => 'YesNoDecision',
        Conditions => "IsAbleToReact(context.Observer) and Enemy(context.Source,context.Observer) and Ally(context.Target,context.Observer) and not Self(context.Target,context.Observer) and HasFunctor(StatsFunctorType.DealDamage) and IsHit() and not DistanceToEntityGreaterThan($r, context.ObserverPosition, context.Target) and not AnyEntityIsItem() and HasLastAttackTriggered()",
        Properties => 'UseSpell(OBSERVER_TARGET,' . (at(1) ? $KIND_TRUST : spell_id('Trust')) . ',true,true,true);ApplyStatus(OBSERVER_OBSERVER,COMPASSION_USED_TECH,100,0)',
        Cost => 'ReactionActionPoint:1;ArcanaReactCompassion:1',
        InterruptDefaultValue => 'Ask;Enabled',
        # the PC deck: holding the card IS the charge (CardDB D.reactions); the use mark discards one copy
        EnableCondition => "HasActionResource('ArcanaReactCompassion', 1, 0, false, false, context.Source)",
        EnableContext => 'OnActionResourcesChanged;OnStatusApplied;OnStatusRemoved');
    my $used = hidden_status('COMPASSION_USED_TECH', 'Compassion used', 'StackType', 'Overwrite');
    # R57: the Trust a rule casts is kind -- the Surge itself, without the reactions that hinder (Created: never a card)
    my $kind = at(1) ? entry($KIND_TRUST, 'SpellData', SpellType => 'Target', using => spell_id('Trust'),
        SpellSuccess => spell_success('Trust', 1)) : '';
    ($card, $status, $interrupt, $used, $kind);
}

# Emotional Contagion (§7.3, R33, R34): Concentration (vanilla Target_Guidance: IsConcentration + a timed status);
# the status is an aura (Joy's contagion, passed P1) that copies the bearer's mood to everyone near it, renewed
# each turn, no save. The bearer's mood is read with HasStatus(..., context.Source) -- probe P11. Copied moods
# replace (StackId MOOD), never react (R7).
sub build_contagion {
    my $id = 'Target_Arcana_Card_Spell_EmotionalContagion';
    my $lvl = master('SPL_Resonant_EmotionalContagion', 'card_level')->{value};
    my $rad = master('SPL_Resonant_EmotionalContagion', 'radius')->{value};
    my $dur = master('SPL_Resonant_EmotionalContagion', 'duration')->{value};
    my $icon = 'Spell_Enchantment_Friends';
    my $spell = entry($id, 'SpellData', SpellType => 'Target', Level => $lvl, SpellSchool => 'Enchantment',
        TargetRadius => master('SPL_Resonant_EmotionalContagion', 'range')->{value}, AmountOfTargets => 1,
        SpellProperties => "ApplyStatus(RESONANT_CONTAGION,100,$dur)",
        TargetConditions => "Character() and not Dead() and not Tagged('CONSTRUCT') and (" . any_mood() . ") and $CARD_MARK",
        Icon => $icon,
        DisplayName => loca(key($id, 'NAME'), 'Emotional Contagion'),
        Description => loca(key($id, 'DESC'), 'Let the mood of a creature spill over: every creature within [1] of it catches the same mood, and catches it again each turn. No saving throw.'),
        DescriptionParams => "Distance($rad)",
        TooltipStatusApply => "ApplyStatus(RESONANT_CONTAGION,100,$dur)",
        @CAST, PreviewCursor => 'Cast', CastTextEvent => 'Cast',
        UseCosts => "ActionPoint:1;SpellSlotsGroup:1:1:$lvl", VerbalIntent => 'Control', SpellStyleGroup => 'Class',
        SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent;IsConcentration', HitAnimationType => 'MagicalNonDamage', MemoryCost => 1);
    my $status = status_entry('RESONANT_CONTAGION', 'Emotional Contagion',
        'Its mood spills over: every creature within [1] catches it, again each turn.',
        $icon, 'mood', { stack => 'RESONANT_CONTAGION', params => "Distance($rad)",
        extra => { AuraRadius => $rad, StatusPropertyFlags => 'ForceOverhead',
            AuraStatuses => join(';', map { my $m = mood_id($_); "IF(not Self() and Ally() and HasStatus('$m', context.Source)):ApplyStatus($m,100,1)" } @WHEEL) } });
    ($spell, $status);
}

# ---------------------------------------------------------------- stage 4: Aspect Awakening -- 14 · Temperance (spec §9)
# The frame of the four existing Aspects, copied from the High Priestess (Empress): hidden ASPECT_AWAKENED_<X> (Tier I
# reached: unlocks the Aspect card, takes the tiers with it), visible _I/_II/_III (one StackId, priority by tier, each
# lists every bonus so far), ASPECT_PROGRESS_<X> (a frozen count), hidden tier passives granted at 3 / 7 / 12 and a
# visible Awakening passive. ARCANA_Aspect_Common.txt counts and awakens (common_rows); temperance_goal holds the goal
# and the Osiris effects.
sub aspect_goal { master('FEAT_Resonant_AspectAwakening', "goal_tier$_[0]")->{value} }
sub tier_texts {   # [label, text] for each tier, with DescriptionParams [1] Tier III's radius
    (['Resonance', at(4) ? "Catharsis deals or restores an extra $TIER1_BONUS." : "Catharsis deals or restores an extra $TIER1_BONUS, and the moods you create last $TIER1_EXTEND turns longer."],
     ['Harmony', "Feelings you braid last $TIER2_EXTEND turns longer. Once per turn, a Weave Surge costs no action, and the emotion it leaves brings its mood at once."],   # R40, R42
     ['Aspect of Empathy', (at(2) ? 'When it awakens, your Overload fills at once, and creatures dancing from your Emotional Overload dance for ' . plain(master('SPL_Resonant_EmotionalOverload', 'dance_tier3_next')->{value}) . ' turns.' : 'Emotional Overload also reaches every enemy within [1] of the target that carries a feeling: it loses its feelings and is Paralysed for ' . master('FEAT_Resonant_AspectAwakening', 'tier3_paralysed_others')->{value} . ' turn.')])
}
sub aspect_params { at(2) ? undef : 'Distance(' . master('FEAT_Resonant_AspectAwakening', 'tier3_radius')->{value} . ')' }

# The Khonsu helper of Tier II's free Surge: every Weave Surge, upcast variants included, by the marker in its
# conditions (IsCardSpell.khn / IsArcanaSpell.khn do the same with ARCANA_IS_CARD / ARCANA_IS_SPELL).
sub weave_surge_khn {
    join "\r\n", '-- Any Weave Surge of the Resonant (ARC-0002, generated by gen_emotion_alchemy.pl -- do not edit by hand).',
        "-- The 8 Surges carry ARCANA_IS_SURGE in their TargetConditions, an always-true marker (the passive does not exist);",
        '-- reading the marker keeps every upcast variant in, which SpellId() would miss. Used by RESONANT_SURGE_FREE (Tier II).',
        'function IsWeaveSurge()', "    return HasStringInSpellConditions('ARCANA_IS_SURGE')", 'end', '';
}
sub build_aspect {
    my $icon = 'Spell_Enchantment_CalmEmotions';
    my @t = tier_texts(); my @roman = qw(I II III);
    my @st;
    push @st, ['Status_BOOST', entry($AWAKENED, 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key($AWAKENED, 'NAME'), '14 - Temperance'),
        Description => loca(key($AWAKENED, 'DESC'), 'Awakened as the Aspect of Empathy until combat ends.'),
        Icon => $icon, StackId => $AWAKENED, StackType => 'Ignore',
        Boosts => 'UnlockSpell(Shout_Arcana_Created_Aspect_TwoCups)', RemoveEvents => 'OnCombatEnded',
        StatusPropertyFlags => 'IgnoreResting;DisableOverhead;DisableCombatlog;DisablePortraitIndicator',
        OnRemoveFunctors => join(';', map { "RemoveStatus(${AWAKENED}_$_)" } @roman), StatusGroups => 'SG_RemoveOnRespec')];
    for my $i (0 .. 2) {
        my $id = "${AWAKENED}_$roman[$i]";
        push @st, ['Status_BOOST', entry($id, 'StatusData', StatusType => 'BOOST',
            DisplayName => loca(key($id, 'NAME'), "14 - Temperance: Awakened $roman[$i]"),
            Description => loca(key($id, 'DESC'), join('<br><br>', map { tag_terms("$t[$_][0]: $t[$_][1]") } 0 .. $i)),
            DescriptionParams => aspect_params(), Icon => $icon,
            StackId => "${AWAKENED}_TIER", StackPriority => $i + 1, StackType => 'Overwrite', RemoveEvents => 'OnCombatEnded',
            StatusPropertyFlags => 'ForceOverhead;IgnoreResting', StatusGroups => 'SG_RemoveOnRespec')];
    }
    push @st, ['Status_BOOST', entry('ASPECT_PROGRESS_TEMPERANCE', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('ASPECT_PROGRESS_TEMPERANCE', 'NAME'), 'Awakening Progress'),
        Description => loca(key('ASPECT_PROGRESS_TEMPERANCE', 'DESC'), 'Reactions you have caused this fight, towards your next Awakening tier.'),
        Icon => $icon, StackId => 'ASPECT_PROGRESS_TEMPERANCE', StackType => 'Overwrite', RemoveEvents => 'OnCombatEnded',
        StatusPropertyFlags => 'FreezeDuration;IgnoreResting;ForceOverhead', StatusGroups => 'SG_RemoveOnRespec')];
    # The Two Cups' Catharsis: its own status, so the Overload does not count it (R38) and the Awakening does
    push @st, status_entry('RESONANT_TWO_CUPS_CATHARSIS', 'Catharsis', 'Opposing emotions, snapped at once by The Two Cups. Every mood is spent.',
        $icon, 'mood', { stack => 'RESONANT_TWO_CUPS_CATHARSIS', onapply => join(';', map { 'RemoveStatus(' . mood_id($_) . ')' } @WHEEL) });
    # Tier II (R40): once per turn a Weave Surge costs no action -- the Fool's FOOL_ZEPHYR_FREE (1 turn, Osiris applies it
    # at turn start and removes it when the Surge is cast) with vanilla Extra Attack's variant
    # Tier II reached (the feelings' +2 reads it): hidden, applied by Osiris with the tier, gone with the combat
    push @st, ['Status_BOOST', entry('RESONANT_TIER2', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('RESONANT_TIER2', 'NAME'), 'Harmony'), StackId => 'RESONANT_TIER2', StackType => 'Ignore',
        RemoveEvents => 'OnCombatEnded', StatusPropertyFlags => 'IgnoreResting;DisableOverhead;DisableCombatlog;DisablePortraitIndicator',
        StatusGroups => 'SG_RemoveOnRespec')];
    push @st, ['Status_BOOST', entry('RESONANT_SURGE_FREE', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('RESONANT_SURGE_FREE', 'NAME'), 'Harmony'),
        Description => loca(key('RESONANT_SURGE_FREE', 'DESC'), 'Your next Weave Surge this turn costs no action, and the emotion it leaves brings its mood at once.'),
        Icon => $icon, StackId => 'RESONANT_SURGE_FREE', StackType => 'Overwrite', TickType => 'EndTurn',
        Boosts => 'UnlockSpellVariant(IsWeaveSurge(),ModifyUseCosts(Replace,ActionPoint,0,0,ActionPoint),ModifyIconGlow(),ModifyTooltipDescription())',
        RemoveEvents => 'OnCombatEnded', StatusPropertyFlags => 'ForceOverhead', StatusGroups => 'SG_RemoveOnRespec')];
    my $passives = '';
    for my $i (0 .. 2) {
        my $id = "Arcana_Passive_Aspect_Temperance_$roman[$i]";
        $passives .= entry($id, 'PassiveData', DisplayName => loca(key($id, 'NAME'), $t[$i][0]),
            Description => loca(key($id, 'DESC'), tag_terms($t[$i][1])), DescriptionParams => aspect_params(), Icon => $icon, Properties => 'IsHidden');
    }
    # ARC-0007: the shape every Awakening passive shares (gen_awakening_progress.pl tests that both say the same)
    my $tt = sub { my $i = shift; my $r = (qw(I II III))[$i]; qq{<LSTag Type="Passive" Tooltip="Arcana_Passive_Aspect_Temperance_$r">} . (tier_texts())[$i][0] . '</LSTag>' };
    $passives .= passive('Arcana_Passive_Aspect_Temperance_Awakening', '14 - Temperance: Awakening',
        'Cause reactions during a fight to awaken the Aspect of Empathy until combat ends. Every feeling you braid, every emotion you intensify and every Catharsis counts. Each goal you reach awakens one more tier.'
        . '<br><br>Level 3: cause ' . aspect_goal(1) . ' reactions to gain ' . $tt->(0) . '.<br><br>Level 7: cause ' . aspect_goal(2)
        . ' reactions to also gain ' . $tt->(1) . '.<br><br>Level 12: cause ' . aspect_goal(3) . ' reactions to awaken as the ' . $tt->(2) . '.'
        . '<br><br>The Awakening status shows how much is left to the next tier.', $icon);
    # The Two Cups (§9.1): the Aspect card, as The Veil Lifts (Shout, AreaRadius, OncePerCombat, Requirements Combat)
    my $id = 'Shout_Arcana_Created_Aspect_TwoCups';
    my $foe = 'IF(not Ally() and not Self())'; my $friend = 'IF(Ally() or Self())';
    my $spell = entry($id, 'SpellData', SpellType => 'Shout', Level => 0, SpellSchool => 'Enchantment', Cooldown => 'OncePerCombat',
        SpellProperties => join(';', "$foe:DealDamage($CATHARSIS_DICE,Psychic,Magical)", "$foe:DealDamage($TIER1_BONUS,Psychic,Magical)",
            "$friend:RegainHitPoints($CATHARSIS_DICE)", "$friend:RegainHitPoints($TIER1_BONUS)", 'ApplyStatus(RESONANT_TWO_CUPS_CATHARSIS,100,0)'),
        AreaRadius => master('SPL_Resonant_TwoCups', 'radius')->{value},
        TargetConditions => 'Character() and not Dead() and (' . any_mood() . ") and $CARD_MARK",
        Icon => $icon,
        DisplayName => loca(key($id, 'NAME'), 'The Two Cups'),
        Description => loca(key($id, 'DESC'), "Pour one cup into the other. Every creature within [3] that carries a mood undergoes Catharsis at once: an enemy takes [1] and $TIER1_BONUS more, an ally regains [2] and $TIER1_BONUS more. Their moods are spent."),
        DescriptionParams => "DealDamage($CATHARSIS_DICE,Psychic);RegainHitPoints($CATHARSIS_DICE);Distance(" . master('SPL_Resonant_TwoCups', 'radius')->{value} . ')',
        TooltipDamageList => "DealDamage($CATHARSIS_DICE,Psychic)",
        PreviewCursor => 'Cast', CastTextEvent => 'Cast', UseCosts => 'ActionPoint:1', SpellAnimation => $SHOUT_ANIMATION,
        VerbalIntent => 'Damage', SpellStyleGroup => 'Class', SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent',
        Requirements => 'Combat', DamageType => 'Psychic');
    (\@st, $passives, $spell);
}

# Rows for ARCANA_Aspect_Common.txt (hand-written, shared by every Aspect): inserted by 54_stage4_apply.pl.
sub common_rows {
    join "\r\n", '// 14 - Temperance (the Resonant): reactions caused in the fight (ARC-0002, generated by gen_emotion_alchemy.pl)',
        qq{DB_ARCANA_Aspect("TEMPERANCE", "ASPECT_PROGRESS_TEMPERANCE", "$AWAKENED", "Arcana_Passive_Aspect_Temperance_I");},
        (map { my $r = (qw(I II III))[$_ - 1]; qq{DB_ARCANA_AspectTier("TEMPERANCE", $_, "Arcana_Passive_Aspect_Temperance_$r", "${AWAKENED}_$r", } . aspect_goal($_) . ');' } 1 .. 3),
        'DB_ARCANA_AspectShow("TEMPERANCE", "COUNT");', '';
}

# Osiris for the Aspect: the goal (each reaction is a step), Harmony's free Surge (Tier II, R40) and the Tier III wave.
# Patterns: ARCANA_Aspect_Empress.txt (Step, nearest candidate from DB_ARCANA_Aspect_InCombat, once per turn cleared
# on TurnStarted, PROC_ARCANA_Aspect_Reset hook); ARCANA_Aspect_Fool.txt (a card by DB_ARCANA_CardFamily).
sub temperance_goal {
    my @feel = map { 'FEELING_' . uc $FEELING{$_}{name} } sort { $FEELING{$a}{name} cmp $FEELING{$b}{name} } keys %FEELING;
    my @aw = ((map { qq{DB_ARCANA_Resonant_AwakeningStatus("$_");} } @feel, (map { intense_id($_) } @WHEEL), 'CATHARSIS', 'RESONANT_TWO_CUPS_CATHARSIS'));
    my @roots = map { sprintf 'DB_ARCANA_Resonant_SurgeRoot("%s", "%s");', spell_id($_), uc $_ } @WHEEL;
    my @fdb = map { qq{DB_ARCANA_Resonant_Feeling("$_");} } @feel;
    my $radius = master('FEAT_Resonant_AspectAwakening', 'tier3_radius')->{value};
    my $para = master('FEAT_Resonant_AspectAwakening', 'tier3_paralysed_others')->{value} * 6;
    my @dbs = ('DB_ARCANA_Resonant_AwakeningStatus(_S)', 'DB_ARCANA_Resonant_SurgeRoot(_R,_E)', 'DB_ARCANA_Resonant_Feeling(_F)');
    my @clear = map { my $d = $_; (my $c = $d) =~ s/,/, /g; ('PROC', 'PROC_ARCANA_Resonant_Temperance_Init()', 'AND', $c, 'THEN', "NOT $c;", '') } @dbs;
    my $g = join "\n", 'Version 1', 'SubGoalCombiner SGC_AND', 'INITSECTION', 'PROC_ARCANA_Resonant_Temperance_Init();', '', 'KBSECTION',
        '// 14 - Temperance (the Resonant). Goal: cause reactions; 3 / 6 / 15 in ARCANA_Aspect_Common.txt (spec 9).',
        '//   Tier I Resonance and the feelings +2 of Tier II live in Stats. Here: the count, the free Surge of Tier II Harmony',
        '//   and the Tier III wave. GENERATED by gen_emotion_alchemy.pl -- do not edit by hand.',
        '//REGION Tables', @clear,
        'PROC', 'PROC_ARCANA_Resonant_Temperance_Init()', 'THEN', @aw, @roots, @fdb, '',
        'IF', 'SavegameLoaded()', 'THEN', 'PROC_ARCANA_Resonant_Temperance_Init();', '//END_REGION', '',
        '//REGION Goal: every feeling, intense emotion and Catharsis caused (The Two Cups: each one)',
        'IF', 'StatusApplied(_Target, _Status, (CHARACTER)_Resonant, _)', 'AND', 'DB_ARCANA_Resonant_AwakeningStatus(_Status)',
        'AND', 'HasPassive(_Resonant, "Arcana_Passive_Aspect_Temperance_Awakening", 1)', 'THEN', 'PROC_ARCANA_Aspect_Step(_Resonant, "TEMPERANCE");', '//END_REGION', '',
        '//REGION Tier II: Harmony -- once per turn a Weave Surge costs no action (R40; the Fool\'s Zephyr Strike pattern)',
        'PROC', 'PROC_ARCANA_Aspect_OnTier((CHARACTER)_Resonant, (STRING)_Aspect, (INTEGER)_Tier)', 'AND', '_Aspect == "TEMPERANCE"', 'AND', '_Tier == 2',
        'THEN', 'ApplyStatus(_Resonant, "RESONANT_SURGE_FREE", 6.0, 1, _Resonant);', 'ApplyStatus(_Resonant, "RESONANT_TIER2", -1.0, 1, _Resonant);', '',
        'IF', 'TurnStarted((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_AspectReached(_Resonant, 2)', 'THEN', 'ApplyStatus(_Resonant, "RESONANT_SURGE_FREE", 6.0, 1, _Resonant);', '',
        'IF', 'CastedSpell((CHARACTER)_Resonant, _Spell, _, _, _)', 'AND', 'DB_ARCANA_CardFamily(_Spell, _Root)', 'AND', 'DB_ARCANA_Resonant_SurgeRoot(_Root, _)',
        'AND', 'HasActiveStatus(_Resonant, "RESONANT_SURGE_FREE", 1)', 'THEN', 'RemoveStatus(_Resonant, "RESONANT_SURGE_FREE", _Resonant);', '',
        'PROC', 'PROC_ARCANA_Aspect_Reset((CHARACTER)_Char)', 'THEN', 'RemoveStatus(_Char, "RESONANT_SURGE_FREE", _Char);', 'RemoveStatus(_Char, "RESONANT_TIER2", _Char);', '//END_REGION', '',
        (at(2) ? (   # ARC-0017 stage 2: the area is Emotional Overload's rank III (R67); waking Tier III fills the meter (R56)
        '//REGION Tier III: the dam breaks -- waking it fills the Overload meter (R56)',
        'PROC', 'PROC_ARCANA_Aspect_OnTier((CHARACTER)_Resonant, (STRING)_Aspect, (INTEGER)_Tier)', 'AND', '_Aspect == "TEMPERANCE"', 'AND', '_Tier == 3',
        'AND', 'NOT DB_ARCANA_Resonant_OverloadFull(_Resonant)', 'THEN', 'PROC_ARCANA_Resonant_Overload_Fill(_Resonant);', '//END_REGION') : (
        "//REGION Tier III: Emotional Overload reaches every enemy within $radius m of the target that carries a feeling (first collect, then apply)",
        'IF', 'UsingSpellOnTarget((CHARACTER)_Resonant, (CHARACTER)_Target, _Spell, _, _, _)', 'AND', 'DB_ARCANA_CardFamily(_Spell, "Target_Arcana_Created_EmotionalOverload")', 'AND', 'DB_ARCANA_AspectReached(_Resonant, 3)',
        'AND', 'DB_ARCANA_Aspect_InCombat(_Resonant, _Combat)', 'THEN', 'PROC_ARCANA_Resonant_WaveCollect(_Resonant, _Target, _Combat);', 'PROC_ARCANA_Resonant_WaveApply(_Resonant);', '',
        'PROC', 'PROC_ARCANA_Resonant_WaveCollect((CHARACTER)_Resonant, (CHARACTER)_Target, (GUIDSTRING)_Combat)', 'AND', 'DB_ARCANA_Aspect_InCombat(_Cand, _Combat)',
        'AND', '_Cand != _Target', 'AND', 'IsEnemy(_Resonant, _Cand, 1)', 'AND', 'IsDead(_Cand, 0)', 'AND', 'GetDistanceTo(_Target, _Cand, _Dist)', 'AND', "_Dist <= $radius.0",
        'AND', 'DB_ARCANA_Resonant_Feeling(_Feeling)', 'AND', 'HasActiveStatus(_Cand, _Feeling, 1)', 'THEN', 'DB_ARCANA_Resonant_WavePending(_Resonant, _Cand);', '',
        'PROC', 'PROC_ARCANA_Resonant_WaveApply((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_Resonant_WavePending(_Resonant, _Cand)', 'AND', 'DB_ARCANA_Resonant_Feeling(_Feeling)',
        'AND', 'HasActiveStatus(_Cand, _Feeling, 1)', 'THEN', 'RemoveStatus(_Cand, _Feeling, _Resonant);', '',
        'PROC', 'PROC_ARCANA_Resonant_WaveApply((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_Resonant_WavePending(_Resonant, _Cand)',
        'THEN', 'NOT DB_ARCANA_Resonant_WavePending(_Resonant, _Cand);', "ApplyStatus(_Cand, \"PARALYZED\", $para.0, 1, _Resonant);", '//END_REGION',
        )),
        'EXITSECTION', '', 'ENDEXITSECTION', '';
    $g =~ s/\n/\r\n/g;
    $g;
}

# ---------------------------------------------------------------- stage 5: Shared Heart, the capstone (spec §7.6)
# The card as the Deceiver's capstone Grand Deception (Shout, AreaRadius, Level 5, OncePerRest, a level 5 slot; Unique
# in CardDB). The link is a status; Osiris copies a FEELING (R46) to the other linked creatures with the linked
# TARGET as the copies' source, so the Overload, Awakening and refund rules (which ask for a Resonant source) count the
# Surge once (R19) and a copy never copies again.
sub build_shared_heart {
    my $id = 'Shout_Arcana_Card_Spell_SharedHeart';
    my $lvl = master('SPL_Resonant_SharedHeart', 'card_level')->{value};
    my $r = master('SPL_Resonant_SharedHeart', 'range')->{value};
    my $icon = 'Spell_Abjuration_WardingBond';
    my $card = entry($id, 'SpellData', SpellType => 'Shout', Level => $lvl, SpellSchool => 'Enchantment', Cooldown => 'OncePerRest',
        SpellProperties => 'ApplyStatus(SHARED_HEART,100,-1)' . (at(4) ? ';ApplyStatus(RESONANT_SHARED_JOY,100,1)' : ''), AreaRadius => $r,
        TargetConditions => "(Ally() or Self()) and Character() and not Dead() and $CARD_MARK",
        Icon => $icon,
        DisplayName => loca(key($id, 'NAME'), 'Shared Heart'),
        Description => loca(key($id, 'DESC'), "Bind your heart to your allies' until the end of the fight. You and every ally within [1] are linked: a feeling braided in one linked creature is braided in all of them, and a Catharsis on one heals them all."),
        DescriptionParams => "Distance($r)", TooltipStatusApply => 'ApplyStatus(SHARED_HEART,100,-1)',
        PreviewCursor => 'Cast', CastTextEvent => 'Cast', UseCosts => "ActionPoint:1;SpellSlotsGroup:1:1:$lvl", SpellAnimation => $SHOUT_ANIMATION,
        VerbalIntent => 'Buff', SpellStyleGroup => 'Class', SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent',
        Requirements => 'Combat');
    my @st;
    push @st, ['Status_BOOST', entry('SHARED_HEART', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('SHARED_HEART', 'NAME'), 'Shared Heart'),
        Description => loca(key('SHARED_HEART', 'DESC'), "Linked to the Resonant's heart. A feeling braided in any linked creature is braided in all of them; a Catharsis heals them all."),
        Icon => $icon, StackId => 'SHARED_HEART', StackType => 'Overwrite', RemoveEvents => 'OnCombatEnded',
        StatusPropertyFlags => 'IgnoreResting;ForceOverhead', StatusGroups => 'SG_RemoveOnRespec')];
    # R58: Joy on every linked creature -- the peak itself (it fades into Serene), but no Overload or Awakening counts it
    push @st, ['Status_BOOST', entry('RESONANT_SHARED_JOY', 'StatusData', StatusType => 'BOOST', using => peak_id('Joy'),
        StackId => 'EMOTION')] if at(4);
    # R44: a Catharsis on a linked ally heals the others the base amount and spends their moods
    push @st, status_entry('RESONANT_SHARED_CATHARSIS', 'Catharsis', 'Opposing emotions, snapped through a Shared Heart. Heals, and every mood is spent.',
        $icon, 'mood', { stack => 'RESONANT_SHARED_CATHARSIS',
        onapply => join(';', "RegainHitPoints($CATHARSIS_DICE)", map { 'RemoveStatus(' . mood_id($_) . ')' } @WHEEL) });
    ($card, \@st);
}

sub shared_heart_goal {
    my @res = map { qq{DB_ARCANA_Resonant_SharedResult("$_");} }    # R46: feelings only; R57: only the helpful ones
        map { 'FEELING_' . uc $FEELING{$_}{name} } grep { !at(1) || $FEELING{$_}{kind} eq 'A' } sort keys %FEELING;
    my $g = join "\n", 'Version 1', 'SubGoalCombiner SGC_AND', 'INITSECTION', 'PROC_ARCANA_Resonant_SharedHeart_Init();', '', 'KBSECTION',
        '// Shared Heart (the Resonant capstone, spec 7.6). GENERATED by gen_emotion_alchemy.pl -- do not edit by hand.',
        '//REGION Tables (DB_ARCANA_Resonant_SurgeRoot lives in ARCANA_Aspect_Temperance)',
        'PROC', 'PROC_ARCANA_Resonant_SharedHeart_Init()', 'AND', 'DB_ARCANA_Resonant_SharedResult(_S)', 'THEN', 'NOT DB_ARCANA_Resonant_SharedResult(_S);', '',
        'PROC', 'PROC_ARCANA_Resonant_SharedHeart_Init()', 'THEN', @res, '',
        'IF', 'SavegameLoaded()', 'THEN', 'PROC_ARCANA_Resonant_SharedHeart_Init();', '//END_REGION', '',
        '//REGION A Surge result on a linked creature reaches every other linked creature (source = that target: counted once, R19)',
        'IF', 'StatusApplied((CHARACTER)_Target, _Status, (CHARACTER)_Resonant, _)', 'AND', 'DB_ARCANA_Resonant_SharedResult(_Status)',
        'AND', 'HasPassive(_Resonant, "Arcana_Passive_EmotionalAlchemy", 1)', 'AND', 'HasActiveStatus(_Target, "SHARED_HEART", 1)',
        'AND', 'GetStatusTurns(_Target, _Status, _Turns)', 'AND', 'DB_ARCANA_Aspect_InCombat(_Target, _Combat)',
        'THEN', 'PROC_ARCANA_Resonant_SharedCopy(_Target, _Status, _Turns, _Combat);', '',
        'PROC', 'PROC_ARCANA_Resonant_SharedCopy((CHARACTER)_Target, (STRING)_Status, (INTEGER)_Turns, (GUIDSTRING)_Combat)',
        'AND', 'DB_ARCANA_Aspect_InCombat(_Other, _Combat)', 'AND', '_Other != _Target', 'AND', 'IsDead(_Other, 0)', 'AND', 'HasActiveStatus(_Other, "SHARED_HEART", 1)',
        'AND', 'IntegerProduct(_Turns, 6, _Secs)', 'AND', 'IntegerToReal(_Secs, _Dur)',
        'THEN', 'ApplyStatus(_Other, _Status, _Dur, 1, _Target);', '//END_REGION', '',
        '//REGION R44: a Catharsis on a linked creature heals every other linked creature',
        'IF', 'StatusApplied((CHARACTER)_Target, "CATHARSIS", (CHARACTER)_Resonant, _)', 'AND', 'HasPassive(_Resonant, "Arcana_Passive_EmotionalAlchemy", 1)',
        'AND', 'HasActiveStatus(_Target, "SHARED_HEART", 1)', 'AND', 'DB_ARCANA_Aspect_InCombat(_Target, _Combat)',
        'THEN', 'PROC_ARCANA_Resonant_SharedCatharsis(_Target, _Combat);', '',
        'PROC', 'PROC_ARCANA_Resonant_SharedCatharsis((CHARACTER)_Target, (GUIDSTRING)_Combat)', 'AND', 'DB_ARCANA_Aspect_InCombat(_Other, _Combat)',
        'AND', '_Other != _Target', 'AND', 'IsDead(_Other, 0)', 'AND', 'HasActiveStatus(_Other, "SHARED_HEART", 1)',
        'THEN', 'ApplyStatus(_Other, "RESONANT_SHARED_CATHARSIS", 0.0, 1, _Target);', '//END_REGION', '',
        'EXITSECTION', '', 'ENDEXITSECTION', '';
    $g =~ s/\n/\r\n/g;
    $g;
}

sub main {
    my ($out) = grep { defined } map { $ARGV[$_ + 1] if $ARGV[$_] eq '--out' } 0 .. $#ARGV;
    $out //= default_out();
    my $engine = build_engine_patch();
    write_file("$out/10_engine.patch", $engine);
    my ($up, $n) = build_upcast_patch();
    write_file("$out/20_upcast_targets.patch", $up);
    write_file("$out/30_catharsis_levelmap.lsx-fragment", catharsis_levelmap());
    write_file("$out/32_dice_levelmaps.lsx-fragment", dice_levelmaps()) if at(4);   # ARC-0017 R62/R67
    write_file("$out/40_overload_goal.txt", overload_goal());
    write_file("$out/42_temperance_goal.txt", temperance_goal());
    write_file("$out/43_common_rows.txt", common_rows());
    write_file("$out/45_shared_heart_goal.txt", shared_heart_goal());
    write_file("$out/44_IsWeaveSurge.khn", weave_surge_khn());   # ARC-0005: goes into ArcanaHelpers.khn (its own section), never as a separate file
    printf "10_engine.patch: %d new entries, %d removals, %d strings\n",
        scalar(() = $engine =~ /^new entry /mg), scalar(() = $engine =~ /^\@remove /mg), scalar(() = $engine =~ /^\@loca /mg);
    printf "20_upcast_targets.patch: %d variants%s\n", $n, $n ? '' : ' (none yet: run gen_upcast_variants.pl --apply, then generate again)';
}

main() unless caller;
1;
