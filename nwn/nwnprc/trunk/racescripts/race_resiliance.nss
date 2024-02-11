/* Resiliance racial ability for Elans
   Piggybacks on the Psionic system as a "fake manifestation" similar to Diamond Dragons 
   To simulate damage prevention adds Temp HP for 1 round.*/

#include "psi_inc_psifunc"
#include "prc_sp_func"

void main()
{

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
         EvaluateManifestation(oManifester, oTarget, PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS, 1, PRC_UNLIMITED_AUGMENTATION), METAPSIONIC_NONE); 
                              
    effect eHP = EffectTemporaryHitpoints(manif.nTimesAugOptUsed_1 * 2);

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eHP), oTarget, 6.0, TRUE, -1, 0);
}