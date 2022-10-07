//::///////////////////////////////////////////////
//:: Teleport include auxiliary
//:: prc_teleport_aux
//::///////////////////////////////////////////////
/** @file
    The script called when an user has made their
    choice when selecting location to teleport to
    using an effect that uses the Teleport() in
    spinc_teleport


    @author Ornedan
    @date   Created - 2005.11.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_teleport"


void main()
{
    if(DEBUG) DoDebug("prc_teleport_aux running");

    object oCaster = OBJECT_SELF;

    TeleportAux(oCaster);
}