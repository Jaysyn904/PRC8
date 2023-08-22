//:://////////////////////////////////////////////
//:: Teleport Quickselection
//:: prc_telep_quicks
//:://////////////////////////////////////////////
/** @file
    This script is used by the teleport quick-
    selection feats. When used, it sets the
    metalocation bound to that
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 31.05.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"


const int QUICKSELECT_BEGIN = 2696;

void main()
{
    object oPC = OBJECT_SELF;
    int nInd = GetSpellId() - QUICKSELECT_BEGIN;
    struct metalocation mlocL;

    // Make sure there is a metalocation in this slot
    if(!GetLocalInt(oPC, "PRC_Teleport_QuickSelection_" + IntToString(nInd)))
    {
        SendMessageToPCByStrRef(oPC, 16825292); //"This quickselection slot is empty!"
        return;
    }

    // Get this quickslot's metalocation
    mlocL = GetLocalMetalocation(oPC, "PRC_Teleport_QuickSelection_" + IntToString(nInd));

    if(!GetIsMetalocationValid(mlocL)) SendMessageToPC(oPC, "Not valid!");

    // Set it as the active quickselection
    SetLocalInt(oPC, "PRC_Teleport_Quickselection", TRUE); // Mark quickselection as active
    SetLocalMetalocation(oPC, "PRC_Teleport_Quickselection", mlocL);
    
    //              Teleport location quickselection set to
    SendMessageToPC(oPC, GetStringByStrRef(16825293) + " " + MetalocationToString(mlocL));
}