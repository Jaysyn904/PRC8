/** @file psi_pow_emptrn

    Empathic Transfer

    Psychometabolism
    Level: Egoist 2, psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Touch
    Target: Willing creature touched
    Duration: Instantaneous
    Power Points: 3
    Metapsionics: Empower, Maximize, Twin

    You heal another creature’s wounds, transferring some of its damage to
    yourself. When you manifest this power, you can heal as much as 2d10 points
    of damage. The target regains a number of hit points equal to the dice
    result, and you lose hit points equal to half of that amount. (This loss can
    bring you to 0 or fewer hit points.) Powers and abilities you may have such
    as damage damage reduction and regeneration do not lessen or change this
    damage, since you are taking the target’s pain into yourself in an empathic
    manner. The damage transferred by this power has no type, so even if you
    have immunity to the type of damage the target originally took, the transfer
    occurs normally and deals hit point damage to you.

    Augment: For every additional power point you spend, you can heal an
             additional 2d10 points of damage (to a maximum of 10d10 points per
             manifestation).

    @author Stratovarius
    @date   Created: May 11, 2005
    @date   Modified: Jul 3, 2006
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_sp_func"

void AvoidDR(object oTarget, int nDamage)
{
    int nCurHP         = GetCurrentHitPoints(oTarget);
    int nTargetHP      = nCurHP - nDamage;
    int nDamageToApply = nDamage;
    effect eDamage;

    // Try magical damage
    eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_MAGICAL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

    // Check if the target's HP dropped enough. Skip if the target died on the way
    if(GetCurrentHitPoints(oTarget) > nTargetHP && !GetIsDead(oTarget))
    {
        // Didn't, try again, this time with Divine damage
        nDamageToApply = GetCurrentHitPoints(oTarget) - nTargetHP;

        eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_DIVINE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

        // Check if the target's HP dropped enough. Skip if the target died on the way
        if(GetCurrentHitPoints(oTarget) > nTargetHP && !GetIsDead(oTarget))
        {
            // Didn't, try again, this time with Positive damage
            nDamageToApply = GetCurrentHitPoints(oTarget) - nTargetHP;

            eDamage = EffectDamage(nDamageToApply, DAMAGE_TYPE_POSITIVE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

            // If it still didn't work, just give up. The blighter probably has immunities to everything else, too, anyway
            return;
        }
    }
}

int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    // Target needs to be willing
    if(!GetIsEnemy(oTarget))
    {
        int nNumberOfDice = 2 + (2 * manif.nTimesAugOptUsed_1);
        int nDieSize      = 10;
        int nHeal;
        effect eHeal, eDam;

        // Let the AI know
        PRCSignalSpellEvent(oTarget, FALSE, manif.nSpellID, oManifester);

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            nHeal = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, FALSE, FALSE);
            eHeal = EffectHeal(nHeal);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);

            // Apply damage to manifester
            AvoidDR(oManifester, nHeal/2);
        }
    }

    return TRUE;    //Held charge is used if at least 1 touch from twinned power hits
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
                                                       1, 4
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
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