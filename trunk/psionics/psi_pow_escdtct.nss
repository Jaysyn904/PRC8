/*
   ----------------
   Escape Detection

   psi_pow_escdtct
   ----------------

   11/05/07 by Stratovarius
*/ /** @file

Escape Detection

Clairsentience
Level: Psychic warrior 3, seer 3
Display: None
Manifesting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour/level
Power Points: 5
Metapsionics: Extend

You (plus all your gear and any objects you carry) become difficult to detect by clairsentience powers 
such as clairvoyant sense, remote viewing, and others. If a clairsentience power or similar effect is 
attempted against you, the manifester of the power must succeed on a manifester level check (1d20 + 
manifester level, or caster level if the opponent is not a manifester) against a DC of 13 + your manifester level (maximum +10).
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
        float fDur = HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDur *= 2;

    	effect eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_HEAL, 1), EffectSkillDecrease(SKILL_HEAL, 1));
    	//VFX for start & end of the effect
    	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    	//apply the effect
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDur);
    }
}