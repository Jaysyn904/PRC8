/*
   ----------------
   True Seeing, Psionic

   psi_pow_truesee
   ----------------

   23/2/05 by Stratovarius
*/ /** @file

    True Seeing, Psionic

    Clairsentience
    Level: Psion/wilder 5
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 9
    Metapsionics: Extend

    As the true seeing spell, except as noted here.
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
        effect eLink    =                          EffectVisualEffect(VFX_DUR_ULTRAVISION);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eTrueSee = EffectTrueSeeing();
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Adjust to PnP-like True Seeing
        if(GetPRCSwitch(PRC_PNP_TRUESEEING))
        {
            eTrueSee  = EffectSeeInvisible();
            int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
            // Default to 15
            if(nSpot == 0)
                nSpot = 15;
            effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
            eTrueSee     = EffectLinkEffects(eTrueSee , eSpot);
        }

        // Finish the effect link
        eLink = EffectLinkEffects(eLink, eTrueSee);

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    }// end if - Successfull manifestation
}
