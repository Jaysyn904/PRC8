//::///////////////////////////////////////////////
//:: Name      Brilliant Emanation - On Exit
//:: FileName  sp_brill_emanB.nss
//:://////////////////////////////////////////////
/**@file Brilliant Emanation
Evocation [Good] 
Level: Sanctified 3 
Components: Sacrifice 
Casting Time: 1 standard action 
Range: 100 ft. + 10 ft./level
Area: 100-ft.-radius emanation + 10-ft. radius per level
Duration: 1d4 rounds
Saving Throw: Fortitude partial 
Spell Resistance: Yes

This spell causes a divine glow to radiate from 
any reflective objects worn or carried by the 
caster, including metal armor. Evil creatures 
within the spell's area are blinded unless they 
succeed on a Fortitude saving throw. Non-evil 
characters perceive the brilliant light emanating 
from the caster, but are not blinded by it and do 
not suffer any negative effects from it. Evil 
characters that make their saving throw are not 
blinded, but are distracted, taking a -1 penalty 
on any attacks made within the spell's area for 
the duration of the spell. Creatures must be able 
to see visible light to be affected by this spell.

Sacrifice: 1d3 points of Strength damage. 

Author:    Tenjac
Created:   6/8/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oTarget = GetExitingObject();
	effect eAOE = GetFirstEffect(oTarget);
	
	//Search through the valid effects on the target.	
	while (GetIsEffectValid(eAOE))
	{
		if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
		{
			if(GetEffectType(eAOE) == EFFECT_TYPE_BLINDNESS)
			{
				//If the effect was created by Brilliant Emanation then remove it
				if(GetEffectSpellId(eAOE) == SPELL_BRILLIANT_EMANATION)
				{
					RemoveEffect(oTarget, eAOE);
				}
			}
			
			if(GetEffectType(eAOE) == EFFECT_TYPE_ATTACK_DECREASE)
			{
				//If the effect was created by Brilliant Emanation then remove it
				if(GetEffectSpellId(eAOE) == SPELL_BRILLIANT_EMANATION)
				{
					RemoveEffect(oTarget, eAOE);
				}
			}			
		}
		//Get next effect on the target
		eAOE = GetNextEffect(oTarget);
	}
	PRCSetSchool();
}
				
		
	
	