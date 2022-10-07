//::///////////////////////////////////////////////
//:: OnClientLeave eventscript
//:: prc_onleave
//:://////////////////////////////////////////////
#include "prc_class_const"
#include "inc_utility"
#include "inc_letoscript"
#include "inc_leto_prc"

void main()
{
    // Execute scripts hooked to this event for the player triggering it
    object oPC = GetExitingObject();
    if(!GetIsDM(oPC))
    {
        if(GetPRCSwitch(PRC_LETOSCRIPT_FIX_ABILITIES))
            PRCLetoExit(oPC);
        if(GetPRCSwitch(PRC_USE_LETOSCRIPT))
            LetoPCExit(oPC);
    }
    AssignCommand(GetModule(), DelayCommand(0.1, RecalculateTime()));
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTLEAVE);
}
