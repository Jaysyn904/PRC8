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


#include "prc_inc_spells"
#include "prc_alterations"

void RemoveImprovedRicochet(object oPC, object oWeap)
{
    if (DEBUG) FloatingTextStringOnCreature("Remove ImprovedRicochet is run", oPC);

    RemoveSpecificProperty(oWeap,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
    DeleteLocalInt(oWeap, "ImprovedRicochet");
}

void ImprovedRicochet(object oPC, object oWeap)
{
    if(GetLocalInt(oWeap, "ImprovedRicochet") == TRUE) return;

    if (DEBUG) FloatingTextStringOnCreature("Add ImprovedRicochet is run", oPC);

    RemoveImprovedRicochet(oPC, oWeap);
    DelayCommand(0.1, IPSafeAddItemProperty(oWeap, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE));
    SetLocalInt(oWeap, "ImprovedRicochet", TRUE);
}


void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
    object oUnequip = GetItemLastUnequipped();
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    if(GetLevelByClass(CLASS_TYPE_HALFLING_WARSLINGER, oPC) == 6)
    {
       	if (iEquip == 1)    RemoveImprovedRicochet(oPC, oUnequip);
        if (iEquip == 2)    ImprovedRicochet(oPC, oWeap);
    }
}
