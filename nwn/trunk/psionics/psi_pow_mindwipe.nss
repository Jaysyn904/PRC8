/*
   ----------------
   Mindwipe

   psi_pow_mindwipe
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Mindwipe

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 4
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Points: 7
    Metapsionics: Twin

    You partially wipe your victim’s mind of past experiences, bestowing two
    negative levels upon it. If the subject has at least as many negative levels
    as Hit Dice, it dies. The effects of multiple negative levels stack.

    If the subject survives, it loses these two negative levels after 1 hour.
    (No Fortitude save is necessary to avoid gaining the negative level
    permanently.)

    Augment: You can manifest this power in one or both of the following ways.
    1. For every 2 additional power points you spend, this power’s save DC
       increases by 1.
    2. For every 3 additional power points you spend, this power bestows an
       additional negative level on the subject.
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
                                                       3, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
        int nPen          = GetPsiPenetration(oManifester);
        int nNegLevels    = 2 + manif.nTimesAugOptUsed_2;
        effect eLink      = EffectLinkEffects(EffectNegativeLevel(nNegLevels),
                                              EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)
                                              );

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Check for Power Resistance
            if(PRCMyResistPower(oManifester, oTarget, nPen))
            {
                // Save - Fort negates
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
                {
                    // Delayed to make sure the negative levels stack
                    DelayCommand(0.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(1), TRUE, manif.nSpellID, manif.nManifesterLevel));
                }// end if - Save
            }// end if - SR
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
