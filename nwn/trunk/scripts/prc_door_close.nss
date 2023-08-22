//::///////////////////////////////////////////////
//:: OnClose door eventscript
//:: prc_door_close
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONCLOSE);
}