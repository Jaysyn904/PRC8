// Added compatibility for PRC base classes
// classes that should pass *only* the priest test go here
#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int bCondition = GetLocalInt(OBJECT_SELF, "NW_L_TALKLEVEL") == 1
                  && (GetLevelByClass(CLASS_TYPE_ARCHIVIST, oPC)
                  || GetLevelByClass(CLASS_TYPE_CLERIC, oPC)
                  || GetLevelByClass(CLASS_TYPE_DRUID, oPC)
                  || GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC)
                  || GetLevelByClass(CLASS_TYPE_HEALER, oPC)
                  || GetLevelByClass(CLASS_TYPE_MYSTIC, oPC)
                  || GetLevelByClass(CLASS_TYPE_SHAMAN, oPC)
                  || GetLevelByClass(CLASS_TYPE_SHUGENJA, oPC)
                  || GetLevelByClass(CLASS_TYPE_TEMPLAR, oPC));
    return bCondition;
}