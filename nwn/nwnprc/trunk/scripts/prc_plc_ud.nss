//::///////////////////////////////////////////////
//:: OnUserDefined placeable eventscript
//:: prc_plc_ud
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUSERDEFINED);
}