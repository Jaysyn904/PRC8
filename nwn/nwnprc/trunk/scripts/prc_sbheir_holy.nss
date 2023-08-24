//::///////////////////////////////////////////////
//:: Shining Blade of Heironeous - Holy Weapon
//:: prc_sbheir_holy.nss
//:://////////////////////////////////////////////
//:: Applies a temporary 1d6 Electric Bonus and a
//:: 2d6 Bonus vs evil creatures to the
//:: Shining Blade's weapon. Duration based on Cha
//:: and Class level.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 13, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_class_const"
#include "prc_inc_sbheir"

void main()
{
    object oPC = OBJECT_SELF;

    //Calculate bonus duration

    int nCharisma = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    if (nCharisma < 0) nCharisma = 0;
    int nDuration = (GetLevelByClass(CLASS_TYPE_SHINING_BLADE,oPC)) + nCharisma;

    //Get the wielded weapons

    object oOnHandWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oOffHandWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    int bOnHand = (GetBaseItemType(oOnHandWeapon) == BASE_ITEM_LONGSWORD);
    int bOffHand = (GetBaseItemType(oOffHandWeapon) == BASE_ITEM_LONGSWORD);

    //Apply the bonuses
    
    if (bOnHand)
        HolyBlade_ApplyProperties(oOnHandWeapon, nDuration);

    if (bOffHand)
        HolyBlade_ApplyProperties(oOffHandWeapon, nDuration);

    //Schedule the bonuses to expire
    
    SetLocalInt(oPC, PRC_ShiningBlade_Duration, nDuration);
    SetLocalInt(oPC, PRC_ShiningBlade_Level, SHINING_BLADE_LEVEL_HOLY);
    ShiningBlade_ScheduleBonusExpiration(oPC, nDuration, SHINING_BLADE_LEVEL_HOLY);

    //If bonuses not applied, tell why

    if(!bOnHand && !bOffHand)
    {
        FloatingTextStringOnCreature(GetStringByStrRef(60541+0x01000000), oPC, FALSE);
        IncrementRemainingFeatUses(oPC, FEAT_HOLY_BLADE);
    }
}
