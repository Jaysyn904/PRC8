//::///////////////////////////////////////////////
//:: Name           Fiendish template test script
//:: FileName       tmp_t_fiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Fiendish Creature
    
    Fiendish creatures dwell on the lower planes, the realms of evil, although they resemble beings found on 
    the Material Plane. They are more fearsome in appearance than their earthly counterparts.
    
    Creating A Fiendish Creature
    
    "Fiendish" is an inherited template that can be added to any corporeal aberration, animal, dragon, fey, 
    giant, humanoid, magical beast, monstrous humanoid, ooze, plant, or vermin of nongood alignment 
    (referred to hereafter as the base creature).
    
    A fiendish creature uses all the base creature’s statistics and abilities except as noted here. Do not 
    recalculate the creature’s Hit Dice, base attack bonus, saves, or skill points if its type changes.
    Size and Type
    
    Animals or vermin with this template become magical beasts, but otherwise the creature type is unchanged. 
    Size is unchanged. Fiendish creatures encountered on the Material Plane have the extraplanar subtype.
    Special Attacks
    
    A fiendish creature retains all the special attacks of the base creature and also gains the following 
    special attack.
    
    Smite Good (Su)
    
    Once per day the creature can make a normal melee attack to deal extra damage equal to its HD total 
    (maximum of +20) against a good foe.
    
    Special Qualities
    
    A fiendish creature retains all the special qualities of the base creature and also gains the following.
    Hit Dice    Resistance to Cold and Fire     Damage Reduction
    1-3         5   
    4-7         5                               5/magic
    8-11        10                              5/magic
    12 or more  10                              10/magic
    
        * Darkvision out to 60 feet.
        * Damage reduction (see table).
        * Resistance to cold and fire (see table).
        * Spell resistance equal to the creature’s HD + 5 (maximum 25).
    
    If the base creature already has one or more of these special qualities, use the better value.
    
    If a fiendish creature gains damage reduction, its natural weapons are treated as magic weapons for 
    the purpose of overcoming damage reduction.
    
    Abilities
    
    Same as the base creature, but Intelligence is at least 3.
    
    Environment
    
    Any evil-aligned plane.
    
    Challenge Rating
    
    HD 3 or less, as base creature; HD 4 to 7, as base creature +1; HD 8 or more, as base creature +2.
    
    Alignment
    
    Always evil (any).
    
    Level Adjustment
    
    Same as the base creature +2. 


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
        //&& nRace != RACIAL_TYPE_ELEMENTAL
        //&& nRace != RACIAL_TYPE_OUTSIDER
        //&& nRace != RACIAL_TYPE_SHAPECHANGER
        && nRace != RACIAL_TYPE_UNDEAD // Vile Death spell allows undead
        //&& nRace != RACIAL_TYPE_OOZE
        )
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        
    if(GetHasTemplate(TEMPLATE_HALF_FIEND))  
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
}