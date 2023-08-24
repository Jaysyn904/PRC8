//::///////////////////////////////////////////////
//:: Shining Blade of Heironeous - Shock Weapon
//:: prc_sbheir_shock.nss
//:://////////////////////////////////////////////
//:: Applies a temporary 1d6 Electric Bonus to the
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
        ShockBlade_ApplyProperties(oOnHandWeapon, nDuration);

    if (bOffHand)
        ShockBlade_ApplyProperties(oOffHandWeapon, nDuration);

    //Schedule the bonuses to expire
    
    SetLocalInt(oPC, PRC_ShiningBlade_Duration, nDuration);
    SetLocalInt(oPC, PRC_ShiningBlade_Level, SHINING_BLADE_LEVEL_SHOCK);
    ShiningBlade_ScheduleBonusExpiration(oPC, nDuration, SHINING_BLADE_LEVEL_SHOCK);

    //If bonuses not applied, tell why

    if(!bOnHand && !bOffHand)
    {
        FloatingTextStringOnCreature(GetStringByStrRef(60539+0x01000000), oPC, FALSE);
        IncrementRemainingFeatUses(oPC, FEAT_SHOCK_BLADE);
    }
}
