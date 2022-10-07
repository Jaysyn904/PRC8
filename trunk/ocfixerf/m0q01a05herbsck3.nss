// Added compatibility for PRC base classes
// classes similar to paladin - not important
#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, oPC)
        || GetLevelByClass(CLASS_TYPE_CRUSADER, oPC)
        || GetLevelByClass(CLASS_TYPE_KNIGHT, oPC)
        || GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
}