/*
   ----------------
   Eradicate Invisibility

   psi_pow_neginvis
   ----------------

   11/12/04 by Stratovarius
*/ /** @file

    Eradicate Invisibility

    Psychokinesis
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: 50 ft.
    Targets: You and all invisible creatures and objects in a 50-ft.-radius burst centered on you
    Duration: Instantaneous
    Saving Throw: Reflex negates
    Power Resistance: No
    Power Points: 5
    Metapsionics: Twin, Widen

    You radiate a psychokinetic burst that disrupts and negates all types of
    invisibility. Any creature that fails its save to avoid the effect loses its
    invisibility.

    Augment: For every additional power point you spend, this power’s range and
             the radius of the burst in which it functions both increase by 5
             feet.
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
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_TWIN |METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC          = GetManifesterDC(oManifester);
        effect eImpact   = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        effect eTest;
        float fRadius    = EvaluateWidenPower(manif, FeetToMeters(50.0f + (5.0f * manif.nTimesAugOptUsed_1)));
        location lTarget = PRCGetSpellTargetLocation();
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Apply impact VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

            // Loop over targets in the area
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oTarget))
            {
                // Difficulty check
                if(oTarget == oManifester                                            || // Despite usual limitations, this power explicitly hits self
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester)
                   )
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Save - Reflex negates
                    if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        // Loop over effects and remove all (non-cutscene) invisibility ones
                        eTest = GetFirstEffect(oTarget);
                        while(GetIsEffectValid(eTest))
                        {
                            if(GetEffectType(eTest) == EFFECT_TYPE_INVISIBILITY         ||
                               GetEffectType(eTest) == EFFECT_TYPE_IMPROVEDINVISIBILITY
                               )
                                RemoveEffect(oTarget, eTest);

                            eTest = GetNextEffect(oTarget);
                        }// end while - Effect loop
                    }// end if - Save
                }// end if - Targeting limitations

                // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
            }// end while - Target Loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
