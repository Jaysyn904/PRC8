//::///////////////////////////////////////////////
//:: OnHeartbeat placeable eventscript
//:: prc_plc_hb
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONHEARTBEAT);
}