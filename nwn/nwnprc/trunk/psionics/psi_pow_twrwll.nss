/*
   ----------------
   Tower of Iron Will

   prc_pow_twrwll
   ----------------

   23/2/05 by Stratovarius
*/ /** @file

    Tower of Iron Will

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 5
    Manifesting Time: 1 swift action
    Range: 10 ft.
    Area: 10-ft.-radius emanation centered on you
    Duration: 1 round
    Saving Throw: None
    Power Resistance: No
    Power Points: 9
    Metapsionics: Extend, Widen

    You generate a bastion of thought so strong that it offers protection to you
    and everyone around you, improving the self-control of all. You and all
    creatures in the power’s area gain power resistance 19 against all
    mind-affecting powers.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round.

    Augment: For every additional power point you spend, this power’s duration
             increases by 1 round and the power resistance it provides increases
             by 1 point.
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
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nPowRes      = 19 + manif.nTimesAugOptUsed_1;
        effect eDur      = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                                             EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE)
                                             );
        effect eVis      = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        effect eFNF      = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
        location lTarget = PRCGetSpellTargetLocation();
        object oTarget;
        float fRadius    = EvaluateWidenPower(manif, FeetToMeters(10.0f));
        float fDuration  = 6.0f * (1 + manif.nTimesAugOptUsed_1);
        if(manif.bExtend) fDuration *= 2;

        // Apply area VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, lTarget);

        // Loop over targets
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            // Store the PR amount
            SetLocalInt(oTarget, "PRC_Power_TowerOfIronWill_PR", nPowRes);

            // Apply impact VFX
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // Set a VFX for the monitor to watch
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

            // Start the monitor
            DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));

            // Get next target
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }// end while - Target loop
    }// end if - Successfull manifestation
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_twrwll: Power expired, clearing");

        // Clear the marker
        DeleteLocalInt(oTarget, "PRC_Power_TowerOfIronWill_PR");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
