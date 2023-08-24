//::///////////////////////////////////////////////
//:: Teleport System - Clear Quickselection
//:: prc_telep_end_qs
//::///////////////////////////////////////////////
/** @file
    This featscript deactivates the user's teleport
    target location quickselection by deleting the
    variable it is stored in.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 31.05.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_teleport"

void main()
{
    object oPC = OBJECT_SELF;

    // Clear the quickselection
    RemoveTeleportQuickSelection(oPC, PRC_TELEPORT_ACTIVE_QUICKSELECTION);
    
    SendMessageToPCByStrRef(oPC, 16825291); // "Teleport quickselection deactivated"
}