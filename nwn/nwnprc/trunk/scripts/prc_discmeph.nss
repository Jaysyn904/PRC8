//::///////////////////////////////////////////////
//:: [Disciple of Mephistopheles Feats]
//:: [prc_elemsavant.nss]
//:://////////////////////////////////////////////
//:: Check to see which Disciple of Mephistopheles feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Attilla.  Modified by Aaon Graywolf
//:: Created On: Jan 8, 2004
//:: Modified by Lockindal Linantal: glove property.
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"

// * Applies the Disciple of Mephistopheles's resistances on the object's skin.
// * iLevel = IP_CONST_DAMAGERESIST_*
void DiscMephResist(object oPC, object oSkin, int iResist)
{
    if(GetLocalInt(oSkin, "DiscMephResist") == iResist) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_RESISTANCE,IP_CONST_DAMAGETYPE_FIRE, iResist, 1, "DiscMephResist");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, iResist), oSkin);
    SetLocalInt(oSkin, "DiscMephResist", iResist);
}

void HellFireGrasp(object oPC, object oGaunt)
{
    if(GetLocalInt(oGaunt, "DiscMephGlove") == 6) return;

    RemoveSpecificProperty(oGaunt, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, -1, "DiscMephGlove", -1, DURATION_TYPE_TEMPORARY);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), oGaunt, 9999.0);
    SetLocalInt(oGaunt, "DiscMephGlove", 6);
}

void RemoveHellFire(object oPC, object oGaunt)
{
    if(GetLocalInt(oGaunt, "DiscMephGlove") == 6)
        RemoveSpecificProperty(oGaunt, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, "DiscMephGlove", -1, DURATION_TYPE_TEMPORARY);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oGaunt = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    object oUnequip = GetItemLastUnequipped();
    int iResist = -1;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    if(GetHasFeat(FEAT_FIRE_RESISTANCE_10, oPC))
    {
        iResist = IP_CONST_DAMAGERESIST_10;
    }

    else if(GetHasFeat(FEAT_FIRE_RESISTANCE_20, oPC))
    {
        iResist = IP_CONST_DAMAGERESIST_20;
    }

   if(GetHasFeat(FEAT_HELLFIRE_GRASP, oPC))
    {
    if (GetLocalInt(oUnequip, "DiscMephGlove") == 6)
    {
            if (iEquip == 1)    RemoveHellFire(oPC, oUnequip);
    }
        if (iEquip == 2)    HellFireGrasp(oPC, oGaunt);
    }

    //Apply bonuses accordingly
    if(iResist > -1) DiscMephResist(oPC, oSkin, iResist);
}