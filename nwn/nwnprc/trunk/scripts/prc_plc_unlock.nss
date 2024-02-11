//::///////////////////////////////////////////////
//:: OnUnocked placeable eventscript
//:: prc_plc_unlock
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUNLOCK);
}