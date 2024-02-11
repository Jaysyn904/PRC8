//:://////////////////////////////////////////////
//:: Power: Intellect Fortress
//:: psi_pow_intfort
//:://////////////////////////////////////////////
/** @file

    Intellect Fortress

    Psychokinesis
    Level: Psion/wilder 4
    Manifesting Time: 1 swift action
    Range: 20 ft.
    Area: 20-ft.-radius spread centered on you
    Duration: 1 round
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Extend, Widen

    You encase yourself and your allies in a shimmering fortress of telekinetic
    force. All damage from powers and psi-like abilities taken by subjects
    inside the area of the intellect fortress, including ability damage, is
    halved. This lowering takes place prior to the effects of other powers or
    abilities that lessen damage, such as damage reduction and evasion.

    Powers that are not subject to power resistance are not affected by an
    intellect fortress.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round.

    Augment: For every additional power point you spend, this power’s duration
             increases by 1 round.

    @author Ornedan
    @date   Created - 2006.02.02
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

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
        effect eDur      = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                                             EffectVisualEffect(PSI_DUR_INTELLECT_FORTRESS)
                                             );
        effect eVis      = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        effect eFNF      = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
        location lTarget = PRCGetSpellTargetLocation();
        object oTarget;
        float fRadius    = EvaluateWidenPower(manif, FeetToMeters(12.0f));
        float fDuration  = 6.0f * (1 + manif.nTimesAugOptUsed_1);
        if(manif.bExtend) fDuration *= 2;

        // Apply area VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, lTarget);

        // Loop over targets
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
            // Targeting check
            if(oTarget == oManifester                                       ||
               spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oManifester)
               )
            {
                // Set marker local
                SetLocalInt(oTarget, "PRC_Power_IntellectFortress_Active", TRUE);

                // Apply impact VFX
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                // Set a VFX for the monitor to watch
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

                // Start the monitor
                DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
            }// end if - Targeting check

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
        if(DEBUG) DoDebug("psi_pow_intfort: Power expired, clearing");

        // Clear the marker
        DeleteLocalInt(oTarget, "PRC_Power_IntellectFortress_Active");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
