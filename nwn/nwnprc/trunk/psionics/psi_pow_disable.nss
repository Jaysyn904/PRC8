/*
   ----------------
   Disable

   psi_pow_disable
   ----------------

   29/10/04 by Stratovarius
*/ /** @file

    Disable

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: 20 ft.
    Area: Cone-shaped emanation centered on you
    Duration: 1 min./level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin, Widen

    You broadcast a mental compulsion that convinces one or more creatures of
    4 Hit Dice or less that they are disabled. Creatures with the fewest HD are
    affected first. Among creatures with equal Hit Dice, those who are closest
    to the power’s point of origin are affected first. Hit Dice that are not
    sufficient to affect a creature are wasted.
    Creatures affected by this power believe that they have somehow been brought
    to the brink of unconsciousness and must act accordingly.

    Augment: For every 2 additional power points you spend, this power’s range
             increases by 5 feet and its save DC increases by 1.
    In addition, for every additional power point you spend to increase the range and
    the save DC, this power can affect targets that have Hit Dice equal to 4 + the
    number of additional points.
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
                              PowerAugmentationProfile(1,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC         = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
        int nPen        = GetPsiPenetration(oManifester);
        int nMaxHD      = 4 + manif.nTimesGenericAugUsed;
        int nHDLeft     = nMaxHD;
        int nTargetHD;
        effect eLink    = EffectSlow();
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        effect eVis     = EffectVisualEffect(VFX_IMP_DAZED_S);
        float fWidth    = EvaluateWidenPower(manif, FeetToMeters(20.0f + (5.0f * manif.nTimesAugOptUsed_1)));
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Determine potential targets
        location lTarget = PRCGetSpellTargetLocation();
        object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oTarget))
        {
             if(oTarget != oManifester                    && // Not the manifester
                spellsIsTarget(oTarget,                      // Game difficulty adjustment
                               SPELL_TARGET_STANDARDHOSTILE,
                               oManifester)
                )
            {
                AddToTargetList(oTarget, oManifester, INSERTION_BIAS_HD, FALSE);
            }// end if - target is valid for this
            oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }// end while - target list generation

        // Now get targets until out of affectable HD or out of targets
        oTarget = GetTargetListHead(oManifester);
        while(nHDLeft > 0 && GetIsObjectValid(oTarget))
        {
            nTargetHD = GetHitDice(oTarget);
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) && // Check that the target has a mind to affect
               nTargetHD <= nMaxHD                              && // It has low enough HD to be affectable at all
               nTargetHD <= nHDLeft                                // There are enough affectable HD left to affect it
               )
            {
                // Let the AI know
                PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                // Handle Twin Power
                int nRepeats = manif.bTwin ? 2 : 1;
                for(; nRepeats > 0; nRepeats--)
                {
                    //Check for Power Resistance
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Will negates
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            //Apply VFX Impact and slow effect
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        }// end if - Failed save
                    }// end if - SR check
                }// end for - Twin Power

                // Only remove from the HD pool if an attempt was made
                nHDLeft -= nTargetHD;
            }// end if - Target validity testing

            // Get next target, if any
            oTarget = GetTargetListHead(oManifester);
        }// end while - Target loop
    }// end if - Successfull manifestation
}
