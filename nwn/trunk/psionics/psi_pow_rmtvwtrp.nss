/*
   ----------------
   Remote View Trap

   psi_pow_rmtvwtrp
   ----------------

   11/05/07 by Stratovarius
*/ /** @file

Remote View Trap

Clairsentience [Electricity]
Level: Psion/wilder 6
Display: Mental and visual
Manifesting Time: 1 standard action
Range: Personal
Target: You
Duration: 24 hours + 1 hour/level
Saving Throw: Will half; see text
Power Resistance: No
Power Points: 11
Metapsionics: Extend

When others use clairvoyant sense, remote viewing, or other means of scrying 
you from afar, your prepared trap gives them a nasty surprise. If the scryer 
fails its saving throw, you are undetected. Moreover, the would-be observer 
takes 8d6 points of electricity damage. If the scryer makes its saving throw, 
it takes only 4d6 points of electricity damage and is able to observe you 
normally. Either way, you are aware of the attempt to view you, but not of 
the viewer or the viewer’s location.
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
        float fDur = HoursToSeconds(24) + HoursToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDur *= 2;

    	effect eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_HEAL, 1), EffectSkillDecrease(SKILL_HEAL, 1));
    	//VFX for start & end of the effect
    	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    	//apply the effect
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDur);
    }
}