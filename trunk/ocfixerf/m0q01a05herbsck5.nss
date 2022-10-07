// Added compatibility for PRC base classes
// classes similar to ranger - not important
#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return GetLevelByClass(CLASS_TYPE_BOWMAN, oPC)
        || GetLevelByClass(CLASS_TYPE_RANGER, oPC)
        || GetLevelByClass(CLASS_TYPE_SCOUT, oPC)
        || GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oPC);
}