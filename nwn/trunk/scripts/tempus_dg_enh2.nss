#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"


int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iLvl=GetLevelByClass(CLASS_TYPE_TEMPUS,OBJECT_SELF);

    return (iLvl>5 && GetLocalInt(oPC,"TempusPower")>1);
}

