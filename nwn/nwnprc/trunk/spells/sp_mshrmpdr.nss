//::///////////////////////////////////////////////
//:: Name      Mushroom Powder
//:: FileName  sp_mshrmpwdr.nss 
//:://////////////////////////////////////////////
/** Script for the drug Devil Weed

Author:    Tenjac
Created:   5/23/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
// Mushroom powder initial effects and side effects

#include "prc_inc_spells"
#include "prc_inc_drugfunc"

void main()
{
	object oPC = OBJECT_SELF;
	
	//Handle resetting addiction DC
	SetPersistantLocalInt(oPC, "PRC_Addiction_Mushroom_DC", 10);
	
	//Handle satiation
	SetPersistantLocalInt(oPC, "PRC_MushroomSatiation", 5);
	
	//Make addiction check
	if(!GetHasSpellEffect(SPELL_DRUG_RESISTANCE, oPC))
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 10, SAVING_THROW_TYPE_DISEASE))
		{
			effect eAddict = EffectDisease(DISEASE_MUSHROOM_POWDER_ADDICTION);
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAddict, oPC);
			FloatingTextStringOnCreature("You have become addicted to Mushroom Powder.", oPC, FALSE);
		}
	}
	
	// Initial effect
	effect eLink = EffectAbilityIncrease(ABILITY_INTELLIGENCE,2);
	eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_CHARISMA,2), eLink);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eLink), oPC, HoursToSeconds(1));
	
	// Side effects
	effect eWis = EffectAbilityDecrease(ABILITY_WISDOM,2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eWis), oPC, HoursToSeconds(d4()));
	
	effect eLink2 = EffectAbilityDecrease(ABILITY_STRENGTH,2);
	
	eLink2 = EffectLinkEffects(EffectAbilityDecrease(ABILITY_CONSTITUTION,2),eLink2);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,SupernaturalEffect(eLink2), oPC, HoursToSeconds(d4(2)));
	
	//Secondary
	
	DelayCommand(60.0f, ApplyAbilityDamage(oPC, ABILITY_STRENGTH, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));
	
	//Overdose 
	if(GetOverdoseCounter(oPC, "PRC_MushroomOD2") == 4)
	{
		effect eDam2 = PRCEffectDamage(oPC, d6(4));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oPC);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oPC, HoursToSeconds(d4(2)));		
	}
	
	else if(GetOverdoseCounter(oPC, "PRC_MushroomOD") == 1)
	{
		effect eDam = PRCEffectDamage(oPC, d6(2));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
	}
	
	//OD increment
	IncrementOverdoseTracker(oPC, "PRC_MushroomOD", HoursToSeconds(12));
	IncrementOverdoseTracker(oPC, "PRC_MushroomOD2", HoursToSeconds(24));
	
}


