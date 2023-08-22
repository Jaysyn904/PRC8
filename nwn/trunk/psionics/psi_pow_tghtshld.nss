/*
   ----------------
   Thought Shield

   psi_pow_tghtshld
   ----------------

   9/11/04 by Stratovarius
*/ /** @file

    Thought Shield

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 2, psychic warrior 2
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round
    Power Points: 3
    Metapsionics: Extend

    You fortify your mind against intrusions, gaining power resistance 13
    against all mind-affecting powers.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round.

    Augment: For every additional power point you spend, this power’s duration
             increases by 1 round, and the power resistance it provides
             increases by 1 point.
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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nPowRes     = 13 + manif.nTimesAugOptUsed_1;
        effect eDur     = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                                            EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE)
                                            );
        effect eVis     = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        float fDuration = 6.0f * (1 + manif.nTimesAugOptUsed_1);
        if(manif.bExtend) fDuration *= 2;

        // Store the PR amount
        SetLocalInt(oTarget, "PRC_Power_ThoughtShield_PR", nPowRes);

        // Apply impact VFX
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

        // Set a VFX for the monitor to watch
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

        // Start the monitor
        DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
    }
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_tghtshld: Power expired, clearing");

        // Clear the marker
        DeleteLocalInt(oTarget, "PRC_Power_ThoughtShield_PR");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
