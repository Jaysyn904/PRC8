/*
   ----------------
   Ultrablast

   prc_pow_ultrabst
   ----------------

   25/2/04 by Stratovarius
*/ /** @file

    Ultrablast

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 7
    Manifesting Time: 1 standard action
    Range: 15 ft.
    Area: 15-ft.-radius spread centered on you
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Points: 13
    Metapsionics: Empower, Maximize, Twin, Widen

    You “grumble” psychically (which both psionic and nonpsionic creatures can
    detect), then release a horrid shriek from your subconscious that disrupts
    the brains of all enemies in the power’s area, dealing 13d6 points of damage
    to each enemy.

    Augment: For every additional power point you spend, this power’s damage
             increases by 1d6 points.
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
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        int nDC           = GetManifesterDC(oManifester);
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 13 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nDamage;
        effect eFNF       = EffectVisualEffect(VFX_FNF_HOWL_MIND);
        effect eVis       = EffectVisualEffect(PSI_IMP_ULTRABLAST);
        effect eDamage;
        float fRadius     = EvaluateWidenPower(manif, FeetToMeters(15.0f));
        float fDelay;
        location lTarget  = PRCGetSpellTargetLocation();
        object oTarget;

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Apply area VFX
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, lTarget);

            // Loop over targets
            oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                // Targeting limitations
                if(oTarget != oManifester                                            && // Don't hit self
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester)   // Difficulty limits
                   )
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Check Immunity and Power Resistance
                    if(PRCMyResistPower(oManifester, oTarget, nPen)                 &&
                       !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oManifester)
                       )
                    {
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                        // Target-specific stuff
                        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);

                        // Save - Will half
                        if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            nDamage /= 2;
                            
                    		if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                    		{
                			nDamage = 0;
                    		}                             
                        }

                        // Create effect, calculate delay and apply
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                        fDelay  = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) / 20.0f;
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }// end if - SR check
                }// end if - Targeting check

                // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
