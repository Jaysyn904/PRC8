/////////////////////////////////////////////////
// Fist of Hextor Strength Boost
//-----------------------------------------------
// Created By: Stratovarius
/////////////////////////////////////////////////
#include "prc_alterations"
#include "prc_class_const"

void main()
{

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eLink = EffectLinkEffects(eStr, eDur);
    eLink = ExtraordinaryEffect(eLink);
    int nDur = (GetLevelByClass(CLASS_TYPE_HEXTOR, OBJECT_SELF) + 4);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDur));

}