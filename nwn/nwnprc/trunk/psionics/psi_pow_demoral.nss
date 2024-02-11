/*
   ----------------
   Demoralize

   psi_pow_demoral
   ----------------

   29/10/04 by Stratovarius
*/ /** @file

    Demoralize

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: 30 ft.
    Area: 30-ft.-radius spread centered on you
    Duration: 1 min./level
    Saving Throw: Will negates
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Extend, Twin, Widen

    You fill your enemies with self-doubt. Any enemy in the area that fails its
    save becomes shaken for the duration of the power. Allies are unaffected.

    Augment: For every 2 additional power points you spend, this power’s range
             and the radius of its area both increase by 5 feet, and the power’s
             save DC increases by 1.
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
        int nDC         = GetManifesterDC(oManifester) + manif.nTimesAugOptUsed_1;
        int nPen        = GetPsiPenetration(oManifester);
        effect eDoom    = EffectShaken();
    	effect eImpact  = EffectVisualEffect(VFX_IMP_DOOM);
    	effect eFNF     = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        float fWidth    = EvaluateWidenPower(manif, FeetToMeters(30.0f + (5.0f * manif.nTimesAugOptUsed_1)));
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;
        location lTarget = GetLocation(oManifester);
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Do VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, lTarget);

            // Target loop
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, lTarget, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                // No scaring self or non-hostiles
                if(oTarget != oManifester &&
                   spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oManifester)
                   )
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Check for Power Resistance
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Will negates
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            // Apply effect and visuals
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDoom, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                        }// end if - Failed save
                    }// end if - SR check
                }// end if - Target is someone we don't want to skip

                oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, lTarget, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
