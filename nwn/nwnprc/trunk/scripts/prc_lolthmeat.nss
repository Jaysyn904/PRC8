//::////////////////////////////////////////////////////////  
//:: Name Lolth's Meat  
//:: FileName prc_lolthmeat  
//:: Copyright (c) 2001 Bioware Corp.  
//::////////////////////////////////////////////////////////  
/*  
	Lolth's Meat
	( Underdark, p. 26)

	[General]

	Like all drow raised in cities that are ruled by Lolth's 
	priestesses, you know that you exist only to provide 
	your goddess with food and pleasure. This knowledge 
	lends you a certain bloodthirsty readiness.
	Prerequisite

	*Race*: Drow,
	Benefit

	If you kill a living creature that has an Intelligence 
	score of 3 or higher with a melee attack, you gain a +1 
	morale bonus on attack rolls, damage rolls, and saving 
	throws for the rest of the encounter. If you kill such 
	an opponent either by performing a coup de grace or 
	with a touch spell, you gain a +2 morale bonus on attack 
	rolls, damage rolls, and saving throws for the rest of 
	the encounter. To qualify for this bonus, you must 
	either reduce the target to —10 hp with your blow or 
	kill it with a touch spell (such as slay living).
  
*/  
//:://////////////////////////////////////////////////////// 
//:: Created By: PsychicToaster  
//:: Created On: 7-31-04  
//::
//:; Fixed By: Jaysyn
//:: Fixed on: 2026-09-13 09:30:39
//::////////////////////////////////////////////////////////  
#include "prc_inc_racial"  
#include "inc_prc_npc"  
#include "prc_inc_combat"  
#include "prc_sp_func"  
  
void main()  
{  
	object oPC  = OBJECT_SELF;  
	object oKilled = GetLastBeingDied();  
  
	// Must be a living creature  
	if (!PRCGetIsAliveCreature(oKilled)) return;  
  
	// Determine if the kill was a touch spell 
	int nSpellID = GetLastSpell();  
	int bIsTouchKill = (nSpellID != -1 && IsTouchSpell(nSpellID));  
   
	if (!GetIsInMeleeRange(oKilled, oPC) && !bIsTouchKill) return;  
	// Can't be a (non-touch) spell  
	if (GetIsObjectValid(GetAttemptedSpellTarget()) && !bIsTouchKill) return;  
  
	if(GetHasFeat(FEAT_LOLTHS_MEAT))  
	{  
		// Remove any existing Lolth's Meat effects first to prevent stacking  
		effect eOld = GetFirstEffect(oPC);  
		while(GetIsEffectValid(eOld))  
		{  
			if(GetEffectTag(eOld) == "LOLTHS_MEAT")  
				RemoveEffect(oPC, eOld);  
			eOld = GetNextEffect(oPC);  
		}  
  
		int nBonus = bIsTouchKill ? 2 : 1;  
  
		effect eLink = EffectLinkEffects(EffectAttackIncrease(nBonus, ATTACK_BONUS_MISC), EffectDamageIncrease(nBonus, DAMAGE_TYPE_UNTYPED));  
		       eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL));  
		       eLink = TagEffect(eLink, "LOLTHS_MEAT");  
  
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0);  
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);  
	}  
}




/* void main()
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
} */
