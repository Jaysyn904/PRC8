//:://////////////////////////////////////////////
//:: Mark location for teleporting
//:: prc_telep_mrkloc
//:://////////////////////////////////////////////
/** @file
    Script for storing the user's current location
    as a teleport target location.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 19.06.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
//#include "prc_inc_listener"
#include "prc_inc_chat"
#include "prc_inc_teleport"


void Aux(object oPC, location lToStore);

void main()
{
    object oPC = OBJECT_SELF;

    // To simplify the code and in order to be able avoid the "Aargh! Concurrency!"-effect, do not allow the user to
    // mark one location while the name query for another is still pending.
    if(GetLocalInt(oPC, "PRC_Teleport_MarkingLocation"))
    {
        SendMessageToPCByStrRef(oPC, 16825296); // "A location is already being marked, please wait."
        return;
    }

    location lToStore = GetLocation(oPC);
    float fTime = GetLocalFloat(oPC, "PRC_Teleport_NamingListenerDuration");
    if(fTime > 0.0f)
    {
        //SpawnListener("prc_telep_lname", lToStore, "**", oPC, fTime);
        AddChatEventHook(oPC, "prc_telep_lname", fTime);
        DelayCommand(fTime, Aux(oPC, lToStore));
    }
    else
    {
        DelayCommand(0.0f, Aux(oPC, lToStore));
    }

    // Set the name of the location to be "Unnamed". If the user speaks a name, it will override this.
    SetLocalString(oPC, "PRC_Teleport_LocationBeingStored_Name", GetStringByStrRef(16825297)); // "Unnamed"
}


void Aux(object oPC, location lToStore)
{
    string sName = GetLocalString(oPC, "PRC_Teleport_LocationBeingStored_Name");
    DeleteLocalString(oPC, "PRC_Teleport_LocationBeingStored_Name");

    struct metalocation mlocToStore = LocationToMetalocation(lToStore, sName);

    if(GetLocalInt(oPC, PRC_TELEPORT_CREATE_MAP_PINS))
        CreateMapPinFromMetalocation(mlocToStore, oPC);

    AddTeleportTargetLocationAsMeta(oPC, mlocToStore);

    // Tell the user the location was added
    //                   "Added teleport location: "
    SendMessageToPC(oPC, GetStringByStrRef(16825303) + " "+ MetalocationToString(mlocToStore));
}