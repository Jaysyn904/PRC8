/*
   ----------------
   Reddopsi

   psi_pow_reddopsi
   ----------------

   6/10/05 by Stratovarius
*/ /** @file

    Reddopsi

    Psychokinesis
    Level: Kineticist 7
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 13
    Metapsionics: Extend

    When you manifest reddopsi, powers targeted against you rebound to affect
    the original manifester. This effect reverses powers that have only you as a
    target (except dispel psionics and similar powers or effects). Powers that
    affect an area can’t be reversed. Reddopsi also can’t reverse any power with
    a range of touch.

    Should you rebound a power back against a manifester who also is protected
    by reddopsi, the power rebounds once more upon you.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

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
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eDur     = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR);
	float fDuration = 600.0 * manif.nManifesterLevel;
	if(manif.bExtend) fDuration *= 2;

	// Set the marker local
	SetLocalInt(oTarget, "PRC_Power_Reddopsi_Active", TRUE);

	// Set a VFX for the monitor to watch
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

        // Start the monitor
        DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
    }// end if - Successfull manifestation
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_reddopsi: Power expired, clearing");

        // Clear the marker
        DeleteLocalInt(oTarget, "PRC_Power_Reddopsi_Active");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
