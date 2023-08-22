//::///////////////////////////////////////////////
//:: Name      Rouse
//:: FileName  sp_rouse.nss
//:://////////////////////////////////////////////
/**@file Rouse
Enchantment (Compulsion) [Mind-Affecting]
Level: Beguiler 1, duskblade 1, sorcerer/wizard 1
Components: V,S
Casting Time: 1 standard action
Range: Close
Area 10-ft radius burst
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

This spell has no effect on creatures that are
unconscious due to being reduced to negative hit 
points or that have taken nonlethal damage in 
excess of their current hit points.

**/
/////////////////////////////////////////////////
// Author: Tenjac
// Date:   26.9.06
/////////////////////////////////////////////////

void RemoveSleep(object oTarget);

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	location lLoc = PRCGetSpellTargetLocation();
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 3.048f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	
	while(GetIsObjectValid(oTarget))
	{
		RemoveSleep(oTarget);
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 3.048f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	PRCSetSchool();
}

void RemoveSleep(object oTarget)
{
	effect eTest = GetFirstEffect(oTarget);
	
	while(GetIsEffectValid(eTest))
	{
		if(eTest == EffectSleep())
		{
			RemoveEffect(oTarget, eTest);
		}
		eTest = GetNextEffect(oTarget);
	}
}