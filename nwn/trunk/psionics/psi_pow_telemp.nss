/*
   ----------------
   Telempathic Projection

   psi_pow_telemp
   ----------------

   12/12/04 by Stratovarius
*/ /** @file

    Telempathic Projection

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One creature
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    Using this power, you can grant a +4 bonus on your own (or others’) Bluff,
    Intimidate, Perform, and Persuade checks.
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
        effect eLink    =                          EffectSkillIncrease(SKILL_BLUFF,      4);
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, 4));
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERFORM,    4));
               eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERSUADE,   4));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eTest;
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
    }// end if - Successfull manifestation
}
