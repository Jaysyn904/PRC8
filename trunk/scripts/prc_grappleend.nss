//::///////////////////////////////////////////////
//:: Grapple End 
//:: prc_grappleend
//::///////////////////////////////////////////////
/** @file
    Relies on prc_inc_combmove to end a grapple

    @author Stratovarius
    @date   Created - 2018.9.27
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combmove"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetGrappleTarget(oPC);
    
    if (GetLocalInt(oPC, "GrappleOriginator") == FALSE)
    {
        FloatingTextStringOnCreature("You cannot end a grapple you did not start", oPC, FALSE);
        return;
    }    
    
    EndGrapple(oPC, oTarget);
    // Remove the hooks
    if(DEBUG) DoDebug("prc_grappleend: Removing eventhooks");
    RemoveEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_grapple", TRUE, FALSE);  
    FloatingTextStringOnCreature("Ending grapple", oPC, FALSE);            
}