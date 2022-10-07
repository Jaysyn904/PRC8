/*
   ----------------
   Darkvision, Psionic

   psi_pow_darkvis
   ----------------

   25/10/04 by Stratovarius
*/ /** @file

    Darkvision, Psionic

    Clairsentience
    Level: Psion/wilder 3, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: Psion/wilder 5, psychic warrior 3
    Metapsionics: Extend

    You psionically enhance your eyes to gain the effects of darkvision.
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
        effect eLink =                          EffectVisualEffect(VFX_DUR_ULTRAVISION);
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
               eLink = EffectLinkEffects(eLink, EffectUltravision());
        float fDuration = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, manif.nManifesterLevel);
    }
}
