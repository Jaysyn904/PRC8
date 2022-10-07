//::///////////////////////////////////////////////
//:: Name      Sure Strike
//:: FileName  sp_sure_strike.nss
//:://////////////////////////////////////////////
/**@file Sure Strike
Divination
Level: Duskblade 2, sorcerer/wizard 2
Components: V
Casting Time: 1 swift action
Range: Personal
Target: You
Duration: 1 round or until discharged

You cast this spell immediately before you make an
attack roll.  You can see into the future for that
attack, granting you a +1 insight bonus per three 
caster levels on your next attack roll.
**/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_DIVINATION);
	
	object oPC = OBJECT_SELF;
	effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
	int nCasterLvl = PRCGetCasterLevel(oPC);
		
	// determine the attack bonus to apply
	effect eAttack = EffectAttackIncrease(nCasterLvl/3);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eAttack, eDur);
	
	PRCSignalSpellEvent(oPC, FALSE, SPELL_SURE_STRIKE, oPC);
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(1));
	
	PRCSetSchool();
}
	