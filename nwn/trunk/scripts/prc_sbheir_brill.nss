//::///////////////////////////////////////////////
//:: Shining Blade of Heironeous - Brilliant Weapon
//:: prc_sbheir_holy.nss
//:://////////////////////////////////////////////
//:: Applies a temporary 1d6 Electric Bonus and a
//:: 2d6 Bonus vs evil creatures to the
//:: Shining Blade's weapon. Duration based on Cha
//:: and Class level. Also adds +20 to Attack.
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

    int nCharisma = GetAbilityModifier(ABILITY_CHARISMA);
    if(nCharisma < 0) nCharisma = 0;
    int nDuration = GetLevelByClass(CLASS_TYPE_SHINING_BLADE) + nCharisma;

    //Get the wielded weapons

    object oOnHandWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    object oOffHandWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    int bOnHand = (GetBaseItemType(oOnHandWeapon) == BASE_ITEM_LONGSWORD);
    int bOffHand = (GetBaseItemType(oOffHandWeapon) == BASE_ITEM_LONGSWORD);
    
    //Apply the bonuses
    
    if (bOnHand)
        BrilliantBlade_ApplyProperties(oOnHandWeapon, nDuration);

    if (bOffHand)
        BrilliantBlade_ApplyProperties(oOffHandWeapon, nDuration);
    
    BrilliantBlade_ApplyAttackBonuses(oPC, bOnHand, bOffHand);
    
    //Schedule the bonuses to expire

    SetLocalInt(oPC, PRC_ShiningBlade_Duration, nDuration);
    SetLocalInt(oPC, PRC_ShiningBlade_Level, SHINING_BLADE_LEVEL_BRILLIANT);
    ShiningBlade_ScheduleBonusExpiration(oPC, nDuration, SHINING_BLADE_LEVEL_BRILLIANT);
    
    //If bonuses not applied, tell why

    if(!bOnHand && !bOffHand)
    {
        FloatingTextStringOnCreature(GetStringByStrRef(60543+0x01000000), oPC, FALSE);
        IncrementRemainingFeatUses(oPC, FEAT_BRILLIANT_BLADE);
    }
}
