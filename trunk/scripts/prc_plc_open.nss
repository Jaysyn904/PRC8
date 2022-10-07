//::///////////////////////////////////////////////
//:: OnOpened door eventscript
//:: prc_plc_open
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONOPEN);
}