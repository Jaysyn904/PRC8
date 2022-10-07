//::///////////////////////////////////////////////
//:: Black Flame Zealot
//:: prc_bfz.nss
//:://////////////////////////////////////////////
//:: Check to see which Black Flame Zealot feats a PC
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 6, 2004
//:://////////////////////////////////////////////
#include "inc_item_props"
#include "prc_x2_itemprop"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    // Zealous Heart
    if(!GetLocalInt(oSkin, "BFZHeart"))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), oSkin);
        SetLocalInt(oSkin, "BFZHeart", TRUE);
    }

    // Sacred Flame
    if(GetHasFeat(FEAT_SACRED_FLAME, oPC))
    {
        object oItem;
        int iEquip = GetLocalInt(oPC, "ONEQUIP");
        //OnEquip - add bonus damage
        if(iEquip == 2)
        {
            oItem = GetItemLastEquipped();
            if(IPGetIsMeleeWeapon(oItem))
            {
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), oItem, 999999.0);
                return;
            }
        }
        //OnUnequip - remove bonus damage
        else if(iEquip == 1)
        {
            oItem = GetItemLastUnequipped();
            if(IPGetIsMeleeWeapon(oItem))
            {
                RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, "", -1, DURATION_TYPE_TEMPORARY);
                return;
            }
        }
        //everything else - update damage if DEX changed
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if(IPGetIsMeleeWeapon(oItem))
        {
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, "", -1, DURATION_TYPE_TEMPORARY);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), oItem, 999999.0);
        }
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if(IPGetIsMeleeWeapon(oItem))
        {
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, "", -1, DURATION_TYPE_TEMPORARY);
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), oItem, 999999.0);
        }
    }
}