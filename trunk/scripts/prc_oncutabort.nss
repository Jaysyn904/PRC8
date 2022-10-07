//::///////////////////////////////////////////////
//:: OnCutsceneAbort eventscript
//:: prc_oncutabort
//:://////////////////////////////////////////////
#include "prc_alterations"

void main()
{
    // Execute scripts hooked to this event for the player triggering it
    object oPC = GetLastPCToCancelCutscene();
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCUTSCENEABORT);
}
