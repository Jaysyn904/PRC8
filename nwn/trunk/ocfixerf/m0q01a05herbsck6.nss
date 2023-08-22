// Added compatibility for PRC base classes
// classes similar to monk - not important
#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int bCondition = GetLevelByClass(CLASS_TYPE_BRAWLER, oPC)
                  || GetLevelByClass(CLASS_TYPE_MONK, oPC)
                  || GetLevelByClass(CLASS_TYPE_SOHEI, oPC);
    return bCondition;
}