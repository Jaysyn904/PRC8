/*
    prc_dnc_chrnltch

    Charnel Touch
    Does 1d8 negative energy damage plus 1 per four levels to touched creatures.
    Undead are healed 1 + 1 per 4 levels.
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"

void main()
{
  object oCaster = OBJECT_SELF;
  object oTarget = PRCGetSpellTargetObject();
  int nClass = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oCaster);
  int iEleDmg = DAMAGE_TYPE_NEGATIVE;
  int iNegDam = d8() + (nClass / 4);
  
  if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
  || (GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
  || GetLocalInt(oTarget, "AcererakHealing"))
  {
    effect eVis2 = EffectVisualEffect(VFX_IMP_DOOM);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1 + (nClass/4)), oTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
  }
  else
  {
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));

      SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOOM), oTarget);
      ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, iNegDam, iEleDmg);
    }
  }
}