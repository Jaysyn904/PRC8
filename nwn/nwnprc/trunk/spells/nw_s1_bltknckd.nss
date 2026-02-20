//::///////////////////////////////////////////////
//:: Bolt: Knockdown
//:: NW_S1_BltKnckD
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
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eBolt = EffectKnockdown();
    int nDC = 10 + (nHD/2);
    effect eDam = PRCEffectDamage(oTarget, d6(), DAMAGE_TYPE_BLUDGEONING);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BOLT_KNOCKDOWN));
    //Make a saving throw check
    if (PRCDoRangedTouchAttack(oTarget))
    {
       //Apply the VFX impact and effects
       SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, RoundsToSeconds(3));
       SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
       SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}
