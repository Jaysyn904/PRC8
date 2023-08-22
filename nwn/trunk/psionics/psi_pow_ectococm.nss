/*
   ----------------
   Ectoplasmic Cocoon, Mass

   psi_pow_ectococm
   ----------------

   9/4/05 by Stratovarius
*/ /** @file

    Ectoplasmic Cocoon, Mass

    Metacreativity
    Level: Shaper 7
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Area: 20-ft.-radius burst
    Duration: 1 hour/level
    Saving Throw: Reflex negates
    Power Resistance: No
    Power Points: 13
    Metapsionics: Extend, Twin, Widen

    You draw writhing strands of ectoplasm from the Astral Plane that wrap up
    the subjects in the area like mummies. The subjects can still breathe but
    are otherwise helpless, unable to see outside the cocoon, speak, or take any
    physical actions. The subjects’s nostrils are clear (air passes through the
    cocoon normally).

    Augment: For every 2 additional power points you spend, the radius of this
             power’s area increases by 5 feet.
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
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC         = GetManifesterDC(oManifester);
        effect eLink    = EffectCutsceneParalyze();
    	       eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
    	       // The cocoon has hardness 8 and 20 hitpoints
	        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    8));
	       	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    8));
	        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 8));    
                eLink = EffectLinkEffects(eLink, EffectDamageReduction(20, DAMAGE_POWER_PLUS_TWENTY, 20));    
        effect eVis     = EffectVisualEffect(VFX_DUR_TENTACLE);
        float fRadius   = EvaluateWidenPower(manif, FeetToMeters(20.0f + (5.0f * manif.nTimesAugOptUsed_1)));
        float fDuration = RoundsToSeconds(manif.nManifesterLevel);
        object oTarget;
        location lTarget = PRCGetSpellTargetLocation();
        if(manif.bExtend) fDuration *= 2;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while (GetIsObjectValid(oTarget))
            {
				// Only effect those that are hostile
	    		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester))
				{
        	        // Let the AI know
	                PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        	        // Reflex negates
	                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                	{
        	            // Apply effects
	       	            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
	                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 4.5f, FALSE);
                	}// end if - Save
				}	

                oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
