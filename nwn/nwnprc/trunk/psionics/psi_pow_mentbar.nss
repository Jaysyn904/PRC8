/*
   ----------------
   Mental Barrier

   psi_pow_mentbar
   ----------------

   17/2/05 by Stratovarius
*/ /** @file

    Mental Barrier

    Clairsentience
    Level: Psion/wilder 3, psychic warrior 3
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round
    Power Points: 5
    Metapsionics: Extend

    You project a field of improbability around yourself, creating a fleeting
    protective shell. You gain a +4 deflection bonus to Armor Class.

    Manifesting the power is a swift action, like manifesting a quickened power,
    and it counts toward the normal limit of one quickened power per round.

    Augment: You can augment this power in one or both of the following ways.
    1. If you spend 4 additional power points, the deflection bonus to Armor
       Class increases by 1.
    2. For every additional power point you spend, this power’s duration
       increases by 1 round.
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
                                                       4, PRC_UNLIMITED_AUGMENTATION,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus      = 4 + manif.nTimesAugOptUsed_1;
        effect eLink    = EffectLinkEffects(EffectACIncrease(nBonus, AC_DEFLECTION_BONUS),
                                            EffectVisualEffect(VFX_DUR_GLOBE_MINOR)
                                            );
        float fDuration = 6.0f * (1 + manif.nTimesAugOptUsed_2);
        if(manif.bExtend) fDuration *= 2;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
    }// end if - Successfull manifestation
}
