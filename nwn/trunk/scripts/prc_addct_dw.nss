//::///////////////////////////////////////////////
//:: Name      Addiction: Devil Weed  
//:: FileName  sp_addct_dw.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Devil Weed

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//::///////////////////////////////////////////////
//:: Name      Addiction: Baccaran  
//:: FileName  sp_addct_bac.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Baccaran

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "PRC_Addiction_Devilweed_DC");
	int nSatiation = GetPersistantLocalInt(oPC, "PRC_DevilweedSatiation") ;
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) && (nSatiation < 1))
	
	{
		//1d3 Dex
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d3(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		DeletePersistantLocalInt(oPC, "PRC_PreviousDevilweedSave");
	}

        else 
        {
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PRC_PreviousDevilweedSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);
			
			
			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_DEVILWEED)
					{
						RemoveEffect(oPC, eDisease);
						DeletePersistantLocalInt(oPC, "PRC_PreviousDevilweedSave");
						break;
					}
				}
				eDisease = GetNextEffect(oPC);
			}
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PRC_PreviousDevilweedSave", 1);
		}
		
		//Handle DC increase from addiction.  
		if(nSatiation < 1)
		{
			SetPersistantLocalInt(oPC, "PRC_Addiction_Devilweed_DC", (nDC + 5));
		}
		
		//Decrement satiation
		nSatiation--;
		SetPersistantLocalInt(oPC, "PRC_DevilweedSatiation", nSatiation);
	}
}