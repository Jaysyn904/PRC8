/*
   ----------------
   Crystal Shard

   psi_pow_crysshrd
   ----------------

   21/10/04 by Stratovarius
*/ /** @file

    Crystal Shard

    Metacreativity (Creation)
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Empower, Maximize, Split Psionic Ray, Twin

    Upon manifesting this power, you propel a razor-sharp crystal shard at your target.
    You must succeed on a ranged touch attack with the ray to deal damage to a target.
    The ray deals 1d6 points of piercing damage.

    Augment: For every additional power point you spend, this power’s damage increases
            by 1d6 points.
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
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_SPLIT | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        int nNumberOfDice = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize      = 6;
        int nDamage;
        effect eShard = EffectVisualEffect(VFX_IMP_FROST_S); // NORMAL_DART
        effect eDamage;
        object oSecondaryTarget = GetSplitPsionicRayTarget(manif, oTarget);

        // Let the AI know
        PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
        if(GetIsObjectValid(oSecondaryTarget))
            PRCSignalSpellEvent(oSecondaryTarget, TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Shoot the visual effect
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eShard, oTarget);

            // Do touch attack
            int nTouchAttack = PRCDoRangedTouchAttack(oTarget);
            if(nTouchAttack)
            {
                 // Roll damage
                nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, TRUE);
                // Target-specific stuff
                nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, FALSE);

                ApplyTouchAttackDamage(oManifester, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_PIERCING);
            }

            // Is there a secondary target?
            if(GetIsObjectValid(oSecondaryTarget))
            {
                // Shoot the visual effect
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eShard, oSecondaryTarget);

                // Do touch attack
                int nTouchAttack = PRCDoRangedTouchAttack(oSecondaryTarget);
                if(nTouchAttack)
                {
                     // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, TRUE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oSecondaryTarget, oManifester, nDamage, TRUE, FALSE);

                    ApplyTouchAttackDamage(oManifester, oSecondaryTarget, nTouchAttack, nDamage, DAMAGE_TYPE_PIERCING, TRUE);
                }
            }// end if - Split Psionic Ray target check
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
