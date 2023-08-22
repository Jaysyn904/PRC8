//::///////////////////////////////////////////////
//:: Name      Calm Emotions: On Exit
//:: FileName  sp_calm_emotionB.nss
//:://////////////////////////////////////////////2
/** @file Calm Emotions
Enchantment (Compulsion) [Mind-Affecting]
Level: 	Brd 2, Clr 2, Law 2
Components: 	V, S, DF
Casting Time: 	1 standard action
Range: 	Medium (100 ft. + 10 ft./level)
Area: 	Creatures in a 20-ft.-radius spread
Duration: 	1 round/level
Saving Throw: 	Will negates
Spell Resistance: 	Yes

This spell calms agitated creatures. You have no 
control over the affected creatures, but calm emotions
can stop raging creatures from fighting or joyous ones
from reveling. Creatures so affected cannot take 
violent actions (although they can defend themselves) 
or do anything destructive. 


**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   8.10.06
//////////////////////////////////////////////////////
#include "prc_inc_spells"

void main()
{
	object oTarget = GetExitingObject();
	effect eAOE;
	if(GetHasSpellEffect(SPELL_CALM_EMOTIONS, oTarget))
	{
		//Search through the valid effects on the target.
		eAOE = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eAOE))
		{
			if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
			{
				//If the effect was created by Calm Emotions then remove it
				if(GetEffectSpellId(eAOE) == SPELL_CALM_EMOTIONS)
				{
					RemoveEffect(oTarget, eAOE);
				}				
			}
			//Get next effect on the target
			eAOE = GetNextEffect(oTarget);
		}
	}
}