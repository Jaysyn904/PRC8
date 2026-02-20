//::///////////////////////////////////////////////
//:: Bolt: Acid
//:: NW_S1_BltAcid
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature must make a ranged touch attack to hit
    the intended target.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 11 , 2001
//:://////////////////////////////////////////////
#include "prc_inc_spells"  
#include "prc_inc_sp_tch"   
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nHD = GetHitDice(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eBolt;
    int nDC = 10 + (nHD/2);
    int nCount = nHD /2;
    if (nCount == 0)
    {
        nCount = 1;
    }

    int nDamage = d6(nCount);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_ACID));
    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
    //nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC,SAVING_THROW_TYPE_ACID);
    //Make a ranged touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);
    if(nTouch > 0)
    {
        if(nTouch == 2)
        {
            nDamage *= 2;
        }
        //Set damage effect
        eBolt = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        if(nDamage > 0)
        {
            //Apply the VFX impact and effects
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
