//::///////////////////////////////////////////////
//:: OnAreaTransitionClick door eventscript
//:: prc_door_transit
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONTRANSITION);
}