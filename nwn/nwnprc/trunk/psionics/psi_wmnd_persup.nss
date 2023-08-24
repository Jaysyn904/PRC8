/////////////////////////////////////////////////
// Warmind Chain of Personal Superiority
//-----------------------------------------------
// Created By: Stratovarius
/////////////////////////////////////////////////
#include "prc_alterations"
#include "prc_class_const"

void main()
{

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
    int nClass = GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF);
    int nBonus = 2;
    if (nClass >= 7) nBonus = 4;
    
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nBonus);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nBonus);
    effect eLink = EffectLinkEffects(eStr, eDur);
    eLink = EffectLinkEffects(eLink, eCon);
    eLink = ExtraordinaryEffect(eLink);
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 60.0);

}