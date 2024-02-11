//::///////////////////////////////////////////////
//:: Soulknife: Psychic Strike
//:: psi_sk_psychsrtk <- typo in the file name
//::///////////////////////////////////////////////
/*
    Charges the mindblade. Next hit against a
    living, non-mindless creature will deal extra
    dice of damage based on SK level.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


void main()
{
    object oPC = OBJECT_SELF;
    
    // Make sure the PC is wielding at least one mindblade
    if(!(GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)), 14) == "prc_sk_mblade_" ||
         GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oPC)), 14) == "prc_sk_mblade_"
       ) )
    {
        // Inform the player and return
        SendMessageToPCByStrRef(oPC, 16824509); // "You must have a mindblade manifested to use this feat."
        return;
    }
    
    if (!GetLocalInt(oPC, "MindCleave"))
    {
    	if(!TakeMoveAction(oPC)) return;
    }	

    // Charge mainhand blade first
    if(!GetLocalInt(oPC, PSYCHIC_STRIKE_MAINH) && GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)), 14) == "prc_sk_mblade_")
    {
        SetLocalInt(oPC, PSYCHIC_STRIKE_MAINH, TRUE);
        SendMessageToPCByStrRef(oPC, 16824599); // "You have charged the mindblade in your main hand."
    }
    else if(!GetLocalInt(oPC, PSYCHIC_STRIKE_OFFH) && GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oPC)), 14) == "prc_sk_mblade_")
    {
        SetLocalInt(oPC, PSYCHIC_STRIKE_OFFH, TRUE);
        SendMessageToPCByStrRef(oPC, 16824600); // "You have charged the mindblade in your off hand."
    }
    else // "Your Psychic Strike is already active."
        SendMessageToPCByStrRef(oPC, 16824498);
}
