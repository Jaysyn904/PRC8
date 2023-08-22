/*
   ----------------
   Inflict Pain

   psi_pow_inpain
   ----------------

   25/10/04 by Stratovarius
*/ /** @file

    Inflict Pain

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 round/level
    Saving Throw: Will partial; see text
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Extend, Twin, Widen

    You telepathically stab the mind of your foe, causing horrible agony. The
    subject suffers wracking pain that imposes a -4 penalty on attack rolls,
    skill checks, and ability checks. If the target makes its save, it takes
    only a -2 penalty.

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
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
        int nPen         = GetPsiPenetration(oManifester);
        int nSecondary   = manif.nTimesAugOptUsed_1;
        int nCounter;
        effect eLink     =                          EffectSkillDecrease(SKILL_ALL_SKILLS, 4);
               eLink     = EffectLinkEffects(eLink, EffectAttackDecrease(4));
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
               eLink     = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
        effect eLink2    =                           EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
               eLink2    = EffectLinkEffects(eLink2, EffectAttackDecrease(2));
               eLink2    = EffectLinkEffects(eLink2, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
               eLink2    = EffectLinkEffects(eLink2, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
        effect eVis      = EffectVisualEffect(VFX_IMP_DOOM);
        location lTarget = GetLocation(oMainTarget);
        object oSecondaryTarget;
        float fRadius    = EvaluateWidenPower(manif, FeetToMeters(15.0f));
        float fDuration  = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

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
                // Apply impact VFX
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);

                // Will partial
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oMainTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oMainTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                }// end if - Save for lesser effect
                else if (!GetHasMettle(oMainTarget, SAVING_THROW_WILL))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oMainTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                }// end else - Apply lesser effect
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
                            // Apply impact VFX
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSecondaryTarget);

                            // Will partial
                            if(!PRCMySavingThrow(SAVING_THROW_WILL, oSecondaryTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                            {
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oSecondaryTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                            }// end if - Save for lesser effect
                            else if (!GetHasMettle(oSecondaryTarget, SAVING_THROW_WILL))
                            {
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oSecondaryTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                            }// end else - Apply lesser effect
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
