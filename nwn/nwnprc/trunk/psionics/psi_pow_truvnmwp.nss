/*
   ----------------
   Truevenom Weapon

   psi_pow_truvnmwp
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Truevenom Weapon

    Psychometabolism (Creation)
    Level: Psychic warrior 4
    Manifesting Time: 1 swift action
    Range: Personal
    Target: One held weapon; see text
    Duration: 1 min./level or until discharged
    Saving Throw: None and Fortitude negates; see text
    Power Points: 7
    Metapsionics: Extend, Empower, Maximize, Twin

    As truevenom, except your weapon gains the poison coating as long as it
    remains in your grip, until the effect is discharged, or until the duration
    expires, whichever occurs first.
    You can use this power to produce a horrible poison that coats a
    manufactured weapon you are wielding. On your next successful melee attack
    with the weapon during the power’s duration, the poison deals 1d8 points of
    Constitution damage immediately and another 1d8 points of Constitution
    damage 1 minute later. The target of your attack can negate each instance of
    damage with a Fortitude save.
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
    // Are we running the manifestation part or one of the events?
    if(GetRunningEvent() != EVENT_ITEM_ONHIT               &&
       GetRunningEvent() != EVENT_ITEM_ONPLAYERUNEQUIPITEM
       )
    {
        if(!PsiPrePowerCastCode()){ return; }
        object oManifester = OBJECT_SELF;
        object oTarget     = PRCGetSpellTargetObject();
        object oWeapon     = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

        // Validity check
        if(!GetIsObjectValid(oWeapon))
        {
            // "Target is not wielding a weapon!"
            FloatingTextStrRefOnCreature(16826669, oManifester, FALSE);
            return;
        }

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
            float fDuration   = 60.0f * manif.nManifesterLevel;
            if(manif.bExtend) fDuration *= 2;

            /* Apply the VFX to whatever is wielding the target */
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // Create the values array if it doesn't already exist
            if(!array_exists(oWeapon, "PRC_Power_TruevenomWeapon_Values"))
                array_create(oWeapon, "PRC_Power_TruevenomWeapon_Values");

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, 0, FALSE, FALSE);
                // Store the DC and the damage to be dealt on the creature
                array_set_int(oWeapon, "PRC_Power_TruevenomWeapon_Values",
                              array_get_size(oWeapon, "PRC_Power_TruevenomWeapon_Values"),
                              (nDC << 16) | nDamage
                              );
            }

            // Hook to the item's OnHit
            AddEventScript(oWeapon, EVENT_ITEM_ONHIT,               "psi_pow_truvnmwp", TRUE, FALSE);
            // Hook to the item's OnUnEquip
            AddEventScript(oWeapon, EVENT_ITEM_ONPLAYERUNEQUIPITEM, "psi_pow_truvnmwp", TRUE, FALSE);

            /* Add the onhit spell to the weapon */
            IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }// end if - Successfull manifestation
    }// end if - Running manifestation
    else if(GetRunningEvent() == EVENT_ITEM_ONHIT)
    {
        object oManifester = OBJECT_SELF;
        object oWeapon     = GetSpellCastItem();
        object oTarget     = PRCGetSpellTargetObject();
        int nArraySize     = array_get_size(oWeapon, "PRC_Power_TruevenomWeapon_Values") - 1;
        int nValue         = array_get_int(oWeapon, "PRC_Power_TruevenomWeapon_Values", nArraySize);
        int nDamage        = nValue & 0x0000FFFF;
        int nDC            = (nValue >>> 16 ) & 0x0000FFFF;

        // Target-specific damage adjustments
        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, FALSE, FALSE);

        if(DEBUG) DoDebug("psi_pow_truvnmwp: OnHit: Damage = " + IntToString(nDamage) + "; DC = " + IntToString(nDC));

        // Apply poison, then apply again 1 minute later
        DoPoison(oTarget, oManifester, nDC, nDamage);
        DelayCommand(60.0f, DoPoison(oTarget, oManifester, nDC, nDamage));

        // Remove the damage value from the array
        int nNewSize = array_get_size(oWeapon, "PRC_Power_TruevenomWeapon_Values") - 1;
        if(nNewSize > 0)
            array_shrink(oWeapon, "PRC_Power_TruevenomWeapon_Values", nNewSize);
        else
        {
            array_delete(oWeapon, "PRC_Power_TruevenomWeapon_Values");
            RemoveEventScript(oWeapon, EVENT_ITEM_ONHIT,               "psi_pow_truvnmwp", TRUE, FALSE);
            RemoveEventScript(oWeapon, EVENT_ITEM_ONPLAYERUNEQUIPITEM, "psi_pow_truvnmwp", TRUE, FALSE);
        }
    }// end else - Running OnHit
    else if(GetRunningEvent() == EVENT_ITEM_ONPLAYERUNEQUIPITEM)
    {
        object oWeapon = OBJECT_SELF;

        if(DEBUG) DoDebug("psi_pow_truvnmwp: OnPlayerUnEquipItem: Weapon " + DebugObject2Str(oWeapon) + "; Removing values array and eventhooks");

        // Delete values array
        array_delete(oWeapon, "PRC_Power_TruevenomWeapon_Values");

        // Unhook events
        RemoveEventScript(oWeapon, EVENT_ITEM_ONHIT,               "psi_pow_truvnmwp", TRUE, FALSE);
        RemoveEventScript(oWeapon, EVENT_ITEM_ONPLAYERUNEQUIPITEM, "psi_pow_truvnmwp", TRUE, FALSE);
    }// end else - Running OnPlayerUnEquipItem
    else if(DEBUG) Assert(FALSE, "FALSE", "Script run for unknown event: " + IntToString(GetRunningEvent()), "psi_pow_truvnmwp", "main()");
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
