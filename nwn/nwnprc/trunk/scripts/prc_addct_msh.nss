//::///////////////////////////////////////////////
//:: Name      Addiction: Mushroom Powder 
//:: FileName  sp_addct_msh.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Mushroom Powder

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "PRC_Addiction_Mushroom_DC");
	int nSatiation = GetPersistantLocalInt(oPC, "PRC_MushroomSatiation");
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   (!GetPersistantLocalInt(oPC, "PRC_MushroomSatiation")))
	{
		//1d8 Dex, 1d8 Wis, 1d6 Con, 1d6 Str
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d4(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_WISDOM, d4(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		
		DeletePersistantLocalInt(oPC, "PRC_PreviousMushroomSave");
	}
	
	else 
	{
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PRC_PreviousMushroomSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);
						
			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_MUSHROOM_POWDER)
					{
						RemoveEffect(oPC, eDisease);
						DeletePersistantLocalInt(oPC, "PRC_PreviousMushroomSave");
						break;
					}
				}
				
				eDisease = GetNextEffect(oPC);
			}			
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PRC_PreviousMushroomSave", 1);
		}
	}
	
	//Handle DC increase from addiction.  
	if(!GetPersistantLocalInt(oPC, "PRC_MushroomSatiation"))
	{
		SetPersistantLocalInt(oPC, "PRC_Addiction_Mushroom_DC", (nDC + 5));
	}
	
	//Decrement satiation
	nSatiation--;
	SetPersistantLocalInt(oPC, "PRC_MushroomSatiation", nSatiation);
}