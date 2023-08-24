// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

int StartingConditional()
{
    if(DEBUG) DoDebug("m0q01a08kettsck8 running");

    object oPC = GetPCSpeaker();
    int bCondition = (GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC)
                   || GetLevelByClass(CLASS_TYPE_BARD, oPC)
                   || GetLevelByClass(CLASS_TYPE_BEGUILER, oPC)
                   || GetLevelByClass(CLASS_TYPE_NINJA, oPC)
                   || GetLevelByClass(CLASS_TYPE_ROGUE, oPC)
                   || GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE, oPC)
                   || GetLevelByClass(CLASS_TYPE_SCOUT, oPC))
                   && GetLocalInt(GetModule(),"NW_G_M0Q01_ROGUE_TEST") < 2;
    return bCondition;
}