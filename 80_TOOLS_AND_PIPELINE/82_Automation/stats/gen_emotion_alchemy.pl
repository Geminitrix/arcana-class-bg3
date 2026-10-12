#!/usr/bin/perl
# Resonant: generates the Emotional Alchemy engine (spec 20_GAME_DESIGN/21_GDD_Arcana_Class/21.04_Subclasses/Resonant/2026-10-11-resonant-design.md).
#
# One table -- Plutchik's wheel and its states -- becomes two patches for stats_add.pl:
#   50_ENGINEERING/55_Implementation_Specs/_wip/Resonant/10_engine.patch          8 Weave Surges, the statuses, the passives, the DEBUG util and the text
#   50_ENGINEERING/55_Implementation_Specs/_wip/Resonant/20_upcast_targets.patch  +1 target per level on the _N variants (only after gen_upcast_variants)
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
our $CATHARSIS_MAP      = 'Catharsis_Damage';
our $CATHARSIS_MAP_UUID = '11006542-a7b5-4599-938a-2840982c4bb1';   # fixed: generated once for this map
our $CATHARSIS_DICE     = "LevelMapValue($CATHARSIS_MAP)";           # damage and healing scale with level (25: STA_Resonant_Catharsis)
sub catharsis_levelmap {
    my $by = master('STA_Resonant_Catharsis', 'damage')->{by_level};
    my @th = sort { $a <=> $b } keys %$by;
    my %lv; for my $L (1 .. 20) { my ($t) = grep { $_ <= $L } reverse @th; $lv{$L} = $by->{$t} }
    my $s = qq{                <node id="LevelMapSeries">\n};
    $s .= qq{                    <attribute id="Level$_" type="LSString" value="$lv{$_}"/>\n} for sort { "$a" cmp "$b" } 1 .. 20;
    $s .= qq{                    <attribute id="Name" type="FixedString" value="$CATHARSIS_MAP"/>\n};
    $s .= qq{                    <attribute id="UUID" type="guid" value="$CATHARSIS_MAP_UUID"/>\n                </node>\n};
}
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
    my %r = (distance => $d, gate => $GATE{$d}, mood => mood_id($m));
    if    ($d == 0) { $r{kind} = 'intensify'; $r{status} = intense_id($s) }
    elsif ($d == 4) { $r{kind} = 'catharsis'; $r{status} = 'CATHARSIS' }
    else            { $r{kind} = 'feeling';   $r{status} = feeling_id($s, $m) }
    \%r;
}

sub cond_of { my $r = shift; my $c = "HasStatus('$r->{mood}')";
    $r->{gate} ? "$c and HasPassive('$r->{gate}', context.Source)" : $c }

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
    my $s = shift;
    my @r = map { reaction($s, $_) } @WHEEL;
    my @f = ('IF(' . join(' and ', map { 'not (' . cond_of($_) . ')' } @r) . '):ApplyStatus(' . peak_id($s) . ',100,1)');
    # R16: any reaction refunds the Surge's slot -- placed before any reaction spends the mood
    push @f, 'IF(' . join(' or ', map { '(' . cond_of($_) . ')' } @r) . '):ApplyStatus(SELF,RESONANT_REFUND_TECH,100,0)';
    for my $r (grep { $_->{kind} ne 'catharsis' } @r) {
        my $turns = $r->{kind} eq 'intensify' ? 1 : $FEELING_TURNS;
        push @f, 'IF(' . cond_of($r) . "):ApplyStatus($r->{status},100,$turns)";
    }
    for my $r (grep { $_->{kind} eq 'catharsis' } @r) {
        my $c = cond_of($r);
        push @f, "IF($c and not Ally() and not Self()):DealDamage($CATHARSIS_DICE,Psychic,Magical)",
                 "IF($c and (Ally() or Self())):RegainHitPoints($CATHARSIS_DICE)",
                 "IF($c):ApplyStatus(CATHARSIS,100,0)";
    }
    join ';', @f;
}

sub any_mood { join ' or ', map { "HasStatus('" . mood_id($_) . "')" } @WHEEL }

sub target_conditions {
    my $s = shift;
    my $base = "Character() and not Dead() and not Tagged('CONSTRUCT') and not HasPassive('ARCANA_IS_CARD', context.Source)";
    my $side = $EMO{$s}{side} eq 'A' ? '(Ally() or Self())' : '(not Ally() and not Self())';
    "$base and ($side or " . any_mood() . ')';
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
        my $fade = 'IF(RemoveCause(StatusRemoveCause.TimeOut)):ApplyStatus(' . mood_id($e) . ",100,$MOOD_TURNS)";
        push @out, status_entry(peak_id($e), "Emotion: $e",
            tag_terms("Surging with $e. $E->{peak}{text}"),
            $E->{icon}, $side, { %{ $E->{peak} }, stack => 'EMOTION', onremove => $fade });
        push @out, status_entry(mood_id($e), "Mood: $E->{mood}{name}",
            tag_terms("The fading echo of $e. $E->{mood}{text}"),
            $E->{icon}, 'mood', { %{ $E->{mood} }, stack => 'MOOD' });
        my $I = $E->{intense};
        push @out, status_entry(intense_id($e), "Emotion: $I->{name}",
            tag_terms("$e surged again on its own echo. $I->{text}"),
            $E->{icon}, $side, { %$I, stack => 'EMOTION', onremove => $fade,
            onapply => join(';', grep { defined } 'RemoveStatus(' . mood_id($e) . ')', $I->{onapply}) });
    }
    for my $k (sort { $FEELING{$a}{name} cmp $FEELING{$b}{name} } keys %FEELING) {
        my $F = $FEELING{$k}; my ($x, $y) = split /\+/, $k;
        my $consume = join ';', map { 'RemoveStatus(' . mood_id($_) . ')' } $x, $y;
        push @out, status_entry('FEELING_' . uc $F->{name}, "Feeling: $F->{name}",
            tag_terms("$x and $y, braided together. $F->{text}"),
            $F->{icon}, $F->{kind}, { %$F, stack => 'FEELING_' . uc $F->{name},
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
    # Stage 2: the Overload meter -- a count shown as a frozen duration, like ASPECT_PROGRESS_* (ARCANA_Aspect_Common.txt)
    push @out, ['Status_BOOST', entry('RESONANT_OVERLOAD', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('RESONANT_OVERLOAD', 'NAME'), 'Overload'),
        Description => loca(key('RESONANT_OVERLOAD', 'DESC'), 'Everything you made others feel this fight, felt again. When it is full, you suffer at the start of each turn until you release it with Emotional Overload.'),
        Icon => 'Spell_Enchantment_CalmEmotions', StackId => 'RESONANT_OVERLOAD', StackType => 'Overwrite',
        RemoveEvents => 'OnCombatEnded', StatusPropertyFlags => 'FreezeDuration;IgnoreResting', StatusGroups => 'SG_RemoveOnRespec')];
    # full: Psychic damage equal to the slot level at the start of each turn (25: FEAT_Resonant_Overload#full_damage),
    # by class-level bracket as Arcana_Passive_ArcaneOverflow; flat TickFunctors damage as vanilla ORI_GALE_AURANECROSIS
    my $tick = join ';', map { my ($dmg, $lo, $hi) = @$_; my @c = ("ClassLevelHigherOrEqualThan($lo,'Arcana')");
        push @c, "not ClassLevelHigherOrEqualThan($hi,'Arcana')" if $hi; 'IF(' . join(' and ', @c) . "):DealDamage($dmg,Psychic,Magical)" }
        ([3, 5, 7], [4, 7, 9], [5, 9, 11], [6, 11, undef]);
    push @out, ['Status_BOOST', entry('RESONANT_OVERLOAD_FULL', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca(key('RESONANT_OVERLOAD_FULL', 'NAME'), 'Overloaded'),
        Description => loca(key('RESONANT_OVERLOAD_FULL', 'DESC'), 'You can release Emotional Overload. Until you do, you take Psychic damage at the start of each of your turns.'),
        Icon => 'Spell_Enchantment_CalmEmotions', StackId => 'RESONANT_OVERLOAD_FULL', TickType => 'StartTurn',
        TickFunctors => $tick, RemoveEvents => 'OnCombatEnded', StatusPropertyFlags => 'IgnoreResting')];
    push @out, hidden_status('RESONANT_OVERLOAD_SPENT_TECH', 'Overload spent', 'StackId', 'RESONANT_OVERLOAD_SPENT_TECH');
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
    @out;
}

sub hidden_status {
    my ($id, $name, $field, $functors) = @_;
    ['Status_BOOST', entry($id, 'StatusData', StatusType => 'BOOST', DisplayName => loca(key($id, 'NAME'), $name),
        StackId => $id, StatusPropertyFlags => 'DisableOverhead;DisableCombatlog;DisablePortraitIndicator', $field => $functors)];
}

sub build_passives {
    my $love = st_tag('FEELING_LOVE', 'Love'); my $catharsis = st_tag('CATHARSIS', 'Catharsis');
    my $out = '';
    $out .= passive('Arcana_Passive_EmotionalAlchemy', 'Emotional Alchemy',
        "When your Weave Surge touches a creature that already carries a mood, the threads react instead of surging, and the mood is spent.<br><br>Neighbouring emotions braid into a feeling, such as $love, that lasts $FEELING_TURNS turns.<br><br>Opposing emotions snap into $catharsis: an enemy takes [1] and an ally regains [2].<br><br>When your Weave Surge causes a reaction, you regain the spell slot it used. Once per turn.",
        'Spell_Enchantment_CalmEmotions', DescriptionParams => "DealDamage($CATHARSIS_DICE,Psychic);RegainHitPoints($CATHARSIS_DICE)");
    $out .= passive('Arcana_Passive_Overload', 'Overload',
        'You feel what you make others feel. Each emotion that takes hold adds 1 to your Overload, and each reaction adds 2. When it is full, you take Psychic damage at the start of each turn until you release it with Emotional Overload.',
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
        DescriptionParams => $x{DescriptionParams}, Icon => $icon, Boosts => $x{Boosts});
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

# The Surge's ExtraDescription: what it becomes on each mood, one line per kind of reaction.
our @REACTION_LINES = ([1, 'Primary'], [2, 'Secondary'], [3, 'Tertiary'], [4, 'Catharsis'], [0, 'Intense']);
sub result_name { my ($s, $m, $r) = @_;
    $r->{kind} eq 'catharsis' ? 'Catharsis' : $r->{kind} eq 'intensify' ? $EMO{$s}{intense}{name} : feeling_of($s, $m)->{name} }
sub reaction_list {
    my $s = shift;
    my @lines;
    for my $l (@REACTION_LINES) {
        my ($d, $label) = @$l;
        my @m = grep { distance($s, $_) == $d } @WHEEL;
        my $gate = $GATE{$d};
        my $head = $gate ? "$label (level $GATE_LEVEL{$gate})" : $label;
        push @lines, "$head: " . join(', ', map { my $r = reaction($s, $_);
            st_tag(mood_id($_), $EMO{$_}{mood}{name}) . ' into ' . st_tag($r->{status}, result_name($s, $_, $r)) } @m) . '.';
    }
    join('<br>', @lines) . '<br><br>Any reaction gives back the spell slot this surge used. Once per turn.';   # R16, where players read it
}

sub build_spells {
    my $out = '';
    for my $e (@WHEEL) {
        my $E = $EMO{$e}; my $dark = $E->{side} eq 'I';
        my $desc = tag_terms("$E->{flavour} $E->{effect}<br><br>When the surge fades, it leaves the target "
                 . st_tag(mood_id($e), $E->{mood}{name}) . " for $MOOD_TURNS turns, $E->{mood}{fx}.");
        $out .= entry(spell_id($e), 'SpellData',
            SpellType => 'Target', Level => 1, SpellSchool => 'Enchantment', TargetRadius => 18, AmountOfTargets => 1,
            SpellRoll => 'Ally() or Self() or not SavingThrow(Ability.Wisdom, SourceSpellDC())',
            SpellSuccess => spell_success($e),
            SpellFail => 'ApplyStatus(SAVED_AGAINST_HOSTILE_SPELL,100,0)',
            TargetConditions => target_conditions($e),
            Icon => $E->{icon},
            DisplayName => loca(key(spell_id($e), 'NAME'), "Weave Surge: $e"),
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
            HitAnimationType => $dark ? 'None' : 'MagicalNonDamage', MemoryCost => 1);
    }
    $out;
}

sub build_debug {
    my $passives = 'Arcana_Passive_EmotionalAlchemy;Arcana_Passive_EmpathicSight;Arcana_Passive_ComplexFeelings;Arcana_Passive_Overwhelm;Arcana_Passive_MixedFeelings;Arcana_Passive_Overload';
    my $shout = entry('Shout_Arcana_Util_DEBUG_Resonant', 'SpellData',
        SpellType => 'Shout', Level => 0, SpellSchool => 'Divination', TargetConditions => 'Self()',
        SpellProperties => 'ApplyStatus(RESONANT_DEBUG,100,-1)', Icon => 'GenericIcon_Intent_Buff',
        DisplayName => loca('HW_DEBUG_SHOUT_NAME', '[DEBUG] Resonant Passives'),
        Description => loca('HW_DEBUG_SHOUT_DESC', 'Grants every Resonant passive until you rest, to test Emotional Alchemy.'),
        PreviewCursor => 'Cast', CastTextEvent => 'Cast',
        SpellAnimation => '355a5479-07c9-4a34-9ab6-3b2669fdd248,,;,,;2ac8ee64-6d74-4cad-a74c-660ef3fc3d06,,;5bf6f6e6-353e-40f9-9a6f-0d6d16e19496,,;1c5627cb-6352-454b-9b84-c5b10ef2d201,,;,,;1cc6ba3b-fa78-48f8-858c-ac4c78fdb8fc,,;,,;,,',
        VerbalIntent => 'Utility', SpellStyleGroup => 'Class', SpellFlags => 'IsSpell');
    my $status = entry('RESONANT_DEBUG', 'StatusData', StatusType => 'BOOST',
        DisplayName => loca('HW_DEBUG_STATUS_NAME', '[DEBUG] Resonant'), Icon => 'Spell_Divination_DetectEvilAndGood',
        StackId => 'RESONANT_DEBUG', Passives => $passives,
        Boosts => 'UnlockSpell(Target_Arcana_Created_EmotionalOverload)',   # stage 2: testable before the progression (stage 6)
        RemoveEvents => 'OnLongRest');
    ($shout, $status);
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
our %RETIRED = map { $_ => 1 } qw(Interrupt_Arcana_TrustFollowUp);   # generated once, replaced (R27), never published
sub removals {
    my ($have, $new) = @_;   # $new: name => file
    my %ours = map { my $e = $_; map { (spell_id($e) . "_$_" => 1) } 2 .. 6 } @WHEEL;
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
    my $spells   = build_spells() . build_overload_spell();
    my @statuses = build_statuses();
    my $passives = build_passives();
    my ($shout, $debugst) = build_debug();
    my $interrupts = build_interrupts();
    my %new;
    $new{$_} = 'Interrupt' for names_in($interrupts);
    $new{$_} = 'Spell_Target' for names_in($spells);
    for my $st (@statuses) { $new{$_} = $st->[0] for names_in($st->[1]) }
    $new{$_} = 'Status_BOOST' for names_in($debugst);
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
        $p .= "\@section DEBUG STATUS\n\n$debugst" if $file eq 'Status_BOOST';
    }
    $p .= "\@file Passive\n\@section ARCANA PASSIVES\n\n$passives";
    $p .= "\@file Interrupt\n\@section -\n\n$interrupts";
    $p;
}

# +1 target per variant level, only for variants that already exist (gen_upcast_variants makes them).
sub build_upcast_patch {
    my $have = existing_entries();
    my $p = "# GENERATED by tools/stats/gen_emotion_alchemy.pl -- do not edit by hand.\n"
          . "# Run AFTER gen_upcast_variants.pl --apply: +1 target per slot level.\n\n\@file Spell_Target\n";
    my $n = 0;
    for my $e (@WHEEL) { for my $L (2 .. 6) {
        my $v = spell_id($e) . "_$L";
        next unless ($have->{$v} // '') eq 'Spell_Target';
        $p .= "\@set $v AmountOfTargets $L\n"; $n++ } }
    ($p, $n);
}

sub write_file { my ($path, $s) = @_; make_path(dirname($path)); open my $h, '>:raw', $path or die "$path: $!"; print $h $s; close $h }

# ---------------------------------------------------------------- stage 2: the ultimate and the Overload counter
# Emotional Overload (R9, R10, R20, R22): only with the meter full, no save, no slot. Created: never in the deck.
# Paralysis: vanilla PARALYZED (INCAPACITATED, no RemoveConditions). Numbers: 25 SPL_Resonant_EmotionalOverload.
sub build_overload_spell {
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
        TargetConditions => "Character() and not Dead() and not Ally() and not Self() and not Tagged('CONSTRUCT') and HasStatus('RESONANT_OVERLOAD_FULL', context.Source) and not HasPassive('ARCANA_IS_SPELL', context.Source)",   # Arcana spell mark: detonates the Sigil (check_cards)
        Icon => 'Spell_Enchantment_CalmEmotions',
        DisplayName => loca(key($id, 'NAME'), 'Emotional Overload'),
        Description => loca(key($id, 'DESC'), tag_terms("Pour everything you have felt this fight into one creature. Every feeling it carries tears at it for [1] Psychic damage and is spent, and it is Paralysed for $turns turns. No saving throw.")),
        DescriptionParams => "DealDamage($dmg,Psychic)",
        TooltipStatusApply => "ApplyStatus(PARALYZED,100,$turns)",
        @CAST, PreviewCursor => 'Cast', CastTextEvent => 'Cast',
        CycleConditions => 'Enemy() and not Dead()', UseCosts => 'ActionPoint:1',
        VerbalIntent => 'Control', SpellStyleGroup => 'Class',
        SpellFlags => 'IsSpell;HasVerbalComponent;HasSomaticComponent;IsHarmful', HitAnimationType => 'None');
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
    for my $L (1 .. 20) { my ($t) = grep { $_ <= $L } reverse @th; $t //= $th[0]; push @rows, "DB_ARCANA_Resonant_OverloadMax($L, $by->{$t});" }
    my $g = join "\n", 'Version 1', 'SubGoalCombiner SGC_AND', 'INITSECTION', 'PROC_ARCANA_Resonant_Overload_Init();', '', 'KBSECTION',
        '//REGION Resonant - Overload tables (GENERATED by gen_emotion_alchemy.pl -- do not edit by hand)',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Init()', 'AND', 'DB_ARCANA_Resonant_OverloadPoints(_Status, _Pts)', 'THEN', 'NOT DB_ARCANA_Resonant_OverloadPoints(_Status, _Pts);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Init()', 'AND', 'DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max)', 'THEN', 'NOT DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Init()', 'THEN', @rows, '',
        'IF', 'SavegameLoaded()', 'THEN', 'PROC_ARCANA_Resonant_Overload_Init();', '//END_REGION', '',
        '//REGION Resonant - Overload count: +1 per peak that lands, +2 per reaction, only in combat (R12)',
        'IF', 'StatusApplied(_Target, _Status, (CHARACTER)_Resonant, _)', 'AND', 'DB_ARCANA_Resonant_OverloadPoints(_Status, _Pts)',
        'AND', 'HasPassive(_Resonant, "Arcana_Passive_Overload", 1)', 'AND', 'IsInCombat(_Resonant, 1)', 'AND', 'NOT DB_ARCANA_Resonant_OverloadFull(_Resonant)',
        'THEN', 'PROC_ARCANA_Resonant_Overload_Add(_Resonant, _Pts);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Add((CHARACTER)_Resonant, (INTEGER)_Pts)', 'AND', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _)', 'THEN', 'DB_ARCANA_Resonant_Overload(_Resonant, 0);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Add((CHARACTER)_Resonant, (INTEGER)_Pts)', 'AND', 'DB_ARCANA_Resonant_Overload(_Resonant, _Old)',
        'AND', 'IntegerSum(_Old, _Pts, _New)', 'AND', 'GetLevel(_Resonant, _Lvl)', 'AND', 'DB_ARCANA_Resonant_OverloadMax(_Lvl, _Max)',
        'THEN', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _Old);', 'PROC_ARCANA_Resonant_Overload_Set(_Resonant, _New, _Max);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Set((CHARACTER)_Resonant, (INTEGER)_New, (INTEGER)_Max)', 'AND', '_New < _Max',
        'THEN', 'DB_ARCANA_Resonant_Overload(_Resonant, _New);', 'PROC_ARCANA_Resonant_Overload_Show(_Resonant, _New);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Set((CHARACTER)_Resonant, (INTEGER)_New, (INTEGER)_Max)', 'AND', '_New >= _Max',
        'THEN', 'DB_ARCANA_Resonant_Overload(_Resonant, _Max);', 'DB_ARCANA_Resonant_OverloadFull(_Resonant);',
        'PROC_ARCANA_Resonant_Overload_Show(_Resonant, _Max);', 'ApplyStatus(_Resonant, "RESONANT_OVERLOAD_FULL", -1.0, 1, _Resonant);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Show((CHARACTER)_Resonant, (INTEGER)_N)', 'AND', 'IntegerProduct(_N, 6, _Secs)', 'AND', 'IntegerToReal(_Secs, _Dur)',
        'THEN', 'ApplyStatus(_Resonant, "RESONANT_OVERLOAD", _Dur, 1, _Resonant);', '//END_REGION', '',
        '//REGION Resonant - Overload reset: Emotional Overload released, or the combat left',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Reset((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_Resonant_Overload(_Resonant, _N)', 'THEN', 'NOT DB_ARCANA_Resonant_Overload(_Resonant, _N);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Reset((CHARACTER)_Resonant)', 'AND', 'DB_ARCANA_Resonant_OverloadFull(_Resonant)', 'THEN', 'NOT DB_ARCANA_Resonant_OverloadFull(_Resonant);', '',
        'PROC', 'PROC_ARCANA_Resonant_Overload_Reset((CHARACTER)_Resonant)', 'THEN',
        'RemoveStatus(_Resonant, "RESONANT_OVERLOAD", _Resonant);', 'RemoveStatus(_Resonant, "RESONANT_OVERLOAD_FULL", _Resonant);', '',
        'IF', 'StatusApplied((CHARACTER)_Resonant, "RESONANT_OVERLOAD_SPENT_TECH", _, _)', 'THEN', 'PROC_ARCANA_Resonant_Overload_Reset(_Resonant);', '',
        'IF', 'LeftCombat((CHARACTER)_Resonant, _)', 'THEN', 'PROC_ARCANA_Resonant_Overload_Reset(_Resonant);', '//END_REGION',
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
    write_file("$out/40_overload_goal.txt", overload_goal());
    printf "10_engine.patch: %d new entries, %d removals, %d strings\n",
        scalar(() = $engine =~ /^new entry /mg), scalar(() = $engine =~ /^\@remove /mg), scalar(() = $engine =~ /^\@loca /mg);
    printf "20_upcast_targets.patch: %d variants%s\n", $n, $n ? '' : ' (none yet: run gen_upcast_variants.pl --apply, then generate again)';
}

main() unless caller;
1;
