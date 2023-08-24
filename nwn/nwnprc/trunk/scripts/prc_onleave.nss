//::///////////////////////////////////////////////
//:: OnClientLeave eventscript
//:: prc_onleave
//:://////////////////////////////////////////////
#include "prc_class_const"
#include "inc_utility"

void main()
{
    // Execute scripts hooked to this event for the player triggering it
    object oPC = GetExitingObject();
    AssignCommand(GetModule(), DelayCommand(0.1, RecalculateTime()));
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTLEAVE);
}
