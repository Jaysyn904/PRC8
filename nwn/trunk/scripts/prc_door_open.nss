//::///////////////////////////////////////////////
//:: OnOpen door eventscript
//:: prc_door_open
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONOPEN);
}