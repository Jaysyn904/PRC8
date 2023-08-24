/*
   ----------------
   Hustle

   psi_pow_hustle
   ----------------

   26/3/05 by Stratovarius
*/ /** @file

    Hustle

    Psychometabolism
    Level: Egoist 3, psychic warrior 2
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Power Points: Egoist 5, psychic warrior 3
    Metapsionics: Extend

    You gain the effect of Haste for one round.

    You can manifest this power with an instant thought. Manifesting the power
    is a swift action, like manifesting a quickened power, and it counts toward
    the normal limit of one quickened power per round.
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
        effect eLink    = EffectLinkEffects(EffectHaste(),
                                            EffectVisualEffect(VFX_IMP_HASTE)
                                            );
        float fDuration = manif.bExtend ? 12.0f : 6.0f;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
    }
}
