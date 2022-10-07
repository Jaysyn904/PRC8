/*
   ----------------
   Share Pain, Forced

   psi_pow_shrpainf
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Share Pain, Forced

    Psychometabolism
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 round/level
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Extend, Twin

    As share pain, except as noted here.

    You attempt to force the sharing of your wounds with an unwilling creature,
    and for less time. If you are immune to the type of damage dealt, the target
    takes no damage.

    Augment: For every 2 additional power points you spend, this power’s save DC
             increases by 1.


    Implementation notes:
    You may not have more than one Share Pain or Share Pain, Forced active at
    any one time. Any subsequent uses override the previous.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nManifesterLevel, int nBeatsRemaining);

void main()
{
    // Power use hook
    if(!PsiPrePowerCastCode()) return;

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC         = GetManifesterDC(oManifester);
        int nPen        = GetPsiPenetration(oManifester);
        int bSuccess    = FALSE;
        effect eDurPos  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
        effect eDurNeg  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        float fDuration = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen) && PRCGetIsAliveCreature(oTarget))
            {
                // Save - Fortitude negates
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    bSuccess = TRUE;
                }// end if - Save
            }// end if - SR check
        }// end for - Twin Power

        // This stuff should only be done once, even if the the power is twinned and both attempts succeed
        if(bSuccess)
        {
            // Get the OnHitCast: Unique on the manifester's armor / hide
            ExecuteScript("prc_keep_onhit_a", oManifester);

            // Hook eventscript
            AddEventScript(oManifester, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);

            // Store the target for use in the damage script
            SetLocalObject(oManifester, "PRC_Power_SharePain_Target", oTarget);

            // Do VFX for the monitor to look for
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurNeg, oTarget,     fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurPos, oManifester, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

            // Start effect end monitor
            DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, manif.nManifesterLevel, FloatToInt(fDuration) / 6));
        }// end if - The power affected the target at least once
    }// end if - Successfull manifestation
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nManifesterLevel, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                            ||
       GetIsDead(oTarget)                                                  ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)     ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oManifester, oManifester) ||
       GetDistanceBetween(oManifester, oTarget) > FeetToMeters(25.0f + (5.0f * (nManifesterLevel / 2)))
       )
    {
        if(DEBUG) DoDebug("psi_pow_shrpain: Effect expired, clearing");
        // Clear the target local
        DeleteLocalObject(oManifester, "PRC_Power_SharePain_Target");
        // Remove the eventscript
        RemoveEventScript(oManifester, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);

        // Remove remaining effects
        PRCRemoveSpellEffects(nSpellID, oManifester, oTarget);
        PRCRemoveSpellEffects(nSpellID, oManifester, oManifester);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nManifesterLevel, nBeatsRemaining));
}
