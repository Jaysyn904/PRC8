/** @file psi_pow_dsslvtch

    Dissolving Touch

    Psychometabolism [Acid]
    Level: Psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Creature or object touched
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Points: 3
    Metapsionics: Chain, Empower, Maximize, Twin

    Your touch, claw, or bite is corrosive, and sizzling moisture visibly oozes
    from your natural weapon or hand. You deal 4d6 points of acid damage to any
    creature or object you touch with your successful melee touch attack.

    Augment: For every 2 additional power points you spend, this power’s damage
             increases by 1d6 points.

    @author Stratovarius
    @date   Created: Oct 27, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"
#include "prc_inc_sp_tch"

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nNumberOfDice = 4 + manif.nTimesAugOptUsed_1;
    int nDieSize      = 6;
    int nTouchAttack, i, nDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    object oChainTarget;

    // Determine Chain Power targets
    if(manif.bChain)
        EvaluateChainPower(manif, oTarget, TRUE);

    // Let the AI know
    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);
    if(manif.bChain)
        for(i = 0; i < array_get_size(oManifester, PRC_CHAIN_POWER_ARRAY); i++)
            PRCSignalSpellEvent(array_get_object(oManifester, PRC_CHAIN_POWER_ARRAY, i), TRUE, manif.nSpellID, oManifester);

    int bHit = 0;

    PRCSignalSpellEvent(oTarget, TRUE, manif.nSpellID, oManifester);

    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nTouchAttack = PRCDoMeleeTouchAttack(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            // Calculate damage
            nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, TRUE, FALSE);

            // Apply VFX and damage to main target
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyTouchAttackDamage(oManifester, oTarget, nTouchAttack,
                                   GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE),
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
        }
    }

    return bHit;    //Held charge is used if at least 1 touch from twinned power hits
}

void main()
{
    if(!PsiPrePowerCastCode()) return;
    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif;
    int nEvent = GetLocalInt(oManifester, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                       2, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_CHAIN | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );

        if(manif.bCanManifest)
        {
            if(GetLocalInt(oManifester, PRC_SPELL_HOLD) && oManifester == oTarget)
            {   //holding the charge, manifesting power on self
                SetLocalSpellVariables(oManifester, 1);   //change 1 to number of charges
                SetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION, manif);
                return;
            }
            DoPower(oManifester, oTarget, manif);
        }
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            manif = GetLocalManifestation(oManifester, PRC_POWER_HOLD_MANIFESTATION);
            if(DoPower(oManifester, oTarget, manif))
                DecrementSpellCharges(oManifester);
        }
    }
}