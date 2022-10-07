/*
   ----------------
   Touchsight

   psi_pow_tchsght
   ----------------

   17/2/05 by Stratovarius
*/ /** @file

    Touchsight

    Psychometabolism
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 5
    Metapsionics: Extend

    You generate a subtle telekinetic field of mental contact, allowing you to
    “feel” your surroundings even in total darkness or when your sight would
    otherwise be obscured by your physical environment. You ignore invisibility,
    darkness, and concealment. You do not need to make Spot or Listen checks to
    notice creatures; you can detect and pinpoint all creatures within 60 feet.
    In many circumstances, comparing your regular senses to what you learn with
    touchsight is enough to tell you the difference between visible, invisible,
    hiding, and concealed creatures.
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
        effect eLink    =                          EffectTrueSeeing();
               eLink    = EffectLinkEffects(eLink, EffectUltravision());
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_ULTRAVISION));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    }// end if - Successfull manifestation
}
