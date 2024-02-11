//::///////////////////////////////////////////////
//:: Name      Baccaran  
//:: FileName  sp_baccaran.nss 
//:://////////////////////////////////////////////
/** Script for the drug Baccaran

Author:    Tenjac
Created:   5/18/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_inc_drugfunc"

void main()
{
	object oPC = OBJECT_SELF;
	effect eMind = EffectSavingThrowDecrease(SAVING_THROW_WILL,2,SAVING_THROW_TYPE_MIND_SPELLS);
	effect eWis = EffectAbilityIncrease(ABILITY_WISDOM,d6()+1);
	effect eDam = PRCEffectDamage(oPC, d6(2));
	
	//Handle resetting addiction DC
	SetPersistantLocalInt(oPC, "PRC_Addiction_Baccaran_DC", 6);
		
	//Handle satiation
	SetPersistantLocalInt(oPC, "PRC_BaccaranSatiation", 10);
	
	//Make addiction check
	if(!GetHasSpellEffect(SPELL_DRUG_RESISTANCE, oPC))
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 6, SAVING_THROW_TYPE_DISEASE))
		{
			effect eAddict = EffectDisease(DISEASE_BACCARAN_ADDICTION);
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAddict, oPC);
			FloatingTextStringOnCreature("You have become addicted to Baccaran.", oPC, FALSE);
		}
	}

	//Primary
	ApplyAbilityDamage(oPC, ABILITY_STRENGTH, 4, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oPC, HoursToSeconds(d4(2)));
	
	//Secondary - 1 minute after primary
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWis, oPC, HoursToSeconds(d2())));
	
	//Overdose
	if(GetOverdoseCounter(oPC, "PRC_BaccaranOD"))
	{
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMind, oPC, HoursToSeconds(d4(2)));
	}
	
	//OD increment
	IncrementOverdoseTracker(oPC, "PRC_BaccaranOD", HoursToSeconds(24));
}
		