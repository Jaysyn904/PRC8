/////////////////////////////////////////////////////////////////////
//
// Legion's Curse of Petty Failing - Target takes a -2 penalty to 
// attacks and saves.
//
/////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = PRCGetSpellTargetLocation();

	// Determine the save bonus.
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
	int nBonus = 2 + (nCasterLvl / 6);
	if (nBonus > 5) nBonus = 5;

	// Determine the spell's duration, taking metamagic feats into account.
	float fDuration = PRCGetMetaMagicDuration(MinutesToSeconds(nCasterLvl));

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

			// Apply the curse and vfx.
			effect eBuff = EffectACIncrease(nBonus, AC_DEFLECTION_BONUS);
			eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLvl
));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget));
		}
		
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

	PRCSetSchool();
}
