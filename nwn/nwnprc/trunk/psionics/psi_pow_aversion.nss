/*
   ----------------
   Aversion

   psi_pow_aversion
   ----------------

   19/4/05 by Stratovarius
*/ /** @file

    Aversion

    Telepathy (Compulsion) [Mind-Affecting]
    Level: Telepath 2
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: 1 hour/level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Extend, Twin

    You plant a powerful aversion in the mind of the subject. The target flees
    from you at every opportunity.

    Augment: For every 2 additional power points you spend, this power’s save DC
             increases by 1 and the duration increases by 1 hour.
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
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        // Get some more data
        int nDC  = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
	    int nPen = GetPsiPenetration(oManifester);

	    float fDur = HoursToSeconds(manif.nManifesterLevel + manif.nTimesAugOptUsed_1);
	    if(manif.bExtend) fDur *= 2;

	    // Build effects
	    effect eVis  = EffectVisualEffect(VFX_IMP_DAZED_S);
	    effect eLink =                          EffectFrightened();
	           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
	           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

        // Let the target know a power was used on it
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            //Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply VFX Impact and fear effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, manif.nSpellID, manif.nManifesterLevel);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }// end if - Save to negate
            }// end if - SR check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
