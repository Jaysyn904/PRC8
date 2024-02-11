/////////////////////////////////////////////////////////////////////
//
// Legion's Conviction - Give all allies in a huge burst a +2 to
// +5 bonus to saves.
//
/////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = PRCGetSpellTargetLocation();

	// Get the effective caster level.
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

	// Determine the save bonus.
	int nBonus = 2 + (PRCGetCasterLevel() / 6);
	if (nBonus > 5) nBonus = 5;

	// Determine the spell's duration, taking metamagic feats into account.
	float fDuration = PRCGetMetaMagicDuration(TurnsToSeconds(PRCGetCasterLevel()));

	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			PRCSignalSpellEvent(oTarget, FALSE);

			float fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);

			// Apply the buff and vfx.
			effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);
			eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
			eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLvl
));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_LESSER), oTarget));
		}
		
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

	PRCSetSchool();
}
