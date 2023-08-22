//::///////////////////////////////////////////////
//:: OnDeath door eventscript
//:: prc_door_death
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONDEATH);
}