/*
   ----------------
   Body Equilibrium

   psi_pow_bdyequib
   ----------------

   6/12/04 by Stratovarius
*/ /** @file

    Body Equilibrium

    Psychometabolism
    Level: Psion/wilder 2, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 3
    Metapsionics: Extend

    You adjust your bodies equilibrium to correspond with the surface you are walking on,
    making you able to move easily across unusual and unstable surfaces. This makes you
    immune to entangle.
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
        effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
        effect eVis      = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
        effect eDur      = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink     = EffectLinkEffects(eVis, eEntangle);
               eLink     = EffectLinkEffects(eLink, eDur);

        float fDur = 600.0 * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, -1, manif.nManifesterLevel);
    }
}
