/*
    ----------------
    Crystallize

    psi_pow_crystlz
    ----------------

    25/10/04 by Stratovarius
*/ /** @file

    Crystallize

    Metacreativity
    Level: Shaper 6
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One living creature
    Duration: Permanent
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Points: 11
    Metapsionics: Twin

    You seed the subject’s flesh with supersaturated crystal. In an eyeblink,
    the subject’s form seems to freeze over, as its flesh and fluids are
    instantly crystallized. Following the application of this power, the subject
    appears lifeless. In fact, it is not dead (though no life can be detected
    with powers or spells that detect such).

    Implementation note: The effect is equivalent to standard petrification.
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
                              METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC      = GetManifesterDC(oManifester);
        int nPen     = GetPsiPenetration(oManifester);

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            //Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                //use bioware petrify effect instead
                //that works better for henchmen, DMs, etc
                //as well as not petrifying undead, constructs, etc
                //and putting all petrification code in one place, so builder hooks can work
                PRCDoPetrification(manif.nManifesterLevel, oManifester, oTarget, manif.nSpellID, nDC);

                /*
                if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
                {
                    //SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPetrify(), oTarget);
                }
                */
            }
        }
    }
}
