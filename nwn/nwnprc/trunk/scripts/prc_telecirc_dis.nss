//:://////////////////////////////////////////////
//:: Teleportation Circle Trigger OnDisarmed
//:: prc_telecirc_dis
//:://////////////////////////////////////////////
/** @file
    OnDisarmed script of the trap trigger created
    by Teleporation Circle spell / power. Destroys
    both itself and the AoE object.

    @author Ornedan
    @date   Created  - 2005.10.26
    @date   Modified - 2006.06.04
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_telecircle"

void main()
{
    if(DEBUG) DoDebug("prc_telecirc_dis running, disarmed by " + DebugObject2Str(GetLastDisarmed()));

    object oTrap = OBJECT_SELF;
    object oAoE  = GetLocalObject(oTrap, "AreaOfEffectObject");

    // Destroy all traps linked to the AoE and the AoE itself
    int i;
    for(i = 0; i < TC_NUM_TRAPS; i++)
        DestroyObject(GetLocalObject(oAoE, "Trap_" + IntToString(i)));
    DestroyObject(oAoE);
}