//::///////////////////////////////////////////////
//:: Order of the Bow Initiate
//:: prc_ootbi.nss
//:://////////////////////////////////////////////
//:: Applies Order of the Bow Initiate Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 20, 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void RemoveGreaterWeaponFocus(object oPC, object oWeap)
{
    if(DEBUG) DoDebug("prc_ootbi.nss: Remove GreaterWeaponFocus is run");

    PRCRemoveEffectsFromSpell(oPC, SPELL_OOTBI_GREATER_WEAPON_FOCUS);
    DeleteLocalInt(oWeap, "GreaterWeaponFocus");
}

void GreaterWeaponFocus(object oPC, object oWeap)
{
    if(GetLocalInt(oWeap, "GreaterWeaponFocus"))
        return;

    if(DEBUG) DoDebug("prc_ootbi.nss: Add GreaterWeaponFocus is run");

    RemoveGreaterWeaponFocus(oPC, oWeap);
    // Greater Weapon Focus ability
    DelayCommand(0.1, ActionCastSpellOnSelf(SPELL_OOTBI_GREATER_WEAPON_FOCUS));
    SetLocalInt(oWeap, "GreaterWeaponFocus", TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLevelByClass(CLASS_TYPE_ORDER_BOW_INITIATE, oPC) >= 4)
    {
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oUnequip = GetItemLastUnequipped();
        int iEquip = GetLocalInt(oPC, "ONEQUIP");

        if(iEquip == 1)
            RemoveGreaterWeaponFocus(oPC, oUnequip);
        if(iEquip == 2)
        {
            int iType = GetBaseItemType(oWeap);
            if(iType == BASE_ITEM_LONGBOW || iType == BASE_ITEM_SHORTBOW)
            {
                GreaterWeaponFocus(oPC, oWeap);
            }
        }
    }
}