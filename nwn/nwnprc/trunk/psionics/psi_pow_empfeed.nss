/*
   ----------------
   Empathic Feedback

   psi_pow_empfeed
   ----------------

   19/2/04 by Stratovarius
*/ /** @file

    Empathic Feedback

    Telepathy [Mind-Affecting]
    Level: Psion/wilder 4, psychic warrior 3
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level
    Power Points: Psion/wilder 7, psychic warrior 5
    Metapsionics: Extend

    You empathically share your pain and suffering with your attacker. Each time
    a creature strikes you in melee, it takes damage equal to the amount it
    dealt to you or 5 points, whichever is less. This damage is empathic in
    nature, so powers and abilities the attacker may have such as damage
    reduction and regeneration do not lessen or change this damage. The damage
    from empathic feedback has no type, so even if you took fire damage from a
    creature that has immunity to fire, empathic feedback will damage your
    attacker.

    Augment: For every additional power point you spend, this power’s damage
             potential increases by 1 point.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_inc_spells"

const string EMPATHIC_FEEDBACK_VARNAME = "PRC_Power_EmpathicFeedback_Damage";


void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

void main()
{
    // Are we running the manifestation part or the onhit part?
    if(GetRunningEvent() != EVENT_ONHIT)
    {
        // Power use hook
        if(!PsiPrePowerCastCode()) return;

        object oManifester = OBJECT_SELF;
        object oTarget     = PRCGetSpellTargetObject();
        struct manifestation manif =
            EvaluateManifestation(oManifester, oTarget,
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           1, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                  METAPSIONIC_EXTEND
                                  );

        if(manif.bCanManifest)
        {
            int nDamage     = 5 + manif.nTimesAugOptUsed_1;
            effect eDur     = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
            float fDuration = 60.0f * manif.nManifesterLevel;
            if(manif.bExtend) fDuration *= 2;

            // Get the OnHitCast: Unique on the target's armor / hide
            ExecuteScript("prc_keep_onhit_a", oTarget);

            // Hook eventscript
            AddEventScript(oTarget, EVENT_ONHIT, "psi_pow_empfeed", TRUE, FALSE);

            // Set the local variable for the amount of damage transferrable
            SetLocalInt(oTarget, EMPATHIC_FEEDBACK_VARNAME, nDamage);

            // Do VFX for the monitor to look for
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, TRUE, manif.nSpellID, manif.nManifesterLevel);

            // Start effect end monitor
            DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6));
        }// end if - Successfull manifestation
    }// end if - Manifesting a power
    // Running the OnHit event
    else
    {
        object oManifester = OBJECT_SELF;
        object oItem       = GetSpellCastItem();

        // Make sure the one doing the triggering hit was someone else
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR ||
           GetBaseItemType(oItem) == BASE_ITEM_CREATUREITEM
           )
        {
            object oTarget = PRCGetSpellTargetObject();

            // Mind-affecting immunity check, and must be in melee range
            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) && GetIsInMeleeRange(oManifester, oTarget))
            {
                int nMaxDamage   = GetLocalInt(oManifester, EMPATHIC_FEEDBACK_VARNAME);
                int nDamageTaken = GetTotalDamageDealt();
                int nDamage      = min(nMaxDamage, nDamageTaken);

                // Use positive damage, it's unlikelier to be resisted than magic damage
                effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }// end if - Mind-affecting immunity check
        }// end if - Manifester was the one hit in the triggering attack
    }// end else - Running OnHit event
}

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0) ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oManifester)
       )
    {
        if(DEBUG) DoDebug("psi_pow_empfeed: Removing marker");
        // Clear the effect presence marker
        DeleteLocalInt(oTarget, EMPATHIC_FEEDBACK_VARNAME);
        // Remove the eventscript
        RemoveEventScript(oTarget, EVENT_ONHIT, "psi_pow_empfeed", TRUE, FALSE);
    }
    else
       DelayCommand(6.0f, DispelMonitor(oManifester, oTarget, nSpellID, nBeatsRemaining));
}
