//::///////////////////////////////////////////////
//:: Unicorn Blood Damage 2
//:: ravage_uncrnbld2
//:://////////////////////////////////////////////
/*
    1d4 Str damage
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

	ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d4(1) + nExtra, DURATION_TYPE_PERMANENT, TRUE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}