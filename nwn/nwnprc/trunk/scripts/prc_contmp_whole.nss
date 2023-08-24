/*
   ----------------
   Divine Wholeness, Contemplative class ability

   prc_contmp_whole
   ----------------
*/
#include "prc_alterations"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nContemp = GetLevelByClass(CLASS_TYPE_CONTEMPLATIVE, oPC);
    int nHP = nContemp * 4;
    effect eHeal = EffectHeal(nHP);
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
}