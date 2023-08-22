//::///////////////////////////////////////////////
//:: Name      Vodare
//:: FileName  sp_vodare.nss 
//:://////////////////////////////////////////////
/** Script for the drug Vodare

Author:    Tenjac
Created:   5/23/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_drugfunc"

void main()
{
	object oPC = OBJECT_SELF;
	float fDur = HoursToSeconds(d4(1));
	
	//Vodare primary
	//+2 Intimidate and fear saving throws 1d4 hours
	effect eBuff = EffectSkillIncrease(SKILL_INTIMIDATE, 2);
	       eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR));
	       
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oPC, fDur);
	
	//Vodare secondary
	//-4 Diplomacy & bluff 2d4 hours
	effect eDebuff = EffectSkillDecrease(SKILL_PERSUADE, 4);
	       eDebuff = EffectLinkEffects(eDebuff, EffectSkillDecrease(SKILL_BLUFF, 4));
	
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oPC, HoursToSeconds(d4(2))));
	
	//Vodare overdose - more than 1 dose in 4 hours
	//catatonic fort DC 15
	
	if(GetOverdoseCounter(oPC, "PRC_VodareOD"))
	{
		//Fort DC 15
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 15, SAVING_THROW_TYPE_POISON))
		{
			//catatonic
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, fDur);
		}
	}
	
	//OD increment
	IncrementOverdoseTracker(oPC, "PRC_VodareOD", HoursToSeconds(4));
}
			
		