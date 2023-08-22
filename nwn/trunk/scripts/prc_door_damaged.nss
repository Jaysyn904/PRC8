//::///////////////////////////////////////////////
//:: OnDamaged door eventscript
//:: prc_door_damaged
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONDAMAGED);
}