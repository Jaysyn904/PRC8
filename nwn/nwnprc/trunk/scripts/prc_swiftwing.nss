//::///////////////////////////////////////////////
//:: Swift Wing
//:: prc_swiftwing.nss
//::///////////////////////////////////////////////
/*
    Handles the passive bonuses for Swift Wings
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 21, 2007
//:://////////////////////////////////////////////
#include "prc_x2_itemprop"
#include "inc_item_props"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC);

    //Energy Resistance/Immunity
    if(nLevel > 3)
    {
        //Acid
        if(GetHasFeat(FEAT_DRAGON_AFFINITY_BK, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_CP, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_GR, oPC))
        {
            if(nLevel > 8)
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            else
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }

        //Cold
        else if(GetHasFeat(FEAT_DRAGON_AFFINITY_CR, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_SR, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_TP, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_WH, oPC))
        {
            if(nLevel > 8)
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            else
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }

        //Electric
        else if(GetHasFeat(FEAT_DRAGON_AFFINITY_BL, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_BZ, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_SA, oPC))
        {
            if(nLevel > 8)
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            else
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }

        //Fire
        else if(GetHasFeat(FEAT_DRAGON_AFFINITY_BS, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_GD, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_RD, oPC)
        || GetHasFeat(FEAT_DRAGON_AFFINITY_AM, oPC))
        {
            if(nLevel > 8)
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            else
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }

        //Sonic
        else if(GetHasFeat(FEAT_DRAGON_AFFINITY_EM, oPC))
        {
            if(nLevel > 8)
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            else
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        }
    }

    //Damage Reduction 5/+1 at level 7
    if(nLevel > 6)
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);

    //Draconic Surge bonuses
    if(nLevel > 9)
    {
        if(GetHasFeat(FEAT_DRACONIC_SURGE_STR, oPC))
        {
            if(!GetPersistantLocalInt(oPC, "NWNX_DragonicSurgeStr"))
                SetCompositeBonus(oSkin, "DrSge_STR", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_DEX, oPC))
        {
            if(!GetPersistantLocalInt(oPC, "NWNX_DragonicSurgeDex"))
                SetCompositeBonus(oSkin, "DrSge_DEX", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_CON, oPC))
        {
            if(!GetPersistantLocalInt(oPC, "NWNX_DragonicSurgeCon"))
                SetCompositeBonus(oSkin, "DrSge_CON", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_INT, oPC))
        {
            if(!GetPersistantLocalInt(oPC, "NWNX_DragonicSurgeInt"))
                SetCompositeBonus(oSkin, "DrSge_INT", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_WIS, oPC))
        {
            if(!GetPersistantLocalInt(oPC, "NWNX_DragonicSurgeWis"))
                SetCompositeBonus(oSkin, "DrSge_WIS", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
        }
        if(GetHasFeat(FEAT_DRACONIC_SURGE_CHA, oPC))
        {
            if(!GetPersistantLocalInt(oPC, "NWNX_DragonicSurgeCha"))
                SetCompositeBonus(oSkin, "DrSge_CHA", 1, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
        }
    }
}