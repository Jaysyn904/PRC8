//::///////////////////////////////////////////////
//:: Name      Rain of RosesB: OnExit
//:: FileName  sp_rain_rose.nss
//:://////////////////////////////////////////////
/**@file Rain of Roses 
Evocation [Good] 
Level: Drd 7 
Components: V, S, M 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Area: Cylinder (80-ft. radius, 80 ft. high)
Duration: 1 round/level (D)
Saving Throw: None (ability damage) and Fortitude 
negates (sickening) 
Spell Resistance: Yes

Red roses fall from the sky. Their sharp thorns 
graze the flesh of evil creatures, dealing 1d4 
points of temporary Wisdom damage per round. A 
creature reduced to 0 Wisdom falls unconscious as
its mind succumbs to horrible nightmares. In 
addition, the beautiful rose petals sicken evil 
creatures touched by them; those that fail a 
Fortitude save are sickened (-2 penalty on attack
rolls, weapon damage rolls, saving throws, 
ability checks, and skill checks) until they
leave the spell's area. A successful Fortitude 
save renders a creature immune to the sickening 
effect of the roses, but not the ability damage 
caused by their thorns.

Material Component: A red rose. 

Author:    Tenjac
Created:   7/17/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oTarget = GetExitingObject();
	object oCreator = GetAreaOfEffectCreator();
	
	effect eAOE;
	if(GetHasSpellEffect(SPELL_AVASCULAR_MASS, oTarget))
	{
		//Search through the valid effects on the target.
		eAOE = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eAOE))
		{
			if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
			{
				//If the effect was created by Rain of Roses then remove it
				if(GetEffectSpellId(eAOE) == SPELL_RAIN_OF_ROSES)
				{
					RemoveEffect(oTarget, eAOE);
				}
			}
			//Get next effect on the target
			eAOE = GetNextEffect(oTarget);
		}
	}
}
	
	