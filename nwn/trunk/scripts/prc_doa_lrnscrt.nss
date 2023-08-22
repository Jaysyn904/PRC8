//::///////////////////////////////////////////////
//:: Disciple of Asmodeus Learn Secret
//:: prc_doa_lrnscrt.nss
//::///////////////////////////////////////////////
/*
    Gives them a +10 bonus to Lore for 1 round a day.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    	object oPC = OBJECT_SELF;
    
    	effect eLore = EffectSkillIncrease(SKILL_LORE, 10);
    	effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eVis, eDur);
    	eLink = EffectLinkEffects(eLink, eLore);
    
	//Apply linked and VFX effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(1),TRUE,-1,99);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);    
}