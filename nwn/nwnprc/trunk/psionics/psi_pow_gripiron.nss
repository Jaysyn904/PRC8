/** @file psi_pow_gripiron

    Grip of Iron

    Psychometabolism
	Level: Psychic warrior 1
	Manifesting Time: 1 swift action
	Range: Personal
	Target: You
	Duration: 1 round/level
	Saving Throw: None
	Power Resistance: No
	Power Points: 1
	Metapsionics: Extend
	
	You can improve your chances in a grapple as an immediate action, gaining a +4 enhancement bonus on your grapple checks.
	 
	Augment: For every 4 additional power points you spend, the enhancement bonus on your grapple checks increases by 2.

    @author Stratovarius
    @date   Created: May 3, 2021
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(4),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
    	effect eVis     = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
        effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        float fDuration = RoundsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        int nBoost = 4 + manif.nTimesGenericAugUsed*2;
        if (DEBUG) DoDebug("psi_pow_gripiron nBoost = "+IntToString(nBoost));
        SetLocalInt(oTarget, "Psi_GripOfIron", nBoost);
    }
}