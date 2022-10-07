/*
   ----------------
   Steadfast Perception

   psi_pow_stdfstpr
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Steadfast Perception

    Clairsentience
    Level: Psychic warrior 4
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: 7
    Metapsionics: Extend

    Your vision cannot be distracted or misled, granting you immunity to all
    figments and glamers (such as invisibility). Moreover, your Spot and Search
    checks receive a +6 enhancement bonus for the duration of this power.
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
        effect eLink    =                          EffectSeeInvisible();
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT,   6));
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, 6));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eVis     = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        float fDuration = 600.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    }// end if - Successfull manifestation
}
