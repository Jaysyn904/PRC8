//::///////////////////////////////////////////////
//:: OnCombatRoundEnd NPC eventscript
//:: prc_npc_combat
//:://////////////////////////////////////////////
#include "prc_alterations"

void main()
{   
    // Execute scripts hooked to this event for the NPC triggering it
    // Epic spells will take priority here, so any commands given in
    // these may well be ignored.
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONCOMBATROUNDEND);
}