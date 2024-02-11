//::///////////////////////////////////////////////
//:: Name       Battle Blessing
//:: FileName   prc_ft_bbless
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the instant feat to toggle it on/off
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius   
//:: Created On: 09/08/22
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_ipfeat_const"

void DisableBattleBlessing()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, "BattleBlessingActive");
    //not on, abort
    if(!nValue)
        return;
    //its on, turn it off    
    DeleteLocalInt(oPC, "BattleBlessingActive");
    //remove bonusfeats
    object oSkin = GetPCSkin(oPC);
    itemproperty ipTest = GetFirstItemProperty(oSkin);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT
            && (GetItemPropertySubType(ipTest) == IP_CONST_FEAT_EPIC_AUTO_QUICKEN_I
             || GetItemPropertySubType(ipTest) == IP_CONST_FEAT_EPIC_AUTO_QUICKEN_II))
        {
            RemoveItemProperty(oSkin, ipTest);
        }
        ipTest = GetNextItemProperty(oSkin);
    }
    //send a message
    FloatingTextStringOnCreature("Battle Blessing Deactivated", oPC, FALSE);
}

void main()
{
    //get current value
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, "BattleBlessingActive");
    if(nValue)
    {
        DisableBattleBlessing();
    }   
    else
    {
        //its off, turn it on
        SetLocalInt(oPC, "BattleBlessingActive", TRUE);
        object oSkin = GetPCSkin(oPC);

        //auto-quicken all spells so the casting and attacking is the same action
        itemproperty ipTest = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_I);
        IPSafeAddItemProperty(oSkin, ipTest, 99999.0);
        ipTest = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_II);
        IPSafeAddItemProperty(oSkin, ipTest, 99999.0);
        //send a message
        FloatingTextStringOnCreature("Battle Blessing Activated", oPC, FALSE);
    }
}