//::///////////////////////////////////////////////
//:: Cloud of the Achaierai B: On Exit
//:: sp_cloud_achaiB.nss
//:://////////////////////////////////////////////
/*
    Removes the effect after the AOE dies.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 3/24/06
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	//Declare major variables
	//Get the object that is exiting the AOE
	object oTarget = GetExitingObject();
	effect eAOE;
	if(GetHasSpellEffect(SPELL_CLOUD_OF_THE_ACHAIERAI, oTarget))
	{
		//Search through the valid effects on the target.
		eAOE = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eAOE))
		{
			if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
			{
				if(GetEffectType(eAOE) == EFFECT_TYPE_DARKNESS)
				{
					//If the effect was created by CotA then remove it
					if(GetEffectSpellId(eAOE) == SPELL_CLOUD_OF_THE_ACHAIERAI)
					{
						RemoveEffect(oTarget, eAOE);
					}
				}
			}
			//Get next effect on the target
			eAOE = GetNextEffect(oTarget);
		}
	}	
	PRCSetSchool();
}
