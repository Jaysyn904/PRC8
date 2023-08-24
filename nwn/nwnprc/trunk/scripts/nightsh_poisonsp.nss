#include "prc_alterations"
void main()
{
  object oWeapon = GetSpellCastItem();
  object oTarget = PRCGetSpellTargetObject();

  effect eVis =EffectVisualEffect(VFX_IMP_POISON_S);
  effect ePoison = EffectPoison(101);

  ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
}
