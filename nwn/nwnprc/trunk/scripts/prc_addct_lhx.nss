//::///////////////////////////////////////////////
//:: Name      Addiction: Luhix  
//:: FileName  sp_addct_lhx.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Luhix

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "PRC_Addiction_Luhix_DC");
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   (!GetPersistantLocalInt(oPC, "PRC_LuhixSatiation")))
	{
		//1d8 Dex, 1d8 Wis, 1d6 Con, 1d6 Str
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d8(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_WISDOM, d8(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_STRENGTH, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		
		DeletePersistantLocalInt(oPC, "PRC_PreviousLuhixSave");
	}
	
	else 
	{
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PRC_PreviousLuhixSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);
			effect eTest = EffectDisease(DISEASE_LUHIX_ADDICTION);
			
			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_LUHIX)
					{
						RemoveEffect(oPC, eDisease);
						DeletePersistantLocalInt(oPC, "PRC_PreviousLuhixSave");
						break;
					}
				}
				
				eDisease = GetNextEffect(oPC);
			}			
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PRC_reviousLuhixSave", 1);
		}
	}
	
	//Handle DC increase from addiction.  
	if(!GetPersistantLocalInt(oPC, "PRC_LuhixSatiation"))
	{
		SetPersistantLocalInt(oPC, "PRC_Addiction_Luhix_DC", (nDC + 5));
	}
	
	//Remove the int, as it only lasts 1 day
	DeletePersistantLocalInt(oPC, "PRC_LuhixSatiation");
}
