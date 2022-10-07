//:://////////////////////////////////////////////
//:: Name     Holy Storm On Enter
//:: FileName   sp_holystormA.nss
//:://////////////////////////////////////////////
/** @file 
Conjuration (Creation) [Good, Water]
Level: Cleric 3, Paladin 3,
Components: V, S, M, DF,
Casting Time: 1 standard action
Range: 20 ft.
Area: Cylinder (20-ft. radius, 20 ft. high)
Duration: 1 round/level (D)
Saving Throw: None
Spell Resistance: No

You call upon the forces of good, and a heavy rain begins to fall
around you, its raindrops soft and warm.

A driving rain falls around you. It falls in a fixed area once 
created. The storm reduces hearing and visibility, resulting in a 
-4 penalty on Listen, Spot, and Search checks. It also applies a
-4 penalty on ranged attacks made into, out of, or through the 
storm. 

The rain damages evil creatures, dealing 2d6 points of damage 
per round (evil outsiders take double damage) at the beginning
of your turn.

Material Component: A flask of holy water (25 gp).
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/9/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	location lLoc = GetLocation(OBJECT_SELF);
	int nDam;
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 6.096f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	effect ePenalty = EffectLinkEffects(EffectSkillDecrease(SKILL_LISTEN, 4), EffectSkillDecrease(SKILL_SPOT), 4));
	ePenalty = EffectLinkEffects(ePenalty, EffectSkillDecrease(SKILL_SEARCH, 4));
	
	while(GetIsObjectValid(oTarget))
	{
		//Penalties to skills
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenalty, oTarget, RoundsToSeconds(1));	
		
		//Penalty to attack if ranged equipped
		if(GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget))
		{
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(4), 6.0f);
		}
		
		//Bonus AC vs Ranged?
		
		//if evil
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			nDam = d6(2);
			//if outsider
			if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
			{
				nDam+=nDam;
			}
			
			//damage
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_DIVINE, nDam, oTarget));
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 6.096f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
}