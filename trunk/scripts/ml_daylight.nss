#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
  object oPC = OBJECT_SELF;
  object oTarget = PRCGetSpellTargetObject();
  effect eAoE = EffectAreaOfEffect(VFX_MOB_DAYLIGHT);
  int nCasterLvl = GetPrCAdjustedCasterLevelByType(TYPE_DIVINE,oPC,1);
  float fDur = (600.0f * nCasterLvl);

  SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oTarget, fDur);
}
