//::///////////////////////////////////////////////
//:: Name      Arrowsplit
//:: FileName  sp_arrowsplit.nss
//:://////////////////////////////////////////////
/**@file Arrowsplit
Conjuration (Creation)
Level: Assassin 3, ranger 3
Components: V, M
Casting Time: 1 swift action
Range: Long
Target: One creature
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You fire a masterwork or magical arrow at a target, and
it split in mid-flight into 1d4+1 identical arrows or bolts. 
All the missiles strike the same target, and you must make
a separate attack roll for each missile.  

Material Component: Masterwork/magical arrow or bolt.

Author:    Tenjac
Created:   8/22/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "prc_craft_inc"
#include "prc_inc_combat"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    object oAmmo;
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nType = GetBaseItemType(oWeapon);

    if(nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_SHORTBOW)
    {
        oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
    }
    else if (nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_HEAVYCROSSBOW)
    {
        oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
    }
    else
    {
        PRCSetSchool();
        return;
    }

    //Check for Masterwork or magical
    string sMaterial = GetStringLeft(GetTag(oAmmo), 3);

    if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oAmmo)))
    {
        PRCSetSchool();
        return;
    }

    int nSplit = d4(1) + 1;
    int nStack = GetItemStackSize(oAmmo);
    int nCount = nSplit;
    effect eNone;

    //Stack too big to increase prior to firing
    if(nStack + nSplit > 99)
    {
        //Delay the addition of arrows until after firing
        DelayCommand(1.0, SetItemStackSize(oAmmo, nStack - 1));
    }
    //Small enough... go ahead and do it to make sure we have ammo
    else SetItemStackSize(oAmmo, nStack + nSplit - 1);

    while(nCount > 0)
    {
        PerformAttack(oTarget, oPC, eNone);
        nCount--;
    }

    PRCSetSchool();
}