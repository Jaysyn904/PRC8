// Added compatibility for PRC base classes
// All divine classes - not really important
#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int bCondition = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, oPC)
                  || GetLevelByClass(CLASS_TYPE_ARCHIVIST, oPC)
                  || GetLevelByClass(CLASS_TYPE_CLERIC, oPC)
                  || GetLevelByClass(CLASS_TYPE_CRUSADER, oPC)
                  || GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC)
                  || GetLevelByClass(CLASS_TYPE_DRUID, oPC)
                  || GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC)
                  || GetLevelByClass(CLASS_TYPE_HEALER, oPC)
                  || GetLevelByClass(CLASS_TYPE_MYSTIC, oPC)
                  || GetLevelByClass(CLASS_TYPE_PALADIN, oPC)
                  || GetLevelByClass(CLASS_TYPE_SHAMAN, oPC)
                  || GetLevelByClass(CLASS_TYPE_SHUGENJA, oPC)
                  || GetLevelByClass(CLASS_TYPE_SOHEI, oPC)
                  || GetLevelByClass(CLASS_TYPE_TEMPLAR, oPC);
    return bCondition;
}