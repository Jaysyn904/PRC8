//::///////////////////////////////////////////////
//:: OnDeath placeable eventscript
//:: prc_plc_death
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONDEATH);
}