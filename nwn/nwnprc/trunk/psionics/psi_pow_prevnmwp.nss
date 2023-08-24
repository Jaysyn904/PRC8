/*
   ----------------
   Prevenom Weapon

   psi_pow_prevnmwp
   ----------------

   5/11/05 by Stratovarius
*/ /** @file

    Prevenom Weapon

    Psychometabolism (Creation)
    Level: Psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: One held weapon; see text
    Duration: Until discharged; see text
    Saving Throw: None and Fortitude negates; see text
    Power Points: 1
    Metapsionics: Twin

    As prevenom, except your weapon gains the poison coating as long as it
    remains in your grip:
    This power produces a mild venom that coats a manufactured weapon you are
    wielding. On your next successful melee attack, the venom deals 2 points of
    Constitution damage. A target struck by the poison can make a Fortitude save
    (DC 10 + 1/2 your manifester level + your key ability modifier) to negate
    the damage.

    Augment: For every 6 additional power points you spend, this power’s
             Constitution damage increases by 2 points.
*/


const int ERROR_CODE_5_FIX_AGAIN = 1;
#include "prc_alterations"
#include "prc_inc_spells"
#include "psi_inc_onhit"
#include "psi_inc_psifunc"
#include "psi_spellhook"

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
                                  PowerAugmentationProfile(PRC_NO_GENERIC_AUGMENTS,
                                                           6, PRC_UNLIMITED_AUGMENTATION
                                                           ),
                                  METAPSIONIC_TWIN
                                  );

        if(manif.bCanManifest)
        {
            int nDamage = 2 + (2 * manif.nTimesAugOptUsed_1);
            int nDC     = 10
                        + manif.nManifesterLevel / 2
                        + GetAbilityModifier(GetAbilityOfClass(GetManifestingClass(oManifester)), oManifester);
            effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);

            /* Apply the VFX to whatever is wielding the target */
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // Create the values array if it doesn't already exist
            if(!array_exists(oWeapon, "PRC_Power_PrevenomWeapon_Values"))
                array_create(oWeapon, "PRC_Power_PrevenomWeapon_Values");

            // Handle Twin Power
            int nRepeats = manif.bTwin ? 2 : 1;
            for(; nRepeats > 0; nRepeats--)
            {
                // Store the DC and the damage to be dealt on the creature
                array_set_int(oWeapon, "PRC_Power_PrevenomWeapon_Values",
                              array_get_size(oWeapon, "PRC_Power_PrevenomWeapon_Values"),
                              (nDC << 16) | nDamage
                              );
            }

            // Hook to the item's OnHit
            AddEventScript(oWeapon, EVENT_ITEM_ONHIT,               "psi_pow_prevnmwp", TRUE, FALSE);
            // Hook to the item's OnUnEquip
            AddEventScript(oWeapon, EVENT_ITEM_ONPLAYERUNEQUIPITEM, "psi_pow_prevnmwp", TRUE, FALSE);

            /* Add the onhit spell to the weapon */
            IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }// end if - Successfull manifestation
    }// end if - Running manifestation
    else if(GetRunningEvent() == EVENT_ITEM_ONHIT)
    {
        object oManifester = OBJECT_SELF;
        object oWeapon     = GetSpellCastItem();
        object oTarget     = PRCGetSpellTargetObject();
        int nArraySize     = array_get_size(oWeapon, "PRC_Power_PrevenomWeapon_Values") - 1;
        int nValue         = array_get_int(oWeapon, "PRC_Power_PrevenomWeapon_Values", nArraySize);
        int nDamage        = nValue & 0x0000FFFF;
        int nDC            = (nValue >>> 16 ) & 0x0000FFFF;

        // Target-specific damage adjustments
        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, FALSE, FALSE);

        if(DEBUG) DoDebug("psi_pow_prevnmwp: OnHit: Damage = " + IntToString(nDamage) + "; DC = " + IntToString(nDC));

        // First check for poison immunity, if not, make a fort save versus spells.
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) &&
           !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oManifester))
        {
                //Apply the poison effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_S), oTarget);
                ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        }

        // Remove the damage value from the array
        int nNewSize = array_get_size(oWeapon, "PRC_Power_PrevenomWeapon_Values") - 1;
        if(nNewSize > 0)
            array_shrink(oWeapon, "PRC_Power_PrevenomWeapon_Values", nNewSize);
        else
        {
            array_delete(oWeapon, "PRC_Power_PrevenomWeapon_Values");
            RemoveEventScript(oWeapon, EVENT_ITEM_ONHIT,               "psi_pow_prevnmwp", TRUE, FALSE);
            RemoveEventScript(oWeapon, EVENT_ITEM_ONPLAYERUNEQUIPITEM, "psi_pow_prevnmwp", TRUE, FALSE);
        }
    }// end else - Running OnHit
    else if(GetRunningEvent() == EVENT_ITEM_ONPLAYERUNEQUIPITEM)
    {
        object oWeapon = OBJECT_SELF;

        if(DEBUG) DoDebug("psi_pow_prevnmwp: OnPlayerUnEquipItem: Weapon " + DebugObject2Str(oWeapon) + "; Removing values array and eventhooks");

        // Delete values array
        array_delete(oWeapon, "PRC_Power_PrevenomWeapon_Values");

        // Unhook events
        RemoveEventScript(oWeapon, EVENT_ITEM_ONHIT,               "psi_pow_prevnmwp", TRUE, FALSE);
        RemoveEventScript(oWeapon, EVENT_ITEM_ONPLAYERUNEQUIPITEM, "psi_pow_prevnmwp", TRUE, FALSE);
    }// end else - Running OnPlayerUnEquipItem
    else if(DEBUG) Assert(FALSE, "FALSE", "Script run for unknown event: " + IntToString(GetRunningEvent()), "psi_pow_prevnmwp", "main()");
}
