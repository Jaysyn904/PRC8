//::///////////////////////////////////////////////
//:: Onheartbeat door eventscript
//:: prc_door_hb
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONHEARTBEAT);
}