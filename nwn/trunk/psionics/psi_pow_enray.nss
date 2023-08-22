/*
   ----------------
   Energy Ray

   psi_pow_enray
   ----------------

   30/10/04 by Stratovarius
*/ /** @file
    Energy Ray

    Psychokinesis [see text]
    Level: Psion/wilder 1
    Manifesting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Effect: Ray
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: Yes
    Power Points: 1
    Metapsionics: Chain, Empower, Maximize, Split Psionic Ray, Twin

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You create a ray of energy of the chosen type that shoots forth from your
    fingertip and strikes a target within range, dealing 1d6 points of damage,
    if you succeed on a ranged touch attack with the ray.

    Cold: A ray of this energy type deals +1 point of damage per die.
    Electricity: Manifesting a ray of this energy type provides a +2 bonus on
                 manifester level checks for the purpose of overcoming power
                 resistance.
    Fire: A ray of this energy type deals +1 point of damage per die.
    Sonic: A ray of this energy type deals -1 point of damage per die and
           ignores an object’s hardness.

    This power’s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power’s damage increases by one die (d6).
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_sp_tch"
#include "psi_inc_enrgypow"

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
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_CHAIN | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_SPLIT | METAPSIONIC_TWIN
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, POWER_ENERGYRAY_COLD, POWER_ENERGYRAY_ELEC, POWER_ENERGYRAY_FIRE, POWER_ENERGYRAY_SONIC,
                           VFX_BEAM_COLD, VFX_BEAM_LIGHTNING, VFX_BEAM_FIRE, VFX_BEAM_MIND);

        int nPen             = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice    = 1 + manif.nTimesAugOptUsed_1;
        int nDieSize         = 6;
        int nTouchAttack,
            nOriginalDamage,
            nDamage,
            i;
        effect eVis          = EffectVisualEffect(enAdj.nVFX1);
        effect eRay,
               eDamage;
        object oSplitTarget  = GetSplitPsionicRayTarget(manif, oMainTarget);
        object oChainTarget;

        // Determine Chain Power targets
        if(manif.bChain)
            EvaluateChainPower(manif, oMainTarget, TRUE);

        // Let the AI know
        PRCSignalSpellEvent(oMainTarget, TRUE, manif.nSpellID, oManifester);
        if(GetIsObjectValid(oSplitTarget))
            PRCSignalSpellEvent(oSplitTarget, TRUE, manif.nSpellID, oManifester);
        if(manif.bChain)
            for(i = 0; i < array_get_size(oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                PRCSignalSpellEvent(array_get_object(oManifester, PRC_CHAIN_POWER_ARRAY, i), TRUE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Touch attack the main target
            nTouchAttack = PRCDoRangedTouchAttack(oMainTarget);

            // Shoot the ray
            eRay = EffectBeam(enAdj.nVFX2, oManifester, BODY_NODE_HAND, !(nTouchAttack > 0));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oMainTarget, 1.7, FALSE);

            if(nTouchAttack > 0 && oManifester != oMainTarget) // Don't shoot yourself, idiots
            {
                //Check for Power Resistance
                if(PRCMyResistPower(oManifester, oMainTarget, nPen))
                {
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, TRUE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oMainTarget, oManifester, nDamage, TRUE, TRUE);

                    // Apply the damage. Critical hits & precision damage apply
                    ApplyTouchAttackDamage(oManifester, oMainTarget, nTouchAttack, nDamage, enAdj.nDamageType);

                    // Apply damage to Chain targets
                    if(manif.bChain)
                    {
                        // Halve the damage
                        nOriginalDamage = nDamage / 2;

                        for(i = 0; i < array_get_size(oManifester, PRC_CHAIN_POWER_ARRAY); i++)
                        {
                            // Get target to affect
                            oChainTarget = array_get_object(oManifester, PRC_CHAIN_POWER_ARRAY, i);
                            // Determine damage
                            nDamage = nOriginalDamage;
                            // Target-specific stuff
                            nDamage = GetTargetSpecificChangesToDamage(oChainTarget, oManifester, nDamage, TRUE, TRUE);

                            // Apply VFX and damage to chained target
                            eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oChainTarget);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oChainTarget);
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(enAdj.nVFX2, oMainTarget, BODY_NODE_CHEST), oChainTarget, 1.7, FALSE);
                        }// end for - Chain targets
                    }// end if - Chain Power
                }// end if - SR check
            }// end if - Touch attack hit

            if(GetIsObjectValid(oSplitTarget))
            {
                // Touch attack the main target
                nTouchAttack = PRCDoRangedTouchAttack(oSplitTarget);

                // Shoot the ray
                eRay = EffectBeam(enAdj.nVFX2, oManifester, BODY_NODE_HAND, !(nTouchAttack > 0));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oSplitTarget, 1.7, FALSE);

                if(nTouchAttack > 0)
                {
                    //Check for Power Resistance
                    if(PRCMyResistPower(oManifester, oSplitTarget, nPen))
                    {
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, TRUE);
                        // Target-specific stuff
                        nDamage = GetTargetSpecificChangesToDamage(oSplitTarget, oManifester, nDamage, TRUE, TRUE);

                        // Apply the damage. Critical hits & precision damage apply
                        ApplyTouchAttackDamage(oManifester, oSplitTarget, nTouchAttack, nDamage, enAdj.nDamageType);
                    }// end if - SR check
                }// end if - Touch attack hit
            }// end if - There is a target for Split Psionic Ray
        }// end for - Twin Power
    }// end if - Successfull manifestation
}
