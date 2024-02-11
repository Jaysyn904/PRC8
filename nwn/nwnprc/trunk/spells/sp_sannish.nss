//::///////////////////////////////////////////////
//:: Name      Sannish
//:: FileName  sp_sannish.nss 
//:://////////////////////////////////////////////
/** Script for the drug Sannish

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
	float fDur = HoursToSeconds(d4());
	
	// Initial effect
	ApplyAbilityDamage(oPC, ABILITY_WISDOM, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	
	effect eNerf = EffectAttackDecrease(1);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNerf, oPC, fDur);
			
	//Secondary - Immune to pain
	SetLocalInt(oPC, "PRC_ImmuneToPain_Sannish", 1);
	DelayCommand(HoursToSeconds(d4(1)), DeleteLocalInt(oPC, "PRC_ImmuneToPain_Sannish"));
	
	//Overdose
	if(GetOverdoseCounter(oPC, "PRC_SannishOD"))
	{
		effect eDaze = EffectDazed();
		float fDur = HoursToSeconds(d4(2));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oPC, fDur);
	}
	
	//OD increment
	IncrementOverdoseTracker(oPC, "PRC_Sannish", fDur);
}

