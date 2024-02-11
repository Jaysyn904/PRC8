//::///////////////////////////////////////////////
//:: OnFailToOpen door eventscript
//:: prc_door_fail
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONFAILTOOPEN);
}