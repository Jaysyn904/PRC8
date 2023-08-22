#include "prc_alterations"
#include "prc_inc_spells"
#include "inc_poison"

void main()
{
  object oTarget = PRCGetSpellTargetObject();
  effect ePoison = EffectPoison(POISON_RAVAGE_GOLDEN_ICE);

  SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE);
}
