//::///////////////////////////////////////////////
//:: Name      Slashing Dispell
//:: FileName  sp_slash_displ.nss
//:://////////////////////////////////////////////
/**@file Slashing Dispell
Abjuration/Evocation
Level: Duskblade 5, sorcerer/wizard 4
Components: V,S
Casting Time: 1 standard action
Range: Medium
Target or Area: One creature or 20ft radius burst
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

This spell functions like dispel magic, except as 
noted here.  Any creature that has a spell effect
removed from it takes 2 points of damage per level
of the dispelled effect.  If a creature loses the 
effects of multiple spells, it takes damage for
each one.
**/

#include "inc_dispel"
#include "prc_add_spell_dc"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	if (!X2PreSpellCastCode()) return;
	
	object    oPC          = OBJECT_SELF;
	effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
	effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
	object    oTarget      = PRCGetSpellTargetObject();
	location  lLocal       = PRCGetSpellTargetLocation();
	int       nCasterLevel = PRCGetCasterLevel(oPC);
		
	//--------------------------------------------------------------------------
	// Dispel Magic is capped at caster level 10
	//--------------------------------------------------------------------------
	if(nCasterLevel > 10)
	{
		nCasterLevel = 10;
	}
	
	if (GetIsObjectValid(oTarget))
	{
		//----------------------------------------------------------------------
		// Targeted Dispel - Dispel all
		//----------------------------------------------------------------------
		spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);
		
	}
	else
	{
		//----------------------------------------------------------------------
		// Area of Effect - Only dispel best effect
		//----------------------------------------------------------------------
		
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
		oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
		while (GetIsObjectValid(oTarget))
		{
			if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
			{
				//--------------------------------------------------------------
				// Handle Area of Effects
				spellsDispelAoEMod(oTarget, oPC,nCasterLevel);
			}
			else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
			{
				SignalEvent(oTarget, EventSpellCastAt(oPC, GetSpellId()));
			}
			else
			{				
				spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact, FALSE);
			}
			oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
		}
	}
	
	PRCSetSchool();
}




