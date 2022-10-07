/*
   ----------------
   Daze, Psionic

   psi_pow_daze
   ----------------

   25/10/04 by Stratovarius
*/ /** @file

    Daze, Psionic

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One humanoid creature that has 4 HD or less
    Duration: 1 round
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin

    You daze a single creature with 4 HD or less.

    Augment: For every additional power point you spend, this power can affect a
             target that has Hit Dice equal to 4 + the additional points.
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
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester);
        int nPen     = GetPsiPenetration(oManifester);
        int nMaxHD   = 4 + manif.nTimesAugOptUsed_1;
        effect eLink =                          EffectDazed();
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
        effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);

        float fDuration = 6.0f;
        if(manif.bExtend) fDuration *= 2;

        //Make sure the target is a humaniod
        if(PRCAmIAHumanoid(oTarget))
        {
            // Hit Dice check
            if(GetHitDice(oTarget) <= nMaxHD)
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
                        //Make a saving throw check
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            //Apply VFX Impact and daze effect
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        }// end if - Failed save
                    }// end if - SR check
                }// end for - Twin Power
            }// end if - HD check
        }// end if - Humanoidity check
    }// end if - Successfull manifestation
}
