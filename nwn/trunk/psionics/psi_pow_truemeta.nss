/*
   ----------------
   True Metabolism

   psi_pow_truemeta
   ----------------

   25/2/05 by Stratovarius
*/ /** @file

    True Metabolism

    Psychometabolism
    Level: Psion/wilder 8
    Manifesting Time: 1 round
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 15
    Metapsionics: Extend

    You are difficult to kill while this power persists. You automatically heal
    damage at the rate of 10 hit points per round.

    This power is not effective against damage from starvation, thirst, or
    suffocation. Also, attack forms that don’t deal hit point damage (for
    example, most poisons) ignore true metabolism. You must have a Constitution
    score to gain any of this power’s benefits.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
        effect eLink    =                          EffectRegenerate(10, 6.0f);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_ACIDSHIELD));
        effect eVis     = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }// end if - Successfull manifestation
}
