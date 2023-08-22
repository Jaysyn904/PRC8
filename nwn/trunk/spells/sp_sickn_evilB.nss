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
	//Declare major variables
	//Get the object that is exiting the AOE
	object oTarget = GetExitingObject();
	effect eAOE;
	if(GetHasSpellEffect(SPELL_SICKEN_EVIL, oTarget))
	{
		//Search through the valid effects on the target.
		eAOE = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eAOE))
		{
			if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
			{
				if(GetEffectSpellId(eAOE) == SPELL_SICKEN_EVIL)
				{
					RemoveEffect(oTarget, eAOE);
				}
			}			
			//Get next effect on the target
			eAOE = GetNextEffect(oTarget);
		}
	}	
	PRCSetSchool();
}
