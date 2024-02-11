//::///////////////////////////////////////////////
//:: Name      Masochism
//:: FileName  sp_masochism.nss
//:://////////////////////////////////////////////
/**@file Masochism 
Enchantment [Evil] 
Level: Asn 3, Blk 3, Clr 3, Sor/Wiz 2 
Components: V, S, M
Casting Time: 1 action 
Range: Personal 
Target: Caster
Duration: 1 round/level
 
For every 10 points of damage the caster takes in a
given round, he gains a +1 luck bonus on attack 
rolls, saving throws, and skill checks made in 
the following round. The more damage the caster
takes, the greater the luck bonus. It's possible to
get a luck bonus in multiple rounds if the caster 
takes damage in more than one round during the spell's
duration.

Material Component: A leather strap that has been 
soaked in the caster's blood.

Author:    Tenjac
Created:   6/13/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
void MasochLoop(object oPC, int nHP, int nCounter);

#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	int nCounter = PRCGetCasterLevel(oPC);
	int nHP = GetCurrentHitPoints(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if (nMetaMagic & METAMAGIC_EXTEND)
	{
		nCounter += nCounter;
	}
	
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);
	
	MasochLoop(oPC, nHP, nCounter);
	
	PRCSetSchool();
	//SPEvilShift(oPC);
}

void MasochLoop(object oPC, int nHP, int nCounter)
{
	if(nCounter > 0)
	{		
		int nHPChange = (nHP - GetCurrentHitPoints(oPC));
		nHP = GetCurrentHitPoints(oPC);
		int nBonus = nHPChange/10;
		
		effect eLink = EffectAttackIncrease(nBonus);
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL));
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus));
		
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0f);
		
		nCounter--;
				
		DelayCommand(6.0f, MasochLoop(oPC, nHP, nCounter));
	}
}