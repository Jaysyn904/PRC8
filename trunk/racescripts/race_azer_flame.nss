//::///////////////////////////////////////////////
//:: Azer Heat damage adder
//:: race_azer_flame
//::///////////////////////////////////////////////
/*
    Adds 1 fire damage to all the Azer's weapons.
    Moved to it's own script since adding to
    natural weapons requires waiting for callback
    from unarmed_caller.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "prc_inc_unarmed"

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetLocalInt(oPC, UNARMED_CALLBACK))
    {
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if (!GetIsObjectValid(oItem))
        {
            // Add fire damage to gloves
            oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
            SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);

            // Request callback once the feat & fist evaluation is done, if it is done
            AddEventScript(oPC, CALLBACKHOOK_UNARMED, "race_azer_flame", FALSE, FALSE);
        }
        else
        {
            // Add fire damage to mainhand
            SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);

            // Add fire damage to offhand, if it contains a weapon
            oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            // check to make sure the weapon is not a shield or torch
            if (GetIsObjectValid(oItem) &&
                GetBaseItemType(oItem) != BASE_ITEM_SMALLSHIELD && GetBaseItemType(oItem) != BASE_ITEM_LARGESHIELD &&
                GetBaseItemType(oItem) != BASE_ITEM_TOWERSHIELD && GetBaseItemType(oItem) != BASE_ITEM_TORCH)
                    SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);
        }
    }
    else
    {
        // Add damage to natural weapons in the callback

        object oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
        if(GetIsPRCCreatureWeapon(oItem))
            SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);

        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
        if(GetIsPRCCreatureWeapon(oItem))
            SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);

        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
        if(GetIsPRCCreatureWeapon(oItem))
            SetCompositeDamageBonusT(oItem, "AzerFlameDamage", 1, IP_CONST_DAMAGETYPE_FIRE);
    }
}