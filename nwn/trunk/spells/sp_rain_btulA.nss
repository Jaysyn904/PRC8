//::///////////////////////////////////////////////
//:: Name      Rain of Black Tulips: On Enter
//:: FileName  sp_rain_btulA.nss
//:://////////////////////////////////////////////
/**@file Rain of Black Tulips 
Evocation [Good] 
Level: Drd 9 
Components: V, S, M 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Area: Cylinder (80-ft. radius, 80 ft. high)
Duration: 1 round/level (D) 
Saving Throw: None (damage), Fortitude negates (nausea) 
Spell Resistance: Yes

Tulips as black as midnight fall from the sky. The 
tulips explode with divine energy upon striking evil
creatures, each of which takes 5d6 points of damage. 
In addition, evil creatures that fail a Fortitude 
save are nauseated (unable to attack, cast spells, 
concentrate on spells, perform any task requiring 
concentration, or take anything other than a single
move action per turn) until they leave the spell's 
area. A successful Fortitude save renders a creature
immune to the nauseating effect of the tulips, but 
not the damage.

Material Component: A black tulip. 

Author:    Tenjac
Created:   7/14/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
	object oTarget = GetEnteringObject();
	object aoeCreator = GetAreaOfEffectCreator();
	int nDC = PRCGetSaveDC(oTarget, aoeCreator);
	
	if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
	{
		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDazed(), oTarget);
		}
	}
}