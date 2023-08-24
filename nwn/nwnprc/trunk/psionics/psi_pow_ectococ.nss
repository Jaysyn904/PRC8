/*
   ----------------
   Ectoplasmic Cocoon

   psi_pow_ectococ
   ----------------

   9/4/05 by Stratovarius
*/ /** @file

    Ectoplasmic Cocoon

    Metacreativity
    Level: Shaper 3
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One Medium or smaller creature
    Duration: 1 round/level
    Saving Throw: Reflex negates
    Power Resistance: No
    Power Points: 5
    Metapsionics: Extend, Twin

    You draw writhing strands of ectoplasm from the Astral Plane that wrap up
    the subject like a mummy. The subject can still breathe but is otherwise
    helpless, unable to see outside the cocoon, speak, or take any physical
    actions. The subject’s nostrils are clear (air passes through the cocoon
    normally).

    Augment: You can augment this power in one or both of the following ways.
    1. For every 2 additional power points you spend, this power’s save DC
       increases by 1.
    2. For every 2 additional power points you spend, this power can affect a
       target one size category larger.
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
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION,
                                                       2, 4
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
        int nMaxSize = CREATURE_SIZE_MEDIUM + manif.nTimesAugOptUsed_2;
    	effect eLink =                          EffectCutsceneParalyze();
    	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY));
    	       // The cocoon has hardness 8 and 20 hitpoints
       		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    8));
		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    8));
                eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 8));    
                eLink = EffectLinkEffects(eLink, EffectDamageReduction(20, DAMAGE_POWER_PLUS_TWENTY, 20));    
        effect eVis  = EffectVisualEffect(VFX_DUR_TENTACLE);
        float fDuration = RoundsToSeconds(manif.nManifesterLevel);
        if(manif.bExtend) fDuration *= 2;

        // Target size check
        if(PRCGetCreatureSize(oTarget) <= nMaxSize)
        {
            // Let the AI know
            PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                // Reflex negates
                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    // Apply effects
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 4.5f, FALSE);
                }// end if - Save
            }// end for - Twin Power
        }// end if - Size check
    }// end if - Successfull manifestation
}
