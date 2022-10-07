//:://////////////////////////////////////////////
//:: Name     Forceward On Enter
//:: FileName   sp_forcewardA.nss
//:://////////////////////////////////////////////
/** @file Abjuration
Level: Cleric 3 (Helm), Paladin 3, Knight of the Weave 3,
Components: V, S, DF,
Casting Time: 1 full round
Range: 10 ft.
Area: 10-ft.-radius emanation centered on you
Duration: 1 minute/level
Saving Throw: Will negates
Spell Resistance: Yes

You create an unmoving, transparent sphere of force 
centered on your location.
The sphere illuminates its interior and everything 
within 5 feet of its edge.
You and your allies may enter the sphere at will.
Any other creature that tries to enter the sphere must 
make a Will saving throw, otherwise it cannot pass into
the area defined by the sphere.
A creature may leave the area freely, although it must
make a Will save to enter again, even if the creature 
is you or one of your allies.
Creatures within the area when the spell is cast are not
forced out.
The forceward does not prevent spells or objects from 
entering the forceward, so it is possible for two creatures
on opposite sides of the forceward's edge to fight without
penalties (although creatures using unarmed attacks or 
natural weapons still have tomake Will saves every round
for their attacks to have a chance of entering the forceward).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 07/04/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();
	int nDC = PRCGetSaveDC(oTarget, oCreator);
	int nCasterLvl = PRCGetCasterLevel(oCreator);
	location lAOE = GetLocation(OBJECT_SELF);
	
	//Will save if it doesn't have the local int
	if(!GetLocalInt(oTarget, "PRCForcewardEntry"))
	{
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE, oCreator))
		{
			ActionMoveAwayFromLocation(lAOE, FALSE, 3.048f);
		}
	}
}