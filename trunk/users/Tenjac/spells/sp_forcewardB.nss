//:://////////////////////////////////////////////
//:: Name     Forceward On Exit
//:: FileName   sp_forcewardB.nss
//:://////////////////////////////////////////////
/** @file
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/4/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	object oTarget = GetExitingObject();
	
	if(GetLocalInt(oTarget, "PRCForcewardEntry"))
	{
		DeleteLocalInt(oTarget, "PRCForcewardEntry"));
	}
	
	 effect eAOE;
	 if(GetHasSpellEffect(SPELL_SOLID_FOG, oTarget))
	 {
	 	//Search through the valid effects on the target.
	        eAOE = GetFirstEffect(oTarget);
	        while (GetIsEffectValid(eAOE))
	        {
	        	if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
	        	{
	        		//If the effect was created by either half of Fog from the Void
	        		if(GetEffectSpellId(eAOE) == SPELL_SOLID_FOG)
	        		{
	        			RemoveEffect(oTarget, eAOE);
	        		}
	                }
	         }
	         //Get next effect on the target
	         eAOE = GetNextEffect(oTarget);
	 }
}