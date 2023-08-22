/*
   ----------------
   Insanity

   psi_pow_insane
   ----------------

   25/2/05 by Stratovarius
*/ /** @file

    Insanity

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Psion/wilder 7
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 13
    Metapsionics: Twin, Widen

    Creatures affected by this power are permanently confused and constantly
    behave randomly, as the spell.

    Augment: For every 2 additional power points you spend, this power’s save DC
             increases by 1, and the power can affect an additional target. Any
             additional target cannot be more than 15 feet from another target
             of the power.
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
    object oMainTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oMainTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
        int nPen         = GetPsiPenetration(oManifester);
        int nSecondary   = manif.nTimesAugOptUsed_1;
        int nCounter;
        effect eLink     =                          PRCEffectConfused();
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED));
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
               eLink     = SupernaturalEffect(eLink);
        effect eVis      = EffectVisualEffect(VFX_IMP_CONFUSION_S);
        location lTarget = GetLocation(oMainTarget);
        object oSecondaryTarget;
        float fRadius    = EvaluateWidenPower(manif, FeetToMeters(15.0f));

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            /* Affect the main target */
            // Let the AI know
            PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, oManifester);

            // Check for Power Resistance
            if(PRCMyResistPower(oManifester, oMainTarget, nPen))
            {
                // Will negates
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oMainTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // Apply effects
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oMainTarget, 0.0f, TRUE, manif.nSpellID, manif.nManifesterLevel);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);
                }// end if - Save to negate
            }// end if - SR check

            // Affect targets in the area if augmented
            if(nSecondary)
            {
                nCounter = 0;
                oSecondaryTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oSecondaryTarget) && nCounter < nSecondary)
                {
                    if(oSecondaryTarget != oManifester                                             &&
                       oSecondaryTarget != oMainTarget                                             &&
                       spellsIsTarget(oSecondaryTarget, SPELL_TARGET_SELECTIVEHOSTILE, oManifester)
                       )
                    {
                        // Let the AI know
                        PRCSignalSpellEvent(oSecondaryTarget, TRUE, manif.nSpellID, oManifester);

                        // Check for Power Resistance
                        if(PRCMyResistPower(oManifester, oSecondaryTarget, nPen))
                        {
                            // Will negates
                            if(!PRCMySavingThrow(SAVING_THROW_WILL, oSecondaryTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                            {
                                // Apply effects
                                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSecondaryTarget, 0.0f, TRUE, manif.nSpellID, manif.nManifesterLevel);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSecondaryTarget);
                            }// end if - Save to negate
                        }// end if - SR check

                        // Use up a target slot only if we actually did something to it
                        nCounter += 1;
                    }// end if - Target is someone we want to / can affect

                    // Get next target
                    oSecondaryTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
                }// end while - Target loop
            }// end if - There are secondary targets
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
