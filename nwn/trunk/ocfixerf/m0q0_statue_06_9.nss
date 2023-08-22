//* Check to see if a spell was cast at the statue, which will destroy it and
// Added compatibility for PRC base classes
#include "inc_debug"
#include "prc_class_const"

void main()
{
    if(DEBUG) DoDebug("m0q0_statue_06_9 running");

    object oCaster = GetLastSpellCaster();
    if(GetLevelByClass(CLASS_TYPE_ARTIFICER, oCaster)
    || GetLevelByClass(CLASS_TYPE_BARD, oCaster)
    || GetLevelByClass(CLASS_TYPE_BEGUILER, oCaster)
    || GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oCaster)
    || GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oCaster)
    || GetLevelByClass(CLASS_TYPE_DUSKBLADE, oCaster)
    || GetLevelByClass(CLASS_TYPE_HEXBLADE, oCaster)
    || GetLevelByClass(CLASS_TYPE_PSION, oCaster)
    || GetLevelByClass(CLASS_TYPE_PSYWAR, oCaster)
    || GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oCaster)
    || GetLevelByClass(CLASS_TYPE_SORCERER, oCaster)
    || GetLevelByClass(CLASS_TYPE_WARLOCK, oCaster)
    || GetLevelByClass(CLASS_TYPE_WARMAGE, oCaster)
    || GetLevelByClass(CLASS_TYPE_WILDER, oCaster)
    || GetLevelByClass(CLASS_TYPE_WITCH, oCaster)
    || GetLevelByClass(CLASS_TYPE_WIZARD, oCaster))
    {
        effect eDeath = EffectDeath(TRUE);
        SetPlotFlag(OBJECT_SELF,FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,OBJECT_SELF);
        SetLocalInt(GetModule(),"NW_G_M0Q01_MAGE_TEST",2);
        AssignCommand(GetNearestObjectByTag("M1Q0BJaroo"),
                      SpeakOneLinerConversation());
    }
}