/*
   ----------------
   Identify, Psionic

   psi_pow_identify
   ----------------

   22/10/04 by Stratovarius
*/ /** @file

    Identify, Psionic

    Clairsentience
    Level: Psion/wilder 2
    Manifesting Time: 1 standard action
    Range: Touch
    Target: One touched object
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: None

    The power determines all magic properties of a single magic item.
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
                              METAPSIONIC_NONE
                              );

    if(manif.bCanManifest)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);

        SetIdentified(oTarget, TRUE);

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 4.5f, FALSE);
    }
}