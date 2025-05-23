//::///////////////////////////////////////////////
//:: OnPlayerRespawn eventscript
//:: prc_onrespawn
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"
#include "prc_inc_function"

void main()
{
    // Execute scripts hooked to this event for the player triggering it
    object oPC =  GetLastRespawnButtonPresser();
    // clear the death marker if using PW death tracking
    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING))
        SetPersistantLocalInt(oPC, "persist_dead", FALSE);

    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERRESPAWN);
	
	DelayCommand(0.1f, EvalPRCFeats(oPC));
}