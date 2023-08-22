//::///////////////////////////////////////////////
//:: OnPhysicalAttacked door eventscript
//:: prc_door_phyatt
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONATTACKED);
}