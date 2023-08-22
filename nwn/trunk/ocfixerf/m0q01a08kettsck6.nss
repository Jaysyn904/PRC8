// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

int StartingConditional()
{
    if(DEBUG) DoDebug("m0q01a08kettsck6 running");

    object oPC = GetPCSpeaker();
    int bCondition = GetLocalInt(OBJECT_SELF, "NW_L_TALKLEVEL") == 2
                  && !GetIsObjectValid(GetItemPossessedBy(oPC,"NW_ROGUE_ITEM"))
                  && (GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC)
                  || GetLevelByClass(CLASS_TYPE_BARD, oPC)
                  || GetLevelByClass(CLASS_TYPE_BEGUILER, oPC)
                  || GetLevelByClass(CLASS_TYPE_NINJA, oPC)
                  || GetLevelByClass(CLASS_TYPE_ROGUE, oPC)
                  || GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE, oPC)
                  || GetLevelByClass(CLASS_TYPE_SCOUT, oPC));
    return bCondition;
}

