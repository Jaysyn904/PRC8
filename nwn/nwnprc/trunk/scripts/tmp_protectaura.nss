//::///////////////////////////////////////////////////
//:: Name           Saint Template - Protective Aura
//:: FileName       tmp_protectaura.nss
//:: 
//:://////////////////////////////////////////////
/*

Protective Aura (Su): As a free action, a saint can surround herself with a 
nimbus of light having a radius of 20 feet. This acts as a double-strength magic
circle against evil and as a lesser globe of invulnerability both as cast by a 
cleric whose level equal to the saint's Hit Dice.

*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 2022/06/03
//:://////////////////////////////////////////////

#include "prc_inc_spells" 

void main()
{
//:: Declare major variables
    object oPC = OBJECT_SELF;
	
    int CasterLvl = GetHitDice(oPC);
    int nDuration = CasterLvl;
	int nSpellID = PRCGetSpellId();
	
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSpell = EffectSpellLevelAbsorption(4, 0);
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD);
	effect eVis1 = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
	effect eVis2 = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
    effect eVis3 = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eVis4 = EffectVisualEffect(VFX_IMP_GOOD_HELP);	
	
//:: Link Effects
    effect eLink = EffectLinkEffects(eVis1, eVis2);
	eLink = EffectLinkEffects(eLink, eVis3);
	eLink = EffectLinkEffects(eLink, eAOE);
	eLink = EffectLinkEffects(eLink, eSpell);
    eLink = EffectLinkEffects(eLink, eDur);

//:: Duration sanity check
    if (nDuration < 1) {nDuration = 1;}		

//:: Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpellID, FALSE));

//:: No non-good Saints.
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
    { 
		//:: Create AOE and apply the VFX impact and effects
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis4, oPC);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
	}		
	else
	{ 
		SendMessageToPC(oPC, "Saints must be good aligned");
	}
}