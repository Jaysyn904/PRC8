/*
   ----------------
   Thicken Skin

   psi_pow_thickskn
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Thicken Skin

    Psychometabolism
    Level: Egoist 1, psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 1
    Metapsionics: Extend

    Your skin or natural armor thickens and spreads across your body, providing
    a +1 natural enhancement bonus to your Armor Class.

    Augment: For every 3 additional power points you spend, the natural
             enhancement bonus increases by 1.
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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       3, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nACBonus    = 1 + manif.nTimesAugOptUsed_1;
        effect eLink    = EffectLinkEffects(EffectACIncrease(nACBonus, AC_NATURAL_BONUS),
                                            EffectVisualEffect(VFX_DUR_PROT_BARKSKIN)
                                            );
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    }// end if - Successfull manifestation
}
