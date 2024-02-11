//::///////////////////////////////////////////////
//:: Name      Blinding Glory
//:: FileName  sp_blnd_glory.nss
//:://////////////////////////////////////////////
/**@file Blinding Glory
Conjuration (Creation) [Good] 
Level: Glory 9, Sor/Wiz 9 
Components: V, S, M/DF 
Casting Time: 1 hour
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 100-ft./level radius spread, centered on you
Duration: 1 hour/level 
Saving Throw: None 
Spell Resistance: No

A brilliant radiance spreads from you, brightly 
illuminating the area. The light is similar to that
created by the daylight spell, but no magical 
darkness counters or dispels it. Furthermore, 
evil-aligned creatures are blinded within this light.

Blinding glory brought into an area of magical 
darkness (or vice versa), including an utterdark 
spell, is temporarily negated, so that the otherwise
prevailing light conditions exist in the overlapping
areas of effect.

Arcane Material Component: A polished rod of pure 
silver.

Author:    Tenjac
Created:   6/13/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	//Get the object that is exiting the AOE
	object oTarget = GetExitingObject();
	effect eAOE;
	if(GetHasSpellEffect(SPELL_BLINDING_GLORY, oTarget))
	{
		//Search through the valid effects on the target.
		eAOE = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eAOE))
		{
			if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
			{
				//If the effect was created by CotA then remove it
				if(GetEffectSpellId(eAOE) == SPELL_BLINDING_GLORY)
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
	
	
	