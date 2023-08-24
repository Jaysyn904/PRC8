//::///////////////////////////////////////////////
//:: OnDamaged placeable eventscript
//:: prc_plc_damaged
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONDAMAGED);
}