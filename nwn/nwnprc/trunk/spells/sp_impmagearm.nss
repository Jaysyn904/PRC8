#include "prc_inc_spells"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	PRCSetSchool(SPELL_SCHOOL_CONJURATION);

	// Declare major variables
	object oTarget = PRCGetSpellTargetObject();

	// Signal the spell cast at event
	PRCSignalSpellEvent(oTarget, FALSE);
	
	int nCasterLevel = PRCGetCasterLevel();
	
	// Boost AC.
	int nIncrease = 3 + nCasterLevel / 2;
	if (nIncrease > 8) nIncrease = 8;
    effect eAC = EffectACIncrease(nIncrease, AC_ARMOUR_ENCHANTMENT_BONUS);
    eAC = EffectLinkEffects(eAC, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

	// Get duration, 1 hour / level unless extended.
	float fDuration = PRCGetMetaMagicDuration(MinutesToSeconds(nCasterLevel));
	
	// Build the list of fancy visual effects to apply when the spell goes off.
	effect eVFX = EffectVisualEffect(VFX_IMP_AC_BONUS);

	// Remove existing effect, if any.	
    PRCRemoveEffectsFromSpell(oTarget, GetSpellId());

	// Apply effects and VFX to target
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, fDuration,TRUE,-1,nCasterLevel);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
	
	PRCSetSchool();
}
