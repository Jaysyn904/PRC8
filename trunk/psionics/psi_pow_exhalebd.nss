/*
   ----------------
   Exhalation of the Black Dragon

   psi_pow_exhalebd
   ----------------

   28/10/04 by Stratovarius
*/ /** @file

    Exhalation of the Black Dragon

    Psychometabolism [Acid]
    Level: Psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Chain, Empower, Maximize, Split Psionic Ray, Twin

    You spit forth vitriolic acid, originating from your mouth, at your target.
    If you succeed on a ranged touch attack, the target takes 3d6 points of
    acid damage.

    Augment: For every 2 additional power points you spend, this power’s damage
             increases by 1d6 points.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_sp_tch"

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
    object oMainTarget = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oMainTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_CHAIN | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_SPLIT | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nPen          = GetPsiPenetration(oManifester);
        int nNumberOfDice = 3 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nTouchAttack, i, nDamage;
        effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
        object oSecondaryTarget = GetSplitPsionicRayTarget(manif, oMainTarget);
        object oChainTarget;

        // Determine Chain Power targets
        if(manif.bChain)
            EvaluateChainPower(manif, oMainTarget, TRUE);

        // Let the AI know
        PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, oManifester);
        if(GetIsObjectValid(oSecondaryTarget))
            PRCSignalSpellEvent(oSecondaryTarget, TRUE, manif.nSpellID, oManifester);
        if(manif.bChain)
            for(i = 0; i < array_get_size(oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                PRCSignalSpellEvent(array_get_object(oManifester, PRC_CHAIN_POWER_ARRAY, i), TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Perform the Touch Attack on the main target
            nTouchAttack = PRCDoRangedTouchAttack(oMainTarget);
            if(nTouchAttack > 0)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oMainTarget, nPen))
                {
                    // Calculate damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, TRUE);

                    // Apply VFX and damage to main target
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oMainTarget);
                    ApplyTouchAttackDamage(oManifester, oMainTarget, nTouchAttack,
                                           GetTargetSpecificChangesToDamage(oMainTarget, oManifester, nDamage, TRUE, TRUE),
                                           DAMAGE_TYPE_ACID
                                           );
                    // Apply damage to Chain targets
                    if(manif.bChain)
                    {
                        // Halve the damage
                        nDamage /= 2;

                        for(i = 0; i < array_get_size(oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                        {
                           oChainTarget = array_get_object(oManifester, PRC_CHAIN_POWER_ARRAY, i);
                            // Apply VFX and damage to chained target. No criticals or precision-based damage here
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oChainTarget);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                                                  EffectDamage(GetTargetSpecificChangesToDamage(oChainTarget, oManifester, nDamage, TRUE, TRUE),
                                                               DAMAGE_TYPE_ACID
                                                               ),
                                                  oChainTarget
                                                  );
                        }// end for - Chain targets
                    }// end if - Chain Power
                }// end if - SR check
            }// end if - Touch attack hit main target

            // Perform the Touch Attack on the split ray target
            nTouchAttack = PRCDoRangedTouchAttack(oSecondaryTarget);
            if(nTouchAttack > 0)
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oSecondaryTarget, nPen))
                {
                    // Calculate damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, TRUE);

                    // Apply VFX and damage to main target
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSecondaryTarget);
                    ApplyTouchAttackDamage(oManifester, oMainTarget, nTouchAttack,
                                           GetTargetSpecificChangesToDamage(oSecondaryTarget, oManifester, nDamage, TRUE, TRUE),
                                           DAMAGE_TYPE_ACID, TRUE
                                           );
                }// end if - SR check
            }// end if - Touch attack hit split ray target
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
