//::///////////////////////////////////////////////
//:: Bolt: Wisdom Drain
//:: NW_S1_BltWisDr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target. 
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:: Updated On: July 15, 2003 Georg Zoeller - Removed saving throws
//:://////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_inc_sp_tch"   
#include "NW_I0_SPELLS"  
  
void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eBolt;
    int nDC = 10 + (nHD/2);
    int nCount = (nHD /3);
    if (nCount == 0)
    {
        nCount = 1;
    }
    int nDamage = d6(nCount);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_ABILITY_DRAIN_WISDOM));
    //Make a saving throw check
    if (PRCDoRangedTouchAttack(oTarget))
    {
        eBolt = EffectAbilityDecrease(ABILITY_WISDOM, nCount);
        eBolt = SupernaturalEffect(eBolt);
        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eBolt, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
