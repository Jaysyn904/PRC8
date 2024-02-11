/*
   ----------------
   Sequester, Psionic

   psi_pow_sequestr
   ----------------

   11/05/07 by Stratovarius
*/ /** @file

Sequester, Psionic

Clairsentience
Level: Psion/wilder 7
Display: None
Manifesting Time: 1 standard action
Range: Touch
Target: One willing creature or one object (up to a 2-ft. cube/level) touched
Duration: One day/level (D)
Saving Throw: None or Will negates (object)
Power Resistance: No or Yes (object)
Power Points: 13
Metapsionics: Extend

When cast, this spell not only prevents divination spells from working to detect or 
locate the creature or object affected by sequester, it also renders the affected 
creature or object invisible to any form of sight or seeing (as the invisibility spell). 
The spell does not prevent the subject from being discovered through tactile means or 
through the use of devices. Creatures affected by sequester become comatose and are effectively 
in a state of suspended animation until the spell wears off or is dispelled.

Note: The Will save prevents an attended or magical object from being sequestered. 
There is no save to see the sequestered creature or object or to detect it with a divination spell.

Material Component: A basilisk eyelash, gum arabic, and a dram of whitewash.
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
        float fDur = HoursToSeconds(24) * manif.nManifesterLevel;
        if(manif.bExtend) fDur *= 2;

    	// Effects (Invis)
    	effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    	effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eCover = EffectConcealment(50);
    	effect eLink = EffectLinkEffects(eDur, eCover);
    	eLink = EffectLinkEffects(eLink, eVis);    
    	eLink = EffectLinkEffects(eLink, eInvis);
    	// Target also is in suspended animation
    	eLink = EffectLinkEffects(eLink, EffectCutsceneParalyze());
    	//apply the effect
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
    }
}