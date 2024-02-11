//::///////////////////////////////////////////////
//:: OnSpellCastAt door eventscript
//:: prc_door_spell
//:://////////////////////////////////////////////

#include "inc_eventhook"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONSPELL);
}