//::///////////////////////////////////////////////
//:: Name      Flesh Armor
//:: FileName  sp_flesh_armor.nss
//:://////////////////////////////////////////////
/**@file Flesh Armor 
Abjuration [Evil] 
Level: Asn 4 
Components: V, S, M, F 
Casting Time: 1 action 
Range: Personal 
Target: Caster
Duration: 10 minutes/level or until discharged
 
 Prior to casting flesh armor, the caster flays the 
 skin from a creature of his size and lays it upon 
 his own flesh, wearing it like clothing or armor. 
 Once the caster casts flesh armor, his skin develops
 resistance to blows, cuts, stabs, and slashes. The 
 caster gains damage reduction 10/+1. Once the spell
 has prevented a total of 5 points of damage per 
 caster level (maximum 50 points), it is discharged,
 and the skin slowly rots, shedding in patches like 
 the skin of a molting snake.
 
 Material Component: A bit of flesh torn from 
 the caster's body during the casting (dealing 1 point
 of damage).

 Focus: The entire freshly harvested skin of another 
 creature of the caster's size.

Author:    Tenjac
Created:   05/05/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur= (600.0f * nCasterLvl);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nAmount = min(50, (5 * nCasterLvl));
	effect eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE, nAmount);
	
	//placeholder VFX
	effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	
	//Spellhook
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	 //Meta Magic
	 if(nMetaMagic & METAMAGIC_EXTEND)
	 {
		 fDur = (fDur * 2);
	 }
	 
	 //Link and Apply
	 
	 effect eLink = EffectLinkEffects(eDR, eVis);
	 
	 SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
	 
	 //SPEvilShift(oPC);
	 
	 PRCSetSchool();
 }
	 
	 
	 
	 
	 
	