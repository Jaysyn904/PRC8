//::///////////////////////////////////////////////
//:: Name           Celestial template test script
//:: FileName       tmp_t_celest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Half-Celestial
    
    No matter the form, half-celestials are always comely and delightful to the senses, having golden skin,
    sparkling eyes, angelic wings, or some other sign of their higher nature.
    
    Creating A Half-Celestial
    
    "Half-celestial" is an inherited template that can be added to any living, corporeal creature with an 
    Intelligence score of 4 or higher and nonevil alignment (referred to hereafter as the base creature).
    
    A half-celestial uses all the base creature’s statistics and special abilities except as noted here.
    
    Size and Type
    
    The creature’s type changes to outsider. Do not recalculate the creature’s Hit Dice, base attack bonus, 
    or saves. Size is unchanged. Half-celestials are normally native outsiders.
    
    Speed
    
    A half-celestial has feathered wings and can fly at twice the base creature’s base land speed 
    (good maneuverability). If the base creature has a fly speed, use that instead.
    
    Armor Class
    
    Natural armor improves by +1 (this stacks with any natural armor bonus the base creature has).
    
    Special Attacks
    
    A half-celestial retains all the special attacks of the base creature and also gains the following special 
    abilities.
    
    Daylight (Su)
    
    Half-celestials can use a daylight effect (as the spell) at will.
    
    Smite Evil (Su)
    
    Once per day a half-celestial can make a normal melee attack to deal extra damage equal to its HD 
    (maximum of +20) against an evil foe.
    
    HD  Abilities
    1-2     Protection from evil 3/day, bless
    3-4     Aid, detect evil
    5-6     Cure serious wounds, neutralize poison
    7-8     Holy smite, remove disease
    9-10    Dispel evil
    11-12   Holy word
    13-14   Holy aura 3/day, hallow
    15-16   Mass charm monster
    17-18   Summon monster IX (celestials only)
    19-20   Resurrection
    
    Spell-Like Abilities
    
    A half-celestial with an Intelligence or Wisdom score of 8 or higher has two or more spell-like abilities, 
    depending on its Hit Dice, as indicated on the table below. The abilities are cumulative
    
    Unless otherwise noted, an ability is usable once per day. Caster level equals the creature’s HD, and the 
    save DC is Charisma-based.
    
    Special Qualities
    
    A half-celestial has all the special qualities of the base creature, plus the following special qualities.
    
        * Darkvision out to 60 feet.
        * Immunity to disease.
        * Resistance to acid 10, cold 10, and electricity 10.
        * Damage reduction: 5/magic (if HD 11 or less) or 10/magic (if HD 12 or more).
        * A half-celestial’s natural weapons are treated as magic weapons for the purpose of overcoming damage reduction.
        * Spell resistance equal to creature’s HD + 10 (maximum 35).
        * +4 racial bonus on Fortitude saves against poison.
    
    Abilities
    
    Increase from the base creature as follows: Str +4, Dex +2, Con +4, Int +2, Wis +4, Cha +4.
    
    Skills
    
    A half-celestial gains skill points as an outsider and has skill points equal to (8 + Int modifier) × (HD +3). 
    Do not include Hit Dice from class levels in this calculation—the half-celestial gains outsider skill points only for its racial Hit Dice, and gains the normal amount of skill points for its class levels. Treat skills from the base creature’s list as class skills, and other skills as cross-class.
    
    Challenge Rating
    
    HD 5 or less, as base creature +1; HD 6 to 10, as base creature +2; HD 11 or more, as base creature +3.
    
    Alignment
    
    Always good (any).
    
    Level Adjustment
    
    Same as base creature +4. 

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
    
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
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
        
    if(GetHasTemplate(TEMPLATE_CELESTIAL))  
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
}