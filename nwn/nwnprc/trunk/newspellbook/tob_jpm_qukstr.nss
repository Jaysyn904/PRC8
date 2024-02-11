#include "prc_sp_func"

void main()
{
    int nEvent = GetRunningEvent();
    object oInitiator = OBJECT_SELF;
    object oItem;

    // We aren't being called from any event, perform setup
    if(nEvent == FALSE)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);

        // Has to be a melee weapon
        if(GetWeaponRanged(oItem))
        {
            FloatingTextStringOnCreature("You must use a melee weapon for this ability", oInitiator, FALSE);
            return;
        }

        if(GetLocalInt(oInitiator, "JPM_Quickening_Strike_Expended"))
        {
            FloatingTextStringOnCreature("*Quickening Strike Already Expended*", oInitiator, FALSE);
            return;
        }

        // Expend class ability
        SetLocalInt(oInitiator, "JPM_Quickening_Strike_Expended", TRUE);
        FloatingTextStringOnCreature("* Quickening Strike Expended *", oInitiator, FALSE);

        // The OnHit
        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 12.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_qukstr", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook, so deal the damage
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem = GetSpellCastItem();

        //Add autoquicken II feat for 6 seconds
        itemproperty ipAutoQuicken = ItemPropertyBonusFeat(IP_CONST_JPM_AUTO_QUICKEN);
        FloatingTextStringOnCreature("* Quickening Strike Hit *", oInitiator, FALSE);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipAutoQuicken, oItem, 6.0f);

        // Cleaning
        RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_jpm_qukstr", TRUE, FALSE);
    }
}