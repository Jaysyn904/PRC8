//:://////////////////////////////////////////////
//:: Teleport System: Mark location OnRest
//:: prc_telep_mrkrst
//:://////////////////////////////////////////////
/** @file
    Script for storing the user's current location
    as a teleport target location when resting.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 15.08.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_teleport"


void main()
{
    object oPC = GetLastBeingRested();
    // Get the location of whomever triggered this script                      "Last rested here"
    struct metalocation mlocToStore = LocationToMetalocation(GetLocation(oPC), GetStringByStrRef(16825310));

    SetPersistantLocalMetalocation(oPC, PRC_TELEPORT_ARRAY_NAME + "_0", mlocToStore);

    // Tell the user the location was added
    //                   "Added teleport location: "
    SendMessageToPC(oPC, GetStringByStrRef(16825303) + " " + MetalocationToString(mlocToStore));

}