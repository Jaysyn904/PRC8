//:: Created by xwarren

// Converts integer value into ASF ip constant. The proportion is
// 1:5, meaning 1 = 5% ASF reduction, 2 = 10% etc.
int GetIPASF(int asf);

// Converts ip ASF constant into integer value
int GetASF(int IP_ASF);

// Removes all previously applied asf properties from the PCs skin
void RemoveASFBonus(object oSkin);

#include "prc_class_const"
#include "inc_item_props"

const string PRC_ASF_FLAG = "PRC_ArcaneSpellFailure";

int GetIPASF(int asf)
{
    switch(asf)
    {
        case 1:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;
        case 2:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;
        case 3:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT;
        case 4:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
        case 5:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;
        case 6:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT;
        case 7:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT;
        case 8:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT;
        case 9:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT;
        case 10: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
    }

   return -1;
}

int GetASF(int IP_ASF)
{
    switch(IP_ASF)
    {
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT: return -10;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT: return -9;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT: return -8;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT: return -7;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT: return -6;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT: return -5;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT: return -4;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT: return -3;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT: return -2;
        case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT:  return -1;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_5_PERCENT:   return 1;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_10_PERCENT:  return 2;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_15_PERCENT:  return 3;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_20_PERCENT:  return 4;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_25_PERCENT:  return 5;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_30_PERCENT:  return 6;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_35_PERCENT:  return 7;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_40_PERCENT:  return 8;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_45_PERCENT:  return 9;
        case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_50_PERCENT:  return 10;
    }

    return -1;
}

int checkASF(object oItem)
{
    int total;
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE)
        {
           total += GetASF(GetItemPropertyCostTableValue(ip));
        }
        ip = GetNextItemProperty(oItem);
    }
    return total;
}

void RemoveASFBonus(object oSkin)
{
    itemproperty ip = GetFirstItemProperty(oSkin);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE
        && GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {
           RemoveItemProperty(oSkin, ip);
        }
        ip = GetNextItemProperty(oSkin);
    }
}

int ReducedSpellFailure(object oPC, object oArmor)
{
    int nAC = GetBaseAC(oArmor);
    int nASF;

    //spellsword bonus
    int nSSLvl = GetLevelByClass(CLASS_TYPE_SPELLSWORD, oPC);
    if(nSSLvl)
    {
        if     (nSSLvl > 10) nASF = (nSSLvl + 7) / 2;
        else if(nSSLvl > 4) nASF = ((nSSLvl - 1) / 2) * 2;
        else if(nSSLvl > 2) nASF = 3;
        else                nASF = 2;
    }

    //medium or light armor equiped
    if(nAC < 6)
    {
        //Rage mage - arcane spell failure reduced by 10% while wearing light or medium armor.
        if(GetLevelByClass(CLASS_TYPE_RAGE_MAGE, oPC) >= 2) nASF += 2;

        //light armor equiped
        if(nAC < 4)
        {
            if(GetLevelByClass(CLASS_TYPE_BLADESINGER, oPC) > 5
            || (GetLevelByClass(CLASS_TYPE_BARD, oPC) && GetPRCSwitch(PRC_BARD_LIGHT_ARMOR_SPELLCASTING)))
            {
                int nASFArmor = checkASF(oArmor);

                if (nAC == 1) nASFArmor += 1;
                else if (nAC == 2) nASFArmor += 2;
                else if (nAC == 3) nASFArmor += 4;

                if(nASFArmor > 0) nASF += nASFArmor;
            }
        }
    }
    return nASF;
}

void main()
{
    object oPC = OBJECT_SELF;
    object oArmor;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    switch(iEquip)
    {
        case 0: oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC); break;
        case 1: oArmor = GetItemLastUnequipped(); break;
        case 2: oArmor = GetItemLastEquipped();   break;
    }

    if(GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)//no need to run the script if we're called from equip/unequip event but the armor was not changed
        return;

    object oSkin = GetPCSkin(oPC);
    int iBonus = GetLocalInt(oSkin, PRC_ASF_FLAG);
    int nASF = ReducedSpellFailure(oPC, oArmor);// 1 point = 5%

    if(nASF == iBonus)// the bonus is the same - nothing to do
        return;

    // First thing is to remove old ASF
    RemoveASFBonus(oSkin);

    SetLocalInt(oSkin, PRC_ASF_FLAG, nASF);

    //add asf - max 100%
    while(nASF)
    {
        if(nASF > 10)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT), oSkin);
            nASF -= 10;
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyArcaneSpellFailure(GetIPASF(nASF)), oSkin);
            nASF = 0;
        }
    }
}