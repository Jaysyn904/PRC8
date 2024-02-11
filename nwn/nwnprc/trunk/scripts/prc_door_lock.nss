//::///////////////////////////////////////////////
//:: OnLocked door eventscript
//:: prc_door_lock
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONLOCK);
}