//::///////////////////////////////////////////////
//:: Celestial Lightsblood Damage 2
//:: ravage_cllghtbl2
//:://////////////////////////////////////////////
/*
    1 Con damage
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////


#include "prc_inc_spells"
#include "inc_ravage"

void main()
{
	object oTarget = OBJECT_SELF;
	// Ravages only affect evil creatures
	if (GetAlignmentGoodEvil(oTarget)!=ALIGNMENT_EVIL) return;
	int nExtra = GetRavageExtraDamage(oTarget);
	effect eVis = GetRavageVFX();

	ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, 1 + nExtra, DURATION_TYPE_PERMANENT, TRUE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}