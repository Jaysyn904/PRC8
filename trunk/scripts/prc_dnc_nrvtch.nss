/*
    prc_dnc_nrvtch

    Enervating Touch
    Negative level on touch
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"

void main()
{
	object oCaster = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nClass = GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oCaster);
	int nDC = 10 + nClass/2 + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	
	int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
	if (iAttackRoll > 0)
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
		{
			effect eDrain = EffectNegativeLevel(1);
			effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));

}