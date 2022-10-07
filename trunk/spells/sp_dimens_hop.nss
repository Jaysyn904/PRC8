//::///////////////////////////////////////////////
//:: Name      Dimension Hop
//:: FileName  sp_dimens_hop.nss
//:://////////////////////////////////////////////
/**@file Dimension Hop
Conjuration (Teleportation)
Level: Duskblade 2, sorcerer/wizard 2
Components: V
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Will negates
Spell Resistance: Yes

You instantly teleport the subject creature a distance
of 5 feet per two caster levels.  The destination must
be an unoccupied space within line of sight.
**/
/////////////////////////////////////////////////////
// Author: Tenjac (nearly completely copied from Ornedan)
// Date:   3.10.06
/////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);
	
	object oPC = OBJECT_SELF;
	location lTarget = PRCGetSpellTargetLocation();
	
	//Remember to set range to medium and change the tlk description.
	
	// Assign jump command with delay to prevent the damn infinite action loop
	DelayCommand(1.0f, AssignCommand(oPC, JumpToLocation(lTarget)));
	
	// Do some VFX
	DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oPC, 0.55));
	DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oPC), GetPosition(oPC), GetPositionFromLocation(lTarget), 0.0, FloatToInt(GetDistanceBetweenLocations(GetLocation(oPC), lTarget)), 0.5);
	
	PRCSetSchool();
}
	