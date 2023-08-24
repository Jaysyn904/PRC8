//::///////////////////////////////////////////////
//:: Armoured Mind
//:: psi_imnd_armmnd
//::///////////////////////////////////////////////
/*
    Allows a user to expend focus to give themselves a bonus on Will saves
    equal to the base AC of her armour. This lasts for 1 round.

    Using Armoured Mind requires expending psionic focus.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 14.02.2006
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST);
    int nAC = GetBaseAC(oItem);

    // If he isn't wearing armour, this fails
    if(nAC < 1)
    {
        SendMessageToPC(oPC, "You must be wearing armour to use this feat");
        return;
    }
    if(!UsePsionicFocus(oPC))
    {
        SendMessageToPC(oPC, "You must be psionically focused to use this feat");
        return;
    }
    
    // Add the AC as a will save bonus
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nAC);
    // One round duration
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oPC, 6.0);

}