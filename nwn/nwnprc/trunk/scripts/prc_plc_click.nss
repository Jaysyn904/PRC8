//::///////////////////////////////////////////////
//:: OnClick placeable eventscript
//:: prc_plc_click
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONCLICK);
}