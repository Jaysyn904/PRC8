//::///////////////////////////////////////////////
//:: OnLocked placeable eventscript
//:: prc_plc_lock
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONLOCK);
}