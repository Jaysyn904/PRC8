//::///////////////////////////////////////////////
//:: Bolt: Dominated
//:: NW_S1_BltDomn
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
//:: Declare major variables
	object oNPC		= OBJECT_SELF;
	object oTarget 	= PRCGetSpellTargetObject();
	
    int nHD 		= GetHitDice(oNPC);
	int nCHAMod		= GetAbilityModifier(ABILITY_CHARISMA, oNPC);
    int nDC			= 10 +nCHAMod+ (nHD/2);
	int nCount 		= (nHD + 1) / 2;
    if (nCount == 0) { nCount = 1; }
	nCount 			= GetScaledDuration(nCount, oTarget);
	
    effect eVis 	= EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eBolt 	= EffectDominated();
    eBolt 			= GetScaledEffect(eBolt, oTarget);
    effect eVis2 	= EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    eBolt 			= GetScaledEffect(eBolt, oTarget);
    effect eDur 	= EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink 	= EffectLinkEffects(eBolt, eDur);
    eLink 			= EffectLinkEffects(eLink, eVis2);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oNPC, SPELLABILITY_BOLT_DOMINATE));
	
    //Make a saving throw check
    if (PRCDoRangedTouchAttack(oTarget))
    {
       //Apply the VFX impact and effects
       SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCount));
       SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
