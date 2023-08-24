//::///////////////////////////////////////////////
//:: Share Pain (,Forced) auxiliary script
//:: psi_pow_shrpnaux
//::///////////////////////////////////////////////
/** @file
    The eventhook script for Share Pain and Share
    Pain, Forced. Applies the damage transfer when
    the user is damaged.

    @author Ornedan
    @date   Created - 2005.11.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "prc_inc_spells"

void AvoidDR(object oTarget, int nDamage);

void main()
{
    object oManifester = OBJECT_SELF;
    object oItem       = GetSpellCastItem();

    // Make sure the one doing the triggering hit was someone else
    if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR ||
       GetBaseItemType(oItem) == BASE_ITEM_CREATUREITEM
       )
    {
        object oTarget    = GetLocalObject(oManifester, "PRC_Power_SharePain_Target");
        int nDamage       = GetTotalDamageDealt() / 2;
        effect eHealLink  = EffectLinkEffects(EffectHeal(nDamage),
                                              EffectVisualEffect(VFX_IMP_HEALING_L)
                                              );
        effect eDamageVis = EffectVisualEffect(VFX_IMP_HARM);

        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealLink, oManifester);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageVis, oTarget);
        AvoidDR(oTarget, nDamage);

        // If the target died, remove the event hook immediately. The monitor will take care of the rest
        if(GetIsDead(oTarget))
            RemoveEventScript(oManifester, EVENT_ONHIT, "psi_pow_shrpnaux", TRUE, FALSE);
    }// end if - Manifester was the one hit in the triggering attack
}

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