//::///////////////////////////////////////////////
//:: Name      Addiction: Agony  
//:: FileName  sp_addct_ag.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Agony

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "PRC_Addiction_Agony_DC");
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   (!GetPersistantLocalInt(oPC, "PRC_AgonySatiation")))
	{
		//1d6 Dex, 1d6 Wis, 1d6 Con
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_WISDOM, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		
		DeletePersistantLocalInt(oPC, "PRC_PreviousAgonySave");
	}
	
	else 
	{
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PRC_PreviousAgonySave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(OBJECT_SELF);
						
			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_AGONY)
					{
						RemoveEffect(oPC, eDisease);
						DeletePersistantLocalInt(oPC, "PRC_PreviousAgonySave");
						break;
					}
				}
				eDisease = GetNextEffect(OBJECT_SELF);
			}			
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PRC_PreviousAgonySave", 1);
		}
	}
	
	//Handle DC increase from addiction.  
	if(!GetPersistantLocalInt(oPC, "PRC_AgonySatiation"))
	{
		SetPersistantLocalInt(oPC, "PRC_Addiction_Agony_DC", (nDC + 5));
	}
	
	//Remove the int, as it only lasts 1 day
	DeletePersistantLocalInt(oPC, "PRC_AgonySatiation");
}

