/*
   ----------------
   Burst

   prc_pow_burst
   ----------------

   8/4/05 by Stratovarius
*/ /** @file

    Burst

    Psychoportation
    Level: Nomad 1, psychic warrior 1
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 round
    Power Points: 1
    Metapsionics: Extend

    This power increases your speed by 50%.

    Manifesting this power is a swift action, like manifesting a quickened
    power, and it counts toward the normal limit of one quickened power per
    round.
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
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        float fDur = 6.0f;
        if(manif.bExtend) fDur *= 2;

        effect eFast = EffectMovementSpeedIncrease(150);
        effect eVis  = EffectVisualEffect(PSI_DUR_BURST);
        effect eLink = EffectLinkEffects(eFast, eVis);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, -1, manif.nManifesterLevel);
    }
}
