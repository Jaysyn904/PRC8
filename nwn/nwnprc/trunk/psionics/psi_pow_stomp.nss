/*
   ----------------
   Stomp

   psi_pow_stomp
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Stomp

    Psychokinesis
    Level: Psychic warrior 1
    Manifesting Time: 1 standard action
    Range: 20 ft.
    Area: Cone-shaped spread
    Duration: Instantaneous
    Saving Throw: Reflex negates
    Power Resistance: No
    Power Points: 1
    Metapsionics: Empower, Maximize, Twin, Widen

    Your foot stomp precipitates a psychokinetic shock wave that travels along
    the ground, toppling creatures and loose objects. The shock wave affects
    only creatures standing on the ground within the power’s area. Creatures
    that fail their saves are thrown to the ground, become prone, and take 1d2
    points of bludgeoning damage.

    Augment: For every additional power point you spend, this power’s
             bludgeoning damage increases by 1d2 points.
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
        int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 2;
        int nDamage;
        effect eLink      = EffectLinkEffects(EffectKnockdown(),
                                              EffectVisualEffect(VFX_IMP_SONIC)
                                              );
        effect eDamage;
        float fRange      = EvaluateWidenPower(manif, FeetToMeters(20.0f));
        float fDelay;
        object oTarget;
        location lTarget  = PRCGetSpellTargetLocation();

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester                                             && // Avoid the cone targeting bug
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester) && // Difficulty dependent restrictions
                   GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE      && // Incorporeal creatures are not affected
                   !GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN)                        // And the creature is not just generally immune to knockdown
                   )
                {
                    // Let the AI know
                    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

                    // Save - Reflex negates
                    if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                    {
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);
                        // Target-specific stuff
                        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);
                        // Create damage effect
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);

                        // Apply effects
                        fDelay = GetDistanceBetween(oManifester, oTarget) / 20.0f;
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
    	                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0, FALSE));
                    }// end if - Save
                }// end if - Targeting check

                // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
