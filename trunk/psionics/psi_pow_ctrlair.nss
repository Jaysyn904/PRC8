/*
    ----------------
    Control Air

    psi_pow_ctrlair
    ----------------

    26/3/05 by Stratovarius
*/ /** @file

    Control Air

    Psychokinesis
    Level: Kineticist 2
    Manifesting Time: 1 standard action
    Range: Long (400 ft. + 40 ft./level)
    Area: 50-ft.-radius spread
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Points: 3
    Metapsionics: Twin, Widen

    You summon a gust of wind, knocking down everyone in the area unless they
    succeed at their save.
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
                              PowerAugmentationProfile(),
                              METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        effect eExplode   = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
        effect eWind      = EffectVisualEffect(VFX_IMP_PULSE_WIND);
        effect eKnockdown = EffectKnockdown();
        float fWidth      = EvaluateWidenPower(manif, FeetToMeters(50.0f));
        float fDelay;
        location lTarget  = PRCGetSpellTargetLocation();
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

            // Get targets
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                // Let the AI know
                PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                // Don't knock self down
                if(oTarget != oManifester)
                {
                    // SR check
                    if(PRCMyResistPower(OBJECT_SELF, oTarget,nPen, fDelay))
                    {
                        // Fortitude negates
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                        {
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(3), FALSE);
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eWind, oTarget));
                        }
                    }
                }
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
