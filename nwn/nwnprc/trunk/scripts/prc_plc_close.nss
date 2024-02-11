//::///////////////////////////////////////////////
//:: OnClose placeable eventscript
//:: prc_plc_close
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONCLOSE);
}