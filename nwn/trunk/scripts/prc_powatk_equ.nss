//::///////////////////////////////////////////////
//:: Power Attack OnEquip script
//:: prc_powatk_equ
//::///////////////////////////////////////////////
/*
    To prevent abuse of turning power attack on while
    wielding a melee weapon and then switching in
    a ranged weapon, this eventhooked script
    checks for what they equip while powerattacking.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC   = GetItemLastEquippedBy();
    object oItem = GetItemLastEquipped();

    if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem &&
       GetWeaponRanged(oItem)
       )
        ExecuteScript("prc_powatk_off", oPC);
}