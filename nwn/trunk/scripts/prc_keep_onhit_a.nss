//::///////////////////////////////////////////////
//:: OnHit Armor maintainer
//:: prc_keep_onhit_a
//::///////////////////////////////////////////////
/** @file
    A script for keeping OnHitCastSpell: Unique
    itemproperty on whatever is the creature's
    current armor or if no armor is present,
    on the hide. The intent is to have this
    script take care of the issues related
    to maintaining the presence of an OnHit
    virtual event for the creature.

    Note that the hooking is intended to be
    permanent, so that from the point this script
    is first called, it will always keep the
    property active on the creature.

    @author Ornedan
    @date   Created - 2005.11.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

void AddProperty(object oItem)
{
    // Paranoia check - there are ways to get the item off a creature without triggering Unequip
    if(!GetLocalInt(oItem, "PRC_OnHitKeeper_Marker"))
    {
        // Determine whether the item already has the OnHitCastSpell itemproperty
        if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL))
        {
            // Get the itemproperty
            itemproperty ipOHCS = GetFirstItemProperty(oItem);
            while(GetIsItemPropertyValid(ipOHCS) && GetItemPropertyType(ipOHCS) != ITEM_PROPERTY_ONHITCASTSPELL)
                ipOHCS = GetNextItemProperty(oItem);

            // Is it permanent? If it's temporary, we don't need to care about it, since it'd die off in the next few hundred years anyway :P
            if(GetItemPropertyDurationType(ipOHCS) == DURATION_TYPE_PERMANENT)
            {
                // Set the old itemproperty marker
                SetLocalInt(oItem, "PRC_OnHitKeeper_ItemAlreadyHadProperty", TRUE);
                // Store the itemproperty's date for restoration later on
                SetLocalInt(oItem, "PRC_OnHitKeeper_OldIP_SubType", GetItemPropertySubType(ipOHCS));
                SetLocalInt(oItem, "PRC_OnHitKeeper_OldIP_CostTableValue", GetItemPropertyCostTableValue(ipOHCS) + 1);
            }
        }

        // Add the itemproperty
        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
                              0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

        // Add a marker to note that the item has been handled
        SetLocalInt(oItem, "PRC_OnHitKeeper_Marker", TRUE);
    }
}

void main()
{
    int nEvent = GetRunningEvent();

    // OnEquip event
    if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        object oItem = GetItemLastEquipped();
        object oEquipper = GetItemLastEquippedBy();
        if(GetItemInSlot(INVENTORY_SLOT_CHEST, oEquipper) == oItem)
            AddProperty(oItem);
    }
    // OnUnEquip event
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        object oItem = GetItemLastUnequipped();
        object oUnEquipper = GetItemLastUnequippedBy();

        // No need to check slot here, just the marker local variable is enough
        if(GetLocalInt(oItem, "PRC_OnHitKeeper_Marker"))
        {
            // Remove the current property
            RemoveSpecificProperty(oItem,
                                   ITEM_PROPERTY_ONHITCASTSPELL,
                                   IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,
                                   0,
                                   1,
                                   "",
                                   -1,
                                   DURATION_TYPE_PERMANENT);
            // Restore the old property if such existed
            if(GetLocalInt(oItem, "PRC_OnHitKeeper_ItemAlreadyHadProperty"))
            {
                itemproperty ip = ItemPropertyOnHitCastSpell(GetLocalInt(oItem, "PRC_OnHitKeeper_OldIP_SubType"),
                                                             GetLocalInt(oItem, "PRC_OnHitKeeper_OldIP_CostTableValue")
                                                             );
                IPSafeAddItemProperty(oItem, ip, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

                // Cleanup
                DeleteLocalInt(oItem, "PRC_OnHitKeeper_ItemAlreadyHadProperty");
                DeleteLocalInt(oItem, "PRC_OnHitKeeper_OldIP_SubType");
                DeleteLocalInt(oItem, "PRC_OnHitKeeper_OldIP_CostTableValue");
            }

            // Cleanup
            DeleteLocalInt(oItem, "PRC_OnHitKeeper_Marker");
        }
    }
    // Hook the evenscripts and do initial itemproperty additions
    else
    {
        object oCreature = OBJECT_SELF;

        // Set the eventhooks
        AddEventScript(oCreature, EVENT_ONPLAYEREQUIPITEM, "prc_keep_onhit_a", TRUE, FALSE);
        AddEventScript(oCreature, EVENT_ONPLAYERUNEQUIPITEM, "prc_keep_onhit_a", TRUE, FALSE);

        // Add the property to the hide and current armor
        object oSkin = GetPCSkin(oCreature);
        AddProperty(oSkin);

        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
        if(GetIsObjectValid(oArmor))
            AddProperty(oArmor);
    }
}
