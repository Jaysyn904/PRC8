/*
   ----------------
   Mental Disruption

   psi_pow_mntdsrp
   ----------------

   7/11/04 by Stratovarius
*/ /** @file

    Mental Disruption

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: 10 ft.
    Area: 10-ft.-radius spread centered on you
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Twin, Widen

    You generate a mental wave of confusion that instantly sweeps out from your
    location. All creatures you designate in the affected area (you can choose
    certain creatures to be unaffected) must make a Will save or become dazed
    for 1 round.

    Augment: You can augment this power in one or both of the following ways.
    1. For every 2 additional power points you spend, this power’s save DC
       increases by 1.
    2. For every 2 additional power points you spend, this power’s range and the
       radius of its area both increase by 5 feet.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

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
                                                       2, PRC_UNLIMITED_AUGMENTATION,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
        int nPen         = GetPsiPenetration(oManifester);
        effect eLink     =                          EffectDazed();
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        effect eVis      = EffectVisualEffect(VFX_IMP_DAZED_S);
        effect eImpact   = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        float fRadius    = EvaluateWidenPower(manif, FeetToMeters(10.0f + (5.0f * manif.nTimesAugOptUsed_2)));
        location lTarget = PRCGetSpellTargetLocation();
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Apply impact VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester                                             && // No targeting self
                   spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oManifester)   // Select only hostiles
                   )
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Check for Power Resistance
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Save - Will negates
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            // Apply effect & VFX
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0f, TRUE, manif.nSpellID, manif.nManifesterLevel);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        }// end if - Save
                    }// end if - SR check
                }// end if - Target validity check

                // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
