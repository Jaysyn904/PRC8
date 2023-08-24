// Added compatibility for PRC base classes
// classes that should pass *only* the rogue test go here
#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int bCondition = GetLevelByClass(CLASS_TYPE_NINJA, oPC)
                  || GetLevelByClass(CLASS_TYPE_ROGUE, oPC)
                  || GetLevelByClass(CLASS_TYPE_PSYCHIC_ROGUE, oPC)
                  || GetLevelByClass(CLASS_TYPE_SCOUT, oPC);
    return bCondition;
}