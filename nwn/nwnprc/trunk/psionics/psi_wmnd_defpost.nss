/////////////////////////////////////////////////
// Warmind Chain of Defensive Posture
//-----------------------------------------------
// Created By: Stratovarius
/////////////////////////////////////////////////
#include "prc_alterations"
#include "prc_class_const"

void main()
{

    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_DEATH_ARMOR);
    
    int nClass = GetLevelByClass(CLASS_TYPE_WARMIND, OBJECT_SELF);
    int nBonus = 2;
    if (nClass >= 8) nBonus = 4;
    
    effect eAC = EffectACIncrease(nBonus);
    effect eLink = EffectLinkEffects(eAC, eDur);
    eLink = ExtraordinaryEffect(eLink);
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 60.0);

}