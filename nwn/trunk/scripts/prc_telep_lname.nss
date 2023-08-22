//:://////////////////////////////////////////////
//:: Script used in marking teleport locations
//:: prc_telep_lname
//:://////////////////////////////////////////////
/** @file
    This script stores the string spoken by the player
    into a local variable on them.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 20.06.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_chat"

void main()
{
    object oPC = OBJECT_SELF;
    // Store the spoken value
    string sName = GetLocalString(oPC, PRC_PLAYER_RESPONSE);
    SetLocalString(oPC, "PRC_Teleport_LocationBeingStored_Name", sName);
    //                               "Name gotten:"
    SendMessageToPC(oPC, GetStringByStrRef(16825307) + " " + sName);
}