//::///////////////////////////////////////////////
//:: Name      Addiction: Vodare
//:: FileName  sp_addct_vdr.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Vodare

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "PRC_Addiction_Vodare_DC");
	int nSatiation = GetPersistantLocalInt(oPC, "PRC_VodareSatiation");
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   (!GetPersistantLocalInt(oPC, "PRC_VodareSatiation")))
	{
		//1d6 Dex, 1d6 Wis, 1d2 Con
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_WISDOM, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, d2(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		
		DeletePersistantLocalInt(oPC, "PRC_PreviousVodareSave");
	}
	
	else 
	{
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PRC_PreviousVodareSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);
			effect eTest = EffectDisease(DISEASE_VODARE_ADDICTION);
			
			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_DEVILWEED)
					{
						RemoveEffect(oPC, eDisease);
						DeletePersistantLocalInt(oPC, "PRC_PreviousVodareSave");
						break;
					}
				}
				
				eDisease = GetNextEffect(oPC);
			}			
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PRC_PreviousVodareSave", 1);
		}
	}
	
	//Handle DC increase from addiction.  
	if(!GetPersistantLocalInt(oPC, "PRC_VodareSatiation"))
	{
		SetPersistantLocalInt(oPC, "PRC_Addiction_Vodare_DC", (nDC + 5));
	}
	
	//Decrement satiation
	nSatiation--;
	SetPersistantLocalInt(oPC, "PRC_VodareSatiation", nSatiation);
}