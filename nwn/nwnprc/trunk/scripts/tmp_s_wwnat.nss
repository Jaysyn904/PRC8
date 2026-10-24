//::///////////////////////////////////////////////
//:: Natural werewolf template setup
//:: tmp_s_wwnat
//:://////////////////////////////////////////////

#include "prc_inc_template"
#include "prc_inc_wwolf"

void main()
{
    object oPC = OBJECT_SELF;
    SetPersistantLocalInt(oPC, "PRC_WW_Aware", TRUE);
}

