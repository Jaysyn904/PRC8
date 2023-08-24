/////////////////////////////////////////////////////////////////////
//
// Legion's Curse of Petty Failing - Target takes a -2 penalty to 
// attacks and saves.
//
/////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = PRCGetSpellTargetLocation();

	// Get the effective caster level.
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

	// Determine the save bonus.
	int nBonus = 2 + (PRCGetCasterLevel() / 6);
	if (nBonus > 5) nBonus = 5;

	// Determine the spell's duration, taking metamagic feats into account.
	float fDuration = PRCGetMetaMagicDuration(MinutesToSeconds(PRCGetCasterLevel()));

	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
     	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			PRCSignalSpellEvent(oTarget);

			float fDelay = PRCGetSpellEffectDelay(lTarget, oTarget);

			// Apply the curse and vfx.
			effect eCurse = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
			eCurse = EffectLinkEffects(eCurse, EffectAttackDecrease(2));
			eCurse = EffectLinkEffects(eCurse, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
			eCurse = EffectLinkEffects(eCurse, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oTarget, fDuration,TRUE,-1,nCasterLvl
));
			DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget));
		}
		
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

	PRCSetSchool();
}
