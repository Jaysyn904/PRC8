//::///////////////////////////////////////////////
//:: OnSpellCastAt NPC eventscript
//:: prc_npc_physatt
//:://////////////////////////////////////////////
#include "prc_alterations"

void main()
{
    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONSPELLCASTAT);
}