//::///////////////////////////////////////////////
//:: Name           Half-fiend template test script
//:: FileName       tmp_t_hfiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Half-Fiend

    No matter its form, a half-fiend is always hideous to behold, having dark scales, horns, glowing red eyes, 
    bat wings, a fetid odor, or some other obvious sign that it is tainted with evil.
    
    Half-Fiend Damage Size  Bite Damage     Claw Damage
    Fine    1   —
    Diminutive  1d2     1
    Tiny    1d3     1d2
    Small   1d4     1d3
    Medium  1d6     1d4
    Large   1d8     1d6
    Huge    2d6     1d8
    Gargantuan  3d6     2d6
    Colossal    4d6     3d6
    
    Half-Fiend Spell-Like Abilities HD  Abilities
    1-2     Darkness 3/day
    3-4     Desecrate
    5-6     Unholy blight
    7-8     Poison 3/day
    9-10    Contagion
    11-12   Blasphemy
    13-14   Unholy aura 3/day, unhallow
    15-16   Horrid wilting
    17-18   Summon monster IX (fiends only)
    19-20   Destruction
    
    
    Creating A Half-Fiend

    "Half-fiend" is an inherited template that can be added to any living, corporeal creature with an 
    Intelligence score of 4 or more and nongood alignment (referred to hereafter as the base creature).

    A half-fiend uses all the base creature’s statistics and special abilities except as noted here.
    
    Size and Type

    The creature’s type changes to outsider. Do not recalculate Hit Dice, base attack bonus, or saves. 
    Size is unchanged. Half-fiends are normally native outsiders.
    Speed

    A half-fiend has bat wings. Unless the base creature has a better fly speed, the creature can fly 
    at the base creature’s base land speed (average maneuverability).
    
    Armor Class

    Natural armor improves by +1 (this stacks with any natural armor bonus the base creature has).
    
    Attack

    A half-fiend has two claw attacks and a bite attack, and the claws are the primary natural weapon. 
    If the base creature can use weapons, the half-fiend retains this ability. A half-fiend fighting without weapons uses a claw when making an attack action. When it has a weapon, it usually uses the weapon instead.
    
    Full Attack

    A half-fiend fighting without weapons uses both claws and its bite when making a full attack. If 
    armed with a weapon, it usually uses the weapon as its primary attack and its bite as a natural 
    secondary attack. If it has a hand free, it uses a claw as an additional natural secondary attack.
    
    Damage

    Half-fiends have bite and claw attacks. If the base creature does not have these attack forms, use 
    the damage values in the table. Otherwise, use the values in the table or the base creature’s damage 
    values, whichever are greater.
    
    Special Attacks

    A half-fiend retains all the special attacks of the base creature and gains the following special attack.
    
    Smite Good (Su)

    Once per day the creature can make a normal melee attack to deal extra damage equal to its HD 
    (maximum of +20) against a good foe.
    
    Spell-Like Abilities

    A half-fiend with an Intelligence or Wisdom score of 8 or higher has spell-like abilities depending 
    on its Hit Dice, as indicated on the table. The abilities are cumulative. Unless otherwise noted, 
    an ability is usable once per day. Caster level equals the creature’s HD, and the save DC is Charisma-based.
    
    Special Qualities

    A half-fiend has all the special qualities of the base creature, plus the following special qualities.

        * Darkvision out to 60 feet.
        * Immunity to poison.
        * Resistance to acid 10, cold 10, electricity 10, and fire 10.
        * Damage reduction: 5/magic (if HD 11 or less) or 10/magic (if HD 12 or more).
        * A half-fiend’s natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
        * Spell resistance equal to creature’s HD + 10 (maximum 35).

    Abilities

    Increase from the base creature as follows: Str +4, Dex +4, Con +2, Int +4, Cha +2.
    
    Skills

    A half-fiend gains skill points as an outsider and has skill points equal to (8 + Int modifier) × (HD + 3). 
    Do not include Hit Dice from class levels in this calculation the half-fiend gains outsider skill points 
    only for its racial Hit Dice, and gains the normal amount of skill points for its class levels. Treat skills 
    from the base creature’s list as class skills, and other skills as cross-class.
    
    Challenge Rating

    HD 4 or less, as base creature +1; HD 5 to 10, as base creature +2; HD 11 or more, as base creature +3.
    
    Alignment

    Always evil (any).
    
    Level Adjustment

    +4. 

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 18/04/06
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    
    int nRace = MyPRCGetRacialType(oPC);
    if(nRace != RACIAL_TYPE_DWARF
        && nRace != RACIAL_TYPE_ELF
        && nRace != RACIAL_TYPE_GNOME
        && nRace != RACIAL_TYPE_HALFLING
        && nRace != RACIAL_TYPE_HALFELF
        && nRace != RACIAL_TYPE_HALFORC
        && nRace != RACIAL_TYPE_HUMAN
        && nRace != RACIAL_TYPE_HUMANOID_GOBLINOID
        && nRace != RACIAL_TYPE_HUMANOID_MONSTROUS
        && nRace != RACIAL_TYPE_HUMANOID_ORC
        && nRace != RACIAL_TYPE_HUMANOID_REPTILIAN
        && nRace != RACIAL_TYPE_ABERRATION
        && nRace != RACIAL_TYPE_ANIMAL
        && nRace != RACIAL_TYPE_BEAST
        && nRace != RACIAL_TYPE_ANIMAL
        && nRace != RACIAL_TYPE_DRAGON
        && nRace != RACIAL_TYPE_FEY
        && nRace != RACIAL_TYPE_GIANT
        && nRace != RACIAL_TYPE_MAGICAL_BEAST
        && nRace != RACIAL_TYPE_VERMIN
        //&& nRace != RACIAL_TYPE_CONSTRUCT
        && nRace != RACIAL_TYPE_ELEMENTAL
        && nRace != RACIAL_TYPE_OUTSIDER
        && nRace != RACIAL_TYPE_SHAPECHANGER
        //&& nRace != RACIAL_TYPE_UNDEAD
        && nRace != RACIAL_TYPE_OOZE
        )
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    
    if(GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < 4)
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        
    if(GetHasTemplate(TEMPLATE_FIENDISH))  
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
}