//::///////////////////////////////////////////////
//:: Acquired werewolf template setup
//:: tmp_s_wwacq
//:://////////////////////////////////////////////

#include "prc_inc_template"
#include "prc_inc_wwolf"

void main()
{
    // A deliberately selected acquired template represents a character
    // who already knows the nature of the affliction. Bite transmission
    // resets this marker until the first recognized involuntary change.
    PRCWWResetRuntimeState(OBJECT_SELF);
    DeletePersistantLocalInt(OBJECT_SELF, "PRC_WW_Embraced");
    SetPersistantLocalInt(OBJECT_SELF, "PRC_WW_Aware", TRUE);
    SetPersistantLocalInt(OBJECT_SELF, "PRC_WW_Manifested", TRUE);
}
