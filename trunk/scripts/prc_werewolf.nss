//::///////////////////////////////////////////////
//:: Adds the Werewolf skin properties
//:: prc_werewolf
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 11, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_class_const"
#include "prc_feat_const"

void AddLycanthropeSkinProperties(object oPC, object oSkin)
{
    if (GetLocalInt(oSkin, "WerewolfArmorBonus") == 2) return;

    SetCompositeBonus(oSkin, "WerewolfArmorBonus", 2, ITEM_PROPERTY_AC_BONUS);
    SetCompositeBonus(oSkin, "WerewolfWisBonus", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_WIS);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    AddLycanthropeSkinProperties(oPC, oSkin);
}
