/*
   ----------------
   Truevenom

   psi_pow_truvnm
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Truevenom

    Psychometabolism
    Level: Psychic warrior 4
    Manifesting Time: 1 swift action
    Range: Personal
    Target: You
    Duration: 1 min./level or until discharged
    Saving Throw: None and Fortitude negates; see text
    Power Points: 7
    Metapsionics: Extend, Empower, Maximize, Twin

    If you have a claw attack (either from an actual natural weapon or from an
    effect such as claws of the beast), you can use this power to produce a
    horrible poison that coats one of your claws. On your next successful melee
    attack with the claw during the power’s duration, the poison deals 1d8
    points of Constitution damage immediately and another 1d8 points of
    Constitution damage 1 minute later. The target of your attack can negate
    each instance of damage with a Fortitude save.
*/

const int ERROR_CODE_5_FIX_AGAIN = 1;
#include "prc_alterations"
#include "prc_inc_spells"
#include "psi_inc_onhit"
#include "psi_inc_psifunc"
#include "psi_spellhook"

// Used for the DelayCommanded second iteration of poison
void DoPoison(object oTarget, object oManifester, int nDC, int nDam);


void main()
{
    // Are we running the manifestation part or the onhit part?
    if(GetRunningEvent() != EVENT_ONHIT)
    {
        if (!PsiPrePowerCastCode()){ return; }

        object oManifester = OBJECT_SELF;
        object oTarget     = PRCGetSpellTargetObject();
        struct manifestation manif =
            EvaluateManifestation(oManifester, oTarget,
                                  PowerAugmentationProfile(),
                                  METAPSIONIC_EXTEND | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                                  );

        if(manif.bCanManifest)
        {
            int nNumberOfDice = 1;
            int nDieSize      = 8;
            int nDamage;
            int nDC           = GetManifesterDC(oManifester);
            effect eVis       = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
            object oLClaw     = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
            object oRClaw     = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
            object oBite      = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
            float fDuration   = 60.0f * manif.nManifesterLevel;
            if(manif.bExtend) fDuration *= 2;

            // Must have a natural attack
            if(!(GetIsObjectValid(oLClaw) || GetIsObjectValid(oRClaw) || GetIsObjectValid(oBite)))
            {
                // "Target does not posses a natural attack!"
                FloatingTextStrRefOnCreature(16826656, oManifester, FALSE);
                return;
            }

            /* Apply the VFX to the target */
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // Create the values array if it doesn't already exist
            if(!array_exists(oTarget, "PRC_Power_Truevenom_Values"))
                array_create(oTarget, "PRC_Power_Truevenom_Values");

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, FALSE, FALSE);
                // Store the DC and the damage to be dealt on the creature
                array_set_int(oTarget, "PRC_Power_Truevenom_Values",
                              array_get_size(oTarget, "PRC_Power_Truevenom_Values"),
                              (nDC << 16) | nDamage
                              );
            }

            // Hook to the creature's OnHit
            AddEventScript(oTarget, EVENT_ONHIT, "psi_pow_truvnm", TRUE, FALSE);

            /* Add the onhit spell to the weapon */
            IPSafeAddItemProperty(oLClaw, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oRClaw, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }// end if - Successfull manifestation
    }// end if - Running manifestation
    else
    {
        object oManifester = OBJECT_SELF;
        object oItem       = GetSpellCastItem();
        object oTarget     = PRCGetSpellTargetObject();

        // Make sure the event was triggered by a natural weapon
        if(oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oManifester) ||
           oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oManifester) ||
           oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oManifester)
           )
        {
            int nArraySize = array_get_size(oManifester, "PRC_Power_Truevenom_Values");
            int nValue     = array_get_int(oManifester, "PRC_Power_Truevenom_Values", nArraySize - 1);
            int nDamage    = nValue & 0x0000FFFF;
            int nDC        = (nValue >>> 16 ) & 0x0000FFFF;

            // Target-specific damage adjustments
            nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, FALSE, FALSE);

            if(DEBUG) DoDebug("psi_pow_truvnm: OnHit: Damage = " + IntToString(nDamage) + "; DC = " + IntToString(nDC));

            // Apply poison, then apply again 1 minute later
            DoPoison(oTarget, oManifester, nDC, nDamage);
            DelayCommand(60.0f, DoPoison(oTarget, oManifester, nDC, nDamage));

            // Remove the damage value from the array
            nArraySize -= 1;
            if(nArraySize > 0)
                array_shrink(oManifester, "PRC_Power_Truevenom_Values", nArraySize);
            else
            {
                array_delete(oManifester, "PRC_Power_Truevenom_Values");
                RemoveEventScript(oManifester, EVENT_ONHIT, "psi_pow_truvnm", TRUE, FALSE);
            }
        }// end if - Triggered by a natural weapon
    }// end else - Running OnHit
}

void DoPoison(object oTarget, object oManifester, int nDC, int nDam)
{
    // First check for poison immunity, if not, make a fort save versus spells.
    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON)                                              &&
       !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oManifester)
       )
    {
        //Apply the poison effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_S), oTarget);
        ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
    }
}
