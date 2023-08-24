//* If I've been healed, Trial has been completed
// Added compatibility for PRC base classes
#include "prc_class_const"

void main()
{
    int nSpell = GetLastSpell();
//* Check if healed
    if(nSpell == SPELL_CURE_MINOR_WOUNDS
    || nSpell == SPELL_CURE_LIGHT_WOUNDS
    || nSpell == SPELL_CURE_MODERATE_WOUNDS
    || nSpell == SPELL_CURE_SERIOUS_WOUNDS
    || nSpell == SPELL_CURE_CRITICAL_WOUNDS)
    {
        RemoveEffect(OBJECT_SELF,GetFirstEffect(OBJECT_SELF));
        object oCaster = GetLastSpellCaster();
        if(GetLocalInt(GetModule(),"NW_G_M1Q0HalfPriest") == TRUE
        || GetLevelByClass(CLASS_TYPE_ARCHIVIST, oCaster)
        || GetLevelByClass(CLASS_TYPE_BARD, oCaster)
        || GetLevelByClass(CLASS_TYPE_CLERIC, oCaster)
        || GetLevelByClass(CLASS_TYPE_DRUID, oCaster)
        || GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oCaster)
        || GetLevelByClass(CLASS_TYPE_HEALER, oCaster)
        || GetLevelByClass(CLASS_TYPE_MYSTIC, oCaster)
        || GetLevelByClass(CLASS_TYPE_SHAMAN, oCaster)
        || GetLevelByClass(CLASS_TYPE_SHUGENJA, oCaster)
        || GetLevelByClass(CLASS_TYPE_TEMPLAR, oCaster)
        || GetLevelByClass(CLASS_TYPE_WITCH, oCaster))
        {
            SetLocalInt(GetModule(),"NW_G_M0Q01_PRIEST_TEST",2);
            AssignCommand(GetNearestObjectByTag("M1Q0BElynwyd"),
                          SpeakOneLinerConversation());
        }
        else
        {
            SetLocalInt(GetModule(),"NW_G_M1Q0HalfPriest",TRUE);
            SetLocalInt(GetModule(),"NW_G_M1Q0Healing",TRUE);
        }
    }
}