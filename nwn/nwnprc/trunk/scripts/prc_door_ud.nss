//::///////////////////////////////////////////////
//:: OnUserDefined door eventscript
//:: prc_door_ud
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONUSERDEFINED);
}