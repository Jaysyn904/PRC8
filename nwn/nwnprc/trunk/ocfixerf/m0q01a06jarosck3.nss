// Added compatibility for PRC base classes
// classes for arcane test
#include "inc_debug"
#include "prc_class_const"

int StartingConditional()
{
    if(DEBUG) DoDebug("m0q01a06jarosck3 running");

    object oPC = GetPCSpeaker();
    int bCondition = GetLocalInt(OBJECT_SELF, "NW_L_TALKLEVEL") == 1
                  && (GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC)
                   || GetLevelByClass(CLASS_TYPE_BARD, oPC)
                   || GetLevelByClass(CLASS_TYPE_BEGUILER, oPC)
                   || GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC)
                   || GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC)
                   || GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC)
                   || GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC)
                   || GetLevelByClass(CLASS_TYPE_PSION, oPC)
                   || GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)
                   || GetLevelByClass(CLASS_TYPE_SORCERER, oPC)
                   || GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oPC)
                   || GetLevelByClass(CLASS_TYPE_WARLOCK, oPC)
                   || GetLevelByClass(CLASS_TYPE_WARMAGE, oPC)
                   || GetLevelByClass(CLASS_TYPE_WILDER, oPC)
                   || GetLevelByClass(CLASS_TYPE_WITCH, oPC)
                   || GetLevelByClass(CLASS_TYPE_WIZARD, oPC));
    return bCondition;
}