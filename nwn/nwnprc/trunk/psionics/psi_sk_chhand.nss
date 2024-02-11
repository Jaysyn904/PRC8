//::///////////////////////////////////////////////
//:: Soulknife: Change Mindblade Hand
//:: psi_sk_chhand
//::///////////////////////////////////////////////
/** @file
    Changes the hand a mindblade of the single types
    will be manifested to.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_soulkn"

void main()
{
    object oPC = OBJECT_SELF;
    
    // Get the old setting
    int nHand = GetPersistantLocalInt(oPC, MBLADE_HAND);
    // Change the hand to be the opposite
    if(nHand == INVENTORY_SLOT_RIGHTHAND)
    {// "Your mind blade will now be manifested to off hand."
        SendMessageToPCByStrRef(oPC, 16824603);
        nHand = INVENTORY_SLOT_LEFTHAND;
    }
    else
    {// "Your mind blade will now be manifested to main hand."
        SendMessageToPCByStrRef(oPC, 16824604);
        nHand = INVENTORY_SLOT_RIGHTHAND;
    }
    // Store the new value
    SetPersistantLocalInt(oPC, MBLADE_HAND, nHand);
}