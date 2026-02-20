//::///////////////////////////////////////////////
//:: Bolt: Lightning
//:: NW_S1_BltLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 1d6 per level to a single target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 10, 2001
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
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF,BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eBolt;
    int nDC = 10 + (nHD/2);
    int nCount = nHD /2;
    if (nCount == 0)
    {
        nCount = 1;
    }

    int nDamage = d6(nCount);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_LIGHTNING));
    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
    //nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC,SAVING_THROW_TYPE_ELECTRICITY);
    //Make a ranged touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);
    if(nTouch > 0)
    {
        if(nTouch == 2)
        {
            nDamage *= 2;
        }
        //Set damage effect
        eBolt = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_ELECTRICAL);
        if(nDamage > 0)
        {
            //Apply the VFX impact and effects
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
        }
    }
    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    //SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 1.8);
}
