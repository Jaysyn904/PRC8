//::///////////////////////////////////////////////
//:: OnSpellCastAt door eventscript
//:: prc_plc_spell
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONSPELL);
}