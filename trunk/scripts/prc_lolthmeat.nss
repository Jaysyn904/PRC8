//::///////////////////////////////////////////////
//:: Name Lolth's Meat
//:: FileName prc_lolthmeat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Lolth's Meat feat
*/
//:://////////////////////////////////////////////
//:: Created By: PsychicToaster
//:: Created On: 7-31-04
//:://////////////////////////////////////////////

#include "prc_inc_racial"
#include "inc_prc_npc"
#include "prc_inc_combat"

void main()
{

	object oPC  = OBJECT_SELF;
	object oKilled = GetLastBeingDied();

	// Conditions that cause it to fail
	// Creatures that arent alive. Are Elementals? Uncertain so will let them work for now.
	if (MyPRCGetRacialType(oKilled) == RACIAL_TYPE_UNDEAD || MyPRCGetRacialType(oKilled) == RACIAL_TYPE_CONSTRUCT) return;
	// Gotta be in melee range
	if (!GetIsInMeleeRange(oKilled, oPC)) return;
	// Can't be a spell
	if (GetIsObjectValid(GetAttemptedSpellTarget())) return;

	if(GetHasFeat(FEAT_LOLTHS_MEAT))
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(1, ATTACK_BONUS_MISC), oPC, 24.0);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(1, DAMAGE_TYPE_DIVINE), oPC, 24.0);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL), oPC, 24.0);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);
	}
}
