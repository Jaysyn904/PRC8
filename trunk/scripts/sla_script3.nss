
//::///////////////////////////////////////////////
//:: Name       Spell-like-ability script
//:: FileName   sla_script
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Used for Archmage and Heirophant SLA ability
    
    Spell-Like Ability
    
    An archmage who selects this type of high arcana can use 
    one of her arcane spell slots (other than a slot expended 
    to learn this or any other type of high arcana) to 
    permanently prepare one of her arcane spells as a spell-like 
    ability that can be used twice per day. The archmage does 
    not use any components when casting the spell, although a 
    spell that costs XP to cast still does so and a spell with 
    a costly material component instead costs her 10 times that 
    amount in XP. This ability costs one 5th-level spell slot.
    
    
    The spell-like ability normally uses a spell slot of the 
    spell’s level, although the archmage can choose to make a 
    spell modified by a metamagic feat into a spell-like ability 
    at the appropriate spell level.
    
    The archmage may use an available higher-level spell slot 
    in order to use the spell-like ability more often. Using a 
    slot three levels higher than the chosen spell allows her 
    to use the spell-like ability four times per day, and a 
    slot six levels higher lets her use it six times per day.
    
    If spell-like ability is selected more than one time as a 
    high arcana choice, this ability can apply to the same spell 
    chosen the first time (increasing the number of times per day 
    it can be used) or to a different spell. 


    Implementation notes:
    
    These abilities are implmented as loosing spellslot levels rather 
    than loosing specific slots.
    
    To keep this viable for different level spells, the uses/day
    depends on the spelllevel.
    
    0 5
    1 5
    2 4
    3 4
    4 3
    5 3
    6 2 
    7 2
    8 1
    9 1

    When this ability it used, it first checks if not stored already.
    If not stored, it uses spellhooking to catch the next spell cast
    and store that
    If stored, it uses ActionCastSpell to cast that spell at the
    appropriate level & DC.

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 4/9/06
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

int SLA_ID = 3;

void main()
{

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = PRCGetSpellTargetLocation();
    DoArchmageHeirophantSLA(oPC, oTarget, lTarget, 3);
}