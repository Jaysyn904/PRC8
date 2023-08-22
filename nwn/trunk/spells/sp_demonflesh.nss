//::///////////////////////////////////////////////
//:: Name      Demonflesh
//:: FileName  sp_demonflesh.nss
//:://////////////////////////////////////////////
/**@file Demonflesh
Transmutation [Evil]
Level: Blk 1, Demonic 1, Demonologist 1
Components: V, S
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 1 minute/level
 
The caster grows the thick, leathery flesh of a demon,
gaining a +1 natural armor bonus to Armor Class for 
every five caster levels (at least +1, maximum +4). 
This spell has no effect if the caster is an evil 
outsider.

Author:    Tenjac
Created:   03/25/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//define vars
	object oPC = OBJECT_SELF;
	int nEnhance = 1;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = (60.0f * nCasterLvl);
			
	//+1/5 levels, min 1, max 4
	if(nCasterLvl > 9)
	{
		nEnhance = 2;
	}
	
	if(nCasterLvl > 14)
	{
		nEnhance = 3;
	}
	
	if(nCasterLvl > 19)
	{
		nEnhance = 4;
	}
	
	//Eval for Extend
	if(nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur = (fDur * 2);
	}
			
	//Apply armor bonus
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(nEnhance, AC_NATURAL_BONUS), oPC, fDur);
	
	//SPEvilShift(oPC);
	
	PRCSetSchool();
}