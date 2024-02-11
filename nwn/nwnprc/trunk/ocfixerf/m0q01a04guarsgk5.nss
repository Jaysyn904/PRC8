// Added compatibility for PRC base classes
// classes that should pass the rogue and arcane test go here
#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int bCondition = GetLevelByClass(CLASS_TYPE_BARD, oPC)
                  || GetLevelByClass(CLASS_TYPE_BEGUILER, oPC);
    return bCondition;
}