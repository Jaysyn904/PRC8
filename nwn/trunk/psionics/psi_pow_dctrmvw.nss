/*
   ----------------
   Detect Remote Viewing

   psi_pow_dctrmvw
   ----------------

   11/05/07 by Stratovarius
*/ /** @file

Detect Remote Viewing

Clairsentience
Level: Psion/wilder 4
Display: Mental and visual
Manifesting Time: 1 standard action
Range: Personal
Target: You
Duration: 24 hours
Saving Throw: None
Power Resistance: No
Power Points: 7
Metapsionics: Extend.

You immediately become aware of any attempt to observe you by means of a clairsentience (scrying) power or divination (scrying) spell.
You and the remote viewer immediately make opposed manifester level checks. If you succeed you learn the manifester's name and location.
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
        float fDur = HoursToSeconds(24);
        if(manif.bExtend) fDur *= 2;

    	effect eEffect = EffectLinkEffects(EffectSkillIncrease(SKILL_HEAL, 1), EffectSkillDecrease(SKILL_HEAL, 1));
    	//VFX for start & end of the effect
    	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    	eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    	//apply the effect
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDur);
    }
}