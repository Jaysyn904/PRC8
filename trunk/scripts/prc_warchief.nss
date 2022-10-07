//::///////////////////////////////////////////////
//:: Warchief
//:: prc_warchief.nss
//:://////////////////////////////////////////////
//:: Applies the Warchief Charisma boost
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_x2_itemprop"

void main()
{
    object oPC = OBJECT_SELF;
    int nWarChief = GetLevelByClass(CLASS_TYPE_WARCHIEF, oPC);

    //Ability Boost
    /*if(nWarChief > 1)
    {
        string sFlag = "WarchiefCha";
        // +2 at 2nd, 6th, 10th, etc.
        int nBonus = ((nWarChief + 2) / 4) * 2;
        int nDiff = nBonus - GetPersistantLocalInt(oPC, "NWNX_"+sFlag);

        if(nDiff != 0)//only part of the bouns was applied permanently or not applied at all
            SetCompositeBonus(GetPCSkin(oPC), sFlag, nDiff, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
    }*/

    //Devoted Bodyguards
    if(nWarChief > 7)
    {
        object oItem;
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        int iEquip = GetLocalInt(oPC, "ONEQUIP");

        if(iEquip == 2// On Equip
        && GetItemLastEquipped() == oArmor)
        {
            // add bonus to armor
            IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        else if(iEquip == 1// Unequip
        && GetBaseItemType(GetItemLastUnequipped()) == BASE_ITEM_ARMOR)
            RemoveSpecificProperty(oArmor, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
        else                  // On level, rest, or other events
            IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }

}
